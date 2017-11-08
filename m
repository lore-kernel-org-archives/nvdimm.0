Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 8 Nov 2017 12:42:38 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] vmalloc: introduce vmap_pfn for persistent
 memory
In-Reply-To: <20171108153522.GB24548@infradead.org>
Message-ID: <alpine.LRH.2.02.1711081236570.1168@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1711071645240.1339@file01.intranet.prod.int.rdu2.redhat.com> <20171108095909.GA7390@infradead.org> <alpine.LRH.2.02.1711080725490.12294@file01.intranet.prod.int.rdu2.redhat.com> <20171108150447.GA10374@infradead.org>
 <alpine.LRH.2.02.1711081007570.8618@file01.intranet.prod.int.rdu2.redhat.com> <20171108153522.GB24548@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, dm-devel@redhat.com, Ross Zwisler <ross.zwisler@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Dan Williams <dan.j.williams@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>



On Wed, 8 Nov 2017, Christoph Hellwig wrote:

> On Wed, Nov 08, 2017 at 10:21:38AM -0500, Mikulas Patocka wrote:
> > > And what do you do for an architecture with virtuall indexed caches?
> > 
> > Persistent memory is not supported on such architectures - it is only 
> > supported on x86-64 and arm64.
> 
> For now.  But once support is added your driver will just corrupt data
> unless you have the right API in place.

If dax_flush were able to flush vmapped area, I don't see a problem with 
it.

You obviously can't access the same device simultaneously through vmapped 
area and direct mapping. But when the persistent memory driver is using 
the device, no one is expected to touch it anyway.

Mikulas

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
