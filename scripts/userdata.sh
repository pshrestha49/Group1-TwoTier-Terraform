#!/bin/bash

yum update -y || true

yum install -y httpd

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

<h2>Pratham Shrestha</h2>

<img src="cat.jpg" width="500">

</body>
</html>
EOF