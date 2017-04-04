Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr0-f194.google.com (mail-wr0-f194.google.com
 [209.85.128.194])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8EB992193930D
 for <linux-nvdimm@lists.01.org>; Tue,  4 Apr 2017 03:59:31 -0700 (PDT)
Received: by mail-wr0-f194.google.com with SMTP id w43so41145411wrb.1
 for <linux-nvdimm@lists.01.org>; Tue, 04 Apr 2017 03:59:31 -0700 (PDT)
Subject: Re: [RFC 6/8] nvmet: Be careful about using iomem accesses when
 dealing with p2pmem
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-7-git-send-email-logang@deltatee.com>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <080b68b4-eba3-861c-4f29-5d829425b5e7@grimberg.me>
Date: Tue, 4 Apr 2017 13:59:26 +0300
MIME-Version: 1.0
In-Reply-To: <1490911959-5146-7-git-send-email-logang@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>


>  u16 nvmet_copy_to_sgl(struct nvmet_req *req, off_t off, const void *buf,
>  		size_t len)
>  {
> -	if (sg_pcopy_from_buffer(req->sg, req->sg_cnt, buf, len, off) != len)
> +	bool iomem = req->p2pmem;
> +	size_t ret;
> +
> +	ret = sg_copy_buffer(req->sg, req->sg_cnt, (void *)buf, len, off,
> +			     false, iomem);
> +
> +	if (ret != len)
>  		return NVME_SC_SGL_INVALID_DATA | NVME_SC_DNR;
> +
>  	return 0;
>  }

We can never ever get here from an IO command, and that is a good thing
because it would have been broken if we did, regardless of what copy
method we use...

Note that the nvme completion queues are still on the host memory, so
this means we have lost the ordering between data and completions as
they go to different pcie targets.

If at all, this is the place to *emphasize* we must never get here
with p2pmem, and immediately fail if we do.

I'm not sure what will happen with to copy_from_sgl, I guess we
have the same race because the nvme submission queues are also
on the host memory (which is on a different pci target). Maybe
more likely to happen with write-combine enabled?

Anyway I don't think we have a real issue here *currently*, because
we use copy_to_sgl only for admin/fabrics commands emulation and
copy_from_sgl to setup dsm ranges...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
