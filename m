Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 3 Nov 2015 12:15:23 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 04/15] libnvdimm, pmem: move request_queue allocation
 earlier in probe
Message-ID: <20151103191523.GC23366@linux.intel.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151102043004.6610.78684.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151102043004.6610.78684.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@fb.com, jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Nov 01, 2015 at 11:30:04PM -0500, Dan Williams wrote:
> Before the dynamically allocated struct pages from devm_memremap_pages()
> can be put to use outside the driver, we need a mechanism to track
> whether they are still in use at teardown.  Towards that goal reorder
> the initialization sequence to allow the 'q_usage_counter' from the
> request_queue to be used by the devm_memremap_pages() implementation (in
> subsequent patches).
> 
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
<>
> @@ -150,16 +151,23 @@ static struct pmem_device *pmem_alloc(struct device *dev,
>  		return ERR_PTR(-EBUSY);
>  	}
>  
> -	if (pmem_should_map_pages(dev))
> +	q = blk_alloc_queue_node(GFP_KERNEL, dev_to_node(dev));
> +	if (!q)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (pmem_should_map_pages(dev)) {

No need to introduce braces for this if().

Otherwise this looks fine.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
