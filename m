Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Mon, 27 Feb 2017 09:56:18 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2 01/16] chardev: add helper function to register char
 devs with a struct device
Message-ID: <20170227165618.GE5891@obsidianresearch.com>
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
 <1488091097-12328-2-git-send-email-logang@deltatee.com>
 <CAPcyv4i91_esBtBxbnDH3ZDd8Mnz4HoJEW2yeEvQ4QikFBjapA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4i91_esBtBxbnDH3ZDd8Mnz4HoJEW2yeEvQ4QikFBjapA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jan Kara <jack@suse.cz>, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Alexandre Bounine <alexandre.bounine@idt.com>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, linux-scsi <linux-scsi@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Parav Pandit <pandit.parav@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Alexandre Courbot <gnurou@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, rtc-linux@googlegroups.com, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, Richard Weinberger <richard@nod.at>, Marek Vasut <marek.vasut@gmail.com>, Doug Ledford <dledford@redhat.com>, Hans Verkuil <hans.verkuil@cisco.com>, Matt Porter <mporter@kernel.crashing.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Boaz Harrosh <ooo@electrozaur.com>, Arnd Bergmann <arnd@arndb.de>, Boris Brezillon <boris.brezillon@free-electrons.com>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, linux-input@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Vladimir Zapolskiy <vz@mleia.com>, Joe Perches <joe@perches.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Haggai Eran <haggaie@mellanox.com>, Brian Norris <computersforpeace@gmail.com>, Lorenzo Stoakes <lstoakes@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Artem Bityutskiy <dedekind1@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-gpio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Bates <stephen.bates@microsemi.com>, Hartmut Knaack <knaack.h@gmx.de>, Olof Johansson <olof@lixom.net>, linux-mtd@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>, David Woodhouse <dwmw2@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Feb 26, 2017 at 10:21:25AM -0800, Dan Williams wrote:
> > + * cdev_device_add() adds the char device represented by @cdev to the system,
> > + * just as cdev_add does. It then adds @dev to the system using device_add
> > + * The dev_t for the char device will be taken from the struct device which
> > + * needs to be initialized first. This helper function correctly takes a
> > + * reference to the parent device so the parent will not get released until
> > + * all references to the cdev are released.
> > + *
> > + * This function should be used whenever the struct cdev and the
> > + * struct device are members of the same structure whose lifetime is
> > + * managed by the struct device.
> > + */
> 
> Perhaps add a note here that userspace may have invoked file
> operations between cdev_add() and a failing device_add(), so
> additional cleanup beyond put_device() (like mmap invalidation) might
> be needed. That can be a later follow-on patch.

Yes please, that is way too subtle. Suggest:

NOTE: Callers must assume that userspace was able to open the cdev and
can call cdev fops callbacks at any time, even if this function fails.

I would also add a note to cdev_device_del:

NOTE: This guarantees that associated sysfs callbacks are not running
or runnable, however any open cdevs will remain and their fops remain
callable even after this returns.

Since I have seen a lot of confusion on that point as well..

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
