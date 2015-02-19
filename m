Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54E5BA90.3010609@plexistor.com>
Date: Thu, 19 Feb 2015 12:27:28 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [Linux-nvdimm] [PATCH 0/2] e820: Fix handling of NvDIMM chips
References: <54E1CF5B.9020905@plexistor.com>	<20150216220302.GF3364@wil.cx>	<54E2FEF2.8060701@plexistor.com>	<CAPcyv4if=9Cv__4D0oE9ds1C37TRDkURSVtyB8_k9Nc3WUwbrg@mail.gmail.com>	<20150218183049.GA7032@gmail.com>	<CAPcyv4hq0ETPMEuH0RKuy1=bqrnDM4-k+36ESTnS5EuB6d4MJw@mail.gmail.com>	<20150218185327.GA7828@gmail.com>	<CAPcyv4jVyk=mTRzGCKhy9P8cjukiuBWE=kfRaZ2DG-QsVgsvYg@mail.gmail.com>	<20150218192704.GA8441@gmail.com> <CAPcyv4inN4Pja9vOpYd8m_RB6kgFmjQXvwJv3CqKwEUaaXpNCw@mail.gmail.com>
In-Reply-To: <CAPcyv4inN4Pja9vOpYd8m_RB6kgFmjQXvwJv3CqKwEUaaXpNCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@kernel.org>
Cc: Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <linux-nvdimm@lists.01.org>

On 02/18/2015 09:35 PM, Dan Williams wrote:
> On Wed, Feb 18, 2015 at 11:27 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
<>
>>>>>>>
>>>>>>> No, it seems the safe thing to do is prevent the
>>>>>>> kernel from accessing any memory that it does not know
>>>>>>> the side-effects of accessing.
>>>>>>
<>

The Kernel does not do any such access.

Reading the code the  "busy" state of the unknown type looks
like an accident to me. The code just assumes all types are
known. And did a negative check.

Consider a memory-region that sits on a PCIE slot. The BUS
does not know anything about that BAR, it just exposes that
information up the stack so a driver can positively identify
its device and drive it.

Same here. e820 is just a description of what sits on the
DDR I^2C bus as read by the BIOS (or other means). The actual
driver of these is for example the add_memory() call. Well sure
unknown-types are not added to any active use.

Parallel to what you are saying is that we band any PCI-ID
that does not have a registered device-id, the card will be
enumerated but drivers will receive "already taken" even
though no one is using it.

If you really believe in what you are saying then please
move away from the "busy" bit. "busy" bit means "taken".
Have a new bit saying. "no one told me about this device"

>>>>>> Well, except when the kernel does know how to access
>>>>>> it: when an nvdimm driver knows about its own memory
>>>>>> region and knows how to handle it, right?
>>>>>
<>
>>>>
>>>> But ... if a user is blessed/haunted with such firmware,
>>>> why not let new types fall back to 'reserved', which is a
>>>> reasonable default that still allows sufficiently aware
>>>> Linux drivers to work, right?
>>>

I want to emphasize here. After my patch the new type is
distinctly differentiated from the regular "reserved"
type so any knowledgeable driver can easily distinguish
it from a regular "reserved" region.

Only that when such driver wants to register its use
of that region it does not receive a phony busy.

[And Proceed to use that region by ignoring the phony busy]  

<>
>>
>> Well, we could emit a warning (or taint the kernel), to
>> keep the user informed that there's a version mismatch
>> between kernel and firmware - but otherwise still allow
>> informed drivers to register that region?
> 
> Sounds good to me.
> 

There is already a distinct message both at dmesg bring up:
	 user: [mem 0x0000000100000000-0x000000017fffffff] type 12
And at /proc/iomem
	100000000-1ffffffff : reserved-unknown

I would love to make this:
	100000000-1ffffffff : unknown-12

But it will need a bit of code to maintain such strings

So the information for any one that wants to look for it is there.

Do you require another redundant message who's purpose is to scare
people off, like:
	e820: WARN [mem 0x0000000100000000-0x000000017fffffff] is unknown type 12

Sure I'll add it

Thanks
Boaz

