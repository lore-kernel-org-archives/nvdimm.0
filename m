Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AE32F12AF
	for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 00:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774052894; cv=none; b=oTkzFo8z6J3A7ej5qaNtEItX/zLy6rpPazA7q38BuEl9OTnELLvgJaqAFWz5AeL+O/oWtcNiIP6AMORwdp/ngt6oMNiB4ZaNNKH5heNjKSqU9tkF0eCCy5CESPEtop5xiUpOWI9WJg6Z1UunJr5EN9IAYN0emRgFsJmQXOlXB4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774052894; c=relaxed/simple;
	bh=wC6szQCqJZuY+Q9qJeJKyn6sqxCTs+A2/WskussJ2dY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HrK23I18WV0xG9iiXF5ipqWlt6Jcr4G6yz9inDWgGxCsQLOq8Qu8u1Dr6V6jQ2GDxDBd4FFprTyTFO8MmnjyXwfv82160HbYLjE8+OdBGcR0q7yy7ICllOg0uGuw2Je6VPTQ2KwqXK8DEvoIXTE6wekckWsEA638OKh6spEGqz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 496E8140472;
	Sat, 21 Mar 2026 00:28:02 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf09.hostedemail.com (Postfix) with ESMTPA id BFF362002A;
	Sat, 21 Mar 2026 00:27:49 +0000 (UTC)
Date: Fri, 20 Mar 2026 19:27:47 -0500
From: John Groves <john@groves.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH V8 2/8] dax: Factor out dax_folio_reset_order() helper
Message-ID: <ab3lBTsWadqh6Eeu@groves.net>
References: <20260318202737.4344.dax@groves.net>
 <20260319012820.4420-1-john@groves.net>
 <20260319113055.00001182@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319113055.00001182@huawei.com>
X-Stat-Signature: io611885a3m65o4m8sgw4p1giccihgro
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: BFF362002A
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1/XeKQN2rh6FlNJIEhuaIZ9qtyi7+yXf4A=
X-HE-Tag: 1774052869-390546
X-HE-Meta: U2FsdGVkX188nkdXDqauVEIadXau6m45CjW7r70wKOrmsu604ksuKmEIjeaPzFT3x8LmZcyLqlLZJ5j6TFbsbfUTcj69Te9SRiT3vZ1IXIVEpMrmUBDsQgPNfbhnvu91xkaAa0TpkPmmq4eJkuwDGeXrhlp8+xK1BIAwqzv6SBUZSKD/zYl5WeFkmliAroyUhUTSTeltlx+M2D+ltG3r4081ZLvqKUdz3a3UJRzBT/Ae25RpnNzzAwpXsE8/TNuxslEUby5uIZIMGdLNl+ULP7rjgc07Sgj0oltOVymGsX5Z4ViCgOUBoxnFAfYQFfscQ52m4NHGLP5lo8IATwKNe1FFlNN4+KMof0DvLEFNqEqs2/t0ZWnPAewA3480RFb69E22cf7rvcwhM5lx0Zbk3Udy/Uenckvvf2UZ/Epf7X8=

On 26/03/19 11:30AM, Jonathan Cameron wrote:
> On Wed, 18 Mar 2026 20:28:20 -0500
> John Groves <john@groves.net> wrote:
> 
> > From: John Groves <John@Groves.net>
> > 
> > Both fs/dax.c:dax_folio_put() and drivers/dax/fsdev.c:
> > fsdev_clear_folio_state() (the latter coming in the next commit after this
> > one) contain nearly identical code to reset a compound DAX folio back to
> > order-0 pages. Factor this out into a shared helper function.
> > 
> > The new dax_folio_reset_order() function:
> > - Clears the folio's mapping and share count
> > - Resets compound folio state via folio_reset_order()
> > - Clears PageHead and compound_head for each sub-page
> > - Restores the pgmap pointer for each resulting order-0 folio
> > - Returns the original folio order (for callers that need to advance by
> >   that many pages)
> > 
> > This simplifies fsdev_clear_folio_state() from ~50 lines to ~15 lines while
> > maintaining the same functionality in both call sites.
> > 
> > Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Signed-off-by: John Groves <john@groves.net>
> 
> Comment below. I may well be needing more coffee, or failing wrt
> to background knowledge as I only occasionally dip into dax.

