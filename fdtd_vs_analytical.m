analytical=load('bhcyl_analytical/analytical.dat');
fdtd=load('fdtd.dat');
plot(analytical(:,1),[analytical(:,2),analytical(:,3)-analytical(:,2),analytical(:,3)],...
fdtd(:,1),fdtd(:,2),'s',...
fdtd(:,1),fdtd(:,3),'*',...
fdtd(:,1),fdtd(:,3)+fdtd(:,2),'o');
legend('Scattering-Analytical','Absorption-Analytical','Extinction-Analytical','Scattering-Meep','Absorption-Meep','Extinction-Meep')
title('Scattering/Absorption/Extinction crossections for a infinite silver nanowire using MEEP and analytical solution')
xlabel('Wavelength (nm)')
ylabel('Cross-section (nm)')
print('cylinders_meepvsanalytical.png','-dpng','-r100') 
