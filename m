Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED15225761
	for <nvdimm@lists.linux.dev>; Wed, 27 Aug 2025 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756313965; cv=none; b=XvSaLawO9ALAik6KbTKcU2LSPMwwcJUWOiQNe0a8yc3ucp1mZaAkjmVsiMvsFYmoqMMcU+iF0grctJfG0ugWrM/1nPHLbN2hk34XF2fsG+w9dTiR1gBi1XAQMw2dGYGRXdSTNJOVaYX+m6No2FHq8FxWR8wlIQ0ms1067e084CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756313965; c=relaxed/simple;
	bh=HP+oCFjbaV0ErYQHYOSOr3F3umYVDZHj90JBCgWCcms=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIvMdXL2aP2v/bzQdVJIKI/Y9ZWXRdyNW560ii21ibwt2KTiGvfC1LcaCeEihbBDEjR120qEgvQ1n0utLobbOU2Kri7llQndnjbIM+WYRztLY+aPg9BlVUAxMeDseA9VAyr9dL5t6BqViJ9qlqWWsvcBHlHp59oUZM7WFmla+78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZkHT8go5; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZkHT8go5"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3366f66a04cso424131fa.1
        for <nvdimm@lists.linux.dev>; Wed, 27 Aug 2025 09:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756313962; x=1756918762; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cSz+0Jdl3rsxgIMqjiE4eLITB/Ptqi8xoIkjq9Q3i9w=;
        b=ZkHT8go50q4i0G2hbSAKMhUGQ1TWcdSTQeF5AacngiBnzBCTqOMLIjcf1J8w0Ti+G6
         3Fz/R28Q2tT+u3yc6hL15dqyCchFa9Iq+nTyZFJYxDMl//xCAPISCdSzzI5/uNRnzrx5
         DoIfxJ/AASKByH1PNahQojSczjSRYD4MxVaH0LLlMMynQ03JgYG0edsaisNJ+sXCi6WQ
         z9mdd/++cFB9hK/h7QWBCQ3zNLiNJdlwPY9Y/qwNxey7NlLkWL5puawyn2Fy5xF3xEs+
         19iCC+5BVDpIe2Y3pe0kWRoPY3OmNLZnJE+1aniHOeWZJxjFom2qoorBoDODcvl15C0C
         99ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756313962; x=1756918762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cSz+0Jdl3rsxgIMqjiE4eLITB/Ptqi8xoIkjq9Q3i9w=;
        b=OawxuGT0rrXHt4zJH47KH8FA0JQpR/MLcEJnPd5f9ge+csfCatErh7yLlKg1/G9jrx
         6ONNNPzZnVxxOXGumqHcrIk2Zu2gMh10cElb4x2e/Goziq9CJirzAyHStlH0+4bLaHji
         m8rP6IbKwJk/k3+mqELMuNX8SCNcq4RF/AhmyX4ZiChYh3JxAoRUZz3kGnpWyKBgx0IR
         l5XTiu0IgVsI63ne6RovXzJdSjbMqV14GJ4Ne7e1qF40qe1WHv/POk6lhSM4K6EvVSxz
         IbKIBD8jYw0IAM70q1W/iA4cbXn/xjQvRKjILI8eySoi9U6hbZEyCzIa+QlnxOeRKvbn
         wY7A==
X-Forwarded-Encrypted: i=1; AJvYcCWRBDHEelhdSAnas+DyV/CgAQ9trJ01oD7Axg406e4toRLMCKRYjSgB95JUDFFcrTS/ZQQoIiA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx//1BdMlGHod4P7knkHlCy5GAzCVgNDXY6F55Ljrv0X+bZMnn6
	t6JV8PmnzOfJKcNxQ5i2tqWE2FWRsLFy9tMQmhpZ37mMcs56gWZiua37
