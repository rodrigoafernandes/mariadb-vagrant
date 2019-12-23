exec { "update-upgrade-system":
  command => "/usr/bin/apt-get update && /usr/bin/apt-get upgrade -y"
}

exec { "install-tools":
  command => "/usr/bin/apt-get install -y apt-transport-https bash-completion curl jq",
  unless => "/bin/ls /usr/bin/ | /bin/grep docker",
  require => Exec["update-upgrade-system"]
}

exec { "install-docker":
  command => "/usr/bin/curl -fsSL https://get.docker.com/ | bash",
  timeout => 1800,
  unless => "/bin/ls /usr/bin/ | /bin/grep docker",
  require => Exec["install-tools"]
}

exec { "add-docker-to-user":
  command => "/usr/sbin/usermod -aG docker vagrant",
  unless => "/usr/bin/groups vagrant | /bin/grep docker",
  require => Exec["install-docker"]
}

exec { "download-docker-compose":
  command => "/usr/bin/curl -L \"https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
  unless => "/bin/ls /usr/local/bin/ | /bin/grep docker-compose",
  require => Exec["add-docker-to-user"]
}

exec { "executable-docker-compose":
  command => "/bin/chmod +x /usr/local/bin/docker-compose",
  unless => "/bin/ls -ls /usr/local/bin/ | /bin/grep -E \"[d\\-](([rw\\-]{2})x){1,3}\"",
  require => Exec["download-docker-compose"]
}

exec { "run-mariadb":
  command => "/usr/bin/docker container run -d --name mariadb-pedidos --restart always -p 3306:3306 -e MYSQL_ROOT_PASSWORD=admin123 -e MYSQL_DATABASE=DBPDDEV01 -e MYSQL_USER=SVC_PED -e MYSQL_PASSWORD=gerenciadorsvcped2019 mariadb",
  unless => "/usr/bin/docker container ps | /bin/grep mariadb-pedidos",
  timeout => 1800,
  require => Exec["executable-docker-compose"]
}
