%Transmission Line Analysis Project%
function [ ] = line_analysis(ABCD)
fprintf('Transmission Line Terminal Data\t\t\t  Select\n===============================          =======\nReceiving-End Voltage, Apparent Power\n');
fprintf('\tand power factor\t\t\t\t\t\tRE\n\nSending-End Voltage, Apparent Power\n\tand power factor\t\t\t\t\t\tSE\n_________________________________________________\n');
lt=input(' \n Enter your Choice: ','s');
while(3)
    switch lt
       case {'RE','SE'}
            break
        otherwise
            lt=input('Kindly Select RE or SE only in upper case letters: ','s');
    end
end
switch lt
    case 'RE'
    in={'Enter the Vr line-to-line:','Enter 3-phase Sr, MVA:','Enter receiving end power factor: ','Type lagging or leading:'};
    title='Receiving-End parameters';
    case 'SE'
    in={'Enter the Vs line-to-line:','Enter 3-phase Ss, MVA:','Enter sending end power factor: ','Type lagging or leading:'};
    title='Sending-End parameters';
end 
    box=inputdlg(in,title);
    vl=str2double(box(1))*1e+3;
    S=str2double(box(2))*1e+6;
    pf=str2double(box(3));
    while 1
    a=strcmp(box(4),'lagging');
    a2=strcmp(box(4),'leading');
         if a==1
             x=-acos(pf);
             break
         elseif a2==1
             x=acos(pf);
             break
         else
             in='Please type lagging or leading only: ';
             box(4)=inputdlg(in);
         end
    end
    Pgiv=S*pf;
    VgivP=(vl/sqrt(3));
    IgivP=S/((sqrt(3)*vl));
    IgivL=((IgivP))*complex(cos(x),sin(x));
switch lt
    case 'RE'
    END='Sending-End';
    VreqP=ABCD(1,1)*VgivP+ABCD(1,2)*IgivL;
    IreqP=ABCD(2,1)*VgivP+ABCD(2,2)*IgivL;
    Preq=3*real(VreqP*(conj(IreqP)));
    EF=((Pgiv)/Preq)*100;
    VR=abs((((abs(VreqP)/abs(ABCD(1,1)))-abs(VgivP))/abs(VgivP)))*100;
    case 'SE'
    END='Receiving-End'; 
    VreqP=ABCD(1,1)*VgivP-ABCD(1,2)*IgivL;
    IreqP=-ABCD(2,1)*VgivP+ABCD(2,2)*IgivL;
    Preq=3*real(VreqP*(conj(IreqP)));
    EF=((Preq)/Pgiv)*100;
    VR=abs((((abs(VgivP)/abs(ABCD(1,1)))-abs(VreqP))/abs(VreqP)))*100;
end
    Qreq=3*imag(VreqP*(conj(IreqP)));
    pF=cos(atan(Qreq/Preq));
    Iangle=angle(IreqP)*(180/pi);
    Vpangle=angle(VreqP)*(180/pi);
    if Qreq<0
        pFd='Leading';
    else
        pFd='Lagging';
    end
    fprintf('%s phase voltage = %0.4f kV at %0.4f degrees.',END,abs(VreqP)*1e-3,Vpangle);
    fprintf('\n%s current = %0.4f A at %0.4f degrees.',END,abs(IreqP),Iangle);
    fprintf('\n%s line voltage = %0.4f kV at %0.4f degrees.',END,abs(VreqP)*1e-3*sqrt(3),Vpangle+30);
    fprintf('\n%s Real power = %0.4f MW.',END,Preq*1e-6);
    fprintf('\n%s Reactive power = %0.4f MVAr.',END,Qreq*1e-6);
    fprintf('\n%s Power factor = %0.4f, %s.',END,pF,pFd);
    fprintf('\nVoltage Regulation = %0.4f',VR);
    disp('%.');
    fprintf('Line Efficiency = %0.4f',EF);
    disp('%.');
end
