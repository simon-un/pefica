% imprimir en la ventana de comandos un texto que indica el comienzo
% de un grupo de instrucciones y medir el tiempo al final
%------------------------------------------------------------------------------
% Se entra dos veces en esta función:

%    - 1ra: al inicio de una etapa de cáclulo se introduce la línea: 
%      TINI = IMTIEM('operación',0);
%      con esta línea, la función ejecuta el primer condicional, por lo que se
%      imprime el nombre de la operación y se inicia el reloj que calculará el 
%      tiempo de ejecución. El tiempo transcurrido se guarda en la variable 
%      TINI de la rutina principal de PEFICA.

%    - 2da: al finalizar el cálculo, se introduce la línea:
%      TFIN = IMTIEM('',TINI);
%      Ya que la variable TINI tiene almacenado el tiempo transcurrido y es 
%      diferente de cero, la función considerará en el segundo condicional, 
%      allí se almacena el tiempo transcurrido en segundos en la variable TFIN,
%      finalmente, se imprime esta variable sin texto, con lo que en la ventana
%      de comandos se obtiene algo como:   "operación (10.0 seg)".
%------------------------------------------------------------------------------

function TFIN = IMTIEM(TEXT,TINI)
% entrada:  TEXT: texto que se desea imprimir
%           TINI: tiempo inicial del grupo de instrucciones
% salida:   TFIN: tiempo al comienzo del grupo de instrucciones si TINI=0
%                 tiempo al final del grupo de instrucciones si TINI<>0

  if TINI==0
    % imprimir texto del comienzo de un grupo de instrucciones
    % y medir el tiempo inicial
    fprintf(TEXT);
    TFIN = clock(); % tiempo al comienzo de las instrucciones
  else
    % imprimir el tiempo empleado entre el comienzo y el final 
    % de un grupo de instrucciones
    TFIN= etime(clock(),TINI); % tiempo al final de las instrucciones
    fprintf('%s (%6.2f seg.) \n',TEXT,TFIN);
  end % endswitch
  % alternativa de presentación paso a paso de mensajes que solo funciona
  % en octave
  %fflush(stdout);
  % presentación paso a paso de mensajes que funciona en matlab 
  %drawnow('expose');
  
end