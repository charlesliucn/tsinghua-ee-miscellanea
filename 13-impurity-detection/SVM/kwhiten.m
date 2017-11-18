function result=kwhiten(data,U,sample,sigma)
[Nd,~]=size(data);
[Nr,~]=size(sample);
K=zeros(Nd,Nr);
for i=1:Nr
    K(:,i)=FI(data,repmat(sample(i,:),Nd,1),sigma);
end
result=K*U;
