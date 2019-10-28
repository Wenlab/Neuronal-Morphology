function [yout,bp]=sholl_plot_norm(file_name,type,yin) %type specifies basal or apical dendrites

%we generalize the traditional Sholl plot. 
%We draw concentric spheres and count the number of branches intersecting each sphere. 
%However, unlike the traditional Sholl plot, where all spheres are centered on the soma, 
%we repeat the procedure for spheres centered on randomly chosen dendritic segments. 
%To avoid boundary effects (i.e., regions with low density and irregular distribution of branches), 
%we restrict the choice of the sphere centers to the interior of the arbor, which is defined as a distance less than gyration radius the arbor. 
%For each sphere radius r we average the number, n, of branch-sphere intersections over center locations.
%Then we measure Sholl sphere radius in the units of arbor radius R and
%normalize the total area under each Sholl plot (i.e., the total dendritic length) to one. 


A=open_swc(file_name); %open the swc file



[B,bp]=rearrange_points(A,2,type); % partition the dendrites into segments 5 micron in length

L=length(B);
CM=mean(B,1);
R_f=sqrt(mean(sum((B-repmat(CM,L,1)).^2,2))); % gyration radius of the arbor
i=1;
k=1;

for i=1:L
    if (norm(B(i,1:3)-CM)<=R_f) % find all segments within the gyration radius of the arbor
        table(k)=i;
        k=k+1;
    end
end
n=length(table);
if n==0 return; end
bin=0.02;
x=0.02:bin:3.5;
y=zeros(n,length(x));
r_all=zeros(n*(L-1),1);
for i=1:n
    R=sqrt(mean(sum((B-repmat(B(table(i),:),L,1)).^2,2)));
    r=sqrt(sum((B-repmat(B(table(i),:),L,1)).^2,2))/R;%normalize sphere radius
    t=hist(r,x); %histogram
    y(i,:)=t;
    y(i,1)=(y(i,1)-1);
    y(i,:)=y(i,:)/(L-1)/bin;%normalize the number of intersections
end

yout=[yin;mean(y(:,3:end))];
plot(x(3:end),mean(y(:,3:end),1),'-','color',[0.5 0.5 0.5]); % display the normalized sholl plot
hold on;









function [B,bp]=rearrange_points(A,kl,type)
[m,n]=size(A);
i=1;
left=0;
bp=0;
for id=1:m
    if A(id,2)==type&&A(id,n)>0
        pre_id=A(id,n);
        L_c=norm(A(pre_id,3:5)-A(id,3:5));
        if L_c>0
            v_c=(A(id,3:5)-A(pre_id,3:5))/L_c;
            if L_c+left<kl
                left=L_c+left;
            else
                v1=A(pre_id,3:5);
                num=floor((L_c-kl+left)/kl);
                for j=0:num
                    B(i,1:3)=v1+v_c*(kl-left+kl*j);
                    i=i+1;
                end
                left=L_c-kl+left-num*kl;
            end
        end
        if id<=m-1&&A(id+1,n)~=id
            left=0;
            bp=bp+1;
        end
    end
end





function A=smooth(A,m,n)
Xch=0; Ych=0; Zch=1;
B=A;
done=0;
times=0;
while times<=10%max([Xch Ych Zch])==Zch
    id=1;
    while id<m
        if A(id,n)>0&A(id+1,n)==id
            pre_id=A(id,n);
            post_id=id+1;
            B(id,5)=mean([A(pre_id,5) A(id,5) A(post_id,5)]);
        end
        id=id+1;
    end
    A=B;
    %j=1;
    %for id=2:m
    %    if A(id,n)>0 
    %        pre_id=A(id,n);
    %        xchange(j)=abs(A(pre_id,3)-A(id,3));
    %        ychange(j)=abs(A(pre_id,4)-A(id,4));
    %        zchange(j)=abs(A(pre_id,5)-A(id,5));
    %        j=j+1;
    %    end
    % end
    %Xch=mean(xchange); Ych=mean(ychange); Zch=mean(zchange);
    times=times+1;
end
    
function Sur=surface_estimate(center,radius,arbor,tess)
M=1000;
u=rand(M,1);
v=rand(M,1);
theta=2*pi*u;
phi=acos(2*v-1);
X=radius*cos(theta).*sin(phi)+center(1);
Y=radius*sin(theta).*sin(phi)+center(2);
Z=radius*cos(phi)+center(3);
t=inhull([X Y Z],arbor,tess,1e-10);
Sur=sum(t)/M*radius^2;


function A=move_kink(A,m,n)

done=0;
times=0;
pre_id1=[];
pre_id2=[];
post_id1=[];
post_id2=[];
for id=1:m
    if A(id,n)>0
        pre_id1=A(id,n);
        if A(pre_id1,n)>0
            pre_id2=A(pre_id1,n);
        end
    end
        
    if id<m&A(id+1,n)==id
        post_id1=id+1;
        if id<m-2&A(post_id1+1,n)==post_id1
            post_id2=post_id1+1;
        end
    end
    
    
    if ~isempty(pre_id1)&~isempty(pre_id2)&~isempty(post_id1)&~isempty(post_id2)
        h1=abs(A(pre_id1,5)-A(pre_id2,5));
        h2=(A(id,5)-A(pre_id1,5));
        h3=(A(post_id1,5)-A(id,5));
        h4=abs(A(post_id1,5)-A(post_id2,5));
        if (abs(h2)>3*(h1+h4)/2)|(abs(h3)>3*(h1+h4)/2)
            A(id,5)=A(pre_id1,5)+sign(h2)*(h1+h4)/2;
        end
    end
    
    pre_id1=[];
    pre_id2=[];
    post_id1=[];
    post_id2=[];
end



