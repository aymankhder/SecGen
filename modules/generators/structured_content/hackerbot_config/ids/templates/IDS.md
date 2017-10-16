# Intrusion Detection and Prevention Systems: Configuration and Monitoring using Snort

## Getting started
### VMs in this lab

==Start these VMs== (if you haven't already):

- hackerbot_server (leave it running, you don't log into this)
- ids_server (IP address: <%= $server_ip %>)
- ids_server (IP address: <%= $server_ip %>)
- desktop

All of these VMs need to be running to complete the lab.

### Your login details for the "desktop" and "ids_server" VMs
User: <%= $main_user %>
Password: tiaspbiqe2r (**t**his **i**s **a** **s**ecure **p**assword **b**ut **i**s **q**uite **e**asy **2** **r**emember)

You won't login to the hackerbot_server, but the VM needs to be running to complete the lab.

You don't need to login to the backup_server, but you will connect to it via SSH later in the lab.

### If you are using Virtualbox (not oVirt)

Leeds Beckett students will complete these labs using oVirt. Otherwise, if you have used SecGen to spin up local VMs, you need to ensure your VMs have permission to monitor networks by using promiscuous mode (Google is your friend).

### For marks in the module
1. **You need to submit flags**. Note that the flags and the challenges in your VMs are different to other's in the class. Flags will be revealed to you as you complete challenges throughout the module. Flags look like this: ==flag{*somethingrandom*}==. Follow the link on the module page to submit your flags.
2. **You need to document the work and your solutions in a workbook**. This needs to include screenshots (including the flags) of how you solved each Hackerbot challenge and a writeup describing your solution to each challenge, and answering any "Workbook Questions". The workbook will be submitted later in the semester.

## Hackerbot!
![small-right](images/skullandusb.svg)

This exercise involves interacting with Hackerbot, a chatbot who will task you to perform backups and will attack your system. If you satisfy Hackerbot by completing the challenges, she will reveal flags to you.

Work through the below exercises, completing the Hackerbot challenges as noted.

---
## Network monitoring basics

This section gives a quick overview of the basics of network monitoring. If you feel you are already familiar with these techniques, keep in mind that these are important foundations, and we will quickly build on these.

From your desktop VM, ==SSH into the IDS server==:

```bash
ssh <%= $server_ip %>
```

The IDS server has a network card interface that can enter promiscuous mode, meaning that it can view traffic destined to other systems on the network.

To view live network traffic, ==start tcpdump:==

```bash
tcpdump
```
> Tip: If running tcpdump generates the error "packet printing is not supported for link type USB\_Linux: use -w", then append "-i *eth0*" to each tcpdump command. (Where eth0 is the name of the interface as reported by ifconfig).

With tcpdump still running, ==perform a ping to the Kali VM, from the openSUSE VM.== 
> Hint: find the IP address of the Kali system, then from the other system run “nmap *IP-address-of-Kali Linux-VM*”). 

Note that tcpdump displays the network activity taking place, including TCP connections and ARP requests.
> In each case, once you have seen tcpdump in action displaying packets you can ==press Ctrl-C to exit==

Now with tcpdump still running, try performing an Nmap port scan against the Kali VM, from the openSUSE VM

Tcpdump can format the output in various ways, showing various levels of detail.

Close tcpdump if it is still running (Ctrl-C), and run on the Kali VM:

> tcpdump -q
>
> ping the Kali VM again and observe the output

This shows a less verbose version of the output.

While,

> tcpdump -A
>
> ping the Kali VM again and observe the output

Shows the packet content without the information about the source and destination. If you access a web page in a browser on the Kali VM (go ahead...), it will display the content, so long as the traffic is not SSL encrypted (for example, if the URL starts with http**s**://).

If you want to access the Web from within Kali Linux when using the oVirt VM management system, you will need to set Firefox to use the Leeds Beckett HTTP proxy: which is 192.168.201.51 port 3128 (this should already be set for you but use the following instructions if you need to set it yourself).

Hint: ![](media/image5.png){width="0.25in" height="0.20833333333333334in"} &gt; Preferences &gt; Advanced &gt; Network &gt; Settings &gt; Manual proxy configuration. Enter the proxy IP address and port number then tick “Use this proxy for all protocols”.

#### For students working in the campus IMS labs using the IMS system (not oVirt)

Note that if you want to access the Web from within Kali Linux in the Leeds Beckett IMS labs using the IMS system (Not oVirt), you will need to set Firefox to use the Leeds Beckett HTTP proxy: which is 192.168.208.51 port 3128 (this should already be set).

Also note that the fact that all our traffic is going via proxies makes the network traffic a bit more complicated to make sense of, since connections are made to the proxy, rather than directly to the IP address of the web servers. If you try this on another VM or access a web server in the lab rather than the Internet, the traffic will be easier to monitor.

Start apache in Kali Linux:

> service apache2 start

Set Firefox to not the proxy for local network addresses on openSUSE:

In Firefox choose:

![](media/image3.png){width="0.25in" height="0.20833333333333334in"} &gt; Preferences &gt; Advanced &gt; Network &gt; Settings

Enter, 192.168.0.0/16 in the No Proxy for: textbox

![](media/image4.png){width="4.645833333333333in" height="0.96875in"}

Click OK

In Firefox, on the openSUSE VM, browse to a web page by visiting the IP address of the Kali Linux VM (Hint: with tcpdump -A still running on the Kali VM)

Stop tcpdump (Ctrl-C) on the Kali VM once you have observed the output.

Run the following command on the Kali VM:

> tcpdump -v

The above is even more verbose, showing lots of detail about the network traffic.

Now try the port scan against the Kali VM again. Note the very detailed output.

It is possible to write tcpdump network traffic to storage, so that it can be analysed later:

> tcpdump -w /tmp/tcpdump-output
>
> While that is running, access a web page from Firefox on the Kali VM, then close tcpdump (Ctrl-C).

To view the file containing the tcpdump output on the Kali VM type:

> less /tmp/tcpdump-output

(press “y” to see the output if you are warned that it may be a binary file)

You should be able to PageUp and PageDown through the file.

> Press “Q” to quit when ready

If you are interested, run “man tcpdump” and read about the many options for output and filtering.

The graphical program Wireshark can also be used to monitor network traffic, and can also read tcpdump output.

On the Kali Linux VM, run (ignore any error messages about running Wireshark as superuser):

> wireshark -r /tmp/tcpdump-output

Have a look at the recorded network traffic data using Wireshark, and investigate various ways that the data can be displayed. For example, right click one of the HTTP connections, and “follow TCP stream”. Once you have finished, close Wireshark.

We could use tcpdump to do some simple monitoring of the network traffic to detect certain key words.

On the Kali Linux VM, run:

> tcpdump -A | grep "leedsbeckett.ac.uk"
>
> Tip: if you are using a UK keyboard and Kali Linux is configured for US, the “|” symbol is located where “\~” is.

Open a web browser **on the Kali VM**, and visit [*http://leedsbeckett.ac.uk*](http://leedsbeckett.ac.uk), (make sure the proxy is set) note that tcpdump captures *most* network content, and grep can be used to filter it down to lines that are interesting to us.

Note that making sense of this information using tcpdump and/or Wireshark is possible (and is a common sys-admin task), but the output is too noisy to be constantly and effectively monitored by a human to detect security incidents. Therefore we can use an IDS such as Snort to monitor and analyse the network traffic to detect activity that it is configured to alert.

Make tcpdump is stopped (Ctrl-C).

### IDS monitoring basics

Continuing **on the Kali Linux VM**, install Snort:

> apt-get update
>
> apt-get install snort
>
> Accept the default settings, make a note of the IP address range and interface Snort is using: for example, 192.168.0.0/16 (in this case you should use the IP addresses in this range).
>
> *Tip: if you are behind a proxy (such as in the IMS labs or using oVirt) you may need to set a proxy first,* [**this URL**](http://www.ubuntugeek.com/how-to-configure-ubuntu-desktop-to-use-your-proxy-server.html) *may be helpful. (On oVirt you may need to run “export http\_proxy=*[**http://192.168.201.51:3128**](http://192.168.201.51:3128)*”) ( In the IMS lanbs, you may need to run “export http\_proxy=*[**http://192.168.208.51:3128**](http://192.168.201.51:3128)*”) *
>
> *Tip: if you can not install snort,* [**this URL**](http://docs.kali.org/general-use/kali-linux-sources-list-repositories) *may be helpful. You may need to manually update the contents of /etc/apt/sources.list*

Make a backup of the snort’s configuration file in case anything goes wrong:

cp /etc/snort/snort.conf /etc/snort/snort.conf.bak

Change snort’s output to something more readable:

vi /etc/snort/snort.conf

(remember: editing using vi involves pressing “i” to insert/edit text, then *Esc*,

“:wq” to write changes and quit)

Comment out the line starting with “output …” (put a \# in front of it)

Add the following line:

output alert\_fast

> **Help with find in vi:** the find command in vi is the / character (forward slash) . When **NOT in insert mode** (pressing Esc will get you out of insert mode if you need to), to find “output” you could enter / output \[+ PRESS ENTER\] Then press the n character to find the next output and the next and the next and the next etc.
>
> If there is still no alert file in /var/log/snort/, you may need to edit /etc/snort/snort.debian.conf, to use the correct interface (for example, eth1 if the output of “ifconfig” does not contain “eth0”).

Start Snort:

> systemctl start snort

Snort should now be running, monitoring network traffic for activity.

Do an nmap port scan of the Kali Linux VM (from the openSUSE VM).

This should trigger an alert from Snort, which is stored in an alerts log file.

Does the log match what happened? Are there any false positives (alerts that describe things that did not actually happen)?

“Follow” the log file by running:

> tail -f /var/log/snort/alert

The tail program will wait for new alerts to be written to the file, and will display them as they are logged.

Press Ctrl-Z to stop the process, if it did not do so automatically.

Kali Linux’s Snort configuration file can be configured to output, a “tcpdump” formatted network capture.

Open the snort.conf file in vi:

vi /etc/snort/snort.conf

> (remember: editing using vi involves pressing “i” to insert/edit text, then *Esc*, “:wq” to write changes and quit)

Uncomment the following line and then save the changes (remove the \#):

output log\_tcpdump: tcpdump.log

Restart Snort:

> systemctl restart snort

Try another type of port scan, such as an Xmas Tree scan from the openSUSE VM (*hint: “man nmap”*).

Then run the following command to view the contents of the log:

tcpdump -r /var/log/snort/tcpdump.log.\*

You can use tcpdump’s various flags to change the way it is displayed, or even open the logged network activity in wireshark.

**Configuring Snort**

Open /etc/snort/snort.conf in an editor; for example:

> vi /etc/snort/snort.conf
>
> (remember: editing using vi involves pressing “i” to insert/edit text, then *Esc*, “:wq” to write changes and quit)

Scroll through the config file and, take notice of these details:

-   In a production environment you would configure Snort to to correctly identify which traffic is considered LAN traffic, and which IP addresses are known to run various servers (this is also configured in snort.debian.conf). In this case, we will leave these settings as is.

-   Note the line “var RULE\_PATH /etc/snort/rules”: this is where the IDS signatures are stored.

-   Note the presence of a Back Orifice detector preprocessor “bo”. Back Orifice was a Windows Trojan horse that was popular in the 90s.

-   We have already seen the “sfportscan” preprocessor in practice, detecting various kinds of port scans.

-   The “arpspoof” preprocessor is described as experimental, and is not enabled by default.

-   Towards the end of the config file are “include” lines, which specify which of the rule files in RULE\_PATH are in effect. As is common, lines beginning with “\#” are ignored, which is used to list disabled rule files. There are rule files for detecting known exploits, attacks against services such as DNS and FTP, denial of service (DoS) attacks, and so on.

Add the following line below the other include rules (at the end of the file):

> include \$RULE\_PATH/my.rules

Save your changes to snort.conf (for example, in vi, press Esc, then type “:wq”). Hint: you may find it easier to use Esc, then type “:w” to write your changes to disk and then type “:q” to exit.

*Remember: if you are working on a IMS lab VM (not using oVirt), any changes on disk will not be permanent, so save copies of your work to USB.*

Run this command, to create your new rule file:

> touch /etc/snort/rules/my.rules

Edit the file. For example:

vi /etc/snort/rules/my.rules

Add this line (with your own name), then save your changes:

> alert icmp any any -&gt; any any (msg: "*Your-name*: ICMP Packet found"; sid:1000000; rev:1;)
>
> For example, “alert icmp any any -&gt; any any (msg: "**Cliffe**: ICMP Packet found"; sid:1000000; rev:1;)”

Now that you have new rules, tell Snort to reload its configuration:

> systemctl restart snort
>
> (If after attempting a reload Snort fails to start, you have probably made a configuration mistake, so check the log for details by running: “tail /var/log/syslog”)

Due to the new rule you have just applied, sending a simple ICMP Ping (typically used to troubleshoot connectivity) will trigger a Snort alert.

Try it, from the openSUSE VM:

> ping *Kali-Linux-VM-IP-Address*

Check for the Snort alert. You should see that the ping was detected, and our new message was added to the alerts log file.

### Writing your own Snort rules

Snort is predominantly designed as a signature-based IDS. Snort monitors the network for matches to rules that indicate activity that should trigger an alert. You have now seen Snort detect a few types of activity, and have added a rule to detect ICMP packets. Next you will apply more complicated rules, and create your own.

In addition to the lecture slides, you may find this resource helpful to complete these tasks:

> Martin Roesch (n.d.) **Chapter 2:** Writing Snort Rules - How to Write Snort Rules and Keep Your Sanity. In: *Snort Users Manual*. Available from: &lt;[*http://www.snort.org.br/documentacao/SnortUsersManual.pdf*](http://www.snort.org.br/documentacao/SnortUsersManual.pdf)&gt; \[Accessed 31 August 2016\].

In general, rules are defined on one line (although, they can break over lines by using “\\”), and take the form of:

header (body)

where header =

action(log,alert) protocol(ip,tcp,udp,icmp,any) src IP src port direction(-&gt;,&lt;&gt;)

> for example: “alert tcp any any -&gt; any any” to make an alert for all TCP traffic, or “alert tcp any any -&gt; 192.168.0.1 23”\* to make an alert for connections to telnet on the given IP address

and body =

> option; option: “parameter”; ...

The most common options are:

> msg: “message to display”

and, to search the packet’s content:

> content: “some text to search for”

To set the type of alert:

> classtype:misc-attack
>
> (where misc-attack is defined in /etc/snort/classification.conf)

To give a unique identifier and revision version number:

> sid:1000001; rev:1

So for example the body could be:\*

> msg: “user login attempt”; content: “user”; classtype:attempted-user; sid:1000001; rev:1;

And bringing all this together a Snort rule could read:

> alert tcp any any -&gt; 192.168.0.1 110 (msg: “Email login attempt”; content: “user”; classtype:attempted-user; sid:1000001; rev:1;)

This rule looks at packets destined for 192.168.0.1 on the pop3 Email port (110), and sends an alert if the content contains the “user” command (which is used to log on to check email). Note that this rule is imperfect as it is, since it is case sensitive.

There are lots more options that can make rules more precise and efficient. For example, making them case insensitive, or starting to search content after an offset. Feel free to do some reading, to help you to create better IDS rules.

Optional: figure out how the rule could be improved to be case insensitive.

Study the existing rules in /etc/snort/rules and figure out how at least two of them work.

### Problem-based tasks

Edit your new rules file:

> vi /etc/snort/rules/my.rules

Add a rule to detect any attempt to connect to a Telnet server. Connections to a Telnet server could be a security issue, since logging into a networked computer using Telnet is known to be insecure because traffic is not encrypted. Make the output message include your name, as we did previously.

Hint: you can combine the information above (tagged with \*) to create this rule. Change the IP address to “any”, and consider removing any content rules.

Once you have saved your rule and reloaded Snort, test this rule by using Telnet. Rather than starting an actual Telnet server (unless you want to do so), you can simulate this by using Netcat to listen on the Telnet port, then connect with Telnet from the openSUSE VM.

On a terminal on the Kali Linux VM:

netcat -l -p 23

Leaving that running, and on a terminal on the openSUSE VM:

> telnet localhost
>
> type “hello”

Hint: if you have connectivity problems, make sure both systems are on the same subnet (the IP addresses start the same). If you have problems in the IMS labs using VMs (not oVirt), consider setting networking to “bridged”.

Look at the alert output, and confirm that your alert has been logged, and it includes your name in the output.

**Take a screenshot as evidence that you have completed this part of the task. Preferably with the Telnet window running in the background, and your alert from the log file visible.**

**Label it or save it as “IDS-A1”.**

Create a Snort rule that detects visits to the Leeds Beckett website from the Kali VM, but does not get triggered by general web browsing.

Hints:

Look at some of the existing Snort rules for detecting Web sites, such as those in /etc/snort/rules/community-inappropriate.rules

In the IMS labs or when using oVirt, you are likely using the proxy to access the web, so you will need to approach your rules a little differently, you may find you need to change the port you are listening to. Look at the output of tcpdump -A when you access a web page, what does the traffic contain that may point to what is being accessed? Have a look through the output of tcpdump for the text “Host”.

As before, include your name in the alert message.

**Save the rule you have created, and take a screenshot of an alert and the rule, as evidence that you have completed this part of the task.**

**Label it or save it as “IDS-A2”.**

Enable the arpspoof preprocessor, and get Snort to detect an attempt at arp spoofing.

Hint: you will need preprocessor configuration rule(s) and alert(s) to match the preprocessor output. Refer to the Snort manual.

**Take screenshots of configuration changes and an alert, as evidence that you have completed this part of the task.**

**Label it or save it as “IDS-A3”.**

Setup Snort as an intrusion *prevention* system (IPS): on the Kali VM so that it can actually deny traffic, and demonstrate with a rule. You may wish to extend the Leeds Beckett website rule, so that all attempts to access the website are denied by Snort.

**Take screenshots of configuration changes, an alert, and a denied connection, as evidence that you have completed this part of the task.**

**Label it or save it as “IDS-A4”.**
