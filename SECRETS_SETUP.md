# GitHub Secrets Setup

Kamu perlu menambahkan secrets berikut di **Settings > Secrets and variables > Actions** di repositori GitHub kamu:

## Required Secrets

| Secret Name | Deskripsi | Cara Mendapatkan |
|-------------|-----------|------------------|
| `TELEGRAM_BOT_TOKEN` | Token bot dari BotFather | Chat [@BotFather](https://t.me/BotFather) → `/newbot` → ikuti instruksi |
| `TELEGRAM_CHAT_ID` | ID chat Telegram tujuan | Chat bot kamu → kirim pesan → buka `https://api.telegram.org/bot<BOT_TOKEN>/getUpdates` → cari `"chat":{"id":` |

## Optional Secrets (untuk Android build)

| Secret Name | Deskripsi | Cara Mendapatkan |
|-------------|-----------|------------------|
| `ANDROID_KEYSTORE_BASE64` | Keystore dalam base64 | `base64 -i your-keystore.jks` |
| `ANDROID_KEYSTORE_USER` | Alias keystore | Saat membuat keystore |
| `ANDROID_KEYSTORE_PASSWORD` | Password keystore | Saat membuat keystore |

## Cara Setup BotFather

1. Buka Telegram, cari **@BotFather**
2. Kirim `/newbot`
3. Ikuti instruksi untuk nama bot
4. Simpan token yang diberikan
5. Tambahkan bot ke grup/channel atau chat langsung
6. Kirim pesan ke bot tersebut
7. Buka `https://api.telegram.org/bot<TOKEN>/getUpdates` untuk dapat chat ID

## Cara Setup Android Keystore (opsional, kalau mau build APK)

```bash
keytool -genkey -v -keystore android.keystore -alias mygame -keyalg RSA -keysize 2048 -validity 10000
base64 -i android.keystore > keystore_base64.txt
```

Lalu copy isi `keystore_base64.txt` ke secret `ANDROID_KEYSTORE_BASE64`.
