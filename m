Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2AC7E8040A
 for <linux-nvdimm@lists.01.org>; Thu, 16 Mar 2017 10:39:20 -0700 (PDT)
References: <1488783873-2614-1-git-send-email-logang@deltatee.com>
 <1488783873-2614-17-git-send-email-logang@deltatee.com>
 <20170316084231.GA5476@kroah.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <ed12f209-842c-675d-9473-c4cc08f81d72@deltatee.com>
Date: Thu, 16 Mar 2017 11:39:18 -0600
MIME-Version: 1.0
In-Reply-To: <20170316084231.GA5476@kroah.com>
Subject: Re: [PATCH v3 16/16] switchtec: utilize new device_add_cdev helper
 function
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
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jan Kara <jack@suse.cz>, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Alexandre Bounine <alexandre.bounine@idt.com>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, linux-scsi@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>, Parav Pandit <pandit.parav@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Alexandre Courbot <gnurou@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, rtc-linux@googlegroups.com, Leon Romanovsky <leon@kernel.org>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Richard Weinberger <richard@nod.at>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Marek Vasut <marek.vasut@gmail.com>, Doug Ledford <dledford@redhat.com>, Hans Verkuil <hans.verkuil@cisco.com>, Matt Porter <mporter@kernel.crashing.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-media@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Arnd Bergmann <arnd@arndb.de>, Boris Brezillon <boris.brezillon@free-electrons.com>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, linux-input@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Vladimir Zapolskiy <vz@mleia.com>, Joe Perches <joe@perches.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, linux-fsdevel@vger.kernel.org, Haggai Eran <haggaie@mellanox.com>, Lorenzo Stoakes <lstoakes@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Artem Bityutskiy <dedekind1@gmail.com>, linux-gpio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org, Stephen Bates <stephen.bates@microsemi.com>, Hartmut Knaack <knaack.h@gmx.de>, Olof Johansson <olof@lixom.net>, linux-mtd@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>, Brian Norris <computersforpeace@gmail.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>



On 16/03/17 02:42 AM, Greg Kroah-Hartman wrote:
> As this file isn't in 4.11-rc1, I can't take this patch, but I took all
> of the others.  You should resend this to Bjorn after 4.12-rc1 is out.

Yup, I expected this. I'll keep an eye out and make sure it gets in when
the time comes.

Thanks,

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
