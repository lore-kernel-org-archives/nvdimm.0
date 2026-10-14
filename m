Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9781B3957
	for <nvdimm@lists.linux.dev>; Wed, 14 Oct 2026 12:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982477; cv=none; b=rHua3OAkt+gvzn9w9axs2pAoYRQaR4VNlRLVY2rymDK79/RuS6sn9Yb4yLBmFXLtf2CZdBR8looUEyMxhmY2rR5xak43MMTu5Y4pAhGoHq1YSLpFtw8aMdtzpAeq4glw2w6Z4hIj4x2a2k98ZOR0N6DRAtGjwXsuHh8D/iTJO54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982477; c=relaxed/simple;
	bh=hpcg1jgzngplLEDfCJgF27/UlLBHLObqI9s2YymHbdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kx/wH7byD16awtemYnaYFseo4q7k70df+8b1YOmaWxQb11auizyMryYOD9wBPCftk+qS+27sTopWRPfhQW/Zzn9641is1XsYbO0X+pqNravxgrxA9N5TnZkXTF9IgXBP0SgonXAs7//KXoDIXRh46SIGJEsuWN6L3DQdKRE14FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DZ468QI9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ir1C+oqO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DZ468QI9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ir1C+oqO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DZ468QI9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ir1C+oqO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DZ468QI9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ir1C+oqO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 08E221FB5D;
	Wed, 14 Oct 2026 12:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791982464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yiag147YDzRhJZQmdF9FuIn31YFtAGEtLjcC+W+Mgt0=;
	b=DZ468QI9zy+G17t8LQgWerTdwf1/ijRZbhnrjV+dTV4JYYqm0PyuPv7qdeoaS+LP2t3AUn
	DwAZE2fUqRc5yPlVlSIDvKg3hNLoJFAo9WjRUNJCzymcGin9Ej7dGrT3CXqTV9B3skee++
	mHhVMg7r0NmtDb+OBdAEAb+2HSEyp+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791982464;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yiag147YDzRhJZQmdF9FuIn31YFtAGEtLjcC+W+Mgt0=;
	b=Ir1C+oqOMOIcacDq1tx/pNbRkPQKcRUKsAzTj+YqDIjuO8k95WA0Bf9W1Jo3Z5jVL1VZIn
	hnNPQEXs4th1WEDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DZ468QI9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ir1C+oqO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791982464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yiag147YDzRhJZQmdF9FuIn31YFtAGEtLjcC+W+Mgt0=;
	b=DZ468QI9zy+G17t8LQgWerTdwf1/ijRZbhnrjV+dTV4JYYqm0PyuPv7qdeoaS+LP2t3AUn
	DwAZE2fUqRc5yPlVlSIDvKg3hNLoJFAo9WjRUNJCzymcGin9Ej7dGrT3CXqTV9B3skee++
	mHhVMg7r0NmtDb+OBdAEAb+2HSEyp+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791982464;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yiag147YDzRhJZQmdF9FuIn31YFtAGEtLjcC+W+Mgt0=;
	b=Ir1C+oqOMOIcacDq1tx/pNbRkPQKcRUKsAzTj+YqDIjuO8k95WA0Bf9W1Jo3Z5jVL1VZIn
	hnNPQEXs4th1WEDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A47AA1368E;
	Wed, 14 Oct 2026 12:54:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2P6oFn97z2rOFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 14 Oct 2026 12:54:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 93594A140F; Wed, 14 Oct 2026 14:54:22 +0200 (CEST)
Date: Wed, 14 Oct 2026 14:54:22 +0200
From: Jan Kara <jack@suse.cz>
To: jianyungao89@gmail.com
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Goldwyn Rodrigues <rgoldwyn@suse.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"open list:FILESYSTEMS (VFS and infrastructure)" <linux-fsdevel@vger.kernel.org>, 
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v2] dax: fix dax_range_compare_iter() to use correct size
 and address offset
Message-ID: <zvixzzexxaekw63q7yzeqibjd6elvq34q72xzsy6wmvrufxqae@b6yazc6wtpxy>
References: <20261011064840.1296-1-jianyungao89@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011064840.1296-1-jianyungao89@gmail.com>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 08E221FB5D
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim,suse.com:email];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Sun 11-10-26 14:48:39, jianyungao89@gmail.com wrote:
> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> dax_range_compare_iter() has two bugs in how it calls
> dax_iomap_direct_access() and uses the returned addresses:
> 
> 1. The size argument passed to dax_iomap_direct_access() is
>    ALIGN(pos + len, PAGE_SIZE), which is an absolute file offset
>    rather than a length. This causes the underlying dax_direct_access()
>    to request a massively inflated nr_pages via PHYS_PFN(size).
> 
> 2. The addresses returned by dax_iomap_direct_access() are page-aligned
>    starting addresses, but memcmp() compares from saddr/daddr directly
>    without adding the page-in-page offset of pos1/pos2. When pos1/pos2
>    are not page-aligned, this compares the wrong data.
> 
> Fix the size by computing ALIGN(len + offset_in_page(pos), PAGE_SIZE),
> matching the pattern used in dax_iomap_copy_around(). Fix the address
> by adding offset_in_page(pos1)/offset_in_page(pos2) to saddr/daddr in
> the memcmp() call.
> 
> Fixes: 6f7db3894ae2 ("fsdax: dedup file range to use a compare function")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> 
> Changes in v2:
> - Add offset_in_page(pos1)/offset_in_page(pos2) to the saddr/daddr
>   arguments in memcmp() to fix the page-in-page offset issue pointed
>   out in the v1 review.
> - Use offset_in_page() macro instead of (pos & ~PAGE_MASK) for
>   consistency with the rest of the codebase.
> 
> v1: https://lore.kernel.org/lkml/20261010071453.6028-1-jianyungao89@gmail.com/
> 
>  fs/dax.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 6ba50142eeb2..b08d408418bd 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -2197,6 +2197,7 @@ static int dax_range_compare_iter(struct iomap_iter *it_src,
>  	const struct iomap *dmap = &it_dest->iomap;
>  	loff_t pos1 = it_src->pos, pos2 = it_dest->pos;
>  	void *saddr, *daddr;
> +	size_t size1, size2;
>  	int id, ret;
>  
>  	len = min(len, min(smap->length, dmap->length));
> @@ -2212,17 +2213,18 @@ static int dax_range_compare_iter(struct iomap_iter *it_src,
>  	}
>  
>  	id = dax_read_lock();
> -	ret = dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
> -				      &saddr, NULL);
> +	size1 = ALIGN(len + offset_in_page(pos1), PAGE_SIZE);
> +	ret = dax_iomap_direct_access(smap, pos1, size1, &saddr, NULL);
>  	if (ret < 0)
>  		goto out_unlock;
>  
> -	ret = dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
> -				      &daddr, NULL);
> +	size2 = ALIGN(len + offset_in_page(pos2), PAGE_SIZE);
> +	ret = dax_iomap_direct_access(dmap, pos2, size2, &daddr, NULL);
>  	if (ret < 0)
>  		goto out_unlock;
>  
> -	*same = !memcmp(saddr, daddr, len);
> +	*same = !memcmp(saddr + offset_in_page(pos1),
> +			daddr + offset_in_page(pos2), len);
>  	if (!*same)
>  		len = 0;
>  	dax_read_unlock(id);
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
