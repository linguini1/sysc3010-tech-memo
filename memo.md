# Interfacing the Raspberry Pi 4 with Buzzers Using Python

Buzzers are both very simple and very useful components for building circuits. They can provide auditory feedback in
circuits that may not always be visible, play music and alert users of events.

The buzzers we will be focusing on are piezoelectric buzzers, called piezo buzzers for short. They are simple electronic
components with two terminals: voltage and ground. This makes them very simple to integrate with a
micro-controller/digital device (in our case, the Raspberry Pi 4).

## Table of Contents

- [Types of Buzzers](#types-of-buzzers)
  - [Passive](#passive)
  - [Active](#active)
- [What Kind of Buzzer do I Have](#what-kind-of-buzzer-do-i-have)
  - [Identifying Positive and Negative Terminals](#identifying-positive-and-negative-terminals)
    - [Positive Marker in Shield](#positive-marker-in-shield)
    - [Different Terminal Lengths](#different-terminal-lengths)
  - [Test Circuit](#test-circuit)
- [Interfacing with the Pi](#interfacing-with-the-pi)
  - [Active Buzzer Controller](#active-buzzer-controller)
  - [Passive Buzzer Controller](#passive-buzzer-controller)
- [References](#references)

## Types of Buzzers

There are two main types of piezo buzzers: passive and active. One thing to keep in mind is that both buzzers will
exhibit a louder volume when connected to _higher voltage_. Make sure, however, that you keep the supply voltage within
the limit that your buzzer is rated for.

### Passive

Passive buzzers require a changing signal in order to produce noise. They are called "passive" because they don't do
anything on their own with just a DC (direct current) signal.

The type of signal usually provided to a buzzer is a rapidly pulsing signal, called a PWM or pulse-width modulated
signal. The signal itself looks like the image below:

<figure>
    <img src="https://github.com/linguini1/sysc3010-tech-memo/blob/main/pwm.png">
    <figcaption align="center">A sample PWM signal and its characteristics. [1]</figcaption>
</figure>

With a passive buzzer, it's possible to control the frequency or tone of the produced sound by changing the frequency of
the PWM signal. Thankfully, Python will abstract away those details for us and provide a simple interface for selecting
tones.

### Active

Active buzzers are buzzers that produce noise with just a constant DC signal. You can connect an active buzzer directly
to a battery and it will produce noise. You can also control this buzzer with a PWM signal, but a DC signal is all you
need.

## What Kind of Buzzer do I Have

In order to control your buzzer with the Raspberry Pi, you should first determine which type of buzzer
you have. If you aren't sure which type of buzzer you've purchased, you can perform a simple test.

### Identifying Positive and Negative Terminals

The indication of positive and negative terminals of piezo buzzers is manufacturer dependent. The most common types are
as follows:

#### Positive Marker in Shield

Some piezo buzzers have a small marking on their shield with a "+" sign, indicating which terminal is the positive
terminal. The symbol is directly over the positive lead.

<figure>
    <img src="https://github.com/linguini1/sysc3010-tech-memo/blob/main/shield-marking.jpg">
    <figcaption align="center">A piezo buzzer with a marking on its casing indicating the positive terminal.</figcaption>
</figure>

#### Different Terminal Lengths

Similar to LEDs, some piezo buzzers will use different lead lengths to indicate the polarity of the terminals. As is
convention, the **shorter lead is the negative terminal** (ground), and the **longer lead is the positive terminal**
(supply voltage).

<figure>
    <img src="https://github.com/linguini1/sysc3010-tech-memo/blob/main/lead-lengths.jpg">
    <figcaption align="center">A piezo buzzer with differing lead lengths for determining polarity.</figcaption>
</figure>

### Test Circuit

<figure>
    <img src="https://www.raspberrypi.com/documentation/computers/images/GPIO-Pinout-Diagram-2.png">
    <figcaption align="center">The Raspberry Pi 4 pinout diagram. [4]</figcaption>
</figure>

Using the ground connection on the Raspberry Pi, connect the negative terminal of the buzzer to ground using a wire onto
your breadboard. Then, using one of the Raspberry Pi's 3V output pins (see the pinout diagram), connect the positive
terminal of the buzzer to 3V. If the buzzer produces noise, it is an active buzzer. If not, it is a passive buzzer and
requires a changing signal.

<!--- TODO: add fritzing schematic of test circuit --->

<!--- TODO: add a picture of the test circuit --->

## Interfacing with the Pi

Now that you've determined which type of piezo buzzer you have and you've tried hooking it up to a circuit, interfacing
with a Pi isn't much more difficult!

You will want to modify the test circuit so that the buzzer is connected to a GPIO pin instead of the 3V pin. Pin 22 has
been chosen for this demo.

<!--- TODO: add fritzing schematic of demo circuit --->

<!--- TODO: add a picture of the demo circuit --->

In your Raspberry Pi's console window/terminal, open the directory where you want to write your test code. Use the
following commands to create a virtual environment with the required dependencies for development:

```console
python3 -m venv venv
source venv/bin/activate
pip install gpiozero
```

Once you've finished writing your script (outlined in the next sections), you'll be able to execute it using the
following command.

```console
python3 <your_script_name.py>
```

### Active Buzzer Controller

The active buzzer controller is very akin to a controller for toggling an LED, as our active buzzer can be either on
(producing noise) or off.

The following code is all that's required for interfacing with the active buzzer. You can replace `22` with your
selected GPIO pin in the `GPIO_PIN` constant.

```python
from gpiozero import Buzzer
import time

GPIO_PIN: int = 22  # The GPIO pin the buzzer is connected to (22 for this demo)

buzzer = Buzzer(GPIO_PIN) # Instantiate the buzzer controller

# In an infinite loop, turn the buzzer on and off in 1 second intervals
while True:
    buzzer.on()
    time.sleep(1)
    buzzer.off()
    time.sleep(1)
```

As long as you have the `gpiozero` module installed, you can run this Python code and listen to your active buzzer turn
on and off in a loop! Make sure to kill the program before your ears start ringing :)

### Passive Buzzer Controller

The passive buzzer is a little more interesting because we have control over the tone the buzzer produces. Just the like
the active buzzer, the passive buzzer has two states: playing and stopped (on and off). However, when on, the buzzer can
play several different tones. The `gpiozero` module has convenient tools for selecting tone as well.

```python
from gpiozero import TonalBuzzer
from gpiozero.tones import Tone
import time

GPIO_PIN: int = 22  # The GPIO pin the buzzer is connected to (22 for this demo)

buzzer = TonalBuzzer(GPIO_PIN) # Instantiate the buzzer controller

# Create a couple of tones to play
B_FLAT: Tone = Tone.from_frequency(466.164)
A_4: Tone = Tone("A4")

# In an infinite loop, turn the buzzer on (playing a B flat) and off in 1 second intervals
while True:
    buzzer.play(B_FLAT) # You can change the tone to something else if you want
    time.sleep(1)
    buzzer.stop()
    time.sleep(1)
```

The program is very similar to the active buzzer, but when we turn our buzzer on we use the `.play(tone)` method to play
a specific tone. In this demo I used B flat, and also declared `A_4` to be a concert A note if I wanted to change the
note later.

There are several ways to select tones in `gpiozero`, which you can find documented [here][gpiozero-tones]. \[2\] Some
of the methods include:

- From a frequency in Hz (e.g. 466.164)
- From a string representing the note (e.g. "A4")
- From a midi note (e.g. 69 for A4)

A useful resource when defining tones for more musical applications is [this chart of notes and their
frequencies][note-freqs]. \[3\]

## References

\[1\] Mohamed, A. M. Elmahalawy, and H. M. Harb, "Developing the pulse width modulation tool (PWMT) for two timer
mechanism technique in microcontrollers," Dec. 2013, doi: https://doi.org/10.1109/jec-ecc.2013.6766403.

\[2\] "gpiozero.tones — gpiozero 2.0.1 Documentation," gpiozero.readthedocs.io.
https://gpiozero.readthedocs.io/en/stable/_modules/gpiozero/tones.html (accessed Mar. 18, 2024).

\[3\] R. M. Mottola, "Liutaio Mottola Lutherie Information Website," Liutaio Mottola Lutherie Information Website,
Jan. 09, 2020. https://www.liutaiomottola.com/formulae/freqtab.htm

\[4\] "Raspberry Pi Documentation - Raspberry Pi Hardware," www.raspberrypi.com.
https://www.raspberrypi.com/documentation/computers/raspberry-pi.html

<!--- Links --->

[pwm-wave]: https://www.researchgate.net/profile/Ahmed_Elmahalawy/publication/271437313/figure/fig4/AS:668441367306246@1536380249520/PWM-signal-with-its-two-basic-time-periods.png
[gpiozero-tones]: https://gpiozero.readthedocs.io/en/stable/_modules/gpiozero/tones.html
[note-freqs]: https://www.liutaiomottola.com/formulae/freqtab.htm
[rpi-pinout]: https://www.raspberrypi.com/documentation/computers/images/GPIO-Pinout-Diagram-2.png
