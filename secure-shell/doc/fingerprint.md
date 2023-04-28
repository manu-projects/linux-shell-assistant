# Fingerprint (huella digital)
## Que es para el Servidor SSH
- lo identifica
- representa la **huella digital** de su (hostkey) *Clave PÚBLICA* generada mediante una _función de hash_
- la proporciona cada vez que nos conectemos a él
  (si llegara a cambiar nuestro cliente SSH nos avisaría que podría ser un RIESGO conectarnos a él)
## Que es para el Cliente SSH
- persiste en él luego que acepte la conexión por primera vez
- permanece en la _base de datos_ de hosts conocidos en el archivo `~/.ssh/known_hosts`
## Como obtenerlo de una clave pública generada
- si queremos validar en el cliente ssh, ejecutar `ssh-keygen -l -f ~/.ssh/nombredelaclave.pub`
- si queremos validar en el servidor ssh, ejecutar `ssh-keygen -l -f /etc/ssh/ssh_host_nombreDelAlgoritmo.pub`
# Prevención contra un ataque man-in-the-middle
1. nos conectamos a un servidor SSH (no siendo la primera vez)
2. nos aparece un mensaje de advertencia sobre el fingerprint
3. entonces _analizamos si aceptar ó no_ la conexión remota
4. si es un servicio en la nube, contactar con el administrador de sistema
5. si es un servidor de nuestra red
   1. comprobar si cambió el fingerprint del Servidor SSH ejecutando en el servidor `ssh-keygen -l -f ~/etc/ssh/ssh_host_nombreDelAlgoritmo.pub`
   2. si lo anterior no concuerda, borrar todas las claves asociadas a ese host ejecutando en el cliente `ssh-keygen -f ~/.ssh/known_hosts -R numero-ip-maliciosa`
# Causas de advertencia de fingerprint
- Nos conectamos por primera vez
- Si ya nos habíamos conectado, el servidor SSH generó nuevamente un par de claves
- Si ya nos habíamos conectado, posible servidor SSH malicioso
