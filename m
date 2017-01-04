From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] x86: fix kaslr and memmap collision
Date: Wed, 4 Jan 2017 10:37:28 +0800
Message-ID: <20170104023728.GC15788@x1>
References: <148347651968.64111.7765172823804130174.stgit@djiang5-desk3.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <148347651968.64111.7765172823804130174.stgit-Cxk7aZI4ujnJARH06PadV2t3HXsI98Cx0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Hi Dave,

I have several concerns, please see the inline comments.

On 01/03/17 at 01:48pm, Dave Jiang wrote:
> CONFIG_RANDOMIZE_BASE relocates the kernel to a random base address.
> However it does not take into account the memmap= parameter passed in from
> the kernel cmdline. This results in the kernel sometimes being put in
> the middle of the user memmap. Teaching kaslr to not insert the kernel in
		    ~~~~~~~~~~~
It could be better to be replaced with "user-defined physical RAM map"
or memmap directly because memmap is meaning user-defined physical RAM
map. Please check the boot info printing about them. I was confused at
first glance.
> memmap defined regions. We will support up to 4 memmap regions. Any
> additional regions will cause kaslr to disable. The mem_avoid set has
> been augmented to add up to 4 regions of memmaps provided by the user
                              ~~~
    4 un-usable memmap region need be cared, usable memory is not
