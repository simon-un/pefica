% PRBOID archivo de datos de entrada:
% ------------------------------------------------------------------------- 
% DEFINICIÓN DE LECTURA DE DATOS Y TIPO DE PROBLEMA
% -------------------------------------------------------------------------
TLEN = 14;             % TLEN = 13: análisis controlado por desplazamientos
                       %        14: análisis controlado por fuerzas
% ------------------------------------------------------------------------- 
% DEFINICIÓN DEL NÚMERO DE PSEUDO-TIEMPOS E INCREMENTOS DE
% CARGA/DESPLAZAMIENTO
% ------------------------------------------------------------------------- 
LAM = [   0:   5:    450,...  % Etapa 1
        454:   4:    480,...  % Etapa 2
        480:   2:    490,...  % Etapa 2
        450: -50:      0]';   % Etapa 3
                       % vector de factor de mayoración de cargas lambda
NPSE = size(LAM,1);    % número de pasos de carga
% ------------------------------------------------------------------------- 
% DEFINICIÓN DE PARÁMETROS PARA EL ESQUEMA DE SOLUCIÓN ITERATIVO
% -------------------------------------------------------------------------
TOLE = 5e-3;           % tolerancia para criterio de convergencia
NMIT = 50;             % número máximo de iteraciones
TIMC = 3;              % tipo de modelo constitutivo
                       %(1): End. isotrópico 
                       %(2): End. cinemático
                       %(3): End. combinado
% ------------------------------------------------------------------------- 
% DEFINICIÓN DE PRESENTACIÓN DE RESULTADOS
% -------------------------------------------------------------------------
PRO = 0;              % PRO = 0: Presentación de resultados promedio en los 
                      %          nudos.
                      %       1: Presentación de resultados en el interior
                      %          de los elementos.
                      %       2: Presentación de resultados para varias
                      %          categorías de material.
                       
                       