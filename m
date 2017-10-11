Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6644521F3C181
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 06:50:49 -0700 (PDT)
Date: Wed, 11 Oct 2017 21:54:15 +0800
From: Xiong Zhou <xzhou@redhat.com>
Subject: Re: ffsb job does not exit on xfs 4.14-rc1+
Message-ID: <20171011135415.6omvzcdflflqghbo@XZHOUW.usersys.redhat.com>
References: <20170925014006.5tvdkjszrbj6uhgc@XZHOUW.usersys.redhat.com>
 <20170925084903.fsjgrn7rfernou5j@hades.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170925084903.fsjgrn7rfernou5j@hades.localdomain>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 25, 2017 at 10:49:03AM +0200, Carlos Maiolino wrote:
> On Mon, Sep 25, 2017 at 01:40:06AM +0000, Xiong Zhou wrote:
> > Hi,
> > 
> > ffsb test won't exit like this on Linus tree 4.14-rc1+.
> > Latest commit cd4175b11685
> 
> Can you provide more information? Do you have any kernel log from this issue?
> dmesg, Oopses, traces, etc.
> Storage configuration might also be required here.

Turns out this only repreduces on nvdimm devices, xfs without dax
mount option. More logs are attached.

> 
> have you also tried to reproduce it with another filesystem? If so, is the same
> problem reproducible with another filesystem or only with XFS?

Only xfs. Test on ext4 ends shortly.

> 
> P.S. please avoid sending it to all lists (mainly LKML).

Why?  I thought LKML was better archived.

> Unless it's a more generic kernel problem, keep it in fsdevel and/or the
> respective filesystem list if it's related to a single filesystem only.

4.14-rc1+ won't survive this script, while 4.13 can.

========== start of script ============================
#!/bin/bash -x

mkfs.xfs  -f /dev/pmem0 || exit
rm -rf /xfsmnt
mkdir -p /xfsmnt
mount /dev/pmem0 /xfsmnt || exit

cat > ffsb.job <<EOF
# Large file creates
# Creating 1 GB files.

time=300
alignio=1
directio=0

[filesystem0]
	location=/xfsmnt

	# All created files will be 1 GB.
	min_filesize=1GB
	max_filesize=1GB
[end0]

[threadgroup0]
	num_threads=192

	create_weight=1

	write_blocksize=4KB

	[stats]
		enable_stats=1
		enable_range=1

		msec_range    0.00      0.01
		msec_range    0.01      0.02
		msec_range    0.02      0.05
		msec_range    0.05      0.10
		msec_range    0.10      0.20
		msec_range    0.20      0.50
		msec_range    0.50      1.00
		msec_range    1.00      2.00
		msec_range    2.00      5.00
		msec_range    5.00     10.00
		msec_range   10.00     20.00
		msec_range   20.00     50.00
		msec_range   50.00    100.00
		msec_range  100.00    200.00
		msec_range  200.00    500.00
		msec_range  500.00   1000.00
		msec_range 1000.00   2000.00
		msec_range 2000.00   5000.00
		msec_range 5000.00  10000.00
	[end]
[end0]
EOF

which ffsb || {
wget https://sourceforge.net/projects/ffsb/files/ffsb/ffsb-6.0-rc2/ffsb-6.0-rc2.tar.bz2;
tar jxf ffsb-6.0-rc2.tar.bz2;
cd ffsb-6.0-rc2;
./configure && make && make install || exit;
cd ..;
}
ffsb ffsb.job

umount -d /xfsmnt
uname -r
========== end of script ============================

More logs:

# ps jf
 PPID   PID  PGID   SID TTY      TPGID STAT   UID   TIME COMMAND
 1979  1980  1980  1980 pts/1     1997 Ss       0   0:00 /bin/bash
 1980  1997  1997  1980 pts/1     1997 S+       0   0:00  \_ sh -x 414ffsb
 1997  2013  1997  1980 pts/1     1997 Sl+      0 125:32      \_ ffsb ffsb.job
 1689  1690  1690  1690 pts/0     2220 Ss       0   0:00 -bash
 1690  2220  2220  1690 pts/0     2220 R+       0   0:00  \_ ps jf
    1  1524  1524  1524 tty1      1524 Ss+      0   0:00 /sbin/agetty --noclear tty1 linux
    1  1523  1523  1523 ttyS1     1523 Ss+      0   0:00 /sbin/agetty --keep-baud 115200,38400,9600 ttyS1 vt220

# lspci
00:00.0 Host bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DMI2 (rev 01)
00:01.0 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 1 (rev 01)
00:01.1 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 1 (rev 01)
00:02.0 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 2 (rev 01)
00:02.1 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 2 (rev 01)
00:02.2 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 2 (rev 01)
00:02.3 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 2 (rev 01)
00:03.0 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 3 (rev 01)
00:03.1 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 3 (rev 01)
00:03.2 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 3 (rev 01)
00:03.3 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 3 (rev 01)
00:04.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 0 (rev 01)
00:04.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 1 (rev 01)
00:04.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 2 (rev 01)
00:04.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 3 (rev 01)
00:04.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 4 (rev 01)
00:04.5 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 5 (rev 01)
00:04.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 6 (rev 01)
00:04.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 7 (rev 01)
00:05.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Map/VTd_Misc/System Management (rev 01)
00:05.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D IIO Hot Plug (rev 01)
00:05.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D IIO RAS/Control Status/Global Errors (rev 01)
00:05.4 PIC: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D I/O APIC (rev 01)
00:11.0 Unassigned class [ff00]: Intel Corporation C610/X99 series chipset SPSR (rev 05)
00:14.0 USB controller: Intel Corporation C610/X99 series chipset USB xHCI Host Controller (rev 05)
00:1a.0 USB controller: Intel Corporation C610/X99 series chipset USB Enhanced Host Controller #2 (rev 05)
00:1c.0 PCI bridge: Intel Corporation C610/X99 series chipset PCI Express Root Port #1 (rev d5)
00:1c.2 PCI bridge: Intel Corporation C610/X99 series chipset PCI Express Root Port #3 (rev d5)
00:1c.4 PCI bridge: Intel Corporation C610/X99 series chipset PCI Express Root Port #5 (rev d5)
00:1c.6 PCI bridge: Intel Corporation C610/X99 series chipset PCI Express Root Port #7 (rev d5)
00:1c.7 PCI bridge: Intel Corporation C610/X99 series chipset PCI Express Root Port #8 (rev d5)
00:1d.0 USB controller: Intel Corporation C610/X99 series chipset USB Enhanced Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation C610/X99 series chipset LPC Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation C610/X99 series chipset 6-Port SATA Controller [AHCI mode] (rev 05)
00:1f.3 SMBus: Intel Corporation C610/X99 series chipset SMBus Controller (rev 05)
01:00.0 System peripheral: Hewlett-Packard Company Integrated Lights-Out Standard Slave Instrumentation & System Support (rev 06)
01:00.1 VGA compatible controller: Matrox Electronics Systems Ltd. MGA G200EH (rev 01)
01:00.2 System peripheral: Hewlett-Packard Company Integrated Lights-Out Standard Management Processor Support and Messaging (rev 06)
01:00.4 USB controller: Hewlett-Packard Company Integrated Lights-Out Standard Virtual USB Controller (rev 03)
02:00.0 Ethernet controller: Broadcom Limited NetXtreme BCM5719 Gigabit Ethernet PCIe (rev 01)
02:00.1 Ethernet controller: Broadcom Limited NetXtreme BCM5719 Gigabit Ethernet PCIe (rev 01)
02:00.2 Ethernet controller: Broadcom Limited NetXtreme BCM5719 Gigabit Ethernet PCIe (rev 01)
02:00.3 Ethernet controller: Broadcom Limited NetXtreme BCM5719 Gigabit Ethernet PCIe (rev 01)
03:00.0 RAID bus controller: Hewlett-Packard Company Smart Array Gen9 Controllers (rev 01)
04:00.0 Ethernet controller: Broadcom Limited NetXtreme II BCM57810 10 Gigabit Ethernet (rev 10)
04:00.1 Ethernet controller: Broadcom Limited NetXtreme II BCM57810 10 Gigabit Ethernet (rev 10)
7f:08.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D QPI Link 0 (rev 01)
7f:08.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D QPI Link 0 (rev 01)
7f:09.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D QPI Link 1 (rev 01)
7f:09.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D QPI Link 1 (rev 01)
7f:0b.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D R3 QPI Link 0/1 (rev 01)
7f:0b.1 Performance counters: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D R3 QPI Link 0/1 (rev 01)
7f:0b.2 Performance counters: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D R3 QPI Link 0/1 (rev 01)
7f:0b.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D R3 QPI Link Debug (rev 01)
7f:0c.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0c.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0c.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0c.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0c.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0c.5 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0c.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0c.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0d.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0d.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0d.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0d.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0d.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0d.5 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0d.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0d.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0e.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0e.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0f.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0f.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0f.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0f.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0f.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0f.5 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:0f.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
7f:10.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D R2PCIe Agent (rev 01)
7f:10.1 Performance counters: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D R2PCIe Agent (rev 01)
7f:10.5 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Ubox (rev 01)
7f:10.6 Performance counters: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Ubox (rev 01)
7f:10.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Ubox (rev 01)
7f:12.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Home Agent 0 (rev 01)
7f:12.1 Performance counters: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Home Agent 0 (rev 01)
7f:12.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Home Agent 0 Debug (rev 01)
7f:12.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Home Agent 1 (rev 01)
7f:12.5 Performance counters: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Home Agent 1 (rev 01)
7f:12.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Home Agent 1 Debug (rev 01)
7f:13.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Target Address/Thermal/RAS (rev 01)
7f:13.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Target Address/Thermal/RAS (rev 01)
7f:13.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Channel Target Address Decoder (rev 01)
7f:13.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Channel Target Address Decoder (rev 01)
7f:13.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 0/1 Broadcast (rev 01)
7f:13.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Global Broadcast (rev 01)
7f:14.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Channel 0 Thermal Control (rev 01)
7f:14.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Channel 1 Thermal Control (rev 01)
7f:14.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Channel 0 Error (rev 01)
7f:14.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Channel 1 Error (rev 01)
7f:14.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 0/1 Interface (rev 01)
7f:14.5 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 0/1 Interface (rev 01)
7f:14.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 0/1 Interface (rev 01)
7f:14.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 0/1 Interface (rev 01)
7f:16.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Target Address/Thermal/RAS (rev 01)
7f:16.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Target Address/Thermal/RAS (rev 01)
7f:16.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Channel Target Address Decoder (rev 01)
7f:16.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Channel Target Address Decoder (rev 01)
7f:16.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 2/3 Broadcast (rev 01)
7f:16.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Global Broadcast (rev 01)
7f:17.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 1 - Channel 0 Thermal Control (rev 01)
7f:17.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 1 - Channel 1 Thermal Control (rev 01)
7f:17.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 1 - Channel 0 Error (rev 01)
7f:17.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 1 - Channel 1 Error (rev 01)
7f:17.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 2/3 Interface (rev 01)
7f:17.5 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 2/3 Interface (rev 01)
7f:17.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 2/3 Interface (rev 01)
7f:17.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 2/3 Interface (rev 01)
7f:1e.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Power Control Unit (rev 01)
7f:1e.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Power Control Unit (rev 01)
7f:1e.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Power Control Unit (rev 01)
7f:1e.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Power Control Unit (rev 01)
7f:1e.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Power Control Unit (rev 01)
7f:1f.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Power Control Unit (rev 01)
7f:1f.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Power Control Unit (rev 01)
80:00.0 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 0 (rev 01)
80:01.0 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 1 (rev 01)
80:01.1 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 1 (rev 01)
80:02.0 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 2 (rev 01)
80:02.1 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 2 (rev 01)
80:02.2 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 2 (rev 01)
80:02.3 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 2 (rev 01)
80:03.0 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 3 (rev 01)
80:03.1 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 3 (rev 01)
80:03.2 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 3 (rev 01)
80:03.3 PCI bridge: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D PCI Express Root Port 3 (rev 01)
80:04.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 0 (rev 01)
80:04.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 1 (rev 01)
80:04.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 2 (rev 01)
80:04.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 3 (rev 01)
80:04.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 4 (rev 01)
80:04.5 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 5 (rev 01)
80:04.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 6 (rev 01)
80:04.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Crystal Beach DMA Channel 7 (rev 01)
80:05.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Map/VTd_Misc/System Management (rev 01)
80:05.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D IIO Hot Plug (rev 01)
80:05.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D IIO RAS/Control Status/Global Errors (rev 01)
80:05.4 PIC: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D I/O APIC (rev 01)
ff:08.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D QPI Link 0 (rev 01)
ff:08.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D QPI Link 0 (rev 01)
ff:09.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D QPI Link 1 (rev 01)
ff:09.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D QPI Link 1 (rev 01)
ff:0b.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D R3 QPI Link 0/1 (rev 01)
ff:0b.1 Performance counters: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D R3 QPI Link 0/1 (rev 01)
ff:0b.2 Performance counters: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D R3 QPI Link 0/1 (rev 01)
ff:0b.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D R3 QPI Link Debug (rev 01)
ff:0c.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0c.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0c.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0c.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0c.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0c.5 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0c.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0c.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0d.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0d.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0d.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0d.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0d.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0d.5 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0d.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0d.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0e.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0e.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0f.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0f.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0f.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0f.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0f.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0f.5 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:0f.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Caching Agent (rev 01)
ff:10.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D R2PCIe Agent (rev 01)
ff:10.1 Performance counters: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D R2PCIe Agent (rev 01)
ff:10.5 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Ubox (rev 01)
ff:10.6 Performance counters: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Ubox (rev 01)
ff:10.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Ubox (rev 01)
ff:12.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Home Agent 0 (rev 01)
ff:12.1 Performance counters: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Home Agent 0 (rev 01)
ff:12.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Home Agent 0 Debug (rev 01)
ff:12.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Home Agent 1 (rev 01)
ff:12.5 Performance counters: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Home Agent 1 (rev 01)
ff:12.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Home Agent 1 Debug (rev 01)
ff:13.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Target Address/Thermal/RAS (rev 01)
ff:13.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Target Address/Thermal/RAS (rev 01)
ff:13.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Channel Target Address Decoder (rev 01)
ff:13.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Channel Target Address Decoder (rev 01)
ff:13.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 0/1 Broadcast (rev 01)
ff:13.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Global Broadcast (rev 01)
ff:14.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Channel 0 Thermal Control (rev 01)
ff:14.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Channel 1 Thermal Control (rev 01)
ff:14.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Channel 0 Error (rev 01)
ff:14.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 0 - Channel 1 Error (rev 01)
ff:14.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 0/1 Interface (rev 01)
ff:14.5 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 0/1 Interface (rev 01)
ff:14.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 0/1 Interface (rev 01)
ff:14.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 0/1 Interface (rev 01)
ff:16.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Target Address/Thermal/RAS (rev 01)
ff:16.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Target Address/Thermal/RAS (rev 01)
ff:16.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Channel Target Address Decoder (rev 01)
ff:16.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Channel Target Address Decoder (rev 01)
ff:16.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 2/3 Broadcast (rev 01)
ff:16.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Global Broadcast (rev 01)
ff:17.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 1 - Channel 0 Thermal Control (rev 01)
ff:17.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 1 - Channel 1 Thermal Control (rev 01)
ff:17.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 1 - Channel 0 Error (rev 01)
ff:17.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Memory Controller 1 - Channel 1 Error (rev 01)
ff:17.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 2/3 Interface (rev 01)
ff:17.5 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 2/3 Interface (rev 01)
ff:17.6 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 2/3 Interface (rev 01)
ff:17.7 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D DDRIO Channel 2/3 Interface (rev 01)
ff:1e.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Power Control Unit (rev 01)
ff:1e.1 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Power Control Unit (rev 01)
ff:1e.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Power Control Unit (rev 01)
ff:1e.3 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Power Control Unit (rev 01)
ff:1e.4 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Power Control Unit (rev 01)
ff:1f.0 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Power Control Unit (rev 01)
ff:1f.2 System peripheral: Intel Corporation Xeon E7 v4/Xeon E5 v4/Xeon E3 v4/Xeon D Power Control Unit (rev 01)

# cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-4.14.0-rc4-v414rc4-8a5776a5f498 root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/root rd.lvm.lv=fedora/swap console=ttyS1,115200N81 LANG=en_US.UTF-8

# ndctl list
[
  {
    "dev":"namespace1.0",
    "mode":"raw",
    "size":8589934592,
    "blockdev":"pmem1"
  },
  {
    "dev":"namespace3.0",
    "mode":"raw",
    "size":8589934592,
    "blockdev":"pmem3"
  },
  {
    "dev":"namespace0.0",
    "mode":"raw",
    "size":8589934592,
    "blockdev":"pmem0"
  },
  {
    "dev":"namespace2.0",
    "mode":"raw",
    "size":8589934592,
    "blockdev":"pmem2"
  }
]

# lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              72
On-line CPU(s) list: 0-71
Thread(s) per core:  2
Core(s) per socket:  18
Socket(s):           2
NUMA node(s):        2
Vendor ID:           GenuineIntel
CPU family:          6
Model:               79
Model name:          Intel(R) Xeon(R) CPU E5-2695 v4 @ 2.10GHz
Stepping:            1
CPU MHz:             2097.460
CPU max MHz:         2100.0000
CPU min MHz:         1200.0000
BogoMIPS:            4194.92
Virtualization:      VT-x
L1d cache:           32K
L1i cache:           32K
L2 cache:            256K
L3 cache:            46080K
NUMA node0 CPU(s):   0-17,36-53
NUMA node1 CPU(s):   18-35,54-71
Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb cat_l3 cdp_l3 intel_ppin intel_pt tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm cqm rdt_a rdseed adx smap xsaveopt cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local dtherm ida arat pln pts

# free -g
              total        used        free      shared  buff/cache   available
Mem:             31           0          22           0           8          30
Swap:            15           0          15

