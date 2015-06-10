Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 10 Jun 2015 14:46:16 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v5 17/21] libnvdimm: infrastructure for btt devices
Message-ID: <20150610184616.GL2729@linux.intel.com>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150602001541.4506.90125.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150609064200.GE9804@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150609064200.GE9804@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 09, 2015 at 08:42:00AM +0200, Christoph Hellwig wrote:
> > The BTT driver is the initial first consumer of this mechanism to allow
> > layering atomic sector update guarantees on top of nd_io capable
> > libnvdimm-block-devices, or their partitions.
> 
> As mentioned during the last time of the review the layering here
> is complete broken.  If you expose additional capabilities from a block
> device do it at the block device level.  That is enhance the rw_page
> callback to allo byte sized access, add a capability flag on the queue,
> etc.

Don't screw up rw_page.  The point of rw_page is to read or write a page
cache page.  It can sleep, and it indicates success by using the page
flags.  Don't try and scqueeze rw_bytes into it.  If you want rw_bytes
to be a queue operation, that's one thing, but don't mess with rw_page.
