Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x236.google.com (mail-ot0-x236.google.com
 [IPv6:2607:f8b0:4003:c0f::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1FE6C82101
 for <linux-nvdimm@lists.01.org>; Sun, 26 Feb 2017 10:22:38 -0800 (PST)
Received: by mail-ot0-x236.google.com with SMTP id x10so40194623otb.1
 for <linux-nvdimm@lists.01.org>; Sun, 26 Feb 2017 10:22:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1488091097-12328-3-git-send-email-logang@deltatee.com>
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
 <1488091097-12328-3-git-send-email-logang@deltatee.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 26 Feb 2017 10:22:36 -0800
Message-ID: <CAPcyv4hkirsNhx14HhiF6d7qmjtY7YD6ZjiyeLMw8C=QGpq0VA@mail.gmail.com>
Subject: Re: [PATCH v2 02/16] device-dax: fix cdev leak
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
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jan Kara <jack@suse.cz>, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Alexandre Bounine <alexandre.bounine@idt.com>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, linux-scsi <linux-scsi@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Parav Pandit <pandit.parav@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Alexandre Courbot <gnurou@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, rtc-linux@googlegroups.com, Leon Romanovsky <leon@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, Richard Weinberger <richard@nod.at>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Marek Vasut <marek.vasut@gmail.com>, Doug Ledford <dledford@redhat.com>, Hans Verkuil <hans.verkuil@cisco.com>, Matt Porter <mporter@kernel.crashing.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Boaz Harrosh <ooo@electrozaur.com>, Arnd Bergmann <arnd@arndb.de>, Boris Brezillon <boris.brezillon@free-electrons.com>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, linux-input@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Vladimir Zapolskiy <vz@mleia.com>, Joe Perches <joe@perches.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Lorenzo Stoakes <lstoakes@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Artem Bityutskiy <dedekind1@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-gpio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Stephen Bates <stephen.bates@microsemi.com>, Hartmut Knaack <knaack.h@gmx.de>, Olof Johansson <olof@lixom.net>, linux-mtd@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>, Brian Norris <computersforpeace@gmail.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Feb 25, 2017 at 10:38 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
> From: Dan Williams <dan.j.williams@intel.com>
>
> If device_add() fails, cleanup the cdev. Otherwise, we leak a kobj_map()
> with a stale device number.
>
> As Jason points out, there is a small possibility that userspace has
> opened and mapped the device in the time between cdev_add() and the
> device_add() failure. We need a new kill_dax_dev() helper to invalidate
> any established mappings.
>
> Fixes: ba09c01d2fa8 ("dax: convert to the cdev api")
> Cc: <stable@vger.kernel.org>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Reported-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Since you are forwarding this patch you should add

"Signed-off-by: Logan Gunthorpe <logang@deltatee.com>"
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