thanks!

> 
> 
> > ---
> >  fs/dax.c | 60 +++++++++++++++++++++++++++++++++++++++-----------------
> >  1 file changed, 42 insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 289e6254aa30..7d7bbfb32c41 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -378,6 +378,45 @@ static void dax_folio_make_shared(struct folio *folio)
> >  	folio->share = 1;
> >  }
> >  
> > +/**
> > + * dax_folio_reset_order - Reset a compound DAX folio to order-0 pages
> > + * @folio: The folio to reset
> > + *
> > + * Splits a compound folio back into individual order-0 pages,
> > + * clearing compound state and restoring pgmap pointers.
> > + *
> > + * Returns: the original folio order (0 if already order-0)
> > + */
> > +int dax_folio_reset_order(struct folio *folio)
> > +{
> > +	struct dev_pagemap *pgmap = page_pgmap(&folio->page);
> > +	int order = folio_order(folio);
> > +	int i;
> > +
> > +	folio->mapping = NULL;
> > +	folio->share = 0;
> 
> This is different from the code you are replacing..
> 
> Just above the call to this in dax_folio_put()
> 
> if (!dax_folio_is_shared(folio))
> // in here is the interesting bit...
> 	ref = 0;
> else
> //this is fine because either it's still > 0 and we return
> //or it is zero and you are writing that again.
> 	ref = --folio->share;
> if (ref)
> 	return ref;
> 
> So the path that bothers me is if 
> !dax_folio_is_shared() can return false with shared != 0
> 
> /*
>  * A DAX folio is considered shared if it has no mapping set and ->share (which
>  * shares the ->index field) is non-zero. Note this may return false even if the
>  * page is shared between multiple files but has not yet actually been mapped
>  * into multiple address spaces.
>  */
> static inline bool dax_folio_is_shared(struct folio *folio)
> {
> 	return !folio->mapping && folio->share;
> }
> 
> So it can if !folio->mapping is false (i.e. folio->mapping is set)
> 
> Now I have zero idea of whether this is a real path and have
> a long review queue so not looking into it for now.
> However if it's not then I'd expect some commentary in the patch description
> to say why it's not a problem.  Maybe even a precursor patch adding
> the folio->share so there is a place to state clearly that it doesn't
> matter and why.

I believe it is correct, and I'm adding a clarifying comment above as follows:

	/*
	 * DAX maintains the invariant that folio->share != 0 only when
	 * folio->mapping == NULL (enforced by dax_folio_make_shared()).
	 * Equivalently: folio->mapping != NULL implies folio->share == 0.
	 * Callers ensure share has been decremented to zero before calling
	 * here, so unconditionally clearing both fields is correct.
	 */
	folio->mapping = NULL;
	folio->share = 0;
	...

> 
> > +
> > +	if (!order) {
> > +		folio->pgmap = pgmap;
> This is also different...

Here too, I think it is correct, and I'm adding a comment as follows:

	if (!order) {
		/*
		 * Restore pgmap explicitly even for order-0 folios. For the
		 * dax_folio_put() caller this is a no-op (same value), but
		 * fsdev_clear_folio_state() may call this on folios that were
		 * previously compound and need pgmap re-established.
		 */
		folio->pgmap = pgmap;
		return 0;
	}

...but if I'm missing anything I hope somebody will point it out!

> 
> > +		return 0;
> > +	}
> > +
> > +	folio_reset_order(folio);
> > +
> > +	for (i = 0; i < (1UL << order); i++) {
> 
> I'd take advantage of evolving conventions and do
> 
> 	for (int i = 0; i < ...) 

Done, thanks!

John

<snip>

