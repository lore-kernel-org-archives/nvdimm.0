Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A4C99802E9
 for <linux-nvdimm@lists.01.org>; Sat,  4 Mar 2017 14:58:08 -0800 (PST)
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
 <1488091097-12328-12-git-send-email-logang@deltatee.com>
 <8eff8408-1681-a59d-3b61-8fd5dab73af1@cisco.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <9941530f-c36a-3fa0-6f5b-87d779f5988c@deltatee.com>
Date: Sat, 4 Mar 2017 15:57:40 -0700
MIME-Version: 1.0
In-Reply-To: <8eff8408-1681-a59d-3b61-8fd5dab73af1@cisco.com>
Subject: Re: [PATCH v2 11/16] media: utilize new cdev_device_add helper
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
To: Hans Verkuil <hansverk@cisco.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Linus Walleij <linus.walleij@linaro.org>, Alexandre Courbot <gnurou@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Olof Johansson <olof@lixom.net>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Haggai Eran <haggaie@mellanox.com>, Parav Pandit <pandit.parav@gmail.com>, Leon Romanovsky <leon@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, Mauro Carvalho Chehab <mchehab@kernel.org>, Artem Bityutskiy <dedekind1@gmail.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, Marek Vasut <marek.vasut@gmail.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alexandre.bounine@idt.com>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Lorenzo Stoakes <lstoakes@gmail.com>, Vladimir Zapolskiy <vz@mleia.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Boaz Harrosh <ooo@electrozaur.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Bates <stephen.bates@microsemi.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-scsi@vger.kernel.org, rtc-linux@googlegroups.com, linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>, linux-rdma@vger.kernel.org, linux-mtd@lists.infradead.org, linux-input@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>



On 27/02/17 02:02 AM, Hans Verkuil wrote:
> FYI: this patch series didn't turn up at the linux-media mailinglist for
> some reason.

Strange my mail logs show success (see below) but none of the lists at
vger.kernel.org picked up either v1 or v2. I don't know what to do about
that. My previous other patch series doesn't have an issue and I'm using
the exact same setup. Maybe I'm sending to too many lists at once with
this series? I'm not really sure.

Logan


2017-02-25 23:40:37 1chsTZ-0004fx-8Y => linux-pci@vger.kernel.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-scsi@vger.kernel.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-media@vger.kernel.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-iio@vger.kernel.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-rdma@vger.kernel.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-gpio@vger.kernel.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-input@vger.kernel.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-fsdevel@vger.kernel.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-kernel@vger.kernel.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
