Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 9 Jun 2015 08:58:54 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 9/9] x86: convert dma_map_ops to support mapping a
	__pfn_t.
Message-ID: <20150609065854.GD10167@lst.de>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com> <20150605211955.20751.15047.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150605211955.20751.15047.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, arnd@arndb.de, ross.zwisler@linux.intel.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, benh@kernel.crashing.org, linux-nvdimm@lists.01.org, heiko.carstens@de.ibm.com, hch@lst.de, tj@kernel.org, paulus@samba.org, hpa@zytor.com, schwidefsky@de.ibm.com, willy@linux.intel.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 05, 2015 at 05:19:55PM -0400, Dan Williams wrote:
> As long as a dma_map_sg() implementation avoids sg_page() conversions it
> can support scatterlists that carry "page-less" __pfn_t entries.
> However, a couple implementations require that __pfn_t_has_page() is
> always true. The Xen swiotlb implementation's entanglements with ARM and
> the Calgary MMUs requirement to have a pre-existing virtual mapping make
> them unable to support this conversion (i.e. these now have 'depends on
> !HAVE_DMA_PFN').

That's why we really need a whole kernel conversion and not just a piecemail
one.  Given how trivial this patch is that doesn't look like a too big
task ayway.
