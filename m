Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE182E03F4
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 12:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751546068; cv=none; b=o4Lg8Jt5IkZdLhCAqA3+9JODSrIj0Aom2oFeYw+qawJAybrMNT4FdrLqJaAzE/IIw7D87okY954n/fSIlhW05jArc9lsNTOkosEOf1ks3L95DloAAiI2mU0yjRdUIu7YiDw9yrNBrgOm0SEWqKSD2+sKTKgYtvICvOZfRiNuLeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751546068; c=relaxed/simple;
	bh=Pj8Cdq0sivdNx0WCtdyO0zBAKWGSVYHVKqj2V5LSI/g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n4KmnmCrT+LCX5grvm9aSTmHe/pTrJp4ogk5DBidW2Sn7soDG8JXiKsjYIPnIL0hC+SYv3DDDdTyJ8iZr7AId81lNe5g3Z6umVJYjp5QJQB6doUHkXpiyeB1P/nfV1U2Mw84otBV5tUmZgzZNU2tjwV3uJW8vLGKkeJ4Uewdzpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jPmmvoE0; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jPmmvoE0"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6f8aa9e6ffdso88935346d6.3
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 05:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751546065; x=1752150865; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pj8Cdq0sivdNx0WCtdyO0zBAKWGSVYHVKqj2V5LSI/g=;
        b=jPmmvoE0EBWSf/JKwTNpP9gg97cHEzUl9uP852vQ76MbWfCWRV41Rjb78Q5ifla0sj
         vtYD05YbCQ7Rijnmv5dj/R18Mo67MqA1waqt5tIAeTLhJCSRyHCfprHDQQ5GLdaO9UHQ
         o/Tzgjs7E8uwFnL7vdwsGWumjVcqfLGmz5arHPjRyjt1jzkw9KHoCB01qIIPZ6i60bTc
         NB19K1N1fb0m8dmT+xhZT1GbbDl3wnODppsWbO1XX2eABjuIXQzv6RoPtGBxGLgxieda
         UDONqcmopgvkki7XJRl30udCQSi94u0B6HI6Jjb+j94ZdQmusi3nFMRB+YGATGeTAzlR
         aaUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751546065; x=1752150865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pj8Cdq0sivdNx0WCtdyO0zBAKWGSVYHVKqj2V5LSI/g=;
        b=mQgEIU70XS21P5ax6EI283oo4A1y+fZ4r7H4kTTXTuPSnAL+UBS5psZiyeIrTj5uQY
         +rUzsil/P6OpS/7OsB7fz+MEulvy3nj9WtD5RW7s/bfVHivF/AuJeHVLXOUjUCJSCF5u
         yN2HK7W+kpqnEjPnNevLMd5x215cTEHyHOeilVE70/QsyiYJkURsCU7qIAbW469ntXuU
         +p9rn68ZA6Jwyigxb0XIg1CmLrdXniZtjg0lSGYlBrUpSnhLlPG1PMGoldywH3b1D01q
         IgvOXgqj65KuNQAX3ghtUID66xihV8g+cfD9OF1HAFmGlfASzSzcl4OFGx4Ijn3zP75P
         M5Gw==
X-Forwarded-Encrypted: i=1; AJvYcCWlMP4wKmET0xZb3++ifUGUnad6q7IdD/1n4x9ROtWCBMk0xvUmzQ6Ael+gccv4/G9mfRv/oMc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzepLh6zxqX43FWtGaF/OJMkrMxKFDhE6CMSNcX3/fzLDerpLqK
	j7iZmpsynLDJzpSyXvqtp4avWwMoEgJLnRQTtzUuOV/lVNS0w70SHODPTpTcslEm0krPZvuwvbS
	rcBIyRDEHUBR+71p7LxPmRetCmCC/jYo=
X-Gm-Gg: ASbGncvjM8hpXKNkso5ZUHvmydiEaVozW0rgE9rz1RLhB+oMC0o5HmULZNhM2VMT5Ce
	kdaV45n7fQGlnf0vcvhsJnrIKY/WjxY1Bbn4l3ZGxg7l1qKCJW1NGsYziqO3P7JGRIyJFhVqzqJ
	9CnCEos7Md5gK7yxbGG1JZkEeqk5d/rqF4ToN2ssXsg/NrKmPW9kngBeFMhw==
