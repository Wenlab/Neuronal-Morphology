function corr_vs_pl=angular_correlation(branches)

N = length(branches);
h = 0;
for i=1:N
    l = size(branches{i},1)-1;
    h = h + l*(l-1)/2;
end
corr_vs_pl = zeros(h,2);
idx = 1;

for i=1:N
    branch = branches{i};
    pts = branch';
    v_direction=(pts(:,2:end)-pts(:,1:end-1));
    path=sqrt(sum(v_direction.^2,1));
    l=size(v_direction,2);
    v_norm=v_direction./repmat(path,3,1);
    
    if l>1
        for j=1:l-1
            for k=j+1:l          
                angular_correlation = dot(v_norm(:,j),v_norm(:,k));
                if ~isnan(angular_correlation)
                    corr_vs_pl(idx,:)=[angular_correlation,sum(path(j:k))];
                    idx = idx + 1;
                end
            end
        end
    end
end
if idx<=h
    corr_vs_pl(idx:h,:)=[];
end




