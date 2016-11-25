Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 24 Nov 2016 23:58:17 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161125075817.GA18428@infradead.org>
References: <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <9cc22068-ede8-c1bc-5d8b-cf6224a7ce05@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9cc22068-ede8-c1bc-5d8b-cf6224a7ce05@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Haggai Eran <haggaie@mellanox.com>, "Bridgman, John  <John.Bridgman@amd.com>, linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "Blinzer, Paul  <Paul.Blinzer@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "Sander, Ben  <ben.sander@amd.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Deucher,, "Christian  <Christian.Koenig@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 24, 2016 at 11:11:34AM -0700, Logan Gunthorpe wrote:
> * Regular DAX in the FS doesn't work at this time because the FS can
> move the file you think your transfer to out from under you. Though I
> understand there's been some work with XFS to solve that issue.

The file system will never move anything under locked down pages,
locking down pages is used exactly to protect against that.  So as long
as we page structures available RDMA to/from device memory _from kernel
space_ is trivial, although for file systems to work properly you
really want a notification to the consumer if the file systems wants
to remove the mapping.  We have implemented that using FL_LAYOUTS locks
for NFSD, but only XFS supports it so far.  Without that a long term
locked down region of memory (e.g. a kernel MR) would prevent various
file operations that would simply hang.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
