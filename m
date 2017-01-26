Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D88E81F72
 for <linux-nvdimm@lists.01.org>; Thu, 26 Jan 2017 15:34:05 -0800 (PST)
Date: Thu, 26 Jan 2017 16:34:02 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: No Persistent Memory (legacy) even persistent (type 12) was found
Message-ID: <20170126233402.GA6659@linux.intel.com>
References: <31922059.1436799.1485417418342.ref@mail.yahoo.com>
 <31922059.1436799.1485417418342@mail.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <31922059.1436799.1485417418342@mail.yahoo.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Soccer Liu <soccer_liu@yahoo.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 26, 2017 at 07:56:58AM +0000, Soccer Liu wrote:
> Hi:
> =

> =A0I am trying to play with the NVDIMM driver and follow instructions in =

> https://nvdimm.wiki.kernel.org/how_to_choose_the_correct_memmap_kernel_pa=
rameter_for_pmem_on_your_system and =

> https://www.suse.com/communities/blog/nvdimm-enabling-part-2-intel
> =

> for setting up an emulated NVDIMM memory. =

> =

> I claimed the memory range from 0x10000000 -- 0x1fffffff via adding a ker=
nel command line param memmap=3D256M!256M .
> =

> soccerl@ubuntu:~$ dmesg | grep e820
> [=A0=A0=A0 0.000000] e820: BIOS-provided physical RAM map:
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fff=
f] usable
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x00000000000c0000-0x00000000000ffff=
f] reserved
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007eeecff=
f] usable=A0=A0 <------------------------------- *
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007eeed000-0x000000007eef1ff=
f] ACPI data
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007eef2000-0x000000007ef1aff=
f] reserved
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ef1b000-0x000000007ff9aff=
f] usable
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ff9b000-0x000000007ffb6ff=
f] reserved
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ffb7000-0x000000007ffb8ff=
f] type 20
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ffb9000-0x000000007ffbaff=
f] reserved
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ffbb000-0x000000007ffbbff=
f] type 20
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ffbc000-0x000000007ffbdff=
f] reserved
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ffbe000-0x000000007ffbeff=
f] type 20
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ffbf000-0x000000007ffc0ff=
f] reserved
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ffc1000-0x000000007ffc1ff=
f] type 20
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ffc2000-0x000000007ffc3ff=
f] reserved
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ffc4000-0x000000007ffc5ff=
f] type 20
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ffc6000-0x000000007ffc7ff=
f] reserved
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ffc8000-0x000000007ffc8ff=
f] type 20
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ffc9000-0x000000007fff2ff=
f] reserved
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007fff3000-0x000000007fffaff=
f] ACPI data
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007fffb000-0x000000007fffeff=
f] ACPI NVS
> [=A0=A0=A0 0.000000] BIOS-e820: [mem 0x000000007ffff000-0x000000007ffffff=
f] usable
> [=A0=A0=A0 0.000000] e820: user-defined physical RAM map:
> [=A0=A0=A0 0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=
=3D> reserved
> [=A0=A0=A0 0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [=A0=A0=A0 0.000000] e820: last_pfn =3D 0x80000 max_arch_pfn =3D 0x400000=
000
> [=A0=A0=A0 0.000000] e820: [mem 0x80000000-0xffffffff] available for PCI =
devices
> =

> soccerl@ubuntu:~$ dmesg | grep user
> [=A0=A0=A0 0.000000] e820: user-defined physical RAM map:
> [=A0=A0=A0 0.000000] user: [mem 0x0000000000000000-0x000000000009ffff] us=
able
> [=A0=A0=A0 0.000000] user: [mem 0x00000000000c0000-0x00000000000fffff] re=
served
> [=A0=A0=A0 0.000000] user: [mem 0x0000000000100000-0x000000000fffffff] us=
able
> [=A0=A0=A0 0.000000] user: [mem 0x0000000010000000-0x000000001fffffff] pe=
rsistent (type 12)=A0 <-------- this shows=A0 the memmap works as expected
> [=A0=A0=A0 0.000000] user: [mem 0x0000000020000000-0x000000007eeecfff] us=
able
> [=A0=A0=A0 0.000000] user: [mem 0x000000007eeed000-0x000000007eef1fff] AC=
PI data
> [=A0=A0=A0 0.000000] user: [mem 0x000000007eef2000-0x000000007ef1afff] re=
served
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ef1b000-0x000000007ff9afff] us=
able
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ff9b000-0x000000007ffb6fff] re=
served
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ffb7000-0x000000007ffb8fff] ty=
pe 20
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ffb9000-0x000000007ffbafff] re=
served
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ffbb000-0x000000007ffbbfff] ty=
pe 20
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ffbc000-0x000000007ffbdfff] re=
served
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ffbe000-0x000000007ffbefff] ty=
pe 20
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ffbf000-0x000000007ffc0fff] re=
served
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ffc1000-0x000000007ffc1fff] ty=
pe 20
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ffc2000-0x000000007ffc3fff] re=
served
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ffc4000-0x000000007ffc5fff] ty=
pe 20
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ffc6000-0x000000007ffc7fff] re=
served
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ffc8000-0x000000007ffc8fff] ty=
pe 20
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ffc9000-0x000000007fff2fff] re=
served
> [=A0=A0=A0 0.000000] user: [mem 0x000000007fff3000-0x000000007fffafff] AC=
PI data
> [=A0=A0=A0 0.000000] user: [mem 0x000000007fffb000-0x000000007fffefff] AC=
PI NVS
> [=A0=A0=A0 0.000000] user: [mem 0x000000007ffff000-0x000000007fffffff] us=
able

