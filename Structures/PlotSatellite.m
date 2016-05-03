function PlotSatellite(components, structures)
% hwlRectangle = [2,3,1];
% xyzRectangle = [0,0,0];

hold on
grid 'on'
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')
axis equal
% S.LN = plot(S.x,S.x,'r');

% RectangularPlotter(hwlRectangle(1),hwlRectangle(2),hwlRectangle(3),xyzRectangle(1),xyzRectangle(2),xyzRectangle(3))
% SpherePlotter(1.5,0,0,2)
% CylindricalPlotter(1,2,2,2)

outside_obj = PlotComponents(components);
structures_obj = PlotStructures(structures);
obj = [outside_obj,structures_obj];
hold off
view(3) %sets the default three-dimensional view, az = ?37.5, el = 30.
% Create a Slider Bar
sl_handle = uicontrol('style','slide',...
         'min',0,'max',1,'val',1,...
         'Units', 'normalized','Position',[0.95,0.3,.05,.4], ...
        'callback',{@sl_call,obj});
%  set(sl_handle,'ylabel','Structures Transparancy'),

% ConePlotter()
function [] = sl_call(varargin)
% Callback for the slider.
[h,obj] = varargin{[1,3]};  % calling handle and data structure.
set(obj,'FaceAlpha',get(h,'Value'))

function obj = PlotComponents(components)
% function to plot the components
nr = length(components);
obj = [];
for i = 1:nr
    if ~isempty(components(i).CG_XYZ )
        [FaceColor,EdgeColor] = ColorSelection(components(i).Subsystem);
        objnew = ShapePlotter(components(i).Shape,components(i).Dim,components(i).Vertices,components(i).CG_XYZ,FaceColor,EdgeColor);
    else
        fprintf([components(i).Name,' not added to satellite because it doesn"t fit\n'])
    end
    if strcmp(components(i).LocationReq,'Outside')
        obj = [obj,objnew];
    end
end

function obj = PlotStructures(structures)
% Function to plot the structure
nr = length(structures);
obj = [];
for i = 1:nr
    myVertices = [structures(i).Bottom_Vertices;structures(i).Top_Vertices];
    myCG = structures(i).CG_XYZ; 
    [FaceColor,EdgeColor] = ColorSelection('Structures');
    objnew = ShapePlotter(structures(i).Shape,structures(i).Dim,myVertices,myCG,FaceColor,EdgeColor);
    obj = [obj,objnew];
end


function obj = ShapePlotter(Shape,myDim,myVertices,myCG,FaceColor,EdgeColor)


% myVertices = [-l/2 -w/2 -h/2; 
%                 -l/2 w/2 -h/2; 
%                 l/2 w/2 -h/2; 
%                 l/2 -w/2 -h/2; 
%                 -l/2 -w/2 h/2; 
%                 -l/2 w/2 h/2; 
%                 l/2 w/2 h/2; 
%                 l/2 -w/2 h/2];
%             
% X = ones(8,1)*x;
% Y = ones(8,1)*y;
% Z = ones(8,1)*z;
% myVertices =  myVertices + [X,Y,Z];

if strcmp(Shape,'Rectangle')
    % A function that plots a rectangle of heigh (z axis) h, width (y axis) w,
    % and length (x axis) l
    % x, y, and z are the coordinates of the center of the rectangle.
    myFaces = [1 2 3 4; 2 6 7 3; 4 3 7 8; 1 5 8 4; 1 2 6 5; 5 6 7 8];
     obj = patch('Vertices', myVertices, 'Faces', myFaces, 'FaceColor', FaceColor,'EdgeColor',EdgeColor);
elseif strcmp(Shape,'Sphere')
    % A function that plots a sphere of radius r and centered at location (a,b,c)
    % sphere with radius 5 centred at (0,0,0)
    r = myDim;
    [x,y,z] = sphere();
     obj = surf(r*x+myCG(1), r*y+myCG(2), r*z+myCG(3),'FaceColor', FaceColor,'EdgeColor',EdgeColor);
elseif strcmp(Shape,'Cone')
 
elseif ~(isempty(strfind(Shape,'Cylinder')))
    % A function that plots a cylinder of radius r and with the bottom centered at location (a,b,c)
    r = myDim(1,2);
    h = myDim(1,1);
    [x,y,z] = cylinder(r);
    z = (z*h)-h/2;
    obj = surf(x+myCG(1),y+myCG(2),z+myCG(3),'FaceColor', FaceColor,'EdgeColor',EdgeColor);
end

function ConePlotter()
% 
% h = linspace(0,3,25);
% 
% r=linspace(3,2,25);
% theta = linspace(0,2*pi,25);
% [r,theta] = meshgrid(r,theta);
% x = r.*cos(theta);
% y = r.*sin(theta);
% z = -r;
% surf(x,y,z)

r1 = 1.0;
r2 = 5;
h = 2.0;
m = h/abs(r1-r2);
[R,A] = meshgrid(linspace(r1,r2,11),linspace(0,2*pi,41));
X = R .* cos(A);
Y = R .* sin(A);
Z = m*R;
% Cone around the z-axis, point at the origin
surf(X,Y,Z)

% [x,y,z] = cylinder(1:10);