⚠️ Disclaimer: Use your own professional judgement before using any scripts or queries. I take no responsibility for issues caused by their use.

### `add_configuration.mof`

Open your configuration.mof file located in <CM install directory>\inboxes\clifiles.src\hinv, and scroll to the bottom of the configuration.mof file. Add the contents of add_configuration.mof per below:

<img width="1489" height="1011" alt="image" src="https://github.com/user-attachments/assets/ad328a99-395f-4f41-8f5c-3381a18c939b" />

### `ext_system_secureboot.mof & ext_system_secureboot_servicing.mof`

Go to the Client Agent setting section in the MECM console, and click Set Classes:

<img width="1014" height="722" alt="image" src="https://github.com/user-attachments/assets/c0924253-981a-4ae7-9379-e1a71e5a1121" />

Click on the Import… button:

<img width="684" height="593" alt="image" src="https://github.com/user-attachments/assets/2e7141ae-7c39-4659-b36a-cac396c2ebea" />

select ext_system_secureboot.mof and click open:

<img width="941" height="531" alt="image" src="https://github.com/user-attachments/assets/87940aec-2b27-4b53-9ba0-1186e96889ac" />

Once you get the below confirmation box, click import again: 

<img width="530" height="589" alt="image" src="https://github.com/user-attachments/assets/2d4f0fc6-508b-446d-bd51-fa341dc9321d" />

<img width="532" height="590" alt="image" src="https://github.com/user-attachments/assets/baf9de1c-42e6-43c3-9011-e7d78dfa57f2" />

Repeat the same process for ext_system_secureboot_servicing.mof.

The tables and views in MECM will be created once the first devices start to update your hardware inventory (hint: you can force this process by sending 
1. download a computer policy
2. a client notification to collect a fresh set of the current hardware inventory:

<img width="607" height="127" alt="image" src="https://github.com/user-attachments/assets/5b5aaff5-069f-4fbf-817a-2deffb2d020e" />

### `ext_hwInventory.sql`

This file can be used to combine the inventory data with the extended information added to MECM. The SQL file is build in SQL Server Management Studio but can also be used as an official MECM report:

<img width="1345" height="117" alt="image" src="https://github.com/user-attachments/assets/7735379b-34bd-45a3-b51f-7eab9df75f67" />
