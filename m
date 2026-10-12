Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C69546C830
	for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 09:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791798475; cv=none; b=fVaXOM6OmzpV1RSq6pRv1EPomYaeJBEn431hMZL4HdOikbnpYfdrvVgbJYQDKvQUkPETQ/YfIWzDj852GekUoikmgrn/2SboWwkU1QnrxYRa3a0acet3xqx18dZFVoi5/OyIaqz4vssSG/NgHJINMMF+14BAe+xZKQ8Pox26JVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791798475; c=relaxed/simple;
	bh=LEk/A/nrJyywMNg3MM69Syjo6/JmBTolLn8hKM1th50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qoElJHFdvmkm7Ihkk23NbTCl+XsG4a+g3H0yC6KVd1C7sDkpcTA2PlgNwwV4CZJsDzJ6croRiUWD7fRHrmfb0RsbVqp/H3gjCY7n5oXILm16+V4kR34qqI6d2k3bB9mXCn0YL5eFlSiFW/EQixy8n/lFqJGmXOU63zES9TVeiOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yhr/xUfg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VFZx090F; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OcE8jk2U; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=coWOxpQO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yhr/xUfg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VFZx090F";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OcE8jk2U";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="coWOxpQO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CC6781F78F;
	Mon, 12 Oct 2026 09:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791798472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1XtAnjY5kuB4iyaUZjBNl24UZ1rbK0xSs9L8uM9evPQ=;
	b=yhr/xUfgauf8MOgSogCvtvtL4chYrx+Xoyc8bmEyprv2FWXRTCiJR5eqo8MbDWim5Boalb
	wIl4B+F5VDkKmE1ghX1FSbBC/ttQivWS9jLYDo1mTMTWLsBjtAOteCpLtDCxCAewZeMFA6
	lVXOrHJJMtNmYozZUHzZwtERQ8i/crg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791798472;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1XtAnjY5kuB4iyaUZjBNl24UZ1rbK0xSs9L8uM9evPQ=;
	b=VFZx090F859J+UsL2O/mlsn/BD9mN7HU/G1B9wHLxQOGe9s7OvXq5CP1UgV8lDZVFg8wDc
	tlV2AYBpbdimi3CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OcE8jk2U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=coWOxpQO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791798471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1XtAnjY5kuB4iyaUZjBNl24UZ1rbK0xSs9L8uM9evPQ=;
	b=OcE8jk2UYrLK2rP8vUosEYXaW3bb92WsnsxKV/1QQDWvx463l56ViXJxvSXNjRFpqnwkI9
	Fz6PyFWBIHc7Y98tVOQdTqn9Tbv9LdSKMmRuc+aT/K+BA4BiEvz7KxUj8n+cdUn7dLgb/6
	vii8HS7V5KYTLAdLqo+s6YJUuheKpfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791798471;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1XtAnjY5kuB4iyaUZjBNl24UZ1rbK0xSs9L8uM9evPQ=;
	b=coWOxpQO/8FARLxH8xLc69bcFhBRTKrI+hgeFxNMvVw862niU3olZ9bMVn8ZcHQeMEYHYe
	XqN9WnOIMNu7Y0Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A8D2D13314;
	Mon, 12 Oct 2026 09:47:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P45vIseszGo2fgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 09:47:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3BE2DA1403; Mon, 12 Oct 2026 11:47:36 +0200 (CEST)
Date: Mon, 12 Oct 2026 11:47:36 +0200
From: Jan Kara <jack@suse.cz>
To: jianyungao89@gmail.com
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <linux-fsdevel@vger.kernel.org>, 
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] dax: fix wrong error code returned from
 dax_dedupe_file_range_compare()
Message-ID: <g43wbteg6ntidsfrhlb56okwjmu2lerja563uldjrgoxplpsmv@as744f3re7hm>
References: <20261010021010.19575-1-jianyungao89@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010021010.19575-1-jianyungao89@gmail.com>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CC6781F78F
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Sat 10-10-26 10:10:09, jianyungao89@gmail.com wrote:
> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> When dax_range_compare_iter() returns a negative error code (e.g. -EIO),
> dax_dedupe_file_range_compare() incorrectly returns 'ret' which holds the
> positive return value from iomap_iter() indicating more iterations remain.
> This positive value leaks to the caller, where vfs_dedupe_file_range()
> interprets it as success (bytes_deduped = len), causing userspace to
> incorrectly believe deduplication completed.
> 
> Return 'status' instead to propagate the actual error code.
> 
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dax.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 6ba50142eeb2..1f6a4fbb97bd 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -2261,7 +2261,7 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>  		status = dax_range_compare_iter(&src_iter, &dst_iter,
>  				min(src_iter.len, dst_iter.len), same);
>  		if (status < 0)
> -			return ret;
> +			return status;
>  		src_iter.status = dst_iter.status = status;
>  	}
>  	return ret;
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
