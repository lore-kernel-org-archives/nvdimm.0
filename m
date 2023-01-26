Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5DC1C06
	for <nvdimm@lists.linux.dev>; Thu, 26 Jan 2023 05:30:30 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6D8C568D0A; Thu, 26 Jan 2023 06:30:26 +0100 (CET)
Date: Thu, 26 Jan 2023 06:30:25 +0100
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
Subject: Re: [PATCH 2/7] mm: remove the swap_readpage return value
Message-ID: <20230126053025.GB28355@lst.de>
References: <20230125133436.447864-1-hch@lst.de> <20230125133436.447864-3-hch@lst.de> <Y9FRpwaiee2GaOm+@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9FRpwaiee2GaOm+@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 25, 2023 at 08:58:31AM -0700, Keith Busch wrote:
> On Wed, Jan 25, 2023 at 02:34:31PM +0100, Christoph Hellwig wrote:
> > -static inline int swap_readpage(struct page *page, bool do_poll,
> > -				struct swap_iocb **plug)
> > +static inline void swap_readpage(struct page *page, bool do_poll,
> > +		struct swap_iocb **plug)
> >  {
> >  	return 0;
> >  }
> 
> Need to remove the 'return 0'.

Yes.
