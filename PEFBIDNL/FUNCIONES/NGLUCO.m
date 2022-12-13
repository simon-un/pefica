% Su primera tarea es crear tabla o matriz de grados de libertad por nudo
% a partir de la tabla de desplazamientos conocidos de algunos nudos.
% Su segunda tarea es crear el subvector de desplazamientos conocidos.
% ----------------------------------------------------------------------------
% Cuado el formato de UTC() es tipo A:
% UCT = [ INUD DCUX DCUY VAUX VAUY ]
%       INUD: identificador del nudo con desplazamiento conocido
%       DCUX: Indicador del desplazamiento en x. Vale 0:desconocido 1:conocido
%       DCUY: Indicador del desplazamiento en y. Vale 0:desconocido 1:conocido
%       VAUX: valor del desplazamiento conocido en x
%       VAUY: valor del desplazamiento conocido en y
% VAUX no será leída si el desplazamiento es desconocido, es decir DCUX=0,
% VAUY no será leída si el desplazamiento es desconocido, es decir DCUY=0.
% 
function [MGL,UBB,NGLN,NGLC] = NGLUCO(UTC,NNUD)
  % entrada:  UTC():  tabla de desplazamientos conocidos en algunos nudos
  %           NNUD:   número de nudos de la malla
  % salida:   MGL():  tabla de grados de libertad por nudo
  %           UBB():  subvector de desplazamientos conocidos
  %           NGLN:   número de GL por nudo
  %           NGLC:   número de GL conocidos
  
%------------------------------------------------------------------------------

  % La varibale NGLN, par problemas bidimensionales, siempre resultará ser 2,
  % puesto que la matriz de desplazamientos conocidos UTC() en formato A
  % es definida por nostros como un arreglo de 5 columnas.
  
  % La matriz de grados de libertad MGL() se define con dimensiones NNUD(valor 
  % extraído directamente del archivo de entrada de datos) x NGLN (2, para 
  % problemas bidimensionales).

  [FUTC,CUTC] = size(UTC);  % identificar número de nudos y 2 veces GL por nudo
  NGLN = (CUTC-1)/2; % número de GL por nudo
  NGLT = NNUD*NGLN; % número total de GL
  MGL = zeros(NNUD,NGLN,'int64'); % definición de tamaño y tipo para MGL()
  TEM = zeros(NGLT,1); % definir vector valor despl conoc y desconoc como 0
%------------------------------------------------------------------------------ 
 
  % primera tarea: crear tabla con numeración de GL conocidos y 
  % crear de desplazamientos conocidos
  
  % Para cada nudo con desplazamiento conocido (contador IUTC) y, a su vez, para
  % cada grado de libertad  por nudo (contador JNGL) se verifica que el 
  % indicador de desplazamiento conocido (UTC(IUTC,2 ó 3)) sea igual 1. 
  
  % Dentro del ciclo, se almacena en la matriz de grados de libertad MGL(), para 
  % cada nudo con desplazamiento conocido INUD y cada grado de libertad JNGL, el
  % valor NNUD*NGLN-COGL que representa una numeración de grados de libertad 
  % conocidos empezando desde el último de los grados de libertad totales
  % NGLT.
  
     % MGL(INUD,1): Número del GL asociado al desplazamiento en X para INUD
     % MGL(INUD,2): Número del GL asociado al desplazamiento en Y para INUD
  
  % Se almacena, para cada grado de libertad por nudo JGLN, el valor del despl
  % conodido asociado dentro del subvector de despl conocidos TEM() en la 
  % posición del GL definido a partir de la numeración hacia atrás.
  
  COGL = -1; % NNUD * NGLN - COGL: contador de GL conocidos
  for IUTC = 1:FUTC % ciclo por lista de nudos con desplazam conocido
    for JGLN = 1:NGLN % ciclo por GLs por nudo
      if UTC(IUTC,JGLN+1)==1 % desplazamiento conocido
        INUD = UTC(IUTC,1); % identificador del nudo
        if MGL(INUD, JGLN) == 0
          COGL = COGL + 1; % descuenta GL conocidos
          % crear tabla con numeración de GL conocidos
          MGL(INUD, JGLN) = NNUD * NGLN - COGL; % número del GL del desp conoc
          % crear subvector de desplazamientos conocidos
          TEM(MGL(INUD, JGLN),1) = UTC(IUTC,JGLN+NGLN+1); % valor despl conocido
%------------------------------------------------------------------------------           
  % Si se almacena más de un desplazamiento conocido para el JGLN, se presenta 
  % un mensaje de error.
       else
          fprintf('\n');
          TEXT = ...
          strcat('NGLUCO: condicion de borde impuesta dos veces al grado de',...
                 ' libertad %io del nudo %g.',...
                 '\n         Revisar los datos de entrada.');  
          error(TEXT,JGLN,INUD);
        end % endif
      end % endif
    end % endfor JGLN
  end % endfor IUTC
