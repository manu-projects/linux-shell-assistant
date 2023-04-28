NEWT_COLOR_PALETTE_DIALOGS="$(shell cat $(UTILS_CONFIGS)/whiptail-theme-green.cfg)"
WHIPTAIL_COLORED=export NEWT_COLORS=$(NEWT_COLOR_PALETTE_DIALOGS); whiptail

# usamos la opción (--assign) para definir una variable (x) que contenga las comillas dobles
AWK_FORMAT_MENU_OPTIONS=awk --assign x="\"" --field-separator=':' '{print x$$1x, x$$2x}'

# Nota:
# - definimos una macro para la "coma" y la usamos dónde invocemos a nuestra función color_box de la forma $(,)
# - en las funciones de GNU Make la coma es el separador de parámetros
# - si usamos la coma común, GNU Make considerará que la función recibirá más parámetros, afectando el comportamiento deseado de nuestra función..
# (alternativas de solución fallidas: el comando sed de GNU, la función subst de GNU Make)
, =,

# comando boxes
# ==============
#
# opciones
# --------
# -d		elegir el diseño a mostrar (Ej. parchment, cat, ..)
# -a		para alinear/posicionar el texto dentro de la caja
# -a hx (alinear horizontalmente) dónde "x" puede ser l (left), c (center), r (right)
# -a vx (alinear verticalmente) dónde "x" puede ser t (top), c (center), b (bottom)
#
# Ej. boxes -a hlvc (alinear horizontalmente hacia la izquierda, alinear verticalmente hacia arriba)
define color_box
	echo "Notas:\n" $(1) | boxes -a hlvc -d parchment | lolcat --animate --duration=1 --seed=35
endef

##@ Utilidades
h help: ## Mostrar menú de ayuda
	@awk 'BEGIN {FS = ":.*##"; printf "\nOpciones para usar:\n  make \033[36m\033[0m\n"} /^[$$()% 0-9a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
