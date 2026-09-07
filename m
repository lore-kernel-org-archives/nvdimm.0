Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9E040EB80
	for <nvdimm@lists.linux.dev>; Mon,  7 Sep 2026 08:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788769367; cv=none; b=kan0nAmQa7ibSd0kmgXaExRkauj9Opr73Yo8g9P0alg+n5/GYLdAsSVZDJHS0vSxb57/u6xj/cJx3sX9Fq9l/AwIAhFV7BDupxlAW5+Zy5LgfGUDM8oQ5B4nW/SSoxlhoFDFpS5orAqx+9o5ABGPhXUK3W7fU6HgwOzG+JSmkVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788769367; c=relaxed/simple;
	bh=rEWz+2MgbRmVtT7OLloOvjm8wTJkVrbeff4P6FpteDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c1iyZxQR5C4065g71AU35epG8wCU6uKorLFRTns+kd2zibaszxGlWXDJhaI0+AxVjXSuB62nLo4joE1pYszeZvZUcdnhhlq6zA2hHju3QrqGACne4eEWTVWGDIq3cN18j1SG4h2EW4JHn1WrG+AclM8Gk+G54gQb8Da3aUihL8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Dg2B/oo5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JZYipjlK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wVTUjHO0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0hqHcM2X; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Dg2B/oo5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JZYipjlK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wVTUjHO0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0hqHcM2X"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 538CA2196E;
	Mon,  7 Sep 2026 08:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788769360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jTpSjLnIj763xnbF7Xh8jDRqOjqOQscn5h2AEOJ5PVM=;
	b=Dg2B/oo5SIPGgJnvN9NFZ2cBxheLZ3iVDWhCfoe9VJWzpJYbAWMTS0djiCQbPRPYybLCg5
	h9C6UExqnz719tcDlFpnztqpzQcxHuXQz+Na1L9edo2DPZ6rvm/5Q9IkulKtXR+OQemkKD
	CFRp9pW+7JqEJzDar6DKq7pOvLwmZkA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788769360;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jTpSjLnIj763xnbF7Xh8jDRqOjqOQscn5h2AEOJ5PVM=;
	b=JZYipjlK1hmcvbh8RTQDYU7Yn3fyWvsglWI5/pAxQvM16vQQCgtKdwhxHqAKFunblf/bkb
	+nvdi2afymaWGVDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wVTUjHO0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0hqHcM2X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788769356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jTpSjLnIj763xnbF7Xh8jDRqOjqOQscn5h2AEOJ5PVM=;
	b=wVTUjHO03jp5z9PIcRk/vAUdyUPio6eOracv6Oqm9/Bfop8rzjbE5Z3ayCR80Hy4WfaM39
	sITL27hWzRCk+2zLl86pEDGLAgKD4EHkGLjqFkrZfeV0AQ/nPOTkrivXTtCApTQv9cpEMQ
	6nZERWSpQrJlnNjZLqNHLIb5kWZYN94=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788769356;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jTpSjLnIj763xnbF7Xh8jDRqOjqOQscn5h2AEOJ5PVM=;
	b=0hqHcM2XcnDYrTcQG9MUpDS5uRbOQP5numu9ImRqK7HFJNzIqZcA9F8mg4AEV1+QxTasjT
	QFA2junHvWnu9sCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 309FB1368D;
	Mon,  7 Sep 2026 08:22:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id D5bfC0x0nmr6OgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 07 Sep 2026 08:22:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D35ACA13B2; Mon, 07 Sep 2026 10:22:31 +0200 (CEST)
