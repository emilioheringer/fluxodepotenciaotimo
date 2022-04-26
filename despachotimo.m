%Despachootimo
%% Estudo de caso
%%Emílio Camargo Heringer
%%Planejamento e operação de sistemas elétricos
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
