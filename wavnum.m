function xkt = wavnum(frq,dep)

for zz = 1:length(frq)
    tmp = (2*pi*frq(zz))^2/9.81;
    xk = tmp;

    d20 = 2*pi/(20 * tmp);
    if dep <= d20
        xkt(zz) = (2*pi * frq(zz)) / sqrt(9.81 * dep);
        continue
        %return
    end

    for ii = 1:150
        xk_new = tmp/tanh(xk*dep);
        diff = abs((xk_new - xk) /xk_new);
        if (diff <= 0.005)
            xkt(zz) = xk;
            continue
            %return
        end
        xk = xk_new;
    end
end

        
        