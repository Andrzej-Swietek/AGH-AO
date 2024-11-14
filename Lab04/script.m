% Transformacja - zamiana postaci reprezentacji 
% transformata - wynik transformacji - musi byc odwracalny

% Przekształcamy problem na inny
% Problem A -> A*
%         ||   |
%         B -> B*    

% Transformata Lorentza - sterowania - kiedy właczyc klimatyzacje zeby po godzinie byla
% temperatura

% funckje bazowe f_1 - zero wszedzie poza 1 ptk gdzie ma wartosc 1
% funckje bazowe f_2 - zero wszedzie poza 1 ptk gdzie ma wartosc 1
%                ... itd ...
% funckje bazowe f_n - zero wszedzie poza 1 ptk gdzie ma wartosc 1
%         
% f(x) = y = sum y_i * f_i(x) - kazda funkcje mozna zapisac jako sume
% funkcji bazowych

% Transformata Fouriera - zmieniamy przestrzen funckji bazowych - kazdej
%   funckji przypisujemy funkcje typu sinus(x) - i tym czym sie roznia to
%   czestotliwoscia - czestostliwosci przypisujemy amplitude
%   f(x,y) = z
%   y = Asin(wx + fi) --> omega czestotliwosc jest odpowiednikiem y_i
%   A \in [0, +infi)  - amplituda jest nieujemna
%   fi \ [0,2pi), - dowolny przedzial o szerokosci 2pi -> u nas [-pi, pi)

% my chcemy za pomoca zapisac za pomoca jednej liczby zapisac 2 -> liczba
% zespolona ale mamy te constrainy dziedziny wiec zapis katowy fi i |z|=A

% z = a + ib
% A = sqrt( a^2 + b^2 )   z = A*e^(i*fi)
% fi = arctg( b / a )
clear; clc; clf; close all;

im = rgb2gray(double(imread("opera.jpg"))/255); % wczytujemy obrazek
fim = fft2(im); % fft 2D

A = abs(fim);
phi = angle(fim); 

imshow(log(A), [ 0, log(max(A(:))) ]) % - musimy zmienic zakres z 0-1

% poniewaz transformata fouriera jest okresowa mozemy zamienic cwiartki 1 z 3 i 2 z 4 - ale to te same dane

imshow(fftshift(log(A)), [ 0, log(max(A(:))) ])

% kazdy punkt pokazuje aplitude punktów z ktorych sklada sie opera

z = A.*exp(1i * phi); % 1i to urojona jednostka
im2 = abs(ifft2(z)); % powrot do oryginału
imshow(im2);

% zwiekszenie amplitudy -> pojawiły sie nam takie fale
% A(5,8) = 10^5; % czestotliwosc pojawiania sie amximu to (n-1, m-1)i nas 4 i 7 bo (5,8)
% z = A.*exp(1i * phi); 
% im2 = abs(ifft2(z)); 
% imshow(im2);

% A(5,end-3) = 10^5; % cw druga strone fale
% z = A.*exp(1i * phi); 
% im2 = abs(ifft2(z)); 
% imshow(im2);



% Amplituda - punkt reprezentuje zaleznosc miedzy punktami w zdlaz tych
% lini - w druga strone sa takie same zaleznosci 

% Dwa punkty sa podobne - obie jasne obie ciemne lub jedno jasne drgue ciemne

% wysokie amplitudy oznacza kreski 
% niska wartosc - poziome krawedzie


% Faza - bierzemy amplitude i układamy z niej opere
imshow(phi, [-pi,pi]);



% w dziedzinie czestostliwosciowe filtracja:
% - mnozymy amplitude przez wartosc amplitudy filtra
%   A.*f_A
% ma wyrazna strukture takich kwadracikow ( jest ich k na k)
k = 11;
f = ones(k)/k^2;
imfilter(A, f);
[h,w] = size(im);
ff = fft2(f,h,w);
fA = abs(ff);
fphi = angle(ff);
imshow(log(fA), log([min(fA(:)), max(fA(:))]));
imshow(fphi, [-pi,pi]);

% filteracja
z = fA.*A .* exp(1i * phi);
im2 = abs(ifft2(z));

imshow(im2);

% Jak chcemy wiecej filtów nalozyc to poprostu mnozymy ...

% maska - wyciecie danych z poza rogow (rogi trzymaja wszystko co jest istosne) - wycinamy czesc informacji - kompresja

m = zeros(h,w);
k = 20; % k =100, 50, 20 % dlugosc kwadratu w rogu ktory zostawiamy
m([1:k, end-k:end],:) = 1;
m(:, [1:k, end-k:end]) = 1;

% m([1:k, end-k, end],[1:k, end-k, end]) = 1;

z = m .* A .* exp(1i * phi);
im2 = abs(ifft2(z));
imshow(im2);


% Sprawozdanie:
% - co robione było na laboratoriach
% - nie trzeba wstepow teoreycznych
% - krotkie wnioski
% - wstawianie obrazka: podpis - wynik jakiej operacji
% - tresc nawiazuje do obrazka a obrazek do tresci
% - nie wrzucac miliona obrazkow na raz
% - mail - tytół: Andrzej Świętek - Sprawozdanie AO - 1 - format PDF
% Nazwisko_Imie_1.pdf
% nama maila .fis.agh.edu.pl
% na 21.11.2024 16:24





