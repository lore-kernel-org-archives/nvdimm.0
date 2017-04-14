Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6A87D2194EB64
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 01:36:09 -0700 (PDT)
Date: Fri, 14 Apr 2017 10:36:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/22] libiscsi: Make use of new the sg_map helper function
Message-ID: <20170414083607.GB25471@lst.de>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-4-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1492121135-4437-4-git-send-email-logang@deltatee.com>
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
Cc: Steve Wise <swise@opengridcomputing.com>, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, devel@driverdev.osuosl.org, rds-devel@oss.oracle.com, linux-scsi@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, Ming Lin <ming.l@ssi.samsung.com>, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, dri-devel@lists.freedesktop.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, linaro-mm-sig@lists.linaro.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-nvdimm@lists.01.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 13, 2017 at 04:05:16PM -0600, Logan Gunthorpe wrote:
> Convert the kmap and kmap_atomic uses to the sg_map function. We now
> store the flags for the kmap instead of a boolean to indicate
> atomicitiy. We also propogate a possible kmap error down and create
> a new ISCSI_TCP_INTERNAL_ERR error type for this.

Can you split out the new error handling into a separate prep patch
which should go to the iscsi maintainers ASAP?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
