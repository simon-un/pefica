# pefica
Programa de Elementos FInitos a Código Abierto (Open Source Finite Element Program) 

Este programa se escribió para utilizar principalmente como una herramienta didáctica en los cursos de métodos numéricos y análisis por elementos finitos. Está escrito cuidando la compatibilidad entre Octave y Matlab, para facilidad de los usuarios.


% -------------------------------------------------------------------------
% PEFiCA: Programa de elementos finitos a código abierto. versión 2.0.1
%
% Esta versión está en la carpeta PEFBID, e incluye:
% Análisis elástico lineal para problemas en condición plana de esfuerzos
% y deformaciones mediante el método de los elementos finitos. Considera
% deformaciones infinitesimales y utiliza elementos finitos triangulares
% lineales y cuadrilaterales bilineales. Puede leer datos y escribir 
% resultados de los programas GiD (Problem Type PEFICA-O.gid) y GMSH.
% -------------------------------------------------------------------------
% Dorian L. Linero S., Martín Estrada M. & Diego A. Garzón A.
% Universidad Nacional de Colombia
% Facultad de Ingeniería
% Todos los derechos reservados, 2020
%
% -------------------------------------------------------------------------
% Uso: 
%      PEFICA ADAT TLEC 
%      PEFICA("ADAT", "TLEC")
%
% Uso desde consola (terminal):
%      octave --eval 'PEFICA ADAT TLEC'
%      octave --eval 'PEFICA("ADAT", "TLEC")'
%
% ADAT: nombre del archivo de entrada de datos sin extensión
% TLEC: identificador de la opción de lectura de datos. Este es un parámetro
%       que por defecto es igual a 0.
% -------------------------------------------------------------------------

function PEFICA (ADAT,TLEC)
% ADAT: nombre del archivo de entrada de datos sin extensión
% TLEC: identificador de la opción de lectura de datos. Este es un parámetro
%       que por defecto es igual a 0.
% -------------------------------------------------------------------------
