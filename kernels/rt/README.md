Please append the following content to `/boot/cmdline.txt`
```ini
dwc_otg.fiq_enable=0 dwc_otg.fiq_fsm_enable=0
```

Issue [Freezing with RT-patch (Pi 3)](https://www.raspberrypi.org/forums/viewtopic.php?f=29&t=159170) and see [Raspberry Pi and real-time Linux](https://www.osadl.org/Single-View.111+M5c03315dc57.0.html) for details.
