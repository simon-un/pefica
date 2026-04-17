
% Evaluación de un modelo constitutivo en elementos bidimensionales
function [DXY] = IMVONM(ELE,SRE,VIN,IPSE,NMIT,CAT,DOM,DXY,ADAD,ITER)

  %  ENTRADAS:
  %-----------------------------------------------------------------------------
  %  - [SIGY]: Límite de fluencia del material:
  %  - [AEND]: Variable interna de endurecimiento isotrópico
  %  - [HPPL]: Módulo plástico de endurecimiento isotrópico
  %  - [SEL]: Tabla de esfuerzos de prueba de los elementos:
  %           [IELE IGAU STE(3,1)' SPR(3,1)' STVM]
  %  - [VIE]: Tabla de variables internas de los elementos:
  %           [IELE IGAU AEND EPL(3,1)' BET(3,1)' HPPL]
  
  
  NDOM = size(DOM,1);
  
  for IDOM=1:NDOM
      % Extracción de estado de esfuerzos [SEN] y variables
      % internas del modelo constitutivo [VNN] en el nudo y
      % el vector de la categoría [CAE] correspondiente al
      % elemento.
      NUDO = DOM(IDOM,:);
      [TEM] = SRE(SRE(:, 2) == NUDO,:);
      [SEN] = TEM(1,:); CELE = SEN(1,1);
      [TEM] = VIN(VIN(:, 2) == NUDO,:);
      [VNN] = TEM(TEM(:,1)==CELE,:);
      [CAE] = CAT(ELE(CELE,1),:); % propiedades de la categ eleme IELE
      
      SIGY = CAE(1,9);               % Límite de fluencia del material
      AEND = VNN(:,3);               % Variable interna de end. isotrópico
      HPPL = VNN(:,10);              % Variable interna de end. isotrópico
      
      % Obtención de la elipse del dominio elástico de VM
      SPM = floor((SIGY+HPPL*AEND)*2/sqrt(3)); % Definición del valor límite para la construcción de la elipse
      SXP = linspace (0, SPM, 100); % Creación de la variable ind. positiva
      SYP = 1/2 * (SXP + sqrt(4*(SIGY+HPPL*AEND)^2 - 3*SXP.^2)); % Evaluación variable dependiente positiva
      SXN = linspace (0, SPM, 100); % Creación de la variable ind. negatica
      SYN = 1/2 * (SXN - sqrt(4*(SIGY+HPPL*AEND)^2 - 3*SXN.^2)); % Evaluación variable dependiente negativa
      
      % Cálculo de los esfuerzos principales
      SXY = SEN(1,3:5)'; % Extración del vector de estado de esfuerzos
      S1 = SXY(1,1) + SXY(2,1); % Pre-cálculo 1
      S2 = (SXY(1,1) - SXY(2,1)) ^ 2; % Pre-cálculo 2
      S3 = 4 * (SXY(3,1) ^ 2); % Pre-cálculo 3
      MPR(1, 1) = 0.5 * (S1 + sqrt(S2 + S3)); % Esfuerzo principal 1
      MPR(2, 1) = 0.5 * (S1 - sqrt(S2 + S3)); % Esfuerzo principal 2
      
      % Cáclulo de las componentes principales del esfuerzo de retroceso
      BXY = VNN(1,7:9)'; % Extración del vector de esfuerzos de retroceso
      B1 = BXY(1,1) + BXY(2,1); % Pre-cálculo 1
      B2 = (BXY(1,1) - BXY(2,1)) ^ 2; % Pre-cálculo 2
      B3 = 4 * (BXY(3,1) ^ 2); % Pre-cálculo 3
      BPR(1, 1) = 0.5 * (B1 + sqrt(B2 + B3)); % Esfuerzo principal 1
      BPR(2, 1) = 0.5 * (B1 - sqrt(B2 + B3)); % Esfuerzo principal 2
      
      % Ordenamiento de los esfuerzos principales
      SPR2 = MPR(2, 1);
      SPR1 = MPR(1, 1);
      
      % Estructura de la gráfica de la elipse
      SP1 = BPR(1, 1) + [SXN,fliplr(SXP),-SXN,-fliplr(SXP)]'; % Unión de parte positiva y negativa var. ind.
      SP2 = BPR(2, 1) + [SYN,fliplr(SYP),-SYN,-fliplr(SYP)]'; % Unión de parte positiva y negativa var. dep.
      
      EXY = [SP1 SP2]; % tabla de esfuerzos para trazar la elipse de VM
      DXY(:,IPSE*2-1:IPSE*2) = [SPR1 SPR2;EXY]; % Almacenamiento por pseudotiempo
     
      
      if IDOM==1
          % Gráfica de la elipse y estado de esfuerzos
          if IPSE==1; clf; end %endif
          plot (SP1,SP2,SPR1,SPR2,"O")
          hold on
          grid on
          refreshdata
          drawnow
      end %endif
  end %endfor
  
  % Salida de gráficas (opcional)
  if ITER==NMIT
      IMVM = strcat(ADAD,'.dom0',num2str(IDOM),'.mat'); % nombre archivo
      save((IMVM),'DXY','-ascii','-tabs'); % Guardado
  end %endif
  
end