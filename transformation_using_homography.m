img1 = imread('wall1.jpg');
img2 = imread('wall2.jpg');

% img1 = imread(fullfile('homog2','IMG_20211207_112741.jpg'));
% img2 = imread(fullfile('homog2','IMG_20211207_112743.jpg'));
% img3 = imread(fullfile('homog2','IMG_20211207_112745.jpg'));

figure(1)
subplot(121), imagesc(img1)
subplot(122), imagesc(img2)

%% manually select pairs of points
u1 = [];
u2 = [];
v1 = [];
v2 = [];
for i = 1:4
    title('')
    subplot(121)
    title('Select point from image 1')
    [x,y] = ginput(1);
    u1 = [u1;x];
    v1 = [v1;y];
    hold on
    plot(x,y,'y*')
    text(x,y,num2str(i))
    hold off
    
    title('')
    subplot(122)
    title('Select corresponding point from image 2')
    [x,y] = ginput(1);
    u2 = [u2;x];
    v2 = [v2;y];
    hold on
    plot(x,y,'y*')
    text(x,y,num2str(i))
    hold off
end

%% Computing homography 

% Initialize A matrix
A = [];

for i = 1:4
    x = u1(i);
    y = v1(i);
    xp = u2(i);
    yp = v2(i);
    
    A = [A;
         -x, -y, -1, 0, 0, 0, x*xp, y*xp, xp;
         0, 0, 0, -x, -y, -1, x*yp, y*yp, yp];
end


% Solving for H

% Compute SVD
[U, S, V] = svd(A);

% Solution is the last column of V
h = V(:, end);

% Reshape h to form the transformation matrix H
H = reshape(h, [3, 3])';
disp('Homography matrix H:');
disp(H);
% show transformed image
tform = projtform2d(H);
img12 = imwarp(img1,tform);

figure(2)
imagesc(img12)

%%
figure(3)
imagesc(img2)