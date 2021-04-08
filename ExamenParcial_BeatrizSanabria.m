clear all
close all
clc

% %---------------------------------------------------------------------% %
% %....INSTITUTO TECNOL”GICO Y DE ESTUDIOS SUPERIORES DE MONTERREY......% %
% %....................CAMPUS CIUDAD DE M…XICO..........................% %
% %...........................INTEGRANTES:..............................% %
% %..............BEATRIZ SANABRIA BARRADAS - A01182649..................% %
% %.........................Examen Parcial 1............................% %
% %---------------------------------------------------------------------% %

%Procedimiento:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.- Leer el artículo de Automated Histogram-Based Brain Segmentation in T1-   %
%Weighted Three-Dimensional Magnetic Resonance Head Imagesî Zu YS et al,        %
%NeuroImage 17, 1587ñ1598 (2002);                                               %
%2.- Descargar el conjunto de imágenes T1W de Resonancia magnética              %
%disponibles en BB.                                                             %
%3.- Siguiendo el procedimiento del artículo, para todas las imágenes generar el%
%código en Matlab que segmente la materia gris y remueva el cráneo y los        %
%tejidos subcraneales (hasta él inciso C de la figura 3).                       %
%4.- Describa en forma detallada la secuencia de pasos (algoritmos) del         %
%procesamiento de la imagen y sus resultados.                                   %
%5.- Análisis y discusiÛn.                                                      %
%6.- Realice una conclusión general de sus resultados.                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Para leer muchas imágenes
imagen=dicomread('IM-0001-0075.dcm');%Cargo una imagen para saber su tamaño

d=dir('*.dcm');%dime todos los archivos que tienen la extensión dcm
tamano=length(d);%tamaño de todo el arreglo, cuantos archivos encontró con esa extensión
I=zeros(918,920,tamano,'uint8');%x y es el tamaño de cada una de las imágenes, leer una imagen y vemos que tamaño tiene para sustituir los valores
IHE=zeros(918,920,tamano,'uint8');%Matriz para guardar imágenes ecualizadas
B1=zeros(918,920,tamano,'uint8');%Matriz para guardar imágenes después de eliminar el umbral de Otsu
M1=zeros(918,920,tamano,'uint8');%Matriz para guardar la máscara
B2=zeros(918,920,tamano,'uint8');%Matriz para guardar las imágenes finales

for i=1:tamano
    imagentmp=rgb2gray(dicomread(d(i).name));%leer el archivo y lo guardo en una variable
    I(:,:,i)=imagentmp;%Asigno el archivo a una sola estructura 
end

%Ecualizar im·genes a una sola imagen
IE=I(:,:,60);%Imagen que se va a utilizar para ecualizar a las demás
[y,x]=imhist(IE);
M=52.24;%Valor de la media del segundo pico estimado en la gaussiana para calcular ts

for i=1:tamano
    I1=I(:,:,i);
    [y,x]=imhist(IE);
    IHE(:,:,i)=histeq(I1,y);
    
    Io=IHE(:,:,i);%Variable para guardar imagen y calcular el umbral de Otsu
    OtsuL=graythresh(Io);
    idx=find(Io<=(OtsuL*255));%Para encontrar los pixeles que se encuentran abajo del umbral de OTSU
    Io(idx)=0;%pongo 0 a todo lo que esta abajo del umbral de Otsu
    B1(:,:,i)=Io;
    
    ts = OtsuL + ((4/5)*(M-OtsuL));%Umbral ts para generar la primer máscara
    nivel = ts/255;
    M1(:,:,i)=im2bw(Io,nivel);%Imagen en blanco y negro modificada
    
    IM= M1(:,:,i);
    SE=strel('disk',3);
    M1(:,:,i)=imopen(IM,SE); %Se utiliza esta función para eliminar los elementos poco conectados
end

