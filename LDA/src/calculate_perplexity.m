function perplexity = calculate_perplexity(phi, theta, dataset)
    log_p_w = 0 ;
    l = size(dataset,2) ;
    global k;
    for d_idx =1 : size(dataset,1)
        word_indices = (dataset(d_idx,:) & 1 ) .* (1:l) ;
        word_indices = word_indices(word_indices ~= 0) ;
        for w = word_indices
            inside_log = 0 ;
            for topic = 1 : k 
                inside_log = inside_log + theta(topic,d_idx)* phi(topic,w);
            end
            log_p_w = log_p_w + dataset(d_idx,w) * log(inside_log) ;
        end
    end
    perplexity = exp(-(log_p_w/sum(sum(dataset))));

