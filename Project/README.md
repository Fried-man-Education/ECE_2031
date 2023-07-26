# Ambient Sound Level Monitor Peripheral
Created by: Andrew Nichols Friedman, Daniel Kyle George, Yuanning Liu, Hassaan Mamoun Mohammed
## Device Functionality
To use the AudioMonitor peripheral, A SCOMP programmer first needs an ADC interface peripheral that takes in ADC data and handles the serial-to-parallel data conversion and synchronization with the SCOMP system. This way, the AudioMonitor peripheral can access a simple 16-bit audio sample. The top-level schematic and inputs/outputs of the AudioMonitor peripheral are available in Figure 1 and Figure 2. 
<div align="center">
<img width="689" alt="Screenshot 2023-07-25 at 8 05 18 PM" src="https://github.com/Fried-man/ECE_2031_Project/assets/17306743/4786637d-d5ca-4f70-99a6-a3c19cdf3bbf">
  
**Figure 1.** The Top-level SCOMP schematic of the AudioMonitor peripheral

| Input/Output       | Description (Relationship with SCOMP signals)                                           |
|--------------------|----------------------------------------------------------------------------------------|
| CS (IN)            | System AUD_EN, enable the peripheral to transfer data to IO_DATA.                      |
| IO_WRITE (IN)      | System IO_WRITE.                                                                      |
| SYS_CLK (IN)       | System clock signal.                                                                  |
| RESETN (IN)        | System RESETN.                                                                        |
| AUD_DATA[15..0] (IN)| 16-bit audio data output from the ADC interface peripheral.                           |
| AUD_NEW (IN)       | A signal from the ADC interface peripheral indicating that a new signal is available for the AudioMonitor Peripheral.  |
| IO_DATA[15..0] (IN)| Ambient sound level output from the AudioMonitor peripheral.                          |

**Figure 2.** Description of the inputs and outputs of the AudioMonitor peripheral
</div>
The SCOMP controls the CS, IO_WRITE, SYS_CLK, and RESETN input of the AudioMonitor peripheral. The ADC interface peripheral signals and passes the newly available audio data to the AudioMonitor peripheral. Every time AUD_DATA is made available, and there is a rising edge of AUD_NEW, we add the current audio value to the sum of all audio values in this window. Then, we calculate the average of all the data points available and store it in average. Once the previous window fills up, we use the equation average <= abs(new_data) + ((average - abs(new_data)) / max to estimate the new average sound level. The AudioMonitor peripheral then latches the ambient sound level data to IO_DATA when CS(AUD_EN) is high, and IO_WRITE is low. When IO_DATA has the data, SCOMP can utilize this data as needed.
  
## Design Decisions and Implementation

To balance the response time of the peripheral, we chose to average the audio data of length 2.5 seconds. We accomplished this via four signals: PARSED_DATA, WINDOW_SUM, COUNT, and AVERAGE. After passing new data into the peripheral, AUD_DATA is converted to a signed format and stored in PARSED_DATA. Then, WINDOW_SUM updates by accumulating the absolute values for each new data up to 30,000,000 cycles. COUNT updates with the number of samples taken in and AVERAGE is updated by dividing WINDOW_SUM by COUNT. Once COUNT exceeds the window size of 30,000,000, the average recalculates in real-time via the above equation. This design is far from the original concept we ideated. Initially, we designed a rolling average on an array in which each item was data from AUD_DATA. An array of length 30,000,000 was required to reach the target of 2.5 seconds, and although the design functioned properly for smaller lengths, this was too large of a quantity for Quartus to compile. This compilation issue led us to focus on methods that did not require arrays, realizing itself in our finalized design.
