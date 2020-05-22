classdef person < handle
   
    properties
        
        ID                  %persons ID number
        demographic         %demographic to which the person belongs
        status              %status ('S' 'I', 'R')           
        virus_amount        %"amount of virus" you contain
        num_days_infected   %number of days infected
        
        infection_status    %describes how bad infection is: no_manifestation, manifestation, or hospitalization
        infector            %person who caused you to be infected 
        manifestor          %person who caused you to be infected to the point of manifesting symtoms
        hospitalizor        %person who caused you to be infected to the point of hospitalization 
        
    end
    
    
    properties (Dependent)
        
        %see demographic class for explanation
        
        demographic_name
        spread_close
        spread_chance
        num_chance
        
        infection_threshold   
        manifestation_threshold
        hospitalization_threshold
        
    end

    
    methods
        
        function obj = person(ID, demographic)
            
            obj.ID = ID;
            obj.demographic = demographic;
            obj.status = 'S';
            obj.virus_amount = 0;
            obj.num_days_infected = 0;
            
        end

        
        %MAIN FUNCTION DICTATING HOW VIRUS SPREADS, VERY IMPORTANT!!!!!
        function obj = spread(obj, contact, contact_type)
            
           if strcmp(obj.status, 'R') || ~strcmp(contact.status, 'I')
              %virus cannot spread in this case
           else
              if strcmp(contact_type, 'close')
                  amount_spread = obj.spread_close * contact.spread_close;
              else
                  amount_spread = obj.spread_chance * contact.spread_chance;
              end
              
              obj.virus_amount = obj.virus_amount + amount_spread; 
              

              if obj.virus_amount < obj.infection_threshold
                  obj.status = 'S';
              elseif (obj.virus_amount >= obj.infection_threshold) && (obj.virus_amount < obj.manifestation_threshold)
                  obj.status = 'I';
                  obj.infection_status = 'no_manifestation';
                  obj.infector = contact;
              elseif (obj.virus_amount >= obj.manifestation_threshold) && (obj.virus_amount < obj.hospitalization_threshold)
                  obj.status = 'I';
                  obj.infection_status = 'manifestation';
                  obj.manifestor = contact;
              else
                  obj.status = 'I';
                  obj.infection_status = 'hospitalization';
                  obj.hospitalizor = contact;
              end
              
              
   
           end
              
        end
        
        
        %increments number of days infected by 1
        function obj = increment(obj)
            obj.num_days_infected = obj.num_days_infected + 1;
        end
        
        
        %person is recovered 
        function obj = recover(obj)
            obj.status = 'R';
        end
        

        %getters
        function demographic_name = get.demographic_name(obj)
            demographic_name = obj.demographic.demographic_name;
        end
        
        function spread_close = get.spread_close(obj)
            spread_close = obj.demographic.spread_close;
        end
        
        function spread_chance = get.spread_chance(obj) 
            spread_chance = obj.demographic.spread_chance;  
        end
        
        function num_chance = get.num_chance(obj)
            num_chance = obj.demographic.num_chance;
        end
   
        function infection_threshold = get.infection_threshold(obj)
            infection_threshold = obj.demographic.infection_threshold;
        end
        
        function manifestation_threshold = get.manifestation_threshold(obj)
            manifestation_threshold = obj.demographic.manifestation_threshold;
        end
        
        function hospitalization_threshold = get.hospitalization_threshold(obj)
            hospitalization_threshold = obj.demographic.hospitalization_threshold;
        end
          
    end

end