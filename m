Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALCETrWcH76_P8pzK+cur50pk--VppkjG9z3ueXMAS_=x9jd1w@mail.gmail.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150428182514.35812.12126.stgit@dwillia2-desk3.amr.corp.intel.com>
	<CALCETrVLoJj6f72MraEZ3dUA9Mgr8fK17Yw-ACT7pvfB9nZ4MA@mail.gmail.com>
	<CAAek22GZPnBnHcPnNHe-dfNb9Kd_TNDHGXYMpdYRNQtNr4FnFw@mail.gmail.com>
	<CALCETrWcH76_P8pzK+cur50pk--VppkjG9z3ueXMAS_=x9jd1w@mail.gmail.com>
Date: Tue, 28 Apr 2015 17:17:15 -0700
Message-ID: <CAAek22GqgtvhSV44AzQNbD1wMKpN74GADLXbUiTNXrApfFhHQw@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2 11/20] libnd, nd_pmem: add libnd support
 to the pmem driver
From: Phil Pokorny <ppokorny@penguincomputing.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 28, 2015 at 3:58 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Apr 28, 2015 at 3:21 PM, Phil Pokorny
> <ppokorny@penguincomputing.com> wrote:
>> On Tue, Apr 28, 2015 at 2:04 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Tue, Apr 28, 2015 at 11:25 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>>>> +config ND_E820
>>>> +       tristate "E820: Support the E820-type-12 PMEM convention"
>>>> +       depends on X86_PMEM_LEGACY
>>>> +       default m if X86_PMEM_LEGACY
>>>> +       select LIBND
>>>> +       help
>>>> +         Prior to ACPI 6 some platforms advertised peristent memory
>>>> +         via type-12 e820 memory ranges.  Create a libnd bus and
>>>> +         attach an instance of the pmem driver to these ranges.
>>>> +
>>>
>>> How about something like:
>>>
>>> "This driver allows libnd to work with legacy, pre-ACPI 6 NVDIMMs.
>>> This enables such devices to be exposed as block devices using PMEM.
>>>
>>> The legacy NVDIMM interface is problematic.  This driver will not work
>>> if you boot using UEFI, and some NVDIMMs and motherboards that work
>>> with this driver may require proprietary code in order to work
>>> reliably."
>>
>> Perhaps not "problematic" but "requires a BIOS in Legacy mode"
>>
>> It might also mention that if you use the kernel command line
>> memmap=nn!ss syntax it adds
>> a type 12 region to the e820 map and so you would want this support.
>>
>> If you have a motherboard with UEFI support for NVDIMM's that would be
>> the recommended
>> configuration.
>
> This is such a mess that I think this driver should maybe flat-out
> refuse to load in this type of configuration without some scary module
> option.  I have some NVDIMMs that report as type 12 but need two extra
> out-of-tree drivers to work safely.  First, they need i2c_imc or the
> equivalent (I'll try to resubmit that soon).  Second, they need secret
> magic NDAed register poking.  The latter is very problematic.

My current experience is that things may be changing to something of a de-facto
standard in the area of register poking.  In which case, we should be
able to ask
the de-facto vendor standard to be released under a non-NDA license so we can
write a proper user-space library for it.  Or at worst, get a
proprietary source utility
that can do the poking.

The vendor isn't going to sell anything if they don't provide the
tools their resellers
and customers need.


> At the very least, I think we should discourage people who don't
> really know what they're doing from using this driver without care.

What would be the fun in that...

But seriously, speaking as Penguin Computing and a retailer of
hardware, I'd rather
not have the kernel telling my customers what's safe and what isn't
when it's a matter
of opinion.  We provide a solution with support and having to tell my
customers: "you
need to load the module with the 'THIS_IS_UNSAFE' argument set to 3"
isn't productive.

Another intersesting possibility of the memmap= directive to declare a
type 12 region of
of memory is that you can test the driver (without the persistance) on
any arbitrary region
of memory in a machine.  Other comments on this patch set talked about
having to put
virtual test hardware in qemu or kvm.  Aside from the register poking,
just adding
memmap=xx!yy to the command line gives you something pmem can attach to and
you can use to test with.  I suppose you could even simulate
persistance by saving off
the contents and restoring it on a controlled reboot.

Phil P.

-- 
Philip Pokorny, RHCE
Chief Technology Officer
PENGUIN COMPUTING, Inc
www.penguincomputing.com
