function [data] = gen_synthetic_data2(N, s, alpha)
%% generate n-D synthetic data for the model.
%% N = number of customers
%% s: start prob
%% (alpha) = vector of parameters of dirichlet distribution
    
    n = length(alpha);
    MAXR = 100;
    table_cnt = zeros(MAXR, 1);
    table_cnt(1) = 1;
    large_tables = [];
    for i = 2 : N
%         if mod(i, 10000) == 0
%             disp(sprintf('process %d out of %d customers', i, N));
%         end
        if (rand() <= s)
            % join a new table
            table_cnt(1) = table_cnt(1) + 1; 
        else
            % randomly select an table to join
            percentile = rand() * (i - 1);
            tot_sum = 0;
            for j = 1 : MAXR
                tot_sum = tot_sum + table_cnt(j) * j;
                if (tot_sum >= percentile)
                    table_cnt(j) = table_cnt(j) - 1;
                    if (j ~= MAXR)
                        table_cnt(j + 1) = table_cnt(j + 1) + 1;
                    else
                        large_tables = [large_tables; j+1];
                    end
                    break
                end
            end
            if tot_sum < percentile
                for j = 1 : size(large_tables, 1)
                    tot_sum = tot_sum + large_tables(j);
                    if tot_sum >= percentile
                        large_tables(j) = large_tables(j) + 1;
                        break;
                    end
                end
            end
        end
    end
    
    % join table done    
    data = [];
    
    for i = 1 : MAXR
        if table_cnt(i) == 0
            continue
        end  
        %sample multinomial from dirichlet
	
        thetas = drchrnd(alpha, table_cnt(i));                
        samples = [];
        st_cnt = zeros(i + 1, 1);
        for j = 1 : table_cnt(i)
            theta = thetas(j,:);
            sample = mnrnd(i, theta);
            samples = [samples; sample];
        end
        samples = sortrows(samples);
        last = 0;
        for j = 1 : table_cnt(i)
            if (j == table_cnt(i)) || (isequal(samples(j,:),samples(j+1,:)) == 0)
                data = [data; [samples(j,:) j-last]];
                last = j;
            end
        end               
    end
        
    large_tables = sort(large_tables);
    last = 0;    
    n_large = size(large_tables, 1);    
    thetas = drchrnd(alpha, n_large);        
    for i = 1 : n_large
        if (i == n_large) || (large_tables(i) ~= large_tables(i + 1))
            samples = [];
            for j = (last+1) : i
                theta = thetas(j,:);                                
                sample = mnrnd(large_tables(j), theta);                                
                samples = [samples; sample];                
            end            
            samples = sortrows(samples);
            tlast = 0;
            nsamples = size(samples,1);
            for j = 1 : nsamples
                if (j == nsamples) || (isequal(samples(j,:),samples(j+1,:)) == 0)                    
                    data = [data; [samples(j,:) j-tlast]];
                    tlast = j;
                end
            end            
            last = i;
        end
    end        
    %data
    disp('generation of synthetic data done');
end
