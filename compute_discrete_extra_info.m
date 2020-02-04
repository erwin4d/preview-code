function [iterVals] = compute_discrete_extra_info(para, iterVals)
  
  Y1 = iterVals.Y1(:,:,iterVals.kvals);
  Y2 = iterVals.Y2(:,:,iterVals.kvals);
  Ye = iterVals.e(:,:,iterVals.kvals);

  lenY1 = iterVals.lenY1;
  lenY2 = iterVals.lenY2;
  kvals = iterVals.kvals;

  % Find when y2 == ye and y1 == ye
%  tmpY1 = zeros(size(Y1,1),size(Y1,2));
  
  tmpY1 = bsxfun(@eq, Y1, Ye);
  tmpY2 = bsxfun(@eq, Y2, Ye);
 % tmpY1(bsxfun(@eq, Y1, Ye)) = Y1(bsxfun(@eq, Y1, Ye)); % find positions y1 == ye

  %tmpY2 = zeros(size(Y2,1),size(Y2,2));
  %tmpY2(bsxfun(@eq, Y2, Ye)) = Y2(bsxfun(@eq, Y2, Ye)); % find positions y2 == ye

  % tmpY1 is an array of 0s and 1s, where 1s denote y1 == ye
  % tmpY2 is an array of 0s and 1s, where 1s denote y2 == ye
  
  % for y1 == y2 == ye, require 1s in tmpY1 and tmpY2 to be in same pos
  
  iterVals.nA(:,:,kvals) = tmpY1 * tmpY2';
  
    
  % now, note that y2 == ye comprises y1 == y2 == ye and y1 != y2, y2 == ye

  iterVals.nB(:,:,kvals)  = repmat(sum(tmpY2,2)',lenY1,1) - iterVals.nA(:,:,kvals);

  % now, note that y1 == ye comprises y1 == y2 == ye and y1 != y2, y1 == ye
  iterVals.nC(:,:,kvals) = repmat(sum(tmpY1,2),1,lenY2) - iterVals.nA(:,:,kvals);

  % is there a faster way to do this?
  tmpnD = zeros(lenY1, lenY2);
  for j = 1:lenY1
    tmpnD(j,:) = transpose(sum(bsxfun(@eq, Y1(j,:), Y2),2));
  end

  iterVals.nD(:,:,kvals) = tmpnD - iterVals.nA(:,:,kvals);

  iterVals.nE(:,:,kvals) = para.kidx(kvals,3)  - iterVals.nA(:,:,kvals) - iterVals.nB(:,:,kvals) -iterVals.nC(:,:,kvals) -iterVals.nD(:,:,kvals);
 
  val = iterVals;
end


