function branches=identify_branches(file_name,type,branches)

  num = length(branches);
  A=open_swc(file_name);
  [N,M]=size(A);
  for i=1:N
    if A(i,2)==type
      pre_id = A(i,M);
      if (pre_id>0)
        if (pre_id==A(i,1)-1)
          branches{num}(end+1,:) = A(i,3:5);
        else
          num = num+1;
          branches{num} = [A(pre_id,3:5); A(i,3:5)];
        end
      elseif (pre_id == -1)
        num = num+1;
        branches{num} = A(i,3:5);
      end
    end
  end
