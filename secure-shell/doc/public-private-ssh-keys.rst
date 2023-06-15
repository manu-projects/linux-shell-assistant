Par de Claves de SSH (Pública/Privada)
======================================

Clave Pública de SSH
--------------------
- archivo regular con extensión ``.pub`` en la ruta ``~/.ssh/`` del usuario que la generó con ``ssh-keygen``
- copiar la **Clave Pública de nuestra maquina local** en el **Servidor SSH**

  1. ejecutamos en la terminal ``ssh-copy-id host`` (reemplazar host por la IP, ó el nombre del Host que definimos ``~/.ssh/config`` del Cliente SSH)
  2. la clave pública se agregará automáticamente en el archivo ``~/.ssh/authorized_keys`` del **Servidor SSH**

Clave Privada de SSH
--------------------
- permanece en nuestra maquina local en el directorio ``~/.ssh/`` (con igual nombre que la Clave Pública)
- utilizada al establecer la conexión con el Servidor SSH, para validar nuestra identidad
- NO debe compartirse ni exponer, porque se utiliza para descifrar/desencriptar la **Clave Pública** asociada

Servidor SSH comprueba la identidad del Cliente SSH
---------------------------------------------------
1. nuestro **Cliente SSH** solicita conectarse al **Servidor SSH**
2. el **Servidor SSH encripta** un texto con nuestra **Clave Pública** (la que le habíamos agregado en ``~/.ssh/authorized_keys``)
3. el **Servidor SSH** nos envía el texto encriptado, para verificar nuestra identidad
4. nuestro **Cliente SSH desencripta** el texto con la **Clave Privada** asociada, y le envía el texto desencriptado
5. el **Servidor SSH** compara el texto desencriptado y decide si aceptar ó rechazar la solicitud de conexión

Frase de Paso (passphrase)
==========================
- agrega una capa de seguridad adicional
- si alguien obtuviera nuestra **Clave Privada**, necesitarían adivinar la **frase de paso** asociada
