% PRBOID archivo de datos de entrada:
% -------------------------------------------------------------------------
% DEFINICIÓN DE LECTURA DE DATOS Y TIPO DE PROBLEMA
% -------------------------------------------------------------------------
TLEN = 13;             % TLEN = 13: análisis controlado por desplazamientos
                       %        14: análisis controlado por fuerzas
% ------------------------------------------------------------------------- 
% DEFINICIÓN DEL NÚMERO DE PSEUDO-TIEMPOS E INCREMENTOS DE
% CARGA/DESPLAZAMIENTO
% ------------------------------------------------------------------------- 
LAM = [    0:     1:    27,... % Etapa 1
          27:   0.5:   100]';  % Etapa 2

            
                       % vector de factor de mayoración de cargas lambda
NPSE = size(LAM,1);    % número de pasos de carga
% ------------------------------------------------------------------------- 
% DEFINICIÓN DE PARÁMETROS PARA EL ESQUEMA DE SOLUCIÓN ITERATIVO
% -------------------------------------------------------------------------
TOLE = 1e-4;           % tolerancia para criterio de convergencia
NMIT = 25;             % número máximo de iteraciones
TIMC = 3;              % tipo de modelo constitutivo
                       %(1): End. isotrópico 
                       %(2): End. cinemático
                       %(3): End. combinado 
% ------------------------------------------------------------------------- 
% DEFINICIÓN DE PRESENTACIÓN DE RESULTADOS
% -------------------------------------------------------------------------
PRO = 2;              % PRO = 0: Presentación de resultados promedio en los 
                      %          nudos.
                      %       1: Presentación de resultados en el interior
                      %          de los elementos.
                      %       2: Presentación de resultados para varias
                      %          categorías de material.         