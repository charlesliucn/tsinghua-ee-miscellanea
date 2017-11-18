function result=classifier(data,sv,alpha,omega,sigma)
[Nd,~]=size(data);
[Ns,~]=size(sv);
K=zeros(Nd,Ns);
for i=1:Ns
    K(:,i)=alpha(i)*FI(data,repmat(sv(i,:),Nd,1),sigma);
end
F=sum(K,2);
result=(1+omega-2*F)<0;