Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190425175440.9354-1-pasha.tatashin@soleen.com>
 <20190425175440.9354-3-pasha.tatashin@soleen.com> <77c286e3-8708-6e64-94a1-fb44b6bbff3f@intel.com>
In-Reply-To: <77c286e3-8708-6e64-94a1-fb44b6bbff3f@intel.com>
From: Pavel Tatashin <patatash@linux.microsoft.com>
Date: Thu, 25 Apr 2019 16:21:49 -0400
Message-ID: <CA+CK2bA=t2U51-Zoii1RWEDbXwvQ_ZALtJyQVZ392b8f7H+sew@mail.gmail.com>
Subject: Re: [v3 2/2] device-dax: "Hotremove" persistent memory that is used
 like normal RAM
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: James Morris <jmorris@namei.org>, Sasha Levin <sashal@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <zwisler@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Huang, Ying" <ying.huang@intel.com>, Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Takashi Iwai <tiwai@suse.de>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, David Hildenbrand <david@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 25, 2019 at 3:01 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> Hi Pavel,
>
> Thanks for doing this!  I knew we'd have to get to it eventually, but
> sounds like you needed it sooner rather than later.

Hi Dave,

Thank you for taking time reviewing this work, my comments below:

> >
> > +#ifdef CONFIG_MEMORY_HOTREMOVE
>
> Instead of this #ifdef, is there any downside to doing
>
>         if (!IS_ENABLED(CONFIG_MEMORY_HOTREMOVE)) {
>                 /*
>                  * Without hotremove, purposely leak ...
>                  */
>                 return 0;
>         }

Your method relies that compiler will optimize out all the code that
is not needed, and that dependencies such as __remove_memory() have
empty stubs. So, I prefer that way it is currently implemented.

>
>
> > +/*
> > + * Check that device-dax's memory_blocks are offline. If a memory_block is not
> > + * offline a warning is printed and an error is returned. dax hotremove can
> > + * succeed only when every memory_block is offlined beforehand.
> > + */
>
> I'd much rather see comments inline with the code than all piled at the
> top of a function like this.

OK

>
> One thing that would be helpful, though, is a reminder about needing the
> device hotplug lock.

OK

>
> > +static int
> > +check_memblock_offlined_cb(struct memory_block *mem, void *arg)
> > +{
> > +     struct device *mem_dev = &mem->dev;
> > +     bool is_offline;
> > +
> > +     device_lock(mem_dev);
> > +     is_offline = mem_dev->offline;
> > +     device_unlock(mem_dev);
> > +
> > +     if (!is_offline) {
> > +             struct device *dev = (struct device *)arg;
>
> The two devices confused me for a bit here.  Seems worth a comment to
> remind the reader what this device _is_ versus 'mem_dev'.

OK

>
> > +             unsigned long spfn = section_nr_to_pfn(mem->start_section_nr);
> > +             unsigned long epfn = section_nr_to_pfn(mem->end_section_nr);
> > +             phys_addr_t spa = spfn << PAGE_SHIFT;
> > +             phys_addr_t epa = epfn << PAGE_SHIFT;
> > +
> > +             dev_warn(dev, "memory block [%pa-%pa] is not offline\n",
> > +                      &spa, &epa);
>
> I thought we had a magic resource printk %something.  Could we just
> print one of the device resources here to save all the section/pfn/paddr
> calculations?

There is no resource for each memory block device, only for system
ram. Since here we inform admin about a particular memory block that
is not offlined, I do not see how to do it differently.

>
> Also, should we consider a slightly scarier message?  This path has a
> permanent, user-visible effect (we can never try to unbind again).

hm, how about:
dev_err(
"DAX region %pR cannot be hotremoved until next reboot because memory
block [%pa-%pa] is not offline"
)

>
> > +             return -EBUSY;
> > +     }
> > +
> > +     return 0;
> > +}
>
> Even though they're static, I'd prefer that we not create two versions
> of check_memblock_offlined_cb() in the kernel.  Can we give this a
> better, non-conflicting name?

how about check_devdax_mem_offlined_cb ?

>
> > +static int dev_dax_kmem_remove(struct device *dev)
> > +{
> > +     struct dev_dax *dev_dax = to_dev_dax(dev);
> > +     struct resource *res = dev_dax->dax_kmem_res;
> > +     resource_size_t kmem_start;
> > +     resource_size_t kmem_size;
> > +     unsigned long start_pfn;
> > +     unsigned long end_pfn;
> > +     int rc;
> > +
> > +     /*
> > +      * dax kmem resource does not exist, means memory was never hotplugged.
> > +      * So, nothing to do here.
> > +      */
> > +     if (!res)
> > +             return 0;
>
> How could that happen?  I can't think of any obvious scenarios.

Yes, I do not think this is possible. I can remove this check. Just
feels safer to have it though.

>
> > +     kmem_start = res->start;
> > +     kmem_size = resource_size(res);
> > +     start_pfn = kmem_start >> PAGE_SHIFT;
> > +     end_pfn = start_pfn + (kmem_size >> PAGE_SHIFT) - 1;
> > +
> > +     /*
> > +      * Walk and check that every singe memory_block of dax region is
> > +      * offline
> > +      */
> > +     lock_device_hotplug();
> > +     rc = walk_memory_range(start_pfn, end_pfn, dev,
> > +                            check_memblock_offlined_cb);
>
> Does lock_device_hotplug() also lock memory online/offline?  Otherwise,
> isn't this offline check racy?  If not, can you please spell that out in
> a comment?

Yes, it locks memory online/offline via sysfs: online_store(), as that
one also takes this lock lock_device_hotplug(). If someone else wants
to offline/online the memory they also need to take this lock.

>
> Also, could you compare this a bit to the walk_memory_range() use in
> __remove_memory()?  Why do we need two walks looking for offline blocks?

It is basically doing the same thing, but I do not really see a way
around this. Because __remove_memory() assumes that pages are
offlined, checks, and panics if they are not. Here, we do not panic,
but inform admin of consequences.

Thank you,
Pasha
