#  How to run MATLAB code in Jupyter notebooks 

For each chapter of the book we have given for each file the original source .m file and the corresponding .ipynb file.
The .m file (after installing FSDA) can be run on your MATLAB desktop or in MATLAB Online (please see the button run in MATLAB Online).
The .ipynb is given in order to show you the output of the code.
The purpose of this file is to show how these .ipynb can be run in jupiter notebook. 

The official MathWorks reference on how to run  MATLAB code in Jupyter notebooks is at [Jupyter Proxy](https://github.com/mathworks/jupyter-matlab-proxy/blob/main/README.md)

Please follow the steps detailed in the file above. If something went wrong and the [TroublesShooting](https://github.com/mathworks/jupyter-matlab-proxy/blob/main/troubleshooting/troubleshooting.md) did not work (as in our case) try the instructions below

## WINDOWS INSTALLATION

Here are the most relevant steps of the setup process.

Open your Python terminal (not the CMD prompt!) (i.e. the Anaconda prompt) and paste these 3 lines:

```
python -m pip install jupyter-matlab-proxy

python -m pip install notebook

python -m pip install jupyterlab
```

If you do not already have a Python setup you can run these lines in the Windows Terminal (CMD)

```
curl https://repo.anaconda.com/miniconda/Miniconda3-py311_24.5.0-0-Windows-x86_64.exe -o miniconda.exe
start /wait "" miniconda.exe /S
del miniconda.exe
```

this is the last supported Python version (3.11.24) of the MATLAB Jupyter proxy project



Now, still into the Python prompt (Anaconda prompt) if you type 

```
jupyter notebook
```

You should be able to start a new Jupyter notebook with a MATLAB kernel.

If you get the error

`Jupyter is not recognized as an internal or external command`

as documented in the Stack Overflow Page

[Jupyter is not recognized](https://stackoverflow.com/questions/52287117/jupyter-is-not-recognized-as-an-internal-or-external-command)

try
```
pip install jupyter notebook 
python -m notebook 
```

Now, finally you should be able to start a new Jupyter notebook with a MATLAB kernel. For example if you have navigated into the folder FigMonitoringBook you should see inside localhost the subfolders of the book and in the background the terminal you used to launch the instruction jupiter notebook


![](./images/jupyter.jpg)


For example, after navigating to cap2 and opening the file areVarComparison and clicking on play button (Run this cell and advance) you should see

![](./images/jupyterStart.jpg)

BE AWARE of the fact that MATLAB can take more than 90 seconds to start and ask you for a valid license before you can actually be able to use the notebook!


When you are prompted to enter your license, enter your credential and wait for MATLAB process to start.


### Troubleshooting after clicking on the play button


If you receive an error such as:

"Could not connect...." or
"MATLAB startup has timed out. Click Start MATLAB to try again",
or if you have installed a prerelease license, MATLAB tries to link your account to this license and says that you do not have a valid license.

In all these cases you have to:
1. terminate the process in the Python prompt with  CTRL+C (twice CTRL+C)
2. close the browser tab
3. delete the folder `<disk>:\Users\<user>\.matlab`
4. relaunch from the Python prompt: `jupyter notebook`
5. wait for the license check 
6. select `existing license` or or `Online License Manager` tab and confirm the choice 

![](./images/ExistingLicence.jpg)

Note that in order to force Jupiter MATLAB proxy not to use the prerelease version (or a particular release) it is necessary to rename MATLAB.exe file inside `R202xx\bin` folder of the prerelease or of the release you do not want to use (say to MATLABtmp.EXE). Of course the steps above remain.

Note that in the Python prompt it is possible to see which release Jupiter MATLAB proxy is trying to use

`INFO:MATLABProxyApp:Found MATLAB executable at: C:\Program Files\MATLAB\R2024a\bin\matlab.EXE`

Remark: of course do not forget to rename to MATLAB.exe the file MATLABtmp.EXE