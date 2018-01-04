Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF8B5222A54DD
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 15:08:13 -0800 (PST)
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-3-logang@deltatee.com>
 <20180104215040.GE189897@bhelgaas-glaptop.roam.corp.google.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <b83d097d-bcde-b277-6d4f-26cd7f943bbd@deltatee.com>
Date: Thu, 4 Jan 2018 16:13:09 -0700
MIME-Version: 1.0
In-Reply-To: <20180104215040.GE189897@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Subject: Re: [PATCH 02/12] pci-p2p: Add sysfs group to display p2pmem stats
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
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 04/01/18 02:50 PM, Bjorn Helgaas wrote:
> On Thu, Jan 04, 2018 at 12:01:27PM -0700, Logan Gunthorpe wrote:
>> Attributes display the total amount of P2P memory, the ammount available
>> and whether it is published or not.
> 
> s/ammount/amount/ (also below)

Will fix.

> I wonder if "p2pdma" would be a more suggestive term?  It's not really
> the *memory* that is peer-to-peer; the peer-to-peer part is referring
> to *access* to the memory.

I agree with Jason on this point. For now, it only describes the 
peer-to-peer memory attributes. If we change the directory to p2pdma 
then we'd have to add a mem prefix or something to each attribute.

>> @@ -82,6 +130,9 @@ static int pci_p2pmem_setup(struct pci_dev *pdev)
>>   	if (error)
>>   		goto out_pool_destroy;
>>   
>> +	if (sysfs_create_group(&pdev->dev.kobj, &p2pmem_group))
>> +		dev_warn(&pdev->dev, "failed to create p2p sysfs group\n");
> 
> Not sure the warning (by itself) is worthwhile.  If we were going to
> disable the feature if sysfs_create_group() failed, that's one thing,
> but we aren't doing anything except generating a warning, which the
> user can't really do anything with.  If the user is looking for the
> sysfs file, its absence will be obvious even without the message.

Unfortunately, sysfs_create_group() has the warn_unused_result flag set. 
So I need to do something with the result to squash the warning. I could 
just assign it to an unused variable but something seemed like it needed 
to be done and printing a warning was the easiest thing...

Logan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
