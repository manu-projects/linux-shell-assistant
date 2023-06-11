ASK_GITHUB_EMAIL=read -p "ingrese su email asociado a github: " GITHUB_EMAIL

sshclient-github-check: ssh-generate-certificate
	ssh -vT git@github.com

# TODO: refactor, crear variable CLIENT_SSH_DIR=$${HOME}/.ssh
#
# TODO: boxes avisando que buscará la clave agregando el prefijo github_
# (no sería necesario agregar github_ as input)
sshagent-github-add-privatekey-file:  # requiere el archivo de la privkey en ~/.ssh/
	$(ASK_SSH_KEY_NAME) \
	&& ssh-add $${HOME}/.ssh/$${SSH_KEY_NAME}

# TODO: mover a ssh-client.mk
sshclient-remove-privatekey-file:
	$(ASK_SSH_KEY_NAME) \
	&& rm -vi $${HOME}/.ssh/$${SSH_KEY_NAME}

# TODO: mover a ssh-client.mk
# TODO: generar una variable con el xclip, y agregar en utils/
sshclient-copy-publickey-to-clipboard:
	$(ASK_SSH_KEY_NAME) \
	&& cat $${HOME}/.ssh/$${SSH_KEY_NAME}.pub \
	| xclip -rmlastnl -selection clipboard

# TODO: boxes diciendo que ya se puede borrar el archivo físico de la clave privada de ~/.ssh
# que la clave ahora está más segura utilizando `pass`, porque ya no pueden robarnos el archivo físico
# y para acceder necesita la clave gpg asociada a `pass` + passphrase de la clave privada si tuviera
# (sugerir el target de Makefile para borrarlo)
#
# TODO: lanzar una excepción más descriptiva que el `exit 1`
sshagent-add-github-privatekey-from-password-manager:
	CATEGORY_NAME=$(MENU_ASK_PASS_CATEGORY); \
	[[ -z "$${CATEGORY_NAME}" ]] && exit 1 \
	|| ssh-add - <<< "$(PASS_ASK_GITHUB_PRIVKEY)"
