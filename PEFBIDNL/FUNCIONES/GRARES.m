% Creación de curvas de resultados para un proceso de carga en el tiempo
function [CXY] = GRARES(CUR,FXY,UXY,SRE,ERE,CXY,IPSE,NMIT,ADAD,DOM,ITER,NPSE)
    
    %  ENTRADAS:
    %-----------------------------------------------------------------------------
    %  - [CUR]: Tabla de curvas a elaborar:
    %           CUR = [ INUD(X) VARX INUD(Y) VARY ]  
    %           (1=UX, 2=UY, 3=FX, 4=FY, 5=EX, 6=EY, 7=SX, 8=SY)
    %  - [FXY]: Fuerzas organizadas por nudo en formato x,y
    %  - [UXY]: Desplazamientos organizados por nudo en formato x,y
    %  - [CX0]: Tabla de gráficas de resultados hasta el pseudo-tiempo
    %           anterior
    %           CX0 = [VX1 VY1 VX2 VY2 VX3 VY3... VXN VYN]
    %-----------------------------------------------------------------------------
    %  SALIDAS:
    %-----------------------------------------------------------------------------
    %  - [CXY]: Tabla de gráficas de resultados hasta el pseudo-tiempo
    %           actual
    %           CXY = [VX1 VY1 VX2 VY2 VX3 VY3... VXN VYN]
    %-----------------------------------------------------------------------------
    
    
    % Almacenamiento de variables
    NCUR = size(CUR,1);
    for ICUR=1:NCUR
        VARX = CUR(ICUR,2); VARY = CUR(ICUR,4);
        INUX = CUR(ICUR,1); INUY = CUR(ICUR,3);
        if VARX==1; CXY(IPSE,ICUR*2-1) = UXY(INUX,1); end %endif
        if VARX==2; CXY(IPSE,ICUR*2-1) = UXY(INUX,2); end %endif
        if VARX==3; CXY(IPSE,ICUR*2-1) = FXY(INUX,1); end %endif
        if VARX==4; CXY(IPSE,ICUR*2-1) = FXY(INUX,2); end %endif
        if VARX==5
            TEM = ERE(ERE(:, 2) == INUX,:);
            CXY(IPSE,ICUR*2-1) = mean(TEM(:,3));
        end %endif
        if VARX==6
            TEM = ERE(ERE(:, 2) == INUX,:);
            CXY(IPSE,ICUR*2-1) = mean(TEM(:,4));
        end %endif
        if VARX==7
            TEM = SRE(SRE(:, 2) == INUX,:);
            CXY(IPSE,ICUR*2-1) = mean(TEM(:,3));
        end %endif
        if VARX==8
            TEM = SRE(SRE(:, 2) == INUX,:);
            CXY(IPSE,ICUR*2-1) = mean(TEM(:,4));
        end %endif
        
        
        if VARY==1; CXY(IPSE,ICUR*2) = UXY(INUY,1); end %endif
        if VARY==2; CXY(IPSE,ICUR*2) = UXY(INUY,2); end %endif
        if VARY==3; CXY(IPSE,ICUR*2) = FXY(INUY,1); end %endif
        if VARY==4; CXY(IPSE,ICUR*2) = FXY(INUY,2); end %endif
        if VARY==5
            TEM = ERE(ERE(:, 2) == INUX,:);
            CXY(IPSE,ICUR*2) = mean(TEM(:,3));
        end %endif
        if VARY==6
            TEM = ERE(ERE(:, 2) == INUX,:);
            CXY(IPSE,ICUR*2) = mean(TEM(:,4));
        end %endif
        if VARY==7
            TEM = SRE(SRE(:, 2) == INUY,:);
            CXY(IPSE,ICUR*2) = mean(TEM(:,3));
        end %endif
        if VARY==8
            TEM = SRE(SRE(:, 2) == INUY,:);
            CXY(IPSE,ICUR*2) = mean(TEM(:,4));
        end %endif
        
    end %endfor ICUR
   
    % Salida de gráficas

    if ITER==NMIT || IPSE==NPSE
        TXY = zeros(NCUR,14);
        % Impresión de archivo.inf.mat, que contiene la información de
        % todas las curvas impresas. Variable y nudo para cada eje.
        for ICUR=1:NCUR
            VARX = CUR(ICUR,2); VARY = CUR(ICUR,4);
            INUX = CUR(ICUR,1); INUY = CUR(ICUR,3);
            switch VARX
                case 1; TVX = 'UX';
                case 2; TVX = 'UY';
                case 3; TVX = 'FX';
                case 4; TVX = 'FY';
                case 5; TVX = 'EX';
                case 6; TVX = 'EY';
                case 7; TVX = 'SX';
                case 8; TVX = 'SY';
            end %endswitch
            switch VARY
                case 1; TVY = 'UX';
                case 2; TVY = 'UY';
                case 3; TVY = 'FX';
                case 4; TVY = 'FY';
                case 5; TVY = 'EX';
                case 6; TVY = 'EY';
                case 7; TVY = 'SX';
                case 8; TVY = 'SY';
            end %endswitch
            IMIF = strcat(ADAD,'.inf.mat'); % nombre archivo .inf.mat
            if ICUR==1
                FIDE = fopen(IMIF,'w'); % abrir archivo primera vez
            else
                FIDE = fopen(IMIF,'a'); % abrir archivo y editar
            end
            TMP = strcat('CURVA',num2str(ICUR),':',TVY,'(PUNTO',...
                num2str(INUY),')','VS.',TVX,'(PUNTO',num2str(INUX),')');
            % estructura renglón de escritura
            fprintf(FIDE,TMP); % escribir renglón para curva ICUR
            fprintf(FIDE,' \n'); % cambio renglón
            fclose(FIDE); % cierre de archivo .inf.mat
        end %endfor ICUR

        % Impresión de curvas
        for ICUR=1:NCUR
            IMGR = strcat(ADAD,'.cur0',num2str(ICUR),'.mat'); % nombre archivo
            VXY = CXY(:,ICUR*2-1:ICUR*2); % tabla de elaboración de curva
            save((IMGR),'VXY','-ascii','-tabs'); % Guardado
        end %endfor
    end %endif

    % Gráfica de la primera curva
    if norm(DOM)==0
        if IPSE==1; clf; end %endif
        VAX = CXY(1:IPSE,1); VAY = CXY(1:IPSE,2);
        plot (VAX,VAY,'-o','color','red')
        hold on
        grid on
        refreshdata
        drawnow
    end %endif
end %endfunction