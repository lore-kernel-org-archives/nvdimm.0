Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 35E3821954068
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 00:48:51 -0700 (PDT)
Date: Wed, 26 Apr 2017 09:48:48 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 02/21] libiscsi: Add an internal error code
Message-ID: <20170426074848.GA8081@lst.de>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-3-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1493144468-22493-3-git-send-email-logang@deltatee.com>
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
Cc: dri-devel@lists.freedesktop.org, dm-devel@redhat.com, target-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, devel@driverdev.osuosl.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, netdev@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 25, 2017 at 12:20:49PM -0600, Logan Gunthorpe wrote:
> This is a prep patch to add a new error code to libiscsi. We want to
> rework some kmap calls to be able to fail. When we do, we'd like to
> use this error code.

The kmap case in iscsi_tcp_segment_map can already fail.  Please add
handling of that failure to this patch, and we should get it merged
ASAP.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
