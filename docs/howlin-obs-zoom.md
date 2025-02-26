Method 2: Using v4l2loopback (For Audio & Video)

If you need to send both video and audio from OBS to Zoom, you’ll need v4l2loopback for video and pavucontrol for audio.
1. Install v4l2loopback:

yay -S v4l2loopback-dkms v4l2loopback-utils

Load the module:

sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Camera" exclusive_caps=1

2. Run OBS with Virtual Camera Support

Since you're using the Flatpak version, run:

flatpak override --user --env=OBS_VIRTUALCAM_ENABLED=1 com.obsproject.Studio

Then restart OBS and start the virtual camera.
3. Route Audio Using PulseAudio:

    Install pavucontrol if you haven’t:

    sudo pacman -S pavucontrol

    Open pavucontrol, go to the Recording tab.
    Change OBS's audio input to Monitor of Built-in Audio Analog Stereo.
    In OBS, set audio output to Monitor and Output in Advanced Audio Properties.

Final Steps:

    In Zoom Video Settings, select "OBS Virtual Camera".
    In Zoom Audio Settings, select "Monitor of Built-in Audio".

This setup ensures Zoom receives both video and audio from OBS.

Let me know if you need help troubleshooting! 🚀