X-Gm-Gg: ASbGncuzBChTYIqVTJgVdSI0FbyMZYqWNyuhs/33dm6hcbZDHpFI0cUJmCarFumij9V
	e0e2GmVPnGoRB3i2INiwQ88qw126w4vTBeMCtNGifq5dbJJTALfUv3VnD+KnKHtJR1eA1FTWVqc
	9OVFCfbBw+SuKsGS0vcbnFeLdYgqsW4ocbJDzU+3+gs5+84N/BasyFrD68U0lsmgqO8dSi753/T
	iTfsn59GrvMGPIsESFnpGpWcXTYN4Eu63M7MyP2eNbUDmxiP6fDH/mPtx6QhT/oC26dj3TiyDsX
	LMXwgV78W6Pi/UezDhuYBuNNYdjr91GPuabkuiM5grS4IWMs+bP/FbSl+ByaiDIv9YT5ny5PPLt
	QOHUqLjprkwKH5L7o7xhWNL/muqeNPtwu0s2xD2SPkTIlTjk0NvRN
X-Google-Smtp-Source: AGHT+IG4BeCx/VIPO9rnbCc0YcRdZMlua4eVbdX3PpKt/fKDdzrBfr7yiiTFTWfK/4UfPVTpR7vpyQ==
X-Received: by 2002:a2e:be03:0:b0:336:7eed:2f8f with SMTP id 38308e7fff4ca-3367eed3c67mr29987221fa.32.1756313961794;
        Wed, 27 Aug 2025 09:59:21 -0700 (PDT)
Received: from pc636 (host-90-233-205-219.mobileonline.telia.com. [90.233.205.219])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3365e5da244sm27443611fa.58.2025.08.27.09.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 09:59:21 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 27 Aug 2025 18:59:16 +0200
To: Kees Cook <kees@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-sgx@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: update core kernel code to use vm_flags_t
 consistently
Message-ID: <aK85ZPVwBIv-sH85@pc636>
References: <cover.1750274467.git.lorenzo.stoakes@oracle.com>
 <d1588e7bb96d1ea3fe7b9df2c699d5b4592d901d.1750274467.git.lorenzo.stoakes@oracle.com>
 <aIgSpAnU8EaIcqd9@hyeyoo>
 <73764aaa-2186-4c8e-8523-55705018d842@lucifer.local>
 <aIkVRTouPqhcxOes@pc636>
 <69860c97-8a76-4ce5-b1d6-9d7c8370d9cd@lucifer.local>
 <aJCRXVP-ZFEPtl1Y@pc636>
 <aJHQ9XCLtibFjt93@kernel.org>
 <aJItxJNfn8B2JBbn@pc636>
 <202508251436.762035B@keescook>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508251436.762035B@keescook>

On Mon, Aug 25, 2025 at 02:37:11PM -0700, Kees Cook wrote:
> On Tue, Aug 05, 2025 at 06:13:56PM +0200, Uladzislau Rezki wrote:
> > I agree. Also it can be even moved under vmalloc.c. There is only one
> > user which needs it globally, it is usercopy.c. It uses find_vmap_area()
> > which is wrong. See:
> > 
> > <snip>
> > 	if (is_vmalloc_addr(ptr) && !pagefault_disabled()) {
> > 		struct vmap_area *area = find_vmap_area(addr);
> > 
> > 		if (!area)
> > 			usercopy_abort("vmalloc", "no area", to_user, 0, n);
> > 
> > 		if (n > area->va_end - addr) {
> > 			offset = addr - area->va_start;
> > 			usercopy_abort("vmalloc", NULL, to_user, offset, n);
> > 		}
> > 		return;
> > 	}
> > <snip>
> > 
> > we can add a function which just assign va_start, va_end as input
> > parameters and use them in the usercopy.c. 
> 
> Yes please! I'd must rather use some exported validation routine than
> having it hand-coded in usercopy.c. :)
> 
I will do it :)

--
Uladzislau Rezki
