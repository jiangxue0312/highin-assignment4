with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

with Measures; use Measures;
with AccountManagementSystem;

-- This procedure run examples of AccountManagementSystem.
package body FatBatExample is
   procedure Run is
      user_1 : UserID;
      user_2 : UserID;
      user_3 : UserID;
      user_4 : UserID;
      Vitals_1 : BPM := 100;
      Footsteps_1 : Footsteps := 780;
      Location_1 : GPSLocation := (90.0, 80.0);
      foot : Footsteps;

   begin
      AccountManagementSystem.Init;
      --Creating at least one wearer, one friend, and one insurance provider.
      user_1 := AccountManagementSystem.CreateUser;
      user_2 := AccountManagementSystem.CreateUser;
      user_3 := AccountManagementSystem.CreateUser;
      user_4 := AccountManagementSystem.CreateUser;

      --Setting and changing a wearer friend and insurance provider.
      --set user_2 as insurer for user_1
      AccountManagementSystem.SetInsurer(user_1, user_2);
      --set user_3 as friend for user_1
      AccountManagementSystem.SetFriend(user_1, user_3);
      --set user_3 as friend for user_2
      AccountManagementSystem.SetFriend(user_2, user_3);
      --change user_1's insurer to user_4;
      AccountManagementSystem.SetInsurer(user_1, user_4);
      --change user_1's friend to user_4;
      AccountManagementSystem.SetFriend(user_1, user_4);
      -- remove user_2's friend user_3
      AccountManagementSystem.RemoveFriend(user_2);

      -- Updating vitals and footsteps for a wearer.
      AccountManagementSystem.UpdateVitals(user_1,Vitals_1);
      AccountManagementSystem.UpdateFootsteps(user_1,Footsteps_1);


      -- Changing permissions to at least one of the types of data for a wearer.
      AccountManagementSystem.UpdateFootstepsPermissions(user_1,user_3,true);
      AccountManagementSystem.UpdateVitalsPermissions(user_1,user_2,false);
      AccountManagementSystem.UpdateVitalsPermissions(user_1,0,true);

      -- Contacting emergency for a wearer.
      AccountManagementSystem.ContactEmergency(user_1,Location_1,Vitals_1);
      -- user_1 is not a friend of user_4, so can not read the footsteps
      foot := AccountManagementSystem.ReadFootsteps(user_4, user_1);
      put(Footsteps'Image(foot));

   end Run;
end FatBatExample;
