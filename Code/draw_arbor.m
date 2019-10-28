function [L,a]=draw_arbor(A,type)
%A is the matrix for arbor data, from swc file

%type=3 is basal, type=4 is apical and type=2 is axon.
[m,n]=size(A);
%figure;
L=0;
%A(:,5)=0;
figure;
for id=1:m
    if (A(id,2)==type)
        pre_id=A(id,n);
        if (pre_id>0)
            Point=[A(pre_id,3:5);A(id,3:5)];
            L=L+norm(A(pre_id,3:5)-A(id,3:5));
            if A(id,2)==3
                plot3(Point(:,1),Point(:,2),Point(:,3),'g','LineWidth',2*A(id,6));
            else
                plot3(Point(:,1),Point(:,2),Point(:,3),'r','LineWidth',2*A(id,6));
            end
            %plot(Point(:,1),Point(:,3),'r','LineWidth',2);
            hold on;
        end
    end
end
axis equal
disp(L);
%x=A(:,3);
%y=A(:,4);
%[K,a]=convhull(x,y);
%disp(a);
%disp(L);
%figure,plot(x(K),y(K),'r-',A(:,3),A(:,4),'b+');


