# 🚀 Reaction Wheel Control of an Air-Bearing Floating Robot  

## 📌 Overview  
This repository contains the code and simulation models for the **attitude control system** of an **air-bearing floating robot** using a **reaction wheel with a single degree of freedom**. This project was developed as part of the **MSc in Space Engineering** at the **University of Surrey - Surrey Space Centre**, aiming to simulate **near-frictionless conditions** similar to those in space.  

## 📂 Repository Structure  
```
Reaction-Wheel-Control/
│── CAD/                     # CAD files of the floating robot assembly
│── CAD_Images/              # Images of the robot model
│── Images/                  # Simulink Simulations ScreenShots
│── src/                     # Simulink models and MATLAB scripts for calculations and system simulations  
│── Documentation/           # Project-related documents and reports  
│── README.md                # This file  
```

## ⚙️ Setup & Usage  

### 1️⃣ Initialize System Variables  
Before running any **Simulink model**, execute the following MATLAB script to load all system variables into the workspace:  
```matlab
run('src/SystemVariables.m');
```
### 2️⃣ Running Simulink Models  
To simulate the **attitude dynamics and control using a reaction wheel**, follow these steps:  

1. Open **MATLAB**.  
2. Navigate to the `src/` directory.  
3. Open the required Simulink model: `src/CompleteControl_SimpleDC.slx`
4. Click **Run** to start the simulation.  

### 3️⃣ Viewing the Full CAD Assembly  
To visualize the **complete robot assembly**, follow these steps:  

1. Open **SolidWorks**.  
2. Navigate to the `CAD/` directory.  
3. Open the following file:  
`CAD/Floating Robot 2.SLDASM`
4. The full 3D model of the robot should load in SolidWorks.

## 🛠 System Components  
- **Reaction Wheel**: Provides the necessary torque for attitude control.  
- **BLDC Motor**: Controls the reaction wheel’s angular velocity.  
- **Air-Bearing System**: Reduces friction, simulating space-like conditions.  
- **MATLAB/Simulink**: Used for system modeling, simulation, and control design.  

## 📌 Research Contributions  
This project contributes to the **development of reaction wheel-based attitude control systems**, which are widely used in **CubeSats** and other small spacecraft. The system has been validated through numerical simulations and CAD modeling, providing a foundation for further experimental testing.  

## 📖 References  
For a detailed explanation of the system design, refer to the **thesis document** included in the `Documentation/` folder.  

## 📝 License  
© 2024 Jorge Antonio Chavarín Montoya.  
This project is part of academic research and is distributed for educational and research purposes.  

