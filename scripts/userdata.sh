#!/bin/bash

dnf update -y

dnf install httpd -y

systemctl enable httpd
systemctl start httpd

cd /var/www/html

aws s3 cp s3://group1-dev-images/cat.jpg .

cat <<EOF > index.html
<html>
<head>
<title>ACS730 Final Project</title>
</head>
<body>

<h1>Aaron King</h1>

<h2>ACS730 Final Project</h2>

<img src="cat.jpg" width="500">

</body>
</html>
EOF