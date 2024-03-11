#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n${redColour}[!] Saliendo...\n"
  exit 1;
}

trap ctrl_c INT

clear

function MAC_Aleatoria(){
  if [[ $USER != "root" ]]; then
    echo -e "\n${redColour}[!] Necesitas ser usuario root para esta opcion\n\n"
    exit 1
  else
  octeto_aleatorio() {
    printf '%02X' $((RANDOM % 256))
  }
  MAC_Aleatoria=$(octeto_aleatorio):$(octeto_aleatorio):$(octeto_aleatorio):$(octeto_aleatorio):$(octeto_aleatorio):$(octeto_aleatorio):
   echo -e "\n"
  for i in $(ifconfig -s | awk '{print $1}' | grep -v "Iface"); do 
    for x in $(ifconfig | grep ${i} | tr ':' ' ' | grep -vE "inet|inet6|lo" | awk '{print $1}'); do
    echo -e "${grayColour}Interfaz --> ${endColour}${blueColour}${x}" 
    done 
  done
  echo -e "\n${yellowColour}[+] Estas son las interfaces disponibles con MAC"
  echo -ne "${grayColour}[+] Ingresa La interfaz que deseas cambiar la MAC: " && read interfaz 
  ifconfig $interfaz down
  ifconfig $interfaz hw ether $MAC_Aleatoria
  ifconfig $interfaz up
  verificacion_mac=$(ifconfig ${interfaz} | grep "ether" | awk '{print $2}')
  echo -e "${grayColour}[+] La direccion MAC de ${interfaz} es: ${greenColour}${verificacion_mac}\n\n"
fi
}

function Interfaces_con_MAC(){
  echo -e "\n"
  for i in $(ifconfig -s | awk '{print $1}' | grep -v "Iface"); do 
    for x in $(ifconfig | grep ${i} | tr ':' ' ' | grep -vE "inet|inet6|lo" | awk '{print $1}'); do
      verificacion=$(ifconfig | grep -A 5 ${x} | grep ether | awk '{print $2}')
      if [[ ! ${verificacion} == "" ]]; then 
        echo -e "${grayColour}La interfaz ${blueColour}${x}${grayColour} tiene como direccion MAC:${redColour} ${verificacion}"
      fi
    done
  done 
  echo -e "\n"
}

function Insertar_MAC(){
  if [[ $USER != "root" ]]; then
    echo -e "\n${redColour}[!] Necesitas ser usuario root para esta opcion\n\n"
    exit 1
  else
    echo -e "\n" 
    for i in $(ifconfig -s | awk '{print $1}' | grep -v "Iface"); do 
      for x in $(ifconfig | grep ${i} | tr ':' ' ' | grep -vE "inet|inet6|lo" | awk '{print $1}'); do 
      echo -e "${grayColour}Interfaz --> ${blueColour}${x}"
      done 
    done
      echo -e "\n${yellowColour}[+] Estas son las interfaces disponibles con MAC"
      echo -ne "${grayColour}[+] Ingresa La interfaz que deseas cambiar la MAC: " && read interfaz 
      echo -ne "${grayColour}[+] Ingresa la nueva direccion MAC: " && read new_mac
      ifconfig $interfaz down
      ifconfig $interfaz hw ether $new_mac
      ifconfig $interfaz up
      verificacion_mac=$(ifconfig ${interfaz} | grep "ether" | awk '{print $2}')
      echo -e "${grayColour}[+] La direccion MAC de ${interfaz} es: ${greenColour}${verificacion_mac}\n\n"
  fi
}

function MAC_En_Uso(){
  echo -e "\n"
   for i in $(ifconfig -s | awk '{print $1}' | grep -v "Iface"); do 
    for x in $(ifconfig | grep ${i} | tr ':' ' ' | grep -vE "inet|inet6|lo" | awk '{print $1}'); do 
    echo -e "${grayColour}Interfaz --> ${blueColour}${x}"
    done 
  done
  echo -ne "${grayColour}[+]Ingresa la interfaz que deseas ver: " && read interfaz 
  mac_actual=$(ifconfig | grep -A 6 ${interfaz} | grep "ether" | awk '{print $2}')
  echo -e "La interfaz ${interfaz} tiene como direccion MAC: ${blueColour}${mac_actual}\n"
}

