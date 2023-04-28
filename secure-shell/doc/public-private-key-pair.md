# Par de Claves (Pública/Privada)
## Clave Pública
- generadas en la ruta `~/.ssh/` del usuario que la generó con `ssh-keygen`
- copiamos la clave pública de nuestra maquina local dentro del Servidor SSH
(en el archivo `~/.ssh/authorized_keys` del usuario asociado al Servidor SSH)
## Clave Privada
- permanece nuestra maquina local en `~/.ssh/` (al igual que la Clave Pública)
- utilizada al establecer la conexión con el Servidor SSH, para validar nuestra identidad
- NO debe compartirse ni exponer, porque se utiliza para descifrar/desencriptar la *clave pública* asociada
# Frase de Paso (passphrase)
- agrega una capa de seguridad adicional
- si alguien obtuviera nuestra *Clave Privada*, necesitarían adivinar la *frase de paso* asociada
