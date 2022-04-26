%% Estudo de caso
%%Emílio Camargo Heringer
%%Planejamento e operação de sistemas elétricos


clear all
clc
DadosSistema6B_ListaExer03_PSP2020
disp('###### MENU #####\n')
disp('1 - Fluxo dc sem perdas')
disp('2 - Fluxo dc com perdas')
disp('3 - Despacho ótimo sem perdas')
disp('4 - Despacho ótimo com perdas')
disp('5 - Despacho proporcional')
disp('6 - Análises de fluxo e geração')
disp('7 - Geração eólica')


x=input('Digite a opção desejada');

switch x
    case 1
        fluxosemperda
    case 2 
        fluxocomperdas
    case 3 
        fluxosemperda
        despachotimo
    case 4
        fluxocomperdas
        despachotimo
    case 5
           
            for cont=1:8736
            clearvars -except Geracao cont fluxos Curva_carga
            DadosSistema6B_ListaExer03_PSP2020
            %%Descomentar a carga que deseja simular
            CargaOriginal
            %CargaSemanaPico
            despachoproporcional
            Dados_Barra(2,8)=Pger(cont,2)/100;
            Dados_Barra(3,8)=Pger(cont,3)/100;
            Dados_Barra(:,2)=Dados_Barra(:,2)*Curva_carga(cont)/100;
            %fluxosemperda
            fluxocomperdas
            Geracao(cont,1)=Relat1(1,4);
            fluxos(cont,1)=Relat2(3,3);
            
           
            end
            PG_med=mean(Geracao);
            PG_desvio=std(Geracao);
            PG_moda=mode(Geracao);
            PG_min=min(Geracao);
            PG_Var=var(Geracao*100);
            F_med=mean(fluxos);
            F_desvio=std(fluxos);
            F_moda=mode(fluxos);
            F_min=min(fluxos);
            F_Var=var(fluxos*100);
            plot(1:8736,210*Curva_carga/100)
            title('Curva de Carga')
            xlabel('Tempo h')
            ylabel('MW')
            figure(2)
            plot(1:8736,Geracao*100)
            title('Curva do Gerador Barra 1')
            xlabel('Tempo h')
            ylabel('MW')         
            
    case 6
                    for cont=1:8736
            clearvars -except Geracao cont fluxos Curva_carga Per_tot geracao_oti
            DadosSistema6B_ListaExer03_PSP2020
            %%Descomentar a carga que deseja simular
            CargaOriginal
            %CargaSemanaPico
            Dados_Barra(4,2)=(((Curva_carga(cont))/100)*(210/100))/3;
            Dados_Barra(5,2)=(((Curva_carga(cont))/100)*(210/100))/3;
            Dados_Barra(6,2)=(((Curva_carga(cont))/100)*(210/100))/3;
            
            %fluxosemperda
            fluxocomperdas
            despachotimo
            Geracao(cont,1)=Relat1(1,4);
            fluxos(cont,1)=Relat2(3,3);
            Per_tot(cont,1)=sum(Relat2(:,5));
            
           geracao_oti(cont,1)=Dados_Barra(1,8);
            end
            PG_med=mean(Geracao);
            PG_desvio=std(Geracao);
            PG_moda=mode(Geracao);
            PG_min=min(Geracao);
            PG_Var=var(Geracao*100);
            F_med=mean(fluxos);
            F_desvio=std(fluxos);
            F_moda=mode(fluxos);
            F_min=min(fluxos);
            F_Var=var(fluxos*100);
            plot(1:8736,100*fluxos)
            title('Curva de fluxos')
            xlabel('Tempo h')
            ylabel('MW')
            figure(2)
            plot(1:8736,Geracao*100)
            title('Curva do Gerador Barra 1')
            xlabel('Tempo h')
            ylabel('MW')    
             figure(3)
            plot(1:8736,Per_tot*100)
            title('Perdas')
            xlabel('Tempo h')
            ylabel('MW') 
                figure(4)
            plot(1:8736,geracao_oti*100)
            title('Geracao Otima Barra 1')
            xlabel('Tempo h')
            ylabel('MW') 
        
    case 7
            for cont=1:8736
            clearvars -except Geracao cont fluxos Curva_carga Per_tot geracao_oti
            DadosSistema6B_ListaExer03_PSP2020
            %%Descomentar a carga que deseja simular
            %CargaOriginal
            CargaSemanaPico
            SerieEolica
            Dados_Barra(4,2)=(((Curva_carga(cont))/100)*(210/100))/3;
            Dados_Barra(5,2)=(((Curva_carga(cont))/100)*(210/100))/3;
            Dados_Barra(6,2)=(((Curva_carga(cont))/100)*(210/100))/3;
            Dados_Barra(6,8)=g6(cont)/100;
            %fluxosemperda
            fluxocomperdas
            despachotimo
            Geracao(cont,1)=Relat1(1,4);
            fluxos(cont,1)=Relat2(3,3);
            Per_tot(cont,1)=sum(Relat2(:,5));
            geracao_oti(cont,1)=Dados_Barra(1,8);
            end
            PG_med=mean(Geracao);
            PG_desvio=std(Geracao);
            PG_moda=mode(Geracao);
            PG_min=min(Geracao);
            PG_Var=var(Geracao*100);
            F_med=mean(fluxos);
            F_desvio=std(fluxos);
            F_moda=mode(fluxos);
            F_min=min(fluxos);
            F_Var=var(fluxos*100);
            plot(1:8736,100*fluxos)
            title('Curva de fluxos')
            xlabel('Tempo h')
            ylabel('MW')
            figure(2)
            plot(1:8736,Geracao*100)
            title('Curva do Gerador Barra 1')
            xlabel('Tempo h')
            ylabel('MW')    
             figure(3)
            plot(1:8736,Per_tot*100)
            title('Perdas')
            xlabel('Tempo h')
            ylabel('MW') 
                figure(4)
            plot(1:8736,geracao_oti*100)
            title('Geracao Otima Barra 1')
            xlabel('Tempo h')
            ylabel('MW') 
end