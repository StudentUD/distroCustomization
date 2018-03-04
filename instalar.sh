#!/bin/bash

aplicacion=/usr/local/bin/glud.sh
if [ -f $aplicacion ]
then
  echo 'El script ya está instalado.'
else

sudo tee $aplicacion << 'EOF'
usuario=${USER^^}
echo "  /\\_/\\  Hola $usuario"
echo ' ( o.o ) Bienvenid@ '
echo '  > ^ < '

#https://wiki.archlinux.org/index.php/proxy_settings
function proxy {
export {HTTP,HTTPS,FTP,ALL,SOCKS,RSYNC}_PROXY=http://10.20.4.15:3128
export {http,https,ftp,all,socks,rsync}_proxy=http://10.20.4.15:3128
export {NO_PROXY,no_proxy}="localhost,127.0.0.1,localaddress,.localdomain.com,10.20.0.0/16"

env | grep -i proxy
}

function proxyoff {
unset {HTTP,HTTPS,FTP,ALL,SOCKS,RSYNC,NO}_PROXY
unset {http,https,ftp,all,socks,rsync,no}_proxy

env | grep -i proxy 
}
EOF

fi

archivos=(
~/.bashrc
"/root/.bashrc"
)

for i in "${archivos[@]}"
do
  if sudo grep -i "$aplicacion" $i &> /dev/null
  then
    echo "El archivo $i ya está modificado."
  else
    sudo cp $i{,.bak}
    sudo tee -a $i <<< "source $aplicacion" 
  fi
done

# rationale: Mostrar al usuario qué hay que hacer
echo
echo 'Ejecuta el comando:'
echo "source $aplicacion"
