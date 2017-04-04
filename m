Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD6152193930E
 for <linux-nvdimm@lists.01.org>; Tue,  4 Apr 2017 08:56:52 -0700 (PDT)
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-3-git-send-email-logang@deltatee.com>
 <f269d9e1-8dcf-7970-382e-cb0d9a020efc@grimberg.me>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <962a8dd8-4d09-0802-9569-00dbf29382d3@deltatee.com>
Date: Tue, 4 Apr 2017 09:56:48 -0600
MIME-Version: 1.0
In-Reply-To: <f269d9e1-8dcf-7970-382e-cb0d9a020efc@grimberg.me>
Subject: Re: [RFC 2/8] cxgb4: setup pcie memory window 4 and create p2pmem
 region
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
To: Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>



On 04/04/17 04:42 AM, Sagi Grimberg wrote:
> This is weird, why even call this if !use_p2pmem?

I personally find it cleaner than:

if (use_p2pmem)
	setup_memwin_p2pmem(...)

I'm not sure why that's so weird.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
