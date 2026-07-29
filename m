Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E973D75A4
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 19:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785354250; cv=pass; b=J3J7jmT2L8b6PcjZwtzPi7+D8aVfJ2vVsyqP1357PamPfPh34tfDW67zwy5Hhf3ERSFiDyjENDk5qJK6nOS29YaSlfwk/nYUb+fATtolnsogyyWXMD+7seS09vov8z6/4IEaZXWs/cWBiLWS8KSS8cKxgxOIB3/wg5REyJRx824=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785354250; c=relaxed/simple;
	bh=z5prSsmGreU+ARDbc2TiWvp5IrCc0YZDiE0i+rJkl44=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nicPjV4uwXhQevt50777dBp0Hmj/axoeKM9bRnbZ+7FHBtFAkWVWdrWGg4xlP7JRpPlAGvQ9/uaZM/WXDbWw/URrmcchwMRSrHlRdVXNAWKk59+XMoo+IcrnJbqNiNjXwc3M73Ww1+1WUwlvBSE9Ifjm48A6evonw3X1VnW7Vlo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=QOl6diiJ; arc=pass smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="QOl6diiJ"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4ab246dfc90so81688b6e.0
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 12:44:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785354241; cv=none;
        d=google.com; s=arc-20260327;
        b=W9fupcN9eobuQGV672fdbR0BFaywl3BE5YIYCo4icB8BtGfl/rbZ2OKQunQIp2anZl
         rZE3/V2AacoMzWDfrOvVdHLuXFFgPmXazIaGJriUMIq23qjy/f4N2BktH71QCPVlpfbi
         qARX/eAcyPwBW5Oq+WFxRiHE41K5I3quBRRmN9Rj8vQdp7tDn6HCrxrKpObkQbyNYt1m
         pGu044nwjRiEOp0mid2BIxVJ9vLNXawKxTPF0+uHIijYHsUCow5+u5ztxYjw6tOLrga7
         UJUCShQUHVINSlms8GunCY10Y6DCFl+92rXyLaxFjiGFafw9XNl6ACUevU8Qj32aEIyu
         exUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LnSKdBsI5P4yNxKlVDAgX6ZRyHfaTBwJq6vRswotV/I=;
        fh=ncGcwJxymg3U6ZtAkknW23jx/rTqjESt0I0DgEEvWZg=;
        b=WAff1lA2ERziKuhoBKeRzkwbzs9mzr1KzuOtKFqoPE24cU6V04cu7/bVgLLURYJFzc
         a2IuMjv+TRMKZCKimmA1HqaodVeaTPdADbJkO4ErGBIw58hEz82hBu9dTghM6DAo8qba
         8sb5XGX+OPjR8eMU/MS/kjasY/eAx9dRfNEDlEc5ZG0DEvO5Tw36adXP63tcPx0XjxdY
         +P5nARG6nM9RQqdnbOwJxgGZm8aFlPF/PmWJYbFobAmn4BtEq6vODh4SCvbSDsvocohI
         2pyRlt2Khc/oGtHGNnoF+aGGeWuYVBzUQd0vKtvkMcnNtcvCPzwIGGZN9pNFimC81W4k
         2ocQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1785354241; x=1785959041; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LnSKdBsI5P4yNxKlVDAgX6ZRyHfaTBwJq6vRswotV/I=;
        b=QOl6diiJG2mBbndXDWdPCsINX8APxeymXjnyml0ZTk1jNPceJsntC7JqVsASzKK+Fz
         pLfxmmaM9XktMB91AWcBeqWDzei4PSDkWz0E1PCmF4wRC4hNSjjkIYwZCW5RqMATRrLW
         WtpPKzCKM0ep28S7nBC0e5ubHBQQOGC41Nf/6WmMwhiC4Ui8fw+kbD4+UVGtgrHPb0XZ
         tkRq1ZVzBJNnFbHvxxvfTR2nVDecEc4/eh/4L7AvLtjjQv4daLZ0TOzlTg2HdoElJR0K
         BDTuqWYyzPU3Ly7B5ogJfU27ZInO9ohkgpwb29mj+vV/upT1lRriYQUzN+48+f0bXQtB
         DaCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785354241; x=1785959041;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LnSKdBsI5P4yNxKlVDAgX6ZRyHfaTBwJq6vRswotV/I=;
        b=RyMBVDzDcxt6BmGRz9SaVuQYS8kOzhaVnByfAw9p085Xd83QE7NQHMzXPWkFDSb/t0
         NGstu7QaMHRJSLZZlhaeCqIkcTCYjBNfDL/Z5ClouBgM/0JVOCLjpT/Hl78hOI8ytdox
         AUEftfjtoZ5dktjWv0JPA66JE/m4c34EstrdkVfco/88IMoHuBWgb68niGRjbhpy7f7T
         3ZfEWBAmTwRXl9u0iRvJuXs7jQd4i26vFkEJPGtmAW7ue/MYowmNq2ZAZf1FOygG3Uyv
         1Uj83IoUdHbJwsDKkmznhzDQHJZ8JssBcWIQtGan4WbJC17sfHEsfFTgBiwx2koA9/jl
         ELLg==
