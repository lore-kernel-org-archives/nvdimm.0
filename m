Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aer-iport-1.cisco.com (aer-iport-1.cisco.com [173.38.203.51])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BA6F381F5B
 for <linux-nvdimm@lists.01.org>; Mon, 27 Feb 2017 01:01:29 -0800 (PST)
Subject: Re: [PATCH v2 01/16] chardev: add helper function to register char
 devs with a struct device
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
 <1488091097-12328-2-git-send-email-logang@deltatee.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <c25a3d35-5570-ac9c-7b51-92dd6383f1f8@cisco.com>
Date: Mon, 27 Feb 2017 10:01:23 +0100
MIME-Version: 1.0
In-Reply-To: <1488091097-12328-2-git-send-email-logang@deltatee.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Logan Gunthorpe <logang@deltatee.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Linus Walleij <linus.walleij@linaro.org>, Alexandre Courbot <gnurou@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Olof Johansson <olof@lixom.net>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Haggai Eran <haggaie@mellanox.com>, Parav Pandit <pandit.parav@gmail.com>, Leon Romanovsky <leon@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, Hans Verkuil <hans.verkuil@cisco.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Artem Bityutskiy <dedekind1@gmail.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, Marek Vasut <marek.vasut@gmail.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alexandre.bounine@idt.com>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Lorenzo Stoakes <lstoakes@gmail.com>, Vladimir Zapolskiy <vz@mleia.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Boaz Harrosh <ooo@electrozaur.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Bates <stephen.bates@microsemi.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-scsi@vger.kernel.org, rtc-linux@googlegroups.com, linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-mtd@lists.infradead.org, linux-input@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 02/26/2017 07:38 AM, Logan Gunthorpe wrote:
> Credit for this patch goes is shared with Dan Williams [1]. I've
> taken things one step further to make the helper function more
> useful and clean up calling code.
>
> There's a common pattern in the kernel whereby a struct cdev is placed
> in a structure along side a struct device which manages the life-cycle
> of both. In the naive approach, the reference counting is broken and
> the struct device can free everything before the chardev code
> is entirely released.
>
> Many developers have solved this problem by linking the internal kobjs
> in this fashion:
>
> cdev.kobj.parent = &parent_dev.kobj;
>
> The cdev code explicitly gets and puts a reference to it's kobj parent.
> So this seems like it was intended to be used this way. Dmitrty Torokhov
> first put this in place in 2012 with this commit:
>
> 2f0157f char_dev: pin parent kobject
>
> and the first instance of the fix was then done in the input subsystem
> in the following commit:
>
> 4a215aa Input: fix use-after-free introduced with dynamic minor changes
>
> Subsequently over the years, however, this issue seems to have tripped
> up multiple developers independently. For example, see these commits:
>
> 0d5b7da iio: Prevent race between IIO chardev opening and IIO device
> (by Lars-Peter Clausen in 2013)
>
> ba0ef85 tpm: Fix initialization of the cdev
> (by Jason Gunthorpe in 2015)
>
> 5b28dde [media] media: fix use-after-free in cdev_put() when app exits
> after driver unbind
> (by Shauh Khan in 2016)
>
> This technique is similarly done in at least 15 places within the kernel
> and probably should have been done so in another, at least, 5 places.
> The kobj line also looks very suspect in that one would not expect
> drivers to have to mess with kobject internals in this way.
> Even highly experienced kernel developers can be surprised by this
> code, as seen in [2].
>
> To help alleviate this situation, and hopefully prevent future
> wasted effort on this problem, this patch introduces a helper function
> to register a char device along with its parent struct device.
> This creates a more regular API for tying a char device to its parent
> without the developer having to set members in the underlying kobject.
>
> This patch introduce cdev_device_add and cdev_device_del which
> replaces a common pattern including setting the kobj parent, calling
> cdev_add and then calling device_add. It also introduces cdev_set_parent
> for the few cases that set the kobject parent without using device_add.
>
> [1] https://lkml.org/lkml/2017/2/13/700
> [2] https://lkml.org/lkml/2017/2/10/370
>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Nice!

