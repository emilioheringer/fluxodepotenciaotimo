%% Estudo de caso
%%Em�lio Camargo Heringer
%%Planejamento e opera��o de sistemas el�tricos


[NBarras] = size(Dados_Barra);
[NLinhas] = size(Dados_Linha);

%% Dados do sistema

BARRA = Dados_Barra(:,1);
nbus = size(Dados_Barra,1);
nlin = size(Dados_Linha,1);
PD = Dados_Barra(:,2);
tipo = Dados_Barra(:,5);
ang = pi/180*Dados_Barra(:,7);
PG = Dados_Barra(:,8);          
Pesp = PG-PD;
b = zeros(nlin,1);
Bsh = zeros(nbus,nbus);
B = zeros(nbus,nbus);
%%%

%%%
%% Matriz Suscept�ncia

for i = 1:nlin
    d = Dados_Linha(i,1); 
    p = Dados_Linha(i,2);
    r = Dados_Linha(i,4); 
    x = Dados_Linha(i,5); 
    g(i) = r/(r^2+x^2); 
    b(i) = -1/x;
    Bsh(i) = Dados_Linha(i,6)/2;        
        
    B(d,d) = B(d,d) + b(i) + Bsh(i);
    B(d,p) = B(d,p) - b(i);
    B(p,d) = B(p,d) - b(i);
    B(p,p) = B(p,p) + b(i) + Bsh(i);
    
end

d = Dados_Linha(:,1);
p = Dados_Linha(:,2);

SW = find(BARRA==1);
B(SW,:) = [];
B(:,SW) = [];
PG(SW) = 0;
Pesp(SW) = [];

teta = -inv(B)*Pesp;
j = 1;

for n = 1:nbus
    if tipo(n) ~= 1
        ang(n) = teta(j);
        j = j + 1;
    end
end

PGtotal = sum(PG);
PDtotal = sum(PD);
PG(SW) = PDtotal - PGtotal;





%RELAT�RIO DE BARRA
Relat1 = zeros(nbus,5);
Relat1(:,1) = BARRA;                
Relat1(:,2) = 180/pi*ang;          
Relat1(:,3) = PG-PD;       
Relat1(:,4) = PG;            
Relat1(:,5) = PD;            


%RELAT�RIO DE CIRCUITOS
%Fluxos
Pij =zeros(nlin,1);
Pji=zeros(nlin,1);
PerdP=zeros(nlin,1);

for n = 1:nlin
    k = d(n);
    m = p(n);
    Pij(n) = -b(n)*(ang(k) - ang(m));
    Pji(n) = -b(n)*(ang(m) - ang(k));
end

Relat2 = zeros(nlin,4);
Relat2(:,1) = d;
Relat2(:,2) = p;
Relat2(:,3) = Pij;
Relat2(:,4) = Pji;
Relat2(:,5) = PerdP;
       
%RESULTADO DADOS DE BARRA
        fprintf('    RELAT�RIO DE BARRA:\n');
        fprintf('    ------------------------------------------------\n');
        fprintf('     Barra    Ang.        Pi        PG        PL    \n');
        fprintf('            (graus)      (pu)      (pu)      (pu)   \n');
        fprintf('    ------------------------------------------------\n');
        disp(Relat1);
        fprintf('    ------------------------------------------------\n\n');

%RESULTADO DADOS DE LINHA
        fprintf('    RELAT�RIO DE LINHA:\n');
        fprintf('    ------------------------------------------------\n');
        fprintf('      DE       PARA      Pkm      Pmk      Perdas   \n');
        fprintf('                         (pu)     (pu)     (pu)     \n');
        fprintf('    ------------------------------------------------\n');
        disp(Relat2);
        fprintf('    ----------------------------------------------\n\n');

