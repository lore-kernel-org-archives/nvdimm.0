Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <1410467739.2759.1.camel@rzwisler-mobl1.amr.corp.intel.com>
Subject: Re: [PATCH 3/9] SQUASHME: pmem: Let each device manage private
 memory region
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Thu, 11 Sep 2014 14:35:39 -0600
In-Reply-To: <540F2008.9050809@plexistor.com>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
	 <540F1EC6.4000504@plexistor.com> <540F2008.9050809@plexistor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2014-09-09 at 18:43 +0300, Boaz Harrosh wrote:
> From: Boaz Harrosh <boaz@plexistor.com>
> 
> This patch removes any global memory information. And lets
> each pmem-device manage it's own memory region.
> 
> pmem_alloc() Now receives phys_addr and disk_size and will
> map that region, also pmem_free will do the unmaping.
> 
> This is so we can support multiple discontinuous memory regions
> in the next patch
> 
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
> ---
>  drivers/block/pmem.c | 122 +++++++++++++++++++++++++++++++--------------------
>  1 file changed, 75 insertions(+), 47 deletions(-)
<>
> @@ -234,26 +227,70 @@ MODULE_PARM_DESC(pmem_count, "Number of pmem devices to evenly split allocated s
>  static LIST_HEAD(pmem_devices);
>  static int pmem_major;
>  
> -/* FIXME: move phys_addr, virt_addr, size calls up to caller */
> -static struct pmem_device *pmem_alloc(int i)
> +/* pmem->phys_addr and pmem->size need to be set.
> + * Will then set virt_addr if successful.
> + */
> +int pmem_mapmem(struct pmem_device *pmem)

Maybe just pmem_map() and pmem_unmap() for simplicity?

Looks good.  You can add:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

I'll pull it into the tree at https://github.com/01org/prd


