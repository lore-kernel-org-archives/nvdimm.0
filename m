Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD562264C0;
	Sat, 11 Jul 2026 06:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783751212; cv=none; b=BcbsEEjgz04NdieG4SNAPGGawnk6LeywLausOq+G76A8VZlPoQc7UC7vZHj8flly1IbJutok5QJgHSfXFsQ0ePjPZr63ynaIjVyukrnbXsTW0AaUjLbccbn8n2xJCKL5fCvpviG3ZgiX6FcphkhWQvJrec3jX4oxSDaK67tBuZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783751212; c=relaxed/simple;
	bh=fyUGvWmUGACJLEHGpYeulTvAaiRvGhXhRKDDaDcbNsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cx+qfBMEEIncAInhK3kvll5M5x0UL/v4iPKLmfYSPE/+Q0Vu5M6uzCta8JD8zoEWexDOHrDApUoYWAGhtQ3OmaB/N+RFMaNmezfCcB/MeteZiRLDeFHXMD1NIa8cpLVwFoidSqY1oUMz/t/we4fWgBVqtqPm3tE4amaWs3WHj5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cnxr8ph+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cnxr8ph+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C64C1F000E9;
	Sat, 11 Jul 2026 06:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783751211;
	bh=oEOFuhzeieMbnwaju2e0IyYLOOljLY7Vu3oSd3kdBHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cnxr8ph+JvOklROMnVucJQrwHjsALSCj4Ss+aIH/0LX604Xs1T9DH/LiBtq8DJ7CB
	 bbFTc6S7EMzv13aXVNHz37o3w0H8cJVDkv4EEInq5aeJXRMvt824n4tG1k47YNFa8G
	 EEA2Db90wtgvblrtq8KsiTYxReeJpSlF3eZjjkyY3N1viC0WHBwCxq3l1oRlpcYqS7
	 QgRD0/favy08A6S+5sgaUW5i6AYO6b9zdbFwe0prWZorlAfVWtQE7i8a/bTndcjz/R
	 KrW6QiZSCXk9Ev7/ALIwvBmzcfBLHJNn0n1YTZf1YI9xC0rUFXaw8voXqV1/nPb13z
	 PG0yxvDGEfIrA==
Date: Sat, 11 Jul 2026 07:26:27 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
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
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 30/30] tools/testing/vma: output compared expression on
 ASSERT_[EQ, NE]()
Message-ID: <alHh1cPs9tNLMLJf@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <432444fa4c12ae1c4047550e2b205d3e9bab458f.1782735110.git.ljs@kernel.org>
 <alFausURKttxHUAI@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alFausURKttxHUAI@gourry-fedora-PF4VCD3F>

On Fri, Jul 10, 2026 at 04:48:58PM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 01:23:41PM +0100, Lorenzo Stoakes wrote:
> > -#define ASSERT_TRUE(_expr)						\
> > -	do {								\
> > -		if (!(_expr)) {						\
> > -			fprintf(stderr,					\
> > -				"Assert FAILED at %s:%d:%s(): %s is FALSE.\n", \
> > -				__FILE__, __LINE__, __FUNCTION__, #_expr); \
> > -			return false;					\
> > -		}							\
> > +#define __ASSERT_TRUE(_expr, _fmt, ...)					   \
> > +	do {								   \
> > +		if (!(_expr)) {						   \
> > +			fprintf(stderr,					   \
> > +				"Assert FAILED at %s:%d:%s(): %s is FALSE" \
> > +				_fmt ".\n",				   \
> > +				__FILE__, __LINE__, __FUNCTION__, #_expr   \
> > +				__VA_OPT__(,) __VA_ARGS__);		   \
> > +			return false;					   \
> > +		}							   \
> >  	} while (0)
> >
> > +#define __TO_SCALAR(x)	((unsigned long long)(uintptr_t)(x))
> > +
> > +#define ASSERT_TRUE(_expr) __ASSERT_TRUE(_expr, "")
>
> Mmmmm... macro madness.... I don't think this is what you want.
>
> I think you end up double-running the expression in the failure branch.
>
>   ASSERT_EQ(cleanup_mm(&mm, &vmi), 2)
>
> run through the preprocessor expands to:
>
>   do {
>       if (!( (cleanup_mm(&mm, &vmi)) == (2) )) {
>               **** first run ****
>
>           fprintf(stderr,
>               "Assert FAILED at %s:%d:%s(): %s is FALSE" " (0x%llx != 0x%llx)" ".\n",
>               "merge.c", 645, __FUNCTION__,
>               "(cleanup_mm(&mm, &vmi)) == (2)",
>               ((unsigned long long)(uintptr_t)(cleanup_mm(&mm, &vmi))),
>                                                **** second run ****
>
>               ((unsigned long long)(uintptr_t)(2)));
>           return false;
>       }
>   } while (0);
>
>
> A bunch of existing ASSERT callers mutate state, so there's no guarantee
> the printed value matches teh actual test value.
>
> I think you want something like:
>
> #define ASSERT_EQ(_val1, _val2) do {	\
> 	__auto_type _v1 = (_val1);	\
> 	__auto_type _v2 = (_val2);	\
> 	__ASSERT_TRUE(_v1 == _v2, " (0x%llx != 0x%llx)",	\
> 		__TO_SCALAR(_v1), __TO_SCALAR(_v2));	\
> } while (0)
>
> which expands to:
>
>   do {
>       __auto_type _v1 = (cleanup_mm(&mm, &vmi));
>       __auto_type _v2 = (2);
>       do {
>           if (!(_v1 == _v2)) {
>               fprintf(stderr, "...FALSE (0x%llx != 0x%llx).\n",
>                       "merge.c", 645, __FUNCTION__, "_v1 == _v2",
>                       ((unsigned long long)(uintptr_t)(_v1)),
>                       ((unsigned long long)(uintptr_t)(_v2)));
>               return false;
>           }
>       } while (0);
>   } while (0);
>
> ~Gregory

It's funny you should mention that... fixed in v2.

But ugh sorry that you reviewed this while I was also fixing this up (Claude
reported it also), your review's very appreciated :>)

Cheers, Lorenzo
