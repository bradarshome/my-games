# GitHub Secrets Setup

Kamu perlu menambahkan secrets berikut di **Settings > Secrets and variables > Actions** di repositori GitHub kamu:

## Required Secrets

| Secret Name | Deskripsi | Cara Mendapatkan |
|-------------|-----------|------------------|
| `TELEGRAM_BOT_TOKEN` | Token bot dari BotFather | Chat [@BotFather](https://t.me/BotFather) → `/newbot` → ikuti instruksi |
| `TELEGRAM_CHAT_ID` | ID chat Telegram tujuan | Chat bot kamu → kirim pesan → buka `https://api.telegram.org/bot<BOT_TOKEN>/getUpdates` → cari `"chat":{"id":` |

## Optional Secrets (untuk Android build)

| Secret Name | Value | Deskripsi |
|-------------|-------|-----------|
| `ANDROID_KEYSTORE_BASE64` | (hasil base64) | Isi lengkap dari `base64 -i mygame.keystore` |
| `ANDROID_KEYSTORE_USER` | `mygame` | Alias yang kamu buat saat generate keystore |
| `ANDROID_KEYSTORE_PASSWORD` | (password kamu) | Password yang kamu input saat generate |

## Cara Setup BotFather

1. Buka Telegram, cari **@BotFather**
2. Kirim `/newbot`
3. Ikuti instruksi untuk nama bot
4. Simpan token yang diberikan
5. Tambahkan bot ke grup/channel atau chat langsung
6. Kirim pesan ke bot tersebut
7. Buka `https://api.telegram.org/bot<TOKEN>/getUpdates` untuk dapat chat ID

## Cara Setup Android Keystore (opsional, kalau mau build APK)

### 1. Buat keystore baru

```bash
keytool -genkey -v -keystore mygame.keystore -alias mygame -keyalg RSA -keysize 2048 -validity 10000
```

Nanti akan diminta input:
- **Keystore password**: → ini jadi `ANDROID_KEYSTORE_PASSWORD`
- **What is your first and last name?**: Skip (enter)
- **What is the name of your organizational unit?**: Skip (enter)
- **What is the name of your organization?**: Skip (enter)
- **What is the name of your City or Locality?**: Skip (enter)
- **What is the name of your State or Province?**: Skip (enter)
- **What is the two-letter country code for this unit?**: isi `ID` (Indonesia)
- **Alias password**: Sama dengan keystore password

### 2. Convert ke base64

```bash
base64 -i mygame.keystore
```

Copy hasilnya (satu baris panjang) ke secret `ANDROID_KEYSTORE_BASE64`.

### 3. Simpan secrets

| Secret | Value |
|--------|-------|
| `ANDROID_KEYSTORE_BASE64` | Hasil base64 dari command di atas |
| `ANDROID_KEYSTORE_USER` | `mygame` (alias yang kamu buat) |
| `ANDROID_KEYSTORE_PASSWORD` | Password yang kamu input |

### 4. Verifikasi keystore (opsional)

```bash
keytool -list -keystore mygame.keystore
```

Akan show informasi:
```
Alias name: mygame
Creation date: ...
Entry type: PrivateKeyEntry
Certificate chain length: 1
...
```
