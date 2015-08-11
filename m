Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 11 Aug 2015 14:51:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 06/10] libnvdimm, pmem: push call to ioremap_cache
	out of line
Message-ID: <20150811125130.GB3402@lst.de>
References: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com> <20150811033823.4987.83902.stgit@otcpl-bsw-rvp-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150811033823.4987.83902.stgit@otcpl-bsw-rvp-2.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, ross.zwisler@linux.intel.com, mcgrof@suse.com, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 10, 2015 at 11:38:23PM -0400, Dan Williams wrote:
> In preparation for deprecating ioremap_cache() push its usage into arch
> code where it deleted in a later globabl conversion of ioremap_cache()
> to arch_memremap().

I don't really see the point of this patch.  Two patches later
we'll get rid arch_memremap_pmem anyway.

I'd rather fold this and the next two patches into a single one,
and keep the new arch_memremap_pmem_flags as a inline in io.h.
