Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 957CD2035521A
 for <linux-nvdimm@lists.01.org>; Wed,  8 Nov 2017 04:29:16 -0800 (PST)
Date: Wed, 8 Nov 2017 07:33:09 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] vmalloc: introduce vmap_pfn for persistent memory
In-Reply-To: <20171108095909.GA7390@infradead.org>
Message-ID: <alpine.LRH.2.02.1711080725490.12294@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1711071645240.1339@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108095909.GA7390@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, dm-devel@redhat.com, Laura Abbott <labbott@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>



On Wed, 8 Nov 2017, Christoph Hellwig wrote:

> On Tue, Nov 07, 2017 at 05:03:11PM -0500, Mikulas Patocka wrote:
> > Hi
> > 
> > I am developing a driver that uses persistent memory for caching. A 
> > persistent memory device can be mapped in several discontiguous ranges.
> > 
> > The kernel has a function vmap that takes an array of pointers to pages 
> > and maps these pages to contiguous linear address space. However, it can't 
> > be used on persistent memory because persistent memory may not be backed 
> > by page structures.
> > 
> > This patch introduces a new function vmap_pfn, it works like vmap, but 
> > takes an array of pfn_t - so it can be used on persistent memory.
> 
> How is cache flushing going to work for this interface assuming
> that your write to/from the virtual address and expect it to be
> persisted on pmem?

We could use the function clwb() (or arch-independent wrapper dax_flush()) 
- that uses the clflushopt instruction on Broadwell or clwb on Skylake - 
but it is very slow, write performance on Broadwell is only 350MB/s.

So in practice I use the movnti instruction that bypasses cache. The 
write-combining buffer is flushed with sfence.

Mikulas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
