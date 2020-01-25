# Setup
## AWS

**IAM**
IAM > ユーザー > ユーザーを追加
ポリシー
- AmazonS3FullAccess
- AmazonTranscribeFullAccess

環境変数

```
AWS_REGION
AWS_ACCESS_KEY_ID
AWS_REGION
```

**S3**
S3 Bucket を作成
アクセス権限
- バケットポリシーを公開
- CORS を有効

環境変数
```
S3_BUCKET
```

## Heroku
```
# set .env
bundle install
ruby app.rb


git push heroku master
heroku config:set ~~
```

## License
   Copyright 2020 Kiminari Homma

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

