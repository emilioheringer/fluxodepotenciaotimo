%despacho proporcional
%% Estudo de caso
%%Em�lio Camargo Heringer
%%Planejamento e opera��o de sistemas el�tricos
P_prop=[116.9680,70.0000,23.0320]./210;

Pger(cont,1)=P_prop(1)*Curva_carga(cont);
Pger(cont,2)=P_prop(2)*Curva_carga(cont);
Pger(cont,3)=P_prop(3)*Curva_carga(cont);

Pger=Pger*210/100;


