% convertir formato B en formato A para los desplazamientos conocidos 
% y fuerzas puntuales
function [VUA] = ORVEBA(VUB,TLEN,NGLN,TASK)
  % entrada:  VUB():  tabla de fuerzas puntuales aplicadas en formato B
  %           TLEN:   tipo de lectura de datos y escritura de resultados
  %           NGLN:   número de grados de libertad por nudo
  %           TASK:   tarea: 0: desplaz conocidos, 1: fuerzas puntuales
  % salida:   VUA():  tabla de fuerzas puntuales aplicadas en formato A
  switch TASK
    case 0 % desplazamientos conocidos
    [VUA] = ORDEBA(VUB,TLEN,NGLN);  
    case 1 % cargas puntuales
    [VUA] = ORFUBA(VUB,TLEN,NGLN);
  end % endswitch TASK

end

% -----------------------------------------------------------------------
% convertir formato B en formato A para los desplazamientos conocidos
function [UCA] = ORDEBA(UCB,TLEN,NGLN)
  % entrada:  UCB():  tabla de desplazamientos conocidos en formato B
  %           TLEN:   tipo de lectura de datos y escritura de resultados
  %           NGLN:   número de grados de libertad por nudo
  % salida:   UCA():  tabla de desplazamientos conocidos en formato A

  if TLEN>9 % convertir formato generado por LEGMSH: Formato B
    % ordenar por la primera columna
    TEM = sortrows(UCB,1); UCB=TEM;
    % convertir de formato
    FUCB=size(UCB,1); % número de filas UCO en formato B
    MUCB=NGLN; % máximo número de componentes de desplazamientos
    UCA=zeros(1,2*MUCB+1); % tamaño inicial
    IUCA=1;
    for IUCB=1:FUCB
      UCA(IUCA,1)=UCB(IUCB,1); % id nudo
      if UCB(IUCB,2)>0
        UCA(IUCA,UCB(IUCB,2)+1)=1; % indicador de desplazamiento conocido
        UCA(IUCA,UCB(IUCB,2)+MUCB+1)=UCB(IUCB,3); % valor desplazamiento en un gl
      end % endif
      if IUCB<FUCB && UCB(IUCB,1)~=UCB(IUCB+1,1)
        IUCA=IUCA+1;
      end % endif
    end % endfor IFUB
    TEM = sortrows(UCA,1); UCA=TEM; % ordenar
  else % conservar formato generado por GiD o escrito direc en .m: Formato A
    % conservar el formato
    UCA=UCB;
  end % endif
  
end

% ----------------------------------------------------------------------
% convertir formato B en formato A para las cargas puntuales
function [FUA] = ORFUBA(FUB,TLEN,NGLN)
  % entrada:  FUB():  tabla de fuerzas puntuales aplicadas en formato B
  %           TLEN:   tipo de lectura de datos y escritura de resultados
  %           NGLN:   número de grados de libertad por nudo
  % salida:   FUA():  tabla de fuerzas puntuales aplicadas en formato A

  if TLEN>9 % convertir formato generado por LEGMSH: Formato B
    % convertir de formato
    FFUB=size(FUB,1); % número de filas del FUN en formato B
    MFUB=NGLN; % máximo número de componentes de fuerzas
    FUA=zeros(1,MFUB+1); % tamaño inicial
    IFUA=0;
    for IFUB=1:FFUB
      IFUA=IFUA+1;
      FUA(IFUA,1)=FUB(IFUB,1); % id nudo
      FUA(IFUA,FUB(IFUB,2)+1)=FUB(IFUB,3); % valor fuerza en un gl
    end % endfor IFUB
  else % conservar formato generado por GiD o escrito direc en .m: Formato A
    % conservar el formato
    FUA=FUB;
  end % endif
end