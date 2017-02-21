Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.free-electrons.com (mail.free-electrons.com [62.4.15.54])
 by ml01.01.org (Postfix) with ESMTP id 32C17821CC
 for <linux-nvdimm@lists.01.org>; Tue, 21 Feb 2017 03:37:17 -0800 (PST)
Date: Tue, 21 Feb 2017 12:37:04 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH 02/14] device-dax: utilize new device_add_cdev helper
 function
Message-ID: <20170221113704.ibwkk2vuc5imkmae@piout.net>
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
 <1487653253-11497-3-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1487653253-11497-3-git-send-email-logang@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jan Kara <jack@suse.cz>, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Alexandre Bounine <alexandre.bounine@idt.com>, linux-mtd@lists.infradead.org, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, linux-scsi@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>, Parav Pandit <pandit.parav@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Alexandre Courbot <gnurou@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, rtc-linux@googlegroups.com, Leon Romanovsky <leon@kernel.org>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Richard Weinberger <richard@nod.at>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Marek Vasut <marek.vasut@gmail.com>, Doug Ledford <dledford@redhat.com>, tpmdd-devel@lists.sourceforge.net, Hans Verkuil <hans.verkuil@cisco.com>, Matt Porter <mporter@kernel.crashing.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-media@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Arnd Bergmann <arnd@arndb.de>, Boris Brezillon <boris.brezillon@free-electrons.com>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, linux-input@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Vladimir Zapolskiy <vz@mleia.com>, Joe Perches <joe@perches.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Benny Halevy <bhalevy@primarydata.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Haggai Eran <haggaie@mellanox.com>, Lorenzo Stoakes <lstoakes@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Artem Bityutskiy <dedekind1@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-gpio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org, Stephen Bates <stephen.bates@microsemi.com>, Hartmut Knaack <knaack.h@gmx.de>, Olof Johansson <olof@lixom.net>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Brian Norris <computersforpeace@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Jonathan Cameron <jic23@kernel.org>, osd-dev@open-osd.org
List-ID: <linux-nvdimm@lists.01.org>

Hi,

A small comment, you must always have a commit message. Even if it is
small.

On 20/02/2017 at 22:00:41 -0700, Logan Gunthorpe wrote:
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  drivers/dax/dax.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
> index ed758b7..0d24822 100644
> --- a/drivers/dax/dax.c
> +++ b/drivers/dax/dax.c
> @@ -701,12 +701,12 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
>  
>  	/* device_initialize() so cdev can reference kobj parent */
>  	device_initialize(dev);
> +	dev->devt = dev_t;
>  
>  	cdev = &dax_dev->cdev;
>  	cdev_init(cdev, &dax_fops);
>  	cdev->owner = parent->driver->owner;
> -	cdev->kobj.parent = &dev->kobj;
> -	rc = cdev_add(&dax_dev->cdev, dev_t, 1);
> +	rc = device_add_cdev(dev, cdev);
>  	if (rc)
>  		goto err_cdev;
>  
> @@ -716,7 +716,6 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
>  	dax_dev->region = dax_region;
>  	kref_get(&dax_region->kref);
>  
> -	dev->devt = dev_t;
>  	dev->class = dax_class;
>  	dev->parent = parent;
>  	dev->groups = dax_attribute_groups;
> -- 
> 2.1.4
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