X-Forwarded-Encrypted: i=1; AHgh+RobuFr4hl3lGoDopHGlxoZy85gVIv2Aj/qGPzpDP/47rPUbR817ypyGgyo6VxpOoj6WtNPBSZk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJEgSjjRphPexbs2em+eUad+K/6eELh/tN0hFfFXoOfSNsx5VP
	isEQXrs7/I19E+NbbZLuYPoA326dXhK8iI61PkgSy3jnULQgr7u197Rj5mu2nq1SvoT2lbiRtzY
	uOAu4F3rVBbofw0UTuVS43YQJHDGsCYGe0dxGkgD7TQ==
X-Gm-Gg: AR+sD10tnuhmymyhQQgehghcyFAx9YcaiRMiIGRq6/RZb6qhoxdFcLhWSXXLAyuHNU1
	vQDILnChOPPmZQS4EMfb3IYXz2PmC7Z9VoiyFnNMQrvGtF3BGoz4juRuRR3vMqLSJea5LvAfn0x
	lCnNkx2JcV9rLVchSmLy29Y8LPHxofiYBCIJpFdeTpX37oED4UjScvkRruHWbk3IQfkrZ+LuqPW
	bNedu2r9gmiIi6knUkAWTknbgb0E+vbzgcewshjrPqUCoMBnpmoV3qgiFQ+TvVhCIB52W46JGpV
	zNge9Mo+xYDsvwjBb6hr06cmwBcMax0Irsth1K3jT8zB
X-Received: by 2002:a05:6871:441:b0:457:9007:a35f with SMTP id
 586e51a60fabf-458bc1eaa28mr97408fac.1.1785354241430; Wed, 29 Jul 2026
 12:44:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785274111.git.asml.silence@gmail.com> <19e5c945ea8114320c10f7951d19197d48b59249.1785274111.git.asml.silence@gmail.com>
In-Reply-To: <19e5c945ea8114320c10f7951d19197d48b59249.1785274111.git.asml.silence@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 29 Jul 2026 12:43:50 -0700
X-Gm-Features: AUfX_mzj7jaY2dlfE4GHJvNcQHfDZNxuFZTdOCDHOZZK5KuWQBBj743IB8eIF1Q
Message-ID: <CADUfDZpwF0jp2e=+c3w_NjWPbnQ858bkSD731M6+x27jzgcJiw@mail.gmail.com>
Subject: Re: [PATCH v4 08/14] nvme-pci: implement dma_token backed requests
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>, 
	William Power <william.power@intel.com>, Phil Cayton <phil.cayton@intel.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	David Sterba <dsterba@suse.com>, Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev, 
	nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 2:35=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> Enable BIO_DMABUF_MAP backed requests. It creates a prp list for the
