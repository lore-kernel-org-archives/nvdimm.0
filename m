Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr0-f195.google.com (mail-wr0-f195.google.com
 [209.85.128.195])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E21E4219392FD
 for <linux-nvdimm@lists.01.org>; Tue,  4 Apr 2017 03:43:02 -0700 (PDT)
Received: by mail-wr0-f195.google.com with SMTP id u18so41039146wrc.0
 for <linux-nvdimm@lists.01.org>; Tue, 04 Apr 2017 03:43:02 -0700 (PDT)
Subject: Re: [RFC 2/8] cxgb4: setup pcie memory window 4 and create p2pmem
 region
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-3-git-send-email-logang@deltatee.com>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <f269d9e1-8dcf-7970-382e-cb0d9a020efc@grimberg.me>
Date: Tue, 4 Apr 2017 13:42:57 +0300
MIME-Version: 1.0
In-Reply-To: <1490911959-5146-3-git-send-email-logang@deltatee.com>
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


> +static void setup_memwin_p2pmem(struct adapter *adap)
> +{
> +	unsigned int mem_base = t4_read_reg(adap, CIM_EXTMEM2_BASE_ADDR_A);
> +	unsigned int mem_size = t4_read_reg(adap, CIM_EXTMEM2_ADDR_SIZE_A);
> +
> +	if (!use_p2pmem)
> +		return;

This is weird, why even call this if !use_p2pmem?

> +static int init_p2pmem(struct adapter *adapter)
> +{
> +	unsigned int mem_size = t4_read_reg(adapter, CIM_EXTMEM2_ADDR_SIZE_A);
> +	struct p2pmem_dev *p;
> +	int rc;
> +	struct resource res;
> +
> +	if (!mem_size || !use_p2pmem)
> +		return 0;

Again, weird...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
