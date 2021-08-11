Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6B317F
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 05:38:59 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 66E0A6736F; Wed, 11 Aug 2021 07:38:56 +0200 (CEST)
Date: Wed, 11 Aug 2021 07:38:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 11/30] iomap: add the new iomap_iter model
Message-ID: <20210811053856.GA1934@lst.de>
References: <20210809061244.1196573-1-hch@lst.de> <20210809061244.1196573-12-hch@lst.de> <20210811003118.GT3601466@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811003118.GT3601466@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 10, 2021 at 05:31:18PM -0700, Darrick J. Wong wrote:
> > +static inline void iomap_iter_done(struct iomap_iter *iter)
> 
> I wonder why this is a separate function, since it only has debugging
> warnings and tracepoints?

The reason for these two sub-helpers was to force me to structure the
code so that Matthews original idea of replacing ->iomap_begin and
->iomap_end with a single next callback so that iomap_iter could
be inlined into callers and the indirect calls could be elided is
still possible.  This would only be useful for a few specific
methods (probably dax and direct I/O) where we care so much, but it
seemed like a nice idea conceptually so I would not want to break it.

OTOH we could just remove this function for now and do that once needed.

> Modulo the question about iomap_iter_done, I guess this looks all right
> to me.  As far as apply.c vs. core.c, I'm not wildly passionate about
> either naming choice (I would have called it iter.c) but ... fmeh.

iter.c is also my preference, but in the end I don't care too much.

