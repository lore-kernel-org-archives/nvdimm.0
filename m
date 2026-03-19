Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4CA35A39A
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 11:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773919869; cv=none; b=OBdoEp+Unvvp+yv9Q2ujJv3pyQ41jISTnetcTMaMMsZ/+1uuQImcUQEHju4ixAmCRaQEccOu+kqinWd1F6lvMTWMS/+Hf5AAh/rS9jN/eMB7P4Ris0gRIZwc+g9t8WjPpWUVViY0yMP1Nv9WPxDkPMmE9ZGIBYxsKNKBdGC8hvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773919869; c=relaxed/simple;
	bh=b+7RcJSueeqt48hizPCHd9UO8vXbtlmIK/V89+m/sVo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WoNd7XlME0cqRfYz2MWycvogNGSvmKwLIWfx8vz2qBaVBdAo2jMM3WaVx/NQsTSn61WeYxK2pWF8uc4WzWfVc+G7SnJEfzdFxmJv8dBzSSozMKoA9ap4G3UkqM0rZOh186SBMBwu+wxQOhCLzwE/XzgmL0iBOGN9CJyqdW4LPYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fc3QH1WwkzJ469d;
	Thu, 19 Mar 2026 19:29:59 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A64640569;
	Thu, 19 Mar 2026 19:30:58 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Mar
 2026 11:30:56 +0000
Date: Thu, 19 Mar 2026 11:30:55 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: John Groves <john@groves.net>
CC: Miklos Szeredi <miklos@szeredi.hu>, Dan Williams
	<dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, "Alison
 Schofield" <alison.schofield@intel.com>, John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong"
	<djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Jeff Layton
	<jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi
	<shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, Josef Bacik
	<josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan
	<chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba
	<tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank Garg
	<shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, <venkataravis@micron.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH V8 2/8] dax: Factor out dax_folio_reset_order() helper
Message-ID: <20260319113055.00001182@huawei.com>
In-Reply-To: <20260319012820.4420-1-john@groves.net>
References: <20260318202737.4344.dax@groves.net>
	<20260319012820.4420-1-john@groves.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Wed, 18 Mar 2026 20:28:20 -0500
John Groves <john@groves.net> wrote:

> From: John Groves <John@Groves.net>
> 
> Both fs/dax.c:dax_folio_put() and drivers/dax/fsdev.c:
> fsdev_clear_folio_state() (the latter coming in the next commit after this
> one) contain nearly identical code to reset a compound DAX folio back to
> order-0 pages. Factor this out into a shared helper function.
> 
> The new dax_folio_reset_order() function:
> - Clears the folio's mapping and share count
> - Resets compound folio state via folio_reset_order()
> - Clears PageHead and compound_head for each sub-page
> - Restores the pgmap pointer for each resulting order-0 folio
> - Returns the original folio order (for callers that need to advance by
>   that many pages)
> 
> This simplifies fsdev_clear_folio_state() from ~50 lines to ~15 lines while
> maintaining the same functionality in both call sites.
> 
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: John Groves <john@groves.net>

Comment below. I may well be needing more coffee, or failing wrt
to background knowledge as I only occasionally dip into dax.


> ---
>  fs/dax.c | 60 +++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 42 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 289e6254aa30..7d7bbfb32c41 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -378,6 +378,45 @@ static void dax_folio_make_shared(struct folio *folio)
>  	folio->share = 1;
>  }
>  
> +/**
> + * dax_folio_reset_order - Reset a compound DAX folio to order-0 pages
> + * @folio: The folio to reset
> + *
> + * Splits a compound folio back into individual order-0 pages,
> + * clearing compound state and restoring pgmap pointers.
> + *
> + * Returns: the original folio order (0 if already order-0)
> + */
> +int dax_folio_reset_order(struct folio *folio)
> +{
> +	struct dev_pagemap *pgmap = page_pgmap(&folio->page);
> +	int order = folio_order(folio);
> +	int i;
> +
> +	folio->mapping = NULL;
> +	folio->share = 0;

This is different from the code you are replacing..

Just above the call to this in dax_folio_put()

if (!dax_folio_is_shared(folio))
// in here is the interesting bit...
	ref = 0;
else
//this is fine because either it's still > 0 and we return
//or it is zero and you are writing that again.
	ref = --folio->share;
if (ref)
	return ref;

So the path that bothers me is if 
!dax_folio_is_shared() can return false with shared != 0

/*
 * A DAX folio is considered shared if it has no mapping set and ->share (which
 * shares the ->index field) is non-zero. Note this may return false even if the
 * page is shared between multiple files but has not yet actually been mapped
 * into multiple address spaces.
 */
static inline bool dax_folio_is_shared(struct folio *folio)
{
	return !folio->mapping && folio->share;
}

So it can if !folio->mapping is false (i.e. folio->mapping is set)

Now I have zero idea of whether this is a real path and have
a long review queue so not looking into it for now.
However if it's not then I'd expect some commentary in the patch description
to say why it's not a problem.  Maybe even a precursor patch adding
the folio->share so there is a place to state clearly that it doesn't
matter and why.

> +
> +	if (!order) {
> +		folio->pgmap = pgmap;
This is also different...

> +		return 0;
> +	}
> +
> +	folio_reset_order(folio);
> +
> +	for (i = 0; i < (1UL << order); i++) {

I'd take advantage of evolving conventions and do

	for (int i = 0; i < ...) 

> +		struct page *page = folio_page(folio, i);
> +		struct folio *f = (struct folio *)page;
> +
> +		ClearPageHead(page);
> +		clear_compound_head(page);
> +		f->mapping = NULL;
> +		f->share = 0;
> +		f->pgmap = pgmap;
> +	}
> +
> +	return order;
> +}
> +
>  static inline unsigned long dax_folio_put(struct folio *folio)
>  {
>  	unsigned long ref;
> @@ -391,28 +430,13 @@ static inline unsigned long dax_folio_put(struct folio *folio)
>  	if (ref)
>  		return ref;
>  
> -	folio->mapping = NULL;
> -	order = folio_order(folio);
> -	if (!order)
> -		return 0;
> -	folio_reset_order(folio);
> +	order = dax_folio_reset_order(folio);
>  
> +	/* Debug check: verify refcounts are zero for all sub-folios */
>  	for (i = 0; i < (1UL << order); i++) {
> -		struct dev_pagemap *pgmap = page_pgmap(&folio->page);
>  		struct page *page = folio_page(folio, i);
> -		struct folio *new_folio = (struct folio *)page;
>  
> -		ClearPageHead(page);
> -		clear_compound_head(page);
> -
> -		new_folio->mapping = NULL;
> -		/*
> -		 * Reset pgmap which was over-written by
> -		 * prep_compound_page().
> -		 */
> -		new_folio->pgmap = pgmap;
> -		new_folio->share = 0;
> -		WARN_ON_ONCE(folio_ref_count(new_folio));
> +		WARN_ON_ONCE(folio_ref_count((struct folio *)page));
>  	}
>  
>  	return ref;