%------------------------------------------------------------------------------  
  % Se le suma 1 al valor final del contador de grados de libertad COGL porque
  % para poder asignar la numeración inversa de GL conocidos, la primera
  % iteración del ciclo usaba COGL=0 en vez de COGL=1.
  
  % Se extraen del vector TEM() las filas correspondientes a los grados de 
  % libertad conocidos, estos se almacenan dentro del subvector  de depl
  % conocidos UBB(). 
   
  NGLC = COGL + 1; % número de GL conocidos
  NGLD = NGLT - NGLC; % número de GL desconocidos
  UBB = TEM(NGLD+1:NGLT,1); % crear subvector desplazamientos conocidos
%------------------------------------------------------------------------------  
  % segunda tarea: numeración de GL desconocidos
  
  % Se revisa para cada nudo INUD y para cada grado de libertad JNGL si ya se
  % ha asignado un identificador de GL, de no ser así se almacena un 
  % identificador de grado de libertad desconocido que irá desde 1 hasta NGLD.
  DEGL = 0; % contador de GL desconocidos
  for INUD = 1:NNUD % ciclo por nudo
    for JGLN = 1:NGLN % ciclo por GL
      if MGL(INUD,JGLN) == 0
        DEGL = DEGL + 1; % contador del GL desconocidos
        MGL(INUD,JGLN) = DEGL;
      end % endif
    end % endfor IGLN
  end % endfor INUD

end

% ----------------------------------------------------------------------------
% Esta rutina es una copia de seguridad si se desea internamente
% leer en formato B
% ----------------------------------------------------------------------------
% Cuando UTC() tiene formato tipo B:
% UTC = [ INUD IDES VALD]
%         INUD: identificador del nudo, 
%         IDES: identificador de la componente de desplazamiento: 
%               1: primer GL despl. en x,
%               2: segundo GL despl. en y
%               3: tercer GL despl. en z.
%         VALD: valor del desplazamiento conocido
% 
function [MGL,UBB,NGLN,NGLC] = NGLUCB(UTC,NNUD,TIPR)
  % entrada:  UTC():  tabla de desplazamientos conocidos en algunos nudos
  %           NNUD:   número de nudos de la malla
  %           TIPR:   tipo de problema
  % salida:   MGL():  tabla de grados de libertad por nudo
  %           UBB():  subvector de desplazamientos conocidos
  %           NGLN:   número de GL por nudo
  %           NGLC:   número de GL conocidos
  
  % número de grados de libertad por nudo
  if TIPR==20||TIPR==21; NGLN=2; end;  % problema bidimensional
  if TIPR==30;           NGLN=3; end;  % problema tridimensional
  
  NGLT = NNUD*NGLN; % número total de GL
  MGL = zeros(NNUD,NGLN,'int64'); % definición de tamaño y tipo para MGL()
  TEM = zeros(NGLT,1); % definir vector valor despl conoc y desconoc como 0
  [FUTC,CUTC] = size(UTC);  % identificar número de nudos y 2 veces GL por nudo
  
  % primera tarea: crear tabla con numeración de GL conocidos y 
  % crear de desplazamientos conocidos
  COGL = -1; % NNUD * NGLN - COGL: contador de GL conocidos
  for IUTC = 1:FUTC % ciclo por lista de nudos con desplazam conocido
    INUD = UTC(IUTC,1); % identificador del nudo con desplazamiento conocido
    IDES = UTC(IUTC,2); % identificador del grado de libertad con desplaz conoc
    VALD = UTC(IUTC,3); % valor del desplazamiento conocido
    % control de error
    if INUD>NNUD; error('NGLUCO: id del nudo incorrecto.'); end;
    if (IDES<1)||(IDES>NGLN); error('NGLUCO: id del GL incorrecto.'); end;
    if MGL(INUD, IDES) == 0
      COGL = COGL + 1; % descuenta GL conocidos
      % crear tabla con numeración de GL conocidos
      MGL(INUD, IDES) = NNUD * NGLN - COGL; % número del GL del despL conoc
      % crear subvector de desplazamientos conocidos
      TEM(MGL(INUD, IDES),1) = VALD; % valor despl conocido
    else
      fprintf('\n');
      TEXT = ...
      strcat('NGLUCO: condicion de borde impuesta dos veces al grado de',...
             ' libertad %io del nudo %g.',...
             '\n         Revisar los datos de entrada.');  
      error(TEXT,IDES,INUD);
    end % endif
  end % endfor IUTC
  NGLC = COGL + 1; % número de GL conocidos
  NGLD = NGLT - NGLC; % número de GL desconocidos
  UBB = TEM(NGLD+1:NGLT,1); % crear subvector desplazamientos conocidos

  % segunda tarea: numeración de GL desconocidos
  DEGL = 0; % contador de GL desconocidos
  for INUD = 1:NNUD % ciclo por nudo
    for JGLN = 1:NGLN % ciclo por GL
      if MGL(INUD,JGLN) == 0
        DEGL = DEGL + 1; % contador del GL desconocidos
        MGL(INUD,JGLN) = DEGL;
      end % endif
    end % endfor IGLN
  end % endfor INUD
  
end