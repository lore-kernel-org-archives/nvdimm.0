Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B063A27F015
	for <nvdimm@lists.linux.dev>; Tue,  5 Aug 2025 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754410445; cv=none; b=j3to9CgSqGKWm3DdMNfEAJ/mq9ymGjckCeYrz2mEgzKmYaP8d0fVtmoIZ5ZOXQolgYPBLDQyyQr7ie4kBit0ZOpVDpqciS6qHHMMBBX5AdjuyEcZGs4qxtEcMsJiyhoeHv8mNZnE+3QRCshaowAph9He+tGv2/LgdBIcfZQfS9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754410445; c=relaxed/simple;
	bh=BglbfbCfxjDdNAl+FJxNAK3U0aRdh/ewx/iXRTko+dM=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bCmNbeoNjxCiJOkQpA5AgctmWxrwYxOk64myWn6QfJKVFwLD9eZPsterRDrBgUAlXvak5oXqwn8pjfSS4/PZlT0jFZsr7WcS4ipaxi4Gn6RXxmjPGjbdu8tB+CBF96xZJ8joZ+Q+aRtuJWOa+31mDqWadGk6qdXVOy0PucI5B+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lr2hJVkO; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lr2hJVkO"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-332631e47afso714361fa.0
        for <nvdimm@lists.linux.dev>; Tue, 05 Aug 2025 09:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754410442; x=1755015242; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ut5lsjSSswYnbLzk6rrdmu5+CeAKFhijQRi1rB1wfMg=;
        b=lr2hJVkO8xZYliuamN8ADUOYsJ10msWLOldFkCwP0B7rsXgGzEtOFn+TKbGtVg17WZ
         c8hCQg9eSA4eP+yS/lqwIyOMqPEZkt4jfSSjjOGa3jbkaQ4/Ih1L+PNeM+YJA48hQGFI
         nC5OhlmE0dkl1uN0m8a0mh2KUcuDdPWAwu/21mgqWpWNiVgKNcjYXjiNpmeR8lV2giew
         QGyqsmbA3KHN7Ppx63Cw/VUVISlhZwq7w16py8n+mztr0+asB+FxBbcFQjBGkh3jIBtQ
         /GKaJov9ZT+AZdyiJsYWPALksWrA0+gSp/IeHWAeDk/9p7LhlqvGyRo6j3SxJ9MQMVBM
         KlcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754410442; x=1755015242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ut5lsjSSswYnbLzk6rrdmu5+CeAKFhijQRi1rB1wfMg=;
        b=fJnI/7tVM72yK0WqiLJ653b9sVBU4K06FDwFW6Y1AUPdljm1jNpuZ/SWjYw4B10htx
         +/1Ni4lAx2G7TM9HNWUHm08X3/8wJEv83ID7HxgYMJxnnJQbNQfXERsTZ8KQKhqyWPsV
         qZZirUu59DIYRYebua4NaEGBDj1Ky1Ck0GLmRtb6jaHlxcIMMpa6qzXdcnM3sBgTXQFw
         SWoSRb9e3yCBPUwS5W+VGXnwPLBsDVc7GlBSsG4po1V6C3EJeejECf6+IkIEm8VsU1mW
         o6LwjJxoH7NWAVtu5tTTx66PGX8fsEzr6/EBNvKeoksMX/b0N9Hawj4VcOZ7/p5OcYz+
         CU6w==
X-Forwarded-Encrypted: i=1; AJvYcCXaD67Luo40bPQz49C6HcAgqwxVCc1RsFF2IbQde4LShakSDhdkjZxLF8Moec43ts5k2ElWTc0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFxzJxB1+1Ym68lg6A7U3DikERfC0lbLxsu1JCKd/opXJJCmvJ
	1fVYaiuALQG6bSJ5myBh4SRUXsRC45I8iSkAVswRhz9dbshFINedvx6Q
