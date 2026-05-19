Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0989409132
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 17:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779210010; cv=pass; b=idNIM9gmzNrJPNAVbxLtq9nyT8AyNjoLSnWe3sRGPvWxpdmp6aiogfDLNbgLY6UhRUhFh+SzEbf+ljyjG/URUs0rSTk7AR33ipbuCB/hGvOyOu3Ksi02IlmlS9lRROc58KCVs/r/9D5Fv3+Hsyv9crecjYM3TYPXdZv9G8Fe37Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779210010; c=relaxed/simple;
	bh=CAA/xks5Y5gsSYqPnbDpUtTl6A+TM8EjrXGeuoOa8QY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fRI321/TdSAaDaq2YDE+A5j4tMFHPSgzayeWfvf9EOwVVEDH6bWFTVqMWFJIGISdV/JMS5o+XM3Uq4+At9BDEZ/qf+LPuMMxl3k55/Ako82aOnn1gbZ/d3VHZP9EfFGEQpCL7Z0K+btHTQh7MAcHFJ7xUpNN+4QzHmTHCcC9ud0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kTtIQpzP; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kTtIQpzP"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bd8f9889a8cso299055666b.1
        for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 10:00:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779210002; cv=none;
        d=google.com; s=arc-20240605;
        b=bDScrhn2IbSeWbtboNVD2XI2d8E6qwHm1C+q+nX2+lW7smXuz4tMPQCVFEfGQfxb9Q
         bZJvTz7HM5qexkgK8Swxq3FRX0rWrgbYf4DJzF0CRaLIHrweV/eT9xeCJ2q9jFo9/eja
         grogpQt7Deh6pEeiEE1Gy1tNTkeqy84rnrlsoVU1BiIJENvCANce6Egr/XkqFYL15DsR
         y6ssC97OHsapx2BUmCIjG+DaG5ruSCCnmKI/yLcRZgE/94N8vInNoK7BgaXqvdZl/OQ0
         HhnYRtUHHp7BUff8emm7GeSgcC2cnPCIjDHA7iKkjAZa+fgUaDugqwrkDSKjyuNv/o42
         /RCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pyhG4QIZqICKavDwcU8OoLlp4cF7iJkoZFMHnoscP14=;
        fh=HY0Dre+bCQ+kQF5zxnUr8HKhV/ox3ErWyY7I+sTFdT4=;
        b=XlZgRmvpdXyWNrrf/9w1g51KUVhCiZ6bRt0UXvtybEXH3nqoCqfxkW1AzyKr32BxoL
         lxynGo3FR6gDGh1gDzZ5eBtTCeyJl0QZkybdmOll+7UhoWMeZ2137aBQjsXr7DItggkR
         uSdDuD7jGzHPOMQ14pR68Ld6dxf3SKf5l7ce+IfctlQ+77bqlriqqsYqaDCRDC6Ugfug
         zsv6k8zlAf1tEJou3ickUZII1pIlbHePhiOQrH6HWSwy4/C8xLV1HGyPXsfcZdkxlKsI
         TWGBrR+HnMj4u9Xe4FymgdMizm+CnQs7xw8I8VU/v3Blmlpeqtmm05U2OLEhj5T68rwy
         2RYg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779210002; x=1779814802; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pyhG4QIZqICKavDwcU8OoLlp4cF7iJkoZFMHnoscP14=;
        b=kTtIQpzP5U4xoPjxj67Ys2KbsE3+48kSbpQSk4PNSKsP6diTsL6Dj4W6fbrp956919
         +gI+i8BnhbJn/EkRgwN4Upd7LflQ+YguzOa+HJqX2Xsgh+gSKvQtov+i4FHkOENX7r3u
         tIu9xHgcLSDJmAR07H/NvyaE3xsPVkVU8S9hTZ0PUZ+ie8lAHMsvb9JbnncUi1khcYUT
         wvGhFPkmiVgABiWzeB0p07zOEWfUMlNK/itSluJY4qnVGy89Isy3ORL2KBrH3tSBuLk3
         QPL0WMcI3HQWFYeqsK6/yTRHus6I76T1gAo45gjoDlTVygnxNQo06abhc7AvXnazqIZv
         AiWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779210002; x=1779814802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pyhG4QIZqICKavDwcU8OoLlp4cF7iJkoZFMHnoscP14=;
        b=V1cTW5C7uxg3van2Xtjr8WBIYwQt2kG6XHq59P/ETQrUfyKBtrFcFHiNozHfuvmZy9
         6Wh+MeLccd/187J+f7FC+yklm+Ev9Y4qnfJVTZEtMv4gcpqlnr0jQr2CN4zKE7Bm2yYL
         8HBifmwxYWw4rAlagIrxxjZ+of6hyfLtktFUcrpp/nyF19a03pK7XSQxGbzJfjP/d77u
         iCdXAAgtXdgGeTSaeENYdCLwwxZ2v2Bv4oeI6LPOaoEZ/+Gs7PxJwcj/PtVusqPp5/2C
         LxKqb4yfTHxbGP7YCmDAe6qD7hnq/miocS4/MEqusz5xLXzQxOz22akMB7CIkm9l4fxA
         z/0w==
