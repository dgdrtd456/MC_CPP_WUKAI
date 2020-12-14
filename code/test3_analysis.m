%clear all
%clc
check1 = textread('G:\example\example\check.txt');
check2= textread('G:\example\example\conformation_trans.txt');

delta_E1=check1(:,2);
delta_E2=check1(:,3);
Energy=check1(:,4);
test_err=check1(:,5);
trans=check2(:,1);

figure
plot(delta_E1)
figure
plot(delta_E2)
figure
plot(Energy)
figure
plot(test_err)
figure
plot(trans)

