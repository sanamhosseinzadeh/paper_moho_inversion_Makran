%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Computes the fully normalized associated Legendre polynomials **P̄nm** up to a given maximum degree.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Pnm = Pnm_normalise(n, m, x)

    if m < 0 || m > n || abs(x) > 1
        error('Invalid arguments in Pnm_normalise: n=%d, m=%d, x=%f', n, m, x);
    end

    if n == m
        if m == 0
            Hnm = 1;
        elseif m == 1
            Hnm = sqrt(3);
        else
            Hnm = sqrt(3);
            for j = 2:m
                Hnm = sqrt(1 + 1/(2*j)) * Hnm;
            end
        end
    elseif n == m+1
        if m == 0
            Hnm = 1;
        elseif m == 1
            Hnm = sqrt(3);
        else
            Hnm = sqrt(3);
            for j = 2:m
                Hnm = sqrt(1 + 1/(2*j)) * Hnm;
            end
        end
        Hnm = sqrt(2*m + 3) * x * Hnm;
    else
        if m == 0
            Hnm2 = 1;
        elseif m == 1
            Hnm2 = sqrt(3);
        else
            Hnm2 = sqrt(3);
            for j = 2:m
                Hnm2 = sqrt(1 + 1/(2*j)) * Hnm2;
            end
        end
        Hnm1 = sqrt(2*m + 3) * x * Hnm2;
        for j = m+2:n
            nn = j - 1;
            alpha_n_1m = sqrt((2*nn+1)*(2*nn-1)/((nn-m)*(nn+m)));
            alpha_nm   = sqrt((2*j+1)*(2*j-1)/((j-m)*(j+m)));
            aux = alpha_nm * (x * Hnm1 - Hnm2 / alpha_n_1m);
            Hnm2 = Hnm1;
            Hnm1 = aux;
        end
        Hnm = Hnm1;
    end

    cos_phi = sqrt(1 - x^2);
    Pnm = cos_phi^m * Hnm;
end
