Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE19F21A04811
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 22:18:45 -0700 (PDT)
Date: Fri, 14 Apr 2017 07:18:43 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/22] nvmet: Make use of the new sg_map helper function
Message-ID: <20170414051843.GA22537@lst.de>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-3-git-send-email-logang@deltatee.com>
 <20170414045951.GA22206@lst.de>
 <4df3e41b-591e-a500-a428-4bc529224030@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4df3e41b-591e-a500-a428-4bc529224030@deltatee.com>
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

On Thu, Apr 13, 2017 at 11:06:16PM -0600, Logan Gunthorpe wrote:
> Or maybe I'll just send a patch for that
> separately seeing it doesn't depend on anything and is pretty simple. I
> can do that next week.

Yes, please just send that patch linux-nvme, we should be able to get
it into 4.12.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
