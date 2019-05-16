function [texto] = getText(feats,modelo)
if nargin<2
modelo=load('CubSVM_std_mean.mat');
end
abc=['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
texto=[];
for i=1:size(feats,1)
tag=modelo.predictFcn(feats(i,:));
texto=num2str(abc(tag-9));
% tag=predict(modelo,feats);
% tag=cellfun(@str2num,tag);
% texto=num2str(abc(tag));
end
end

