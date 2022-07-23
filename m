Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD4D7E
	for <nvdimm@lists.linux.dev>; Sat, 23 Jul 2022 13:31:23 +0000 (UTC)
Received: from [192.168.50.148] (c-24-62-201-179.hsd1.ma.comcast.net [24.62.201.179])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id 5D4BA40119C5;
	Sat, 23 Jul 2022 09:31:22 -0400 (EDT)
Reply-To: moss@cs.umass.edu
Subject: Re: Building on Ubuntu; and persistence_domain:cpu_cache
To: Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev
References: <c8297399-4c99-52d9-861a-62fade81cda1@cs.umass.edu>
 <62daeef3d20b3_2363782948d@dwillia2-xfh.jf.intel.com.notmuch>
 <650016e6-496b-fa6d-f898-6983a35069a3@cs.umass.edu>
 <fa3532d7-4d0c-2730-9b75-b92f329e1c00@cs.umass.edu>
 <62db637410e27_1f553629467@dwillia2-xfh.jf.intel.com.notmuch>
From: Eliot Moss <moss@cs.umass.edu>
Message-ID: <a93ed02f-0234-8d76-ed5e-3c0cbe56ed83@cs.umass.edu>
Date: Sat, 23 Jul 2022 09:31:20 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <62db637410e27_1f553629467@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 7/22/2022 10:56 PM, Dan Williams wrote:
> Eliot Moss wrote:
>> On 7/22/2022 3:08 PM, Eliot Moss wrote:
>>> On 7/22/2022 2:39 PM, Dan Williams wrote:
>>>> Eliot Moss wrote:

> Glad you got it parsed, for future reference use iasl:
> 
> # cp /sys/firmware/acpi/tables/NFIT ./
> # iasl -d NFIT
> 
> Intel ACPI Component Architecture
> ASL+ Optimizing Compiler/Disassembler version 20220331
> Copyright (c) 2000 - 2022 Intel Corporation
> 
> File appears to be binary: found 190 non-ASCII characters, disassembling
> Binary file appears to be a valid ACPI table, disassembling
> Input file NFIT, Length 0xE0 (224) bytes
> ACPI: NFIT 0x0000000000000000 0000E0 (v01 BOCHS  BXPC     00000001 BXPC 00000001)
> Acpi Data Table [NFIT] decoded
> Formatted output:  NFIT.dsl - 5355 bytes
> 
> # cat NFIT.dsl
> 
> /*
>   * Intel ACPI Component Architecture
>   * AML/ASL+ Disassembler version 20220331 (64-bit version)
>   * Copyright (c) 2000 - 2022 Intel Corporation
>   *
>   * Disassembly of NFIT, Fri Jul 22 19:54:16 2022
>   *
>   * ACPI Data Table [NFIT]
>   *
>   * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue (in hex)
>   */
> 
> [000h 0000   4]                    Signature : "NFIT"    [NVDIMM Firmware Interface Table]
> [004h 0004   4]                 Table Length : 000000E0
> [008h 0008   1]                     Revision : 01
> [009h 0009   1]                     Checksum : E3
> [00Ah 0010   6]                       Oem ID : "BOCHS "
> [010h 0016   8]                 Oem Table ID : "BXPC    "
> [018h 0024   4]                 Oem Revision : 00000001
> [01Ch 0028   4]              Asl Compiler ID : "BXPC"
> [020h 0032   4]        Asl Compiler Revision : 00000001
> 
> [024h 0036   4]                     Reserved : 00000000
> 
> [028h 0040   2]                Subtable Type : 0000 [System Physical Address Range]
> [02Ah 0042   2]                       Length : 0038
> 
> [02Ch 0044   2]                  Range Index : 0002
> [02Eh 0046   2]        Flags (decoded below) : 0003
>                     Add/Online Operation Only : 1
>                        Proximity Domain Valid : 1
>                         Location Cookie Valid : 0
> [030h 0048   4]                     Reserved : 00000000
> [034h 0052   4]             Proximity Domain : 00000000
> [038h 0056  16]             Region Type GUID : 66F0D379-B4F3-4074-AC43-0D3318B78CDB
> [048h 0072   8]           Address Range Base : 0000000480000000
> [050h 0080   8]         Address Range Length : 0000001FC0000000
> [058h 0088   8]         Memory Map Attribute : 0000000000008008
> [060h 0096   8]              Location Cookie : 0000000100300001

Thank you, Dan - I had figured that out in the mean time.

For future readers of this thread, ipmctl is also handy for this:

ipmctl show -system NFIT

...
    ---TableType=0x7
       Length: 16 bytes
       TypeEquals: PlatformCapabilities
       HighestValidCapability: 0x02
       Capabilities: 0x00000002
       Capabilities.CPUCacheFlushToNVDIMM: 0
       Capabilities.MemoryControllerFlushToNVDIMM: 1
       Capabilities.MemoryMirroring: 0

-- Eliot
