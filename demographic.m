classdef demographic < handle
    
    
    properties
        
        demographic_name             %name of demographic
        spread_parameters            %parameters dictating how likely this demographic is to spread/recieve the virus
        threshold_parameters         %parameters dictating demographic member's tolerance to virus
        
    end
    
    
    properties (Dependent)

        spread_close                 %"amount of virus" spread to close contact
        spread_chance                %"amount of virus" spread to chance encounter
        num_chance                   %number of chance encounters per day
        
        infection_threshold          %minimum amount of virus needed to be infected
        manifestation_threshold      %minimum amount of virus needed to manifest symptoms
        hospitalization_threshold    %minimum amount of virus needed to become hospitalized 
 
    end
    
    
    methods   
        
        function obj = demographic(demographic_name, spread_parameters, threshold_parameters)
        
            obj.demographic_name = demographic_name;
            obj.spread_parameters = spread_parameters;
            obj.threshold_parameters = threshold_parameters;
            
        end
        
        
        function spread_close = get.spread_close(obj)
            spread_close = obj.spread_parameters(1);
        end
        
        function spread_chance = get.spread_chance(obj)
            spread_chance = obj.spread_parameters(2);
        end
        
        function num_chance = get.num_chance(obj)
            num_chance = obj.spread_parameters(3);
        end
        
        function infection_threshold = get.infection_threshold(obj)
            infection_threshold = obj.threshold_parameters(1);
        end
        
        function manifestation_threshold = get.manifestation_threshold(obj)
            manifestation_threshold = obj.threshold_parameters(2);
        end
        
        function hospitalization_threshold = get.hospitalization_threshold(obj)
            hospitalization_threshold = obj.threshold_parameters(3);
        end
        

    end
    
    
end