function writeParaviewCollection(sourceFolder,sourceFilenames,goalFolder,goalFilename,timesteps)

% sourceFolder = strrep(sourceFolder,'\','/');

fileID = fopen(fullfile(goalFolder, [goalFilename '.pvd']),'wt');
disp(['VTU collection file written: ' fullfile(goalFolder,[goalFilename '.pvd'])])

fprintf(fileID,'<?xml version="1.0"?> \n');
fprintf(fileID,'<VTKFile type="Collection" version="0.1"> \n');
fprintf(fileID,'<Collection> \n');

prevTimestepSTR = num2str(timesteps(1));
dupIDs = [];
for i = 1:length(timesteps)

        timestepSTR = num2str(timesteps(i));
        if i > 1 && strcmp(timestepSTR,prevTimestepSTR)
           dupIDs(end+1) = i;
           lastdigit = str2num(timestepSTR(end));
           
           if lastdigit>5
               lastdigit = lastdigit-1;
           else
               lastdigit = lastdigit+1;
           end
           
           timestepSTR(end) = num2str(lastdigit);
        end
        
        fprintf(fileID, ['<DataSet ',...
            'timestep= "' timestepSTR '" ',...
            'group="" ',...
            'part="' num2str(i-1) '" ',...
            'file="' 'Paraview' '/' sourceFilenames{i} '"',...
            '/> \n']);
        
        prevTimestepSTR = timestepSTR;
end


fprintf(fileID,'</Collection> \n');
fprintf(fileID,'</VTKFile> \n');


%% Finishing
% If some duplicted timesteps are encountered (e.g. due to duplicated
% eigenfrequencies) write an output file in which the modified IDs are
% listed.
filename = 'Modified_timesteps_for_Paraview.txt';
if ~isempty(dupIDs)
   warning([num2str(length(dupIDs)) ' duplicated timestep values were encountered!',...
       ' For more info see file: ' filename ]) 
end
fileID = fopen(fullfile(goalFolder,filename),'w');
fprintf(fileID,'%d\n',dupIDs);
fclose(fileID);

end

