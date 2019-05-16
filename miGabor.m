function [mag,fase] = miGabor(img)
orientations=[0,30,60,90,120,150];
wavelengths=[2,4,8];
bancoGabor=gabor(wavelengths,orientations);
if nargin<1
    img=imread('minombre.jpg');
    img=rgb2gray(img);
    img=imgaussfilt(img,round(size(img,1)/1000));
    %Por default, imbinarize usa el treshold devuelto por el método Otsu
    img=imbinarize(img);
    img=imopen(img,strel('disk',2));
    img=imclose(img,strel('disk',2));
end

[mag,fase]=imgaborfilt(uint8(img),bancoGabor);

end