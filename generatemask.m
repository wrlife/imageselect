function mask=generatemask(img)

mask = zeros(size(img));
row = size(img,1);
col = size(img,2);
for i = 1:size(img,1)
    for j =1:size(img,2)
        if sum(img(i,j,:))~=0&&sum(img(min(i+3,row),j,:))~=0&&sum(img(i,min(j+3,col),:))~=0....
            &&sum(img(max(1,i-3),j,:))~=0&&sum(img(i,max(1,j-3),:))~=0&&sum(img(max(1,i-3),max(1,j-3),:))~=0&&sum(img(max(1,i-3),min(col,j+3),:))~=0&&sum(img(min(row,i+3),max(1,j-3),:))~=0&&sum(img(min(row,i+3),min(col,j+3),:))~=0
            mask(i,j,:)=1;
        end
    end
end
