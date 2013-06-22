clear all 
close all;
a=100;
rad=0.25
sx1=rad*4



scattering=load('trans_flux_structure_scat.dat');
scat_pow=abs((scattering(:,2))-(scattering(:,3))-(scattering(:,4))+(scattering(:,5)));
freq=scattering(:,1);
lam=a*freq.^-1;


no_structure=load('incident_flux.dat'); 
incident_pow=abs(no_structure(:,2))/(sx1);


absorption=load('trans_flux_structure_abs.dat');
abs_pow=((absorption(:,2))-(absorption(:,3))-(absorption(:,4))+(absorption(:,5)));


scat_cross_section=scat_pow./incident_pow;
abs_cross_section=abs_pow./incident_pow;


%plot(lam(lam>300&lam<500),a*cross_section(lam>300&lam<500),'-o');
plot(lam,[a*scat_cross_section],'-s',lam,a*abs_cross_section,'-o')
legend('Scattering','Absorption')

%plot(freq,cross_section,'o')

temp=[lam,a*scat_cross_section,a*abs_cross_section];
save('fdtd.dat','temp','-ascii')
