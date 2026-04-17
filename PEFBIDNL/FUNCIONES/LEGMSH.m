% leer archivo de datos .msh en GMSH
%---------------------------------------------------------------------
function [NNUD,NELE,NNUE,NGAU,NDIM,NCAT,TIPR,ENNU,IMPR,...
                XYZ,ELE,CAT,UCO,FUN,FDI,FHD,SUP,CUR,DOM] = LEGMSH(ADAD)
% notas importantes acerca de la generación de la malla en GMSH
% 1. Las condiciones de borde dadas por los desplazamientos conocidos
%    se definen como entidades físicas asociadas a puntos o líneas 
%    cuyo nombre utiliza el siguiente formato:
%    DISP UX=<valor ux> UY=<valor uy>
%    donde <valor ux> es el valor de la componente de desplazamiento en x,
%    donde <valor uy> es el valor de la componente de desplazamiento en y.
%    Si solo se conoce la componente de desplazamiento en x, el formato es:
%    DISP UX=<valor ux>
%    Si solo se conoce la componente de desplazamiento en y, el formato es:
%    DISP UY=<valor uy>
%
% 2. Las condiciones de borde dadas por fuerzas puntuales conocidas
%    se definen como entidades físicas asociadas a puntos o líneas
%    cuyo nombre utiliza el siguiente formato:
%    LOAD FX=<valor fx> FY=<valor fy>
%    donde <valor fx> es el valor de la componente de fuerza puntual en x,
%    donde <valor fy> es el valor de la componente de fuerza puntual en y.
%
% 3. Las condiciones de borde dadas por presiones conocidas (fuerza/área)
%    se definen como entidades físicas asociadas a líneas 
%    cuyo nombre utiliza los siguientes formatos.
%    3.1. En sistema coord. global:
%    PRES WX=<valor wx> WY=<valor wy>
%    donde <valor wx> es el valor de la componente de presión uniforme en x,
%    donde <valor wy> es el valor de la componente de presión uniforme en y.
%    3.2. En sistema coord. local:
%    PRES WN=<valor wn> WT=<valor wt>
%    donde <valor wn> es el valor de la presión uniforme normal a la línea
%    en dirección y-local,
%    donde <valor wt> es el valor de la presión uniforme tangente a la línea
%    en dirección x-local.
%    El eje x-local está definido en la dirección de la línea desde el punto 
%    inicial al final. El eje y-local sigue la regla de la mano derecha,
%    considerando a z-local saliendo de la pantalla.
%    3.3. Con presión hidráulica:
%    PRES GAWA=<gawa> HEWA=<hewa>
%    donde <gawa> es el peso específico del agua,
%    donde <hewa> es el nivel del agua con respecto al origen coord global.
%    El eje x-local está definido en la dirección de la línea desde el punto 
%    inicial al final. El eje y-local sigue la regla de la mano derecha,
%    considerando a z-local saliendo de la pantalla. El sentido de la presión
%    hidráulica está definido por el sentido del eje y-local de la línea.
%    Si la presión hidráulica tiene sentido contrario a y-local se asigna un 
%    signo negativo (-) al parámetro <gawa>.
%
% 4. Si varias líneas o puntos definen la misma condición de borde se produce
%    un error en el programa.
%
% 5. Las fuerzas distribuidas sobre líneas se sobrescriben cuando se definen
%    más de una vez. Las fuerzas puntuales sobre puntos se sobrescriben cuando 
%    se definen más de una vez. 

% 6. Las categorías (material y constantes reales) se definen como entidades 
%    físicas asociadas a superficies cuyo nombre utiliza el siguiente formato:
%    CATE EYOU=<eyou> POIS=<pois> GAMM=<gamm> TESP=<tesp> TIPR=<tipr>
%    donde <eyou> es el módulo de Young, <pois> es la relación de Poisson,
%    <gamm> es el peso específico (si se omite el parámetro GAMM=0),
%    <tesp> es el espesor, <tipr> es el tipo de problema (si se omite el 
%    parámetro <tipr>=20), <tipr>=20 si es condición plana de esfuerzos y 
%    <tipr>=21 si es condición plana de deformaciones.
%    
% 7. El archivo de la malla se debe guardar desde el menú File>Export>Save as... 
%    desplegar y escoger tipo de archivo: Mesh - Gmsh MSH (*.msh), despues en 
%    la ventana MSH Option, escoger en format: Version 2 ASCII. Finalmente
%    escribir el nombre del archivo con extensión .msh.
%
% 8. GMSH genera elementos finitos tipo punto (código 15) y 
%    elementos tipo barra (código 1) sobre las condiciones de borde tipo
%    desplazamientos, cargas puntuales y cargas distribuidas. Estos elementos
%    son eliminados en esta subrutina. Por lo tanto, la numeración de
%    los elementos de superficie (triangulares y cuadrilaterales) se modificará
%    de forma secuencial empezando en 1.
%
% 9. Esta subrutina modifica la numeración de las entidades físicas asociadas 
%    a las propiedades de material y constantes reales sobre los elementos
%    finitos de superficie (triangulares y cuadrilaterales) de forma secuencial
%    empezando en 1.
%---------------------------------------------------------------------
%               
% entrada: ADAD: nombre del archivo de datos sin extensión
%
% salida:  NNUD: número de nudos
%          NELE: número de elementos
%          NNUE: número máximo de nudos por elemento
%          NGAU: número máximo de puntos de Gauss en un elemento
%          NDIM: número de dimensiones del problema
%          NCAT: número de categorias de los elementos
%          TIPR: código de tipo de problema: 20=pl.esf, 21=pl.defor.
%          ENNU: tipo de evaluación de esfuerzos/deformaciones en el elemento
%          IMPR: tipo de impresión de los resultados
%
%          XYZ: tabla de coordenadas de los nudos
%               [ XNUD YNUD ]
%          ELE: tabla de categoría y conectividades de los elementos
%               [ ICAT NUDI NUDJ NUDK NUDL ]
%          CAT: tabla de categorias de los elementos
%               [ EYOU POIS GAMM TESP TIPE NUEL PGAU EPLA SIGY TYMO ]
%          UCO: tabla de desplazamientos conocidos
%               [ INUD DCUX DCUY VAUX VAUY ]: formato A (GiD) o
%               [ INUD IDES VALD ]: formato B (GMSH)
%          FUN: tabla de fuerzas aplicadas en los nudos de la malla
%               [ INUD FUNX FUNY ]
%          FDI: tabla de fuerzas uniformes distribuidas que se aplican 
%               en las caras de los elementos.
%               [ IELE NUDI NUDJ PREX PREY GLOC ]
%          SUP: tabla auxilar de identificador de la superficie asociada
%               al elemento finito (triangular o cuadrilateral)
%          CUR: tabla de curvas a elaborar
%               [ INUD(X) VARX INUD(Y) VARY ]
%          DOM: tabla de dominios elásticos a elaborar
%               [ IDOM ]
  
% valores por defecto de los parámetros generales para GMSH
NDIM = 2;    % dimensiones del problema
ENNU = 1;    % tipo de eval de esf/defor en el elemento =1: eval en los nudos
IMPR = 5;    % tipo de impresión de los resultados =5: en GMSH.
TIPR = 20;   % tipo de problema: 20:plano de esfuerzos, 21 plano de deformac.

