#!/bin/bash

# Note
echo -e "This is a shell script for preparation before using blender to rendering in Cloud GPU based on Debian and derivative"
echo -e "This configuration based on https://medium.com/@yani/blender-rendering-on-vast-ai-b77a20d1847d"
echo -e "I success rendering a 3D Animation use GPU Rendering with that tutorial in vast.ai\n"
echo -e "2022 - Palguno Wicaksono\n"

# Get Linux distro
echo -e "Check Linux distro\n"
getUname=$(uname -s)
case $getUname in
    Linux* )
        if [[ -e /etc/debian_version ]]; then
        source /etc/os-release
        OS=$ID # debian or ubuntu
        fi
        case $OS in
        "debian" )
            sudo apt install apt-get install -y vim netcat curl libglu1-mesa-dev libxi6 libxrender1 libfontconfig1 libxxf86vm-dev libxfixes-dev libgl1-mesa-glx unxz
            ;;
        "ubuntu" )
            sudo apt install apt-get install -y vim netcat curl libglu1-mesa-dev libxi6 libxrender1 libfontconfig1 libxxf86vm-dev libxfixes-dev libgl1-mesa-glx unxz
            ;;
        esac
        ;;
esac

# Change dir to temp
echo -e "Change directory to tmp\n"
cd /tmp

# Getting blender
echo -e "Getting blender\n"
curl -OL https://ftp.halifax.rwth-aachen.de/blender/release/Blender3.1/blender-3.1.2-linux-x64.tar.xz && unxz blender-3.1.2-linux-x64.tar.xz && tar -xvf blender-3.1.2-linux-x64.tar

# Change dir to blender dir
echo -e "\nChange directory to blender dir"
cd blender-3.1.2-linux-x64

# Make dir media and output
echo -e "Make media and output dir"
mkdir media output

# Add CUDA
echo -e "Make CUDA script"
bash -c "cat >> gpu.py" << EOF
import bpy
scene = bpy.context.scene
scene.cycles.device = 'GPU'
prefs = bpy.context.preferences
prefs.addons['cycles'].preferences.get_devices()
cprefs = prefs.addons['cycles'].preferences
cprefs.compute_device_type = 'CUDA'
for device in cprefs.devices:
    if device.type == 'CUDA':
        device.use = True
EOF

# Finish

echo -e "Configuration finished"
echo -e "Now you can render using this command under blender directory\n"
echo -e "cd /tmp/blender-3.1.2-linux-x64"
echo -e "./blender -b media/yourfile.blend -P gpu.py -s start_frame -e end_frame -E render_engine -o output/ -a"
