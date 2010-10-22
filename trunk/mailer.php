<?php
if(isset($_POST['submit'])) {
$to = "slagio2002@yahoo.co.in";
$subject = "Adra Adra feedback";
$name_field = $_POST['name'];
$email_field = "noob@matrix.com";
$message = $_POST['message'];
 
$body = "From: $name_field\n E-Mail: $email_field\n Message:\n $message";
 
echo "Data has been submitted to $to! Please refresh(F5) to play the game";
mail($to, $subject, $body);
} else {
echo "blarg! error";
}
?>