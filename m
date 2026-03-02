Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE8D407598
	for <nvdimm@lists.linux.dev>; Mon,  2 Mar 2026 15:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772464005; cv=none; b=gq7D17jn9KLmsmQ/z8cD10TetzOAf2+/JJuCji4Jg3CgJFSw/qdTHSCJzyywpCI4aOsuvfnlQ0Eiyz/8CXYRv7G0SpZQbfy5k9r52wqTinWqoyu7XrlCkUNL/E/r7p+kFJ54plpNc2eWobyD0oxd6Xal7JIbAGfKfkCsq4pBk50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772464005; c=relaxed/simple;
	bh=5744P+pGK+XyXUbnqiUcR4ppK8KbZz/PvWksth+Oz8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWj1qBms1oljW9Big/T/sXlbwdXF7ieRpp37/hFO/wO83aRLYg7+iQi11/XsH30xBMDFwc+vnnaVDDstoF/IDtjkMeIVMg74KC/y/p88QIwlBO4bI+yS0QwRL1rJaciOp+Rc9/dVL5dzs6Hu1c3SvjY24ZQ36Ah4mboUoXRQN8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13A571A01BC;
	Mon,  2 Mar 2026 15:06:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf05.hostedemail.com (Postfix) with ESMTPA id 2235B20010;
	Mon,  2 Mar 2026 15:06:25 +0000 (UTC)
Date: Mon, 2 Mar 2026 09:06:23 -0600
From: John Groves <John@groves.net>
To: Ackerley Tng <ackerleytng@google.com>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	John Groves <jgroves@fastmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Gregory Price <gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V7 02/19] dax: Factor out dax_folio_reset_order() helper
Message-ID: <aaWlxFh-bqUYXgUo@groves.net>
References: <0100019bd33b1f66-b835e86a-e8ae-443f-a474-02db88f7e6db-000000@email.amazonses.com>
 <20260118223110.92320-1-john@jagalactic.com>
 <0100019bd33bf5cc-3ab17b9e-cd67-4f0b-885e-55658a1207f0-000000@email.amazonses.com>
 <CAEvNRgHmfpx0BXPzt81DenKbyvQ1QwM5rZeJWMnKUO8fB8MeqA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEvNRgHmfpx0BXPzt81DenKbyvQ1QwM5rZeJWMnKUO8fB8MeqA@mail.gmail.com>
X-Stat-Signature: cq87gmedzk7x7r9ny9iist1ng64zruqa
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 2235B20010
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18sF70d1HqicCYqrH7vz+w2ws8l6S67ZfI=
X-HE-Tag: 1772463985-663465
X-HE-Meta: U2FsdGVkX19+wByPZPpcn3fFxdlS7efSS3Z9sfx2FbKmn+pO0ifUKq0ek7sbqcQSKckha/6QKB0dO38o4/5xEaBD+GsVsq7ETKFWcom7uRHSSn+RVp2j9JNOM/Vj30paav3NtmzU4PFup78HglM3hDeONluYWqykeNoY9+/HZXqJLcAm28+hN8/b030/2zXtfMMEyfxgHY/UmA3e1Sy8tR2hBLX7f4PnfVGd3ztqgPPlCvTkXDr77SPk3sW0FIEY7Sc7zV6DKmspXuu6y+44WrT7hu7h77kH7lp0l1mMiR4rrp96nReTeguCtrXqJdgiImk5Z17L0ZxaA7FMn3FzxVDz1xZoVZNrfTWMXAyyVaQRkd/slAXiwFd9Sk4SYq48vzEK1miTOhR/K8JA1pmO/lhXdIEt9BORVuZfc93ojrZt1rJbkmgV+Kgg5MKpQahN9r09EKJ14MBgVltwhztXEw==

On 26/02/23 07:00PM, Ackerley Tng wrote:
> John Groves <john@jagalactic.com> writes:
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
> > Signed-off-by: John Groves <john@groves.net>
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
> > +
> > +	if (!order) {
> > +		folio->pgmap = pgmap;
> > +		return 0;
> > +	}
> > +
> > +	folio_reset_order(folio);
> > +
> > +	for (i = 0; i < (1UL << order); i++) {
> > +		struct page *page = folio_page(folio, i);
> > +		struct folio *f = (struct folio *)page;
> > +
> > +		ClearPageHead(page);
> > +		clear_compound_head(page);
> > +		f->mapping = NULL;
> > +		f->share = 0;
> > +		f->pgmap = pgmap;
> > +	}
> > +
> > +	return order;
> > +}
> > +
> 
> I'm implementing something similar for guest_memfd and was going to
> reuse __split_folio_to_order(). Would you consider using the
> __split_folio_to_order() function?
> 
> I see that dax_folio_reset_order() needs to set f->share to 0 though,
> which is a union with index, and __split_folio_to_order() sets non-0
> indices.
> 
> Also, __split_folio_to_order() doesn't handle f->pgmap (or f->lru).
> 
> Could these two steps be added to a separate loop after
> __split_folio_to_order()?
> 
> Does dax_folio_reset_order() need to handle any of the folio flags that
> __split_folio_to_order() handles?

Sorry to reply slowly; this took some thought.

I'm nervous about sharing folio initialization code between the page cache
and dax. Might this be something we could unify after the fact - if it
passes muster? 

Unifying paths like this could be regression-prone (page cache changes
breaking dax or vice versa) unless it's really well conceived...

> 
> >  static inline unsigned long dax_folio_put(struct folio *folio)
> >  {
> >  	unsigned long ref;
> > @@ -391,28 +430,13 @@ static inline unsigned long dax_folio_put(struct folio *folio)
> >  	if (ref)
> >  		return ref;
> >
> > -	folio->mapping = NULL;
> > -	order = folio_order(folio);
> > -	if (!order)
> > -		return 0;
> > -	folio_reset_order(folio);
> > +	order = dax_folio_reset_order(folio);
> >
> > +	/* Debug check: verify refcounts are zero for all sub-folios */
> >  	for (i = 0; i < (1UL << order); i++) {
> > -		struct dev_pagemap *pgmap = page_pgmap(&folio->page);
> >  		struct page *page = folio_page(folio, i);
> > -		struct folio *new_folio = (struct folio *)page;
> >
> > -		ClearPageHead(page);
> > -		clear_compound_head(page);
> > -
> > -		new_folio->mapping = NULL;
> > -		/*
> > -		 * Reset pgmap which was over-written by
> > -		 * prep_compound_page().
> > -		 */
> 
> Actually, where's the call to prep_compound_page()? Was that in
> dax_folio_init()? Is this comment still valid and does pgmap have to be
> reset?

Yep, in dax_folio_init()...


Thanks,
John

[snip]

