Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150218192704.GA8441@gmail.com>
References: <54E1CF5B.9020905@plexistor.com>
	<20150216220302.GF3364@wil.cx>
	<54E2FEF2.8060701@plexistor.com>
	<CAPcyv4if=9Cv__4D0oE9ds1C37TRDkURSVtyB8_k9Nc3WUwbrg@mail.gmail.com>
	<20150218183049.GA7032@gmail.com>
	<CAPcyv4hq0ETPMEuH0RKuy1=bqrnDM4-k+36ESTnS5EuB6d4MJw@mail.gmail.com>
	<20150218185327.GA7828@gmail.com>
	<CAPcyv4jVyk=mTRzGCKhy9P8cjukiuBWE=kfRaZ2DG-QsVgsvYg@mail.gmail.com>
	<20150218192704.GA8441@gmail.com>
Date: Wed, 18 Feb 2015 11:35:19 -0800
Message-ID: <CAPcyv4inN4Pja9vOpYd8m_RB6kgFmjQXvwJv3CqKwEUaaXpNCw@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH 0/2] e820: Fix handling of NvDIMM chips
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 18, 2015 at 11:27 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Dan Williams <dan.j.williams@intel.com> wrote:
>
>> On Wed, Feb 18, 2015 at 10:53 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * Dan Williams <dan.j.williams@intel.com> wrote:
>> >
>> >> On Wed, Feb 18, 2015 at 10:30 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> >> >
>> >> > * Dan Williams <dan.j.williams@intel.com> wrote:
>> >> >
>> >> >> On Tue, Feb 17, 2015 at 12:42 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
>> >> >> > On 02/17/2015 12:03 AM, Matthew Wilcox wrote:
>> >> >> >> On Mon, Feb 16, 2015 at 01:07:07PM +0200, Boaz Harrosh wrote:
>> >> >> >>> In any way this is a problem for the new type-12 NvDIMM memory chips that
>> >> >> >>> are circulating around. (It is estimated that there are already 100ds of
>> >> >> >>> thousands NvDIMM chips in active use)
>> >> >> >>
>> >> >> >> Hang on.  NV-DIMM chips don't know anyhing about E820
>> >> >> >> tables.  They don't have anything in them that says "I
>> >> >> >> am type 12!".  How they are reported is up to the
>> >> >> >> BIOS.  Just because your BIOS vendor has chosen to
>> >> >> >> report tham as type 12 doesn't mean that any other
>> >> >> >> BIOS vedor is going to have done the same thing.
>> >> >> >>
>> >> >> >> Fortunately, the BIOS people have all got together and
>> >> >> >> decided what they're going to do, and it's not type
>> >> >> >> 12.  Unfortunately, I think I'm bound by various
>> >> >> >> agreements to not say what they are going to do until
>> >> >> >> they do.  But putting this temporary workaround in the
>> >> >> >> kernel to accomodate one BIOS vendor's unreleased
>> >> >> >> experimental code seems like entirely the wrong idea.
>> >> >> >>
>> >> >> >
>> >> >> > I had a feeling I'm entering an holy war ;-).
>> >> >> >
>> >> >> > I hope you are OK with my first patch. That an unknown
>> >> >> > type need not be reported busy, and behave same as
>> >> >> > "reserved"?
>> >> >>
>> >> >> No, it seems the safe thing to do is prevent the
>> >> >> kernel from accessing any memory that it does not know
>> >> >> the side-effects of accessing.
>> >> >
>> >> > Well, except when the kernel does know how to access
>> >> > it: when an nvdimm driver knows about its own memory
>> >> > region and knows how to handle it, right?
>> >>
>> >> Yes, except that "type-12" is something picked out of the
>> >> air that may be invalidated by a future spec change.
>> >>
>> >> If firmware wants any driver to handle a memory range it
>> >> can already use E820_RESERVED.  The only reason a
>> >> new-type was picked in these early implementations was
>> >> for experiments around reserving nvdimm memory for driver
>> >> use, but also extending it to be covered with struct page
>> >> mappings.  Outside of that there is no real driving
>> >> reason for the new type.
>> >
>> > But ... if a user is blessed/haunted with such firmware,
>> > why not let new types fall back to 'reserved', which is a
>> > reasonable default that still allows sufficiently aware
>> > Linux drivers to work, right?
>>
>> True.
>>
>> >
>> >> > So is there any practical reason to mark the memory
>> >> > resource as busy in that case, instead of just adding
>> >> > it to the reserved list by default and allowing
>> >> > properly informed drivers to (exclusively) request it?
>> >>
>> >> I'm not sure we want firmware to repeat this confusion
>> >> going forward. Why support new memory types unless
>> >> defined by ACPI or otherwise sufficiently described by
>> >> E820_RESERVED?
>> >
>> > Because it would make the kernel more functional? We should
>> > always err on the side of allowing more functionality and
>> > not erect roadblocks.
>> >
>>
>> I'm not convinced Linux is better off enabling one-off
>> BIOS implementations to pick non-standard numbers.  Would
>> it not be safer to at least confirm with the user via a
>> configuration option, "do you want drivers to access
>> unknown memory types"?
>
> Well, we could emit a warning (or taint the kernel), to
> keep the user informed that there's a version mismatch
> between kernel and firmware - but otherwise still allow
> informed drivers to register that region?

Sounds good to me.
