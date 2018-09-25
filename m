Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 990EB21AE30DB
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 11:15:32 -0700 (PDT)
References: <20180925162231.4354-1-logang@deltatee.com>
 <20180925162231.4354-3-logang@deltatee.com>
 <1537896555.11137.22.camel@acm.org>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <9241a6af-9826-d1ff-c13b-882cb3b6a34a@deltatee.com>
Date: Tue, 25 Sep 2018 12:15:19 -0600
MIME-Version: 1.0
In-Reply-To: <1537896555.11137.22.camel@acm.org>
Content-Language: en-US
Subject: Re: [PATCH v7 02/13] PCI/P2PDMA: Add sysfs group to display p2pmem
 stats
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
To: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 2018-09-25 11:29 a.m., Bart Van Assche wrote:
> On Tue, 2018-09-25 at 10:22 -0600, Logan Gunthorpe wrote:
>> @@ -83,9 +132,14 @@ static int pci_p2pdma_setup(struct pci_dev *pdev)
>>  
>>  	pdev->p2pdma = p2p;
>>  
>> +	error = sysfs_create_group(&pdev->dev.kobj, &p2pmem_group);
>> +	if (error)
>> +		goto out_pool_destroy;
>> +
>>  	return 0;
>>  
>>  out_pool_destroy:
>> +	pdev->p2pdma = NULL;
>>  	gen_pool_destroy(p2p->pool);
>>  out:
>>  	devm_kfree(&pdev->dev, p2p);
> 
> This doesn't look right to me. Shouldn't devm_remove_action() be called instead
> of devm_kfree() if sysfs_create_group() fails?

That makes no sense to me. We are reversing a devm_kzalloc() not a
custom action....

One could argue we should _also_ remove the pci_p2pdma_release() action,
but seeing it has a NULL check on pdev->p2pdma it's pretty harmless to
leave in.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
