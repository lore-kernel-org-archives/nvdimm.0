Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <55883605.5020706@sgi.com>
Date: Mon, 22 Jun 2015 09:21:25 -0700
From: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] mm, x86: Remove region_is_ram() call from ioremap
References: <1434750245-6304-1-git-send-email-toshi.kani@hp.com> <1434750245-6304-3-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1434750245-6304-3-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org
Cc: roland@purestorage.com, dan.j.williams@intel.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Clive Harding <clive@sgi.com>, Russ Anderson <rja@sgi.com>
List-ID: <linux-nvdimm@lists.01.org>



On 6/19/2015 2:44 PM, Toshi Kani wrote:
> __ioremap_caller() calls region_is_ram() to look up the resource
> to check if a target range is RAM, which was added as an additinal
> check to improve the lookup performance over page_is_ram() (commit
> 906e36c5c717 "x86: use optimized ioresource lookup in ioremap
> function").
> 
> __ioremap_caller() then calls walk_system_ram_range(), which had
> replaced page_is_ram() to improve the lookup performance (commit
> c81c8a1eeede "x86, ioremap: Speed up check for RAM pages").
> 
> Since both functions walk through the resource table, there is
> no need to call the two functions.  Furthermore, region_is_ram()
> has bugs and always returns with -1.  This makes
> walk_system_ram_range() as the only check being used.

Do you have an example of a failing case?  Also, I didn't know that
IOREMAP'd addresses were allowed to be on non-page boundaries?

Here's the comment and reason for the patches from Patch 0:

<<<
We have a large university system in the UK that is experiencing
very long delays modprobing the driver for a specific I/O device.
The delay is from 8-10 minutes per device and there are 31 devices
in the system.  This 4 to 5 hour delay in starting up those I/O
devices is very much a burden on the customer.
...
The problem was tracked down to a very slow IOREMAP operation and
the excessively long ioresource lookup to insure that the user is
not attempting to ioremap RAM.  These patches provide a speed up
to that function.
>>>

The speed up was pretty dramatic, I think to about 15-20 minutes
(the test was done by our local CS person in the UK).  I think this
would prove the function was working since it would have fallen
back to the previous page_is_ram function and the 4 to 5 hour
startup.

If there is a failure, it would be better for all to fix the specific
bug and not re-introduce the original problem.  Perhaps drop to
page is ram if the address is not page aligned?

> Hence, remove the call to region_is_ram() from __ioremap_caller().
> 
> Note, removing the call to region_is_ram() is also necessary
> to fix the bugs in region_is_ram().  walk_system_ram_range()
> requires RAM ranges aligned by the page size in the resource
> table.  e820_reserve_setup_data() updates the e820 table by
> allocating a separate entry to each data region in setup_data,
> which is not page-aligned.  Therefore, walk_system_ram_range()
> is unable to detect the RAM ranges in setup_data.  This
> restriction has allowed multiple uses of ioremap() to map
> setup_data.  Using fixed region_is_ram() will cause these callers
> to start failing.  After all ioremap to setup_data are converted,
> __ioremap_caller() may call region_is_ram() instead.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  arch/x86/mm/ioremap.c |   24 ++++++------------------
>  1 file changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index 56f8af7..928867e 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -89,7 +89,6 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>  	pgprot_t prot;
>  	int retval;
>  	void __iomem *ret_addr;
> -	int ram_region;
>  
>  	/* Don't allow wraparound or zero size */
>  	last_addr = phys_addr + size - 1;
> @@ -112,26 +111,15 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>  	/*
>  	 * Don't allow anybody to remap normal RAM that we're using..
>  	 */
> -	/* First check if whole region can be identified as RAM or not */
> -	ram_region = region_is_ram(phys_addr, size);
> -	if (ram_region > 0) {
> -		WARN_ONCE(1, "ioremap on RAM at 0x%lx - 0x%lx\n",
> -				(unsigned long int)phys_addr,
> -				(unsigned long int)last_addr);
> -		return NULL;
> -	}
> -
> -	/* If could not be identified(-1), check page by page */
> -	if (ram_region < 0) {
> -		pfn      = phys_addr >> PAGE_SHIFT;
> -		last_pfn = last_addr >> PAGE_SHIFT;
> -		if (walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,
> +	pfn      = phys_addr >> PAGE_SHIFT;
> +	last_pfn = last_addr >> PAGE_SHIFT;
> +	if (walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,
>  					  __ioremap_check_ram) == 1) {
> -			WARN_ONCE(1, "ioremap on RAM at 0x%llx - 0x%llx\n",
> +		WARN_ONCE(1, "ioremap on RAM at 0x%llx - 0x%llx\n",
>  					phys_addr, last_addr);
> -			return NULL;
> -		}
> +		return NULL;
>  	}
> +
>  	/*
>  	 * Mappings have to be page-aligned
>  	 */
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
