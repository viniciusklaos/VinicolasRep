VERMELHO="\033[01;31;40m"
VERDE="\033[01;32;40m"
AMARELO="\033[01;33;40m"
AZUL="\033[01;34;40m"
ROSA="\033[01;35;40m"
CIANO="\033[01;36;40m"
NEGRITO="\033[01;37;40m"
RESET="\033[00;37;40m"
x="sistema"
menu ()
{
	while true $x != "sistema"
	do
	clear
	echo "------------------------------------------------"
	echo -e '${NEGRITO}De qual site veio o cliente?'
	echo "------------------------------------------------"
	echo ""
	echo ""
	echo -e '${NEGRITO}[1] -->${AMARELO} Revenda Brasil'
	echo ""
	echo -e '${NEGRITO}[2] -->${CIANO} Envio Pratico'
	echo ""
	echo -e '${NEGRITO}[3] -->${VERDE} Email Marketing Ideal'
	echo ""
	echo -e '${NEGRITO}[4] -->${ROSA} Disparo Digital'
  echo ""
  echo -e '${NEGRITO}[5] -->${AZUL} HostBH ${RESET}'
	echo ""
	echo ""
	echo "(Use exit para retornar)"
	echo ""
	echo ""
	echo  -e '${NEGRITO}[ ] -- Digite a opção desejada: -- [ ]${RESET}'
	echo ""
	read x
	echo ""
	echo "Voce escolheu: ($x)"
	echo "------------------------------------------------"

case "$x" in
1)
[ -d /home/vtinstall/menusistema ] || mkdir /home/vtinstall/menusistema; cd /home/vtinstall/menusistema
curl -O http://rep.vitalhost.com.br/v4/semcpanel/rb.sh && sh rb.sh
;;
2)
[ -d /home/vtinstall/menusistema ] || mkdir /home/vtinstall/menusistema; cd /home/vtinstall/menusistema
curl -O http://rep.vitalhost.com.br/v4/semcpanel/ep.sh && sh ep.sh
;;
3)
[ -d /home/vtinstall/menusistema ] || mkdir /home/vtinstall/menusistema; cd /home/vtinstall/menusistema
curl -O http://rep.vitalhost.com.br/v4/semcpanel/em.sh && sh em.sh
;;
4)
[ -d /home/vtinstall/menusistema ] || mkdir /home/vtinstall/menusistema; cd /home/vtinstall/menusistema
curl -O http://rep.vitalhost.com.br/v4/semcpanel/dd.sh && sh dd.sh
;;
5)
[ -d /home/vtinstall/menusistema ] || mkdir /home/vtinstall/menusistema; cd /home/vtinstall/menusistema
curl -O http://rep.vitalhost.com.br/v4/semcpanel/hb.sh && sh hb.sh
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
