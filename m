Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76933FE34E
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 14:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774362233; cv=none; b=a6xx9gsp+xTh09hUfJEf4hosgRCLu33orTYXEc4vRerNGxM/sAR3yDe99qfD/wacHYcpvEktdyLQDDH8rqwvZZLmeTj3/5k725oJ7NLevlIL5wQx1FKOH9BSajLt/9f35fRUGWpSjRPTjDxm4bmXTRaYyZGNN8rD3Jt5Hdduzo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774362233; c=relaxed/simple;
	bh=WJr6YvjXtOKVuf68g9gSWSiMHSUdZSG1+XV+/wctW9Y=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DDurrt882eTAP6XZ6Emk1FWdFmzvRYML+8leWsTiUK71n9lO9uQXf0oznnkAYfmiW0UufQQZ9QmbebWNo7YylTjii1oeDRVFd+BsWF2X4J8vvixp1zUY3GKzM7uaSqNrMsPFJB8ChxEZBZSt4bKqYVNa4Gkh/Y7CfCZBEnO9jSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fgC2Q4lDFzJ467N;
	Tue, 24 Mar 2026 22:23:42 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id A38A34056E;
	Tue, 24 Mar 2026 22:23:49 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 24 Mar
 2026 14:23:48 +0000
Date: Tue, 24 Mar 2026 14:23:46 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@Groves.net>, Miklos Szeredi <miklos@szeredi.hu>, "Dan
 Williams" <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>, John Groves
	<jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, "David
 Hildenbrand" <david@kernel.org>, Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Stefan
 Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, Josef
 Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, Chen
 Linxuan <chenlinxuan@uniontech.com>, "James Morse" <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>, "Sean Christopherson" <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay
 Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com"
	<venkataravis@micron.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH V9 2/8] dax: Factor out dax_folio_reset_order() helper
Message-ID: <20260324142346.00002edc@huawei.com>
In-Reply-To: <0100019d1d47285f-eedfbde4-0f74-4356-b694-4b44fab92f2c-000000@email.amazonses.com>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
	<20260324003756.4990-1-john@jagalactic.com>
	<0100019d1d47285f-eedfbde4-0f74-4356-b694-4b44fab92f2c-000000@email.amazonses.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Tue, 24 Mar 2026 00:38:15 +0000
John Groves <john@jagalactic.com> wrote:

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
> Two intentional differences from the original dax_folio_put() logic:
> 
> 1. folio->share is cleared unconditionally. This is correct because the DAX
>    subsystem maintains the invariant that share != 0 only when mapping == NULL
>    (enforced by dax_folio_make_shared()). dax_folio_put() ensures share has
>    reached zero before calling this helper, so the unconditional clear is safe.
> 
> 2. folio->pgmap is now explicitly restored for order-0 folios. For the
>    dax_folio_put() caller this is a no-op (reads and writes back the same
>    field). It is intentional for the upcoming fsdev_clear_folio_state()
>    caller, which converts previously-compound folios and needs pgmap
>    re-established for all pages regardless of order.
> 
> This simplifies fsdev_clear_folio_state() from ~50 lines to ~15 lines.
> 
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
A couple of trivial "if you are respinning" line length of comments
comments inline.
Subject to DAX folk sanity checking the new comments match their
expectations.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/dax.c            | 74 ++++++++++++++++++++++++++++++++++-----------
>  include/linux/dax.h |  1 +
>  2 files changed, 57 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 289e6254aa30..eba86802a7a7 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -378,6 +378,59 @@ static void dax_folio_make_shared(struct folio *folio)
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
> +
> +	/*
> +	 * DAX maintains the invariant that folio->share != 0 only when
> +	 * folio->mapping == NULL (enforced by dax_folio_make_shared()).
> +	 * Equivalently: folio->mapping != NULL implies folio->share == 0.
> +	 * Callers ensure share has been decremented to zero before
> +	 * calling here, so unconditionally clearing both fields is
> +	 * correct.

If you happen to spin again, wrap is a bit short of standard 80 chars.
	 * DAX maintains the invariant that folio->share != 0 only when
	 * folio->mapping == NULL (enforced by dax_folio_make_shared()).
	 * Equivalently: folio->mapping != NULL implies folio->share == 0.
	 * Callers ensure share has been decremented to zero before calling here,
	 * so unconditionally clearing both fields is correct.
> +	 */
> +	folio->mapping = NULL;
> +	folio->share = 0;
> +
> +	if (!order) {
> +		/*
> +		 * Restore pgmap explicitly even for order-0 folios. For
> +		 * the dax_folio_put() caller this is a no-op (same value),
> +		 * but fsdev_clear_folio_state() may call this on folios
> +		 * that were previously compound and need pgmap
> +		 * re-established.
> +		 */
		 * Restore pgmap explicitly even for order-0 folios. For the
		 * dax_folio_put() caller this is a no-op (same value), but
		 * fsdev_clear_folio_state() may call this on folios that were
		 * previously compound and need pgmap re-established.
		 */

> +		folio->pgmap = pgmap;
> +		return 0;
> +	}
> +
> +	folio_reset_order(folio);
> +
> +	for (int i = 0; i < (1UL << order); i++) {
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

