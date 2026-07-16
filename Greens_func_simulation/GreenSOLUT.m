clear
tic

R=1.8;
H=0.2;

scale=10;

N=scale*180;
M=scale*20;
hr=R/N;
hz=H/M;

eps=1e-8;

x=linspace(0,R,N+1);
y=linspace(0,H,M+1);

% ----------------- relaxation for Green func. solution ----------------- %
G=zeros(M+1,N+1,N+1);
for n=1:N+1
    G(M/2+1,n,n)=0;
end

max_err=1;
while (max_err>eps)
    for i=1:N
        for j=2:M
            a=G(j,i,1);
            if (i==1)
                if (j==M/2+1)
                    G(j,1,1)=(4*(hz/hr)*G(j,2,1)+(hr/hz)*G(j-1,1,1)+(hr/hz)*G(j+1,1,1)+1)/(4*hz/hr+2*hr/hz);
                else
                    G(j,1,1)=(4*(hz/hr)*G(j,2,1)+(hr/hz)*G(j-1,1,1)+(hr/hz)*G(j+1,1,1))/(4*hz/hr+2*hr/hz);
                end
            else
                G(j,i,1)=((i-1/2-1)*(hz/hr)*G(j,i-1,1)+(i+1/2-1)*(hz/hr)*G(j,i+1,1)+(i-1)*(hr/hz)*G(j-1,i,1)+(i-1)*(hr/hz)*G(j+1,i,1))/(2*(i-1)*(hz/hr+hr/hz));
            end
            err(j,i,1)=abs(G(j,i,1)-a);
        end
    end
    
    for n=2:N  
        for i=1:N
            for j=2:M
                a=G(j,i,n);
                if (i==1)
                    G(j,i,n)=(4*(hz/hr)*G(j,i+1,n)+(hr/hz)*G(j-1,i,n)+(hr/hz)*G(j+1,i,n))/(4*hz/hr+2*hr/hz);
                else   
                    if (j==M/2+1)&&(i==n)
                        G(j,i,n)=((i-1/2-1)*(hz/hr)*G(j,i-1,n)+(i+1/2-1)*(hz/hr)*G(j,i+1,n)+(i-1)*(hr/hz)*G(j-1,i,n)+(i-1)*(hr/hz)*G(j+1,i,n)+(i-1))/(2*(i-1)*(hz/hr+hr/hz));
                    else
                        G(j,i,n)=((i-1/2-1)*(hz/hr)*G(j,i-1,n)+(i+1/2-1)*(hz/hr)*G(j,i+1,n)+(i-1)*(hr/hz)*G(j-1,i,n)+(i-1)*(hr/hz)*G(j+1,i,n))/(2*(i-1)*(hz/hr+hr/hz));
                    end
                end
                err(j,i,n)=abs(G(j,i,n)-a);
            end
        end
    end
    max_err=max(max(max(err)))
end

toc

% save('GreenFunc180x20.mat', 'G','-v7.3')  % use with scale=1
save('GreenFunc1800x200.mat', 'G','-v7.3') % use with scale=10

%plot(x,G(M/2+1,:,5),x,G(M/2+1,:,50),x,G(M/2+1,:,150))