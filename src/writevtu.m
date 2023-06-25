function writevtu(dim,data,PlotSettings)
%% Info
% Create by: Marton Petoe (06.11.2020)
% Last update: Marton Petoe (23.04.2021)

%% Description
% This code writes a vtk (Visualization Toolkit) file for unstructured
% grid, hence the extension ".vtu". 

%% Input variables
% dim:      '2D' or '3D': Describes whether surface or volume elements are
%           used.
% filename: Name of the generated file
% addMsg:   Additional message that will be written as a comment in the
%           beginning of the file. This message can hold additional useful
%           information, such as excitation frequency.

filedir = PlotSettings.filedir;
filename = [PlotSettings.filename '.vtu'];
fileInfo = PlotSettings.fileInfo;
if ~iscell(fileInfo)
    fileInfo = {fileInfo};
end

%% Delete empty data
toKeep = true(length(data),1);
for i = 1:length(data)
    if isempty(data{i})
        toKeep(i) = false;
    end
end

data = data(toKeep);
%% Analyse element connectivity

elemnodes = zeros(length(data),1);
elemtype = zeros(length(data),1);
str = cell(length(data),1);
NOP = zeros(length(data),1);
NOC = zeros(length(data),1);

for i = 1:length(data)
elemnodes(i) = size(data{i}.Connectivity,2); % Number of nodes per element

% Available element types:
% https://cloud.ovgu.de/apps/files/?dir=/SEM-SCM_supplementary/Documents&openfile=42921472
if strcmp(dim,'2D')
    if elemnodes(i) == 3
        elemtype(i) = 5; % VTK_TRIANGLE (2D, p=1)
        
    elseif elemnodes(i) == 4
        elemtype(i) = 9;  % VTK_QUAD (2D, p=1)
	
	elseif elemnodes(i) == 6
        elemtype(i) = 22;  % VTK_QUADRATIC_TRIANGLE (2D, p=2)
    
    elseif elemnodes(i) == 9
        % Second order Lagrangian elements with full nodes are not
        % supported. In this case, the element is reduced to a 2D 
        % serendipity elemenet with 8 nodes. Higher order nodes will be 
        % ignored
        elemnodes(i) = 8; 
        data{i}.Connectivity = data{i}.Connectivity(:,1:8);
        elemtype(i) = 23;  % VTK_QUADRATIC_QUAD (2D, p=2, serendipity)
        
    elseif elemnodes(i) == 8
        elemtype(i) = 23;  % VTK_QUADRATIC_QUAD (2D, p=2, serendipity)
        
    end
    
elseif strcmp(dim,'3D')
    
    if elemnodes(i) == 4
        
        % Note that in its current state, the function decides which
        % element type should be used for the visualization based on the
        % 1) the given dimension of the problem and,
        % 2) number of nodes per element. 
        % In certain cases, this becomes confusing, such as 4 nodes for a
        % 3D element: This can be either a quad plane in 3D space, or a
        % tetrahedron.
        switch length(data)
            case 1
                coor = data{1}.Coor;
            case 2
                coor = [data{1}.Coor; data{2}.Coor];
            otherwise
                error('For some reason, this has not be implemented yet!')
        end
        
        xyz = coor(data{i}.Connectivity(1,:),:);
        if det( [xyz(2,:)-xyz(1,:); xyz(3,:)-xyz(1,:); xyz(4,:)-xyz(1,:)]) == 0
            elemtype(i) = 9;  % VTK_QUAD  (3D, p=1)
        else
            elemtype(i) = 10; % VTK_TETRA (3D, p=1)
        end
        
    elseif elemnodes(i) == 8
        elemtype(i) = 12; % VTK_HEXAHEDRON (3D, p=1)
		
	elseif elemnodes(i) == 10
        elemtype(i) = 24;  % VTK_QUADRATIC_TETRA (3D, p=2)
        
    elseif elemnodes(i) == 27
        % Second order Lagrangian elements with full nodes are not 
        % supported. In this case, the element is reduced to 3D
        % serendipity elemenet with 20 nodes. Higher order nodes will be
        % ignored 
        elemnodes(i) = 20; 
        data{i}.Connectivity = data{i}.Connectivity(:,[1:12, 17:20, 13:16]);
        elemtype(i) = 25; % VTK_QUADRATIC_HEXAHEDRON (3D, p=2, serendipity)
        
    elseif elemnodes(i) == 20
        elemtype(i) = 25; % VTK_QUADRATIC_HEXAHEDRON (3D, p=2, serendipity)
        
    end
end

% Formatting for writing the node IDs in the connectivity section
str{i} = ['%d' repmat('\t %d', 1,elemnodes(i)-1)];


NOP(i) = size(data{i}.Coor,1);         % Number of points
NOC(i) = size(data{i}.Connectivity,1); % Number of cells
end

%% Write beginning
fileID = fopen(fullfile(filedir, filename),'wt');
fprintf(fileID,...
    ['<?xml version="1.0"?> \n',...
    '<VTKFile type="UnstructuredGrid" version="2.2"> \n',...
    '<UnstructuredGrid> \n']);

fprintf(fileID,'\n');
for i = 1:length(fileInfo)
    fprintf(fileID,['<!--' fileInfo{i} '-->\n']);
end
fprintf(fileID,'\n');

%% MESH ===================================================================


fprintf(fileID,['<Piece NumberOfPoints="' num2str(sum(NOP))...
    '" NumberOfCells="'  num2str(sum(NOC)) '">\n']);

