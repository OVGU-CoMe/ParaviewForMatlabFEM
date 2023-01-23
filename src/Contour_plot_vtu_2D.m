%% Info
% Created by: Marton Petoe (03-12-2020)

%% Description
% The following code takes the results of an FEM/FCM simulation and
% and exports them into a vtu-file for visualization via ParaView.

function Contour_plot_vtu_2D(Mesh, PlotSettings, Geometries, u, Materials)

Phys_Elem = Mesh.Phys_Elem;
Cut_Elem = [];
if isa(Mesh,'UnfittedMesh2D') || isa(Mesh,'UnfittedMesh3D')
    Cut_Elem = Mesh.Cut_Elem;
end

%% Compute results 
if size(u,2) == 1 
    RES = Contour_plot_core_2D(Mesh, Phys_Elem, Cut_Elem, PlotSettings, Geometries,...
        u, Materials);
elseif size(u,2) == 2
    RES = Contour_plot_core_2D_enriched(Mesh, PlotSettings, Geometries, u, Materials);
end

% Find which cells of the results array contains a sub-mesh consisting
% of quadrilateral elements and which one of triangular elements
quads = false(length(RES.Connectivity),1);
for i = 1:length(RES.Connectivity)
    if size(RES.Connectivity{i},2) == 4
        quads(i) = i;
    end
end

% Reorganize the data in two separate arrays: One containing quadrilateral
% -based sub-meshes and another contatining triangle-based sub-meshes
fnames = fieldnames(RES);
for i = 1:length(fnames)
    fname = fnames{i};
    RESQUAD.(fname) = RES.(fname)(quads);
    RESTRI.(fname) = RES.(fname)(~quads);
end

dataStructures = cell(1,1);

% Iterate through the quad and tri parts
for i = 1:2
    switch i
        case 1
            RES = RESQUAD;
        case 2
            RES = RESTRI;
    end
    
    % If the current results data is empty, proceed to the next iteration
    if isempty(RES.Connectivity)
        continue
    end

dataStructures{i} = createDataStructure(RES);
end

%% Write vtu-file
writevtu('2D',dataStructures,PlotSettings);

end

