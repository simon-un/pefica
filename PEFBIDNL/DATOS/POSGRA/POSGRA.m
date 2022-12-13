% Programa anexo para la suma de curvas de resultados obtenidas en un
% problema de PEFICA.

% -------------------------------------------------------------------------
% Entradas:

% ADAT: Nombre de los archivos que contienen los resultados a sumar sin
%       extensión '.cur0n.mat'
% TSUM: identificador de la opción de suma de datos. Este es un parámetro
%       que por defecto es igual a 1.
%              TSUM = 1: Se suma la variable X.
%              TSUM = 2: Se suma la variable Y.
%              TSUM = 3: Se suman ambas variables.
% NCUR: Número de curvas a sumar

% Salidas:

% Archivo con extensión '.cur00.mat' con la grafica sumada de resultados.
% -------------------------------------------------------------------------

function POSGRA(ADAT,TSUM,NCUR)
clc; % limpiar pantalla

% control de ausencia de argumentos

% Se verifica que se haya introducido un nombre de archivo de entrada de datos,
% la función exist arroja 1 de ser verdadero y 0 de ser falso.
if exist('ADAT','var') == 0
    fprintf('POSGRA. La funcion requiere <nombre archivo datos>.\n')
    return
end

NCUR = str2double(NCUR);
TSUM = str2double(TSUM);

ADSZ = strcat('./CURVAS/',ADAT,'.cur01.mat');
SIZ = load(ADSZ,'-ascii');
NPSE = size(SIZ,1);
VXY = zeros(NPSE,2);

for ICUR=1:NCUR
    ADAD = strcat('./CURVAS/',ADAT,'.cur0',num2str(ICUR),'.mat');
    IXY = load(ADAD,'-ascii');

    switch TSUM
        case 1
            VXY(:,1) = VXY(:,1) + IXY(:,1);
            if ICUR==1
            VXY(:,2) = IXY(:,2);
            end %endif
        case 2
            VXY(:,2) = VXY(:,2) + IXY(:,2);
            if ICUR==1
            VXY(:,1) = IXY(:,1);
            end %endif
        case 3
            VXY(:,1) = VXY(:,1) + IXY(:,1);
            VXY(:,2) = VXY(:,2) + IXY(:,2);
    end %endswitch
end %endfor

SUGR = strcat('./CURVAS/',ADAT,'.cur00.mat'); % nombre archivo
save((SUGR),'VXY','-ascii','-tabs'); % Guardado

fprintf(' ----------------------------------------------------------------- \n');
fprintf('resultados guardados en el archivo:\n');
fprintf(strcat('./CURVAS/',ADAT,'.cur00.mat\n'));
fprintf(' ----------------------------------------------------------------- \n');

end %enfunction
    