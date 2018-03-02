Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6ADC820955F30
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 16:31:59 -0800 (PST)
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-3-logang@deltatee.com>
 <20180301174450.GF13722@bhelgaas-glaptop.roam.corp.google.com>
 <d69d59c0-6182-cce7-7ba4-8552ba95bef5@deltatee.com>
 <CAPcyv4hj5XJrsKHxZEWTSdrDAv0k7tf1ptb7_2FpTGpxqY5jUQ@mail.gmail.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <c97fb967-966d-4a8e-91ab-e3f216ebdd97@deltatee.com>
Date: Thu, 1 Mar 2018 17:37:58 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hj5XJrsKHxZEWTSdrDAv0k7tf1ptb7_2FpTGpxqY5jUQ@mail.gmail.com>
Content-Language: en-US
Subject: Re: [PATCH v2 02/10] PCI/P2PDMA: Add sysfs group to display p2pmem
 stats
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 01/03/18 05:36 PM, Dan Williams wrote:
> On Thu, Mar 1, 2018 at 4:15 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
>>
>>
>> On 01/03/18 10:44 AM, Bjorn Helgaas wrote:
>>>
>>> I think these two statements are out of order, since the attributes
>>> dereference pdev->p2pdma.  And it looks like you set "error"
>>> unnecessarily, since you return immediately looking at it.
>>
>>
>> Per the previous series, sysfs_create_group is must_check for some reason. I
>> had a printk there but you didn't think it was necessary. So assigning it to
>> error is the only way to squash the warning.
> 
> Why not fail the setup if the sysfs_create_group() fails? Sure, it may
> not be strictly required for userspace to have access to these
> attributes, but it seems hostile that userspace can't make assumptions
> about the presence of the "p2pmem" directory relative to the
> capability being setup.

Works for me. I'll do that.

Thanks,

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
