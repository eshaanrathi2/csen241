import subprocess
command = ['figlet', 'hello']
result = subprocess.getoutput("figlet hello")
print(result)