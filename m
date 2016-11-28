From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Mon, 28 Nov 2016 12:02:44 -0700
Message-ID: <20161128190244.GA21975@obsidianresearch.com>
References: <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <20161125193252.GC16504@obsidianresearch.com>
 <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
 <20161128165751.GB28381@obsidianresearch.com>
 <1480357179.19407.13.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1480357179.19407.13.camel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "John.Bridgman-5C7GfCeVMHo@public.gmane.org" <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Felix.Kuehling-5C7GfCeVMHo@public.gmane.org" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org" <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Paul.Blinzer-5C7GfCeVMHo@public.gmane.org" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "ben.sander-5C7GfCeVMHo@public.gmane.org" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Alexander.Deucher-5C7GfCeVMHo@public.gmane.org" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "christian.koenig-5C7GfCeVMHo@public.gmane.org" <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Mon, Nov 28, 2016 at 06:19:40PM +0000, Haggai Eran wrote:
> > > GPU memory. We create a non-ODP MR pointing to VRAM but rely on
> > > user-space and the GPU not to migrate it. If they do, the MR gets
> > > destroyed immediately.
> > That sounds horrible. How can that possibly work? What if the MR is
> > being used when the GPU decides to migrate? 
> Naturally this doesn't support migration. The GPU is expected to pin
> these pages as long as the MR lives. The MR invalidation is done only as
> a last resort to keep system correctness.

That just forces applications to handle horrible unexpected
failures. If this sort of thing is needed for correctness then OOM
kill the offending process, don't corrupt its operation.

> I think it is similar to how non-ODP MRs rely on user-space today to
> keep them correct. If you do something like madvise(MADV_DONTNEED) on a
> non-ODP MR's pages, you can still get yourself into a data corruption
> situation (HCA sees one page and the process sees another for the same
> virtual address). The pinning that we use only guarentees the HCA's page
> won't be reused.

That is not really data corruption - the data still goes where it was
originally destined. That is an application violating the
requirements of a MR. An application cannot munmap/mremap a VMA
while a non ODP MR points to it and then keep using the MR.

That is totally different from a GPU driver wanthing to mess with
translation to physical pages.

> > From what I understand we are not really talking about kernel p2p,
> > everything proposed so far is being mediated by a userspace VMA, so
> > I'd focus on making that work.

> Fair enough, although we will need both eventually, and I hope the
> infrastructure can be shared to some degree.

What use case do you see for in kernel?

Presumably in-kernel could use a vmap or something and the same basic
flow?

Jason
