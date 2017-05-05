Ready Thing
-----------
Ready Thing is a tool to deploy productivity suites with user-friendly administration for websites, emails, file sharing and collaboration.

Created for AWS EC2 Amazon Linux. High availability for all!

+ Administration: Ajenti V
+ Web: NGINX or Apache2
+ Mail: RainLoop
+ Filesharing & Collaboration: NextCloud
+ 99.999999999% durability with Amazon S3

## To do
+ LetsEncrypt SSL w/ NGINX
+ Decide between [s3fs-fuse](https://github.com/s3fs-fuse/s3fs-fuse) OR [YAS3FS](https://github.com/danilop/yas3fs)
+ Monitoring
+ Mail with SES
 + [Integrate SES with sendmail]( http://docs.aws.amazon.com/ses/latest/DeveloperGuide/sendmail.html) OR
 + [Integrate Exim with SES](http://docs.aws.amazon.com/ses/latest/DeveloperGuide/exim.html)

## What this script does
+ Create S3 Bucket
+ Create EC2 Instance
  + Create & Assign Roles
  + Create Instance Profile (to communicate with S3)

### IAM Instance Profiles
> **Note**
> An instance profile can contain only one IAM role, although a role can be included in multiple instance profiles. This limit of one role per instance cannot be increased.

`--iam-instance-profile (structure)`
   The IAM instance profile.

Shorthand Syntax:
`Arn=string,Name=string`

---

[Markdown Cheat Sheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)

[EC2 Best Practices](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-best-practices.html)

[Writing IAM Policies to grant specific folder access on Amazon S3 buckets](https://aws.amazon.com/blogs/security/writing-iam-policies-grant-access-to-user-specific-folders-in-an-amazon-s3-bucket/)

[IAM Roles for EC2](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html)
