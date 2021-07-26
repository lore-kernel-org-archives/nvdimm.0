Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340D970
	for <nvdimm@lists.linux.dev>; Mon, 26 Jul 2021 08:22:43 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1A49667373; Mon, 26 Jul 2021 10:22:38 +0200 (CEST)
Date: Mon, 26 Jul 2021 10:22:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 17/27] iomap: switch iomap_seek_hole to use iomap_iter
Message-ID: <20210726082236.GE14853@lst.de>
References: <20210719103520.495450-1-hch@lst.de> <20210719103520.495450-18-hch@lst.de> <20210719172247.GG22402@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719172247.GG22402@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 19, 2021 at 10:22:47AM -0700, Darrick J. Wong wrote:
> > -static loff_t
> > -iomap_seek_hole_actor(struct inode *inode, loff_t start, loff_t length,
> > -		      void *data, struct iomap *iomap, struct iomap *srcmap)
> > +static loff_t iomap_seek_hole_iter(const struct iomap_iter *iter, loff_t *pos)
> 
> /me wonders if @pos should be named hole_pos (here and in the caller) to
> make it a little easier to read...

Sure.

> ...because what we're really saying here is that if seek_hole_iter found
> a hole (and returned zero, thereby terminating the loop before iter.len
> could reach zero), we want to return the position of the hole.

Yes.

> > +	return size;
> 
> Not sure why we return size here...?  Oh, because there's an implicit
> hole at EOF, so we return i_size.  Uh, does this do the right thing if
> ->iomap_begin returns posteof mappings?  I don't see anything in
> iomap_iter_advance that would stop iteration at EOF.

Nothing in ->iomap_begin checks that, iomap_seek_hole initializes
iter.len so that it stops at EOF.
