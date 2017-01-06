Return-Path: <linux-nvdimm-bounces@lists.01.org>
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: RE: Enabling peer to peer device transactions for PCIe devices
Date: Fri, 6 Jan 2017 19:12:32 +0000
Message-ID: <BN6PR12MB1652CC50C4FB1CC17E14BD7DF7630@BN6PR12MB1652.namprd12.prod.outlook.com>
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
In-Reply-To: <20170106182625.GB5724@obsidianresearch.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: 'Jason Gunthorpe' <jgunthorpe@obsidianresearch.com>, Jerome Glisse <jglisse@redhat.com>
Cc: "Zhou, David(ChunMing)" <David1.Zhou@amd.com>, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>, "'linux-nvdimm@lists.01.org'" <linux-nvdimm@ml01.01.org>, Kuehling,, "Serguei  <Serguei.Sagalovitch@amd.com>, 'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>, "Koenig," Christian" <Christian.Koenig@amd.com>, "hch@infradead.org, " <hch@infradead.org>, Yu, Qiang" <Qiang.Yu@amd.com>, "Sander, Ben" <ben.sander@amd.com>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>, Jerome Glisse <j.glisse@gmail.com>, "Blinzer, Paul" <Paul.Blinzer@amd.com>, "'Linux-media@vger.kernel.org'" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe@obsidianresearch.com]
> Sent: Friday, January 06, 2017 1:26 PM
> To: Jerome Glisse
> Cc: Sagalovitch, Serguei; Jerome Glisse; Deucher, Alexander; 'linux-
> kernel@vger.kernel.org'; 'linux-rdma@vger.kernel.org'; 'linux-
> nvdimm@lists.01.org'; 'Linux-media@vger.kernel.org'; 'dri-
> devel@lists.freedesktop.org'; 'linux-pci@vger.kernel.org'; Kuehling, Felix;
> Blinzer, Paul; Koenig, Christian; Suthikulpanit, Suravee; Sander, Ben;
> hch@infradead.org; Zhou, David(ChunMing); Yu, Qiang
> Subject: Re: Enabling peer to peer device transactions for PCIe devices
> 
> On Fri, Jan 06, 2017 at 12:37:22PM -0500, Jerome Glisse wrote:
> > On Fri, Jan 06, 2017 at 11:56:30AM -0500, Serguei Sagalovitch wrote:
> > > On 2017-01-05 08:58 PM, Jerome Glisse wrote:
> > > > On Thu, Jan 05, 2017 at 05:30:34PM -0700, Jason Gunthorpe wrote:
> > > > > On Thu, Jan 05, 2017 at 06:23:52PM -0500, Jerome Glisse wrote:
> > > > >
> > > > > > > I still don't understand what you driving at - you've said in both
> > > > > > > cases a user VMA exists.
> > > > > > In the former case no, there is no VMA directly but if you want one
> than
> > > > > > a device can provide one. But such VMA is useless as CPU access is
> not
> > > > > > expected.
> > > > > I disagree it is useless, the VMA is going to be necessary to support
> > > > > upcoming things like CAPI, you need it to support O_DIRECT from the
> > > > > filesystem, DPDK, etc. This is why I am opposed to any model that is
> > > > > not VMA based for setting up RDMA - that is shorted sighted and
> does
> > > > > not seem to reflect where the industry is going.
> > > > >
> > > > > So focus on having VMA backed by actual physical memory that
> covers
> > > > > your GPU objects and ask how do we wire up the '__user *' to the
> DMA
> > > > > API in the best way so the DMA API still has enough information to
> > > > > setup IOMMUs and whatnot.
> > > > I am talking about 2 different thing. Existing hardware and API where
> you
> > > > _do not_ have a vma and you do not need one. This is just
> > > > > existing stuff.
> 
> > > I do not understand why you assume that existing API doesn't  need one.
> > > I would say that a lot of __existing__ user level API and their support in
> > > kernel (especially outside of graphics domain) assumes that we have vma
> and
> > > deal with __user * pointers.
> 
> +1
> 
> > Well i am thinking to GPUDirect here. Some of GPUDirect use case do not
> have
> > vma (struct vm_area_struct) associated with them they directly apply to
> GPU
> > object that aren't expose to CPU. Yes some use case have vma for share
> buffer.
> 
> Lets stop talkind about GPU direct. Today we can't even make VMA
> pointing at a PCI bar work properly in the kernel - lets start there
> please. People can argue over other options once that is done.
> 
> > For HMM plan is to restrict to ODP and either to replace ODP with HMM or
> change
> > ODP to not use get_user_pages_remote() but directly fetch informations
> from
> > CPU page table. Everything else stay as it is. I posted patchset to replace
> > ODP with HMM in the past.
> 
> Make a generic API for all of this and you'd have my vote..
> 
> IMHO, you must support basic pinning semantics - that is necessary to
> support generic short lived DMA (eg filesystem, etc). That hardware
> can clearly do that if it can support ODP.

We would definitely like to have support for hardware that can't handle page faults gracefully.

Alex

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
