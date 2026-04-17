% Estructuración de vector de deformaciones principales en formato de
% impresión para IMGMSH
function [EPL] = OREPLA(VIN,CAT,ELE,NCOM,TIPR)
    % Se extrae el vector de deformaciones plásticas para cada uno de los
    % nudos de la malla, se almacena con el mismo formato que utiliza
    % PEFICA para el almacenamiento de las deformaciones totales, no se
    % incluye el último término con la deformación equivalente de Von
    % Mises.
    %       EPL(:,1) = IELE;      % número del elemento IELE
    %       EPL(:,2) = IGAU;      % indicador del nudo o punto de gauss
    %       EPL(:,3) = EPL(1,1);  % def. plástica EXX
    %       EPL(:,4) = EPL(2,1);  % def. plástica EYY
    %       EPL(:,5) = EPL(3,1);  % def. plástica EXY
    %       EPL(:,6) = EP1;       % def. plástica principal mayor
    %       EPL(:,7) = EP2;       % def. plástica principal intermedia
    %       EPL(:,8) = EP3;       % def. plástica principal menor  
    %       EPL(:,9) = EQVM;      % def. plástica equivalente de von mises
    
    NRES = size(VIN,1);
    [EPL] = [VIN(:,1:2) VIN(:,NCOM+1:NCOM+3) zeros(NRES,4)];
    for IRES=1:NRES
        IELE = EPL(IRES,1);                % ID del elemento
        [CAE] = CAT(ELE(IELE,1),:);        % propiedades de la categ eleme IELE
        POIS = CAE(1,2);                   % Relación de poisson
        [EPE] = EPL(IRES,NCOM:NCOM+2)';    % estado de deformación plástica
        [EPR,EQVM] = TRPRIN(EPE,POIS,TIPR,2); % vector de deformac principales
        EPL(IRES,NCOM+3:NCOM+5) = EPR';    % guardar deformaciones plasticas 
                                           % principales
        EPL(IRES,NCOM+6) = EQVM;           % def. plástica equivalente de 
                                           % von mises
    end %endfor
        
    