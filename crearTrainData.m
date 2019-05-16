load('emnist-byclass.mat')
data=dataset.test.images;
labels=dataset.test.labels;
images=[];
training=[];
ind=1;

for j=10:35
    aux=data(labels==j,:);
    num_letra=size(aux,1);
    for k=1:num_letra
        training(ind,:)=aux(k,:);
        tags(ind)=j;
        ind=ind+1;
    end
end

%Extraer features
features=zeros(length(labels),18*2);
estdev=zeros(1,18);
for i=1:length(labels)
    letra=reshape(training(i,:),[28,28]);
    letra=imbinarize(letra);
letra=bwskel(letra);
[mag,fase] = miGabor(letra);
for j=1:18
    aux=mag(:,:,j);
    estdev(j)=std(aux(:));
end
features(i,:)=[estdev,squeeze(mean(mean(mag)))'];
end
