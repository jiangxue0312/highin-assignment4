-- this package contains the main procedures and functions of the system
with Measures; use Measures;
with Emergency;
with Ada.Text_IO;
use Ada.Text_IO;

package body AccountManagementSystem is
-- The user information and permission information
-- are stored in two record separately, 
-- which suits the information hiding principle and system expansibility.
-- The database can be designed using association table mapping model.
-- In this project, assume that one user only have one friend and one insurer

-- the USER record contains main personal information of a user
   type USER is
      record
         UserNO         : UserID;      -- userID
         UserFootsteps  : Footsteps;   -- user footsteps
         Vitals         : BPM;         -- user BPM
         Location       : GPSLocation; -- user location
         EmerVitals     : BPM;         -- stored BPM when contact emergency
         EmerLocation   : GPSLocation; -- stored locaton when contact emergency
         Insurer        : UserID;      -- the insurer id
         Friend         : UserID;      -- the friend id
      end record;
-- the PERMISSION record contains the permission of the wearer   
   type PERMISSION is
      record
         UserOwner      : UserID;    -- the wearer id
         UserRelation   : UserID;    -- friend, insurer or emergency id
         PermiLocation  : Boolean;   -- permission for location
         PermiVitals    : Boolean;   -- permission for BPM
         PermiFootsteps : Boolean;   -- permission for footsteps
      end record;
   
-- UserList stores the userid
   type UserList is array ( 0..MAX_USERID ) of USER;
-- PermissionList(x,y), x is owner user, y is other user such as friend
   type PermissionList is array (0..MAX_USERID,0..MAX_USERID) of PERMISSION;
   
   User_New  : UserID;        -- new user id index
   UserInfo  : UserList;
   PermiInfo : PermissionList;
   
-- initial the system
   procedure Init is
   begin
      -- create Emergency user
      UserInfo(0).UserNO := 0 ;
      User_New := 0;
   end Init;
   
