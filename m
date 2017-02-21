Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C73328221A
 for <linux-nvdimm@lists.01.org>; Tue, 21 Feb 2017 10:18:05 -0800 (PST)
Received: by mail-oi0-x234.google.com with SMTP id 2so32748743oif.0
 for <linux-nvdimm@lists.01.org>; Tue, 21 Feb 2017 10:18:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <17f32963-1d0e-5d17-64c9-742b05415722@deltatee.com>
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
 <1487653253-11497-2-git-send-email-logang@deltatee.com>
 <20170221053522.GA1466@dtor-ws>
 <17f32963-1d0e-5d17-64c9-742b05415722@deltatee.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 21 Feb 2017 10:18:04 -0800
Message-ID: <CAPcyv4jOWDxjQoBdZ8GQ+yhcAcL2gOBoEEHE-02beopXKFmGQA@mail.gmail.com>
Subject: Re: [PATCH 01/14] chardev: add helper function to register char devs
 with a struct device
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
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jan Kara <jack@suse.cz>, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Alexandre Bounine <alexandre.bounine@idt.com>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, linux-scsi <linux-scsi@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Parav Pandit <pandit.parav@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Alexandre Courbot <gnurou@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, rtc-linux@googlegroups.com, Leon Romanovsky <leon@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, Richard Weinberger <richard@nod.at>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Marek Vasut <marek.vasut@gmail.com>, Doug Ledford <dledford@redhat.com>, tpmdd-devel@lists.sourceforge.net, Hans Verkuil <hans.verkuil@cisco.com>, Matt Porter <mporter@kernel.crashing.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Boaz Harrosh <ooo@electrozaur.com>, Arnd Bergmann <arnd@arndb.de>, Boris Brezillon <boris.brezillon@free-electrons.com>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, linux-input@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Vladimir Zapolskiy <vz@mleia.com>, Joe Perches <joe@perches.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Benny Halevy <bhalevy@primarydata.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Lorenzo Stoakes <lstoakes@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Artem Bityutskiy <dedekind1@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-gpio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Bates <stephen.bates@microsemi.com>, Hartmut Knaack <knaack.h@gmx.de>, Olof Johansson <olof@lixom.net>, linux-mtd@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>, Brian Norris <computersforpeace@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Jonathan Cameron <jic23@kernel.org>, osd-dev@open-osd.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 20, 2017 at 10:35 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
> On 20/02/17 10:35 PM, Dmitry Torokhov wrote:
>> My only objection is to this statement. There is absolutely nothing that
>> prevents from calling device_unregister() first and cdev_del() later.
>> Refcounting will sort it all out.
>
> Yeah, I was really trying to warn people against calling cdev_del within
> the release function of the device. If you do that, then the cdev
> reference will block the device from ever getting released.
>
> Certainly, you could call device_unregister followed by cdev_del. I
> could reword this if you feel it necessary.

I agree with Dmitry, just delete the statement in parenthesis and the
rest is fine. If you're modifying this patch it might be good to take
the opportunity to add a WARN_ON(!parent->kobj.state_initialized) to
catch attempts to call device_add_cdev() with an uninitialized device.

You can also add:

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
