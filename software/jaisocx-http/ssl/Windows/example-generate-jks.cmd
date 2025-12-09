:: DOWNLOAD AND INSTALL OPENSSL for Windows (Win64 OpenSSL v3.0.5 Light):
:: https://slproweb.com/products/Win32OpenSSL.html



:: Specify the source directory path.
set SRC_DIR=C:\ssl\cert

:: Specify the target directory path.
set TARGET_DIR=C:\ssl\jks


:: HERE GO PATHS TO YOUR CERT FILES FROM CERTIFICATION AUTHORITY
:: Specify a .crt file path.
set CRT_FILE=%SRC_DIR%\jaisocx_com.crt

:: Specify a private key file path.
set PRIVATE_KEY=%SRC_DIR%\jaisocx_private_key

:: Specify root CA.
set ROOT_CA=%SRC_DIR%\RootCA\USERTrust_RSA_Certification_Authority.crt

:: Specify sub CA.
set SUB_CA=%SRC_DIR%\RootCA\Sectigo_RSA_Domain_Validation_Secure_Server_CA.crt



:: HERE GO YOUR OUTPUT JKS PARAMS
:: Keystore JKS alias.
set JKS_ALIAS=jaisocx

:: Specify the keystore password which is used to protect the integrity of the keystore.
:: Keystore password must be at least 6 characters.
set JKS_PASSWORD=superstrongpass

:: Specify the keystore file path.
set JKS_FILE=%TARGET_DIR%\jaisocx.jks



::=============================================================
:: DON'T EDIT BELOW
::=============================================================

:: chain CA.
set CHAIN_CA=%TARGET_DIR%\ca-chain.crt

:: PKCS12 file path.
set PKCS_FILE=%TARGET_DIR%\keystore.p12

:: PKCS12 name.
set PKCS12_NAME=jaisocx

:: PKCS12 password.
set PKCS12_PASSWORD=p12temppass

:: =================================================================================================
:: Create trusted CA chain of certificates. Create PKCS12 keystore from CA chain of certificates.
copy /b "%SUB_CA%"+"%ROOT_CA%"+"%CRT_FILE%" "%CHAIN_CA%"
 "C:\Program Files\OpenSSL-Win64\bin\openssl.exe" pkcs12 -export -name %PKCS12_NAME% -in %CHAIN_CA% ^
 -inkey %PRIVATE_KEY% -passout pass:%PKCS12_PASSWORD% -out %PKCS_FILE%
:: =================================================================================================

:: Convert PKCS12 keystore into a JKS keystore.
"C:\Program Files (x86)\Java\jre1.8.0_333\bin\keytool.exe" -importkeystore -destkeystore %JKS_FILE% ^
-srckeystore %PKCS_FILE% -srcstoretype pkcs12 -srcstorepass %PKCS12_PASSWORD% -alias %JKS_ALIAS% -storepass %JKS_PASSWORD%

:: Delete temporary PKCS12 file
del /f %PKCS_FILE%

:: Delete temporary CA chain file
del /f %CHAIN_CA%
