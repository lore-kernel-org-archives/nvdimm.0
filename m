Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEADB2F24
	for <nvdimm@lists.linux.dev>; Tue,  8 Feb 2022 06:47:00 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id B266568B05; Tue,  8 Feb 2022 07:46:47 +0100 (CET)
Date: Tue, 8 Feb 2022 07:46:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: Felix Kuehling <felix.kuehling@amd.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Ben Skeggs <bskeggs@redhat.com>,
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Alistair Popple <apopple@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ralph Campbell <rcampbell@nvidia.com>, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	nouveau@lists.freedesktop.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 6/8] mm: don't include <linux/memremap.h> in
 <linux/mm.h>
Message-ID: <20220208064646.GA16350@lst.de>
References: <20220207063249.1833066-1-hch@lst.de> <20220207063249.1833066-7-hch@lst.de> <3287da2f-defa-9adb-e21c-c498972e674d@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3287da2f-defa-9adb-e21c-c498972e674d@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 07, 2022 at 04:19:29PM -0500, Felix Kuehling wrote:
>
> Am 2022-02-07 um 01:32 schrieb Christoph Hellwig:
>> Move the check for the actual pgmap types that need the free at refcount
>> one behavior into the out of line helper, and thus avoid the need to
>> pull memremap.h into mm.h.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> The amdkfd part looks good to me.
>
> It looks like this patch is not based on Alex Sierra's coherent memory 
> series. He added two new helpers is_device_coherent_page and 
> is_dev_private_or_coherent_page that would need to be moved along with 
> is_device_private_page and is_pci_p2pdma_page.

Yes.  I Naked that series because it spreads te mess with the refcount
further in this latest version.  My intent is that it gets rebased
on top of this to avoid that spread.  Same for the p2p series form Logan.
