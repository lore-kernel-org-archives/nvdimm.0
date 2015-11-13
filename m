Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <1447436538.21443.95.camel@hpe.com>
Subject: Re: [PATCH v2] libnvdimm, e820: fix numa node for e820-type-12 pmem
 ranges
From: Toshi Kani <toshi.kani@hpe.com>
Date: Fri, 13 Nov 2015 10:42:18 -0700
In-Reply-To: <CAPcyv4iAHMA8g9dC2C5f6iqfkjGfM2vf5SSXNbfk1uUTwhRiYg@mail.gmail.com>
References: <20151112175215.2462.69420.stgit@dwillia2-desk3.jf.intel.com>
	 <1447433307.21443.90.camel@hpe.com>
	 <CAPcyv4iAHMA8g9dC2C5f6iqfkjGfM2vf5SSXNbfk1uUTwhRiYg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2015-11-13 at 09:00 -0800, Dan Williams wrote:
> On Fri, Nov 13, 2015 at 8:48 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> > On Thu, 2015-11-12 at 09:53 -0800, Dan Williams wrote:
> > > Rather than punt on the numa node for these e820 ranges try to find a
> > > better answer with memory_add_physaddr_to_nid() when it is available.
> > > 
 :
> > > +#ifdef CONFIG_MEMORY_HOTPLUG
> > > +static int e820_range_to_nid(resource_size_t addr)
> > > +{
> > > +     return memory_add_physaddr_to_nid(addr);
> > > +}
> > > +#else
> > > +static int e820_range_to_nid(resource_size_t addr)
> > > +{
> > > +     return NUMA_NO_NODE;
> > > +}
> > > +#endif
> > 
> > "linux/memory_hotplug.h" defines as follows.
> > 
> > #ifdef CONFIG_NUMA
> > extern int memory_add_physaddr_to_nid(u64 start);
> > #else
> > static inline int memory_add_physaddr_to_nid(u64 start)
> > {
> >         return 0;
> > }
> > #endif
> > 
> > So, memory_add_physaddr_to_nid() should be defined with #ifdef CONFIG_NUMA.
> > 
> > #ifdef CONFIG_MEMORY_HOTPLUG
> > int memory_add_physaddr_to_nid(u64 start)
> > {
> > 
> 
> I thought so too, but 0day reported this:
> 
> https://lists.01.org/pipermail/kbuild-all/2015-November/014618.html

Oh, I see.  "memory_hotplug.h" has #ifdef CONFIG_MEMORY_HOTPLUG before the
 memory_add_physaddr_to_nid() prototype definition...

Thanks,
-Toshi

 


