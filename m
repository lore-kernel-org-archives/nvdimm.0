Return-Path: <owner-linux-mm@kvack.org>
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: devm_memremap_pages() triggers a kasan_add_zero_shadow() warning
From: Qian Cai <cai@lca.pw>
In-Reply-To: <20190822013100.GC2588@MiWiFi-R3L-srv>
Date: Wed, 21 Aug 2019 21:52:01 -0400
Content-Transfer-Encoding: quoted-printable
Message-Id: <90D5A1E0-24EC-4646-9275-373E43A17A66@lca.pw>
References: <1565991345.8572.28.camel@lca.pw>
 <CAPcyv4i9VFLSrU75U0gQH6K2sz8AZttqvYidPdDcS7sU2SFaCA@mail.gmail.com>
 <0FB85A78-C2EE-4135-9E0F-D5623CE6EA47@lca.pw>
 <CAPcyv4h9Y7wSdF+jnNzLDRobnjzLfkGLpJsML2XYLUZZZUPsQA@mail.gmail.com>
 <E7A04694-504D-4FB3-9864-03C2CBA3898E@lca.pw>
 <CAPcyv4gofF-Xf0KTLH4EUkxuXdRO3ha-w+GoxgmiW7gOdS2nXQ@mail.gmail.com>
 <0AC959D7-5BCB-4A81-BBDC-990E9826EB45@lca.pw>
 <1566421927.5576.3.camel@lca.pw> <20190822013100.GC2588@MiWiFi-R3L-srv>
Sender: owner-linux-mm@kvack.org
To: Baoquan He <bhe@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev@googlegroups.com, Dave Jiang <dave.jiang@intel.com>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>



> On Aug 21, 2019, at 9:31 PM, Baoquan He <bhe@redhat.com> wrote:
>=20
> On 08/21/19 at 05:12pm, Qian Cai wrote:
>>>> Does disabling CONFIG_RANDOMIZE_BASE help? Maybe that workaround =
has
>>>> regressed. Effectively we need to find what is causing the kernel =
to
>>>> sometimes be placed in the middle of a custom reserved memmap=3D =
range.
>>>=20
>>> Yes, disabling KASLR works good so far. Assuming the workaround, =
i.e.,
>>> f28442497b5c
>>> (=E2=80=9Cx86/boot: Fix KASLR and memmap=3D collision=E2=80=9D) is =
correct.
>>>=20
>>> The only other commit that might regress it from my research so far =
is,
>>>=20
>>> d52e7d5a952c ("x86/KASLR: Parse all 'memmap=3D' boot option =
entries=E2=80=9D)
>>>=20
>>=20
>> It turns out that the origin commit f28442497b5c (=E2=80=9Cx86/boot: =
Fix KASLR and
>> memmap=3D collision=E2=80=9D) has a bug that is unable to handle =
"memmap=3D" in
>> CONFIG_CMDLINE instead of a parameter in bootloader because when it =
(as well as
>> the commit d52e7d5a952c) calls get_cmd_line_ptr() in order to run
>> mem_avoid_memmap(), "boot_params" has no knowledge of CONFIG_CMDLINE. =
Only later
>> in setup_arch(), the kernel will deal with parameters over there.
>=20
> Yes, we didn't consider CONFIG_CMDLINE during boot compressing stage. =
It
> should be a generic issue since other parameters from CONFIG_CMDLINE =
could
> be ignored too, not only KASLR handling. Would you like to cast a =
patch
> to fix it? Or I can fix it later, maybe next week.

I think you have more experience than me in this area, so if you have =
time to fix it, that
would be nice.
