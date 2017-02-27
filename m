Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.free-electrons.com (mail.free-electrons.com [62.4.15.54])
 by ml01.01.org (Postfix) with ESMTP id E722981F68
 for <linux-nvdimm@lists.01.org>; Mon, 27 Feb 2017 01:46:49 -0800 (PST)
Date: Mon, 27 Feb 2017 10:46:43 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH v2 14/16] rtc: utilize new cdev_device_add helper function
Message-ID: <20170227094643.pag5preyj2dueabd@piout.net>
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
 <1488091097-12328-15-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1488091097-12328-15-git-send-email-logang@deltatee.com>
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
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jan Kara <jack@suse.cz>, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Alexandre Bounine <alexandre.bounine@idt.com>, linux-mtd@lists.infradead.org, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, linux-scsi@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>, Parav Pandit <pandit.parav@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Alexandre Courbot <gnurou@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, rtc-linux@googlegroups.com, Leon Romanovsky <leon@kernel.org>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Richard Weinberger <richard@nod.at>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Marek Vasut <marek.vasut@gmail.com>, Doug Ledford <dledford@redhat.com>, Hans Verkuil <hans.verkuil@cisco.com>, Matt Porter <mporter@kernel.crashing.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-media@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Arnd Bergmann <arnd@arndb.de>, Boris Brezillon <boris.brezillon@free-electrons.com>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, linux-input@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Vladimir Zapolskiy <vz@mleia.com>, Joe Perches <joe@perches.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Haggai Eran <haggaie@mellanox.com>, Lorenzo Stoakes <lstoakes@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Artem Bityutskiy <dedekind1@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-gpio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org, Stephen Bates <stephen.bates@microsemi.com>, Hartmut Knaack <knaack.h@gmx.de>, Olof Johansson <olof@lixom.net>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Brian Norris <computersforpeace@gmail.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On 25/02/2017 at 23:38:15 -0700, Logan Gunthorpe wrote:
> Mostly straightforward, but we had to remove the rtc_dev_add/del_device
> functions as they split up the cdev_add and the device_add.
> 
> Doing this also revealed that there was likely another subtle bug:
> seeing cdev_add was done after device_register, the cdev probably
> was not ready before device_add when the uevent occurs. This would
> race with userspace, if it tried to use the device directly after
> the uevent. This is fixed just by using the new helper function.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> ---
>  drivers/rtc/class.c   | 14 ++++++++++----
>  drivers/rtc/rtc-dev.c | 17 -----------------
>  2 files changed, 10 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> index 74fd974..5fb4398 100644
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -195,6 +195,8 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
>  		goto exit_ida;
>  	}
>  
> +	device_initialize(&rtc->dev);
> +
>  	rtc->id = id;
>  	rtc->ops = ops;
>  	rtc->owner = owner;
> @@ -233,14 +235,19 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
>  
>  	rtc_dev_prepare(rtc);
>  
> -	err = device_register(&rtc->dev);
> +	err = cdev_device_add(&rtc->char_dev, &rtc->dev);
>  	if (err) {
> +		dev_warn(&rtc->dev, "%s: failed to add char device %d:%d\n",
> +			 rtc->name, MAJOR(rtc->dev.devt), rtc->id);
> +
>  		/* This will free both memory and the ID */
>  		put_device(&rtc->dev);
>  		goto exit;
> +	} else {
> +		dev_dbg(&rtc->dev, "%s: dev (%d:%d)\n", rtc->name,
> +			MAJOR(rtc->dev.devt), rtc->id);
>  	}
>  
> -	rtc_dev_add_device(rtc);
>  	rtc_proc_add_device(rtc);
>  
>  	dev_info(dev, "rtc core: registered %s as %s\n",
> @@ -271,9 +278,8 @@ void rtc_device_unregister(struct rtc_device *rtc)
>  	 * Remove innards of this RTC, then disable it, before
>  	 * letting any rtc_class_open() users access it again
>  	 */
> -	rtc_dev_del_device(rtc);
>  	rtc_proc_del_device(rtc);
> -	device_del(&rtc->dev);
> +	cdev_device_del(&rtc->char_dev, &rtc->dev);
>  	rtc->ops = NULL;
>  	mutex_unlock(&rtc->ops_lock);
>  	put_device(&rtc->dev);
> diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
> index a6d9434..fdd071f 100644
> --- a/drivers/rtc/rtc-dev.c
> +++ b/drivers/rtc/rtc-dev.c
> @@ -477,23 +477,6 @@ void rtc_dev_prepare(struct rtc_device *rtc)
>  
>  	cdev_init(&rtc->char_dev, &rtc_dev_fops);
>  	rtc->char_dev.owner = rtc->owner;
> -	rtc->char_dev.kobj.parent = &rtc->dev.kobj;
> -}
> -
> -void rtc_dev_add_device(struct rtc_device *rtc)
> -{
> -	if (cdev_add(&rtc->char_dev, rtc->dev.devt, 1))
> -		dev_warn(&rtc->dev, "%s: failed to add char device %d:%d\n",
> -			rtc->name, MAJOR(rtc_devt), rtc->id);
> -	else
> -		dev_dbg(&rtc->dev, "%s: dev (%d:%d)\n", rtc->name,
> -			MAJOR(rtc_devt), rtc->id);
> -}
> -
> -void rtc_dev_del_device(struct rtc_device *rtc)
> -{
> -	if (rtc->dev.devt)
> -		cdev_del(&rtc->char_dev);
>  }
>  
>  void __init rtc_dev_init(void)
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
