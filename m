Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D858F3905F5
	for <nvdimm@lists.linux.dev>; Thu,  2 Jul 2026 11:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782993199; cv=none; b=PxVWj+KumMerktOo6Hy5ujXNXMMUnVV0Fkj7+5qkPlK7b3JrmlkcjtafpuDy/MPwyfcbheXwHCMLs6miCu0coNvsXz3z1W15bUZEPtqhTpXqXn6BaK0/JPMgQR5UY6yhNvDJQMZXXCeI7d4w2BQLdjQ+JnFvngWV0soLnMrL4sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782993199; c=relaxed/simple;
	bh=0nzVK4pL1TFIe/BHP21jD7kuyIRs9dRrUj42zYkQjp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvzvktKK1YmAk5a4eKz3v3bksmNT4EIco/w9lic6nfy3eZp/F5o4Mzxm7ZF1Aidvsc8g3YnZkKnm7d/THZxhzkLlIEqY7GK9OjMkgbGEfp4Wls2GmawPVFIOzc7syAoaQ/e1gHAA6010IVibaIcHJE908TK3JNmCojF0ftjUcH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xYVfKCYZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1CfcEF2X; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZsoQ8uTQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KH4HUf0G; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xYVfKCYZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1CfcEF2X";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZsoQ8uTQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KH4HUf0G"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2250F741A2;
	Thu,  2 Jul 2026 11:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782993196; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vVyat4DfuJxMczGxKMvPQcf269Ets9cihaExe8YQLuA=;
	b=xYVfKCYZqsD2UpmKdK9fQagIYcRuil6l2nF+c+r+OdaWXSJ3/rwYjd7a01znBykkCl/Xt3
	9O4NKD4ShEoEJNxL6hGpG4AaLC9aa6PdJXC9DHJBilYLHQ97wn3GN35NJMqUm9UCDFS88r
	wicYeO/ITfDsf1NnfuUfNeKKq6hAmCg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782993196;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vVyat4DfuJxMczGxKMvPQcf269Ets9cihaExe8YQLuA=;
	b=1CfcEF2XREK0S/tUSQtvmsJmKkDvH3H5nu0WdgGnc2E7VNJZR/Zw6wuuz38wcdrZmhtyEi
	jix7vUFpBgOEGBCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782993195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vVyat4DfuJxMczGxKMvPQcf269Ets9cihaExe8YQLuA=;
	b=ZsoQ8uTQ9HKMle6PfLos3WQbXxWjN5sSXPSkT4+ZanUKBq2lpNP4jJRp6GUkrzXkwHJjvB
	yWpyhzC0YNGQkPHvBgmFCvrDVYHqifJdwhEcBa2T0tb/TAg1tJpbYwf72U7Ci9qPVJUSvT
	ORMtcGbh+MGBJHqHakIUbwKXHdphSvU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782993195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vVyat4DfuJxMczGxKMvPQcf269Ets9cihaExe8YQLuA=;
	b=KH4HUf0G2xIXtfn7ykyjf+pVZsRa2r7mxNuifMcKR/Sb9aOtVjljEmdJqCSJ/e9IL2sF9Y
	uM7PBo8soLh0gDAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A8A84779AA;
	Thu,  2 Jul 2026 11:53:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6MDvJSZRRmr6DwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 02 Jul 2026 11:53:10 +0000
Date: Thu, 2 Jul 2026 12:53:09 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 30/30] tools/testing/vma: output compared expression on
 ASSERT_[EQ, NE]()
