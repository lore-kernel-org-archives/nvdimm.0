Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 02613202E60EA
 for <linux-nvdimm@lists.01.org>; Sun, 22 Oct 2017 06:48:39 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id v9so26660416oif.13
 for <linux-nvdimm@lists.01.org>; Sun, 22 Oct 2017 06:52:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN=ZobRsTqFtLiibVDU=yoNPSSgd7S=DaM=p2JTWcBm9x2PjsA@mail.gmail.com>
References: <CAN=ZobSmQ97gRKFaho7DPvXVD18W4145JfTQ5Ncf80Tw17fkGA@mail.gmail.com>
 <20171020162227.GA8576@linux.intel.com>
 <CAN=ZobRsTqFtLiibVDU=yoNPSSgd7S=DaM=p2JTWcBm9x2PjsA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 22 Oct 2017 06:52:19 -0700
Message-ID: <CAPcyv4ifUJUJFKksk0atmfeMiOJoQRPzYU9Z633i0Cj8pjpD6A@mail.gmail.com>
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
To: Oren Berman <oren@lightbitslabs.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Oct 22, 2017 at 4:33 AM, Oren Berman <oren@lightbitslabs.com> wrote:
> Hi Ross
>
> Thanks for the speedy reply. I am also adding the public list to this
> thread as you suggested.
>
> We have tried to dump the SPA table and this is what we get:
>
> /*
>  * Intel ACPI Component Architecture
>  * AML/ASL+ Disassembler version 20160108-64
>  * Copyright (c) 2000 - 2016 Intel Corporation
>  *
>  * Disassembly of NFIT, Sun Oct 22 10:46:19 2017
>  *
>  * ACPI Data Table [NFIT]
>  *
>  * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
>  */
>
> [000h 0000   4]                    Signature : "NFIT"    [NVDIMM Firmware
> Interface Table]
> [004h 0004   4]                 Table Length : 00000028
> [008h 0008   1]                     Revision : 01
> [009h 0009   1]                     Checksum : B2
> [00Ah 0010   6]                       Oem ID : "SUPERM"
> [010h 0016   8]                 Oem Table ID : "SMCI--MB"
> [018h 0024   4]                 Oem Revision : 00000001
> [01Ch 0028   4]              Asl Compiler ID : " "
> [020h 0032   4]        Asl Compiler Revision : 00000001
>
> [024h 0036   4]                     Reserved : 00000000
>
> Raw Table Data: Length 40 (0x28)
>
>   0000: 4E 46 49 54 28 00 00 00 01 B2 53 55 50 45 52 4D  // NFIT(.....SUPERM
>   0010: 53 4D 43 49 2D 2D 4D 42 01 00 00 00 01 00 00 00  // SMCI--MB........
>   0020: 01 00 00 00 00 00 00 00
>
> As you can see the memory region info is missing.
>
> This specific check was done on a supermicro server.
> We also performed a bios update but the results were the same.
>
> As said before ,the pmem devices are detected correctly and we verified
> that they correspond to different numa nodes using the PCM utility.However,
>  linux still reports both pmem devices to be on the same numa - Numa 0.
>
> If this information is missing, why pmem devices and address ranges are
> still detected correctly?

I suspect your BIOS might be using E820-type-12 to describe the pmem
ranges which is not compliant with the ACPI specification and would
need a BIOS change.

> Is there another table that we need to check?

You can dump /proc/iomem.  If it shows "Persistent Memory (legacy)"
then the BIOS is using the E820-type-12 description scheme which does
not include NUMA information.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
