clear; clc; clf; close all;

% 01 - wczytanie ptakow i binaryzacja - ptaki biale, tlo czarne
im = rgb2gray(double(imread("ptaki.jpg"))/255);
t=graythresh(im);
bim=im;
t=0.277;
bim(bim<t)=0;
bim(bim>=t)=1;
bim=1-bim;
bim=imclose(bim,ones(15));
imshow(bim)

% jasnosc gesi pokryw sie z jasnoscia tła
% nie da sie postawic dobrze progu
% poniewaz nie ktore kanały nadrabiaja za inne to 

% na niebieskim spodziewamy sie zobaczyc gesi najlepiej 

%wyswietlenie skladowych kolorow w skali szarosci
figure;
im = double(imread("ptaki.jpg"))/255;
subplot(2,3,1);
imshow(im(:,:,1));
subplot(2,3,2);
imshow(im(:,:,2));
subplot(2,3,3);
imshow(im(:,:,3));
subplot(2,3,4);
imhist(im(:,:,1));
subplot(2,3,5);
imhist(im(:,:,2));
subplot(2,3,6);
imhist(im(:,:,3));

% czerwonego mało - rawie wcale
% top co sie zmienia to ilosc zieolengo - gradient ktory nam rozkłada binaryzaacje
% niebieska fajnie duzo info 

% jasne czesci z czerownego 
% niebieskie czesci z niebieskiego

%zabranie czesci ptakow z poszczegolnych kolorow
figure;
r=imbinarize(im(:,:,1),.3);
b=imbinarize(im(:,:,3),.5);
bim=r|~b; %wczesniej bylo r|b ale wyciagane biale i czarne bylo na odwrot wiec trzeba odwrocic niebieski
bim=imopen(bim,ones(7));
subplot(3,1,1);
imshow(r);
subplot(3,1,2);
imshow(b);
subplot(3,1,3);
imshow(bim);


figure;
bim = imclose(bim, ones(5));
bim = imopen(bim, ones(5));
l = bwlabel(bim); % labelowanie
n = max(l(:));

figure;
a = regionprops(l == 4, 'all');
% imshow(a);

% a -jest stuktura
% area - pole powierzchni w pixelach - liczy ile bialych pixeli
% centroid - srodek masy fizycznie przy zalozeniu jednorodnosci
% bounding box - najmniejszy brostokat ktory jest w stanie opisac figure - rownolegly do osi ukladu 4 liczby x1 x2 y1 y2

% najmniejszy jaki kolwiek prostokat opisujacy figure
% major axis lenght - dlugosc osi w ktorej ma najdluzsza rozpietosc
% minor axis length - pod katem prostym do osi glownej

% excentricity - przesuniecie srodka masy w zgledem srodka bounding boxa (0-1)

% orientation - kat glownej osi

% convex ... - dla 3d - powierchnia zewnetrzna

% image - wyciety obrazek

% filed image - ten sam obrazek tylko z wypelnionymi dziurami -
% zastosowanie dla np tomografia kosci/betonu pow porowate - jak duza czesci jest wypelniona

% eluer number - ilosc obiektow - ilosc dziur

% extrema wspolrzedne prawo lewo gora dol najbardziej wysuniete - jest 8 bo
% moze byc wiecej niz jeden punktow extremalnych - dla kazdego kierunku po
% 2 punkty - jesli jeden taki punkt to zwracami go 2 razy

% solidity - stounnek pola figury do pola bounding boxa - miar jak duza czesc przestrzeni wypelnia powierchnie


% perlimiter - obwod - z dystansow kwazi euklidesowych lub wielomain przyblizyc
% perlimiter - stary sposob licznia

% Osie Fereta dlugosci bounding boxa


% chcemy porownywac do czegos a tym czyms najlepiej jak jest do kolo - 
% - nie zalezy od osi uklady wszytko
% - parametryzowane 1 liczba 
% - jest extremalne w ktora ze stron

% Pole kola jest taki jak pole kasztaltu 
% pole kazdej figury da sie przyrowna do pola kola o jakims promieniu
%  R = sqrt(A/pi)

% mozem yetz zrobic z obwodem ze powiemy ze obwod tej figury jest rowny obwodowi figury 
% R_p = P/(2pi) 

% R_a/R_p \in (0,1] -  stosunek kol nizalezny od skali - circularity

% Czesto podobienstwo wyrazamy przez niepodobienstwo jak nie podobienstwo = 0 to sa takie same

%   wspolczynnik ksztaltu Ra/Rs
%   wspolczynnik malinowskiej - Rp/Ra-1 : im blizej kola tym blizej zera
%   wspolczynnik Bloir-Bliss  - 
%   wspolczynnik Danielssona  - to co wyzej z centroidem tylko dla do krawedzi - dla kola malo
%   wspolczynnik Haralicka    - srednia odlegosc od najblizszej krawedzi - dla kola duzo
%   wspolczynnik Fereta

% A O 5 

AO5RBlairBliss(bim)

%macierz wszystkich wspolczynniki dla wszystkich kaczek

%        W1 W2 W3 W4 W5 W6 W7 W8
%     g1
%     g2
%     g3
%     g4
%     g5
%     g6
%     g7
%     g8

% @ uchwyt do funkcji w matlab
% f{} - wywołanie funkcji

fm = {@AO5RBlairBliss, @AO5RCircularityL, @AO5RCircularityS, @AO5RDanielsson, @AO5RFeret, @AO5RHaralick, @AO5RMalinowska, @AO5RShape};
matrix = zeros(max(l,[],"all"),length(fm));
for i = 1:length(fm)
    for j = 1:max(l,[],"all")
        matrix(j,i) = fm{i}(l==j);
    end
