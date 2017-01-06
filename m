Return-Path: <linux-nvdimm-bounces@lists.01.org>
References: <20170105190113.GA12587@obsidianresearch.com>
 <20170105195424.GB2166@redhat.com>
 <20170105200719.GB31047@obsidianresearch.com>
 <20170105201935.GC2166@redhat.com>
 <20170105224215.GA3855@obsidianresearch.com>
 <20170105232352.GB6426@redhat.com>
 <20170106003034.GB4670@obsidianresearch.com>
 <20170106015831.GA2226@gmail.com>
 <f07700d5-211f-d091-2b0b-fbaf03c4a959@amd.com>
 <20170106173722.GB3804@redhat.com>
 <20170106182625.GB5724@obsidianresearch.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <2a148b6e-86bc-4c4d-2f22-d733e2cc94cc@deltatee.com>
Date: Fri, 6 Jan 2017 15:10:32 -0700
MIME-Version: 1.0
In-Reply-To: <20170106182625.GB5724@obsidianresearch.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
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
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jerome Glisse <jglisse@redhat.com>
Cc: david1.zhou@amd.com, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>, "'linux-nvdimm@lists.01.org'" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "Blinzer, Paul  <Paul.Blinzer@amd.com>, 'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>, Sander,, "Suravee  <Suravee.Suthikulpanit@amd.com>, 'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>, "Deucher, Alexander  <Alexander.Deucher@amd.com>, Jerome Glisse <j.glisse@gmail.com>, Koenig, Christian" <Christian.Koenig@amd.com>, "'Linux-media@vger.kernel.org'" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



On 06/01/17 11:26 AM, Jason Gunthorpe wrote:

> Make a generic API for all of this and you'd have my vote..
> 
> IMHO, you must support basic pinning semantics - that is necessary to
> support generic short lived DMA (eg filesystem, etc). That hardware
> can clearly do that if it can support ODP.

I agree completely.

What we want is for RDMA, O_DIRECT, etc to just work with special VMAs
(ie. at least those backed with ZONE_DEVICE memory). Then
GPU/NVME/DAX/whatever drivers can just hand these VMAs to userspace
(using whatever interface is most appropriate) and userspace can do what
it pleases with them. This makes _so_ much sense and actually largely
already works today (as demonstrated by iopmem).

Though, of course, there are many aspects that could still be improved
like denying CPU access to special VMAs and having get_user_pages avoid
pinning device memory, etc, etc. But all this would just be enhancements
to how VMAs work and not be effected by the basic design described above.

We experimented with GPU Direct and the peer memory patchset for IB and
they were broken by design. They were just a very specific hack into the
IB core and thus didn't help to support O_DIRECT or any other possible
DMA user. And the invalidation thing was completely nuts. We had to pray
an invalidation would never occur because, if it did, our application
would just break.

Logan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
