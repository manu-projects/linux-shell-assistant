MODULE_SHELLS_RESOURCES=shells-terminal-emulators/resources
CURRENT_SHELL=$(shell echo $${SHELL})
CURRENT_USER=$(shell whoami)

VALID_LOGIN_SHELLS=$(MODULE_SHELLS_RESOURCES)/valid-login-shells.lst
DOC_LOGIN_SHELLS=$(MODULE_SHELLS_RESOURCES)/interactive-login-shell.txt
DOC_NONLOGIN_SHELLS=$(MODULE_SHELLS_RESOURCES)/interactive-non-login-shell.txt
DOC_RESTRICTED_SHELLS=$(MODULE_SHELLS_RESOURCES)/restricted-shell.txt

##@ Shell (examples)
try-interactive-login-shell: ##
	@bat $(DOC_LOGIN_SHELLS)
	@echo "Ejecutando ejemplo (c), pero el ejemplo (a) sería más común.." \
	&& ssh -t $(CURRENT_USER)@127.0.0.1

try-interactive-nonlogin-shell: ##
	@bat $(DOC_NONLOGIN_SHELLS)
	@echo "Ejecutando ejemplo (b), pero el ejemplo (a) sería más común.." \
	&& $(CURRENT_SHELL) -i

# TODO: validación para fish no dispone ésta feature
try-restricted-shell: ##
	@bat $(DOC_RESTRICTED_SHELLS)
	@echo "Ejecutando Bash Shell restricta.. (salir con el comando exit)" \
	&& $(CURRENT_SHELL) --restricted

##@ Shell (show info)
print-current-shell: ##
	@echo $(CURRENT_SHELL)

print-valid-login-shells: ##
	@cat $(VALID_LOGIN_SHELLS_FILE)
