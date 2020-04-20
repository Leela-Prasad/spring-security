Http Basic: 
To tell our web server to intercept http requests we need to add below lines in web.xml

<filter>
	<filter-name>springSecurityFilterChain</filter-name>
	<filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
</filter>
	
<filter-mapping>
	<filter-name>springSecurityFilterChain</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>


In the spring-security-config.xml we need to write authentication and authorisation parts when http request is intercepted.

<!— Authorization—>
<http>
	<intercept-url pattern="/addNewBook.do" access="hasRole('ROLE_ADMIN')" />
	<http-basic />
</http>
	
<!— Authentication —>
<authentication-manager>
	<authentication-provider>
		<user-service>
			<user name="leela" password="secret" authorities="ROLE_USER,ROLE_ADMIN"/>
			<user name="abc" password="password" authorities="ROLE_USER"/>
		</user-service>
	</authentication-provider>
</authentication-manager>


Form Authentication:
To enable form authentication we need to use below code
<http>
	<intercept-url pattern="/addNewBook.do" access="hasRole('ROLE_ADMIN')" />
	<form-login />
</http>

Below snippet will ask every user for login, and if the user logins then he will have access to all pages as spring security is given for /**, so a normal user will also have access to admin pages. To avoid this we have to mention restrictions first so that spring will know what urls to be restricted.
<http>
	<intercept-url pattern="/**" access="hasRole('ROLE_USER')" />
	<intercept-url pattern="/addNewBook.do" access="hasRole('ROLE_ADMIN')" />
	<form-login />
</http>

Solution:
<http>
	<intercept-url pattern="/addNewBook.do" access="hasRole('ROLE_ADMIN')" />
	<intercept-url pattern="/**" access="hasRole('ROLE_USER')" />
	<form-login />
</http>
Here spring will execute intercept-url in the given order so that spring knows /addNewBook.do should be accessed only by admin role.


Here /** url-pattern will provide security for all pages, if we have a custom login page then that page will also be not accessible by user. This will cause infinite loops error.
To allow all users to access login page 
<intercept-url pattern="/login.jsp" access="permitAll" />


because /** all CSS resources are also protected, so to provide access to all css resources 
<http pattern="/css/**" security="none" />  
<http pattern="/styles.css" security="none" />

Default form authetication login page will have csrf tag which sends the token to identify the user.

<html><head><title>Login Page</title></head><body onload='document.f.username.focus();'>
<h3>Login with Username and Password</h3><form name='f' action='/mywebapp/login' method='POST'>
<table>
	<tr><td>User:</td><td><input type='text' name='username' value=''></td></tr>
	<tr><td>Password:</td><td><input type='password' name='password'/></td></tr>
	<tr><td colspan='2'><input name="submit" type="submit" value="Login"/></td></tr>
	<input name="_csrf" type="hidden" value="dada3e78-c822-4f03-b7f5-b74eef96445e" />
</table>
</form></body></html>

*** But if we configure this login page to some other page then we need to send the csrf tag or we need to disable csrf otherwise we will get 403 - Forbidden 
error Message : Expected CSRF token not found. Has your session expired?

Logout:
we can redirect to a page when we logout happens
<logout logout-success-url="/viewAllBooks.do" />
In this case when logout happens it will redirect to viewAllBooks page

*** By Default /logout endpoint will cause logout.
so in the html page we can use this endpoint to have logout option
<li><a href='<c:url value="logout"/>'>Logout</a></li>  

We can also configure this logout endpoint in 
<logout logout-url=“myCustomLogoutEndpoint”/>





<beans:beans xmlns="http://www.springframework.org/schema/security" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:beans="http://www.springframework.org/schema/beans"   
	 
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans 
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/security 
        http://www.springframework.org/schema/security/spring-security.xsd">
     
    <http pattern="/styles.css" security="none" />
    <http pattern="/css/**" security="none" /> <!-- To allow users to access all css resources -->
       
	<http>
	
		<csrf disabled="true" />
		<intercept-url pattern="/login.jsp" access="permitAll" />
		<intercept-url pattern="/addNewBook.do" access="hasRole('ROLE_ADMIN')" />
		<intercept-url pattern="/**" access="hasRole('ROLE_USER')" />
		<form-login login-processing-url="/performLogin" 
					username-parameter="vppUsername" 
					password-parameter="vppPassword" 
					login-page="/login.jsp" 
					authentication-failure-url="/login.jsp?error"/>		
					
		<logout logout-success-url="/viewAllBooks.do" />			
	</http>
	
	<authentication-manager>
		<authentication-provider>
			<user-service>
				<user name="leela" password="secret" authorities="ROLE_USER,ROLE_ADMIN"/>
				<user name="abc" password="password" authorities="ROLE_USER"/>
			</user-service>
		</authentication-provider>
	</authentication-manager>
</beans:beans>	


If a username and password doesn’t match application can redirect to login page but username will not be refilled
to prefill this we need to write custom handler.
for username and password check spring will execute “UsernamePasswordAuthenticationFilter”
If credentials are correct this filter will handover request to spring controller 
otherwise this filter will handover to AuthenticationFailureHandler
so we have to define a custom handler which implements AuthenticationFailureHandler so that we can do custom logic when authentication fails.

We can get username/password property names from UsernamePasswordAuthenticationFilter
for this we have autowire this filter.

private UsernamePasswordAuthenticationFilter filter;
filter.getUsernameParameter();

JDBC Authentication:
In this we will authenticate against a database, where users, roles are defined in the tables.
Default tables that spring will look for are 
1. Users(username varchar, password varchar, enabled boolean);
2. Authorities(username varchar, authority varchar);

<beans:bean id="derbyDatasource" class="org.apache.commons.dbcp.BasicDataSource">
    <beans:property name="driverClassName" value="org.apache.derby.jdbc.ClientDriver" />
    <beans:property name="url" value="jdbc:derby://localhost/MyDB2" />
</beans:bean>

<authentication-manager>
		<authentication-provider>
			<jdbc-user-service data-source-ref="derbyDatasource" />
		</authentication-provider>
</authentication-manager>


we can also override this default behaviour by providing custom tables, for that we need to define below 2 properties.
1. users-by-username-query
2. authorities-by-username-query

<authentication-manager>
		<authentication-provider>
			<jdbc-user-service data-source-ref="derbyDatasource"  users-by-username-query="select username,password,true from tbl_users where username=?"
authorities-by-username-query="select username,role from tbl_roles where username=?"/>
		</authentication-provider>
</authentication-manager>


Bcrypt:
BCrypt is one of most secure way for encrypting passwords.
if we give a string to bcrypt it will generate a fixed length of encoded string. This is called hashing.
But while storing same passwords in the database will result in 2 different encoded string because bcrypt will add a salt automatically, so to the hacker will have no clue whether 2 users are having same password or not
So no need to maintain salts in the database.
The default salt value is the username in user details class in spring security but we can  specify other properties also if we need to override defaults.
BCrypt will have 10 rounds of hashing by default, we can also increase so that it will take long time to generate the hash.

bcrypthash(password{username});


<beans:bean id="bcryptEncoder" class="org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder"/>

<authentication-manager alias="vppAuthenticator">
	<authentication-provider>
	<!-- This will authenticate users with their bcrypt encoded passwords, so we need to encode with bcrypt before saving to datastore -->
	<!-- <password-encoder hash="bcrypt" />  -->
	<password-encoder ref="bcryptEncoder" />
			
	<jdbc-user-service data-source-ref="derbyDatasource" />
	</authentication-provider>
</authentication-manager>


Why MD5 and SHA2 are not considered as a best solution for encrypting passwords?
Because MD5 and SHA2 are very fast, we can generate 1billion hashes (with a machine having GPU)in couple of hours, so hackers can easily crack the password.
MD5 and SHA2 are designed to run fast with devices having GPU.

Why SHA256 is not considered as a best solution for encrypting passwords?
In SHA256 hashing will not have default salt.
It is possible that in our database we can have same SHA256 value, which gives a clue to the hacker that these users have a same password.
If a system wide salt value is used for SHA256 it will only increase the difficulty for the hacker to crack because lot of possibilities need to be generated if the size of the password increases, but it will generate same SHA256 value for same password.
It is better to use different salt for every user, which is default in spring BCrypt.


$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa

In tis $2a represents it is a hash generated by Bcrypt.
$10 represents 10 rounds are done to to generate hash.
first 22 characters represents salt 
rest of the characters represents password.

If number of rounds increases it will take more time to generate hashes.
so it is difficult for the hacker to generate hashes for longer passwords.


Purpose of salt;
1. make passwords bigger, as a result it will destroy dictionary words and number of hash possibilities will increase.
2. It will help use to generate different different hashes for users having same password.


Why BCrypt
BCrypt is deliberately designed to be slow, and it can be made run much slower by changing the strength(rounds).
BCrypt also contains salt and you don’t need to set it.




SHA256 for user “leela” using system wide salt “:randomsalt”
secret -> |71b69619ea661c81f503807fb73d8b89ea4f670fe1bddae90e0b83b30cc7e31a

SHA256 for user “prasad” using system wide salt “:randomsalt”
secret -> |71b69619ea661c81f503807fb73d8b89ea4f670fe1bddae90e0b83b30cc7e31a


SHA256 for user “leela” using user-property="username"
secret -> |f0c69ce6348f4309b4213262c267bd0f47b9c9af3623c898b01505e0e1e5eda8

SHA256 for user “prasad” using user-property="username"
secret -> |bf4ad70684cba677bef6c8f9bb7110cbf97f5a7b1f14108ca9d2a65ddb04d7c9

BCrypt provides salt inbuilt defaults to username.

Spring Security Tag Libraries:

Spring security has tags to display or hide some functionalities to specific users like
create account for anonymous users
add new books for admin 
logout for authenticated users.

<sec:authorize access="hasRole('ROLE_ADMIN')">
	<li><a href='addNewBook.do'>Add a New Book</a></li>
</sec:authorize>
		
<sec:authorize access="isAuthenticated()">
	<a href=‘<c:url value="logout”/>’>Logout</a>
</sec:authorize>
		
<sec:authorize access="isAnonymous()">  
	<li><a href='createAccount.do'>Create Account</a></li>
</sec:authorize>			

CSRF(Cross Site Request Forgery)
If a website is vulnerable to CSRF and a user of that website has not done the logout
then malicious user can inject http form thorough attractive links so that it will post http form post on the system which may change the state of the system.
To avoid this we have to enable CSRF, so that system will demand a CSRF token which is unique for every login.

To achieve this manually we have to add 
<input type="hidden" name="_csrf" value="1d630d07-7feb-4c1b-acbd-d980d5dfd50c" />
where the token is generated by the server.

spring security will add this token automatically if that is spring form tag 
If it is a normal form then we have to add below line in the form tag.
<sec:csrfInput />



Why alias is used in Authentication Manager to programatically authenticate users.
<http>
	<intercept-url pattern="/login.jsp" access="permitAll" />
	<intercept-url pattern="/createAccount.do" access="permitAll" />
	<intercept-url pattern="/addNewBook.do" access="hasRole('ROLE_ADMIN')" />
	<intercept-url pattern="/**" access="hasRole('ROLE_USER')" />
	<form-login login-processing-url="/performLogin" 
		username-parameter="vppUsername" 
		password-parameter="vppPassword" 
		login-page="/login.jsp" 
		authentication-failure-handler-ref="authFailureHandler"/> 
		<logout logout-success-url="/viewAllBooks.do" />			
	</http>
	
<authentication-manager alias="vppAuthenticator">
	<authentication-provider>
		<password-encoder ref="bcryptEncoder" />
		<jdbc-user-service data-source-ref="derbyDatasource" />
	</authentication-provider>
</authentication-manager>



Here the http tag intercept-url need to talk to authentication manager behind the scenes to know who the user is and the communication to authentication-manager will happen with a default id that is set to authentication-manager, so if we override this id then http tag doesn’t find this authentication-manager and the authentication(login) will fail.

To override this default id we need to tell http tag manually what the id we are interested in using authentication-manager-ref attribute.
<http authentication-manager-ref="vppAuthenticator">
	<intercept-url pattern="/login.jsp" access="permitAll" />
	<intercept-url pattern="/createAccount.do" access="permitAll" />
	<intercept-url pattern="/addNewBook.do" access="hasRole('ROLE_ADMIN')" />
	<intercept-url pattern="/**" access="hasRole('ROLE_USER')" />
	<form-login login-processing-url="/performLogin" 
		username-parameter="vppUsername" 
		password-parameter="vppPassword" 
		login-page="/login.jsp" 
		authentication-failure-handler-ref="authFailureHandler"/> 
		<logout logout-success-url="/viewAllBooks.do" />			
	</http>
	
<authentication-manager id="vppAuthenticator">
	<authentication-provider>
		<password-encoder ref="bcryptEncoder" />
		<jdbc-user-service data-source-ref="derbyDatasource" />
	</authentication-provider>
</authentication-manager>