# dmesg
[    0.000000] Linux version 4.14.0-rc4-v414rc4-8a5776a5f498 (root@hp-dl380gen9-01.lab.eng.bos.redhat.com) (gcc version 7.2.1 20170915 (Red Hat 7.2.1-2) (GCC)) #40 SMP Tue Oct 10 23:53:11 EDT 2017
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.14.0-rc4-v414rc4-8a5776a5f498 root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/root rd.lvm.lv=fedora/swap console=ttyS1,115200N81 LANG=en_US.UTF-8
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000092fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093000-0x0000000000093fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000094000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006af20fff] usable
[    0.000000] BIOS-e820: [mem 0x000000006af21000-0x000000006b520fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000006b521000-0x000000006b521fff] usable
[    0.000000] BIOS-e820: [mem 0x000000006b522000-0x000000006b5a2fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000006b5a3000-0x00000000784fefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000784ff000-0x00000000791fefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000791ff000-0x000000007b5fefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b5ff000-0x000000007b7fefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b7ff000-0x000000007b7fffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000047fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000480000000-0x000000087fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000880000000-0x0000000c7fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000c80000000-0x000000107fffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x76efa018-0x76f16457] usable ==> usable
[    0.000000] e820: update [mem 0x76efa018-0x76f16457] usable ==> usable
[    0.000000] e820: update [mem 0x76ea1018-0x76ef9a57] usable ==> usable
[    0.000000] e820: update [mem 0x76ea1018-0x76ef9a57] usable ==> usable
[    0.000000] e820: update [mem 0x76e48018-0x76ea0a57] usable ==> usable
[    0.000000] e820: update [mem 0x76e48018-0x76ea0a57] usable ==> usable
[    0.000000] e820: update [mem 0x76e3f018-0x76e47057] usable ==> usable
[    0.000000] e820: update [mem 0x76e3f018-0x76e47057] usable ==> usable
[    0.000000] e820: update [mem 0x76e34018-0x76e3e257] usable ==> usable
[    0.000000] e820: update [mem 0x76e34018-0x76e3e257] usable ==> usable
[    0.000000] e820: update [mem 0x76e04018-0x76e33c57] usable ==> usable
[    0.000000] e820: update [mem 0x76e04018-0x76e33c57] usable ==> usable
[    0.000000] e820: update [mem 0x76dd4018-0x76e03c57] usable ==> usable
[    0.000000] e820: update [mem 0x76dd4018-0x76e03c57] usable ==> usable
[    0.000000] e820: update [mem 0x76da4018-0x76dd3c57] usable ==> usable
[    0.000000] e820: update [mem 0x76da4018-0x76dd3c57] usable ==> usable
[    0.000000] e820: update [mem 0x76d74018-0x76da3c57] usable ==> usable
[    0.000000] e820: update [mem 0x76d74018-0x76da3c57] usable ==> usable
[    0.000000] e820: update [mem 0x76d6e018-0x76d73457] usable ==> usable
[    0.000000] e820: update [mem 0x76d6e018-0x76d73457] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x0000000000092fff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000093000-0x0000000000093fff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000094000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x000000006af20fff] usable
[    0.000000] reserve setup_data: [mem 0x000000006af21000-0x000000006b520fff] reserved
[    0.000000] reserve setup_data: [mem 0x000000006b521000-0x000000006b521fff] usable
[    0.000000] reserve setup_data: [mem 0x000000006b522000-0x000000006b5a2fff] reserved
[    0.000000] reserve setup_data: [mem 0x000000006b5a3000-0x0000000076d6e017] usable
[    0.000000] reserve setup_data: [mem 0x0000000076d6e018-0x0000000076d73457] usable
[    0.000000] reserve setup_data: [mem 0x0000000076d73458-0x0000000076d74017] usable
[    0.000000] reserve setup_data: [mem 0x0000000076d74018-0x0000000076da3c57] usable
[    0.000000] reserve setup_data: [mem 0x0000000076da3c58-0x0000000076da4017] usable
[    0.000000] reserve setup_data: [mem 0x0000000076da4018-0x0000000076dd3c57] usable
[    0.000000] reserve setup_data: [mem 0x0000000076dd3c58-0x0000000076dd4017] usable
[    0.000000] reserve setup_data: [mem 0x0000000076dd4018-0x0000000076e03c57] usable
[    0.000000] reserve setup_data: [mem 0x0000000076e03c58-0x0000000076e04017] usable
[    0.000000] reserve setup_data: [mem 0x0000000076e04018-0x0000000076e33c57] usable
[    0.000000] reserve setup_data: [mem 0x0000000076e33c58-0x0000000076e34017] usable
[    0.000000] reserve setup_data: [mem 0x0000000076e34018-0x0000000076e3e257] usable
[    0.000000] reserve setup_data: [mem 0x0000000076e3e258-0x0000000076e3f017] usable
[    0.000000] reserve setup_data: [mem 0x0000000076e3f018-0x0000000076e47057] usable
[    0.000000] reserve setup_data: [mem 0x0000000076e47058-0x0000000076e48017] usable
[    0.000000] reserve setup_data: [mem 0x0000000076e48018-0x0000000076ea0a57] usable
[    0.000000] reserve setup_data: [mem 0x0000000076ea0a58-0x0000000076ea1017] usable
[    0.000000] reserve setup_data: [mem 0x0000000076ea1018-0x0000000076ef9a57] usable
[    0.000000] reserve setup_data: [mem 0x0000000076ef9a58-0x0000000076efa017] usable
[    0.000000] reserve setup_data: [mem 0x0000000076efa018-0x0000000076f16457] usable
[    0.000000] reserve setup_data: [mem 0x0000000076f16458-0x00000000784fefff] usable
[    0.000000] reserve setup_data: [mem 0x00000000784ff000-0x00000000791fefff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000791ff000-0x000000007b5fefff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000007b5ff000-0x000000007b7fefff] ACPI data
[    0.000000] reserve setup_data: [mem 0x000000007b7ff000-0x000000007b7fffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000080000000-0x000000008fffffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000047fffffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000480000000-0x000000087fffffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000880000000-0x0000000c7fffffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000c80000000-0x000000107fffffff] reserved
[    0.000000] efi: EFI v2.40 by HP
[    0.000000] efi:  ACPI=0x7b7fe000  ACPI 2.0=0x7b7fe014  SMBIOS=0x788db000 
[    0.000000] random: fast init done
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 10/05/2016
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xc80000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000080000000 mask 3FFF80000000 uncachable
[    0.000000]   1 base 001080000000 mask 3FFF80000000 uncachable
[    0.000000]   2 base 008000000000 mask 3F8000000000 uncachable
[    0.000000]   3 base 010000000000 mask 3F0000000000 uncachable
[    0.000000]   4 base 038000000000 mask 3FC000000000 uncachable
[    0.000000]   5 base 00007C000000 mask 3FFFFC000000 uncachable
[    0.000000]   6 base 00007FC00000 mask 3FFFFFC00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.000000] e820: last_pfn = 0x7b800 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff888d00099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x2016e2000, 0x2016e2fff] PGTABLE
[    0.000000] BRK [0x2016e3000, 0x2016e3fff] PGTABLE
[    0.000000] BRK [0x2016e4000, 0x2016e4fff] PGTABLE
[    0.000000] BRK [0x2016e5000, 0x2016e5fff] PGTABLE
[    0.000000] BRK [0x2016e6000, 0x2016e6fff] PGTABLE
[    0.000000] BRK [0x2016e7000, 0x2016e7fff] PGTABLE
[    0.000000] BRK [0x2016e8000, 0x2016e8fff] PGTABLE
[    0.000000] BRK [0x2016e9000, 0x2016e9fff] PGTABLE
[    0.000000] BRK [0x2016ea000, 0x2016eafff] PGTABLE
[    0.000000] Secure boot disabled
[    0.000000] RAMDISK: [mem 0x200e6000-0x2386cfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000000007B7FE014 000024 (v02 HP    )
[    0.000000] ACPI: XSDT 0x000000007B7E8188 000104 (v01 HP     ProLiant 00000001      01000013)
[    0.000000] ACPI: FACP 0x000000007B7F5000 00010C (v05 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: DSDT 0x000000007B7D7000 00F28B (v02 HP     DSDT     00000002 HPAG 00020000)
[    0.000000] ACPI: FACS 0x000000007B4A0000 000040
[    0.000000] ACPI: UEFI 0x000000007B4D9000 000042 (v01 HP     ProLiant 00000002      01000013)
[    0.000000] ACPI: MCEJ 0x000000007B7FC000 000130 (v01 HP     ProLiant 00000001 INTL 0100000D)
[    0.000000] ACPI: SSDT 0x000000007B7FB000 000064 (v02 HP     SpsNvs   00000002 INTL 20130328)
[    0.000000] ACPI: HEST 0x000000007B7FA000 0000A8 (v01 HP     ProLiant 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 0x000000007B7F9000 000030 (v01 HP     ProLiant 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 0x000000007B7F8000 000230 (v01 HP     ProLiant 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 0x000000007B7F7000 000150 (v01 HP     ProLiant 00000001 INTL 00000001)
[    0.000000] ACPI: BGRT 0x000000007B7F6000 000038 (v01 HP     ProLiant 00000002 HP   01000013)
[    0.000000] ACPI: HPET 0x000000007B7F4000 000038 (v01 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: PMCT 0x000000007B7F3000 000064 (v01 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: WDDT 0x000000007B7F2000 000040 (v01 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: APIC 0x000000007B7F1000 00084A (v03 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: MCFG 0x000000007B7F0000 00003C (v01 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: SLIT 0x000000007B7EF000 000030 (v01 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: SRAT 0x000000007B7EE000 000740 (v03 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: SPMI 0x000000007B7ED000 000041 (v05 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: RASF 0x000000007B7EC000 000030 (v01 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: SPCR 0x000000007B7EB000 000050 (v01 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: MSCT 0x000000007B7EA000 000064 (v01 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: BDAT 0x000000007B7E9000 000030 (v01 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: PCCT 0x000000007B7FD000 00006E (v01 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: DMAR 0x000000007B7E7000 000244 (v01 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: SSDT 0x000000007B7D0000 006FBE (v02 HP     PCISSDT  00000002 HPAG 00020000)
[    0.000000] ACPI: SSDT 0x000000007B7CF000 0001CB (v02 HP     TIMESSDT 00000002 HPAG 00020000)
[    0.000000] ACPI: NFIT 0x000000007B7CE000 000308 (v01 HP     ProLiant 00000001 HP   00000001)
[    0.000000] ACPI: SSDT 0x000000007B7C9000 004484 (v02 HP     HPNVDIMM 00000002 HPAG 00020000)
[    0.000000] ACPI: SSDT 0x000000007B7C8000 0002F2 (v01 HP     pmab     00000001 INTL 20130328)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x0000 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0002 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0004 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0006 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0008 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0010 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0012 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0014 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0016 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0020 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0022 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0024 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0026 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0028 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0030 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0032 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0034 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0036 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x0040 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0042 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0044 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0046 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0048 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0050 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0052 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0054 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0056 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0060 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0062 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0064 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0066 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0068 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0070 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0072 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0074 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0076 -> Node 1
[    0.000000] SRAT: PXM 0 -> APIC 0x0001 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0003 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0005 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0007 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0009 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0011 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0013 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0015 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0017 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0021 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0023 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0025 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0027 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0029 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0031 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0033 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0035 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0037 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x0041 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0043 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0045 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0047 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0049 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0051 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0053 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0055 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0057 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0061 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0063 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0065 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0067 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0069 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0071 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0073 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0075 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0077 -> Node 1
[    0.000000] ACPI: SRAT: Node 0 PXM 0 [mem 0x00000000-0x47fffffff]
[    0.000000] ACPI: SRAT: Node 1 PXM 1 [mem 0x880000000-0xc7fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NODE_DATA(0) allocated [mem 0x47ffd5000-0x47fffffff]
[    0.000000] NODE_DATA(1) allocated [mem 0xc7ffd4000-0xc7fffefff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x0000000c7fffffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000092fff]
[    0.000000]   node   0: [mem 0x0000000000094000-0x000000000009ffff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000006af20fff]
[    0.000000]   node   0: [mem 0x000000006b521000-0x000000006b521fff]
[    0.000000]   node   0: [mem 0x000000006b5a3000-0x00000000784fefff]
[    0.000000]   node   0: [mem 0x000000007b7ff000-0x000000007b7fffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000047fffffff]
[    0.000000]   node   1: [mem 0x0000000880000000-0x0000000c7fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000047fffffff]
[    0.000000] On node 0 totalpages: 4161053
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7610 pages used for memmap
[    0.000000]   DMA32 zone: 487039 pages, LIFO batch:31
[    0.000000]   Normal zone: 57344 pages used for memmap
[    0.000000]   Normal zone: 3670016 pages, LIFO batch:31
[    0.000000] Initmem setup node 1 [mem 0x0000000880000000-0x0000000c7fffffff]
[    0.000000] On node 1 totalpages: 4194304
[    0.000000]   Normal zone: 65536 pages used for memmap
[    0.000000]   Normal zone: 4194304 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: X2APIC_NMI (uid[0x00] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x01] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x02] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x03] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x04] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x05] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x06] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x07] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x08] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x09] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x10] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x11] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x12] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x13] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x14] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x15] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x16] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x17] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x20] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x21] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x22] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x23] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x24] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x25] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x26] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x27] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x28] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x29] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x30] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x31] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x32] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x33] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x34] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x35] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x36] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x37] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x40] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x41] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x42] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x43] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x44] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x45] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x46] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x47] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x48] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x49] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x50] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x51] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x52] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x53] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x54] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x55] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x56] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x57] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x60] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x61] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x62] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x63] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x64] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x65] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x66] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x67] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x68] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x69] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x70] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x71] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x72] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x73] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x74] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x75] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x76] high level lint[0x1])
[    0.000000] ACPI: X2APIC_NMI (uid[0x77] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec40000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] [Firmware Bug]: TSC_DEADLINE disabled due to Errata; please update microcode to version: 0xb000020 (or later)
[    0.000000] smpboot: Allowing 72 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00093000-0x00093fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x6af21000-0x6b520fff]
[    0.000000] PM: Registered nosave memory: [mem 0x6b522000-0x6b5a2fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76d6e000-0x76d6efff]
[    0.000000] PM: Registered nosave memory: [mem 0x76d73000-0x76d73fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76d74000-0x76d74fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76da3000-0x76da3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76da4000-0x76da4fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76dd3000-0x76dd3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76dd4000-0x76dd4fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e03000-0x76e03fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e04000-0x76e04fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e33000-0x76e33fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e34000-0x76e34fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e3e000-0x76e3efff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e3f000-0x76e3ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e47000-0x76e47fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e48000-0x76e48fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76ea0000-0x76ea0fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76ea1000-0x76ea1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76ef9000-0x76ef9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76efa000-0x76efafff]
[    0.000000] PM: Registered nosave memory: [mem 0x76f16000-0x76f16fff]
[    0.000000] PM: Registered nosave memory: [mem 0x784ff000-0x791fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x791ff000-0x7b5fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b5ff000-0x7b7fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b800000-0x7fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x80000000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xffffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x480000000-0x87fffffff]
[    0.000000] e820: [mem 0x90000000-0xffffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:72 nr_cpu_ids:72 nr_node_ids:2
[    0.000000] percpu: Embedded 487 pages/cpu @ffff88916b600000 s1954528 r8192 d32032 u2097152
[    0.000000] pcpu-alloc: s1954528 r8192 d32032 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07 
[    0.000000] pcpu-alloc: [0] 08 [0] 09 [0] 10 [0] 11 [0] 12 [0] 13 [0] 14 [0] 15 
[    0.000000] pcpu-alloc: [0] 16 [0] 17 [0] 36 [0] 37 [0] 38 [0] 39 [0] 40 [0] 41 
[    0.000000] pcpu-alloc: [0] 42 [0] 43 [0] 44 [0] 45 [0] 46 [0] 47 [0] 48 [0] 49 
[    0.000000] pcpu-alloc: [0] 50 [0] 51 [0] 52 [0] 53 [1] 18 [1] 19 [1] 20 [1] 21 
[    0.000000] pcpu-alloc: [1] 22 [1] 23 [1] 24 [1] 25 [1] 26 [1] 27 [1] 28 [1] 29 
[    0.000000] pcpu-alloc: [1] 30 [1] 31 [1] 32 [1] 33 [1] 34 [1] 35 [1] 54 [1] 55 
[    0.000000] pcpu-alloc: [1] 56 [1] 57 [1] 58 [1] 59 [1] 60 [1] 61 [1] 62 [1] 63 
[    0.000000] pcpu-alloc: [1] 64 [1] 65 [1] 66 [1] 67 [1] 68 [1] 69 [1] 70 [1] 71 
[    0.000000] Built 2 zonelists, mobility grouping on.  Total pages: 8224781
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.14.0-rc4-v414rc4-8a5776a5f498 root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/root rd.lvm.lv=fedora/swap console=ttyS1,115200N81 LANG=en_US.UTF-8
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 290816 bytes
[    0.000000] log_buf_len min size: 262144 bytes
[    0.000000] log_buf_len: 1048576 bytes
[    0.000000] early log buf free: 233596(89%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 32418808K/33421428K available (9967K kernel code, 3757K rwdata, 4056K rodata, 4720K init, 16844K bss, 1002620K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=72, Nodes=2
[    0.000000] ftrace: allocating 35570 entries in 139 pages
[    0.000000] Running RCU self tests
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=72.
[    0.000000] 	RCU callback double-/use-after-free debug enabled.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=72
[    0.000000] NR_IRQS: 524544, nr_irqs: 1816, preallocated irqs: 16
[    0.000000] ODEBUG: Out of memory. ODEBUG disabled
[    0.000000] 	Offload RCU callbacks from CPUs: .
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [ttyS1] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 7903 kB
[    0.000000]  per task-struct memory footprint: 3072 bytes
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.001000] tsc: Detected 2097.460 MHz processor
[    0.002000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4194.92 BogoMIPS (lpj=2097460)
[    0.003004] pid_max: default: 73728 minimum: 576
[    0.004056] ACPI: Core revision 20170728
[    0.016442] ACPI: 6 ACPI AML tables successfully acquired and loaded
[    0.018007] ---[ User Space ]---
[    0.019004] 0x0000000000000000-0x0000000000001000           4K     RW                 GLB x  pte
[    0.020006] 0x0000000000001000-0x0000000000200000        2044K                               pte
[    0.021007] 0x0000000000200000-0x000000003ec00000        1002M                               pmd
[    0.022005] 0x000000003ec00000-0x000000003ed00000           1M                               pte
[    0.023005] 0x000000003ed00000-0x000000003ed80000         512K     RW                 GLB x  pte
[    0.024004] 0x000000003ed80000-0x000000003ee00000         512K                               pte
[    0.025006] 0x000000003ee00000-0x000000006b400000         710M                               pmd
[    0.026005] 0x000000006b400000-0x000000006b521000        1156K                               pte
[    0.027005] 0x000000006b521000-0x000000006b600000         892K     RW                 GLB x  pte
[    0.028004] 0x000000006b600000-0x000000006ec00000          54M     RW         PSE         x  pmd
[    0.029005] 0x000000006ec00000-0x000000006ecfc000        1008K     RW                 GLB x  pte
[    0.030005] 0x000000006ecfc000-0x000000006ee00000        1040K                               pte
[    0.031004] 0x000000006ee00000-0x0000000070800000          26M                               pmd
[    0.032005] 0x0000000070800000-0x0000000070903000        1036K                               pte
[    0.033004] 0x0000000070903000-0x00000000709b5000         712K     RW                 GLB x  pte
[    0.034004] 0x00000000709b5000-0x00000000709b7000           8K                               pte
[    0.035004] 0x00000000709b7000-0x00000000709b9000           8K     RW                 GLB x  pte
[    0.036004] 0x00000000709b9000-0x00000000709bd000          16K                               pte
[    0.037004] 0x00000000709bd000-0x00000000709be000           4K     RW                 GLB x  pte
[    0.038004] 0x00000000709be000-0x00000000709c0000           8K                               pte
[    0.039004] 0x00000000709c0000-0x00000000709c1000           4K     RW                 GLB x  pte
[    0.040004] 0x00000000709c1000-0x00000000709c2000           4K                               pte
[    0.041004] 0x00000000709c2000-0x00000000709c3000           4K     RW                 GLB x  pte
[    0.042004] 0x00000000709c3000-0x00000000709c7000          16K                               pte
[    0.043004] 0x00000000709c7000-0x0000000070a00000         228K     RW                 GLB x  pte
[    0.044004] 0x0000000070a00000-0x0000000072c00000          34M     RW         PSE         x  pmd
[    0.045004] 0x0000000072c00000-0x0000000072c4b000         300K     RW                 GLB x  pte
[    0.046004] 0x0000000072c4b000-0x0000000072c4f000          16K                               pte
[    0.047006] 0x0000000072c4f000-0x0000000072e00000        1732K     RW                 GLB x  pte
[    0.048004] 0x0000000072e00000-0x0000000076c00000          62M     RW         PSE         x  pmd
[    0.049005] 0x0000000076c00000-0x0000000076cff000        1020K     RW                 GLB x  pte
[    0.050005] 0x0000000076cff000-0x0000000076e00000        1028K                               pte
[    0.051004] 0x0000000076e00000-0x0000000077800000          10M                               pmd
[    0.052005] 0x0000000077800000-0x00000000778a7000         668K                               pte
[    0.053005] 0x00000000778a7000-0x0000000077a00000        1380K     RW                 GLB x  pte
[    0.054004] 0x0000000077a00000-0x0000000078400000          10M     RW         PSE         x  pmd
[    0.055006] 0x0000000078400000-0x0000000078600000           2M     RW                 GLB x  pte
[    0.056004] 0x0000000078600000-0x0000000078800000           2M     RW         PSE         x  pmd
[    0.057006] 0x0000000078800000-0x0000000078a00000           2M     RW                 GLB x  pte
[    0.058004] 0x0000000078a00000-0x0000000079000000           6M     RW         PSE         x  pmd
[    0.059005] 0x0000000079000000-0x00000000790ff000        1020K     RW                 GLB x  pte
[    0.060005] 0x00000000790ff000-0x0000000079200000        1028K                               pte
[    0.061004] 0x0000000079200000-0x000000007b600000          36M                               pmd
[    0.062006] 0x000000007b600000-0x000000007b7ff000        2044K                               pte
[    0.063004] 0x000000007b7ff000-0x000000007b800000           4K     RW                 GLB x  pte
[    0.064004] 0x000000007b800000-0x0000000080000000          72M                               pmd
[    0.065006] 0x0000000080000000-0x0000000090000000         256M     RW     PCD PSE         x  pmd
[    0.066006] 0x0000000090000000-0x00000000c0000000         768M                               pmd
[    0.067004] 0x00000000c0000000-0x0000000c40000000          46G                               pud
[    0.068006] 0x0000000c40000000-0x0000000c6a800000         680M                               pmd
[    0.069004] 0x0000000c6a800000-0x0000000c6a842000         264K                               pte
[    0.070004] 0x0000000c6a842000-0x0000000c6a844000           8K     RW                 GLB NX pte
[    0.071006] 0x0000000c6a844000-0x0000000c6aa00000        1776K                               pte
[    0.072005] 0x0000000c6aa00000-0x0000000c80000000         342M                               pmd
[    0.073007] 0x0000000c80000000-0x0000008000000000         462G                               pud
[    0.074010] 0x0000008000000000-0xffff800000000000   17179737600G                               pgd
[    0.075004] ---[ Kernel Space ]---
[    0.076004] 0xffff800000000000-0xffff808000000000         512G                               pgd
[    0.077003] ---[ Low Kernel Mapping ]---
[    0.078004] 0xffff808000000000-0xffff810000000000         512G                               pgd
[    0.079003] ---[ vmalloc() Area ]---
[    0.080004] 0xffff810000000000-0xffff818000000000         512G                               pgd
[    0.081003] ---[ Vmemmap ]---
[    0.082004] 0xffff818000000000-0xffff888000000000           7T                               pgd
[    0.083004] 0xffff888000000000-0xffff888d00000000          52G                               pud
[    0.084006] 0xffff888d00000000-0xffff888d00200000           2M     RW                 GLB NX pte
[    0.085010] 0xffff888d00200000-0xffff888d6ae00000        1708M     RW         PSE     GLB NX pmd
[    0.086005] 0xffff888d6ae00000-0xffff888d6af21000        1156K     RW                 GLB NX pte
[    0.087005] 0xffff888d6af21000-0xffff888d6b000000         892K                               pte
[    0.088004] 0xffff888d6b000000-0xffff888d6b400000           4M                               pmd
[    0.089005] 0xffff888d6b400000-0xffff888d6b521000        1156K                               pte
[    0.090004] 0xffff888d6b521000-0xffff888d6b522000           4K     RW                 GLB NX pte
[    0.091004] 0xffff888d6b522000-0xffff888d6b5a3000         516K                               pte
[    0.092004] 0xffff888d6b5a3000-0xffff888d6b600000         372K     RW                 GLB NX pte
[    0.093004] 0xffff888d6b600000-0xffff888d78400000         206M     RW         PSE     GLB NX pmd
[    0.094005] 0xffff888d78400000-0xffff888d784ff000        1020K     RW                 GLB NX pte
[    0.095005] 0xffff888d784ff000-0xffff888d78600000        1028K                               pte
[    0.096004] 0xffff888d78600000-0xffff888d7b600000          48M                               pmd
[    0.097006] 0xffff888d7b600000-0xffff888d7b7ff000        2044K                               pte
[    0.098004] 0xffff888d7b7ff000-0xffff888d7b800000           4K     RW                 GLB NX pte
[    0.099004] 0xffff888d7b800000-0xffff888d80000000          72M                               pmd
[    0.100004] 0xffff888d80000000-0xffff888e00000000           2G                               pud
[    0.101004] 0xffff888e00000000-0xffff889180000000          14G     RW         PSE     GLB NX pud
[    0.102004] 0xffff889180000000-0xffff889580000000          16G                               pud
[    0.103004] 0xffff889580000000-0xffff889980000000          16G     RW         PSE     GLB NX pud
[    0.104006] 0xffff889980000000-0xffff890000000000         410G                               pud
[    0.105006] 0xffff890000000000-0xffffb80000000000          47T                               pgd
[    0.106004] 0xffffb80000000000-0xffffb80740000000          29G                               pud
[    0.107004] 0xffffb80740000000-0xffffb80740001000           4K     RW     PCD         GLB NX pte
[    0.108004] 0xffffb80740001000-0xffffb80740002000           4K                               pte
[    0.109004] 0xffffb80740002000-0xffffb80740003000           4K     RW                 GLB NX pte
[    0.110004] 0xffffb80740003000-0xffffb80740004000           4K                               pte
[    0.111004] 0xffffb80740004000-0xffffb80740005000           4K     RW                 GLB NX pte
[    0.112004] 0xffffb80740005000-0xffffb80740006000           4K                               pte
[    0.113004] 0xffffb80740006000-0xffffb80740007000           4K     RW                 GLB NX pte
[    0.114004] 0xffffb80740007000-0xffffb80740008000           4K                               pte
[    0.115004] 0xffffb80740008000-0xffffb80740009000           4K     RW                 GLB NX pte
[    0.116004] 0xffffb80740009000-0xffffb8074000a000           4K                               pte
[    0.117004] 0xffffb8074000a000-0xffffb8074000b000           4K     RW                 GLB NX pte
[    0.118004] 0xffffb8074000b000-0xffffb8074000c000           4K                               pte
[    0.119004] 0xffffb8074000c000-0xffffb8074000d000           4K     RW                 GLB NX pte
[    0.120004] 0xffffb8074000d000-0xffffb8074000e000           4K                               pte
[    0.121004] 0xffffb8074000e000-0xffffb8074000f000           4K     RW                 GLB NX pte
[    0.122004] 0xffffb8074000f000-0xffffb80740010000           4K                               pte
[    0.123004] 0xffffb80740010000-0xffffb80740020000          64K     RW                 GLB NX pte
[    0.124004] 0xffffb80740020000-0xffffb80740021000           4K                               pte
[    0.125004] 0xffffb80740021000-0xffffb80740022000           4K     RW                 GLB NX pte
[    0.126004] 0xffffb80740022000-0xffffb80740023000           4K                               pte
[    0.127004] 0xffffb80740023000-0xffffb80740024000           4K     RW                 GLB NX pte
[    0.128004] 0xffffb80740024000-0xffffb80740025000           4K                               pte
[    0.129004] 0xffffb80740025000-0xffffb80740026000           4K     RW                 GLB NX pte
[    0.130004] 0xffffb80740026000-0xffffb80740027000           4K                               pte
[    0.131004] 0xffffb80740027000-0xffffb80740028000           4K     RW                 GLB NX pte
[    0.132004] 0xffffb80740028000-0xffffb80740029000           4K                               pte
[    0.133004] 0xffffb80740029000-0xffffb8074002a000           4K     RW                 GLB NX pte
[    0.134004] 0xffffb8074002a000-0xffffb8074002b000           4K                               pte
[    0.135004] 0xffffb8074002b000-0xffffb8074002c000           4K     RW                 GLB NX pte
[    0.136004] 0xffffb8074002c000-0xffffb8074002d000           4K                               pte
[    0.137004] 0xffffb8074002d000-0xffffb8074002e000           4K     RW                 GLB NX pte
[    0.138004] 0xffffb8074002e000-0xffffb8074002f000           4K                               pte
[    0.139004] 0xffffb8074002f000-0xffffb80740030000           4K     RW                 GLB NX pte
[    0.140004] 0xffffb80740030000-0xffffb80740031000           4K                               pte
[    0.141004] 0xffffb80740031000-0xffffb80740032000           4K     RW                 GLB NX pte
[    0.142004] 0xffffb80740032000-0xffffb80740033000           4K                               pte
[    0.143004] 0xffffb80740033000-0xffffb80740034000           4K     RW                 GLB NX pte
[    0.144004] 0xffffb80740034000-0xffffb80740035000           4K                               pte
[    0.145004] 0xffffb80740035000-0xffffb80740036000           4K     RW                 GLB NX pte
[    0.146004] 0xffffb80740036000-0xffffb80740037000           4K                               pte
[    0.147004] 0xffffb80740037000-0xffffb80740038000           4K     RW                 GLB NX pte
[    0.149004] 0xffffb80740038000-0xffffb80740039000           4K                               pte
[    0.150004] 0xffffb80740039000-0xffffb8074003a000           4K     RW                 GLB NX pte
[    0.151004] 0xffffb8074003a000-0xffffb8074003b000           4K                               pte
[    0.152004] 0xffffb8074003b000-0xffffb8074003c000           4K     RW                 GLB NX pte
[    0.153004] 0xffffb8074003c000-0xffffb8074003d000           4K                               pte
[    0.154004] 0xffffb8074003d000-0xffffb8074003e000           4K     RW                 GLB NX pte
[    0.155004] 0xffffb8074003e000-0xffffb8074003f000           4K                               pte
[    0.156004] 0xffffb8074003f000-0xffffb80740040000           4K     RW                 GLB NX pte
[    0.157004] 0xffffb80740040000-0xffffb80740041000           4K                               pte
[    0.158004] 0xffffb80740041000-0xffffb80740042000           4K     RW                 GLB NX pte
[    0.159004] 0xffffb80740042000-0xffffb80740043000           4K                               pte
[    0.160004] 0xffffb80740043000-0xffffb80740044000           4K     RW                 GLB NX pte
[    0.161004] 0xffffb80740044000-0xffffb80740045000           4K                               pte
[    0.162004] 0xffffb80740045000-0xffffb80740046000           4K     RW                 GLB NX pte
[    0.163004] 0xffffb80740046000-0xffffb80740048000           8K                               pte
[    0.164004] 0xffffb80740048000-0xffffb8074004f000          28K     RW                 GLB NX pte
[    0.165004] 0xffffb8074004f000-0xffffb80740050000           4K                               pte
[    0.166004] 0xffffb80740050000-0xffffb80740055000          20K     RW                 GLB NX pte
[    0.167004] 0xffffb80740055000-0xffffb80740056000           4K                               pte
[    0.168004] 0xffffb80740056000-0xffffb80740057000           4K     RW                 GLB NX pte
[    0.169006] 0xffffb80740057000-0xffffb80740200000        1700K                               pte
[    0.170006] 0xffffb80740200000-0xffffb80780000000        1022M                               pmd
[    0.171007] 0xffffb80780000000-0xffffb88000000000         482G                               pud
[    0.172005] 0xffffb88000000000-0xffffde0000000000       38400G                               pgd
[    0.173007] 0xffffde0000000000-0xffffde7400000000         464G                               pud
[    0.174004] 0xffffde7400000000-0xffffde7402000000          32M     RW         PSE     GLB NX pmd
[    0.176006] 0xffffde7402000000-0xffffde7404000000          32M                               pmd
[    0.177004] 0xffffde7404000000-0xffffde7412000000         224M     RW         PSE     GLB NX pmd
[    0.178004] 0xffffde7412000000-0xffffde7422000000         256M                               pmd
[    0.179004] 0xffffde7422000000-0xffffde7432000000         256M     RW         PSE     GLB NX pmd
[    0.180004] 0xffffde7432000000-0xffffde7440000000         224M                               pmd
[    0.181004] 0xffffde7440000000-0xffffde8000000000          47G                               pud
[    0.182005] 0xffffde8000000000-0xffffff0000000000       33280G                               pgd
[    0.183004] ---[ ESPfix Area ]---
[    0.184004] 0xffffff0000000000-0xffffff8000000000         512G                               pgd
[    0.185006] 0xffffff8000000000-0xffffffef00000000         444G                               pud
[    0.186003] ---[ EFI Runtime Services ]---
[    0.187004] 0xffffffef00000000-0xfffffffec0000000          63G                               pud
[    0.188005] 0xfffffffec0000000-0xfffffffee4600000         582M                               pmd
[    0.189005] 0xfffffffee4600000-0xfffffffee4700000           1M                               pte
[    0.190004] 0xfffffffee4700000-0xfffffffee4780000         512K     RW                 GLB x  pte
[    0.191006] 0xfffffffee4780000-0xfffffffee4921000        1668K                               pte
[    0.192005] 0xfffffffee4921000-0xfffffffee4a00000         892K     RW                 GLB x  pte
[    0.193005] 0xfffffffee4a00000-0xfffffffee8000000          54M     RW         PSE         x  pmd
[    0.194005] 0xfffffffee8000000-0xfffffffee80fc000        1008K     RW                 GLB x  pte
[    0.195004] 0xfffffffee80fc000-0xfffffffee8103000          28K                               pte
[    0.196004] 0xfffffffee8103000-0xfffffffee81b5000         712K     RW                 GLB x  pte
[    0.197004] 0xfffffffee81b5000-0xfffffffee81b7000           8K                               pte
[    0.198004] 0xfffffffee81b7000-0xfffffffee81b9000           8K     RW                 GLB x  pte
[    0.199004] 0xfffffffee81b9000-0xfffffffee81bd000          16K                               pte
[    0.200004] 0xfffffffee81bd000-0xfffffffee81be000           4K     RW                 GLB x  pte
[    0.201004] 0xfffffffee81be000-0xfffffffee81c0000           8K                               pte
[    0.202004] 0xfffffffee81c0000-0xfffffffee81c1000           4K     RW                 GLB x  pte
[    0.203004] 0xfffffffee81c1000-0xfffffffee81c2000           4K                               pte
[    0.205004] 0xfffffffee81c2000-0xfffffffee81c3000           4K     RW                 GLB x  pte
[    0.206004] 0xfffffffee81c3000-0xfffffffee81c7000          16K                               pte
[    0.207004] 0xfffffffee81c7000-0xfffffffee8200000         228K     RW                 GLB x  pte
[    0.208004] 0xfffffffee8200000-0xfffffffeea400000          34M     RW         PSE         x  pmd
[    0.209004] 0xfffffffeea400000-0xfffffffeea44b000         300K     RW                 GLB x  pte
[    0.210004] 0xfffffffeea44b000-0xfffffffeea44f000          16K                               pte
[    0.211006] 0xfffffffeea44f000-0xfffffffeea600000        1732K     RW                 GLB x  pte
[    0.212004] 0xfffffffeea600000-0xfffffffeee400000          62M     RW         PSE         x  pmd
[    0.213005] 0xfffffffeee400000-0xfffffffeee4ff000        1020K     RW                 GLB x  pte
[    0.214006] 0xfffffffeee4ff000-0xfffffffeee6a7000        1696K                               pte
[    0.215005] 0xfffffffeee6a7000-0xfffffffeee800000        1380K     RW                 GLB x  pte
[    0.216004] 0xfffffffeee800000-0xfffffffeef200000          10M     RW         PSE         x  pmd
[    0.217006] 0xfffffffeef200000-0xfffffffeef400000           2M     RW                 GLB x  pte
[    0.218004] 0xfffffffeef400000-0xfffffffeef600000           2M     RW         PSE         x  pmd
[    0.219006] 0xfffffffeef600000-0xfffffffeef800000           2M     RW                 GLB x  pte
[    0.220004] 0xfffffffeef800000-0xfffffffeefe00000           6M     RW         PSE         x  pmd
[    0.221005] 0xfffffffeefe00000-0xfffffffeefeff000        1020K     RW                 GLB x  pte
[    0.222005] 0xfffffffeefeff000-0xfffffffeeffff000           1M                               pte
[    0.223004] 0xfffffffeeffff000-0xfffffffef0000000           4K     RW                 GLB x  pte
[    0.224005] 0xfffffffef0000000-0xffffffff00000000         256M     RW     PCD PSE         x  pmd
[    0.225004] 0xffffffff00000000-0xffffffff80000000           2G                               pud
[    0.226004] ---[ High Kernel Mapping ]---
[    0.227004] 0xffffffff80000000-0xffffffff87000000         112M                               pmd
[    0.228004] 0xffffffff87000000-0xffffffff89800000          40M     RW         PSE     GLB x  pmd
[    0.229006] 0xffffffff89800000-0xffffffffc0000000         872M                               pmd
[    0.231004] ---[ Modules ]---
[    0.232005] 0xffffffffc0000000-0xfffffffffd200000         978M                               pmd
[    0.233003] ---[ End Modules ]---
[    0.234006] 0xfffffffffd200000-0xfffffffffd400000           2M                               pte
[    0.235004] 0xfffffffffd400000-0xffffffffff400000          32M                               pmd
[    0.236005] 0xffffffffff400000-0xffffffffff577000        1500K                               pte
[    0.237004] 0xffffffffff577000-0xffffffffff578000           4K     ro                 GLB NX pte
[    0.238004] 0xffffffffff578000-0xffffffffff57b000          12K                               pte
[    0.239004] 0xffffffffff57b000-0xffffffffff57c000           4K     ro                 GLB NX pte
[    0.240004] 0xffffffffff57c000-0xffffffffff5f9000         500K                               pte
[    0.241004] 0xffffffffff5f9000-0xffffffffff5fd000          16K     RW PWT PCD         GLB NX pte
[    0.242004] 0xffffffffff5fd000-0xffffffffff600000          12K                               pte
[    0.243004] 0xffffffffff600000-0xffffffffff601000           4K USR ro                 GLB NX pte
[    0.244006] 0xffffffffff601000-0xffffffffff800000        2044K                               pte
[    0.245004] 0xffffffffff800000-0x0000000000000000           8M                               pmd
[    0.246242] Security Framework initialized
[    0.247008] Yama: becoming mindful.
[    0.248017] SELinux:  Initializing.
[    0.249091] SELinux:  Starting in permissive mode
[    0.260805] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.266960] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.267218] Mount-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.268185] Mountpoint-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.270651] CPU: Physical Processor ID: 0
[    0.271008] CPU: Processor Core ID: 0
[    0.272013] mce: CPU supports 22 MCE banks
[    0.273026] CPU0: Thermal monitoring enabled (TM1)
[    0.274059] process: using mwait in idle threads
[    0.275008] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.276006] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.285066] Freeing SMP alternatives memory: 32K
[    0.305569] smpboot: Max logical packages: 4
[    0.306165] DMAR: Host address width 46
[    0.307008] DMAR: DRHD base: 0x000000fbffc000 flags: 0x0
[    0.308032] DMAR: dmar0: reg_base_addr fbffc000 ver 1:0 cap 8d2078c106f0466 ecap f020df
[    0.309008] DMAR: DRHD base: 0x000000c7ffc000 flags: 0x1
[    0.310018] DMAR: dmar1: reg_base_addr c7ffc000 ver 1:0 cap 8d2078c106f0466 ecap f020df
[    0.311007] DMAR: RMRR base: 0x00000079174000 end: 0x00000079176fff
[    0.312009] DMAR: RMRR base: 0x000000791f4000 end: 0x000000791f7fff
[    0.313009] DMAR: RMRR base: 0x000000791de000 end: 0x000000791f3fff
[    0.314009] DMAR: RMRR base: 0x000000791cb000 end: 0x000000791dbfff
[    0.315009] DMAR: RMRR base: 0x000000791dc000 end: 0x000000791ddfff
[    0.316010] DMAR-IR: IOAPIC id 10 under DRHD base  0xfbffc000 IOMMU 0
[    0.317007] DMAR-IR: IOAPIC id 8 under DRHD base  0xc7ffc000 IOMMU 1
[    0.318007] DMAR-IR: IOAPIC id 9 under DRHD base  0xc7ffc000 IOMMU 1
[    0.319008] DMAR-IR: HPET id 0 under DRHD base 0xc7ffc000
[    0.320007] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.322332] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.323000] x2apic enabled
[    0.323013] Switched APIC routing to cluster x2apic.
[    0.326000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.336000] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-2695 v4 @ 2.10GHz (family: 0x6, model: 0x4f, stepping: 0x1)
[    0.337039] Performance Events: PEBS fmt2+, Broadwell events, full-width counters, Broken BIOS detected, complain to your hardware vendor.
[    0.338006] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is 330)
[    0.339005] Intel PMU driver.
[    0.340028] ... version:                3
[    0.341005] ... bit width:              48
[    0.342005] ... generic registers:      4
[    0.343005] ... value mask:             0000ffffffffffff
[    0.344005] ... max period:             00007fffffffffff
[    0.345005] ... fixed-purpose events:   3
[    0.346005] ... event mask:             000000070000000f
[    0.347312] Hierarchical SRCU implementation.
[    0.356622] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
[    0.358607] smp: Bringing up secondary CPUs ...
[    0.359640] x86: Booting SMP configuration:
[    0.360011] .... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7  #8  #9 #10 #11 #12 #13 #14 #15 #16 #17
[    1.416010] .... node  #1, CPUs:   #18 #19 #20 #21 #22 #23 #24 #25 #26 #27 #28 #29 #30 #31 #32 #33 #34 #35
[    2.538010] .... node  #0, CPUs:   #36 #37 #38 #39 #40 #41 #42 #43 #44 #45 #46 #47 #48 #49 #50 #51 #52 #53
[    3.657011] .... node  #1, CPUs:   #54 #55 #56 #57 #58 #59 #60 #61 #62 #63 #64 #65 #66 #67 #68 #69 #70 #71
[    4.774457] smp: Brought up 2 nodes, 72 CPUs
[    4.777008] smpboot: Total of 72 processors activated (302019.38 BogoMIPS)
[    4.787152] devtmpfs: initialized
[    4.788326] x86/mm: Memory block size: 128MB
[    4.809818] PM: Registering ACPI NVS region [mem 0x791ff000-0x7b5fefff] (37748736 bytes)
[    4.818608] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    4.820562] futex hash table entries: 32768 (order: 10, 4194304 bytes)
[    4.823759] pinctrl core: initialized pinctrl subsystem
[    4.824218] RTC time:  9:28:08, date: 10/11/17
[    4.826739] NET: Registered protocol family 16
[    4.828299] cpuidle: using governor menu
[    4.829016] Error parsing PCC subspaces from PCCT
[    4.831021] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    4.832014] ACPI: bus type PCI registered
[    4.833006] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    4.834343] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
[    4.835066] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
[    4.836029] PCI: Using configuration type 1 for base access
[    4.837007] PCI: HP ProLiant DL380 detected, enabling pci=bfsort.
[    4.859126] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    4.860013] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    4.865379] ACPI: Added _OSI(Module Device)
[    4.866015] ACPI: Added _OSI(Processor Device)
[    4.868008] ACPI: Added _OSI(3.0 _SCP Extensions)
[    4.870007] ACPI: Added _OSI(Processor Aggregator Device)
[    4.969612] ACPI: Interpreter enabled
[    4.970051] ACPI: (supports S0 S5)
[    4.972008] ACPI: Using IOAPIC for interrupt routing
[    4.973230] HEST: Table parsing has been initialized.
[    4.975008] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    4.978263] ACPI: Enabled 11 GPEs in block 00 to 3F
[    5.053153] ACPI: PCI Root Bridge [UNC0] (domain 0000 [bus 7f])
[    5.055015] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    5.057038] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    5.060291] PCI host bridge to bus 0000:7f
[    5.061009] pci_bus 0000:7f: root bus resource [bus 7f]
[    5.063045] pci 0000:7f:08.0: [8086:6f80] type 00 class 0x088000
[    5.063300] pci 0000:7f:08.3: [8086:6f83] type 00 class 0x088000
[    5.064023] pci 0000:7f:09.0: [8086:6f90] type 00 class 0x088000
[    5.064230] pci 0000:7f:09.3: [8086:6f93] type 00 class 0x088000
[    5.064472] pci 0000:7f:0b.0: [8086:6f81] type 00 class 0x088000
[    5.064667] pci 0000:7f:0b.1: [8086:6f36] type 00 class 0x110100
[    5.064861] pci 0000:7f:0b.2: [8086:6f37] type 00 class 0x110100
[    5.065076] pci 0000:7f:0b.3: [8086:6f76] type 00 class 0x088000
[    5.065277] pci 0000:7f:0c.0: [8086:6fe0] type 00 class 0x088000
[    5.065471] pci 0000:7f:0c.1: [8086:6fe1] type 00 class 0x088000
[    5.065668] pci 0000:7f:0c.2: [8086:6fe2] type 00 class 0x088000
[    5.065864] pci 0000:7f:0c.3: [8086:6fe3] type 00 class 0x088000
[    5.066079] pci 0000:7f:0c.4: [8086:6fe4] type 00 class 0x088000
[    5.066274] pci 0000:7f:0c.5: [8086:6fe5] type 00 class 0x088000
[    5.066473] pci 0000:7f:0c.6: [8086:6fe6] type 00 class 0x088000
[    5.066680] pci 0000:7f:0c.7: [8086:6fe7] type 00 class 0x088000
[    5.066888] pci 0000:7f:0d.0: [8086:6fe8] type 00 class 0x088000
[    5.067109] pci 0000:7f:0d.1: [8086:6fe9] type 00 class 0x088000
[    5.067309] pci 0000:7f:0d.2: [8086:6fea] type 00 class 0x088000
[    5.067503] pci 0000:7f:0d.3: [8086:6feb] type 00 class 0x088000
[    5.067690] pci 0000:7f:0d.4: [8086:6fec] type 00 class 0x088000
[    5.067885] pci 0000:7f:0d.5: [8086:6fed] type 00 class 0x088000
[    5.068098] pci 0000:7f:0d.6: [8086:6fee] type 00 class 0x088000
[    5.068293] pci 0000:7f:0d.7: [8086:6fef] type 00 class 0x088000
[    5.068487] pci 0000:7f:0e.0: [8086:6ff0] type 00 class 0x088000
[    5.068680] pci 0000:7f:0e.1: [8086:6ff1] type 00 class 0x088000
[    5.068880] pci 0000:7f:0f.0: [8086:6ff8] type 00 class 0x088000
[    5.069098] pci 0000:7f:0f.1: [8086:6ff9] type 00 class 0x088000
[    5.069293] pci 0000:7f:0f.2: [8086:6ffa] type 00 class 0x088000
[    5.069486] pci 0000:7f:0f.3: [8086:6ffb] type 00 class 0x088000
[    5.069679] pci 0000:7f:0f.4: [8086:6ffc] type 00 class 0x088000
[    5.069872] pci 0000:7f:0f.5: [8086:6ffd] type 00 class 0x088000
[    5.070079] pci 0000:7f:0f.6: [8086:6ffe] type 00 class 0x088000
[    5.070287] pci 0000:7f:10.0: [8086:6f1d] type 00 class 0x088000
[    5.070495] pci 0000:7f:10.1: [8086:6f34] type 00 class 0x110100
[    5.070706] pci 0000:7f:10.5: [8086:6f1e] type 00 class 0x088000
[    5.070909] pci 0000:7f:10.6: [8086:6f7d] type 00 class 0x110100
[    5.071126] pci 0000:7f:10.7: [8086:6f1f] type 00 class 0x088000
[    5.071316] pci 0000:7f:12.0: [8086:6fa0] type 00 class 0x088000
[    5.071480] pci 0000:7f:12.1: [8086:6f30] type 00 class 0x110100
[    5.071680] pci 0000:7f:12.2: [8086:6f70] type 00 class 0x088000
[    5.071878] pci 0000:7f:12.4: [8086:6f60] type 00 class 0x088000
[    5.072063] pci 0000:7f:12.5: [8086:6f38] type 00 class 0x110100
[    5.072260] pci 0000:7f:12.6: [8086:6f78] type 00 class 0x088000
[    5.072469] pci 0000:7f:13.0: [8086:6fa8] type 00 class 0x088000
[    5.072899] pci 0000:7f:13.1: [8086:6f71] type 00 class 0x088000
[    5.073192] pci 0000:7f:13.2: [8086:6faa] type 00 class 0x088000
[    5.073421] pci 0000:7f:13.3: [8086:6fab] type 00 class 0x088000
[    5.073650] pci 0000:7f:13.6: [8086:6fae] type 00 class 0x088000
[    5.073845] pci 0000:7f:13.7: [8086:6faf] type 00 class 0x088000
[    5.074065] pci 0000:7f:14.0: [8086:6fb0] type 00 class 0x088000
[    5.074296] pci 0000:7f:14.1: [8086:6fb1] type 00 class 0x088000
[    5.074525] pci 0000:7f:14.2: [8086:6fb2] type 00 class 0x088000
[    5.074754] pci 0000:7f:14.3: [8086:6fb3] type 00 class 0x088000
[    5.074980] pci 0000:7f:14.4: [8086:6fbc] type 00 class 0x088000
[    5.075188] pci 0000:7f:14.5: [8086:6fbd] type 00 class 0x088000
[    5.075383] pci 0000:7f:14.6: [8086:6fbe] type 00 class 0x088000
[    5.075578] pci 0000:7f:14.7: [8086:6fbf] type 00 class 0x088000
[    5.075783] pci 0000:7f:16.0: [8086:6f68] type 00 class 0x088000
[    5.076122] pci 0000:7f:16.1: [8086:6f79] type 00 class 0x088000
[    5.076353] pci 0000:7f:16.2: [8086:6f6a] type 00 class 0x088000
[    5.076583] pci 0000:7f:16.3: [8086:6f6b] type 00 class 0x088000
[    5.076814] pci 0000:7f:16.6: [8086:6f6e] type 00 class 0x088000
[    5.077022] pci 0000:7f:16.7: [8086:6f6f] type 00 class 0x088000
[    5.077224] pci 0000:7f:17.0: [8086:6fd0] type 00 class 0x088000
[    5.077551] pci 0000:7f:17.1: [8086:6fd1] type 00 class 0x088000
[    5.077784] pci 0000:7f:17.2: [8086:6fd2] type 00 class 0x088000
[    5.078034] pci 0000:7f:17.3: [8086:6fd3] type 00 class 0x088000
[    5.078262] pci 0000:7f:17.4: [8086:6fb8] type 00 class 0x088000
[    5.078458] pci 0000:7f:17.5: [8086:6fb9] type 00 class 0x088000
[    5.078655] pci 0000:7f:17.6: [8086:6fba] type 00 class 0x088000
[    5.078844] pci 0000:7f:17.7: [8086:6fbb] type 00 class 0x088000
[    5.079079] pci 0000:7f:1e.0: [8086:6f98] type 00 class 0x088000
[    5.079274] pci 0000:7f:1e.1: [8086:6f99] type 00 class 0x088000
[    5.079471] pci 0000:7f:1e.2: [8086:6f9a] type 00 class 0x088000
[    5.079666] pci 0000:7f:1e.3: [8086:6fc0] type 00 class 0x088000
[    5.079832] pci 0000:7f:1e.4: [8086:6f9c] type 00 class 0x088000
[    5.080046] pci 0000:7f:1f.0: [8086:6f88] type 00 class 0x088000
[    5.080245] pci 0000:7f:1f.2: [8086:6f8a] type 00 class 0x088000
[    5.080779] ACPI: PCI Root Bridge [UNC1] (domain 0000 [bus ff])
[    5.082013] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    5.085021] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    5.087220] PCI host bridge to bus 0000:ff
[    5.089008] pci_bus 0000:ff: root bus resource [bus ff]
[    5.091026] pci 0000:ff:08.0: [8086:6f80] type 00 class 0x088000
[    5.091233] pci 0000:ff:08.3: [8086:6f83] type 00 class 0x088000
[    5.091462] pci 0000:ff:09.0: [8086:6f90] type 00 class 0x088000
[    5.091657] pci 0000:ff:09.3: [8086:6f93] type 00 class 0x088000
[    5.091886] pci 0000:ff:0b.0: [8086:6f81] type 00 class 0x088000
[    5.092106] pci 0000:ff:0b.1: [8086:6f36] type 00 class 0x110100
[    5.092298] pci 0000:ff:0b.2: [8086:6f37] type 00 class 0x110100
[    5.092500] pci 0000:ff:0b.3: [8086:6f76] type 00 class 0x088000
[    5.092711] pci 0000:ff:0c.0: [8086:6fe0] type 00 class 0x088000
[    5.092920] pci 0000:ff:0c.1: [8086:6fe1] type 00 class 0x088000
[    5.093128] pci 0000:ff:0c.2: [8086:6fe2] type 00 class 0x088000
[    5.093326] pci 0000:ff:0c.3: [8086:6fe3] type 00 class 0x088000
[    5.093516] pci 0000:ff:0c.4: [8086:6fe4] type 00 class 0x088000
[    5.093706] pci 0000:ff:0c.5: [8086:6fe5] type 00 class 0x088000
[    5.093908] pci 0000:ff:0c.6: [8086:6fe6] type 00 class 0x088000
[    5.094122] pci 0000:ff:0c.7: [8086:6fe7] type 00 class 0x088000
[    5.094307] pci 0000:ff:0d.0: [8086:6fe8] type 00 class 0x088000
[    5.094499] pci 0000:ff:0d.1: [8086:6fe9] type 00 class 0x088000
[    5.094690] pci 0000:ff:0d.2: [8086:6fea] type 00 class 0x088000
[    5.094884] pci 0000:ff:0d.3: [8086:6feb] type 00 class 0x088000
[    5.095091] pci 0000:ff:0d.4: [8086:6fec] type 00 class 0x088000
[    5.095285] pci 0000:ff:0d.5: [8086:6fed] type 00 class 0x088000
[    5.095468] pci 0000:ff:0d.6: [8086:6fee] type 00 class 0x088000
[    5.095677] pci 0000:ff:0d.7: [8086:6fef] type 00 class 0x088000
[    5.095882] pci 0000:ff:0e.0: [8086:6ff0] type 00 class 0x088000
[    5.096101] pci 0000:ff:0e.1: [8086:6ff1] type 00 class 0x088000
[    5.096305] pci 0000:ff:0f.0: [8086:6ff8] type 00 class 0x088000
[    5.096502] pci 0000:ff:0f.1: [8086:6ff9] type 00 class 0x088000
[    5.096685] pci 0000:ff:0f.2: [8086:6ffa] type 00 class 0x088000
[    5.096876] pci 0000:ff:0f.3: [8086:6ffb] type 00 class 0x088000
[    5.097085] pci 0000:ff:0f.4: [8086:6ffc] type 00 class 0x088000
[    5.097289] pci 0000:ff:0f.5: [8086:6ffd] type 00 class 0x088000
[    5.097493] pci 0000:ff:0f.6: [8086:6ffe] type 00 class 0x088000
[    5.097699] pci 0000:ff:10.0: [8086:6f1d] type 00 class 0x088000
[    5.097896] pci 0000:ff:10.1: [8086:6f34] type 00 class 0x110100
[    5.098122] pci 0000:ff:10.5: [8086:6f1e] type 00 class 0x088000
[    5.098316] pci 0000:ff:10.6: [8086:6f7d] type 00 class 0x110100
[    5.098508] pci 0000:ff:10.7: [8086:6f1f] type 00 class 0x088000
[    5.098701] pci 0000:ff:12.0: [8086:6fa0] type 00 class 0x088000
[    5.098867] pci 0000:ff:12.1: [8086:6f30] type 00 class 0x110100
[    5.099075] pci 0000:ff:12.2: [8086:6f70] type 00 class 0x088000
[    5.099270] pci 0000:ff:12.4: [8086:6f60] type 00 class 0x088000
[    5.099435] pci 0000:ff:12.5: [8086:6f38] type 00 class 0x110100
[    5.099632] pci 0000:ff:12.6: [8086:6f78] type 00 class 0x088000
[    5.099832] pci 0000:ff:13.0: [8086:6fa8] type 00 class 0x088000
[    5.100139] pci 0000:ff:13.1: [8086:6f71] type 00 class 0x088000
[    5.100366] pci 0000:ff:13.2: [8086:6faa] type 00 class 0x088000
[    5.100592] pci 0000:ff:13.3: [8086:6fab] type 00 class 0x088000
[    5.100811] pci 0000:ff:13.6: [8086:6fae] type 00 class 0x088000
[    5.101021] pci 0000:ff:13.7: [8086:6faf] type 00 class 0x088000
[    5.101219] pci 0000:ff:14.0: [8086:6fb0] type 00 class 0x088000
[    5.101449] pci 0000:ff:14.1: [8086:6fb1] type 00 class 0x088000
[    5.101675] pci 0000:ff:14.2: [8086:6fb2] type 00 class 0x088000
[    5.101902] pci 0000:ff:14.3: [8086:6fb3] type 00 class 0x088000
[    5.102141] pci 0000:ff:14.4: [8086:6fbc] type 00 class 0x088000
[    5.102342] pci 0000:ff:14.5: [8086:6fbd] type 00 class 0x088000
[    5.102537] pci 0000:ff:14.6: [8086:6fbe] type 00 class 0x088000
[    5.102725] pci 0000:ff:14.7: [8086:6fbf] type 00 class 0x088000
[    5.102925] pci 0000:ff:16.0: [8086:6f68] type 00 class 0x088000
[    5.103246] pci 0000:ff:16.1: [8086:6f79] type 00 class 0x088000
[    5.103473] pci 0000:ff:16.2: [8086:6f6a] type 00 class 0x088000
[    5.103702] pci 0000:ff:16.3: [8086:6f6b] type 00 class 0x088000
[    5.103944] pci 0000:ff:16.6: [8086:6f6e] type 00 class 0x088000
[    5.104162] pci 0000:ff:16.7: [8086:6f6f] type 00 class 0x088000
[    5.104361] pci 0000:ff:17.0: [8086:6fd0] type 00 class 0x088000
[    5.104784] pci 0000:ff:17.1: [8086:6fd1] type 00 class 0x088000
[    5.105128] pci 0000:ff:17.2: [8086:6fd2] type 00 class 0x088000
[    5.105359] pci 0000:ff:17.3: [8086:6fd3] type 00 class 0x088000
[    5.105583] pci 0000:ff:17.4: [8086:6fb8] type 00 class 0x088000
[    5.105779] pci 0000:ff:17.5: [8086:6fb9] type 00 class 0x088000
[    5.105975] pci 0000:ff:17.6: [8086:6fba] type 00 class 0x088000
[    5.106188] pci 0000:ff:17.7: [8086:6fbb] type 00 class 0x088000
[    5.106400] pci 0000:ff:1e.0: [8086:6f98] type 00 class 0x088000
[    5.106586] pci 0000:ff:1e.1: [8086:6f99] type 00 class 0x088000
[    5.106779] pci 0000:ff:1e.2: [8086:6f9a] type 00 class 0x088000
[    5.106977] pci 0000:ff:1e.3: [8086:6fc0] type 00 class 0x088000
[    5.107160] pci 0000:ff:1e.4: [8086:6f9c] type 00 class 0x088000
[    5.107362] pci 0000:ff:1f.0: [8086:6f88] type 00 class 0x088000
[    5.107559] pci 0000:ff:1f.2: [8086:6f8a] type 00 class 0x088000
[    5.119839] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
[    5.121014] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    5.125219] acpi PNP0A08:00: _OSC: platform does not support [AER]
[    5.128342] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
[    5.130006] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    5.137293] PCI host bridge to bus 0000:00
[    5.138008] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000cbfff window]
[    5.141007] pci_bus 0000:00: root bus resource [io  0x0000-0x03af window]
[    5.143006] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
[    5.145007] pci_bus 0000:00: root bus resource [io  0x03b0-0x03bb window]
[    5.148007] pci_bus 0000:00: root bus resource [io  0x03c0-0x03df window]
[    5.150006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    5.152007] pci_bus 0000:00: root bus resource [io  0x1000-0x9fff window]
[    5.155007] pci_bus 0000:00: root bus resource [mem 0x90000000-0xc7ffbfff window]
[    5.157006] pci_bus 0000:00: root bus resource [mem 0x38000000000-0x39fffffffff window]
[    5.160007] pci_bus 0000:00: root bus resource [bus 00-7e]
[    5.161020] pci 0000:00:00.0: [8086:6f00] type 00 class 0x060000
[    5.162648] pci 0000:00:01.0: [8086:6f02] type 01 class 0x060400
[    5.162758] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    5.163539] pci 0000:00:01.1: [8086:6f03] type 01 class 0x060400
[    5.163648] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
[    5.164414] pci 0000:00:02.0: [8086:6f04] type 01 class 0x060400
[    5.164523] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    5.165302] pci 0000:00:02.1: [8086:6f05] type 01 class 0x060400
[    5.165411] pci 0000:00:02.1: PME# supported from D0 D3hot D3cold
[    5.166164] pci 0000:00:02.2: [8086:6f06] type 01 class 0x060400
[    5.166272] pci 0000:00:02.2: PME# supported from D0 D3hot D3cold
[    5.167032] pci 0000:00:02.3: [8086:6f07] type 01 class 0x060400
[    5.167140] pci 0000:00:02.3: PME# supported from D0 D3hot D3cold
[    5.167879] pci 0000:00:03.0: [8086:6f08] type 01 class 0x060400
[    5.167989] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    5.168735] pci 0000:00:03.1: [8086:6f09] type 01 class 0x060400
[    5.168843] pci 0000:00:03.1: PME# supported from D0 D3hot D3cold
[    5.169594] pci 0000:00:03.2: [8086:6f0a] type 01 class 0x060400
[    5.169703] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
[    5.170460] pci 0000:00:03.3: [8086:6f0b] type 01 class 0x060400
[    5.170568] pci 0000:00:03.3: PME# supported from D0 D3hot D3cold
[    5.171325] pci 0000:00:04.0: [8086:6f20] type 00 class 0x088000
[    5.171350] pci 0000:00:04.0: reg 0x10: [mem 0x39ffff2c000-0x39ffff2ffff 64bit]
[    5.172150] pci 0000:00:04.1: [8086:6f21] type 00 class 0x088000
[    5.172174] pci 0000:00:04.1: reg 0x10: [mem 0x39ffff28000-0x39ffff2bfff 64bit]
[    5.172945] pci 0000:00:04.2: [8086:6f22] type 00 class 0x088000
[    5.172969] pci 0000:00:04.2: reg 0x10: [mem 0x39ffff24000-0x39ffff27fff 64bit]
[    5.173754] pci 0000:00:04.3: [8086:6f23] type 00 class 0x088000
[    5.173779] pci 0000:00:04.3: reg 0x10: [mem 0x39ffff20000-0x39ffff23fff 64bit]
[    5.174563] pci 0000:00:04.4: [8086:6f24] type 00 class 0x088000
[    5.174587] pci 0000:00:04.4: reg 0x10: [mem 0x39ffff1c000-0x39ffff1ffff 64bit]
[    5.175376] pci 0000:00:04.5: [8086:6f25] type 00 class 0x088000
[    5.175401] pci 0000:00:04.5: reg 0x10: [mem 0x39ffff18000-0x39ffff1bfff 64bit]
[    5.176191] pci 0000:00:04.6: [8086:6f26] type 00 class 0x088000
[    5.176215] pci 0000:00:04.6: reg 0x10: [mem 0x39ffff14000-0x39ffff17fff 64bit]
[    5.176984] pci 0000:00:04.7: [8086:6f27] type 00 class 0x088000
[    5.177028] pci 0000:00:04.7: reg 0x10: [mem 0x39ffff10000-0x39ffff13fff 64bit]
[    5.177798] pci 0000:00:05.0: [8086:6f28] type 00 class 0x088000
[    5.178580] pci 0000:00:05.1: [8086:6f29] type 00 class 0x088000
[    5.179392] pci 0000:00:05.2: [8086:6f2a] type 00 class 0x088000
[    5.180146] pci 0000:00:05.4: [8086:6f2c] type 00 class 0x080020
[    5.180166] pci 0000:00:05.4: reg 0x10: [mem 0x95404000-0x95404fff]
[    5.180927] pci 0000:00:11.0: [8086:8d7c] type 00 class 0xff0000
[    5.181773] pci 0000:00:14.0: [8086:8d31] type 00 class 0x0c0330
[    5.181805] pci 0000:00:14.0: reg 0x10: [mem 0x39ffff00000-0x39ffff0ffff 64bit]
[    5.181897] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    5.182638] pci 0000:00:1a.0: [8086:8d2d] type 00 class 0x0c0320
[    5.182672] pci 0000:00:1a.0: reg 0x10: [mem 0x95402000-0x954023ff]
[    5.182805] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    5.183531] pci 0000:00:1c.0: [8086:8d10] type 01 class 0x060401
[    5.183653] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    5.184401] pci 0000:00:1c.2: [8086:8d14] type 01 class 0x060400
[    5.184523] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    5.185282] pci 0000:00:1c.4: [8086:8d18] type 01 class 0x060400
[    5.185404] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    5.186154] pci 0000:00:1c.6: [8086:8d1c] type 01 class 0x060400
[    5.186276] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    5.187039] pci 0000:00:1c.7: [8086:8d1e] type 01 class 0x060400
[    5.187161] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    5.187893] pci 0000:00:1d.0: [8086:8d26] type 00 class 0x0c0320
[    5.187926] pci 0000:00:1d.0: reg 0x10: [mem 0x95401000-0x954013ff]
[    5.188078] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    5.188787] pci 0000:00:1f.0: [8086:8d44] type 00 class 0x060100
[    5.189646] pci 0000:00:1f.2: [8086:8d02] type 00 class 0x010601
[    5.189676] pci 0000:00:1f.2: reg 0x10: [io  0x3058-0x305f]
[    5.189689] pci 0000:00:1f.2: reg 0x14: [io  0x307c-0x307f]
[    5.189703] pci 0000:00:1f.2: reg 0x18: [io  0x3050-0x3057]
[    5.189716] pci 0000:00:1f.2: reg 0x1c: [io  0x3078-0x307b]
[    5.189729] pci 0000:00:1f.2: reg 0x20: [io  0x3020-0x303f]
[    5.189743] pci 0000:00:1f.2: reg 0x24: [mem 0x95400000-0x954007ff]
[    5.189813] pci 0000:00:1f.2: PME# supported from D3hot
[    5.190528] pci 0000:00:1f.3: [8086:8d22] type 00 class 0x0c0500
[    5.190555] pci 0000:00:1f.3: reg 0x10: [mem 0x39ffff31000-0x39ffff310ff 64bit]
[    5.190580] pci 0000:00:1f.3: reg 0x20: [io  0x3000-0x301f]
[    5.191443] pci 0000:03:00.0: [103c:3239] type 00 class 0x010400
[    5.191471] pci 0000:03:00.0: reg 0x10: [mem 0x95200000-0x952fffff 64bit]
[    5.191487] pci 0000:03:00.0: reg 0x18: [mem 0x95300000-0x953003ff 64bit]
[    5.191499] pci 0000:03:00.0: reg 0x20: [io  0x2000-0x20ff]
[    5.191518] pci 0000:03:00.0: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    5.191596] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    5.191820] pci 0000:00:01.0: PCI bridge to [bus 03]
[    5.193010] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    5.193016] pci 0000:00:01.0:   bridge window [mem 0x95200000-0x953fffff]
[    5.193155] pci 0000:00:01.1: PCI bridge to [bus 0e]
[    5.195566] pci 0000:00:02.0: PCI bridge to [bus 05]
[    5.197144] pci 0000:00:02.1: PCI bridge to [bus 0f]
[    5.199486] pci 0000:04:00.0: [14e4:168e] type 00 class 0x020000
[    5.199521] pci 0000:04:00.0: reg 0x10: [mem 0x93800000-0x93ffffff 64bit pref]
[    5.199539] pci 0000:04:00.0: reg 0x18: [mem 0x93000000-0x937fffff 64bit pref]
[    5.199557] pci 0000:04:00.0: reg 0x20: [mem 0x95000000-0x9500ffff 64bit pref]
[    5.199570] pci 0000:04:00.0: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    5.199670] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    5.200021] pci 0000:04:00.0: reg 0x1e4: [mem 0x39fffd80000-0x39fffd87fff 64bit pref]
[    5.200026] pci 0000:04:00.0: VF(n) BAR0 space: [mem 0x39fffd80000-0x39fffdfffff 64bit pref] (contains BAR0 for 16 VFs)
[    5.203029] pci 0000:04:00.0: reg 0x1f4: [mem 0x39fffe20000-0x39fffe21fff 64bit pref]
[    5.203033] pci 0000:04:00.0: VF(n) BAR4 space: [mem 0x39fffe20000-0x39fffe3ffff 64bit pref] (contains BAR4 for 16 VFs)
[    5.207567] pci 0000:04:00.1: [14e4:168e] type 00 class 0x020000
[    5.207601] pci 0000:04:00.1: reg 0x10: [mem 0x94800000-0x94ffffff 64bit pref]
[    5.207619] pci 0000:04:00.1: reg 0x18: [mem 0x94000000-0x947fffff 64bit pref]
[    5.207637] pci 0000:04:00.1: reg 0x20: [mem 0x95010000-0x9501ffff 64bit pref]
[    5.207650] pci 0000:04:00.1: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    5.207750] pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
[    5.207781] pci 0000:04:00.1: reg 0x1e4: [mem 0x39fffd00000-0x39fffd07fff 64bit pref]
[    5.207785] pci 0000:04:00.1: VF(n) BAR0 space: [mem 0x39fffd00000-0x39fffd7ffff 64bit pref] (contains BAR0 for 16 VFs)
[    5.211030] pci 0000:04:00.1: reg 0x1f4: [mem 0x39fffe00000-0x39fffe01fff 64bit pref]
[    5.211035] pci 0000:04:00.1: VF(n) BAR4 space: [mem 0x39fffe00000-0x39fffe1ffff 64bit pref] (contains BAR4 for 16 VFs)
[    5.218041] pci 0000:00:02.2: PCI bridge to [bus 04]
[    5.219011] pci 0000:00:02.2:   bridge window [mem 0x93000000-0x950fffff]
[    5.219020] pci 0000:00:02.2:   bridge window [mem 0x39fffd00000-0x39fffefffff 64bit pref]
[    5.219148] pci 0000:00:02.3: PCI bridge to [bus 10]
[    5.222032] pci 0000:00:03.0: PCI bridge to [bus 08]
[    5.223134] pci 0000:00:03.1: PCI bridge to [bus 11]
[    5.225547] pci 0000:00:03.2: PCI bridge to [bus 0b]
[    5.227144] pci 0000:00:03.3: PCI bridge to [bus 12]
[    5.229151] pci 0000:00:1c.0: PCI bridge to [bus 13] (subtractive decode)
[    5.231019] pci 0000:00:1c.0:   bridge window [mem 0x000c4000-0x000cbfff window] (subtractive decode)
[    5.231023] pci 0000:00:1c.0:   bridge window [io  0x0000-0x03af window] (subtractive decode)
[    5.231028] pci 0000:00:1c.0:   bridge window [io  0x03e0-0x0cf7 window] (subtractive decode)
[    5.231032] pci 0000:00:1c.0:   bridge window [io  0x03b0-0x03bb window] (subtractive decode)
[    5.231037] pci 0000:00:1c.0:   bridge window [io  0x03c0-0x03df window] (subtractive decode)
[    5.231042] pci 0000:00:1c.0:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
[    5.231046] pci 0000:00:1c.0:   bridge window [io  0x1000-0x9fff window] (subtractive decode)
[    5.231051] pci 0000:00:1c.0:   bridge window [mem 0x90000000-0xc7ffbfff window] (subtractive decode)
[    5.231055] pci 0000:00:1c.0:   bridge window [mem 0x38000000000-0x39fffffffff window] (subtractive decode)
[    5.232006] pci 0000:01:00.0: [103c:3306] type 00 class 0x088000
[    5.232046] pci 0000:01:00.0: reg 0x10: [io  0x1200-0x12ff]
[    5.232065] pci 0000:01:00.0: reg 0x14: [mem 0x92a8d000-0x92a8d1ff]
[    5.232084] pci 0000:01:00.0: reg 0x18: [io  0x1100-0x11ff]
[    5.232447] pci 0000:01:00.1: [102b:0533] type 00 class 0x030000
[    5.232486] pci 0000:01:00.1: reg 0x10: [mem 0x91000000-0x91ffffff pref]
[    5.232505] pci 0000:01:00.1: reg 0x14: [mem 0x92a88000-0x92a8bfff]
[    5.232524] pci 0000:01:00.1: reg 0x18: [mem 0x92000000-0x927fffff]
[    5.232622] pci 0000:01:00.1: BAR 0: assigned to efifb
[    5.234272] pci 0000:01:00.2: [103c:3307] type 00 class 0x088000
[    5.234312] pci 0000:01:00.2: reg 0x10: [io  0x1000-0x10ff]
[    5.234331] pci 0000:01:00.2: reg 0x14: [mem 0x92a8c000-0x92a8c0ff]
[    5.234350] pci 0000:01:00.2: reg 0x18: [mem 0x92900000-0x929fffff]
[    5.234369] pci 0000:01:00.2: reg 0x1c: [mem 0x92a00000-0x92a7ffff]
[    5.234388] pci 0000:01:00.2: reg 0x20: [mem 0x92a80000-0x92a87fff]
[    5.234407] pci 0000:01:00.2: reg 0x24: [mem 0x92800000-0x928fffff]
[    5.234426] pci 0000:01:00.2: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    5.234534] pci 0000:01:00.2: PME# supported from D0 D3hot D3cold
[    5.235063] pci 0000:01:00.4: [103c:3300] type 00 class 0x0c0300
[    5.235162] pci 0000:01:00.4: reg 0x20: [io  0x1300-0x131f]
[    5.238036] pci 0000:00:1c.2: PCI bridge to [bus 01]
[    5.239009] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    5.239016] pci 0000:00:1c.2:   bridge window [mem 0x90000000-0x92afffff]
[    5.240061] pci 0000:02:00.0: [14e4:1657] type 00 class 0x020000
[    5.240109] pci 0000:02:00.0: reg 0x10: [mem 0x95190000-0x9519ffff 64bit pref]
[    5.240134] pci 0000:02:00.0: reg 0x18: [mem 0x951a0000-0x951affff 64bit pref]
[    5.240159] pci 0000:02:00.0: reg 0x20: [mem 0x951b0000-0x951bffff 64bit pref]
[    5.240176] pci 0000:02:00.0: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    5.240316] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    5.240809] pci 0000:02:00.1: [14e4:1657] type 00 class 0x020000
[    5.240856] pci 0000:02:00.1: reg 0x10: [mem 0x95160000-0x9516ffff 64bit pref]
[    5.240881] pci 0000:02:00.1: reg 0x18: [mem 0x95170000-0x9517ffff 64bit pref]
[    5.240906] pci 0000:02:00.1: reg 0x20: [mem 0x95180000-0x9518ffff 64bit pref]
[    5.240924] pci 0000:02:00.1: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    5.241078] pci 0000:02:00.1: PME# supported from D0 D3hot D3cold
[    5.241561] pci 0000:02:00.2: [14e4:1657] type 00 class 0x020000
[    5.241608] pci 0000:02:00.2: reg 0x10: [mem 0x95130000-0x9513ffff 64bit pref]
[    5.241633] pci 0000:02:00.2: reg 0x18: [mem 0x95140000-0x9514ffff 64bit pref]
[    5.241658] pci 0000:02:00.2: reg 0x20: [mem 0x95150000-0x9515ffff 64bit pref]
[    5.241675] pci 0000:02:00.2: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    5.241815] pci 0000:02:00.2: PME# supported from D0 D3hot D3cold
[    5.242310] pci 0000:02:00.3: [14e4:1657] type 00 class 0x020000
[    5.242358] pci 0000:02:00.3: reg 0x10: [mem 0x95100000-0x9510ffff 64bit pref]
[    5.242383] pci 0000:02:00.3: reg 0x18: [mem 0x95110000-0x9511ffff 64bit pref]
[    5.242408] pci 0000:02:00.3: reg 0x20: [mem 0x95120000-0x9512ffff 64bit pref]
[    5.242425] pci 0000:02:00.3: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    5.242565] pci 0000:02:00.3: PME# supported from D0 D3hot D3cold
[    5.246052] pci 0000:00:1c.4: PCI bridge to [bus 02]
[    5.247018] pci 0000:00:1c.4:   bridge window [mem 0x95100000-0x951fffff 64bit pref]
[    5.247163] pci 0000:00:1c.6: PCI bridge to [bus 14]
[    5.249147] pci 0000:00:1c.7: PCI bridge to [bus 15]
[    5.251134] pci_bus 0000:00: on NUMA node 0
[    5.252591] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.255334] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.258331] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.262051] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.265328] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.269012] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.542336] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.674338] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.779568] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-fe])
[    5.781013] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    5.784607] acpi PNP0A08:01: _OSC: platform does not support [AER]
[    5.787575] acpi PNP0A08:01: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
[    5.790006] acpi PNP0A08:01: FADT indicates ASPM is unsupported, using BIOS configuration
[    5.793561] PCI host bridge to bus 0000:80
[    5.795007] pci_bus 0000:80: root bus resource [io  0xa000-0xffff window]
[    5.797007] pci_bus 0000:80: root bus resource [mem 0xc8000000-0xfbffbfff window]
[    5.799006] pci_bus 0000:80: root bus resource [mem 0x3a000000000-0x3bfffffffff window]
[    5.802010] pci_bus 0000:80: root bus resource [bus 80-fe]
[    5.804021] pci 0000:80:00.0: [8086:6f01] type 01 class 0x060400
[    5.804124] pci 0000:80:00.0: PME# supported from D0 D3hot D3cold
[    5.804490] pci 0000:80:01.0: [8086:6f02] type 01 class 0x060400
[    5.804592] pci 0000:80:01.0: PME# supported from D0 D3hot D3cold
[    5.805092] pci 0000:80:01.1: [8086:6f03] type 01 class 0x060400
[    5.805194] pci 0000:80:01.1: PME# supported from D0 D3hot D3cold
[    5.805556] pci 0000:80:02.0: [8086:6f04] type 01 class 0x060400
[    5.805658] pci 0000:80:02.0: PME# supported from D0 D3hot D3cold
[    5.806032] pci 0000:80:02.1: [8086:6f05] type 01 class 0x060400
[    5.806133] pci 0000:80:02.1: PME# supported from D0 D3hot D3cold
[    5.806484] pci 0000:80:02.2: [8086:6f06] type 01 class 0x060400
[    5.806585] pci 0000:80:02.2: PME# supported from D0 D3hot D3cold
[    5.806938] pci 0000:80:02.3: [8086:6f07] type 01 class 0x060400
[    5.807056] pci 0000:80:02.3: PME# supported from D0 D3hot D3cold
[    5.807414] pci 0000:80:03.0: [8086:6f08] type 01 class 0x060400
[    5.807517] pci 0000:80:03.0: PME# supported from D0 D3hot D3cold
[    5.807866] pci 0000:80:03.1: [8086:6f09] type 01 class 0x060400
[    5.807968] pci 0000:80:03.1: PME# supported from D0 D3hot D3cold
[    5.808344] pci 0000:80:03.2: [8086:6f0a] type 01 class 0x060400
[    5.808445] pci 0000:80:03.2: PME# supported from D0 D3hot D3cold
[    5.808794] pci 0000:80:03.3: [8086:6f0b] type 01 class 0x060400
[    5.808895] pci 0000:80:03.3: PME# supported from D0 D3hot D3cold
[    5.809271] pci 0000:80:04.0: [8086:6f20] type 00 class 0x088000
[    5.809295] pci 0000:80:04.0: reg 0x10: [mem 0x3bffff1c000-0x3bffff1ffff 64bit]
[    5.809650] pci 0000:80:04.1: [8086:6f21] type 00 class 0x088000
[    5.809673] pci 0000:80:04.1: reg 0x10: [mem 0x3bffff18000-0x3bffff1bfff 64bit]
[    5.810043] pci 0000:80:04.2: [8086:6f22] type 00 class 0x088000
[    5.810067] pci 0000:80:04.2: reg 0x10: [mem 0x3bffff14000-0x3bffff17fff 64bit]
[    5.810425] pci 0000:80:04.3: [8086:6f23] type 00 class 0x088000
[    5.810448] pci 0000:80:04.3: reg 0x10: [mem 0x3bffff10000-0x3bffff13fff 64bit]
[    5.810803] pci 0000:80:04.4: [8086:6f24] type 00 class 0x088000
[    5.810826] pci 0000:80:04.4: reg 0x10: [mem 0x3bffff0c000-0x3bffff0ffff 64bit]
[    5.811197] pci 0000:80:04.5: [8086:6f25] type 00 class 0x088000
[    5.811220] pci 0000:80:04.5: reg 0x10: [mem 0x3bffff08000-0x3bffff0bfff 64bit]
[    5.811574] pci 0000:80:04.6: [8086:6f26] type 00 class 0x088000
[    5.811597] pci 0000:80:04.6: reg 0x10: [mem 0x3bffff04000-0x3bffff07fff 64bit]
[    5.811951] pci 0000:80:04.7: [8086:6f27] type 00 class 0x088000
[    5.811974] pci 0000:80:04.7: reg 0x10: [mem 0x3bffff00000-0x3bffff03fff 64bit]
[    5.812353] pci 0000:80:05.0: [8086:6f28] type 00 class 0x088000
[    5.812700] pci 0000:80:05.1: [8086:6f29] type 00 class 0x088000
[    5.813079] pci 0000:80:05.2: [8086:6f2a] type 00 class 0x088000
[    5.813454] pci 0000:80:05.4: [8086:6f2c] type 00 class 0x080020
[    5.813473] pci 0000:80:05.4: reg 0x10: [mem 0xc8000000-0xc8000fff]
[    5.814036] pci 0000:80:00.0: PCI bridge to [bus 91]
[    5.816298] pci 0000:80:01.0: PCI bridge to [bus 81]
[    5.818118] pci 0000:80:01.1: PCI bridge to [bus 8e]
[    5.820342] pci 0000:80:02.0: PCI bridge to [bus 84]
[    5.822137] pci 0000:80:02.1: PCI bridge to [bus 8f]
[    5.824131] pci 0000:80:02.2: PCI bridge to [bus 87]
[    5.825139] pci 0000:80:02.3: PCI bridge to [bus 90]
[    6.228136] pci 0000:80:03.0: PCI bridge to [bus 88]
[    6.229143] pci 0000:80:03.1: PCI bridge to [bus 8b]
[    6.231132] pci 0000:80:03.2: PCI bridge to [bus 8c]
[    6.233140] pci 0000:80:03.3: PCI bridge to [bus 8d]
[    6.235094] pci_bus 0000:80: on NUMA node 1
[    6.237321] pci 0000:01:00.1: vgaarb: setting as boot VGA device
[    6.238000] pci 0000:01:00.1: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    6.242049] pci 0000:01:00.1: vgaarb: bridge control possible
[    6.244006] vgaarb: loaded
[    6.245615] SCSI subsystem initialized
[    6.247361] libata version 3.00 loaded.
[    6.247361] ACPI: bus type USB registered
[    6.249112] usbcore: registered new interface driver usbfs
[    6.250061] usbcore: registered new interface driver hub
[    6.253306] usbcore: registered new device driver usb
[    6.255628] EDAC MC: Ver: 3.0.0
[    6.258102] Registered efivars operations
[    6.278234] PCI: Using ACPI for IRQ routing
[    6.288180] PCI: pci_cache_line_size set to 64 bytes
[    6.288718] e820: reserve RAM buffer [mem 0x00093000-0x0009ffff]
[    6.288726] e820: reserve RAM buffer [mem 0x6af21000-0x6bffffff]
[    6.288731] e820: reserve RAM buffer [mem 0x6b522000-0x6bffffff]
[    6.288736] e820: reserve RAM buffer [mem 0x76d6e018-0x77ffffff]
[    6.288742] e820: reserve RAM buffer [mem 0x76d74018-0x77ffffff]
[    6.288748] e820: reserve RAM buffer [mem 0x76da4018-0x77ffffff]
[    6.288753] e820: reserve RAM buffer [mem 0x76dd4018-0x77ffffff]
[    6.288759] e820: reserve RAM buffer [mem 0x76e04018-0x77ffffff]
[    6.288764] e820: reserve RAM buffer [mem 0x76e34018-0x77ffffff]
[    6.288770] e820: reserve RAM buffer [mem 0x76e3f018-0x77ffffff]
[    6.288775] e820: reserve RAM buffer [mem 0x76e48018-0x77ffffff]
[    6.288780] e820: reserve RAM buffer [mem 0x76ea1018-0x77ffffff]
[    6.288785] e820: reserve RAM buffer [mem 0x76efa018-0x77ffffff]
[    6.288790] e820: reserve RAM buffer [mem 0x784ff000-0x7bffffff]
[    6.288795] e820: reserve RAM buffer [mem 0x7b800000-0x7bffffff]
[    6.289578] NetLabel: Initializing
[    6.290007] NetLabel:  domain hash size = 128
[    6.292005] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    6.294067] NetLabel:  unlabeled traffic allowed by default
[    6.296259] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    6.298009] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    6.303253] clocksource: Switched to clocksource hpet
[    6.415124] VFS: Disk quotas dquot_6.6.0
[    6.716552] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    6.719200] pnp: PnP ACPI init
[    6.722882] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    6.724123] system 00:01: [io  0x0500-0x053f] has been reserved
[    6.726218] system 00:01: [io  0x0400-0x047f] has been reserved
[    6.728168] system 00:01: [io  0x0540-0x057f] has been reserved
[    6.730095] system 00:01: [io  0x0600-0x061f] has been reserved
[    6.732025] system 00:01: [io  0x0880-0x0883] has been reserved
[    6.733990] system 00:01: [io  0x0800-0x081f] has been reserved
[    6.735943] system 00:01: [mem 0xfed1c000-0xfed3ffff] has been reserved
[    6.738182] system 00:01: [mem 0xfed45000-0xfed8bfff] has been reserved
[    6.740346] system 00:01: [mem 0xff000000-0xffffffff] has been reserved
[    6.742482] system 00:01: [mem 0xfee00000-0xfeefffff] has been reserved
[    6.744616] system 00:01: [mem 0xfed12000-0xfed1200f] has been reserved
[    6.746828] system 00:01: [mem 0xfed12010-0xfed1201f] has been reserved
[    6.748974] system 00:01: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    6.751177] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    6.751356] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    6.751480] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    6.752558] pnp: PnP ACPI: found 4 devices
[    6.767299] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    6.770410] pci 0000:00:1c.4: BAR 14: assigned [mem 0x92b00000-0x92bfffff]
[    6.772689] pci 0000:03:00.0: BAR 6: assigned [mem 0x95380000-0x953fffff pref]
[    7.274851] pci 0000:00:01.0: PCI bridge to [bus 03]
[    7.276579] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    7.278591] pci 0000:00:01.0:   bridge window [mem 0x95200000-0x953fffff]
[    7.280794] pci 0000:00:01.1: PCI bridge to [bus 0e]
[    7.282451] pci 0000:00:02.0: PCI bridge to [bus 05]
[    7.284074] pci 0000:00:02.1: PCI bridge to [bus 0f]
[    7.285713] pci 0000:04:00.0: BAR 6: assigned [mem 0x95080000-0x950fffff pref]
[    7.288106] pci 0000:04:00.1: BAR 6: no space for [mem size 0x00080000 pref]
[    7.290413] pci 0000:04:00.1: BAR 6: failed to assign [mem size 0x00080000 pref]
[    7.292807] pci 0000:00:02.2: PCI bridge to [bus 04]
[    7.294443] pci 0000:00:02.2:   bridge window [mem 0x93000000-0x950fffff]
[    7.296709] pci 0000:00:02.2:   bridge window [mem 0x39fffd00000-0x39fffefffff 64bit pref]
[    7.299389] pci 0000:00:02.3: PCI bridge to [bus 10]
[    7.301013] pci 0000:00:03.0: PCI bridge to [bus 08]
[    7.302665] pci 0000:00:03.1: PCI bridge to [bus 11]
[    7.304312] pci 0000:00:03.2: PCI bridge to [bus 0b]
[    7.306012] pci 0000:00:03.3: PCI bridge to [bus 12]
[    7.307675] pci 0000:00:1c.0: PCI bridge to [bus 13]
[    7.309331] pci 0000:01:00.2: BAR 6: assigned [mem 0x90000000-0x9000ffff pref]
[    7.311666] pci 0000:00:1c.2: PCI bridge to [bus 01]
[    7.313304] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    7.315295] pci 0000:00:1c.2:   bridge window [mem 0x90000000-0x92afffff]
[    7.317578] pci 0000:02:00.0: BAR 6: assigned [mem 0x92b00000-0x92b3ffff pref]
[    7.319933] pci 0000:02:00.1: BAR 6: assigned [mem 0x92b40000-0x92b7ffff pref]
[    7.322289] pci 0000:02:00.2: BAR 6: assigned [mem 0x92b80000-0x92bbffff pref]
[    7.324646] pci 0000:02:00.3: BAR 6: assigned [mem 0x92bc0000-0x92bfffff pref]
[    7.327087] pci 0000:00:1c.4: PCI bridge to [bus 02]
[    7.328776] pci 0000:00:1c.4:   bridge window [mem 0x92b00000-0x92bfffff]
[    7.330977] pci 0000:00:1c.4:   bridge window [mem 0x95100000-0x951fffff 64bit pref]
[    7.433507] pci 0000:00:1c.6: PCI bridge to [bus 14]
[    7.435189] pci 0000:00:1c.7: PCI bridge to [bus 15]
[    7.436915] pci_bus 0000:00: resource 4 [mem 0x000c4000-0x000cbfff window]
[    7.436919] pci_bus 0000:00: resource 5 [io  0x0000-0x03af window]
[    7.436923] pci_bus 0000:00: resource 6 [io  0x03e0-0x0cf7 window]
[    7.436927] pci_bus 0000:00: resource 7 [io  0x03b0-0x03bb window]
[    7.436931] pci_bus 0000:00: resource 8 [io  0x03c0-0x03df window]
[    7.436935] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff window]
[    7.436939] pci_bus 0000:00: resource 10 [io  0x1000-0x9fff window]
[    7.436943] pci_bus 0000:00: resource 11 [mem 0x90000000-0xc7ffbfff window]
[    7.436946] pci_bus 0000:00: resource 12 [mem 0x38000000000-0x39fffffffff window]
[    7.436950] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    7.436954] pci_bus 0000:03: resource 1 [mem 0x95200000-0x953fffff]
[    7.436958] pci_bus 0000:04: resource 1 [mem 0x93000000-0x950fffff]
[    7.436962] pci_bus 0000:04: resource 2 [mem 0x39fffd00000-0x39fffefffff 64bit pref]
[    7.436967] pci_bus 0000:13: resource 4 [mem 0x000c4000-0x000cbfff window]
[    7.436971] pci_bus 0000:13: resource 5 [io  0x0000-0x03af window]
[    7.436974] pci_bus 0000:13: resource 6 [io  0x03e0-0x0cf7 window]
[    7.436978] pci_bus 0000:13: resource 7 [io  0x03b0-0x03bb window]
[    7.436982] pci_bus 0000:13: resource 8 [io  0x03c0-0x03df window]
[    7.436985] pci_bus 0000:13: resource 9 [mem 0x000a0000-0x000bffff window]
[    7.436989] pci_bus 0000:13: resource 10 [io  0x1000-0x9fff window]
[    7.436993] pci_bus 0000:13: resource 11 [mem 0x90000000-0xc7ffbfff window]
[    7.436997] pci_bus 0000:13: resource 12 [mem 0x38000000000-0x39fffffffff window]
[    7.437013] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    7.437017] pci_bus 0000:01: resource 1 [mem 0x90000000-0x92afffff]
[    7.437021] pci_bus 0000:02: resource 1 [mem 0x92b00000-0x92bfffff]
[    7.437025] pci_bus 0000:02: resource 2 [mem 0x95100000-0x951fffff 64bit pref]
[    7.437779] pci 0000:80:00.0: PCI bridge to [bus 91]
[    7.439479] pci 0000:80:01.0: PCI bridge to [bus 81]
[    7.441141] pci 0000:80:01.1: PCI bridge to [bus 8e]
[    7.442772] pci 0000:80:02.0: PCI bridge to [bus 84]
[    7.444415] pci 0000:80:02.1: PCI bridge to [bus 8f]
[    7.446074] pci 0000:80:02.2: PCI bridge to [bus 87]
[    7.447750] pci 0000:80:02.3: PCI bridge to [bus 90]
[    7.449398] pci 0000:80:03.0: PCI bridge to [bus 88]
[    7.451022] pci 0000:80:03.1: PCI bridge to [bus 8b]
[    7.452667] pci 0000:80:03.2: PCI bridge to [bus 8c]
[    7.454317] pci 0000:80:03.3: PCI bridge to [bus 8d]
[    7.455958] pci_bus 0000:80: resource 4 [io  0xa000-0xffff window]
[    7.455962] pci_bus 0000:80: resource 5 [mem 0xc8000000-0xfbffbfff window]
[    7.455966] pci_bus 0000:80: resource 6 [mem 0x3a000000000-0x3bfffffffff window]
[    7.456347] NET: Registered protocol family 2
[    7.460114] TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
[    7.463870] TCP bind hash table entries: 65536 (order: 10, 5767168 bytes)
[    7.469444] TCP: Hash tables configured (established 262144 bind 65536)
[    7.473049] UDP hash table entries: 16384 (order: 9, 3145728 bytes)
[    7.477397] UDP-Lite hash table entries: 16384 (order: 9, 3145728 bytes)
[    7.882184] NET: Registered protocol family 1
[    7.883768] pci 0000:00:14.0: enabling device (0140 -> 0142)
[    7.894572] pci 0000:01:00.1: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    7.899852] PCI: CLS 64 bytes, default 64
[    7.900149] Unpacking initramfs...
[    9.042418] Freeing initrd memory: 56860K
[    9.100205] DMA-API: preallocated 65536 debug entries
[    9.101906] DMA-API: debugging enabled by kernel config
[    9.104241] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    9.106897] software IO TLB [mem 0x66f21000-0x6af21000] (64MB) mapped at [ffff888d66f21000-ffff888d6af20fff]
[    9.142280] Scanning for low memory corruption every 60 seconds
[    9.144850] cryptomgr_test (531) used greatest stack depth: 14712 bytes left
[    9.151217] audit: initializing netlink subsys (disabled)
[    9.153247] audit: type=2000 audit(1507714075.152:1): state=initialized audit_enabled=0 res=1
[    9.154451] Initialise system trusted keyrings
[    9.154543] Key type blacklist registered
[    9.154864] workingset: timestamp_bits=36 max_order=23 bucket_order=0
[    9.164408] zbud: loaded
[    9.168667] SELinux:  Registering netfilter hooks
[    9.286800] cryptomgr_test (535) used greatest stack depth: 14312 bytes left
[    9.322274] cryptomgr_test (536) used greatest stack depth: 14136 bytes left
[    9.324629] cryptomgr_test (546) used greatest stack depth: 14072 bytes left
[    9.334127] cryptomgr_test (549) used greatest stack depth: 13488 bytes left
[    9.336965] modprobe (552) used greatest stack depth: 13472 bytes left
[    9.340447] cryptomgr_test (550) used greatest stack depth: 12736 bytes left
[    9.349202] NET: Registered protocol family 38
[    9.350739] Key type asymmetric registered
[    9.352136] Asymmetric key parser 'x509' registered
[    9.353949] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 248)
[    9.356945] io scheduler noop registered
[    9.358463] io scheduler deadline registered
[    9.360065] io scheduler cfq registered (default)
[    9.361698] io scheduler mq-deadline registered
[    9.365516] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    9.407783] pcieport 0000:00:01.0: Signaling PME with IRQ 25
[    9.409797] pcieport 0000:00:01.1: Signaling PME with IRQ 26
[    9.411772] pcieport 0000:00:02.0: Signaling PME with IRQ 28
[    9.413764] pcieport 0000:00:02.1: Signaling PME with IRQ 29
[    9.415742] pcieport 0000:00:02.2: Signaling PME with IRQ 30
[    9.417771] pcieport 0000:00:02.3: Signaling PME with IRQ 31
[    9.419747] pcieport 0000:00:03.0: Signaling PME with IRQ 33
[    9.421728] pcieport 0000:00:03.1: Signaling PME with IRQ 34
[    9.423698] pcieport 0000:00:03.2: Signaling PME with IRQ 35
[    9.426303] pcieport 0000:00:03.3: Signaling PME with IRQ 36
[    9.428285] pcieport 0000:00:1c.2: Signaling PME with IRQ 37
[    9.430374] pcieport 0000:00:1c.4: Signaling PME with IRQ 38
[    9.432488] pcieport 0000:00:1c.6: Signaling PME with IRQ 39
[    9.434461] pcieport 0000:00:1c.7: Signaling PME with IRQ 40
[    9.436531] pcieport 0000:80:00.0: Signaling PME with IRQ 41
[    9.438491] pcieport 0000:80:01.0: Signaling PME with IRQ 43
[    9.440466] pcieport 0000:80:01.1: Signaling PME with IRQ 44
[    9.442404] pcieport 0000:80:02.0: Signaling PME with IRQ 46
[    9.444385] pcieport 0000:80:02.1: Signaling PME with IRQ 47
[    9.446436] pcieport 0000:80:02.2: Signaling PME with IRQ 48
[    9.448428] pcieport 0000:80:02.3: Signaling PME with IRQ 49
[    9.450392] pcieport 0000:80:03.0: Signaling PME with IRQ 51
[    9.452367] pcieport 0000:80:03.1: Signaling PME with IRQ 52
[    9.454328] pcieport 0000:80:03.2: Signaling PME with IRQ 53
[    9.456442] pcieport 0000:80:03.3: Signaling PME with IRQ 54
[    9.458793] efifb: probing for efifb
[    9.460317] efifb: framebuffer at 0x91000000, using 3072k, total 3072k
[    9.462444] efifb: mode is 1024x768x32, linelength=4096, pages=1
[    9.464414] efifb: scrolling: redraw
[    9.465599] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    9.502969] Console: switching to colour frame buffer device 128x48
[    9.538700] fb0: EFI VGA frame buffer device
[    9.540136] intel_idle: MWAIT substates: 0x2120
[    9.540140] intel_idle: v0.4.1 model 0x4F
[    9.554018] intel_idle: lapic_timer_reliable_states 0xffffffff
[    9.554911] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    9.557709] ACPI: Power Button [PWRF]
[    9.572097] ERST: Error Record Serialization Table (ERST) support is initialized.
[    9.574611] pstore: using zlib compression
[    9.576023] pstore: Registered erst as persistent store backend
[    9.578250] ghes_edac: This EDAC driver relies on BIOS to enumerate memory and get error reports.
[    9.581162] ghes_edac: Unfortunately, not all BIOSes reflect the memory layout correctly.
[    9.583817] ghes_edac: So, the end result of using this driver varies from vendor to vendor.
[    9.586624] ghes_edac: If you find incorrect reports, please contact your hardware vendor
[    9.589289] ghes_edac: to correct its BIOS.
[    9.590647] ghes_edac: This system has 24 DIMM sockets.
[    9.593636] EDAC MC0: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
[    9.597188] EDAC MC1: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
[    9.600854] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
[    9.604187] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    9.627094] 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[   10.050669] 00:03: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[   10.063082] Non-volatile memory driver v1.3
[   10.064697] Linux agpgart interface v0.103
[   10.100333] ahci 0000:00:1f.2: version 3.0
[   10.101870] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x20 impl SATA mode
[   10.104611] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[   10.110084] scsi host0: ahci
[   10.111884] scsi host1: ahci
[   10.113533] scsi host2: ahci
[   10.115172] scsi host3: ahci
[   10.116939] scsi host4: ahci
[   10.118534] scsi host5: ahci
[   10.119756] ata1: DUMMY
[   10.120610] ata2: DUMMY
[   10.121445] ata3: DUMMY
[   10.122279] ata4: DUMMY
[   10.123119] ata5: DUMMY
[   10.123927] ata6: SATA max UDMA/133 abar m2048@0x95400000 port 0x95400380 irq 55
[   10.127528] libphy: Fixed MDIO Bus: probed
[   10.129184] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.131356] ehci-pci: EHCI PCI platform driver
[   10.134942] ehci-pci 0000:00:1a.0: EHCI Host Controller
[   10.137214] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[   10.144131] tsc: Refined TSC clocksource calibration: 2097.569 MHz
[   10.144365] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1e3c37e06c0, max_idle_ns: 440795213283 ns
[   10.439143] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   10.539699] ata6.00: ATAPI: hp      DVD A  DU8A6SH, DHJ2, max UDMA/133
[   10.549170] ehci-pci 0000:00:1a.0: debug port 2
[   10.550721] ata6.00: configured for UDMA/133
[   10.554652] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[   10.554711] ehci-pci 0000:00:1a.0: irq 18, io mem 0x95402000
[   10.563103] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   10.565425] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   10.567773] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.567822] scsi 5:0:0:0: CD-ROM            hp       DVD A  DU8A6SH   DHJ2 PQ: 0 ANSI: 5
[   10.572771] usb usb1: Product: EHCI Host Controller
[   10.574364] usb usb1: Manufacturer: Linux 4.14.0-rc4-v414rc4-8a5776a5f498 ehci_hcd
[   10.576879] usb usb1: SerialNumber: 0000:00:1a.0
[   10.579030] hub 1-0:1.0: USB hub found
[   10.633755] hub 1-0:1.0: 2 ports detected
[   11.084308] ehci-pci 0000:00:1d.0: EHCI Host Controller
[   11.086347] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   11.088827] ehci-pci 0000:00:1d.0: debug port 2
[   11.094291] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[   11.094303] ehci-pci 0000:00:1d.0: irq 18, io mem 0x95401000
[   11.102135] sr 5:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   11.103067] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   11.103243] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   11.103245] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.103247] usb usb2: Product: EHCI Host Controller
[   11.103249] usb usb2: Manufacturer: Linux 4.14.0-rc4-v414rc4-8a5776a5f498 ehci_hcd
[   11.103251] usb usb2: SerialNumber: 0000:00:1d.0
[   11.103692] hub 2-0:1.0: USB hub found
[   11.103718] hub 2-0:1.0: 2 ports detected
[   11.104678] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   11.104695] ohci-pci: OHCI PCI platform driver
[   11.104949] uhci_hcd: USB Universal Host Controller Interface driver
[   11.105309] uhci_hcd 0000:01:00.4: UHCI Host Controller
[   11.105547] uhci_hcd 0000:01:00.4: new USB bus registered, assigned bus number 3
[   11.105583] uhci_hcd 0000:01:00.4: detected 8 ports
[   11.105584] uhci_hcd 0000:01:00.4: port count misdetected? forcing to 2 ports
[   11.105652] uhci_hcd 0000:01:00.4: irq 19, io base 0x00001300
[   11.105874] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   11.105876] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.105878] usb usb3: Product: UHCI Host Controller
[   11.105880] usb usb3: Manufacturer: Linux 4.14.0-rc4-v414rc4-8a5776a5f498 uhci_hcd
[   11.105881] usb usb3: SerialNumber: 0000:01:00.4
[   11.106326] hub 3-0:1.0: USB hub found
[   11.106354] hub 3-0:1.0: 2 ports detected
[   11.108667] xhci_hcd 0000:00:14.0: xHCI Host Controller
[   11.108865] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[   11.110141] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00009810
[   11.110150] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[   11.110464] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[   11.110466] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.110468] usb usb4: Product: xHCI Host Controller
[   11.110470] usb usb4: Manufacturer: Linux 4.14.0-rc4-v414rc4-8a5776a5f498 xhci-hcd
[   11.110472] usb usb4: SerialNumber: 0000:00:14.0
[   11.110947] hub 4-0:1.0: USB hub found
[   11.111033] hub 4-0:1.0: 15 ports detected
[   11.113677] xhci_hcd 0000:00:14.0: xHCI Host Controller
[   11.113906] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 5
[   11.114088] usb usb5: New USB device found, idVendor=1d6b, idProduct=0003
[   11.114091] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.114093] usb usb5: Product: xHCI Host Controller
[   11.114095] usb usb5: Manufacturer: Linux 4.14.0-rc4-v414rc4-8a5776a5f498 xhci-hcd
[   11.114097] usb usb5: SerialNumber: 0000:00:14.0
[   11.114673] hub 5-0:1.0: USB hub found
[   11.114731] hub 5-0:1.0: 6 ports detected
[   11.116248] usbcore: registered new interface driver usbserial
[   11.116274] usbcore: registered new interface driver usbserial_generic
[   11.116408] usbserial: USB Serial support registered for generic
[   11.116484] i8042: PNP: No PS/2 controller found.
[   11.116485] i8042: Probing ports directly.
[   11.636225] i8042: Can't read CTR while initializing i8042
[   12.103590] cdrom: Uniform CD-ROM driver Revision: 3.20
[   12.105461] clocksource: Switched to clocksource tsc
[   12.105486] i8042: probe of i8042 failed with error -5
[   12.105976] mousedev: PS/2 mouse device common for all mice
[   12.106729] rtc_cmos 00:00: RTC can wake from S4
[   12.107148] sr 5:0:0:0: Attached scsi CD-ROM sr0
[   12.107374] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   12.107468] rtc_cmos 00:00: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   12.107598] sr 5:0:0:0: Attached scsi generic sg0 type 5
[   12.107948] device-mapper: uevent: version 1.0.3
[   12.108308] device-mapper: ioctl: 4.37.0-ioctl (2017-09-20) initialised: dm-devel@redhat.com
[   12.114632] hidraw: raw HID events driver (C) Jiri Kosina
[   12.114826] usbcore: registered new interface driver usbhid
[   12.114827] usbhid: USB HID core driver
[   12.116038] drop_monitor: Initializing network drop monitor service
[   12.116468] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.322072] usb 2-1: new high-speed USB device number 2 using ehci-pci
[   12.322134] usb 1-1: new high-speed USB device number 2 using ehci-pci
[   12.322158] usb 4-3: new high-speed USB device number 2 using xhci_hcd
[   12.448231] usb 4-3: New USB device found, idVendor=0424, idProduct=2660
[   12.448234] usb 4-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   12.448816] hub 4-3:1.0: USB hub found
[   12.448861] hub 4-3:1.0: 2 ports detected
[   12.450485] usb 2-1: New USB device found, idVendor=8087, idProduct=8002
[   12.450488] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   12.450616] usb 1-1: New USB device found, idVendor=8087, idProduct=800a
[   12.450618] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   12.451132] hub 2-1:1.0: USB hub found
[   12.451303] hub 1-1:1.0: USB hub found
[   12.451326] hub 2-1:1.0: 8 ports detected
[   12.451486] hub 1-1:1.0: 6 ports detected
[   12.563093] usb 4-12: new low-speed USB device number 3 using xhci_hcd
[   12.625137] Initializing XFRM netlink socket
[   12.625811] NET: Registered protocol family 10
[   12.632926] Segment Routing with IPv6
[   12.632963] mip6: Mobile IPv6
[   12.632987] NET: Registered protocol family 17
[   12.632995] start plist test
[   12.634010] end plist test
[   12.656557] RAS: Correctable Errors collector initialized.
[   12.656707] microcode: sig=0x406f1, pf=0x1, revision=0xb00001e
[   12.660585] microcode: Microcode Update Driver: v2.2.
[   12.660618] AVX2 version of gcm_enc/dec engaged.
[   12.660619] AES CTR mode by8 optimization enabled
[   12.687385] sched_clock: Marking stable (12687309320, 0)->(21557465951, -8870156631)
[   12.711914] usb 4-12: New USB device found, idVendor=0624, idProduct=0341
[   12.711916] usb 4-12: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   12.711918] usb 4-12: Product: HP 336047-B21
[   12.711920] usb 4-12: Manufacturer: Avocent
[   12.719501] input: Avocent HP 336047-B21 as /devices/pci0000:00/0000:00:14.0/usb4/4-12/4-12:1.0/0003:0624:0341.0001/input/input1
[   12.774978] hid-generic 0003:0624:0341.0001: input,hidraw0: USB HID v1.10 Keyboard [Avocent HP 336047-B21] on usb-0000:00:14.0-12/input0
[   12.781265] input: Avocent HP 336047-B21 as /devices/pci0000:00/0000:00:14.0/usb4/4-12/4-12:1.1/0003:0624:0341.0002/input/input2
[   12.912574] hid-generic 0003:0624:0341.0002: input,hidraw1: USB HID v1.10 Mouse [Avocent HP 336047-B21] on usb-0000:00:14.0-12/input1
[   13.078248] registered taskstats version 1
[   13.078297] Loading compiled-in X.509 certificates
[   13.113763] Loaded X.509 cert 'Build time autogenerated kernel key: 68995f8228effdc74ddd73907c03ca17608675c3'
[   13.114367] zswap: loaded using pool lzo/zbud
[   13.624100] Key type big_key registered
[   13.630310] Key type encrypted registered
[   13.637086]   Magic number: 5:729:474
[   13.638494] thermal cooling_device54: hash matches
[   13.640499] rtc_cmos 00:00: setting system clock to 2017-10-11 09:28:17 UTC (1507714097)
[   13.776845] Freeing unused kernel memory: 4720K
[   13.797875] Write protecting the kernel read-only data: 14336k
[   13.826801] Freeing unused kernel memory: 264K
[   13.848225] Freeing unused kernel memory: 40K
[   13.873052] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[   13.903127] rodata_test: all tests were successful
[   13.986167] systemd[1]: systemd 233 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN default-hierarchy=hybrid)
[   14.086122] systemd[1]: Detected architecture x86-64.
[   14.111208] systemd[1]: Running in initial RAM disk.
[   14.138113] systemd[1]: Set hostname to <localhost.localdomain>.
[   14.282611] systemd[1]: Listening on Journal Socket (/dev/log).
[   14.313168] systemd[1]: Reached target Swap.
[   14.337219] systemd[1]: Reached target Local File Systems.
[   14.366358] systemd[1]: Listening on Journal Audit Socket.
[   14.395129] systemd[1]: Reached target Timers.
[   14.421742] systemd[1]: Created slice System Slice.
[   14.510388] audit: type=1130 audit(1507714098.369:2): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-sysctl comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   14.711364] audit: type=1130 audit(1507714098.569:3): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=kmod-static-nodes comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   14.832427] audit: type=1130 audit(1507714098.691:4): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-cmdline comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   14.928185] audit: type=1130 audit(1507714098.787:5): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-tmpfiles-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   15.026165] audit: type=1130 audit(1507714098.885:6): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-vconsole-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   15.127813] audit: type=1131 audit(1507714098.885:7): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-vconsole-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   15.227258] audit: type=1130 audit(1507714099.086:8): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   15.334193] audit: type=1130 audit(1507714099.193:9): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-tmpfiles-setup-dev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   15.443271] audit: type=1130 audit(1507714099.302:10): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-udevd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   16.122426] HP HPSA Driver (v 3.4.20-0)
[   16.142493] hpsa 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[   16.181196] audit: type=1130 audit(1507714100.040:11): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-udev-trigger comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   16.183371] hpsa 0000:03:00.0: Logical aborts not supported
[   16.221256] scsi host6: hpsa
[   16.221701] hpsa can't handle SMP requests
[   16.231271] hpsa 0000:03:00.0: scsi 6:0:0:0: added RAID              HP       P440ar           controller SSDSmartPathCap- En- Exp=1
[   16.231280] hpsa 0000:03:00.0: scsi 6:0:1:0: masked Direct-Access     HP       EH0300JDYTH      PHYS DRV SSDSmartPathCap- En- Exp=0
[   16.231283] hpsa 0000:03:00.0: scsi 6:0:2:0: masked Direct-Access     HP       EH0300JDYTH      PHYS DRV SSDSmartPathCap- En- Exp=0
[   16.231287] hpsa 0000:03:00.0: scsi 6:1:0:0: added Direct-Access     HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=1
[   16.231290] hpsa 0000:03:00.0: scsi 6:1:0:1: added Direct-Access     HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=1
[   16.231970] hpsa can't handle SMP requests
[   16.232829] scsi 6:0:0:0: RAID              HP       P440ar           2.52 PQ: 0 ANSI: 5
[   16.233691] scsi 6:1:0:0: Direct-Access     HP       LOGICAL VOLUME   2.52 PQ: 0 ANSI: 5
[   16.234579] scsi 6:1:0:1: Direct-Access     HP       LOGICAL VOLUME   2.52 PQ: 0 ANSI: 5
[   16.236119] scsi 6:0:0:0: Attached scsi generic sg1 type 12
[   16.238057] sd 6:1:0:0: [sda] 585871964 512-byte logical blocks: (300 GB/279 GiB)
[   16.238114] sd 6:1:0:0: [sda] Write Protect is off
[   16.238116] sd 6:1:0:0: [sda] Mode Sense: 73 00 00 08
[   16.238193] sd 6:1:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   16.238212] sd 6:1:0:0: Attached scsi generic sg2 type 0
[   16.239820] sd 6:1:0:1: [sdb] 585871964 512-byte logical blocks: (300 GB/279 GiB)
[   16.239874] sd 6:1:0:1: [sdb] Write Protect is off
[   16.239876] sd 6:1:0:1: [sdb] Mode Sense: 73 00 00 08
[   16.240081] sd 6:1:0:1: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   16.240083] sd 6:1:0:1: Attached scsi generic sg3 type 0
[   16.250584]  sda: sda1 sda2 sda3
[   16.252638] sd 6:1:0:0: [sda] Attached SCSI disk
[   16.258775]  sdb: sdb1
[   16.259915] sd 6:1:0:1: [sdb] Attached SCSI disk
[   16.342133] scsi_id (871) used greatest stack depth: 12672 bytes left
[   16.342148] scsi_id (872) used greatest stack depth: 12512 bytes left
[   17.154072] checking generic (91000000 300000) vs hw (91000000 1000000)
[   17.154078] fb: switching to mgag200drmfb from EFI VGA
[   17.197521] Console: switching to colour dummy device 80x25
[   17.236229] [TTM] Zone  kernel: Available graphics memory: 16326344 kiB
[   17.266869] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   17.296918] [TTM] Initializing pool allocator
[   17.316484] [TTM] Initializing DMA pool allocator
[   17.378681] fbcon: mgadrmfb (fb0) is primary device
[   17.378939] Console: switching to colour frame buffer device 128x48
[   17.584403] mgag200 0000:01:00.1: fb0: mgadrmfb frame buffer device
[   17.615180] [drm] Initialized mgag200 1.0.0 20110418 for 0000:01:00.1 on minor 0
[   17.757868] systemd-udevd (815) used greatest stack depth: 11744 bytes left
[   17.938994] random: crng init done
[   18.368457] SGI XFS with ACLs, security attributes, no debug enabled
[   18.415482] XFS (dm-0): Mounting V5 Filesystem
[   18.487146] XFS (dm-0): Ending clean mount
[   18.931556] systemd-journald[711]: Received SIGTERM from PID 1 (systemd).
[   19.067713] systemd: 17 output lines suppressed due to ratelimiting
[   19.157827] SELinux: 32768 avtab hash slots, 107464 rules.
[   19.227768] SELinux: 32768 avtab hash slots, 107464 rules.
[   19.388419] SELinux:  8 users, 14 roles, 5095 types, 313 bools, 1 sens, 1024 cats
[   19.388428] SELinux:  94 classes, 107464 rules
[   19.408822] SELinux:  Permission getrlimit in class process not defined in policy.
[   19.442867] SELinux:  Class process2 not defined in policy.
[   19.468113] SELinux:  Permission map in class file not defined in policy.
[   19.498711] SELinux:  Permission map in class dir not defined in policy.
[   19.530742] SELinux:  Permission map in class lnk_file not defined in policy.
[   19.566246] SELinux:  Permission map in class chr_file not defined in policy.
[   19.598213] SELinux:  Permission map in class blk_file not defined in policy.
[   19.630347] SELinux:  Permission map in class sock_file not defined in policy.
[   19.663545] SELinux:  Permission map in class fifo_file not defined in policy.
[   19.696224] SELinux:  Permission map in class socket not defined in policy.
[   19.727673] SELinux:  Permission map in class tcp_socket not defined in policy.
[   19.760418] SELinux:  Permission map in class udp_socket not defined in policy.
[   19.794430] SELinux:  Permission map in class rawip_socket not defined in policy.
[   19.828244] SELinux:  Permission map in class netlink_socket not defined in policy.
[   19.862902] SELinux:  Permission map in class packet_socket not defined in policy.
[   19.897181] SELinux:  Permission map in class key_socket not defined in policy.
[   19.931622] SELinux:  Permission map in class unix_stream_socket not defined in policy.
[   19.967808] SELinux:  Permission map in class unix_dgram_socket not defined in policy.
[   20.002919] SELinux:  Permission map in class netlink_route_socket not defined in policy.
[   20.041800] SELinux:  Permission map in class netlink_tcpdiag_socket not defined in policy.
[   20.082453] SELinux:  Permission map in class netlink_nflog_socket not defined in policy.
[   20.119285] SELinux:  Permission map in class netlink_xfrm_socket not defined in policy.
[   20.156581] SELinux:  Permission map in class netlink_selinux_socket not defined in policy.
[   20.194282] SELinux:  Permission map in class netlink_iscsi_socket not defined in policy.
[   20.231210] SELinux:  Permission map in class netlink_audit_socket not defined in policy.
[   20.268017] SELinux:  Permission map in class netlink_fib_lookup_socket not defined in policy.
[   20.308286] SELinux:  Permission map in class netlink_connector_socket not defined in policy.
[   20.346881] SELinux:  Permission map in class netlink_netfilter_socket not defined in policy.
[   20.385541] SELinux:  Permission map in class netlink_dnrt_socket not defined in policy.
[   20.422565] SELinux:  Permission map in class netlink_kobject_uevent_socket not defined in policy.
[   20.462814] SELinux:  Permission map in class netlink_generic_socket not defined in policy.
[   20.500267] SELinux:  Permission map in class netlink_scsitransport_socket not defined in policy.
[   20.541741] SELinux:  Permission map in class netlink_rdma_socket not defined in policy.
[   20.583176] SELinux:  Permission map in class netlink_crypto_socket not defined in policy.
[   20.620438] SELinux:  Permission map in class appletalk_socket not defined in policy.
[   20.655978] SELinux:  Permission map in class dccp_socket not defined in policy.
[   20.689739] SELinux:  Permission map in class tun_socket not defined in policy.
[   20.722594] SELinux:  Class sctp_socket not defined in policy.
[   20.748895] SELinux:  Class icmp_socket not defined in policy.
[   20.775091] SELinux:  Class ax25_socket not defined in policy.
[   20.803134] SELinux:  Class ipx_socket not defined in policy.
[   20.830190] SELinux:  Class netrom_socket not defined in policy.
[   20.857501] SELinux:  Class atmpvc_socket not defined in policy.
[   20.884985] SELinux:  Class x25_socket not defined in policy.
[   20.911852] SELinux:  Class rose_socket not defined in policy.
[   20.938804] SELinux:  Class decnet_socket not defined in policy.
[   20.966788] SELinux:  Class atmsvc_socket not defined in policy.
[   20.994063] SELinux:  Class rds_socket not defined in policy.
[   21.019611] SELinux:  Class irda_socket not defined in policy.
[   21.047013] SELinux:  Class pppox_socket not defined in policy.
[   21.077721] SELinux:  Class llc_socket not defined in policy.
[   21.105134] SELinux:  Class can_socket not defined in policy.
[   21.131011] SELinux:  Class tipc_socket not defined in policy.
[   21.157654] SELinux:  Class bluetooth_socket not defined in policy.
[   21.187346] SELinux:  Class iucv_socket not defined in policy.
[   21.214323] SELinux:  Class rxrpc_socket not defined in policy.
[   21.241960] SELinux:  Class isdn_socket not defined in policy.
[   21.269672] SELinux:  Class phonet_socket not defined in policy.
[   21.299012] SELinux:  Class ieee802154_socket not defined in policy.
[   21.328784] SELinux:  Class caif_socket not defined in policy.
[   21.355848] SELinux:  Class alg_socket not defined in policy.
[   21.383516] SELinux:  Class nfc_socket not defined in policy.
[   21.410727] SELinux:  Class vsock_socket not defined in policy.
[   21.439056] SELinux:  Class kcm_socket not defined in policy.
[   21.465990] SELinux:  Class qipcrtr_socket not defined in policy.
[   21.494580] SELinux:  Class smc_socket not defined in policy.
[   21.520916] SELinux:  Class infiniband_pkey not defined in policy.
[   21.550383] SELinux:  Class infiniband_endport not defined in policy.
[   21.581954] SELinux: the above unknown classes and permissions will be allowed
[   21.617597] SELinux:  policy capability network_peer_controls=1
[   21.646934] SELinux:  policy capability open_perms=1
[   21.670580] SELinux:  policy capability extended_socket_class=0
[   21.698694] SELinux:  policy capability always_check_network=0
[   21.726147] SELinux:  policy capability cgroup_seclabel=0
[   21.751477] SELinux:  policy capability nnp_nosuid_transition=0
[   21.779227] SELinux:  Completing initialization.
[   21.779230] SELinux:  Setting up existing superblocks.
[   21.907826] kauditd_printk_skb: 30 callbacks suppressed
[   21.907831] audit: type=1403 audit(1507714105.766:42): policy loaded auid=4294967295 ses=4294967295
[   21.910631] systemd[1]: Successfully loaded SELinux policy in 2.793410s.
[   21.933096] systemd[1]: RTC configured in localtime, applying delta of -240 minutes to system time.
[   22.104841] systemd[1]: Relabelled /dev and /run in 51.399ms.
[   22.252298] systemd (1091) used greatest stack depth: 11736 bytes left
[   22.356588] audit: type=1130 audit(1507728506.214:43): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   22.455470] audit: type=1131 audit(1507728506.214:44): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   22.554587] audit: type=1130 audit(1507728506.412:45): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=initrd-switch-root comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   22.658956] audit: type=1131 audit(1507728506.412:46): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=initrd-switch-root comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   22.758801] audit: type=1130 audit(1507728506.617:47): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   22.857184] audit: type=1131 audit(1507728506.617:48): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   22.973976] audit: type=1305 audit(1507728506.831:49): audit_enabled=1 old=1 auid=4294967295 ses=4294967295 subj=system_u:system_r:syslogd_t:s0 res=1
[   23.056353] audit: type=1130 audit(1507728506.914:50): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-fsck-root comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   23.162035] audit: type=1131 audit(1507728506.914:51): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-fsck-root comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   23.318607] gzip (1136) used greatest stack depth: 11528 bytes left
[   23.819959] systemd-journald[1120]: Received request to flush runtime journal from PID 1
[   24.455532] power_meter ACPI000D:00: Found ACPI power meter.
[   24.483208] power_meter ACPI000D:00: Ignoring unsafe software power cap!
[   24.515077] power_meter ACPI000D:00: hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[   24.600067] ipmi message handler version 39.2
[   24.720418] pcc-cpufreq: (v1.10.00) driver loaded with frequency limits: 1200 MHz, 2100 MHz
[   24.784962] ipmi device interface
[   24.928655] ipmi_si: probing via SMBIOS
[   24.934911] i801_smbus 0000:00:1f.3: enabling device (0000 -> 0003)
[   24.963101] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[   25.025130] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   25.060609] ipmi_si: Adding SMBIOS-specified kcs state machine
[   25.112826] ipmi_si IPI0001:00: ipmi_si: probing via ACPI
[   25.180723] ipmi_si IPI0001:00: [io  0x0ca2-0x0ca3] regsize 1 spacing 1 irq 0
[   25.222928] ipmi_si: ACPI-specified kcs state machine: duplicate
[   25.327818] IPMI System Interface driver.
[   25.412648] ipmi_si: probing via SPMI
[   25.418122] dca service started, version 1.12.1
[   25.471184] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   25.514711] ipmi_si: SPMI: io 0xca3 regsize 1 spacing 1 irq 0
[   25.549095] ipmi_si: Adding SPMI-specified kcs state machine
[   25.583192] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
[   25.914183] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   26.045893] ipmi_si dmi-ipmi-si.0: Found new BMC (man_id: 0x00000b, prod_id: 0x2000, dev_id: 0x13)
[   26.145944] ipmi_si dmi-ipmi-si.0: IPMI kcs interface initialized
[   27.425806] IPMI SSIF Interface driver
[   27.839471] RAPL PMU: API unit is 2^-32 Joules, 3 fixed counters, 655360 ms ovfl timer
[   27.894782] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[   27.935033] RAPL PMU: hw unit of domain package 2^-14 Joules
[   27.972168] RAPL PMU: hw unit of domain dram 2^-16 Joules
[   28.080164] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   28.312786] ioatdma 0000:00:04.0: ioat_enumerate_channels: xfercap = 1048576
[   28.640481] pps_core: LinuxPPS API ver. 1 registered
[   28.674230] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   28.815168] ioatdma 0000:00:04.0: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   28.815746] ioatdma 0000:00:04.0: desc[0]: (0x450c00000->0x450c00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   28.816124] ioatdma 0000:00:04.0: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   28.816537] ioatdma 0000:00:04.0: ioat_get_current_completion: phys_complete: 0x450c00000
[   28.817295] ioatdma 0000:00:04.0: __cleanup: head: 0x1 tail: 0x0 issued: 0x1
[   28.817485] ioatdma 0000:00:04.0: desc[0]: (0x450c00000->0x450c00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   28.817671] ioatdma 0000:00:04.0: __cleanup: cancel completion timeout
[   28.818655] ioatdma 0000:00:04.0: ioat_check_space_lock: num_descs: 1 (1:1:1)
[   28.819040] ioatdma 0000:00:04.0: desc[1]: (0x450c00040->0x450c00080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   28.819237] ioatdma 0000:00:04.0: desc[1]: (0x450c00040->0x450c00080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   28.819435] ioatdma 0000:00:04.0: ioat_tx_submit_unlock: cookie: 2
[   28.820759] ioatdma 0000:00:04.0: __ioat_issue_pending: head: 0x2 tail: 0x1 issued: 0x2 count: 0x2
[   28.821725] ioatdma 0000:00:04.0: ioat_get_current_completion: phys_complete: 0x450c00040
[   28.821912] ioatdma 0000:00:04.0: __cleanup: head: 0x2 tail: 0x1 issued: 0x2
[   28.822305] ioatdma 0000:00:04.0: desc[1]: (0x450c00040->0x450c00080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   28.824018] ioatdma 0000:00:04.0: __cleanup: cancel completion timeout
[   28.828263] ioatdma 0000:00:04.0: ioat_get_current_completion: phys_complete: 0x450c00040
[   28.828841] ioatdma 0000:00:04.0: freeing 65536 idle descriptors
[   29.189766] PTP clock support registered
[   29.208205] ioatdma 0000:00:04.0: ioat_xor_val_self_test
[   29.215484] hpwdt 0000:01:00.0: HPE Watchdog Timer Driver: NMI decoding initialized, allow kernel dump: ON (default = 1/ON)
[   29.305809] hpwdt 0000:01:00.0: HPE Watchdog Timer Driver: 1.4.0, timer margin: 30 seconds (nowayout=0).
[   29.605262] ioatdma 0000:00:04.1: ioat_enumerate_channels: xfercap = 1048576
[   30.086140] ioatdma 0000:00:04.1: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   30.086148] ioatdma 0000:00:04.1: desc[0]: (0x44e200000->0x44e200040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   30.086332] ioatdma 0000:00:04.1: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   30.087070] ioatdma 0000:00:04.1: ioat_check_space_lock: num_descs: 1 (1:0:1)
[   30.087267] ioatdma 0000:00:04.1: desc[1]: (0x44e200040->0x44e200080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   30.087457] ioatdma 0000:00:04.1: desc[1]: (0x44e200040->0x44e200080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   30.087641] ioatdma 0000:00:04.1: ioat_tx_submit_unlock: cookie: 2
[   30.087827] ioatdma 0000:00:04.1: __ioat_issue_pending: head: 0x2 tail: 0x0 issued: 0x2 count: 0x2
[   30.094898] ioatdma 0000:00:04.1: ioat_get_current_completion: phys_complete: 0x44e200040
[   30.095096] ioatdma 0000:00:04.1: __cleanup: head: 0x2 tail: 0x0 issued: 0x2
[   30.095102] ioatdma 0000:00:04.1: desc[0]: (0x44e200000->0x44e200040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   30.095298] ioatdma 0000:00:04.1: desc[1]: (0x44e200040->0x44e200080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   30.095483] ioatdma 0000:00:04.1: __cleanup: cancel completion timeout
[   30.095852] ioatdma 0000:00:04.1: ioat_get_current_completion: phys_complete: 0x44e200040
[   30.096800] ioatdma 0000:00:04.1: ioat_get_current_completion: phys_complete: 0x44e200040
[   30.097184] ioatdma 0000:00:04.1: freeing 65536 idle descriptors
[   30.598718] ioatdma 0000:00:04.1: ioat_xor_val_self_test
[   30.626773] tg3.c:v3.137 (May 11, 2014)
[   30.923974] ioatdma 0000:00:04.2: ioat_enumerate_channels: xfercap = 1048576
[   31.385495] ioatdma 0000:00:04.2: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   31.385676] ioatdma 0000:00:04.2: desc[0]: (0x44dc00000->0x44dc00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   31.385681] ioatdma 0000:00:04.2: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   31.386263] ioatdma 0000:00:04.2: ioat_get_current_completion: phys_complete: 0x44dc00000
[   31.386454] ioatdma 0000:00:04.2: __cleanup: head: 0x1 tail: 0x0 issued: 0x1
[   31.386458] ioatdma 0000:00:04.2: desc[0]: (0x44dc00000->0x44dc00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   31.386641] ioatdma 0000:00:04.2: __cleanup: cancel completion timeout
[   31.387370] ioatdma 0000:00:04.2: ioat_check_space_lock: num_descs: 1 (1:1:1)
[   31.387554] ioatdma 0000:00:04.2: desc[1]: (0x44dc00040->0x44dc00080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   31.387734] ioatdma 0000:00:04.2: desc[1]: (0x44dc00040->0x44dc00080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   31.387923] ioatdma 0000:00:04.2: ioat_tx_submit_unlock: cookie: 2
[   31.388154] ioatdma 0000:00:04.2: __ioat_issue_pending: head: 0x2 tail: 0x1 issued: 0x2 count: 0x2
[   31.388347] ioatdma 0000:00:04.2: ioat_get_current_completion: phys_complete: 0x44dc00040
[   31.388526] ioatdma 0000:00:04.2: __cleanup: head: 0x2 tail: 0x1 issued: 0x2
[   31.388705] ioatdma 0000:00:04.2: desc[1]: (0x44dc00040->0x44dc00080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   31.388888] ioatdma 0000:00:04.2: __cleanup: cancel completion timeout
[   31.399533] ioatdma 0000:00:04.2: ioat_get_current_completion: phys_complete: 0x44dc00040
[   31.399906] ioatdma 0000:00:04.2: freeing 65536 idle descriptors
[   31.825282] ioatdma 0000:00:04.2: ioat_xor_val_self_test
[   32.440230] ioatdma 0000:00:04.3: ioat_enumerate_channels: xfercap = 1048576
[   32.803626] ioatdma 0000:00:04.3: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   32.803823] ioatdma 0000:00:04.3: desc[0]: (0x44e200000->0x44e200040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   32.804031] ioatdma 0000:00:04.3: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   32.804957] ioatdma 0000:00:04.3: ioat_check_space_lock: num_descs: 1 (1:0:1)
[   32.805140] ioatdma 0000:00:04.3: desc[1]: (0x44e200040->0x44e200080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   32.805162] ioatdma 0000:00:04.3: desc[1]: (0x44e200040->0x44e200080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   32.805342] ioatdma 0000:00:04.3: ioat_tx_submit_unlock: cookie: 2
[   32.805542] ioatdma 0000:00:04.3: __ioat_issue_pending: head: 0x2 tail: 0x0 issued: 0x2 count: 0x2
[   32.806532] ioatdma 0000:00:04.3: ioat_get_current_completion: phys_complete: 0x44e200040
[   32.806538] ioatdma 0000:00:04.3: __cleanup: head: 0x2 tail: 0x0 issued: 0x2
[   32.806732] ioatdma 0000:00:04.3: desc[0]: (0x44e200000->0x44e200040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   32.806921] ioatdma 0000:00:04.3: desc[1]: (0x44e200040->0x44e200080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   32.807305] ioatdma 0000:00:04.3: __cleanup: cancel completion timeout
[   32.808288] ioatdma 0000:00:04.3: ioat_get_current_completion: phys_complete: 0x44e200040
[   32.824343] ioatdma 0000:00:04.3: ioat_get_current_completion: phys_complete: 0x44e200040
[   32.824723] ioatdma 0000:00:04.3: freeing 65536 idle descriptors
[   32.890787] bnx2x: QLogic 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.712.30-0 (2014/02/10)
[   33.265607] ioatdma 0000:00:04.3: ioat_xor_val_self_test
[   33.268539] tg3 0000:02:00.0 eth0: Tigon3 [partno(N/A) rev 5719001] (PCI Express) MAC address 3c:a8:2a:21:7d:a4
[   33.325093] tg3 0000:02:00.0 eth0: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[   33.379855] tg3 0000:02:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[1]
[   33.430435] tg3 0000:02:00.0 eth0: dma_rwctrl[00000001] dma_mask[64-bit]
[   33.492918] bnx2x 0000:04:00.0: msix capability found
[   33.543264] bnx2x 0000:04:00.0: part number 0-0-0-0
[   33.691944] ioatdma 0000:00:04.4: ioat_enumerate_channels: xfercap = 1048576
[   34.086203] ioatdma 0000:00:04.4: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   34.086393] ioatdma 0000:00:04.4: desc[0]: (0x44dc00000->0x44dc00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   34.086942] ioatdma 0000:00:04.4: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   34.087155] ioatdma 0000:00:04.4: ioat_get_current_completion: phys_complete: 0x44dc00000
[   34.087530] ioatdma 0000:00:04.4: __cleanup: head: 0x1 tail: 0x0 issued: 0x1
[   34.087717] ioatdma 0000:00:04.4: desc[0]: (0x44dc00000->0x44dc00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   34.087898] ioatdma 0000:00:04.4: __cleanup: cancel completion timeout
[   34.088851] ioatdma 0000:00:04.4: ioat_check_space_lock: num_descs: 1 (1:1:1)
[   34.089072] ioatdma 0000:00:04.4: desc[1]: (0x44dc00040->0x44dc00080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   34.089255] ioatdma 0000:00:04.4: desc[1]: (0x44dc00040->0x44dc00080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   34.089632] ioatdma 0000:00:04.4: ioat_tx_submit_unlock: cookie: 2
[   34.089825] ioatdma 0000:00:04.4: __ioat_issue_pending: head: 0x2 tail: 0x1 issued: 0x2 count: 0x2
[   34.090620] ioatdma 0000:00:04.4: ioat_get_current_completion: phys_complete: 0x44dc00040
[   34.090804] ioatdma 0000:00:04.4: __cleanup: head: 0x2 tail: 0x1 issued: 0x2
[   34.090992] ioatdma 0000:00:04.4: desc[1]: (0x44dc00040->0x44dc00080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   34.091401] ioatdma 0000:00:04.4: __cleanup: cancel completion timeout
[   34.119648] ioatdma 0000:00:04.4: ioat_get_current_completion: phys_complete: 0x44dc00040
[   34.120023] ioatdma 0000:00:04.4: freeing 65536 idle descriptors
[   34.205927] ioatdma 0000:00:04.4: ioat_xor_val_self_test
[   34.301455] tg3 0000:02:00.1 eth1: Tigon3 [partno(N/A) rev 5719001] (PCI Express) MAC address 3c:a8:2a:21:7d:a5
[   34.417696] ioatdma 0000:00:04.5: ioat_enumerate_channels: xfercap = 1048576
[   34.730443] ioatdma 0000:00:04.5: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   34.730449] ioatdma 0000:00:04.5: desc[0]: (0x44e200000->0x44e200040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   34.730452] ioatdma 0000:00:04.5: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   34.730460] ioatdma 0000:00:04.5: ioat_get_current_completion: phys_complete: 0x44e200000
[   34.730464] ioatdma 0000:00:04.5: __cleanup: head: 0x1 tail: 0x0 issued: 0x1
[   34.730467] ioatdma 0000:00:04.5: desc[0]: (0x44e200000->0x44e200040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   34.730469] ioatdma 0000:00:04.5: __cleanup: cancel completion timeout
[   34.730487] ioatdma 0000:00:04.5: ioat_check_space_lock: num_descs: 1 (1:1:1)
[   34.730489] ioatdma 0000:00:04.5: desc[1]: (0x44e200040->0x44e200080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   34.730492] ioatdma 0000:00:04.5: desc[1]: (0x44e200040->0x44e200080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   34.730496] ioatdma 0000:00:04.5: ioat_tx_submit_unlock: cookie: 2
[   34.730501] ioatdma 0000:00:04.5: __ioat_issue_pending: head: 0x2 tail: 0x1 issued: 0x2 count: 0x2
[   34.730506] ioatdma 0000:00:04.5: ioat_get_current_completion: phys_complete: 0x44e200040
[   34.730508] ioatdma 0000:00:04.5: __cleanup: head: 0x2 tail: 0x1 issued: 0x2
[   34.730511] ioatdma 0000:00:04.5: desc[1]: (0x44e200040->0x44e200080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   34.730514] ioatdma 0000:00:04.5: __cleanup: cancel completion timeout
[   34.744954] tg3 0000:02:00.1 eth1: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[   34.745164] tg3 0000:02:00.1 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[1]
[   34.745360] tg3 0000:02:00.1 eth1: dma_rwctrl[00000001] dma_mask[64-bit]
[   34.748545] ioatdma 0000:00:04.5: ioat_get_current_completion: phys_complete: 0x44e200040
[   34.748911] ioatdma 0000:00:04.5: freeing 65536 idle descriptors
[   35.179299] ioatdma 0000:00:04.5: ioat_xor_val_self_test
[   35.467984] ioatdma 0000:00:04.6: ioat_enumerate_channels: xfercap = 1048576
[   35.876332] ioatdma 0000:00:04.6: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   35.876684] ioatdma 0000:00:04.6: desc[0]: (0x44dc00000->0x44dc00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   35.876689] ioatdma 0000:00:04.6: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   35.877446] ioatdma 0000:00:04.6: ioat_check_space_lock: num_descs: 1 (1:0:1)
[   35.877452] ioatdma 0000:00:04.6: desc[1]: (0x44dc00040->0x44dc00080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   35.877648] ioatdma 0000:00:04.6: desc[1]: (0x44dc00040->0x44dc00080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   35.877844] ioatdma 0000:00:04.6: ioat_tx_submit_unlock: cookie: 2
[   35.878229] ioatdma 0000:00:04.6: __ioat_issue_pending: head: 0x2 tail: 0x0 issued: 0x2 count: 0x2
[   35.887410] ioatdma 0000:00:04.6: ioat_get_current_completion: phys_complete: 0x44dc00040
[   35.887596] ioatdma 0000:00:04.6: __cleanup: head: 0x2 tail: 0x0 issued: 0x2
[   35.887784] ioatdma 0000:00:04.6: desc[0]: (0x44dc00000->0x44dc00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   35.888161] ioatdma 0000:00:04.6: desc[1]: (0x44dc00040->0x44dc00080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   35.888552] ioatdma 0000:00:04.6: __cleanup: cancel completion timeout
[   35.889293] ioatdma 0000:00:04.6: ioat_get_current_completion: phys_complete: 0x44dc00040
[   35.900907] ioatdma 0000:00:04.6: ioat_get_current_completion: phys_complete: 0x44dc00040
[   35.901323] ioatdma 0000:00:04.6: freeing 65536 idle descriptors
[   35.943889] ioatdma 0000:00:04.6: ioat_xor_val_self_test
[   36.084003] ioatdma 0000:00:04.7: ioat_enumerate_channels: xfercap = 1048576
[   36.510155] ioatdma 0000:00:04.7: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   36.510338] ioatdma 0000:00:04.7: desc[0]: (0x44e200000->0x44e200040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   36.511452] ioatdma 0000:00:04.7: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   36.512056] ioatdma 0000:00:04.7: ioat_check_space_lock: num_descs: 1 (1:0:1)
[   36.512258] ioatdma 0000:00:04.7: desc[1]: (0x44e200040->0x44e200080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   36.512434] ioatdma 0000:00:04.7: desc[1]: (0x44e200040->0x44e200080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   36.512624] ioatdma 0000:00:04.7: ioat_tx_submit_unlock: cookie: 2
[   36.512805] ioatdma 0000:00:04.7: __ioat_issue_pending: head: 0x2 tail: 0x0 issued: 0x2 count: 0x2
[   36.526314] ioatdma 0000:00:04.7: ioat_get_current_completion: phys_complete: 0x44e200040
[   36.526493] ioatdma 0000:00:04.7: __cleanup: head: 0x2 tail: 0x0 issued: 0x2
[   36.526684] ioatdma 0000:00:04.7: desc[0]: (0x44e200000->0x44e200040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   36.526865] ioatdma 0000:00:04.7: desc[1]: (0x44e200040->0x44e200080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   36.527074] ioatdma 0000:00:04.7: __cleanup: cancel completion timeout
[   36.527819] ioatdma 0000:00:04.7: ioat_get_current_completion: phys_complete: 0x44e200040
[   36.528982] ioatdma 0000:00:04.7: ioat_get_current_completion: phys_complete: 0x44e200040
[   36.529951] ioatdma 0000:00:04.7: freeing 65536 idle descriptors
[   36.947888] ioatdma 0000:00:04.7: ioat_xor_val_self_test
[   37.084329] ioatdma 0000:80:04.0: ioat_enumerate_channels: xfercap = 1048576
[   37.226319] bnx2x 0000:04:00.1: msix capability found
[   37.288481] bnx2x 0000:04:00.1: part number 0-0-0-0
[   37.534662] tg3 0000:02:00.2 eth3: Tigon3 [partno(N/A) rev 5719001] (PCI Express) MAC address 3c:a8:2a:21:7d:a6
[   37.598593] tg3 0000:02:00.2 eth3: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[   37.648497] ioatdma 0000:80:04.0: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   37.648682] ioatdma 0000:80:04.0: desc[0]: (0xc55c00000->0xc55c00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   37.648686] ioatdma 0000:80:04.0: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   37.649084] ioatdma 0000:80:04.0: ioat_get_current_completion: phys_complete: 0xc55c00000
[   37.649275] ioatdma 0000:80:04.0: __cleanup: head: 0x1 tail: 0x0 issued: 0x1
[   37.649278] ioatdma 0000:80:04.0: desc[0]: (0xc55c00000->0xc55c00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   37.649461] ioatdma 0000:80:04.0: __cleanup: cancel completion timeout
[   37.650041] ioatdma 0000:80:04.0: ioat_check_space_lock: num_descs: 1 (1:1:1)
[   37.650044] ioatdma 0000:80:04.0: desc[1]: (0xc55c00040->0xc55c00080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   37.650047] ioatdma 0000:80:04.0: desc[1]: (0xc55c00040->0xc55c00080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   37.650233] ioatdma 0000:80:04.0: ioat_tx_submit_unlock: cookie: 2
[   37.650425] ioatdma 0000:80:04.0: __ioat_issue_pending: head: 0x2 tail: 0x1 issued: 0x2 count: 0x2
[   37.650613] ioatdma 0000:80:04.0: ioat_get_current_completion: phys_complete: 0xc55c00040
[   37.650616] ioatdma 0000:80:04.0: __cleanup: head: 0x2 tail: 0x1 issued: 0x2
[   37.650618] ioatdma 0000:80:04.0: desc[1]: (0xc55c00040->0xc55c00080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   37.650809] ioatdma 0000:80:04.0: __cleanup: cancel completion timeout
[   37.652880] ioatdma 0000:80:04.0: ioat_get_current_completion: phys_complete: 0xc55c00040
[   37.653091] ioatdma 0000:80:04.0: freeing 65536 idle descriptors
[   37.662374] tg3 0000:02:00.2 eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[1]
[   37.714137] tg3 0000:02:00.2 eth3: dma_rwctrl[00000001] dma_mask[64-bit]
[   38.240886] ioatdma 0000:80:04.0: ioat_xor_val_self_test
[   38.503905] ioatdma 0000:80:04.1: ioat_enumerate_channels: xfercap = 1048576
[   38.772571] tg3 0000:02:00.3 eth4: Tigon3 [partno(N/A) rev 5719001] (PCI Express) MAC address 3c:a8:2a:21:7d:a7
[   38.841834] tg3 0000:02:00.3 eth4: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[   38.892593] tg3 0000:02:00.3 eth4: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[1]
[   38.947546] tg3 0000:02:00.3 eth4: dma_rwctrl[00000001] dma_mask[64-bit]
[   39.109102] ioatdma 0000:80:04.1: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   39.109494] ioatdma 0000:80:04.1: desc[0]: (0xc40200000->0xc40200040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   39.110103] ioatdma 0000:80:04.1: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   39.110663] ioatdma 0000:80:04.1: ioat_get_current_completion: phys_complete: 0xc40200000
[   39.110865] ioatdma 0000:80:04.1: __cleanup: head: 0x1 tail: 0x0 issued: 0x1
[   39.111078] ioatdma 0000:80:04.1: desc[0]: (0xc40200000->0xc40200040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   39.111283] ioatdma 0000:80:04.1: __cleanup: cancel completion timeout
[   39.112414] ioatdma 0000:80:04.1: ioat_check_space_lock: num_descs: 1 (1:1:1)
[   39.112779] ioatdma 0000:80:04.1: desc[1]: (0xc40200040->0xc40200080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   39.112980] ioatdma 0000:80:04.1: desc[1]: (0xc40200040->0xc40200080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   39.113196] ioatdma 0000:80:04.1: ioat_tx_submit_unlock: cookie: 2
[   39.113759] ioatdma 0000:80:04.1: __ioat_issue_pending: head: 0x2 tail: 0x1 issued: 0x2 count: 0x2
[   39.114184] ioatdma 0000:80:04.1: ioat_get_current_completion: phys_complete: 0xc40200040
[   39.114565] ioatdma 0000:80:04.1: __cleanup: head: 0x2 tail: 0x1 issued: 0x2
[   39.114756] ioatdma 0000:80:04.1: desc[1]: (0xc40200040->0xc40200080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   39.114963] ioatdma 0000:80:04.1: __cleanup: cancel completion timeout
[   39.116671] ioatdma 0000:80:04.1: ioat_get_current_completion: phys_complete: 0xc40200040
[   39.117267] ioatdma 0000:80:04.1: freeing 65536 idle descriptors
[   39.611594] iTCO_vendor_support: vendor-support=0
[   39.695136] ioatdma 0000:80:04.1: ioat_xor_val_self_test
[   39.834436] ioatdma 0000:80:04.2: ioat_enumerate_channels: xfercap = 1048576
[   39.952401] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   39.973978] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[   40.058809] kauditd_printk_skb: 13 callbacks suppressed
[   40.058812] audit: type=1130 audit(1507728523.916:65): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=lvm2-monitor comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   40.070177] ioatdma 0000:80:04.2: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   40.070367] ioatdma 0000:80:04.2: desc[0]: (0xc3fe00000->0xc3fe00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   40.070754] ioatdma 0000:80:04.2: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   40.070944] ioatdma 0000:80:04.2: ioat_get_current_completion: phys_complete: 0xc3fe00000
[   40.071117] ioatdma 0000:80:04.2: __cleanup: head: 0x1 tail: 0x0 issued: 0x1
[   40.071138] ioatdma 0000:80:04.2: desc[0]: (0xc3fe00000->0xc3fe00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   40.071142] ioatdma 0000:80:04.2: __cleanup: cancel completion timeout
[   40.071892] ioatdma 0000:80:04.2: ioat_check_space_lock: num_descs: 1 (1:1:1)
[   40.072097] ioatdma 0000:80:04.2: desc[1]: (0xc3fe00040->0xc3fe00080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   40.072285] ioatdma 0000:80:04.2: desc[1]: (0xc3fe00040->0xc3fe00080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   40.072476] ioatdma 0000:80:04.2: ioat_tx_submit_unlock: cookie: 2
[   40.072672] ioatdma 0000:80:04.2: __ioat_issue_pending: head: 0x2 tail: 0x1 issued: 0x2 count: 0x2
[   40.072864] ioatdma 0000:80:04.2: ioat_get_current_completion: phys_complete: 0xc3fe00040
[   40.072866] ioatdma 0000:80:04.2: __cleanup: head: 0x2 tail: 0x1 issued: 0x2
[   40.073081] ioatdma 0000:80:04.2: desc[1]: (0xc3fe00040->0xc3fe00080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   40.073087] ioatdma 0000:80:04.2: __cleanup: cancel completion timeout
[   40.073654] ioatdma 0000:80:04.2: ioat_get_current_completion: phys_complete: 0xc3fe00040
[   40.074041] ioatdma 0000:80:04.2: freeing 65536 idle descriptors
[   40.531908] pmem0: detected capacity change from 0 to 8589934592
[   40.631637] ioatdma 0000:80:04.2: ioat_xor_val_self_test
[   40.665717] pmem1: detected capacity change from 0 to 8589934592
[   40.704027] ioatdma 0000:80:04.3: ioat_enumerate_channels: xfercap = 1048576
[   40.792169] pmem2: detected capacity change from 0 to 8589934592
[   40.920190] pmem3: detected capacity change from 0 to 8589934592
[   41.220074] ioatdma 0000:80:04.3: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   41.220445] ioatdma 0000:80:04.3: desc[0]: (0xc40200000->0xc40200040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   41.221002] ioatdma 0000:80:04.3: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   41.221213] ioatdma 0000:80:04.3: ioat_get_current_completion: phys_complete: 0xc40200000
[   41.221591] ioatdma 0000:80:04.3: __cleanup: head: 0x1 tail: 0x0 issued: 0x1
[   41.221777] ioatdma 0000:80:04.3: desc[0]: (0xc40200000->0xc40200040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   41.221973] ioatdma 0000:80:04.3: __cleanup: cancel completion timeout
[   41.222760] ioatdma 0000:80:04.3: ioat_check_space_lock: num_descs: 1 (1:1:1)
[   41.222945] ioatdma 0000:80:04.3: desc[1]: (0xc40200040->0xc40200080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   41.223153] ioatdma 0000:80:04.3: desc[1]: (0xc40200040->0xc40200080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   41.223348] ioatdma 0000:80:04.3: ioat_tx_submit_unlock: cookie: 2
[   41.223721] ioatdma 0000:80:04.3: __ioat_issue_pending: head: 0x2 tail: 0x1 issued: 0x2 count: 0x2
[   41.224307] ioatdma 0000:80:04.3: ioat_get_current_completion: phys_complete: 0xc40200040
[   41.224498] ioatdma 0000:80:04.3: __cleanup: head: 0x2 tail: 0x1 issued: 0x2
[   41.224880] ioatdma 0000:80:04.3: desc[1]: (0xc40200040->0xc40200080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   41.225086] ioatdma 0000:80:04.3: __cleanup: cancel completion timeout
[   41.225868] ioatdma 0000:80:04.3: ioat_get_current_completion: phys_complete: 0xc40200040
[   41.226078] ioatdma 0000:80:04.3: freeing 65536 idle descriptors
[   41.361168] tg3 0000:02:00.0 eno1: renamed from eth0
[   41.773537] ioatdma 0000:80:04.3: ioat_xor_val_self_test
[   41.827041] ioatdma 0000:80:04.4: ioat_enumerate_channels: xfercap = 1048576
[   42.342181] ioatdma 0000:80:04.4: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   42.342571] ioatdma 0000:80:04.4: desc[0]: (0xc54e00000->0xc54e00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   42.343128] ioatdma 0000:80:04.4: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   42.343720] ioatdma 0000:80:04.4: ioat_get_current_completion: phys_complete: 0xc54e00000
[   42.344097] ioatdma 0000:80:04.4: __cleanup: head: 0x1 tail: 0x0 issued: 0x1
[   42.344306] ioatdma 0000:80:04.4: desc[0]: (0xc54e00000->0xc54e00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   42.344497] ioatdma 0000:80:04.4: __cleanup: cancel completion timeout
[   42.345481] ioatdma 0000:80:04.4: ioat_check_space_lock: num_descs: 1 (1:1:1)
[   42.345663] ioatdma 0000:80:04.4: desc[1]: (0xc54e00040->0xc54e00080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   42.346034] ioatdma 0000:80:04.4: desc[1]: (0xc54e00040->0xc54e00080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   42.346236] ioatdma 0000:80:04.4: ioat_tx_submit_unlock: cookie: 2
[   42.346800] ioatdma 0000:80:04.4: __ioat_issue_pending: head: 0x2 tail: 0x1 issued: 0x2 count: 0x2
[   42.347186] ioatdma 0000:80:04.4: ioat_get_current_completion: phys_complete: 0xc54e00040
[   42.347586] ioatdma 0000:80:04.4: __cleanup: head: 0x2 tail: 0x1 issued: 0x2
[   42.347781] ioatdma 0000:80:04.4: desc[1]: (0xc54e00040->0xc54e00080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   42.348158] ioatdma 0000:80:04.4: __cleanup: cancel completion timeout
[   42.349528] ioatdma 0000:80:04.4: ioat_get_current_completion: phys_complete: 0xc54e00040
[   42.349924] ioatdma 0000:80:04.4: freeing 65536 idle descriptors
[   42.749544] bnx2x 0000:04:00.1 eno50: renamed from eth5
[   42.871789] ioatdma 0000:80:04.4: ioat_xor_val_self_test
[   42.915483] ioatdma 0000:80:04.5: ioat_enumerate_channels: xfercap = 1048576
[   42.924970] Adding 16470012k swap on /dev/mapper/fedora-swap.  Priority:-2 extents:1 across:16470012k FS
[   42.960656] ioatdma 0000:80:04.5: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   42.960661] ioatdma 0000:80:04.5: desc[0]: (0xc3fe00000->0xc3fe00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   42.960664] ioatdma 0000:80:04.5: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   42.960671] ioatdma 0000:80:04.5: ioat_get_current_completion: phys_complete: 0xc3fe00000
[   42.960674] ioatdma 0000:80:04.5: __cleanup: head: 0x1 tail: 0x0 issued: 0x1
[   42.960677] ioatdma 0000:80:04.5: desc[0]: (0xc3fe00000->0xc3fe00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   42.960679] ioatdma 0000:80:04.5: __cleanup: cancel completion timeout
[   42.960696] ioatdma 0000:80:04.5: ioat_check_space_lock: num_descs: 1 (1:1:1)
[   42.960698] ioatdma 0000:80:04.5: desc[1]: (0xc3fe00040->0xc3fe00080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   42.960701] ioatdma 0000:80:04.5: desc[1]: (0xc3fe00040->0xc3fe00080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   42.960705] ioatdma 0000:80:04.5: ioat_tx_submit_unlock: cookie: 2
[   42.960709] ioatdma 0000:80:04.5: __ioat_issue_pending: head: 0x2 tail: 0x1 issued: 0x2 count: 0x2
[   42.960713] ioatdma 0000:80:04.5: ioat_get_current_completion: phys_complete: 0xc3fe00040
[   42.960715] ioatdma 0000:80:04.5: __cleanup: head: 0x2 tail: 0x1 issued: 0x2
[   42.960718] ioatdma 0000:80:04.5: desc[1]: (0xc3fe00040->0xc3fe00080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   42.960721] ioatdma 0000:80:04.5: __cleanup: cancel completion timeout
[   42.960735] ioatdma 0000:80:04.5: ioat_get_current_completion: phys_complete: 0xc3fe00040
[   42.960743] ioatdma 0000:80:04.5: freeing 65536 idle descriptors
[   43.039872] ioatdma 0000:80:04.5: ioat_xor_val_self_test
[   43.049602] ioatdma 0000:80:04.6: ioat_enumerate_channels: xfercap = 1048576
[   43.060440] tg3 0000:02:00.1 eno2: renamed from eth1
[   43.131775] audit: type=1130 audit(1507728526.989:66): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=lvm2-pvscan@8:3 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   43.139503] ioatdma 0000:80:04.6: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   43.139508] ioatdma 0000:80:04.6: desc[0]: (0xc54e00000->0xc54e00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   43.139511] ioatdma 0000:80:04.6: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   43.139518] ioatdma 0000:80:04.6: ioat_get_current_completion: phys_complete: 0xc54e00000
[   43.139522] ioatdma 0000:80:04.6: __cleanup: head: 0x1 tail: 0x0 issued: 0x1
[   43.139524] ioatdma 0000:80:04.6: desc[0]: (0xc54e00000->0xc54e00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   43.139527] ioatdma 0000:80:04.6: __cleanup: cancel completion timeout
[   43.139543] ioatdma 0000:80:04.6: ioat_check_space_lock: num_descs: 1 (1:1:1)
[   43.139545] ioatdma 0000:80:04.6: desc[1]: (0xc54e00040->0xc54e00080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   43.139548] ioatdma 0000:80:04.6: desc[1]: (0xc54e00040->0xc54e00080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   43.139552] ioatdma 0000:80:04.6: ioat_tx_submit_unlock: cookie: 2
[   43.139557] ioatdma 0000:80:04.6: __ioat_issue_pending: head: 0x2 tail: 0x1 issued: 0x2 count: 0x2
[   43.139561] ioatdma 0000:80:04.6: ioat_get_current_completion: phys_complete: 0xc54e00040
[   43.139564] ioatdma 0000:80:04.6: __cleanup: head: 0x2 tail: 0x1 issued: 0x2
[   43.139566] ioatdma 0000:80:04.6: desc[1]: (0xc54e00040->0xc54e00080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   43.139569] ioatdma 0000:80:04.6: __cleanup: cancel completion timeout
[   43.139616] ioatdma 0000:80:04.6: ioat_get_current_completion: phys_complete: 0xc54e00040
[   43.139625] ioatdma 0000:80:04.6: freeing 65536 idle descriptors
[   43.272208] audit: type=1130 audit(1507728527.130:67): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=lvm2-pvscan@8:17 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   43.464181] ioatdma 0000:80:04.6: ioat_xor_val_self_test
[   43.713154] ioatdma 0000:80:04.7: ioat_enumerate_channels: xfercap = 1048576
[   43.731341] tg3 0000:02:00.3 eno4: renamed from eth4
[   44.152440] ioatdma 0000:80:04.7: __ioat_start_null_desc: head: 0x0 tail: 0x0 issued: 0x0
[   44.152801] ioatdma 0000:80:04.7: desc[0]: (0xc3fe00000->0xc3fe00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   44.153586] ioatdma 0000:80:04.7: __ioat_issue_pending: head: 0x1 tail: 0x0 issued: 0x1 count: 0x1
[   44.153973] ioatdma 0000:80:04.7: ioat_get_current_completion: phys_complete: 0xc3fe00000
[   44.154169] ioatdma 0000:80:04.7: __cleanup: head: 0x1 tail: 0x0 issued: 0x1
[   44.154176] ioatdma 0000:80:04.7: desc[0]: (0xc3fe00000->0xc3fe00040) cookie: 0 flags: 0x2 ctl: 0x00000029 (op: 0x0 int_en: 1 compl: 1)
[   44.154363] ioatdma 0000:80:04.7: __cleanup: cancel completion timeout
[   44.155343] ioatdma 0000:80:04.7: ioat_check_space_lock: num_descs: 1 (1:1:1)
[   44.155538] ioatdma 0000:80:04.7: desc[1]: (0xc3fe00040->0xc3fe00080) cookie: 0 flags: 0x0 ctl: 0x00000000 (op: 0x0 int_en: 0 compl: 0)
[   44.155921] ioatdma 0000:80:04.7: desc[1]: (0xc3fe00040->0xc3fe00080) cookie: 0 flags: 0x1 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   44.156338] ioatdma 0000:80:04.7: ioat_tx_submit_unlock: cookie: 2
[   44.156755] ioatdma 0000:80:04.7: __ioat_issue_pending: head: 0x2 tail: 0x1 issued: 0x2 count: 0x2
[   44.157139] ioatdma 0000:80:04.7: ioat_get_current_completion: phys_complete: 0xc3fe00040
[   44.157329] ioatdma 0000:80:04.7: __cleanup: head: 0x2 tail: 0x1 issued: 0x2
[   44.157700] ioatdma 0000:80:04.7: desc[1]: (0xc3fe00040->0xc3fe00080) cookie: 2 flags: 0x3 ctl: 0x00000009 (op: 0x0 int_en: 1 compl: 1)
[   44.157903] ioatdma 0000:80:04.7: __cleanup: cancel completion timeout
[   44.159848] ioatdma 0000:80:04.7: ioat_get_current_completion: phys_complete: 0xc3fe00040
[   44.160256] ioatdma 0000:80:04.7: freeing 65536 idle descriptors
[   44.735772] ioatdma 0000:80:04.7: ioat_xor_val_self_test
[   44.764484] bnx2x 0000:04:00.0 eno49: renamed from eth2
[   49.094312] tg3 0000:02:00.2 eno3: renamed from eth3
[   58.809813] perf: interrupt took too long (3084 > 2500), lowering kernel.perf_event_max_sample_rate to 64000
[   59.659700] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   59.659834] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   59.659984] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   59.660268] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   59.660379] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   59.660505] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   59.660553] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   59.660663] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   59.660787] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   59.661395] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   59.661865] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   59.661988] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   59.662048] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   59.662161] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   59.662283] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   59.662326] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   59.662440] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   59.662562] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   59.662604] EDAC sbridge: Seeking for: PCI ID 8086:6fac
[   59.662860] EDAC sbridge: Seeking for: PCI ID 8086:6fad
[   59.664771] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   59.665294] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   59.665418] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   59.665447] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   59.665574] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   59.665697] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   59.665725] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   59.665853] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   59.667316] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   59.667693] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   59.667822] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   59.668493] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   59.668520] EDAC sbridge: Seeking for: PCI ID 8086:6f6c
[   59.668775] EDAC sbridge: Seeking for: PCI ID 8086:6f6d
[   59.669051] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   59.669697] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   59.669820] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   59.669880] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   59.669976] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   59.670297] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   59.670356] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   59.670472] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   59.670595] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   59.695392] EDAC sbridge: Couldn't find mci handler
[   59.729042] EDAC sbridge: Couldn't find mci handler
[   59.764420] EDAC sbridge: Couldn't find mci handler
[   59.797220] EDAC sbridge: Couldn't find mci handler
[   59.822143] EDAC sbridge: Failed to register device with error -22.
[   59.889657] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   59.889717] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   59.889787] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   59.889815] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   59.889874] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   59.889940] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   59.889965] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   59.890245] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   59.890311] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   59.890335] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   59.890394] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   59.890459] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   59.890482] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   59.890772] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   59.890837] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   59.890860] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   59.890920] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   59.890985] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   59.891019] EDAC sbridge: Seeking for: PCI ID 8086:6fac
[   59.891411] EDAC sbridge: Seeking for: PCI ID 8086:6fad
[   59.891550] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   59.891634] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   59.891685] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   59.891698] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   59.891751] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   59.891802] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   59.891814] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   59.891868] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   59.891919] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   59.891931] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   59.891985] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   59.892509] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   59.892523] EDAC sbridge: Seeking for: PCI ID 8086:6f6c
[   59.892662] EDAC sbridge: Seeking for: PCI ID 8086:6f6d
[   59.892811] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   59.892851] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   59.892902] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   59.892928] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   59.892968] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   59.893058] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   59.893087] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   59.893361] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   59.893426] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   59.893567] EDAC sbridge: Couldn't find mci handler
[   59.918126] EDAC sbridge: Couldn't find mci handler
[   59.942540] EDAC sbridge: Couldn't find mci handler
[   59.966456] EDAC sbridge: Couldn't find mci handler
[   59.990559] EDAC sbridge: Failed to register device with error -22.
[   60.062061] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.062135] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.062199] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.062226] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.062295] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.062368] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.062391] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.062442] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.062498] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.062519] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.062570] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.062626] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.062646] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.062698] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.062754] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.062774] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.062826] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.062882] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.062901] EDAC sbridge: Seeking for: PCI ID 8086:6fac
[   60.063297] EDAC sbridge: Seeking for: PCI ID 8086:6fad
[   60.063550] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.063673] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.063775] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.063801] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.063908] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.064038] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.064283] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.064406] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.064526] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.064553] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.064675] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.064775] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.064797] EDAC sbridge: Seeking for: PCI ID 8086:6f6c
[   60.065062] EDAC sbridge: Seeking for: PCI ID 8086:6f6d
[   60.065299] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.065409] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.065520] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.065567] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.065661] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.065785] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.065848] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.065963] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.066452] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.066685] EDAC sbridge: Couldn't find mci handler
[   60.090752] EDAC sbridge: Couldn't find mci handler
[   60.090753] EDAC sbridge: Couldn't find mci handler
[   60.090754] EDAC sbridge: Couldn't find mci handler
[   60.090757] EDAC sbridge: Failed to register device with error -22.
[   60.216285] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.216365] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.216638] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.216674] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.216733] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.216977] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.217031] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.217090] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.217155] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.217180] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.217254] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.217312] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.217348] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.217616] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.217681] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.217704] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.217764] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.218025] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.218048] EDAC sbridge: Seeking for: PCI ID 8086:6fac
[   60.218384] EDAC sbridge: Seeking for: PCI ID 8086:6fad
[   60.218554] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.218629] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.218701] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.218725] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.218798] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.218863] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.218879] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.218946] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.219024] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.219217] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.219286] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.219353] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.219373] EDAC sbridge: Seeking for: PCI ID 8086:6f6c
[   60.219405] intel_rapl: Found RAPL domain package
[   60.219623] EDAC sbridge: Seeking for: PCI ID 8086:6f6d
[   60.219875] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.220699] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.220816] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.220873] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.220992] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.221121] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.221168] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.221276] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.221364] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.221494] EDAC sbridge: Couldn't find mci handler
[   60.221495] EDAC sbridge: Couldn't find mci handler
[   60.221496] EDAC sbridge: Couldn't find mci handler
[   60.221498] EDAC sbridge: Couldn't find mci handler
[   60.221500] EDAC sbridge: Failed to register device with error -22.
[   60.382763] intel_rapl: Found RAPL domain dram
[   60.405167] intel_rapl: DRAM domain energy unit 15300pj
[   60.432377] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.432438] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.432728] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.432757] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.432815] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.432882] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.432908] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.432918] intel_rapl: Found RAPL domain package
[   60.432980] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.433054] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.433074] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.433543] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.433606] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.433810] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.433868] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.433932] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.433954] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.434024] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.434454] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.434475] EDAC sbridge: Seeking for: PCI ID 8086:6fac
[   60.434612] EDAC sbridge: Seeking for: PCI ID 8086:6fad
[   60.434927] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.434992] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.435065] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.435079] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.435157] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.435215] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.435228] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.435320] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.435404] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.435414] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.435467] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.435517] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.435527] EDAC sbridge: Seeking for: PCI ID 8086:6f6c
[   60.435636] EDAC sbridge: Seeking for: PCI ID 8086:6f6d
[   60.435745] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.435784] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.435834] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.435858] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.435897] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.435946] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.435970] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.436042] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.436328] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.436659] EDAC sbridge: Couldn't find mci handler
[   60.436661] EDAC sbridge: Couldn't find mci handler
[   60.436662] EDAC sbridge: Couldn't find mci handler
[   60.436664] EDAC sbridge: Couldn't find mci handler
[   60.436667] EDAC sbridge: Failed to register device with error -22.
[   60.591252] intel_rapl: Found RAPL domain dram
[   60.591274] intel_rapl: DRAM domain energy unit 15300pj
[   60.651846] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.651915] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.651992] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.652222] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.652293] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.652360] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.652387] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.652617] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.652864] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.652888] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.652947] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.653023] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.653403] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.653470] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.653536] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.653560] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.653632] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.653704] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.653727] EDAC sbridge: Seeking for: PCI ID 8086:6fac
[   60.653873] EDAC sbridge: Seeking for: PCI ID 8086:6fad
[   60.654029] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.654303] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.654369] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.654577] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.656482] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.658436] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.659010] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.660573] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.662849] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.662865] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.662935] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.663745] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.663759] EDAC sbridge: Seeking for: PCI ID 8086:6f6c
[   60.664986] EDAC sbridge: Seeking for: PCI ID 8086:6f6d
[   60.665324] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.665376] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.665441] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.665474] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.665540] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.665601] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.665631] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.665704] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.665984] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.666869] EDAC sbridge: Couldn't find mci handler
[   60.693512] EDAC sbridge: Couldn't find mci handler
[   60.719730] EDAC sbridge: Couldn't find mci handler
[   60.745685] EDAC sbridge: Couldn't find mci handler
[   60.772571] EDAC sbridge: Failed to register device with error -22.
[   60.881929] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.882027] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.882283] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   60.882315] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.882373] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.882440] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   60.882466] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.882524] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.882588] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   60.882613] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.882675] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.882740] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   60.882764] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.882823] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.882888] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   60.882911] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.882971] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.883437] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   60.883636] EDAC sbridge: Seeking for: PCI ID 8086:6fac
[   60.883775] EDAC sbridge: Seeking for: PCI ID 8086:6fad
[   60.883913] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.883980] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.885451] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   60.886228] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.887771] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.889694] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   60.889910] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.889980] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.890466] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   60.890491] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.890567] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.890631] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   60.890645] EDAC sbridge: Seeking for: PCI ID 8086:6f6c
[   60.891541] EDAC sbridge: Seeking for: PCI ID 8086:6f6d
[   60.893578] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.893629] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.893694] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   60.893726] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.893777] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.893842] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   60.893874] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.893935] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.894198] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   60.898605] EDAC sbridge: Couldn't find mci handler
[   60.931126] EDAC sbridge: Couldn't find mci handler
[   60.964677] EDAC sbridge: Couldn't find mci handler
[   60.998611] EDAC sbridge: Couldn't find mci handler
[   61.031614] EDAC sbridge: Failed to register device with error -22.
[   61.531702] audit: type=1130 audit(1507728545.390:68): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-udev-settle comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   61.856704] audit: type=1130 audit(1507728545.714:69): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=dmraid-activation comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   61.964052] audit: type=1131 audit(1507728545.714:70): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=dmraid-activation comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   62.099127] audit: type=1130 audit(1507728545.958:71): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-fsck@dev-disk-by\x2duuid-5ce6b84b\x2db395\x2d405e\x2d9d56\x2d8fd80d3accd6 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   62.132926] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[   62.310183] audit: type=1130 audit(1507728546.167:72): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-fsck@dev-disk-by\x2duuid-371E\x2d7360 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   62.500776] audit: type=1130 audit(1507728546.358:73): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=dracut-shutdown comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   62.616917] audit: type=1130 audit(1507728546.475:74): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nfs-config comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   62.735847] audit: type=1131 audit(1507728546.475:75): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nfs-config comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   62.874461] audit: type=1130 audit(1507728546.731:76): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=plymouth-read-write comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   63.000977] audit: type=1131 audit(1507728546.733:77): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=plymouth-read-write comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   63.427345] RPC: Registered named UNIX socket transport module.
[   63.457679] RPC: Registered udp transport module.
[   63.457682] RPC: Registered tcp transport module.
[   63.457684] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   65.735137] plymouthd (868) used greatest stack depth: 11392 bytes left
[   65.984734] IPv6: ADDRCONF(NETDEV_UP): eno1: link is not ready
[   66.192205] IPv6: ADDRCONF(NETDEV_UP): eno1: link is not ready
[   66.251670] IPv6: ADDRCONF(NETDEV_UP): eno2: link is not ready
[   66.415454] IPv6: ADDRCONF(NETDEV_UP): eno2: link is not ready
[   66.450004] IPv6: ADDRCONF(NETDEV_UP): eno3: link is not ready
[   66.601721] IPv6: ADDRCONF(NETDEV_UP): eno3: link is not ready
[   66.636481] IPv6: ADDRCONF(NETDEV_UP): eno4: link is not ready
[   66.783790] IPv6: ADDRCONF(NETDEV_UP): eno4: link is not ready
[   66.821690] IPv6: ADDRCONF(NETDEV_UP): eno49: link is not ready
[   67.469126] bnx2x 0000:04:00.0 eno49: using MSI-X  IRQs: sp 130  fp[0] 132 ... fp[7] 139
[   68.179126] IPv6: ADDRCONF(NETDEV_UP): eno49: link is not ready
[   68.222291] IPv6: ADDRCONF(NETDEV_UP): eno50: link is not ready
[   68.858560] bnx2x 0000:04:00.1 eno50: using MSI-X  IRQs: sp 145  fp[0] 147 ... fp[7] 154
[   69.574160] IPv6: ADDRCONF(NETDEV_UP): eno50: link is not ready
[   71.197301] bnx2x 0000:04:00.0 eno49: NIC Link is Up, 1000 Mbps full duplex, Flow control: none
[   71.242037] IPv6: ADDRCONF(NETDEV_CHANGE): eno49: link becomes ready
[  117.881111] sendmail (1719) used greatest stack depth: 10912 bytes left
[  149.307123] EXT4-fs (pmem0): mounted filesystem with ordered data mode. Opts: (null)
[  279.710242] XFS (pmem0): Mounting V5 Filesystem
[  279.736954] XFS (pmem0): Ending clean mount
[  339.209842] kworker/dying (587) used greatest stack depth: 10816 bytes left
[  430.088516] perf: interrupt took too long (4549 > 3855), lowering kernel.perf_event_max_sample_rate to 43000
[  456.072186] kworker/dying (122) used greatest stack depth: 10248 bytes left

