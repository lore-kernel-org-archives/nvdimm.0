Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 195F1222EDCFC
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 22:43:55 -0800 (PST)
Date: Fri, 5 Jan 2018 01:47:01 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 04/12] pci-p2p: Clear ACS P2P flags for all client devices
Message-ID: <20180105064547.GA3212@redhat.com>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-5-logang@deltatee.com>
 <20180104215721.GF189897@bhelgaas-glaptop.roam.corp.google.com>
 <20180104153551.3118f71b@t450s.home>
 <20fdb5bb-0236-c093-ed53-e12664022f53@deltatee.com>
 <20180104203300.79487c98@w520.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180104203300.79487c98@w520.home>
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
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 04, 2018 at 08:33:00PM -0700, Alex Williamson wrote:
> On Thu, 4 Jan 2018 17:00:47 -0700
> Logan Gunthorpe <logang@deltatee.com> wrote:
> =

> > On 04/01/18 03:35 PM, Alex Williamson wrote:
> > > Yep, flipping these ACS bits invalidates any IOMMU groups that depend
> > > on the isolation of that downstream port and I suspect also any peers
> > > within the same PCI slot of that port and their downstream devices.  =
The
> > > entire sub-hierarchy grouping needs to be re-evaluated.  This
> > > potentially affects running devices that depend on that isolation, so
> > > I'm not sure how that happens dynamically.  A boot option might be
> > > easier.  Thanks,  =

> > =

> > I don't see how this is the case in current kernel code. It appears to =

> > only enable ACS globally if the IOMMU requests it.
> =

> IOMMU groups don't exist unless the IOMMU is enabled and x86 and ARM
> both request ACS be enabled if an IOMMU is present, so I'm not sure
> what you're getting at here.  Also, in reply to your other email, if
> the IOMMU is enabled, every device handled by the IOMMU is a member of
> an IOMMU group, see struct device.iommu_group.  There's an
> iommu_group_get() accessor to get a reference to it.
>  =

> > I also don't see how turning off ACS isolation for a specific device is =

> > going to hurt anything. The IOMMU should still be able to keep going on =

> > unaware that anything has changed. The only worry is that a security =

> > hole may now be created if a user was relying on the isolation between =

> > two devices that are in different VMs or something. However, if a user =

> > was relying on this, they probably shouldn't have turned on P2P in the =

> > first place.
> =

> That's exactly what IOMMU groups represent, the smallest set of devices
> which have DMA isolation from other devices.  By poking this hole, the
> IOMMU group is invalid.  We cannot turn off ACS only for a specific
> device, in order to enable p2p it needs to be disabled at every
> downstream port between the devices where we want to enable p2p.
> Depending on the topology, that could mean we're also enabling p2p for
> unrelated devices.  Those unrelated devices might be in active use and
> the p2p IOVAs now have a different destination which is no longer IOMMU
> translated.
>  =

> > We started with a fairly unintelligent choice to simply disable ACS on =

> > any kernel that had CONFIG_PCI_P2P set. However, this did not seem like =

> > a good idea going forward. Instead, we now selectively disable the ACS =

> > bit only on the downstream ports that are involved in P2P transactions. =

> > This seems like the safest choice and still allows people to (carefully=
) =

> > use P2P adjacent to other devices that need to be isolated.
> =

> I don't see that the code is doing much checking that adjacent devices
> are also affected by the p2p change and of course the IOMMU group is
> entirely invalid once the p2p holes start getting poked.
> =

> > I don't think anyone wants another boot option that must be set in orde=
r =

> > to use this functionality (and only some hardware would require this). =

> > That's just a huge pain for users.
> =

> No, but nor do we need IOMMU groups that no longer represent what
> they're intended to describe or runtime, unchecked routing changes
> through the topology for devices that might already be using
> conflicting IOVA ranges.  Maybe soft hotplugs are another possibility,
> designate a sub-hierarchy to be removed and re-scanned with ACS
> disabled.  Otherwise it seems like disabling and re-enabling ACS needs
> to also handle merging and splitting groups dynamically.  Thanks,
> =


Dumb question, can we use a PCI bar address of one device into the
IOMMU page table of another address ie like we would DMA map a
regular system page ?

It would be much better in my view to follow down such path if that
is at all possible from hardware point of view (i am not sure where
to dig in the specification to answer my above question).

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