Message-ID: <akZPXB56I83vkyxd@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <432444fa4c12ae1c4047550e2b205d3e9bab458f.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <432444fa4c12ae1c4047550e2b205d3e9bab458f.1782735110.git.ljs@kernel.org>
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,armlinux.org.uk,kernel.org,siemens-energy.com,hansenpartnership.com,gmx.de,redhat.com,alien8.de,linux.intel.com,mev.co.uk,visionengravers.com,pengutronix.de,gmail.com,ffwll.ch,suse.de,oss.qualcomm.com,ideasonboard.com,nvidia.com,amd.com,shazbot.org,zeniv.linux.org.uk,linux.dev,google.com,infradead.org,samsung.com,goodmis.org,huawei.com,vger.kernel.org,lists.infradead.org,lists.freedesktop.org,lists.linux.dev,kvack.org,googlegroups.com,surriel.com];
	R_RATELIMIT(0.00)[to_ip_from(RL3mhzhn45zpqpmgqn4z7synfm)];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_GT_50(0.00)[75];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,pedro-suse.lan:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Mon, Jun 29, 2026 at 01:23:41PM +0100, Lorenzo Stoakes wrote:
> Update the macros to output the compared values at hex for easier debugging
> when test asserts fail.
> 
> Also remove unused IS_SET() macro.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  tools/testing/vma/shared.h | 31 +++++++++++++++++++------------
>  1 file changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/vma/shared.h b/tools/testing/vma/shared.h
> index ca4f1238f1c7..216be4cda369 100644
> --- a/tools/testing/vma/shared.h
> +++ b/tools/testing/vma/shared.h
> @@ -21,19 +21,28 @@
>  		}							\
>  	} while (0)
> 
> -#define ASSERT_TRUE(_expr)						\
> -	do {								\
> -		if (!(_expr)) {						\
> -			fprintf(stderr,					\
> -				"Assert FAILED at %s:%d:%s(): %s is FALSE.\n", \
> -				__FILE__, __LINE__, __FUNCTION__, #_expr); \
> -			return false;					\
> -		}							\
> +#define __ASSERT_TRUE(_expr, _fmt, ...)					   \
> +	do {								   \
> +		if (!(_expr)) {						   \
> +			fprintf(stderr,					   \
> +				"Assert FAILED at %s:%d:%s(): %s is FALSE" \
> +				_fmt ".\n",				   \
> +				__FILE__, __LINE__, __FUNCTION__, #_expr   \
> +				__VA_OPT__(,) __VA_ARGS__);		   \
> +			return false;					   \
> +		}							   \
>  	} while (0)
> 
> +#define __TO_SCALAR(x)	((unsigned long long)(uintptr_t)(x))

There's a slight footgun here: this can truncate 64-bit types in 32-bit archs.
Though it doesn't really matter in our case, I think.

> +
> +#define ASSERT_TRUE(_expr) __ASSERT_TRUE(_expr, "")
>  #define ASSERT_FALSE(_expr) ASSERT_TRUE(!(_expr))
> -#define ASSERT_EQ(_val1, _val2) ASSERT_TRUE((_val1) == (_val2))
> -#define ASSERT_NE(_val1, _val2) ASSERT_TRUE((_val1) != (_val2))
> +#define ASSERT_EQ(_val1, _val2)						\
> +	__ASSERT_TRUE((_val1) == (_val2), " (0x%llx != 0x%llx)",	\
> +		      __TO_SCALAR(_val1), __TO_SCALAR(_val2))
> +#define ASSERT_NE(_val1, _val2) \
> +	__ASSERT_TRUE((_val1) != (_val2), " (0x%llx == 0x%llx)", \
> +		       __TO_SCALAR(_val1), __TO_SCALAR(_val2))
> 
>  #define ASSERT_FLAGS_SAME_MASK(_flags, _flags_other) \
>  	ASSERT_TRUE(vma_flags_same_mask((_flags), (_flags_other)))
> @@ -53,8 +62,6 @@
>  #define ASSERT_FLAGS_NONEMPTY(_flags) \
>  	ASSERT_FALSE(vma_flags_empty(_flags))
> 
> -#define IS_SET(_val, _flags) ((_val & _flags) == _flags)
> -
>  extern bool fail_prealloc;
> 
>  /* Override vma_iter_prealloc() so we can choose to fail it. */
> --
> 2.54.0

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro
