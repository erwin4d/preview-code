function [iterVals] = compute_binary_extra_info(para, iterVals)
  
  Y1 = iterVals.Y1(:,:,iterVals.kvals);
  Y2 = iterVals.Y2(:,:,iterVals.kvals);
  Ye = iterVals.e(:,:,iterVals.kvals);

  lenY1 = iterVals.lenY1;
  lenY2 = iterVals.lenY2;

  val = 0;
  kvals = iterVals.kvals;

    % Compute nA
  tmpY2 = zeros(size(Y2,1),size(Y2,2));
  tmpY2(bsxfun(@eq, Y2, Ye)) = Y2(bsxfun(@eq, Y2, Ye)); % find y2 == ye
  
  tmpy2len = repmat(sum(abs(tmpY2),2)',lenY1,1);
  tmpy1y2 = Y1 * tmpY2' ;

  iterVals.nA(:,:,kvals) = (tmpy2len - tmpy1y2)/2;

  iterVals.nC(:,:,kvals) = tmpy2len - iterVals.nA(:,:,kvals);

  % Now, same thing but y1 == ye
  tmpY1 = zeros(size(Y1,1),size(Y1,2));
  tmpY1(bsxfun(@eq, Y1, Ye)) = Y1(bsxfun(@eq, Y1, Ye)); % find v1 == v3
  
  tmpy1len = repmat(sum(abs(tmpY1),2),1,lenY2);
  
  iterVals.nD(:,:,kvals) = tmpy1len - iterVals.nC(:,:,kvals);
  
  iterVals.nB(:,:,kvals) = para.kidx(kvals,3) - iterVals.nA(:,:,kvals) - iterVals.nC(:,:,kvals) - iterVals.nD(:,:,kvals);    
  val = iterVals;
end


