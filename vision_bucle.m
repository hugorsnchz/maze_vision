function [row_bola, col_bola] = vision_bucle

global camera
imagen = snapshot(camera);
tamagno = 300;
imagen = imresize(imagen,[tamagno tamagno]);

imgdiff = imsubtract(imagen(:,:,1), rgb2gray(imagen));
imgdiff = medfilt2(imgdiff, [3 3]);
imgdiff = imbinarize(imgdiff,.25);
bw = bwlabel(imgdiff, 8);
data = regionprops(bw, 'BoundingBox', 'Centroid');
bb = data.BoundingBox;

row_bola = bb(1)+(bb(3)/2); % Posición central de la bola
col_bola = bb(2)+(bb(4)/2);
row_bola = row_bola/300*15; % Se adapta a matriz reducida
col_bola = col_bola/300*15;
col_bola = col_bola+0.5; % Se adapta al plot de imshow()
col_bola = col_bola+0.5;

imshow(~matriz_reducida,'InitialMagnification',10000)
plot(round(xm(1)),round(ym(1)),'g.','Markersize',60)
plot(xc,yc,'r.','Markersize',50)

%pause(0.01)

end