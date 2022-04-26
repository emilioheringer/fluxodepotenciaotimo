% TRABALHO 01 DE SEP 2 
% PROFESSOR: FERNANDO ASSIS
% EQUIPE: ALISSON
%         ARTHUR
%         GABRIEL
%         RODRIGO
%
%%
clear;
close all;
clc;
%%
%arquivo = fopen('dados_sistema3B.txt','r'); % Abrindo o arquivo txt
%arquivo = fopen('dados_sistema5B_2ref.txt','r'); % Abrindo o arquivo txt
arquivo = fopen('dados_sistema6Barras_custos.txt','r'); % Abrindo o arquivo txt

Sbase = 100;
Tol = 1e-3;; % Tolerância pra convergência do sistema
MaxIt = 15; % Número máximo de iterações
It = 1; % Contador para número de iterações
Dados_Barra = []; % Dados Barra
Dados_Linha = []; % Dados Linha

linha = fgetl(arquivo);
linha = fgetl(arquivo);
linha = fgetl(arquivo);
linha = fgetl(arquivo);

i = 1;
while feof(arquivo) == 0
    Dados_Barra(i,1) = str2num(linha(1:5)); % Coluna 1 - Número da Barra
    Dados_Barra(i,2) = str2num(linha(7:13)); % Coluna 2 - Potência Ativa barramento
    Dados_Barra(i,3) = str2num(linha(15:21)); % Coluna 3 - Potência Reativa no barramento
    Dados_Barra(i,4) = str2num(linha(23:29)); % Coluna 4 - Capacitância Shunt
    if(linha(34:35) == 'SW') % Coluna 5 - Tipo do barramento
        Dados_Barra(i,5) = 1;
    elseif(linha(34:35) == 'PV')
        Dados_Barra(i,5) = 2;
    elseif(linha(34:35) == 'PQ')
        Dados_Barra(i,5) = 3;
    end
    Dados_Barra(i,6) = str2num(linha(37:44)); % Coluna 6 - Tensão Especificada do barramento
    Dados_Barra(i,7) = str2num(linha(46:53)); % Coluna 7 - Teta especificado
    Dados_Barra(i,8) = str2num(linha(55:63)); % Coluna 8 - Potência Ativa do gerador
    Dados_Barra(i,9) = str2num(linha(65:73)); % Coluna 9 - Custo
    Dados_Barra(i,10) = str2num(linha(75:83)); % Coluna 10 - capacidade de geração mínima
    Dados_Barra(i,11) = str2num(linha(85:93)); % Coluna 11 - capacidade de geração máxima
    linha = fgetl(arquivo);
    i = i + 1;
    if(linha(1:4) == '####')
        break;
    end
end
    
    linha = fgetl(arquivo);
    linha = fgetl(arquivo);
    linha = fgetl(arquivo);
    linha = fgetl(arquivo);
    linha = fgetl(arquivo);
    
    k = 1;
    while feof(arquivo) == 0
        Dados_Linha(k,1) = str2num(linha(1:5)); % Coluna 1 - De
        Dados_Linha(k,2) = str2num(linha(7:11)); % Coluna 2 - Para
        Dados_Linha(k,3) = str2num(linha(13:17)); % Coluna 3 - Número da Linha
        Dados_Linha(k,4) = str2num(linha(19:26)); % Coluna 4 - Resistência
        Dados_Linha(k,5) = str2num(linha(28:35)); % Coluna 5 - Reatância
        Dados_Linha(k,6) = str2num(linha(37:45)); % Coluna 6 - Susceptância Shunt
        Dados_Linha(k,7) = str2num(linha(47:54)); % Coluna 7 - Tap
        Dados_Linha(k,8) = str2num(linha(56:65)); % Coluna 8 - Defasagem
        
        if(linha(79) == 'L')                      % Coluna 9 - Situação: Ligado(L) ou Desligado(D)
          Dados_Linha(k,9) = 1;
        else
            Dados_Linha(k,9) = 0;
        end
        
        Dados_Linha(k,10) = str2num(linha(82:89)); % Coluna 10 - Capacidade da linha
        linha = fgetl(arquivo);
        k = k + 1;
        if(linha(1:4) == '####')
            break;
        end
    end

