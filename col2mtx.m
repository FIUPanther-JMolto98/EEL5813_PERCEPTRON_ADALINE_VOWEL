% col2mtx - FOR EEL5813 PRJ 1, converts an input pattern from a 20-by-1  column vector p to a 4-by-5 MATRIX PM

function PM = col2mtx(p);
PM = reshape(p,4,5);
end