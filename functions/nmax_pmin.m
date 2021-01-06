function [I,time_for_max_min]= nmax_pmin(F)

%%%% ------ Positive Min and Negative Maximums ----- %%%%
    n = length(F);
    countmin=0;
    countmax=0;
    cmin=1;
    cmax=1;
    i=0;
    j=0;
    for r=2:n-1
        if F(r)>0
            if F(r-1)>F(r)
                if F(r+1)>F(r)
                    i = i+1;
                    countmin=countmin+1;
                    cmin(i,1) = r;
                end
            end
        else
            if F(r-1)<F(r)
                if F(r+1)<F(r)
                    j = j+1;
                    countmax=countmax+1;
                    cmax(j,1) = r;
                end
            end
        end
        I(r-1)=countmin+countmax;
    end
    I=[I(1) I I(n-2)];
    time_for_max_min = sort([cmax;cmin],'ascend');
    
end
