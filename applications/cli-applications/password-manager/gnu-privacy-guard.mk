# TODO: mover al makefile principal,
# se agregó porque en (sh) Bourne Shell no tengo la opción -s del comando read
SHELL=/bin/bash

# TODO: sign?
# TODO: la clave expira en 2 años, cambiar a que no expire
# - algoritmo (ed25519) de cifrado curva elípitica
gpg-generate-key-ed25519:
	$(ASK_GPG_IDKEY_USER_NAME) GPG_IDKEY_USER_NAME \
	&& $(ASK_GPG_IDKEY_USER_MAIL) GPG_IDKEY_USER_MAIL \
	&& $(ASK_GPG_PASSPHRASE) GPG_PASSPHRASE \
	&& gpg --batch \
	--passphrase "$${GPG_PASSPHRASE}" \
	--default-new-key-algo "ed25519/cert,sign+cv25519/encr" \
	--quick-generate-key $(GPG_IDKEY)

#gpg-destroy-file-key:
#	gshred -u archivo
