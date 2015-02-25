Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 25 Feb 2015 11:22:40 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/3 v2] e820: Fix handling of NvDIMM chips
Message-ID: <20150225102240.GC7134@gmail.com>
References: <54EB1D33.3050107@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54EB1D33.3050107@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>


* Boaz Harrosh <boaz@plexistor.com> wrote:

> List of patches:
>  [PATCH 1/3] e820: Don't let unknown DIMM type come out BUSY
> 	The main fix
> 
>  [PATCH 2/3] resource: Add new flag IORESOURCE_WARN (64bit)
> 	Warn in request_resource
> 
>  [PATCH 3A/3] e820: Add the unknown-12 Memory type (DDR3-NvDIMM)
> 	Please accept this simple patch
> 
>  [PATCH 3B/3] e820: dynamic unknown-xxx names (for DDR3-NvDIMM)
> 	Else we need this crap

Please also include your nvdimm driver in your next 
submission (even if that is not part of the submission 
yet), so that we can see how the driver makes use of the 
new facility.

There's quite a bit of confusion about what means what, 
people are not of one opinion, and it's easier to see and 
check the fine code instead of making assumptions.

Thanks,

	Ingo
