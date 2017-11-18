function pic=drawline(pic,points,N,M,L)
up=floor(min(points)/M);
down=floor(max(points)/M);
left=min(mod(points-1,M));
right=max(mod(points-1,M));
up=33+up*L;
down=33+down*L;
left=33+left*L;
right=33+right*L;
pic(up:down,left:left+4,:)=0;
pic(up:down,left:left+4,3)=255;
pic(up:down,right-4:right,:)=0;
pic(up:down,right-4:right,3)=255;
pic(up:up+4,left:right,:)=0;
pic(up:up+4,left:right,3)=255;
pic(down-4:down,left:right,:)=0;
pic(down-4:down,left:right,3)=255;

