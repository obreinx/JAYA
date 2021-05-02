#!/bin/bash
echo "
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 JAYA Automation Tool By Twitter:@JafarAlQudah1 Facebook:/Jafarqx                                                                                                            
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++                                                                                             "
echo "[Enter Your Target Domain]:"
read target
mkdir $target
cd $target
##Subdomains-ENUMERATING
echo "Getting All Subdoamins"
(assetfinder $target;subfinder -d $target) > all_subdomains.txt
###Subdomain-takerover
echo "###Checking For Subdomain TakeOvers###"
subzy -targets all_subdomains.txt -hide_fails
####Live_Subdomains
echo "###checking live subdoamins###"
cat all_subdomains.txt | httpx -status-code > live_subdomains_with_status.txt
cat all_subdomains.txt | httpx > live_subdomains.txt
###Waybackurl
echo "###checking waybackurl###"
cat live_subdomains.txt | waybackurls > waybackurls.txt
##(dirsearch)
echo " directory search subdoamins"
dirsearch -l live_subdomains.txt -X js,png,jpeg,jpg,gif -w /usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt > dirsearch.txt
###Ports-scan
echo "###scanning ports###"
naabu -iL all_subdomains.txt -top-ports 100 -o portsscan.txt
###Github-Dorks###
echo " checking github dorks"
cd ..
git-hound --config-file config.yml --subdomain-file /$target/live_subdomains.txt --no-api-keys --dig-files > $target/githound.txt
cd $target
###parameters
echo "###creating parameters files###"
mkdir parameters
cat waybackurls.txt | gf sqli > /parameters/sqli.txt
cat waybackurls.txt | gf lfi > /parameters/lfi.txt
cat waybackurls.txt | gf ssrf > /parameters/ssrf.txt
cat waybackurls.txt | gf rce > /parameters/rce.txt
###javascript files
echo "###javascript files###"
cat waybackurls.txt | grep js > javascript.txt
####Nuclei
echo "###checking files with nuclei###"
nuclei -l all_subdomains.txt -t /home/obr/Desktop/nuclei-templates -o nuclei.txt
