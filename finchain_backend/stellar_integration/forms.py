from django import forms

class SendPaymentForm(forms.Form):
    to_account = forms.CharField(max_length=56)
    amount = forms.DecimalField(max_digits=10, decimal_places=2)
    memo = forms.CharField(required=False)  # Add this line for memo
