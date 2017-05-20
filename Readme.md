Ready Thing
-----------
Ready Thing is a simple shell script to create "productivity suites" with user-friendly administration for websites, emails, file sharing and collaboration.

Created for AWS EC2 Amazon Linux. Documentation is quite rough, sorry! I'm happy to provide any support possible.

+ Administration: Ajenti V
+ Web: NGINX or Apache2
+ Mail: RainLoop
+ Filesharing & Collaboration: NextCloud
+ 99.999999999% durability with Amazon S3

## What this script does
+ Create S3 Bucket Label
+ Setup IAM Stuff
  + Roles, Policies & Instance Profile for EC2 to communicate with S3
+ Create EC2 Instance
  + Generate User Data (Initialization script)
    + Install [Ajenti](http://ajenti.org/) (v1 for now - maybe v2 in future)
    + Install [S3fs](https://github.com/s3fs-fuse/s3fs-fuse) and mount
    + Install MariaDB
    + Install PHP7 (sort of supported by Ajenti with hax)
    + Install [NextCloud](https://nextcloud.com/) (file sharing and collaboration)
    + Install [RainLoop](https://www.rainloop.net/) (mail)
    + More to come...

### To do
+ Create initialization routine for fresh AWS account
+ Un-hardcode more stuff
  + Move variables from getopts to "server.conf" with -c GETOPTS to specify
+ Userdata connect to Chef server because:
  + Bash script should be ported to recipes & cookbook
+ Add more checks and get rid of weird workarounds (eg sleeps)
+ LetsEncrypt SSL w/ NGINX
+ Monitoring
+ Mail with SES
 + [Integrate SES with sendmail]( http://docs.aws.amazon.com/ses/latest/DeveloperGuide/sendmail.html) OR
 + [Integrate Exim with SES](http://docs.aws.amazon.com/ses/latest/DeveloperGuide/exim.html)

### Notes / FAQ
+ If using a chef server, it must already be configured


### Resources used
- [Markdown Cheat Sheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
- [Bootstrapping Chef for Autoscaling instances](https://devops.com/bootstrapping-chef-or-whatever-for-autoscaled-ec2-instances/)
- [Chef Client.rb](https://docs.chef.io/config_rb_client.html)
- [EC2 Best Practices](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-best-practices.html)
- [Writing IAM Policies to grant specific folder access on Amazon S3 buckets](https://aws.amazon.com/blogs/security/writing-iam-policies-grant-access-to-user-specific-folders-in-an-amazon-s3-bucket/)
- [IAM Roles for EC2](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html)
