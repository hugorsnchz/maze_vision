function [flag] = control(mapa)

global CommSerial
flag = 0;
mapa_actualizado = mapa;

%% Nodo inicial y goal

[i,j]= find(mapa==3);
row_bola=i;
col_bola=j;

[i,j]= find(mapa==9);
row_meta=i;
col_meta=j;

%% Inicialización de la posición estable

x = 832;
y = 931;
x_min = x + 30;
x_max = x - 30;
y_min = y - 40; %jumsito
y_max = y + 30;

%% Control (movimiento inicial)

fprintf(CommSerial,'%f',[x,y]); %'%f,%f,%f,%f' % Envía a la posición incial (home, estable)

if (mapa_actualizado(row_bola,col_bola+1)==5 || mapa_actualizado(row_bola,col_bola+1)==9)
    
    col_siguiente=col_bola+1;
    row_siguiente=row_bola;
    
    while (col_siguiente+1==5 || col_siguiente+1==9)
        mapa_actualizado(row_siguiente,col_siguiente)=0;
        col_siguiente=col_siguiente+1;
    end  
    
    fprintf(CommSerial,'%f',[x_max,y]); %'%f,%f,%f,%f'
    %ponle que se incline hacia la derecha que no me acuerdo de
    %que servo movía cada eje
    
elseif (mapa_actualizado(row_bola-1,col_bola)==5 || mapa_actualizado(row_bola-1,col_bola)==9)
    
    col_siguiente=col_bola;
    row_siguiente=row_bola-1;
    
    while (row_siguiente-1==5 || row_siguiente-1==9)
        mapa_actualizado(row_siguiente,col_siguiente)=0;
        row_siguiente=row_siguiente-1;
    end
    
    fprintf(CommSerial,'%f',[x,y_max]); %'%f,%f,%f,%f'
    %ponle que se incline hacia arriba
    
elseif (mapa_actualizado(row_bola,col_bola-1)==5 || mapa_actualizado(row_bola,col_bola-1)==9)
    
    col_siguiente=col_bola-1;
    row_siguiente=row_bola;
    
    while (col_siguiente-1==5 || col_siguiente-1==9)
        mapa_actualizado(row_siguiente,col_siguiente)=0;
        col_siguiente=col_siguiente-1;
    end
    
    fprintf(CommSerial,'%f',[x_min,y]); %'%f,%f,%f,%f'
    %ponle que se incline hacia la izquierda
    
elseif (mapa_actualizado(row_bola+1,col_bola)==5 || mapa_actualizado(row_bola+1,col_bola)==9)
    
    col_siguiente=col_bola;
    row_siguiente=row_bola+1;
    
    while (row_siguiente+1==5 || row_siguiente+1==9)
        mapa_actualizado(row_siguiente,col_siguiente)=0;
        row_siguiente=row_siguiente+1;
    end
    
    fprintf(CommSerial,'%f',[x,y_min]); %'%f,%f,%f,%f'
    %ponle que se incline hacia abajo
end

%% Bucle de control

while (row_bola~=row_meta || col_bola~=col_meta)
    
    while(row_bola~=row_siguiente || col_bola~=col_siguiente) %poner de condicion que si se ha replanificado se salte este while (mirar donde poner a 0 la variable replanificado)
        [row_bola, col_bola] = vision_bucle;
    end
    
    mapa_actualizado(row_bola,col_bola)=0;
    
    %ponle que se estabilice en HOME
    fprintf(CommSerial,'%f',[921 832]); %'%f,%f,%f,%f'
    %pause(t)
    
    if (mapa_actualizado(row_bola,col_bola+1)==5 || mapa_actualizado(row_bola,col_bola+1)==9)
        
        col_siguiente=col_bola+1;
        row_siguiente=row_bola;
        
        while (col_siguiente+1==5 || col_siguiente+1==9)
            mapa_actualizado(row_siguiente,col_siguiente)=0;
            col_siguiente=col_siguiente+1;
        end
        
        fprintf(CommSerial,'%f',[x_max,y]); %'%f,%f,%f,%f'
        %ponle que se incline hacia la derecha que no me acuerdo de
        %que servo movía cada eje
        
    elseif (mapa_actualizado(row_bola-1,col_bola)==5 || mapa_actualizado(row_bola-1,col_bola)==9)
        
        col_siguiente=col_bola;
        row_siguiente=row_bola-1;
        
        while (row_siguiente-1==5 || row_siguiente-1==9)
            mapa_actualizado(row_siguiente,col_siguiente)=0;
            row_siguiente=row_siguiente-1;
        end
        
        fprintf(CommSerial,'%f',[x,y_max]); %'%f,%f,%f,%f'
        %ponle que se incline hacia arriba
        
    elseif (mapa_actualizado(row_bola,col_bola-1)==5 || mapa_actualizado(row_bola,col_bola-1)==9)
        
        col_siguiente=col_bola-1;
        row_siguiente=row_bola;
        
        while (col_siguiente-1==5 || col_siguiente-1==9)
            mapa_actualizado(row_siguiente,col_siguiente)=0;
            col_siguiente=col_siguiente-1;
        end
        
        fprintf(CommSerial,'%f',[x_min,y]); %'%f,%f,%f,%f'
        %ponle que se incline hacia la izquierda
        
    elseif (mapa_actualizado(row_bola+1,col_bola)==5 || mapa_actualizado(row_bola+1,col_bola)==9)
        
        col_siguiente=col_bola;
        row_siguiente=row_bola+1;
        
        while (row_siguiente+1==5 || row_siguiente+1==9)
            mapa_actualizado(row_siguiente,col_siguiente)=0;
            row_siguiente=row_siguiente+1;
        end
        
        fprintf(CommSerial,'%f',[x,y_min]); %'%f,%f,%f,%f'
        %ponle que se incline hacia abajo
        
    else
        
        flag = 1;
        return
        
    end
end

fprintf(CommSerial,'%f',[921 832]);

end