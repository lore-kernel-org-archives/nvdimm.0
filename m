Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from zimbra1.kalray.eu (zimbra1.kalray.eu [92.103.151.219])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0DA29222EDCD8
 for <linux-nvdimm@lists.01.org>; Fri,  5 Jan 2018 07:25:25 -0800 (PST)
Date: Fri, 5 Jan 2018 16:30:26 +0100 (CET)
From: Marta Rybczynska <mrybczyn@kalray.eu>
Message-ID: <281272464.115248600.1515166226009.JavaMail.zimbra@kalray.eu>
In-Reply-To: <20180104190137.7654-10-logang@deltatee.com>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-10-logang@deltatee.com>
Subject: Re: [PATCH 09/12] nvme-pci: Use PCI p2pmem subsystem to manage the CMB
MIME-Version: 1.0
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
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

> @@ -429,10 +429,7 @@ static void __nvme_submit_cmd(struct nvme_queue *nvmeq,
> {
> 	u16 tail = nvmeq->sq_tail;
> 
> -	if (nvmeq->sq_cmds_io)
> -		memcpy_toio(&nvmeq->sq_cmds_io[tail], cmd, sizeof(*cmd));
> -	else
> -		memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
> +	memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
> 

Why is it always memcpy() and not memcpy_toio()? I'd expect something like
if (nvmeq->sq_cmds_is_io)
	memcpy_toio(&nvmeq->sq_cmds_io[tail], cmd, sizeof(*cmd));
else
	memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));

Marta
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
