close all
clear all
clc

% %---------------------------------------------------------------------% %
% %....INSTITUTO TECNOLÓGICO Y DE ESTUDIOS SUPERIORES DE MONTERREY......% %
% %....................CAMPUS CIUDAD DE MÉXICO..........................% %
% %...........................INTEGRANTES:..............................% %
% %..............BEATRIZ SANABRIA BARRADAS - A01182649..................% %
% %..............................Tarea 3................................% %
% %---------------------------------------------------------------------% %

I = squeeze(dicomread('N1.dcm'));

Idd= I(:,:,3);

f = fspecial('gaussian',[10 10],.2);
If = imfilter(Idd,f);
IR = imadd(Idd,If);

f1 = fspecial('log',[8 8],.8);
If = imfilter(IR,f1,'same');
IRR = imsubtract(IR,If);

f2 = fspecial('prewitt');
If = imfilter(IR,f2,'same');
IRR1 = imsubtract(IR,If);

f3 = edge(IR,'Canny') ;
f3 = im2int16(f3);
IRR2 = imadd(IR,f3);

for i=1:16
    
    %Limpieza de las imágenes
    IffL(:,:,i) = imfilter(I(:,:,i),f,'same');
    IRRL(:,:,i) = imadd(I(:,:,i),IffL(:,:,i));
    
    %Log
    Iff1(:,:,i) = imfilter(IRRL(:,:,i),f1,'same');
    IRR1L(:,:,i) = imadd(I(:,:,i),Iff1(:,:,i));
    
    %Prewitt
    Iff2(:,:,i) = imfilter(IRRL(:,:,i),f2,'same');
    IRR2P(:,:,i) = imadd(I(:,:,i),Iff2(:,:,i));
    
    %Canny
    Iff3(:,:,i) = edge(IRRL(:,:,i),'Canny');
    Iff3I(:,:,i) = im2int16(Iff3(:,:,i));
    IRR3C(:,:,i) = imadd(I(:,:,i),Iff3I(:,:,i));
end



figure('Name', 'Muestra de modificaciones'), subplot(2,3,1), imshow(Idd,[]), title('Imagen Original');
subplot(2,3,2), imshow(IR,[]), title('Imagen Limpia');
subplot(2,3,3), imshow(IRR,[]), title('Bordes Resaltados log');
subplot(2,3,4), imshow(IRR1,[]), title('Bordes Resaltados prewitt');
subplot(2,3,5), imshow(IRR2,[]), title('Bordes Resaltados canny');

figure('Name', 'Imágenes originales'),for i=1:16, subplot(4, 4, i), imshow(I(:,:,i),[]), end
figure('Name', 'Imágenes limpias'), for i=1:16, subplot(4,4,i), imshow(IRRL(:,:,i),[]); end;
figure('Name', 'Bordes resaltados Log'), for i=1:16, subplot(4,4,i), imshow(IRR1L(:,:,i),[]); end;
figure('Name', 'Bordes resaltados Prewitt'), for i=1:16, subplot(4,4,i), imshow(IRR2P(:,:,i),[]); end;
figure('Name', 'Bordes resaltados Canny'), for i=1:16, subplot(4,4,i), imshow(IRR3C(:,:,i),[]); end;








