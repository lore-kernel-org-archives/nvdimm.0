From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v5] x86: fix kaslr and memmap collision
Date: Fri, 6 Jan 2017 13:16:19 -0800
Message-ID: <CAGXu5jJbOQZfmydoWLXeNc3ZKgZkgO9003PzdKi85JfkZJcYGA@mail.gmail.com>
References: <148355454697.187917.6504466419095085911.stgit@djiang5-desk3.ch.intel.com>
 <20170105092131.GD15788@x1> <20170106024439.GE15788@x1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170106024439.GE15788@x1>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Thu, Jan 5, 2017 at 6:44 PM, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Add Kees to let him have a look at this too.
>
> On 01/05/17 at 05:21pm, Baoquan He wrote:
>> On 01/04/17 at 11:29am, Dave Jiang wrote:
>> > CONFIG_RANDOMIZE_BASE relocates the kernel to a random base address.
>> > However it does not take into account the memmap= parameter passed in from
>> > the kernel cmdline. This results in the kernel sometimes being put in
>> > the middle of memmap. Teaching kaslr to not insert the kernel in
>> > memmap defined regions. We will support up to 4 memmap regions. Any
>> > additional regions will cause kaslr to disable. The mem_avoid set has
>> > been augmented to add up to 4 unusable regions of memmaps provided by the
>> > user to exclude those regions from the set of valid address range to insert
>> > the uncompressed kernel image. The nn@ss ranges will be skipped by the
>> > mem_avoid set since it indicates memory useable.
>> >
>> > Signed-off-by: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > ---
>> >
>> > v2:
>> > Addressing comments from Ingo.
>> > - Handle entire list of memmaps
>> > v3:
>> > Fix 32bit build issue
>> > v4:
>> > Addressing comments from Baoquan
>> > - Not exclude nn@ss ranges
>> > v5:
>> > Addressing additional comments from Baoquan
>> > - Update commit header and various coding style changes
>> >
>> > diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
>> > index e5612f3..59c2075 100644
>> > --- a/arch/x86/boot/boot.h
>> > +++ b/arch/x86/boot/boot.h
>> > @@ -332,7 +332,10 @@ int strncmp(const char *cs, const char *ct, size_t count);
>> >  size_t strnlen(const char *s, size_t maxlen);
>> >  unsigned int atou(const char *s);
>> >  unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base);
>> > +unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base);
>> > +long simple_strtol(const char *cp, char **endp, unsigned int base);
>> >  size_t strlen(const char *s);
>> > +char *strchr(const char *s, int c);
>> >
>> >  /* tty.c */
>> >  void puts(const char *);
>> > diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
>> > index a66854d..036b514 100644
>> > --- a/arch/x86/boot/compressed/kaslr.c
>> > +++ b/arch/x86/boot/compressed/kaslr.c
>> > @@ -11,6 +11,7 @@
>> >   */
>> >  #include "misc.h"
>> >  #include "error.h"
>> > +#include "../boot.h"
>> >
>> >  #include <generated/compile.h>
>> >  #include <linux/module.h>
>> > @@ -56,11 +57,16 @@ struct mem_vector {
>> >     unsigned long size;
>> >  };
>> >
>> > +/* only supporting at most 4 unusable memmap regions with kaslr */
>> > +#define MAX_MEMMAP_REGIONS 4
>> > +
>> >  enum mem_avoid_index {
>> >     MEM_AVOID_ZO_RANGE = 0,
>> >     MEM_AVOID_INITRD,
>> >     MEM_AVOID_CMDLINE,
>> >     MEM_AVOID_BOOTPARAMS,
>> > +   MEM_AVOID_MEMMAP_BEGIN,
>> > +   MEM_AVOID_MEMMAP_END = MEM_AVOID_MEMMAP_BEGIN + MAX_MEMMAP_REGIONS - 1,
>> >     MEM_AVOID_MAX,
>> >  };
>> >
>> > @@ -77,6 +83,121 @@ static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
>> >     return true;
>> >  }
>> >
>> > +/**
>> > + * _memparse - parse a string with mem suffixes into a number
>> > + * @ptr: Where parse begins
>> > + * @retptr: (output) Optional pointer to next char after parse completes
>> > + *
>> > + * Parses a string into a number.  The number stored at @ptr is
>> > + * potentially suffixed with K, M, G, T, P, E.
>> > + */
>> > +static unsigned long long _memparse(const char *ptr, char **retptr)
>> > +{
>> > +   char *endptr;   /* local pointer to end of parsed string */
>> > +
>> > +   unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
>> > +
>> > +   switch (*endptr) {
>> > +   case 'E':
>> > +   case 'e':
>> > +           ret <<= 10;
>> > +   case 'P':
>> > +   case 'p':
>> > +           ret <<= 10;
>> > +   case 'T':
>> > +   case 't':
>> > +           ret <<= 10;
>> > +   case 'G':
>> > +   case 'g':
>> > +           ret <<= 10;
>> > +   case 'M':
>> > +   case 'm':
>> > +           ret <<= 10;
>> > +   case 'K':
>> > +   case 'k':
>> > +           ret <<= 10;
>> > +           endptr++;
>> > +   default:
>> > +           break;
>> > +   }
>> > +
>> > +   if (retptr)
>> > +           *retptr = endptr;
>> > +
>> > +   return ret;
>> > +}
>> > +
>> > +static int
>> > +parse_memmap(char *p, unsigned long long *start, unsigned long long *size)
>> > +{
>> > +   char *oldp;
>> > +
>> > +   if (!p)
>> > +           return -EINVAL;
>> > +
>> > +   /* we don't care about this option here */
>> > +   if (!strncmp(p, "exactmap", 8))
>> > +           return -EINVAL;
>> > +
>> > +   oldp = p;
>> > +   *size = _memparse(p, &p);
>> > +   if (p == oldp)
>> > +           return -EINVAL;
>> > +
>> > +   switch (*p) {
>> > +   case '@':
>> > +           /* skip this region, usable */
>> > +           *start = 0;
>> > +           *size = 0;
>> > +           return 0;
>> > +   case '#':
>> > +   case '$':
>> > +   case '!':
>> > +           *start = _memparse(p + 1, &p);
>> > +           return 0;
>> > +   }
>> > +
>> > +   return -EINVAL;
>> > +}
>> > +
>> > +static int mem_avoid_memmap(void)
>> > +{
>> > +   char arg[128];
>> > +   int rc = 0;
>> > +
>> > +   /* see if we have any memmap areas */
>> > +   if (cmdline_find_option("memmap", arg, sizeof(arg)) > 0) {
>> > +           int i = 0;
>> > +           char *str = arg;
>> > +
>> > +           while (str && (i < MAX_MEMMAP_REGIONS)) {
>> > +                   unsigned long long start, size;
>> > +                   char *k = strchr(str, ',');
>> > +
>> > +                   if (k)
>> > +                           *k++ = 0;
>> > +
>> > +                   rc = parse_memmap(str, &start, &size);
>> > +                   if (rc < 0)
>> > +                           break;
>> > +                   str = k;
>> > +                   /* a usable region that should not be skipped */
>> > +                   if (size == 0)
>> > +                           continue;
>> > +
>> > +                   mem_avoid[MEM_AVOID_MEMMAP_BEGIN + i].start = start;
>> > +                   mem_avoid[MEM_AVOID_MEMMAP_BEGIN + i].size = size;
>> > +                   i++;
>> > +           }
>> > +
>> > +           /* more than 4 memmaps, fail kaslr */
>> > +           if ((i >= MAX_MEMMAP_REGIONS) && str)
>> > +                   rc = -EINVAL;
>> > +   }
>> > +
>> > +   return rc;
>> > +}
>> > +
>> >  /*
>> >   * In theory, KASLR can put the kernel anywhere in the range of [16M, 64T).
>> >   * The mem_avoid array is used to store the ranges that need to be avoided
>> > @@ -438,6 +559,12 @@ void choose_random_location(unsigned long input,
>> >             return;
>> >     }
>> >
>> > +   /* Mark the memmap regions we need to avoid */
>> > +   if (mem_avoid_memmap()) {
>> > +           warn("KASLR disabled: memmap exceeds limit of 4, giving up.");
>> > +           return;
>> > +   }
>>
>> theoretically, mem_avoid_memmap is doing the mem_avoid initialization
>> job, should be called inside mem_avoid_init(). The reason you put it
>> here is you want to make it cancel kaslr, both physical and virtual
>> address randomization, right?
>>
>> In choose_random_location(), the physical and virtual random are done
>> separately. You can see that later when find_random_phys_addr failed to
>> find a suitable random slot, it just prints a warning, virtual
>> randomization is still be done with calling find_random_virt_addr().
>> Avoiding memmap reserved region should be physical ram issue, should we
>> stop the kernel virtual address randomization either?
>>
>> Kees, what do you think about this?