%------------------------------------------------------------------------------
%  Se abre el archivo de la malla .msh, por medio de la función fopen, para
%  esto, se concatena el nombre del archivo de datos de entrada (ADAT) con la
%  extensión .msh por medio del comando strcat.

% lectura del archivo .msh
GMSH = strcat(ADAD,'.msh'); % nombre archivo GMSH de datos
FLID = fopen(GMSH); % abrir archivo .msh
%------------------------------------------------------------------------------
%  Se verifica que exista el archivo de entrada de datos del problema. Ya que,
%  de no existir, la función fopen almacena un -1 dentro de la variable FLID,
%  se puede interrumpir el proceso si esta condición se cumple.

if FLID==-1
    fprintf('\n');
    error('PEFICA. El archivo %s.msh no existe',ADAD);
end
%------------------------------------------------------------------------------
% leer línea de datos en el archivo

%  La función fgetl lee los caracteres de una línea del archivo de entrada.
%  Cada vez que se redefine la variable TLINE por medio de esta función,
%  se almacena una nueva línea del archivo de entrada de datos.
%  La función ischar(V ó F)evalúa si la línea es un arreglo de caracteres.
%  El primer condicional evalúa las primeras líneas del archivo .msh,
%  si su contenido es "$MeshFormat", y la versión empleada es la 2.2, no habrá
%  error.

