H = 480;
W = 640;
NITER = 10;

x0 = sfi(-2,32,16)
x1 = sfi(1,32,16)
y0 = sfi(-1.5,32,16)
y1 = sfi(1.5,32,16)
imagStep = (y1-y0)/H
realStep = (x1-x0)/W
screen = zeros(W,H,'uint16');
for i=1:H
    imagC = y1 - sfi(imagStep * i,32,16);
    for j=1:W
    realC = x0 + sfi(realStep * j,32,16);
    realZ = sfi(0,32,16);
    imagZ = sfi(0,32,16);
    
        for nIter=1:NITER
            disp( ( (i-1) *W+ j )/(W*H)*100);
            
            realZ = sfi(sfi(realZ*realZ,32,16) - sfi(imagZ*imagZ,32,16) + realC,32,16);
            imagZ = sfi(2*sfi(realZ*imagZ,32,16) + imagC,32,16);
            if((sfi(realZ*realZ,32,16)+sfi(imagZ+imagZ,32,16)) > 2)
                break;
            end
        end
        if nIter == NITER 
            screen(i,j) = 1000;
        else 
            screen(i,j) = 0;
        end
    end
end
imagesc(screen);