end

% mean gęś
mg = mean(matrix);
std_gesi = std(matrix);
c = abs( matrix - mg ) ./ std_gesi;

% 1 sigma = 67.5 %
% 2 sigma = 95 %
% 3 sigma = 99.7 %

% jak jest 3 sigma to mozna przyjac ze to nie ges

%   1. zazwyczaj 5% z jednej i drugiej strony mozna ociac i nic sie nie stanie
%   2. Liczac c liczymy statystyki pomijac ta sama liczbe dla samej siebie
%   3. mediana

%     6.77628991990655	267.380304394384	148.054354890900	101.912626862647	0.510040160642570	78.2537691717737	0.805960416303961	3.26149302525678
%     5.93480284082396	199.261988751053	118.796410357572	87.8769974563456	0.913513513513514	69.3915828352638	0.677340149852035	2.81346997830565
%     5.26654408818064	147.695787189279	89.9665703796773	78.3865319067816	0.862318840579710	51.0660336405955	0.641674085896267	2.69509380430334
%     6.57492739997189	247.326781564805	144.978061804150	95.2472089332038	0.802521008403361	83.8906792259086	0.705960050003406	2.91029969220762
%     5.63247919297187	170.932408880696	102.197768984761	76.4720523174033	0.766467065868264	60.0018075712367	0.672564974546402	2.79747359407941
%     6.17273380682958	226.954948849043	123.195029823622	109.173993526014	0.736318407960199	67.2948708475532	0.842241112924550	3.39385231814949
%     5.79644698501846	160.428182636631	105.610503321782	72.3835836174065	0.497041420118343	56.6395746188149	0.519055184765351	2.30752865436249
%     3.01844422784842	36.2873270249521	28.8785716717696	17.2142400184282	2.61111111111111	15.5398506102445	0.256548538389974	1.57891422932998


for i = 1 : n
    tM = matrix;
    tM(i, :) = [];
    mg = mean(tM);
    sg = std(tM);
    c(i,:) = abs( matrix(i,:) - mg ) ./ sg;
end

% wszystkie gesi ok poza ostatnia


% Lab 07

test = c > 3;
% # kiedy nietypowy ? jeden wspolczynnik lub wszystkie? -> zakladamy 2
test = sum(test,2) > 1; % dla ktorego wiersza sa nietypowe conajmniej 2 wspolczynniki

% M(test, :);
idx = find(test); % index obiektu - 8 - kawałek skrzydla w rogu

% usuwanie obiektu dla kazdego obiektu w idx prypisujemy 0 - tlo
l(l==idx) = 0; 

l = bwlabel(l > 0);   % liczymy jeszcze raz obiekty 
n = max(l(:));        % ilosc obiektow
% M(idx,:) = [];


%% PTAKI 2

im2 = (double(imread("ptaki2.jpg"))/255);
bim2 = ~imbinarize(im2(:,:,3)); % na niebieskim bo czysciej
bim2 = imopen(bim2, ones(3));
bim2 = imclose(bim2, ones(3));
l2 = bwlabel(bim2); 
for i = 1 : max( l2(:) )
    if sum(l2 == i, 'all') < 1000
        l2(l2 ==i) = 0; % usuwanie
    end
end
l2 = bwlabel(l2 > 0);
n2 = max(l2(:));
fm = {@AO5RBlairBliss, @AO5RCircularityL, @AO5RCircularityS, @AO5RDanielsson, @AO5RFeret, @AO5RHaralick, @AO5RMalinowska, @AO5RShape};
M2 = zeros(max(l2,[],"all"),length(fm));
for i = 1:length(fm)
    for j = 1:max(l,[],"all")
        M2(j,i) = fm{i}(l==j);
    end
end

imshow(label2rgb(l2))



%% Problem klasyfikacji - Gęś vs Kaczka

% x wspolczynniki geometryczne -> f -> y: label kaczka/ges

% ================================ Warstwa I=======================================  
%     x1   *w1 + b \
%     x2   *w2 + b  \
%     x3   *w3 + b   -  sum -> funkcja aktywacji sigmoid z1 = [-1,1] --
%     perceptron  
%     ...           /
%     x8   *w8 + b /

% z innymi wagami 
%     x1   *w1_2 + b \
%     x2   *w2_2 + b  \
%     x3   *w3_2 + b   -  sum -> funkcja aktywacji sigmoid z2 = [-1,1] -- perceptron
%     ...           /
%     x8   *w8_2 + b /


% z innymi wagami 
%     x1   *w1_2 + b \
%     x2   *w2_3 + b  \
%     x3   *w3_3 + b   -  sum -> funkcja aktywacji sigmoid z2 = [-1,1] -- perceptron
%     ...           /
%     x8   *w8_3 + b /





% Wartwa I -- > Wartwa II ---> ... ---> suma Po ostatniej wartwie --> funckja --> y1


% Siec typu feed forward

% pojedyncze wejscie to wektor kolunowy
iu = [matrix(1:end-2,:)', M2(1:end-2,:)']; % wejscie uczace z M bierzemy wartosci ( nie wszystkie bo chcemy czyms testowac ) od 1 do 2 od konca 8x9
it = [matrix(end-1:end,:)', M2(end-1:end,:)'];
ou = [ones(1,n-2), zeros(1,n2-2)];

nn = feedforwardnet;
nn = train(nn, iu, ou);