TLINE = fgetl(FLID);
while ischar(TLINE)
    
    % bloque de formato
    if (strcmp(TLINE,'$MeshFormat')==1)
        TLINE = fgetl(FLID);
        VERSI=str2num(TLINE);
        if (VERSI(1,1)>2.2)
            fprintf('\n');
            error('Version mayor a 2.2 del archivo .msh de GMHS');
        end
    end % endif
    %------------------------------------------------------------------------------
    % bloque de entidades físicas
    
    %  Este condicional lee el bloque de entidades físicas del archivo de
    %  entrada. En primer lugar, extrae el número de entidades físicas definidas en
    %  el preproceso. Con este número de entidades define un ciclo haciendo uso
    %  del contador IFIS, dentro de este, evalúa cada tipo de entidad física con
    %  diferentes condicionales, descritos a continuación.
    
    %  ICOBO: Contador de entidades físicas de condicones de borde.
    %  ICATE: Contador de entidades físicas de tipo de categorías.
    
    if (strcmp(TLINE,'$PhysicalNames')==1)
        TLINE = fgetl(FLID); % leer siguiente línea
        NFIS=str2num(TLINE);
        NFIS=int16(NFIS);   % número de entidades físicas
        % inicialización
        ICOBO=0; ICATE=0;
        FCOBO=zeros(1,7); FCATE=zeros(1,11);
        for IFIS=1:NFIS
            TLINE = fgetl(FLID); % leer siguiente línea
            TFIS=strsplit(TLINE); % divide línea en palabras (en un vector fila)
            NCOM=size(TFIS,2); % retorna número de palabras (la segunda dimensión
            % es el número de columna)
            NCOM=NCOM-3; % número de componentes en la línea (resta las tres
            % palabras del inicio de la línea que no son componentes de la entidad
            % física).
            TEMP=char(TFIS{3}); % palabra clave etiqueta ent física (se extrae la
            % tercera palabra de la entidad física, ya que esta es la que define su
            % tipo ("DISP, "PRES, "CATE, etc..).
            %------------------------------------------------------------------------------
            % entidad física tipo desplazamiento
            
            %  Este condicional extrae las entidades físicas de tipo desplazamiento.
            %  Establece el contador de componentes de la entidad física ICOM, a partir de
            %  este entra en un ciclo que se repite hasta alcanzar el número de compoenntes
            %  NCOM. Se estructura el vector FCOBO (1x6) de condiciones de borde, en donde:
            
            % FCOBO(1,1): ID de la entidad física.
            % FCOBO(1,2): Tipo de condición de borde (DISP=10, LOAD=20, PRES=30 , CURV=40).
            % FCOBO(1,3): Indicador de componente en x (1)
            % FCOBO(1,4): Magnitud de componente en x.
            % FCOBO(1,5): Indicador de componente en y (2)
            % FCOBO(1,6): Magnitud de componente en y.
            
            %  Esta estructura solamente aplica en los casos de entidades físicas de
            %  desplazamiento y fuerza puntual. El caso de presión es diferente y se expone
            %  más adelante.
            
            % Por lo tanto, FCOBO almacenará las entidades físicas de condición de borde
            % en filas de 6 términos, cada fila describirá una entidad física.
            
            % El último condicional del ciclo identifica errores de asignación de
            % componentes.
            
            if (strcmp(TEMP(1:5),'"DISP')==1) %Se extraen los caracteres 1 a 5 de
                % la variable TEMP y se comparan con '"DISP'.
                ICOBO=ICOBO+1; % contador de entidades físicas de condic de borde
                FCOBO(ICOBO,1)=str2num(TFIS{2}); % id entidad física
                FCOBO(ICOBO,2)=10;  % tipo de condición de borde
                % 10=tipo desplazamiento
                for ICOM=1:NCOM
                    TEMR=strsplit(TFIS{3+ICOM},{'=','"'}); %Extrae el componente
                    % desplazamiento en un vector fila (1x2), donde el primer término
                    % es la dirección global del desplazamiento y el segundo es su valor
                    
                    % desplazamiento conocido en x
                    if (strcmp(TEMR{1},'UX')==1)
                        FCOBO(ICOBO,3)=1; % indicador desplazamiento en x
                        FCOBO(ICOBO,4)=str2num(TEMR{2}); % valor despl en x
                    end % endif
                    % desplazamiento conocido en y
                    if (strcmp(TEMR{1},'UY')==1)
                        FCOBO(ICOBO,5)=2; % indicador desplazamiento en y
                        FCOBO(ICOBO,6)=str2num(TEMR{2}); % valor despl en y
                    end % endif
                    % desplazamiento incorrecto
                    if((strcmp(TEMR{1},'UX')==0) && ...
                            (strcmp(TEMR{1},'UY')==0))
                        error ('Nombre incorrecto de desplazamiento en la entidad fisica DISP.');
                    end %endif
                end %endfor
            end %endif
            %------------------------------------------------------------------------------
            % entidad física tipo carga puntual
            
            %  Este condicional realiza el mismo procedimiento descrito en el caso de la
            %  entidad física tipo desplazamiento, solamente que en este caso el proceso
            %  se lleva a cabo para entidades de tipo carga puntual.
            
            if (strcmp(TEMP(1:5),'"LOAD')==1)
                ICOBO=ICOBO+1; % contador de entidades físicas de condic de borde
                FCOBO(ICOBO,1)=str2num(TFIS{2}); % id entidad física
                FCOBO(ICOBO,2)=20;  % tipo de condición de borde
                % 20=tipo carga puntual
                for ICOM=1:NCOM
                    TEMR=strsplit(TFIS{3+ICOM},{'=','"'});
                    % carga conocida en x
                    if (strcmp(TEMR{1},'FX')==1)
                        FCOBO(ICOBO,3)=1; % indicador carga en x
                        FCOBO(ICOBO,4)=str2num(TEMR{2}); % valor carga en x
                    end % endif
                    % carga conocida en y
                    if (strcmp(TEMR{1},'FY')==1)
                        FCOBO(ICOBO,5)=2; % indicador carga en y
                        FCOBO(ICOBO,6)=str2num(TEMR{2}); % valor carga en y
                    end % endif
                    % fuerza puntual incorrecta
                    if((strcmp(TEMR{1},'FX')==0) && ...
                            (strcmp(TEMR{1},'FY')==0))
                        error ('Nombre incorrecto de fuerza puntual en la entidad fisica LOAD.');
                    end %endif
                end %endfor
            end %endif
            %------------------------------------------------------------------------------
            % entidad física tipo carga distribuida o presión
            
            %  Este condicional realiza el mismo procedimiento descrito en el caso de la
            %  entidad física tipo desplazamiento, solamente que en este caso el proceso
            %  se lleva a cabo para entidades de tipo carga distribuida. Sin embargo,
            %  para este caso, además de las acciones en los ejes globales X y Y, se tienen
            %  en cuenta las presiones en coordenadas locales e hidrostáticas. Se tiene el
            %  siguiente esquema de almacenamiento:
            
            % FCOBO(1,1): ID de la entidad física.
            % FCOBO(1,2): Tipo de condición de borde (DISP=10, LOAD=20, PRES=30 , CURV=40).
            % FCOBO(1,3): Magnitud de presión en x (gamma agua en pres. hid)
            % FCOBO(1,4): Magnitud de presión en y.(H agua en pres. hid)
            % FCOBO(1,5): ID de tipo de presión (0=s.global 1=s.local 2=p. hidr.)
            % FCOBO(1,6): 0
            
            if (strcmp(TEMP(1:5),'"PRES')==1)
                ICOBO=ICOBO+1; % contador de entidades físicas de condic de borde
                FCOBO(ICOBO,1)=str2num(TFIS{2}); % id entidad física
                FCOBO(ICOBO,2)=30;  % tipo de condición de borde
                % 30=tipo carga distribuida
                SUMG=0;SUML=0;SUMW=0;
                for ICOM=1:NCOM
                    TEMR=strsplit(TFIS{3+ICOM},{'=','"'});
                    % carga conocida en x
                    if (strcmp(TEMR{1},'WX')==1)
                        FCOBO(ICOBO,3)=str2num(TEMR{2}); % valor
                        FCOBO(ICOBO,5)=0; % sist coord global
                        SUMG=1;
                    end % endif
                    % carga conocida en y
                    if (strcmp(TEMR{1},'WY')==1)
                        FCOBO(ICOBO,4)=str2num(TEMR{2}); % valor
                        FCOBO(ICOBO,5)=0; % sist coord global
                        SUMG=1;
                    end % endif
                    % carga conocida tangencial al lado
                    if (strcmp(TEMR{1},'WT')==1)
                        FCOBO(ICOBO,4)=str2num(TEMR{2}); % valor
                        FCOBO(ICOBO,5)=1; % sist coord local
                        SUML=1;
                    end % endif
                    % carga conocida normal al lado
                    if (strcmp(TEMR{1},'WN')==1)
                        FCOBO(ICOBO,3)=str2num(TEMR{2}); % valor
                        FCOBO(ICOBO,5)=1; % sist coord local
                        SUML=1;
                    end % endif
                    % peso especifíco del agua
                    if (strcmp(TEMR{1},'GAWA')==1)
                        FCOBO(ICOBO,3)=str2num(TEMR{2}); % valor
                        FCOBO(ICOBO,5)=2; % presión hidráulica
                        SUMW=1;
                    end % endif
                    % nivel del agua
                    if (strcmp(TEMR{1},'HEWA')==1)
                        FCOBO(ICOBO,4)=str2num(TEMR{2}); % valor
                        FCOBO(ICOBO,5)=2; % presión hidráulica
                        SUMW=1;
                    end % endif
                    % presión incorrecta
                    if((strcmp(TEMR{1},'WX')==0) && ...
                            (strcmp(TEMR{1},'WY')==0) && ...
                            (strcmp(TEMR{1},'WT')==0) && ...
                            (strcmp(TEMR{1},'WN')==0) && ...
                            (strcmp(TEMR{1},'GAWA')==0) && ...
                            (strcmp(TEMR{1},'HEWA')==0))
                        error ('Nombre incorrecto de presion en la entidad fisica PRES.');
                    end %endif
                end %endfor
                
                % control de errores
                
                %  Se verifica que una misma entidad física de cargas distribuidas no posea
                %  comonentes que se refieran a diferentes sistemas coordenados.
                
                SUMT=SUMG+SUML+SUMW;
                if (SUMT>1)
                    fprintf('\n');
                    error('Cargas distribuidas en sistemas coordenados diferentes')
                end %endif
            end %endif
            
            %------------------------------------------------------------------------------
            % entidad física tipo gráfica de curva
            
            %  Este condicional realiza el mismo procedimiento descrito en el caso de la
            %  entidad física tipo desplazamiento, solamente que en este caso el proceso
            %  se lleva a cabo para entidades de tipo curva. Sin embargo,
            %  para este caso, además de las acciones en los ejes globales X y Y, se tienen
            %  en cuenta las presiones en coordenadas locales e hidrostáticas. Se tiene el
            %  siguiente esquema de almacenamiento:
            
            % FCOBO(1,1): ID de la entidad física.
            % FCOBO(1,2): Tipo de condición de borde (DISP=10, LOAD=20, PRES=30 , CURV=40).
            % FCOBO(1,3): Indicador de componente en x (1)
            % FCOBO(1,4): ID de la variable en x (UX UY FX FY EX EY SX SY).
            % FCOBO(1,5): Indicador de componente en y (1)
            % FCOBO(1,6): ID de la variable en y (UX UY FX FY EX EY SX SY).
            % FCOBO(1,7): ID de la curva.
            
            if (strcmp(TEMP(1:5),'"CURV')==1)
                ICOBO=ICOBO+1; % contador de entidades físicas de condic de borde
                FCOBO(ICOBO,1)=str2num(TFIS{2}); % id entidad física
                FCOBO(ICOBO,2)=40;  % tipo de condición de borde
                % 40=tipo gráfica de curva
                for ICOM=1:NCOM
                    TEMR=strsplit(TFIS{3+ICOM},{'=','"'});
                    % identificador de la gráfica de curva
                    if (strcmp(TEMR{1},'ID')==1)
                        FCOBO(ICOBO,7) = str2num(TEMR{2}); % identificador de la curva
                    end % endif
                    % identificador del eje de la gráfica
                    if (strcmp(TEMR{1},'HO')==1)
                        FCOBO(ICOBO,3)=1; % ind de variable en el eje horizontal de curva
                        FCOBO(ICOBO,4) = CURVAL(TEMR{2}); % id de desplaz o reacción nodal
                    end % endif
                    % variable de la curva en el eje vertical sobre el punto
                    if (strcmp(TEMR{1},'VE')==1)
                        FCOBO(ICOBO,5)=2; % ind de variable en el eje vertical de curva
                        FCOBO(ICOBO,6) = CURVAL(TEMR{2}); % id de desplaz o reacción nodal
                    end % endif
                end %endfor
            end %endif
            
            %------------------------------------------------------------------------------
            % entidad física tipo gráfica de curva
            
            % FCOBO(1,1): ID de la entidad física.
            % FCOBO(1,2): Tipo de condición de borde (DISP=10, LOAD=20, PRES=30 , CURV=40).
            
            if (strcmp(TEMP(1:5),'"DOEL')==1)
                ICOBO=ICOBO+1; % contador de entidades físicas de condic de borde
                FCOBO(ICOBO,1)=str2num(TFIS{2}); % id entidad física
                FCOBO(ICOBO,2)=50;  % tipo de condición de borde
                % 50=tipo gráfica de dominio elástico
            end
            
            %------------------------------------------------------------------------------
            % entidad física tipo categoría (material y constantes reales)
            
            %  Este condicional extrae las entidades físicas de tipo categoría.
            %  Establece el contador de componentes de la entidad física ICOM, a partir de
            %  este entra en un ciclo que se repite hasta alcanzar el número de componentes
            %  NCOM. Se estructura el vector FCATE (1x10) de condiciones de borde, en donde:
            
            % FCATE(1,1) : ID de la categoría.
            % FCATE(1,2) : Magnitud del módulo de Young EYOU
            % FCATE(1,3) : Magnitud de la relación de Poisson POIS
            % FCATE(1,4) : Magnitud del rpeso específico GAMM
            % FCATE(1,5) : Magnitud del espesor TESP
            
            % FCATE(1,9) : Módulo plástico del material EPLA
            % FCATE(1,10): Límite de fluencia del material SIGY
            % FCATE(1,11): Tipo de modelo constitutivo TYMO
            
            %  Por lo tanto, FCATE almacenará las entidades físicas de categoría
            %  en filas de 11 términos, cada fila describirá una entidad física.
            
            %  El último condicional del ciclo identifica errores de asignación de
            %  categorías.
            
            %  Se almacena la variable TIPR como el tipo de problema a desarrollar
            %  21 (plano de deformaciones), 20(plano de esfuerzos).
            
            if (strcmp(TEMP(1:5),'"CATE')==1)
                ICATE=ICATE+1; % contador de entidades físicas de tipos de categorias
                FCATE(ICATE,1)=str2num(TFIS{2}); % id entidad física
                for ICOM=1:NCOM
                    TEMR=strsplit(TFIS{3+ICOM},{'=','"'});
                    % módulo de Young
                    if (strcmp(TEMR{1},'EYOU')==1)
                        FCATE(ICATE,2)=str2num(TEMR{2}); % valor
                    end % endif
                    % relación de Poisson
                    if (strcmp(TEMR{1},'POIS')==1)
                        FCATE(ICATE,3)=str2num(TEMR{2}); % valor
                    end % endif
                    % peso específico
                    if (strcmp(TEMR{1},'GAMM')==1)
                        FCATE(ICATE,4)=str2num(TEMR{2}); % valor
                    end % endif
                    % espesor
                    if (strcmp(TEMR{1},'TESP')==1)
                        FCATE(ICATE,5)=str2num(TEMR{2}); % valor
                    end % endif
                    % tipo de problema: 20=plano de esfuerzos
                    %                   21=plano de deformaciones
                    if (strcmp(TEMR{1},'TIPR')==1)
                        TIPR=str2num(TEMR{2}); % valor
                        % se guarda en un escalar porque es
                        % un parámetro general del problema
                    end % endif
                    % módulo plástico del material
                    if (strcmp(TEMR{1},'EPLA')==1)
                        FCATE(ICATE,9)=str2num(TEMR{2}); % valor
                    end % endif
                    % límite plástico del material
                    if (strcmp(TEMR{1},'SIGY')==1)
                        FCATE(ICATE,10)=str2num(TEMR{2}); % valor
                    end % endif
                    % tipo de modelo constitutivo del material
                    if (strcmp(TEMR{1},'TYMO')==1)
                        FCATE(ICATE,11)=str2num(TEMR{2}); % valor
                    end % endif
                    % categoría incorrecta
                    if((strcmp(TEMR{1},'EYOU')==0) && ...
                            (strcmp(TEMR{1},'POIS')==0) && ...
                            (strcmp(TEMR{1},'GAMM')==0) && ...
                            (strcmp(TEMR{1},'TESP')==0) && ...
                            (strcmp(TEMR{1},'SIGY')==0) && ...
                            (strcmp(TEMR{1},'EPLA')==0) && ...
                            (strcmp(TEMR{1},'TYMO')==0) && ...
                            (strcmp(TEMR{1},'TIPR')==0))
                        error ('Nombre incorrecto en la entidad fisica CATE.');
                    end %endif
                    
                end %endfor
                %------------------------------------------------------------------------------
                % control de errores
                
                %  Se verifica que se hayan asignado magnitudes de módulo de elásticidad,
                %  relación de Poisson y espesor.
                if (FCATE(ICATE,2)==0)||(FCATE(ICATE,5)==0)
                    fprintf('\n');
                    error('EYOU, POIS o TESP de una categoria igual a cero');
                end %endif
                
                if(FCATE(ICATE,3)==0)
                    fprintf('\n');
                    warning('POIS de una categoria igual a cero');
                end %endif
            end %endif
            %------------------------------------------------------------------------------
            % entidad física incorrecta
            
            %  Se controla que la entidad física sea evaluable en alguno de los tipos
            %  definidos.
            
            if((strcmp(TEMP(1:5),'"DISP')==0) && ...
                    (strcmp(TEMP(1:5),'"LOAD')==0) && ...
                    (strcmp(TEMP(1:5),'"PRES')==0) && ...
                    (strcmp(TEMP(1:5),'"CURV')==0) && ...
                    (strcmp(TEMP(1:5),'"DOEL')==0) && ...
                    (strcmp(TEMP(1:5),'"CATE')==0))
                error ('Nombre incorrecto de entidad fisica');
            end %endif
            %------------------------------------------------------------------------------
            %  Fin del ciclo que almacena las entidades físicas definidas para el problema.
        end % endfor IFIS
        
        NCOBO=ICOBO; % número de entidades físicas de condic de borde
        NCAT=ICATE; % número de entidades físicas de tipos de categoría
        
    end % endif fin de bloque de entidades físicas
    %------------------------------------------------------------------------------
    % bloque de nudos
    
    %  Este condicional lee el bloque de nudos del archivo de entrada.
    %  En primer lugar, extrae el número de nudos definidas en el preproceso.
    %  Con este número de nudos define un ciclo haciendo uso del contador INUD,
    %  dentro de este, almacena las coordenadas X y Y de cada uno de los nudos
    %  de la malla.
    
    if (strcmp(TLINE,'$Nodes')==1)
        TLINE = fgetl(FLID); % leer siguiente línea
        NNUD=int64(str2num(TLINE));% número de nudos
        XYZ=zeros(NNUD,NDIM);
        for INUD=1:NNUD
            TLINE = fgetl(FLID); % leer siguiente línea
            TEMP=str2num(TLINE); % dividir por variables
            XYZ(INUD,1)=TEMP(2); % coordenada x
            XYZ(INUD,2)=TEMP(3); % coordenada y
        end %endfor INUD
    end % endif fin de bloque de nudos
    %------------------------------------------------------------------------------
    % bloque de elementos y
    % condiciones de borde en puntos y líneas
    
    %  Este condicional lee el bloque de elementos del archivo de entrada.
    %  En primer lugar, extrae el número de elementos definidos en el preproceso.
    %  Con este número de elementos se define un ciclo haciendo uso del contador
    %  IELT, dentro de este, se almacenan características de puntos, líneas y
    %  superficies triangulares lineales o cuadrilaterales bilineales.
    
    % COPL(1,1): ID de la entidad física
    % COPL(1,2): identificador punto 1
    % COPL(1,3): identificador punto 2 (para puntos es 0}
    
    if (strcmp(TLINE,'$Elements')==1)
        
        % inicializar
        ICOPL=0; IELTR=0; IELCU=0; CORL=0; ISUP=0;
        COPL=zeros(1,3); % condiciones de borde en puntos y lineas
        ELTR=zeros(1,4); % elementos en superficie tipo triangulo
        ELCU=zeros(1,5); % elementos en superficie tipo cuadrilateral
        
        TLINE = fgetl(FLID); % leer siguiente línea
        NELT=int64(str2num(TLINE));% núm elem + cond borde
        
        for IELT=1:NELT
            TLINE = fgetl(FLID); % leer siguiente línea
            TEMP=str2num(TLINE); % dividir por variables
            
            % condición de borde en puntos
            if TEMP(2)==15
                ICOPL=ICOPL+1; % contador de cond de borde en puntos y líneas
                COPL(ICOPL,:)=[TEMP(4),TEMP(6), 0];
            end %endif
            
            % condición de borde en líneas
            if TEMP(2)==1
                ICOPL=ICOPL+1; % contador de cond de borde en puntos y líneas
                % [id entidad fisica, id nudo i, id nudo j]
                COPL(ICOPL,:)=[TEMP(4),TEMP(6:7)];
            end %endif
            %------------------------------------------------------------------------------
            % entidad física en superficies con
            % elementos triangulares lineales
            
            %  Para elementos  de superficie triangulares o cuadrilaterales, se definen los
            %  coeficientes restantes de la tabla de categorías:
            
            % FCATE(1,6): Tipo de elemento TIPE
            % FCATE(1,7): Número de nudos del elemento NUEL
            % FCATE(1,8): Número de puntos de Gauss del elemento PGAU
            
            if TEMP(2)==2
                IELTR=IELTR+1; % contador de elementos triangulares
                
                % escribir en la tabla de categorías
                % tipo de elemento: TIPE, nudos por elem: NUEL, p.Gauss: PGAU
                for ICATE=1:NCAT
                    if FCATE(ICATE,1)==TEMP(4)
                        FCATE(ICATE,6:8)=[201,3,1];
                        RCATE=ICATE; % indice de la categoria asociado a la ent física
                    end %endif
                end % endfor ICATE
                %------------------------------------------------------------------------------
                % escribir en la tabla de conectividades
                % revisión y corrección de conectividades en sentido horario
                
                %  Se ensambla la matriz XYE que contiene las coordenadas de los tres nudos del
                %  elemento triangular, se hace uso de la función PBAVEL, en donde, por medio
                %  del cáculo del área del elemento a partir de sus nodos, es posible definir
                %  si estos están ordenados de manera horaria o antihoraria. Conociendo este
                %  resultado, se pueden organizar los identificadores de los nudos
                %  en la matriz de elementos triangulares ELTR. Cada elemento compone una fila
                %  de 4 números en la matriz, el primero es el índice de la categoría y los
                %  siguientes 3 son los identificadores de los nudos ordenados en sentido
                %  antihorario.
                
                for INUE=1:3
                    XYE(INUE,1:2)=XYZ(TEMP(INUE+5),1:2);
                end % endfor INUE
                ARVO = PBAVEL(XYE,201,1);
                if ARVO > 0.0
                    % nudos en sentido antihorario (correcto)
                    % [id categoría ; id nudos i,j,k]
                    ELTR(IELTR,:)=[RCATE,TEMP(6:8)];
                else
                    % nudos en sentido horario (incorrecto)
                    % [id categoría ; id nudos i,j,k]
                    ELTR(IELTR,:)=[RCATE,TEMP(6),TEMP(8),TEMP(7)];
                    CORL=CORL+1; % indicador de la corrección
                end %endif
                
            end %endif
            %------------------------------------------------------------------------------
            % entidad física en superficies con
            % elementos cuadrilaterales bilineales
            
            %  Se ensambla la matriz XYE que contiene las coordenadas de los cuatro nudos
            %  del elemento cuadrilateral, se hace uso de la función PBAVEL, en donde, por
            %  medio del cáculo del área del elemento a partir de sus nodos, es posible
            %  definirsi estos están ordenados de manera horaria o antihoraria. Conociendo
            %  este resultado, se pueden organizar los identificadores de los nudos
            %  en la matriz de elementos cuadrilaterales ELCU. Cada elemento compone una
            %  fila de 5 números en la matriz, el primero es el índice de la categoría y los
            %  siguientes 4 son los identificadores de los nudos ordenados en sentido
            %  antihorario.
            
            if TEMP(2)==3
                IELCU=IELCU+1; % contador de elementos cuadrilaterales
                
                % escribir en la tabla de categorías
                % tipo de elemento: TIPE, nudos por elem: NUEL, p.Gauss: PGAU
                for ICATE=1:NCAT
                    if FCATE(ICATE,1)==TEMP(4)
                        FCATE(ICATE,6:8)=[202,4,4];
                        RCATE=ICATE; % indice de la categoria asociado a la ent física
                    end %endif
                end % endfor ICATE
                
                % escribir en la tabla de conectividades
                % revisión y corrección de conectividades en sentido horario
                for INUE=1:4
                    XYE(INUE,1:2)=XYZ(TEMP(INUE+5),1:2);
                end % endfor INUE
                ARVO = PBAVEL(XYE,202,1);
                if ARVO > 0.0
                    % nudos en sentido antihorario (correcto)
                    % [id entidad fisica ; id nudos i,j,k,l]
                    ELCU(IELCU,:)=[RCATE,TEMP(6:9)];
                else
                    % nudos en sentido horario (incorrecto)
                    % [id entidad fisica ; id nudos i,j,k,l]
                    ELCU(IELCU,:)=[RCATE,TEMP(6),TEMP(9),TEMP(8),TEMP(7)];
                    CORL=CORL+1; % indicador de la corrección
                end %endif
                
            end %endif
            %------------------------------------------------------------------------------
            % tabla auxilar de identificador de la superficie asociada
            % al elemento finito (triangular o cuadrilateral)
            if TEMP(2)==2 || TEMP(2)==3
                ISUP=ISUP+1;
                SUP(ISUP)=TEMP(5);
            end %endif
            %------------------------------------------------------------------------------
            %  Fin de lectura de elementos finitos
        end %endfor IELT
        %------------------------------------------------------------------------------
        %  Si se llega a requerir reordenación de coordenadas, este condicional se
        %  encarga de imprimir el tiempo consumido en la operación.
        
        if CORL>0
            DUMI = IMTIEM('',0);
            fprintf('\n');
            warning(['LEGMSH: corrección de conectividades, ordenando ' ...
                'los nudos en sentido antihorario.']);
        end % endif
        %------------------------------------------------------------------------------
        NCOPL=ICOPL; % número de condiciones de borde
        NELE=IELTR+IELCU; % número de elementos finitos
        
    end % endif bloque de elem y nudos y lados con cond borde
    %------------------------------------------------------------------------------
    %  En caso de que la línea almacenada en TLINE no coincida con niguno de los
    %  condicionales del ciclo, se lee la siguiente línea del archivo de entrada de
    %  datos, para repetir el ciclo, en tanto se cumpla la condición del mismo (que
    %  tenga caracteres).
    TLINE = fgetl(FLID);% leer siguiente línea
    %------------------------------------------------------------------------------
    %  Una vez alcanzada la última línea del archivo .msh, no se cumple la
    %  condición que define el ciclo, por lo tanto este termina. Una vez terminado,
    %  se cierra el archivo de entrada de datos del problema por medio del comando
    %  fclose.
end % endwhile fin de lectura
fclose(FLID); % cierre de archivo
%------------------------------------------------------------------------------
% preparar tabla de categorias de los elementos
%  Se extraen las columnas 2 a 8 de la matriz de categorías FCATE
% [ EYOU POIS GAMM TESP TIPE NUEL PGAU EPLA SIGY TYMO]

CAT=zeros(NCAT,9);
CAT(:,1:10)=FCATE(:,2:11);
%------------------------------------------------------------------------------
% preparar tabla de conectividades de los elementos ELE

%  Si solamente se tienen elementos triangulares en la malla, el índice de
%  cuadrilateros IELCU será igual a cero, por lo que la matriz de elementos
%  será igual a la matriz de elementos triangulares ELTR

if IELCU==0
    % malla de solo elementos triangulares
    NNUE=3; NGAU=1;
    ELE=ELTR;
    %------------------------------------------------------------------------------
    %  Si solamente se tienen elementos cuadrilaterales en la malla, el índice de
    %  triangulos IELTR será igual a cero, por lo que la matriz de elementos
    %  será igual a la matriz de elementos cuadrilaterales ELCU
    
else
    NNUE=4; NGAU=4;
    if IELTR==0
        % malla de solo elementos cuadrilaterales
        ELE=ELCU;
        %------------------------------------------------------------------------------
        %  Se crea una nueva categoría para los elementos triangulares, duplicando las
        %  constantes EYOU POIS GAMM TESP de la última categoría almacenada en FCATE en
        %  la matriz CAT y añadiendo los valores TIPE NUEL PGAU (201,3,1) de un elemento
        %  triangular en las posiciones 5:7 de la misma matriz.
        
        %  Posteriormente, se crea una columna de tamaño NCAT(incluida la nueva categoría
        %  de elementos triangulares) en donde se almacena el número NCAT en todas las
        %  filas. esta matriz se concatena con la matriz de elementos triangulares ELTR,
        %  extrayedo la primera columna (que contenía el número de categoría anterior)
        %  y con una columna de ceros.
        
        %  Con lo anterior, se obtiene una matriz ELTR de dimensiones IELTR x 5, que se
        %  concatena con la matriz de elementos cuadrilaterales ELCU para obtener la
        %  matriz de elementos ELE de dimensiones NELE x 5, donde:
        
        % ELE(:,1): Categoría del elemento de superficie
        % ELE(:,2): Identificador del nodo 1 del elemento
        % ELE(:,3): Identificador del nodo 2 del elemento
        % ELE(:,4): Identificador del nodo 3 del elemento
        % ELE(:,5): Identificador del nodo 4 del elemento (elemetos cuadrilaterales)
        
    else
        % malla de elementos triangulares y cuadrilaterales
        if ELTR(1,1)==ELCU(1,1)
            % si triangulares y cuadrilaterales pertenecen a la misma categoría
            % se crea una nueva categoría para los elementos triangulares
            NCAT=NCAT+1;
            CAT(NCAT,1:4)=FCATE(NCAT-1,2:5);
            CAT(NCAT,8:10)=FCATE(NCAT-1,9:11);
            CAT(NCAT,5:7)=[ 201 3 1 ];
            MONE=ones(IELTR,1)*NCAT;
            MZER=zeros(IELTR,1);
            ELTR=[MONE,ELTR(:,2:4),MZER];
            ELE=[ELTR;ELCU];
        else
            % triangulares y cuadrilaterales son de categorías diferentes
            MZER=zeros(IELTR,1);
            ELTR=[ELTR,MZER];
            ELE=[ELTR;ELCU];
        end % endif
    end % endif
end %endif
%------------------------------------------------------------------------------
%  Para cada condición de borde asignada a un punto o línea almacenada en la
%  matriz COPL, se encuentra la correspondiente entidad física situada en la
%  matriz FCOBO.

% preparar tablas de condiciones de borde para el proceso UCO, FUN, FDI
% inicializar
IUCO=0; IUCP=0; IFUN=0; IFDI=0; ECUR=100; IAXI=0; IDOM=0;
FUN=zeros(1,3); FDI=zeros(1,6); UCO=zeros(1,3); AXI=zeros(1,4); DOM=zeros(1,1); FHD=zeros(1,6);

for ICOPL=1:NCOPL
    for ICOBO=1:NCOBO
        if COPL(ICOPL,1)==FCOBO(ICOBO,1)
            %------------------------------------------------------------------------------
            %  El tercer número de la fila de la matriz de condiciones de borde asignadas
            %  a puntos o líneas es 0 si se trata de un punto, de acuerdo con esta
            %  verificación se asigna la variabla NTEM.
            
            if COPL(ICOPL,3)==0
                NTEM=1; % condición de borde en punto de un nudo
            else
                NTEM=2; % condición de borde en línea formada por dos nudos
            end %endif
            %------------------------------------------------------------------------------
            % preparar tabla de condiciones de borde tipo desplazamiento
            
            %  Para desplazamientos (ID de entidad física = 10) el siguiente ciclo almacena
            %  en la matriz UCO los desplazamientos conocidos como:
            
            % UCO(:,1): ID del nudo
            % UCO(:,2): ID del desplazamiento conocido (1: desp. en x, 2: desp. en y)
            % UCO(:,3): Valor del desplazamiento conocido
            
            % UCO = [ INUD IDES VALD ]: formato B
            
            if FCOBO(ICOBO,2)==10
                % condición de borde en punto o en línea formada por dos nudos
                for ITEM=1:NTEM
                    % primer desplazamiento conocido indicado una misma entidad física
                    if FCOBO(ICOBO,3)>0
                        IUCO=IUCO+1; % cont cond bord tipo de desplaz
                        UCO(IUCO,1)=COPL(ICOPL,ITEM+1); % id nudo
                        UCO(IUCO,2:3)=FCOBO(ICOBO,3:4); % id desplazam, valor despl
                    end % endif
                    % segundo desplazamiento conocido indicado una misma entidad física
                    if FCOBO(ICOBO,5)>0
                        IUCO=IUCO+1; % cont cond bord tipo de desplaz
                        UCO(IUCO,1)=COPL(ICOPL,ITEM+1); % id nudo
                        UCO(IUCO,2:3)=FCOBO(ICOBO,5:6); % id desplazam, valor despl
                    end % endif
                end % endfor
            end %endif
            %------------------------------------------------------------------------------
            % condiciones de borde tipo fuerza puntual
            
            %  Para fuerzas (ID de entidad física = 20) el siguiente ciclo almacena
            %  en la matriz FUN las fuerzas puntuales conocidas como:
            
            % FUN(:,1): ID del nudo
            % FUN(:,2): ID de la fuerza puntual conocida (1: F en x, 2: F en y)
            % FUN(:,3): Valor de la fuerza puntual conocida
            
            %  Este formato aún no almacena la dirección de la fuerza puntual conocida.
            
            % FUN = [ INUD IFUE VALF ]: formato B
            
            if FCOBO(ICOBO,2)==20
                for ITEM=1:NTEM
                    % fuerza puntual aplicada en dirección x
                    if FCOBO(ICOBO,4)~=0
                        IFUN=IFUN+1; % contador de cond bord tipo fuerza puntual por nudos
                        FUN(IFUN,1)=COPL(ICOPL,ITEM+1); % id nudo
                        FUN(IFUN,2:3)=FCOBO(ICOBO,3:4); % id fuerza, valor fuerza
                    end % endif
                    % fuerza puntual aplicada en dirección y
                    if FCOBO(ICOBO,6)~=0
                        IFUN=IFUN+1; % contador de cond bord tipo fuerza puntual por nudos
                        FUN(IFUN,1)=COPL(ICOPL,ITEM+1); % id nudo
                        FUN(IFUN,2:3)=FCOBO(ICOBO,5:6); % id fuerza, valor fuerza
                    end % endif
                end % endfor
            end %endif
            %------------------------------------------------------------------------------
            % condiciones de borde tipo presión en un lado
            if FCOBO(ICOBO,2)==30 && (FCOBO(ICOBO,5)==0 || FCOBO(ICOBO,5)==1)
                IFDI=IFDI+1; % contador de cond bord tipo presión en un lado
                % FDI = [ RELE NUDI NUDJ PREX PREY 0 ]: presión unif en sist global
                % FDI = [ RELE NUDI NUDJ PREN PRET 1 ]: presión unif en sist local
                % FHD = [ RELE NUDI NUDJ PREI PREJ 2 ]: presión hidráulica
                % id elemento
                
                %  Se ingresa a la función ELELAD con la matriz de elementos de superficie ELE
                %  y los ID de los nudos o líneas con condiciones de borde, extraídos de la
                %  matriz COPL (columnas 2 y 3) para cada iteración del contador ICOPL.
                
                %  Con lo anterior, se obtiene el identificador del elemento tipo superficie
                %  que contiene los puntos asociados a dicha condición de borde de presión
                %  uniforme y se almacena en la variable RELE. Se estructura la matriz FDI
                %  como:
                
                % FDI(:,1): ID del elemento de sup. asociado a la presión
                % FDI(:,2): ID del nudo i del lado asociado a la presión
                % FDI(:,3): ID del nudo j del lado asociado a la presión
                % FDI(:,4): Magnitud de la presión en x
                % FDI(:,5): Magnitud de la presión en y
                % FDI(1,6): ID de tipo de presión (0=s.global 1=s.local 2=p. hidr.)
                
                RELE=ELELAD(ELE,COPL(ICOPL,2:3));
                FDI(IFDI,1)=RELE; % id elemento
                % [id_nudo_i, id_nudo_j,...]
                FDI(IFDI,2:3)=COPL(ICOPL,2:3);
                % [..., val_pres_x, val_pres_y, 0]: presión unif sist global
                % [..., val_pres_n, val_pres_t, 1]: presión unif sist local
                FDI(IFDI,4:6)=FCOBO(ICOBO,3:5);
                %------------------------------------------------------------------------------
            end %endif

            % condiciones de borde tipo presión hidrostática
            if FCOBO(ICOBO,2)==30 && FCOBO(ICOBO,5)==2
                IFDI=IFDI+1; % contador de cond bord tipo presión en un lado
                % FDI = [ RELE NUDI NUDJ PREX PREY 0 ]: presión unif en sist global
                % FDI = [ RELE NUDI NUDJ PREN PRET 1 ]: presión unif en sist local
                % FHD = [ RELE NUDI NUDJ PREI PREJ 2 ]: presión hidráulica
                % id elemento

                % FHD(:,1): ID del elemento de sup. asociado a la presión
                % FHD(:,2): ID del nudo i del lado asociado a la presión
                % FHD(:,3): ID del nudo j del lado asociado a la presión
                % FHD(:,4): Magnitud de la presión en x
                % FHD(:,5): Magnitud de la presión en y
                % FHD(1,6): ID de tipo de presión (0=s.global 1=s.local 2=p. hidr.)

                RELE=ELELAD(ELE,COPL(ICOPL,2:3));
                FHD(IFDI,1)=RELE; % id elemento
                % [id_nudo_i, id_nudo_j,...]
                FHD(IFDI,2:3)=COPL(ICOPL,2:3);
                % [..., val_pres_x, val_pres_y, 0]: presión unif sist global
                % [..., val_pres_n, val_pres_t, 1]: presión unif sist local
                FHD(IFDI,4:6)=FCOBO(ICOBO,3:5);
                %------------------------------------------------------------------------------
                if FCOBO(ICOBO,5)==2
                    % [..., val_pres_n_i, val_pres_n_j, 2]: presión hidráulica
                    FHD(IFDI,6)=FCOBO(ICOBO,5);
                    GAWA=FCOBO(ICOBO,3);
                    HEWA=FCOBO(ICOBO,4);

                    %  Se verifica que la altura de la presión hidrostática asignada a la entidad
                    %  física tipo presión uniforme no sea superior a la altura de los puntos
                    %  inicial y final de la entidad a la que está asignada. De ser así, se redefine
                    %  el valor de la altura del agua HEWA como el producto de GAWA con la diferencia
                    %  de estas alturas. Si HEWA es superior a la coordenada Y, se redefine como 0.

                    for ITEM=1:2
                        YNU(ITEM)=XYZ(COPL(ICOPL,ITEM+1),2);
                        if YNU(ITEM)<=HEWA
                            FHD(IFDI,ITEM+3)=GAWA*(HEWA-YNU(ITEM));
                        else
                            FHD(IFDI,ITEM+3)=0;
                        end % endif
                    end % endfor ITEM
                end % endif
            end %endif


            %------------------------------------------------------------------------------
            % Condiciones de borde tipo gráfica de curva

            % AXI(:,1): ID del elemento tipo nudo asociado a la curva
            % AXI(:,2): ID del eje (1=horizontal, 2:vertical)
            % AXI(:,3): ID de la variable (1=UX, 2=UY, 3=FX, 4=FY)
            % AXI(:,4): ID de la curva
                        
            % AXI = [ INUD AXIS IDCO IDCU ]
            
            if FCOBO(ICOBO,2)==40
                for ITEM=1:NTEM
                    % ent física del eje horizontal de gráfica con id
                    if FCOBO(ICOBO,4)~=0 && FCOBO(ICOBO,7)~=0
                        IAXI=IAXI+1; % contador de cond bord tipo gráfica de curva
                        AXI(IAXI,1)=COPL(ICOPL,ITEM+1); % id nudo
                        AXI(IAXI,2)=FCOBO(ICOBO,3); % id eje: 1=horizontal, 2:vertical
                        AXI(IAXI,3)=FCOBO(ICOBO,4); % id componen: 1=UX, 2=UY, 3=FX, 4=FY, 5=EX, 6=EY, 7=SX, 8=SY
                        AXI(IAXI,4)=FCOBO(ICOBO,7); % id curva
                    end % endif
                    % ent física del eje vertical de gráfica con id
                    if FCOBO(ICOBO,6)~=0 && FCOBO(ICOBO,7)~=0
                        IAXI=IAXI+1; % contador de cond bord tipo gráfica de curva
                        AXI(IAXI,1)=COPL(ICOPL,ITEM+1); % id nudo
                        AXI(IAXI,2)=FCOBO(ICOBO,5); % id eje: 1=horizontal, 2:vertical
                        AXI(IAXI,3)=FCOBO(ICOBO,6); % id componen: 1=UX, 2=UY, 3=FX, 4=FY, 5=EX, 6=EY, 7=SX, 8=SY
                        AXI(IAXI,4)=FCOBO(ICOBO,7); % id curva
                    end % endif
                    % ent física de los dos ejes de gráfica sin id
                    if FCOBO(ICOBO,4)~=0 && FCOBO(ICOBO,6)~=0 && FCOBO(ICOBO,7)==0
                        ECUR=ECUR-1; % id de curva sin número
                        IAXI=IAXI+1; % contador de cond bord tipo gráfica de curva
                        AXI(IAXI,1)=COPL(ICOPL,ITEM+1); % id nudo
                        AXI(IAXI,2)=FCOBO(ICOBO,3); % id eje: 1=horizontal, 2:vertical
                        AXI(IAXI,3)=FCOBO(ICOBO,4); % id componen: 1=UX, 2=UY, 3=FX, 4=FY, 5=EX, 6=EY, 7=SX, 8=SY
                        AXI(IAXI,4)=ECUR; % id de curva sin número
                        IAXI=IAXI+1; % contador de cond bord tipo gráfica de curva
                        AXI(IAXI,1)=COPL(ICOPL,ITEM+1); % id nudo
                        AXI(IAXI,2)=FCOBO(ICOBO,5); % id eje: 1=horizontal, 2:vertical
                        AXI(IAXI,3)=FCOBO(ICOBO,6); % id componen: 1=UX, 2=UY, 3=FX, 4=FY, 5=EX, 6=EY, 7=SX, 8=SY
                        AXI(IAXI,4)=ECUR; % id de curva sin número
                    end % endif
                end % endfor
            end %endif
            if FCOBO(ICOBO,2)==50
                for ITEM=1:NTEM
                    IDOM = IDOM+1;
                    DOM(IDOM,1) = COPL(ICOPL,ITEM+1);
                end %endfor
            end %endif
        end %endif
    end %endfor ICOBO
end %endfor ICOPL

% eliminar condiciones de borde de desplazamientos imp exactamente iguales
TEM=unique(UCO,'rows');
UCO=TEM;

% ajustar tabla de fuerzas nodales vacia
if FUN==0; FUN=[0 NDIM 0]; end

%------------------------------------------------------------------------------
% Organización de las gráficas de curvas

% La matriz [CUR] contiene la siguiente información sobre las curvas a
% elaborar:

%   CUR(:,1): ID del nudo asociado a la curva en x
%   CUR(:,2): ID de la variable en x (1=UX, 2=UY, 3=FX, 4=FY)
%   CUR(:,3): ID del nudo asociado a la curva en y
%   CUR(:,4): ID de la variable en y (1=UX, 2=UY, 3=FX, 4=FY)

% CUR = [ INUD(X) VARX INUD(Y) VARY ]

CUR = zeros(1,4);
ICUR = 0;
TEM = sortrows(AXI,4); AXI = TEM;
NAXI = size(AXI,1);
for IAXI=1:NAXI-1
    if AXI(IAXI,4)==AXI(IAXI+1,4)
        ICUR = ICUR + 1;
        if AXI(IAXI,2)==1 % eje horizontal
            CUR(ICUR,1)=AXI(IAXI,1);
            CUR(ICUR,2)=AXI(IAXI,3);
            CUR(ICUR,3)=AXI(IAXI+1,1);
            CUR(ICUR,4)=AXI(IAXI+1,3);
        end % endif
        if AXI(IAXI,2)==2 % eje vertical
            CUR(ICUR,1)=AXI(IAXI+1,1);
            CUR(ICUR,2)=AXI(IAXI+1,3);
            CUR(ICUR,3)=AXI(IAXI,1);
            CUR(ICUR,4)=AXI(IAXI,3);
        end % endif
    end % endif
end % endfor ICUR
% eliminar gráficas de curvas exactamente iguales
TEM=unique(CUR,'rows');
CUR=TEM;

end % fin de la función

% ------------------------------------------
% identifica el número del elemento de 3 o de
% 4 nudos a partir de los nudos de un lado
function RELE=ELELAD(ELE,LAD)
    % entrada:  ELE: tabla de conectividades de los elementos
    %           LAD: identificador de los nudos del lado
    %           INUD=LAD(1,1); JNUD=LAD(1,2);
    % salida:   RELE: identificador del primer elemento con el lado
    
    INUD=LAD(1,1); JNUD=LAD(1,2);
    RELE=0;
    [NELE,NNUE]=size(ELE);
    NNUE=NNUE-1;
    for IELE=1:NELE
        for INUE=1:NNUE
            if ELE(IELE,INUE+1)==INUD
                for JNUE=1:NNUE
                    if ELE(IELE,JNUE+1)==JNUD
                        RELE=IELE; % asignar id elemento encontrado
                        JNUE=NNUE; INUE=NNUE; IELE=NELE; % salida rápida
                    end %endif
                end %endfor JNUE
            end % endif
        end %endfor INUE
    end %endfor IELE
end

% -------------------------------------------------
% lee etiqueta de desplazamientos y fuerzas en nudos
% y devuelve el código respectivo para el bloque
% curvas de HYPLAS
function CODI = CURVAL(ETIQ)
    % Entrada:    ETIQ: etiqueta de desplazamiento o fuerza en nudo para GMSH
    % Salida:     CODI: código id del desplazamiento o fuerza en nudo para HYPLAS
    switch ETIQ
        case 'UX' % desplazamiento nodal en x
            CODI=1;
        case 'UY' % desplazamiento nodal en y
            CODI=2;
        case 'FX' % fuerza de reacción nodal en x
            CODI=3;
        case 'FY' % fuerza de reacción nodal en y
            CODI=4;
        case 'EX' % deformación promedio en x
            CODI=5;
        case 'EY' % deformación promedio en y
            CODI=6;
        case 'SX' % esfuerzo promedio en x
            CODI=7;
        case 'SY' % esfuerzo promedio en y
            CODI=8;
        otherwise
            fprintf('\n');
            error('LEGMSH. Etiqueta desconocida de la componente de despl o fuerza para curvas');
    end
end