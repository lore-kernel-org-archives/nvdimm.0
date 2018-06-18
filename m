Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D0E9A210D93AD
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 06:17:16 -0700 (PDT)
Date: Mon, 18 Jun 2018 09:17:12 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: x86: optimize memcpy_flushcache
Message-ID: <20180618131712.GA25400@redhat.com>
References: <alpine.LRH.2.02.1806180846300.22626@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1806180846300.22626@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Mikulas Patocka <mpatocka@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: dm-devel@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 18 2018 at  8:50am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi Mike
> 
> Could you please push this patch to the kernel 4.18-rc? Dan Williams said 
> that he will submit it, but he forgot about it.
> 
> Without this patch, dm-writecache is suffering 2% penalty because of 
> memcpy_flushcache overhead.

I cannot send this to Linus directly, it needs to go through the x86
tree.

I already tried to get a slightly revised version of this upstream, see:
https://www.redhat.com/archives/dm-devel/2018-May/msg00080.html

I'll try a resend.. but the 4.18 merge window is now closed.

Mike


> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> I use memcpy_flushcache in my persistent memory driver for metadata
> updates and it turns out that the overhead of memcpy_flushcache causes 2%
> performance degradation compared to "movnti" instruction explicitly coded
> using inline assembler.
> 
> This patch recognizes memcpy_flushcache calls with constant short length
> and turns them into inline assembler - so that I don't have to use inline
> assembler in the driver.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  arch/x86/include/asm/string_64.h |   20 +++++++++++++++++++-
>  arch/x86/lib/usercopy_64.c       |    4 ++--
>  2 files changed, 21 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/string_64.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/string_64.h
> +++ linux-2.6/arch/x86/include/asm/string_64.h
> @@ -149,7 +149,25 @@ memcpy_mcsafe(void *dst, const void *src
>  
>  #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
>  #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
> -void memcpy_flushcache(void *dst, const void *src, size_t cnt);
> +void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
> +static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
> +{
> +	if (__builtin_constant_p(cnt)) {
> +		switch (cnt) {
> +			case 4:
> +				asm ("movntil %1, %0" : "=m"(*(u32 *)dst) : "r"(*(u32 *)src));
> +				return;
> +			case 8:
> +				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
> +				return;
> +			case 16:
> +				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
> +				asm ("movntiq %1, %0" : "=m"(*(u64 *)(dst + 8)) : "r"(*(u64 *)(src + 8)));
> +				return;
> +		}
> +	}
> +	__memcpy_flushcache(dst, src, cnt);
> +}
>  #endif
>  
>  #endif /* __KERNEL__ */
> Index: linux-2.6/arch/x86/lib/usercopy_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/lib/usercopy_64.c
> +++ linux-2.6/arch/x86/lib/usercopy_64.c
> @@ -153,7 +153,7 @@ long __copy_user_flushcache(void *dst, c
>  	return rc;
>  }
>  
> -void memcpy_flushcache(void *_dst, const void *_src, size_t size)
> +void __memcpy_flushcache(void *_dst, const void *_src, size_t size)
>  {
>  	unsigned long dest = (unsigned long) _dst;
>  	unsigned long source = (unsigned long) _src;
> @@ -216,7 +216,7 @@ void memcpy_flushcache(void *_dst, const
>  		clean_cache_range((void *) dest, size);
>  	}
>  }
> -EXPORT_SYMBOL_GPL(memcpy_flushcache);
> +EXPORT_SYMBOL_GPL(__memcpy_flushcache);
>  
>  void memcpy_page_flushcache(char *to, struct page *page, size_t offset,
>  		size_t len)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
