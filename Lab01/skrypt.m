% nie mozna nazwac skryptu jak zmienne w srodku

%{
    Komentarz pisany prozą
    Ewentualnie do dlugich opsisow algorytmow
%}

clear; clc; clf;

% IF
a = 5;
if a > 3
    a = 2;
elseif a > 100
    a = 0;
else
    a = 7;
end



% WHILE LOOP
while a > 3
    a = a - 1;
end

% FOR + break, continue
kolekcja = 1 : 10;
for i = kolekcja 
    i
end


% ---- Rozwiazanie problemu metodą Cramera

A = [
     1, 2, 3, 4;
     1, 4, 9,16;
    25,12,12, 1;
     2, 3, 5, 7 
];

x = [ ];
b = (1:4)';
W = det(A);

for i = 1:4
    A_TMP = A;
    A_TMP(:, i) = b;
    x(i) = det(A_TMP) / W;
end

disp(x)

Ax = b;
x = A^(-1)*b;

disp(x)



