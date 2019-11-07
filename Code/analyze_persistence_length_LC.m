cd F:\Neuronal-Morphology\Data\Left_and_right_LC\Left_LC
listing = dir;
branches = {};
for k = 1:length(listing)-2
  folder = listing.folder;
  filename = [folder '\' listing(k+2).name];
  branches=identify_branches(filename,0,branches);
end


cd F:\Neuronal-Morphology\Data\Left_and_right_LC\Right_LC
listing = dir;
for k = 1:length(listing)-2
  folder = listing.folder;
  filename = [folder '\' listing(k+2).name];
  branches=identify_branches(filename,0,branches);
end