Date: Mon, 7 Sep 2026 10:22:31 +0200
From: Jan Kara <jack@suse.cz>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Dan Williams <djbw@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Muchun Song <muchun.song@linux.dev>, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 2/2] fs/dax: Make dax_layout_busy_page_range() static
Message-ID: <htsp4zvc7sidacjm3v733ycvjuzezghggpsnxqszttsycj2hpp@zdq7rutu256r>
References: <20260904152749.84493-1-kaitao.cheng@linux.dev>
 <20260904152749.84493-3-kaitao.cheng@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904152749.84493-3-kaitao.cheng@linux.dev>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 538CA2196E
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Fri 04-09-26 23:27:49, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> dax_layout_busy_page_range() no longer has callers outside fs/dax.c.
> Keeping the range helper exported unnecessarily exposes a low-level
> implementation detail.
> 
> Make the helper static and remove its export and header definitions.
> 
> Also fix the stale dax_layout_busy_page_range() comment to match the
> implementation.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dax.c            | 18 ++++++++----------
>  include/linux/dax.h |  6 ------
>  2 files changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 1e19e4a354ce..c6ad9533aa54 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -770,24 +770,23 @@ static void *grab_mapping_entry(struct xa_state *xas,
>  
>  /**
>   * dax_layout_busy_page_range - find first pinned page in @mapping
> - * @mapping: address space to scan for a page with ref count > 1
> + * @mapping: address space to scan for a pinned page
>   * @start: Starting offset. Page containing 'start' is included.
>   * @end: End offset. Page containing 'end' is included. If 'end' is LLONG_MAX,
>   *       pages from 'start' till the end of file are included.
>   *
> - * DAX requires ZONE_DEVICE mapped pages. These pages are never
> - * 'onlined' to the page allocator so they are considered idle when
> - * page->count == 1. A filesystem uses this interface to determine if
> - * any page in the mapping is busy, i.e. for DMA, or other
> - * get_user_pages() usages.
> + * DAX requires ZONE_DEVICE mapped pages. A page is considered busy when
> + * folio_ref_count(folio) exceeds folio_mapcount(folio). This helper is
> + * used to determine if any page in the mapping is busy, i.e. for DMA,
> + * or other get_user_pages() usages.
>   *
>   * It is expected that the filesystem is holding locks to block the
>   * establishment of new mappings in this address_space. I.e. it expects
> - * to be able to run unmap_mapping_range() and subsequently not race
> + * to be able to run unmap_mapping_pages() and subsequently not race
>   * mapping_mapped() becoming true.
>   */
> -struct page *dax_layout_busy_page_range(struct address_space *mapping,
> -					loff_t start, loff_t end)
> +static struct page *dax_layout_busy_page_range(struct address_space *mapping,
> +					       loff_t start, loff_t end)
>  {
>  	void *entry;
>  	unsigned int scanned = 0;
> @@ -839,7 +838,6 @@ struct page *dax_layout_busy_page_range(struct address_space *mapping,
>  	xas_unlock_irq(&xas);
>  	return page;
>  }
> -EXPORT_SYMBOL_GPL(dax_layout_busy_page_range);
>  
>  static int __dax_invalidate_entry(struct address_space *mapping,
>  				  pgoff_t index, bool trunc)
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 05e59e45a1c2..f2d47975d905 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -155,7 +155,6 @@ int dax_writeback_mapping_range(struct address_space *mapping,
>  		struct dax_device *dax_dev, struct writeback_control *wbc);
>  int dax_folio_reset_order(struct folio *folio);
>  
> -struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
>  dax_entry_t dax_lock_folio(struct folio *folio);
>  void dax_unlock_folio(struct folio *folio, dax_entry_t cookie);
>  dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
> @@ -172,11 +171,6 @@ static inline int fs_dax_get(struct dax_device *dax_dev, void *holder,
>  {
>  	return -EOPNOTSUPP;
>  }
> -static inline struct page *dax_layout_busy_page_range(struct address_space *mapping, pgoff_t start, pgoff_t nr_pages)
> -{
> -	return NULL;
> -}
> -
>  static inline int dax_writeback_mapping_range(struct address_space *mapping,
>  		struct dax_device *dax_dev, struct writeback_control *wbc)
>  {
> -- 
> 2.50.1 (Apple Git-155)
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
