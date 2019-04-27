(aws ecr get-login --no-include-email --region ap-northeast-1)
sudo docker build -t scmnext/frontend frontend
sudo docker tag scmnext/frontend:latest 368865255203.dkr.ecr.ap-northeast-1.amazonaws.com/scmnext/frontend:latest
sudo docker push 368865255203.dkr.ecr.ap-northeast-1.amazonaws.com/scmnext/frontend:latest
sudo docker build -t scmnext/backend backend
sudo docker tag scmnext/backend:latest 368865255203.dkr.ecr.ap-northeast-1.amazonaws.com/scmnext/backend:latest
sudo docker push 368865255203.dkr.ecr.ap-northeast-1.amazonaws.com/scmnext/backend:latest
