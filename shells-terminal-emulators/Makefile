MODULE_SHELLS_RESOURCES=shells-terminal-emulators/resources
CURRENT_SHELL=$(shell echo $${SHELL})
CURRENT_USER=$(shell whoami)

VALID_LOGIN_SHELLS=$(MODULE_SHELLS_RESOURCES)/valid-login-shells.lst
DOC_LOGIN_SHELLS=$(MODULE_SHELLS_RESOURCES)/interactive-login-shell.txt
DOC_NONLOGIN_SHELLS=$(MODULE_SHELLS_RESOURCES)/interactive-non-login-shell.txt
DOC_SHELLSCRIPT=$(MODULE_SHELLS_RESOURCES)/noninteractive-nonlogin-shell.txt
DOC_RESTRICTED_SHELLS=$(MODULE_SHELLS_RESOURCES)/restricted-shell.txt

##@ Shell (examples)
try-interactive-login-shell: ##
	@bat $(DOC_LOGIN_SHELLS)
	@echo "Ejecutando ejemplo (c), pero el ejemplo (a) sería más común.." \
	&& echo "- recuerde comprobar si es una Login Shell, con el comando 'shopt login_shell'" \
	&& echo "- recuerde salir de la Shell Interactiva CON inicio de sesión, con el comando 'logout'" \
	&& ssh -t $(CURRENT_USER)@127.0.0.1 'echo "estamos dentro de otra shell"; shopt login_shell'
#	&& ssh localhost


try-interactive-nonlogin-shell: ##
	@bat $(DOC_NONLOGIN_SHELLS)
	@echo "Ejecutando ejemplo (b), pero el ejemplo (a) sería más común.." \
	&& echo "- recuerde comprobar si es una Login Shell, con el comando 'shopt login_shell'" \
	&& echo "- recuerde salir de la Shell Interactiva SIN inicio de sesión, con el comando 'exit'" \
	&& $(CURRENT_SHELL) -i

# - usamos \ para escapar el - (guión), y el $ para escapar el $ (pesos)
# - devolvemos true para que GNU Make no lance un error
try-noninteractive-nonlogin-shell: ##
	@bat $(DOC_SHELLSCRIPT)
	@echo "Ejecutando ejemplo (a), pero el ejemplo (b) sería más común.."
	@bash -c 'echo $$\-: $$-; shopt login_shell;true'

# TODO: validación para fish no dispone ésta feature
try-restricted-shell: ##
	@bat $(DOC_RESTRICTED_SHELLS)
	@echo "Ejecutando Bash Shell restricta.." \
	&& echo "(recuerde salir de la Shell Restrictiva, con el comando 'exit')" \
	&& $(CURRENT_SHELL) --restricted

##@ Shell (show info)
print-current-shell: ##
	@echo $(CURRENT_SHELL)

print-valid-login-shells: ##
	@cat $(VALID_LOGIN_SHELLS_FILE)
