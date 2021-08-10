Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC964177
	for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 07:19:29 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2FFD467373; Tue, 10 Aug 2021 09:13:13 +0200 (CEST)
Date: Tue, 10 Aug 2021 09:13:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 11/30] iomap: add the new iomap_iter model
Message-ID: <20210810071312.GA16590@lst.de>
References: <20210809061244.1196573-1-hch@lst.de> <20210809061244.1196573-12-hch@lst.de> <20210809221047.GC3657114@dread.disaster.area> <20210810064509.GI3601443@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810064509.GI3601443@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 09, 2021 at 11:45:09PM -0700, Darrick J. Wong wrote:
> > fs/iomap.c without having to take the tree back in time to find
> > those files...
> 
> ...or put the new code in apply.c, remove iomap_apply, and don't bother
> with the renaming at all?
> 
> I don't see much reason to break the git history.  This is effectively a
> new epoch in iomap, but that is plainly obvious from the function
> declarations.
> 
> I'll wander through the rest of the unreviewed patches tomorrow morning,
> these are merely my off-the-cuff impressions.

We could do all that, but why?  There is no code even left from the
apply area.
