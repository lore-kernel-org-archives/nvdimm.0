Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x229.google.com (mail-wm0-x229.google.com
 [IPv6:2a00:1450:400c:c09::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 05DE61A1F46
 for <linux-nvdimm@lists.01.org>; Sun, 20 Mar 2016 03:24:36 -0700 (PDT)
Received: by mail-wm0-x229.google.com with SMTP id r129so17429525wmr.1
 for <linux-nvdimm@lists.01.org>; Sun, 20 Mar 2016 03:24:13 -0700 (PDT)
Message-ID: <56EE7A49.7090904@plexistor.com>
Date: Sun, 20 Mar 2016 12:24:09 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH] pmem: don't allocate unused major device number
References: <87k2lclif1.fsf@notabene.neil.brown.name>
In-Reply-To: <87k2lclif1.fsf@notabene.neil.brown.name>
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
To: NeilBrown <neilb@suse.com>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 03/09/2016 12:21 AM, NeilBrown wrote:
> 
> When alloc_disk(0) or alloc_disk-node(0, XX) is used, the ->major
> number is completely ignored:  all devices are allocated with a
> major of BLOCK_EXT_MAJOR.
> 
> So there is no point allocating pmem_major.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>

Tested-by: Boaz Harrosh <boaz@plexistor.com>

Yes I sent in the same exact patch several times. This is not the
only driver that has this "wasted code" BTW.

I hope it will be finally removed. Thanks Neil
Boaz

> ---
>  drivers/nvdimm/pmem.c | 19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)
> 
> Hi Dan et al,
>  I was recently educating myself about the behavior of alloc_disk(0).
>  As I understand it, the ->major is ignored and all device numbers for all
>  partitions (including '0') are allocated on demand with major number of
>  BLOCK_EXT_MAJOR.
> 
>  So I was a little surprised to find that pmem.c allocated a major
>  number which is never used - historical anomaly I suspect.
>  I was a bit more surprised at the comment in:
> 
>   Commit: 9f53f9fa4ad1 ("libnvdimm, pmem: add libnvdimm support to the pmem driver")
> 
>  "The minor numbers are also more predictable by passing 0 to alloc_disk()."
> 
>  How can they possibly be more predictable given that they are allocated
>  on-demand?  Maybe discovery order is very predictable???
> 
>  In any case, I propose this patch but cannot test it (beyond compiling)
>  as I don't have relevant hardware.  And maybe some user-space code greps
>  /proc/devices for "pmem" to determine if "pmem" is compiled in (though
>  I sincerely hope not).
>  So I cannot be certain that this patch won't break anything, but am
>  hoping that if you like it you might test it.
> 
>  If it does prove acceptable, then similar changes would be appropriate
>  for btt.c and blk.c.   And drivers/memstick/core/ms_block.c and
>  drivers/nvme/host/core.c. (gotta stamp out this cargo cult)
> 
>  drivers/lightnvm/core.c is the only driver which uses alloc_disk(0) and
>  doesn't provide a 'major' number. :-(
> 
> Thanks,
> NeilBrown
> 
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 8d0b54670184..ec7e9e6a768e 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -47,8 +47,6 @@ struct pmem_device {
>  	struct badblocks	bb;
>  };
>  
> -static int pmem_major;
> -
>  static bool is_bad_pmem(struct badblocks *bb, sector_t sector, unsigned int len)
>  {
>  	if (bb->count) {
> @@ -228,8 +226,6 @@ static int pmem_attach_disk(struct device *dev,
>  		return -ENOMEM;
>  	}
>  
> -	disk->major		= pmem_major;
> -	disk->first_minor	= 0;
>  	disk->fops		= &pmem_fops;
>  	disk->private_data	= pmem;
>  	disk->queue		= pmem->pmem_queue;
> @@ -502,26 +498,13 @@ static struct nd_device_driver nd_pmem_driver = {
>  
>  static int __init pmem_init(void)
>  {
> -	int error;
> -
> -	pmem_major = register_blkdev(0, "pmem");
> -	if (pmem_major < 0)
> -		return pmem_major;
> -
> -	error = nd_driver_register(&nd_pmem_driver);
> -	if (error) {
> -		unregister_blkdev(pmem_major, "pmem");
> -		return error;
> -	}
> -
> -	return 0;
> +	return nd_driver_register(&nd_pmem_driver);
>  }
>  module_init(pmem_init);
>  
>  static void pmem_exit(void)
>  {
>  	driver_unregister(&nd_pmem_driver.drv);
> -	unregister_blkdev(pmem_major, "pmem");
>  }
>  module_exit(pmem_exit);
>  
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
