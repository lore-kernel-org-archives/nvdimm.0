Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062A2225404
	for <nvdimm@lists.linux.dev>; Tue,  8 Jul 2025 02:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751943190; cv=none; b=cVgYzl5TUT6Rf5kRCouWV8o1yGc0Z1/pt+Y9cONg9XYAzWmrm14SMY2nkt0knCnvgGdzK6IksBuK8aeehno5I+X9HpqBZin2hlwfabENl6yPYRPP3nKBnDZ9GLnP8FM8INGEtlbvi43ZDYbdXc+WjUrCXVlG2EDDgEz8tLmKqUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751943190; c=relaxed/simple;
	bh=XF/uGrtSptwtHtREcaHsc5q1URje318fjfLC475Pkuk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=La7U0XoNdz401MRANWTsaxj4LORaUXiVgHJ8plOIYEftsqrYVfr2gRquOQ+EPocG9G5aRBBQcb+twNtuYylEAJcNpH1m23TKFsjdg/bzG0UJlQhm8uXACa/DKvNI+CzWqTCo90NN0AeTA8Mc+GWLyxdto9kAJQzJuv3vZTy+bg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fjp9jTz7; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fjp9jTz7"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-717a2ef8943so902207b3.1
        for <nvdimm@lists.linux.dev>; Mon, 07 Jul 2025 19:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751943188; x=1752547988; darn=lists.linux.dev;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/zGCQGxHrSRe/NxvAWIAsgtbup/awoRMVdcTUBJfyTs=;
        b=fjp9jTz7umdPnUbi5CTqRkvE4epAeFZt+ThFBuDDfA6COETQh0n7fUlXNHIVpXRbi2
         52BNY2WRZuaZMToXsN8WZ706OragRXiKRKQ6wySj27u6unjr1ZekuB9fVdR1aMKsizeb
         eDZrzT2tDJY1PwgKPJptg5QQBOMSwDHWRNwKRM/PTOtfd/55pZNmCuIBlWsNcs8xZEGJ
         BWi0jwJozGumktJgEVWtHDoYbDZGRyWrftYSMnffsZ94kuUNrhBkdpNvDPYhIoaFY408
         5TaMogoAZ3Ybg++JaCwjV44Umfb8LsbXxdVHTDBciihwzIud9EAGcaqC2A42Y7vWM+n8
         DiGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751943188; x=1752547988;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/zGCQGxHrSRe/NxvAWIAsgtbup/awoRMVdcTUBJfyTs=;
        b=ZOyRnpF6m2yaFR/hECT6wTFFkWtmsakCk6Ckpfff2slPbgrM+dL7vfxOFuI4srVps8
         t3iosEyIGN7kGAE8HWHBavw73oDuJ/LnAU8ccOftWquzDgbT1IJwvxF0h2cu96L5gEjO
         /Ev+OkDl4mhyQ2flw/5ROt+TChmDSI8vwXhXh/IDgeEYRMBVnrh1Kc80ch8iiMPbk5Ko
         knvtIrFm7M482ph1MBrKxuWtyV9LAW7NFfIwsCfP0Oyi7sA/kVYA5kL7vuLqWouIl8OI
         HiEe16eNoCPZ+sNRFCA2a6rkwHNCvTjrBvJkScRxyGcnywgS6R26Ep7VxUSdy6nA1WWh
         SFIw==
X-Forwarded-Encrypted: i=1; AJvYcCVFKig48Kk2PpZ1BeDwW46vjMUGvOxABQOXZNKAVUqX/esI2kvKf11c50xy02DmuBuCAwh6Pck=@lists.linux.dev
X-Gm-Message-State: AOJu0YxY0CRxuugahnWzE1lyQhIqfbX5YzzvZ45nwAh1ddjrU9pfFcjt
	/eGjd8Zauw4CbZ0bmBISLWoN8LfTd2b2uxMsosmDWhXTj83aOMjKD72Oxl67dh4T9A==