> 
> 
> > 
> > This does not happen on v4.13
> > 
> > Thanks,
> > 
> >     1  1505  Ss   0   0:00 /usr/sbin/sshd -D
> >  1505  1752  Ss   0   0:00  \_ sshd: root [priv]
> >  1752  1762  S    0   0:00  |   \_ sshd: root@pts/0
> >  1762  1763  Ss   0   0:00  |       \_ -bash
> >  1763  8706  S+   0   0:00  |           \_ /bin/bash -x ./run.sh --daxoff ffsb
> >  8706 10044  S+   0   0:00  |               \_ /bin/bash -x ./ffsb.sh xfs /dev/pmem0 /daxmnt 8099
> > 10044 10053  S+   0   0:00  |                   \_ make run
> > 10053 10056  S+   0   0:00  |                       \_ /bin/bash -x ./runtest.sh
> > 10056 10167  Sl+  0 21171969:20  |                           \_ ffsb large_file_creates_threads_192.ffsb
> > 10056 10168  S+   0   0:00  |                           \_ tee large_file_creates_threads_192.ffsb.out
> > .... 
> > 
> > sh-4.4# xfs_info /daxmnt/
> > meta-data=/dev/pmem0             isize=512    agcount=4, agsize=524288 blks
> >          =                       sectsz=4096  attr=2, projid32bit=1
> >          =                       crc=1        finobt=1 spinodes=0 rmapbt=0
> >          =                       reflink=0
> > data     =                       bsize=4096   blocks=2097152, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal               bsize=4096   blocks=2560, version=2
> >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > sh-4.4# uname -r
> > 4.14.0-rc1-master-cd4175b11685+
> > 
> > sh-4.4# xfs_io -V
> > xfs_io version 4.10.0
> > 
> > sh-4.4# ffsb -V
> > FFSB version 6.0-RC2 started
> > -V: No such file or directory
> > 
> > 
> > # cat large_file_creates_threads_192.ffsb
> > 
> > # Large file creates
> > # Creating 1 GB files.
> > 
> > time=300
> > alignio=1
> > directio=0
> > 
> > [filesystem0]
> > 	location=__SCRATCH_MNT__
> > 
> > 	# All created files will be 1 GB.
> > 	min_filesize=1GB
> > 	max_filesize=1GB
> > [end0]
> > 
> > [threadgroup0]
> > 	num_threads=192
> > 
> > 	create_weight=1
> > 
> > 	write_blocksize=4KB
> > 
> > 	[stats]
> > 		enable_stats=1
> > 		enable_range=1
> > 
> > 		msec_range    0.00      0.01
> > 		msec_range    0.01      0.02
> > 		msec_range    0.02      0.05
> > 		msec_range    0.05      0.10
> > 		msec_range    0.10      0.20
> > 		msec_range    0.20      0.50
> > 		msec_range    0.50      1.00
> > 		msec_range    1.00      2.00
> > 		msec_range    2.00      5.00
> > 		msec_range    5.00     10.00
> > 		msec_range   10.00     20.00
> > 		msec_range   20.00     50.00
> > 		msec_range   50.00    100.00
> > 		msec_range  100.00    200.00
> > 		msec_range  200.00    500.00
> > 		msec_range  500.00   1000.00
> > 		msec_range 1000.00   2000.00
> > 		msec_range 2000.00   5000.00
> > 		msec_range 5000.00  10000.00
> > 	[end]
> > [end0]
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Carlos
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
