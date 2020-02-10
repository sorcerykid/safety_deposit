Safety Deposit Mod v1.0
By Leslie E. Krause

Safety Deposit integrates with the Simple Cipher Mod to provide an additional layer of 
security for itemstack metadata via block-chain encryption. 

Since container inventories are sent to every connected client, it is possible to use
either client-side modding or local map-saving to examine the contents of locked chests, 
mailboxes, etc. This has the potential to expose sensitive personal information, as in the 
case of written books which are often used for communication between players.

Itemstack metadata can be be encrypted and descrypted on the fly using the following two
API functions, both of which supply the administrator username as the public key:

  * safety_deposit.encrypt_metadata( itemstack, data )
    Serializes and encrypts the data, saving the resulting ciphertext as a Base-64 encoded
    string to the itemstack meta.

  * safety_deposit.decrypt_metadata( itemstack )
    Decrypts and deserializes the itemstack meta. As a fallback, in case the string is not
    actually encrypted, it will simply be deserialized.

If someone happens to obtain a copy of the map (without the private key of the server 
owner), then it will be virtually impossible, outside of a sophisticated brute-force 
attack, to fully extract the metedata of these items once encrypted.

A digital safe can also be crafted for even higher-grade security. This container, once 
placed in world, encrypts its entire inventory, thereby thwarting any unwanted intruders. 
The only means of access is by a 4-digit PIN which only the owner (or team-members) will 
possibly know. Even the administrator cannot retrieve the access code if forgotten, so it
is very important to write the number down immediatly after engaging the lock.


Repository
----------------------

Browse source code...
  https://bitbucket.org/sorcerykid/safety_deposit

Download archive...
  https://bitbucket.org/sorcerykid/safety_deposit/get/master.zip
  https://bitbucket.org/sorcerykid/safety_deposit/get/master.tar.gz

Compatability
----------------------

Minetest 0.4.15+ required

Dependencies
----------------------

Default Mod (required)
  https://github.com/minetest/minetest_game

ActiveFormspecs Mod (required)
  https://bitbucket.org/sorcerykid/formspecs

Simple Cipher Mod (optional)
  https://bitbucket.org/sorcerykid/cipher

Installation
----------------------

  1) Unzip the archive into the mods directory of your subgame
  2) Rename the safety_deposit-master directory to "safety_deposit"
  3) Add "safety_deposit" as a dependency to any mods using the API


Source Code License
----------------------

GNU Lesser General Public License v3 (LGPL-3.0)

Copyright (c) 2020, Leslie E. Krause

This program is free software; you can redistribute it and/or modify it under the terms of
the GNU Lesser General Public License as published by the Free Software Foundation; either
version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU Lesser General Public License for more details.

http://www.gnu.org/licenses/lgpl-2.1.html


Multimedia License (textures, sounds, and models)
----------------------------------------------------------

Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)

   /sounds/safe_error.ogg
   obtained from https://notificationsounds.com/message-tones/glitch-in-the-matrix-600
   modified by sorcerykid

   /sounds/safe_entry.ogg
   obtained from https://notificationsounds.com/message-tones/your-turn-491
   modified by sorcerykid

   /sounds/safe_abort.ogg
   obtained from https://notificationsounds.com/message-tones/knob-458
   modified by sorcerykid

   /sounds/safe_open.ogg
   obtained from https://freesound.org/people/kyles/sounds/362053/
   modified by sorcereykid

   /sounds/safe_close.ogg
   obtained from https://freesound.org/people/kyles/sounds/362053/
   modified by sorcerykid

   /sounds/safe_lock.ogg
   obtained from https://freesound.org/people/kyles/sounds/362053/
   modified by sorcerykid

   /sounds/safe_unlock.ogg
   obtained from https://freesound.org/people/kyles/sounds/362053/
   modified by sorcerykid

   /textures/safe_front.png
   obtained from https://gitlab.com/VanessaE/currency/

   /textures/safe_side.png
   obtained from https://gitlab.com/VanessaE/currency/

   /textures/counter_0.png
   by sorcerykid

   /textures/counter_1.png
   by sorcerykid

   /textures/counter_3.png
   by sorcerykid

   /textures/counter_4.png
   by sorcerykid

   /textures/counter_5.png
   by sorcerykid

   /textures/counter_6.png
   by sorcerykid

   /textures/counter_7.png
   by sorcerykid

   /textures/counter_8.png
   by sorcerykid

   /textures/counter_9.png
   by sorcerykid

   /textures/counter_nil.png
   by sorcerykid

You are free to:
Share — copy and redistribute the material in any medium or format.
Adapt — remix, transform, and build upon the material for any purpose, even commercially.
The licensor cannot revoke these freedoms as long as you follow the license terms.

Under the following terms:

Attribution — You must give appropriate credit, provide a link to the license, and
indicate if changes were made. You may do so in any reasonable manner, but not in any way
that suggests the licensor endorses you or your use.

No additional restrictions — You may not apply legal terms or technological measures that
legally restrict others from doing anything the license permits.

Notices:

You do not have to comply with the license for elements of the material in the public
domain or where your use is permitted by an applicable exception or limitation.
No warranties are given. The license may not give you all of the permissions necessary
for your intended use. For example, other rights such as publicity, privacy, or moral
rights may limit how you use the material.

For more details:
http://creativecommons.org/licenses/by-sa/3.0/
