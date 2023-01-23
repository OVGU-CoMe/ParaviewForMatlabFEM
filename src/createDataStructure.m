function DataStructure = createDataStructure(RES)

%% Handle nodal coordinates and connectivity
if isfield(RES,'X') && isfield(RES,'Y')
    if iscell(RES.X) && iscell(RES.Y)
        X = cell2mat(RES.X);
        Y = cell2mat(RES.Y);
        if isfield(RES,'Z')
            Z = cell2mat(RES.Z);
        else
            Z = zeros(length(X),1);
        end
        
    else
        X = RES.X;
        Y = RES.Y;
        if isfield(RES,'Z')
            Z = RES.Z;
        else
            Z = zeros(length(X),1);
        end
    end  
    
    Coor = [X,Y,Z];
else
    error('Nodal coordinates must be given!') 
end
    
if isfield(RES,'Connectivity')
    if iscell(RES.Connectivity)
        Connectivity = cell2mat(RES.Connectivity);
    else
        Connectivity = RES.Connectivity;
    end
else
    error('Connectivity of the nodes must be given!') 
end

% Initial value of variable "ID" for the following part of code
ID = 1;

%% Handle displacements
if isfield(RES,'UX') && isfield(RES,'UY')
   if iscell(RES.UX) && iscell(RES.UY)
       UX = cell2mat(RES.UX);
       UY = cell2mat(RES.UY);

       if isfield(RES,'UZ')
           UZ = cell2mat(RES.UZ);
       else 
           UZ = zeros(length(UX),1);
       end
   
   else
       UX = RES.UX;
       UY = RES.UY;
       if isfield(RES,'UZ')
           UZ = RES.UZ;
       else
           UZ = zeros(length(UX),1);
       end
   end

   isComplex = false;
   if ~isreal(UX) || ~isreal(UY) || ~isreal(UZ)
       isComplex = true;
   end

   if ~isComplex
       PointData{ID}.name = 'Displacement';
       PointData{ID}.array = [UX, UY, UZ];

       ID = ID+1;
   else

       PointData{ID}.name = 'Displacement_real';
       PointData{ID}.array = real([UX, UY, UZ]);

       ID = ID+1;

       PointData{ID}.name = 'Displacement_imag';
       PointData{ID}.array = imag([UX, UY, UZ]);

       ID = ID+1;

   end
end

%% Handle stresses
if isfield(RES,'SXX') && isfield(RES,'SYY') && isfield(RES,'SXY') 

    if iscell(RES.SXX) && iscell(RES.SYY) && iscell(RES.SXY)
        SXX = cell2mat(RES.SXX);
        SYY = cell2mat(RES.SYY);
        SXY = cell2mat(RES.SXY);
    else
        SXX = RES.SXX;
        SYY = RES.SYY;
        SXY = RES.SXY;
    end

    if isreal(SXX) && isreal(SYY) && isreal(SXY) 
    
    PointData{ID}.name = 'Stress';
    PointData{ID}.componentNames = {'SXX', 'SYY', 'SXY'};
    PointData{ID}.array = [SXX, SYY, SXY];
    
    ID = ID+1;

    elseif ~isreal(SXX) && ~isreal(SYY) && ~isreal(SXY)

        PointData{ID}.name = 'Stress_real';
        PointData{ID}.componentNames = {'SXX', 'SYY', 'SXY'};
        PointData{ID}.array = real([SXX, SYY, SXY]);

        ID = ID+1;

        PointData{ID}.name = 'Stress_imag';
        PointData{ID}.componentNames = {'SXX', 'SYY', 'SXY'};
        PointData{ID}.array = imag([SXX, SYY, SXY]);

        ID = ID+1;

    else
        error('Stress components should be all real or complex!')
    end
end

%% Handle strains
if isfield(RES,'EXX') && isfield(RES,'EYY') && isfield(RES,'EXY')

    if iscell(RES.EXX) && iscell(RES.EYY) && iscell(RES.EXY)
        EXX = cell2mat(RES.EXX);
        EYY = cell2mat(RES.EYY);
        EXY = cell2mat(RES.EXY);
    else
        EXX = RES.EXX;
        EYY = RES.EYY;
        EXY = RES.EXY;
    end

    if isreal(EXX) && isreal(EYY) && isreal(EXY)

        PointData{ID}.name = 'Strain';
        PointData{ID}.componentNames = {'EXX', 'EYY', 'EXY'};
        PointData{ID}.array = [EXX, EYY, EXY];

        ID = ID+1;

    elseif ~isreal(EXX) && ~isreal(EYY) && ~isreal(EXY)

        PointData{ID}.name = 'Strain_real';
        PointData{ID}.componentNames = {'EXX', 'EYY', 'EXY'};
        PointData{ID}.array = real([EXX, EYY, EXY]);

        ID = ID+1;

        PointData{ID}.name = 'Strain_imag';
        PointData{ID}.componentNames = {'EXX', 'EYY', 'EXY'};
        PointData{ID}.array = imag([EXX, EYY, EXY]);

        ID = ID+1;

    else
        error('Strain components should be all real or complex!')
    end
end

%% Handle material
if isfield(RES,'C11') && isfield(RES,'C12') && isfield(RES,'C13') && ...
   isfield(RES,'C21') && isfield(RES,'C22') && isfield(RES,'C23') && ...
   isfield(RES,'C31') && isfield(RES,'C32') && isfield(RES,'C33')

    if iscell(RES.C11) && iscell(RES.C12) && iscell(RES.C13) && ...
       iscell(RES.C21) && iscell(RES.C22) && iscell(RES.C23) && ...
       iscell(RES.C31) && iscell(RES.C32) && iscell(RES.C33)
        C11 = cell2mat(RES.C11);
        C12 = cell2mat(RES.C12);
        C13 = cell2mat(RES.C13);
        C21 = cell2mat(RES.C21);
        C22 = cell2mat(RES.C22);
        C23 = cell2mat(RES.C23);
        C31 = cell2mat(RES.C31);
        C32 = cell2mat(RES.C32);
        C33 = cell2mat(RES.C33);
    else
        C11 = RES.C11;
        C12 = RES.C12;
        C13 = RES.C13;
        C21 = RES.C21;
        C22 = RES.C22;
        C23 = RES.C23;
        C31 = RES.C31;
        C32 = RES.C32;
        C33 = RES.C33;
    end
      
    PointData{ID}.name = 'C_matrix';
    PointData{ID}.componentNames = {'C11', 'C12', 'C13','C21', 'C22', 'C23','C31', 'C32', 'C33'};
    PointData{ID}.array = [C11 C12 C13 C21 C22 C23 C31 C32 C33];

    ID = ID+1;
end

DataStructure.Coor = Coor;
DataStructure.Connectivity = Connectivity;
DataStructure.PointData = PointData;

end