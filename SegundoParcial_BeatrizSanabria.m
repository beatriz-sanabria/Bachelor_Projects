clear all
close all
clc

% %---------------------------------------------------------------------% %
% %....INSTITUTO TECNOL�GICO Y DE ESTUDIOS SUPERIORES DE MONTERREY......% %
% %....................CAMPUS CIUDAD DE M�XICO..........................% %
% %...........................INTEGRANTES:..............................% %
% %..............BEATRIZ SANABRIA BARRADAS - A01182649..................% %
% %.........................Examen Parcial 2............................% %
% %---------------------------------------------------------------------% %

%Procedimiento:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.- La evaluaci�n cuantitativa de la funci�n del coraz�n como bomba permite a  %
%los cardi�logos hacer un diagn�stico y pron�stico de la posible enfermedad que %
%un paciente pueda tener. Para ello, es importante contar una herramienta de    %
%procesamiento de im�genes que permita la segmentaci�n del borde epic�rdico     %
%(Verde) y endoc�rdico (rojo) como se ilustra en la figura 1.                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Proponga una soluci�n en Matlab para segmentar el borde del endocardio (rojo)  %
%de un conjunto de im�genes de Resonancia Magn�tica:                            %
%a) Despliegue los resultados para cada una de las im�genes.                    %
%b) Reporte en forma detallada la secuencia de pasos (algoritmo) del            %
%procesamiento de la imagen y sus resultados.                                   %
%c) Analice y discuta los par�metros �ptimos para la segmentaci�n de los        %
%bordes.                                                                        %
%d) Realice una conclusi�n general de sus resultados.                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Para leer muchas im�genes
imagen=dicomread('IM-0001-0001.dcm');%Cargo una imagen para saber su tama�o

d=dir('*.dcm');%dime todos los archivos que tienen la extensi�n dcm
tamano=length(d);%tama�o de todo el arreglo, cuantos archivos encontro con esa extensi�n
I=zeros(128,128,tamano,'uint16');%Vector para guardar todas las im�genes en una variable
Id=zeros(128,128,tamano,'double');%Vector para guardar las im�genes en tipo double para hacer el filtrado
Im=zeros(128,128,tamano,'double');%Vector para guardar m�scara 
If=zeros(128,128,tamano,'double');%Vector para guardar m�scara filtrada
Ifo=zeros(128,128,tamano,'double');%Vector para guardar im�genes filtradas

%Asigno todas las im�genes al vector I
for i=1:tamano
     imagentmp=dicomread(d(i).name);%leer el archivo y lo guardo en una variable
     I(:,:,i)=imagentmp;%Asigno el archivo a una sola estructura 
end

%Convierto todas las im�genes a tipo double para filtrarlas
for i=1:tamano
     Id(:,:,i)=im2double(I(:,:,i));
     Im(:,:,i)=Id(:,:,i);
end

%Creo una m�scara para localizar el epicardio y el endocardio
for i=1:tamano
    for j=1:47
        Im(j,:,i)=0;
    end
    
    for j=80:128
        Im(j,:,i)=0;
    end

    for j=1:55
        Im(:,j,i)=0;
    end

    for j=85:128
        Im(:,j,i)=0;
    end
end

for i=1:20
    for j=1:80
        Im(j,i,21)=0;
    end
end

for i=75:128
    Im(i,:,2)=0;
end

for i=1:tamano
    If(:,:,i) = edge(Im(:,:,i),'Canny');
    nivel = graythresh(If(:,:,i));
    Io_bw=im2bw(If(:,:,i),nivel);%Imagen en blanco y negro modificada
    If(:,:,i) = Io_bw;
end

%Cerrando imagen 2
If(63,76,2) = 1;
If(63,77,2) = 1;
If(63,78,2) = 1;
If(64,78,2) = 1;

%Cerrando imagen 10
If(57,66,10) = 1;
If(58,76,10) = 1;

%Cerrando imagen 11
If(64,76,11) = 1;

%Cerrando imagen 15
If(58,66,15) = 1;

%Cerrando imagen 18
If(58,73,18) = 1;
If(57,78,18) = 0;

%Cerrando imagen 19
If(55,66,19) = 1;

SE=strel('disk',2);

%Funci�n para rellenar estructuras
for i=1:tamano
    If2(:,:,i)=imfill(If(:,:,i),'holes');
end

%Se utiliza la siguiente funci�n para eliminar los elementos poco conectados
for i=1:tamano
    If2(:,:,i)=imopen(If2(:,:,i),SE);
end

%Liampiado imagen para tener solo el contorno
for i=1:tamano
    If2(:,:,i)=If2(:,:,i).*If(:,:,i);
end

%M�scara figura 1
for i=65:74
    for j=63:71
        If2(j,i,1)=0;
    end
end
If2(61,73,1)=0;
If2(61,74,1)=0;
If2(62,74,1)=0;

%M�scara figura 2
for i=64:74
    for j=64:69
        If2(j,i,2)=0;
    end
end
If2(64,78,2)=1;
If2(63,78,2)=1;
If2(63,77,2)=1;

%M�scara figura 3
for j=1:58
    If2(j,:,3)=0;
end

%M�scara figura 4
If2(66,66,4)=0;

%M�scara figura 6
for i=64:73
    for j=62:71
        If2(j,i,6)=0;
    end
end

%M�scara figura 7
for i=61:73
    for j=63:71
        If2(j,i,7)=0;
    end
end

%M�scara figura 8
for i=63:73
    for j=63:71
        If2(j,i,8)=0;
    end
end

%M�scara figura 9
for i=63:75
    for j=59:72
        If2(j,i,9)=0;
    end
end

%M�scara figura 10
for i=64:73
    for j=63:73
        If2(j,i,10)=0;
    end
end

%M�scara figura 11
If2(65,78,11)=1;
If2(64,78,11)=1;
If2(64,77,11)=1;
for i=65:69
    for j=64:69
        If2(j,i,11)=0;
    end
end

%M�scara figura 11
If2(65,78,11)=1;
If2(64,78,11)=1;
If2(64,77,11)=1;
for i=65:69
    for j=64:69
        If2(j,i,11)=0;
    end
end

%M�scara figura 15
If2(65,72,15)=0;
If2(66,72,15)=0;
If2(67,72,15)=0;
for i=65:71
    for j=62:71
        If2(j,i,15)=0;
    end
end

%M�scara figura 18
for i=63:73
    for j=60:73
        If2(j,i,18)=0;
    end
end

%M�scara figura 16
for i=62:73
    for j=61:70
        If2(j,i,16)=0;
    end
end

%M�scara figura 17
for i=64:72
    for j=64:70
        If2(j,i,17)=0;
    end
end

%M�scara figura 19
for i=64:75
    for j=60:71
        If2(j,i,19)=0;
    end
end

%M�scara figura 20
If2(63,77,20)=1;
for i=65:71
    for j=65:68
        If2(j,i,20)=0;
    end
end

%M�scara figura 21
If2(50,63,21)=0;
If2(66,66,21)=0;
If2(67,66,21)=0;
for i=55:62
    for j=48:61
        If2(j,i,21)=0;
    end
end

for i=1:tamano
    If3(:,:,i)=im2uint16(If2(:,:,i));
    Irgb(:,:,:,i)=ind2rgb(I(:,:,i),colormap);
end

close all

for i=1:tamano
    figure,imshow(I(:,:,i),[], 'InitialMag', 'fit');
    red= cat(3, ones(128,128), zeros(128,128), zeros(128,128));
    hold on
    h = imshow(red);
    hold off 
    set(h, 'AlphaData',If3(:,:,i));
end


