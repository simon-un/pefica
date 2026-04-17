% Evaluación de un modelo constitutivo del material
function [STE,VIE,DTA] = MODCON(VI0,CAE,IELE,IGAU,EPE,ITEP,IPSE,LAM,TIPR)
    
    % Se selecciona el modelo constitutivo a utilizar de acuerdo con la
    % variable TYMO, almacenada en la categoría del material. Los modelos
    % constitutivos a considerar son:
    
    % Tipo de modelo constitutivo TYMO =
    %    (11): modelo elástico en condición plana de esfuerzos
    %    (21): modelo de plasticidad con end. isotrópico
    %    (22): modelo de plasticidad con end. cinemático
    %    (23): modelo de plasticidad con end. combinado
        
    TYMO = CAE(1,10); % Extracción del tipo de modelo constitutivo a considerar
    switch TYMO
        case 11 % modelo elástico
            [STE,VIE,DTA] = MODELA(VI0,CAE,IELE,IGAU,EPE,ITEP,IPSE,LAM,TIPR);
        case {21, 22, 23} % modelo de plasticidad con endurecimiento
            switch TIPR
                case 20
                    [STE,VIE,DTA] = MODPLE(VI0,CAE,IELE,IGAU,EPE,ITEP,IPSE,LAM);
                case 21
                    [STE,VIE,DTA] = MODPLD(VI0,CAE,IELE,IGAU,EPE,ITEP,IPSE,LAM);
            end %endswitch
        case 90 % modelo constitutivo definido por el usuario
            %Inserte aquí su modelo constitutivo
    end %endswitch
end %endfunction


  
