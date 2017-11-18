function [sv,alpha,omega]=svdd(data,sigma,C)
[N,~]=size(data);
K=zeros(N);
e=1e-3;
for i=1:N
    K(:,i)=FI(data,repmat(data(i,:),N,1),sigma);
end
alpha=quadprog(K,zeros(N,1),[],[],ones(1,N),1,zeros(N,1),C*ones(N,1));
sv=data(alpha>e,:);
alpha=alpha.*(alpha>e);
alpha=alpha/sum(alpha);
E=sum(K.*repmat(alpha',N,1),2);
omega=2*sum(E.*(alpha>e));
alpha=alpha(alpha>e);
omega=omega/length(alpha)-1;


%initial
%e=1e-10;
%initN=1/C;
%alpha=[C*ones(initN,1);zeros(N-initN,1)];
% Ks=sum(K,2);
% E=sum(K.*repmat(alpha',N,1),2);
% Nsv=initN;
% omega=sum(2*E.*(alpha>0));
% G=omega/Nsv-2*E;
% kkt=@(a,g,c)((~a&(g>=0))|(a>0&a<c&(abs(g)>e))|(a==c&g<=0));
% KKT=kkt(alpha,G,C);
% KKTNUM=sum(KKT);
% %loop
% while KKTNUM>1
%     i=find(KKT&(alpha>0),1,'first');
%     j=find(KKT&(alpha<C),1,'last');
%     lambda=alpha(i)+alpha(j);
%     alpha1=alpha(i);
%     alpha2=alpha(j);
%     alpha(j)=lambda/2;
%     alpha(i)=lambda/2;
%     Nsv=Nsv+(alpha(i)>0)-(alpha1>0)+(alpha(j)>0)-(alpha2>0);
%     E=E+(alpha(i)-alpha1)*K(:,i)+(alpha(j)-alpha2)*K(:,j);
%     omega=omega+2*(((alpha(i)>0)*alpha(i)-(alpha1>0)*alpha1)*Ks(i)+((alpha(j)>0)*alpha(j)-(alpha2>0)*alpha2)*Ks(j));
%     G=omega/Nsv-2*E;
%     KKT=kkt(alpha,G,C);
%     KKTNUM=KKTNUM-~KKT(i)-~KKT(j);
% end
% omega=omega/Nsv-1;
% sv=data(alpha>0,:);
% alpha=alpha(alpha>0);

    
    
    
    
    
    