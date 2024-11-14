clear; clc; clf; close all;


% 01 - wczytanie kaczek i binaryzacja - kaczki biale, tlo czarne
im = rgb2gray(double(imread("kaczki.jpg"))/255);
t=graythresh(im);
bim=im;
bim(bim<t)=0;
bim(bim>=t)=1;
bim=1-bim;
bim=imclose(bim,ones(15));

% lub 

bim = ~imbinarize(im, 0.6);
bim=imclose(bim,ones(15));

% imshow(bim);


% morfologia - rozne funkcje:
% clean - pozbywa sie bialych pikseli,
% fill - pozbywa sie pojedynczych czarnych pikseli,
% open i close tak samo jak wyzej ale mniej dokladne bo bez parametrow, 
% remove - usuwa wnetrze zostaje krawedz, tak jak w filtrze krawedziowym
% diate -

%   SKLADNIA:     bim = bwmorph(bim, 'funckja')


%   ZNAJDZ KRAWEDZIE = BIM - Eroza(BIM) = REMOVE
rim = bwmorph(bim,"remove"); % znalezienie ksztaltu, usuniecie wypelnienia
imshow(rim);


%   ZNAJDZ SZKIELET - SZKIELETYZACJA
figure;
% sk = bwmorph(bim,"skeleton",37); % wytworzenie szkieletu obrazka, przy kilkudziesieciu razach (37) przestaje sie redukowac, im wieksza rozdzielczosc tym wiecej razy trzeba zrobic, zamiast liczby inf
sk = bwmorph(bim,"skeleton",inf);
imshow(sk);
% # usuwa wartwa po warstwie do puki nie dostaniemy samego szkieletu - zbier punktow rowno odlegoych


%   ZNAJDZ PUNKTY KONCOWE
figure;
ep = bwmorph(sk,"endpoints");
% imshow(ep); %znalezienie punktow z konca linii na szkielecie

%   ZNAJDZ PUNKTY GDZIE SIE ROZGALEZIA
figure;
branch_points = bwmorph(sk,"branchpoints");
imshow(branch_points);


%   [y,x]=find(pt==1); %znalezienie wpsolrzednych punktow o wartosci 1
% mozna nalozyc te punkty na jakis konkretny obrazek
%pt = find(pt > 0.7);
%sim = im;
%sim(pt) = 1;
%imshow(sim);


% SHRINK - erozja nie zmieniajaca liczby eulera ksztaltu - ilosc dziur -
% nie zrbi nam z 1 objektu 2 - redukujemy zawsze obiekt do zbioru punktow
% lub punktu ale zawsze zelacego w obiekcie
figure; 
shrinked = bwmorph(bim,"shrink",inf);
% imshow(shrinked);

% cos na zasadzie erozji, zwezanie kaczki, na samym koncu pojedyncze piksele, majac jeden piksel mozemy wiedziec gdzie ktora kaczka sie znajdowala, 
% punkt to nie srodek masy, piksel nalezy do kaczki


% THIN
% redukuje kazdy z obiektow do jedenj sciezkiktora ma grubosc 1px
% tam gdzie interesuje nas przebieg lini a nie sama grubosc lini
% np miasto a polaczone z miastem b
%np w ocr - jak pismo odreczne - nie interesuje nas jakgruba linia tylko jak idzie

% Liczba eulera - ilosc obiektow - ilosc dziur - wazne zachowanie tej
% liczby, thin i shrink zachowuja ta liczbe, ilosc obiekt-dziura taka sama,
% wazne zeby sie nie robily dziury

figure;
thined = bwmorph(bim, "thin", inf);
% imshow(thined)

% THICKEN - dylatacja zachowujaca granice miedzy obiektami - tworzy
% segmenty - w kazdym segmencie na pewno jest dokladnie 1 obiekt
figure;
thickened = bwmorph(bim, "thicken", 10);
imshow(thickened)

figure;
thickened = bwmorph(bim, "thicken", 20);
imshow(thickened)

figure;
thickened = bwmorph(bim, "thicken", 30);
imshow(thickened)

figure;
thickened = bwmorph(bim, "thicken", inf);
imshow(thickened)


% tlo - etykieta 0
% kaczka 1 - etykieta 1
% kaczka 2 - etykieta 2
% kaczka 3 - etykieta 3


figure;
l = bwlabel(bim);
imshow(label2rgb(l)); %nadanie kazdemu segmentowi osobnego koloru


% tylko kaczka nr 2
figure;
kaczka_nr_2 = (l==2);
imshow(label2rgb(kaczka_nr_2));
%imshow(kaczka_nr_2 .* im); - na oryginalnym zdjeciu
imshow(kaczka_nr_2 .* bim .* im); 

% Policz kaczki 
policzone_kaczki = max(l(:));



%    l          |         bim        |         im
% -----------------------------------------------------
% podzial       |      ksztalty      |      jasnosci
% kaczka nie kaczka                        kolory

% SEGMENTACJA PRZEZ POGRUBIANIE - to co robilismy powyzej - pogrubiamy tak
% dlugo az dostaniemy osobne segmenty

% INNA SEGMENTACJA - transformata odleglosciowa
figure;
d = bwdist(bim); %      funkcja realizujaca transformate - im dalej od kaczki tym jasniej, rozne spoosby liczenia odleglosci, standardowo 'euclidian'
imshow(d, [0, max(d(:))]);

figure;
nd = bwdist(~bim); 
imshow(nd, [0, max(nd(:))]);



% zlewiska - obszar do ktorego wszystko sie zlewa - jak w gorach i woda
% wododzial - granica miedzy nimi
% jesli splywa do jednego zbiornia to zanczy jest to jeden segment
figure;
l = watershed(d);
imshow(label2rgb(l));

% odleglosc euklidesowa :
% L1 = d = root 1rd ( a^1 + b^1) 
% L2 = d = sqrt ( a^2 + b^2)
% L infi = root inf st ( a^inf + b^inf ) = max { a,b } 
% 
% cityblock - manhatan
% chessboard - chebyshev

figure;
d = bwdist(bim, "chessboard");
l = watershed(d);
imshow(label2rgb(l));


figure;
d = bwdist(bim, "quasi-euclidean");
l = watershed(d);
imshow(label2rgb(l));


figure;
d = bwdist(bim, "cityblock");
l = watershed(d);
imshow(label2rgb(l));