Regards,

	Hans

> ---
>  fs/char_dev.c        | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/cdev.h |  4 ++++
>  2 files changed, 71 insertions(+)
>
> diff --git a/fs/char_dev.c b/fs/char_dev.c
> index 44a240c..471d480 100644
> --- a/fs/char_dev.c
> +++ b/fs/char_dev.c
> @@ -471,6 +471,70 @@ int cdev_add(struct cdev *p, dev_t dev, unsigned count)
>  	return 0;
>  }
>
> +/**
> + * cdev_set_parent() - set the parent kobject for a char device
> + * @p: the cdev structure
> + * @kobj: the kobject to take a reference to
> + *
> + * cdev_set_parent() sets a parent kobject which will be referenced
> + * appropriately so the parent is not freed before the cdev. This
> + * should be called before cdev_add.
> + */
> +void cdev_set_parent(struct cdev *p, struct kobject *kobj)
> +{
> +	WARN_ON(!kobj->state_initialized);
> +	p->kobj.parent = kobj;
> +}
> +
> +/**
> + * cdev_device_add() - add a char device and it's corresponding
> + *	struct device, linkink
> + * @dev: the device structure
> + * @cdev: the cdev structure
> + *
> + * cdev_device_add() adds the char device represented by @cdev to the system,
> + * just as cdev_add does. It then adds @dev to the system using device_add
> + * The dev_t for the char device will be taken from the struct device which
> + * needs to be initialized first. This helper function correctly takes a
> + * reference to the parent device so the parent will not get released until
> + * all references to the cdev are released.
> + *
> + * This function should be used whenever the struct cdev and the
> + * struct device are members of the same structure whose lifetime is
> + * managed by the struct device.
> + */
> +int cdev_device_add(struct cdev *cdev, struct device *dev)
> +{
> +	int rc = 0;
> +
> +	cdev_set_parent(cdev, &dev->kobj);
> +
> +	rc = cdev_add(cdev, dev->devt, 1);
> +	if (rc)
> +		return rc;
> +
> +	rc = device_add(dev);
> +	if (rc)
> +		cdev_del(cdev);
> +
> +	return rc;
> +}
> +
> +/**
> + * cdev_device_del() - inverse of cdev_device_add
> + * @dev: the device structure
> + * @cdev: the cdev structure
> + *
> + * cdev_device_del() is a helper function to call cdev_del
> + * and device_del. It should be used whenever cdev_device_add
> + * is used.
> + */
> +void cdev_device_del(struct cdev *cdev, struct device *dev)
> +{
> +	device_del(dev);
> +	cdev_del(cdev);
> +}
> +
>  static void cdev_unmap(dev_t dev, unsigned count)
>  {
>  	kobj_unmap(cdev_map, dev, count);
> @@ -570,5 +634,8 @@ EXPORT_SYMBOL(cdev_init);
>  EXPORT_SYMBOL(cdev_alloc);
>  EXPORT_SYMBOL(cdev_del);
>  EXPORT_SYMBOL(cdev_add);
> +EXPORT_SYMBOL(cdev_set_parent);
> +EXPORT_SYMBOL(cdev_device_add);
> +EXPORT_SYMBOL(cdev_device_del);
>  EXPORT_SYMBOL(__register_chrdev);
>  EXPORT_SYMBOL(__unregister_chrdev);
> diff --git a/include/linux/cdev.h b/include/linux/cdev.h
> index f876361..4c99579 100644
> --- a/include/linux/cdev.h
> +++ b/include/linux/cdev.h
> @@ -26,6 +26,10 @@ void cdev_put(struct cdev *p);
>
>  int cdev_add(struct cdev *, dev_t, unsigned);
>
> +void cdev_set_parent(struct cdev *p, struct kobject *kobj);
> +int cdev_device_add(struct cdev *cdev, struct device *dev);
> +void cdev_device_del(struct cdev *cdev, struct device *dev);
> +
>  void cdev_del(struct cdev *);
>
>  void cd_forget(struct inode *);
>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
