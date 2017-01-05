Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 5 Jan 2017 15:42:15 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20170105224215.GA3855@obsidianresearch.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <20170105183927.GA5324@gmail.com>
 <20170105190113.GA12587@obsidianresearch.com>
 <20170105195424.GB2166@redhat.com>
 <20170105200719.GB31047@obsidianresearch.com>
 <20170105201935.GC2166@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170105201935.GC2166@redhat.com>
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
Cc: david1.zhou@amd.com, qiang.yu@amd.com, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>, "'linux-nvdimm@lists.01.org'" <linux-nvdimm@ml01.01.org>, Kuehling,, "Serguei  <Serguei.Sagalovitch@amd.com>, 'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>, Koenig,, Alexander, "Ben  <ben.sander@amd.com>, Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>, Jerome Glisse <j.glisse@gmail.com>, "Blinzer, Paul" <Paul.Blinzer@amd.com>, "'Linux-media@vger.kernel.org'" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 05, 2017 at 03:19:36PM -0500, Jerome Glisse wrote:

> > Always having a VMA changes the discussion - the question is how to
> > create a VMA that reprensents IO device memory, and how do DMA
> > consumers extract the correct information from that VMA to pass to the
> > kernel DMA API so it can setup peer-peer DMA.
> 
> Well my point is that it can't be. In HMM case inside a single VMA
> you
[..]

> In the GPUDirect case the idea is that you have a specific device vma
> that you map for peer to peer.

[..]

I still don't understand what you driving at - you've said in both
cases a user VMA exists.

>From my perspective in RDMA, all I want is a core kernel flow to
convert a '__user *' into a scatter list of DMA addresses, that works no
matter what is backing that VMA, be it HMM, a 'hidden' GPU object, or
struct page memory.

A '__user *' pointer is the only way to setup a RDMA MR, and I see no
reason to have another API at this time.

The details of how to translate to a scatter list are a MM subject,
and the MM folks need to get 

I just don't care if that routine works at a page level, or a whole
VMA level, or some combination of both, that is up to the MM team to
figure out :)

> a page level. Expectation here is that the GPU userspace expose a special
> API to allow RDMA to directly happen on GPU object allocated through
> GPU specific API (ie it is not regular memory and it is not accessible
> by CPU).

So, how do you identify these GPU objects? How do you expect RDMA
convert them to scatter lists? How will ODP work?

> > We have MMU notifiers to handle this today in RDMA. Async RDMA MR
> > Invalidate like you see in the above out of tree patches is totally
> > crazy and shouldn't be in mainline. Use ODP capable RDMA hardware.
> 
> Well there is still a large base of hardware that do not have such
> feature and some people would like to be able to keep using those.

Hopefully someone will figure out how to do that without the crazy
async MR invalidation.

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
