% -------------------------------------------------------------------------
% PEFiCA: Programa de elementos finitos a código abierto. versión 2.3
%
% Esta versión está en la carpeta PEFICA 2.3, e incluye:
% Análisis elástico no lineal para problemas en condición plana de esfuerzos
% y deformaciones mediante el método de los elementos finitos. Considera
% deformaciones infinitesimales y utiliza elementos finitos triangulares
% lineales. Puede leer datos y escribir resultados de GMSH.
% -------------------------------------------------------------------------
% Dorian L. Linero S., Martín Estrada M., Helbert D. Santamaria R. & Diego A. Garzón A.
% Universidad Nacional de Colombia
% Facultad de Ingeniería
% Todos los derechos reservados, 2022

function PEFICA (ADAT)
    % ADAT: nombre del archivo de entrada de datos sin extensión
    % TLEC: identificador de la opción de lectura de datos. Este es un parámetro
    %       que por defecto es igual a 0.
    % ------------------------------------------------------------------------------
    % presentación inicial en pantalla
    clc; % limpiar pantalla
    fprintf('----------------------------------------------------------------- \n');
    fprintf('       PEFICA 2.0. Universidad Nacional de Colombia 2020          \n');
    fprintf('----------------------------------------------------------------- \n');
    fprintf('PEFBID/PEFICA: Analisis bidimensional elastico lineal \n');
    fprintf('escriba PEFICA <nombre archivo datos .m o .msh> <opciones lectura>\n');
    fprintf('el parametro <opciones lectura> puede ser igual a: \n');
    fprintf('=04: lectura de .m de GiD y escritura malla en TikZ\n');
    fprintf('=05: lectura de .m de GiD y escritura definida por IMPR.\n');
    fprintf('     Si IMPR=2 se escriben resultados en .gid.res y gid.msh de GiD\n');
    fprintf('=06: lectura de .m de GiD y escritura resultados en .gid.res y\n');
    fprintf('     gid.msh de GiD, y en ventana de comandos\n');
    fprintf('=07: lectura de .m de GiD y escritura resultados en .pos de GMSH\n');
    fprintf('     esfuerzos y deformaciones promedio en nudos PRO=0\n');
    fprintf('=08: lectura de .m de GiD y escritura resultados en .pos de GMSH\n');
    fprintf('     esfuerzos y deformaciones en el interior de elementos PRO=1\n');
    fprintf('=10: lectura datos de .msh de GMSH y escritura resultados en\n');
    fprintf('     .pos de GMSH esfuerzos y deformaciones promedio en nudos\n');
    fprintf('     para una categoría de material y espesor PRO=0\n');
    fprintf('=11: lectura datos de .msh de GMSH y escritura resultad en .pos de\n');
    fprintf('     GMSH, esfuerzos y deformaciones en el interior de eleme PRO=1\n');
    fprintf('=12: lectura datos de .msh de GMSH y escritura resultados en \n');
    fprintf('     .pos de GMSH esfuerzos y deformaciones promedio en nudos \n');
    fprintf('     para varias categorías de material y espesor PRO=2.\n');
    fprintf('     Adicionalmente se imprime en la ventana las reacciones.\n');
    % ------------------------------------------------------------------------------
    fprintf('=13: análisis no lineal controlado por desplazamientos, lectura de \n');
    fprintf('     datos en archivo .m y escritura resultados en archivo .pos de GMSH\n');
    fprintf('=14: análisis no lineal controlado por fuerzas, lectura de datos en \n');
    fprintf('     archivo .m y escritura resultados en archivo .pos de GMSH\n');
    % ------------------------------------------------------------------------------
    fprintf('=17: lectura datos de .msh de GMSH y escritura resultado .gid.res \n');
    fprintf('     y gid.msh de GiD \n');
    fprintf('=19: lectura datos de .msh de GMSH y escritura malla en TikZ \n');
    fprintf('Si <opciones lectura> se omite adquiere un valor de 10. \n');
    fprintf('------------------------------------------------------------------\n');
    % ------------------------------------------------------------------------------    
    % control de ausencia de argumentos

    % Se verifica que se haya introducido un nombre de archivo de entrada de datos,
    % la función exist arroja 1 de ser verdadero y 0 de ser falso.
    if exist('ADAT','var') == 0
        fprintf('PEFICA. La funcion requiere <nombre archivo datos>.\n')
        return
    end
    
    ADAD = strcat('./DATOS/',ADAT); % Concatena el nombre del archivo de entrada
    %  de datos sin extensión con la ruta de la carpeta de datos
    
    % adicionar carpetas y tomar tiempo inicial
    addpath('./FUNCIONES');
    ruta = genpath('DATOS');
    addpath(ruta);
