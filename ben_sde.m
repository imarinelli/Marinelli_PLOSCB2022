function [dxdt] = ben_sde(A,X,beta,lamB,lamE_cort,lamE_sleep,node,tau)

coder.inline('never')

%% Function computes a step (Forward Euler) for the Benjamin model, including linear coupling.
% Input: state vector x (at time t) and adjacency matrix A
% Output: change vector dxdt for the given x at time t


n      = length(A);                                                         % Number of nodes A: Adjacency Matrix
ome    = 20;                                                                % omega: frequency of oscillation
sig    = 2;                                                                 % sigma: coefficient r^3-term: unstable limit-cycle
kap    = -1;                                                                % kappa: coefficient r^5-term: outer stable limit-cycle
dxdt   = zeros(3*n,1);                                                      % initialize solution-step
x      = X(1:n);                                                            % all real parts         
y      = X(n+1:2*n);                                                        % all imaginary parts
lam    = X(2*n+1:end);                                                      % all lambda's
r      = x.^2+y.^2;                                                         % r = |z|^2 = (x^2+y^2) with z=x+iy
coup_a = zeros(1,n);                                                        % initialize coupling-term
coup_b = zeros(1,n);                                                        % initialize couping-term

for k = 1:n
    coup_a(k) = A(:,k)'*(x-x(k));                                           % linear coupling: beta*M(i,j)*(z_j-z_i)
    coup_b(k) = A(:,k)'*(y-y(k));                                           % see above
end

dxdt(1:n)       = -ome.*y + x.*((lam-1) + sig*r + kap*r.^2) + beta*coup_a';     % x'=...
dxdt(n+1:2*n)   =  ome.*x + y.*((lam-1) + sig*r + kap*r.^2) + beta*coup_b';     % y'=...
dxdt(2*n+1:end) = (lamB-lam-r)./tau;                                            % lam'=...   
dxdt(2*n+node)  = (lamB-lam(node)+lamE_cort+lamE_sleep-r(node))./tau;                           % lam-local