concerned.
> to exclude those regions from the set of valid address range to insert
> the uncompressed kernel image. The nn@ss ranges will be skipped by the
> mem_avoid set since it indicates memory useable.
> 
> Signed-off-by: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/boot/boot.h             |    3 +
>  arch/x86/boot/compressed/kaslr.c |  131 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/boot/string.c           |   38 +++++++++++
>  3 files changed, 172 insertions(+)
> 
> diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
> index e5612f3..59c2075 100644
> --- a/arch/x86/boot/boot.h
> +++ b/arch/x86/boot/boot.h
> @@ -332,7 +332,10 @@ int strncmp(const char *cs, const char *ct, size_t count);
>  size_t strnlen(const char *s, size_t maxlen);
>  unsigned int atou(const char *s);
>  unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base);
> +unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base);
> +long simple_strtol(const char *cp, char **endp, unsigned int base);
>  size_t strlen(const char *s);
> +char *strchr(const char *s, int c);
>  
>  /* tty.c */
>  void puts(const char *);
> diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
> index a66854d..f5a1c8d 100644
> --- a/arch/x86/boot/compressed/kaslr.c
> +++ b/arch/x86/boot/compressed/kaslr.c
> @@ -11,6 +11,7 @@
>   */
>  #include "misc.h"
>  #include "error.h"
> +#include "../boot.h"
>  
>  #include <generated/compile.h>
>  #include <linux/module.h>
> @@ -61,9 +62,16 @@ enum mem_avoid_index {
>  	MEM_AVOID_INITRD,
>  	MEM_AVOID_CMDLINE,
>  	MEM_AVOID_BOOTPARAMS,
> +	MEM_AVOID_MEMMAP1,
> +	MEM_AVOID_MEMMAP2,
> +	MEM_AVOID_MEMMAP3,
> +	MEM_AVOID_MEMMAP4,

This looks not good. Could it be done like fixed_addresses?
Something like:

	MEM_AVOID_MEMMAP_BEGIN,
	MEM_AVOID_MEMMAP_BEGIN + MEM_AVOID_MAX -1,

Please point it out to me if there's some existing code in kernel like
your way, I can also accept it.

>  	MEM_AVOID_MAX,
>  };
>  
> +/* only supporting at most 4 memmap regions with kaslr */
And here, "Only supporting at most 4 un-usable memmap regions with kaslr"?
Surely this is based on if you will ignore the usable memory and do not
store it as 0. And also the log need be changed too accordingly.
> +#define MAX_MEMMAP_REGIONS	4
> +
>  static struct mem_vector mem_avoid[MEM_AVOID_MAX];
>  
>  static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
> @@ -77,6 +85,121 @@ static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
>  	return true;
>  }
>  
> +/**
> + *	_memparse - parse a string with mem suffixes into a number
> + *	@ptr: Where parse begins
> + *	@retptr: (output) Optional pointer to next char after parse completes
> + *
> + *	Parses a string into a number.  The number stored at @ptr is
> + *	potentially suffixed with K, M, G, T, P, E.
> + */
> +static unsigned long long _memparse(const char *ptr, char **retptr)
> +{
> +	char *endptr;	/* local pointer to end of parsed string */
> +
> +	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
> +
> +	switch (*endptr) {
> +	case 'E':
> +	case 'e':
> +		ret <<= 10;
> +	case 'P':
> +	case 'p':
> +		ret <<= 10;
> +	case 'T':
> +	case 't':
> +		ret <<= 10;
> +	case 'G':
> +	case 'g':
> +		ret <<= 10;
> +	case 'M':
> +	case 'm':
> +		ret <<= 10;
> +	case 'K':
> +	case 'k':
> +		ret <<= 10;
> +		endptr++;
> +	default:
> +		break;
> +	}
> +
> +	if (retptr)
> +		*retptr = endptr;
> +
> +	return ret;
> +}
> +
> +static int
> +parse_memmap(char *p, unsigned long long *start, unsigned long long *size)
> +{
> +	char *oldp;
> +
> +	if (!p)
> +		return -EINVAL;
> +
> +	/* we don't care about this option here */
> +	if (!strncmp(p, "exactmap", 8))
> +		return -EINVAL;
> +
> +	oldp = p;
> +	*size = _memparse(p, &p);
> +	if (p == oldp)
> +		return -EINVAL;
> +
> +	switch (*p) {
> +	case '@':
> +		/* skip this region, usable */
> +		*start = 0;
> +		*size = 0;
> +		return 0;
How about direclty return if nn@ss? Seems no need to waste one mem avoid
region slot. In fact even amount of usable memory regions are provided to
100, it won't impact that you want to specify a reserve memmap region if
you skip it direclty. Personal opinion.
> +	case '#':
> +	case '$':
> +	case '!':
> +		*start = _memparse(p + 1, &p);
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int mem_avoid_memmap(void)
> +{
> +	char arg[128];
> +	int rc = 0;
> +
> +	/* see if we have any memmap areas */
> +	if (cmdline_find_option("memmap", arg, sizeof(arg)) > 0) {
> +		int i = 0;
> +		char *str = arg;
> +
> +		while (str && (i < MAX_MEMMAP_REGIONS)) {
> +			unsigned long long start, size;
> +			char *k = strchr(str, ',');
> +
> +			if (k)
> +				*k++ = 0;
> +
> +			rc = parse_memmap(str, &start, &size);
> +			if (rc < 0)
> +				break;
> +			str = k;
> +			/* a usable region that should not be skipped */
> +			if (size == 0)
> +				continue;
> +
> +			mem_avoid[MEM_AVOID_MEMMAP1 + i].start = start;
> +			mem_avoid[MEM_AVOID_MEMMAP1 + i].size = size;
> +			i++;
> +		}
> +
> +		/* more than 4 memmaps, fail kaslr */
> +		if ((i >= MAX_MEMMAP_REGIONS) && str)
> +			rc = -EINVAL;
> +	}
> +
> +	return rc;
> +}
> +
>  /*
>   * In theory, KASLR can put the kernel anywhere in the range of [16M, 64T).
>   * The mem_avoid array is used to store the ranges that need to be avoided
> @@ -429,6 +552,7 @@ void choose_random_location(unsigned long input,
>  			    unsigned long *virt_addr)
>  {
>  	unsigned long random_addr, min_addr;
> +	int rc;
>  
>  	/* By default, keep output position unchanged. */
>  	*virt_addr = *output;
> @@ -438,6 +562,13 @@ void choose_random_location(unsigned long input,
>  		return;
>  	}
>  
> +	/* Mark the memmap regions we need to avoid */
> +	rc = mem_avoid_memmap();
> +	if (rc < 0) {
Or write it like below, the rc is not needed. Personal coding style,
just talk about it.
	if (mem_avoid_memmap()) {
		warn("KASLR disabled: memmap exceeds limit of 4, giving up.");
		return;
	}
> +
>  	boot_params->hdr.loadflags |= KASLR_FLAG;
>  
>  	/* Prepare to add new identity pagetables on demand. */
> diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
> index cc3bd58..0464aaa 100644
> --- a/arch/x86/boot/string.c
> +++ b/arch/x86/boot/string.c
> @@ -122,6 +122,31 @@ unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int bas
>  }
>  
>  /**
> + * simple_strtoul - convert a string to an unsigned long
> + * @cp: The start of the string
> + * @endp: A pointer to the end of the parsed string will be placed here
> + * @base: The number base to use
> + */
> +unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
> +{
> +	return simple_strtoull(cp, endp, base);
> +}
> +
> +/**
> + * simple_strtol - convert a string to a signed long
> + * @cp: The start of the string
> + * @endp: A pointer to the end of the parsed string will be placed here
> + * @base: The number base to use
> + */
> +long simple_strtol(const char *cp, char **endp, unsigned int base)
> +{
> +	if (*cp == '-')
> +		return -simple_strtoul(cp + 1, endp, base);
> +
> +	return simple_strtoul(cp, endp, base);
> +}
> +
> +/**
>   * strlen - Find the length of a string
>   * @s: The string to be sized
>   */
> @@ -155,3 +180,16 @@ char *strstr(const char *s1, const char *s2)
>  	}
>  	return NULL;
>  }
> +
> +/**
> + * strchr - Find the first occurrence of the character c in the string s.
> + * @s: the string to be searched
> + * @c: the character to search for
> + */
> +char *strchr(const char *s, int c)
> +{
> +	while (*s != (char)c)
> +		if (*s++ == '\0')
> +			return NULL;
> +	return (char *)s;
> +}
> 
