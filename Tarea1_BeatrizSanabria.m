clear all
close all
clc

% %---------------------------------------------------------------------% %
% %....INSTITUTO TECNOL�GICO Y DE ESTUDIOS SUPERIORES DE MONTERREY......% %
% %....................CAMPUS CIUDAD DE M�XICO..........................% %
% %...........................INTEGRANTES:..............................% %
% %..............BEATRIZ SANABRIA BARRADAS - A01182649..................% %
% %..............................Tarea 1................................% %
% %---------------------------------------------------------------------% %

%Instrucciones:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.- Determinar el �rea efectiva de las im�genes de la pr�tesis valvular ( video%
%disponible en BlackBoard) proponiendo una secuencia de pasos estructurada y    %
%reproducible para tal fin.                                                     % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load imagen;%Cargo el video a una variable

for i=1:22, subplot(6,4,i),imshow(I(:,:,i)), end %graficar todas las im�genes
Io=I(:,:,18); %Imagen de la v�lvula 18
I1=I(:,:,4); %Imagen de la v�lvula 4
I2=I(:,:,7); %Imagen de la v�lvula 7
I3=I(:,:,11); %Imagen de la v�lvula 11
I4=I(:,:,15); %Imagen de la v�lvula 15

%%%%%%%%%%%%%%%%%%%%%%%%%
%An�lisis par v�lvula 18%
%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name', 'V�lvula 18')
subplot(1,2,1),imshow(Io) %Imagen original
title('Imagen original') 
subplot(1,2,2),imhist(Io) %Histograma de la imagen original
title('Histograma')

nivel = graythresh(Io);%Funci�n que nos permite calcular el valor que nos va 
%a definir a partir de donde van a ser 1s y 0s
Io_bw=im2bw(Io,nivel);%Imagen en blanco y negro modificada

figure('Name', 'Procesamiento de imagen: V�lvula 18')
subplot(2,3,1),imshow(Io) %Imagen original
title('Imagen original')
subplot(2,3,2),imshow(Io_bw) %Imagen en blanco y negro
title('Imagen b/n')

SE=strel('disk',5);
Io1=imopen(Io_bw,SE); %Se utiliza esta funci�n para eliminar los elementos poco conectados
subplot(2,3,3),imshow(Io1);
title('Apertura')

SE=strel('square',4);
Io1=imclose(Io1,SE); %Se utiliza esta funci�n para asociar los elementos que se desconectaron en el procedimiento anterior
subplot(2,3,4), imshow(Io1)
title('Cierre')

SE=strel('square',4);
Io1=imerode(Io1,SE); %Se erosiona la imagen para eliminar elementos del borde valvular
subplot(2,3,5), imshow(Io1)
title('Erosi�n')

cont=0;%Contador para saber cu�ntos pixeles corresponden al contorno
%Los siguientes FOR anidados nos sirven para contar cu�ntos pixeles se
%encuentran en 1 y por lo tanto conocer el �rea del contorno valvular

k=1;%Variable para guardar posici�n

for i=1:480
    for j=1:640
        valor = Io1(i,j);
        if valor == 1
            cont=cont+1;
            x(k)=i;
            y(k)=j;
            k=k+1;
        end
    end
end

IoF=imfill(Io1,'holes'); %Funci�n para rellenar la estructura de la v�lvula y conocer su �rea
IoF_RGB=ind2rgb(Io1,colormap);%Convierto mi imagen a RGB

cont2=0;%Contador para saber cu�ntos pixeles corresponden al �rea valvular
%Los siguientes FOR anidados nos sirven para contar cu�ntos pixeles se
%encuentran en 1 y por lo tanto conocer el �rea valvular
k=1;
for i=1:480
    for j=1:640
        valor = IoF(i,j);
        if valor == 1
            cont2=cont2+1;
            x1(k)=i;
            y1(k)=j;
            k=k+1;
        end
    end
end

%Los siguientes FOR se est�n utilizando para pintar el contorno rojo de la
%v�lvula y el �rea efectiva
for i=1:95136
    IoF_RGB(x1(i),y1(i),1)=255;
    IoF_RGB(x1(i),y1(i),2)=255;
    IoF_RGB(x1(i),y1(i),3)=255;
end

for i=1:21625
    IoF_RGB(x(i),y(i),1)=255;
    IoF_RGB(x(i),y(i),2)=0;
    IoF_RGB(x(i),y(i),3)=0;
end
subplot(2,3,6), imshow(IoF_RGB)
title('Imagen rellena')

