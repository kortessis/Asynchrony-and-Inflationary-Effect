function dIdt = ISink_Sink(t, I, rhi, rlo, m)
dIdt(:,1) = zeros(2,1);

dIdt(1) = I(1).*(rhi - m) + m*I(2);
dIdt(2) = I(2).*(rlo - m) + m*I(1);

end

