Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 25 Jun 2019 13:59:21 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 18/22] mm: mark DEVICE_PUBLIC as broken
Message-ID: <20190625115921.GA3874@lst.de>
References: <20190613094326.24093-1-hch@lst.de> <20190613094326.24093-19-hch@lst.de> <20190620192648.GI12083@dhcp22.suse.cz> <20190625072915.GD30350@lst.de> <20190625114422.GA3118@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625114422.GA3118@mellanox.com>
Sender: owner-linux-mm@kvack.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>, Michal Hocko <mhocko@kernel.org>, Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 25, 2019 at 11:44:28AM +0000, Jason Gunthorpe wrote:
> Which tree and what does the resolution look like?

Looks like in -mm.  The current commit in linux-next is:

commit 0d23b042f26955fb35721817beb98ba7f1d9ed9f
Author: Robin Murphy <robin.murphy@arm.com>
Date:   Fri Jun 14 10:42:14 2019 +1000

    mm: clean up is_device_*_page() definitions


> Also, I don't want to be making the decision if we should keep/remove
> DEVICE_PUBLIC, so let's get an Ack from Andrew/etc?
> 
> My main reluctance is that I know there is HW out there that can do
> coherent, and I want to believe they are coming with patches, just
> too slowly. But I'd also rather those people defend themselves :P

Lets keep everything as-is for now.  I'm pretty certain nothing
will show up, but letting this linger another release or two
shouldn't be much of a problem.  And if we urgently feel like removing
it we can do it after -rc1.
