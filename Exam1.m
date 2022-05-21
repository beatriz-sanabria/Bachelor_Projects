clear all
close all
clc

% %---------------------------------------------------------------------% %
% %....INSTITUTO TECNOLÓGICO Y DE ESTUDIOS SUPERIORES DE MONTERREY......% %
% %....................CAMPUS CIUDAD DE MÉXICO..........................% %
% %...........................INTEGRANTES:..............................% %
% %..............BEATRIZ SANABRIA BARRADAS - A01182649..................% %
% %.........................Examen Parcial 1............................% %
% %---------------------------------------------------------------------% %

%Procedimiento:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.- Leer el art’culo de Automated Histogram-Based Brain Segmentation in T1-   %
%Weighted Three-Dimensional Magnetic Resonance Head Images” Zu YS et al,        %
%NeuroImage 17, 1587–1598 (2002);                                               %
%2.- Descargar el conjunto de im‡genes T1W de Resonancia magnŽtica              %
%disponibles en BB.                                                             %
%3.- Siguiendo el procedimiento del art’culo, para todas las im‡genes generar el%
%c—digo en Matlab que segmente la materia gris y remueva el cr‡neo y los        %
%tejidos subcraneales (hasta Žl inciso C de la figura 3).                       %
%4.- Describa en forma detallada la secuencia de pasos (algoritmos) del         %
%procesamiento de la imagen y sus resultados.                                   %
%5.- An‡lisis y discusión.                                                      %
%6.- Realice una conclusi—n general de sus resultados.                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Para leer muchas im‡genes
imagen=dicomread('IM-0001-0075.dcm');%Cargo una imagen para saber su tama–o

d=dir('*.dcm');%dime todos los archivos que tienen la extensi—n dcm
tamano=length(d);%tama–o de todo el arreglo, cuantos archivos encontr— con esa extensi—n
I=zeros(918,920,tamano,'uint8');%x y es el tama–o de cada una de las im‡genes, leer una imagen y vemos que tama–o tiene para sustituir los valores
IHE=zeros(918,920,tamano,'uint8');%Matriz para guardar im‡genes ecualizadas
B1=zeros(918,920,tamano,'uint8');%Matriz para guardar im‡genes despuŽs de eliminar el umbral de Otsu
M1=zeros(918,920,tamano,'uint8');%Matriz para guardar la m‡scara
B2=zeros(918,920,tamano,'uint8');%Matriz para guardar las im‡genes finales

for i=1:tamano
    imagentmp=rgb2gray(dicomread(d(i).name));%leer el archivo y lo guardo en una variable
    I(:,:,i)=imagentmp;%Asigno el archivo a una sola estructura 
end

%Ecualizar imágenes a una sola imagen
IE=I(:,:,60);%Imagen que se va a utilizar para ecualizar a las dem‡s
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
    
    ts = OtsuL + ((4/5)*(M-OtsuL));%Umbral ts para generar la primer m‡scara
    nivel = ts/255;
    M1(:,:,i)=im2bw(Io,nivel);%Imagen en blanco y negro modificada
    
    IM= M1(:,:,i);
    SE=strel('disk',3);
    M1(:,:,i)=imopen(IM,SE); %Se utiliza esta funci—n para eliminar los elementos poco conectados
end

%El siguiente ciclo se procesan las im‡genes para eliminar las adyacencias,
%cr‡neo y tejidos subcut‡neos, y conservar el cerebro.
%El an‡lisis de las im‡genes se realiz— dependiendo de sus necesidades, no
%se utiliz— el mismo procedimiento en todas.
%Las primeras y las úœltimas im‡genes que no contienen informaci—n
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
        M1(:,:,i)=imerode(IM,SE); %Se utiliza esta función para erosionar
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
        IM=imerode(IM,SE); %Se utiliza esta función para erosionar
        M1(:,:,i)=imopen(IM,SE); %Se utiliza esta función para erosionar
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

%Se hace la triple dilataci—n de las m‡scaras
for i=1:tamano
    IM= M1(:,:,i);
    SE=strel('disk',3);
    IM=imdilate(IM,SE); %Se utiliza esta funci—n para dilatar
    IM=imdilate(IM,SE); %Se utiliza esta funci—n para dilatar
    IM=imdilate(IM,SE); %Se utiliza esta funci—n para dilatar
    M1(:,:,i) = IM;
end

%Se hace la multiplicaci—n de las m‡scaras por las im‡genes ecualizadas y
%sin el umbral de Otsu
for i=1:tamano
    B2(:,:,i)=B1(:,:,i).*M1(:,:,i);
end

%Despliegue de las im‡genes
for i=1:144, imshow(I(:,:,i),[]), end %Im‡genes originales
for i=1:144, imshow(B1(:,:,i),[]), end %Im‡genes ecualizadas y sin umbral de Otsu
for i=1:144, imshow(M1(:,:,i),[]), end %M‡scaras
for i=1:144, imshow(B2(:,:,i),[]), end %Im‡genes finales

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
% title('Imagen de la m‡scara (M1) 5')
% subplot(2,2,2), imshow(M1(:,:,20),[])
% title('Imagen de la m‡scara (M1) 20')
% subplot(2,2,3), imshow(M1(:,:,97),[])
% title('Imagen de la m‡scara (M1) 97')
% subplot(2,2,4), imshow(M1(:,:,126),[])
% title('Imagen de la m‡scara (M1) 126')
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
