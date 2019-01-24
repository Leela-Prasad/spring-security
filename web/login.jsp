<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
   <head>
   	<title>Login</title>
   	<link href="<c:url value="/styles.css"/>" rel="Stylesheet" type="text/css"/>   
   </head>

   <body>
	  <jsp:include page="/header.jsp"/>

	  <div id="addBook">
	  
	  	  <c:url value="/performLogin" var="loginUrl"/>
	  
		  <form action="${loginUrl}" method="post">
		  		  		
		  	<label>Username:</label> <input type="text" name="vppUsername" value=""/>
		  	<label>Password:</label> <input type="password" name="vppPassword"/>
		   
	        <input type="submit" value="Login"/>
	      </form>		   	  
      </div>
            
      <jsp:include page="/footer.jsp"/>
   </body>
</html>
