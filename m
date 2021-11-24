Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37472C81
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 06:39:38 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id D92CF68AFE; Wed, 24 Nov 2021 07:39:34 +0100 (CET)
Date: Wed, 24 Nov 2021 07:39:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 14/29] fsdax: simplify the pgoff calculation
Message-ID: <20211124063934.GC6889@lst.de>
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-15-hch@lst.de> <20211123223642.GI266024@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123223642.GI266024@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 23, 2021 at 02:36:42PM -0800, Darrick J. Wong wrote:
> > -	phys_addr_t phys_off = (start_sect + sector) * 512;
> > -
> > -	if (pgoff)
> > -		*pgoff = PHYS_PFN(phys_off);
> > -	if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
> 
> AFAICT, we're relying on fs_dax_get_by_bdev to have validated this
> previously, which is why the error return stuff goes away?

Exactly.
