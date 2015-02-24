Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54EC39EB.8030901@plexistor.com>
Date: Tue, 24 Feb 2015 10:44:27 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3 v3] resource: Add new flag IORESOURCE_MEM_WARN
References: <54EB1D33.3050107@plexistor.com> <54EB206E.4010009@plexistor.com> <CALCETrXBwJdAarXVgO7VaEkTHtnO=-+n7mXy02PbS+sLqNiMyA@mail.gmail.com> <54EC38CA.6050607@plexistor.com>
In-Reply-To: <54EC38CA.6050607@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 02/24/2015 10:39 AM, Boaz Harrosh wrote:
> 
> Resource providers set this flag if they want
> that request_region_XXX will print a warning in dmesg
> if this particular resource is locked by a driver.
> 
> Thous acting as a Protocol Police about experimental
> devices that did not pass a comity approval.
> 
> The Only user of  this flag is x86/kernel/e820.c that
> wants to WARN about UNKNOWN memory types.
> 

Hi Ingo

So I slept on it and I think this simple version is safe and
does what we need. It is more simple than the wrappers thing

Who can push such a patch, can you push it through your tree or
is there another maintainer that needs to push this?

Who can we ask about the safeness of these flags?

> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
<>

Thanks
Boaz

