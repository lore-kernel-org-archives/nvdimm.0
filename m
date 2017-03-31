Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 489A121BC6A24
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 08:42:01 -0700 (PDT)
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-6-git-send-email-logang@deltatee.com>
 <20170331070950.GA9059@infradead.org>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <435d4471-436b-87e6-8827-c9fc6cbdde2c@deltatee.com>
Date: Fri, 31 Mar 2017 09:41:56 -0600
MIME-Version: 1.0
In-Reply-To: <20170331070950.GA9059@infradead.org>
Subject: Re: [RFC 5/8] scatterlist: Modify SG copy functions to support io
 memory.
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, linux-scsi@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 31/03/17 01:09 AM, Christoph Hellwig wrote:
> You're calling memcpy_{to,from}_iomem on non-__iomem pointers.  This
> is a fundamental no-go as we keep I/O memory separate from kernel
> pointers.

Yes, that's true, however I don't know how we could get around that when
the iomem is referenced by struct pages inside a scatter gather list. Do
we need to now have special __iomem sgls? And even still, I'm not sure
how that could work when the nvme target code is using the same sgls to
sometimes point to iomem and sometimes point to regular memory.

I'm certainly open to suggestions, though.

Logan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
