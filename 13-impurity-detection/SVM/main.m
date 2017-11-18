p=imread('test.bmp');
type=0;
load('sv.mat');
[px,py,~]=size(p);
L=25;
xf=64;
yf=64;
t=cell(0);
while xf<=px
    while yf<=py
        t=[t;p(xf-63:xf,yf-63:yf,:)];
        yf=yf+L;
    end
    xf=xf+L;
    yf=64;
end

N=length(t);
fl=length(extFeature(t{1},type));
dtfeature=zeros(N,fl);
for i=1:N
    dtfeature(i,:)=extFeature(t{i},type);
end
rdtfeature=kwhiten(dtfeature,U,feature,sigma);
label=classifier(rdtfeature,sv,alpha,omega,sigma);

[~,fL]=size(feature);
sigma1=2.5;
C1=1/4;
fold1=ceil(12*rand(N,1));
t1=t((fold1==1)&label);
feature1=dtfeature((fold1==1)&label,:);
[U1,rfeature1]=kpca(feature1,sigma1,fL);
[sv1,alpha1,omega1]=svdd(rfeature1,sigma1,C1);
dtfeature1=dtfeature(~label,:);
rdtfeature1=kwhiten(dtfeature1,U1,feature1,sigma1);
label1=classifier(rdtfeature1,sv1,alpha1,omega1,sigma1);
q1=find(~label);
q2=q1(~label1);
adjlabel=ones(length(label),1);
adjlabel(q2)=0;

xf=64;
yf=64;
ct=1;
q=p;
bx=1+floor((px-64)/L);
by=1+floor((py-64)/L);
wrong=near(adjlabel,bx,by);
wrongset=uniwrong(wrong,bx,by);
i=1;
adjwrong=[];
while i<=length(wrongset)
    if length(wrongset{i})<=9
        wrongset(i)=[];
    else
        adjwrong=[adjwrong;wrongset{i}];
        i=i+1;
    end
end
for i=1:length(wrongset)
q=drawline(q,wrongset{i},bx,by,L);
end
imshow(q);
imwrite(q,'~/result.bmp');
