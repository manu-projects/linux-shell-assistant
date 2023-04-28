# TODO: después hay que usar la macro de la ruta absoluta
# en el Makefile principal dónde se definen los módulos
include $(MODULE_APPS_CLI)/password-manager/*.mk

ASK_GPG_PASSPHRASE=read -s -p 'Escriba la frase de paso: '
ASK_GPG_IDKEY_USER_NAME=read -p "Escriba su nombre: "
ASK_GPG_IDKEY_USER_MAIL=read -p "Escriba su email: "

GPG_IDKEY="$${GPG_IDKEY_USER_NAME} <$${GPG_IDKEY_USER_MAIL}>"

install-security-GnuPG:
	sudo aptitude install gnupg

# TODO: mover una categoría de lenguajes de programación
install-language-golang:
	sudo aptitude install golang-go

install-password-manager-gopass: install-language-golang
	sudo aptitude install gopass
