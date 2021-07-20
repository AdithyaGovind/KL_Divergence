clear vars
clc

    % Year=[2002,2003,2004,2005,2011,2012,2017,2019];
    % Change year for different concentration and source files
    year=2011;
    
    % Sample Concentrations
    filename1=sprintf('SamplingConc_%d',year);
    Conc=xlsread('Dioxin_Master_WithoutHeaders.xlsx',filename1);
  
    % Source Concentrations
    filename2=sprintf('Source_%d',year);
    Source=xlsread('Dioxin_Master_WithoutHeaders.xlsx',filename2);

        
%%% Source file arrangement %%%
c=0;
AA=size(Source,1);
AA=AA-17;
S=zeros(17,4);
% Arranging/forming the source matrix
for i1=1:17:AA
  c=c+1;
  T=0;
  for i2=i1:(i1+17)-1
      T=T+1;
      % S matrix: 17 congener rows, 4 sources=> columns
      
      S((i2-i1)+1,c)=Source(i2,2);
  end
end

%%% Concentration file arrangement %%%
c=0;
BB=size(Conc,1);
C=zeros(17,50);
%Reading concentration file
for i1=1:17:BB
    c=c+1;
    T=0;
    for i2=i1:(i1+17)-1
      T=T+1;
        % C matrix: 17 congener rows, (no. of col=no. of stns)
       
        C((i2-i1)+1,c)=Conc(i2,2);
    end 
end


%%% K-L Divergence algorithm %%%

% Add rows of concentration and source matrices
% Summing the rows gives the total dioxin across all stations/sources

Sum_C=sum(C,1);
Sum_S=sum(S,1);

% Find the probabilities of each congener in each station/source by
    % dividing each congener conc by the sum

Probab_C=C./Sum_C;
Probab_S=S./Sum_S;

% Initializing KL_Result as the result of KL Divergence calculations
KL_Result=zeros(size(Probab_C,2),4); %  no. of stns x 4 sources

C_rows=size(Probab_C,1);
C_cols=size(Probab_C,2);

k=1;
while k<=size(Probab_S,2) % Loop for sources
    for j=1:C_cols % Loop for stations
        for i=1:C_rows % Loop for congeners
   
        KL_Result(j,k)=KL_Result(j,k)+Probab_C(i,j)*...
            log(Probab_C(i,j)/Probab_S(i,k));
        end
    end
k=k+1;
end

    % Output file
    sheetname1=sprintf('%d',year);
    xlswrite('KL_Div_Result.xlsx',KL_Result,sheetname1);