with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

with Measures; use Measures;
with AccountManagementSystem;

-- This procedure demonstrates a simple user of AccountManagementSystem.
procedure Example is
   Wearer : UserID;
   b : UserID;
   c : UserID;
   Location : GPSLocation := (90.0, 0.0); 
   Vitals : BPM := 100;
begin
   AccountManagementSystem.Init;
   Wearer := AccountManagementSystem.CreateUser;
   b := AccountManagementSystem.CreateUser;
   AccountManagementSystem.SetInsurer(b, Wearer);
   c := AccountManagementSystem.ReadInsurer(b);
   Put(UserID'Image(c));
   AccountManagementSystem.ContactEmergency(Wearer, Location, Vitals);
end Example;
