From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5] x86: fix kaslr and memmap collision
Date: Sat, 7 Jan 2017 18:48:49 +0800
Message-ID: <20170107104849.GI6937@x1>
References: <148355454697.187917.6504466419095085911.stgit@djiang5-desk3.ch.intel.com>
 <20170105092131.GD15788@x1> <20170106024439.GE15788@x1>
 <CAGXu5jJbOQZfmydoWLXeNc3ZKgZkgO9003PzdKi85JfkZJcYGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jJbOQZfmydoWLXeNc3ZKgZkgO9003PzdKi85JfkZJcYGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On 01/06/17 at 01:16pm, Kees Cook wrote:
> On Thu, Jan 5, 2017 at 6:44 PM, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >> > +static int mem_avoid_memmap(void)
> >> > +{
> >> > +   char arg[128];
> >> > +   int rc = 0;
> >> > +
> >> > +   /* see if we have any memmap areas */
> >> > +   if (cmdline_find_option("memmap", arg, sizeof(arg)) > 0) {
> >> > +           int i = 0;
> >> > +           char *str = arg;
> >> > +
> >> > +           while (str && (i < MAX_MEMMAP_REGIONS)) {
> >> > +                   unsigned long long start, size;
> >> > +                   char *k = strchr(str, ',');
> >> > +
> >> > +                   if (k)
> >> > +                           *k++ = 0;
> >> > +
> >> > +                   rc = parse_memmap(str, &start, &size);
> >> > +                   if (rc < 0)
> >> > +                           break;
> >> > +                   str = k;
> >> > +                   /* a usable region that should not be skipped */
> >> > +                   if (size == 0)
> >> > +                           continue;
> >> > +
> >> > +                   mem_avoid[MEM_AVOID_MEMMAP_BEGIN + i].start = start;
> >> > +                   mem_avoid[MEM_AVOID_MEMMAP_BEGIN + i].size = size;
> >> > +                   i++;
> >> > +           }
> >> > +
> >> > +           /* more than 4 memmaps, fail kaslr */
> >> > +           if ((i >= MAX_MEMMAP_REGIONS) && str)
> >> > +                   rc = -EINVAL;
> >> > +   }
> >> > +
> >> > +   return rc;
> >> > +}
> >> > +
> >> >  /*
> >> >   * In theory, KASLR can put the kernel anywhere in the range of [16M, 64T).
> >> >   * The mem_avoid array is used to store the ranges that need to be avoided
> >> > @@ -438,6 +559,12 @@ void choose_random_location(unsigned long input,
> >> >             return;
> >> >     }
> >> >
> >> > +   /* Mark the memmap regions we need to avoid */
> >> > +   if (mem_avoid_memmap()) {
> >> > +           warn("KASLR disabled: memmap exceeds limit of 4, giving up.");
> >> > +           return;
> >> > +   }
> >>
> >> theoretically, mem_avoid_memmap is doing the mem_avoid initialization
> >> job, should be called inside mem_avoid_init(). The reason you put it
> >> here is you want to make it cancel kaslr, both physical and virtual
> >> address randomization, right?
> >>
> >> In choose_random_location(), the physical and virtual random are done
> >> separately. You can see that later when find_random_phys_addr failed to
> >> find a suitable random slot, it just prints a warning, virtual
> >> randomization is still be done with calling find_random_virt_addr().
> >> Avoiding memmap reserved region should be physical ram issue, should we
> >> stop the kernel virtual address randomization either?
> >>
> >> Kees, what do you think about this?
> 
> Yeah, good catch. mem_avoid_memmap() should be called from
> mem_avoid_init(). I think likely the cleanest approach to dealing with
> the >4 case would be to set a global flag, similar to slot_area_index,
> that is checked in find_random_phys_addr().
> 
> Maybe something like:
> 
> static bool memmap_too_large;

Yes, this is better.

> 
> static int mem_avoid_memmap(void)
> {
> ...
>            /* more than 4 memmaps, fail kaslr */
>            if ((i >= MAX_MEMMAP_REGIONS) && str) {
>                    memmap_too_large = true;
>                    rc = -EINVAL;
>            }
> ...
> }
> ...
> static unsigned long find_random_phys_addr(unsigned long minimum,
>                                            unsigned long image_size)
> {
>         int i;
>         unsigned long addr;
> 
>         /* Check if we had too many memmaps. */
>         if (memmap_too_large) {
>             debug_putstr("Aborted e820 scan (more than 4 memmap=
> arguments)!\n");
>             return 0;
>         }
> 
>         /* Make sure minimum is aligned. */
>         minimum = ALIGN(minimum, CONFIG_PHYSICAL_ALIGN);
> ...
> 
> 
> And we should likely adjust this warning:
> 
>         if (!random_addr) {
>                 warn("KASLR disabled: could not find suitable E820 region!");
> 
> to something like:
> 
>         if (!random_addr) {
>                 warn("Physical KASLR disabled: no suitable memory region!");
> 
> 
> -Kees
> 
> >>
> >> > +
> >> >     boot_params->hdr.loadflags |= KASLR_FLAG;
> >> >
> >> >     /* Prepare to add new identity pagetables on demand. */
