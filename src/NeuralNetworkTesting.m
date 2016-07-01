mod = NeuralNetwork();

a= rand(1,1000);
b=rand(1,1000);
c=rand(1,1000);
d=rand(1,1000);

y=a*5+b.*c+7*c+d;


 for iter = (1:400)
    display(iter);
    mod.addSample(a(iter), b(iter), c(iter),d(iter),y(iter));
 end

mod.trainIt()

networkStuff = [];

for iter = (600:1000)
    networkStuff(end+1)  = mod.evaluate([a(iter);b(iter);c(iter);d(iter)]);
end
realStuff =a(600:1000)*5+b(600:1000).*c(600:1000)+7*c(600:1000);

figure(1)
plot(networkStuff)
figure(2)
plot(realStuff)