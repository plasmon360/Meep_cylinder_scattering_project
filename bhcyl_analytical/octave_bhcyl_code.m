% Purpose of this code is to write a fort.11 input file for bhcyl executable, execute bhcyl and then read the output from fort.12. This is done for a series of wavelengths. Used LD.m code for generating the refractive indices of Silver using Lorentz-Drude model. The outout of bhcyl executable is scattering efficencies and extinction efficiencies. They need to converted scattering/extinction crossection per unit by multiplying with 2*Rad.
clear all
Rad=25; % Should be in nanometers.
lam=[200:2:700]; % Should be in nanometers
[epsr,epsi,N]=LD(lam*1e-9,'Ag','LD');
fin_angle=0; % dont change these
num_angle=1;% dont change these
for i=1:1:length(lam)
fid=fopen('fort.11','wt');
fprintf(fid,'%0.5g\n',real(N(i)));
fprintf(fid,'%0.5g\n',imag(N(i)));
fprintf(fid,'%0.5g\n',Rad);
fprintf(fid,'%0.5g\n',lam(i));
fprintf(fid,'%0.5g\n',fin_angle);
fprintf(fid,'%0.5g\n',num_angle);
fclose(fid);
system ./bhcyl_exec ;
calc=load('fort.12');
scatter(i)=calc(1);
ext(i)=calc(2);
end

plot(lam,2*Rad*scatter,'-*') % multiplty by 2*Rad to get the cross-section per unit length of cylinder
temp=[lam',2*Rad*scatter',2*Rad*ext'];
save('analytical.dat','temp','-ascii')

