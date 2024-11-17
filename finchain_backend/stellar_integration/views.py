from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from .serializers import UserProfileSerializer, StellarAccountSerializer, SendPaymentSerializer, UserRegistrationSerializer,CustomTokenObtainPairSerializer,UserLoginSerializer,FundAccountSerializer
from .models import StellarAccount, UserProfile,UserWallet
from .utils import create_stellar_account, check_account_balance, send_payment, get_transaction_history, fund_account
from django.contrib.auth import get_user_model ,authenticate
from rest_framework import generics
from rest_framework.permissions import AllowAny
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework import status
from django.shortcuts import get_object_or_404
from rest_framework.exceptions import NotFound



class StellarAccountViewSet(viewsets.ModelViewSet):
    queryset = StellarAccount.objects.all()
    serializer_class = StellarAccountSerializer
    permission_classes = [IsAuthenticated]

    @action(detail=False, methods=['post'])
    def create_account(self, request):
        public_key, secret_seed = create_stellar_account()
        if public_key and secret_seed:
            account = StellarAccount(user=request.user, account_id=public_key)
            account.set_secret_seed(secret_seed)
            account.save()
            return Response({'public_key': public_key, 'secret_seed': secret_seed})
        return Response({'error': 'Failed to create the account'}, status=400)

    # @action(detail=False, methods=['post'])
    # def fund_account(self, request):
    #     public_key = request.data.get('public_key')
        
    #     if not public_key:
    #         return Response({'error': 'Public key is required'}, status=400)
        
    #     try:
    #         response = fund_account(public_key)
    #         return Response({'status': 'success', 'response': response})
    #     except Exception as e:
    #         return Response({'error': str(e)}, status=400)
    @action(detail=False, methods=['post'])
    def fund_account(self, request):
        # Use the serializer for validation
        serializer = FundAccountSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=400)

        # Extract mobile number and find wallet
        mobile_number = serializer.validated_data['mobile_number']
        try:
            wallet = UserWallet.objects.filter(mobile_number=mobile_number).first()
            if not wallet:
                return Response({'error': 'Wallet not found for the given mobile number'}, status=404)

            # Fund the Stellar account
            public_key = wallet.wallet_address
            response = fund_account(public_key)
            return Response({'status': 'success', 'response': response})
        except Exception as e:
            return Response({'error': str(e)},status=400)

    @action(detail=False, methods=['get'])
    def check_balance(self, request):
        account = StellarAccount.objects.get(user=request.user)
        balances = check_account_balance(account.account_id)
        return Response({'balances': balances})

    # @action(detail=False, methods=['post'])
    # def send_payment(self, request):
    #     serializer = SendPaymentSerializer(data=request.data)
    #     serializer.is_valid(raise_exception=True)
    #     data = serializer.validated_data
        
    #     from_account = StellarAccount.objects.get(user=request.user)


    #     #this will allow to map the mobile number 
    #     recipient = get_object_or_404(UserWallet, mobile_number=data['mobile_number'])
    #     to_account = recipient.wallet_address


        
    #     balance = check_account_balance(from_account.account_id)
    #     if any(b['asset_type'] == 'native' and float(b['balance']) < data['amount'] for b in balance):
    #         return Response({'error': 'Insufficient balance'}, status=400)
        
    #     # response = send_payment(from_account, data['to_account'], data['amount'])
    #     # return Response({'response': response})
    #     memo = data.get('memo', "")  # Get memo or use empty string if not provided
    #     response = send_payment(from_account, data['to_account'], data['amount'], memo=memo)
    #     return Response({'response': response})
    @action(detail=False, methods=['post'])
    def send_payment(self, request):
        serializer = SendPaymentSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data
    
    # Fetch the StellarAccount for the logged-in user
        from_account = StellarAccount.objects.get(user=request.user)
    
    # Extract the mobile number from the request data
        mobile_number = data.get('mobile_number')

    # Check if a UserWallet exists for the provided mobile number
        try:
            recipient_wallet = UserWallet.objects.get(mobile_number=mobile_number)
        except UserWallet.DoesNotExist:
            return Response({'error': f'No UserWallet found for the mobile number: {mobile_number}'}, status=400)

    # If the wallet exists, get the wallet address
        to_account = recipient_wallet.wallet_address

    # Check if the sender has sufficient balance to make the payment
        balance = check_account_balance(from_account.account_id)
        if any(b['asset_type'] == 'native' and float(b['balance']) < data['amount'] for b in balance):
            return Response({'error': 'Insufficient balance'}, status=400)
    
    # Proceed to send the payment
        memo = data.get('memo', "")  # Get memo or use an empty string if not provided
        try:
            response = send_payment(from_account, to_account, data['amount'], memo=memo)
            return Response({'response': response})
        except Exception as e:
        # Catch any exceptions thrown during the payment process
            return Response({'error': str(e)}, status=500)


    @action(detail=False, methods=['get'])
    def transaction_history(self, request):
        account = StellarAccount.objects.get(user=request.user)
        transactions = get_transaction_history(account.account_id)
        return Response({'transactions': transactions})

class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return UserProfile.objects.filter(user=self.request.user)

    @action(detail=False, methods=['get'])
    def retrieve_profile(self, request):
        profile, created = UserProfile.objects.get_or_create(user=request.user)
        serializer = UserProfileSerializer(profile)
        return Response(serializer.data)

    @action(detail=False, methods=['patch'])
    def update_profile(self, request):
        profile, created = UserProfile.objects.get_or_create(user=request.user)
        serializer = UserProfileSerializer(profile, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)
    @action(detail=False, methods=['get'])
    def all_users(self, request):
        profiles = UserProfile.objects.all()
        serializer = UserProfileSerializer(profiles, many=True)
        return Response(serializer.data)

class UserRegistrationView(generics.CreateAPIView):
    queryset = get_user_model().objects.all()
    serializer_class = UserRegistrationSerializer
    permission_classes = [AllowAny]




class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer

# class UserLoginView(generics.GenericAPIView):
#     serializer_class = UserLoginSerializer
#     permission_classes = [AllowAny]

#     def post(self, request):
#         serializer = self.serializer_class(data=request.data)
#         if serializer.is_valid():
#             username = serializer.validated_data['username']
#             password = serializer.validated_data['password']
#             user = authenticate(username=username, password=password)
            
#             if user:
#                 refresh = CustomTokenObtainPairSerializer.get_token(user)
#                 return Response({
#                     'refresh': str(refresh),
#                     'access': str(refresh.access_token),
#                     'user': {
#                         'username': user.username,
#                         'id': user.id
#                     }
#                 })
#             return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class UserLoginView(generics.GenericAPIView):
    serializer_class = UserLoginSerializer
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            mobile_number = serializer.validated_data['mobile_number']
            pin = serializer.validated_data['pin']

            # Authenticate the user using mobile_number and pin as password
            try:
                user = get_user_model().objects.get(mobile_number=mobile_number)
            except get_user_model().DoesNotExist:
                return Response({'error': 'Invalid mobile number or PIN'}, status=status.HTTP_401_UNAUTHORIZED)

            if user.check_password(pin):  # Check if the PIN matches
                refresh = CustomTokenObtainPairSerializer.get_token(user)
                return Response({
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                    'user': {
                        'username': user.username,
                        'id': user.id
                    }
                })
            else:
                return Response({'error': 'Invalid mobile number or PIN'}, status=status.HTTP_401_UNAUTHORIZED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
