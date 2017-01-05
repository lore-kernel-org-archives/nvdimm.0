From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] x86: fix kaslr and memmap collision
Date: Thu, 5 Jan 2017 09:00:35 +0800
Message-ID: <20170105010035.GC6937@x1>
References: <148347651968.64111.7765172823804130174.stgit@djiang5-desk3.ch.intel.com>
 <20170104023728.GC15788@x1>
 <f91679bd-f728-d3aa-e943-45fb42d2e20b@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f91679bd-f728-d3aa-e943-45fb42d2e20b-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On 01/04/17 at 10:06am, Dave Jiang wrote:
> On 01/03/2017 07:37 PM, Baoquan He wrote:
> >>  #include <generated/compile.h>
> >>  #include <linux/module.h>
> >> @@ -61,9 +62,16 @@ enum mem_avoid_index {
> >>  	MEM_AVOID_INITRD,
> >>  	MEM_AVOID_CMDLINE,
> >>  	MEM_AVOID_BOOTPARAMS,
> >> +	MEM_AVOID_MEMMAP1,
> >> +	MEM_AVOID_MEMMAP2,
> >> +	MEM_AVOID_MEMMAP3,
> >> +	MEM_AVOID_MEMMAP4,
> > 
> > This looks not good. Could it be done like fixed_addresses?
> > Something like:
> > 
> > 	MEM_AVOID_MEMMAP_BEGIN,
> > 	MEM_AVOID_MEMMAP_BEGIN + MEM_AVOID_MAX -1,
> > 
> > Please point it out to me if there's some existing code in kernel like
> > your way, I can also accept it.
> 
> I think you mean:
> MEM_AVOID_MEMMAP_BEGIN + MAX_MEMMAP_REGIONS - 1

Ah, yes. Sorry for this.

> 
> I will change
> 
> 
> > 
> >>  	MEM_AVOID_MAX,
> >>  };
> >>  
> >> +/* only supporting at most 4 memmap regions with kaslr */
> > And here, "Only supporting at most 4 un-usable memmap regions with kaslr"?
> > Surely this is based on if you will ignore the usable memory and do not
> > store it as 0. And also the log need be changed too accordingly.
> >> +#define MAX_MEMMAP_REGIONS	4
...
> >> +static int
> >> +parse_memmap(char *p, unsigned long long *start, unsigned long long *size)
> >> +{
> >> +	char *oldp;
> >> +
> >> +	if (!p)
> >> +		return -EINVAL;
> >> +
> >> +	/* we don't care about this option here */
> >> +	if (!strncmp(p, "exactmap", 8))
> >> +		return -EINVAL;
> >> +
> >> +	oldp = p;
> >> +	*size = _memparse(p, &p);
> >> +	if (p == oldp)
> >> +		return -EINVAL;
> >> +
> >> +	switch (*p) {
> >> +	case '@':
> >> +		/* skip this region, usable */
> >> +		*start = 0;
> >> +		*size = 0;
> >> +		return 0;
> > How about direclty return if nn@ss? Seems no need to waste one mem avoid
> > region slot. In fact even amount of usable memory regions are provided to
> > 100, it won't impact that you want to specify a reserve memmap region if
> > you skip it direclty. Personal opinion.
> 
> We are not wasting the slot. If you look mem_avoid_memmap() where I call
> the function, it will skip with a continue if size == 0 without
> incrementing the 'i' counter. That will skip all the nn@ss regions
> without counting against the max avoid mapping.

Yes, indeed. Sorry, I didn't read the code carefully.

Thanks
Baoquan
