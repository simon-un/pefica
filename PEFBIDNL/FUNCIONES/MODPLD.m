% Evaluación de un modelo constitutivo de plasticidad en elementos
% bidimensionales en condición plana de deformaciones
function [STE,VIE,DTA] = MODPLD(VI0,CAE,IELE,IGAU,EPE,ITEP,IPSE,LAM)
    
    %%  ENTRADAS:
    %-----------------------------------------------------------------------------
    %  - [VI0]: Tabla de variables internas de los elementos en (l-1):
    
    %       VI0(IELE,1) = IELE;      % número del elemento IELE
    %       VI0(IELE,2) = IGAU;      % indicador del nudo o punto de gauss
    %       VI0(IELE,3) = AEND;      % (VI 1): variable interna de endurecimiento a en (l-1)
    %       VI0(IELE,4) = EPL(1,1);  % (VI 2): deformación plástica en XX en (l-1)
    %       VI0(IELE,5) = EPL(2,1);  % (VI 2): deformación plástica en YY en (l-1)
    %       VI0(IELE,6) = EPL(3,1);  % (VI 2): deformación plástica en XY en (l-1)
    %       VI0(IELE,7) = EPL(4,1);  % (VI 2): deformación plástica en ZZ en (l-1)
    %       VI0(IELE,8) = BET(1,1);  % (VI 3): retroceso de esfuerzo en XX en (l-1)
    %       VI0(IELE,9) = BET(2,1);  % (VI 3): retroceso de esfuerzo en YY en (l-1)
    %       VI0(IELE,10) = BET(3,1); % (VI 3): retroceso de esfuerzo en XY en (l-1)
    %       VI0(IELE,11) = BET(4,1); % (VI 3): retroceso de esfuerzo en ZZ en (l-1)
    %       VI0(IELE,12) = HPPL;     % módulo plástico de endurecimiento isotrópico
    %       VI0(IELE,13) = VIPE;     % Variable interna de predicción elástica
    %       VI0(IELE,14) = STE(4,1); % esfuerzo SZZ en (l-1)
    
    %  - [CAE]: Tabla de categorias del elemento
    %           [ EYOU POIS GAMM TESP TIPE NUEL PGAU EPLA SIGY ]
    
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
    %  SALIDAS:
    %-----------------------------------------------------------------------------
    %  - [SEL]: Tabla de esfuerzos de prueba de los elementos:
    
    %       SEL(:,1) = IELE;      % número del elemento IELE
    %       SEL(:,2) = IGAU;      % indicador del nudo o punto de gauss
    %       SEL(:,3) = STE(1,1);  % esfuerzo SXX
    %       SEL(:,4) = STE(2,1);  % esfuerzo SYY
    %       SEL(:,5) = STE(3,1);  % esfuerzo SXY
    %       SEL(:,6) = SP1;       % esfuerzo principal mayor
    %       SEL(:,7) = SP2;       % esfuerzo principal intermedio
    %       SEL(:,8) = SP3;       % esfuerzo principal menor
    %       SEL(:,9) = STVM;      % esfuerzo de Von Mises
    
    %  - [VIE]: Tabla de variables internas de los elementos en (l-1):
    
    %       VIE(IELE,1) = IELE;      % número del elemento IELE
    %       VIE(IELE,2) = IGAU;      % indicador del nudo o punto de gauss
    %       VIE(IELE,3) = AEND;      % (VI 1): variable interna de endurecimiento a en (i)
    %       VIE(IELE,4) = EPL(1,1);  % (VI 2): deformación plástica en XX en (i)
    %       VIE(IELE,5) = EPL(2,1);  % (VI 2): deformación plástica en YY en (i)
    %       VIE(IELE,6) = EPL(3,1);  % (VI 2): deformación plástica en XY en (i)
    %       VI0(IELE,7) = EPL(4,1);  % (VI 2): deformación plástica en ZZ en (l-1)
    %       VIE(IELE,8) = BET(1,1);  % (VI 3): retroceso de esfuerzo en XX en (i)
    %       VIE(IELE,9) = BET(2,1);  % (VI 3): retroceso de esfuerzo en YY en (i)
    %       VIE(IELE,10) = BET(3,1); % (VI 3): retroceso de esfuerzo en XY en (i)
    %       VIE(IELE,11) = BET(4,1); % (VI 3): rettroceso de esfuerzo en ZZ en (l-1)
    %       VIE(IELE,12) = HPPL;     % módulo plástico de endurecimiento isotrópico
    %       VIE(IELE,13) = VIPE;     % Variable interna de predicción elástica
    %       VI0(IELE,14) = STE(4,1); % esfuerzo SZZ en (l)
    
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
        
        EYOU = CAE(1,1);                % Módulo de elasticidad
        EPLA = CAE(1,8);                % Módulo plástico del material
        POIS = CAE(1,2);                % Relación de poisson
        SIGY = CAE(1,9);                % Límite de fluencia del material
        GRIG = EYOU / (2 * (1+POIS));   % Módulo de rigidez
        KBLK = EYOU / (3 * (1-2*POIS)); % Módulo de compresibilidad
        HPPL = (EPLA/(1-(EPLA/EYOU))) * 0.7; % módulo endurecimiento plástico isotrópico
        HKPL = (EPLA/(1-(EPLA/EYOU))) * 0.3; % módulo de endurecimiento plástico cinemático
        
        % Extracción de variables internas de la iteración anterior (i-1)
        
        EPL = VI0(:,4:7)';       % Deformación plástica total del paso anterior
        AEND = VI0(:,3);            % Variable interna de end. isotrópico
        BET = VI0(:,8:11)';         % Variable interna de end. cinemático
        VIPE = VI0(:,13);           % Variable interna de prección elástica
        
        % Matriz constitutiva elástica en condición plana de esfuerzos
        
        DEL(1,1) = (1-POIS)*EYOU/((1+POIS)*(1-2*POIS));
        DEL(1,2) = POIS*EYOU/((1+POIS)*(1-2*POIS));
        DEL(2,1) = DEL(1,2);
        DEL(2,2) = DEL(1,1);
        DEL(3,3) = 0.5*(1-POIS)*(EYOU/(1-POIS^2));
        
        % Definición de componentes esférica y desviadora de la deformación
        % plástica
        
        EPL = [EPL(1)  EPL(2)  EPL(3)/2  EPL(4)]'; % Parte desviadora de las deformaciones plásticas
        
        % Definición de componente esférica de la deformación total
        
        EPR = [EPE;0]; EPR(3) = EPR(3)/2;
        EET = EPR - EPL; % Tensor de deformaciones elásticas totales
        TRE = (EET(1) + EET(2) + EET(4)) / 3;  % Traza del tensor de deformaciones elásticas totales
        EEV = [EET(1)-TRE  EET(2)-TRE  EET(3)  EET(4)-TRE]'; % Parte desviadora de las deformaciones elásticas totales
        EEE = [TRE TRE 0 TRE]'; % Parte esférica de las deformaciones elásticas totales
        
        % Cálculo de estado de esfuerzos y función de fluencia de prueba
        
        STD = 2 * GRIG * (EEV); % Parte desviadora del estado de esfuerzos
        ZTR = STD - BET; % Vector de esfuerzos equivalentes de prueba
        ETNR = sqrt(ZTR(1)^2 + ZTR(2)^2 + 2*ZTR(3)^2 + ZTR(4)^2);
        FTRL = ETNR - sqrt(2/3)*(SIGY+HPPL*AEND); % Función de fluencia de prueba
        
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
            BET = BET + zeros(4,1);
            AEND = AEND + 0;
            EPL = EPL + zeros(4,1);
            DTA = DEL;
            %  STE = DEL * (EPE(1:3)-EPL(1:3));
            STE = 3*KBLK * EEE + STD;
        else
            % Cálculo iterativo del multiplicador plástico DELG
            NMIT = 100;    % Número máximo de iteraciones  para el cálculo de DELG
            DELG = 0;      % Valor inicial de DELG para el método de Newton
            TOLE = 1E-8;   % Tolerancia para el criterio de convergencia
            
            for ITER=1:NMIT
                
                % Función de fluencia
                FLUE = -sqrt(2/3)*(SIGY + HPPL*(AEND + sqrt(2/3)*DELG)) + ETNR...
                    -(2*GRIG*DELG + 2/3*HKPL*DELG);
                
                % Derivada de la función de fluencia
                DFLU = -2*GRIG*(1 + (HPPL+HKPL) / (3*GRIG));
                ERRO = abs(FLUE/SIGY);
                if ERRO<=TOLE
                    break
                else
                    if ITER==NMIT
                        warning('Se llegó al número máximo de iteraciones permitidas');
                        break
                    end %endif
                end %endif ITER
                DELG = DELG - FLUE/DFLU; % Actualización de DELG para siguiente iteración
            end %endfor ITER
            
            % Actualización de las variables en el pseudotiempo (l)
            ZEQ = ZTR;
            NUN = ZEQ / ETNR; % Vector unitario normal
            AEND = AEND + sqrt(2/3)* DELG; % Variable interna de end. isotrópico
            BET = BET + 2/3 * HKPL * DELG * NUN; % Vector de retroceso de esfuerzo debido a end. cinemático BET
