<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="todaysDate" value="<%= new java.util.Date() %>"/>

<h1>JR <span>Hartley</span> <small>booksellers since 1923</small></h1>

<div id="links">
	<ul>
		<li><a href='viewAllBooks.do'>All Books</a></li>
		<li><a href='<c:url value="viewCart.do"/>'>Your Shopping Cart</a></li>
		<li><a href='findByAuthor.jsp'>Find By Author</a></li>
		<li><a href='addNewBook.do'>Add a New Book</a></li>
		<li><a href='<c:url value="logout"/>'>Logout</a></li>  <!--  In spring by default /logout url is defined for logout we can tweak this
																	logout tag in the configuration -->
	</ul>
</div>