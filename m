Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 402132194EB7D
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 14:02:59 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id l7so5903072oil.11
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 14:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190421014429.31206-1-pasha.tatashin@soleen.com>
 <20190421014429.31206-3-pasha.tatashin@soleen.com>
 <4ad3c587-6ab8-1307-5a13-a3e73cf569a5@redhat.com>
In-Reply-To: <4ad3c587-6ab8-1307-5a13-a3e73cf569a5@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 24 Apr 2019 14:02:48 -0700
Message-ID: <CAPcyv4h3+hU=MmB=RCc5GZmjLW_ALoVg_C4Z7aw8NQ=1LzPKaw@mail.gmail.com>
Subject: Re: [v2 2/2] device-dax: "Hotremove" persistent memory that is used
 like normal RAM
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
To: David Hildenbrand <david@redhat.com>
Cc: Sasha Levin <sashal@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Huang, Ying  <ying.huang@intel.com>, Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 24, 2019 at 1:55 PM David Hildenbrand <david@redhat.com> wrote:
>
> On 21.04.19 03:44, Pavel Tatashin wrote:
> > It is now allowed to use persistent memory like a regular RAM, but
> > currently there is no way to remove this memory until machine is
> > rebooted.
> >
> > This work expands the functionality to also allows hotremoving
> > previously hotplugged persistent memory, and recover the device for use
> > for other purposes.
> >
> > To hotremove persistent memory, the management software must first
> > offline all memory blocks of dax region, and than unbind it from
> > device-dax/kmem driver. So, operations should look like this:
> >
> > echo offline > echo offline > /sys/devices/system/memory/memoryN/state
> > ...
> > echo dax0.0 > /sys/bus/dax/drivers/kmem/unbind
> >
> > Note: if unbind is done without offlining memory beforehand, it won't be
> > possible to do dax0.0 hotremove, and dax's memory is going to be part of
> > System RAM until reboot.
> >
> > Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  drivers/dax/dax-private.h |  2 +
> >  drivers/dax/kmem.c        | 91 +++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 89 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> > index a45612148ca0..999aaf3a29b3 100644
> > --- a/drivers/dax/dax-private.h
> > +++ b/drivers/dax/dax-private.h
> > @@ -53,6 +53,7 @@ struct dax_region {
> >   * @pgmap - pgmap for memmap setup / lifetime (driver owned)
> >   * @ref: pgmap reference count (driver owned)
> >   * @cmp: @ref final put completion (driver owned)
> > + * @dax_mem_res: physical address range of hotadded DAX memory
> >   */
> >  struct dev_dax {
> >       struct dax_region *region;
> > @@ -62,6 +63,7 @@ struct dev_dax {
> >       struct dev_pagemap pgmap;
> >       struct percpu_ref ref;
> >       struct completion cmp;
> > +     struct resource *dax_kmem_res;
> >  };
> >
> >  static inline struct dev_dax *to_dev_dax(struct device *dev)
> > diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> > index 4c0131857133..d4896b281036 100644
> > --- a/drivers/dax/kmem.c
> > +++ b/drivers/dax/kmem.c
> > @@ -71,21 +71,104 @@ int dev_dax_kmem_probe(struct device *dev)
> >               kfree(new_res);
> >               return rc;
> >       }
> > +     dev_dax->dax_kmem_res = new_res;
> >
> >       return 0;
> >  }
> >
> > +#ifdef CONFIG_MEMORY_HOTREMOVE
> > +/*
> > + * Check that device-dax's memory_blocks are offline. If a memory_block is not
> > + * offline a warning is printed and an error is returned. dax hotremove can
> > + * succeed only when every memory_block is offlined beforehand.
> > + */
> > +static int
> > +offline_memblock_cb(struct memory_block *mem, void *arg)
>
> Function name suggests that you are actually trying to offline memory
> here. Maybe check_memblocks_offline_cb(), just like we have in
> mm/memory_hotplug.c.
>
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
> > +             unsigned long spfn = section_nr_to_pfn(mem->start_section_nr);
> > +             unsigned long epfn = section_nr_to_pfn(mem->end_section_nr);
> > +             phys_addr_t spa = spfn << PAGE_SHIFT;
> > +             phys_addr_t epa = epfn << PAGE_SHIFT;
> > +
> > +             dev_warn(dev, "memory block [%pa-%pa] is not offline\n",
> > +                      &spa, &epa);
> > +
> > +             return -EBUSY;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
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
> > +
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
> > +     rc = walk_memory_range(start_pfn, end_pfn, dev, offline_memblock_cb);
> > +     unlock_device_hotplug();
> > +
> > +     /*
> > +      * If admin has not offlined memory beforehand, we cannot hotremove dax.
> > +      * Unfortunately, because unbind will still succeed there is no way for
> > +      * user to hotremove dax after this.
> > +      */
> > +     if (rc)
> > +             return rc;
>
> Can't it happen that there is a race between you checking if memory is
> offline and an admin onlining memory again? maybe pull the
> remove_memory() into the locked region, using __remove_memory() instead.

I think the race is ok. The admin gets to keep the pieces of allowing
racing updates to the state and the kernel will keep the range active
until the next reboot.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
