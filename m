Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9DF2773F9
	for <nvdimm@lists.linux.dev>; Tue, 24 Feb 2026 03:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771902020; cv=pass; b=N5Bnt2/HuathF9ALTzuQSlgB5UNe0fSPULrtF1i9GnDahp1XHf9YaAJoLNuEwIvj41wI9s0CXMtCf5ZxF1+SrgR8Z+0Wk6H6Wyvxn6MlwKjsy1B+5/nYlw6enpx08BSO7Fsfoe1AXp2TkcLso98DbAWXtJNYmLSPNisz9LQMfCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771902020; c=relaxed/simple;
	bh=URG9p5PA0AV/5bQlXeYXvRn2vYf4zuMTvunUlPWBpFY=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PZMpDdLJ18MDmfWNEiqV+71oxPTfTdQpj5Tnh8aD3o8Dg1vgf6F7NQf+NBmO7G3i3gynokMhC3l2IPxYt9qFBAFcUf11jXE6KfUDDNzdVp4/A051nBqoNtl47SLVepz1dgkdSf/Z+0b0xN8cu732wM+z6JanlP1pL01ove9HHIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RSoRmdIz; arc=pass smtp.client-ip=209.85.217.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RSoRmdIz"
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-5fc41f88ff1so1308587137.2
        for <nvdimm@lists.linux.dev>; Mon, 23 Feb 2026 19:00:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771902017; cv=none;
        d=google.com; s=arc-20240605;
        b=GSoWJdk7SHmNkCRtEO/47s2HhgmkvnDzu9/AayevNzkhbgeop9Zj3edcCP/ZBgg7BN
         YBXxsPC/knCpz5cohETtuZbGi9az7csgzEryFidSGsQsN0AmYJg7aX5pfKA1ypFhTcPA
         wSvidRoRpLSDm+0ngWv5dFsdcodJ0cG0NR2XWiEUoxvrfTRN3CquEJsREzi0TuLckLl+
         CagjwCPt5R0paTRDSYIWNAuXeOLA8IezuZ5FvW/nbtxMIdTKombygBkSes8YJhUmENkI
         aGTwNlVt4Uzyx0YVeF35zpBRP1IzsR/jcAlLpzVb5H34d5HzmY4zWaNqRw9vW7bAMpLY
         G3lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=xFe8WdiYvRsGLyynpqXx4xXBoM9FyyzukwEjWl1pbts=;
        fh=kjFUhHdFAvhOBYjBJfxwexSYfrahOcOIDkoJv3oy2dQ=;
        b=g6KekqzlOoY+TyDSBKi7TzK2aEdRSmpsVzsnuiWqtXAFXAGKp21Bft16UAxY0045vZ
         Zb3qY/3PHk3gV+/1mRM9zqYD9GW6v3DRPhRmejgUJgkrC41+JRruF6fvOXwBTaqjB7n9
         4Cg/I4fu1xBkVzgcqT3pL+UsuScYk5QaSZEb8O1riltv1DfPdzSqhMSTXDAms90sbOwL
         enmZsK7FpEgz07Q5UyYfF1z7lS5nfvzkLTuleumrQCod8xaCOd7SUKMWlt/8GB5UAAPN
         6UWzK/BNIIBlsz25KXgo7DFNMvcBChpj3tGApLne2sFgb3L7ogW1eKT0SJw9atH50YfR
         sUuA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771902017; x=1772506817; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xFe8WdiYvRsGLyynpqXx4xXBoM9FyyzukwEjWl1pbts=;
        b=RSoRmdIzU+djOqg+jcuHkQ4x7S0dAAunN3HE4XCn3LlUqKtijxklt0321UXvwd2YNs
         O7XMkot9/01+eUJE6w7esJV/PkPAxgX7isYRhlc4qDYQbkYfYf1bDbX6e8Ry4dbozfUQ
         xFyLSZ5hnTZSUYABmRptxM2Ja6EcSZGlcmI6/lMxGdfUzjaOfeo62fa6WHf2zcVZsV+j
         z4N78u7+OCk3mbw+HCZIiTiagS65ZWRrqYSvPsSFc9xQkSI4urxmCzIsrjzkJc8CbMMZ
         j0Dl466uXiXQ3VtRgUXxTl9ULuWlihRAs9Whu34ME5iMTrJwbqCGDjxQl0UEpz/424xs
         zDbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771902017; x=1772506817;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xFe8WdiYvRsGLyynpqXx4xXBoM9FyyzukwEjWl1pbts=;
        b=HH5b36HtX16CgLEOAl/58gUCyq2BaMj4KqItlEeeOZv9tzCleadTx3aMGQjypnEwdb
         adX9pu5SP3oHbMRLW81ySM+1fvrv1AKNkL//t39zttEnJwcyFpKe/5wvWqQlN3tMYLeA
         FCDvXqXdZSIY53tgqep3lDtJgkbnwieipP4C8ZraNP9XqLbJ0JYQOQy0LmGijmzthF9S
         yhJY7d51Bq9Gbhs5Pua5iDNEON1xUsl6x0KbCsVb2/Sn+7RRi4uKoXgD1gmx6At9jZWS
         yALqV4ksKw+JKbu+a+7Hr65RMfc+y46xcQGk5Xkcbx+n3sAx1vyi716Y3pcStat6C//s
         jPbw==
