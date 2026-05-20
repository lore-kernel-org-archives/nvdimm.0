Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEE43A3826
	for <nvdimm@lists.linux.dev>; Wed, 20 May 2026 10:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779273223; cv=pass; b=CR4Iz8l3b/Z+ZExNMtISsnwv7LXnIcZLGecrj0PPuJ2r75z2CKr3nnJcxok1MPY7+DkXOBKpWHVeyxG0vioIftAPaeYvaXWLbFeypLB1103ygVRIZ4lKHUYJa/QkKaqPYdQj+tlj0/rjY1Dy7hNok1oYw8ONDRxaTAJC+ga0QYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779273223; c=relaxed/simple;
	bh=I3nCSO8EnQlbzVzYsHNKe6zQ9gVE/7aRqrfkKO0oNLY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JBQB60zIonWWIkppR5abfCp0K2V1RaBq1cmY0ekq13B/oj2qFVzwlWGFkKYH8jeJZwFU2p3J7yrMbi3TbJx11wiVokknTbKJ3IBH5dkUrMDAeSOYzPVW0A5oFKVui8Ff83qgPEc9GW4g9RARNfdBWpvpIrwwH28UfaGJ9RlWzAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dvblKMrG; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dvblKMrG"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-67b32c695efso11151705a12.1
        for <nvdimm@lists.linux.dev>; Wed, 20 May 2026 03:33:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779273217; cv=none;
        d=google.com; s=arc-20240605;
        b=PgdG9IethflUVGzJMLmt5iYavKZTh4Sac/F/IqMXdqzYCa3/Zlj7LqZSU8gY4lyNMe
         HGV94O0tYkdbWvRroyLSVesh7tqY8ZBAboKZCM7NRSi/QXJhcRsaeRpgiTnmh7+Hhi3D
         TCyCuvJ1L+X6UprMO2OH/yHmrJooJoNv5C3E98H9Ajr35RAzFS7vmeZariWDuvj7Ujs4
         b86uCzg21n1TOmV+XqI6JAf5cPZUtANGs7LM/VHHoLM6sxw+0drzrBli8ffQsgEMrQyu
         8w31pTwfhgreMG9n/KGkque83CZqKjtj12Z5KaucCPt34fvAzE6Em7LNqWlG2dtep0xw
         IO3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CuNkcUrfA5La6Ov2pSAQWUelqrEhmV3emRmHUdz7AgI=;
        fh=uxL4RMRHomEptAPehzx/oBFv1q/vUtyvqRv3f8WQqPk=;
        b=i0chqu6390nlRYlAsMpGsleoS3i4xf7Xfjf7pzoGXhLzM/SksDnOhOTTkfE1VO0Kbl
         2bjuXchJ1+iRstoAJNiakw8to+e+iIYTvg1BTCa4V3Zao3G5dz8AVgwv04ZyM1vgsRjb
         FyTG68hGZIOKVUEgumdkBuZsN9c2cD2UKmaDJdEGHmeW40iNpnfXQ4YUo9+pca5Zd/DS
         trx3S6WlFfgnDiNvboAuQ76EV1/yxk0ElV6gKS789W0a5vdY32RSsDeXLeU/a1RFXY7f
         +qjbVCwDWFbB8JJRg7mENHRgDNpwgeBuT552L5Yimd+mkyg9cUqGQAsDzVpdwpdeHYYV
         o0qw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779273217; x=1779878017; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CuNkcUrfA5La6Ov2pSAQWUelqrEhmV3emRmHUdz7AgI=;
        b=dvblKMrGZW6FYo0x/r6+IhqhCAnASMHNQuoPtO0SuDFHW8IyHG58lsqWmgWL01s7VQ
         ZQRZP7aOaMyONXtsdc+6MEhqUC+HRHuOd9YoKl4uBktMuhWJR7XmgAXZY46IVhLjoozv
         4xowTw3MnxB1e7RfxXce376ki+VARxl7wXgb6HLJRWu3GR7eQ5yEBkruxeuV2tjnsbCn
         XLR94B3fAb+/8q3fzzxbKHnrl96C57zam86WBXCgdrp+rKCPfRmds6XQx3F0kggG75zs
         /N0oUY0RIi/R+HqKUhTMhF9GATuziDmRLHi8y08ClWE3GexpnlAI0289tCLuk3zB1Csp
         0ARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779273217; x=1779878017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CuNkcUrfA5La6Ov2pSAQWUelqrEhmV3emRmHUdz7AgI=;
        b=rYS37eTEb42JMU6ijxvJDBf74FJHLV7QTDNF0bD8XT/tRwmzfxE0i9vBZy6jFb320g
         nDqJWGjb0fV4KV4IhOTq7ubUOhEgA59XJTrmyYzFAtnJPbJVhlqDzOFxvulym6UIsSrX
         rtNzUAzcWUhGdiShhyxb8rb3eLGuYdMDxvNZSsuJhkv3nZLuwMCd7a4AyP7tFHDzMhU8
         IzIuiq4HYZ8EOxLXLbulDOhdZqNSyGan+e8O4N1NFNeJvBJgx5wtFinKE48qvTZcDGnK
         JCMyEh7YWQVYJScAlc1aPvwaxFGroKyLM46XvLyWoacGay3ISosC6pN1AIiiXUylsVFw
         PpEA==
