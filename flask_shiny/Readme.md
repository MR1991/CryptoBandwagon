---
title: "Explanation Flask & Shiny on 1 VM"
author: "Maurice Richard"
output: html_document
---
### R shiny server setup
Follow this guide to spin up a virtual machine and get R shiny server running.  
https://deanattali.com/2015/05/09/setup-rstudio-shiny-server-digital-ocean/

After you are done, most relevant location is:  
```cd /srv/shiny-server/```

In this folder you will have:
  
* index.html -> main page aka www.url.com  
* folders, e.g. /srv/shiny-server/resume/index.html will display www.url.com/resume


### Nginx setup

During the shiny server tutorial you will have set up nginx.
Relevant file:

```sudo nano /etc/nginx/sites-available/default```

It will look something like this:

```
server {                                                                                            
    listen 80 default_server;                                                                      
    listen [::]:80 default_server;                                                                  
    server_name _;                                                                                  
                                                                                                    
    access_log  /var/log/nginx/access.log;                                                          
    error_log  /var/log/nginx/error.log;                                                            
                                                                                                    
    root /var/www/html;                                                                             
                                                                                                    
    index index.html index.htm index.nginx-debian.html;                                            
                                                                                                    
    location /rstudio/ {                                                                            
      proxy_pass http://127.0.0.1:8787/;                                                            
      proxy_http_version 1.1;                                                                       
      proxy_set_header Upgrade $http_upgrade;                                                       
      proxy_set_header Connection "upgrade";                                                        
    }                                                                                               

    location /flask/ {
      root /home/mauricha/myproject;                                           
      include uwsgi_params;                                                   
      uwsgi_pass unix:/home/mauricha/myproject/myproject.sock;                 
    }

 # 3838 is the shiny server port    
    location / {                                
      proxy_pass http://127.0.0.1:3838/;        
    }                                          
}                                               
              
```    


After editing run:
```sudo service myproject restart```
This updates the sites-enabled file.

Then run next line (needed?):
```sudo service nginx restart```

Nginx redirects /Shiny to port 3838 
Nginx redirects /rstudio to port 8787






### Flask setup

Relevant locations:

``` cd /home/mauricha/myproject ```

* myprojectenv  
* myproject.py 

```
from flask import Flask
app = Flask(__name__)

@app.route("/hello")
def hello():
    return "<h1 style='color:blue'>Hello There!</h1>"

if __name__ == "__main__":
    app.run(host='0.0.0.0')
```

Here, URL ‘/hello’ rule is bound to the hello_world() function. As a result, if a user visits http://localhost:5000/hello URL, the output of the hello_world() function will be rendered in the browser. Remember that nginx links the real URL to port 5000 so a nginx setting like:

```
    location /flask/ {
       proxy_pass  http://127.0.0.1:5000;
    }
    
```
will result in url.com/flask/hello being the URL a user has to go to.

To edit:   
```   
sudo nano myproject.py  
sudo systemctl stop myproject  
sudo systemctl start myproject  
```

* myproject.ini  


```
[uwsgi]
module = wsgi:app

master = true
processes = 5

socket = myproject.sock
chmod-socket = 666
vacuum = true

die-on-term = true
```

* wsgi.py  

```
from myproject import app

if __name__ == "__main__":
  application.run()
```

* myproject.sock  
Created by ini. 




Service to start uWSGI automatically:  
https://www.digitalocean.com/community/tutorials/how-to-serve-flask-applications-with-uswgi-and-nginx-on-ubuntu-18-04

```sudo nano /etc/systemd/system/myproject.service```

```
  [Unit]                                                                        
  Description=Gunicorn instance to serve myproject                              
  After=network.target                                                          
                                                                                
  [Service]                                                                     
  User=mauricha                                                                 
  Group=www-data                                                                
  WorkingDirectory=/home/mauricha/myproject/                                    
  Environment="PATH=/home/mauricha/myproject/myprojectenv/bin"                  
  ExecStart=/home/mauricha/myproject/myprojectenv/bin/uwsgi --ini myproject.ini 
                                                                                
  [Install]                                                                     
  WantedBy=multi-user.target         
```

We can now start the uWSGI service we created and enable it so that it starts at boot:
sudo systemctl start myproject
sudo systemctl enable myproject

Let's check the status:
sudo systemctl status myproject



● myproject.service - uWSGI instance to serve myproject
   Loaded: loaded (/etc/systemd/system/myproject.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2018-07-13 14:28:39 UTC; 46s ago
 Main PID: 30360 (uwsgi)
    Tasks: 6 (limit: 1153)
   CGroup: /system.slice/myproject.service
           ├─30360 /home/sammy/myproject/myprojectenv/bin/uwsgi --ini myproject.ini
           ├─30378 /home/sammy/myproject/myprojectenv/bin/uwsgi --ini myproject.ini
           ├─30379 /home/sammy/myproject/myprojectenv/bin/uwsgi --ini myproject.ini
           ├─30380 /home/sammy/myproject/myprojectenv/bin/uwsgi --ini myproject.ini
           ├─30381 /home/sammy/myproject/myprojectenv/bin/uwsgi --ini myproject.ini
           └─30382 /home/sammy/myproject/myprojectenv/bin/uwsgi --ini myproject.ini
