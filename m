Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3FC22B585
	for <nvdimm@lists.linux.dev>; Thu, 19 Jun 2025 12:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750335531; cv=none; b=b9qhvmihaUDIab84zkRlCojk17d+sT7IFtqn+PN3dZsrQNrZ/oN2QzT3uSdit9oIS64OVyze84KGnR//51BqTTpU4ssel0K3KVM2ACwxK7DM1jUjswlxI2YIllP3nBzJ+y88bYgezXUe1D8hoc+1zUr+xQZcNfORtPyPXhp3OlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750335531; c=relaxed/simple;
	bh=CjKg6+dv4hvhun00CEKq5N6o+T3kt/+QgrCScn5vaeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m9P8Zc2+R09kjM2jpHrDyPt5mD1eLRAvGX8FsBjSl/Zl4+84v9jyP0edEz7MxlE3vzmjRAXurcEUHZCgx7CwSYmmCU/pzopuVwPoHgFuQUFX9+PmFS0gTvVbCS5JEu494C9VgQopowjE3HDVMeavED7jTn77Cw+JJg1BAZpxEdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0D9RoVhM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Dpgy3Wg7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DNfLMbsb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GORhZOkG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0D9RoVhM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Dpgy3Wg7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DNfLMbsb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GORhZOkG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EE91E21224;
	Thu, 19 Jun 2025 12:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1750335528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PDOfXTJCUy9RIYvfyC/VOHcfLVOwjMHrr1ef/hUG1vw=;
	b=0D9RoVhMEonp/hV8uaXnWkQPbV/JEuaAoBGz4lRYk1713uXnqsKqKKoKjGdrhc2Dxm9lIH
	xPTLBsMX/NzpFSt8Z6wsmFarTh8ePmF0/C2vSLhAv4ujwqHvxW2EykKXAEfy2z/KtXNqIJ
	RF5ZGN22HA8zNiJGlz/M3FJ4aqPbjqQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1750335528;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PDOfXTJCUy9RIYvfyC/VOHcfLVOwjMHrr1ef/hUG1vw=;
	b=Dpgy3Wg7YvJxx2jJaEYDWWkZ8WMyJT4ofeIkQFpdU0hzmcgb+8i0c1quG6kVrhxqduhSqd
	MQcmEXTDDIclnVBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1750335526; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PDOfXTJCUy9RIYvfyC/VOHcfLVOwjMHrr1ef/hUG1vw=;
	b=DNfLMbsbjxVntx3ja38oq/iryWc2jvDi14gzOxDZCREDjzMCyTp+fxF9sod6QxCr6g/ath
	ZOkym8ze3HY2eSmf4HuoLelv/Ku8HWF3A6pNTWsJ39nCYdtuuxB4LMimYLoXksWvdXExM0
	xR9ft5sK4GaEHPw/oEyq1gZJx0W0G+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1750335526;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PDOfXTJCUy9RIYvfyC/VOHcfLVOwjMHrr1ef/hUG1vw=;
	b=GORhZOkG7p30uftoHa+iJg98cr18tQpd7lZYHu0zHRqqPh8tSxwA0MCUU1H9jBkLy/etec
	5P1jtL4gJn/azEAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDD9C136CC;
	Thu, 19 Jun 2025 12:18:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QtXWKiIAVGg1egAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 19 Jun 2025 12:18:42 +0000
Date: Thu, 19 Jun 2025 14:18:40 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>, Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-sgx@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: update architecture and driver code to use
 vm_flags_t
Message-ID: <aFQAIK4hyFAU9Rk0@localhost.localdomain>
References: <cover.1750274467.git.lorenzo.stoakes@oracle.com>
 <b6eb1894abc5555ece80bb08af5c022ef780c8bc.1750274467.git.lorenzo.stoakes@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6eb1894abc5555ece80bb08af5c022ef780c8bc.1750274467.git.lorenzo.stoakes@oracle.com>
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLj6zumtikrrmnnbmzkety5zmd)];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_GT_50(0.00)[64];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,armlinux.org.uk,arm.com,kernel.org,linux.ibm.com,ellerman.id.au,gmail.com,csgroup.eu,davemloft.net,gaisler.com,linux.intel.com,linutronix.de,redhat.com,alien8.de,zytor.com,infradead.org,zeniv.linux.org.uk,suse.cz,nvidia.com,linux.alibaba.com,oracle.com,zte.com.cn,linux.dev,google.com,suse.com,surriel.com,intel.com,goodmis.org,efficios.com,ziepe.ca,suse.de,cmpxchg.org,bytedance.com,lists.infradead.org,vger.kernel.org,lists.ozlabs.org,kvack.org,lists.linux.dev];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.30

On Wed, Jun 18, 2025 at 08:42:54PM +0100, Lorenzo Stoakes wrote:
> In future we intend to change the vm_flags_t type, so it isn't correct for
> architecture and driver code to assume it is unsigned long. Correct this
> assumption across the board.
> 
> Overall, this patch does not introduce any functional change.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs
