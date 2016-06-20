Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from na01-by2-obe.outbound.protection.outlook.com
 (mail-by2on0693.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fc0c::693])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E278D1A1E25
 for <linux-nvdimm@lists.01.org>; Mon, 20 Jun 2016 06:34:33 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] block: convert to device_add_disk()
References: <146618127395.31030.11800447312061202344.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146618128465.31030.12159307386730181867.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Bart Van Assche <bart.vanassche@sandisk.com>
Message-ID: <8dc61bb4-fc9f-a855-d792-37e4e6a02db9@sandisk.com>
Date: Mon, 20 Jun 2016 15:33:49 +0200
MIME-Version: 1.0
In-Reply-To: <146618128465.31030.12159307386730181867.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, linux-block@vger.kernel.org
Cc: axboe@fb.com, Ulf Hansson <ulf.hansson@linaro.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Michael S." Tsirkin" <mst@redhat.com>, David Woodhouse <dwmw2@infradead.org>," linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-nvdimm@lists.01.org, Keith Busch <keith.busch@intel.com>, "David S. Miller" <davem@davemloft.net>
List-ID: <linux-nvdimm@lists.01.org>

On 06/17/2016 06:34 PM, Dan Williams wrote:
> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
> index ef6b4d960bad..4e7cb5df8e43 100644
> --- a/arch/um/drivers/ubd_kern.c
> +++ b/arch/um/drivers/ubd_kern.c
> @@ -823,12 +823,11 @@ static int ubd_disk_register(int major, u64 size, int unit,
>  		ubd_devs[unit].pdev.dev.release = ubd_device_release;
>  		dev_set_drvdata(&ubd_devs[unit].pdev.dev, &ubd_devs[unit]);
>  		platform_device_register(&ubd_devs[unit].pdev);
> -		disk->driverfs_dev = &ubd_devs[unit].pdev.dev;
>  	}
>
>  	disk->private_data = &ubd_devs[unit];
>  	disk->queue = ubd_devs[unit].queue;
> -	add_disk(disk);
> +	device_add_disk(&ubd_devs[unit].pdev.dev, disk);
>
>  	*disk_out = disk;
>  	return 0;

Have you reviewed this patch yourself? I think the above change is an 
unintended behavior change.

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