X-Gm-Gg: ASbGncv9skRy+/EStX9bEQfoGEHU7V/NBHqi4OnWBk0NJtkaLYwaZx7RoOS2xqV3QuS
	dvpehl3Adrx5/fdP5PoLIxAQB/shgYpLQBrG0arDDF7npI+VwHWOrb5+x4mdwD4iLB2jxzZkIRw
	DADuiyJ3Trw6NlivJWp3tSpOW1IxcUq6OImm+e9KhMfEDWgbpaPmUh/zlBtWpVlyuIG1n1xVMsQ
	4tFeS25IaJRwqVwQqFrH8+yYt1OrlGoiGvFcT17585DX8Ei0oDiJqF3GPXaBHfepMZUgt/nQ2eh
	npWyNZaHbtLw0/J936LPAQNgesw0r2uKrFJNStyUDqKwHlR5lG79lOXu4HM1oJCJGV43v88q/Vr
	VHT5AjO+5zQbNBWx79gvuFP6J2twg+oZvBbHvzkY3MO7OlgS3bQ==
X-Google-Smtp-Source: AGHT+IH0xPAx9h/e+86wx2UChAIDs8RS46jNjVMEpxxiiDlgZAALsSVVnEbgPp+pN/RR7dfa5MNCmA==
X-Received: by 2002:a05:651c:b0f:b0:332:341d:9531 with SMTP id 38308e7fff4ca-3327b9157d5mr10915411fa.12.1754410441379;
        Tue, 05 Aug 2025 09:14:01 -0700 (PDT)
Received: from pc636 (host-95-203-18-142.mobileonline.telia.com. [95.203.18.142])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-33238272ff7sm20616811fa.7.2025.08.05.09.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 09:14:00 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 5 Aug 2025 18:13:56 +0200
To: Mike Rapoport <rppt@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
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
	Kees Cook <kees@kernel.org>, Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
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
Message-ID: <aJItxJNfn8B2JBbn@pc636>
References: <cover.1750274467.git.lorenzo.stoakes@oracle.com>
 <d1588e7bb96d1ea3fe7b9df2c699d5b4592d901d.1750274467.git.lorenzo.stoakes@oracle.com>
 <aIgSpAnU8EaIcqd9@hyeyoo>
 <73764aaa-2186-4c8e-8523-55705018d842@lucifer.local>
 <aIkVRTouPqhcxOes@pc636>
 <69860c97-8a76-4ce5-b1d6-9d7c8370d9cd@lucifer.local>
 <aJCRXVP-ZFEPtl1Y@pc636>
 <aJHQ9XCLtibFjt93@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJHQ9XCLtibFjt93@kernel.org>