function pregunta(){
  echo -e """
  ${redColour}¿Por que se modifica la MAC?${endColour}

  ${grayColour}Las direcciones MAC se modifican ya que es una forma de mantenerte seguro
  en todo lo que es la parte de ataques de redes locales por ejemplo
  1.- Ataque de Desautenticacion
  2.- Ataque de fuerza bruta
  3.- Sniffer
  4.- Ataques de Evil Twin
  5.- Ataque de Beacon

  Entre muchos ataques mas.
  Debemos tener en cuenta que basicamente nuestra direccion MAC es el identificador de la tarjeta de red 
  donde con esto pueden saber
  1.- Nuestro ISP
  2.- Nuestra localizacion exacta
  
  Por eso he creado mayormente esta herramienta para el anonimato en el campo de ataques locales
  o fisicos

  hacia entidades externas recuerda nunca proporcionarles la direccion MAC tuya ya que podrian
  sacarte tu localizacion exacta, donde este es un metodo de geolocalizacion
  
  """
}

echo -e """${grayColour}

 ███▄ ▄███▓ ▄▄▄       ▄████▄      ▄████▄   ██░ ██  ▄▄▄       ███▄    █   ▄████ ▓█████  ██▀███  
▓██▒▀█▀ ██▒▒████▄    ▒██▀ ▀█     ▒██▀ ▀█  ▓██░ ██▒▒████▄     ██ ▀█   █  ██▒ ▀█▒▓█   ▀ ▓██ ▒ ██▒
▓██    ▓██░▒██  ▀█▄  ▒▓█    ▄    ▒▓█    ▄ ▒██▀▀██░▒██  ▀█▄  ▓██  ▀█ ██▒▒██░▄▄▄░▒███   ▓██ ░▄█ ▒
▒██    ▒██ ░██▄▄▄▄██ ▒▓▓▄ ▄██▒   ▒▓▓▄ ▄██▒░▓█ ░██ ░██▄▄▄▄██ ▓██▒  ▐▌██▒░▓█  ██▓▒▓█  ▄ ▒██▀▀█▄  
▒██▒   ░██▒ ▓█   ▓██▒▒ ▓███▀ ░   ▒ ▓███▀ ░░▓█▒░██▓ ▓█   ▓██▒▒██░   ▓██░░▒▓███▀▒░▒████▒░██▓ ▒██▒
░ ▒░   ░  ░ ▒▒   ▓▒█░░ ░▒ ▒  ░   ░ ░▒ ▒  ░ ▒ ░░▒░▒ ▒▒   ▓▒█░░ ▒░   ▒ ▒  ░▒   ▒ ░░ ▒░ ░░ ▒▓ ░▒▓░
░  ░      ░  ▒   ▒▒ ░  ░  ▒        ░  ▒    ▒ ░▒░ ░  ▒   ▒▒ ░░ ░░   ░ ▒░  ░   ░  ░ ░  ░  ░▒ ░ ▒░
░      ░     ░   ▒   ░           ░         ░  ░░ ░  ░   ▒      ░   ░ ░ ░ ░   ░    ░     ░░   ░ 
       ░         ░  ░░ ░         ░ ░       ░  ░  ░      ░  ░         ░       ░    ░  ░   ░     
                     ░           ░                                                             
                          Herramienta Creada por DarknetGhost

Menu de Opciones
1.- Visualizar Direccion MAC Actual
2.- Cambiar a una direccion MAC aleatoria
3.- Poner una Direccion MAC a gusto de usuario
4.- Ver interfaces con una direccion MAC
5.- Por que cambiar direccion MAC?
99.- Salir${endColour}
"""
echo -ne "${grayColour}[+] Ingresa la opcion que deseas: " && read opcion 

case $opcion in 
  1)
    MAC_En_Uso
  ;;
  
  2)
    MAC_Aleatoria
  ;;

  3)
    Insertar_MAC
  ;;

  4)
    Interfaces_con_MAC
  ;;

  5)
    pregunta 
  ;;
esac
