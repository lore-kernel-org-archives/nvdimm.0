Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681E92F20
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 15:23:19 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4F79068AFE; Thu, 10 Feb 2022 16:23:08 +0100 (CET)
Date: Thu, 10 Feb 2022 16:23:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Alistair Popple <apopple@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
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
Subject: Re: [PATCH 13/27] mm: move the migrate_vma_* device migration code
 into it's own file
Message-ID: <20220210152308.GA13344@lst.de>
References: <20220210072828.2930359-1-hch@lst.de> <20220210072828.2930359-14-hch@lst.de> <2160837.zdNQNePZV9@nvdebian>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2160837.zdNQNePZV9@nvdebian>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 10, 2022 at 09:35:10PM +1100, Alistair Popple wrote:
> I got the following build error:
> 
> /data/source/linux/mm/migrate_device.c: In function ‘migrate_vma_collect_pmd’:
> /data/source/linux/mm/migrate_device.c:242:3: error: implicit declaration of function ‘flush_tlb_range’; did you mean ‘flush_pmd_tlb_range’? [-Werror=implicit-function-declaration]
>   242 |   flush_tlb_range(walk->vma, start, end);
>       |   ^~~~~~~~~~~~~~~
>       |   flush_pmd_tlb_range
> 
> Including asm/tlbflush.h in migrate_device.c fixed it for me.

Yes, the buildbot also complained about this, but somehow in my test
configfs it got pulled in implicitly.
