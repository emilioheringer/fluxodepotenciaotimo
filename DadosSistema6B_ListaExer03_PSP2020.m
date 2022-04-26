%% Estudo de caso
%%Emílio Camargo Heringer
%%Planejamento e operação de sistemas elétricos
%%
%%DADOS GERAIS
%NUMERO DE BARRAS
nb = 6;
%POTÃŠNCIA BASE
Sbase = 100.0;
%NUMERO DE CIRCUITOS
nl = 11;
%%FIM DADOS GERAIS
Sbase = 100;
Tol = 1e-3;; % Tolerância pra convergência do sistema
MaxIt = 15; % Número máximo de iterações
It = 1; % Contador para número de iterações
%%DADOS DE BARRAS 
%NUM  ==> Numero da barra
%TIPO ==> Tipo de barra: 1 se barra de referÃªncia; 2 se barra de geraÃ§Ã£o; 3 se barra de carga.
%Pger ==> Potência maxima de geracao na barra em MW 
%Pcar ==> Carga pico na barra em MW
%Cost ==> Custo de geracao por MW em $/MW
Dados_Barra=[
%%BARRA  PD(PU)  QD(PU) Bsh(PU) TIPO  Vesp(PU) Oesp(°) PGesp(PU) Cus($/MW) CGmin(PU) CGmax(PU)
   01    0.00    0.00    0.00    1     1.00     0.00      0.00     25.00      0.00      1.2
   02    0.00    0.00    0.00    2     1.00     0.00      0.70     15.00      0.00      0.7
   03    0.00    0.00    0.00    2     1.00     0.00      0.70     35.00      0.00      0.7
   04    0.70    0.00    0.00    3     1.00     0.00      0.00     00.00      0.00      0
   05    0.70    0.00    0.00    3     1.00     0.00      0.00     00.00      0.00      0
   06    0.70    0.00    0.00    3     1.00     0.00      0.00     00.00      0.00      0
];
%+--+ +--+ +---+ +---+ +---+ 
%%FIM DADOS DE BARRAS 


%%DADOS DE LINHA
%NUM  ==> Numero do circuito
%DE   ==> Barra de origem
%PARA ==> Barra destino
%R%   ==> Resistencia percentual
%X%   ==> Reatan¢ncia percentual
%CAP  ==> Capacidade maxima de fluxo no circuito
%+--+ +--+ +--+ +--+ +--+ +--+
% NUM  DE  PARA  R%    X%  CAP
%+--+ +--+ +--+ +--+ +--+ +--+
Dados_Linha = [
 %%BDE   BPARA  NCIR  RES(PU) REAT(PU) SUCsh(PU)  TAP(PU)   DEF(GRAUS) LIG(1)DESL(0) CAP(PU)
   01    02     01    0.0200    0.2000      0.00     1.00     00.000           1     0.5000
   01    04     02    0.0200    0.2000      0.00     1.00     00.000           1     0.5000
   01    05     03    0.0300    0.3000      0.00     1.00     00.000           1     0.4000
   02    03     04    0.0250    0.2500      0.00     1.00     00.000           1     0.4000
   02    04     05    0.0100    0.1000      0.00     1.00     00.000           1     0.8000
   02    05     06    0.0300    0.3000      0.00     1.00     00.000           1     0.4000
   02    06     07    0.0200    0.2000      0.00     1.00     00.000           1     0.5000
   03    05     08    0.02600   0.2600      0.00     1.00     00.000           1     0.4000
   03    06     09    0.0100    0.1000      0.00     1.00     00.000           1     0.8000
   04    05     10    0.0400    0.4000      0.00     1.00     00.000           1     0.3000
   05    06     11    0.0300    0.3000      0.00     1.00     00.000           1     0.4000
];
%+--+ +--+ +--+ +--+ +--+ +--+
%% FIM DADOS DE LINHA

%%%%FIM DO ARQUIVO
   
