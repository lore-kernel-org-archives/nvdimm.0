Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <54EB206E.4010009@plexistor.com>
References: <54EB1D33.3050107@plexistor.com> <54EB206E.4010009@plexistor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 23 Feb 2015 07:46:47 -0800
Message-ID: <CALCETrXBwJdAarXVgO7VaEkTHtnO=-+n7mXy02PbS+sLqNiMyA@mail.gmail.com>
Subject: Re: [PATCH 2/3] resource: Add new flag IORESOURCE_WARN (64bit)
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 23, 2015 at 4:43 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
>
> Resource providers set this flag if they want
> that request_region_XXX will print a warning in dmesg
> if this particular resource is locked by a driver.
>
> Thous acting as a Protocol Police about experimental
> devices that did not pass a comity approval.
>
> The warn print looks like this:
>   [Feb22 19:59] resource: request unknown region [mem 0x100000000-0x1ffffffff] unkown-12
> Where the unkown-12 is taken from the res->name
>
> The Only user of  this flag is x86/kernel/e820.c that
> wants to WARN about UNKNOWN memory types.
>
> NOTE: This patch looks very simple, a bit flag
>   communicates between a resource provider ie e820.c
>   that a warning should be printed, and resource.c
>   prints such a message, when the resource is locked
>   for use.

I'm not really convinced this is necessary.  If you somehow manage to
reserve a physical address corresponding to an nvdimm, you probably
know what you're doing.  After all, no in-tree driver will do this by
default.

--Andy