% Define points -----------------------------------------------------------
fprintf(fileID,[...
    '\t<Points>\n',...
    '\t\t<DataArray type="Float64" Name="nodes" NumberOfComponents=" 3" format="ascii"> \n']);
for i = 1:length(data)
    fprintf(fileID,['\t\t\t %E' repmat('\t %E', 1, size(data{i}.Coor,2)-1) '\n'], data{i}.Coor');
end
fprintf(fileID,[...
    '\t\t</DataArray> \n',...
    '\t</Points> \n']);

% Define cells / Connectivity ---------------------------------------------
fprintf(fileID,[...
    '\t<Cells> \n',...
    '\t\t<DataArray type="Int32" Name="connectivity" NumberOfComponents=" 1" format="ascii"> \n']);
for i = 1:length(data)
    fprintf(fileID,['\t\t\t' str{i} '\n'], data{i}.Connectivity'-1);
end
fprintf(fileID,'\t\t</DataArray> \n');

% Define cells / Offsets --------------------------------------------------
fprintf(fileID,'\t\t<DataArray type="Int32" Name="offsets" NumberOfComponents=" 1" format="ascii"> \n');
for i = 1:length(data)
    if i == 1
        offset = 0;
    else
        offset = elemnodes(i-1)*NOC(i-1);
    end
    fprintf(fileID,'\t\t\t%d \n', ( elemnodes(i)*(1:NOC(i)) + offset )');
end
fprintf(fileID,'\t\t</DataArray> \n');

% Define cells / Types ---------------------------------------
fprintf(fileID,'\t\t<DataArray type="UInt8" Name="types" NumberOfComponents=" 1" format="ascii"> \n');
for i = 1:length(data)
    fprintf(fileID,'\t\t\t%d \n', elemtype(i)*ones(NOC(i),1));
end
fprintf(fileID,[...
    '\t\t</DataArray> \n',...
    '\t </Cells> \n']);

%% RESULTS
% In this section the obtained results on the mesh are printed into the vtu
% file. It is possible to output mulitple fields, such as displacement,
% pressure, stresses, strains, etc. Each of the different output fields are
% stored as individual cells in the cell array "Field".
% if ~iscell(Field)
%     C{1} = Field;
%     Field = C;
%     clear C;
% end

% Available data block type
DataBlocks = {'PointData', 'CellData'};
for d = 1:length(DataBlocks)
    
    % Get current data block type
    DataBlock = DataBlocks{d};
    
    % If the current data block does not exist, skip the current iteration
    if ~isfield(data{1},DataBlock)
        continue
    end
    
    % Start current data block
    fprintf(fileID,['\t<' DataBlock '> \n']);
    
    
% Iterate through the cell array "Fields" and print the content of the 
% cells  
for i = 1:length(data{1}.(DataBlock))
           
     % If the given field has also component names, write the field array
     % into one text-block. The given component names will be visible also
     % when the file is oepened in paraview. If the given field has no
     % given component names, just write the field name and its
     % corresponding array.
   
    
    % Collect the right data type for the "array"
    if isfield(data{1}.(DataBlock){i},'type')
        type = data{1}.(DataBlock){i}.type;
    else
        switch class(data{1}.(DataBlock){i}.array)
            case 'single'
                type = 'Float32';
                format = '%E';
            case 'double'
                type = 'Float64';
                format = '%E';
            case 'int8'
                type = 'Int8';
                format = '%d'; 
            case 'int16'
                type = 'Int16';
                format = '%d';
            case 'int32'
                type = 'Int32';
                format = '%d';
            case 'int64'
                type = 'Int64';
                format = '%d';
            case 'uint8'
                type = 'UInt8';
                format = '%d';
            case 'uint16'
                type = 'UInt16';
                format = '%d';
            case 'uint32'
                type = 'UInt32';
                format = '%d';
            case 'uint64'
                type = 'UInt64';
                format = '%d';
        end
    end
    
    nComp = size(data{1}.(DataBlock){i}.array,2);
    arrayformat = [format repmat([' \t' format], 1, nComp-1)];
    
    if isfield(data{1}.(DataBlock){i},'componentNames')
        fprintf(fileID,['\t\t<DataArray type="' type '" Name="' data{1}.(DataBlock){i}.name,...
            '" NumberOfComponents="' num2str(nComp) '" format="ascii"']);
        
        for j = 1:length(data{1}.(DataBlock){i}.componentNames)
            fprintf(fileID, ['\nComponentName' num2str(j-1) '="' data{1}.(DataBlock){i}.componentNames{j} '"']);
        end
        
        fprintf(fileID,'>\n');
        
    else
        fprintf(fileID,['\t\t<DataArray type="' type '" Name="' data{1}.(DataBlock){i}.name,...
            '" NumberOfComponents="' num2str(nComp) '" format="ascii"> \n']);
        
    end
    
    for k = 1:length(data)
        fprintf(fileID,['\t\t\t' arrayformat '\n'], data{k}.(DataBlock){i}.array');
    end
    fprintf(fileID,'\t\t</DataArray> \n');
end

% Close current data block
fprintf(fileID,['\t</' DataBlock '> \n']);
end



fprintf(fileID,[...
    '</Piece> \n',...
    '</UnstructuredGrid> \n',...
    '</VTKFile> \n']);

fclose(fileID);

disp(['VTU file has been successfully written to: ' filedir])
end

