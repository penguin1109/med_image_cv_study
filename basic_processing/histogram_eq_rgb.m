% Histogram Equalization on RGB Images

I  = imread("lena.jpg");

% [STEP 1] Change to HSV color map
hsv = rgb2hsv(I);
V = hsv(:, :, 3);

% [STEP 2] Equalize the V Channel
% V channel이기 때문에 double 자료형을 갖는다.
maxV = max(V, [], 'all');
minV = min(V, [], 'all');

equalized = hist_equalize_hsv(V, 256) / 255;
equalized_rgb = hist_equalize_rgb(I);
% equalized = histeq(V);

% [STEP 3] Convert back to RGB Color map
hsv(:, :, 3) = equalized;
answer = hsv2rgb(hsv);

figure;
subplot(3,2, 1);
imshow(answer);
title("My Equalization Using HSV");
subplot(3,2,2);
histogram(answer, 256);
title("Histogram of My Equalization Using HSV");
subplot(3,2, 3);
imshow(equalized_rgb);
title("My Equalization Using RGB");
subplot(3,2,4);
histogram(equalized_rgb, 256);
title("Histogram of My Equalization Using RGB");
subplot(3,2,5);
eq = histeq(I);
imshow(eq);
title("MATLAB Equalization");
subplot(3,2,6);
histogram(eq, 256);
title("Histogram of MATLAB Equalization");

function equalized = hist_equalize_rgb(I)
    [h w ] = size(I);
    pdf = zeros(1, 256);
    for i = 1:h
        for j = 1:w
            val = I(i, j);
            pdf(val+1) = pdf(val+1) + 1;
        end
    end
    pdf = pdf / (h*w);
    cdf = zeros(1, 256);
    cdf(1) = pdf(1);
    for i = 2:256
        cdf(i) = pdf(i) +cdf(i-1);
    end
    cdf = roundn(cdf*255, 0);
    equalized = uint8(zeros(size(I)));
    for i = 1:h
        for j = 1:w
            val = I(i, j);
            equalized(i, j) = cdf(val+1);
        end
    end

end


function equalized = hist_equalize_hsv(gray, nbins)
    % Gets the input of one channel image
 
    [h w] = size(gray);
    maxV = max(gray, [], 'all');
    minV = min(gray, [], 'all');
    bin_size = (maxV-minV) / nbins;

    pdf = double(zeros(1, nbins+1));
    for i = 1:h
         for j = 1:w
             val = gray(i, j);
             idx = roundn((val-minV)/bin_size, 0);
             pdf(idx+1) = pdf(idx+1)+1;
         end
    end
    pdf = pdf / (h*w);
    cdf = double(zeros(1, nbins+1));
    cdf(1) = pdf(1);
    for i = 2:nbins+1
        cdf(i) = pdf(i) + cdf(i-1);
    end

    cdf = roundn(cdf * 255, 0);
    equalized = double(zeros(size(gray)));

     for i = 1:h
         for j = 1:w
             val = gray(i, j);
             idx = roundn((val-minV) / bin_size, 0);
             equalized(i, j) = cdf(idx+1);
         end
    end
end
