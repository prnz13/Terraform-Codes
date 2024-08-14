
resource "azuread_user" "userA" {
  user_principal_name = "userA@princepaulsingh713outlook.onmicrosoft.com"
  display_name        = "userA"
  password            = "Secret@123"
}

data "azuread_group" "example" {
  display_name     = "test-grp"
  security_enabled = true
}

resource "azuread_group_member" "example" {
  group_object_id  = data.azuread_group.example.id
  member_object_id = azuread_user.userA.object_id
}