On Tue, Aug 05, 2025 at 12:37:57PM +0300, Mike Rapoport wrote:
> On Mon, Aug 04, 2025 at 12:54:21PM +0200, Uladzislau Rezki wrote:
> > Hello, Lorenzo!
> > 
> > > So sorry Ulad, I meant to get back to you on this sooner!
> > > 
> > > On Tue, Jul 29, 2025 at 08:39:01PM +0200, Uladzislau Rezki wrote:
> > > > On Tue, Jul 29, 2025 at 06:25:39AM +0100, Lorenzo Stoakes wrote:
> > > > > Andrew - FYI there's nothing to worry about here, the type remains
> > > > > precisely the same, and I'll send a patch to fix this trivial issue so when
> > > > > later this type changes vmalloc will be uaffected.
> > > > >
> > > > > On Tue, Jul 29, 2025 at 09:15:51AM +0900, Harry Yoo wrote:
> > > > > > [Adding Uladzislau to Cc]
> > > > >
> > > > > Ulad - could we PLEASE get rid of 'vm_flags' in vmalloc? It's the precise
> > > > > same name and (currently) type as vma->vm_flags and is already the source
> > > > > of confusion.
> > > > >
> > > > You mean all "vm_flags" variable names? "vm_struct" has flags as a
> > > > member. So you want:
> > > >
> > > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/execmem.c
> > > > 29:                          pgprot_t pgprot, unsigned long vm_flags)
> > > > 39:             vm_flags |= VM_DEFER_KMEMLEAK;
> > > > 41:     if (vm_flags & VM_ALLOW_HUGE_VMAP)
> > > > 45:                              pgprot, vm_flags, NUMA_NO_NODE,
> > > > 51:                                      pgprot, vm_flags, NUMA_NO_NODE,
> > > > 85:                          pgprot_t pgprot, unsigned long vm_flags)
> > > > 259:    unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
> > > > 266:    p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
> > > > 376:    unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
> > > > 385:            p = execmem_vmalloc(range, size, pgprot, vm_flags);
> > > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/vmalloc.c
> > > > 3853: * @vm_flags:                additional vm area flags (e.g. %VM_NO_GUARD)
> > > > 3875:                   pgprot_t prot, unsigned long vm_flags, int node,
> > > > 3894:   if (vmap_allow_huge && (vm_flags & VM_ALLOW_HUGE_VMAP)) {
> > > > 3912:                             VM_UNINITIALIZED | vm_flags, start, end, node,
> > > > 3977:   if (!(vm_flags & VM_DEFER_KMEMLEAK))
> > > > 4621:   vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
> > > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/execmem.c
> > > > 29:                          pgprot_t pgprot, unsigned long vm_flags)
> > > > 39:             vm_flags |= VM_DEFER_KMEMLEAK;
> > > > 41:     if (vm_flags & VM_ALLOW_HUGE_VMAP)
> > > > 45:                              pgprot, vm_flags, NUMA_NO_NODE,
> > > > 51:                                      pgprot, vm_flags, NUMA_NO_NODE,
> > > > 85:                          pgprot_t pgprot, unsigned long vm_flags)
> > > > 259:    unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
> > > > 266:    p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
> > > > 376:    unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
> > > > 385:            p = execmem_vmalloc(range, size, pgprot, vm_flags);
> > > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags ./include/linux/vmalloc.h
> > > > 172:                    pgprot_t prot, unsigned long vm_flags, int node,
> > > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$
> > > >
> > > > to rename all those "vm_flags" to something, for example, like "flags"?
> > > 
> > > Yeah, sorry I know it's a churny pain, but I think it's such a silly source
> > > of confusion _in general_, not only this series where I made a mistake (of
> > > course entirely my fault but certainly more understandable given the
> > > naming), but in the past I've certainly sat there thinking 'hmmm wait' :)
> > > 
> > > Really I think we should rename 'vm_struct' too, but if that causes _too
> > > much_ churn fair enough.
> 
> Well, it's not that terrible :)
> 
> ~/git/linux$ git grep -w vm_struct | wc -l
> 173
> 
Indeed :)


> > > I think even though it's long-winded, 'vmalloc_flags' would be good, both
> > > in fields and local params as it makes things very very clear.
> > > 
> > > Equally 'vm_struct' -> 'vmalloc_struct' would be a good change.
> 
> Do we really need the _struct suffix?
> How about vmalloc_area?
> 
I think, we should not use vmalloc_ prefix here, because vmalloc
operates within its own range: VMALLOC_START:VMALLOC_END, therefore
it might be confusing also.

others can use another regions. vmap_mapping?

>
> It also seems that struct vmap_area can be made private to mm/.
> 
I agree. Also it can be even moved under vmalloc.c. There is only one
user which needs it globally, it is usercopy.c. It uses find_vmap_area()
which is wrong. See:

<snip>
	if (is_vmalloc_addr(ptr) && !pagefault_disabled()) {
		struct vmap_area *area = find_vmap_area(addr);

		if (!area)
			usercopy_abort("vmalloc", "no area", to_user, 0, n);

		if (n > area->va_end - addr) {
			offset = addr - area->va_start;
			usercopy_abort("vmalloc", NULL, to_user, offset, n);
		}
		return;
	}
<snip>

we can add a function which just assign va_start, va_end as input
parameters and use them in the usercopy.c. 

Thanks!

--
Uladzislau Rezki
