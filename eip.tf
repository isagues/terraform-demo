resource "aws_eip" "natgw_1_eip" {
  vpc = true
}
resource "aws_eip" "natgw_2_eip" {
  vpc = true
}
