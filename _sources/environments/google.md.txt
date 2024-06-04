# Google keys

Google keys are used by the Google Drive interlinker and the KPIs script (it sends the results of the queries executed in Dremio to a Google Sheet)

## Creation of Google credentials in Google Cloud

A service account is a special type of Google account intended to represent a non-human user that needs to authenticate and be authorized to access data in Google APIs. A service account is needed for each environment.

[![Watch the video](https://images.drivereasy.com/wp-content/uploads/2017/07/img_596dda8d77553.png)](https://drive.google.com/file/d/1vuZOSId7rGE0HyComsnrPlZ7sYblUkof/view?usp=sharing)

Once the service accounts have been created, we need to create the credentials and download the JSON keys:

[![Watch the video](https://images.drivereasy.com/wp-content/uploads/2017/07/img_596dda8d77553.png)](https://drive.google.com/file/d/1vuZOSId7rGE0HyComsnrPlZ7sYblUkof/view?usp=sharing)


## Setting the credentials in the GitHub secrets

Given the following JSON with the Google credentials:

```json
{
  "type": "service_account",
  "project_id": "exempl(...)512",
  "private_key_id": "38457732b(...)0d8336dd7a7",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCbfIDAC/AXAqB6\nYEy13H7Q81ekV2vPKPGWEGSvedkTysDn8ws6AZCMcmcy/Rsnq1daF0ipit3kdsgG\nGBG3szX7s0I4yQJywhd4wLZH3VfEl/4cuhKH3zEwydyPM5m6WBl/ycnyC/EFY+qX\njhAwMLSdNOn1KHXmy67QDnLZaVMKMjPECrCorkgOrZIXWDUU6FGyPEvOtWVFf1G1\np1gEeaLVmHiH8Ma8v3vygWXs7PzEyuYnbR127Lz4OyXOAzMxEYvCVth92vq6g/4E\nG...plkLrZnIBynwbBUfUZ0rOagVnDR5kqLLtJ1MUdLe7f/1ubqhMkZq\nfA1DI4F/EFemSzEzZTeQCpOAkNAZyzIFer/mR4ag+vWh/GtCvGEBcUqhJM3m8f48\nYt5ABw7DfWefjy44SAazLwPL2Q==\n-----END PRIVATE KEY-----\n",
  "client_email": "development-environment@(...)com",
  "client_id": "11457(...)7096844",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleap(...)ccount.com"
}
```

The secrets should be (important the DEV_ prefix):

```
DEV_GOOGLE_PROJECT_ID = exempl(...)512
DEV_GOOGLE_PRIVATE_KEY_ID = 38457732b(...)0d8336dd7a7

####################################################################
# important the double quotes and to replace "\n" with "\\n"
####################################################################

DEV_GOOGLE_PRIVATE_KEY = "-----BEGIN PRIVATE KEY-----\\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCbfIDAC/AXAqB6\\nYEy13H7Q81ekV2vPKPGWEGSvedkTysDn8ws6AZCMcmcy/Rsnq1daF0ipit3kdsgG\\nGBG3szX7s0I4yQJywhd4wLZH3VfEl/4cuhKH3zEwydyPM5m6WBl/ycnyC/EFY+qX\\njhAwMLSdNOn1KHXmy67QDnLZaVMKMjPECrCorkgOrZIXWDUU6FGyPEvOtWVFf1G1\\np1gEeaLVmHiH8Ma8v3vygWXs7PzEyuYnbR127Lz4OyXOAzMxEYvCVth92vq6g/4E\\nG...plkLrZnIBynwbBUfUZ0rOagVnDR5kqLLtJ1MUdLe7f/1ubqhMkZq\\nfA1DI4F/EFemSzEzZTeQCpOAkNAZyzIFer/mR4ag+vWh/GtCvGEBcUqhJM3m8f48\\nYt5ABw7DfWefjy44SAazLwPL2Q==\\n-----END PRIVATE KEY-----\\n"
DEV_GOOGLE_CLIENT_EMAIL = development-environment@(...)com
DEV_GOOGLE_CLIENT_ID = 11457(...)7096844
DEV_GOOGLE_CLIENT_X509 = https://www.googleap(...)ccount.com
```
