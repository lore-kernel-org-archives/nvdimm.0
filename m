Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 207D921A04811
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 21:59:54 -0700 (PDT)
Date: Fri, 14 Apr 2017 06:59:51 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/22] nvmet: Make use of the new sg_map helper function
Message-ID: <20170414045951.GA22206@lst.de>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-3-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1492121135-4437-3-git-send-email-logang@deltatee.com>
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

On Thu, Apr 13, 2017 at 04:05:15PM -0600, Logan Gunthorpe wrote:
> This is a straight forward conversion in two places. Should kmap fail,
> the code will return an INVALD_DATA error in the completion.

It really should be using nvmet_copy_from_sgl to make things safer,
as we don't want to rely on any particular SG list layout.  In fact
I'm pretty sure I did the conversion at some point, but it must never
have made it upstream.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