X-Forwarded-Encrypted: i=1; AFNElJ9Hh5b55J2isPuELWLZLdtAuA5okm8iDIU8/M0jFfoJAKqlwatntWF7TWX0SZqmQ2scvsJPLY0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5nUfOVSvf3dYccLDbW9CAgqKPJKedBFwaQY8yjux1pDS2yYtj
	iITSl4KuA5SYsJgHbdLbiQ22kPnXhgy1Sa2eMNIGOUTEIepEpWbjqoWuClTzn+ZhK3PA+ZFwVGi
	FZy1WWPaPEWNcpd6+vyBp+hbbveKjMjo=
X-Gm-Gg: Acq92OGav8/8fs0FKl75eVuzaPe0OoZ4nzzTzqmOh1nxSr5tKTR8EB2dHeEYt/WFNvM
	bbbdX+2Xnh3RmhYkw/VnrIvDvzYFpwpqhw/pgrI7o9zFyA3XrLlzrmnei2EBWt2oT5dFOwR6qWh
	DQnCcUbbAa1Lvzegk+Y31tP7/kPVtnpQri973a49Fnm0l0u52QyJfiteCBF1s7r0Z9qvR0Fg/9O
	Id1OGUT+2zVj92XhM3EpK6RljsgJSbApDOabRwjVk7A5akMO2WVKX1MfeABs00aIoAz2pNhwC9r
	ORcTYOZRaXeWUvHGJe32SPK2f9hloNZxY4qszj3G6LVtb8W5l60=
X-Received: by 2002:a17:906:f59b:b0:bd6:4d6d:e02c with SMTP id
 a640c23a62f3a-bd64d6de820mr859954566b.2.1779210001640; Tue, 19 May 2026
 10:00:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260519151008.1399226-1-qkrwngud825@gmail.com>
 <5d00b63c-1802-450f-8e54-8da6c0aeedc2@intel.com> <CAD14+f2p7D6eco+-O0X6zWwi-XaxGLs0nQKDAC8eVWhQmB1VhA@mail.gmail.com>
 <e38e5fd0-db57-417b-a2d1-0521333ae7cb@intel.com>
In-Reply-To: <e38e5fd0-db57-417b-a2d1-0521333ae7cb@intel.com>
From: Juhyung Park <qkrwngud825@gmail.com>
Date: Wed, 20 May 2026 01:59:49 +0900
X-Gm-Features: AVHnY4K5SYQOv34TwiBv3zKFQF1M6Tyl-TeVLU2eS0aTWiFY5udiXMkdBY5RsDs
Message-ID: <CAD14+f3sohXj9SKEkRXGK_Mpbp73R5az-tsiHnHkj0poBHwpvw@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-mm@kvack.org, stable@vger.kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dan Williams <djbw@kernel.org>, Dave Jiang <dave.jiang@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org, 
	nvdimm@lists.linux.dev, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 1:41=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 5/19/26 09:27, Juhyung Park wrote:
