Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 24 Nov 2016 09:24:22 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161124162422.GB20818@obsidianresearch.com>
References: <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <SN1PR12MB0703CE07F4878243164299C4FEB70@SN1PR12MB0703.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <SN1PR12MB0703CE07F4878243164299C4FEB70@SN1PR12MB0703.namprd12.prod.outlook.com>
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
To: "Sagalovitch, Serguei" <Serguei.Sagalovitch@amd.com>
Cc: Haggai Eran <haggaie@mellanox.com>, "Bridgman, John  <John.Bridgman@amd.com>, linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Kuehling,, "Paul  <Paul.Blinzer@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sander,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Deucher,, "Christian  <Christian.Koenig@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 24, 2016 at 12:40:37AM +0000, Sagalovitch, Serguei wrote:
> On Wed, Nov 23, 2016 at 02:11:29PM -0700, Logan Gunthorpe wrote:
> 
> > Perhaps I am not following what Serguei is asking for, but I
> > understood the desire was for a complex GPU allocator that could
> > migrate pages between GPU and CPU memory under control of the GPU
> > driver, among other things. The desire is for DMA to continue to work
> > even after these migrations happen.
> 
> The main issue is to  how to solve use cases when p2p is 
> requested/initiated via CPU pointers where such pointers could 
> point to non-system memory location e.g.  VRAM.  

Okay, but your list is conflating a whole bunch of problems..

 1) How to go from a __user pointer to a p2p DMA address
  a) How to validate, setup iommu and maybe worst case bounce buffer
     these p2p DMAs
 2) How to allow drivers (ie GPU allocator) dynamically
    remap pages in a VMA to/from p2p DMA addresses
 3) How to expose uncachable p2p DMA address to user space via mmap

> to allow "get_user_pages"  to work transparently similar 
> how it is/was done for "DAX Device" case. Unfortunately 
> based on my understanding "DAX Device" implementation 
> deal only with permanently  "locked" memory  (fixed location) 
> unrelated to "get_user_pages"/"put_page" scope  
> which doesn't satisfy requirements  for "eviction" / "moving" of 
> memory keeping CPU address intact.  

Hurm, isn't that issue with DAX only to do with being coherent with
the page cache?

A GPU allocator would not use the page cache, it would have to
construct VMAs some other way.

> My understanding is that It will not solve RDMA MR issue where "lock" 
> could be during the whole  application life but  (a) it will not make 
> RDMA MR case worse  (b) should be enough for all other cases for 
> "get_user_pages"/"put_page" controlled by  kernel.

Right. There is no solution to the RDMA MR issue on old hardware. Apps
that are using GPU+RDMA+Old hardware will have to use short lived MRs
and pay that performance cost, or give up on migration.

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
