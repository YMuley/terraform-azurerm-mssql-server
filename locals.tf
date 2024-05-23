locals {
   sql_server = {for sql in var.pass_sql_server_list : sql.name => sql }
}