X-Google-Smtp-Source: AGHT+IGbPYrN54dYrzHXjzvtPMziKIP2dK+ZFdrAB9bFhOzkRz3Vofn+4fvXYD/kf1p6asLy/7oo4AMZVhDjgjTRKGE=
X-Received: by 2002:ad4:5cc9:0:b0:700:bc46:5355 with SMTP id
 6a1803df08f44-702bcc507bdmr58755466d6.28.1751546065169; Thu, 03 Jul 2025
 05:34:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250617154345.2494405-1-david@redhat.com> <20250617154345.2494405-2-david@redhat.com>
 <aFVZCvOpIpBGAf9w@localhost.localdomain> <c88c29d2-d887-4c5a-8b4e-0cf30e71d596@redhat.com>
In-Reply-To: <c88c29d2-d887-4c5a-8b4e-0cf30e71d596@redhat.com>
From: Lance Yang <ioworker0@gmail.com>
Date: Thu, 3 Jul 2025 20:34:11 +0800
X-Gm-Features: Ac12FXwlisPZPIPS0YTxEVYIGMNVB3un9rKexLCpMfXXShG5J5pRHWps4sQZYSw
Message-ID: <CABzRoyZtxBgJUZK4p0V1sPAqbNr=6S-aE1S68u8tKo=cZ2ELSw@mail.gmail.com>
Subject: Re: [PATCH RFC 01/14] mm/memory: drop highest_memmap_pfn sanity check
 in vm_normal_page()
To: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Dan Williams <dan.j.williams@intel.com>, 
	Alistair Popple <apopple@nvidia.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2025 at 10:04=E2=80=AFPM David Hildenbrand <david@redhat.co=
m> wrote:
>
> On 20.06.25 14:50, Oscar Salvador wrote:
> > On Tue, Jun 17, 2025 at 05:43:32PM +0200, David Hildenbrand wrote:
> >> In 2009, we converted a VM_BUG_ON(!pfn_valid(pfn)) to the current
> >> highest_memmap_pfn sanity check in commit 22b31eec63e5 ("badpage:
> >> vm_normal_page use print_bad_pte"), because highest_memmap_pfn was
> >> readily available.
> >>
> >> Nowadays, this is the last remaining highest_memmap_pfn user, and this
> >> sanity check is not really triggering ... frequently.
> >>
> >> Let's convert it to VM_WARN_ON_ONCE(!pfn_valid(pfn)), so we can
> >> simplify and get rid of highest_memmap_pfn. Checking for
> >> pfn_to_online_page() might be even better, but it would not handle
> >> ZONE_DEVICE properly.
> >>
> >> Do the same in vm_normal_page_pmd(), where we don't even report a
> >> problem at all ...
> >>
> >> What might be better in the future is having a runtime option like
> >> page-table-check to enable such checks dynamically on-demand. Somethin=
g
> >> for the future.
> >>
> >> Signed-off-by: David Hildenbrand <david@redhat.com>
> >
>
> Hi Oscar,
>
> > I'm confused, I'm missing something here.
> > Before this change we would return NULL if e.g: pfn > highest_memmap_pf=
n, but
> > now we just print the warning and call pfn_to_page() anyway.
> > AFAIK, pfn_to_page() doesn't return NULL?
>
> You're missing that vm_normal_page_pmd() was created as a copy from
> vm_normal_page() [history of the sanity check above], but as we don't
> have (and shouldn't have ...) print_bad_pmd(), we made the code look
> like this would be something that can just happen.
>
> "
> Do the same in vm_normal_page_pmd(), where we don't even report a
> problem at all ...
> "
>
> So we made something that should never happen a runtime sanity check
> without ever reporting a problem ...

IIUC, the reasoning is that because this case should never happen, we can
change the behavior from returning NULL to a "warn and continue" model?

Thanks,
Lance
