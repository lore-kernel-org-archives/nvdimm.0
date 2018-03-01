Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 1 Mar 2018 13:53:15 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
Message-ID: <20180301205315.GJ19007@ziepe.ca>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <CAPcyv4h7mcFphv3j_vW-CGxXa2pjQgLqpBOLzHuTzAFzygai-Q@mail.gmail.com>
 <1519936477.4592.23.camel@au1.ibm.com>
 <1519936815.4592.25.camel@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1519936815.4592.25.camel@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@au1.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Logan Gunthorpe <logang@deltatee.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma <linux-rdma@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Oliver OHalloran <oliveroh@au1.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 02, 2018 at 07:40:15AM +1100, Benjamin Herrenschmidt wrote:
> Also we need to be able to hard block MEMREMAP_WB mappings of non-RAM
> on ppc64 (maybe via an arch hook as it might depend on the processor
> family). Server powerpc cannot do cachable accesses on IO memory
> (unless it's special OpenCAPI or nVlink, but not on PCIe).

I think you are right on this - even on x86 we must not create
cachable mappings of PCI BARs - there is no way that works the way
anyone would expect.

I think this series doesn't have a problem here only because it never
touches the BAR pages with the CPU.

BAR memory should be mapped into the CPU as WC at best on all arches..

Jason
