Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC822517A5
	for <nvdimm@lists.linux.dev>; Tue, 29 Jul 2025 18:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753814350; cv=none; b=gf+2v+VBUv2TcOU4wBEylzGByl5VcrQldxRUSND6AMQg+/y/kX3krDNwVgszCTKivzcEbTHe4ATdQj9df0FE+LZ0u7CElUATTX/CS+G0+UabKfxcf8vUa104DZCLEB+3iPSrXwisGv9R7n8AX5sROxZCnYA8ve5wQ5iFqDJNhjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753814350; c=relaxed/simple;
	bh=K0MGb4ayzYxYJZKg1HWu8KpfAsEMhfWFw3xLTjemhe4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0wxXbYPDf4qe3QnA7aZ37GmQ0TQy8ZitdH0gW2zxPt5KhR7kD/WqyGm59PRG68l89NixYmiWEzEjNldezOal7IR0+R1X2l590IabEksIYD+zmGX6PgG/fIay31CmHNAC1Gkjxd3vF8oEDfhw7jhq7kr4L+WdAxaBIr3fUBxq8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cFsD0Y76; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cFsD0Y76"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-32e14cf205cso58663501fa.1
        for <nvdimm@lists.linux.dev>; Tue, 29 Jul 2025 11:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753814347; x=1754419147; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GYRfCV3hbQi5DsgzlDild2w/1OeWF4e+oM87WSvfwwM=;
        b=cFsD0Y763kMol/PrunyKosjCVz/b4mChu9Olg7HYDpNc/6OX58y64IacMfio0DzXOU
         UsUWLSSoUFSVwJpMV5UhAZPS25UXLY0FOQII1qATSCj2u0x4L3wPp1WTXgGpbSivQhni
         Ka5wxE87lT/mS+/JR6T0rfBo0JeCmolimUhz0DH0LA0GojRwKVPIdqv58lJ4nsNg8P2I
         18A2DMZqfblLpKpJ6SZsUimLajXUDi6dQNs4cvHa+pKFMRtLbLUQ4m1YnbKQ/vpnzBfj
         wM6LWwEqURpPRDzeLa9TnsgDxeqlkOsj/IXIRwSGnbRhfDn0+qAn9e7zXxabbTU2wmSd
         fEqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753814347; x=1754419147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GYRfCV3hbQi5DsgzlDild2w/1OeWF4e+oM87WSvfwwM=;
        b=Qf0st+OmaE+jcyPAdRYJTdLIkvc9caOJLQ0jFbopefXL9YY2YAMlWTA/ZZU9NtL1d5
         E9obJpG5KEzjl7hfVvSJ1l1ZD5VSiP1Duzpm/ByE39Km7pZ+dtWE5zfqCX+zsRwW/xAs
         xs/pNLYb2LFp+qZqxTlfMzs3HbZQaZk2znzb/xccLZkMoxEIwlPYZxByrtN5/Epo3KhG
         7soGkt7tPA09xlqhQX5h/JcHyveUFvoS47fK66DRYY4i/bu2sQUrRvDD6eD1dVKsnQ0d
         zsD3dQsYs6QP4W8nIjWlPvhRP6ZbRhnmyOwChTJ0QmPcn37Oadmx4mm2oc5S9+jVcd4H
         nC6g==
X-Forwarded-Encrypted: i=1; AJvYcCXYTGE+Y4hz7ub5aMzTPyXgcqEpLH/kXDH4l/1/9B9Zs6n1O7u6EbGPyVm5CeS+T4+cE7fAOK8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQuiTgnsO3pDZMC0amvgs6j/X5Fxmk7S5DlAoHj196cxaEMiAe
	Oaje3fGIiQY2tr5zi3NGDcVk71j11tgijF+6MZj2LnysoOas+7/b/FWO
X-Gm-Gg: ASbGnctGtjSFnlHBcD8JtR7tkP0flT/t9btIQ/020oejgfUiVIB5L2Mr3QdHwgiJeVu
	3LCyqQiR4Q+VUJgh60DGVBS5OK+C+vxGARP01QrWb9tmP1rzKQDA1cr6O7AVh4WfRm4WRwvz3rm
	aihGBtqoHWrhIxsGJzXMG48b2KQa9blp1uR0X01CkoH29iM8XVXO25NR0CRkjI9fM32sREK9rY/
	RyFgrJUPouobEvFuttLiY35+Yrm/IDjj8jglh2C7d4U+Oy9vGN2pmnnT3trzhlSvQmQfEHNOEE5
	WAUqkhCjvuXHkANBYrJr/Zns1G6gy+TVtorQPx7/7Q8e5KyfiKDD1poF1/FkI8IE
