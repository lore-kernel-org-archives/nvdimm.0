Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <1445871136.20657.81.camel@hpe.com>
Subject: Re: [PATCH v2 3/3] ACPI/APEI/EINJ: Allow memory error injection to
 NVDIMM
From: Toshi Kani <toshi.kani@hpe.com>
Date: Mon, 26 Oct 2015 08:52:16 -0600
In-Reply-To: <20151025104512.GC6084@nazgul.tnic>
References: <1445626439-8424-1-git-send-email-toshi.kani@hpe.com>
	 <1445626439-8424-4-git-send-email-toshi.kani@hpe.com>
	 <20151025104512.GC6084@nazgul.tnic>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@alien8.de>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, rjw@rjwysocki.net, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Sun, 2015-10-25 at 11:45 +0100, Borislav Petkov wrote:
> On Fri, Oct 23, 2015 at 12:53:59PM -0600, Toshi Kani wrote:
> > In the case of memory error injection, einj_error_inject() checks
> > if a target address is regular RAM.  Update this check to add a call
> > to region_intersects_pmem() to verify if a target address range is
> > NVDIMM.  This allows injecting a memory error to both RAM and NVDIMM
> > for testing.
> > 
> > Also, the current RAM check, page_is_ram(), is replaced with
> > region_intersects_ram() so that it can verify a target address
> > range with the requested size.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> > ---
> >  drivers/acpi/apei/einj.c |   12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> ...
> 
> > @@ -545,10 +545,14 @@ static int einj_error_inject(u32 type, u32 flags, u64 param1,
> > u64 param2,
> >  	/*
> >  	 * Disallow crazy address masks that give BIOS leeway to pick
> >  	 * injection address almost anywhere. Insist on page or
> > -	 * better granularity and that target address is normal RAM.
> > +	 * better granularity and that target address is normal RAM or
> > +	 * NVDIMM.
> >  	 */
> > -	pfn = PFN_DOWN(param1 & param2);
> > -	if (!page_is_ram(pfn) || ((param2 & PAGE_MASK) != PAGE_MASK))
> > +	base_addr = param1 & param2;
> > +	size = (~param2) + 1;
> 
> Just a minor nitpick: please separate assignments from the if-statement
> here with a \n.

Sure.  I will send an updated patch for 3/3, "[PATCH v2 UPDATE 3/3]".

Thanks,
-Toshi

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