Yeah, good catch. mem_avoid_memmap() should be called from
mem_avoid_init(). I think likely the cleanest approach to dealing with
the >4 case would be to set a global flag, similar to slot_area_index,
that is checked in find_random_phys_addr().

Maybe something like:

static bool memmap_too_large;

static int mem_avoid_memmap(void)
{
...
           /* more than 4 memmaps, fail kaslr */
           if ((i >= MAX_MEMMAP_REGIONS) && str) {
                   memmap_too_large = true;
                   rc = -EINVAL;
           }
...
}
...
static unsigned long find_random_phys_addr(unsigned long minimum,
                                           unsigned long image_size)
{
        int i;
        unsigned long addr;

        /* Check if we had too many memmaps. */
        if (memmap_too_large) {
            debug_putstr("Aborted e820 scan (more than 4 memmap=
arguments)!\n");
            return 0;
        }

        /* Make sure minimum is aligned. */
        minimum = ALIGN(minimum, CONFIG_PHYSICAL_ALIGN);
...


And we should likely adjust this warning:

        if (!random_addr) {
                warn("KASLR disabled: could not find suitable E820 region!");

to something like:

        if (!random_addr) {
                warn("Physical KASLR disabled: no suitable memory region!");


-Kees

>>
>> > +
>> >     boot_params->hdr.loadflags |= KASLR_FLAG;
>> >
>> >     /* Prepare to add new identity pagetables on demand. */
>> > diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
>> > index cc3bd58..0464aaa 100644
>> > --- a/arch/x86/boot/string.c
>> > +++ b/arch/x86/boot/string.c
>> > @@ -122,6 +122,31 @@ unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int bas
>> >  }
>> >
>> >  /**
>> > + * simple_strtoul - convert a string to an unsigned long
>> > + * @cp: The start of the string
>> > + * @endp: A pointer to the end of the parsed string will be placed here
>> > + * @base: The number base to use
>> > + */
>> > +unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
>> > +{
>> > +   return simple_strtoull(cp, endp, base);
>> > +}
>> > +
>> > +/**
>> > + * simple_strtol - convert a string to a signed long
>> > + * @cp: The start of the string
>> > + * @endp: A pointer to the end of the parsed string will be placed here
>> > + * @base: The number base to use
>> > + */
>> > +long simple_strtol(const char *cp, char **endp, unsigned int base)
>> > +{
>> > +   if (*cp == '-')
>> > +           return -simple_strtoul(cp + 1, endp, base);
>> > +
>> > +   return simple_strtoul(cp, endp, base);
>> > +}
>> > +
>> > +/**
>> >   * strlen - Find the length of a string
>> >   * @s: The string to be sized
>> >   */
>> > @@ -155,3 +180,16 @@ char *strstr(const char *s1, const char *s2)
>> >     }
>> >     return NULL;
>> >  }
>> > +
>> > +/**
>> > + * strchr - Find the first occurrence of the character c in the string s.
>> > + * @s: the string to be searched
>> > + * @c: the character to search for
>> > + */
>> > +char *strchr(const char *s, int c)
>> > +{
>> > +   while (*s != (char)c)
>> > +           if (*s++ == '\0')
>> > +                   return NULL;
>> > +   return (char *)s;
>> > +}
>> >



-- 
Kees Cook
Nexus Security
