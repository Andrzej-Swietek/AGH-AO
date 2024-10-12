clear; clc;

% ----------- vector ----------- 

a = [1,2,3];
 
% ----------- macierz ----------- 

a = [1,2,3; 4,5,6 ];

% praca na indexach - indexujemy od 1
a(1,2);

% pod macierze / pod vectory
a(1, [1,3]) % 1,3

a(2, :3)    % 4,5,6

% end dla macierzy - ostatni index

a(2,1:end);

a(2, : ) % to samo co 1:end

a(:, 1)  % pierwsza kolumna wszytkich wierzszy


% jaka robimy a(3) to jakby idziemy kolumnami

% a(1) a(4) a(7)
% a(2) a(5) a(8)
% a(3) a(6) a(9)

a(a>2);

% ans =
% 
%      4
%      5
%      3
%      6


a(a>2) = 15:19;


a = [1,2,3;4,5,6];
b =  = [7,8,9; 5, 2,7];


a' * b; % Transpozycja a nastepnie mnozenie
a * b';
a ./ b;


% skalarnie
a + b;
a - b;
a .^ b; % np do budowania wielomianow
a .^ 2; % kazdy element a do kwadratu

X = 0 : .1 : 10
Y = sin(x)
plot(x,y)
%  ----------- ciag ----------- 

 c = 1: 10;      % od 1 do 10 wlacznie

 d = 1 : 0.4 : 10; % ostatni 9.8

 % ciag malejacy

 e = 10 : 1;