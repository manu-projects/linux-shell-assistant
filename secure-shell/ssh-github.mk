ASK_GITHUB_EMAIL=read -p "ingrese su email asociado a github: "

sshclient-github-check: ssh-generate-certificate
	ssh -vT git@github.com

SSH_KEYGEN_GITHUB=ssh-keygen \
		-a $(NUMBER_ROUNDS_KDF) \
		-t $(SIGNATURE_ALGORITHM) \
		-f $${HOME}/.ssh/github_$${SSH_KEY_NAME} \
		-N "$${SSH_KEY_PASSPHRASE}" \
		-C $${GITHUB_EMAIL}

# TODO: boxes avisando que la clave tendrá el prefijo github_
# TODO: definir nombre $${SSH_KEY_NAME} ó $${SSH_KEY_NAME}_$(SIGNATURE_ALGORITHM)
sshclient-github-create-pairkey:
	$(ASK_GITHUB_EMAIL) GITHUB_EMAIL \
	&& $(ASK_SSH_KEY_NAME) SSH_KEY_NAME\
	&& $(ASK_SSH_KEY_PASSPHRASE) SSH_KEY_PASSPHRASE \
	&& $(SSH_KEYGEN_GITHUB)

# TODO: chequear por las opciones seguras
# TODO
# ssh-github-createkey: ##
# 	$(ASK_GITHUB_EMAIL) GITHUB_EMAIL \
# 	&& ssh-keygen \
# 		-t $(GITHUB_ALGORITHM) \
# 		-C $${GITHUB_EMAIL} \
# 		-f $${HOME}/.ssh/github_$(GITHUB_ALGORITHM)

# TODO: boxes avisando que buscará la clave agregando el prefijo github_
# (no sería necesario agregar github_ as input)
sshagent-github-add-privatekey:  # requiere el archivo de la privkey en ~/.ssh/
	$(ASK_SSH_KEY_NAME) SSH_KEY_NAME \
	&& ssh-add $${HOME}/.ssh/github_$${SSH_KEY_NAME}

# TODO: boxes avisando que buscará la clave agregando el prefijo github_
sshclient-github-remove-privatekey:
	$(ASK_SSH_KEY_NAME) SSH_KEY_NAME \
	&& rm -vi $${HOME}/.ssh/github_$${SSH_KEY_NAME}

sshclient-github-remove-privatekey:
	$(ASK_SSH_KEY_NAME) SSH_KEY_NAME \
	&& rm -vi $${HOME}/.ssh/github_$${SSH_KEY_NAME}

sshclient-github-copy-publickey-to-clipboard:
	$(ASK_SSH_KEY_NAME) SSH_KEY_NAME \
	&& cat $${HOME}/.ssh/github_$${SSH_KEY_NAME}.pub \
	| xclip -rmlastnl -selection clipboard

# TODO: boxes diciendo que ya se puede borrar el archivo físico de la clave privada de ~/.ssh
# que la clave ahora está más segura utilizando `pass`, porque ya no pueden robarnos el archivo físico
# y para acceder necesita la clave gpg asociada a `pass` + passphrase de la clave privada si tuviera
# (sugerir el target de Makefile para borrarlo)
#
# TODO: boxes diciendo que se requiere tener instalado ssh-ask-pass para éste método
# éste método requiere tener instalado el paquete de linux `ssh-askpass`
#
# TODO: lanzar una excepción más descriptiva que el `exit 1`
sshagent-github-add-privatekey-safe: ssh-install-askpass ## requiere un Password Manager (pass, gopass, ..)
	CATEGORY_NAME=$(MENU_ASK_PASS_CATEGORY); \
	[[ -z "$${CATEGORY_NAME}" ]] && exit 1 \
	|| ssh-add - <<< "$(PASS_ASK_GITHUB_PRIVKEY)"
