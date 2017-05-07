Ready Thing
-----------
Ready Thing is a tool to create "productivity suites" with user-friendly administration for websites, emails, file sharing and collaboration.

Created for AWS EC2 Amazon Linux

+ Administration: Ajenti V
+ Web: NGINX or Apache2
+ Mail: RainLoop
+ Filesharing & Collaboration: NextCloud
+ 99.999999999% durability with Amazon S3

## What this code does
+ Create S3 Bucket Label
+ Setup IAM Stuff
  + Roles, Policies & Instance Profile for EC2 to communicate with S3
+ Create EC2 Instance
  + Generate User Data
  +

### To do
+ Create initialization routine for fresh AWS account
+ Un-hardcode stuff. Variables/input for AWS subnets and security groups
+ Add checks and get rid of weird workarounds (eg sleeps)
+ LetsEncrypt SSL w/ NGINX
+ Monitoring
+ Mail with SES
 + [Integrate SES with sendmail]( http://docs.aws.amazon.com/ses/latest/DeveloperGuide/sendmail.html) OR
 + [Integrate Exim with SES](http://docs.aws.amazon.com/ses/latest/DeveloperGuide/exim.html)

### Resources used
- [Markdown Cheat Sheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
- [EC2 Best Practices](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-best-practices.html)
- [Writing IAM Policies to grant specific folder access on Amazon S3 buckets](https://aws.amazon.com/blogs/security/writing-iam-policies-grant-access-to-user-specific-folders-in-an-amazon-s3-bucket/)
- [IAM Roles for EC2](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html)
