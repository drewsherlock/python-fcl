import os
import sys
import inspect

from setuptools import Extension, setup
import numpy


# get current directory of file in case someone
# called setup.py from elsewhere
cwd = os.path.dirname(os.path.abspath(
    inspect.getfile(inspect.currentframe())))

# load __version__
exec(open(os.path.join(cwd,
                       'fcl/version.py'), 'r').read())
    
platform_supported = False
for prefix in ['darwin', 'linux', 'bsd']:
    if prefix in sys.platform:
        platform_supported = True
        include_dirs = ['/usr/include',
                        '/usr/local/include',
                        '/usr/include/eigen3']
        lib_dirs = ['/usr/lib',
                    '/usr/local/lib']

        extra_compile_args = ["-std=c++11"]
        libraries='/usr/lib/fcl' #,'/usr/lib/octomap'
                #],
        
        if 'CPATH' in os.environ:
            include_dirs += os.environ['CPATH'].split(':')
        if 'LD_LIBRARY_PATH' in os.environ:
            lib_dirs += os.environ['LD_LIBRARY_PATH'].split(':')

        print('include_dirs: ', include_dirs)
        print('lib_dirs: ', lib_dirs)
        
        try:
            # get the numpy include path from numpy
            import numpy
            include_dirs.append(numpy.get_include())
        except:
            pass

        setup(
            name='python-fcl',
            version=__version__,
            description='Python bindings for the Flexible Collision Library',
            long_description='Python bindings for the Flexible Collision Library',
            url='https://github.com/BerkeleyAutomation/python-fcl',
            author='Matthew Matl',
            author_email='mmatl@eecs.berkeley.edu',
            license = "BSD",
            classifiers=[
                'Development Status :: 3 - Alpha',
                'License :: OSI Approved :: BSD License',
                'Operating System :: POSIX :: Linux',
                'Programming Language :: Python :: 2',
                'Programming Language :: Python :: 2.7',
                'Programming Language :: Python :: 3',
                'Programming Language :: Python :: 3.0',
                'Programming Language :: Python :: 3.1',
                'Programming Language :: Python :: 3.2',
                'Programming Language :: Python :: 3.3',
                'Programming Language :: Python :: 3.4',
                'Programming Language :: Python :: 3.5',
                'Programming Language :: Python :: 3.6',
            ],
            keywords='fcl collision distance',
            packages=['fcl'],
            setup_requires=['cython'],
            install_requires=['numpy', 'cython'],
            ext_modules=[Extension(
                "fcl.fcl",
                ["fcl/fcl.pyx"],
                include_dirs = include_dirs,
                library_dirs = lib_dirs,
                libraries = libraries,
                language = "c++",
                extra_compile_args = extra_compile_args,
            )],
            language_level=3,
            compiler="gcc",
        )
        break

if sys.platform == "win32":
    platform_supported = True
    extra_compile_args = [""]
    include_dirs = ['C:\\Program Files\\fcl\\include',
                    '..\\boost_1_72_0',
                   numpy.get_include(),
                    ]
    lib_dirs = ['../fcl/build/lib/Release',
                '../boost_1_72_0/stage/lib',
                '../libccd/build/src/Release']

    #libraries = [
    #            "C:\\Program Files\\libccd\\lib\\ccd.lib",
    #            "C:\\Program Files\\fcl\\lib\\fcl.lib"
    #            ],                

    libraries = ["fcl",
                 "ccd"
                ]
    
    data_files=[('', ['../libccd/build/src/Release/ccd.dll'])]

    setup(
        name='python-fcl',
        version=__version__,
        description='Python bindings for the Flexible Collision Library',
        long_description='Python bindings for the Flexible Collision Library',
        url='https://github.com/BerkeleyAutomation/python-fcl',
        author='Matthew Matl',
        author_email='mmatl@eecs.berkeley.edu',
        license = "BSD",
        classifiers=[
            'Development Status :: 3 - Alpha',
            'License :: OSI Approved :: BSD License',
            'Operating System :: POSIX :: Linux',
            'Programming Language :: Python :: 2',
            'Programming Language :: Python :: 2.7',
            'Programming Language :: Python :: 3',
            'Programming Language :: Python :: 3.0',
            'Programming Language :: Python :: 3.1',
            'Programming Language :: Python :: 3.2',
            'Programming Language :: Python :: 3.3',
            'Programming Language :: Python :: 3.4',
            'Programming Language :: Python :: 3.5',
            'Programming Language :: Python :: 3.6',
        ],
        keywords='fcl collision distance',
        packages=['fcl'],
        setup_requires=['cython'],
        install_requires=['numpy', 'cython'],
        ext_modules=[Extension(
            "fcl.fcl",
            ["fcl/fcl.pyx"],
            include_dirs = include_dirs,
            library_dirs = lib_dirs,
            libraries = libraries,
            language = "c++",
            extra_compile_args = extra_compile_args,
        )],
        language_level=3,
        compiler="msvc",
        data_files=data_files
    )
                
if not platform_supported:
    raise NotImplementedError(sys.platform)


