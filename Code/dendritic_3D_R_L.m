function [L,R]=dendritic_3D_R_L(file,type,L,R)
%Calculating the arbor radius and the total length of dendrites

A=open_swc(file);
draw_arbor(A,3);
%return;
%savefile=file;
%savefile(end-2:end)='mat';
%save(savefile,'A');
%load(file);
%B=rearrange_points(A,2,type);
%L=length(B);
[L_d,coordinate,weight]=dendritic_length(A,type);
N=length(weight);
CM=sum(coordinate.*repmat(weight,1,3),1)/L_d;
R_g=sqrt(sum(weight.*sum((coordinate-repmat(CM,N,1)).^2,2))/L_d);
%r_square=0;
%for i=1:N
%    for j=i+1:N
%        r_square=r_square+weight(i)*weight(j)*(norm(coordinate(i,:)-coordinate(j,:)))^2;
%    end
%end
%R_g=sqrt(r_square/L_d^2);
L=[L;L_d];
R=[R;R_g*sqrt(2)];
disp('done');





function [L,coor,weight]=dendritic_length(A,type)
[m,n]=size(A);
L=0;
i=1;
for id=2:m
    if (A(id,2)==type)
        pre_id=A(id,n);
        if (pre_id>0)
            Point=[A(pre_id,3:5);A(id,3:5)];
            coor(i,:)=mean(Point,1);
            weight(i)=norm(A(pre_id,3:5)-A(id,3:5));
            L=L+weight(i);
            i=i+1;
        end
    end
end
weight=weight';

function B=rearrange_points(A,kl,type)
[m,n]=size(A);
i=1;
left=0;
for id=1:m
    if A(id,2)==type&A(id,n)>0%
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
        if id<=m-1&A(id+1,n)~=id
            left=0;
        end
    end
end


