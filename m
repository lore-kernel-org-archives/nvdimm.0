Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <54EC2F4E.1080606@plexistor.com>
References: <54EB1D33.3050107@plexistor.com>
	<54EB1E03.4010306@plexistor.com>
	<1424751767.9050.4.camel@intel.com>
	<54EC2F4E.1080606@plexistor.com>
Date: Wed, 25 Feb 2015 18:09:01 -0800
Message-ID: <CAPcyv4hNJO+2S7-H52CY7PjCVx46=OC0OMqO09vO-WB0MFVM-g@mail.gmail.com>
Subject: Re: [PATCH 1/3] e820: Don't let unknown DIMM type come out BUSY
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 23, 2015 at 11:59 PM, Boaz Harrosh <boaz@plexistor.com> wrote:
> No, this is a complete HACK, since when do we hard code specific (GLOBAL)
> ARCHs strings in common code. Please look at linux/ioport.h see the richness
> of options for all kind of buses and systems. The flag system works perfectly
> and I just continue this here.
>
> And really DAN, you prefer a global string that's dead garbage in 99% of arches
> to a simple bit flag definition that costs nothing? I don't think so.

Glad we're moving ahead with the IORESOURCE_MEM_WARN solution rather
than this or the 64-bit-limited IORESOURCE_WARN approach.

>
>> +             add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
>
> NACK!!
>

I disagree.  Ultimately what goes into kernel/resource.c is not up to
me, but firmware/driver combinations that subvert standards should be
flagged by the kernel.  Stepping back from the original motivation, in
the general case, an unknown memory type is indiscernible from a BIOS
bug.

TAINT_FIRMWARE_WORKAROUND is simply a notification that firmware needs
to be updated, and I believe a driver attaching to unknown memory is
such an event.  It does not block a user from using that memory
however he or she sees fit.