> > Hi Dave,
> >
> > On Wed, May 20, 2026 at 1:02=E2=80=AFAM Dave Hansen <dave.hansen@intel.=
com> wrote:
> >>
> >> On 5/19/26 08:10, Juhyung Park wrote:
> >>>  #endif
> >>>       } else {
> >>> -             pagetable_free(page_ptdesc(page));
> >>> +             /*
> >>> +              * Use __free_pages() to honor @order: vmemmap PMD leav=
es
> >>> +              * freed here are not compound pages, so pagetable_free=
()
> >>> +              * would lose leak 511 of 512 pages per 2 MB chunk.
> >>> +              */
> >>> +             __free_pages(page, order);
> >>>       }
> >>>  }
> >>
> >> I find myself really wondering how much of this came from a human and
> >> how much from the LLM. Could you share that with us?
> >
> > Not my first kernel contribution, just so you know. (first in mm tho)
> >
> > I asked Claude to write both the commit body and comment and it was
> > too verbose. I manually trimmed it down.
> > Sorry if it still sounds too LLM-ish.
>
> Yeah, it still sounded really LLM-ish to me. Still rather chatty.
>
> > This was tested on a VM with virtualized CXL device and toggling it
> > back and forth was visibly causing leaks. kmemleak was unable to catch
> > this (rightfully so), so I skeptically asked Claude to see if it can
> > figure it out while pwd was the kernel source the VM was running.
> > "Access the VM at "ssh -p2223 root@192.168.0.185". There's a memory
> > leak whenever CXL memory switches modes via: daxctl reconfigure-device
> > --mode=3Dsystem-ram dax0.0 --force, daxctl reconfigure-device
> > --mode=3Ddevdax dax0.0 --force. Figure out why. If you need to reboot
> > the VM, do not do it yourself and ask me."
> >
> > It did in 6 minutes and it basically told me to revert bf9e4e30f353. I
> > was very skeptical and reviewed manually (with my short knowledge of
> > mm) why this would be a correct fix.
>
> Neato.
>
> >> We're trying to get _away_ from using the 'struct page' APIs on page
> >> tables. This goes backwards. Worst case, do:
> >>
> >>         /* vmemmap PMD leaves are not compound pages */
> >>         for (i =3D 0; i < 1<<order; i++)
> >>                 pagetable_free(page_ptdesc(&page[i]));
> >>
> >> Right?
> >
> > Shouldn't I worry about the loop overhead? With order =3D=3D 9, that's =
512
> > iterations. That's compounded to O(N) when the entire memory size is
> > in consideration.
>
> Is it optimal? No.
>
> Will anybody ever notice? Also no.
>
> Will anybody ever care? No sir.

Just spun a test with that loop. It doesn't fix the leak.

I hate to be the guy that copy-pastas LLM but this is outside my
knowledge of mm. Claude suggests:
"Each pagetable_free() on the tails is a no-op: When
alloc_pages_node(node, gfp, order=3D9) returns without __GFP_COMP, the
buddy allocator only sets _refcount =3D 1 on the head page. The other
511 pages (page[1] =E2=80=A6 page[511]) have _refcount =3D 0. There's no
compound metadata, so they aren't "tails" in the folio sense either =E2=80=
=94
they're just contiguous pages whose refcounts the allocator never
touched."

Any ideas?

Thanks.

>
> Can you measure the difference? I'd wager a beer: No again.
>
> Even if someone manages to notice, then you have a clear path to fix it
> *right*: fix the ptdesc data structure to represent high-order allocation=
s.
