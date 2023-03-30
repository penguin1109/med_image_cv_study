% histogram     equalization function without using the hist_eq 

I = imread('test_image.png');
GI = rgb2gray(I);

% Step 1: Calculate the CDF function of the image pixel intensity
PDF = zeros(1, 256);
[h w c] = size(I);
tot = h * w * c; % total number of the pixels

for ch = 1:c
    for i = 1:h 
        for j=1:w
            val = I(i, j, ch);
            
            PDF(val+1) = PDF(val+1)+1; % count the number of pixels of each intensity
        end

    end
end

add = PDF(1);
CDF = zeros(1, 256);
CDF(1) = add;
for cnt = 2: 256
    add = add + PDF(cnt);
    CDF(cnt) = add;
end

new_image = double(zeros(size(I)));
% Step 2: Map the intensity values to based on the look up table
mul_val = 256 / tot;

for ch = 1:c
    for i = 1:h
        for j = 1:w
            new_image(i, j, ch) = round(mul_val * CDF(I(i, j, ch)+1));
        %disp(new_image(i, j));
        end
    end
end


% Step 3: Show the histogram equalized target image.
figure;
subplot(1, 2, 1);
imshow(I);
title('Original RGB Image');
subplot(1, 2, 2);
imshow(new_image / 255);
% imshow(repmat(double(new_image)/255, [1 1 3]));
title('Equalized RGB Image');
% imshow(histeq(I));
