% tabla grados de libertad por elemento o matriz de incidencias
function [INC] = NGLELE(ELE,MGL)
  % entrada:  ELE(): tabla de categorias y conectividades de los elementos
  %           MGL(): tabla de GL por nudo
  % salida:   INC(): tabla de GL por elemento o matriz de incidencias
  
     % ELE(:,1): Categoría del elemento de superficie
     % ELE(:,2): Identificador del nodo 1 del elemento
     % ELE(:,3): Identificador del nodo 2 del elemento
     % ELE(:,4): Identificador del nodo 3 del elemento 
     % ELE(:,5): Identificador del nodo 4 del elemento (elemetos cuadrilaterales)
     
     % MGL(INUD,1): Número del GL asociado al desplazamiento en X para INUD
     % MGL(INUD,2): Número del GL asociado al desplazamiento en Y para INUD

  % -------------------------------------------------------------------------
  
  % Se crea la matriz de incidencias INC() con dimensiones NELExNGLE(NGLN*NNUE)
  
  [NELE,NNUE] = size(ELE);  % número de elementos y de nudos por elemento +1
  NNUE = NNUE-1; % número de nudos por elemento
  [NNUD,NGLN] = size(MGL);  % número de nudos y de GL por nudo
  
  NGLE = NGLN*NNUE; % número de GL por elemento
  INC = zeros(NELE,NGLE,'int64'); % definición de tamaño y tipo de matriz INC()
  
  % -------------------------------------------------------------------------
  
  % Se define el contador de incidencias IINC que recorre los elementos de la
  % malla, en cada elemento se considera uno a uno los nudos con el contador
  % JINC y, a su vez, el contador HINC recorre los grados de libertad por nudo.
  
  % dentro del ciclo se almacena el identidificador del GL asociado a cada nudo
  % de los elementos de la malla. Con lo que:

     % INC(:,1): ID del GL en X del nudo 1 del elemento.
     % INC(:,2): ID del GL en Y del nudo 1 del elemento.
     % INC(:,3): ID del GL en X del nudo 2 del elemento.    
     % INC(:,4): ID del GL en Y del nudo 2 del elemento.
     % INC(:,5): ID del GL en X del nudo 3 del elemento.
     % INC(:,6): ID del GL en Y del nudo 3 del elemento.
     % INC(:,7): ID del GL en X del nudo 4 del elemento. (0 en e. triangulares)  
     % INC(:,8): ID del GL en Y del nudo 4 del elemento. (0 en e. triangulares)      
     
  for IINC = 1:NELE
    for JINC = 1:NNUE
      for HINC = 1:NGLN
        SINC = (JINC-1)*NGLN + HINC;
        if ELE(IINC, JINC+1) == 0
          INC(IINC, SINC) = 0;
        else
          INC(IINC, SINC) = MGL(ELE(IINC, JINC+1), HINC);
        end % endif
      end % endfor HINC
    end % endfor JINC
  end % endfor IINC
  
end