%El siguiente ciclo se procesan las imágenes para eliminar las adyacencias,
%cráneo y tejidos subcutáneos, y conservar el cerebro.
%El análisis de las imágenes se realizó dependiendo de sus necesidades, no
%se utilizó el mismo procedimiento en todas.
%Las primeras y las ˙últimas imágenes que no contienen información
%relacionada con el cerebro fueron eliminadas.
for i=1:tamano
    if (i >= 18) && (i <= 19)
        for j=1:530
            M1(j,:,i)=0;
        end
        for j=710:918
            M1(j,:,i)=0;
        end
        for j=1:275
            M1(:,j,i)=0;
        end
        for j=670:920
            M1(:,j,i)=0;
        end
        ME=M1(:,:,i);
        CC = bwconncomp(ME);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [biggest,idx] = max(numPixels);
        id=idx;
        numPixels(1,idx)=0;
        [biggest,idx] = max(numPixels);
        id1=idx;
        num=size(numPixels,2);
        for k=1:num
            idx=k;
            if (id ~= idx) && (id1 ~= idx)
                ME(CC.PixelIdxList{idx}) = 0;
                M1(:,:,i)=ME;
            end
        end
  
    elseif (i >= 20) && (i <= 28)
        for j=1:507
            M1(j,:,i)=0;
        end
        for j=730:918
            M1(j,:,i)=0;
        end
        for j=1:275
            M1(:,j,i)=0;
        end
        for j=670:920
            M1(:,j,i)=0;
        end
        ME=M1(:,:,i);
        CC = bwconncomp(ME);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [biggest,idx] = max(numPixels);
        id=idx;
        numPixels(1,idx)=0;
        [biggest,idx] = max(numPixels);
        id1=idx;
        num=size(numPixels,2);
        for k=1:num
            idx=k;
            if (id ~= idx) && (id1 ~= idx)
                ME(CC.PixelIdxList{idx}) = 0;
                M1(:,:,i)=ME;
            end
        end
        
    elseif (i >= 29) && (i <= 40)
        for j=1:507
            M1(j,:,i)=0;
        end
        ME=M1(:,:,i);
        CC = bwconncomp(ME);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [biggest,idx] = max(numPixels);
        id=idx;
        num=size(numPixels,2);
        for k=1:num
            idx=k;
            if id ~= idx 
                ME(CC.PixelIdxList{idx}) = 0;
                M1(:,:,i)=ME;
            end
        end
        
    elseif (i >= 41) && (i <= 44)
        for j=1:370
            M1(j,:,i)=0;
        end
        IM= M1(:,:,i);
        SE=strel('disk',4);
        M1(:,:,i)=imerode(IM,SE); %Se utiliza esta funciÛn para erosionar
        ME=M1(:,:,i);
        CC = bwconncomp(ME);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [biggest,idx] = max(numPixels);
        id=idx;
        num=size(numPixels,2);
        for k=1:num
            idx=k;
            if id ~= idx 
                ME(CC.PixelIdxList{idx}) = 0;
                M1(:,:,i)=ME;
            end
        end
        
    elseif (i >= 45) && (i <= 97)
        IM= M1(:,:,i);
        SE=strel('disk',4);
        IM=imerode(IM,SE); %Se utiliza esta funciÛn para erosionar
        M1(:,:,i)=imopen(IM,SE); %Se utiliza esta funciÛn para erosionar
        ME=M1(:,:,i);
        CC = bwconncomp(ME);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [biggest,idx] = max(numPixels);
        id=idx;
        num=size(numPixels,2);
        for k=1:num
            idx=k;
            if id ~= idx 
                ME(CC.PixelIdxList{idx}) = 0;
                M1(:,:,i)=ME;
            end
        end
    
    elseif (i == 98)  
        ME=M1(:,:,i);
        CC = bwconncomp(ME);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [biggest,idx] = max(numPixels);
        id=idx;
        num=size(numPixels,2);
        for k=1:num
            idx=k;
            if (id ~= idx) 
                ME(CC.PixelIdxList{idx}) = 0;
                M1(:,:,i)=ME;
            end
        end
        
    elseif (i >= 99) && (i <= 108)
        ME=M1(:,:,i);
        CC = bwconncomp(ME);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [biggest,idx] = max(numPixels);
        id=idx;
        numPixels(1,idx)=0;
        [biggest,idx] = max(numPixels);
        id1=idx;
        num=size(numPixels,2);
        for k=1:num
            idx=k;
            if (id ~= idx) && (id1 ~= idx)
                ME(CC.PixelIdxList{idx}) = 0;
                M1(:,:,i)=ME;
            end
        end
        
    elseif (i == 109) 
       ME=M1(:,:,i);
       CC = bwconncomp(ME);
       numPixels = cellfun(@numel,CC.PixelIdxList);
       [biggest,idx] = max(numPixels);
       id=idx;
       numPixels(1,idx)=0;
       [biggest,idx] = max(numPixels);
       numPixels(1,idx)=0;
       [biggest,idx] = max(numPixels);
       id1=idx;
       num=size(numPixels,2);
       for k=1:num
           idx=k;
           if (id ~= idx) && (id1 ~= idx)
               ME(CC.PixelIdxList{idx}) = 0;
               M1(:,:,i)=ME;
           end
       end
        
    elseif (i >= 110) && (i <= 112)
        ME=M1(:,:,i);
        CC = bwconncomp(ME);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [biggest,idx] = max(numPixels);
        ME(CC.PixelIdxList{idx}) = 0;
        numPixels(1,idx)=0;
        [biggest,idx] = max(numPixels);
        id=idx;
        numPixels(1,idx)=0;
        [biggest,idx] = max(numPixels);
        id1=idx;
        num=size(numPixels,2);
        for k=1:num
            idx=k;
            if (id ~= idx) && (id1 ~= idx)
                ME(CC.PixelIdxList{idx}) = 0;
                M1(:,:,i)=ME;
            end
        end
        
    elseif (i >= 113) && (i <= 118)
        ME=M1(:,:,i);
        CC = bwconncomp(ME);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [biggest,idx] = max(numPixels);
        ME(CC.PixelIdxList{idx}) = 0;
        M1(:,:,i)=ME;
        
    else
        M1(:,:,i)=0;
    end