This all looks fine.  I ran my QEMU guest with this same reservation and it
worked, so I don't think it's an issue with the size or placement of the
reservation.

> However,=A0 I could not find any Persistent Memory (legacy) from the iome=
m output.
> I was expecting something like =

> 10000000-1fffffff : Persistent Memory (legacy)

Yep, here are the lines in my guest: =

	10000000-1fffffff : Persistent Memory (legacy)
	  10000000-1fffffff : namespace0.0

> soccerl@ubuntu:~$ cat /proc/iomem
> 00000000-00000000 : reserved
> 00000000-00000000 : System RAM
> 00000000-00000000 : reserved
> =A0 00000000-00000000 : System ROM
> 00000000-00000000 : System RAM
> =A0 00000000-00000000 : Kernel code
> =A0 00000000-00000000 : Kernel data
> =A0 00000000-00000000 : Kernel bss
> 00000000-00000000 : System RAM
> 00000000-00000000 : ACPI Tables
> 00000000-00000000 : System RAM
> 00000000-00000000 : reserved
> 00000000-00000000 : reserved
> 00000000-00000000 : reserved
> 00000000-00000000 : reserved
> 00000000-00000000 : reserved
> 00000000-00000000 : reserved
> 00000000-00000000 : ACPI Tables
> 00000000-00000000 : ACPI Non-volatile Storage
> 00000000-00000000 : System RAM
> 00000000-00000000 : 5620e0c7-8062-4dce-aeb7-520c7ef76171
> 00000000-00000000 : PNP0003:00
> 00000000-00000000 : Local APIC
> =A0 00000000-00000000 : PNP0003:00

Ummm...all the addresses are zero?  I don't know what would cause this - a
broken kconfig option?

> I do have the following kernel config flags set
> =

> CONFIG_ARCH_HAS_PMEM_API=3Dy
> CONFIG_BLK_DEV_PMEM=3Dm
> CONFIG_LIBNVDIMM=3Dy
> CONFIG_X86_PMEM_LEGACY=3Dy
> CONFIG_FS_DAX=3Dy
> CONFIG_BLK_DEV_RAM_DAX=3Dy
> =

> Any idea on what I might have missed?

My best guess is that it's a missed kernel config option.  Here are the
relevant ones from my v4.9 config:

$ egrep -i 'dax|pmem|nvdimm' .config
CONFIG_X86_PMEM_LEGACY_DEVICE=3Dy
CONFIG_X86_PMEM_LEGACY=3Dm
CONFIG_BLK_DEV_RAM_DAX=3Dy
CONFIG_LIBNVDIMM=3Dm
CONFIG_BLK_DEV_PMEM=3Dm
CONFIG_NVDIMM_PFN=3Dy
CONFIG_NVDIMM_DAX=3Dy
CONFIG_DEV_DAX=3Dm
CONFIG_DEV_DAX_PMEM=3Dm
CONFIG_NR_DEV_DAX=3D32768
CONFIG_FS_DAX=3Dy
CONFIG_ARCH_HAS_PMEM_API=3Dy

The DEV_DAX ones won't matter, but I'd verify the rest of them and make sure
they're set.

Also, what kernel version are you using?

- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
