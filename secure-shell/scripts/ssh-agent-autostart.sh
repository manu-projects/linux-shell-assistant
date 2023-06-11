SSH_ENV="${HOME}/.ssh/agent-environment"

function start_agent_ssh {
    echo "Inicializando un nuevo Agente de Autenticación de SSH en una Subshell..."

    echo "guardando los comandos de shell devueltos por el Agente SSH (${SSH_ENV})..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded

    echo "asignando permisos de lectura y escritura al archivo anterior.."
    chmod u+rw "${SSH_ENV}"

    echo "ejecutando los comandos de Shell guardados del Agente SSH..."
    . "${SSH_ENV}" > /dev/null

    echo "guardando las Claves Privadas en el Agente SSH.."
    /usr/bin/ssh-add;
}

# 1. si ya existe el archivo que contiene los comandos devueltos al ejecutar el agente SSH
if [ -f "${SSH_ENV}" ]; then
    # redireccionamos el resultado de ejecutar los comandos al dispositivo null,
    # para no mostrarlos por pantalla (stdout)
    echo "ejecutando los comandos de Shell guardados del Agente SSH, para configurar las variables de entorno de la Shell..."
    . "${SSH_ENV}" > /dev/null

    # Verificamos si el Agente SSH no está ejecutando, si NO está ejecutando entonces ejecutará nuestra función de Bash,
    # al ejecutar la función de Bash se ejecutará un nuevo Agente SSH y se reescribirán las variables de entorno
    # en el archivo que referenciamos en ${SSH_ENV}
    #
    #
    # 1.1. filtramos entre todos los procesos asociados a la Shell, buscando por el Agente SSH
    # (redireccionamos el resultado devuelto por grep al dispositivo /dev/null para no mostrarlo por pantalla (stdout))
    #
    # 1.2. si el Agente SSH no está ejecutandose entonces se ejecutará la función de bash que definimos como start_agent_ssh
    # - si el "Estado de Salida" de un comando es distinto de cero, entonces no tuvo éxito al ejecutar ó ocurrió un error, en este caso si no encuentra a un proceso
    # - utilizar el operador lógico OR (||) si queremos ejecutar un comando (B) en caso de que el "estado de salida" de un comando (B) sea distinto de cero
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        echo "No existe un Agente SSH ejecutando."
        echo "Ejecutando un nuevo Agente SSH, y reescribiendo los comandos que definen las variables de entorno actuales de la Shell.."
        start_agent_ssh
    }
# 2. si NO existe el archivo que contiene los comandos devueltos al ejecutar el agente SSH
else
    # 2.1. creamos el archivo (que guardará los comandos que devuelve el Agente SSH para setear las variables de entorno)
    # 2.2. ejecutamos un Agente SSH
    # 2.3. agregamos las claves privadas al Agente SSH
    start_agent_ssh
fi
