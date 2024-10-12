clear; clc; clf; close all;

im = imread('zubr.jpg'); % uint8 0-255 | 642 x 1000 x 3 - 3 to rgb

% imshow(im); % wyswietlenie obrazka

im = double(im) / 255; % rzutowanie do double - normalizacja zeby miec dalej ten sam obraz (/255)

imshow(im);  % funkcja im show spodziewa sie 0 lub 1 jak cos pomiedzy to zaokragla


% kilka obrazkow na raz - osobne okna
% figure;
% imshow(im);


% ================ ZUBR RGB MULIPLOT ================ 

% kilka obszarów jednego okna
h=2;
w=2;
% RGB
subplot(h,w,1)
imshow(im)
% sama warstwa zielona r = img(:,:,1)
subplot(h,w,2) 
r = im(:,:,1);
imshow(r)
% sama warstwa zielona g = img(:,:,2)
subplot(h,w,3)
g = im(:,:,2);
imshow(g)

% sama warstwa niebieska b = img(:,:,3)
subplot(h,w,4)
b = im(:,:,3);
imshow(b)

figure;
% ================ ZUBR HISTOGRAM ================ 
h=3;
w=2;

for i = 1:3
    image = im(:,:,i);
    subplot(h,w,2*i-1)
    imshow(image);

    subplot(h,w,2*i)
    imhist(image)
end


figure;
% ================ ZUBR KONWERSJA DO SKALI SZAROSCI ================ 
% chcemy policzyc srednia arytmetyczna 3 warstw (R,G,B)
% gotowa funkcja rgb2gray(im)
gray_image = mean(im, 3); % usredniamy w 3 kierunku
imshow(gray_image);

% ale mozna uzyc innych funckji akumulacyjnych jak min,max , median,
% srednia wazona np dla jakis kolorow wieksza waga - bo np slonce swieci to
% trzeba najwiecej jest na srodku (zielone) swiatla widzialnego
% zielony widzimy lepiej pozniej czerwony a na koncu niebieski

figure;
% o tym mowi standard yuv 
% on nadaje wagi dla kolorow rgb
YUV = [.299, .587, .144];

% mnozymy razy wektor 1x1x3 - obracamy funkcja permute(YUV, [1,3,2]) -
% drugi z 3 wymiarem zmieniamy
YUV = permute(YUV, [1,3,2]);

im_yuv = sum(im .* YUV,3) ;
imshow(im_yuv)


% ================ ZUBR PRZEKSZTALCENIA ================
% Jak zrobic korekcje tych 3 wartosci
% 1. Jasnosc - zmieniamy wszystkie o te sama stała - dodawanie 
% 2. Kontrast
% 3. Gamma

% ========== JASNOSC
figure;
b = .2;
bim = gray_image + b;
bim(bim>1) = 1; % jakby wyszlo poza 0-1
bim(bim<0) =0;  % jakby wyszlo poza 0-1
imshow(bim)

h = 2;
w = 2;
subplot(h,w,1)
imshow(gray_image)
subplot(h,w,2)
imhist(gray_image)
subplot(h,w,3)
imshow(bim)
subplot(h,w,4)
imhist(bim)

% funkcja przeksztalcenia liniowego miedzy obrazkami
figure;
x = 0:(1/255):1;
y = x + b;
y(y>1) = 1;
y(y<0) = 0;
plot(x,y)
ylim([0,1])



% ========== KONTRAST - roznica miedzy wartosciami
figure;
c = .5;
cim = gray_image * c;
cim(cim>1) = 1; % jakby wyszlo poza 0-1
cim(cim<0) =0;  % jakby wyszlo poza 0-1
imshow(cim)

h = 2;
w = 2;
subplot(h,w,1)
imshow(gray_image)
subplot(h,w,2)
imhist(gray_image)
subplot(h,w,3)
imshow(cim)
subplot(h,w,4)
imhist(cim)


% funkcja przeksztalcenia liniowego miedzy obrazkami
figure;
x = 0:(1/255):1;
y = x*c;
y(y>1) = 1;
y(y<0) = 0;
plot(x,y)
ylim([0,1])


% ========== GAMMA - roznica miedzy wartosciami
figure;
gamma = 0.5; % 2; % inna opcja .5;
gamma_im = gray_image .^ (1/gamma);
imshow(gamma_im)

h = 2;
w = 2;
subplot(h,w,1)
imshow(gray_image)
subplot(h,w,2)
imhist(gray_image)
subplot(h,w,3)
imshow(gamma_im)
subplot(h,w,4)
imhist(gamma_im)

% funkcja przeksztalcenia miedzy obrazkami
figure;
x = 0:(1/255):1;
y = x.^gamma;
y(y>1) = 1;
y(y<0) = 0;
plot(x,y)
ylim([0,1])


% b in (-1,1)
% c in (0, infi) a tak naprawde do 255
% g in (0, infi)

% wartosci neurtalne : b=0
% jak by chcec zrobic suwak dla c i g to trzeba log(c) 

% Calkowite przeksztalcenie
% Y = c X^(g) + b


% =================== WYROWNANIE HISTOGRAMU ===================
% jest to operacja deterministyczna
% rozrzedzi histogram i nie bedzie on dokladnie rowny - jedynie rowniejszy
% wysokosc histogramu musi byc zachowana
% jedyne co mozna robic to przestawiac slupki na siebie
% ubywa nam informacji wiec normalnie nie chcemy tego uzywac - chyba ze nic
% na nim nie widac 
%
% algorytm: dystrybuanta empiryczna
figure;
him = histeq(gray_image);

h = 2;
w = 2;
subplot(h,w,1)
imshow(gray_image)
subplot(h,w,2)
imhist(gray_image)
subplot(h,w,3)
imshow(him)
subplot(h,w,4)
imhist(him)
