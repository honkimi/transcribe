```
# AWS
**IAM**
IAM > ユーザー > ユーザーを追加
ポリシー
- AmazonS3FullAccess
- AmazonTranscribeFullAccess

環境変数
AWS_REGION
AWS_ACCESS_KEY_ID
AWS_REGION

**S3**
S3 Bucket を作成
アクセス権限
- バケットポリシーを公開
- CORS を有効

環境変数
S3_BUCKET

# set .env
bundle install
ruby app.rb


git push heroku master
heroku config:set ~~
```
