Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 9 Feb 2016 11:27:41 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] x86/lib/copy_user_64.S: Handle 4-byte nocache copy
Message-ID: <20160209102741.GA11313@gmail.com>
References: <1454524511-29416-1-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1454524511-29416-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, micah.parrish@hpe.com, brian.boylston@hpe.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


* Toshi Kani <toshi.kani@hpe.com> wrote:

> Data corruption issues were observed in tests which initiated
> a system crash/reset while accessing BTT devices.  This problem
> is reproducible.
> 
> The BTT driver calls pmem_rw_bytes() to update data in pmem
> devices.  This interface calls __copy_user_nocache(), which
> uses non-temporal stores so that the stores to pmem are
> persistent.
> 
> __copy_user_nocache() uses non-temporal stores when a request
> size is 8 bytes or larger (and is aligned by 8 bytes).  The
> BTT driver updates the BTT map table, which entry size is
> 4 bytes.  Therefore, updates to the map table entries remain
> cached, and are not written to pmem after a crash.
> 
> Change __copy_user_nocache() to use non-temporal store when
> a request size is 4 bytes.  The change extends the current
> byte-copy path for a less-than-8-bytes request, and does not
> add any overhead to the regular path.
> 
> Also add comments to the code, and clarify the cases that
> lead cache copy.
> 
> Reported-and-tested-by: Micah Parrish <micah.parrish@hpe.com>
> Reported-and-tested-by: Brian Boylston <brian.boylston@hpe.com>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> ---
> v2:
>  - Add comments (Ingo Molnar).
>  - Make this patch as an individual patch since v2 debug changes
>    will not depend on this patch.
> ---
>  arch/x86/lib/copy_user_64.S |   74 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 61 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
> index 982ce34..1641327 100644
> --- a/arch/x86/lib/copy_user_64.S
> +++ b/arch/x86/lib/copy_user_64.S
> @@ -232,17 +232,30 @@ ENDPROC(copy_user_enhanced_fast_string)
>  
>  /*
>   * copy_user_nocache - Uncached memory copy with exception handling
> - * This will force destination/source out of cache for more performance.
> + * This will force destination out of cache for more performance.
> + *
> + * Note: Cached memory copy is used when destination or size is not
> + * naturally aligned. That is:
> + *  - Require 8-byte alignment when size is 8 bytes or larger.
> + *  - Require 4-byte alignment when size is 4 bytes.
>   */
>  ENTRY(__copy_user_nocache)
>  	ASM_STAC
> +
> +	/* If size is less than 8 bytes, goto 4-byte copy */
>  	cmpl $8,%edx
> -	jb 20f		/* less then 8 bytes, go to byte copy loop */
> +	jb 20f

So another pet peeve of mine is to not use numeric labels, please use 
descriptively named labels instead.

It would also be nice to split the patch into two parts: first one does all these 
readability improvements, the second one adds the nocache enhancement/fix.

Thanks,

	Ingo
