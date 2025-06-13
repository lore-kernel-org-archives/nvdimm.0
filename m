Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0662E11D6
	for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 13:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749822686; cv=none; b=HQXx2NLNqmZUYA940YKjy+27zfokv69dVwEROyw6YBu0H6yAVp4ZH34VwJ6PoYZJ8MJRnElDl/VIPw1hwBrtRFZGevFwNpG9d5+MEmz1PRtTYKbjbkU7bzzUScPaQqHyrvDTn5cq4FEVJVJv5EQhZON8yVyGn5wyY5iFhQzfjNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749822686; c=relaxed/simple;
	bh=fWjrdTn9ahDL/yhq4EI+kPXyWDfEKhDyxOTrt9Cyzc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2tMlNYkd1Q76aXe55lhUvLps/XSwxeV/+0lJ1h5rdTv9Hwo33+g3+UQ2M8k4QEYJIQn09MUVAqO7hvAy+WHG03YOEqFVbEttCVurknyBcamRbasTr7qOHMahcyPU7TE7WeAEx4E1CoQQI/qfX54FDykuSOmwkcjrIuKTr/gB3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MPeK2koI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=X1BvddT8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MPeK2koI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=X1BvddT8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MPeK2koI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="X1BvddT8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MPeK2koI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="X1BvddT8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 95356219B3;
	Fri, 13 Jun 2025 13:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749822683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XPPCFRRWECVGkw1RvEAyBtsaT8JowaAghXLwWqGIjX4=;
	b=MPeK2koIHmGtjyeTxn/TIHd/3qV8R12DqcXikOzO7WEKMHW7mnQ9rEc5c+eUUKrBHJqpZg
	1jcdDwJf4VIyYhxHQT1XSH/mVi80SOeHv8oSk52OLGqx2f+kzgQxCh0bS+cL8B+Ji9d/+M
	Ad0w7/08vEUQbUkFkamKJkNneQ9CVco=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749822683;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XPPCFRRWECVGkw1RvEAyBtsaT8JowaAghXLwWqGIjX4=;
	b=X1BvddT8ac656JKa6nlxpB/MsRIdRy4dN+iucSHOkqGo/t/r+Wg0/FEs6kueVrBOBtL/B3
	xAMMCKnrcLms6RDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749822683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XPPCFRRWECVGkw1RvEAyBtsaT8JowaAghXLwWqGIjX4=;
	b=MPeK2koIHmGtjyeTxn/TIHd/3qV8R12DqcXikOzO7WEKMHW7mnQ9rEc5c+eUUKrBHJqpZg
	1jcdDwJf4VIyYhxHQT1XSH/mVi80SOeHv8oSk52OLGqx2f+kzgQxCh0bS+cL8B+Ji9d/+M
	Ad0w7/08vEUQbUkFkamKJkNneQ9CVco=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749822683;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XPPCFRRWECVGkw1RvEAyBtsaT8JowaAghXLwWqGIjX4=;
	b=X1BvddT8ac656JKa6nlxpB/MsRIdRy4dN+iucSHOkqGo/t/r+Wg0/FEs6kueVrBOBtL/B3
	xAMMCKnrcLms6RDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 92F51137FE;
	Fri, 13 Jun 2025 13:51:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R9xDIdosTGioCwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Fri, 13 Jun 2025 13:51:22 +0000
Date: Fri, 13 Jun 2025 15:51:12 +0200
From: Oscar Salvador <osalvador@suse.de>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v3 2/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pmd()
Message-ID: <aEws0EQ6a3659F1g@localhost.localdomain>
References: <20250613092702.1943533-1-david@redhat.com>
 <20250613092702.1943533-3-david@redhat.com>
 <aEwseqmFrpNO5NJC@localhost.localdomain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEwseqmFrpNO5NJC@localhost.localdomain>
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Fri, Jun 13, 2025 at 03:49:46PM +0200, Oscar Salvador wrote:
> Reviewed-by: Oscar salvador <osalvador@suse.de>

Fat-fingers on a Friday afternoon:

Reviewed-by: Oscar Salvador <osalvador@suse.de>
 

-- 
Oscar Salvador
SUSE Labs
