VERMELHO="\033[01;31;40m"
VERDE="\033[01;32;40m"
AMARELO="\033[01;33;40m"
AZUL="\033[01;34;40m"
ROSA="\033[01;35;40m"
CIANO="\033[01;36;40m"
RESET="\033[00;37;40m"
NEGRITO="\033[01;37;40m"

x="sistema"
menu ()
{
	while true $x != "sistema"
	do
	clear
	echo -e '${NEGRITO}------------------------------------------------'
	echo "***   -   Revenda Brasil"
	echo "------------------------------------------------"
	echo ""
	echo ""
	echo -e '[1] --> MKT MINI'
	echo ""
	echo -e '[2] --> MKT 1'
	echo ""
	echo -e '[3] --> MKT 2'
	echo ""
	echo -e '[4] --> MKT 3'
	echo ""
	echo -e '[5] --> MKT 4'
	echo ""
	echo -e '[6] --> MKT 5'
	echo ""
	echo -e '[7] --> MKT 6'
	echo ""
	echo -e '[8] --> MKT 7'
	echo ""
	echo -e '[9] --> MKT 8'
	echo ""
	echo -e '[10] --> MKT 9'
	echo ""
	echo -e '[11] --> MKT 10'
	echo ""
	echo -e '[12] --> MKT MAXIMO'
	echo ""
	echo ""
	echo "(Use exit para retornar)"
	echo ""
	echo ""
	echo  -e '[ ] -- Digite a opção desejada: -- [ ]${RESET}'
	echo ""
	read x
	echo ""
	echo "Voce escolheu: ($x)"
	echo "------------------------------------------------"

case "$x" in
1)
	taxahora='500'
	taxames='50000'
	admin='0'
	echo $taxahora > /tmp/horatemp
	echo $taxames > /tmp/mestemp
	echo $admin > /tmp/admin
  cd /home/vtinstall
  curl -O http://rep.vitalhost.com.br/v4/semcpanel/superautomatico.sh
  clear
	sh superautomatico.sh
  exit
;;
2)
	taxahora='1000'
	taxames='100000'
	admin='0'
	echo $taxahora > /tmp/horatemp
	echo $taxames > /tmp/mestemp
	echo $admin > /tmp/admin
	cd /home/vtinstall
	curl -O http://rep.vitalhost.com.br/v4/semcpanel/superautomatico.sh
	clear
	sh superautomatico.sh
	exit
;;
3)
	taxahora='2000'
	taxames='500000'
	admin='0'
	echo $taxahora > /tmp/horatemp
	echo $taxames > /tmp/mestemp
	echo $admin > /tmp/admin
	cd /home/vtinstall
	curl -O http://rep.vitalhost.com.br/v4/semcpanel/superautomatico.sh
	clear
	sh superautomatico.sh
	exit
;;
4)
	taxahora='3000'
	taxames='1000000'
	admin='0'
	echo $taxahora > /tmp/horatemp
	echo $taxames > /tmp/mestemp
	echo $admin > /tmp/admin
	cd /home/vtinstall
	curl -O http://rep.vitalhost.com.br/v4/semcpanel/superautomatico.sh
	clear
	sh superautomatico.sh
	exit
;;
5)
	taxahora='7000'
	taxames='5000000'
	admin='1'
	echo $taxahora > /tmp/horatemp
	echo $taxames > /tmp/mestemp
	echo $admin > /tmp/admin
	cd /home/vtinstall
	curl -O http://rep.vitalhost.com.br/v4/semcpanel/superautomatico.sh
	clear
	sh superautomatico.sh
	exit
;;
6)
	taxahora='14000'
	taxames='10000000'
	admin='1'
	echo $taxahora > /tmp/horatemp
	echo $taxames > /tmp/mestemp
	echo $admin > /tmp/admin
	cd /home/vtinstall
	curl -O http://rep.vitalhost.com.br/v4/semcpanel/superautomatico.sh
	clear
	sh superautomatico.sh
	exit
;;
7)
	taxahora='25000'
	taxames='18000000'
	admin='1'
	echo $taxahora > /tmp/horatemp
	echo $taxames > /tmp/mestemp
	echo $admin > /tmp/admin
	cd /home/vtinstall
	curl -O http://rep.vitalhost.com.br/v4/semcpanel/superautomatico.sh
	clear
	sh superautomatico.sh
	exit
;;
8)
	taxahora='40000'
	taxames='28000000'
	admin='1'
	echo $taxahora > /tmp/horatemp
	echo $taxames > /tmp/mestemp
	echo $admin > /tmp/admin
	cd /home/vtinstall
	curl -O http://rep.vitalhost.com.br/v4/semcpanel/superautomatico.sh
	clear
	sh superautomatico.sh
	exit
;;
9)
	taxahora='65000'
	taxames='46800000'
	admin='1'
	echo $taxahora > /tmp/horatemp
	echo $taxames > /tmp/mestemp
	echo $admin > /tmp/admin
	cd /home/vtinstall
	curl -O http://rep.vitalhost.com.br/v4/semcpanel/superautomatico.sh
	clear
	sh superautomatico.sh
	exit
;;
10)
	taxahora='130000'
	taxames='a'
	admin='1'
	echo $taxahora > /tmp/horatemp
	echo $taxames > /tmp/mestemp
	echo $admin > /tmp/admin
	cd /home/vtinstall
	curl -O http://rep.vitalhost.com.br/v4/semcpanel/superautomatico.sh
	clear
	sh superautomatico.sh
	exit
;;
11)
	taxahora='195000'
	taxames='a'
	admin='1'
	echo $taxahora > /tmp/horatemp
	echo $taxames > /tmp/mestemp
	echo $admin > /tmp/admin
	cd /home/vtinstall
	curl -O http://rep.vitalhost.com.br/v4/semcpanel/superautomatico.sh
	clear
	sh superautomatico.sh
	exit
;;
12)
	taxahora='260000'
	taxames='a'
	admin='1'
	echo $taxahora > /tmp/horatemp
	echo $taxames > /tmp/mestemp
	echo $admin > /tmp/admin
	cd /home/vtinstall
	curl -O http://rep.vitalhost.com.br/v4/semcpanel/superautomatico.sh
	clear
	sh superautomatico.sh
	exit
;;
exit)

	exit;
;;
*)
	echo "Opção Inválida."
	sleep 1
esac
done

}
menu
