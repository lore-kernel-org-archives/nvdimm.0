Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4A4A021E74906
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 19:35:50 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id t75so11352741oie.3
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 19:38:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1708312138390.32309@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1708312138390.32309@file01.intranet.prod.int.rdu2.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 Aug 2017 19:38:32 -0700
Message-ID: <CAPcyv4j9KcgWU+rDY_5zAQ4xg3cx4Z3UkjTieVNMkWLc7C0OLg@mail.gmail.com>
Subject: Re: [PATCH] dax: remove the pmem_dax_ops->flush abstraction
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 31, 2017 at 6:47 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> The patch abebfbe2f731 ("dm: add ->flush() dax operation support") is
> buggy. A dm device may be composed of multiple underlying devices and all
> of them need to be flushed. The patch just routes the flush request to the
> first device and ignores the other devices.
>
> It could be fixed by adding more complex logic to the device mapper. But
> there is only one implementation of the method pmem_dax_ops->flush - that
> is pmem_dax_flush() - and it calls arch_wb_cache_pmem(). Consequently, we
> don't need the pmem_dax_ops->flush abstraction at all, we can call
> arch_wb_cache_pmem() directly from dax_flush() because dax_dev->ops->flush
> couldn't ever reach anything different from arch_wb_cache_pmem().

Unfortunately, this is not true, see usage of DAXDEV_WRITE_CACHE. This
is for platforms that arrange for cpu caches to be flushed on
power-fail, like standalone storage appliances, where it would be a
waste for the kernel to track and flush dirty cachelines for dax.
Theoretically this could be done on a per-address range basis (think
battery backing a subset of the system memory). I think we need to fix
the routing to flush the same dax_device that ->direct_access() was
invoked.


> It should be also pointed out that for some uses of persistent memory it
> is needed to flush only very small amount of data (such as 1 cacheline),
> and it would be overkill if we go through that device mapper machinery for
> a single flushed cache line.

I think this is more an argument to not enable DAX on that
device-mapper topology if operation routing impacts performance. DAX
is meant to get the kernel out of the way most of the time.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
