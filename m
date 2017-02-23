Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x242.google.com (mail-pg0-x242.google.com
 [IPv6:2607:f8b0:400e:c05::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B91BB82166
 for <linux-nvdimm@lists.01.org>; Thu, 23 Feb 2017 00:37:07 -0800 (PST)
Received: by mail-pg0-x242.google.com with SMTP id 5so3806648pgj.0
 for <linux-nvdimm@lists.01.org>; Thu, 23 Feb 2017 00:37:07 -0800 (PST)
Date: Thu, 23 Feb 2017 00:37:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 03/14] input: utilize new device_add_cdev helper function
Message-ID: <20170223083703.GF18639@dtor-ws>
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
 <1487653253-11497-4-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1487653253-11497-4-git-send-email-logang@deltatee.com>
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
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jan Kara <jack@suse.cz>, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Alexandre Bounine <alexandre.bounine@idt.com>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, linux-scsi@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>, Parav Pandit <pandit.parav@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Alexandre Courbot <gnurou@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, rtc-linux@googlegroups.com, Leon Romanovsky <leon@kernel.org>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Richard Weinberger <richard@nod.at>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Marek Vasut <marek.vasut@gmail.com>, Doug Ledford <dledford@redhat.com>, tpmdd-devel@lists.sourceforge.net, Hans Verkuil <hans.verkuil@cisco.com>, Matt Porter <mporter@kernel.crashing.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-media@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Arnd Bergmann <arnd@arndb.de>, Boris Brezillon <boris.brezillon@free-electrons.com>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, linux-input@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Vladimir Zapolskiy <vz@mleia.com>, Joe Perches <joe@perches.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Benny Halevy <bhalevy@primarydata.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Haggai Eran <haggaie@mellanox.com>, Lorenzo Stoakes <lstoakes@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Artem Bityutskiy <dedekind1@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-gpio@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Stephen Bates <stephen.bates@microsemi.com>, Hartmut Knaack <knaack.h@gmx.de>, Olof Johansson <olof@lixom.net>, linux-mtd@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>, Brian Norris <computersforpeace@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Jonathan Cameron <jic23@kernel.org>, osd-dev@open-osd.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 20, 2017 at 10:00:42PM -0700, Logan Gunthorpe wrote:
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---

Please add some more verbage, otherwise

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>


>  drivers/input/evdev.c    | 3 +--
>  drivers/input/joydev.c   | 3 +--
>  drivers/input/mousedev.c | 3 +--
>  3 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index e9ae3d5..a3407ea 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -1416,8 +1416,7 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
>  		goto err_free_evdev;
>  
>  	cdev_init(&evdev->cdev, &evdev_fops);
> -	evdev->cdev.kobj.parent = &evdev->dev.kobj;
> -	error = cdev_add(&evdev->cdev, evdev->dev.devt, 1);
> +	error = device_add_cdev(&evdev->dev, &evdev->cdev);
>  	if (error)
>  		goto err_unregister_handle;
>  
> diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
> index abd18f3..012e06f 100644
> --- a/drivers/input/joydev.c
> +++ b/drivers/input/joydev.c
> @@ -905,8 +905,7 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
>  		goto err_free_joydev;
>  
>  	cdev_init(&joydev->cdev, &joydev_fops);
> -	joydev->cdev.kobj.parent = &joydev->dev.kobj;
> -	error = cdev_add(&joydev->cdev, joydev->dev.devt, 1);
> +	error = device_add_cdev(&joydev->dev, &joydev->cdev);
>  	if (error)
>  		goto err_unregister_handle;
>  
> diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
> index b604564..efd8666 100644
> --- a/drivers/input/mousedev.c
> +++ b/drivers/input/mousedev.c
> @@ -901,8 +901,7 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
>  	}
>  
>  	cdev_init(&mousedev->cdev, &mousedev_fops);
> -	mousedev->cdev.kobj.parent = &mousedev->dev.kobj;
> -	error = cdev_add(&mousedev->cdev, mousedev->dev.devt, 1);
> +	error = device_add_cdev(&mousedev->dev, &mousedev->cdev);
>  	if (error)
>  		goto err_unregister_handle;
>  
> -- 
> 2.1.4
> 

-- 
Dmitry
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
