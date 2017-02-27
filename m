From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 06/16] tpm-chip: utilize new cdev_device_add helper
 function
Date: Mon, 27 Feb 2017 09:42:09 -0700
Message-ID: <20170227164209.GD5891@obsidianresearch.com>
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
 <1488091097-12328-7-git-send-email-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488091097-12328-7-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Alexandre Bounine <alexandre.bounine-49Rm3DX9dRQ@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Peter Meerwald-Stadler <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Marek Vasut <marek.vasut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Matt Porter <mporte>
List-Id: linux-nvdimm@lists.01.org

On Sat, Feb 25, 2017 at 11:38:07PM -0700, Logan Gunthorpe wrote:
> Replace the open coded registration of the cdev and dev with the
> new device_add_cdev() helper. The helper replaces a common pattern by
> taking the proper reference against the parent device and adding both
> the cdev and the device.
> 
> Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
>  drivers/char/tpm/tpm-chip.c | 19 +++----------------
>  1 file changed, 3 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index a77262d..933f96e 100644
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -187,7 +187,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
>  
>  	cdev_init(&chip->cdev, &tpm_fops);
>  	chip->cdev.owner = THIS_MODULE;
> -	chip->cdev.kobj.parent = &chip->dev.kobj;
>  
>  	return chip;
>  
> @@ -230,27 +229,16 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>  {
>  	int rc;
>  
> -	rc = cdev_add(&chip->cdev, chip->dev.devt, 1);
> +	rc = cdev_device_add(&chip->cdev, &chip->dev);
>  	if (rc) {
>  		dev_err(&chip->dev,
> -			"unable to cdev_add() %s, major %d, minor %d, err=%d\n",
> +			"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
>  			dev_name(&chip->dev), MAJOR(chip->dev.devt),
>  			MINOR(chip->dev.devt), rc);
>  
>  		return rc;
>  	}
>  
> -	rc = device_add(&chip->dev);
> -	if (rc) {
> -		dev_err(&chip->dev,
> -			"unable to device_register() %s, major %d, minor %d, err=%d\n",
> -			dev_name(&chip->dev), MAJOR(chip->dev.devt),
> -			MINOR(chip->dev.devt), rc);
> -
> -		cdev_del(&chip->cdev);
> -		return rc;
> -	}

This will collide with the patch I sent:

https://patchwork.kernel.org/patch/9589001/

Jarkko: The resolution will be to continue to call tpm_del_char_device
from the cdev_device_add error path and drop all calls to cdev_del

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Jason