X-Gm-Gg: ASbGnctKo0wyxpTvRRaPIcrEtDh+GlNphrZh961nVuX/YlC+/KrI3k7mQ1SX6hXnIXf
	w8nKTFipp2cfuXQBvDG2At59p1fc57FAsZ2hetyRRrvYoE+PtHnZ7peEjKkB9gpxKaWJS4CD40q
	SLguJNUaDBAeg1Wc6dLBpflRkS/V6AvDIE/hoQqOGc8nS+e/7q5S7ETySCeH3pPBwfohYNw8sWF
	f/6zqcy8wVloSiSobLroE4+C5pv1rbbXkFa4OvXCRFBBoSH6GFjV4RNaixY6PvooBetBvi/J9er
	c5WWvcUwKHfdzuIBVrNCaD/ZHfEqKwfGx8cn420ER/G7fgfuLWiLZ9cIfJW85lQNmFW/1c6DQpD
	GBb7djfm/skX6Xu+wQsQxyVxjTH/EpqcVWOSJjpuIiKhOuS8=
X-Google-Smtp-Source: AGHT+IFGk1zw6u42yZgVl3xmkGAoYOyMoRKxLmKRqsd/hjEURFvgk/4mOy+h8KG+4313YBELzU59vA==
X-Received: by 2002:a05:690c:62c6:b0:716:69e0:bb85 with SMTP id 00721157ae682-717a036f27fmr14923907b3.18.1751943187668;
        Mon, 07 Jul 2025 19:53:07 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71665ae2c29sm19151417b3.78.2025.07.07.19.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 19:53:06 -0700 (PDT)
Date: Mon, 7 Jul 2025 19:52:51 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: David Hildenbrand <david@redhat.com>
cc: Hugh Dickins <hughd@google.com>, Lance Yang <lance.yang@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, linux-kernel@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev, 
    Andrew Morton <akpm@linux-foundation.org>, Juergen Gross <jgross@suse.com>, 
    Stefano Stabellini <sstabellini@kernel.org>, 
    Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
    Dan Williams <dan.j.williams@intel.com>, 
    Alistair Popple <apopple@nvidia.com>, Matthew Wilcox <willy@infradead.org>, 
    Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
    Christian Brauner <brauner@kernel.org>, Zi Yan <ziy@nvidia.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
    Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
    Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
    Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
    Lance Yang <ioworker0@gmail.com>
Subject: Re: [PATCH RFC 01/14] mm/memory: drop highest_memmap_pfn sanity
 check in vm_normal_page()
In-Reply-To: <36dd6b12-f683-48a2-8b9c-c8cd0949dfdc@redhat.com>
Message-ID: <0b1cb496-4e50-252e-5bcf-74a89a78a8c0@google.com>
References: <20250617154345.2494405-1-david@redhat.com> <20250617154345.2494405-2-david@redhat.com> <aFVZCvOpIpBGAf9w@localhost.localdomain> <c88c29d2-d887-4c5a-8b4e-0cf30e71d596@redhat.com> <CABzRoyZtxBgJUZK4p0V1sPAqbNr=6S-aE1S68u8tKo=cZ2ELSw@mail.gmail.com>
 <5e5e8d79-61b1-465d-ab5a-4fa82d401215@redhat.com> <aa977869-f93f-4c2b-a189-f90e2d3bc7da@linux.dev> <b6d79033-b887-4ce7-b8f2-564cad7ec535@redhat.com> <b0984e6e-eabd-ed71-63c3-4c4d362553e8@google.com> <36dd6b12-f683-48a2-8b9c-c8cd0949dfdc@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-475110467-1751943186=:6773"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-475110467-1751943186=:6773
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 7 Jul 2025, David Hildenbrand wrote:
> On 07.07.25 08:31, Hugh Dickins wrote:
> > On Fri, 4 Jul 2025, David Hildenbrand wrote:
> >> On 03.07.25 16:44, Lance Yang wrote:
> >>> On 2025/7/3 20:39, David Hildenbrand wrote:
> >>>> On 03.07.25 14:34, Lance Yang wrote:
> >>>>> On Mon, Jun 23, 2025 at 10:04=E2=80=AFPM David Hildenbrand <david@r=
edhat.com>
> >>>>> wrote:
> >>>>>>
> >>>>>> On 20.06.25 14:50, Oscar Salvador wrote:
> >>>>>>> On Tue, Jun 17, 2025 at 05:43:32PM +0200, David Hildenbrand wrote=
:
> >>>>>>>> In 2009, we converted a VM_BUG_ON(!pfn_valid(pfn)) to the curren=
t
> >>>>>>>> highest_memmap_pfn sanity check in commit 22b31eec63e5 ("badpage=
:
> >>>>>>>> vm_normal_page use print_bad_pte"), because highest_memmap_pfn w=
as
> >>>>>>>> readily available.

highest_memmap_pfn was introduced by that commit for this purpose.

> >>>>>>>>
> >>>>>>>> Nowadays, this is the last remaining highest_memmap_pfn user, an=
d
> >>>>>>>> this
> >>>>>>>> sanity check is not really triggering ... frequently.
> >>>>>>>>
> >>>>>>>> Let's convert it to VM_WARN_ON_ONCE(!pfn_valid(pfn)), so we can
> >>>>>>>> simplify and get rid of highest_memmap_pfn. Checking for
> >>>>>>>> pfn_to_online_page() might be even better, but it would not hand=
le
> >>>>>>>> ZONE_DEVICE properly.
> >>>>>>>>
> >>>>>>>> Do the same in vm_normal_page_pmd(), where we don't even report =
a
> >>>>>>>> problem at all ...
> >>>>>>>>
> >>>>>>>> What might be better in the future is having a runtime option li=
ke
> >>>>>>>> page-table-check to enable such checks dynamically on-demand.
> >>>>>>>> Something
> >>>>>>>> for the future.
> >>>>>>>>
> >>>>>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
> >=20
> > The author of 22b31eec63e5 thinks this is not at all an improvement.
> > Of course the condition is not triggering frequently, of course it
> > should not happen: but it does happen, and it still seems worthwhile
> > to catch it in production with a "Bad page map" than to let it run on
> > to whatever kind of crash it hits instead.
>=20
> Well, obviously I don't agree and was waiting for having this discussion =
:)
>=20
> We catch corruption in a handful of PTE bits, and that's about it. You ne=
ither
> detect corruption of flags nor of PFN bits that result in another valid P=
FN.

