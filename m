Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 1 Mar 2018 11:42:49 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 10/10] nvmet: Optionally use PCI P2P memory
Message-ID: <20180301184249.GI19007@ziepe.ca>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-11-logang@deltatee.com>
 <749e3752-4349-0bdf-5243-3d510c2b26db@grimberg.me>
 <40d69074-31a8-d06a-ade9-90de7712c553@deltatee.com>
 <5649098f-b775-815b-8b9a-f34628873ff4@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5649098f-b775-815b-8b9a-f34628873ff4@grimberg.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Steve Wise <swise@opengridcomputing.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 01, 2018 at 08:35:55PM +0200, Sagi Grimberg wrote:
> 
> >On 01/03/18 04:03 AM, Sagi Grimberg wrote:
> >>Can you describe what would be the plan to have it when these devices
> >>do come along? I'd say that p2p_dev needs to become a nvmet_ns reference
> >>and not from nvmet_ctrl. Then, when cmb capable devices come along, the
> >>ns can prefer to use its own cmb instead of locating a p2p_dev device?
> >
> >The patchset already supports CMB drives. That's essentially what patch 7
> >is for. We change the nvme-pci driver to use the p2pmem code to register
> >and manage the CMB memory. After that, it is simply available to the nvmet
> >code. We have already been using this with a couple prototype CMB drives.
> 
> The comment was to your statement:
> "Ideally, we'd want to use an NVME CMB buffer as p2p memory. This would
> save an extra PCI transfer as the NVME card could just take the data
> out of it's own memory. However, at this time, cards with CMB buffers
> don't seem to be available."
> 
> Maybe its a left-over which confused me...
> 
> Anyways, my question still holds. If I rack several of these
> nvme drives, ideally we would use _their_ cmbs for I/O that is
> directed to these namespaces. This is why I was suggesting that
> p2p_dev should live in nvmet_ns and not in nvmet_ctrl as a single
> p2p_dev used by all namespaces.

I agree, I don't think this series should target anything other than
using p2p memory located in one of the devices expected to participate
in the p2p trasnaction for a first pass..

locality is super important for p2p, so I don't think things should
start out in a way that makes specifying the desired locality hard.

This is also why I don't entirely understand why this series has a
generic allocator for p2p mem, it makes little sense to me.

Why wouldn't the nmve driver just claim the entire CMB of its local
device for its own use? Why involve p2p core code in this?

Jason
