function [data] = gen_synthetic_data(N, s, alpha, beta)
%% generate n-D synthetic data for the model.
%% N = number of customers
%% s: start prob
%% (alpha) = vector of parameters of dirichlet distribution
%% n = length(alpha);

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
        %thetas = betarnd(alpha, beta, table_cnt(i), 1);
	%sample dirichlet from gamma
	x=gamrnd([0.1, 0.5, 1, 2, 4], 1);
	thetas = x/sum(x);
        st_cnt = zeros(i + 1, 1);
        for j = 1 : table_cnt(i)
            theta = thetas(j);
            n_male = binornd(i, theta);
            st_cnt(n_male + 1) = st_cnt(n_male + 1) + 1;
        end
        for j = 1 : i + 1
            if st_cnt(j) > 0
                data = [data; (j-1) (i - j + 1) st_cnt(j)];
            end
        end
    end
    
    large_tables = sort(large_tables);
    last = 0;
    thetas = betarnd(alpha, beta, size(large_tables, 1), 1);
    n_large = size(large_tables, 1);
    for i = 1 : n_large
        if (i == n_large) || (large_tables(i) ~= large_tables(i + 1))
            male_cnt = [];
            for j = (last+1) : i
                theta = thetas(j);
                n_male = binornd(large_tables(j), theta);
                male_cnt = [male_cnt; n_male];
            end
            male_cnt = sort(male_cnt);
            tlast = 0;
            seg_cnt = i - last;
            for j = 1 : seg_cnt
                if (j == seg_cnt) || (male_cnt(j) ~= male_cnt(j + 1))
                    data = [data; male_cnt(j) (large_tables(i)-male_cnt(j)) (j-tlast)];
                    tlast = j;
                end
            end
            last = i;
        end
    end        
    %data
    disp('generation of synthetic data done');
end
