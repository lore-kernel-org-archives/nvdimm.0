Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 448E02194D3AE
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 12:30:42 -0700 (PDT)
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830192012.GG3529@redhat.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <d5d38a3d-ae6f-9995-e818-a8f186a7f346@deltatee.com>
Date: Thu, 30 Aug 2018 13:30:32 -0600
MIME-Version: 1.0
In-Reply-To: <20180830192012.GG3529@redhat.com>
Content-Language: en-US
Subject: Re: [PATCH v5 00/13] Copy Offload in NVMe Fabrics with P2P PCI Memory
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
To: Jerome Glisse <jglisse@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 30/08/18 01:20 PM, Jerome Glisse wrote:
> On Thu, Aug 30, 2018 at 12:53:39PM -0600, Logan Gunthorpe wrote:
> 
> [...]
> 
>>
>> When the PCI P2PDMA config option is selected the ACS bits in every
>> bridge port in the system are turned off to allow traffic to
>> pass freely behind the root port. At this time, the bit must be disabled
>> at boot so the IOMMU subsystem can correctly create the groups, though
>> this could be addressed in the future. There is no way to dynamically
>> disable the bit and alter the groups.

Oh, sorry this paragraph in the cover letter is wrong now. We now rely
on the disable_acs_redir command line option introduced in

aaca43fda742 ("PCI: Add "pci=disable_acs_redir=" parameter for
peer-to-peer support")


> Can you provide an example on how to test this ? Like kernel command
> line option, the doc patch does not have any such example. It would be
> nice to add.

Do you mean to test the patchset or the ACS bits you quoted?

Testing the patchset is a matter of having the right hardware (ie an
RDMA NIC and CMB enabled NVMe behind a PCIe switch, with the ACS bits
set correctly by the above command line option) and setting the p2pmem
configfs attribute in an nvme-of port to 'yes'.


Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
