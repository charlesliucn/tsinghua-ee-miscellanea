function [U,after]=kpca(before,sigma,L)
[N,~]=size(before);
K=zeros(N);
for i=1:N
    K(:,i)=FI(before,repmat(before(i,:),N,1),sigma);
end
%K=K-ones(N)*K/N-K*ones(N)/N+ones(N)*K*ones(N)/N^2;
[A,D]=eig(K);
A=A./repmat(diag(D)',N,1);
U=A(:,1:L);
after=K*U;