area18 = cont2 - cont; %Se restan el total de pixeles en 1 en la imagen rellena menos los del contorno 
%para conocer el �rea efectiva de la v�lvula

%%%%%%%%%%%%%%%%%%%%%%%%%
%An�lisis par v�lvula 4%
%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name', 'V�lvula 4')
subplot(1,2,1),imshow(I1) %Imagen original
title('Imagen original') 
subplot(1,2,2),imhist(I1) %Histograma de la imagen original
title('Histograma')

nivel = graythresh(I1);%Funci�n que nos permite calcular el valor que nos va 
%a definir a partir de donde van a ser 1s y 0s
Io_bw=im2bw(I1,nivel);%Imagen en blanco y negro modificada

figure('Name', 'Procesamiento de imagen: V�lvula 4')
subplot(2,3,1),imshow(I1) %Imagen original
title('Imagen original')
subplot(2,3,2),imshow(Io_bw) %Imagen en blanco y negro
title('Imagen b/n')

SE=strel('disk',5);
Io1=imopen(Io_bw,SE); %Se utiliza esta funci�n para eliminar los elementos poco conectados
subplot(2,3,3),imshow(Io1);
title('Apertura')

SE=strel('square',4);
Io1=imclose(Io1,SE); %Se utiliza esta funci�n para asociar los elementos que se desconectaron en el procedimiento anterior
subplot(2,3,4), imshow(Io1)
title('Cierre')

SE=strel('square',4);
Io1=imerode(Io1,SE); %Se erosiona la imagen para eliminar elementos del borde valvular
subplot(2,3,5), imshow(Io1)
title('Erosi�n')

cont=0;%Contador para saber cu�ntos pixeles corresponden al contorno
%Los siguientes FOR anidados nos sirven para contar cu�ntos pixeles se
%encuentran en 1 y por lo tanto conocer el �rea del contorno valvular

k=1;

for i=1:480
    for j=1:640
        valor = Io1(i,j);
        if valor == 1
            cont=cont+1;
            x(k)=i;
            y(k)=j;
            k=k+1;
        end
    end
end

IoF=imfill(Io1,'holes'); %Funci�n para rellenar la estructura de la v�lvula y conocer su �rea
IoF_RGB=ind2rgb(Io1,colormap);

cont2=0;%Contador para saber cu�ntos pixeles corresponden al �rea valvular
%Los siguientes FOR anidados nos sirven para contar cu�ntos pixeles se
%encuentran en 1 y por lo tanto conocer el �rea valvular
k=1;
for i=1:480
    for j=1:640
        valor = IoF(i,j);
        if valor == 1
            cont2=cont2+1;
            x1(k)=i;
            y1(k)=j;
            k=k+1;
        end
    end
end

for i=1:95136
    IoF_RGB(x1(i),y1(i),1)=255;
    IoF_RGB(x1(i),y1(i),2)=255;
    IoF_RGB(x1(i),y1(i),3)=255;
end

for i=1:22973
    IoF_RGB(x(i),y(i),1)=255;
    IoF_RGB(x(i),y(i),2)=0;
    IoF_RGB(x(i),y(i),3)=0;
end
subplot(2,3,6), imshow(IoF_RGB)
title('Imagen rellena')

area4 = cont2 - cont; %Se restan el total de pixeles en 1 en la imagen rellena menos los del contorno 
%para conocer el �rea efectiva de la v�lvula

%%%%%%%%%%%%%%%%%%%%%%%%%
%An�lisis par v�lvula 7%
%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name', 'V�lvula 7')
subplot(1,2,1),imshow(I2) %Imagen original
title('Imagen original') 
subplot(1,2,2),imhist(I2) %Histograma de la imagen original
title('Histograma')

nivel = graythresh(I2);%Funci�n que nos permite calcular el valor que nos va 
%a definir a partir de donde van a ser 1s y 0s
Io_bw=im2bw(I2,nivel);%Imagen en blanco y negro modificada

figure('Name', 'Procesamiento de imagen: V�lvula 7')
subplot(2,3,1),imshow(I2) %Imagen original
title('Imagen original')
subplot(2,3,2),imshow(Io_bw) %Imagen en blanco y negro
title('Imagen b/n')

SE=strel('disk',5);
Io1=imopen(Io_bw,SE); %Se utiliza esta funci�n para eliminar los elementos poco conectados
subplot(2,3,3),imshow(Io1);
title('Apertura')

