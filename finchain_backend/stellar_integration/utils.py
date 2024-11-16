from stellar_sdk import Asset, Keypair, Server, TransactionBuilder, Network
import requests
from django.conf import settings
from cryptography.fernet import Fernet
import logging


def get_fernet():
    return Fernet(settings.FERNET_KEY)

def encrypt_data(data):
    fernet = get_fernet()
    encrypted = fernet.encrypt(data.encode())
    return encrypted.decode()

def decrypt_data(data):
    fernet = get_fernet()
    decrypted = fernet.decrypt(data.encode())
    return decrypted.decode()

def create_stellar_account():
    keypair = Keypair.random()
    public_key = keypair.public_key
    secret_seed = keypair.secret

    try:
        fund_account(public_key)
        return public_key, secret_seed
    except Exception as e:
        print(f"Error funding account: {e}")
        return None, None

def fund_account(public_key):
    friendbot_url = "https://friendbot.stellar.org"
    response = requests.get(friendbot_url, params={"addr": public_key}) 

    if response.status_code == 200:
        return response.json()
    else:
        raise Exception(f"Failed to fund account: {response.text}")

def check_account_balance(account_id):
    server = Server(horizon_url="https://horizon-testnet.stellar.org")
    account = server.accounts().account_id(account_id).call()
    return account['balances']


def send_payment(from_account, to_account, amount, asset_code="XLM", asset_issuer=None, memo=None):
    server = Server(horizon_url="https://horizon-testnet.stellar.org")
    source_keypair = Keypair.from_secret(from_account.get_secret_seed())  # Decrypt secret seed
    source_account = server.load_account(account_id=from_account.account_id)
    base_fee = server.fetch_base_fee()
    
    if asset_code == "XLM":
        asset = Asset.native()
    else:
        asset = Asset(asset_code, asset_issuer)
    
    transaction_builder = TransactionBuilder(
        source_account=source_account,
        network_passphrase=Network.TESTNET_NETWORK_PASSPHRASE,
        base_fee=base_fee
    ).append_payment_op(
        destination=to_account,
        amount=str(amount),
        asset=asset
    )

    # Add memo if provided
    if memo:
        transaction_builder.add_text_memo(memo)  # Add memo to the transaction

    transaction = transaction_builder.build()
    transaction.sign(source_keypair)
    response = server.submit_transaction(transaction)
    return response



# def get_transaction_history(account_id):
#     server = Server(horizon_url="https://horizon-testnet.stellar.org")
#     try:
#         transactions = server.transactions().for_account(account_id).limit(20).order(desc=True).call()
        
#         extracted_transactions = []
#         for transaction in transactions['_embedded']['records']:
#             transaction_info = {
#                 'timestamp': transaction.get('created_at'),
#                 'fee': transaction.get('fee_charged'),
#                 'sender': account_id,
#                 'memo': transaction.get('memo'),
#                 'receiver': None,
#                 'amount': 0
#             }
            
#             operations = server.operations().for_transaction(transaction['hash']).call()['_embedded']['records']
#             for operation in operations:
#                 if operation['type'] == 'payment':
#                     transaction_info['receiver'] = operation['to']
#                     transaction_info['amount'] = operation['amount']
#                     break

#             extracted_transactions.append(transaction_info)
        
#         return extracted_transactions
#     except Exception as e:
#         logger.error(f"Error fetching transaction history: {e}")
#         raise
def get_transaction_history(account_id):
    from .models import UserWallet
    server = Server(horizon_url="https://horizon-testnet.stellar.org")
    try:
        transactions = server.transactions().for_account(account_id).limit(20).order(desc=True).call()
        
        extracted_transactions = []
        for transaction in transactions['_embedded']['records']:
            transaction_info = {
                'timestamp': transaction.get('created_at'),
                'fee': transaction.get('fee_charged'),
                'sender_mobile': None,
                'receiver_mobile': None,
                'memo': transaction.get('memo'),
                'amount': 0
            }
            
            # Fetch operations related to the transaction
            operations = server.operations().for_transaction(transaction['hash']).call()['_embedded']['records']
            for operation in operations:
                if operation['type'] == 'payment':
                    sender_wallet_address = account_id
                    receiver_wallet_address = operation['to']

                    # Look up the sender's and receiver's mobile numbers
                    try:
                        sender_wallet = UserWallet.objects.get(wallet_address=sender_wallet_address)
                        transaction_info['sender_mobile'] = sender_wallet.mobile_number
                    except UserWallet.DoesNotExist:
                        logger.warning(f"No mobile number found for sender wallet address: {sender_wallet_address}")

                    try:
                        receiver_wallet = UserWallet.objects.get(wallet_address=receiver_wallet_address)
                        transaction_info['receiver_mobile'] = receiver_wallet.mobile_number
                    except UserWallet.DoesNotExist:
                        logger.warning(f"No mobile number found for receiver wallet address: {receiver_wallet_address}")

                    # Set the amount for the transaction
                    transaction_info['amount'] = operation['amount']
                    break  # Only process the first payment operation

            extracted_transactions.append(transaction_info)
        
        return extracted_transactions
    except Exception as e:
        logger.error(f"Error fetching transaction history: {e}")
        raise