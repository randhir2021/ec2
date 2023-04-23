# output "aws_instance_arn" {
#   value = aws_instance.example[*].arn
# }

# output "aws_public_dns" {
#   value = aws_instance.example[*].public_dns
# }

output "instance_detail" {
  value = zipmap(
    aws_instance.example[*].arn,
    aws_instance.example[*].public_dns
  )
}