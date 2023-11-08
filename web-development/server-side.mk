# ésta macro es necesaria, para ejecutar la sintáxis `bash >(url de un shellscript)`
SHELL := /bin/bash

install-nvm:
	bash <(curl -s https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh) \
	&& source ~/.bashrc

# Alternativa al target anterior.. sería usar bash -c "bash <(url de un shellscript)"
# (ésta opción nos evita modificar el tipo de SHELL, pero quizás agrega complejidad)
#
#	bash -c "bash <(curl -s https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh)"

