function [folderPath,pathImgs, siftPath]= crawl_database_directories(faceDB, post)
%folderPath - cell array containing the path to the folder which contains each image in the database specified by faceDB
%pathImgs - cell array containing the path to each image in the database specified by faceDB

%post - post-fix for the file names to look for in the database:
% we look for 1[post].jpeg, 2[post].jpeg, 3[post].jpeg, 4[post].jpeg

currPath = pwd;

%go into the database
cd(fullfile('C:\Users\Haider\Documents\CS_Phd\Fall_2013\CS_183_ComputerVision\Project\Databases', faceDB));

dbPath = pwd;

%Get all folder names
fnames = dir; %get all folders in the database
folder_names = {fnames([fnames.isdir]).name}; %get rid of dots...

%create the path to the four images in the folders
count = 1;
for f = 1:length(folder_names)
    if(folder_names{f}(1) =='.')  %don't process '.' files
        continue;
    end
    for i = 1:4
        folderPath{count} = fullfile(dbPath, folder_names{f});
        if(nargin==2)
            pathImgs{count} = fullfile(folderPath{count}, [num2str(i) post '.jpeg']);
            siftPath{count} = fullfile(folderPath{count}, [num2str(i) '_' post '_sift']);
        else
            pathImgs{count} = fullfile(folderPath{count}, [num2str(i) '.jpeg']);
            siftPath{count} = fullfile(folderPath{count}, [num2str(i) 'sift']);
        end
        count = count+1;
    end
end

cd(currPath);