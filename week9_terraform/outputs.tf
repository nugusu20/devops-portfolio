output "instance_id" {                       # השם "instance_id" – בחירה שלי, אפשר לשנות
  description = "ID of the EC2 instance"    # טקסט חופשי להסבר
  value       = aws_instance.dev_server.id  # תבנית: resource.name.attribute  | attribute="id" לפי הרגיסטר
}

output "instance_public_ip" {                             # גם השם כאן לבחירתנו
  description = "Public IP address of the EC2 instance"   # תיאור חופשי
  value       = aws_instance.dev_server.public_ip         # attribute="public_ip" כפי שמופיע ברגיסטר
}

