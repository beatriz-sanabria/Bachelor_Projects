close all
clear all
clc

% %---------------------------------------------------------------------% %
% %....INSTITUTO TECNOLÓGICO Y DE ESTUDIOS SUPERIORES DE MONTERREY......% %
% %....................CAMPUS CIUDAD DE MÉXICO..........................% %
% %...........................INTEGRANTES:..............................% %
% %..............BEATRIZ SANABRIA BARRADAS - A01182649..................% %
% %..............................Tarea 2................................% %
% %---------------------------------------------------------------------% %

%Instrucciones:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FILTRADO ESPACIAL: Con la serie de imágenes de Cardio Resonancia Magnética, resalte%
%los bordes y muestre los resultados para todos los frames del estudio.             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I = dicomread('Cardio_RM.dcm');%Cargo el video a una variable
I=squeeze(I); 
figure('Name', 'Imágenes originales'), for i=1:30, subplot(6,5,i), imshow(I(:,:,i),[]); end;

Id = im2double(I(:,:,3));%convierto la imagen original a tipo double
Idd= I(:,:,3);
%Laplaciano
f = fspecial('laplacian',1);
If = imfilter(Id,f);
If = im2uint16(If);
IR = imsubtract(Idd,If);
figure, subplot(2,2,1), imshow(Id,[]), title('Imagen Original');
subplot(2,2,2), imshow(If,[]), title('Laplaciano Original');
subplot(2,2,3), imshow(IR,[]), title('Bordes Resaltados');

%Kernel 1
k1 = [0 1 0; 1 -4 1; 0 1 0];
If1 = imfilter(Id,k1,'same');
If1 = im2uint16(If1);
IR1 = imsubtract(Idd,If1);
figure, subplot(2,2,1), imshow(Id,[]), title('Imagen Original');
subplot(2,2,2), imshow(If1,[]), title('Imagen con Kernel 1');
subplot(2,2,3), imshow(IR1,[]), title('Bordes resaltados');

%Kernel 2
k2=[1 1 1; 1 -8 1; 1 1 1];
If2 = imfilter(Id,k2,'same');
If2 = im2uint16(If2);
IR2 = imsubtract(Idd,If2);
figure, subplot(2,2,1), imshow(Id,[]), title('Imagen Original');
subplot(2,2,2), imshow(If2,[]), title('Imagen con Kernel 2');
subplot(2,2,3), imshow(IR2,[]), title('Bordes resaltados');

%Kernel 3
k3=[0 -1 0; -1 5 -1; 0 -1 0];
If3 = imfilter(Id,k3,'same');
If3 = im2uint16(If3);
IR3 = imsubtract(Idd,If3);
figure, subplot(2,2,1), imshow(Id,[]), title('Imagen Original');
subplot(2,2,2), imshow(If3,[]), title('Imagen con Kernel 3');
subplot(2,2,3), imshow(IR2,[]), title('Bordes resaltados');

for i=1:30
    Idd(:,:,i) = im2double(I(:,:,i));%convierto la imagen original a tipo double
    
    %Laplaciano
    Iff(:,:,i) = imfilter(Idd(:,:,i),f);
    Iff(:,:,i) = im2uint16(Iff(:,:,i));
    IRR(:,:,i) = imsubtract(I(:,:,i),Iff(:,:,i));
    
    %Kernel 1
    Iff1(:,:,i) = imfilter(Idd(:,:,i),k1,'same');
    Iff1(:,:,i) = im2uint16(Iff1(:,:,i));
    IRR1(:,:,i) = imsubtract(I(:,:,i),Iff1(:,:,i));

    %Kernel 2
    Iff2(:,:,i) = imfilter(Idd(:,:,i),k2,'same');
    Iff2(:,:,i) = im2uint16(Iff2(:,:,i));
    IRR2(:,:,i) = imsubtract(I(:,:,i),Iff2(:,:,i));

    %Kernel 3
    Iff3(:,:,i) = imfilter(Idd(:,:,i),k3,'same');
    Iff3(:,:,i) = im2uint16(Iff3(:,:,i));
    IRR3(:,:,i) = imsubtract(I(:,:,i),Iff3(:,:,i));
end

figure('Name', 'Bordes resaltados Laplaciano'), for i=1:30, subplot(6,5,i), imshow(IRR(:,:,i),[]); end;
figure('Name', 'Bordes resaltados Kernel 1'), for i=1:30, subplot(6,5,i), imshow(IRR1(:,:,i),[]); end;
figure('Name', 'Bordes resaltados Kernel 2'), for i=1:30, subplot(6,5,i), imshow(IRR2(:,:,i),[]); end;
figure('Name', 'Bordes resaltados Kernel 3'), for i=1:30, subplot(6,5,i), imshow(IRR3(:,:,i),[]); end;

