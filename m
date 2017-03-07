Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D47280349
 for <linux-nvdimm@lists.01.org>; Tue,  7 Mar 2017 00:32:01 -0800 (PST)
Date: Tue, 7 Mar 2017 10:31:39 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3 06/16] tpm-chip: utilize new cdev_device_add helper
 function
Message-ID: <20170307083139.ccaoascf7yjoixg5@intel.com>
References: <1488783873-2614-1-git-send-email-logang@deltatee.com>
 <1488783873-2614-7-git-send-email-logang@deltatee.com>
 <20170306210426.qeftgujergryutie@intel.com>
 <20170307053138.GA7665@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170307053138.GA7665@kroah.com>
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
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jan Kara <jack@suse.cz>, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Alexandre Bounine <alexandre.bounine@idt.com>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, linux-scsi@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>, Parav Pandit <pandit.parav@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Alexandre Courbot <gnurou@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, rtc-linux@googlegroups.com, Leon Romanovsky <leon@kernel.org>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Richard Weinberger <richard@nod.at>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Marek Vasut <marek.vasut@gmail.com>, Doug Ledford <dledford@redhat.com>, Hans Verkuil <hans.verkuil@cisco.com>, Matt Porter <mporter@kernel.crashing.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-media@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Arnd Bergmann <arnd@arndb.de>, Boris Brezillon <boris.brezillon@free-electrons.com>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, linux-input@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Vladimir Zapolskiy <vz@mleia.com>, Joe Perches <joe@perches.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, linux-fsdevel@vger.kernel.org, Haggai Eran <haggaie@mellanox.com>, Lorenzo Stoakes <lstoakes@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Artem Bityutskiy <dedekind1@gmail.com>, David Woodhouse <dwmw2@infradead.org>, linux-gpio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org, Stephen Bates <stephen.bates@microsemi.com>, Hartmut Knaack <knaack.h@gmx.de>, Olof Johansson <olof@lixom.net>, linux-mtd@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>, Brian Norris <computersforpeace@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 07, 2017 at 06:31:38AM +0100, Greg Kroah-Hartman wrote:
> On Mon, Mar 06, 2017 at 11:04:26PM +0200, Jarkko Sakkinen wrote:
> > On Mon, Mar 06, 2017 at 12:04:22AM -0700, Logan Gunthorpe wrote:
> > > Replace the open coded registration of the cdev and dev with the
> > > new device_add_cdev() helper. The helper replaces a common pattern by
> > > taking the proper reference against the parent device and adding both
> > > the cdev and the device.
> > > 
> > > Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> > > Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > > ---
> > >  drivers/char/tpm/tpm-chip.c | 19 +++----------------
> > >  1 file changed, 3 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > > index c406343..935f0e9 100644
> > > --- a/drivers/char/tpm/tpm-chip.c
> > > +++ b/drivers/char/tpm/tpm-chip.c
> > > @@ -187,7 +187,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
> > >  
> > >  	cdev_init(&chip->cdev, &tpm_fops);
> > >  	chip->cdev.owner = THIS_MODULE;
> > > -	chip->cdev.kobj.parent = &chip->dev.kobj;
> > >  
> > >  	return chip;
> > >  
> > > @@ -230,27 +229,16 @@ static int tpm_add_char_device(struct tpm_chip *chip)
> > >  {
> > >  	int rc;
> > >  
> > > -	rc = cdev_add(&chip->cdev, chip->dev.devt, 1);
> > > +	rc = cdev_device_add(&chip->cdev, &chip->dev);
> > >  	if (rc) {
> > >  		dev_err(&chip->dev,
> > > -			"unable to cdev_add() %s, major %d, minor %d, err=%d\n",
> > > +			"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
> > >  			dev_name(&chip->dev), MAJOR(chip->dev.devt),
> > >  			MINOR(chip->dev.devt), rc);
> > >  
> > >  		return rc;
> > >  	}
> > >  
> > > -	rc = device_add(&chip->dev);
> > > -	if (rc) {
> > > -		dev_err(&chip->dev,
> > > -			"unable to device_register() %s, major %d, minor %d, err=%d\n",
> > > -			dev_name(&chip->dev), MAJOR(chip->dev.devt),
> > > -			MINOR(chip->dev.devt), rc);
> > > -
> > > -		cdev_del(&chip->cdev);
> > > -		return rc;
> > > -	}
> > > -
> > >  	/* Make the chip available. */
> > >  	mutex_lock(&idr_lock);
> > >  	idr_replace(&dev_nums_idr, chip, chip->dev_num);
> > > @@ -261,8 +249,7 @@ static int tpm_add_char_device(struct tpm_chip *chip)
> > >  
> > >  static void tpm_del_char_device(struct tpm_chip *chip)
> > >  {
> > > -	cdev_del(&chip->cdev);
> > > -	device_del(&chip->dev);
> > > +	cdev_device_del(&chip->cdev, &chip->dev);
> > >  
> > >  	/* Make the chip unavailable. */
> > >  	mutex_lock(&idr_lock);
> > > -- 
> > > 2.1.4
> > > 
> > 
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > 
> > I cannot test this at this point as security tree does not include
> > the commit that is dependent on this. I'm also wondering if this
> > commit is even going through my tree to upstream?
> 
> I can take it all at once through my tree.
> 
> thanks,
> 
> greg k-h

Alright, thank you!

/Jarkko
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
