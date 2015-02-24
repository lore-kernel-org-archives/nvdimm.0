Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 24 Feb 2015 10:07:43 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/3 v3] resource: Add new flag IORESOURCE_MEM_WARN
Message-ID: <20150224090742.GC19930@gmail.com>
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

> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1075,8 +1075,13 @@ struct resource * __request_region(struct resource *parent,
>  			break;
>  		if (conflict != parent) {
>  			parent = conflict;
> -			if (!(conflict->flags & IORESOURCE_BUSY))
> +			if (!(conflict->flags & IORESOURCE_BUSY)) {
> +				if (conflict->flags & IORESOURCE_MEM_WARN)
> +					pr_warn("request unknown region [mem %#010llx-%#010llx] %s\n",
> +						conflict->start, conflict->end,
> +						conflict->name);

Maybe:

   'request region with unknown memory type [mem ...]'?

The driver (we hope!) very well knows about the region so 
it's not totally unknown.

Thanks,

	Ingo