X-Forwarded-Encrypted: i=1; AFNElJ94+oZZkAia32HwCBQAzGhkEc9RXiu7kCjFADwDbop5l3NJSPFLPrjFTt0ni+uH4f/RGDDku/I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/E4K7HYzuw6wEhHJU+WhLyIwHUxhkighoJSMD2ODZee9QjiQs
	Oka48mI3eOizoHEv0Z1lDDKj+dFWD3jWa7cYehBPcmQ0npbEYlHZNgT9NGVqICLv+LW+Yazi3+W
	SHdLz1n8JN7cmeWEDLdXZJxfW94gfACY=
X-Gm-Gg: Acq92OGZnIFpiA0Bv9NXBycij2yqmKfpK95lQVDYh5IN443JCRwDDHY6PALjfgmBCOZ
	txcIRO8E0JtDxjJ0rAn4cUkRysnxEFhzRz7W9VAqSp5JQ2L0pTHnSYMMVrOd+mv9toro2Vl4cId
	Amz6e/dFc+RrxVdFMDe55CJgtotK/5j+dqm1Vdn80l0pOin3svW15Cs2slJbQC9jZzQnzJCNbol
	qC1Th+tG3R9pWVcNcriBXCTTaYextX4UjGvDhkp03uw80dciP9yAwSAhH4ZvnyVdD7/zwYBqngL
	wqh9YmLVenGs1NKtCA8gEkj3/dQz0a/oWVSi3Vss
X-Received: by 2002:a17:906:4fc4:b0:bcf:6ba7:4bf8 with SMTP id
 a640c23a62f3a-bd4f34bd118mr1396926266b.26.1779273217009; Wed, 20 May 2026
 03:33:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260519151008.1399226-1-qkrwngud825@gmail.com> <e9a08bed-3d5f-4606-8d17-80a16a4c82f1@kernel.org>
In-Reply-To: <e9a08bed-3d5f-4606-8d17-80a16a4c82f1@kernel.org>
From: Juhyung Park <qkrwngud825@gmail.com>
Date: Wed, 20 May 2026 19:33:24 +0900
X-Gm-Features: AVHnY4IeL4rkcfGD6vJpoWHJPVsVY0mlOdz31w-7ieRtyfoF4Q7rZALT5Z8EpPQ
Message-ID: <CAD14+f316+wMZNm_sJF6ULRDUD9EbkdecdDwhGQKcsu70Bdp0w@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, stable@vger.kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dan Williams <djbw@kernel.org>, Dave Jiang <dave.jiang@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Neat. Any sign of it getting merged?

Thanks.


On Wed, May 20, 2026 at 2:24=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 5/19/26 17:10, Juhyung Park wrote:
> > free_pagetable() is called via free_hugepage_table() with
> > get_order(PMD_SIZE) =3D 9 to free the 2 MB vmemmap PMD leaves that back
> > struct page arrays on x86_64. After commit bf9e4e30f353 ("x86/mm: use
> > pagetable_free()"), it goes through pagetable_free() instead of
> > __free_pages(), and pagetable_free() ultimately calls
> > __free_pages(page, compound_order()) which ignores the explicit order
> > argument and infers it from the page's compound metadata.
> >
> > The vmemmap PMD chunks are allocated by vmemmap_alloc_block() using
> > alloc_pages_node() without __GFP_COMP, so PG_head is not set and
> > compound_order() returns 0. Only the first of 512 pages of each PMD
> > chunk is returned to the buddy allocator on hot-remove; the remaining
> > 511 pages stay allocated and become unreachable. Generalized: roughly
> > 16 MB leaked per GB of hot-removed memory per cycle.
> >
> > The leak affects every memory hot-remove path on x86_64 when
> > memmap_on_memory=3DN (the default), including dax_kmem, virtio-mem,
> > balloon drivers, ACPI memory hotplug, and direct sysfs offline+remove.
> > memmap_on_memory=3DY avoids it because free_hugepage_table() then takes
> > the altmap branch and does not call free_pagetable().
> >
> > Reproduced with CXL memory toggled through DAX in a loop:
> >
> >   daxctl reconfigure-device --mode=3Dsystem-ram dax0.0 --force
> >   daxctl reconfigure-device --mode=3Ddevdax    dax0.0 --force
> >
> > Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
> > Cc: stable@vger.kernel.org
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Andy Lutomirski <luto@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@kernel.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Dan Williams <djbw@kernel.org>
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Cc: linux-cxl@vger.kernel.org
> > Cc: nvdimm@lists.linux.dev
> > Assisted-by: Claude:claude-opus-4-7
> > Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
> > ---
> >  arch/x86/mm/init_64.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> > index df2261fa4f98..a2301bddb647 100644
> > --- a/arch/x86/mm/init_64.c
> > +++ b/arch/x86/mm/init_64.c
> > @@ -1024,7 +1024,12 @@ static void __meminit free_pagetable(struct page=
 *page, int order)
> >               free_reserved_pages(page, nr_pages);
> >  #endif
> >       } else {
> > -             pagetable_free(page_ptdesc(page));
> > +             /*
> > +              * Use __free_pages() to honor @order: vmemmap PMD leaves
> > +              * freed here are not compound pages, so pagetable_free()
> > +              * would lose leak 511 of 512 pages per 2 MB chunk.
> > +              */
> > +             __free_pages(page, order);
> >       }
> >  }
> >
>
> I sent a proper fix for this already:
>
> https://lore.kernel.org/all/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org=
/
>
> --
> Cheers,
>
> David
