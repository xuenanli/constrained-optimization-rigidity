function [grad_approx, grad_tan_approx, grad_pen_approx] = approx_grad_obj_fcn(x,a,pfix,dim,h,list_free_edge,rho,framework)
grad_approx = zeros(length(x),1);
grad_tan_approx = zeros(length(x),1);
grad_pen_approx = zeros(length(x),1);

for i=1:length(x)/2
    if find(pfix==i,1) % ith vertex is fixed
        grad_approx(2*i-1:2*i) = 0;
    else
        % odd
        dx = zeros(length(x),1);
        dx(2*i-1) = h;
        
        [f0_up, f_tan_up, f_pen_up] = f0_objective_fcn(x+dx,a,pfix,dim,list_free_edge,rho,framework);
        [f0_dn, f_tan_dn, f_pen_dn] = f0_objective_fcn(x-dx,a,pfix,dim,list_free_edge,rho,framework);

        grad_approx(2*i-1) = f0_up - f0_dn;
        grad_approx(2*i-1) = grad_approx(2*i-1)/2/h;

        grad_tan_approx(2*i-1) = f_tan_up - f_tan_dn;
        grad_tan_approx(2*i-1) = grad_tan_approx(2*i-1)/2/h;

        grad_pen_approx(2*i-1) = f_pen_up - f_pen_dn;
        grad_pen_approx(2*i-1) = grad_pen_approx(2*i-1)/2/h;
        
        % even
        dx = zeros(length(x),1);
        dx(2*i) = h;

        [f0_up, f_tan_up, f_pen_up] = f0_objective_fcn(x+dx,a,pfix,dim,list_free_edge,rho,framework);
        [f0_dn, f_tan_dn, f_pen_dn] = f0_objective_fcn(x-dx,a,pfix,dim,list_free_edge,rho,framework);

        grad_approx(2*i) = f0_up - f0_dn;
        grad_approx(2*i) = grad_approx(2*i)/2/h;

        grad_tan_approx(2*i) = f_tan_up - f_tan_dn;
        grad_tan_approx(2*i) = grad_tan_approx(2*i)/2/h;

        grad_pen_approx(2*i) = f_pen_up - f_pen_dn;
        grad_pen_approx(2*i) = grad_pen_approx(2*i)/2/h;
    end
end
end