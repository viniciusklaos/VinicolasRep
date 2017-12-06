VERMELHO="\033[01;31;40m"
VERDE="\033[01;32;40m"
AMARELO="\033[01;33;40m"
AZUL="\033[01;34;40m"
ROSA="\033[01;35;40m"
CIANO="\033[01;36;40m"
RESET="\033[00;37;40m"
NEGRITO="\033[01;37;40m"
x="teste"
menu ()
{
while true $x != "teste"
do
clear
echo -e '${NEGRITO}------------------------------------------------'
echo -e ' Menu para sistemas ${VERDE}COM CPANEL${NEGRITO}:'
echo "------------------------------------------------"
echo ""
echo "[ ] -- Digite a opção desejada: -- [ ]"
echo ""
echo ""
echo -e '[1] --> Instalar conta'
echo ""
echo -e '[2] --> Dar manutenção'
echo ""
echo ""
echo -e '[3] -- Sair ${RESET}'
echo ""
echo ""
read x
echo ""
echo "Voce escolheu: ($x)"
echo "------------------------------------------------"

case "$x" in
1)
    [ -d /home/vtinstall/menusistema ] || mkdir /home/vtinstall/menusistema; cd /home/vtinstall/menusistema
    [ -d /home/vtinstall/vartemp ] || mkdir /home/vtinstall/vartemp; cd /home/vtinstall/vartemp
    curl -O http://rep.vitalhost.com.br/v4/semcpanel/menusist.sh && sh menusist.sh
echo "------------------------------------------------"
;;
   2)
      [ -d /home/vtinstall/menu ] || mkdir /home/vtinstall/menu; cd /home/vtinstall/menu
      curl -O http://rep.vitalhost.com.br/v4/semcpanel/manucpanel.sh && sh manucpanel.sh
echo "------------------------------------------------"
;;
    3)
         echo -e '${RESET}'
         exit;
echo "------------------------------------------------"
;;

    *)
        echo "Opção inválida."
        sleep 1
esac
done

}
menu
