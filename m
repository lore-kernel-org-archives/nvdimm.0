Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B7492236BA95
 for <linux-nvdimm@lists.01.org>; Fri,  5 Jan 2018 10:09:47 -0800 (PST)
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-10-logang@deltatee.com>
 <281272464.115248600.1515166226009.JavaMail.zimbra@kalray.eu>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <a284e33f-c10d-0540-cd24-ad1993a042b6@deltatee.com>
Date: Fri, 5 Jan 2018 11:14:38 -0700
MIME-Version: 1.0
In-Reply-To: <281272464.115248600.1515166226009.JavaMail.zimbra@kalray.eu>
Content-Language: en-US
Subject: Re: [PATCH 09/12] nvme-pci: Use PCI p2pmem subsystem to manage the CMB
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
To: Marta Rybczynska <mrybczyn@kalray.eu>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 05/01/18 08:30 AM, Marta Rybczynska wrote:
>> @@ -429,10 +429,7 @@ static void __nvme_submit_cmd(struct nvme_queue *nvmeq,
>> {
>> 	u16 tail = nvmeq->sq_tail;
>>
>> -	if (nvmeq->sq_cmds_io)
>> -		memcpy_toio(&nvmeq->sq_cmds_io[tail], cmd, sizeof(*cmd));
>> -	else
>> -		memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
>> +	memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
>>
> 
> Why is it always memcpy() and not memcpy_toio()? I'd expect something like
> if (nvmeq->sq_cmds_is_io)
> 	memcpy_toio(&nvmeq->sq_cmds_io[tail], cmd, sizeof(*cmd));
> else
> 	memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));

We're going on the assumption that memory mapped with 
devm_memremap_pages() can be treated as regular memory. So memcpy_toio 
is not necessary for P2P memory.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
