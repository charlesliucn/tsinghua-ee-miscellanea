function y=FI(X,Y,sigma)
y=(exp(-sum((X-Y).^2,2)/sigma^2));