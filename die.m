classdef die < handle
    
    
    properties
        probability_vector
        pint
        N
    end
    

    methods
        
        
        function obj = die(probability_vector)
            
            obj.probability_vector = probability_vector;     
            p = probability_vector;
            n = length(p);
            p = 100 * p;
            obj.N = sum(p);
            obj.pint = zeros(1, obj.N);
            a = 1;
            for j = 1 : n
                 b = a + p(j) - 1;
                 obj.pint(a : b) = j * ones(1, b - a + 1);
                 a = b + 1;
            end
            
        end
        
        

        
        function r = roll(obj)
        
            i = randi([1, obj.N]);
            r = obj.pint(i);
        
        end
        
        
 
        
    end
    
    
end