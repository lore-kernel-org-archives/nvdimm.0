Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2782128C860
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 10:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758106169; cv=none; b=ABAAU+p2U7a60Nbe7/IW6wqOmNRja63gczO9JhH5/MtsMFtN4w1cfhWC5rdyJI3cQfHc/cjaXxCe4D3VY0r2cv/CL8VZPDxtMKti3btBfHxdnpuXhu8S5bPxKxLw4sNKGjGAsxmmORkLKcOifktZXGq7IclVXdt8uChEoDBXbJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758106169; c=relaxed/simple;
	bh=Lv8lsxmw1T40EYS0DvJKScoRYDPLYB5fZTCwKGxV9KQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=at5mGdcQI/UQFrZ/yr5p4C8nM1AjXNpvYvDGgLUi1rj3IfeMjDLo5ylNEVUKzitV4+8FYvqa0rvFYLW5TKnQZPzcCYwbHvPlAApcFi7+v1SLAwSADFImLMggdJ3J2Xd2nbQpOQd6guYnvE8LdSNVMX6C9fW/4IXXHAbYhFk56+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=niTkxtcE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7sXTFmdj; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=niTkxtcE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7sXTFmdj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="niTkxtcE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7sXTFmdj";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="niTkxtcE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7sXTFmdj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 054001F7B8;
	Wed, 17 Sep 2025 10:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758106164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u8t6SHPjmQz0qqNQrQ8pFqlRTGyimMO7f4zNnyjDmnw=;
	b=niTkxtcEsWHMLusW2uhOMmiQ+Zfat7dgrfB4F9HpeVv6d6//vidrvTnU/aJ4FYqBUF6/31
	S8xdorf8fnri1Yz4VUshF2jJ8nD3YR9xyA5krXG5aE2bhuBHqd5dn3msDcKISdnCbwA/zG
	3PnSCfyh+pAV2PK+IzaNWAQWDSAuWLw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758106164;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u8t6SHPjmQz0qqNQrQ8pFqlRTGyimMO7f4zNnyjDmnw=;
	b=7sXTFmdjfBvPh9vPl+957gltmt72YVjGoLfmTjzZc9/62+QYrp3JFMXUWd+wQo8Bl2PL++
	hD8DSBFfFKYnHNBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=niTkxtcE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7sXTFmdj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758106164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u8t6SHPjmQz0qqNQrQ8pFqlRTGyimMO7f4zNnyjDmnw=;
	b=niTkxtcEsWHMLusW2uhOMmiQ+Zfat7dgrfB4F9HpeVv6d6//vidrvTnU/aJ4FYqBUF6/31
	S8xdorf8fnri1Yz4VUshF2jJ8nD3YR9xyA5krXG5aE2bhuBHqd5dn3msDcKISdnCbwA/zG
	3PnSCfyh+pAV2PK+IzaNWAQWDSAuWLw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758106164;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u8t6SHPjmQz0qqNQrQ8pFqlRTGyimMO7f4zNnyjDmnw=;
	b=7sXTFmdjfBvPh9vPl+957gltmt72YVjGoLfmTjzZc9/62+QYrp3JFMXUWd+wQo8Bl2PL++
	hD8DSBFfFKYnHNBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 66CFE1368D;
	Wed, 17 Sep 2025 10:49:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 50PgFTCSymh8PQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 17 Sep 2025 10:49:20 +0000
Date: Wed, 17 Sep 2025 11:49:18 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "David S . Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Jann Horn <jannh@google.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	kexec@lists.infradead.org, kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>, 
	iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 05/13] mm/vma: rename __mmap_prepare() function to
 avoid confusion
Message-ID: <jokgdkyv4ca4sb7nl2wjkzxclhzhaee4p4luwj546tsdbylfei@laplfpugf3of>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <3063484588ffc8a74cca35e1f0c16f6f3d458259.1758031792.git.lorenzo.stoakes@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3063484588ffc8a74cca35e1f0c16f6f3d458259.1758031792.git.lorenzo.stoakes@oracle.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,lwn.net,infradead.org,kernel.org,alpha.franken.de,linux.ibm.com,davemloft.net,gaisler.com,arndb.de,linuxfoundation.org,intel.com,fluxnic.net,linux.dev,suse.de,redhat.com,paragon-software.com,arm.com,zeniv.linux.org.uk,suse.cz,oracle.com,google.com,suse.com,linux.alibaba.com,gmail.com,vger.kernel.org,lists.linux.dev,kvack.org,lists.infradead.org,googlegroups.com,nvidia.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_GT_50(0.00)[62];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	R_RATELIMIT(0.00)[to_ip_from(RLzjiba8kn1xq17x95uu9jb85x)];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 054001F7B8
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -2.51

On Tue, Sep 16, 2025 at 03:11:51PM +0100, Lorenzo Stoakes wrote:
> Now we have the f_op->mmap_prepare() hook, having a static function called
> __mmap_prepare() that has nothing to do with it is confusing, so rename
> the function to __mmap_setup().
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

I would love to bikeshed on the new name (maybe something more descriptive?),
but I don't really mind.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro
