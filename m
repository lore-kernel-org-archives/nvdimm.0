Return-Path: <owner-linux-mm@kvack.org>
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: devm_memremap_pages() triggers a kasan_add_zero_shadow() warning
From: Qian Cai <cai@lca.pw>
In-Reply-To: <CAPcyv4gofF-Xf0KTLH4EUkxuXdRO3ha-w+GoxgmiW7gOdS2nXQ@mail.gmail.com>
Date: Sat, 17 Aug 2019 23:25:28 -0400
Content-Transfer-Encoding: quoted-printable
Message-Id: <0AC959D7-5BCB-4A81-BBDC-990E9826EB45@lca.pw>
References: <1565991345.8572.28.camel@lca.pw>
 <CAPcyv4i9VFLSrU75U0gQH6K2sz8AZttqvYidPdDcS7sU2SFaCA@mail.gmail.com>
 <0FB85A78-C2EE-4135-9E0F-D5623CE6EA47@lca.pw>
 <CAPcyv4h9Y7wSdF+jnNzLDRobnjzLfkGLpJsML2XYLUZZZUPsQA@mail.gmail.com>
 <E7A04694-504D-4FB3-9864-03C2CBA3898E@lca.pw>
 <CAPcyv4gofF-Xf0KTLH4EUkxuXdRO3ha-w+GoxgmiW7gOdS2nXQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev@googlegroups.com, Baoquan He <bhe@redhat.com>, Dave Jiang <dave.jiang@intel.com>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>



> On Aug 17, 2019, at 12:59 PM, Dan Williams <dan.j.williams@intel.com> =
wrote:
>=20
> On Sat, Aug 17, 2019 at 4:13 AM Qian Cai <cai@lca.pw> wrote:
>>=20
>>=20
>>=20
>>> On Aug 16, 2019, at 11:57 PM, Dan Williams =
<dan.j.williams@intel.com> wrote:
>>>=20
>>> On Fri, Aug 16, 2019 at 8:34 PM Qian Cai <cai@lca.pw> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Aug 16, 2019, at 5:48 PM, Dan Williams =
<dan.j.williams@intel.com> wrote:
>>>>>=20
>>>>> On Fri, Aug 16, 2019 at 2:36 PM Qian Cai <cai@lca.pw> wrote:
>>>>>>=20
>>>>>> Every so often recently, booting Intel CPU server on linux-next =
triggers this
>>>>>> warning. Trying to figure out if  the commit 7cc7867fb061
>>>>>> ("mm/devm_memremap_pages: enable sub-section remap") is the =
culprit here.
>>>>>>=20
>>>>>> # ./scripts/faddr2line vmlinux devm_memremap_pages+0x894/0xc70
>>>>>> devm_memremap_pages+0x894/0xc70:
>>>>>> devm_memremap_pages at mm/memremap.c:307
>>>>>=20
>>>>> Previously the forced section alignment in devm_memremap_pages() =
would
>>>>> cause the implementation to never violate the =
KASAN_SHADOW_SCALE_SIZE
>>>>> (12K on x86) constraint.
>>>>>=20
>>>>> Can you provide a dump of /proc/iomem? I'm curious what resource =
is
>>>>> triggering such a small alignment granularity.
>>>>=20
>>>> This is with memmap=3D4G!4G ,
>>>>=20
>>>> # cat /proc/iomem
>>> [..]
>>>> 100000000-155dfffff : Persistent Memory (legacy)
>>>> 100000000-155dfffff : namespace0.0
>>>> 155e00000-15982bfff : System RAM
>>>> 155e00000-156a00fa0 : Kernel code
>>>> 156a00fa1-15765d67f : Kernel data
>>>> 157837000-1597fffff : Kernel bss
>>>> 15982c000-1ffffffff : Persistent Memory (legacy)
>>>> 200000000-87fffffff : System RAM
>>>=20
>>> Ok, looks like 4G is bad choice to land the pmem emulation on this
>>> system because it collides with where the kernel is deployed and =
gets
>>> broken into tiny pieces that violate kasan's. This is a known =
problem
>>> with memmap=3D. You need to pick an memory range that does not =
collide
>>> with anything else. See:
>>>=20
>>>   =
https://nvdimm.wiki.kernel.org/how_to_choose_the_correct_memmap_kernel_par=
ameter_for_pmem_on_your_system
>>>=20
>>> ...for more info.
>>=20
>> Well, it seems I did exactly follow the information in that link,
>>=20
>> [    0.000000] BIOS-provided physical RAM map:
>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093fff] =
usable
>> [    0.000000] BIOS-e820: [mem 0x0000000000094000-0x000000000009ffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000005a7a0fff] =
usable
>> [    0.000000] BIOS-e820: [mem 0x000000005a7a1000-0x000000005b5e0fff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x000000005b5e1000-0x00000000790fefff] =
usable
>> [    0.000000] BIOS-e820: [mem 0x00000000790ff000-0x00000000791fefff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000791ff000-0x000000007b5fefff] =
ACPI NVS
>> [    0.000000] BIOS-e820: [mem 0x000000007b5ff000-0x000000007b7fefff] =
ACPI data
>> [    0.000000] BIOS-e820: [mem 0x000000007b7ff000-0x000000007b7fffff] =
usable
>> [    0.000000] BIOS-e820: [mem 0x000000007b800000-0x000000008fffffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000087fffffff] =
usable
>>=20
>> Where 4G is good. Then,
>>=20
>> [    0.000000] user-defined physical RAM map:
>> [    0.000000] user: [mem 0x0000000000000000-0x0000000000093fff] =
usable
>> [    0.000000] user: [mem 0x0000000000094000-0x000000000009ffff] =
reserved
>> [    0.000000] user: [mem 0x00000000000e0000-0x00000000000fffff] =
reserved
>> [    0.000000] user: [mem 0x0000000000100000-0x000000005a7a0fff] =
usable
>> [    0.000000] user: [mem 0x000000005a7a1000-0x000000005b5e0fff] =
reserved
>> [    0.000000] user: [mem 0x000000005b5e1000-0x00000000790fefff] =
usable
>> [    0.000000] user: [mem 0x00000000790ff000-0x00000000791fefff] =
reserved
>> [    0.000000] user: [mem 0x00000000791ff000-0x000000007b5fefff] ACPI =
NVS
>> [    0.000000] user: [mem 0x000000007b5ff000-0x000000007b7fefff] ACPI =
data
>> [    0.000000] user: [mem 0x000000007b7ff000-0x000000007b7fffff] =
usable
>> [    0.000000] user: [mem 0x000000007b800000-0x000000008fffffff] =
reserved
>> [    0.000000] user: [mem 0x00000000ff800000-0x00000000ffffffff] =
reserved
>> [    0.000000] user: [mem 0x0000000100000000-0x00000001ffffffff] =
persistent (type 12)
>> [    0.000000] user: [mem 0x0000000200000000-0x000000087fffffff] =
usable
>>=20
>> The doc did mention that =E2=80=9CThere seems to be an issue with =
CONFIG_KSAN at the moment however.=E2=80=9D
>> without more detail though.
>=20
> Does disabling CONFIG_RANDOMIZE_BASE help? Maybe that workaround has
> regressed. Effectively we need to find what is causing the kernel to
> sometimes be placed in the middle of a custom reserved memmap=3D =
range.

Yes, disabling KASLR works good so far. Assuming the workaround, i.e., =
f28442497b5c
(=E2=80=9Cx86/boot: Fix KASLR and memmap=3D collision=E2=80=9D) is =
correct.

The only other commit that might regress it from my research so far is,

d52e7d5a952c ("x86/KASLR: Parse all 'memmap=3D' boot option entries=E2=80=9D=
)
