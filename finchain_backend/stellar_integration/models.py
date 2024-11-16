from django.db import models
from django.conf import settings
from django.contrib.auth.models import AbstractUser
from .utils import encrypt_data, decrypt_data


class CustomUser(AbstractUser):
    """
    Custom user model that extends AbstractUser.
    """
    mobile_number = models.CharField(max_length=15, unique=True, null=True, blank=False)
    pin = models.CharField(max_length=6, blank=False)  # Store PIN securely

    def __str__(self):
        return self.username


class StellarAccount(models.Model):
    """
    Model to represent Stellar accounts.
    """
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    account_id = models.CharField(max_length=56)
    secret_seed = models.CharField(max_length=256)  # Encrypted seed
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.account_id

    def set_secret_seed(self, secret_seed):
        self.secret_seed = encrypt_data(secret_seed)
        self.save()

    def get_secret_seed(self):
        return decrypt_data(self.secret_seed)


class UserProfile(models.Model):
    """
    Model to represent additional user profile information.
    """
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    first_name = models.CharField(max_length=30, blank=True)
    last_name = models.CharField(max_length=30, blank=True)
    email = models.EmailField(blank=True)
    profile_picture = models.ImageField(upload_to='profile_pictures/', blank=True, null=True)

    def __str__(self):
        return self.user.username


class UserWallet(models.Model):
    """
    Model to represent user wallets.
    """
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    mobile_number = models.CharField(max_length=15, unique=True)
    wallet_address = models.CharField(max_length=56, unique=True)  # For Stellar public key

    def __str__(self):
        return f"{self.user.username} - {self.mobile_number}"
