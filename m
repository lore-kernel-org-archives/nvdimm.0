Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F2E3802AE
 for <linux-nvdimm@lists.01.org>; Thu, 16 Mar 2017 01:40:11 -0700 (PDT)
Date: Thu, 16 Mar 2017 17:39:55 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [rtc-linux] [PATCH v3 05/16] gpiolib: utilize new
 cdev_device_add helper function
Message-ID: <20170316083955.GA18265@kroah.com>
References: <1488783873-2614-1-git-send-email-logang@deltatee.com>
 <1488783873-2614-6-git-send-email-logang@deltatee.com>
 <CACRpkdaNW+kexYNOZiVTRywHpwndKLbXmP1NXDjOifKY3JUURQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACRpkdaNW+kexYNOZiVTRywHpwndKLbXmP1NXDjOifKY3JUURQ@mail.gmail.com>
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
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jan Kara <jack@suse.cz>, "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Alexandre Bounine <alexandre.bounine@idt.com>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, linux-scsi@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>, Parav Pandit <pandit.parav@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Alexandre Courbot <gnurou@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Arnd Bergmann <arnd@arndb.de>, Leon Romanovsky <leon@kernel.org>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Richard Weinberger <richard@nod.at>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Marek Vasut <marek.vasut@gmail.com>, Doug Ledford <dledford@redhat.com>, Hans Verkuil <hans.verkuil@cisco.com>, Matt Porter <mporter@kernel.crashing.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Boaz Harrosh <ooo@electrozaur.com>, "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, Linux Input <linux-input@vger.kernel.org>, Marcel Selhorst <tpmdd@selhorst.net>, Vladimir Zapolskiy <vz@mleia.com>, Joe Perches <joe@perches.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, linux-fsdevel@vger.kernel.org, Haggai Eran <haggaie@mellanox.com>, Lorenzo Stoakes <lstoakes@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Artem Bityutskiy <dedekind1@gmail.com>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Bates <stephen.bates@microsemi.com>, Hartmut Knaack <knaack.h@gmx.de>, Olof Johansson <olof@lixom.net>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Brian Norris <computersforpeace@gmail.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 14, 2017 at 04:28:28PM +0100, Linus Walleij wrote:
> On Mon, Mar 6, 2017 at 8:04 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
> 
> > Replace the open coded registration of the cdev and dev with the
> > new device_add_cdev() helper. The helper replaces a common pattern by
> > taking the proper reference against the parent device and adding both
> > the cdev and the device.
> >
> > Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Please inform me if you plan to merge this into the device core
> tree or similar, or whether I should apply it for like v4.13 after merging
> the core patch or so.

I'll take this through my tree, no need to bother you with it.

thanks,

greg k-h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
