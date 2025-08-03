#!/bin/sh

butler push build/web alarabread/eel-birthday-party-simulator:web
butler push build/windows alarabread/eel-birthday-party-simulator:windows
butler push build/linux alarabread/eel-birthday-party-simulator:linux
butler push build/mac/eel-birthday-party-simulator.zip alarabread/eel-birthday-party-simulator:mac