fclose(arquivo);
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
%% Matriz Susceptância

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


%% Fluxo Ótimo

%Declarando tamanho dos vetores

for n=1:nbus
    if Dados_Barra(n,:) ~= 0
        i=0;
        i=i+1;
        [nger]=size(i);
    end
    
   
end
for n=1:nlin
    [ncir]=size(Dados_Linha,1);
end




%RELATÓRIO DE BARRA
Relat1 = zeros(nbus,5);
Relat1(:,1) = BARRA;                
Relat1(:,2) = 180/pi*ang;          
Relat1(:,3) = PG-PD;       
Relat1(:,4) = PG;            
Relat1(:,5) = PD;            


%RELATÓRIO DE CIRCUITOS
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
        fprintf('    RELATÓRIO DE BARRA:\n');
        fprintf('    ------------------------------------------------\n');
        fprintf('     Barra    Ang.        Pi        PG        PL    \n');
        fprintf('            (graus)      (pu)      (pu)      (pu)   \n');
        fprintf('    ------------------------------------------------\n');
        disp(Relat1);
        fprintf('    ------------------------------------------------\n\n');

%RESULTADO DADOS DE LINHA
        fprintf('    RELATÓRIO DE LINHA:\n');
        fprintf('    ------------------------------------------------\n');
        fprintf('      DE       PARA      Pkm      Pmk      Perdas   \n');
        fprintf('                         (pu)     (pu)     (pu)     \n');
        fprintf('    ------------------------------------------------\n');
        disp(Relat2);
        fprintf('    ----------------------------------------------\n\n');

%%% FPO

NPV = length(find(2 == Dados_Barra(:,11)));                       % Número de barras PV
cr = 100;                                                  % Custo do corte de carga [$/MW]
T2 = zeros(1,nbus);
T3 = zeros(1,nbus);
Bsus = zeros(nbus);
ncar = size((find(0~=Dados_Barra(:,2))),1);

%% achando a matriz de referencia
x = find(1==Dados_Barra(:,5));

%% montagem da matriz B
for c = 1:nlin
    m = Dados_Linha(c,1);
    n = Dados_Linha(c,2);
    Bsus(m,n) = Bsus(m,n) + 1/Dados_Linha(c,5);
    Bsus(n,m) = Bsus(m,n);
    Bsus(m,m) = Bsus(m,m) - 1/Dados_Linha(c,5);
    Bsus(n,n) = Bsus(n,n) - 1/Dados_Linha(c,5);
end

%% iniciando matrizes do linprog
f = zeros(1,nbus-1);
lb = zeros(nbus,1);
ub = zeros(nbus,1);
for i = 1:nbus
    if Dados_Barra(i,5) ~= 0
        lb(i) = -pi;
        ub(i) = pi;
    end
end
lb(x) = [];
ub(x) = [];
for i = 1:nbus
    if Dados_Barra(i,5) < 3 %adicionando as barras geradoras
        f = ([f Dados_Barra(i,9)]);
        lb = ([lb;Dados_Barra(i,10)]);
        ub = ([ub;Dados_Barra(i,11)]);
        T2(i) = i;
    end
end

for i = 1:nbus
    if Dados_Barra(i,2) ~= 0
        T3(i) = i; %
    end
end

for i = 1:nbus
    if T3(i) ~= 0 %adicionando corte de carga
        f = ([f cr]);
        lb = ([lb;0]);
        ub = ([ub;Dados_Barra(i,2)]);
    end
end

t = find(0~=T2);
t2 = size(t,2);
Aeq2 = zeros(nbus,t2);
for j = 1:size(Aeq2,2)
    Aeq2(t(j),j) = 1;
end

t = find(0~=T3);
t2 = size(t,2);
Aeq3 = zeros(nbus,t2);
for j = 1:size(Aeq3,2)
    Aeq3(t(j),j) = 1;
end

