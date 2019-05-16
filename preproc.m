function [imout] = preproc(imin)
img=rgb2gray(imin);
img=imgaussfilt(img,1);
%Por default, imbinarize usa el treshold devuelto por el método Otsu
img=imbinarize(img);
img=abs(img-max(img));
img=imopen(img,strel('disk',1));
img=imclose(img,strel('disk',1));
img = bwareaopen(img, round((size(img,2)/500)^2*pi));
mark=imopen(img,strel('rectangle',[5,1]));
img2=imreconstruct(mark,img);
lineas=img-img2;
    reglinea=regionprops(lineas,'BoundingBox');
    linbox=reglinea.BoundingBox;
imout=img2(:,round(linbox(1)):round(linbox(1))+round(linbox(3)));

end

