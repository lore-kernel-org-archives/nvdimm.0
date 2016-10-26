From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 1/3] introduce memcpy_nocache()
Date: Wed, 26 Oct 2016 21:30:39 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1610262110220.5013@nanos>
References: <20161026155021.20892-1-brian.boylston@hpe.com> <20161026155021.20892-2-brian.boylston@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161026155021.20892-2-brian.boylston@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian Boylston <brian.boylston@hpe.com>
Cc: linux-nvdimm@ml01.01.org, linux-kernel@vger.kernel.org, toshi.kani@hpe.com, oliver.moreno@hpe.com, Ross Zwisler <ross.zwisler@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-nvdimm@lists.01.org

On Wed, 26 Oct 2016, Brian Boylston wrote:
> --- a/arch/x86/include/asm/string_32.h
> +++ b/arch/x86/include/asm/string_32.h
> @@ -196,6 +196,9 @@ static inline void *__memcpy3d(void *to, const void *from, size_t len)

> +#define __HAVE_ARCH_MEMCPY_NOCACHE
> +extern void *memcpy_nocache(void *dest, const void *src, size_t count);

Can we please move that prototype to linux/string.h instead of having it in
both files and just define __HAVE_ARCH_MEMCPY_NOCACHE? And that define can
move into x86/include/asm/string.h. There is no point in duplicating all
that stuff.

> --- a/arch/x86/include/asm/string_64.h
> +++ b/arch/x86/include/asm/string_64.h
> @@ -51,6 +51,9 @@ extern void *__memcpy(void *to, const void *from, size_t len);

> +#define __HAVE_ARCH_MEMCPY_NOCACHE
> +extern void *memcpy_nocache(void *dest, const void *src, size_t count)

> +#ifdef __HAVE_ARCH_MEMCPY_NOCACHE

You define __HAVE_ARCH_MEMCPY_NOCACHE for both 32 and 64 bit. What is
this #ifdef for ?

> +void *memcpy_nocache(void *dest, const void *src, size_t count)
> +{
> +	__copy_from_user_inatomic_nocache(dest, src, count);

You want to replace a memcpy with this and then use copy from user. Why?
That does not make any sense to me and even if it makes sense for whatever
reason then this wants to be documented and the src argument needs a type
cast to (void __user *)..

Further this uses the inatomic variant. Why? Does a memcpy replacement
suddenly require to be called in atomic context? Again, this makes no sense
and lacks any form of comment. The kernel doc below does not say anything
about that.

Neither provides the changelog any useful information which is
complementary to what the patch actually does.

> +#ifndef __HAVE_ARCH_MEMCPY_NOCACHE
> +/**
> + * memcpy_nocache - Copy one area of memory to another, avoiding the
> + * processor cache if possible

I'm not sure whether kerneldoc is happy about that line break. Did you
build the docs?

Make the initial line shorter and explain the functionality in detail
below the arguments

> + * @dest: Where to copy to
> + * @src: Where to copy from
> + * @count: The size of the area.

Nit. Can you please make this in tabular form for readability sake?

 * @dest:	Where to copy to
 * @src:	Where to copy from
 * @count:	The size of the area.

> + */
> +static inline void *memcpy_nocache(void *dest, const void *src, size_t count)
> +{
> +	return memcpy(dest, src, count);
> +}
> +#endif

Thanks,

	tglx
