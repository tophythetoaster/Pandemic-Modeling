classdef population < handle
    
    properties
        
        G                           %fixed, underlying graph; nodes represent people, edges represent "close contacts" (family, co-workers,...)
        demographics                %array of demographic objects
        demographics_distribution   %probability vector giving the proportion of the population beloning to each demographic
        
        num_demographics            %number of different "demographics," i.e. groups of people with specific spread and threshold parameters
        num_people                  %number of people in population, equivalent to number of nodes in G
         
        people                      %array of person objects                   
        time_series                 %array which will store information for our simulations      
        
    end
    
  
    properties (Dependent)

        susceptible_IDs             %IDs of susceptible persons
        infected_IDs                %IDs of infected persons
        recovered_IDs               %IDs of recovered persons
        
        susceptible                 %array of susceptible persons
        infected                    %array of infected persons
        recovered                   %array of recovered persons
        
        num_susceptible             %number of susceptible persons
        num_infected                %number of infected persons
        num_recovered               %number of recovered persons
        
    end
    
    
    
    methods
        
        %constructor for the class
        function obj = population(G, demographics, demographics_distribution)
            
            obj.G = G;
            obj.demographics = demographics;
            obj.demographics_distribution = demographics_distribution;
            
            obj.num_people = numnodes(G);
            obj.people = person.empty(0, obj.num_people);
            obj.num_demographics = length(demographics);
            Die_Fledermaus = die(obj.demographics_distribution);
            for j = 1 : obj.num_people
                ID = j;
                demographic_idx = Die_Fledermaus.roll;
                demographic = obj.demographics(demographic_idx);
                peep = person(ID, demographic);
                obj.people(j) = peep;
            end
             
        end
        
        
        %num_initially_infected randomly selected people are infected
        function obj = initial_infection(obj, num_initially_infected)
            
            idx_initially_infected = randsample(obj.num_people, num_initially_infected);
            for j = 1 : num_initially_infected
                ID = idx_initially_infected(j);
                peep = obj.people(ID);
                peep.status = 'I';
                peep.infection_status = 'no_manifestation';
                peep.virus_amount = peep.demographic.infection_threshold;
            end
            
        end
        
 
        %SIMULATES PASSAGE OF SINGLE DAY, VERY IMPORTANT!!!!!
        function obj = time_step(obj)

            %iterate through infected persons
            inf = obj.infected;
            for i = 1 : obj.num_infected
               
                %x is an infected person
                x = inf(i);
                
                %iterate through infected person x's close contacts
                close_contacts = obj.close(x);
                num_close_contacts = length(close_contacts);
                for j = 1 : num_close_contacts
                    y = close_contacts(j);
                    y.spread(x, 'close');
                    obj.people(y.ID) = y;
                end
                
                %iterate through infected person x's chance encounters
                chance_encounters = obj.chance(x);
                num_chance_encounters = length(chance_encounters);
                for j = 1 : num_chance_encounters
                    y = chance_encounters(j);
                    y.spread(x, 'chance');
                    obj.people(y.ID) = y;
                end
                
                %increment number of days infected for person x. 
                x.increment;
                num_days_infected = x.num_days_infected;
                if num_days_infected >= 15
                    x.recover;
                    obj.people(x.ID) = x;
                end       
                
            end                      

        end

        
        %simulation with T + 1 days (initial infection day + T more days after)
        function obj = simulate(obj, num_initially_infected, T)
            
            obj.time_series = zeros(3, T + 1);
            
            %initialize
            obj.initial_infection(num_initially_infected);
            obj.time_series(:, 1) = [obj.num_susceptible, obj.num_infected, obj.num_recovered];
            
            %main loop
            for t = 1 : T
                str = sprintf('Day %d of %d', t, T);
                disp(str);
                obj.time_step;
                obj.time_series(:, t + 1) = [obj.num_susceptible, obj.num_infected, obj.num_recovered];
            end
            
        end
        
        
        
        %close is array of close contacts of person peep
        function close_contacts = close(obj, peep)
            ID = peep.ID;
            close_contact_IDs = neighbors(obj.G, ID);
            close_contacts = obj.people(close_contact_IDs);
        end
        
        
        %chance is array of chance encounters of person peep
        function chance_encounters = chance(obj, peep)
            ID = peep.ID;
            chance_encounter_IDs = randsample(obj.num_people, peep.num_chance);
            chance_encounters = obj.people(chance_encounter_IDs);
        end
        
        
        %getters
        function susceptible_IDs = get.susceptible_IDs(obj)
            status = [obj.people.status];
            susceptible_IDs = find(status == 'S');
        end
        
        function infected_IDs = get.infected_IDs(obj)
            status = [obj.people.status];
            infected_IDs = find(status == 'I');
        end
        
        function recovered_IDs = get.recovered_IDs(obj)
            status = [obj.people.status];
            recovered_IDs = find(status == 'R');
        end
        
        function susceptible = get.susceptible(obj)
            susceptible = obj.people(obj.susceptible_IDs);
        end
        
        function infected = get.infected(obj)
            infected = obj.people(obj.infected_IDs);
        end
        
        function recovered = get.recovered(obj)
           recovered = obj.people(obj.recovered_IDs);
        end
        
        function num_susceptible = get.num_susceptible(obj)
            num_susceptible = length(obj.susceptible_IDs);
        end
        
        function num_infected = get.num_infected(obj)
            num_infected = length(obj.infected_IDs);
        end
        
        function num_recovered = get.num_recovered(obj)
            num_recovered = length(obj.recovered_IDs);
        end
        
               
    end

end