H = 480/4;
W = 640/4;
NITER = 5;
NBITS = 32;
PREC = 16 ;

x0 = -2;
x1 = 1;
y0 = -1.5;
y1 = 1.5;
[x,y] = meshgrid(linspace(x0, x1, W), linspace(y0, y1, H));

%% Floating point
c = complex(x,y);
z = zeros(size(c));
k = zeros(size(c));

for i = 1:NITER
    disp(i/NITER*100)
    z = z.^2 + c;
    k(abs(z) > 2 & k == 0) = NITER - i;
end
subplot(1,3,1)
imagesc(k)
axis image
xticks(linspace(0,W,6))
xticklabels(linspace(x0,x1,6))
yticks(linspace(0,H,6))
yticklabels(flip(linspace(y0,y1,6)))
%% Fixed point 1
z = zeros(size(c));
k = zeros(size(c));
for i = 1:NITER
    disp(i/NITER*100)
    z = z.^2 + c;
    mod = abs(z);
    mod(mod==inf) = 1000;
    k(sfi(mod,NBITS,PREC) > 2 & k == 0) = NITER-i;
end
subplot(1,3,2)
imagesc(k)
axis image
xticks(linspace(0,W,6))
xticklabels(linspace(x0,x1,6))
yticks(linspace(0,H,6))
yticklabels(flip(linspace(y0,y1,6)))
%% Fixed point 2
z = sfi(zeros(size(c)),NBITS,PREC);
c = sfi(c,NBITS,PREC);
k = zeros(size(c));
F = fimath;
F.OverflowAction = 'wrap';
F.ProductMode = 'SpecifyPrecision';
F.ProductWordLength = 32;
F.ProductFractionLength = 16;
F.SumMode = 'SpecifyPrecision';
F.SumWordLength = 32;
F.SumFractionLength=16;

z.fimath = F;
c.fimath = F;
for i = 1:NITER
    disp(i/NITER*100)
    z = z.^2 + c;
    k(abs(z) > 2 & k == 0) = NITER - i;
end
subplot(1,3,3)
imagesc(k)
axis image
xticks(linspace(0,W,6))
xticklabels(linspace(x0,x1,6))
yticks(linspace(0,H,6))
yticklabels(flip(linspace(y0,y1,6)))