#!/bin/sh

if [ -n "$DESTDIR" ] ; then
    case $DESTDIR in
        /*) # ok
            ;;
        *)
            /bin/echo "DESTDIR argument must be absolute... "
            /bin/echo "otherwise python's distutils will bork things."
            exit 1
    esac
fi

echo_and_run() { echo "+ $@" ; "$@" ; }

echo_and_run cd "/home/xiao/catkin_ws/src/dr_spaam_ros"

# ensure that Python install destination exists
echo_and_run mkdir -p "$DESTDIR/home/xiao/catkin_ws/install/lib/python2.7/dist-packages"

# Note that PYTHONPATH is pulled from the environment to support installing
# into one location when some dependencies were installed in another
# location, #123.
echo_and_run /usr/bin/env \
    PYTHONPATH="/home/xiao/catkin_ws/install/lib/python2.7/dist-packages:/home/xiao/catkin_ws/build/dr_spaam_ros/lib/python2.7/dist-packages:$PYTHONPATH" \
    CATKIN_BINARY_DIR="/home/xiao/catkin_ws/build/dr_spaam_ros" \
    "/usr/bin/python2" \
    "/home/xiao/catkin_ws/src/dr_spaam_ros/setup.py" \
     \
    build --build-base "/home/xiao/catkin_ws/build/dr_spaam_ros" \
    install \
    --root="${DESTDIR-/}" \
    --install-layout=deb --prefix="/home/xiao/catkin_ws/install" --install-scripts="/home/xiao/catkin_ws/install/bin"
