function flowImage = flow2rgb(flow)
% Brief: 把光流转化为可视化的RGB图像
%
% Inputs:
%    flow - [1,1] size,[opticalFlow] build-in type,光流opticalFlow对象（https://ww2.mathworks.cn/help/vision/ref/opticalflowobject.html）
% 
% Outputs:
%    flowImage - [m,n] size,[single,double] type,光流RGB图像，[0,1]范围归一化图像
% 
% Example: 
% % 创建光流图像的尺寸  
% width = 800;  
% height = 800;  
% 
% % 创建一个网格  
% [x, y] = meshgrid(1:width, 1:height);  
% 
% % 图像中心  
% centerX = width / 2;  
% centerY = height / 2;  
% 
% % 计算 Vx 和 Vy  
% Vx = (x - centerX) .* sqrt((x - centerX).^2 + (y - centerY).^2) ./ (width/2);  
% Vy = (y - centerY) .* sqrt((x - centerX).^2 + (y - centerY).^2) ./ (height/2);  
% 
% % 将 Vx 和 Vy 组合成光流
% flow = opticalFlow(Vx,Vy);  
% 
% % 绘制稀疏光流箭头
% figure;  
% plot(flow,DecimationFactor=[50 50])
% axis equal tight;  
% title('Optical Flow Field');  
% xlabel('X direction');  
% ylabel('Y direction');
% 
% % 显示稠密光流图像
% flowImage = flow2rgb(flow);
% figure;imshow(flowImage)
% 
% See also: opticalFlow

% Author:                          cuixingxing
% Email:                           cuixingxing150@gmail.com
% Created:                         14-Nov-2024 09:27:18
% Version history revision notes:
%                                  None
% Implementation In Matlab R2024b
% Copyright © 2024 TheMatrix.All Rights Reserved.
%
arguments
    flow (1,1) opticalFlow
end
% 计算光流的角度和幅度
magnitude = flow.Magnitude;   % 计算幅度
angle = flow.Orientation;  % 计算角度
% angle = atan2(-flow.Vy,-flow.Vx);

% 归一化角度到[0,1]
angle_normalized = (angle + pi)./(2 * pi);

% 归一化幅度
magnitude_normalized = magnitude./max(magnitude(:));

% 将角度映射到自定义颜色轮
mapColor = make_colorwheel();  % 55*3, [0,1] color map array
numColors = size(mapColor, 1);

% 将归一化角度映射到颜色轮中的颜色值
x = linspace(0,1,numColors)';
rgbImage = interp1(x,mapColor,angle_normalized,"linear");

% 使用幅度调整亮度,即幅度越小越接近1（颜色饱和),幅度越大越接近原始颜色值
flowImage = 1-magnitude_normalized .*(1-rgbImage );
end

function colorwheel = make_colorwheel()
% Generates a color wheel for optical flow visualization as presented in:
% Baker et al. "A Database and Evaluation Methodology for Optical Flow" (ICCV, 2007)
% URL: http://vision.middlebury.edu/flow/flowEval-iccv07.pdf
%
% Code follows the original C++ source code of Daniel Scharstein.
% Code follows the the Matlab source code of Deqing Sun.
%
% Returns:
%   55*3 double,[0,1] range array: Color wheel
% 
% Visualize color wheel Example:
% % generate rows*cols size color wheel image
% rows = 100;
% cols = 1000;
% colorwheel = make_colorwheel();
% nColors = size(colorwheel,1);
%
% ind = ones(rows,1)*linspace(1,nColors,cols);
% rgb = interp1((1:nColors)',colorwheel,ind);
% figure;imshow(rgb)
%

% Author:                          cuixingxing
% Email:                           cuixingxing150@gmail.com
% Created:                         14-Nov-2024 8:40:29
% Version history revision notes:
%                                  None
% Implementation In Matlab R2024b
% Copyright © 2024 TheMatrix.All Rights Reserved.

RY = 15;
YG = 6;
GC = 4;
CB = 11;
BM = 13;
MR = 6;

ncols = RY + YG + GC + CB + BM + MR;
colorwheel = zeros(ncols, 3);
col = 1;

% RY
colorwheel(1:RY, 1) = 255;
colorwheel(1:RY, 2) = floor(255*(0:RY-1)/RY);
col = col+RY;
% YG
colorwheel(col:col+YG-1, 1) = 255 - floor(255*(0:YG-1)/YG);
colorwheel(col:col+YG-1, 2) = 255;
col = col+YG;
% GC
colorwheel(col:col+GC-1, 2) = 255;
colorwheel(col:col+GC-1, 3) = floor(255*(0:GC-1)/GC);
col = col+GC;
% CB
colorwheel(col:col+CB-1, 2) = 255 - floor(255*(0:CB-1)/CB);
colorwheel(col:col+CB-1, 3) = 255;
col = col+CB;
% BM
colorwheel(col:col+BM-1, 3) = 255;
colorwheel(col:col+BM-1, 1) = floor(255*(0:BM-1)/BM);
col = col+BM;
% MR
colorwheel(col:col+MR-1, 3) = 255 - floor(255*(0:MR-1)/MR);
colorwheel(col:col+MR-1, 1) = 255;

colorwheel = colorwheel./255;
end
