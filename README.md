TDT4242 Shop
================

A running copy of the project can be found at https://tdt4242eshop.azurewebsites.net/.

What's included?
----------------

- [Devise](http://devise.plataformatec.com.br/) for authentication
- [Pundit](https://github.com/varvet/pundit#pundit) for authorization
- [Bootstrap v3](https://getbootstrap.com/docs/3.3/css/) for layout and styles
- [Administrate](https://github.com/thoughtbot/administrate#administrate) as an admin dashboard for database entries
- Sqlite as database
- Embedded Ruby as template engine

Project structure
-----------------
The `app` folder contains the actual application. All other folders fulfill necessary support functions, e.g. 
configuration for deployment.

In the app folder, we have several subfolders:
- `assets` contains all images, stylesheets and JavaScript files that our application uses.
- The `controllers` folder contains one Ruby file per model that our application uses. 
On top of that, there is an `ApplicationController` (for things relevant to the entire application) 
and several controllers for our database admin dashboard `Administrate`.
- The `dashboards`, you find the definition of all `Administrate` dashboards that are shown in the admin area. These 
files are necessary to define the fields that are displayed in a dashboard.
- `Helpers` are used in RoR to accommodate more complex functions that fit neither in a controller nor in a model. 
They help to keep controller and model files concise and tidy.
- We use `mailers` to communicate with users of our application. Emails concerned with user matters (email confirmation 
etc.) are carried out by the `TdtMailer` class. Emails that are specifically concerned with orders, are sent via the 
`StatusMailer`. The `ApplicationMailer` provides a common base class for both of them.
- All models have a Ruby class in the `models` folder. This is where relationships between models and requirements to 
any fields (e.g. price must be numeric) are established and validated.
- The `policies` folder has one file per model. A policy is used by Pundit to determine whether a user is authorized to 
access a certain resource or not.
- `Services` are used during database setup. We establish our three default users (admin, seller, customer) using a 
service each. The services get the pre-defined credentials from so-called secrets.
- The `views` folder contains all Embedded Ruby files that are later converted to HTML files. The subfolder structure 
mostly follows our model structure. The `devise` folder contains views that are specific to authentication with Devise. 
The `layouts` folder holds common views, such as the general application template and the navigation bar.


Running the project
-------------------

Development was done with the following versions:
- Ruby 2.5.0
- Rails 5.1.4

Other versions should work fine, as long as they are not too old (or too recent).


Run `bundle install`.

Run `rails server`.

Run `rake db:setup`.

In case you have run the project before, you may need to run `rake db:migrate` before `rake db:setup`. Your command
line should tell you about this with a message along the lines of "there are migrations outstanding".


The application should now be available at `localhost:3000`.


Default users are:

- user: `administrator@tdt4242.shop`, password: `administrator`
- user: `seller@tdt4242.shop`, password: `seller`
- user: `customer@tdt4242.shop`, password: `customer`