X-Forwarded-Encrypted: i=1; AJvYcCV0KB/wVJS7Db1FFwG0UXcCFsG+7O7PiHzNJfHtB0JHnDeZ/eEf+OakL0aLyT3vitTvUlgvfFc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKbsXapP9mIM0+dV1oUZYfLxNDW7iCwmE3qEWSibXmvWWlSiud
	G1B1d6VUNWnKTvXVnDdapDHHDRLfua6K5msYqJBQr50cPsxHFCcrUK6IhSU8R7pDf/OWxMfY5hS
	LVbEQ8vGbd5YLp8owfXh10HTZj3JzvzxQ6JM2ZjZt
X-Gm-Gg: ATEYQzzocgWgAmu/FLXW1z4dq4FlDM0mEa62f0MCR01icsRznLS73kWSJxL+hwM/Fy+
	GnMT7HoyxN82PI2F+tYQuZcj0USOIjfEaM2xAtflBNv1jachMlvO72jHpztMZqCHDTeI7QiIr5l
	8eHaRsZtlynpDa+GZcnlC6L3eHVpTLmeCSdwe2P6Umm67kdWe/kjYf0BAZtE/TdAWTbidLDXwiK
	XIcE5yIoGBAcM6dFcRygMf4ULBLbS+llkOye7160Ja8CAlsm5ChrF8O4u1M9f9VEpmWdyH0Zcg9
	xyytldfHj3hbTPmKWfWA3mUT4hIT1MI4LrkPDicWj7jOZKydqch/ZzvYJv5U3Eu39w==
X-Received: by 2002:a05:6102:3048:b0:5f8:e2cb:d245 with SMTP id
 ada2fe7eead31-5feb2c23567mr4062890137.0.1771902016820; Mon, 23 Feb 2026
 19:00:16 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Feb 2026 19:00:16 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Feb 2026 19:00:16 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <0100019bd33bf5cc-3ab17b9e-cd67-4f0b-885e-55658a1207f0-000000@email.amazonses.com>
References: <0100019bd33b1f66-b835e86a-e8ae-443f-a474-02db88f7e6db-000000@email.amazonses.com>
 <20260118223110.92320-1-john@jagalactic.com> <0100019bd33bf5cc-3ab17b9e-cd67-4f0b-885e-55658a1207f0-000000@email.amazonses.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 23 Feb 2026 19:00:16 -0800
X-Gm-Features: AaiRm52vebMvqU0lH0n0vOtDAX6OI7Y7um56VSKnaZ96AOmxaI9gmZymUaqHfu0
Message-ID: <CAEvNRgHmfpx0BXPzt81DenKbyvQ1QwM5rZeJWMnKUO8fB8MeqA@mail.gmail.com>
Subject: Re: [PATCH V7 02/19] dax: Factor out dax_folio_reset_order() helper
To: John Groves <john@jagalactic.com>, John Groves <John@groves.net>, 
	Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>, John Groves <jgroves@fastmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

John Groves <john@jagalactic.com> writes:

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
> Signed-off-by: John Groves <john@groves.net>
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
> +
> +	if (!order) {
> +		folio->pgmap = pgmap;
> +		return 0;
> +	}
> +
> +	folio_reset_order(folio);
> +
> +	for (i = 0; i < (1UL << order); i++) {
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

I'm implementing something similar for guest_memfd and was going to
reuse __split_folio_to_order(). Would you consider using the
__split_folio_to_order() function?

I see that dax_folio_reset_order() needs to set f->share to 0 though,
which is a union with index, and __split_folio_to_order() sets non-0
indices.

Also, __split_folio_to_order() doesn't handle f->pgmap (or f->lru).

Could these two steps be added to a separate loop after
__split_folio_to_order()?

Does dax_folio_reset_order() need to handle any of the folio flags that
__split_folio_to_order() handles?

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

Actually, where's the call to prep_compound_page()? Was that in
dax_folio_init()? Is this comment still valid and does pgmap have to be
reset?

> -		new_folio->pgmap = pgmap;
> -		new_folio->share = 0;
> -		WARN_ON_ONCE(folio_ref_count(new_folio));
> +		WARN_ON_ONCE(folio_ref_count((struct folio *)page));
>  	}
>
>  	return ref;
> --
> 2.52.0
