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
	echo "***   -   Host BH"
	echo "------------------------------------------------"
	echo ""
	echo ""
	echo -e '[1] --> MKT Super economico'
	echo ""
	echo -e '[2] --> MKT Economico'
	echo ""
	echo -e '[3] --> MKT Bronze'
	echo ""
	echo -e '[4] --> MKT Prata'
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
		taxames='10000'
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
		taxahora='500'
		taxames='350000'
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
	4)
		taxahora='6000'
		taxames='4000000'
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
