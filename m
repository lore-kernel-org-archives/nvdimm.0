Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE492C81
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 06:36:15 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id C659668AFE; Wed, 24 Nov 2021 07:36:05 +0100 (CET)
Date: Wed, 24 Nov 2021 07:36:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 06/29] dax: move the partition alignment check into
 fs_dax_get_by_bdev
Message-ID: <20211124063605.GA6889@lst.de>
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-7-hch@lst.de> <20211123222555.GE266024@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123222555.GE266024@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 23, 2021 at 02:25:55PM -0800, Darrick J. Wong wrote:
> > +	if ((get_start_sect(bdev) * SECTOR_SIZE) % PAGE_SIZE ||
> > +	    (bdev_nr_sectors(bdev) * SECTOR_SIZE) % PAGE_SIZE) {
> 
> Do we have to be careful about 64-bit division here, or do we not
> support DAX on 32-bit?

I can't find anything in the Kconfig limiting DAX to 32-bit.  But
then again the existing code has divisions like this, so the compiler
is probably smart enough to turn them into shifts.

> > +		pr_info("%pg: error: unaligned partition for dax\n", bdev);
> 
> I also wonder if this should be ratelimited...?

This happens once (or maybe three times for XFS with rt and log devices)
at mount time, so I see no need for a ratelimit.
