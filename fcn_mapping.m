function [ out_img ] = fcn_mapping( img, plot_graph)

%     x_shift = 0.5;
%     x_shift = max(img(:)) - std(img(:))
    x_shift = mean(img(:));
    scale = 50*(max(img(:))-min(img(:)));
    width = 0.8;
%     scale = scale*x_shift
    
    out_img = width*1./(1+exp(-scale*(img-x_shift)))+(1-width)/2 + (x_shift-0.5);
    out_img(img<(x_shift-width/2)) = img(img<(x_shift-width/2));
    out_img(img>(x_shift+width/2)) = img(img>(x_shift+width/2));
    
    if (plot_graph)
        x = -1:0.01:1;
        y = width*1./(1+exp(-scale*(x-x_shift)))+(1-width)/2 + (x_shift-0.5); 
        y(x<(x_shift-width/2)) = x(x<(x_shift-width/2));
        y(x>(x_shift+width/2)) = x(x>(x_shift+width/2));
        figure; plot(x, y); title('mapping function');
    end
end