Of course it's limited in what it can catch (and won't even get called
if the present bit was not set - a more complete patch might unify with
those various "Bad swap" messages). Of course. But it's still useful for
stopping pfn_to_page() veering off the end of the memmap[] (in some configs=
).
And it's still useful for printing out a series of "Bad page map" messages
when the page table is corrupted: from which a picture can sometimes be
built up (isolated instance may just be a bitflip; series of them can
sometimes show e.g. ascii text, occasionally helpful for debugging).

>=20
> Corruption of the "special" bit might be fun.
>=20
> When I was able to trigger this during development once, the whole machin=
e
> went down shortly after -- mostly because of use-after-free of something =
that
> is now a page table, which is just bad for both users of such a page!
>=20
> E.g., quit that process and we will happily clear the PTE, corrupting dat=
a of
> the other user. Fun.
>=20
> I'm sure I could find a way to unify the code while printing some compara=
ble
> message, but this check as it stands is just not worth it IMHO: trying to
> handle something gracefully that shouldn't happen, when really we cannot
> handle it gracefully.

So, you have experience of a time when it didn't help you. Okay. And we
have had experience of other times when it has helped, if only a little.
Like with other "Bad page"s: sometimes helpful, often not; but tending to
build up a big picture from repeated occurrences.

We continue to disagree. I can't argue more than append the 2.6.29
commit message, which seems to me as valid now as it was then.

From=2022b31eec63e5f2e219a3ee15f456897272bc73e8 Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hugh@veritas.com>
Date: Tue, 6 Jan 2009 14:40:09 -0800
Subject: [PATCH] badpage: vm_normal_page use print_bad_pte

print_bad_pte() is so far being called only when zap_pte_range() finds
negative page_mapcount, or there's a fault on a pte_file where it does not
belong.  That's weak coverage when we suspect pagetable corruption.

Originally, it was called when vm_normal_page() found an invalid pfn: but
pfn_valid is expensive on some architectures and configurations, so 2.6.24
put that under CONFIG_DEBUG_VM (which doesn't help in the field), then
2.6.26 replaced it by a VM_BUG_ON (likewise).

Reinstate the print_bad_pte() in vm_normal_page(), but use a cheaper test
than pfn_valid(): memmap_init_zone() (used in bootup and hotplug) keep a
__read_mostly note of the highest_memmap_pfn, vm_normal_page() then check
pfn against that.  We could call this pfn_plausible() or pfn_sane(), but I
doubt we'll need it elsewhere: of course it's not reliable, but gives much
stronger pagetable validation on many boxes.

Also use print_bad_pte() when the pte_special bit is found outside a
VM_PFNMAP or VM_MIXEDMAP area, instead of VM_BUG_ON.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---1463770367-475110467-1751943186=:6773--
