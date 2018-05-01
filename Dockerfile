FROM amazonlinux:latest

ARG S3_BUCKET
ARG AWS_SECRET_KEY
ARG AWS_SECRET_ACCESS_KEY

RUN mkdir -p /opt/app
WORKDIR /opt/app

RUN yum update -y && yum install \
  cpio \
  python27-pip \
  zip \
  
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN ./build_lambda.sh
RUN aws --region us-east-2 s3 cp /opt/app/build/lambda.zip s3://${S3_BUCKET}/lambda.zip
