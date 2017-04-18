From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Tue, 18 Apr 2017 14:48:03 -0600
Message-ID: <1cdeee61-2107-a392-4e5e-77a6aa10354f@deltatee.com>
References: <CAPcyv4it56J8Voo6kV0bBcO3nHsOHYLENpAtONJZTGceDDwNPg@mail.gmail.com>
 <1492381396.25766.43.camel@kernel.crashing.org>
 <20170418164557.GA7181@obsidianresearch.com>
 <cce00131-1f28-27b3-40ab-04f8783f1e5a@deltatee.com>
 <20170418190138.GH7181@obsidianresearch.com>
 <df1351d8-b86c-2e21-1948-4688ece5dc2b@deltatee.com>
 <CAPcyv4gScx6A7vG9VEHpNF41GOy1Nxst7QQ3QC3uZ54bWoxbMg@mail.gmail.com>
 <1565047873.28680036.1492547352121.JavaMail.zimbra@redhat.com>
 <CAPcyv4hTWbXkdeCEO9O0UM-EPcSjpdHCh7vDpSoNs1kB-Kup3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4hTWbXkdeCEO9O0UM-EPcSjpdHCh7vDpSoNs1kB-Kup3A@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Jerome Glisse <jglisse@redhat.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-nvdimm@lists.01.org



On 18/04/17 02:31 PM, Dan Williams wrote:
> On Tue, Apr 18, 2017 at 1:29 PM, Jerome Glisse <jglisse@redhat.com> wrote:
>>> On Tue, Apr 18, 2017 at 12:35 PM, Logan Gunthorpe <logang@deltatee.com>
>>> wrote:
>>>>
>>>>
>>>> On 18/04/17 01:01 PM, Jason Gunthorpe wrote:
>>>>> Ultimately every dma_ops will need special code to support P2P with
>>>>> the special hardware that ops is controlling, so it makes some sense
>>>>> to start by pushing the check down there in the first place. This
>>>>> advice is partially motivated by how dma_map_sg is just a small
>>>>> wrapper around the function pointer call...
>>>>
>>>> Yes, I noticed this problem too and that makes sense. It just means
>>>> every dma_ops will probably need to be modified to either support p2p
>>>> pages or fail on them. Though, the only real difficulty there is that it
>>>> will be a lot of work.
>>>
>>> I don't think you need to go touch all dma_ops, I think you can just
>>> arrange for devices that are going to do dma to get redirected to a
>>> p2p aware provider of operations that overrides the system default
>>> dma_ops. I.e. just touch get_dma_ops().
>>
>> This would not work well for everyone, for instance on GPU we usualy
>> have buffer object with a mix of device memory and regular system
>> memory but call dma sg map once for the list.
>>
> 
> ...and that dma_map goes through get_dma_ops(), so I don't see the conflict?

The main conflict is in dma_map_sg which only does get_dma_ops once but
the sg may contain memory of different types.

Logan
