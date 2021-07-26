Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A612FB0
	for <nvdimm@lists.linux.dev>; Mon, 26 Jul 2021 16:41:39 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id A078F6044F;
	Mon, 26 Jul 2021 16:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1627317699;
	bh=gzDT7wFMaBVM7jHMV9j2LnPXkhFzf2SkOgzgY0DWdco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dt7NiyJ6S0ebbg6JjN1J3hpYwMtBeuZFLHg4XctWD+PJT1VkkEkLiaVIv+Ax7oYIM
	 wouQol0HzZ0dJEwjW5dRnGama/EvRsKNsP+C1lSpYHFTBGjRFxQ5wDzp/eRC2rwK7+
	 I/2sVR1ncgrhp/P4K/kV9AGRFO5EmjUd2ZcPdSOcotZ0xBbN7RUHTVHmIjGD/tJEsI
	 LIbfakTnG02uhbYf4Z+mVfl+4qoEqfIqJgjaMWYwcHF6aGr/HYVpL+QylMGse0fklH
	 YDbCnHZmlb+VqxjZut4VysLwKaKZeUe7AuiRbflIG360pc6W3GTfIPfKwvhMwsZVbb
	 sw7t1KZqiaf7A==
Date: Mon, 26 Jul 2021 09:41:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 17/27] iomap: switch iomap_seek_hole to use iomap_iter
Message-ID: <20210726164139.GS559212@magnolia>
References: <20210719103520.495450-1-hch@lst.de>
 <20210719103520.495450-18-hch@lst.de>
 <20210719172247.GG22402@magnolia>
 <20210726082236.GE14853@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726082236.GE14853@lst.de>

On Mon, Jul 26, 2021 at 10:22:36AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 19, 2021 at 10:22:47AM -0700, Darrick J. Wong wrote:
> > > -static loff_t
> > > -iomap_seek_hole_actor(struct inode *inode, loff_t start, loff_t length,
> > > -		      void *data, struct iomap *iomap, struct iomap *srcmap)
> > > +static loff_t iomap_seek_hole_iter(const struct iomap_iter *iter, loff_t *pos)
> > 
> > /me wonders if @pos should be named hole_pos (here and in the caller) to
> > make it a little easier to read...
> 
> Sure.
> 
> > ...because what we're really saying here is that if seek_hole_iter found
> > a hole (and returned zero, thereby terminating the loop before iter.len
> > could reach zero), we want to return the position of the hole.
> 
> Yes.
> 
> > > +	return size;
> > 
> > Not sure why we return size here...?  Oh, because there's an implicit
> > hole at EOF, so we return i_size.  Uh, does this do the right thing if
> > ->iomap_begin returns posteof mappings?  I don't see anything in
> > iomap_iter_advance that would stop iteration at EOF.
> 
> Nothing in ->iomap_begin checks that, iomap_seek_hole initializes
> iter.len so that it stops at EOF.

Oh, right.  Sorry, I forgot that. :(

--D
