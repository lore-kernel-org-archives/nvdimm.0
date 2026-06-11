Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECD53DD51B
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 11:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781176417; cv=none; b=tN9LiGkHr+00GWgGqp0w3DZrqKp9MhSA+rJRe1YpqrumY1Acqd4B7TZj0M6bpBJUnatYGRAcX9PhNyIVNiTwnSRlclZ6dq6TjHpwvKBmahJS4jaXTrDCRC7GLEOzLBjlvUmQNUfZqDRrM9GMalmTkNnNTs48IXLHxq0QQmQ/wKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781176417; c=relaxed/simple;
	bh=yX+biDOJMWTtKkH3Cw9JnqrWk90JigwtHAtrPYqc1mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovjTV8cWWyuWeKprXrYRhezBhUgWoWaEozUYSLnc4M/UvCzS2jVN7mn5hvg8qzVudciK3i/K7cekTXAShg/JdBqGm2W6cT7vHkUMEN6D13zP+pargsyCtcS51n7GLeD3zaYqp8Ax54UFFe7fMku7ZC/xDkR85hZr3y/8uEbK/1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=h7gGhUHC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3oX5UDZz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=h7gGhUHC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3oX5UDZz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="h7gGhUHC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3oX5UDZz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="h7gGhUHC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3oX5UDZz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1D4517595F;
	Thu, 11 Jun 2026 11:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781176414; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uTPmKDC2++fFuX1IGIaCfTosGFLn7J/XiVm22BhhlKY=;
	b=h7gGhUHCMWHR9qmMcGC0AoT1CAbC0qDA+DovzA8zAz7H7fQv0PFs7CPOjJnxhCdFaDcGUu
	vyvAK0DfyY1RdmfXFklPCJyPNhMzAuw2CP1s6N7qwcEYWiR5mxL9DG/5BysO6PhZMxKoKD
	ISZg6RTIwJecj6GxaQYPdfgUtqJTzRk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781176414;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uTPmKDC2++fFuX1IGIaCfTosGFLn7J/XiVm22BhhlKY=;
	b=3oX5UDZz+h4XTy4ey9XkDARLpL0LSp4+oHtkq9J8VDyjYLcXPfbAOHxVyfqg6po5L3jIcS
	rP2TI5nu7gaMawCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h7gGhUHC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3oX5UDZz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781176414; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uTPmKDC2++fFuX1IGIaCfTosGFLn7J/XiVm22BhhlKY=;
	b=h7gGhUHCMWHR9qmMcGC0AoT1CAbC0qDA+DovzA8zAz7H7fQv0PFs7CPOjJnxhCdFaDcGUu
	vyvAK0DfyY1RdmfXFklPCJyPNhMzAuw2CP1s6N7qwcEYWiR5mxL9DG/5BysO6PhZMxKoKD
	ISZg6RTIwJecj6GxaQYPdfgUtqJTzRk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781176414;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uTPmKDC2++fFuX1IGIaCfTosGFLn7J/XiVm22BhhlKY=;
	b=3oX5UDZz+h4XTy4ey9XkDARLpL0LSp4+oHtkq9J8VDyjYLcXPfbAOHxVyfqg6po5L3jIcS
	rP2TI5nu7gaMawCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0CEF1779A7;
	Thu, 11 Jun 2026 11:13:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wxlKO1mYKmqmDQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 11 Jun 2026 11:13:29 +0000
Date: Thu, 11 Jun 2026 12:13:28 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Huang Shijie <huangsj@hygon.cn>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	surenb@google.com, mjguzik@gmail.com, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, shakeel.butt@linux.dev, rppt@kernel.org, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, linux@armlinux.org.uk, 
	dinguyen@kernel.org, schuster.simon@siemens-energy.com, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, djbw@kernel.org, willy@infradead.org, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com, james.clark@linaro.org, 
	mhiramat@kernel.org, oleg@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, linmiaohe@huawei.com, nao.horiguchi@gmail.com, jannh@google.com, 
	riel@surriel.com, harry@kernel.org, will@kernel.org, brian.ruley@gehealthcare.com, 
	rmk+kernel@armlinux.org.uk, dave.anglin@bell.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, zhongyuan@hygon.cn, fangbaoshun@hygon.cn, yingzhiwei@hygon.cn
Subject: Re: [PATCH v2 1/4] mm: use mapping_mapped to simplify the code
Message-ID: <aiqYJTJFIHHk_IOt@pedro-suse.lan>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
 <20260611061915.2354307-2-huangsj@hygon.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611061915.2354307-2-huangsj@hygon.cn>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,zeniv.linux.org.uk,kernel.org,suse.cz,linux.dev,suse.de,google.com,gmail.com,infradead.org,suse.com,lwn.net,linuxfoundation.org,armlinux.org.uk,siemens-energy.com,hansenpartnership.com,gmx.de,redhat.com,arm.com,linux.intel.com,intel.com,linaro.org,nvidia.com,linux.alibaba.com,huawei.com,surriel.com,gehealthcare.com,bell.net,kvack.org,vger.kernel.org,lists.infradead.org,lists.linux.dev,hygon.cn];
	FREEMAIL_ENVRCPT(0.00)[bell.net,gmail.com,gmx.de];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RL89xh3ijk4gdpeanxbepagf1s)];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[kernel];
	RCPT_COUNT_GT_50(0.00)[65];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,pedro-suse.lan:mid,suse.de:email,suse.de:dkim,hygon.cn:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1D4517595F
X-Spam-Score: -3.01

On Thu, Jun 11, 2026 at 02:18:57PM +0800, Huang Shijie wrote:
> Use mapping_mapped() to simplify the code, make
> the code tidy and clean.
> 
> Signed-off-by: Huang Shijie <huangsj@hygon.cn>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

LGTM, thanks! Super uncontroversial so perhaps
could be picked up separately.

-- 
Pedro
