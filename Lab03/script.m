clear; clc; clf; close all;

im = imread('zubr.jpg');
im = double(im) / 255; 
im = rgb2gray(im);
% imshow(im); 

% pixele sasiaduja jesli maja conajmniej jeden wspolny wierchołek

% mozemy patrzec na sasiedztwo
% - krawiedz    ( von Neiman )
% - wierzchołek ( moore )

% rzad sasiedztwa - np 2 rzad sasiedzi sasiada


% w filtrze srdokowy pixel w macierzy filtru to ten na ktory patrzymy a te do okaola to jego sasiedztwo

% ## FILTRY - FILTR UŚREDNIAJACY -- BLUR
% zastosowania:
%   - dziwne extrem
%   - dziwne białe pixele/kropki w środku żubra
%   - odszumianie

k = 33;
f = ones(k) / k^2; % usredniamy wartosci przestow bardziej sie zlewaja wiec dostajemy efekt blur

% filtracja realizowana przez funkcje
fim = imfilter(im, f);

h=1; w=2;
subplot(h,w,1)
imshow(im)
subplot(h,w,2) 
imshow(fim)

% ======= Różne wagi =======

k = 3;
% f = ones(k) / k^2;
f = [ 1 2 1; 2 4 2; 1 2 1 ] / 16;
fim = imfilter(im, f);

figure;
h=1; w=2;
subplot(h,w,1)
imshow(im)
subplot(h,w,2) 
imshow(fim)

% jak mamy rozkład gausaa w 2 wymiarach to nazywamy to gaussian blur

% rozmywanie w kierunku np w pionie

f = [ 0 0 0; 2 4 2; 0 0 0 ] / 8;
fim = imfilter(im, f);

figure;
h=1; w=2;
subplot(h,w,1)
imshow(im)
title("Oryginał")
subplot(h,w,2) 
imshow(fim)
title("Rozymwanie w pionie")

% wagi ujemne - uwypuklamy roznice na obrazie
figure;
k = 3;
f = -ones(k);
f((k+1)/2, (k+1)/2) = k^2;
fim = imfilter(im, f);
h=1; w=2;
subplot(h,w,1)
imshow(im)
title("Oryginał")
subplot(h,w,2) 
imshow(fim)
title("Wagi ujemne")



%% Filtr krawedziowy sumuja sie do zera - jak suma wag = 0 zawsze jakos
% pokaze krawedzie
figure;
f = -ones(k);
f((k+1)/2, (k+1)/2) = k^2 -1;
fim = imfilter(im, f);
h=1; w=2;
subplot(h,w,1)
imshow(im)
title("Oryginał")
subplot(h,w,2) 
imshow(fim)
title("Wagi ujemne")

%% Filtr medianowy - troche bardziej widac krawedzie - jak na filtr dolnoprzepustowy
% bardzo dobry do odszumiania bo nie jedzie tak po bryle - krawedziach
k=3;

% segment podstawowy
figure;
fim = medfilt2(im, [k,k]);
imshow(fim)
title("Filtr medianowy")

%% Binaryzacja
figure;
bim = im;
bim( bim < .5)  = 0;
bim( bim >= .5) = 1;

h=1; w=1;
subplot(h,w,1)
imshow(bim)
imshow(bim)


% inna wartość progowa dla np ciemniejszych / jasniejszych obrazow
% 
% figure;
% imhist(im)

figure;
bim = im;
t = 0.6;
bim( bim < t)  = 0;
bim( bim >= t) = 1;

h=1; w=1;
subplot(h,w,1)
imshow(bim)
imshow(bim)



% najlepsza metoda dobierania progow to reczna



% opcja zautomatyzowana graytrash znajdowania progu

figure;
bim = im;
t = graythresh(im);
bim( bim < t)  = 0;
bim( bim >= t) = 1;

h=1; w=1;
subplot(h,w,1)
imshow(bim)
imshow(bim)
title("Graytresh - Binaryzacja")


figure;
bim = 1 - bim;
imshow(bim)
title("Graytresh - Binaryzacja v2")

figure;
bim = imbinarize(im,t);
bim = ~bim; % -- nagtyw - zapreczenie bo ma typ logoczny (01)
imshow(bim)
title("Binaryzacja imbinerize")


figure;
bim = imbinarize(im,'adaptive');
bim = ~bim; % -- nagtyw - zapreczenie bo ma typ logoczny (01)
imshow(bim)
title("Binaryzacja imbinerize - adaptive")



%% Operacje na obrazach binarnych

figure;
t=0.6;
bim = imbinarize(im,t);
bim = ~bim; % -- nagtyw - zapreczenie bo ma typ logoczny (01)
imshow(bim)
title("Binaryzacja imbinerize")


bim_med = medfilt2(bim, [3,3]);
figure;
h=1; w=2;
subplot(h,w,1)
imshow(bim)
title("Obraz binarny")
subplot(h,w,2) 
imshow(bim_med)
title("F. Medianowy")


%% MORFOLOGIA

% erozja - usuwa male elementy

% dylatacja - wypelnianie dziur


% erozja + dylatacja nie koniecznie da ten sam obraz - czasem da
% zwlaszcza jak mamy maly obiet - erozja usunie a dylatacja go nie
% przywroci bo go nie ma


% Otwarcie morfologiczne   = obraz -> erozja -> dylatacja


% Zamkniecie morfologiczne = obraz -> dylatacja -> erozja


e = imerode(bim, ones(3));
d = imdilate(bim,ones(3));
o = imopen(bim,  ones(3));
c = imclose(bim, ones(3));

figure;
h=2; w=2;
subplot(h,w,1)
imshow(e)
title("Erozja")
subplot(h,w,2) 
imshow(d)
title("Dylatacja")

subplot(h,w,3)
imshow(o)
title("Otwarie")
subplot(h,w,4) 
imshow(c)
title("Zamkniecie")

% Wyciecie zubra - maskowanie
figure;
c = imclose(bim, ones(7));
imshow( im .* c )


figure;
im_rgb = imread('zubr.jpg');
im_rgb = double(im_rgb) / 255; 
c = imclose(bim, ones(7));
imshow( im_rgb .* c )



%% Filtry w matlabie - np prewitt

h = fspecial('prewitt');
prewitted =  imfilter(im,h,"replicate");
imshow(prewitted)


%% Motion filter
H = fspecial("motion",20,45);
motionBlur = imfilter(I,H,"replicate");
imshow(motionBlur)
