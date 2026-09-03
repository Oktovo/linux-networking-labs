#!/bin/bash

set -e

sudo ip netns del Client
sudo ip netns del Server
sudo ip netns del Router