SE=strel('square',4);
Io1=imclose(Io1,SE); %Se utiliza esta funci�n para asociar los elementos que se desconectaron en el procedimiento anterior
subplot(2,3,4), imshow(Io1)
title('Cierre')

SE=strel('square',4);
Io1=imerode(Io1,SE); %Se erosiona la imagen para eliminar elementos del borde valvular
subplot(2,3,5), imshow(Io1)
title('Erosi�n')

cont=0;%Contador para saber cu�ntos pixeles corresponden al contorno
%Los siguientes FOR anidados nos sirven para contar cu�ntos pixeles se
%encuentran en 1 y por lo tanto conocer el �rea del contorno valvular
k=1;

for i=1:480
    for j=1:640
        valor = Io1(i,j);
        if valor == 1
            cont=cont+1;
            x(k)=i;
            y(k)=j;
            k=k+1;
        end
    end
end

IoF=imfill(Io1,'holes'); %Funci�n para rellenar la estructura de la v�lvula y conocer su �rea
IoF_RGB=ind2rgb(Io1,colormap);

cont2=0;%Contador para saber cu�ntos pixeles corresponden al �rea valvular
%Los siguientes FOR anidados nos sirven para contar cu�ntos pixeles se
%encuentran en 1 y por lo tanto conocer el �rea valvular
k=1;
for i=1:480
    for j=1:640
        valor = IoF(i,j);
        if valor == 1
            cont2=cont2+1;
            x1(k)=i;
            y1(k)=j;
            k=k+1;
        end
    end
end

for i=1:95808
    IoF_RGB(x1(i),y1(i),1)=255;
    IoF_RGB(x1(i),y1(i),2)=255;
    IoF_RGB(x1(i),y1(i),3)=255;
end

for i=1:22973
    IoF_RGB(x(i),y(i),1)=255;
    IoF_RGB(x(i),y(i),2)=0;
    IoF_RGB(x(i),y(i),3)=0;
end
subplot(2,3,6), imshow(IoF_RGB)
title('Imagen rellena')

area7 = cont2 - cont; %Se restan el total de pixeles en 1 en la imagen rellena menos los del contorno 
%para conocer el �rea efectiva de la v�lvula

%%%%%%%%%%%%%%%%%%%%%%%%%
%An�lisis par v�lvula 11%
%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name', 'V�lvula 11')
subplot(1,2,1),imshow(I3) %Imagen original
title('Imagen original') 
subplot(1,2,2),imhist(I3) %Histograma de la imagen original
title('Histograma')

nivel = graythresh(I3);%Funci�n que nos permite calcular el valor que nos va 
%a definir a partir de donde van a ser 1s y 0s
Io_bw=im2bw(I3,nivel);%Imagen en blanco y negro modificada

figure('Name', 'Procesamiento de imagen: V�lvula 11')
subplot(2,3,1),imshow(I3) %Imagen original
title('Imagen original')
subplot(2,3,2),imshow(Io_bw) %Imagen en blanco y negro
title('Imagen b/n')

SE=strel('disk',5);
Io1=imopen(Io_bw,SE); %Se utiliza esta funci�n para eliminar los elementos poco conectados
subplot(2,3,3),imshow(Io1);
title('Apertura')

SE=strel('square',5);
Io1=imclose(Io1,SE); %Se utiliza esta funci�n para asociar los elementos que se desconectaron en el procedimiento anterior
subplot(2,3,4), imshow(Io1)
title('Cierre')

SE=strel('square',2);
Io1=imerode(Io1,SE); %Se erosiona la imagen para eliminar elementos del borde valvular
subplot(2,3,5), imshow(Io1)
title('Erosi�n')

cont=0;%Contador para saber cu�ntos pixeles corresponden al contorno
%Los siguientes FOR anidados nos sirven para contar cu�ntos pixeles se
%encuentran en 1 y por lo tanto conocer el �rea del contorno valvular
k=1;

for i=1:480
    for j=1:640
        valor = Io1(i,j);
        if valor == 1
            cont=cont+1;
            x(k)=i;
            y(k)=j;
            k=k+1;
        end
    end
end

IoF=imfill(Io1,'holes'); %Funci�n para rellenar la estructura de la v�lvula y conocer su �rea
IoF_RGB=ind2rgb(Io1,colormap);

