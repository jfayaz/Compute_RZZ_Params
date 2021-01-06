function zhat=z_zhatcalc(error,targetLP)

if (error(1)>0)
    %interpolate:
    zp=length(find(error>0))*0.1; %damping that corresponds to the smallest positive error
    zn=zp+0.1;                    %damping that corresponds to the smallest negative error       
    if zp<0.9
    if zn<=28   
    ep=error(round(zp*10));       %smallest positive error
    en=error(round(zn*10));       %smallest negative error
    zhat=zp-ep*((zp-zn)/(ep-en));
    else
        zhat=1000;
    end
    else
    if zn<=28   
    ep=error(8);       %smallest positive error
    en=error(9);       %smallest negative error
    zhat=0.9-ep*((0.8-0.9)/(ep-en));
    else
        zhat=1000;
    end
    end
else   
    %extrapolate assuming error for damping=0 is sum(target) (reasonable assumption
    %since harmonic motion has 0 damping and 0 pmin+nmax)
    zp=0;
    ep=sum(targetLP);
    zn=0.1;
    en=error(1);
    zhat=zp-ep*((zp-zn)/(ep-en));
end
end
  