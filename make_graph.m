function G = make_graph(n, p)
    
    A = sprand(n, n, p / 2);
    A = A + A';
    A = A / 2;
    G = graph(A);
    
end