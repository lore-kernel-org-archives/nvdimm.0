Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60AB2F22
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 06:45:26 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id DE15A68BFE; Thu, 10 Feb 2022 07:45:19 +0100 (CET)
Date: Thu, 10 Feb 2022 07:45:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: Alistair Popple <apopple@nvidia.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Ben Skeggs <bskeggs@redhat.com>,
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ralph Campbell <rcampbell@nvidia.com>, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	nouveau@lists.freedesktop.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 6/8] mm: don't include <linux/memremap.h> in
 <linux/mm.h>
Message-ID: <20220210064519.GA3692@lst.de>
References: <20220207063249.1833066-1-hch@lst.de> <3287da2f-defa-9adb-e21c-c498972e674d@amd.com> <20220209174836.GA24864@lst.de> <2168128.7o4XcKHI9n@nvdebian>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2168128.7o4XcKHI9n@nvdebian>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 10, 2022 at 01:10:47PM +1100, Alistair Popple wrote:
> diff --git a/mm/gup.c b/mm/gup.c
> index cbb49abb7992..8e85c9fb8df4 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2007,7 +2007,6 @@ static long check_and_migrate_movable_pages(unsigned long nr_pages,
>  	if (!ret && list_empty(&movable_page_list) && !isolation_error_count)
>  		return nr_pages;
>  
> -	ret = 0;
>  unpin_pages:

This isn't quite correct as ret is initially set to -EFAULT now.  I'll
fix it by removing the early ret initialization and always using the
goto. I've also added another refactoring patch for this messy function.

I've folded the inversion of the is_device_coherent_page check in
migrate.c in as well, thanks!
