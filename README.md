# domain_resolver
Mikrotik script that resolve domains/keywords and save IP or domain in address-list

Usage
Edit "dataArray" and add address-list name and domain/s or keyword/s to search (All of this between doble quotes and semicolon separated).
Format: :local dataArray {{"address-list_name";"domain/keyword1";"domain/keyword2";"domain/keywordn"};{"another_address-list_name";"domain/keyword1";"domain/keyword2";"domain/keywordn"}}

Example for Netflix: :local dataArray {{"netflix";"netflix.com";""nflxvideo"}}

Example for Netflix and Youtube: :local dataArray {{"netflix";"netflix.com";""nflxvideo"};{"youtube";"youtube.com";""googlevideo"}}

At the first run script sets an entry in scheduler to run every 5 minutes. You can test if is working running script in console.
