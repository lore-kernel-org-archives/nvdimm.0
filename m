Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from SMTP.EU.CITRIX.COM (smtp.eu.citrix.com [185.25.65.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F0FE21951C86
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 00:37:31 -0700 (PDT)
Date: Wed, 26 Apr 2017 08:37:20 +0100
From: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [PATCH v2 15/21] xen-blkfront: Make use of the new sg_map helper
 function
Message-ID: <20170426073720.okv33ly2ldepilti@dhcp-3-128.uk.xensource.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-16-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1493144468-22493-16-git-send-email-logang@deltatee.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, dri-devel@lists.freedesktop.org, dm-devel@redhat.com, target-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, devel@driverdev.osuosl.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, Juergen Gross <jgross@suse.com>, Julien Grall <julien.grall@arm.com>, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, netdev@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 25, 2017 at 12:21:02PM -0600, Logan Gunthorpe wrote:
> Straightforward conversion to the new helper, except due to the lack
> of error path, we have to use SG_MAP_MUST_NOT_FAIL which may BUG_ON in
> certain cases in the future.
> =

> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: "Roger Pau Monn=E9" <roger.pau@citrix.com>
> ---
>  drivers/block/xen-blkfront.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> =

> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 3945963..ed62175 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -816,8 +816,9 @@ static int blkif_queue_rw_req(struct request *req, st=
ruct blkfront_ring_info *ri
>  		BUG_ON(sg->offset + sg->length > PAGE_SIZE);
>  =

>  		if (setup.need_copy) {
> -			setup.bvec_off =3D sg->offset;
> -			setup.bvec_data =3D kmap_atomic(sg_page(sg));
> +			setup.bvec_off =3D 0;
> +			setup.bvec_data =3D sg_map(sg, 0, SG_KMAP_ATOMIC |
> +						 SG_MAP_MUST_NOT_FAIL);

I assume that sg_map already adds sg->offset to the address?

Also wondering whether we can get rid of bvec_off and just increment bvec_d=
ata,
adding Julien who IIRC added this code.

>  		}
>  =

>  		gnttab_foreach_grant_in_range(sg_page(sg),
> @@ -827,7 +828,7 @@ static int blkif_queue_rw_req(struct request *req, st=
ruct blkfront_ring_info *ri
>  					      &setup);
>  =

>  		if (setup.need_copy)
> -			kunmap_atomic(setup.bvec_data);
> +			sg_unmap(sg, setup.bvec_data, 0, SG_KMAP_ATOMIC);
>  	}
>  	if (setup.segments)
>  		kunmap_atomic(setup.segments);
> @@ -1053,7 +1054,7 @@ static int xen_translate_vdev(int vdevice, int *min=
or, unsigned int *offset)
>  		case XEN_SCSI_DISK5_MAJOR:
>  		case XEN_SCSI_DISK6_MAJOR:
>  		case XEN_SCSI_DISK7_MAJOR:
> -			*offset =3D (*minor / PARTS_PER_DISK) + =

> +			*offset =3D (*minor / PARTS_PER_DISK) +
>  				((major - XEN_SCSI_DISK1_MAJOR + 1) * 16) +
>  				EMULATED_SD_DISK_NAME_OFFSET;
>  			*minor =3D *minor +
> @@ -1068,7 +1069,7 @@ static int xen_translate_vdev(int vdevice, int *min=
or, unsigned int *offset)
>  		case XEN_SCSI_DISK13_MAJOR:
>  		case XEN_SCSI_DISK14_MAJOR:
>  		case XEN_SCSI_DISK15_MAJOR:
> -			*offset =3D (*minor / PARTS_PER_DISK) + =

> +			*offset =3D (*minor / PARTS_PER_DISK) +
>  				((major - XEN_SCSI_DISK8_MAJOR + 8) * 16) +
>  				EMULATED_SD_DISK_NAME_OFFSET;
>  			*minor =3D *minor +
> @@ -1119,7 +1120,7 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capac=
ity,
>  	if (!VDEV_IS_EXTENDED(info->vdevice)) {
>  		err =3D xen_translate_vdev(info->vdevice, &minor, &offset);
>  		if (err)
> -			return err;		=

> +			return err;

Cosmetic changes should go in a separate patch please.

Roger.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
