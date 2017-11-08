Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 8 Nov 2017 07:04:47 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vmalloc: introduce vmap_pfn for persistent memory
Message-ID: <20171108150447.GA10374@infradead.org>
References: <alpine.LRH.2.02.1711071645240.1339@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108095909.GA7390@infradead.org>
 <alpine.LRH.2.02.1711080725490.12294@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1711080725490.12294@file01.intranet.prod.int.rdu2.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, dm-devel@redhat.com, Laura Abbott <labbott@redhat.com>, Christoph Hellwig <hch@lst.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 08, 2017 at 07:33:09AM -0500, Mikulas Patocka wrote:
> We could use the function clwb() (or arch-independent wrapper dax_flush()) 
> - that uses the clflushopt instruction on Broadwell or clwb on Skylake - 
> but it is very slow, write performance on Broadwell is only 350MB/s.
> 
> So in practice I use the movnti instruction that bypasses cache. The 
> write-combining buffer is flushed with sfence.

And what do you do for an architecture with virtuall indexed caches?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
