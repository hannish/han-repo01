#!/bin/bash


echo "Enter password:"
stty -echo
read pwd
stty echo
echo "YOur password is" $pwd
