clear all

DefaultFolder = 'C:\Users\Win7\Desktop\EXP';


[filename, pathname] = uigetfile('*.txt', 'Choose RampInfo file to open ...', DefaultFolder);
fid = fopen([pathname filename]);
i=1;
% ------ read file RampInfo ------ %
while ~feof(fid)
    tline = fgetl(fid);
    data = sscanf(tline, '%e');
    Vg(i) = data(1);
    i = i+1;
end
N=i-1                                   % number of points in MW frequency scan
fclose(fid);

SW_files = dir([pathname 'guard*']);
SW_names={SW_files.name}; % make listing of file
SW_names = sort(SW_names); % sort the list 

for i1=1:N
    
    fid = fopen([pathname SW_names{i1}]);                                        
    i3=1;
    
    while ~feof(fid)
        tline = fgetl(fid); 
        data = sscanf(tline, '%e');
                                                                                                                                                    
        Amp(i3,i1) = data(1);  
                                                            
        i3=i3+1;
    end
    
    fclose(fid);
    
end

M=i3-1 

for i3=1:M
    
    Frf(i3)=106+(i3-1)*0.05;
    
end

figure
imagesc(Vg,Frf,Amp);
set(gca,'YDir','normal'); 

h = colorbar;
h.Label.String = '\Delta Re(\Gamma)';
xlabel('V_{BGTG} (V  )')
ylabel('{\it f}_{c} (MHz)') 