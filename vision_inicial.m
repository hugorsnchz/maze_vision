function [mapa, xm_p, ym_p] = vision_inicial()

global camera
imagen = snapshot(camera);
tamagno = 300;
imagen = imresize(imagen,[tamagno tamagno]);


%% Primera matriz binaria

matriz = imbinarize(imagen(:,:,1)); % Usa el canal rojo, donde la bola aparece también blanca.
matriz = double(~matriz); % Cambio 1-0

%% Transformación a matriz reducida

tamagno_reducida = 15;
matriz_reducida = zeros(tamagno_reducida,tamagno_reducida);
ratio=tamagno/tamagno_reducida;

k = ratio/2;
l = ratio/2;

for i = 1:tamagno_reducida
    for j = 1:tamagno_reducida
        if matriz(k,l) == 1
            matriz_reducida(i,j) = 1;
        elseif matriz(k,l) == 0
            matriz_reducida(i,j) = 0;
        end
        l = l+ratio;
    end
    l = ratio/2;
    k = k+ratio;
end

%% Plot inicial

figure(), daspect([1 1 1])
imshow(~matriz_reducida,'InitialMagnification',10000), hold on, axis on

%% Detección de bola roja

imgdiff = imsubtract(imagen(:,:,1), rgb2gray(imagen));
imgdiff = medfilt2(imgdiff, [3 3]);
imgdiff = imbinarize(imgdiff,.25);
bw = bwlabel(imgdiff, 8);
data = regionprops(bw, 'BoundingBox', 'Centroid');
bb = data.BoundingBox;

xc = bb(1)+(bb(3)/2); % Posición central de la bola
yc = bb(2)+(bb(4)/2);
xc = xc/300*15; % Se adapta a matriz reducida
yc = yc/300*15;
xc = xc+0.5; % Se adapta al plot de imshow()
yc = yc+0.5;

plot(xc,yc,'r.','Markersize',50)

%% Selección de la meta

[xm,ym] = getpts;
xm_p = round(xm(1));
ym_p = round(16-ym(1));

%% Creación de la matriz para planificación

yc = round(yc);
xc = round(xc);
matriz_plan = rot90(matriz_reducida,0);
matriz_plan(16-ym_p,xm_p) = 9; % Ajuste por imshow()
matriz_plan(yc,xc) = 3; % Ajuste por imshow()

mapa = matriz_plan;

end