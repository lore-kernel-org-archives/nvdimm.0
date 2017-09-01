Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A843F21E74915
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 19:46:41 -0700 (PDT)
Date: Thu, 31 Aug 2017 22:49:19 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dax: remove the pmem_dax_ops->flush abstraction
In-Reply-To: <CAPcyv4j9KcgWU+rDY_5zAQ4xg3cx4Z3UkjTieVNMkWLc7C0OLg@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1708312242080.32309@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1708312138390.32309@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4j9KcgWU+rDY_5zAQ4xg3cx4Z3UkjTieVNMkWLc7C0OLg@mail.gmail.com>
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On Thu, 31 Aug 2017, Dan Williams wrote:

> On Thu, Aug 31, 2017 at 6:47 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > The patch abebfbe2f731 ("dm: add ->flush() dax operation support") is
> > buggy. A dm device may be composed of multiple underlying devices and all
> > of them need to be flushed. The patch just routes the flush request to the
> > first device and ignores the other devices.
> >
> > It could be fixed by adding more complex logic to the device mapper. But
> > there is only one implementation of the method pmem_dax_ops->flush - that
> > is pmem_dax_flush() - and it calls arch_wb_cache_pmem(). Consequently, we
> > don't need the pmem_dax_ops->flush abstraction at all, we can call
> > arch_wb_cache_pmem() directly from dax_flush() because dax_dev->ops->flush
> > couldn't ever reach anything different from arch_wb_cache_pmem().
> 
> Unfortunately, this is not true, see usage of DAXDEV_WRITE_CACHE. This
> is for platforms that arrange for cpu caches to be flushed on
> power-fail, like standalone storage appliances, where it would be a
> waste for the kernel to track and flush dirty cachelines for dax.
> Theoretically this could be done on a per-address range basis (think
> battery backing a subset of the system memory). I think we need to fix
> the routing to flush the same dax_device that ->direct_access() was
> invoked.

With my patch, dax_flush checks DAXDEV_WRITE_CACHE and doesn't do anything 
if it's not set - it just doesn't go through device mapper.

> > It should be also pointed out that for some uses of persistent memory it
> > is needed to flush only very small amount of data (such as 1 cacheline),
> > and it would be overkill if we go through that device mapper machinery for
> > a single flushed cache line.
> 
> I think this is more an argument to not enable DAX on that
> device-mapper topology if operation routing impacts performance. DAX
> is meant to get the kernel out of the way most of the time.

I don't understand what do you mean? I am writing a device mapper target 
that uses persistent memory as a cache. When flushing the metadata, 
sometimes it is needed to flush single cache lines. Ideally, I would use 
the clwb instruction for this purpose, but that clwb is hidden behind a 
complicated pmem_dax_ops->flush abstraction (and that abstraction will get 
even more complicated if implemented correctly). How do you think I should 
write that target without DAX?

Mikulas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
