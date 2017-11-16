clear all,close all,clc;

load v1.mat;
v=v1;L=3;e=0.25;
pace=10;
Face_size=28;
Faces=imread('test.jpg');
[width,len,dim]=size(Faces);
len=2*len;
Faces=imresize(Faces,[width,len]);
YNum=ceil((width-Face_size)/pace);
XNum=ceil((len-Face_size)/pace);
ys1=[];ys2=[];xs1=[];xs2=[];mark=[];
for i=1:YNum
    for j=1:XNum
        y1=(i-1)*pace+1;
        y2=(i-1)*pace+Face_size;
        x1=(j-1)*pace+1;
        x2=(j-1)*pace+Face_size;
        Block=Faces(y1:y2,x1:x2,:);
        u=ColorExc(L,Block);
        Sqr=sqrt(u.*v);
        d=1-sum(Sqr);
        if(d<e)
            ys1=[ys1,(i-1)*pace+1]; 
            ys2=[ys2,(i-1)*pace+Face_size];
            xs1=[xs1,(j-1)*pace+1];
            xs2=[xs2,(j-1)*pace+Face_size];
            mark=[mark,1];
        end
    end
end
LocNum=length(ys1);
for i=1:LocNum-1
    isinter=0;
    for j=i+1:LocNum
        a1=((ys1(j)-ys1(i))<(ys2(i)-ys1(i)));
        a2=((ys1(i)-ys1(j))<(ys2(j)-ys1(j)));
        a3=((xs1(j)-xs1(i))<(xs2(i)-xs1(i)));
        a4=((xs1(i)-xs1(j))<(xs2(j)-xs1(j)));
        if(a1&&a2&&a3&&a4)
            isinter=1;
            break;
        end
    end
    if(isinter)
        ys1(j)=min(ys1(i),ys1(j));
     	ys2(j)=max(ys2(i),ys2(j));
        xs1(j)=min(xs1(i),xs1(j));
      	xs2(j)=max(xs2(i),xs2(j));
    else
        mark(i)=0;
    end
end
mark(LocNum)=0;
for i=1:LocNum
    if(~mark(i))
        a=ys1(i);b=ys2(i);
        c=xs1(i);d=xs2(i);
        Faces(a,c:d,1)=255;Faces(a,c:d,2)=0;Faces(a,c:d,3)=0;
        Faces(b,c:d,1)=255;Faces(b,c:d,2)=0;Faces(b,c:d,3)=0;
       	Faces(a:b,c,1)=255;Faces(a:b,c,2)=0;Faces(a:b,c,3)=0;
        Faces(a:b,d,1)=255;Faces(a:b,d,2)=0;Faces(a:b,d,3)=0;
    end
end
imshow(Faces);
imwrite(Faces,'./Faces_resize/Faces_resize.bmp');