X-Google-Smtp-Source: AGHT+IF9yvJyPiTzwXfrNX8PT/G9myfdCCK3lbY+TklU3bxii0UFYjkiLDeONxAItTuHZBzIFqK+RA==
X-Received: by 2002:a05:6512:3414:b0:553:241d:4e77 with SMTP id 2adb3069b0e04-55b7c011afdmr184040e87.22.1753814346295;
        Tue, 29 Jul 2025 11:39:06 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-332219ce7aesm832441fa.34.2025.07.29.11.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 11:39:04 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 29 Jul 2025 20:39:01 +0200
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Harry Yoo <harry.yoo@oracle.com>,
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
	Uladzislau Rezki <urezki@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-sgx@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: update core kernel code to use vm_flags_t
 consistently
Message-ID: <aIkVRTouPqhcxOes@pc636>
References: <cover.1750274467.git.lorenzo.stoakes@oracle.com>
 <d1588e7bb96d1ea3fe7b9df2c699d5b4592d901d.1750274467.git.lorenzo.stoakes@oracle.com>
 <aIgSpAnU8EaIcqd9@hyeyoo>
 <73764aaa-2186-4c8e-8523-55705018d842@lucifer.local>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73764aaa-2186-4c8e-8523-55705018d842@lucifer.local>

On Tue, Jul 29, 2025 at 06:25:39AM +0100, Lorenzo Stoakes wrote:
> Andrew - FYI there's nothing to worry about here, the type remains
> precisely the same, and I'll send a patch to fix this trivial issue so when
> later this type changes vmalloc will be uaffected.
> 
> On Tue, Jul 29, 2025 at 09:15:51AM +0900, Harry Yoo wrote:
> > [Adding Uladzislau to Cc]
> 
> Ulad - could we PLEASE get rid of 'vm_flags' in vmalloc? It's the precise
> same name and (currently) type as vma->vm_flags and is already the source
> of confusion.
> 
You mean all "vm_flags" variable names? "vm_struct" has flags as a
member. So you want:

urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/execmem.c
29:                          pgprot_t pgprot, unsigned long vm_flags)
39:             vm_flags |= VM_DEFER_KMEMLEAK;
41:     if (vm_flags & VM_ALLOW_HUGE_VMAP)
45:                              pgprot, vm_flags, NUMA_NO_NODE,
51:                                      pgprot, vm_flags, NUMA_NO_NODE,
85:                          pgprot_t pgprot, unsigned long vm_flags)
259:    unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
266:    p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
376:    unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
385:            p = execmem_vmalloc(range, size, pgprot, vm_flags);
urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/vmalloc.c
3853: * @vm_flags:                additional vm area flags (e.g. %VM_NO_GUARD)
3875:                   pgprot_t prot, unsigned long vm_flags, int node,
3894:   if (vmap_allow_huge && (vm_flags & VM_ALLOW_HUGE_VMAP)) {
3912:                             VM_UNINITIALIZED | vm_flags, start, end, node,
3977:   if (!(vm_flags & VM_DEFER_KMEMLEAK))
4621:   vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/execmem.c
29:                          pgprot_t pgprot, unsigned long vm_flags)
39:             vm_flags |= VM_DEFER_KMEMLEAK;
41:     if (vm_flags & VM_ALLOW_HUGE_VMAP)
45:                              pgprot, vm_flags, NUMA_NO_NODE,
51:                                      pgprot, vm_flags, NUMA_NO_NODE,
85:                          pgprot_t pgprot, unsigned long vm_flags)
259:    unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
266:    p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
376:    unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
385:            p = execmem_vmalloc(range, size, pgprot, vm_flags);
urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags ./include/linux/vmalloc.h
172:                    pgprot_t prot, unsigned long vm_flags, int node,
urezki@pc638:~/data/backup/coding/linux-not-broken.git$

to rename all those "vm_flags" to something, for example, like "flags"?

Thanks!

--
Uladzislau Rezki
