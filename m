Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB80E203B8585
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 16:32:04 -0700 (PDT)
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
 <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
 <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
 <20180508133407.57a46902@w520.home>
 <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
 <20180508141331.7cd737cb@w520.home>
 <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
 <20180508144341.0441b676@w520.home>
 <a524127a-3557-3dff-971c-dfe94ba5a01c@deltatee.com>
 <20180508152631.50fd583c@w520.home>
 <354F7407-0DC7-470C-B9AA-74FDF9C46B08@raithlin.com>
 <20180508160336.0935ddde@w520.home>
 <20905682-9440-7d4b-0260-99d3dc794c3d@deltatee.com>
 <C3CEE4DB-A001-4E4C-B9B9-4B160E4C5367@raithlin.com>
 <20180508171150.0e8fd291@w520.home>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <0a0a1782-04b2-c571-63c7-bfff68312946@deltatee.com>
Date: Tue, 8 May 2018 17:31:48 -0600
MIME-Version: 1.0
In-Reply-To: <20180508171150.0e8fd291@w520.home>
Content-Language: en-US
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
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
To: Alex Williamson <alex.williamson@redhat.com>, Stephen Bates <sbates@raithlin.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>



On 08/05/18 05:11 PM, Alex Williamson wrote:
> On to the implementation details... I already mentioned the BDF issue
> in my other reply.  If we had a way to persistently identify a device,
> would we specify the downstream points at which we want to disable ACS
> or the endpoints that we want to connect?  The latter has a problem
> that the grouping upstream of an endpoint is already set by the time we
> discover the endpoint, so we might need to unwind to get the grouping
> correct.  The former might be more difficult for users to find the
> necessary nodes, but easier for the kernel to deal with during
> discovery.  

I was envisioning the former with kernel helping by printing a dmesg in
certain circumstances to help with figuring out which devices need to be
specified. Specifying a list of endpoints on the command line and having
the kernel try to figure out which downstream ports need to be adjusted
while we are in the middle of enumerating the bus is, like you said, a
nightmare.

> A runtime, sysfs approach has some benefits here,
> especially in identifying the device assuming we're ok with leaving
> the persistence problem to userspace tools.  I'm still a little fond of
> the idea of exposing an acs_flags attribute for devices in sysfs where
> a write would do a soft unplug and re-add of all affected devices to
> automatically recreate the proper grouping.  Any dynamic change in
> routing and grouping would require all DMA be re-established anyway and
> a soft hotplug seems like an elegant way of handling it.  Thanks,

This approach sounds like it has a lot more issues to contend with:

For starters, a soft unplug/re-add of all the devices behind a switch is
going to be difficult if a lot of those devices have had drivers
installed and their respective resources are now mounted or otherwise in
use.

Then, do we have to redo a the soft-replace every time we change the ACS
bit for every downstream port? That could mean you have to do dozens
soft-replaces before you have all the ACS bits set which means you have
a storm of drivers being added and removed.

This would require some kind of fancy custom setup software that runs at
just the right time in the boot sequence or a lot of work on the users
part to unbind all the resources, setup the ACS bits and then rebind
everything (assuming the soft re-add doesn't rebind it every time you
adjust one ACS bit). Ugly.

IMO, if we need to do the sysfs approach then we need to be able to
adjust the groups dynamically in a sensible way and not through the
large hammer that is soft-replaces. I think this would be great but I
don't think we will be tackling that with this patch set.

Logan


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
