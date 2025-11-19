<!-- Header block for project -->
<hr>

<div align="center">

![logo](https://avatars.githubusercontent.com/u/42477332?s=96&v=4)

<h1 align="center">ReFRACtor CAE Jupyter Install</h1>

</div>

<pre align="center">Instructions for installing ReFRACtor framework into a CAE Jupyterlab Account</pre>

<!-- Header block for project -->

## Overview

These instructions illustrate how to use the `independent_deploy.sh` script to get a working ReFRACtor environment running under JPL CAE's Jupytertlab.

## Requirements

Ensure that you can log into [CAE Jupyterlab](https://cae-jupyterhub.jpl.nasa.gov/).

## Instructions

### Setup Access to Github

The following steps detail how to connect your Jupyterhub environment to JPL's Github Enterprise to allow downloading of the ReFRACtor source.

#### Log In to Jupyterhub

First set up an SSH key inside your Jupterhub environment if one does not exist already.

Log into [CAE Jupterhub](https://cae-jupyterhub.jpl.nasa.gov/) using your JPL username and password. If a server is not already running then click on *Start Jupyter*.

Next launch a new terminal. You can either use the menu from the top by clicking *File -> New -> Terminal* or by clicking on the Terminal icon from the *Launcher* tab. 

#### Check for Existing Key

Confirm that a key does not already exist with the following command:

	jovyan$ ls ~/.ssh/id_rsa.pub 
	ls: cannot access '/home/jovyan/.ssh/id_rsa.pub': No such file or directory
	
If the file does not exists, continue to the next step, if not then skip the next of generating a new key.

#### Generate a New Key

Generate an ssh key from the command line. Use all the default options:

	jovyan$ ssh-keygen 
	Generating public/private rsa key pair.
	Enter file in which to save the key (/home/jovyan/.ssh/id_rsa):
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /home/jovyan/.ssh/id_rsa
	Your public key has been saved in /home/jovyan/.ssh/id_rsa.pub
	The key fingerprint is:
	SHA256:6OQslpjkyPvgOnzh7D5GB7qkDRXHYN3nY400I79+HWA jovyan@jupyter
	The key's randomart image is:
	+---[RSA 3072]----+
	|  o+ .           |
	| .. + o =        |
	|   o   * =       |
	|  ..   .* E      |
	| .o . o.S+ .     |
	|o* = B  .   .    |
	|==O * +.   . .   |
	|+o+B .  . . .    |
	|o+*+.    .       |
	+----[SHA256]-----+

#### Obtain Public Key Contents

We now need the contents of the `/home/jovyan/.ssh/id_rsa.pub` so we can copy it into the Github interface. Either open the `id_rsa.pub` file using the Jupter file browser or use the terminal to output it:

	jovyan$ cat ~/.ssh/id_rsa.pub
	-----BEGIN OPENSSH PRIVATE KEY-----
	.....
	....
	.....
	-----END OPENSSH PRIVATE KEY-----
	
You will need the values between the `BEGIN` and `END` markers in the above example. Your output will look different, here we have not shown a real key.

#### Add Key to Github Enterprise

In order to add this key to your Github Enterprise account, first navgate to the [Github SSH keys](https://github.jpl.nasa.gov/settings/keys) page. Click on the green *New SSH Key* button and populate the *Key* text box with the value you copied from `id_rsa.pub` inside Jupyterhub. For title put a value to remind you where this key came from, such as *CAE Jupyterhub*. When finished click the green *Add SSH key* button. You will need to reenter your JPL password to confirm. Your Jupyterhub environment now has the ability to access your Github account.

### Initialize Conda under Jupyterhub

Go back to CAE Jupyterhub. Open a new terminal unless you have an existing terminal tab open. Run the following two commands:

	conda init
	mamba init
	
Example output is shown below:

	jovyan$ conda init
	no change     /opt/conda/condabin/conda
	no change     /opt/conda/bin/conda
	no change     /opt/conda/bin/conda-env
	no change     /opt/conda/bin/activate
	no change     /opt/conda/bin/deactivate
	no change     /opt/conda/etc/profile.d/conda.sh
	no change     /opt/conda/etc/fish/conf.d/conda.fish
	no change     /opt/conda/shell/condabin/Conda.psm1
	no change     /opt/conda/shell/condabin/conda-hook.ps1
	no change     /opt/conda/lib/python3.9/site-packages/xontrib/conda.xsh
	no change     /opt/conda/etc/profile.d/conda.csh
	modified      /home/jovyan/.bashrc
	
	==> For changes to take effect, close and re-open your current shell. <==
	
	jovyan$ mamba init
	
	                  __    __    __    __
	                 /  \  /  \  /  \  /  \
	                /    \/    \/    \/    \
	███████████████/  /██/  /██/  /██/  /████████████████████████
	              /  / \   / \   / \   / \  \____
	             /  /   \_/   \_/   \_/   \    o \__,
	            / _/                       \_____/  `
	            |/
	        ███╗   ███╗ █████╗ ███╗   ███╗██████╗  █████╗
	        ████╗ ████║██╔══██╗████╗ ████║██╔══██╗██╔══██╗
	        ██╔████╔██║███████║██╔████╔██║██████╔╝███████║
	        ██║╚██╔╝██║██╔══██║██║╚██╔╝██║██╔══██╗██╔══██║
	        ██║ ╚═╝ ██║██║  ██║██║ ╚═╝ ██║██████╔╝██║  ██║
	        ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝ ╚═╝  ╚═╝
	
	        mamba (0.19.1) supported by @QuantStack
	
	        GitHub:  https://github.com/mamba-org/mamba
	        Twitter: https://twitter.com/QuantStack
	
	█████████████████████████████████████████████████████████████
	
	no change     /opt/conda/condabin/conda
	no change     /opt/conda/bin/conda
	no change     /opt/conda/bin/conda-env
	no change     /opt/conda/bin/activate
	no change     /opt/conda/bin/deactivate
	no change     /opt/conda/etc/profile.d/conda.sh
	no change     /opt/conda/etc/fish/conf.d/conda.fish
	no change     /opt/conda/shell/condabin/Conda.psm1
	no change     /opt/conda/shell/condabin/conda-hook.ps1
	no change     /opt/conda/lib/python3.9/site-packages/xontrib/conda.xsh
	no change     /opt/conda/etc/profile.d/conda.csh
	no change     /home/jovyan/.bashrc
	No action taken.
	Added mamba to /home/jovyan/.bashrc

	==> For changes to take effect, close and re-open your current shell. <==

Note that both commands should report that they have changed the `.bashrc` file in your home directory. You will need to restart your Jupyterhub server for these changes to take effect. From the Jupter menu click *File -> Hub Control Panel*. On the next screen click the red *Stop My Server* button. When that has finished click the blue *Start My Server* button. Click the red *Start Jupyter* button.

### Install ReFRACtor

Open a new terminal under Jupyter. Run the following commands to run the ReFRACtor installation script:

	mkdir refractor
	cd refractor
	git clone git@github.jpl.nasa.gov:refractor/build_supplement.git
	cd build_supplement
	./independent_deploy.sh $HOME/refractor $HOME/my-conda-envs/refractor |& tee refractor_deploy.log
	
Truncated example output is shown below:

	jovyan$ mkdir refractor
	jovyan$ cd refractor
	jovyan$ git clone git@github.jpl.nasa.gov:refractor/build_supplement.git
	Cloning into 'build_supplement'...
	remote: Enumerating objects: 132, done.
	remote: Counting objects: 100% (24/24), done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 132 (delta 11), reused 22 (delta 9), pack-reused 108
	Receiving objects: 100% (132/132), 74.53 KiB | 641.00 KiB/s, done.
	Resolving deltas: 100% (44/44), done.
	jovyan$ cd build_supplement
	jovyan$ ./independent_deploy.sh $HOME/refractor $HOME/my-conda-envs/refractor |& tee refractor_deploy.log
	Detected mamba installation, using it for conda calls
	Initializing Conda environment at: /home/jovyan/my-conda-envs/refractor
	...
	Activating conda environment: /home/jovyan/my-conda-envs/refractor
	Updated Git hooks.
	Git LFS initialized.
	~/refractor/source ~/refractor/build_supplement
	Cloning framework
	Cloning into 'framework'...
	...
	~/refractor/build_supplement

Now wait for a long time. Please keep the browser window open throughout. If errors do occur, the `refractor_deploy.log` file generated in the `build_supplicant` directory should be sent to the ReFRACtor team for debugging.

### Using ReFRACtor

When ReFRACtor has been successfully installed you will now have a Jupyter kernel option named *Python [refractor]*. Select this kernel from under the *Notebook* group in the *Launcher* tab. In a new or existing notebook, select this kernel in the upper right part of the window where you see the word *Python* with a circle to its right.

### Testing

Start a new notebook using the *Python [refractor]* kernel. Add the following into a cell and then execute the cell:

	from refractor import framework
	
If you do not see an error message then ReFRACtor has been successfully installed.
