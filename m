Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x22e.google.com (mail-vk0-x22e.google.com
 [IPv6:2607:f8b0:400c:c05::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6A7EC2035D33E
 for <linux-nvdimm@lists.01.org>; Tue,  9 Jan 2018 14:20:42 -0800 (PST)
Received: by mail-vk0-x22e.google.com with SMTP id o73so10401259vkd.2
 for <linux-nvdimm@lists.01.org>; Tue, 09 Jan 2018 14:25:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACTTzNa06a4ZM6tkYesqf-19WfcSuJovD-AWKC8-obVp_cTOPQ@mail.gmail.com>
References: <CAN=ZobSmQ97gRKFaho7DPvXVD18W4145JfTQ5Ncf80Tw17fkGA@mail.gmail.com>
 <20171020162227.GA8576@linux.intel.com>
 <CAN=ZobRsTqFtLiibVDU=yoNPSSgd7S=DaM=p2JTWcBm9x2PjsA@mail.gmail.com>
 <CAPcyv4ifUJUJFKksk0atmfeMiOJoQRPzYU9Z633i0Cj8pjpD6A@mail.gmail.com>
 <CAN=ZobTYOgWxPbLcH275EK4PkoniMk+1g1HehxoXLp1bqUN9Bg@mail.gmail.com>
 <CAA9_cmff4YFQnP+1csz2Z_=dKcQeW5jYFC2QLcN9V4j1FV+zyA@mail.gmail.com>
 <CAN=ZobSKm8isvTEALkd_-X7Hyjbv6tH-Yy0UGtOTkn2_fKoqhA@mail.gmail.com>
 <CAA9_cmes_Strpx6jNYDOnxZ0DUENFpWOpL-65jvpv3ztQwB74Q@mail.gmail.com>
 <CACTTzNa06a4ZM6tkYesqf-19WfcSuJovD-AWKC8-obVp_cTOPQ@mail.gmail.com>
From: Oren Berman <oren@lightbitslabs.com>
Date: Wed, 10 Jan 2018 00:25:51 +0200
Message-ID: <CAN=ZobTrcu9LALChbB2HT1Fw_aAnDLGotU0Uo8uhewf5c3E+UA@mail.gmail.com>
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
To: Yigal Korman <yigal@plexistor.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi

I would like to know if you encountered such a problem.

We are accessing the nvram as memory from withing the kernel.
By mapping dax device and reading its mapping we can know the physical
address of the nvram.
As a result we can access this address range in the kernel by calling
phys_to_virt.
This  is working in most case but we saw some issue that after reboot, when
trying to read the info saved
on the nvram before the power off, one kernel thread was able to read
from this range but another kernel thread got page fault.

This is not recreated very easily and we need run many reboot sequences to
get this failure again.
Are you aware of any mapping issues of nvram to kernel space?

Thanks for any suggestions you might have.
BR
Oren

On 31 December 2017 at 10:23, Yigal Korman <yigal@plexistor.com> wrote:

> You can try to force a legacy pmem device with memmap=XX!YY kernel
> parameter.
>
> On Thu, Dec 28, 2017 at 8:16 PM, Dan Williams <dan.j.williams@intel.com>
> wrote:
>
>> Type-7 only tells the kernel to reserve the memory range. NFIT carves that
>> reservation into pmem devices. Type-12 skips the reservation and creates a
>> pmem device directly. There is no workaround if the platform only has a
>> BIOS that produces a type-12 range.
>>
>>
>> On Thursday, December 28, 2017, Oren Berman <oren@lightbitslabs.com>
>> wrote:
>>
>> > Thanks Dan.
>> > I understand the shortcomings of using legacy mode but currently my
>> problem
>> > is that TYPE 12 is detected and I can use dax even in legacy mode but
>> for
>> > some reason type 7 is not. Is there a way to force it be treated as
>> legacy
>> > as well.
>> > The reason I am asking is that I am not sure I can change my bios and I
>> > know at least that type 12 NVDIMM is working for me.
>> >
>> > BR
>> > Oren
>> >
>> >
>> >
>> > On 28 December 2017 at 11:14, Dan Williams <dan.j.williams@intel.com>
>> > wrote:
>> >
>> > > [sent from my phone, forgive formatting]
>> > >
>> > > Your BIOS would need to put SPA range entries in the ACPI NFIT. The
>> > > problem with legacy pmem ranges in the e820 table is that it omits
>> > critical
>> > > details like battery status and whether the platform supports flushing
>> > > memory controller buffers at power loss (ADR).
>> > >
>> > > The NFIT can also reliably communicate NUMA information  for NVDIMMs
>> that
>> > > e820 does not.
>> > >
>> > > On Wednesday, December 27, 2017, Oren Berman <oren@lightbitslabs.com>
>> > > wrote:
>> > >
>> > >> Hi
>> > >>
>> > >> I have a question regrading NVDIMM detection.
>> > >>
>> > >> When we are working with NVDIMM of type 12 it is detected by the
>> linux
>> > in
>> > >> legacy mode and we can
>> > >> accesses it as pmem or dax device. we have an e820 bios.
>> > >>
>> > >> When we are using a type 7 NVDIMM it is reported by the linux as
>> > >> persistence type 7 memory but there is no pmem or dax device created.
>> > >> Linux Kernel identifies this memory in the e820 table but it does not
>> > >> trigger nvdimm probe for it.
>> > >> Do you know what could be the cause? Is their a workaround for that?
>> > >> Can it still be treated as legacy mode so we can access it through
>> > >> pmem/dax
>> > >> device?
>> > >>
>> > >> BR
>> > >> Oren Berman
>> > >>
>> > >> On 22 October 2017 at 16:52, Dan Williams <dan.j.williams@intel.com>
>> > >> wrote:
>> > >>
>> > >> > On Sun, Oct 22, 2017 at 4:33 AM, Oren Berman <
>> oren@lightbitslabs.com>
>> > >> > wrote:
>> > >> > > Hi Ross
>> > >> > >
>> > >> > > Thanks for the speedy reply. I am also adding the public list to
>> > this
>> > >> > > thread as you suggested.
>> > >> > >
>> > >> > > We have tried to dump the SPA table and this is what we get:
>> > >> > >
>> > >> > > /*
>> > >> > >  * Intel ACPI Component Architecture
>> > >> > >  * AML/ASL+ Disassembler version 20160108-64
>> > >> > >  * Copyright (c) 2000 - 2016 Intel Corporation
>> > >> > >  *
>> > >> > >  * Disassembly of NFIT, Sun Oct 22 10:46:19 2017
>> > >> > >  *
>> > >> > >  * ACPI Data Table [NFIT]
>> > >> > >  *
>> > >> > >  * Format: [HexOffset DecimalOffset ByteLength]  FieldName :
>> > >> FieldValue
>> > >> > >  */
>> > >> > >
>> > >> > > [000h 0000   4]                    Signature : "NFIT"    [NVDIMM
>> > >> Firmware
>> > >> > > Interface Table]
>> > >> > > [004h 0004   4]                 Table Length : 00000028
>> > >> > > [008h 0008   1]                     Revision : 01
>> > >> > > [009h 0009   1]                     Checksum : B2
>> > >> > > [00Ah 0010   6]                       Oem ID : "SUPERM"
>> > >> > > [010h 0016   8]                 Oem Table ID : "SMCI--MB"
>> > >> > > [018h 0024   4]                 Oem Revision : 00000001
>> > >> > > [01Ch 0028   4]              Asl Compiler ID : " "
>> > >> > > [020h 0032   4]        Asl Compiler Revision : 00000001
>> > >> > >
>> > >> > > [024h 0036   4]                     Reserved : 00000000
>> > >> > >
>> > >> > > Raw Table Data: Length 40 (0x28)
>> > >> > >
>> > >> > >   0000: 4E 46 49 54 28 00 00 00 01 B2 53 55 50 45 52 4D  //
>> > >> > NFIT(.....SUPERM
>> > >> > >   0010: 53 4D 43 49 2D 2D 4D 42 01 00 00 00 01 00 00 00  //
>> > >> > SMCI--MB........
>> > >> > >   0020: 01 00 00 00 00 00 00 00
>> > >> > >
>> > >> > > As you can see the memory region info is missing.
>> > >> > >
>> > >> > > This specific check was done on a supermicro server.
>> > >> > > We also performed a bios update but the results were the same.
>> > >> > >
>> > >> > > As said before ,the pmem devices are detected correctly and we
>> > >> verified
>> > >> > > that they correspond to different numa nodes using the PCM
>> > >> > utility.However,
>> > >> > >  linux still reports both pmem devices to be on the same numa -
>> Numa
>> > >> 0.
>> > >> > >
>> > >> > > If this information is missing, why pmem devices and address
>> ranges
>> > >> are
>> > >> > > still detected correctly?
>> > >> >
>> > >> > I suspect your BIOS might be using E820-type-12 to describe the
>> pmem
>> > >> > ranges which is not compliant with the ACPI specification and would
>> > >> > need a BIOS change.
>> > >> >
>> > >> > > Is there another table that we need to check?
>> > >> >
>> > >> > You can dump /proc/iomem.  If it shows "Persistent Memory (legacy)"
>> > >> > then the BIOS is using the E820-type-12 description scheme which
>> does
>> > >> > not include NUMA information.
>> > >> >
>> > >> _______________________________________________
>> > >> Linux-nvdimm mailing list
>> > >> Linux-nvdimm@lists.01.org
>> > >> https://lists.01.org/mailman/listinfo/linux-nvdimm
>> > >>
>> > >
>> > _______________________________________________
>> > Linux-nvdimm mailing list
>> > Linux-nvdimm@lists.01.org
>> > https://lists.01.org/mailman/listinfo/linux-nvdimm
>> >
>> _______________________________________________
>> Linux-nvdimm mailing list
>> Linux-nvdimm@lists.01.org
>> https://lists.01.org/mailman/listinfo/linux-nvdimm
>>
>
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