AEQ = Bsus;
AEQ(:,x) = [];
AEQ = ([AEQ Aeq2 Aeq3]);
beq = zeros(1,nbus);
for i=1:nbus
    beq(i) = Dados_Barra(i,2);
end

blin = zeros(2*nlin,1);
i = 1;
j = 1;
while i <= 2*nlin
    blin(i) = Dados_Linha(j,10);
    j = j + 1;
    i = i + 2;
end
i = 2;
j = 1;
while i <= 2*nlin
    blin(i) = Dados_Linha(j,10);
    j = j + 1;
    i = i + 2;
end
A1 = zeros(nlin);
for i=1:nlin
    m = Dados_Linha(i,1);
    n = Dados_Linha(i,2);
    if m ~= x
        A1(i,n) = -1/Dados_Linha(i,5);
        A1(i,m) = 1/Dados_Linha(i,5);
    else
        A1(i,n) = -1/Dados_Linha(i,5);
    end
end
A = zeros(2*nlin,size(f,2));
i = 1;
j = 1;
while i <= 2*nlin
    for t = 1:nlin
        A(i,t) = A1(j,t);
    end
    j = j + 1;
    i = i + 2;
end
i = 2;
j = 1;
while i <= 2*nlin
    for t = 1:nlin
        A(i,t) = -A1(j,t);
    end
    j = j + 1;
    i = i + 2;
end
A(:,x) = [];
i = size(A,2);
A(:,i+1) = 0;

%% OBTENÇÃO DO PONTO OTIMO
[w,S,exitflag,output,lambda] = linprog(f,A,blin,AEQ,beq,lb,ub);
j = nbus;
k = nbus + NPV + 1;
for i = 1:nbus
    if T2(i) ~= 0
        Dados_Barra(i,8) = w(j,1);
        j = j + 1;
    end
    if T3(i) ~= 0
        Dados_Barra(i,2) = Dados_Barra(i,2) - w(k,1);
        k = k + 1;
    end
end



        
%%%%%%%%%%%%%IMPRESSÃO DO SISTEMA OTIMIZADO

NPV = length(find(2 == Dados_Barra(:,5)));                       % Número de barras PV
jj = nbus + NPV + 1;
        if exitflag == 1
    fprintf('O Sistema Possui Solução Factível:                  Sim \n')
else
    fprintf('O Sistema Possui Solução Factível:                  Não \n')
end
h=0;
fprintf('    ------------------------------------------------\n');
for i = 1:nbus
if Dados_Barra (i,8)~=0
    fprintf('Potência gerada na barra %.0f (MW):                 %.4f \n',Dados_Barra(i,1),Dados_Barra(i,8)*100)
end
end

fprintf('    ------------------------------------------------\n');

for i = 1:nbus
if Dados_Barra(i,5)~=1
h=h+1;
%h(i)=[h(i) 1]
Dados_Barra(i,7)=w(h);
    fprintf('Angulo da Barra %.0f:                               %.4fº \n',Dados_Barra(i,1),w(h)*180/pi)

end
end

fprintf('    ------------------------------------------------\n');

    fprintf('Corte de Carga Total (MW):                       %.4f \n', sum(w(jj:end))*100)

for i = 1:nbus
    if T3(i) ~= 0
    fprintf('Corte de Carga na barra %.0f (MW):                  %.4f \n',i,w(jj,1)*100)
        jj = jj + 1;
    else
    fprintf('Corte de Carga na barra %.0f (MW):                  %.4f \n',i,0)
    end
end

fprintf('    ------------------------------------------------\n');    

    fprintf('Custo Total de Geraçao ($):                      %.4f \n', S)

fprintf('    ------------------------------------------------\n');

for n = 1:nlin
  DE=Dados_Linha(n,1);
  PARA=Dados_Linha(n,2);
  SUS=1/Dados_Linha(n,5);
  fprintf('Fluxo %.0f para %.0f (MW):                  %.4f \n', DE, PARA, 100*(Dados_Barra(DE,7) - Dados_Barra(PARA,7))*SUS)
    
end

fprintf('    ------------------------------------------------\n');
