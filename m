Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1DB0581EFA
 for <linux-nvdimm@lists.01.org>; Fri, 10 Feb 2017 11:22:50 -0800 (PST)
References: <1486754370-3057-1-git-send-email-logang@deltatee.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <d88a26ff-7575-f53f-2de1-74b397914247@deltatee.com>
Date: Fri, 10 Feb 2017 12:22:48 -0700
MIME-Version: 1.0
In-Reply-To: <1486754370-3057-1-git-send-email-logang@deltatee.com>
Subject: Re: [PATCH] device-dax: don't set kobj parent during cdev init
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
To: Dan Williams <dan.j.williams@intel.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hey,

Also on the subject of very minor fixes: I noticed drivers/dax is not in
the maintainers file. I just assumed the nvdimm list should have been
included with those from get_maintainers.

Thanks,

Logan

On 10/02/17 12:19 PM, Logan Gunthorpe wrote:
> I copied this code and per feedback from Greg Kroah-Hartman [1] the
> cdev's kobject's parent should not be set to the related device.
> This should have minor consequences but isn't doing what anyone
> expects it to.
> 
> This patch then fixes device-dax so it doesn't make the same mistake.
> 
> [1] https://lkml.org/lkml/2017/2/10/370
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  drivers/dax/dax.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
> index ed758b7..24e53b7 100644
> --- a/drivers/dax/dax.c
> +++ b/drivers/dax/dax.c
> @@ -699,13 +699,9 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
>  		goto err_inode;
>  	}
>  
> -	/* device_initialize() so cdev can reference kobj parent */
> -	device_initialize(dev);
> -
>  	cdev = &dax_dev->cdev;
>  	cdev_init(cdev, &dax_fops);
>  	cdev->owner = parent->driver->owner;
> -	cdev->kobj.parent = &dev->kobj;
>  	rc = cdev_add(&dax_dev->cdev, dev_t, 1);
>  	if (rc)
>  		goto err_cdev;
> @@ -722,7 +718,7 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
>  	dev->groups = dax_attribute_groups;
>  	dev->release = dax_dev_release;
>  	dev_set_name(dev, "dax%d.%d", dax_region->id, dax_dev->id);
> -	rc = device_add(dev);
> +	rc = device_register(dev);
>  	if (rc) {
>  		put_device(dev);
>  		return ERR_PTR(rc);
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
