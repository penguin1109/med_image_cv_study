% histogram matching Refined Version
% 1. Equalize the histogram of the source image
% 2. Calculate the G function for the target image
% 3. Choost the value z so that G(z) is the closest to s
% 4. Map s_{k} -> z_P{q}


utils = histogram_utils;
SI = imread('cat.jpg');
TI = imread('rainbow.jpg');

[h w c] = size(SI);

R = utils.hist_match(SI(:, :, 1), TI(:, :, 1));
G =  utils.hist_match(SI(:, :, 2), TI(:, :, 2));
B= utils.hist_match(SI(:, :, 3), TI(:, :, 3));

matched_image = uint8(zeros(size(SI)));
matched_image(:, :, 1) = R;
matched_image(:, :, 2) = G;
matched_image(:, :, 3) = B;

figure;
subplot(1, 4, 1);
imshow(matched_image);
title("Matched Image");
subplot(1, 4, 2);
plot(utils.calc_hist(SI));
title("PDF of Source Image")
subplot(1, 4, 3);
plot(utils.calc_hist(TI));
title("PDF of Target Image")
subplot(1, 4, 4);
plot(utils.calc_hist(matched_image));
title("PDF of Matched Image");
