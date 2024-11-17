from pydantic import ValidationError
from rest_framework import serializers
from .models import StellarAccount, UserProfile,UserWallet
from django.contrib.auth import get_user_model
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .utils import create_stellar_account,encrypt_data

class StellarAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = StellarAccount
        fields = ['user', 'account_id', 'secret_seed', 'created_at']



class SendPaymentSerializer(serializers.Serializer):
    # to_account = serializers.CharField(max_length=56)
    mobile_number = serializers.CharField()
    amount = serializers.DecimalField(max_digits=10, decimal_places=2)
    # memo = serializers.CharField(required=False, allow_blank=True)
    #   # Add this line for memo
    memo = serializers.CharField(max_length=28, required=False)

    def validate_amount(self, value):
        if value <= 0:
            raise ValidationError("Amount must be greater than zero.")
        return value
    def validate_memo(self, value):
        if value and len(value.encode('utf-8')) > 28:  # Ensure memo length is checked in bytes
            raise ValidationError("Memo must be 28 characters or less.")
        return value
    
class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = ['user', 'first_name', 'last_name', 'email', 'profile_picture']


# class UserRegistrationSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = get_user_model()
#         fields = ['username', 'password']
#         extra_kwargs = {'password': {'write_only': True}}

#     def create(self, validated_data):
#         user = get_user_model().objects.create_user(**validated_data)
#         UserProfile.objects.create(user=user)
#         return user
    


# class UserRegistrationSerializer(serializers.ModelSerializer):
#     mobile_number = serializers.CharField(max_length=15, required=True)
#     pin = serializers.CharField(write_only=True, min_length=4, max_length=6, required=True)

#     class Meta:
#         model = get_user_model()
#         fields = ['mobile_number', 'pin']

#     def validate_mobile_number(self, value):
#         # Ensure the mobile number is unique
#         if get_user_model().objects.filter(mobile_number=value).exists():
#             raise serializers.ValidationError("Mobile number already registered.")
#         return value

#     def create(self, validated_data):
#         mobile_number = validated_data['mobile_number']
#         pin = validated_data['pin']

#         # Create a user with mobile number as both `username` and `mobile_number`
#         user = get_user_model().objects.create_user(
#             username=mobile_number,  # Use mobile number as username
#             mobile_number=mobile_number,
#             password=pin  # Use PIN as the password
#         )
#         # Create an associated user profile
#         UserProfile.objects.create(user=user)
#         return user
class UserRegistrationSerializer(serializers.ModelSerializer):
    mobile_number = serializers.CharField(max_length=15, required=True)
    pin = serializers.CharField(write_only=True, min_length=4, max_length=6, required=True)

    class Meta:
        model = get_user_model()
        fields = ['mobile_number', 'pin']

    def validate_mobile_number(self, value):
        # Ensure the mobile number is unique
        if get_user_model().objects.filter(mobile_number=value).exists():
            raise serializers.ValidationError("Mobile number already registered.")
        return value

    def create(self, validated_data):
        mobile_number = validated_data['mobile_number']
        pin = validated_data['pin']

        # Create a user with the mobile number as both `username` and `mobile_number`
        user = get_user_model().objects.create_user(
            username=mobile_number,  # Use mobile number as username
            mobile_number=mobile_number,
            password=pin  # Use PIN as the password
        )

        # Create a Stellar account and associate it with a UserWallet
        public_key, secret_seed = create_stellar_account()
        if public_key and secret_seed:
            StellarAccount.objects.create(user=user, account_id=public_key, secret_seed=encrypt_data(secret_seed))
            UserWallet.objects.create(user=user, mobile_number=mobile_number, wallet_address=public_key)
        else:
            raise serializers.ValidationError("Failed to create a Stellar account.")

        # Create an associated user profile
        UserProfile.objects.create(user=user)

        return user


class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        # Add custom claims
        token['username'] = user.username
        return token

# class UserLoginSerializer(serializers.Serializer):
#     username = serializers.CharField()
#     password = serializers.CharField(write_only=True)


class FundAccountSerializer(serializers.Serializer):
    mobile_number = serializers.CharField(max_length=15, required=True)

    def validate_mobile_number(self, value):
        # Ensure the mobile number is linked to a wallet
        if not UserWallet.objects.filter(mobile_number=value).exists():
            raise serializers.ValidationError("No wallet found for the provided mobile number.")
        return value

class UserLoginSerializer(serializers.Serializer):
    mobile_number = serializers.CharField()
    pin = serializers.CharField(write_only=True)

    def validate_mobile_number(self, value):
        # Ensure the mobile number exists in the system
        if not get_user_model().objects.filter(mobile_number=value).exists():
            raise serializers.ValidationError("Mobile number not registered.")
        return value