cont2=0;%Contador para saber cu�ntos pixeles corresponden al �rea valvular
%Los siguientes FOR anidados nos sirven para contar cu�ntos pixeles se
%encuentran en 1 y por lo tanto conocer el �rea valvular
k=1;
for i=1:480
    for j=1:640
        valor = IoF(i,j);
        if valor == 1
            cont2=cont2+1;
            x1(k)=i;
            y1(k)=j;
            k=k+1;
        end
    end
end

for i=1:92637
    IoF_RGB(x1(i),y1(i),1)=255;
    IoF_RGB(x1(i),y1(i),2)=255;
    IoF_RGB(x1(i),y1(i),3)=255;
end

for i=1:25234
    IoF_RGB(x(i),y(i),1)=255;
    IoF_RGB(x(i),y(i),2)=0;
    IoF_RGB(x(i),y(i),3)=0;
end
subplot(2,3,6), imshow(IoF_RGB)
title('Imagen rellena')

area11 = cont2 - cont; %Se restan el total de pixeles en 1 en la imagen rellena menos los del contorno 
%para conocer el �rea efectiva de la v�lvula

%%%%%%%%%%%%%%%%%%%%%%%%%
%An�lisis par v�lvula 15%
%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name', 'V�lvula 15')
subplot(1,2,1),imshow(I4) %Imagen original
title('Imagen original') 
subplot(1,2,2),imhist(I4) %Histograma de la imagen original
title('Histograma')

nivel = graythresh(I4);%Funci�n que nos permite calcular el valor que nos va 
%a definir a partir de donde van a ser 1s y 0s
Io_bw=im2bw(I3,nivel);%Imagen en blanco y negro modificada

figure('Name', 'Procesamiento de imagen: V�lvula 15')
subplot(2,3,1),imshow(I4) %Imagen original
title('Imagen original')
subplot(2,3,2),imshow(Io_bw) %Imagen en blanco y negro
title('Imagen b/n')

SE=strel('disk',5);
Io1=imopen(Io_bw,SE); %Se utiliza esta funci�n para eliminar los elementos poco conectados
subplot(2,3,3),imshow(Io1);
title('Apertura')

SE=strel('square',5);
Io1=imclose(Io1,SE); %Se utiliza esta funci�n para asociar los elementos que se desconectaron en el procedimiento anterior
subplot(2,3,4), imshow(Io1)
title('Cierre')

SE=strel('square',2);
Io1=imerode(Io1,SE); %Se erosiona la imagen para eliminar elementos del borde valvular
subplot(2,3,5), imshow(Io1)
title('Erosi�n')

cont=0;%Contador para saber cu�ntos pixeles corresponden al contorno
%Los siguientes FOR anidados nos sirven para contar cu�ntos pixeles se
%encuentran en 1 y por lo tanto conocer el �rea del contorno valvular
k=1;

for i=1:480
    for j=1:640
        valor = Io1(i,j);
        if valor == 1
            cont=cont+1;
            x(k)=i;
            y(k)=j;
            k=k+1;
        end
    end
end

IoF=imfill(Io1,'holes'); %Funci�n para rellenar la estructura de la v�lvula y conocer su �rea
IoF_RGB=ind2rgb(Io1,colormap);

cont2=0;%Contador para saber cu�ntos pixeles corresponden al �rea valvular
%Los siguientes FOR anidados nos sirven para contar cu�ntos pixeles se
%encuentran en 1 y por lo tanto conocer el �rea valvular
k=1;
for i=1:480
    for j=1:640
        valor = IoF(i,j);
        if valor == 1
            cont2=cont2+1;
            x1(k)=i;
            y1(k)=j;
            k=k+1;
        end
    end
end

for i=1:92637
    IoF_RGB(x1(i),y1(i),1)=255;
    IoF_RGB(x1(i),y1(i),2)=255;
    IoF_RGB(x1(i),y1(i),3)=255;
end

for i=1:25234
    IoF_RGB(x(i),y(i),1)=255;
    IoF_RGB(x(i),y(i),2)=0;
    IoF_RGB(x(i),y(i),3)=0;
end
subplot(2,3,6), imshow(IoF_RGB)
title('Imagen rellena')

area15 = cont2 - cont; %Se restan el total de pixeles en 1 en la imagen rellena menos los del contorno 
%para conocer el �rea efectiva de la v�lvula

nombres={'4','7','11','15','18'};
figure ('Name','�reas valvulares m�ximas')
bar([area4 area7 area11 area15 area18]);
set(gca,'XtickLabel',nombres)
ylabel('Pixeles')
xlabel('V�lvulas')
title ('�reas valvulares m�ximas')

