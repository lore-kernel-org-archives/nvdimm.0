Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BN3-obe.outbound.protection.outlook.com
 (mail-bn3nam01on0621.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe41::621])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EC5942194EB64
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 09:07:20 -0700 (PDT)
From: "Kershner, David A" <David.Kershner@unisys.com>
Subject: RE: [PATCH 10/22] staging: unisys: visorbus: Make use of the new
 sg_map helper function
Date: Fri, 14 Apr 2017 16:07:14 +0000
Message-ID: <CY4PR07MB317691139A5B2F902CDA9B0EF0050@CY4PR07MB3176.namprd07.prod.outlook.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-11-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-11-git-send-email-logang@deltatee.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Logan Gunthorpe <logang@deltatee.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Sumit Semwal <sumit.semwal@linaro.org>, Ming Lin <ming.l@ssi.samsung.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>, "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>, *S-Par-Maintainer <SParMaintainer@unisys.com>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>
Cc: Steve Wise <swise@opengridcomputing.com>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Logan Gunthorpe [mailto:logang@deltatee.com]
...
> Subject: [PATCH 10/22] staging: unisys: visorbus: Make use of the new
> sg_map helper function
> 
> Straightforward conversion to the new function.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>

Can you add Acked-by for this patch? 

Acked-by: David Kershner <david.kershner@unisys.com>

Tested on s-Par and no problems. 

Thanks,
David Kershner

> ---
>  drivers/staging/unisys/visorhba/visorhba_main.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c
> b/drivers/staging/unisys/visorhba/visorhba_main.c
> index 0ce92c8..2d8c8bc 100644
> --- a/drivers/staging/unisys/visorhba/visorhba_main.c
> +++ b/drivers/staging/unisys/visorhba/visorhba_main.c
> @@ -842,7 +842,6 @@ do_scsi_nolinuxstat(struct uiscmdrsp *cmdrsp, struct
> scsi_cmnd *scsicmd)
>  	struct scatterlist *sg;
>  	unsigned int i;
>  	char *this_page;
> -	char *this_page_orig;
>  	int bufind = 0;
>  	struct visordisk_info *vdisk;
>  	struct visorhba_devdata *devdata;
> @@ -869,11 +868,14 @@ do_scsi_nolinuxstat(struct uiscmdrsp *cmdrsp,
> struct scsi_cmnd *scsicmd)
> 
>  		sg = scsi_sglist(scsicmd);
>  		for (i = 0; i < scsi_sg_count(scsicmd); i++) {
> -			this_page_orig = kmap_atomic(sg_page(sg + i));
> -			this_page = (void *)((unsigned long)this_page_orig |
> -					     sg[i].offset);
> +			this_page = sg_map(sg + i, SG_KMAP_ATOMIC);
> +			if (IS_ERR(this_page)) {
> +				scsicmd->result = DID_ERROR << 16;
> +				return;
> +			}
> +
>  			memcpy(this_page, buf + bufind, sg[i].length);
> -			kunmap_atomic(this_page_orig);
> +			sg_unmap(sg + i, this_page, SG_KMAP_ATOMIC);
>  		}
>  	} else {
>  		devdata = (struct visorhba_devdata *)scsidev->host-
> >hostdata;
> --
> 2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
