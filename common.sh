color=\\e[35m
no_color=\\e[0m

systemd_setup() {
    echo -e ${color}Restart ${component} serrvice ${no_color}
    systemctl daemon-reload &>>/tmp/roboshop.log
    systemctl enable ${component} &>>/tmp/roboshop.log
    systemctl restart ${component} &>>/tmp/roboshop.log
    echo Status - $?
}

app_prereq() {
    echo -e ${color}Copy Systemd service file${no_color}
    cp ${component}.service /etc/systemd/system/${component}.service &>>/tmp/roboshop.log
    echo Status - $?

    echo -e ${color}Add roboshop user${no_color}
    useradd roboshop &>>/tmp/roboshop.log
    echo Status - $?

    echo -e ${color}Delete existing app content${no_color}
    rm -rf /app &>>/tmp/roboshop.log
    echo Status - $?

    echo -e ${color}Create app Directory${no_color}
    mkdir /app &>>/tmp/roboshop.log
    echo Status - $?

    echo -e ${color}Create app code${no_color}
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>/tmp/roboshop.log
    echo Status - $?
    cd /app

    echo -e ${color}Extract app code${no_color}
    unzip /tmp/${component}.zip &>>/tmp/roboshop.log
    echo Status - $?
}

nodejs_setup() {
  echo -e ${color}Disable default NodeJs${no_color}
  dnf module disable nodejs -y &>>/tmp/roboshop.log
  echo Status - $?

  echo -e ${color}enable nodejs:20${no_color}
  dnf module enable nodejs:20 -y &>>/tmp/roboshop.log
  echo Status - $?

  echo -e ${color}Install NodeJs${no_color}
  dnf install nodejs -y &>>/tmp/roboshop.log
  echo Status - $?

  app_prereq

  cd /app
  echo -e ${color}Instsll NodeJs dependencies${no_color}
  npm install &>>/tmp/roboshop.log
  echo Status - $?

  systemd_setup
}

python_setu() {
  echo -e ${color}Instsll python${no_color}
  dnf install python3 gcc python3-devel -y &>>/tmp/roboshop.log
  echo Status - $?

  app_prereq

  cd /app

  echo -e ${color}Instsll python dependencies${no_color}
  pip3 install -r requirements.txt

  systemd_setup
}


