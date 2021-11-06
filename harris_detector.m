function result = harris_detector(img, threshold)
    sob = [-1 0 1; -2 0 2; -1 0 1];
    gaus = fspecial('gaussian', 5, 1);
    dog = conv2(gaus, sob);
    ix = imfilter(img, dog);
    iy = imfilter(img, dog');
    ix2g = imfilter(ix .* ix, gaus);
    iy2g = imfilter(iy .* iy, gaus);
    ixiyg = imfilter(ix .* iy, gaus);

    harcor = ix2g .* iy2g - ixiyg .* ixiyg - 0.05 * (ix2g + iy2g).^2;
    harris_corner = harcor > threshold;
    result = harris_corner;
end