clear all;
tic;
image = imread('C:\Users\75215\Desktop\计算机视觉\test.jpg');
target = imread('C:\Users\75215\Desktop\计算机视觉\cug_90.jpg');
im_gray = double(rgb2gray(image));
tar_gray = double(rgb2gray(target));
[target_x,target_y] = size(tar_gray);
[image_x,image_y] = size(im_gray);
xy = target_x *target_y;
avgray_tar =double(0);

for x =1:target_x
    for y = 1: target_y
        avgray_tar = avgray_tar + tar_gray(x,y);%计算模板的总灰度值
    end
end
avgray_tar = avgray_tar/xy;%模板平均灰度值
for w =1 : (image_x-target_x-1)
    disp(w);
    for h = 1:(image_y-target_y-1) 
        avgray_im=double(0);
        tempt_image = im_gray(w:w+target_x-1,h:h+target_y-1);%裁剪中模板大小的区域
       
        for x  =1:target_x
            for y = 1:target_y
                avgray_im = avgray_im + tempt_image(x,y);%计算裁剪区域的总灰度值
            end
        end
        avgray_im = avgray_im/xy;%裁剪部分的平均灰度值
        err_tar =double(0);%模板的灰度误差
        err_img =double(0);%裁剪区域的灰度误差
        err_all = double(0);%二者相乘
        var_img =double(0);%裁剪区域标准差
        var_tar = double(0);%模板标准差
        for x=1:target_x
            for y=1:target_y
                err_tar = (tar_gray(x,y) - avgray_tar);
                err_img = (tempt_image(x,y)-avgray_im);
                err_all = err_all+err_tar*err_img;
                var_tar = power((tar_gray(x,y)-avgray_tar),2)+var_tar;
                var_img =power((tempt_image(x,y)-avgray_im),2)+var_img;
            end
        end
        ncc(w,h) = ((err_all)/(sqrt(var_tar)*sqrt(var_img)))/(xy-1);%计算NCC值
    end
end
max_ncc = max(max(ncc));
[max_x,max_y] = find(ncc == max(max(ncc))); %找到最大匹配值的位置
figure(1)
imshow(uint8(target));
ncc=mapminmax(ncc,-1,1);%归一化到[-1,1]
figure(2)
imshow(uint8(image));%画原图
hold on;
show = imagesc(ncc);    %根据矩阵变为热力图
set(show,'AlphaData',0.6); %设置透明度
rectx =[max_y,max_x,target_y,target_x]; %设置矩形区域
rectangle('Position',rectx,'Edgecolor','r','LineWidth',2);%画矩形，红shai，粗2
toc
disp(toc)