end

%Se hace la triple dilatación de las máscaras
for i=1:tamano
    IM= M1(:,:,i);
    SE=strel('disk',3);
    IM=imdilate(IM,SE); %Se utiliza esta función para dilatar
    IM=imdilate(IM,SE); %Se utiliza esta función para dilatar
    IM=imdilate(IM,SE); %Se utiliza esta función para dilatar
    M1(:,:,i) = IM;
end

%Se hace la multiplicación de las máscaras por las imágenes ecualizadas y
%sin el umbral de Otsu
for i=1:tamano
    B2(:,:,i)=B1(:,:,i).*M1(:,:,i);
end

%Despliegue de las imágenes
for i=1:144, imshow(I(:,:,i),[]), end %Imágenes originales
for i=1:144, imshow(B1(:,:,i),[]), end %Imágenes ecualizadas y sin umbral de Otsu
for i=1:144, imshow(M1(:,:,i),[]), end %Máscaras
for i=1:144, imshow(B2(:,:,i),[]), end %Imágenes finales

% subplot(2,2,1), imshow(I(:,:,5),[])
% title('Imagen original 5')
% subplot(2,2,2), imshow(I(:,:,20),[])
% title('Imagen original 20')
% subplot(2,2,3), imshow(I(:,:,97),[])
% title('Imagen original 97')
% subplot(2,2,4), imshow(I(:,:,126),[])
% title('Imagen original 126')
% 
% figure()
% subplot(2,2,1), imshow(IHE(:,:,5),[])
% title('Imagen ecualizada 5')
% subplot(2,2,2), imshow(IHE(:,:,20),[])
% title('Imagen ecualizada 20')
% subplot(2,2,3), imshow(IHE(:,:,97),[])
% title('Imagen ecualizada 97')
% subplot(2,2,4), imshow(IHE(:,:,126),[])
% title('Imagen ecualizada 126')
% 
% figure()
% subplot(2,2,1), imshow(B1(:,:,5),[])
% title('Imagen B1 5')
% subplot(2,2,2), imshow(B1(:,:,20),[])
% title('Imagen B1 20')
% subplot(2,2,3), imshow(B1(:,:,97),[])
% title('Imagen B1 97')
% subplot(2,2,4), imshow(B1(:,:,126),[])
% title('Imagen B1 126')
% 
% figure()
% subplot(2,2,1), imshow(M1(:,:,5),[])
% title('Imagen de la máscara (M1) 5')
% subplot(2,2,2), imshow(M1(:,:,20),[])
% title('Imagen de la máscara (M1) 20')
% subplot(2,2,3), imshow(M1(:,:,97),[])
% title('Imagen de la máscara (M1) 97')
% subplot(2,2,4), imshow(M1(:,:,126),[])
% title('Imagen de la máscara (M1) 126')
% 
% figure()
% subplot(2,2,1), imshow(B2(:,:,5),[])
% title('Imagen final (B2) 5')
% subplot(2,2,2), imshow(B2(:,:,20),[])
% title('Imagen final (B2) 20')
% subplot(2,2,3), imshow(B2(:,:,97),[])
% title('Imagen final (B2) 97')
% subplot(2,2,4), imshow(B2(:,:,126),[])
% title('Imagen final (B2) 126')
% 
