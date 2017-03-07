Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.free-electrons.com (mail.free-electrons.com [62.4.15.54])
 by ml01.01.org (Postfix) with ESMTP id DAFAC8034B
 for <linux-nvdimm@lists.01.org>; Tue,  7 Mar 2017 14:41:44 -0800 (PST)
Date: Tue, 7 Mar 2017 23:41:35 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH v3 14/16] rtc: utilize new cdev_device_add helper function
Message-ID: <20170307224135.eyi62jgnmic5ordb@piout.net>
References: <1488783873-2614-1-git-send-email-logang@deltatee.com>
 <1488783873-2614-15-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1488783873-2614-15-git-send-email-logang@deltatee.com>
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

On 06/03/2017 at 00:04:30 -0700, Logan Gunthorpe wrote:
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

I think I already acked v2 but
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

-- 
Alexandre Belloni, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
