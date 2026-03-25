Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6453E557B
	for <nvdimm@lists.linux.dev>; Wed, 25 Mar 2026 14:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450500; cv=none; b=aAxiV8wwgKxOcGTQS5BJRQIndZE9iMd6juOl52d79fiGNvdQcsC11+bd67qDGqx915y6AVihFmZLfJFDhqfTa2l2lbeh0YNGAkg90hO6Q4ev000F4UoBBAD9jFoPA57J2wH4hAS1+7HwaJ77CQ3luHUzclfuuMYwvppu99aNxpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450500; c=relaxed/simple;
	bh=MYhZP7KI2acrHYS5z9F6cGMsPpEaHUK5v2b6RSUHD5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AjAn/omvsyco20VDwqckWYb0EXK8PFp8+JsBREdmFI9g6C9Jty52Qb8if/yX4AzIdpnCLxmPgvoR69Rui/tRAK+PNsKzq/rbEJej8cjQTe+JmboaH385GCvmcYXgce8qV+T9y2voWif0tIQiZXMV5sg51mDCO6zr7R3MktiTSrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kfjBhpkW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KxKmaq0G; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eslfnx7h; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bOKSc2s0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kfjBhpkW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KxKmaq0G";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eslfnx7h";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bOKSc2s0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E2A964D244;
	Wed, 25 Mar 2026 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450495; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/wXjEuEJQTN4k0jag/OQOqiBqUpftxguZi3Bfxxazc=;
	b=kfjBhpkWS16JY8q2qhzrpMm8Qqcs2ZrtKS4zlJEvRrcKzCGUHSYFoBdcLJsmKv4hjTURyd
	yd4A/VFS1ynIvUXSdfbN+WxSwj3zLyvx02En3KZUx/jYp4phNK6LAOI8yTXuWVz/Nltv20
	hyTn2mpZxIoIAv6/6Rvb3UfWqNm23fM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450495;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/wXjEuEJQTN4k0jag/OQOqiBqUpftxguZi3Bfxxazc=;
	b=KxKmaq0GZ6SbmxU5yVYvT3J98IVPybrqCzJYC2RmzYb9aKP+qaSl9V6BjPBkq9CVdvc8UG
	MmoaFM8Fl1XcZvBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450494; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/wXjEuEJQTN4k0jag/OQOqiBqUpftxguZi3Bfxxazc=;
	b=eslfnx7hQIz+CqBMaKTHFfI4A5TaGYs6A9oOjOoC6EAoJqhv9gkRua4SGXrrlzy3kuKdzT
	bzw+G48vIqIIz5lkBfsEk+Dd6ymbTjzXBQMGW1sbCTIV5CxReOHAtNecLZSpjk1qvgUfR9
	nmZyWiv2dQf45miza5KfPMuQPZOpR3w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450494;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/wXjEuEJQTN4k0jag/OQOqiBqUpftxguZi3Bfxxazc=;
	b=bOKSc2s03svO8ZobkiDMrnkLqmSYPCdv3zFSNzJ05OB0u9gYR0s9JtEEpIiTbIKzp6ATVb
	nBCfqs3dIyX5voCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F61244462;
	Wed, 25 Mar 2026 14:54:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tAkWDDz3w2lQYwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 25 Mar 2026 14:54:52 +0000
Date: Wed, 25 Mar 2026 14:54:50 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-ID: <ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
References: <cover.1772704455.git.ljs@kernel.org>
 <241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[linux-foundation.org,arndb.de,linuxfoundation.org,intel.com,kernel.org,gmail.com,linux.alibaba.com,google.com,huawei.com,vivo.com,linux.dev,suse.de,paragon-software.com,arm.com,amd.com,wdc.com,infradead.org,suse.cz,oracle.com,suse.com,ziepe.ca,vger.kernel.org,lists.linux.dev,lists.ozlabs.org,kvack.org];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLhefktrybubrrcz79tisgnzmd)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Thu, Mar 05, 2026 at 10:50:16AM +0000, Lorenzo Stoakes (Oracle) wrote:
> Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> macro) always being inline, as we rely on the compiler converting this
> function into meaningful.
		meaningful what?

> 
> Also update all of the functions __mk_vma_flags() ultimately invokes to be
> always inline too.
> 
> Note that test_bitmap_const_eval() asserts that the relevant bitmap
> functions result in build time constant values.
> 
> Additionally, vma_flag_set() operates on a vma_flags_t type, so it is
> inconsistently named versus other VMA flags functions.
> 
> We only use vma_flag_set() in __mk_vma_flags() so we don't need to worry
> about its new name being rather cumbersome, so rename it to
> vma_flags_set_flag() to disambiguate it from vma_flags_set().
> 
> Also update the VMA test headers to reflect the changes.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Is there an actual difference in codegen here? On -O2.

-- 
Pedro
