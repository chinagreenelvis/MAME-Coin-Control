# MAME-Coin-Control

Coin Control allows restrictions for coin inputs in MAME (https://www.mamedev.org). It begins each player who presses the start button with a set amount of coins. After the initial press, the start button will then revert to its normal function. After an interval (set in the INI in minutes), incremental amounts of coins will be added for each player.

It can be toggled using the INI file, by pressing F1, or holding Button 8 on the first controller. Coin Control is started by pressing Joy8 (XBox360: Start). When deactivated, coin inputs are defaulted to Joy10 (XBox360: Right Thumbstick).

MAME must be started using the command line option: -keyboardprovider dinput

All controllers must be connected and turned on before starting the script. MAME's keybindings for "start" and "coin" should all be left to their defaults (Numbers 1-8), including the start buttons for individual player controls.

The included sound files for activation/deactivation notifications were created using the website https://15.ai/
