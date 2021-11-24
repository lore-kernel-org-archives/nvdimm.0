Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4219C2C81
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 07:14:34 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8727968AFE; Wed, 24 Nov 2021 08:14:30 +0100 (CET)
Date: Wed, 24 Nov 2021 08:14:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 23/29] xfs: use IOMAP_DAX to check for DAX mappings
Message-ID: <20211124071430.GD7229@lst.de>
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-24-hch@lst.de> <20211123230124.GR266024@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123230124.GR266024@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 23, 2021 at 03:01:24PM -0800, Darrick J. Wong wrote:
> On Tue, Nov 09, 2021 at 09:33:03AM +0100, Christoph Hellwig wrote:
> > Use the explicit DAX flag instead of checking the inode flag in the
> > iomap code.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Any particular reason to pass this in as a flag vs. querying the inode?

Same reason as the addition of IOMAP_DAX.  But I think I'll redo this
a bit to do the XFS paramater passing first and then actually check
IOMAP_DAX together with introducing it to make it all a little more clear.
