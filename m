Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <54EC262E.9010903@plexistor.com>
References: <54EB1D33.3050107@plexistor.com> <54EB206E.4010009@plexistor.com>
 <CALCETrXBwJdAarXVgO7VaEkTHtnO=-+n7mXy02PbS+sLqNiMyA@mail.gmail.com> <54EC262E.9010903@plexistor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 24 Feb 2015 11:58:49 -0800
Message-ID: <CALCETrVUqxL2UbkPqRooYe7zxG5x7cOMGxEFKwNLazZodCHV7Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] resource: Add new flag IORESOURCE_WARN (64bit)
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 23, 2015 at 11:20 PM, Boaz Harrosh <boaz@plexistor.com> wrote:
> On 02/23/2015 05:46 PM, Andy Lutomirski wrote:
>> On Mon, Feb 23, 2015 at 4:43 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
>>>
>>> Resource providers set this flag if they want
>>> that request_region_XXX will print a warning in dmesg
>>> if this particular resource is locked by a driver.
>>>
>>> Thous acting as a Protocol Police about experimental
>>> devices that did not pass a comity approval.
>>>
>>> The warn print looks like this:
>>>   [Feb22 19:59] resource: request unknown region [mem 0x100000000-0x1ffffffff] unkown-12
>>> Where the unkown-12 is taken from the res->name
>>>
>>> The Only user of  this flag is x86/kernel/e820.c that
>>> wants to WARN about UNKNOWN memory types.
>>>
>>> NOTE: This patch looks very simple, a bit flag
>>>   communicates between a resource provider ie e820.c
>>>   that a warning should be printed, and resource.c
>>>   prints such a message, when the resource is locked
>>>   for use.
>>
>> I'm not really convinced this is necessary.  If you somehow manage to
>> reserve a physical address corresponding to an nvdimm, you probably
>> know what you're doing.
>
> I think so too but, Ingo asked for it and I understand how it can be
> useful
>
>> After all, no in-tree driver will do this by
>> default.
>
> What? why? I intend to send pmem upstream soon. For god's sake
> These devices are out there, lots of them, used everyday, since
> when do we keep people systems out-of-tree?
> And why because some comity did not anticipate that the DDR bus
> will be used for "something else". With PCI or any other bus
> I develop a new card, give it an ID, scan for it and use it.
> DDR no, I need to re-write my BIOS, god. I wish it was Linux
> that was scanning the DDR bus, who gives a *ck about BIOS.
> I thought it was you who pushed for Linux's scan of the DDR bus?

This was a scan of the i2c part of the bus, which is kind of
enumerable.  If Linux can reliably enumerate nvdimms, then great!  But
the mere existence of a type 12 e820 region does not indicate the
presence of a working nvdimm (I know this because I have the
super-secret docs for one of these things).  It's also a problem on
EFI, because there's no such thing as type 12.

>
> DDR bus will be used for lots more then flat NvDIMM, we will see
> soon, and already see, lots of Devices off of the DDR bus which as
> nothing to do with memory. The BIOS and e820 better be put aside,
> we need a simple scan and ID for these devices and let upper drivers
> take care of them. What do you want to happen, that each new device
> needs to go through this ordeal all over again?

The BIOS *has* to be involved due to the way that memory controllers work.

In order to access the data part of the bus, the memory controller
needs to be programmed to map all the memory to the right physical
addresses, set up timings, etc.  Until that happens, there is no RAM.
That means that gnarly code runs out of cache (crazy dance, documented
(!) on SNB and earlier and sort of documented on Haswell, dunno about
IVB) very very early in boot.  Booting Linux before that happens would
be impossible.  Afterwards, the memory initialization code has done
its thing, and it had better have mapped the nvdimms somewhere useful,
and not, say, interleaved with other memory, if Linux is supposed to
use them.

So we need BIOS to tell us where they are and what they are.  For that
to work, we need a data channel to BIOS that's guaranteed to exist,
and e820 is not a useful answer.

AFAIK the ACPI people are working on it, and I'm sure that there's
some politics involved, but it'll happen.  In the mean time, if you
can write a driver that works reliably and doesn't cause damage,
great!

--Andy
