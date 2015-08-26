Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 26 Aug 2015 14:46:49 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 9/9] devm_memremap_pages: protect against pmem
	device unbind
Message-ID: <20150826124649.GA8014@lst.de>
References: <20150826010220.8851.18077.stgit@dwillia2-desk3.amr.corp.intel.com> <20150826012813.8851.35482.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150826012813.8851.35482.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, boaz@plexistor.com, david@fromorbit.com, linux-kernel@vger.kernel.org, hch@lst.de, linux-mm@kvack.org, hpa@zytor.com, ross.zwisler@linux.intel.com, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 25, 2015 at 09:28:13PM -0400, Dan Williams wrote:
> Given that:
> 
> 1/ device ->remove() can not be failed
> 
> 2/ a pmem device may be unbound at any time
> 
> 3/ we do not know what other parts of the kernel are actively using a
>    'struct page' from devm_memremap_pages()
> 
> ...provide a facility for active usages of device memory to block pmem
> device unbind.  With a percpu_ref it should be feasible to take a
> reference on a per-I/O or other high frequency basis.

Without a caller of get_page_map this is just adding dead code.  I'd
suggest to group it in a series with that caller.

Also if the page_map gets exposed in a header the name is a bit too generic.
memremap_map maybe?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
