Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E58A2202E5E5A
 for <linux-nvdimm@lists.01.org>; Wed,  8 Nov 2017 12:22:18 -0800 (PST)
Date: Wed, 8 Nov 2017 15:26:16 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] vmalloc: introduce vmap_pfn for persistent
 memory
In-Reply-To: <20171108174747.GA12199@infradead.org>
Message-ID: <alpine.LRH.2.02.1711081516010.29922@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1711071645240.1339@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108095909.GA7390@infradead.org>
 <alpine.LRH.2.02.1711080725490.12294@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108150447.GA10374@infradead.org>
 <alpine.LRH.2.02.1711081007570.8618@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108153522.GB24548@infradead.org>
 <alpine.LRH.2.02.1711081236570.1168@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108174747.GA12199@infradead.org>
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
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, dm-devel@redhat.com, Laura Abbott <labbott@redhat.com>, Christoph Hellwig <hch@lst.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>



On Wed, 8 Nov 2017, Christoph Hellwig wrote:

> Can you start by explaining what you actually need the vmap for?

It is possible to use lvm on persistent memory. You can create linear or 
striped logical volumes on persistent memory and these volumes still have 
the direct_access method, so they can be mapped with the function 
dax_direct_access().

If we create logical volumes on persistent memory, the method 
dax_direct_access() won't return the whole device, it will return only a 
part. When dax_direct_access() returns the whole device, my driver just 
uses it without vmap. When dax_direct_access() return only a part of the 
device, my driver calls it repeatedly to get all the parts and then 
assembles the parts into a linear address space with vmap.

See the function persistent_memory_claim() here: 
https://www.redhat.com/archives/dm-devel/2017-November/msg00026.html

> Going through a vmap for every I/O is certainly not going to be nice
> on NVDIMM-N or similar modules :)

It's just a call to vmalloc_to_page.

Though, if persistent memory is not page-backed, I have to copy the data 
before writing them.

Mikulas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
