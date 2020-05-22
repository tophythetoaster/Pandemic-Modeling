%% make demographics

%{

name                         = name of demographic     
spread_parameters            = [spread_close, spread_chance, num_chance]  
threshold_parameters         = [infection_threshold, manifestation_threshold, hospitalization_threshold]
dem = demographic(name, spread_parameters, threshold_parameters);


copy-paste this to make instantiation of demographics easier: 

name = '';
spread_parameters = [,,];
threshold_parameters = [,,];
dem = demographic(name, spread_parameters, threshold_parameters);

%}

%constructing demographic 1
name_1 = 'active, no mask';
spread_parameters_1 = [1, .5, 10];
threshold_parameters_1 = [10, 100, 1000];
dem_1 = demographic(name_1, spread_parameters_1, threshold_parameters_1);

%constructing demographic 2
name_2 = 'passive, wears mask';
spread_parameters_2 = [1, 0, 0];
threshold_parameters_2 = [10, 30, 100];
dem_2 = demographic(name_2, spread_parameters_2, threshold_parameters_2);

%array containing demographic objects
demographics = [dem_1, dem_2];


%% make population

%make underlying graph G, which simulates close contacts (family, co-workers,...) 
num_people = 100000;
ave_num_contacts = 4;
connectivity = ave_num_contacts / num_people;
G = make_graph(num_people, connectivity);

%demographics distribution approximate proportion of population belonging to corresponding demographic
demographics_distribution = [.8, .2];       

%construct population object
pop = population(G, demographics, demographics_distribution);


%% simulate pandemic 

%number of people initially infected, chosen uniformly at random
num_initially_infected = 1;

%number of days after initial infection day the simulation runs
T = 30;

%runs simulation
pop.simulate(num_initially_infected, T);


%% plot time series

time_series = pop.time_series;
time_series = log10(1 + time_series);

figure;
plot(days, time_series, 'LineWidth', 2);
title('Pandemic Simulation', 'Fontsize', 18);
legend({'Susceptible', 'Infected', 'Recovered'}, 'Fontsize', 16);
b = log10(pop.num_people) + 1;
ylim([0, b]);
xlabel('Days', 'Fontsize', 14);
ylabel('Number of People, log-scale', 'Fontsize', 16);