%             STE = [DEL * (EET(1:3));0] - 2*GRIG*DELG*NUN;
            STE = 3*KBLK * EEE + STD - 2*GRIG*DELG*NUN; % Estado de esfuerzos STE
            EPL = EPL + DELG * NUN; EPL(3) = 2*EPL(3); % Componente desviadora de la deformación plástica
            
            % Cálculo de la matriz consistente elastoplástica
            TET1 = 1-2*GRIG*DELG / norm(ZEQ); % Primer término para el calculo de DTA
            KISO = SIGY + HPPL * AEND; % Endurecimiento isotrópico evaluado en (l)
            TET2 = 1 / (1+(KISO+HKPL)/(3*GRIG)) - (1-TET1); % Segundo término para el cálculo de DTA
            TEM1 = [1 1 0 1;1 1 0 1; 0 0 0 0; 1 1 0 1];
            TEM2 = [1 0 0 0;0 1 0 0; 0 0 0.5 0;  0 0 0 1];
            DT1 = KBLK * TEM1;
            DT2 = 2 * GRIG * TET1 * (TEM2 - 1/3 *TEM1);
            DT3 = 2 * GRIG * TET2 * (NUN * NUN');
            DTA = DT1 + DT2 - DT3; % Matriz consistente elastoplástica
            DTA = DTA(1:3,1:3);
            
        end %endif
        
        VIE = [IELE, IGAU, AEND, EPL', BET', HPPL, 0, STE(4)];
        STE = STE(1:3);
        
        if norm(VIE(:,3:11))==norm(VI0(:,3:11)) && ITEP==1 % Caso 2
            VIE(:,13) = 1;
        else
            VIE(:,13) = 0;
        end %endif
        
    end %endfunction
    
    %-----------------------------------------------------------------------------
    %%  2. Modelo de plasticidad con endurecimiento cinemático
    %-----------------------------------------------------------------------------
    
    function [STE,VIE,DTA] = ENDCIN(VI0,CAE,IELE,IGAU,EPE,ITEP,IPSE,LAM)
        
        EYOU = CAE(1,1);                % Módulo de elasticidad
        EPLA = CAE(1,8);                % Módulo plástico del material
        POIS = CAE(1,2);                % Relación de poisson
        SIGY = CAE(1,9);                % Límite de fluencia del material
        GRIG = EYOU / (2 * (1+POIS));   % Módulo de rigidez
        KBLK = EYOU / (3 * (1-2*POIS)); % Módulo de compresibilidad
        HPPL = 0; % módulo endurecimiento plástico isotrópico
        HKPL = (EPLA/(1-(EPLA/EYOU))); % módulo de endurecimiento plástico cinemático
        
        % Extracción de variables internas de la iteración anterior (i-1)
        
        EPL = VI0(:,4:7)';       % Deformación plástica total del paso anterior
        AEND = VI0(:,3);            % Variable interna de end. isotrópico
        BET = VI0(:,8:11)';         % Variable interna de end. cinemático
        VIPE = VI0(:,13);           % Variable interna de prección elástica
        
        % Matriz constitutiva elástica en condición plana de esfuerzos
        
        DEL(1,1) = (1-POIS)*EYOU/((1+POIS)*(1-2*POIS));
        DEL(1,2) = POIS*EYOU/((1+POIS)*(1-2*POIS));
        DEL(2,1) = DEL(1,2);
        DEL(2,2) = DEL(1,1);
        DEL(3,3) = 0.5*(1-POIS)*(EYOU/(1-POIS^2));
        
        % Definición de componentes esférica y desviadora de la deformación
        % plástica
        
        EPL = [EPL(1)  EPL(2)  EPL(3)/2  EPL(4)]'; % Parte desviadora de las deformaciones plásticas
        
        % Definicón de componente esférica de la deformación total
        
        EPR = [EPE;0]; EPR(3) = EPR(3)/2;
        EET = EPR - EPL; % Tensor de deformaciones elásticas totales
        TRE = (EET(1) + EET(2) + EET(4)) / 3;  % Traza del tensor de deformaciones elásticas totales
        EEV = [EET(1)-TRE  EET(2)-TRE  EET(3)  EET(4)-TRE]'; % Parte desviadora de las deformaciones elásticas totales
        EEE = [TRE TRE 0 TRE]'; % Parte esférica de las deformaciones elásticas totales
        
        % Cálculo de estado de esfuerzos y función de fluencia de prueba
        
        STD = 2 * GRIG * (EEV); % Parte desviadora del estado de esfuerzos
        ZTR = STD - BET; % Vector de esfuerzos equivalentes de prueba
        ETNR = sqrt(ZTR(1)^2 + ZTR(2)^2 + 2*ZTR(3)^2 + ZTR(4)^2);
        FTRL = ETNR - sqrt(2/3)*(SIGY+HPPL*AEND); % Función de fluencia de prueba
        
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
            BET = BET + zeros(4,1);
            AEND = AEND + 0;
            EPL = EPL + zeros(4,1);
            DTA = DEL;
            %  STE = DEL * (EPE(1:3)-EPL(1:3));
            STE = 3*KBLK * EEE + STD;
        else
            % Cálculo iterativo del multiplicador plástico DELG
            NMIT = 100;    % Número máximo de iteraciones  para el cálculo de DELG
            DELG = 0;      % Valor inicial de DELG para el método de Newton
            TOLE = 1E-8;   % Tolerancia para el criterio de convergencia
            
            for ITER=1:NMIT
                
                % Función de fluencia
                FLUE = -sqrt(2/3)*(SIGY + HPPL*(AEND + sqrt(2/3)*DELG)) + ETNR...
                    -(2*GRIG*DELG + 2/3*HKPL*DELG);
                
                % Derivada de la función de fluencia
                DFLU = -2*GRIG*(1 + (HPPL+HKPL) / (3*GRIG));
                ERRO = abs(FLUE/SIGY);
                if ERRO<=TOLE
                    break
                else
                    if ITER==NMIT
                        warning('Se llegó al número máximo de iteraciones permitidas');
                        break
                    end %endif
                end %endif ITER
                DELG = DELG - FLUE/DFLU; % Actualización de DELG para siguiente iteración
            end %endfor ITER
            
            % Actualización de las variables en el pseudotiempo (l)
            ZEQ = ZTR;
            NUN = ZEQ / ETNR; % Vector unitario normal
            AEND = AEND + 0; % Variable interna de end. isotrópico
            BET = BET + 2/3 * HKPL * DELG * NUN; % Vector de retroceso de esfuerzo debido a end. cinemático BET
%             STE = [DEL * (EET(1:3));0] - 2*GRIG*DELG*NUN;
            STE = 3*KBLK * EEE + STD - 2*GRIG*DELG*NUN; % Estado de esfuerzos STE
            EPL = EPL + DELG * NUN; EPL(3) = 2*EPL(3); % Componente desviadora de la deformación plástica
            
            % Cálculo de la matriz consistente elastoplástica
            TET1 = 1-2*GRIG*DELG / norm(ZEQ); % Primer término para el calculo de DTA
            KISO = SIGY + HPPL * AEND; % Endurecimiento isotrópico evaluado en (l)
            TET2 = 1 / (1+(KISO+HKPL)/(3*GRIG)) - (1-TET1); % Segundo término para el cálculo de DTA
            TEM1 = [1 1 0 1;1 1 0 1; 0 0 0 0; 1 1 0 1];
            TEM2 = [1 0 0 0;0 1 0 0; 0 0 0.5 0;  0 0 0 1];
            DT1 = KBLK * TEM1;
            DT2 = 2 * GRIG * TET1 * (TEM2 - 1/3 *TEM1);
            DT3 = 2 * GRIG * TET2 * (NUN * NUN');
            DTA = DT1 + DT2 - DT3; % Matriz consistente elastoplástica
            DTA = DTA(1:3,1:3);
            
        end %endif
        
        VIE = [IELE, IGAU, AEND, EPL', BET', HPPL, 0, STE(4)];
        STE = STE(1:3);
        
        if norm(VIE(:,3:11))==norm(VI0(:,3:11)) && ITEP==1 % Caso 2
            VIE(:,13) = 1;
        else
            VIE(:,13) = 0;
        end %endif
        
    end %endfunction
    
    %-----------------------------------------------------------------------------
    %%  3. Modelo de plasticidad con endurecimiento isotrópico
    %-----------------------------------------------------------------------------
    
    function [STE,VIE,DTA] = ENDISO(VI0,CAE,IELE,IGAU,EPE,ITEP,IPSE,LAM)
        
        EYOU = CAE(1,1);                % Módulo de elasticidad
        EPLA = CAE(1,8);                % Módulo plástico del material
        POIS = CAE(1,2);                % Relación de poisson
        SIGY = CAE(1,9);                % Límite de fluencia del material
        GRIG = EYOU / (2 * (1+POIS));   % Módulo de rigidez
        KBLK = EYOU / (3 * (1-2*POIS)); % Módulo de compresibilidad
        HPPL = (EPLA/(1-(EPLA/EYOU))); % módulo endurecimiento plástico isotrópico
        HKPL = 0; % módulo de endurecimiento plástico cinemático
        
        % Extracción de variables internas de la iteración anterior (i-1)
        
        EPL = VI0(:,4:7)';       % Deformación plástica total del paso anterior
        AEND = VI0(:,3);            % Variable interna de end. isotrópico
        BET = VI0(:,8:11)';         % Variable interna de end. cinemático
        VIPE = VI0(:,13);           % Variable interna de prección elástica
        
        % Matriz constitutiva elástica en condición plana de esfuerzos
        
        DEL(1,1) = (1-POIS)*EYOU/((1+POIS)*(1-2*POIS));
        DEL(1,2) = POIS*EYOU/((1+POIS)*(1-2*POIS));
        DEL(2,1) = DEL(1,2);
        DEL(2,2) = DEL(1,1);
        DEL(3,3) = 0.5*(1-POIS)*(EYOU/(1-POIS^2));
        
        % Definición de componentes esférica y desviadora de la deformación
        % plástica
        
        EPL = [EPL(1)  EPL(2)  EPL(3)/2  EPL(4)]'; % Parte desviadora de las deformaciones plásticas
        
        % Definicón de componente esférica de la deformación total
        
        EPR = [EPE;0]; EPR(3) = EPR(3)/2;
        EET = EPR - EPL; % Tensor de deformaciones elásticas totales
        TRE = (EET(1) + EET(2) + EET(4)) / 3;  % Traza del tensor de deformaciones elásticas totales
        EEV = [EET(1)-TRE  EET(2)-TRE  EET(3)  EET(4)-TRE]'; % Parte desviadora de las deformaciones elásticas totales
        EEE = [TRE TRE 0 TRE]'; % Parte esférica de las deformaciones elásticas totales
        
        % Cálculo de estado de esfuerzos y función de fluencia de prueba
        
        STD = 2 * GRIG * (EEV); % Parte desviadora del estado de esfuerzos
        ZTR = STD - BET; % Vector de esfuerzos equivalentes de prueba
        ETNR = sqrt(ZTR(1)^2 + ZTR(2)^2 + 2*ZTR(3)^2 + ZTR(4)^2);
        FTRL = ETNR - sqrt(2/3)*(SIGY+HPPL*AEND); % Función de fluencia de prueba
        
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
        
        if size(LAM,1)==1 || (ITEP==1 && norm(EPL)==0 && AEND==0 && norm(BET)==0) || IPSE==1 % Caso 1
            VIPE = 1;
        elseif abs(LAM(IPSE)) < abs(LAM(IPSE-1)) && ITEP==1 % Caso 3
            VIPE = 1;
        end %endif
        
        if FTRL<=0  || VIPE==1
            BET = BET + zeros(4,1);
            AEND = AEND + 0;
            EPL = EPL + zeros(4,1);
            DTA = DEL;
            % STE = DEL * (EPE(1:3)-EPL(1:3));
            STE = 3*KBLK * EEE + STD;
        else
            % Cálculo iterativo del multiplicador plástico DELG
            NMIT = 100;    % Número máximo de iteraciones  para el cálculo de DELG
            DELG = 0;      % Valor inicial de DELG para el método de Newton
            TOLE = 1E-8;   % Tolerancia para el criterio de convergencia
            
            for ITER=1:NMIT
                
                % Función de fluencia
                FLUE = -sqrt(2/3)*(SIGY + HPPL*(AEND + sqrt(2/3)*DELG)) + ETNR...
                    -(2*GRIG*DELG + 2/3*HKPL*DELG);
                
                % Derivada de la función de fluencia
                DFLU = -2*GRIG*(1 + (HPPL+HKPL) / (3*GRIG));
                ERRO = abs(FLUE/SIGY);
                if ERRO<=TOLE
                    break
                else
                    if ITER==NMIT
                        warning('Se llegó al número máximo de iteraciones permitidas');
                        break
                    end %endif
                end %endif ITER
                DELG = DELG - FLUE/DFLU; % Actualización de DELG para siguiente iteración
            end %endfor ITER
            
            % Actualización de las variables en el pseudotiempo (l)
            ZEQ = ZTR;
            NUN = ZEQ / ETNR; % Vector unitario normal
            AEND = AEND + sqrt(2/3)* DELG; % Variable interna de end. isotrópico
            BET = BET + zeros(4,1); % Vector de retroceso de esfuerzo debido a end. cinemático BET
%             STE = [DEL * (EET(1:3));0] - 2*GRIG*DELG*NUN;
            STE = 3*KBLK * EEE + STD - 2*GRIG*DELG*NUN; % Estado de esfuerzos STE
            EPL = EPL + DELG * NUN; EPL(3) = 2*EPL(3); % Componente desviadora de la deformación plástica
            
            % Cálculo de la matriz consistente elastoplástica
            TET1 = 1-2*GRIG*DELG / norm(ZEQ); % Primer término para el calculo de DTA
            KISO = SIGY + HPPL * AEND; % Endurecimiento isotrópico evaluado en (l)
            TET2 = 1 / (1+(KISO+HKPL)/(3*GRIG)) - (1-TET1); % Segundo término para el cálculo de DTA
            TEM1 = [1 1 0 1;1 1 0 1; 0 0 0 0; 1 1 0 1];
            TEM2 = [1 0 0 0;0 1 0 0; 0 0 0.5 0;  0 0 0 1];
            DT1 = KBLK * TEM1;
            DT2 = 2 * GRIG * TET1 * (TEM2 - 1/3 *TEM1);
            DT3 = 2 * GRIG * TET2 * (NUN * NUN');
            DTA = DT1 + DT2 - DT3; % Matriz consistente elastoplástica
            DTA = DTA(1:3,1:3);
            
        end %endif
        
        VIE = [IELE, IGAU, AEND, EPL', BET', HPPL, 0, STE(4)];
        STE = STE(1:3);
        
        if norm(VIE(:,3:11))==norm(VI0(:,3:11)) && ITEP==1 % Caso 2
            VIE(:,13) = 1;
        else
            VIE(:,13) = 0;
        end %endif
        
    end %endfunction
    
end %endfunction
