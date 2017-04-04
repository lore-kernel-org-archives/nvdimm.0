Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr0-f193.google.com (mail-wr0-f193.google.com
 [209.85.128.193])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 920FE219392FD
 for <linux-nvdimm@lists.01.org>; Tue,  4 Apr 2017 03:46:14 -0700 (PDT)
Received: by mail-wr0-f193.google.com with SMTP id u18so41062527wrc.0
 for <linux-nvdimm@lists.01.org>; Tue, 04 Apr 2017 03:46:14 -0700 (PDT)
Subject: Re: [RFC 4/8] p2pmem: Add debugfs "stats" file
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-5-git-send-email-logang@deltatee.com>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <95928b70-0148-7297-8f5e-5031d996bb98@grimberg.me>
Date: Tue, 4 Apr 2017 13:46:09 +0300
MIME-Version: 1.0
In-Reply-To: <1490911959-5146-5-git-send-email-logang@deltatee.com>
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


> +	p2pmem_debugfs_root = debugfs_create_dir("p2pmem", NULL);
> +	if (!p2pmem_debugfs_root)
> +		pr_info("could not create debugfs entry, continuing\n");
> +

Why continue? I think it'd be better to just fail it.

Besides, this can be safely squashed into patch 1.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
