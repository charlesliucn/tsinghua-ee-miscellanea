function img_low = butterlp(img_gray,n)

[height,width]=size(img_gray);
f = double(img_gray);
g = fftshift(fft2(f));          
D0 = 50;
u = fix(height/2);
v = fix(width/2);
img_temp1 = zeros(height,width);
for i = 1:height
       for j = 1:width
           D = sqrt((i-u)^2+(j-v)^2);
           H = 1/(1+(D/D0)^(2*n));  % ¼ÆËãµÍÍ¨ÂË²¨Æ÷´«µÝº¯Êý
           img_temp1(i,j) = H*g(i,j);
       end
end
img_temp1 = ifftshift(img_temp1);
img_temp2 = ifft2(img_temp1);
img_low = uint8(real(img_temp2));