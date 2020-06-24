clear all;
tic;
image = imread('C:\Users\75215\Desktop\������Ӿ�\test.jpg');
target = imread('C:\Users\75215\Desktop\������Ӿ�\cug_90.jpg');
im_gray = double(rgb2gray(image));
tar_gray = double(rgb2gray(target));
[target_x,target_y] = size(tar_gray);
[image_x,image_y] = size(im_gray);
xy = target_x *target_y;
avgray_tar =double(0);

for x =1:target_x
    for y = 1: target_y
        avgray_tar = avgray_tar + tar_gray(x,y);%����ģ����ܻҶ�ֵ
    end
end
avgray_tar = avgray_tar/xy;%ģ��ƽ���Ҷ�ֵ
for w =1 : (image_x-target_x-1)
    disp(w);
    for h = 1:(image_y-target_y-1) 
        avgray_im=double(0);
        tempt_image = im_gray(w:w+target_x-1,h:h+target_y-1);%�ü���ģ���С������
       
        for x  =1:target_x
            for y = 1:target_y
                avgray_im = avgray_im + tempt_image(x,y);%����ü�������ܻҶ�ֵ
            end
        end
        avgray_im = avgray_im/xy;%�ü����ֵ�ƽ���Ҷ�ֵ
        err_tar =double(0);%ģ��ĻҶ����
        err_img =double(0);%�ü�����ĻҶ����
        err_all = double(0);%�������
        var_img =double(0);%�ü������׼��
        var_tar = double(0);%ģ���׼��
        for x=1:target_x
            for y=1:target_y
                err_tar = (tar_gray(x,y) - avgray_tar);
                err_img = (tempt_image(x,y)-avgray_im);
                err_all = err_all+err_tar*err_img;
                var_tar = power((tar_gray(x,y)-avgray_tar),2)+var_tar;
                var_img =power((tempt_image(x,y)-avgray_im),2)+var_img;
            end
        end
        ncc(w,h) = ((err_all)/(sqrt(var_tar)*sqrt(var_img)))/(xy-1);%����NCCֵ
    end
end
max_ncc = max(max(ncc));
[max_x,max_y] = find(ncc == max(max(ncc))); %�ҵ����ƥ��ֵ��λ��
figure(1)
imshow(uint8(target));
ncc=mapminmax(ncc,-1,1);%��һ����[-1,1]
figure(2)
imshow(uint8(image));%��ԭͼ
hold on;
show = imagesc(ncc);    %���ݾ����Ϊ����ͼ
set(show,'AlphaData',0.6); %����͸����
rectx =[max_y,max_x,target_y,target_x]; %���þ�������
rectangle('Position',rectx,'Edgecolor','r','LineWidth',2);%�����Σ���shai����2
toc
disp(toc)
