# Github - Configuración inicial
## 1. crear el par de claves pública/privada + la frase de paso (ó passphrase)
```shell
make sshclient-github-create-pairkey
```
> persiste en el cliente SSH, en el directorio `~/.ssh/`
## 2. importar al Password Manager (pass) la Clave Privada
```shell
make pass-github-import-privateKey
```
> contemplamos el escenario de que esté comprometida la seguridad de nuestra máquina,
> cifrar la clave y luego borrar el archivo físico
## 2.1 (opcional) comprobar que la clave privada se importó correctamente
```shell
make pass-list-passwords
```
## 3. agregar en el Agente SSH, la Clave Privada cifrada en el Password Manager
```shell
make sshagent-github-add-privatekey-safe
```
> éste agente recordará la Clave Privada y la Frase de paso, los clientes SSH le preguntarán a él
## 3.1 (opcional) comprobar que la Clave Privada se guardó en el Agente SSH
```shell
make sshagent-list-publickeys
```
## 4. remover el archivo físico de ~/.ssh la Clave Privada
```shell
make sshclient-github-remove-privatekey
```
> contemplamos el escenario de que esté comprometida la seguridad de nuestra máquina,
> la clave quedó cifrada en el Password Manager
## 5 (opcional) copiar en el portapeles la Clave Pública para utilizar el atajo Ctrl+v
```shell
make sshclient-github-copy-publickey-to-clipboard
```
> acceder al navegador web y pegar el contenido en https://github.com/settings/ssh/new
# Github - Momento productivo
## agregar en el Agente SSH, la Clave Privada cifrada en el Password Manager
```shell
make sshagent-github-add-privatekey-safe
```
> evitar Shell Scripts en ~/.bash_profile que agregan la Clave Privada al Agente SSH al iniciar el Sistema,
> decidimos utilizarla sólo cuando es necesario (tenemos un mayor control)
