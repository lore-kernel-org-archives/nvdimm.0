Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22e.google.com (mail-ot0-x22e.google.com
 [IPv6:2607:f8b0:4003:c0f::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3AAA782221
 for <linux-nvdimm@lists.01.org>; Tue, 21 Feb 2017 11:26:35 -0800 (PST)
Received: by mail-ot0-x22e.google.com with SMTP id k4so75397650otc.0
 for <linux-nvdimm@lists.01.org>; Tue, 21 Feb 2017 11:26:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170221113704.ibwkk2vuc5imkmae@piout.net>
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
 <1487653253-11497-3-git-send-email-logang@deltatee.com>
 <20170221113704.ibwkk2vuc5imkmae@piout.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 21 Feb 2017 11:26:33 -0800
Message-ID: <CAPcyv4huQGQPSwvX9=iAVtzr1ga8RbN+e_q7DNaUMWGbWt_5mA@mail.gmail.com>
Subject: Re: [PATCH 02/14] device-dax: utilize new device_add_cdev helper
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
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jan Kara <jack@suse.cz>, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Alexandre Bounine <alexandre.bounine@idt.com>, linux-mtd@lists.infradead.org, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, linux-scsi <linux-scsi@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Parav Pandit <pandit.parav@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Alexandre Courbot <gnurou@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, rtc-linux@googlegroups.com, Leon Romanovsky <leon@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, Richard Weinberger <richard@nod.at>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Marek Vasut <marek.vasut@gmail.com>, Doug Ledford <dledford@redhat.com>, tpmdd-devel@lists.sourceforge.net, Hans Verkuil <hans.verkuil@cisco.com>, Matt Porter <mporter@kernel.crashing.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Boaz Harrosh <ooo@electrozaur.com>, Arnd Bergmann <arnd@arndb.de>, Boris Brezillon <boris.brezillon@free-electrons.com>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, linux-input@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Vladimir Zapolskiy <vz@mleia.com>, Joe Perches <joe@perches.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Benny Halevy <bhalevy@primarydata.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Haggai Eran <haggaie@mellanox.com>, Brian Norris <computersforpeace@gmail.com>, Lorenzo Stoakes <lstoakes@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Artem Bityutskiy <dedekind1@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-gpio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Bates <stephen.bates@microsemi.com>, Hartmut Knaack <knaack.h@gmx.de>, Olof Johansson <olof@lixom.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Woodhouse <dwmw2@infradead.org>, Jonathan Cameron <jic23@kernel.org>, osd-dev@open-osd.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 21, 2017 at 3:37 AM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> Hi,
>
> A small comment, you must always have a commit message. Even if it is
> small.

Yes, something like: "Replace the open coded initialization of the
cdev with the new device_add_cdev() helper. The helper takes the
proper reference against the parent device while the cdev object is
alive."

With that you can also add:

Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
