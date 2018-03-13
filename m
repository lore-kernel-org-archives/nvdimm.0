Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9C5362244888F
 for <linux-nvdimm@lists.01.org>; Mon, 12 Mar 2018 18:49:10 -0700 (PDT)
Subject: Re: [PATCH v3 08/11] nvme-pci: Use PCI p2pmem subsystem to manage the
 CMB
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-9-logang@deltatee.com>
From: Sinan Kaya <okaya@codeaurora.org>
Message-ID: <4b08ec0b-76f4-4b67-a38b-5a1940c4c40d@codeaurora.org>
Date: Mon, 12 Mar 2018 21:55:27 -0400
MIME-Version: 1.0
In-Reply-To: <20180312193525.2855-9-logang@deltatee.com>
Content-Language: en-US
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
To: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On 3/12/2018 3:35 PM, Logan Gunthorpe wrote:
> -	if (nvmeq->sq_cmds_io)

I think you should keep the code as it is for the case where
(!nvmeq->sq_cmds_is_io && nvmeq->sq_cmds_io)

You are changing the behavior for NVMe drives with CMB buffers.
You can change the if statement here with the statement above.

> -		memcpy_toio(&nvmeq->sq_cmds_io[tail], cmd, sizeof(*cmd));
> -	else
> -		memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
> +	memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
>  


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
