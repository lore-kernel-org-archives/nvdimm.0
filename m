Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4367B
	for <nvdimm@lists.linux.dev>; Tue, 12 Apr 2022 09:54:00 +0000 (UTC)
Received: from zn.tnic (p200300ea97156149329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9715:6149:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3135C1EC04EC;
	Tue, 12 Apr 2022 11:53:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1649757234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=juw7VzB56UKaB4KslRsPqKcKyA9IXYjsuIL6qC0OH24=;
	b=IudAycwHR56V9u9XIIOAyDIMIL7rNI2FMyxnlVozrhoGkeqneIef3NdEUTbhXv6NK0xjP9
	7CKVVuL+XcOPs8bZ6fV2nDhOY8dIZmvoOSpGmDN/xP+79eC2a01UgC2Ekv182YyGX1r+VW
	U+fOdZ9IYB+WeMkhUgTqBjwyw6NQT2I=
Date: Tue, 12 Apr 2022 11:53:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v7 1/6] x86/mm: fix comment
Message-ID: <YlVMMmTbaTqipwM9@zn.tnic>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-2-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220405194747.2386619-2-jane.chu@oracle.com>

On Tue, Apr 05, 2022 at 01:47:42PM -0600, Jane Chu wrote:
> There is no _set_memory_prot internal helper, while coming across
> the code, might as well fix the comment.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  arch/x86/mm/pat/set_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index abf5ed76e4b7..38af155aaba9 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -1816,7 +1816,7 @@ static inline int cpa_clear_pages_array(struct page **pages, int numpages,
>  }
>  
>  /*
> - * _set_memory_prot is an internal helper for callers that have been passed
> + * __set_memory_prot is an internal helper for callers that have been passed
>   * a pgprot_t value from upper layers and a reservation has already been taken.
>   * If you want to set the pgprot to a specific page protocol, use the
>   * set_memory_xx() functions.
> -- 

This is such a trivial change so that having it as a separate patch is
probably not needed - might as well merge it with patch 3...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
