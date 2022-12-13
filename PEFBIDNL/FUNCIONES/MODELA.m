% Evaluación de un modelo elástico (condición plana de esfuerzos)
function [STE,VIE,DTA] = MODELA(VI0,CAE,~,~,EPE,~,~,~,TIPR)
    
    %%  ENTRADAS:
    %-----------------------------------------------------------------------------
    %  - [VI0]: Tabla de variables internas de los elementos en (l-1): no
    %           se usa en este modelo, por lo que la salida es igual a la 
    %           entrada.
        
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
    
    %  - [VIE]: Tabla de variables internas de los elementos en (l-1):: no
    %           se usa en este modelo, por lo que la salida es igual a la 
    %           entrada.
    
    %  - [DTA]: Matriz constitutiva elástica
    %-----------------------------------------------------------------------------
    
    %-----------------------------------------------------------------------------
    %%  1. Modelo de elasticidad en condición plana de esfuerzos
    %-----------------------------------------------------------------------------
              
        % Matriz constitutiva elástica en condición plana de esfuerzos
        
        DTA = DELEME(CAE,TIPR);
              
        % Cálculo de estado de esfuerzos y función de fluencia de prueba
        
        STE = DTA * EPE; % vector de esfuerzos del elem. IELE en el punto IGAU
        VIE = VI0;
        
    end %endfunction