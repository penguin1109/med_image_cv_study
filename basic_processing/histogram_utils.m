classdef histogram_utils
    methods
        function hist = calc_hist(~,I)
            [h, w] =  size(I);
         
            hist = zeros(1, 256);
            for i = 1:h
                for j = 1:w
                    val = I(i, j);
                    hist(val + 1) = hist(val+1) +1; % histogram calculated for the image
                end
            end
        end

        function [equalized, cdf] = eq_hist(obj,I)
            hist = obj.calc_hist(I);
            [h, w] = size(I);
            tot = h*w;
            
            hist = hist/ tot; % Now the histogram is in the percentile range
            cdf = zeros(1, 256);
            cdf(1) = hist(1);
            for i = 2:256
                cdf(i) = cdf(i-1) + hist(i);
            end

            cdf = roundn(255 * cdf, 0);
            equalized = uint8(zeros(size(I)));
           
            for i =1:h
                for j = 1:w
                    equalized(i, j) = cdf(I(i, j) + 1);
                end
            end
        end

        function matched = hist_match(obj, source, target)
            % [STEP 1] Source image(r)에 히스토그램 평활화 적용: r -> s
            [equalized_si, si_cdf] = obj.eq_hist(source);
            % [STEP 2] Target image에서 평활화된 source 영상의 histogram을 찾기 위한 G 계산
            [equalized_ti, ti_cdf] = obj.eq_hist(target);

            % [STEP 3]
            G_inverse = zeros(1, 256);
            for i = 1:256
                diff = abs(si_cdf(i) - ti_cdf);
                [~, idx] = min(diff);
                G_inverse(i) = idx-1;
            end
            % [STEP 4] s_{k} -> z_{q} Mapping
            matched = uint8(zeros(size(source)));
            [h w] = size(source);
            for i = 1:h
                for j = 1:w
                    matched(i, j) = G_inverse(source(i, j)+1);
                end
            end
        end

    end % end for methods
end % end for classdef
