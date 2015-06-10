Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 10 Jun 2015 17:11:00 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 2/9] x86: support kmap_atomic_pfn_t() for persistent
	memory
Message-ID: <20150610151100.GA12757@lst.de>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com> <20150605211912.20751.35406.stgit@dwillia2-desk3.amr.corp.intel.com> <20150610121202.GA9190@lst.de> <20150610150334.GK2729@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150610150334.GK2729@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, linux-arch@vger.kernel.org, arnd@arndb.de, ross.zwisler@linux.intel.com, linux-nvdimm@lists.01.org, benh@kernel.crashing.org, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, tj@kernel.org, paulus@samba.org, hpa@zytor.com, schwidefsky@de.ibm.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 10, 2015 at 11:03:35AM -0400, Matthew Wilcox wrote:
> On Wed, Jun 10, 2015 at 02:12:02PM +0200, Christoph Hellwig wrote:
> > Btw, I don't think this actually is safe without refcounting your kmap
> > structure.
> > 
> > The driver model ->remove callback can be called at any time, which
> > will ioremap the memory and remap the kmap structure.  But at this
> > point a user might still be using it.
> 
> Won't the device data structures be pinned by the refcount on the bdev?

An open filesystem only keeps a reference on the request_queue.  The
underlying driver model ->remove method will still be called on
a surprise removal.