-- create new user and return the user id 
   function CreateUser return UserID is
   begin
      User_New := User_New + 1; -- new userid index
      -- set the user information
      UserInfo(Integer(User_New)).UserNO := User_New ;
      UserInfo(Integer(User_New)).UserFootsteps := 0;
      UserInfo(Integer(User_New)).Location := (0.0,0.0);
      UserInfo(Integer(User_New)).EmerLocation := (0.0,0.0);
      UserInfo(Integer(User_New)).Vitals := -1;
      UserInfo(Integer(User_New)).EmerVitals := -1;
      UserInfo(Integer(User_New)).Insurer := -1;
      UserInfo(Integer(User_New)).Friend := -1;
      -- set permission to read their own data
      PermiInfo(Integer(User_New),Integer(User_New)).PermiLocation :=true;
      PermiInfo(Integer(User_New),Integer(User_New)).PermiVitals := true;
      PermiInfo(Integer(User_New),Integer(User_New)).PermiFootsteps :=true;
      Put("New user ID is ");
      Put_Line(UserID'Image(UserInfo(Integer(User_New)).UserNO));
      return User_New;
   end CreateUser;
   
-- set insurer for the wearer
   procedure SetInsurer(Wearer : in UserID; Insurer : in UserID) is
   begin
      UserInfo(Integer(Wearer)).Insurer := Insurer;
      Put(UserID'Image(Wearer));
      Put(" sets ");
      put(UserID'Image(UserInfo(Integer(Wearer)).Insurer));
      Put_Line(" as insurer. ");
   end SetInsurer;

-- remove the insurer for the wearer
   procedure RemoveInsurer(Wearer : in UserID) is
   begin
      UserInfo(Integer(Wearer)).Insurer := -1;
      Put(UserID'Image(Wearer));
      Put(" removes ");
      Put_Line(" the insurer. ");
   end RemoveInsurer;

-- read the insurer of the wearer   
   function ReadInsurer(Wearer : in UserID) return UserID is
   begin
      Put(UserID'Image(Wearer));
      Put(" has ");
      Put(UserID'Image(UserInfo(Integer(Wearer)).Insurer));
      Put_Line(" as insurer ");
      return  UserInfo(Integer(Wearer)).Insurer;
   end ReadInsurer;

-- set friend for the wearer
   procedure SetFriend(Wearer : in UserID; NewFriend : in UserID) is
   begin
      UserInfo(Integer(Wearer)).Friend := NewFriend;
      Put(UserID'Image(Wearer));
      Put(" sets ");
      put(UserID'Image(UserInfo(Integer(Wearer)).Friend));
      Put_Line(" as friend. ");
   end SetFriend;

-- read the friend of the wearer
   function ReadFriend(Wearer : in UserID) return UserID is
   begin
      Put(UserID'Image(Wearer));
      Put(" has ");
      Put(UserID'Image(UserInfo(Integer(Wearer)).Friend));
      Put_Line(" as friend ");
      return UserInfo(Integer(Wearer)).Friend;
   end ReadFriend;
   
-- remove the friend of the wearer
   procedure RemoveFriend(Wearer : in UserID) is
   begin
      UserInfo(Integer(Wearer)).Friend := -1;
      Put(UserID'Image(Wearer));
      Put(" removes ");
      Put_Line(" the friend. ");
   end RemoveFriend;

-- update the vitals permission   
   procedure UpdateVitalsPermissions(Wearer : in UserID;
                     Other : in UserID;
                     Allow : in Boolean) is
   begin
      PermiInfo(Integer(Wearer),Integer(Other)).PermiVitals := Allow;
      Put(UserID'Image(Wearer));
      Put(" sets ");
      Put(UserID'Image(Other));
      Put(" permission ");
      Put_Line(Boolean'Image(PermiInfo(Integer(Wearer),
               Integer(Other)).PermiVitals));
   end UpdateVitalsPermissions;

-- update the permission for footsteps
   procedure UpdateFootstepsPermissions(Wearer : in UserID;
                    Other : in UserID;
                    Allow : in Boolean) is
   begin
      PermiInfo(Integer(Wearer),Integer(Other)).PermiFootsteps := Allow; 
      Put(UserID'Image(Wearer));
      Put(" sets ");
      Put(UserID'Image(Other));
      Put(" permission ");
      Put_Line(Boolean'Image(PermiInfo(Integer(Wearer),
                 Integer(Other)).PermiFootsteps));
   end UpdateFootstepsPermissions;

-- update the permission for location
   procedure UpdateLocationPermissions(Wearer : in UserID;
                       Other : in UserID;
                       Allow : in Boolean) is
   begin
      PermiInfo(Integer(Wearer),Integer(Other)).PermiFootsteps := Allow;
      
      Put(UserID'Image(Wearer));
      Put(" sets ");
      Put(UserID'Image(Other));
      Put(" permission ");
      Put_Line(Boolean'Image(PermiInfo(Integer(Wearer),
               Integer(Other)).PermiLocation));
   end UpdateLocationPermissions;

-- update the vitals for the wearer   
   procedure UpdateVitals(Wearer : in UserID; NewVitals : in BPM) is
   begin
      UserInfo (Integer(Wearer)).Vitals := NewVitals;
      Put(UserID'Image(Wearer));
      Put(" update BPM ");
      Put_Line(BPM'Image(UserInfo (Integer(Wearer)).Vitals));
   end UpdateVitals;

-- update the footsteps for the wearer
   procedure UpdateFootsteps(Wearer : in UserID; NewFootsteps : in Footsteps) is
   begin
      UserInfo (Integer(Wearer)).UserFootsteps := NewFootsteps; 
      Put(UserID'Image(Wearer));
      Put(" update Footsteps ");
      Put_Line(Footsteps'Image(UserInfo (Integer(Wearer)).UserFootsteps));
   end UpdateFootsteps;

-- update the location for the wearer
   procedure UpdateLocation(Wearer : in UserID; NewLocation : in GPSLocation) is
   begin
      UserInfo (Integer(Wearer)).Location := NewLocation;
      Put(UserID'Image(Wearer));
      Put(" update location ");
      Put_Line("  Location: (" & 
                Latitude'Image(UserInfo (Integer(Wearer)).Location.Lat)& ", " &
                 Longitude'Image(UserInfo (Integer(Wearer)).Location.Long) & 
                 " )");
   end UpdateLocation;

-- the requester( insurer, friend, emergency) reads the targetuser vitals
   function ReadVitals(Requester : in UserID; TargetUser : in UserID)
              return BPM is
   begin
      -- if the permission for the requester is true
      if PermiInfo(Integer(TargetUser),
                   Integer(Requester)).PermiVitals = true then
      -- return the BPM    
      Put(UserID'Image(Requester));
      Put(" reads ");
      Put(UserID'Image(TargetUser));   
      Put(BPM'Image(UserInfo(Integer(TargetUser)).Vitals));
      Put_Line(" BPM ");
         return UserInfo(Integer(TargetUser)).Vitals;
      else
         -- else put the no permission message
         Put_Line(" Do not have the permission ");
         return -1;
      end if;
   end ReadVitals;

-- the requester( insurer, friend, emergency) reads the targetuser footsteps
   function ReadFootsteps(Requester : in UserID; TargetUser : in UserID)
             return Footsteps is
   begin
      -- if the permission for the requester is true
      if PermiInfo(Integer(TargetUser),
                   Integer(Requester)).PermiFootsteps = true then
      -- return the footsteps   
      Put(UserID'Image(Requester));
      Put(" reads ");
      Put(UserID'Image(TargetUser));   
      Put(Footsteps'Image(UserInfo(Integer(TargetUser)).UserFootsteps));
      Put_Line(" Footsteps ");
         return UserInfo(Integer(TargetUser)).UserFootsteps;
      else
         -- else return no permission message
         Put_Line(" Do not have the permission ");
         return 0;
      end if;
   end ReadFootsteps;

-- the requester( insurer, friend, emergency) reads the targetuser location
   function ReadLocation(Requester : in UserID; TargetUser : in UserID)
            return GPSLocation is
   begin
      -- if the permission for the requester is true
      if PermiInfo(Integer(TargetUser),
                   Integer(Requester)).PermiLocation = true then
      -- return the location   
      Put(UserID'Image(Requester));
      Put(" reads ");
      Put(UserID'Image(TargetUser));   
      Put_Line("  Location: (" & 
               Latitude'Image(UserInfo (Integer(TargetUser)).Location.Lat)&", " 
               & Longitude'Image(UserInfo (Integer(TargetUser)).Location.Long) 
               & " )");
         return UserInfo(Integer(TargetUser)).Location;
      else
         Put(" Do not have the permission ");
         return (0.0,0.0);
      end if;
   end ReadLocation;

-- contact the emergency
   procedure ContactEmergency(Wearer : in UserID;
                  Location : in GPSLocation;
                              Vitals : in BPM) is
      Vitals_Current : BPM; -- the current vitals
   begin
      Vitals_Current := ReadVitals(0, Wearer);
      -- if it returns -1 
      -- means that the emergency has no permission to read vitals of wearer
      -- so if it is not -1 then the system will contact emergency
      -- and store the location and vitals for further use
      if Vitals_Current /= -1 then
         UserInfo(Integer(Wearer)).EmerVitals := Vitals;
         UserInfo(Integer(Wearer)).EmerLocation := Location;
         Emergency.ContactEmergency(Wearer,Vitals_Current,Location);
      else
         Put_Line("Fail to Contact Emergency  ");
      end if;
   end ContactEmergency;

end AccountManagementSystem;
