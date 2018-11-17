:global lst "Whatsapp";
:foreach i in=[/ip dns cache all find where (name~"whatsapp" || name~"whatscom") && (type="A") ] do={
  :local tmpName [/ip dns cache get $i name];
  :local ttl [/ip dns cache get $i ttl];
  delay delay-time=10ms

  :if ( [/ip firewall address-list find where address=$tmpName] = "") do={ 
    :log info ("added entry: $tmpName $tmpAddress");
   /ip firewall address-list add address=$tmpName list="$lst" comment=$tmpName timeout=$ttl;
  }
}
