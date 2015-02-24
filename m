Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 24 Feb 2015 10:06:08 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/3 v3] resource: Add new flag IORESOURCE_MEM_WARN
Message-ID: <20150224090608.GB19930@gmail.com>
References: <54EB1D33.3050107@plexistor.com>
 <54EB206E.4010009@plexistor.com>
 <CALCETrXBwJdAarXVgO7VaEkTHtnO=-+n7mXy02PbS+sLqNiMyA@mail.gmail.com>
 <54EC38CA.6050607@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54EC38CA.6050607@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>


* Boaz Harrosh <boaz@plexistor.com> wrote:

> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -255,6 +256,5 @@ static inline bool resource_overlaps(struct resource *r1, struct resource *r2)
>         return (r1->start <= r2->end && r1->end >= r2->start);
>  }
>  
> -
>  #endif /* __ASSEMBLY__ */

While the newline is spurious, it should probably not be 
removed in this patch.

Thanks,

	Ingo
