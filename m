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
 <2a148b6e-86bc-4c4d-2f22-d733e2cc94cc@deltatee.com>
 <d5a72e1e5f6d606697dc0027f073fd87.squirrel@webmail.raithlin.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <8bda88d4-1e7c-7889-7d20-1a0eb43de31a@deltatee.com>
Date: Thu, 12 Jan 2017 15:35:07 -0700
MIME-Version: 1.0
In-Reply-To: <d5a72e1e5f6d606697dc0027f073fd87.squirrel@webmail.raithlin.com>
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
To: Stephen Bates <sbates@raithlin.com>
Cc: david1.zhou@amd.com, hch@infradead.org, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>, "'linux-nvdimm@lists.01.org'" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <felix.kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "Blinzer, Paul  <paul.blinzer@amd.com>, 'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>, "Sander," Ben" <ben.sander@amd.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>," qiang.yu@amd.com, Jerome Glisse <jglisse@redhat.com>, "Suthikulpanit, Suravee  <suravee.suthikulpanit@amd.com>, 'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>, "Deucher, Alexander  <alexander.deucher@amd.com>, Jerome Glisse <j.glisse@gmail.com>, Koenig, Christian" <christian.koenig@amd.com>, "'Linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



On 11/01/17 09:54 PM, Stephen Bates wrote:
> The iopmem patchset addressed all the use cases above and while it is not
> an in kernel API it could have been modified to be one reasonably easily.
> As Logan states the driver can then choose to pass the VMAs to user-space
> in a manner that makes sense.

Just to clarify: the iopmem patchset had one patch that allowed for
slightly more flexible zone device mappings which ought to be useful for
everyone.

The other patch (which was iopmem proper) was more of an example of how
the zone_device memory _could_ be exposed to userspace with "iopmem"
hardware that looks similar to nvdimm hardware. Iopmem was not really
useful, in itself, for NVMe devices and it was never expected to be
useful for GPUs.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
