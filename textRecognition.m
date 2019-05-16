function textoEntero=textRecognition(img,save,modelo)
%Esta es la función principal, que permite cargar una imagen y devolver el
%texto digitalizado.
%INPUTS:
% img: path de la imagen a procesar
% save: True o False, permite escoger si se desea guardar el texto en un
% archivo o tan solo imprimir el resultado por pantalla
% modelo: variable que contiene el modelo entrenado. De no especificarlo,
% se cargará un modelo disponible en la carpeta, QuadSVM_std_mean.
feats=[];
close all
if nargin<1
    img=imread('minombre.jpg');
end
if nargin<2
    save=true;
end
if nargin<3
    modelocargado=load('QuadSVM_std_mean.mat');
    modelo=modelocargado.QuadSVM_std_mean;
end
img = homofilter(img,10);
img = preproc(img);

imglineas=imclose(img,strel('rectangle',[5,200]));
labimglineas=bwlabel(imglineas);
textoEntero=[];
textLinea=[];
for l=1:max(max(labimglineas))
    aux=zeros(size(img));
    aux(labimglineas==l)=1;
    reglinea=regionprops(aux,'BoundingBox');
    linbox=reglinea.BoundingBox;
    poslinea(l)=linbox(2);
    linea=img(round(linbox(2)):round(linbox(2))+round(linbox(4)),round(linbox(1)):round(linbox(1))+round(linbox(3)));

%     palabras=imdilate(linea,strel('rectangle',[40,40]));
%     palabras=imopen(linea,strel('disk',10));
        palabras=imclose(linea,strel('rectangle',[5,25]));
    labels=bwlabel(palabras);
    if save==true
    mkdir(['linea',num2str(l)]);
    end
    
    for i=1:max(max(labels))
        aux=zeros(size(palabras));
        aux(labels==i)=1;

        elems=regionprops(aux,'BoundingBox');
        palbox=elems.BoundingBox;
        palabra=linea(max([round(palbox(2)),1]):min([round(palbox(2))+round(palbox(4)),size(linea,1)]),max([1,round(palbox(1))]):min([size(linea,2),round(palbox(1))+round(palbox(3))]));
        if save==true
        mkdir(fullfile(['linea',num2str(l)],['palabra',num2str(i)]));
        end
        labletras=bwlabel(palabra);
        textPalabra=[];
            for k=1:max(max(labletras))
            aux=zeros(size(palabra));
            aux(labletras==k)=1;
            elems=regionprops(aux,'BoundingBox');
            letbox=elems.BoundingBox;
            letra=palabra(max([round(letbox(2)),1]):min([round(letbox(2))+round(letbox(4)),size(linea,1)]),max([1,round(letbox(1))]):min([size(linea,2),round(letbox(1))+round(letbox(3))]));
            dims=size(letra);
            if dims(1)>dims(2)
                letra=[zeros(dims(1),round((dims(1)-dims(2))/2)),letra,zeros(dims(1),round((dims(1)-dims(2))/2))];
            elseif dims(2)>dims(1)
                letra=[zeros(round((dims(2)-dims(1))/2),dims(2));letra;zeros(round((dims(2)-dims(1))/2),dims(2))];
            end
            letra=imresize(letra,[28,28]);
            letra=imbinarize(double(letra));
            letra=bwskel(letra);
            [mag,~] = miGabor(letra);
            for j=1:18
                aux=mag(:,:,j);
                estdev(j)=std(aux(:));
            end
            feats=[estdev,squeeze(mean(mean(mag)))'];
           
            if save==true
            imwrite(letra,fullfile(['linea',num2str(l)],['palabra',num2str(i)],['letra',num2str(k),'.jpg']));
            mkdir(fullfile(['linea',num2str(l)],['palabra',num2str(i)],['GaborLetra',num2str(k)]));
            end
            textPalabra = strcat(textPalabra,getText(feats,modelo));
            for r=1:size(mag,3)
                if save==true
                imwrite(mag(:,:,r),fullfile(['linea',num2str(l)],['palabra',num2str(i)],['GaborLetra',num2str(k)],['Gabor',num2str(r),'.jpg']));
                end
            end
            end
        textLinea=strcat(textLinea,{' '},textPalabra);
    end
    textLinea=strcat(textLinea,'/');
end
textosLineas=split(textLinea,'/');
[~,orden_lineas]=sort(poslinea);
for m=1:length(orden_lineas)
    if m==1
        textoEntero=textosLineas(orden_lineas(m));
    else
        textoEntero=strcat(textoEntero,'\n',textosLineas(orden_lineas(m)));
    end
end
if save==true
for o=1:numel(orden_lineas)
   movefile(['linea',num2str(o)], ['Line',num2str(orden_lineas(o))]);
end
end
textoEntero=string(textoEntero);
compose(textoEntero)
end
