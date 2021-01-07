# Code to compute RZZ Parameters


This code computes the RZZ parameters for the GMs provided by the user. The user is required to provide GM input file that contains 4 variables:

      'ACC1'   --> n x 1 Cell Structure containing GM history in Direction 1 (units of g) 
      'ACC2'   --> n x 1 Cell Structure containing GM history in Direction 2 (units of g)
      'DT'     --> n x 1 array containing dts for the GM histories
      'RRUP'   --> n x 1 array containing Rrups of the GM histories (units of KM)
      

INPUTS:

The following inputs within the code are required:

      'GM_Input_File'      --> GM Input File containing the time-histories, DT and RRUP (as mentioned above)  
      'Results_Folder'     --> Folder that will contain the output RZZ parameters
      'Damping_Ratio'      --> Damping Rato of SDOF  
      'Periods_for_Sa'     --> Periods for computing Sa for both components (after rotation as per the provided reference) of GMs


OUTPUT:

The code will create 3 sub-folders inside 'Results_Folder' which include:

      'Non_Pulse_Like_GMs'    -->  contains RZZ parameters and Component Sa (after rotation as per the provided reference) of GMs classified as Non-Pulse-Like
      'Pulse_Like_GMs'        -->  contains RZZ parameters and Component Sa (after rotation as per the provided reference) of GMs classified as Pulse-Like
      'Pulse_Classification'  -->  contains Pulse Classification parameters 


The indices of the results are in the same order as the provided GMs. The code will also create 'RZZ_Params' .mat and .xlsx files that contain the important RZZs that are useful for engineering analysis. These results are also present in the workspace variable named 'RZZ_PARAMS'

Also, the Sa of the rotated components will be provided as 'SA_SPECTRA' variable and saved as 'SA_SPECTRA.mat'




NOTE:
To be efficient and prevent re-computations, before computing the RZZ parameters, the code performs a check in the 'Results_Folder' to see if RZZs of any GMs are already computed using the indices of the GMs. If the results are present, the code will NOT recompute the RZZ parameters for those GMs. Hence, to start fresh computations of RZZ parameters either delete the already created 'Results_Folder' or provide a different name for the 'Results_Folder' to save the results



Citation Reference: (https://doi.org/10.1785/0120200240)

        Jawad Fayaz, Sarah Azar, Mayssa Dabaghi, and Farzin Zareian (2020). "Methodology for Validation of Simulated Ground Motions for Seismic Response Assessment: Application to Cybershake Source-Based Ground Motions". Bulletin of Seismological Society of America. 


