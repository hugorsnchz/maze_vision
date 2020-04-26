clear all
close all
clc

%% Conexión serial

global CommSerial
delete(instrfind({'Port'},{'COM3'}));
CommSerial = serial('COM3','BAUD',9600);
fopen(CommSerial);

%% Bucle

global camera
url = 'url aqui pls';
camera = ipcam(url);

[mapa, xm_p, ym_p] = vision_inicial();
[mapa_p] = a_star(mapa);
[FLAG] = control(mapa);

while FLAG == 1
    
    [mapa] = vision(xm_p, ym_p);
    [mapa_p] = a_star(mapa);
    [FLAG] = control(mapa);
    
end


disp('de puta madre')