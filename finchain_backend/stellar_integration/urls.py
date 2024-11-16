from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from django.urls import path
from .views import StellarAccountViewSet, UserProfileViewSet,UserRegistrationView,UserLoginView,CustomTokenObtainPairView


router = DefaultRouter()
router.register(r'stellar_accounts', StellarAccountViewSet)
router.register(r'user_profiles', UserProfileViewSet)


urlpatterns = [
    path('register/', UserRegistrationView.as_view(), name='register'),
    path('login/', UserLoginView.as_view(), name='login'),
    path('token/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
] + router.urls