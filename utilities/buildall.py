import glob
import os
import subprocess

def build_project(project_dir):
    os.chdir(project_dir)
    subprocess.run(["alr", "clean"], check=True)    
    subprocess.run(["alr", "build"], check=True)    
    os.chdir("..")
    
projects = glob.glob("*/alire.toml")
projects.sort()
for p in projects:    
    print(p  , end="") 
    print(" in " ,  end="")
    print( os.path.dirname(p) )
    build_project( os.path.dirname(p))