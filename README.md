# Shared Storage Sample Application

## Setup

Create Rails 5.2 `credentials.yml.enc` and `master.key` files:
```bash
bin/rails credentials:edit
# Make sure that a "secret_key_base: xxx" entry exists
# (generate a secret with "bin/rails secret")
```
To make running this example easier, a `credentials.yml.enc` and `master.key`
have already been included.
While checking `credentials.yml.env` into git is ok,
**do never check in your `master.key` file!**
Anyone with access to your repository will be able to decrypt your credentials.
Read more about [Rails Encrypted Credentials](https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2).

## Deployment on Engine Yard

1. Create a new Rails 5 application with this repository.
2. Create and boot an environment for the application
    * Stack: `stable-v5 3.0`
    * Rails Environment: `production`
    * Application Server Stack: `Puma`
    * Database Stack: `PostgreSQL 9.6.x`
    * Boot a staging configuration (this boots two application instances, which shows the necessity of a shared file system)
3. While the environment is booting, create a shared file system:
    * Go to "Shared File System" in "More Options"
    * Click on "Create".
4. When the environment booted, log in to your application master instance:
    * Make sure that the shared file system has been mounted on `/efs` (run `df`)
    * If not, run Apply and check again.
5. Copy the local `master.key` file 
   (for the sake of this example you can use the one in this repo) to `/efs/secrets/master.key`
   (create the directory if it doesn't exist).
6. Deploy the application (run DB migrations)
7. On the application master instance, setup the spina installation
   `bin/rails g spina:install`

You can now open the application in the browser, and log in at `/admin`
with the credentials you created in step 7.
Edit the Homepage and upload an image.
You should see some files created in `/efs/shared`.
Every app instance will have access to the uploaded image on the shared file system.

## How it works

### Active Storage Configuration

Engine Yard environments with a Shared File System have a nfs mount at `/efs`.
In this sample we configure an Active Storage service (`ey_shared_fs`) of type `Disk` in [storage.yml](./config/storage.yml).
In the [production environment config](./config/environments/production.rb) we set
`config.active_storage.service = :ey_shared_fs` to use the shared file system.

### Rails Encrypted Credentials

Read more about that in this great blog post: [https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2](https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2).

Here we place the `master.key` file on the shared file system and 
create a symlink to it in a deploy hook ([before_compile_assets](./deploy/before_compile_assets.rb)).

### Misc

Do check the commit history of this sample repository, especially:
* https://github.com/engineyard/shared-fs-sample/commit/09edda37f978f10a1f4cc05db96fbdeb3a965a66
* https://github.com/engineyard/shared-fs-sample/commit/90f96dcd88431dcda5318f2556c4ba9088455c6d
