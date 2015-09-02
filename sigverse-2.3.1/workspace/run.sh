#!/bin/bash
set -o verbose

sigserver.sh -w ./world.xml # -p 9002
sigkill.sh

