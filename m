Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C362DFA4A
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 10:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758105712; cv=none; b=E0XLbsjnAO7drndPo4cL2da4Ugpq0/v+3BIfJbxZwgKjtnF3ltS2rxncqZgByD7xt+wrHURuttoB0lYRbbU8sqSuBGgSpy4kXbcvqmhy/lsBYumn9Y0dv49Q2WK69WT1xKyFv0Vov27zNczKtMzCYglCJHHlKR/6wHUBIANGz1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758105712; c=relaxed/simple;
	bh=EeQIzYruA0FedL169V+W6uX8pts0cRiItZjv2xk0G+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fThbwViC+OHTCVM8vMwMCdcLLBj78OQbAVguhp8IUdDzEwqcw/biy7UmGDbhmSbv5eoWm7+0e7MEtdeXy//27EaYZlrjkd8w8ROFh/mTk1mYl2M3jqHefRIaUf4m/PpxsanOeRZNBa70O5Q0xpSNJ7toPkNs9FD8PFs77hfcclk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DukI9feJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cNqFvcTO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DukI9feJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cNqFvcTO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DukI9feJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cNqFvcTO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DukI9feJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cNqFvcTO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ABBA222096;
	Wed, 17 Sep 2025 10:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758105709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ofj744S0hdgV+oqudN+JHGPXOpDjYVMC07hCO7WqjNw=;
	b=DukI9feJZ9PHgr6VTWS5HiVn6jlBgHPZpHg9NAZaFM1yw3drJVaDQdEhCoGEF+xCybfKQi
	KigTRbEqW8N/WTK5cnGsrUK8yI1e3tSEiEHWYw63RkG5+wJoQRAlGRnyBLdbAweJqhkvFG
	K+M9ZwPSAHpES21BjOxPwep1vHqojMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758105709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ofj744S0hdgV+oqudN+JHGPXOpDjYVMC07hCO7WqjNw=;
	b=cNqFvcTO/C5yxY1VCi5d3aNqbq/TGtGlWg7DF48yF4jgUx+6Nw9p12MfcKeo18wD1Fyfa/
	aIyR+xrwgNcBRQCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DukI9feJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cNqFvcTO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758105709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ofj744S0hdgV+oqudN+JHGPXOpDjYVMC07hCO7WqjNw=;
	b=DukI9feJZ9PHgr6VTWS5HiVn6jlBgHPZpHg9NAZaFM1yw3drJVaDQdEhCoGEF+xCybfKQi
	KigTRbEqW8N/WTK5cnGsrUK8yI1e3tSEiEHWYw63RkG5+wJoQRAlGRnyBLdbAweJqhkvFG
	K+M9ZwPSAHpES21BjOxPwep1vHqojMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758105709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ofj744S0hdgV+oqudN+JHGPXOpDjYVMC07hCO7WqjNw=;
	b=cNqFvcTO/C5yxY1VCi5d3aNqbq/TGtGlWg7DF48yF4jgUx+6Nw9p12MfcKeo18wD1Fyfa/
	aIyR+xrwgNcBRQCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 33E9F1368D;
	Wed, 17 Sep 2025 10:41:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gAoOCWqQymiEOgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 17 Sep 2025 10:41:46 +0000
Date: Wed, 17 Sep 2025 11:41:44 +0100
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
Subject: Re: [PATCH v3 04/13] relay: update relay to use mmap_prepare
Message-ID: <jrxexcuzlxpnfs2jhm7ecdh4kak5i4a6e5od4cm72fn3twwzms@vptu5rfimbez>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <ae3769daca38035aaa71ab3468f654c2032b9ccb.1758031792.git.lorenzo.stoakes@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae3769daca38035aaa71ab3468f654c2032b9ccb.1758031792.git.lorenzo.stoakes@oracle.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[linux-foundation.org,lwn.net,infradead.org,kernel.org,alpha.franken.de,linux.ibm.com,davemloft.net,gaisler.com,arndb.de,linuxfoundation.org,intel.com,fluxnic.net,linux.dev,suse.de,redhat.com,paragon-software.com,arm.com,zeniv.linux.org.uk,suse.cz,oracle.com,google.com,suse.com,linux.alibaba.com,gmail.com,vger.kernel.org,lists.linux.dev,kvack.org,lists.infradead.org,googlegroups.com,nvidia.com];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	R_RATELIMIT(0.00)[to_ip_from(RLzjiba8kn1xq17x95uu9jb85x)];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_GT_50(0.00)[62];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,suse.de:email,suse.de:dkim]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: ABBA222096
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -2.51

On Tue, Sep 16, 2025 at 03:11:50PM +0100, Lorenzo Stoakes wrote:
> It is relatively trivial to update this code to use the f_op->mmap_prepare
> hook in favour of the deprecated f_op->mmap hook, so do so.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro
