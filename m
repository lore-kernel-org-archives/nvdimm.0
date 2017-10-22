Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x235.google.com (mail-ua0-x235.google.com
 [IPv6:2607:f8b0:400c:c08::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 385512034C082
 for <linux-nvdimm@lists.01.org>; Sun, 22 Oct 2017 04:30:01 -0700 (PDT)
Received: by mail-ua0-x235.google.com with SMTP id 47so11076066uas.8
 for <linux-nvdimm@lists.01.org>; Sun, 22 Oct 2017 04:33:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171020162227.GA8576@linux.intel.com>
References: <CAN=ZobSmQ97gRKFaho7DPvXVD18W4145JfTQ5Ncf80Tw17fkGA@mail.gmail.com>
 <20171020162227.GA8576@linux.intel.com>
From: Oren Berman <oren@lightbitslabs.com>
Date: Sun, 22 Oct 2017 14:33:40 +0300
Message-ID: <CAN=ZobRsTqFtLiibVDU=yoNPSSgd7S=DaM=p2JTWcBm9x2PjsA@mail.gmail.com>
Subject: Re: Detecting NUMA per pmem
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Ross

Thanks for the speedy reply. I am also adding the public list to this
thread as you suggested.

We have tried to dump the SPA table and this is what we get:

/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20160108-64
 * Copyright (c) 2000 - 2016 Intel Corporation
 *
 * Disassembly of NFIT, Sun Oct 22 10:46:19 2017
 *
 * ACPI Data Table [NFIT]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
 */

[000h 0000   4]                    Signature : "NFIT"    [NVDIMM Firmware
Interface Table]
[004h 0004   4]                 Table Length : 00000028
[008h 0008   1]                     Revision : 01
[009h 0009   1]                     Checksum : B2
[00Ah 0010   6]                       Oem ID : "SUPERM"
[010h 0016   8]                 Oem Table ID : "SMCI--MB"
[018h 0024   4]                 Oem Revision : 00000001
[01Ch 0028   4]              Asl Compiler ID : " "
[020h 0032   4]        Asl Compiler Revision : 00000001

[024h 0036   4]                     Reserved : 00000000

Raw Table Data: Length 40 (0x28)

  0000: 4E 46 49 54 28 00 00 00 01 B2 53 55 50 45 52 4D  // NFIT(.....SUPERM
  0010: 53 4D 43 49 2D 2D 4D 42 01 00 00 00 01 00 00 00  // SMCI--MB........
  0020: 01 00 00 00 00 00 00 00

As you can see the memory region info is missing.

This specific check was done on a supermicro server.
We also performed a bios update but the results were the same.

As said before ,the pmem devices are detected correctly and we verified
that they correspond to different numa nodes using the PCM utility.However,
 linux still reports both pmem devices to be on the same numa - Numa 0.

If this information is missing, why pmem devices and address ranges are
still detected correctly?
Is there another table that we need to check?

I also ran dmidecode and the NVDIMMs are being listed (we tested with
netlist NVDIMMs). I can also see the bank locator showing P0 and P1 which I
think indicates the numa.  Here is  an example:

Handle 0x002D, DMI type 17, 40 bytes
Memory Device
Array Handle: 0x002A
Error Information Handle: Not Provided
Total Width: 72 bits
Data Width: 64 bits
Size: 16384 MB
Form Factor: DIMM
Set: None
Locator: P1-DIMMA3
Bank Locator: P0_Node0_Channel0_Dimm2
Type: DDR4
Type Detail: Synchronous
Speed: 2400 MHz
Manufacturer: Netlist
Serial Number: 66F50006
Asset Tag: P1-DIMMA3_AssetTag (date:16/42)
Part Number: NV3A74SBT20-000
Rank: 1
Configured Clock Speed: 1600 MHz
Minimum Voltage: Unknown
Maximum Voltage: Unknown
Configured Voltage: Unknown


Handle 0x003B, DMI type 17, 40 bytes
Memory Device
Array Handle: 0x0038
Error Information Handle: Not Provided
Total Width: 72 bits
Data Width: 64 bits
Size: 16384 MB
Form Factor: DIMM
Set: None
Locator: P2-DIMME3
Bank Locator: P1_Node1_Channel0_Dimm2
Type: DDR4
Type Detail: Synchronous
Speed: 2400 MHz
Manufacturer: Netlist
Serial Number: 66B50010
Asset Tag: P2-DIMME3_AssetTag (date:16/42)
Part Number: NV3A74SBT20-000
Rank: 1
Configured Clock Speed: 1600 MHz
Minimum Voltage: Unknown
Maximum Voltage: Unknown
Configured Voltage: Unknown

Did you encounter such a a case? We would appreciate any insight you might
have.

BR
Oren Berman


On 20 October 2017 at 19:22, Ross Zwisler <ross.zwisler@linux.intel.com>
wrote:

> On Thu, Oct 19, 2017 at 06:12:24PM +0300, Oren Berman wrote:
> >    Hi Ross
> >    My name is Oren Berman and I am a senior developer at lightbitslabs.
> >    We are working with NDIMMs but we encountered a problem that the
> kernel
> >     does not seem to detect the numa id per PMEM device.
> >    It always reports numa 0 although we have NVDIMM devices on both
> nodes.
> >    We checked that it always returns 0 from sysfs and also from
> retrieving
> >    the device of pmem in the kernel and calling dev_to_node.
> >    The result is always 0 for both pmem0 and pmem1.
> >    In order to make sure that indeed both numa sockets are used we ran
> >    intel's pcm utlity. We verified that writing to pmem 0 increases
> socket 0
> >    utilization and  writing to pmem1 increases socket 1 utilization so
> the hw
> >    works properly.
> >    Only the detection seems to be invalid.
> >    Did you encounter such a problem?
> >    We are using kernel version 4.9 - are you aware of any fix for this
> issue
> >    or workaround that we can use.
> >    Are we missing something?
> >    Thanks for any help you can give us.
> >    BR
> >    Oren Berman
>
> Hi Oren,
>
> My first guess is that your platform isn't properly filling out the
> "proximity
> domain" field in the NFIT SPA table.
>
> See section 5.2.25.2 in ACPI 6.2:
> http://uefi.org/sites/default/files/resources/ACPI_6_2.pdf
>
> Here's how to check that:
>
>   # cd /tmp
>   # cp /sys/firmware/acpi/tables/NFIT .
>   # iasl NFIT
>
>   Intel ACPI Component Architecture
>   ASL+ Optimizing Compiler version 20160831-64
>   Copyright (c) 2000 - 2016 Intel Corporation
>
>   Binary file appears to be a valid ACPI table, disassembling
>   Input file NFIT, Length 0xE0 (224) bytes
>   ACPI: NFIT 0x0000000000000000 0000E0 (v01 BOCHS  BXPCNFIT 00000001 BXPC
>   00000001)
>   Acpi Data Table [NFIT] decoded
>   Formatted output:  NFIT.dsl - 5191 bytes
>
> This will give you an NFIT.dsl file which you can look at.  Here is what my
> SPA table looks like for an emulated QEMU NVDIMM:
>
>   [028h 0040   2]                Subtable Type : 0000 [System Physical
> Address Range]
>   [02Ah 0042   2]                       Length : 0038
>
>   [02Ch 0044   2]                  Range Index : 0002
>   [02Eh 0046   2]        Flags (decoded below) : 0003
>                      Add/Online Operation Only : 1
>                         Proximity Domain Valid : 1
>   [030h 0048   4]                     Reserved : 00000000
>   [034h 0052   4]             Proximity Domain : 00000000
>   [038h 0056  16]           Address Range GUID :
> 66F0D379-B4F3-4074-AC43-0D3318B78CDB
>   [048h 0072   8]           Address Range Base : 0000000240000000
>   [050h 0080   8]         Address Range Length : 0000000440000000
>   [058h 0088   8]         Memory Map Attribute : 0000000000008008
>
> So, the "Proximity Domain" field is 0, and this lets the system know which
> NUMA node to associate with this memory region.
>
> BTW, in the future it's best to CC our public list,
> linux-nvdimm@lists.01.org,
> as a) someone else might have the same question and b) someone else might
> know
> the answer.
>
> Thanks,
> - Ross
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
