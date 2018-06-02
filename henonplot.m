%Function to plot the henon map in a figure on matlab
%Uncomment the last line
function henonplot
x(1)= 0.44;
y(1)= 0.99;
a = 6;
b = 0.9;
n = 3;
for i= 2:n
    x(i)= a+(x(i-1)^2)+b*y(i-1);
    y(i)= x(i-1);
end
x
y

dx(1) = x(n);
dy(1) = y(n);

for i = 2:n
    dx(i) = dy(i-1);
    dy(i) = (dx(i-1)-dy(i-1)^2-a)/b;
end
x
y
%plot(x,y)
