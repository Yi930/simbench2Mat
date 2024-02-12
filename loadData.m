tmp = pyenv(Version="/Users/bing/anaconda3/bin/python", ExecutionMode="OutOfProcess");
linesTmp = pyrunfile("loadData.py", "lines");
loadsTmp = pyrunfile("loadData.py", "loads");
busesTmp = pyrunfile("loadData.py", "buses");
gensTmp = pyrunfile("loadData.py", "gens");
geoDataTmp = pyrunfile("loadData.py", "geoData");
% pyrunfile("loadData.py");
% Read the line data
line1 = cell(linesTmp(1));
line1 = double(line1{1,1});
line2 = cell(linesTmp(2));
line2 = double(line2{1,1});
lines = [line1', line2'];

% Read the loads' bus position
loads = double(loadsTmp(1,:));

% Read the gens' bus position
gens = double(gensTmp(1,:));

% Read the geo data
geox = cell(geoDataTmp(1));
geox = double(geox{1,1});
geoy = cell(geoDataTmp(2));
geoy = double(geoy{1,1});

% Read the index. Because the index is not a sequence list like 0, 1, 2...
% 37587, but something like 0, 1, 5, 6, 9, 104644, the array has to be
% accessed by the index.
index = double(busesTmp.index.tolist());
cellIndex = cell(size(index));
for i = 1:numel(index)
    cellIndex{i} = num2str(index(i));
end

% Loads use the str name, it needs to be transformed to index name.
loadCorrespondingIndex = [];
for i=1:size(loads,2)
    tmp = find(index==loads(i));
    loadCorrespondingIndex = [loadCorrespondingIndex, tmp];
end

% Gens use the str name, it needs to be transformed to index name.
genCorrespondingIndex = [];
for i=1:size(gens,2)
    tmp = find(index==gens(i));
    genCorrespondingIndex = [genCorrespondingIndex, tmp];
end

% To access the A array with the index name instead of the row or colomn
% number, the A array has to be a table.
A = zeros(size(index,2),size(index,2),'logical');
A = array2table(A, 'RowNames', cellIndex, 'VariableNames', cellIndex);

% Change the data in A table
for i=1:size(lines,1)
    tmpIndex = lines(i,:);
    Index1 = num2str(tmpIndex(1));
    Index2 = num2str(tmpIndex(2));
    A{Index1, Index2} = 1;
    A{Index2, Index1} = 1;
end

% in = zeros(max(line1), size(lines,1),'logical');  % bus number, line number
% 
% for i=1:size(lines,1)
%     in(lines(i,1)+1,i+1) = 1;
%     in(lines(i,2)+1,i+1) = 1;
% end

Array = table2array(A);
gr = graph(Array);
h = plot(gr, 'XData', geox, 'YData', geoy);
highlight(h, loadCorrespondingIndex, 'NodeColor', 'r');
highlight(h, genCorrespondingIndex,'Marker', 'pentagram', 'MarkerSize', 5, 'NodeColor', 'blue');