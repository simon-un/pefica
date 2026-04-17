% Evaluación de un modelo constitutivo de plasticidad en elementos
% bidimensionales en condición plana de esfuerzos
function [STE,VIE,DTA] = MODPLE(VI0,CAE,IELE,IGAU,EPE,ITEP,IPSE,LAM)
    
    %%  ENTRADAS:
    %-----------------------------------------------------------------------------
    %  - [VI0]: Tabla de variables internas de los elementos en (l-1):
    
    %       VI0(IELE,1) = IELE;      % número del elemento IELE
    %       VI0(IELE,2) = IGAU;      % indicador del nudo o punto de gauss
    %       VI0(IELE,3) = AEND;      % (VI 1): variable interna de endurecimiento a en (l-1)
    %       VI0(IELE,4) = EPL(1,1);  % (VI 2): deformación plástica en XX en (l-1)
    %       VI0(IELE,5) = EPL(2,1);  % (VI 2): deformación plástica en YY en (l-1)
    %       VI0(IELE,6) = EPL(3,1);  % (VI 2): deformación plástica en XY en (l-1)
    %       VI0(IELE,7) = BET(1,1);  % (VI 3): retroceso de esfuerzo en XX en (l-1)
    %       VI0(IELE,8) = BET(2,1);  % (VI 3): retroceso de esfuerzo en YY en (l-1)
    %       VI0(IELE,9) = BET(3,1);  % (VI 3): retroceso de esfuerzo en XY en (l-1)
    %       VI0(IELE,10) = HPPL;     % módulo plástico de endurecimiento isotrópico
    %       VI0(IELE,11) = VIPE;     % Variable interna de predicción elástica
    
    %  - [CAE]: Tabla de categorias del elemento
    %           [ EYOU POIS GAMM TESP TIPE NUEL PGAU EPLA SIGY TYMO ]
    
    %       CAE(1,1): Magnitud del módulo de Young EYOU
    %       CAE(1,2): Magnitud de la relación de Poisson POIS
    %       CAE(1,3): Magnitud del peso específico GAMM
    %       CAE(1,4): Magnitud del espesor TESP
    %       CAE(1,5): Tipo de elemento TIPE
    %       CAE(1,6): Número de nudos del elemento NUEL
    %       CAE(1,7): Número de puntos de Gauss del elemento PGAU
    %       ----------------------------------------------------------------------
    %       CAE(1,8): Módulo plástico del material EPLA
    %       CAE(1,9): Límite de fluencia del material SIGY
    %       CAE(1,10): Tipo de modelo constitutivo TYMO
    
    %  - IELE: ID del elemeto finito
    
    %  - IGAU: ID del punto de gauss
    
    %  - [EPE]: deformación de prueba en el tiempo (l) [EXX EYY EXY]
    %-----------------------------------------------------------------------------
    
    
    %%  SALIDAS:
    %-----------------------------------------------------------------------------
    %  - [STE]: Tabla de esfuerzos de prueba de los elementos:
    
    %       STE(:,1) = IELE;      % número del elemento IELE
    %       STE(:,2) = IGAU;      % indicador del nudo o punto de gauss
    %       STE(:,3) = STP(1,1);  % esfuerzo SXX
    %       STE(:,4) = STP(2,1);  % esfuerzo SYY
    %       STE(:,5) = STP(3,1);  % esfuerzo SXY
    %       STE(:,6) = SP1;       % esfuerzo principal mayor
    %       STE(:,7) = SP2;       % esfuerzo principal intermedio
    %       STE(:,8) = SP3;       % esfuerzo principal menor
    %       STE(:,9) = STVM;      % esfuerzo de Von Mises
    
    %  - [VIE]: Tabla de variables internas de los elementos en (l-1):
    
    %       VIE(IELE,1) = IELE;      % número del elemento IELE
    %       VIE(IELE,2) = IGAU;      % indicador del nudo o punto de gauss
    %       VIE(IELE,3) = AEND;      % (VI 1): variable interna de endurecimiento a en (i)
    %       VIE(IELE,4) = EPL(1,1);  % (VI 2): deformación plástica en XX en (i)
    %       VIE(IELE,5) = EPL(2,1);  % (VI 2): deformación plástica en YY en (i)
    %       VIE(IELE,6) = EPL(3,1);  % (VI 2): deformación plástica en XY en (i)
    %       VIE(IELE,7) = BET(1,1);  % (VI 3): retroceso de esfuerzo en XX en (i)
    %       VIE(IELE,8) = BET(2,1);  % (VI 3): retroceso de esfuerzo en YY en (i)
    %       VIE(IELE,9) = BET(3,1);  % (VI 3): retroceso de esfuerzo en XY en (i)
    %       VIE(IELE,10) = HPPL;     % módulo plástico de endurecimiento isotrópico
    
    %  - [DTA]: Matriz tangente
    %-----------------------------------------------------------------------------
        
    %% Seleción del modelo constitutivo de plasticidad a emplear
    TYMO = CAE(1,10); % Extracción del tipo de modelo contitutivo a considerar
    switch TYMO
        case 21 % modelo de plasticidad con endurecimiento isotrópico
            [STE,VIE,DTA] = ENDISO(VI0,CAE,IELE,IGAU,EPE,ITEP,IPSE,LAM);
        case 22 % modelo de plasticidad con endurecimiento cinemático
            [STE,VIE,DTA] = ENDCIN(VI0,CAE,IELE,IGAU,EPE,ITEP,IPSE,LAM);
        case 23 % modelo de plasticidad con endurecimiento isotrópico y cinemático
            [STE,VIE,DTA] = ENDCOM(VI0,CAE,IELE,IGAU,EPE,ITEP,IPSE,LAM);
        otherwise
            % pendiente
    end %endswitch
    
    %-----------------------------------------------------------------------------
    %%  1. Modelo de plasticidad con endurecimiento combinado
    %-----------------------------------------------------------------------------
    
    function [STE,VIE,DTA] = ENDCOM(VI0,CAE,IELE,IGAU,EPE,ITEP,IPSE,LAM)
        
        EYOU = CAE(1,1);               % Módulo de elasticidad
        EPLA = CAE(1,8);               % Módulo plástico del material
        POIS = CAE(1,2);               % Relación de poisson
        SIGY = CAE(1,9);               % Límite de fluencia del material
        GRIG = EYOU / (2 * (1+POIS));  % Módulo de rigidez
        HPPL = EPLA * 0.7; % módulo endurecimiento plástico isotrópico
        HKPL = EPLA * 0.3; % módulo de endurecimiento plástico cinemático
        
        % Extracción de variables internas de la iteración anterior (i-1)
        
        EPL = VI0(:,4:6)';          % Deformación plástica del paso anterior
        AEND = VI0(:,3);            % Variable interna de end. isotrópico
        BET = VI0(:,7:9)';          % Variable interna de end. cinemático
        VIPE = VI0(:,11);           % Variable interna de prección elástica
        
        % Matriz constitutiva elástica en condición plana de esfuerzos
        
        DEL(1,1) = EYOU/(1-POIS^2);
        DEL(1,2) = POIS*EYOU/(1-POIS^2);
        DEL(2,1) = DEL(1,2);
        DEL(2,2) = DEL(1,1);
        DEL(3,3) = 0.5*(1-POIS)*(EYOU/(1-POIS^2));
        
        % Cálculo de estado de esfuerzos y función de fluencia de prueba
        
        PTR = 1/3 * [2 -1 0;-1 2 0; 0 0 6]; % Matriz de transformación PTR de esfuerzo
        STR = DEL * (EPE-EPL); % vector de esfuerzos del elem. IELE en el punto IGAU
        ZTR = STR - BET; % Vector de esfuerzos equivalentes de prueba
        FTRL = sqrt(ZTR'*PTR*ZTR) - sqrt(2/3)*(SIGY+HPPL*AEND); % Función de fluencia de prueba
        
        % Variable interna de predicción de deformación elástica VIPE. 
        % La varibale define cuándo se deben calcular el estado de 
        % esfuerzos y la matriz tangente de manera elástica. Lo
        % anterior debe hacerse en los siguientes casos:
        
        %   Caso 1: el paso anterior no ha experimentado deformaciones
        %           plásticas.
        %   Caso 2: los dos pasos anteriores poseen el mismo nivel de
        %           deformación plástica.
        %   Caso 3: el valor absoluto del factor de mayoración de cargas o
        %           desplazamientos LAMB(ISPE) es menor que el
        %           correspondiente al pseudo-tiempo anterior LAMB(ISPE-1).
        % 
        %   VIPE = 0: No se requiere predicción elástica, porque no se
        %             cumple ninguno de los 3 casos.
        %          1: Se requiere predicción elástica, porque se cumple
        %             cualquiera de los tres casos.
        
        if size(LAM,1)==1 || (ITEP==1 && norm(EPL)==0 && AEND==0 && norm(BET)==0) % Caso 1
            VIPE = 1;
        elseif abs(LAM(IPSE)) < abs(LAM(IPSE-1)) && ITEP==1 % Caso 3
            VIPE = 1;            
        end %endif
        
        if FTRL<=0  || VIPE==1
            STE = STR;
            BET = BET + zeros(3,1);
            AEND = AEND + 0;
            EPL = EPL + zeros(3,1);
            DTA = DEL;
        else
            Z11 = ZTR(1,1);
            Z22 = ZTR(2,1);
            Z12 = ZTR(3,1);
            
            % Cálculo iterativo del multiplicador plástico DELG
            NMIT = 100;    % Número máximo de iteraciones  para el cálculo de DELG
            DELG = 0;      % Valor inicial de DELG para el método de Newton
            TOLE = 1E-5;   % Tolerancia para el criterio de convergencia
            
            for ITER=1:NMIT
                
                % Primer sumando de la función de fluencia al cuadrado
                FES2 = 1/2 * 1/3*(Z11+Z22)^2 / (1+(EYOU/(3*(1-POIS))+2/3*HKPL)*DELG)^2 + ...
                    (1/2*(Z11-Z22)^2 + 2*Z12^2) / (1 + (2*GRIG + 2/3*HKPL)*DELG)^2;
                
                % Primer sumando de la función de fluencia
                FES1 = sqrt(FES2);
                
                % Derivada respecto a DELG del primer sumando de la función de fluencia al
                % cuadrado
                DFE2 = -1/3*(Z11+Z22)^2 * (EYOU/(3*(1-POIS)) + 2/3*HKPL) / (1+(EYOU/(3*(1-POIS)) + 2/3*HKPL)*DELG)^3 - ...
                    ((Z11-Z22)^2 + 4*Z12^2) * (2*GRIG+2/3*HKPL) / (1 + (2*GRIG+2/3*HKPL)*DELG)^3;
                
                % Derivada respecto a DELG del primer sumando de la función de fluencia
                DFE1 = 1/2 * DFE2 / sqrt(FES2);
                
                % Segundo sumando de la función de fluencia al cuadrado
                RIS2 = 1/3* (SIGY + HPPL * (AEND + sqrt(2/3) * DELG * FES1))^2;
                
                % Derivada respecto a DELG del segundo sumando de la función de fluencia al
                % cuadrado
                DRI2 = 2/9*sqrt(6) * HPPL *(FES1+DELG*DFE1)*(SIGY+HPPL*AEND) + 4/9 * HPPL^2 * (DELG*FES2+DELG^2*FES1*DFE1);
                
                % Función de fluencia al cuadrado
                FLU2 = 1/2 * FES2 - RIS2;
                
                % Derivada de la función de fluencia al cuadrado
                DFL2 = 1/2 * DFE2 - DRI2;
                
                ERRO = abs(sqrt(FLU2)/SIGY);
                
                if ERRO<=TOLE
                    break
                else
                    if ITER==NMIT
                        warning('Se llegó al número máximo de iteraciones permitidas');
                        break
                    end %endif
                end %endif
                
                DELG = DELG - FLU2/DFL2; % Actualización de DELG para siguiente iteración
                
            end %endfor
            
            % Actualización de las variables en el pseudotiempo (l)
            MTA = (DEL^-1+DELG/(1+2/3*DELG*HKPL)*PTR)^-1; % Matriz elástica tangente algorítmica modificada
            ZEQ = 1 / (1 + 2/3*DELG*HKPL) * MTA * DEL^-1 * ZTR; % Estado de esfuerzos equivalentes ZEQ
            BET = BET + DELG * 2/3 * HKPL * ZEQ; % Vector de retroceso de esfuerzo debido a end. cinemático BET
            STE = ZEQ + BET; % Estado de esfuerzos STE
            FES1 = sqrt(ZEQ' * PTR * ZEQ);
            AEND = AEND + sqrt(2/3) * DELG * FES1; % Variable interna de end. isotrópico
            EPL = EPL + DELG * PTR * ZEQ;   % Vector de deformaciones plásticas
            %     E33 = -POIS/EYOU * (STE(1,1) + STE(2,1)) - (EPL(1,1) + EPL(2,1)); % Actualización de la deformación E33
            
            % Cálculo de la matriz consistente elastoplástica
            TET1 = 1+2/3*HKPL*DELG; % Primer término para el calculo de DTA
            KISO = SIGY + HPPL * AEND; % Endurecimiento isotrópico evaluado en (l)
            TET2 = 1-2/3*KISO*DELG; % Segundo término para el cálculo de DTA
            TEMP = 2/3 * TET1/TET2 * (KISO*TET1+HKPL*TET2)*ZEQ'*PTR*ZEQ;
            DTA = MTA - ( (MTA*PTR*ZEQ) * (MTA*PTR*ZEQ)' ) / ...
                (ZEQ'*PTR*MTA*PTR*ZEQ + TEMP); % Matriz consistente elastoplástica
            
        end %endif
        
        VIE = [IELE, IGAU, AEND, EPL', BET', HPPL, 0, 0, 0, 0];
        
        if norm(VIE(:,3:9))==norm(VI0(:,3:9)) && ITEP==1 % Caso 2
            VIE(:,11) = 1;
        else
            VIE(:,11) = 0;
        end %endif
        
    end %endfunction
    
    %-----------------------------------------------------------------------------
    %%  2. Modelo de plasticidad con endurecimiento cinemático
    %-----------------------------------------------------------------------------
    
    function [STE,VIE,DTA] = ENDCIN(VI0,CAE,IELE,IGAU,EPE,ITEP,IPSE,LAM)
        
        EYOU = CAE(1,1);               % Módulo de elasticidad
        EPLA = CAE(1,8);               % Módulo plástico del material
        POIS = CAE(1,2);               % Relación de poisson
        SIGY = CAE(1,9);               % Límite de fluencia del material
        GRIG = EYOU / (2 * (1+POIS));  % Módulo de rigidez
        HPPL = 0;                      % módulo endurecimiento plástico isotrópico
        HKPL = EPLA; % módulo de endurecimiento plástico cinemático
        
        % Extracción de variables internas de la iteración anterior (i-1)
        
        EPL = VI0(:,4:6)';          % Deformación plástica del paso anterior
        AEND = VI0(:,3);            % Variable interna de end. isotrópico
        BET = VI0(:,7:9)';          % Variable interna de end. cinemático
        VIPE = VI0(:,11);
        
        % Matriz constitutiva elástica en condición plana de esfuerzos
        
        DEL(1,1) = EYOU/(1-POIS^2);
        DEL(1,2) = POIS*EYOU/(1-POIS^2);
        DEL(2,1) = DEL(1,2);
        DEL(2,2) = DEL(1,1);
        DEL(3,3) = 0.5*(1-POIS)*(EYOU/(1-POIS^2));
        
        % Cálculo de estado de esfuerzos y función de fluencia de prueba
        
        PTR = 1/3 * [2 -1 0;-1 2 0; 0 0 6]; % Matriz de transformación PTR de esfuerzo
        STR = DEL * (EPE-EPL); % vector de esfuerzos del elem. IELE en el punto IGAU
        ZTR = STR - BET; % Vector de esfuerzos equivalentes de prueba
        FTRL = sqrt(ZTR'*PTR*ZTR) - sqrt(2/3)*(SIGY+HPPL*AEND); % Función de fluencia de prueba
        
        % Variable interna de predicción de deformación elástica VIPE. 
        % La varibale define cuándo se deben calcular el estado de 
        % esfuerzos y la matriz tangente de manera elástica. Lo
        % anterior debe hacerse en los siguientes casos:
        
        %   Caso 1: el paso anterior no ha experimentado deformaciones
        %           plásticas.
        %   Caso 2: los dos pasos anteriores poseen el mismo nivel de
        %           deformación plástica.
        %   Caso 3: el valor absoluto del factor de mayoración de cargas o
        %           desplazamientos LAMB(ISPE) es menor que el
        %           correspondiente al pseudo-tiempo anterior LAMB(ISPE-1).
        % 
        %   VIPE = 0: No se requiere predicción elástica, porque no se
        %             cumple ninguno de los 3 casos.
        %          1: Se requiere predicción elástica, porque se cumple
        %             cualquiera de los tres casos.
        
        if size(LAM,1)==1 || (ITEP==1 && norm(EPL)==0 && AEND==0 && norm(BET)==0) % Caso 1
            VIPE = 1;
        elseif abs(LAM(IPSE)) < abs(LAM(IPSE-1)) && ITEP==1 % Caso 3
            VIPE = 1;            
        end %endif
        
        if FTRL<=0  || VIPE==1
            STE = STR;
            BET = BET + zeros(3,1);
            AEND = AEND + 0;
            EPL = EPL + zeros(3,1);
            DTA = DEL;
            
        else
            
            Z11 = ZTR(1,1);
            Z22 = ZTR(2,1);
            Z12 = ZTR(3,1);
            
            % Cálculo iterativo del multiplicador plástico DELG
            
            NMIT = 100;    % Número máximo de iteraciones  para el cálculo de DELG
            DELG = 0;      % Valor inicial de DELG para el método de Newton
            TOLE = 1E-5;   % Tolerancia para el criterio de convergencia
            
            for ITER=1:NMIT
                
                % Primer sumando de la función de fluencia al cuadrado
                FES2 = 1/2 * 1/3*(Z11+Z22)^2 / (1+(EYOU/(3*(1-POIS))+2/3*HKPL)*DELG)^2 + ...
                    (1/2*(Z11-Z22)^2 + 2*Z12^2) / (1 + (2*GRIG + 2/3*HKPL)*DELG)^2;
                
                % Primer sumando de la función de fluencia
                FES1 = sqrt(FES2);
                
                % Derivada respecto a DELG del primer sumando de la función de fluencia al
                % cuadrado
                DFE2 = -1/3*(Z11+Z22)^2 * (EYOU/(3*(1-POIS)) + 2/3*HKPL) / (1+(EYOU/(3*(1-POIS)) + 2/3*HKPL)*DELG)^3 - ...
                    ((Z11-Z22)^2 + 4*Z12^2) * (2*GRIG+2/3*HKPL) / (1 + (2*GRIG+2/3*HKPL)*DELG)^3;
                
                % Derivada respecto a DELG del primer sumando de la función de fluencia
                DFE1 = 1/2 * DFE2 / sqrt(FES2);
                
                % Segundo sumando de la función de fluencia al cuadrado
                RIS2 = 1/3* (SIGY + HPPL * (AEND + sqrt(2/3) * DELG * FES1))^2;
                
                % Derivada respecto a DELG del segundo sumando de la función de fluencia al
                % cuadrado
                DRI2 = 2/9*sqrt(6) * HPPL *(FES1+DELG*DFE1)*(SIGY+HPPL*AEND) + 4/9 * HPPL^2 * (DELG*FES2+DELG^2*FES1*DFE1);
                
                % Función de fluencia al cuadrado
                FLU2 = 1/2 * FES2 - RIS2;
                
                % Derivada de la función de fluencia al cuadrado
                DFL2 = 1/2 * DFE2 - DRI2;
                
                ERRO = abs(sqrt(FLU2)/SIGY);
                
                if ERRO<=TOLE
                    break
                else
                    if ITER==NMIT
                        warning('Se llegó al número máximo de iteraciones permitidas');
                        break
                    end %endif
                end %endif
                
                DELG = DELG - FLU2/DFL2; % Actualización de DELG para siguiente iteración
                
            end %endfor
            
            % Actualización de las variables en el pseudotiempo (l)
            
            MTA = (DEL^-1+DELG/(1+2/3*DELG*HKPL)*PTR)^-1; % Matriz elástica tangente algorítmica modificada
            ZEQ = 1 / (1 + 2/3*DELG*HKPL) * MTA * DEL^-1 * ZTR; % Estado de esfuerzos equivalentes ZEQ
            BET = BET + DELG * 2/3 * HKPL * ZEQ; % Vector de retroceso de esfuerzo debido a end. cinemático BET
            STE = ZEQ + BET; % Estado de esfuerzos STE
            AEND = AEND + 0; % Variable interna de end. isotrópico
            EPL = EPL + DELG * PTR * ZEQ;   % Vector de deformaciones plásticas
            %     E33 = -POIS/EYOU * (STE(1,1) + STE(2,1)) - (EPL(1,1) + EPL(2,1)); % Actualización de la deformación E33
            
            % Cálculo de la matriz consistente elastoplástica
            
            TET1 = 1+2/3*HKPL*DELG; % Primer término para el calculo de DTA
            KISO = SIGY + HPPL * AEND; % Endurecimiento isotrópico evaluado en (l)
            TET2 = 1-2/3*KISO*DELG; % Segundo término para el cálculo de DTA
            TEMP = 2/3 * TET1/TET2 * (KISO*TET1+HKPL*TET2)*ZEQ'*PTR*ZEQ;
            DTA = MTA - ( (MTA*PTR*ZEQ) * (MTA*PTR*ZEQ)' ) / ...
                (ZEQ'*PTR*MTA*PTR*ZEQ + TEMP); % Matriz consistente elastoplástica
            
        end %endif
        
        VIE = [IELE, IGAU, AEND, EPL', BET', HPPL, 0, 0, 0, 0];
        
        if norm(VIE(:,3:9))==norm(VI0(:,3:9)) && ITEP==1 % Caso 2
            VIE(:,11) = 1;
        else
            VIE(:,11) = 0;
        end %endif
        
    end %endfunction
    
    %-----------------------------------------------------------------------------
    %%  3. Modelo de plasticidad con endurecimiento isotrópico
    %-----------------------------------------------------------------------------
    
    function [STE,VIE,DTA] = ENDISO(VI0,CAE,IELE,IGAU,EPE,ITEP,IPSE,LAM)
        
        EYOU = CAE(1,1);               % Módulo de elasticidad
        EPLA = CAE(1,8);               % Módulo plástico del material
        POIS = CAE(1,2);               % Relación de poisson
        SIGY = CAE(1,9);               % Límite de fluencia del material
        GRIG = EYOU / (2 * (1+POIS));  % Módulo de rigidez
        HPPL = EPLA; % módulo endurecimiento plástico isotrópico
        HKPL = 0; % módulo de endurecimiento plástico cinemático
        
        % Extracción de variables internas de la iteración anterior (i-1)
        
        EPL = VI0(:,4:6)';          % Deformación plástica del paso anterior
        AEND = VI0(:,3);            % Variable interna de end. isotrópico
        BET = VI0(:,7:9)';          % Variable interna de end. cinemático
        VIPE = VI0(:,11);
        
        % Matriz constitutiva elástica en condición plana de esfuerzos
        
        DEL(1,1) = EYOU/(1-POIS^2);
        DEL(1,2) = POIS*EYOU/(1-POIS^2);
        DEL(2,1) = DEL(1,2);
        DEL(2,2) = DEL(1,1);
        DEL(3,3) = 0.5*(1-POIS)*(EYOU/(1-POIS^2));
        
        % Cálculo de estado de esfuerzos y función de fluencia de prueba
        
        PTR = 1/3 * [2 -1 0;-1 2 0; 0 0 6]; % Matriz de transformación PTR de esfuerzo
        STR = DEL * (EPE-EPL); % vector de esfuerzos del elem. IELE en el punto IGAU
        ZTR = STR - BET; % Vector de esfuerzos equivalentes de prueba
        FTRL = sqrt(ZTR'*PTR*ZTR) - sqrt(2/3)*(SIGY+HPPL*AEND); % Función de fluencia de prueba
        
        % Variable interna de predicción de deformación elástica VIPE. 
        % La varibale define cuándo se deben calcular el estado de 
        % esfuerzos y la matriz tangente de manera elástica. Lo
        % anterior debe hacerse en los siguientes casos:
        
        %   Caso 1: el paso anterior no ha experimentado deformaciones
        %           plásticas.
        %   Caso 2: los dos pasos anteriores poseen el mismo nivel de
        %           deformación plástica.
        %   Caso 3: el valor absoluto del factor de mayoración de cargas o
        %           desplazamientos LAMB(ISPE) es menor que el
        %           correspondiente al pseudo-tiempo anterior LAMB(ISPE-1).
        % 
        %   VIPE = 0: No se requiere predicción elástica, porque no se
        %             cumple ninguno de los 3 casos.
        %          1: Se requiere predicción elástica, porque se cumple
        %             cualquiera de los tres casos.
        
        if size(LAM,1)==1 || (ITEP==1 && norm(EPL)==0 && AEND==0 && norm(BET)==0) % Caso 1
            VIPE = 1;
        elseif abs(LAM(IPSE)) < abs(LAM(IPSE-1)) && ITEP==1 % Caso 3
            VIPE = 1;            
        end %endif
        
        if FTRL<=0  || VIPE==1
            STE = STR;
            BET = BET + zeros(3,1);
            AEND = AEND + 0;
            EPL = EPL + zeros(3,1);
            DTA = DEL;
            
        else
            
            Z11 = ZTR(1,1);
            Z22 = ZTR(2,1);
            Z12 = ZTR(3,1);
            
            % Cálculo iterativo del multiplicador plástico DELG
            
            NMIT = 100;    % Número máximo de iteraciones  para el cálculo de DELG
            DELG = 0;      % Valor inicial de DELG para el método de Newton
            TOLE = 1E-5;   % Tolerancia para el criterio de convergencia
            
            for ITER=1:NMIT
                
                % Primer sumando de la función de fluencia al cuadrado
                FES2 = 1/2 * 1/3*(Z11+Z22)^2 / (1+(EYOU/(3*(1-POIS))+2/3*HKPL)*DELG)^2 + ...
                    (1/2*(Z11-Z22)^2 + 2*Z12^2) / (1 + (2*GRIG + 2/3*HKPL)*DELG)^2;
                
                % Primer sumando de la función de fluencia
                FES1 = sqrt(FES2);
                
                % Derivada respecto a DELG del primer sumando de la función de fluencia al
                % cuadrado
                DFE2 = -1/3*(Z11+Z22)^2 * (EYOU/(3*(1-POIS)) + 2/3*HKPL) / (1+(EYOU/(3*(1-POIS)) + 2/3*HKPL)*DELG)^3 - ...
                    ((Z11-Z22)^2 + 4*Z12^2) * (2*GRIG+2/3*HKPL) / (1 + (2*GRIG+2/3*HKPL)*DELG)^3;
                
                % Derivada respecto a DELG del primer sumando de la función de fluencia
                DFE1 = 1/2 * DFE2 / sqrt(FES2);
                
                % Segundo sumando de la función de fluencia al cuadrado
                RIS2 = 1/3* (SIGY + HPPL * (AEND + sqrt(2/3) * DELG * FES1))^2;
                
                % Derivada respecto a DELG del segundo sumando de la función de fluencia al
                % cuadrado
                DRI2 = 2/9*sqrt(6) * HPPL *(FES1+DELG*DFE1)*(SIGY+HPPL*AEND) + 4/9 * HPPL^2 * (DELG*FES2+DELG^2*FES1*DFE1);
                
                % Función de fluencia al cuadrado
                FLU2 = 1/2 * FES2 - RIS2;
                
                % Derivada de la función de fluencia al cuadrado
                DFL2 = 1/2 * DFE2 - DRI2;
                
                ERRO = abs(sqrt(FLU2)/SIGY);
                
                if ERRO<=TOLE
                    break
                else
                    if ITER==NMIT
                        warning('Se llegó al número máximo de iteraciones permitidas');
                        break
                    end %endif
                end %endif
                
                DELG = DELG - FLU2/DFL2; % Actualización de DELG para siguiente iteración
                
            end %endfor
            
            % Actualización de las variables en el pseudotiempo (l)
            
            MTA = (DEL^-1+DELG/(1+2/3*DELG*HKPL)*PTR)^-1; % Matriz elástica tangente algorítmica modificada
            ZEQ = 1 / (1 + 2/3*DELG*HKPL) * MTA * DEL^-1 * ZTR; % Estado de esfuerzos equivalentes ZEQ
            BET = BET + DELG * 2/3 * HKPL * ZEQ; % Vector de retroceso de esfuerzo debido a end. cinemático BET
            STE = ZEQ + zeros(3,1); % Estado de esfuerzos STE
            FES1 = sqrt(ZEQ' * PTR * ZEQ);
            AEND = AEND + sqrt(2/3) * DELG * FES1; % Variable interna de end. isotrópico
            EPL = EPL + DELG * PTR * ZEQ;   % Vector de deformaciones plásticas
            %     E33 = -POIS/EYOU * (STE(1,1) + STE(2,1)) - (EPL(1,1) + EPL(2,1)); % Actualización de la deformación E33
            
            % Cálculo de la matriz consistente elastoplástica
            
            TET1 = 1+2/3*HKPL*DELG; % Primer término para el calculo de DTA
            KISO = SIGY + HPPL * AEND; % Endurecimiento isotrópico evaluado en (l)
            TET2 = 1-2/3*KISO*DELG; % Segundo término para el cálculo de DTA
            TEMP = 2/3 * TET1/TET2 * (KISO*TET1+HKPL*TET2)*ZEQ'*PTR*ZEQ;
            DTA = MTA - ( (MTA*PTR*ZEQ) * (MTA*PTR*ZEQ)' ) / ...
                (ZEQ'*PTR*MTA*PTR*ZEQ + TEMP); % Matriz consistente elastoplástica
            
        end %endif
        
        VIE = [IELE, IGAU, AEND, EPL', BET', HPPL, 0, 0, 0, 0];
        
        if norm(VIE(:,3:9))==norm(VI0(:,3:9)) && ITEP==1 % Caso 2
            VIE(:,11) = 1;
        else
            VIE(:,11) = 0;
        end %endif
        
    end %endfunction
    
    
end %endfunction