> dmabuf when it's mapped, which is then used to initialise requests.
>
> Suggested-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  drivers/nvme/host/core.c |  12 ++
>  drivers/nvme/host/nvme.h |   2 +
>  drivers/nvme/host/pci.c  | 259 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 273 insertions(+)
>
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 453c1f0b2dd0..ce66a1843bec 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -2676,6 +2676,17 @@ static int nvme_report_zones(struct gendisk *disk,=
 sector_t sector,
>  #define nvme_report_zones      NULL
>  #endif /* CONFIG_BLK_DEV_ZONED */
>
> +static int nvme_init_dma_buf_io_ctx(struct block_device *bdev,
> +                                   struct dma_buf_io_ctx *ctx)
> +{
> +       struct nvme_ns *ns =3D bdev->bd_disk->private_data;
> +       struct nvme_ctrl *ctrl =3D ns->ctrl;
> +
> +       if (!ctrl->ops->init_dma_buf_io_ctx)
> +               return -EINVAL;
> +       return ctrl->ops->init_dma_buf_io_ctx(ctrl, ctx);
> +}
> +
>  const struct block_device_operations nvme_bdev_ops =3D {
>         .owner          =3D THIS_MODULE,
>         .ioctl          =3D nvme_ioctl,
> @@ -2686,6 +2697,7 @@ const struct block_device_operations nvme_bdev_ops =
=3D {
>         .get_unique_id  =3D nvme_get_unique_id,
>         .report_zones   =3D nvme_report_zones,
>         .pr_ops         =3D &nvme_pr_ops,
> +       .init_dma_buf_io_ctx =3D nvme_init_dma_buf_io_ctx,
>  };
>
>  static int nvme_wait_ready(struct nvme_ctrl *ctrl, u32 mask, u32 val,
> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
> index 824651cc898d..034c31af8fec 100644
> --- a/drivers/nvme/host/nvme.h
> +++ b/drivers/nvme/host/nvme.h
> @@ -652,6 +652,8 @@ struct nvme_ctrl_ops {
>         int (*get_address)(struct nvme_ctrl *ctrl, char *buf, int size);
>         void (*print_device_info)(struct nvme_ctrl *ctrl);
>         bool (*supports_pci_p2pdma)(struct nvme_ctrl *ctrl);
> +       int (*init_dma_buf_io_ctx)(struct nvme_ctrl *ctrl,
> +                                  struct dma_buf_io_ctx *ctx);
>         unsigned long (*get_virt_boundary)(struct nvme_ctrl *ctrl, bool i=
s_admin);
>  };
>
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index 69932d640b53..f1b67c191892 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -27,6 +27,8 @@
>  #include <linux/io-64-nonatomic-lo-hi.h>
>  #include <linux/io-64-nonatomic-hi-lo.h>
>  #include <linux/sed-opal.h>
> +#include <linux/dma-buf-io.h>
> +#include <linux/dma-resv.h>
>
>  #include "trace.h"
>  #include "nvme.h"
> @@ -393,6 +395,13 @@ struct nvme_queue {
>         struct completion delete_done;
>  };
>
> +struct nvme_dmabuf_map {
> +       struct dma_buf_io_map base;
> +       struct sg_table *sgt;
> +       unsigned nr_entries;
> +       dma_addr_t dma_list[];
> +};
> +
>  /* bits for iod->flags */
>  enum nvme_iod_flags {
>         /* this command has been aborted by the timeout handler */
> @@ -859,6 +868,138 @@ static void nvme_free_descriptors(struct request *r=
eq)
>         }
>  }
>
> +static inline struct nvme_dmabuf_map *
> +to_nvme_dmabuf_map(struct dma_buf_io_map *map)
> +{
> +       return container_of(map, struct nvme_dmabuf_map, base);
> +}
> +
> +static void nvme_dmabuf_map_sync_for_cpu(struct nvme_dev *nvme_dev,
> +                                        struct request *req)
> +{
> +       struct device *dev =3D nvme_dev->dev;
> +       enum dma_data_direction dma_dir;
> +       struct bio *bio =3D req->bio;
> +       struct nvme_dmabuf_map *map =3D to_nvme_dmabuf_map(bio->bi_dmabuf=
_map);
> +       dma_addr_t *dma_list =3D map->dma_list;
> +       unsigned offset =3D bio->bi_iter.bi_offset;
> +       unsigned map_idx =3D offset / NVME_CTRL_PAGE_SIZE;
> +       int length =3D blk_rq_payload_bytes(req) +
> +                    (offset & (NVME_CTRL_PAGE_SIZE - 1));
> +
> +       dma_dir =3D rq_data_dir(req) =3D=3D READ ? DMA_FROM_DEVICE : DMA_=
TO_DEVICE;
> +
> +       while (length > 0) {
> +               dma_sync_single_for_cpu(dev, dma_list[map_idx++],
> +                                       NVME_CTRL_PAGE_SIZE, dma_dir);
> +               length -=3D NVME_CTRL_PAGE_SIZE;
> +       }
> +}
> +
> +static void nvme_dmabuf_map_sync_for_device(struct nvme_dev *nvme_dev,
> +                                           struct request *req)
> +{
> +       struct device *dev =3D nvme_dev->dev;
> +       enum dma_data_direction dma_dir;
> +       struct bio *bio =3D req->bio;
> +       struct nvme_dmabuf_map *map =3D to_nvme_dmabuf_map(bio->bi_dmabuf=
_map);
> +       dma_addr_t *dma_list =3D map->dma_list;
> +       unsigned offset =3D bio->bi_iter.bi_offset;
> +       unsigned map_idx =3D offset / NVME_CTRL_PAGE_SIZE;
> +       int length =3D blk_rq_payload_bytes(req) +
> +                    (offset & (NVME_CTRL_PAGE_SIZE - 1));
> +
> +       dma_dir =3D rq_data_dir(req) =3D=3D READ ? DMA_FROM_DEVICE : DMA_=
TO_DEVICE;
> +
> +       while (length > 0) {
> +               dma_sync_single_for_device(dev, dma_list[map_idx++],
> +                                          NVME_CTRL_PAGE_SIZE, dma_dir);
> +               length -=3D NVME_CTRL_PAGE_SIZE;
> +       }
> +}
> +
> +static void nvme_rq_clean_dmabuf_map(struct nvme_dev *dev,
> +                                     struct request *req)
> +{
> +       struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
> +
> +       nvme_dmabuf_map_sync_for_cpu(dev, req);
> +
> +       if (!(iod->flags & IOD_SINGLE_SEGMENT))
> +               nvme_free_descriptors(req);
> +}
> +
> +static blk_status_t nvme_rq_setup_dmabuf_map(struct request *req,
> +                                            struct nvme_queue *nvmeq)
> +{
> +       struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
> +       struct bio *bio =3D req->bio;
> +       struct nvme_dmabuf_map *map =3D to_nvme_dmabuf_map(bio->bi_dmabuf=
_map);
> +       unsigned bvec_done =3D bio->bi_iter.bi_offset;
> +       unsigned map_idx =3D bvec_done / NVME_CTRL_PAGE_SIZE;
> +       unsigned offset =3D bvec_done & (NVME_CTRL_PAGE_SIZE - 1);
> +       int length =3D blk_rq_payload_bytes(req) - (NVME_CTRL_PAGE_SIZE -=
 offset);
> +       dma_addr_t *dma_list =3D map->dma_list;
> +       u64 prp1_dma =3D dma_list[map_idx++] + offset;
> +       u64 dma_addr, prp2_dma;
> +       dma_addr_t prp_dma;
> +       __le64 *prp_list;
> +       unsigned i;
> +
> +       nvme_dmabuf_map_sync_for_device(nvmeq->dev, req);
> +
> +       if (length <=3D 0) {
> +               prp2_dma =3D 0;
> +               goto done;
> +       }
> +
> +       if (length <=3D NVME_CTRL_PAGE_SIZE) {
> +               prp2_dma =3D dma_list[map_idx];
> +               goto done;
> +       }
> +
> +       if (DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE) <=3D
> +           NVME_SMALL_POOL_SIZE / sizeof(__le64))
> +               iod->flags |=3D IOD_SMALL_DESCRIPTOR;
> +
> +       prp_list =3D dma_pool_alloc(nvme_dma_pool(nvmeq, iod), GFP_ATOMIC=
,
> +                       &prp_dma);

I wonder if it's possible to perform the PRP list page allocations and
initialization in nvme_dma_buf_io_map() instead of the I/O path. The
NVMe dma_pools are per-NUMA-node linked lists protected by spinlocks,
making them significant CPU hotspots. If the dmabuf registration set
up a contiguous DMA-coherent list of PRP entries for the pages of the
registered buffer, any command using the dmabuf and requiring at most
1 PRP list page (i.e. length <=3D 2 MB) could just set its PRP list
pointer to an offset into the dmabuf's PRP list.

Best,
Caleb


> +       if (!prp_list)
> +               return BLK_STS_RESOURCE;
> +
> +       iod->descriptors[iod->nr_descriptors++] =3D prp_list;
> +       prp2_dma =3D prp_dma;
> +       i =3D 0;
> +       for (;;) {
> +               if (i =3D=3D NVME_CTRL_PAGE_SIZE >> 3) {
> +                       __le64 *old_prp_list =3D prp_list;
> +
> +                       prp_list =3D dma_pool_alloc(nvmeq->descriptor_poo=
ls.large,
> +                                       GFP_ATOMIC, &prp_dma);
> +                       if (!prp_list)
> +                               goto free_prps;
> +                       iod->descriptors[iod->nr_descriptors++] =3D prp_l=
ist;
> +                       prp_list[0] =3D old_prp_list[i - 1];
> +                       old_prp_list[i - 1] =3D cpu_to_le64(prp_dma);
> +                       i =3D 1;
> +               }
> +
> +               dma_addr =3D dma_list[map_idx++];
> +               prp_list[i++] =3D cpu_to_le64(dma_addr);
> +
> +               length -=3D NVME_CTRL_PAGE_SIZE;
> +               if (length <=3D 0)
> +                       break;
> +       }
> +done:
> +       iod->cmd.common.dptr.prp1 =3D cpu_to_le64(prp1_dma);
> +       iod->cmd.common.dptr.prp2 =3D cpu_to_le64(prp2_dma);
> +       return BLK_STS_OK;
> +free_prps:
> +       nvme_free_descriptors(req);
> +       return BLK_STS_RESOURCE;
> +}
> +
>  static void nvme_free_prps(struct request *req, unsigned int attrs)
>  {
>         struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
> @@ -937,6 +1078,11 @@ static void nvme_unmap_data(struct request *req)
>         struct device *dma_dev =3D nvmeq->dev->dev;
>         unsigned int attrs =3D 0;
>
> +       if (blk_mq_rq_is_dmabuf(req)) {
> +               nvme_rq_clean_dmabuf_map(nvmeq->dev, req);
> +               return;
> +       }
> +
>         if (iod->flags & IOD_SINGLE_SEGMENT) {
>                 static_assert(offsetof(union nvme_data_ptr, prp1) =3D=3D
>                                 offsetof(union nvme_data_ptr, sgl.addr));
> @@ -1251,6 +1397,9 @@ static blk_status_t nvme_map_data(struct request *r=
eq)
>         struct blk_dma_iter iter;
>         blk_status_t ret;
>
> +       if (blk_mq_rq_is_dmabuf(req))
> +               return nvme_rq_setup_dmabuf_map(req, nvmeq);
> +
>         /*
>          * Try to skip the DMA iterator for single segment requests, as t=
hat
>          * significantly improves performances for small I/O sizes.
> @@ -2269,6 +2418,112 @@ static int nvme_create_queue(struct nvme_queue *n=
vmeq, int qid, bool polled)
>         return result;
>  }
>
> +#if defined(CONFIG_DMA_SHARED_BUFFER)
> +static void nvme_dmabuf_invalidate_mappings(struct dma_buf_attachment *a=
ttach)
> +{
> +       struct dma_buf_io_ctx *ctx =3D attach->importer_priv;
> +
> +       dma_buf_io_invalidate_mappings(ctx);
> +}
> +
> +const struct dma_buf_attach_ops nvme_dmabuf_importer_ops =3D {
> +       .invalidate_mappings    =3D nvme_dmabuf_invalidate_mappings,
> +       .allow_peer2peer        =3D true,
> +};
> +
> +static struct dma_buf_io_map *nvme_dma_buf_io_map(struct dma_buf_io_ctx =
*ctx)
> +{
> +       unsigned nr_entries =3D ctx->dmabuf->size / NVME_CTRL_PAGE_SIZE;
> +       struct dma_buf_attachment *attach =3D ctx->dev_priv;
> +       unsigned long tmp, i =3D 0;
> +       struct nvme_dmabuf_map *map;
> +       struct scatterlist *sg;
> +       struct sg_table *sgt;
> +       int ret;
> +
> +       dma_resv_assert_held(ctx->dmabuf->resv);
> +
> +       map =3D kmalloc_flex(*map, dma_list, nr_entries);
> +       if (!map)
> +               return ERR_PTR(-ENOMEM);
> +
> +       sgt =3D dma_buf_map_attachment(attach, ctx->dir);
> +       if (IS_ERR(sgt)) {
> +               ret =3D PTR_ERR(sgt);
> +               sgt =3D NULL;
> +               goto err;
> +       }
> +
> +       for_each_sgtable_dma_sg(sgt, sg, tmp) {
> +               dma_addr_t dma_addr =3D sg_dma_address(sg);
> +               unsigned long sg_len =3D sg_dma_len(sg);
> +
> +               if (sg_len % NVME_CTRL_PAGE_SIZE) {
> +                       ret =3D -EINVAL;
> +                       goto err;
> +               }
> +
> +               while (sg_len) {
> +                       map->dma_list[i++] =3D dma_addr;
> +                       dma_addr +=3D NVME_CTRL_PAGE_SIZE;
> +                       sg_len -=3D NVME_CTRL_PAGE_SIZE;
> +               }
> +       }
> +
> +       ret =3D dma_buf_io_init_map(ctx, &map->base);
> +       if (ret)
> +               goto err;
> +       map->nr_entries =3D nr_entries;
> +       map->sgt =3D sgt;
> +       return &map->base;
> +err:
> +       if (sgt)
> +               dma_buf_unmap_attachment(attach, sgt, ctx->dir);
> +       kfree(map);
> +       return ERR_PTR(ret);
> +}
> +
> +static void nvme_dma_buf_io_unmap(struct dma_buf_io_ctx *ctx,
> +                                 struct dma_buf_io_map *map_base)
> +{
> +       struct dma_buf_attachment *attach =3D ctx->dev_priv;
> +       struct nvme_dmabuf_map *map =3D to_nvme_dmabuf_map(map_base);
> +
> +       dma_resv_assert_held(ctx->dmabuf->resv);
> +
> +       dma_buf_unmap_attachment(attach, map->sgt, ctx->dir);
> +}
> +
> +static void nvme_dma_buf_io_release(struct dma_buf_io_ctx *ctx)
> +{
> +       struct dma_buf_attachment *attach =3D ctx->dev_priv;
> +
> +       dma_buf_detach(ctx->dmabuf, attach);
> +}
> +
> +const struct dma_buf_io_ops nvme_dma_buf_io_ops =3D {
> +       .map            =3D nvme_dma_buf_io_map,
> +       .unmap          =3D nvme_dma_buf_io_unmap,
> +       .release        =3D nvme_dma_buf_io_release,
> +};
> +
> +static int nvme_pci_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
> +                                       struct dma_buf_io_ctx *ctx)
> +{
> +       struct dma_buf_attachment *attach;
> +       struct nvme_dev *dev =3D to_nvme_dev(ctrl);
> +
> +       attach =3D dma_buf_dynamic_attach(ctx->dmabuf, dev->dev,
> +                                       &nvme_dmabuf_importer_ops, ctx);
> +       if (IS_ERR(attach))
> +               return PTR_ERR(attach);
> +
> +       ctx->dev_priv =3D attach;
> +       ctx->dev_ops =3D &nvme_dma_buf_io_ops;
> +       return 0;
> +}
> +#endif
> +
>  static const struct blk_mq_ops nvme_mq_admin_ops =3D {
>         .queue_rq       =3D nvme_queue_rq,
>         .complete       =3D nvme_pci_complete_rq,
> @@ -3563,6 +3818,9 @@ static const struct nvme_ctrl_ops nvme_pci_ctrl_ops=
 =3D {
>         .print_device_info      =3D nvme_pci_print_device_info,
>         .supports_pci_p2pdma    =3D nvme_pci_supports_pci_p2pdma,
>         .get_virt_boundary      =3D nvme_pci_get_virt_boundary,
> +#if defined(CONFIG_DMA_SHARED_BUFFER)
> +       .init_dma_buf_io_ctx    =3D nvme_pci_init_dma_buf_io_ctx,
> +#endif
>  };
>
>  static int nvme_dev_map(struct nvme_dev *dev)
> @@ -4327,5 +4585,6 @@ MODULE_AUTHOR("Matthew Wilcox <willy@linux.intel.co=
m>");
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION("1.0");
>  MODULE_DESCRIPTION("NVMe host PCIe transport driver");
> +MODULE_IMPORT_NS("DMA_BUF");
>  module_init(nvme_init);
>  module_exit(nvme_exit);
> --
> 2.54.0
>
>
