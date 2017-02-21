Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: [PATCH 00/14] Cleanup chardev instances with helper function
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
From: Richard Weinberger <richard@nod.at>
Message-ID: <94a91057-82f1-98da-d624-0b30658e23da@nod.at>
Date: Tue, 21 Feb 2017 08:54:08 +0100
MIME-Version: 1.0
In-Reply-To: <1487653253-11497-1-git-send-email-logang@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Linus Walleij <linus.walleij@linaro.org>, Alexandre Courbot <gnurou@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Olof Johansson <olof@lixom.net>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Haggai Eran <haggaie@mellanox.com>, Parav Pandit <pandit.parav@gmail.com>, Leon Romanovsky <leon@kernel.org>, Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, Hans Verkuil <hans.verkuil@cisco.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Artem Bityutskiy <dedekind1@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, Marek Vasut <marek.vasut@gmail.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alexandre.bounine@idt.com>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Lorenzo Stoakes <lstoakes@gmail.com>, Vladimir Zapolskiy <vz@mleia.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Boaz Harrosh <ooo@electrozaur.com>, Benny Halevy <bhalevy@primarydata.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Bates <stephen.bates@microsemi.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-scsi@vger.kernel.org, rtc-linux@googlegroups.com, linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-input@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Logan,

Am 21.02.2017 um 06:00 schrieb Logan Gunthorpe:
> Hello,
> 
> Our story for this patch-set begins with a new driver I wrote and am in
> the process of submitting upstream. That driver creates a fairly
> standard char device and the code for it was copied from a similar
> instance in device-dax. However, upon review, Greg Kroah-Hartman
> noticed [1] a suspicious line that assigned to the parent field of
> the underlying kobject for the char device.
> 
> I removed that from my code and endeavoured to remove it from the
> code I copied as well. However, Dan Williams pointed out [2] that this
> code is necessary for correct reference counting of the underlying
> structures. This prompted me to do a fair bit more research and
> investigation into whats going on and I found it to be a common pattern.
> (Although misleading and though required to be correct, frequently
> forgotten.) This pattern is used in at least 15 places in the kernel
> and probably should have been used in at least 5 more.
> 
> This patch-set aims to correct this and hopefully prevent future
> developers from wasting their time on it. The first patch introduces
> a new helper API as originally proposed by Dan Williams [3]. Please
> see the commit message for that patch for a longer description of the
> problem and history.
> 
> The subsequent patches either update correct instances to use the
> new API or fix incorrect usages to ensure the cdev correctly takes
> a reference count using the new API (this is noted in those patches).
> 
> This moves all except four of the cdev.kobj.parent usages into the one
> cdev function, the remaining four are in the infiniband subsystem and
> I've left alone because that subsystem seems to make use of kobjects
> directly (instead of struct devices). These are noted in patch 7 of
> this series.
> 
> This series is based on v4.10 with the exception of the last patch
> which is for my new driver which, as yet, has not been accepted
> upstream.
> 
> @Dan the first patch in this series will need your sign-off.
> 
> Thanks,
> 
> Logan
> 
> [1] https://lkml.org/lkml/2017/2/10/370
> [2] https://lkml.org/lkml/2017/2/10/607
> [3] https://lkml.org/lkml/2017/2/13/700
> 
> Logan Gunthorpe (14):
>   chardev: add helper function to register char devs with a struct
>     device
>   device-dax: utilize new device_add_cdev helper function
>   input: utilize new device_add_cdev helper function
>   gpiolib: utilize new device_add_cdev helper function
>   tpm-chip: utilize new device_add_cdev helper function
>   platform/chrome: utilize new device_add_cdev helper function
>   infiniband: utilize new device_add_cdev helper function
>   iio:core: utilize new device_add_cdev helper function
>   media: utilize new device_add_cdev helper function
>   mtd: utilize new device_add_cdev helper function
>   rapidio: utilize new device_add_cdev helper function
>   rtc: utilize new device_add_cdev helper function
>   scsi: utilize new device_add_cdev helper function
>   switchtec: utilize new device_add_cdev helper function
> 
>  drivers/char/tpm/tpm-chip.c              |  3 +--
>  drivers/dax/dax.c                        |  5 ++---
>  drivers/gpio/gpiolib.c                   |  3 +--
>  drivers/iio/industrialio-core.c          |  3 +--
>  drivers/infiniband/core/ucm.c            |  8 +++++---
>  drivers/input/evdev.c                    |  3 +--
>  drivers/input/joydev.c                   |  3 +--
>  drivers/input/mousedev.c                 |  3 +--
>  drivers/media/cec/cec-core.c             |  3 +--
>  drivers/media/media-devnode.c            |  3 +--
>  drivers/mtd/ubi/build.c                  |  8 +++++---
>  drivers/mtd/ubi/vmt.c                    | 10 +++++-----
>  drivers/pci/switch/switchtec.c           |  3 +--
>  drivers/platform/chrome/cros_ec_dev.c    |  6 ++----
>  drivers/rapidio/devices/rio_mport_cdev.c |  9 ++++++---
>  drivers/rtc/rtc-dev.c                    |  3 +--
>  drivers/scsi/osd/osd_uld.c               |  9 +++++----
>  fs/char_dev.c                            | 24 ++++++++++++++++++++++++
>  include/linux/cdev.h                     |  1 +
>  19 files changed, 65 insertions(+), 45 deletions(-)

Do you have a git tree where I can pull from?

Thanks,
//richard
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
