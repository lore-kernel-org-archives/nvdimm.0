Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 300002110BD65
 for <linux-nvdimm@lists.01.org>; Fri, 31 Aug 2018 08:42:22 -0700 (PDT)
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-14-logang@deltatee.com>
 <ecbb669a-2e84-1333-7e0d-1560cf014750@grimberg.me>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <ee3d5c87-4dff-edfb-1f85-958571cb1fef@deltatee.com>
Date: Fri, 31 Aug 2018 09:41:51 -0600
MIME-Version: 1.0
In-Reply-To: <ecbb669a-2e84-1333-7e0d-1560cf014750@grimberg.me>
Content-Language: en-US
Subject: Re: [PATCH v5 13/13] nvmet: Optionally use PCI P2P memory
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
To: Sagi Grimberg <sagi@grimberg.me>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Steve Wise <swise@opengridcomputing.com>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Thanks, for the review.

On 30/08/18 06:25 PM, Sagi Grimberg wrote:
>> +	if (req->port->p2p_dev) {
>> +		if (!pci_p2pdma_assign_provider(req->port->p2p_dev,
>> +						&ctrl->p2p_clients)) {
>> +			pr_info("peer-to-peer memory on %s is not supported\n",
>> +				pci_name(req->port->p2p_dev));
>> +			goto free_devices;
>> +		}
>> +		ctrl->p2p_dev = pci_dev_get(req->port->p2p_dev);
>> +	} else {
> 
> When is port->p2p_dev == NULL? a little more documentation would help 
> here...

In the configfs functions, if the user enables p2p (port->use_p2pmem)
using 'auto' or 'y' then port->p2p_dev will be NULL. If the user sets a
specific p2p_dev to use, port->p2p_dev will be set to that device. I can
add a couple comments in the next version.

Logan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
