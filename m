Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2216142050
	for <nvdimm@lists.linux.dev>; Mon,  7 Sep 2026 08:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788769323; cv=none; b=jFcFtd1/Jf1Wm7sHamurzyFgyt2DsK6bpPs4gePt1XvaYVsJv8NB/+uFrr2j3RGzJyDmS7ktCOsVRzZJfX+NnRKZ2JiEYBqbwXrOC7lcvN0qeJMOnB5ihjcUHFGU4d/joHhdAK0XIsPhLCgu7uzoJobUdZsID2cGec7gfQk4m2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788769323; c=relaxed/simple;
	bh=3QPwa3MeBF3B84pme974A80HEI+sVX5CODPVCBdfC+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dnpmrFJVs+2BUOodbXUZ+zctpGhgNFZCcGM6pBbkMZ+p7d0kU1fOTkMFx4hMl9KuxB23f+iFKyzFXPDQPrpY53IZe2JkNsORUS0mbtvL/OOsh1xr892KTvBOkQc5vJXs4OcgFwbn4dqMYnZYBgj849qt0H0P4A8vVT1Egsiz6ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lEAzgXId; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mBcTfsYf; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uTAXmQ9F; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zuAeVTWW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lEAzgXId";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mBcTfsYf";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uTAXmQ9F";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zuAeVTWW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0B08D21B40;
	Mon,  7 Sep 2026 08:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788769316; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gHHdFupRkSPL5Qu9Y6CTRq5TzAGvzNKJA+0n+VN11dI=;
	b=lEAzgXId0wnbywLNGMFKA3SOBhnbQFepub3knfVFFsabW1F+wjAAtrhOWXldoZMBAwlZKl
	g17Klrsu9rqcRwqAV5Y5l1C3AD3F6hZ0im3UmIV+qco/1mkc3vPcRBBQm8WSu4O+JlIEhl
	4LIyBeGUc2lPSShDHjiB5l4EQ7fD9Qk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788769316;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gHHdFupRkSPL5Qu9Y6CTRq5TzAGvzNKJA+0n+VN11dI=;
	b=mBcTfsYfj47DnTiA56VGJRmXqDqWE0zgiKWrfKf2371GsfYvYTt+YmfhLfjOww+PYsxe1F
	7qlu3In+vocWe9Dg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788769312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gHHdFupRkSPL5Qu9Y6CTRq5TzAGvzNKJA+0n+VN11dI=;
	b=uTAXmQ9F9dgnFDQLS2P5QCnRP3HXRBTpwDLCR9OZiKp9CdcwaM0nntN7x0JDyxOSJq6SA1
	ppG81oZuXc+0VaJBN+2h1yA2alPqV3N//VgvIGyqbgGUPNRVC6hhfyJqwipKT0wQlCS3X6
	2BrdSvrE+0/RniIR3YYRryPMnqOy5nA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788769312;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gHHdFupRkSPL5Qu9Y6CTRq5TzAGvzNKJA+0n+VN11dI=;
	b=zuAeVTWWhm3zC2sVdpjt8GtveLKbIIIRpQtf7sZ7hp9IJZ5geEWl2q8gd9QXGBq+VJKCeL
	jzGjwxhN/ZdpqKBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DECEA1339B;
	Mon,  7 Sep 2026 08:21:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nUJbNh90nmq6OgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 07 Sep 2026 08:21:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 794E6A13B2; Mon, 07 Sep 2026 10:21:43 +0200 (CEST)
Date: Mon, 7 Sep 2026 10:21:43 +0200
From: Jan Kara <jack@suse.cz>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Dan Williams <djbw@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Muchun Song <muchun.song@linux.dev>, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 1/2] fs/dax: Remove unused dax_layout_busy_page()
Message-ID: <kuqhtiqd5ibegkkpul5q62xjrpuzbzhlswiziqatlzfksvcfgl@jp3fbktfv64q>
References: <20260904152749.84493-1-kaitao.cheng@linux.dev>
 <20260904152749.84493-2-kaitao.cheng@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904152749.84493-2-kaitao.cheng@linux.dev>
X-Spam-Level: 
X-Spam-Score: -3.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]

On Fri 04-09-26 23:27:48, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> dax_layout_busy_page() used to let filesystems scan an entire DAX
> mapping for pinned pages. All callers now use dax_break_layout(),
> which also handles waiting for busy pages and deleting DAX mapping
> entries once the range becomes idle.
> 
> The remaining function is only a wrapper around
> dax_layout_busy_page_range() and has no in-tree users. Remove it
> together with its declaration, !CONFIG_FS_DAX stub, and exported
> symbol.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dax.c            | 6 ------
>  include/linux/dax.h | 6 ------
>  2 files changed, 12 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index dad4efea7964..1e19e4a354ce 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -841,12 +841,6 @@ struct page *dax_layout_busy_page_range(struct address_space *mapping,
>  }
>  EXPORT_SYMBOL_GPL(dax_layout_busy_page_range);
>  
> -struct page *dax_layout_busy_page(struct address_space *mapping)
> -{
> -	return dax_layout_busy_page_range(mapping, 0, LLONG_MAX);
> -}
> -EXPORT_SYMBOL_GPL(dax_layout_busy_page);
> -
>  static int __dax_invalidate_entry(struct address_space *mapping,
>  				  pgoff_t index, bool trunc)
>  {
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index fe6c3ded1b50..05e59e45a1c2 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -155,7 +155,6 @@ int dax_writeback_mapping_range(struct address_space *mapping,
>  		struct dax_device *dax_dev, struct writeback_control *wbc);
>  int dax_folio_reset_order(struct folio *folio);
>  
> -struct page *dax_layout_busy_page(struct address_space *mapping);
>  struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
>  dax_entry_t dax_lock_folio(struct folio *folio);
>  void dax_unlock_folio(struct folio *folio, dax_entry_t cookie);
> @@ -173,11 +172,6 @@ static inline int fs_dax_get(struct dax_device *dax_dev, void *holder,
>  {
>  	return -EOPNOTSUPP;
>  }
> -static inline struct page *dax_layout_busy_page(struct address_space *mapping)
> -{
> -	return NULL;
> -}
> -
>  static inline struct page *dax_layout_busy_page_range(struct address_space *mapping, pgoff_t start, pgoff_t nr_pages)
>  {
>  	return NULL;
> -- 
> 2.50.1 (Apple Git-155)
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
