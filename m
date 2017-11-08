Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 48F4620355214
 for <linux-nvdimm@lists.01.org>; Wed,  8 Nov 2017 01:55:10 -0800 (PST)
Date: Wed, 8 Nov 2017 01:59:09 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vmalloc: introduce vmap_pfn for persistent memory
Message-ID: <20171108095909.GA7390@infradead.org>
References: <alpine.LRH.2.02.1711071645240.1339@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1711071645240.1339@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, dm-devel@redhat.com, Laura Abbott <labbott@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 07, 2017 at 05:03:11PM -0500, Mikulas Patocka wrote:
> Hi
> 
> I am developing a driver that uses persistent memory for caching. A 
> persistent memory device can be mapped in several discontiguous ranges.
> 
> The kernel has a function vmap that takes an array of pointers to pages 
> and maps these pages to contiguous linear address space. However, it can't 
> be used on persistent memory because persistent memory may not be backed 
> by page structures.
> 
> This patch introduces a new function vmap_pfn, it works like vmap, but 
> takes an array of pfn_t - so it can be used on persistent memory.

How is cache flushing going to work for this interface assuming
that your write to/from the virtual address and expect it to be
persisted on pmem?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
