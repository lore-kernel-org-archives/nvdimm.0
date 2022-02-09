Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25B029CA
	for <nvdimm@lists.linux.dev>; Wed,  9 Feb 2022 13:54:01 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id D733867373; Wed,  9 Feb 2022 14:53:51 +0100 (CET)
Date: Wed, 9 Feb 2022 14:53:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Ben Skeggs <bskeggs@redhat.com>,
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	amd-gfx list <amd-gfx@lists.freedesktop.org>,
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
	nouveau@lists.freedesktop.org,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH 7/8] mm: remove the extra ZONE_DEVICE struct page
 refcount
Message-ID: <20220209135351.GA20631@lst.de>
References: <20220207063249.1833066-1-hch@lst.de> <20220207063249.1833066-8-hch@lst.de> <CAPcyv4h_axDTmkZ35KFfCdzMoOp8V3dc6btYGq6gCj1OmLXM=g@mail.gmail.com> <20220209062345.GB7739@lst.de> <20220209122956.GI49147@ziepe.ca>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209122956.GI49147@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 09, 2022 at 08:29:56AM -0400, Jason Gunthorpe wrote:
> It is nice, but the other series are still impacted by the fsdax mess
> - they still stuff pages into ptes without proper refcounts and have
> to carry nonsense to dance around this problem.
> 
> I certainly would be unhappy if the amd driver, for instance, gained
> the fsdax problem as well and started pushing 4k pages into PMDs.

As said before: I think this all needs to be fixed.  But I'd rather
fix it gradually and I think this series is a nice step forward.
After that we can look at the pte mappings.
