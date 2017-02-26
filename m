Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x232.google.com (mail-ot0-x232.google.com
 [IPv6:2607:f8b0:4003:c0f::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D07782101
 for <linux-nvdimm@lists.01.org>; Sun, 26 Feb 2017 10:21:27 -0800 (PST)
Received: by mail-ot0-x232.google.com with SMTP id j38so40131661otb.3
 for <linux-nvdimm@lists.01.org>; Sun, 26 Feb 2017 10:21:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1488091097-12328-2-git-send-email-logang@deltatee.com>
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
 <1488091097-12328-2-git-send-email-logang@deltatee.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 26 Feb 2017 10:21:25 -0800
Message-ID: <CAPcyv4i91_esBtBxbnDH3ZDd8Mnz4HoJEW2yeEvQ4QikFBjapA@mail.gmail.com>
Subject: Re: [PATCH v2 01/16] chardev: add helper function to register char
 devs with a struct device
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
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jan Kara <jack@suse.cz>, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Alexandre Bounine <alexandre.bounine@idt.com>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, linux-scsi <linux-scsi@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Parav Pandit <pandit.parav@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Alexandre Courbot <gnurou@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, rtc-linux@googlegroups.com, Leon Romanovsky <leon@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, Richard Weinberger <richard@nod.at>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Marek Vasut <marek.vasut@gmail.com>, Doug Ledford <dledford@redhat.com>, Hans Verkuil <hans.verkuil@cisco.com>, Matt Porter <mporter@kernel.crashing.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Boaz Harrosh <ooo@electrozaur.com>, Arnd Bergmann <arnd@arndb.de>, Boris Brezillon <boris.brezillon@free-electrons.com>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, linux-input@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Vladimir Zapolskiy <vz@mleia.com>, Joe Perches <joe@perches.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Lorenzo Stoakes <lstoakes@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Artem Bityutskiy <dedekind1@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-gpio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Bates <stephen.bates@microsemi.com>, Hartmut Knaack <knaack.h@gmx.de>, Olof Johansson <olof@lixom.net>, linux-mtd@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>, Brian Norris <computersforpeace@gmail.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Feb 25, 2017 at 10:38 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
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

Nice history!

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
>         return 0;
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
> +       WARN_ON(!kobj->state_initialized);
> +       p->kobj.parent = kobj;
> +}
> +
> +/**
> + * cdev_device_add() - add a char device and it's corresponding
> + *     struct device, linkink

"add a cdev and it's corresponding struct device"

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

Perhaps add a note here that userspace may have invoked file
operations between cdev_add() and a failing device_add(), so
additional cleanup beyond put_device() (like mmap invalidation) might
be needed. That can be a later follow-on patch.

> +int cdev_device_add(struct cdev *cdev, struct device *dev)
> +{
> +       int rc = 0;
> +
> +       cdev_set_parent(cdev, &dev->kobj);
> +
> +       rc = cdev_add(cdev, dev->devt, 1);
> +       if (rc)
> +               return rc;
> +
> +       rc = device_add(dev);
> +       if (rc)
> +               cdev_del(cdev);
> +
> +       return rc;
> +}
> +
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
