Detector 在ros package里的应用

我把之前dr_spaam文件夹里与detector相关的包都放在catkin_ws/src/dr_spaam_ros/src/dr_spaam_ros包内的dr_spaam_detector包下了

注意确实是文件夹里有init.py在运行python是就已经会被视为package了。而且在package被作为module被其他运行的py文件引入时，这些module旁边才会产生pyc文件。（比如在运行完roslaunch dr_spaam_ros dr_spaam_ros.launch后，那些有包结构的module都新增了pyc文件。）

把dr_spaam_detector放入src之后，为了直接运用这个包而非使用安装在python2.7下的包，把dr_spaam_ros/下的dr_spaam_ros.py里的#from dr_spaam.detector import Detector改为from dr_spaam_detector.detector import Detector。

注意整个引用关系：
在运行roslaunch dr_spaam_ros dr_spaam_ros.launch 时，ROS在catkin_ws里面寻找dr_spaam_ros这个ros package， 运行里面script路径下的node.py
node.py 的作用仅仅是引用了from dr_spaam_ros.dr_spaam_ros import DrSpaamROS，即找到了src下面的dr_spaam_ros这个python包的dr_spaam_ros模块里的class DrSpaamROS()

而dr_spaam_ros模块是引用到之前dr_spaam这个python包里的detector的部分，由于我们已经把detector包的相关内容放进了src/dr_spaam_ros这个包下，而dr_spaam_ros模块与之平级同属一个包，
所以dr_spaam_ros.py里直接from dr_spaam_detector.detector import Detector （直接引用）

（注意，scripts里的脚本如果是直接用python在命令行里运行，如果不是在script文件夹内部，python是找不到文件位置的，把scripts路径加入PYTHON PATH的方法是bashrc里写入
export PYTHONPATH=$PYTHONPATH:<你的要加入的路径1>:<你的要加入的路径2>:等等）
但是当通过rosrun 或者 roslaunch运行python scripts时，由于我们已经把ros工作空间source过了，因此python文件所在的ros package是可以被找到的，而放置于ros package的scripts下的python脚本也无需通过PYTHON PATH而是通过ros package的路径被找到。


ROS package 里的python scripts和modules的安装：
http://docs.ros.org/en/jade/api/catkin/html/howto/format2/installing_python.html
首先明确一点，以包形式构建的python文件放在src下，单独的脚本形式的python文件放在scripts下。

一般一个ros package即使只用python也是需要catkin CmakeList.txt来安装可执行脚本和引入modules以使得他们可以被其他ros package调用

对于单纯的脚本（放在scripts下的那种）：
ROS executables are installed in a per-package directory, not the distributions’s global bin/ directory. They are accessible to rosrun and roslaunch, without cluttering up the shell’s $PATH, and their names only need to be unique within each package. There are only a few core ROS commands like rosrun and roslaunch that install in the global bin/ directory.

Standard ROS practice is to place all executable Python programs in a package subdirectory named nodes/ or scripts/. Their usage is the same, the two names distinguish ROS nodes from other executable Python scripts. To keep the user API clean, executable script names generally do not include a .py suffix. Your CMakeLists.txt should install all the scripts explictly using the special install function catkin_install_python. This will make sure that shebang lines are updated to use the specific Python version used at configure time:

catkin_install_python(PROGRAMS nodes/your_node scripts/another_script
                      DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})
Another good practice is to keep executable scripts very short, placing most of the code in a module which the script imports and then invokes:

#! /usr/bin/env python
import your_package.main
if __name__ == '__main__':
    your_package.main()

对于模块的安装：
Standard ROS practice is to place Python modules under the src/your_package subdirectory, making the top-level module name the same as your package（顶层package包的名字与ros包的名字一致）. Python requires that directory to have an __init__.py file, too.

With rosbuild, it was possible to place Python modules directly within src/. That violated Python setup conventions, and catkin does not allow it. If you need to define a module named your_package, place its code in src/your_package/__init__.py or import its public symbols there.

Catkin installs Python packages using a variant of the standard Python setup.py script. Assuming your modules use the standard ROS layout, it looks like this:

## ! DO NOT MANUALLY INVOKE THIS setup.py, USE CATKIN INSTEAD

from distutils.core import setup
from catkin_pkg.python_setup import generate_distutils_setup

# fetch values from package.xml
setup_args = generate_distutils_setup(
    packages=['your_package'],
    package_dir={'': 'src'})

setup(**setup_args)
This setup.py is only for use with catkin. Remember not to invoke it yourself.

Put that script in the top directory of your package, and add this to your CMakeLists.txt:

catkin_python_setup()
（这两布也是dr_spaam_ros这个ros pacage里做的，即src下的dr_spaam_ros这个python包就是以这个方法作为ROS package的一部分被安装完成的）
