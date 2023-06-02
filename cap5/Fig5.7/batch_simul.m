% batch job on a LOCAL paralle cluster
% SSHFS is required, unexpectedly CHIEDERE A FABIO - FAUSTO

% simulations 
simuls=50;


% start the cluster and assign it to a variable 'c'
c=parcluster();

% start the parallel job on the local cluster
% pleas note the peculiar syntax for passing and retrieving data from
% functions!
job = batch(c,@NUfx,4,{simuls}, 'Pool',4,'CurrentFolder','.');

% find the ID of the current job
lastjob=findJob(c,'ID',job.ID);

% when job is finished retrieve output data
X = fetchOutputs(lastjob);

% enumerate jobs output
X{1}
X{2}

% clean job
delete(job);
clear job

%% the same on unipr HPC

% batch job on a LOCAL paralle cluster

% simulations 
simuls=5000;


% start the cluster and assign it to a variable 'c'
c=parcluster('cluster R2022a');

% start the parallel job on the local cluster
% pleas note the peculiar syntax for passing and retrieving data from
% functions!
job = batch(c,@NUfx,4,{simuls}, 'Pool',47,'CurrentFolder','.');

% find the ID of the current job
lastjob=findJob(c,'ID',job.ID);

% when job is finished retrieve output data
X = fetchOutputs(lastjob);

% enumerate jobs output
X{1}
X{2}

% clean job
delete(job);
clear job