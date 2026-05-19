Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3597A233952;
	Tue, 19 May 2026 11:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779190487; cv=none; b=ewbFCcyBbghqjbKP3PqnZAOpfV50W6/xwVf9ZJe3v8At0+aCtbEks2J41Y3Q0pUKjakLAy8o+XeA1ZSUd7u/BI5qbHChnvQQR8QI1UH+pb6q6kipIuPXcIhkUjzAabPyJxgZkQLJucbDvpbqFfYWnDeLt+KBZTY/XgZLEtUjYY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779190487; c=relaxed/simple;
	bh=dYBNK9BCQHghU8qmFx2G1DFK6xWsL7Iok1FhcvW19I0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h1P66NEtZvzKDrtm+h76KAxFkWDb/JlRmXlXeMwu7BBQDWA04fzGZT4DGf50HyP1iuyREYB9V/M9Qzv+fegwZ8+/h3RFhYakgHc2OrG6R8/Qgmfzoo+UgmUxM05cCVMt7eB5KS33iydz60Cw50YUEk6mNM5sAJpnhYyC4Cdmr2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lVK3PoUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lVK3PoUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD529C2BCB3;
	Tue, 19 May 2026 11:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779190486;
	bh=dYBNK9BCQHghU8qmFx2G1DFK6xWsL7Iok1FhcvW19I0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lVK3PoUjecLuQGRwNciRDGnvHK3OFM9sFfzxfhCh827wo4PFrNFuTUCiyx1tEwZBR
	 osT4eHCNV+Iwz9oq0HLUG0CoNim7bV1DEcRTHP2W1YDwWaqu8GrGUOKJWDLqKpXWBJ
	 gTAoG2il0N6+U8YMZ8BrzPzeLfYuO6FylpXVfWwQaRH4jWZf6gSyouQh/atzZdOOTc
	 joe8pU3HvgW30owFH7D7eJge2Hoq3vWXVq8tj4zIHV0tvlvpnCRHLLoXa6CicWPNU6
	 4V5OxiI+Jqr0wSfy82jESPbbFR/c3iX5AeC4Lvx94fVS4FLJIttICH/Sr67OtSDWkE
	 +vuUxu06E9Xrg==
Date: Tue, 19 May 2026 12:34:36 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: John Groves <john@jagalactic.com>
Cc: John Groves <John@Groves.net>, Dan Williams <djbw@kernel.org>, John
 Groves <jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan
 Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Alison
 Schofield <alison.schofield@intel.com>, Ira Weiny <iweiny@kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/6] dax: fix misleading comment about share/index union
 in dax_folio_reset_order()
Message-ID: <20260519123436.04aa1891@jic23-huawei>
In-Reply-To: <0100019e3d045be0-088bc509-0545-4e5a-b532-507045af78d0-000000@email.amazonses.com>
References: <0100019e3d03bba9-d27282f3-5552-4fa0-8326-981e4c13dace-000000@email.amazonses.com>
	<20260518213549.31246-1-john@jagalactic.com>
	<0100019e3d045be0-088bc509-0545-4e5a-b532-507045af78d0-000000@email.amazonses.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 18 May 2026 21:35:56 +0000
John Groves <john@jagalactic.com> wrote:

> From: John Groves <John@Groves.net>
> 
> The comment in dax_folio_reset_order() claims that DAX maintains an
> invariant where folio->share != 0 only when folio->mapping == NULL,
> implying folio->share is zero whenever mapping is non-NULL. This is
> misleading because folio->share and folio->index are a union -- for
> non-shared folios with mapping != NULL, reading folio->share returns

Maybe for consistency refer to that as folio->mapping != NULL

> the file page offset (folio->index), which is typically non-zero.
> 
> Reword the comment to accurately describe the union aliasing: the
> assignment clears whichever interpretation of the union word is active
> (index for non-shared folios, share for shared folios), which is correct
> because the folio is being released in either case.
> 
> No functional change -- the code was already correct, only the
> justification was wrong.
> 
> Fixes: 59eb73b98ae0b ("dax: Factor out dax_folio_reset_order() helper")
> Signed-off-by: John Groves <john@groves.net>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>

> ---
>  fs/dax.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 6d175cd47a99b..df19c9317d10e 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -392,12 +392,12 @@ int dax_folio_reset_order(struct folio *folio)
>  	int order = folio_order(folio);
>  
>  	/*
> -	 * DAX maintains the invariant that folio->share != 0 only when
> -	 * folio->mapping == NULL (enforced by dax_folio_make_shared()).
> -	 * Equivalently: folio->mapping != NULL implies folio->share == 0.
> -	 * Callers ensure share has been decremented to zero before
> -	 * calling here, so unconditionally clearing both fields is
> -	 * correct.
> +	 * Clear the mapping and the index/share union word. folio->share
> +	 * and folio->index occupy the same union in struct folio. For
> +	 * non-shared folios (mapping != NULL), the union holds folio->index
> +	 * (file page offset); for shared folios (mapping == NULL), it holds
> +	 * folio->share (reference count). Either way, we are releasing the
> +	 * folio and both fields should be zeroed.
>  	 */
>  	folio->mapping = NULL;
>  	folio->share = 0;

