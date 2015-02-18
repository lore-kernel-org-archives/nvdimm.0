Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <54E2FEF2.8060701@plexistor.com>
References: <54E1CF5B.9020905@plexistor.com>
	<20150216220302.GF3364@wil.cx>
	<54E2FEF2.8060701@plexistor.com>
Date: Wed, 18 Feb 2015 10:15:32 -0800
Message-ID: <CAPcyv4if=9Cv__4D0oE9ds1C37TRDkURSVtyB8_k9Nc3WUwbrg@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH 0/2] e820: Fix handling of NvDIMM chips
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 17, 2015 at 12:42 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
> On 02/17/2015 12:03 AM, Matthew Wilcox wrote:
>> On Mon, Feb 16, 2015 at 01:07:07PM +0200, Boaz Harrosh wrote:
>>> In any way this is a problem for the new type-12 NvDIMM memory chips that
>>> are circulating around. (It is estimated that there are already 100ds of
>>> thousands NvDIMM chips in active use)
>>
>> Hang on.  NV-DIMM chips don't know anyhing about E820 tables.  They don't
>> have anything in them that says "I am type 12!".  How they are reported
>> is up to the BIOS.  Just because your BIOS vendor has chosen to report
>> tham as type 12 doesn't mean that any other BIOS vedor is going to have
>> done the same thing.
>>
>> Fortunately, the BIOS people have all got together and decided what
>> they're going to do, and it's not type 12.  Unfortunately, I think
>> I'm bound by various agreements to not say what they are going to do
>> until they do.  But putting this temporary workaround in the kernel to
>> accomodate one BIOS vendor's unreleased experimental code seems like
>> entirely the wrong idea.
>>
>
> I had a feeling I'm entering an holy war ;-).
>
> I hope you are OK with my first patch. That an unknown type need not
> be reported busy, and behave same as "reserved"?

No, it seems the safe thing to do is prevent the kernel from accessing
any memory that it does not know the side-effects of accessing.

> Then if we agree about PATCH-1, which is the actual fix.
> Then the 2nd patch (hence the RFC btw) is nothing more than
> a name.
>
> I have an old BIOS that knows nothing of NvDIMM, actually a few
> of them they all report 12.
> The fact of the matter is that all the people I've talked with,
> reported that different vendor chips, all came up type-12.
> Perhaps type-12 just means "Unknown to current BIOS"
>
> What is the name you suggest "type-12" "unknown-12".
> Do you understand why they all come out 12 ?
>

In fact it was originally "type-6" until ACPI 5 claimed that number
for official use, so these platforms, with early proof-of-concept
nvdimm support, have already gone through one transition to a new
number.  They need to do the same once an official number for nvdimm
support is published.

Put another way, these early platforms are already using out-of-tree
patches for nvdimm enabling.  They can continue to do so, or switch to
standard methods when the standard is published.