%     addpath('./DATOS');
    TINT = IMTIEM('Inicio de ejecucion del programa \n',0);
    
    % -------------------------------------------------------------------------
    %  Variables iniciales para opción de lectura
    % -------------------------------------------------------------------------
    run(ADAT); % leer datos de entrada de un archivo .m

    % -------------------------------------------------------------------------   
    % lectura de archivo de entrada de datos
    % -------------------------------------------------------------------------
    if TLEN<10
        % opción de lectura de entrada de datos de archivo .m (de GiD o escrito direc)
        TINI = IMTIEM('Lectura de datos de entrada de archivo .m ',0);
        run(ADAT);
        % sub opciones
        if TLEN==06
            % escribir resultados en GiD y en ventana de comandos
            IMPR=3;
        elseif TLEN==07 || TLEN==08
            % escritura resultados en .pos de GMSH
            % esfuerzos y deformaciones promedio en nudos o en el interior de los elem
            IMPR=5; PRO=TLEN-7; ENNU=1;
        elseif TLEN==04
            % escritura malla en TikZ
            IMPR=4;
        end % endif
        % -------------------------------------------------------------------------
    else
        % opción de lectura de entrada de datos de archivo .msh de GMSH
        TINI = IMTIEM('Lectura de datos de entrada de archivo .msh de GMSH ',0);
        
        %  Se hace uso de la función LEGMSH para leer el archivo de entrada de datos .msh
        %  preparado
        
        [NNUD,NELE,NNUE,NGAU,NDIM,NCAT,TIPR,ENNU,IMPR,...
            XYZ,ELE,CAT,UCO,FUN,FDI,FHD,SUP,CUR,DOM] = LEGMSH(ADAD);
        % -------------------------------------------------------------------------
        % convertir despl conoc de formato B a formato A
        % para este tipo de problema NDIM=NGLN el cual aún no ha sido calculado
        [TEM] = ORVEBA(UCO,TLEN,NDIM,0); UCO=TEM;
        % convertir FUN de formato B a formato A
        [TEM] = ORVEBA(FUN,TLEN,NDIM,1); FUN=TEM;
        % -------------------------------------------------------------------------
        % sub opciones
        if TLEN==10 || TLEN==11 || TLEN==12
            % esfuerzos y deformaciones promedio en nudos o en el interior de los
            % elementos con una o varias categorías
            PRO=TLEN-10;
        elseif TLEN==17
            % opción de lectura de .msh de GMSH y escritura de resultados en GiD
            ENNU=0; IMPR=2;
        elseif TLEN==19
            % opción de lectura de .msh de GMSH y escritura de malla en TikZ
            IMPR=4;
        end % endif
    end %endif
    % -------------------------------------------------------------------------
    %  Con el valor de la variable TIPR almacenado desde la ejecucuión de la función
    %  LEGMSH, se define la cantidad de propiedades del material en la variable
    %  PMAT y el número de propiedades por elemento PELE, a su vez, el número
    %  de propiedades de categoría PCAT resulta de su suma. Si no se ha definido
    %  correctamente un tipo de problema, se lanza un mensaje de error.
    
    
    ELE = int64(ELE); % cambio de tipo de datos para las matrices enteras
    if (TIPR==20 || TIPR==21)
        PMAT = 3;    % número de propiedades de cada material [ EYOU POIS GAMM ]
        PELE = 4;    % número de propiedades de cada elemento [ TESP TIPE NUEL PGAU ]
        PCAT = PMAT+PELE;    % número de propiedades en cada categoria
        NCOM=3; % NCOM: número de componentes de esfuerzo o deformación
    else
        error('PEFiCA. Tipo incorrecto de problema');
    end % endif problema bidimensional, material isotrópico
    % -------------------------------------------------------------------------
    
    IMTIEM('',TINI);
    
    TINI = IMTIEM('Grados de libertad de nudos y elementos ',0);
    % -------------------------------------------------------------------------
    % A partir de la tabla de desplazamientos conocidos de algunos nudos UCO()
    % se crea la tabla de GL por nudo MGL(), el subvector de desplazamientos
    % conocidos UBB() y se obtiene el número de GL por nudo NGLN y el número de
    % GL conocidos NGLC.
    [MGL,UBB,NGLN,NGLC] = NGLUCO(UCO,NNUD);
    NGLT = NNUD*NGLN;  % número de grados de libertad del sólido
    NGLD = NGLT-NGLC;  % número de grados de libertad conocidos
    % Se crea la tabla de GLs por elemento o matriz de incidencias
    [INC] = NGLELE(ELE,MGL);
    IMTIEM('',TINI);
    % indicador de parámetros de la malla
    fprintf('Malla de %g nudos, %g elementos y %g GLs\n', NNUD,NELE,NGLT);
    
    if (IMPR==4)
        TINI = IMTIEM('Dibujar geometria en Tikz LaTeX ',0);
        % -----------------------------------------------------------------------
        ADAD = strcat('./DATOS/',ADAT);
        TIPN = 0; %   0=sin numeración, 1=numeración nudos
        %                 2=numeración elementos, 3=numeración nudos y elementos.
        %  previamente están convertidos UCO y FUN de formato B a formato A
        IMTIKZ(ADAD,NNUD,NELE,NNUE,XYZ,ELE,UCO,FUN,TIPN);
        IMTIEM('',TINI); % tiempo de ejecución
        % mostrar tiempo final
        IMTIEM('Tiempo total de ejecucion del programa ',TINT);
        return
    end % endif IMPR
        
    % -------------------------------------------------------------------------
    % VECTORES DE FUERZAS
    % -------------------------------------------------------------------------
    
    TINI = IMTIEM('Vectores de fuerzas en los nudos del solido ',0);
    
    % - Fuerzas por acción del peso propio del sólido [FGC]
    
    FGC = zeros(NGLT,1); % definición de tamaño del vector de fuer cuerp sólido
    GAMT = sum(CAT(:,3));
    if GAMT~=0 % contror de problemas sin fuerzas de cuerpo GAMM=0
        for IELE = 1:NELE
            % vector de fuerzas equivalentes al peso propio en el elemento
            CAE(1:PCAT) = CAT(ELE(IELE,1),1:PCAT); % propiedades de la categ eleme IELE
            NUEL = CAE(1,PMAT+3);  % número de nudos del elemento IELE
            XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
            [FEL] = FELEMC(XYE,CAE); % vector de fuerzas de cuerpo del elemento
            % ensamblaje de FEL() del elemento IELE en FGC() del sólido
            NFEL = size(FEL,1); % tamaño de vector del elemento
            for IFEL=1:NFEL
                if INC(IELE, IFEL) ~= 0
                    FGC(INC(IELE, IFEL), 1) = FGC(INC(IELE, IFEL), 1) + FEL(IFEL,1);
                end % endif
            end % endfor IFEL
            % fin ensamblaje
        end % endfor IEIE
    end % endif
    
    % - Fuerzas equivalentes a acciones distribuidas  [FGS]
    
    NFDI = size(FDI,1); % número de cargas distribuidas en elementos
    FGS = zeros(NGLT,1); % definición de tamaño del vec fuerz superf del sólido
    for IFDI = 1:NFDI % ciclo por carga distribuida
        if FDI(IFDI,1)~=0 % control de problemas sin fuerzas de superficie
            FDE = FDI(IFDI,:); % caracteristicas del lado
            ICAT = ELE(FDI(IFDI,1),1); % identific de la categ del elemento cargado
            CAE = CAT(ICAT,:); % propiedades de la categ eleme IELE
            [NLA,LLAD,VNR] = PBLADO(XYZ,ELE,FDE); % longitud y normal al lado cargado
            [FEL] = FELEMS(CAE,LLAD,NLA,VNR,FDE); % vec fuerza de superf del element
            IELE=FDI(IFDI,1);
            % ensamblaje de FEL() del elemento IELE en FGS() del sólido
            NFEL = size(FEL,1); % tamaño de vector del elemento
            for IFEL=1:NFEL
                if INC(IELE, IFEL) ~= 0
                    FGS(INC(IELE, IFEL), 1) = FGS(INC(IELE, IFEL), 1) + FEL(IFEL,1);
                end % endif
            end % endfor IFEL
            % fin ensamblaje
        end % endif
    end % endfor

    % - Fuerzas equivalentes a presiones hidrostáticas [FGH]
    
    NFHD = size(FHD,1); % número de cargas distribuidas en elementos
    FGH = zeros(NGLT,1); % definición de tamaño del vec fuerz superf del sólido
    for IFHD = 1:NFHD % ciclo por carga distribuida
        if FHD(IFHD,1)~=0 % control de problemas sin fuerzas de superficie
            FDE = FHD(IFHD,:); % caracteristicas del lado
            ICAT = ELE(FHD(IFHD,1),1); % identific de la categ del elemento cargado
            CAE = CAT(ICAT,:); % propiedades de la categ eleme IELE
            [NLA,LLAD,VNR] = PBLADO(XYZ,ELE,FDE); % longitud y normal al lado cargado
            [FEL] = FELEMS(CAE,LLAD,NLA,VNR,FDE); % vec fuerza de superf del element
            IELE=FHD(IFHD,1);
            % ensamblaje de FEL() del elemento IELE en FGS() del sólido
            NFEL = size(FEL,1); % tamaño de vector del elemento
            for IFEL=1:NFEL
                if INC(IELE, IFEL) ~= 0
                    FGH(INC(IELE, IFEL), 1) = FGH(INC(IELE, IFEL), 1) + FEL(IFEL,1);
                end % endif
            end % endfor IFEL
            % fin ensamblaje
        end % endif
    end % endfor
    
    % - Fuerzas puntuales aplicadas directamente     [FGN]
    
    [TEM] = ORTAEX(FUN,NNUD); % tabla de fuerzas puntuales extendida a todos nuds
    [FGN] = ORTAVE(TEM,MGL); % vector de fuerzas en los nudos del sólido
    % solo es valido del GL=1 hasta GL=NGLD, los términos donde GL>NGLD son las
    % reacciones en los apoyos que aún son desconocidas
    
    % - Fin de creación de vectores de fuerzas
    IMTIEM('',TINI);
    
    % control interno del tipo de matriz de rigidez ensamblada:
    % LSIZ=0: matriz llena que funciona hasta 15,000 nudos
    % LSIZ=1: matriz sparse para problemas de más de 15,000 nudos
    LSIZ=0;
    if NNUD>650
        LSIZ=1;
    end % endif
    
    fprintf('----------------------------------------------------------------- \n');
    TINP = IMTIEM('Proceso iterativo de Newton - Raphson:\n',0);
    fprintf('----------------------------------------------------------------- \n');
    %   -------------------------------------------------------------------------
    %   VARIABLES INICIALES:
    %   -------------------------------------------------------------------------
    %   TOLE: tolerancia para evaluar el criterio de convergencia por iteración
    %   NMIT: número máximo de iteraciones para cada pseudotiempo
    %   NPSE: número de incrementos de carga/pseudotiempos
    %   ------------------------------------------------------------------------- 
    
    % 3. Definir desp. desconoc. de prueba [UAP] para iteración 0:
    [UAP] = zeros(NGLD,1);
    
    % 4. Definir la matriz inicial de deformaciones y esfuerzos de los elementos [SRE]:
    if ENNU==0; NEVA=NGAU; end % evaluada en los puntos de Gauss
    if ENNU==1; NEVA=NNUE; end % evaluada en los nudos
    if ENNU==2; NEVA=1; end % evaluada en el centro del elemento
    
    [SRE] = zeros(NELE*NEVA,NCOM+6); % crear tabla de esfuerzos por elemento
    [ERE] = zeros(NELE*NEVA,NCOM+6); % crear tabla de deformaci por elemento
    
    % 5. Definir la matriz inicial de variables internas del mod. constitutivo [VIN]:
    [VIN] = zeros(NELE*NEVA,NCOM+11); % crear tabla de variables internas por elemento
    TEMP = 1;
    for IELE=1:NELE
        for IEVA=1:NEVA
            VIN(TEMP,1)=IELE;
            if ENNU==0; VIN(TEMP,2)=IEVA; end
            if ENNU==1; VIN(TEMP,2)=ELE(IELE,IEVA+1); end
            TEMP=TEMP+1;
        end
    end
    
    % 6. Definir la matriz de gráficas de resultados
    [CXY] = zeros(NPSE,size(CUR,1)*2);
    [DXY] = [];
    
    %-------------------------------------------------------------------------
    % PARA CADA PSEUDO TIEMPO:
    %-------------------------------------------------------------------------
    for IPSE = 1:NPSE
        
        % 0. Extraer el factor de mayoración de cargas externas LAMB del vector [LAM]:
        LAMB = LAM(IPSE,1);
                
        % 1. Conteo del tiempo epleado por pseudo tiempo
        TEMP = [' Pseudotiempo número ',num2str(IPSE),' (LAMB = ',num2str(LAMB),')','\n'];
        TINI = IMTIEM(TEMP,0);
        fprintf(' ----------------------------------------------------------------- \n');
                       
        % 2. Crear vector de f.ext. mayoradas asociadas a desp. desconoc:
        %    subvec.fuer.totales conocidas alpha, entre 1<=GL<=NGLD
        
        switch TLEN
            case 13
                [UBP] = LAMB * UBB;
                [FAM] = FGN(1:NGLD,1) + FGS(1:NGLD,1) + FGC(1:NGLD,1)+ FGH(1:NGLD,1);
                
            case 14
                [UBP] = UBB;
                [FAM] = LAMB * (FGN(1:NGLD,1) + FGS(1:NGLD,1)) + FGC(1:NGLD,1) + FGH(1:NGLD,1);  
        end %endswitch
        
        % -------------------------------------------------------------------------
        % PARA CADA ITERACIÓN:
        % -------------------------------------------------------------------------
        for ITER=1:NMIT
            
            % 0. Conteo de tiempo empleado por iteración:
            fprintf('  Iteración %1i',ITER);
            
            % 1. Ensamblar vector de desplazamientos de prueba [UTP]:
            [UTP] = [ UAP ; UBP ];
            
            % 2. Crear matrices y vectores iniciales:
            [FIG] = zeros(NGLT,1); %vector de fuerzas internas
            [SRP] = zeros(NELE*NEVA,NCOM+6); % matriz de estado de esfuerzos de la malla
            [VIP] = [VIN(:,1:2) zeros(NELE*NEVA,NCOM+9)]; % matriz de variables internas de la malla
            
            switch MTNL
                case 0 % método de Newton-Raphson modificado KT0
                    if IPSE==1 && ITER==1
                        [KGS] = zeros(NGLT,NGLT);
                    end %endif
                case 1 % método de Newton-Raphson modificado KT1
                    if ITER==1
                        [KGS] = zeros(NGLT,NGLT);
                    end %endif
                case 2 % método de Newton-Raphson convencional
                    [KGS] = zeros(NGLT,NGLT);
            end %endswitch
            
            IRES = 0; % índice de la tabla de esfuerzos y deformaciones
            
            IKGS = 0;
            KGV = zeros(1,1,'double');
            KGC = zeros(1,1,'double');
            KGF = zeros(1,1,'double');
            
            % -------------------------------------------------------------------------
            % PARA CADA ELEMENTO FINITO:
            % -------------------------------------------------------------------------
            for IELE=1:NELE % ciclo por elemento
                
                % 1. Extraer despl. de prueba en cada elemento [UEL]:
                NUEL = CAT(ELE(IELE,1),6); % número de nudos del elemento
                NGLE = NUEL*NGLN; % número de GL por elemento
                [UEL] = EXTRAV(UTP,INC,IELE,NGLE); % vector de despl nodales del elemento
                TIPE = CAT(ELE(IELE,1),5); % código tipo del elemento
                XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
                [CAE] = CAT(ELE(IELE,1),:); % propiedades de la categ eleme IELE
                [TEM] = PBPGAU(NEVA, NDIM, ENNU); % ubicación y ponder de puntos de Gauss
                POIS = CAE(2);  % relación de Poisson
                
                % 2. Extracción de la matriz de variables internas del elemento [VIE]
                [VIE] = VIN(VIN(:, 1) == IELE,:);
                
                % -------------------------------------------------------------------------
                % PARA CADA PUNTO DE EVALUACIÓN:
                % -------------------------------------------------------------------------
                for IEVA=1:NEVA
                    
                    % 1. Ubicación del punto de Gauss o nudo
                    [XYP] = TEM(IEVA,1:2); % ubicación de puntos de Gauss o por nudos
                    
                    % 2. Obtener matriz B [BEL]:
                    [DJAC,BEL] = BELEME(XYE,XYP,TIPE); % matriz B en el punto de Gauss o nudo IGAU
                    
                    % 3. Calcular deformación de prueba:
                    [EPE] = BEL * UEL; % vector de deformaciones del elem. IELE en el punto IGAU
                    
                    % 4. Evaluar modelo constitutivo en función del esfuerzo de prueba STEL
                    [VI0] = VIE(IEVA,:); % Extracción de las variables internas del punto
                    IGAU = VI0(:,2);
                    
                    [SEP,VPP,DTA] = MODCON(VI0,CAE,IELE,IGAU,EPE,ITER,IPSE,LAM,TIPR);
                   
                    if TIPR==20
                        [SPR,STVM] = TRPRIN(SEP,POIS,TIPR,0); % vector de esfuerzo principales
                    end %endif
                    
                    if TIPR==21
                        % SEV(): vector de esfuerzos o deformaciones
                        %        = [ SXX, SYY, SZZ, SXY, SXZ, SYZ ] para esfuerzos
                        SEV = [ SEP(1), SEP(2), VPP(14), SEP(3), 0, 0];
                        [SPR,STVM] = TRPRID(SEV,0); % tabla esf.princ SP1,SP2,SP3
                    end %endif
                    
                    [EPR,EPVM] = TRPRIN(EPE,POIS,TIPR,1); % vector de deformac principales
                    
                    % -----------------------------------------------------------------------------------------------
                    % preparar tabla de esfuerzos y de deformaciones por elemento para GiD
                    % con elemento de valor constante en su interior
                    IRES = IRES+1; % ubicación del resultado en la tabla SRE() o ERE()
                    
                    SRP(IRES,1) = IELE; % tabla de esfuerzos, número del elemento IELE
                    ERE(IRES,1) = IELE; % tabla de deformaci, número del elemento IELE
                    
                    if ENNU==0
                        % evaluación en puntos de Gauss
                        SRP(IRES,2) = IEVA; % tabla de esfuerzos, número del PG
                        ERE(IRES,2) = IEVA; % tabla de deformaci, número del PG
                    elseif ENNU==1
                        % evaluación en los extremos de cada elemento
                        SRP(IRES,2) = ELE(IELE,IEVA+1); % tabla de esfuerzo, número del nudo
                        ERE(IRES,2) = ELE(IELE,IEVA+1); % tabla de deformac, número del nudo
                    elseif ENNU==2
                        % evaluación en el centro
                        SRP(IRES,2) = 0; % tabla de esfuerzo, 0 indica el centro
                        ERE(IRES,2) = 0; % tabla de deformac, 0 indica el centro
                    end % endif
                    
                    for ICOM = 1:NCOM % componente de esfuerzo leida
                        SRP(IRES, ICOM+2) = SEP(ICOM, 1); % tabla de esfuerzos SXX, SYY, SXY
                        ERE(IRES, ICOM+2) = EPE(ICOM, 1); % tabla de deformaciones EXX, EYY, GXY
                    end % endfor ICOM
                    for JCOM = 1:3 % esfuerzos o deformaciones principales
                        SRP(IRES, JCOM+NCOM+2) = SPR(JCOM, 1); % tabla esf.princ SP1,SP2,SP3
                        ERE(IRES, JCOM+NCOM+2) = EPR(JCOM, 1); % tabla defor.princ EP1,EP2,EP3
                    end % endfor JCOM
                    SRP(IRES, NCOM+6) = STVM; % esfuerzo de von Mises
                    ERE(IRES, NCOM+6) = EPVM; % esfuerzo de von Mises
                    % -----------------------------------------------------------------------------------------------
                    
                    VIP(IRES,:) = VPP;
                    
                    % 5. Calcular vector de fuerzas internas [FIE]:
                    AREA = PBAVEL(XYE,TIPE);      % Área del elemento finito
                    TESP = CAE(:,4);              % Espesor del elemento finito
                    if TIPE==201;PWPW = 1;end     % ponderación W_xi*W_eta
                    [FIE] = PWPW * BEL' * SEP * DJAC * AREA * TESP;
                    
                    % 6. Ensamblar vector de fuerzas internas del sólido [FIG]:
                    if TIPE==201 && IEVA==1
                        NFIE = size(FIE,1);
                        for IFIE=1:NFIE
                            if INC(IELE, IFIE) ~= 0
                                FIG(INC(IELE, IFIE), 1) = FIG(INC(IELE, IFIE), 1) + FIE(IFIE,1);
                            end % endif
                        end % endfor IFIE
                        
                        % 7. Matriz de rigidez en sistema local de coordenadas [KTN]:
                        KTG = PWPW * BEL' * DTA * BEL * DJAC * AREA * TESP;
                        
                        % 8. Ensamblar matriz de rigidez
                        if MTNL==2 ||(MTNL==0&&IPSE==1&&ITER==1)||(MTNL==1&&ITER==1)
                            switch LSIZ
                                case 0
                                    % ensamblaje convensional de la matriz de rigidez, el cual tiene una
                                    % capacidad máxima de 40 grados de libertad
                                    NKTG = size(KTG,1); % tamaño de la matriz de rigidez del elemento
                                    for IKTG=1:NKTG
                                        for JKTG=1:NKTG
                                            if ( INC(IELE, IKTG) ~= 0 && INC(IELE, JKTG) ~= 0)
                                                KGS(INC(IELE, IKTG), INC(IELE, JKTG)) = ...
                                                    KGS(INC(IELE, IKTG), INC(IELE, JKTG)) + KTG(IKTG, JKTG);
                                            end % endif
                                        end % endfor JKEL
                                    end % endfor IKEL
                                case 1
                                    % ensamblaje de una matriz de rigidez tipo sparse.
                                    NKTG = size(KTG,1); % tamaño de la matriz de rigidez del elemento
                                    for IKTG=1:NKTG
                                        for JKTG=1:NKTG
                                            if (INC(IELE, IKTG) ~= 0 && INC(IELE, JKTG) ~= 0)
                                                IKGS = IKGS + 1;
                                                KGF(IKGS) = INC(IELE, IKTG);
                                                KGC(IKGS) = INC(IELE, JKTG);
                                                KGV(IKGS) = KTG(IKTG, JKTG);
                                            end % endif
                                        end % endfor JKEL
                                    end % endfor IKEL
                            end %endswitch
                        end %endif MTNL
                    end %endif TIPE || IEVA
                end %endfor IEVA
                % -------------------------------------------------------------------------
                % FINAL DE CÁLCULO POR PUNTO DE EVALUACIÓN
                % -------------------------------------------------------------------------
                
            end %endfor IELE
            % -------------------------------------------------------------------------
            % FINAL DE CÁLCULO POR ELEMENTO FINITO
            % -------------------------------------------------------------------------
            % 3. Extraer matriz de fuerzas internas asociadas a despl. desc. [FIA]:
            [FIA] = FIG(1:NGLD,1);
            
            % 4. Calcular vector de fuerzas residuales asociadas a desp. desc.:
            [FRE] = FIA - FAM;
            
            % 5. Extraer submatriz de rigidez asociada a GL de desp. desconocidos [KAA]:
            if LSIZ==1 && (MTNL==2 ||(MTNL==0&&IPSE==1&&ITER==1)||(MTNL==1&&ITER==1))
                [KGS] = sparse(KGF,KGC,KGV);
            end %endif
            [KAA] = KGS(1:NGLD,1:NGLD);            % submatriz K_{alpha,alpha}
            
            % 6. Obtener incremento de desplazamientos de prueba [DEU]:
            % [DEU] = -KAA^-1 * FRE;
            switch LSIZ
                case 0
                    % solución del sistema de ecuaciones simultáneas mediante
                    % el método de Cholesky aplicado a la matriz de rigidez llena
                    opts.SYM = true;
                    [DEU] = linsolve(KAA,-FRE,opts);
                case 1
                    % solución del sistema de ecuaciones simultáneas mediante
                    % el método iterativo de los gradientes conjugados aplicado
                    % a la matriz de rigidez tipo sparse
                    [DEU,~] = pcg(KAA,-FRE,1e-5,1000);
            end % endswitch

            % 7. Evaluación del criterio de convergencia del pseudo-tiempo:
            switch TLEN
                % 7.1. Evaluación de evolución controlada por fuerzas:
                case 14
                    if LAMB==0 || norm(FAM)==0; ERRO = norm(FRE);
                    else
                        ERRO = norm(FRE)/norm(FAM); 
                    end %endif
                    
                % 7.2. Evaluación de evolución controlada por desplazamientos:
                case 13
                    if LAMB==0 || norm(UAP)==0; ERRO = norm(DEU);
                    else
                        ERRO = norm(DEU)/norm(UAP); 
                    end %endif
            end %endswitch
            
            if ERRO<=TOLE
                SRE = SRP;
                VIN = VIP;
                fprintf(', error = %1i < TOLE = %1i\n',ERRO,TOLE);
                break
            else
                if ITER==NMIT
                    warning('Se llegó al número máximo de iteraciones permitidas');
                    break
                end %endif
            end %endif

            % 8. Cálculo de los desplazamientos totales de prueba bara la iteración
            % ITER+1:
            [UAP] = UAP + DEU;
            
            % 9. Imprimir error de la iteración
            fprintf(', error = %1i\n',ERRO);

        end %endfor ITER
        % -------------------------------------------------------------------------
        % FINAL DE CÁLCULO POR ITERACIÓN
        % -------------------------------------------------------------------------

        if ITER==NMIT
            break
        end %endif
        
        % 7. Alamacenar desplazamientos de prueba [UTP] que cumplen el criterio de
        % convergencia para el tiempo IPSE:
        [FXY] = ORVETA(FIG,MGL); % tabla de fuerzas nodales en formato FX,FY
        [UXY] = ORVETA(UTP,MGL); % tabla de desplaz. nodales en formato UX,UY
        
        % 8. Generación de gráficas de fuerzas contra desplazamiento.
        if norm(CUR)~=0
            CXY = GRARES(CUR,FXY,UXY,SRE,ERE,CXY,IPSE,NMIT,ADAD,DOM,ITER,NPSE);
        end %endif
        
        if norm(DOM)~=0         
            DXY = IMVONM(ELE,SRE,VIN,IPSE,NMIT,CAT,DOM,DXY,ADAD,ITER); %Construcción de la elipse de
            % VonMises a partir del estado de esfuerzos de un nudo.
        end %endif
        
        % 9. Almacenar resultados de pseudo tiempo en archivo .pos de postproceso:
        IMGMSH(ADAD,NNUD,NELE,NNUE,NGAU,NCAT,XYZ,ELE,SUP,UXY,FXY,SRE,ERE,PRO,IPSE,NPSE,VIN,CAT,TIPR,LAM);
        
        % 10. Cierre del conteo del tiempo transcurrido
        fprintf(' \n');
        TEMP = [' Convergencia pseudotiempo número ',num2str(IPSE)];        
        IMTIEM(TEMP,TINI);
        fprintf(' ----------------------------------------------------------------- \n');
        
    end %endfor IPSE
    %  -------------------------------------------------------------------------
    %        FINAL DE CÁLCULO POR PSEUDOTIEMPO
    %  -------------------------------------------------------------------------
    IMTIEM('Fin del proceso iterativo de Newton Raphson',TINP);
    fprintf('----------------------------------------------------------------- \n');
  
    
    % mostrar tiempo final
    IMTIEM('Tiempo total de ejecucion del programa ',TINT);
end