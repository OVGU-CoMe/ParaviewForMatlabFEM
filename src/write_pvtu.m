function write_pvtu(sourceFilenames,goalFilename,goalFolder)

arguments
    sourceFilenames {mustBeText}
    goalFilename {mustBeText}
    goalFolder {mustBeText}
end

fileID = fopen(fullfile(goalFolder, [goalFilename '.pvtu']),'wt');
disp(['VTU collection file written: ' fullfile(goalFolder,[goalFilename '.pvd'])])

fprintf(fileID, '<?xml version="1.0"?> \n');
fprintf(fileID, '<VTKFile type="PUnstructuredGrid" version="0.1"> \n');
fprintf(fileID, '\t<PUnstructuredGrid GhostLevel="0"> \n');
fprintf(fileID, '\t\t<PCellData>\n');
fprintf(fileID,	'\t\t\t<PDataArray type="Float64"  Name="flags" NumberOfComponents="1" format="ascii"/>\n');
fprintf(fileID, '\t\t</PCellData>\n');
fprintf(fileID,	'\t\t<PPoints>\n');
fprintf(fileID,	'\t\t\t<PDataArray NumberOfComponents="3" type="Float64"/>\n');
fprintf(fileID,	'\t\t</PPoints>\n');


for i = 1:length(sourceFilenames)
    fprintf(fileID, ['\t\t<Piece Source="' sourceFilenames{i} '"/>\n']);    
end


fprintf(fileID,'\t</PUnstructuredGrid> \n');
fprintf(fileID,'</VTKFile> \n');
fclose(fileID);

end

