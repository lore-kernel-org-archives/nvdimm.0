Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE023FE665
	for <nvdimm@lists.linux.dev>; Wed, 25 Mar 2026 14:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450278; cv=none; b=FNnKAPHIIgXp7HoXr8iCoqPGo56xhFpuBMl9EfPZdyEyvFa3pTyXetO3fBbfJ9GVzblYcVaqYPlhxJvrgrMv9Rn02yp0ibBqH904u+4G5cJUHl8Dj+YD7aMVP42K+1pU/JQSoNXhUYX+c8b1UJmelzgoknTf6wSdp1+pGsHqhNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450278; c=relaxed/simple;
	bh=l2Lc7ADbwtGwZrTrSy5HTL6YFd1Zh1tOw1yK+YRZ9MI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSZwp9XrRiaqDjqIHhCrVz/f0ghQRgeDWTYazyG5F1j5AMzfYNY7NX0FNCEJdKciHVeuLAEB7V0kbHEYvgC0GEdxRMBfBmeFZ+vaiuGZikwI5Tt24qLQY9z/pPGj4LvgQkeoB3+7PYoZtgDHb0Kly1d4UxNPsL6C7JHYBybv2Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HWmOZ5Fg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u14cIhOK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HWmOZ5Fg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u14cIhOK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HWmOZ5Fg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u14cIhOK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HWmOZ5Fg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u14cIhOK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 63F235BD52;
	Wed, 25 Mar 2026 14:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IbrNguOL2oU7ugpbxDymPY+bcfAOeIY2ch0aNWgxbs=;
	b=HWmOZ5FgwDtrteSM2Ew5PXqlKiEfNmaAxZwNcrDu5cm7qqyNqx+T4KuS+fzLrhGhLe0BMw
	4jK5lnRLUqHsAlBFQz+I+hBfsPpC3uQ9V4D0BKTscU6LcEG3GYwivCMcvxhC1hemevb4sH
	uOKbUkmNtRHNhlJlq6nBbg/lY2lzSfY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450269;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IbrNguOL2oU7ugpbxDymPY+bcfAOeIY2ch0aNWgxbs=;
	b=u14cIhOKRc22D/k23HZ0bIZUBPARER5TAWoWA++mI3iuA8hY3F7HH/iLi3+LZe1XvB+eno
	2GHcX4DZFxOCZCDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IbrNguOL2oU7ugpbxDymPY+bcfAOeIY2ch0aNWgxbs=;
	b=HWmOZ5FgwDtrteSM2Ew5PXqlKiEfNmaAxZwNcrDu5cm7qqyNqx+T4KuS+fzLrhGhLe0BMw
	4jK5lnRLUqHsAlBFQz+I+hBfsPpC3uQ9V4D0BKTscU6LcEG3GYwivCMcvxhC1hemevb4sH
	uOKbUkmNtRHNhlJlq6nBbg/lY2lzSfY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450269;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IbrNguOL2oU7ugpbxDymPY+bcfAOeIY2ch0aNWgxbs=;
	b=u14cIhOKRc22D/k23HZ0bIZUBPARER5TAWoWA++mI3iuA8hY3F7HH/iLi3+LZe1XvB+eno
	2GHcX4DZFxOCZCDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B7C9A4445E;
	Wed, 25 Mar 2026 14:51:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zMJkKVr2w2nWXgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 25 Mar 2026 14:51:06 +0000
Date: Wed, 25 Mar 2026 14:51:04 +0000
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
Subject: Re: [PATCH 1/6] mm: rename VMA flag helpers to be more readable
Message-ID: <6c6le67q23xsity3tkfq2uazzhwustmqcsqj3talft6qq737hz@dytog6bi4vsa>
References: <cover.1772704455.git.ljs@kernel.org>
 <0f9cb3c511c478344fac0b3b3b0300bb95be95e9.1772704455.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f9cb3c511c478344fac0b3b3b0300bb95be95e9.1772704455.git.ljs@kernel.org>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,arndb.de,linuxfoundation.org,intel.com,kernel.org,gmail.com,linux.alibaba.com,google.com,huawei.com,vivo.com,linux.dev,suse.de,paragon-software.com,arm.com,amd.com,wdc.com,infradead.org,suse.cz,oracle.com,suse.com,ziepe.ca,vger.kernel.org,lists.linux.dev,lists.ozlabs.org,kvack.org];
	R_RATELIMIT(0.00)[to_ip_from(RLhefktrybubrrcz79tisgnzmd)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]
X-Spam-Flag: NO

On Thu, Mar 05, 2026 at 10:50:14AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On reflection, it's confusing to have vma_flags_test() and
> vma_desc_test_flags() test whether any comma-separated VMA flag bit is set,
> while also having vma_flags_test_all() and vma_test_all_flags() separately
> test whether all flags are set.
> 
> Firstly, rename vma_flags_test() to vma_flags_test_any() to eliminate this
> confusion.

Hmm. The names are getting longer. We should fix this One Day.

> 
> Secondly, since the VMA descriptor flag functions are becoming rather
> cumbersome, prefer vma_desc_test*() to vma_desc_test_flags*(), and also
> rename vma_desc_test_flags() to vma_desc_test_any().

> 
> Finally, rename vma_test_all_flags() to vma_test_all() to keep the
> VMA-specific helper consistent with the VMA descriptor naming convention
> and to help avoid confusion vs. vma_flags_test_all().
> 
> While we're here, also update whitespace to be consistent in helper
> functions.

Extremely amazing patch! you were truly inspired!


> Suggested-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro
