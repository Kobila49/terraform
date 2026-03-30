locals {
  double_numbers =[ for num in var.numbers_list: num * 2 ]
  even_numbers = [ for num in var.numbers_list: num if num % 2 == 0 ]
}