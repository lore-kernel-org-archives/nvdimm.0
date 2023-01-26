Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FBD1C17
	for <nvdimm@lists.linux.dev>; Thu, 26 Jan 2023 05:30:30 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7936068D09; Thu, 26 Jan 2023 06:30:18 +0100 (CET)
Date: Thu, 26 Jan 2023 06:30:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/7] block: remove ->rw_page
Message-ID: <20230126053017.GA28355@lst.de>
References: <20230125133436.447864-1-hch@lst.de> <20230125133436.447864-8-hch@lst.de> <Y9FYsXgo9pVJ5weX@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9FYsXgo9pVJ5weX@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 25, 2023 at 09:28:33AM -0700, Keith Busch wrote:
> On Wed, Jan 25, 2023 at 02:34:36PM +0100, Christoph Hellwig wrote:
> > @@ -363,8 +384,10 @@ void __swap_writepage(struct page *page, struct writeback_control *wbc)
> >  	 */
> >  	if (data_race(sis->flags & SWP_FS_OPS))
> >  		swap_writepage_fs(page, wbc);
> > +	else if (sis->flags & SWP_SYNCHRONOUS_IO)
> > +		swap_writepage_bdev_sync(page, wbc, sis);
> 
> For an additional cleanup, it looks okay to remove the SWP_SYNCHRONOUS_IO flag
> entirely and just check bdev_synchronous(sis->bdev)) directly instead.

The swap code relatively consistently maps bdev flags to SWP_* flags,
including SWP_STABLE_WRITES, SWAP_FLAG_DISCARD and the somewhat misnamed
SWP_SOLIDSTATE.   So if we want to change that it's probably a separate
series.
