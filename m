Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 5 Jan 2017 18:23:52 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20170105232352.GB6426@redhat.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <20170105183927.GA5324@gmail.com>
 <20170105190113.GA12587@obsidianresearch.com>
 <20170105195424.GB2166@redhat.com>
 <20170105200719.GB31047@obsidianresearch.com>
 <20170105201935.GC2166@redhat.com>
 <20170105224215.GA3855@obsidianresearch.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170105224215.GA3855@obsidianresearch.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: david1.zhou@amd.com, qiang.yu@amd.com, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>, "'linux-nvdimm@lists.01.org'" <linux-nvdimm@ml01.01.org>, Kuehling,, "Serguei  <Serguei.Sagalovitch@amd.com>, 'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>, Koenig,, Alexander, "Ben  <ben.sander@amd.com>, Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>, Jerome Glisse <j.glisse@gmail.com>, "Blinzer, Paul" <Paul.Blinzer@amd.com>, "'Linux-media@vger.kernel.org'" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 05, 2017 at 03:42:15PM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 05, 2017 at 03:19:36PM -0500, Jerome Glisse wrote:
> =

> > > Always having a VMA changes the discussion - the question is how to
> > > create a VMA that reprensents IO device memory, and how do DMA
> > > consumers extract the correct information from that VMA to pass to the
> > > kernel DMA API so it can setup peer-peer DMA.
> > =

> > Well my point is that it can't be. In HMM case inside a single VMA
> > you
> [..]
> =

> > In the GPUDirect case the idea is that you have a specific device vma
> > that you map for peer to peer.
> =

> [..]
> =

> I still don't understand what you driving at - you've said in both
> cases a user VMA exists.

In the former case no, there is no VMA directly but if you want one than
a device can provide one. But such VMA is useless as CPU access is not
expected.

> =

> From my perspective in RDMA, all I want is a core kernel flow to
> convert a '__user *' into a scatter list of DMA addresses, that works no
> matter what is backing that VMA, be it HMM, a 'hidden' GPU object, or
> struct page memory.
> =

> A '__user *' pointer is the only way to setup a RDMA MR, and I see no
> reason to have another API at this time.
> =

> The details of how to translate to a scatter list are a MM subject,
> and the MM folks need to get =

> =

> I just don't care if that routine works at a page level, or a whole
> VMA level, or some combination of both, that is up to the MM team to
> figure out :)

And that's what i am trying to get accross. There is 2 cases here.
What exist on today hardware. Thing like GPU direct, that works on
VMA level. Versus where some new hardware is going were want to do
thing on page level. Both require different API at different level.

What i was trying to get accross is that no matter what level you
consider in the end you still need something at the DMA API level.
And that the 2 different use case (device vma or regular vma) means
2 differents API for the device driver.

> =

> > a page level. Expectation here is that the GPU userspace expose a speci=
al
> > API to allow RDMA to directly happen on GPU object allocated through
> > GPU specific API (ie it is not regular memory and it is not accessible
> > by CPU).
> =

> So, how do you identify these GPU objects? How do you expect RDMA
> convert them to scatter lists? How will ODP work?

No ODP on those. If you want vma, the GPU device driver can provide
one. GPU object are disjoint from regular memory (coming from some
form of mmap). They are created through ioctl and in many case are
never expose to the CPU. They only exist inside the GPU driver realm.

None the less there is usecase where exchanging those object accross
computer over a network make sense. I am not an end user here :)


> > > We have MMU notifiers to handle this today in RDMA. Async RDMA MR
> > > Invalidate like you see in the above out of tree patches is totally
> > > crazy and shouldn't be in mainline. Use ODP capable RDMA hardware.
> > =

> > Well there is still a large base of hardware that do not have such
> > feature and some people would like to be able to keep using those.
> =

> Hopefully someone will figure out how to do that without the crazy
> async MR invalidation.

Personnaly i don't care too much about this old hardware and thus i am
fine without supporting them. The open source userspace is playing
catchup and doing feature for old hardware probably does not make sense.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
