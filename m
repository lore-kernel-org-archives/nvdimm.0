Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 26 Oct 2016 22:46:58 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 2/3] use a nocache copy for bvecs and kvecs in
 copy_from_iter_nocache()
Message-ID: <20161027044658.GA20001@linux.intel.com>
References: <20161026155021.20892-1-brian.boylston@hpe.com>
 <20161026155021.20892-3-brian.boylston@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026155021.20892-3-brian.boylston@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian Boylston <brian.boylston@hpe.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, toshi.kani@hpe.com, oliver.moreno@hpe.com, Ross Zwisler <ross.zwisler@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 26, 2016 at 10:50:20AM -0500, Brian Boylston wrote:
> Update copy_from_iter_nocache() to use memcpy_nocache()
> for bvecs and kvecs.
> 
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: <x86@kernel.org>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
> Reviewed-by: Toshi Kani <toshi.kani@hpe.com>
> Reported-by: Oliver Moreno <oliver.moreno@hpe.com>
> ---
>  lib/iov_iter.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index 7e3138c..71e4531 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -342,6 +342,13 @@ static void memcpy_from_page(char *to, struct page *page, size_t offset, size_t
>  	kunmap_atomic(from);
>  }
>  
> +static void memcpy_from_page_nocache(char *to, struct page *page, size_t offset, size_t len)
> +{
> +	char *from = kmap_atomic(page);
> +	memcpy_nocache(to, from + offset, len);
> +	kunmap_atomic(from);
> +}
> +
>  static void memcpy_to_page(struct page *page, size_t offset, const char *from, size_t len)
>  {
>  	char *to = kmap_atomic(page);
> @@ -392,9 +399,10 @@ size_t copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i)
>  	iterate_and_advance(i, bytes, v,
>  		__copy_from_user_nocache((to += v.iov_len) - v.iov_len,
>  					 v.iov_base, v.iov_len),
> -		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
> -				 v.bv_offset, v.bv_len),
> -		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
> +		memcpy_from_page_nocache((to += v.bv_len) - v.bv_len,
> +					 v.bv_page, v.bv_offset, v.bv_len),
> +		memcpy_nocache((to += v.iov_len) - v.iov_len,
> +			       v.iov_base, v.iov_len)
>  	)
>  
>  	return bytes;
> -- 
> 2.8.3

I generally agree with Boaz's comments to your patch 1 - this feels like yet
another layer where we have indirection based on the architecture.

We already have an arch switch at memcpy_to_pmem() based on whether the
architecture supports the PMEM API.  And we already have
__copy_from_user_nocache(), which based on the architecture can map to either
a non-cached memcpy (x86_32, x86_64), or it can just map to a normal memcpy
via __copy_from_user_inatomic() (this happens in include/linux/uaccss.h, which
I believe is used for all non-x86 architectures).

memcpy_nocache() now does the same thing as __copy_from_user_nocache(), where
we define an uncached memcpy for x86_32 and x86_64, and a normal memcpy
variant for other architectures.  But, weirdly, the x86 version maps to our
to __copy_from_user_nocache(), but it on non-x86 we don't map to
__copy_from_user_nocache() and use its fallback, we provide a new fallback of
our own via a direct call to memcpy()?

And, now in copy_from_iter_nocache() on x86 we call __copy_from_user_nocache()
two different ways: directly, and indirectly through memcpy_nocache() and
memcpy_from_page_nocache()=>memcpy_nocache().

Is there any way to simplify all of this?

All in all I'm on board with doing non-temporal copies in all cases, and I
like the idea behind memcpy_from_page_nocache().  I just think there must be a
way to make it simpler.
