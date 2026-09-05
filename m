Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7DB369985
	for <nvdimm@lists.linux.dev>; Sat,  5 Sep 2026 03:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788578803; cv=pass; b=erqWRDYCtC9xqhfjRdT3nkBjoGyyRm+MEjaKccg3wzY+mOM7Wn7r/w3mPSzlFOpg0OVuOLAuj9GgpCAuPkEdPSM5dGmMTIpxVC2zqv41C7zk/JuA0gpumw+kQ3Nv/6SS254USwVqgYoGOt8adsgrohSpFXbXbZRrKbegGnAf+lE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788578803; c=relaxed/simple;
	bh=Ro5WQFnUyuX6c8ZMaP/vKnPsUVwk4Al6XZOewowjF5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L1OiLqr+09XPY68/l/DGz+u4qXVkZGIjFzXqkm9Sbxu2sQQwA2/7WsxV2BTr6pLyN+b8wu1g5sKPf5t7o+Zc27lZgr+arjALxBRH1xa/dC9ozkaa50LP2++31ICB6nhesBoyxiw0MQiofNFptxP0cOin0yd1Q3S0NcEqWV1GwIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=MkUjZb3V; arc=pass smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="MkUjZb3V"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8200b55dc47so23605317b3.3
        for <nvdimm@lists.linux.dev>; Fri, 04 Sep 2026 20:26:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788578800; cv=none;
        d=google.com; s=arc-20260327;
        b=PMnE9nvPlnltD1r/TG/PkKA3Ro7d0jGNawev2uZhbtHyNtA5jGUGCZdIk+jH6RrMpt
         wmWTx0VV+zl37Mt5yxTq+NoXKFwZQtLkACZHy7spJEgETe5vigNKHVgoZAatgrl7zTxU
         gPiBcS0/tSMd3uA2t8dfIuWmb2revWD5bORisqeftOdQM/Fx4xe6dd2Jq7eCWSqrAgQQ
         ZAJdBIVw4YVc1R1izttTJRMBYyiAmEWkRpBGkkLzAuTfDnU7cPQnkAS+4926RqZxQB+Q
         FMJi/LOVCssRQFFMLnmVoNy9YacB00aI8lpJSP0WThyrjSB5VENce5uGL0q9O6Q/eeQq
         +ZtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/nulUh8YNeX+n+nn9HvwdNzcBQLH+YBQeOJSncThU38=;
        fh=+EqZIQ/Z0eTPY3bjRaHymGh5YecU+3rv2c1KGcdjJQw=;
        b=GSWZIrZ96olx4g5Yr58cktIUgZug3Zlg8dc5KppZoEyJiS9+3vMscBO81MX6C+i3fD
         HaCJo9Fm7GugIxEN3B8c0Xbhs/+fOcS6SaV4RQ3pB5s2PVCcVHoHTvF6jKb58ksYu3TS
         mbg6Kemy11dK+ppnrykHd9O3HS580huxiYQbi+YR27ZNCu2wJuUMxMWysj9vLUFbEnqu
         ssZThNvTxWU0sgRvSVxQNYBDfL6ST+ABKb+ng7iOhfwHU5kGukwVXg38mzWkeap7V4XZ
         tfzeT+sIVnvg6yF5QI6683XmqB0+OGA4XFhHkZqDhnYVkncWd3adA7iAeRJahl4egMJr
         lHeg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788578800; x=1789183600; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/nulUh8YNeX+n+nn9HvwdNzcBQLH+YBQeOJSncThU38=;
        b=MkUjZb3VV75sudGvgm4vdnWNc4FvID6vkEe3JhxVJSK/PlAZnQbjwKqur+Huy5Ernf
         RRP3AWFVJfLaMzlkWReppSOjYvYGcqoYiTSdoONYF9pr138MAj3j2NFu4mk30zQb4B37
         mww97BVKfFLUxyeXcBGJpbwGE93t/0Olho2LQZQNRlBffEQRoiR1uAzQDrF187NquQaO
         S+YdQtS49GZgz25mRLEVbAn6jOpnofkY3yesq2S7n223EyQj1EQamKGq0VN7LCADL8SC
         H5A3AOOOqRem1YJNX1XqWnAds2PBtTrEOJYMdpcyRiFi7is9Tl9kTaHHAy0maKSCy/Db
         97NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788578800; x=1789183600;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/nulUh8YNeX+n+nn9HvwdNzcBQLH+YBQeOJSncThU38=;
        b=IvSWn4f2QxIcgYLH4vdN81w4O+LuiZbKNuEKSsNLwSQ4/FjLQi+KqOh0HdXWaHn8XM
         TUoVHhS27ICPTrSsBYz6+ci9MJ95ETIj0ssLgUV+BDHzNtuFjtmbzBwn4Pjf+9FURP1p
         TA7rZlt4IP5SwjI5qGBb8MIsTyVZmKh+ZXNwDOXltdLV2YmukRk/m9EdNU8bDCRftgrz
         4jkp5806j4PWlJfvha9lrXuaBUUfProZ9tvRAc1EUofpdrRtxtt5R9NPlNJpUVIhfR9A
         Ac4LdFHm2rz1Wk+RPUmjPXSrmFJOI4plYn8at6LkHXH8H5o3gYFHjli5IaVZ04Fd2fg+
         3ywQ==
X-Gm-Message-State: AFuF++kGZQ3orhnFn66NSp1diSyI4UuUH3YAUUJx3kui1ZIEW1w0Jw+u
	2KkPN7+KicfxMzirnrBd+rBUzXg4U5RqYf/avpM6fnoMo0PbvjL44ICK5fpQM9kzrDPF3vl1DXa
	mKA0JBrBz68LEMKC+FFdvNLBsOuSsFomBvQ94MQsVlw==
X-Gm-Gg: AYBFou2ggHrhKtzWc753sz1KbxFz3xG/xbj1NcFUizePKBQl0cQsQ4znQU+Hx63gsyg
	5PKf9OPP/2HfQOZITmgME3+QfEIGL3rO/mt/87zaKaSfXbhGx0NKvi8cI+psaCE6aT/vI7x6SXl
	6iIkPzqZpiS6ct6wCtPfRmNMfFtFAWib+g4grm1GtyBnxHxTtB7DYDyCFTOabJ0dMqu1fqy/VaP
	SMv9ggzh+4r9Y7/+QH8b/JIkOssI09U2hVHlGNIuz+51BMmB9Tq/Pm2atJMniQ86TB8osTeDDDk
	mLcIF7uP5rxPDaqHqcCWXqWWnpsuLsk6zqZLK+4futniu0Y=
X-Received: by 2002:a05:690c:9c0e:b0:85e:6840:4ea5 with SMTP id
 00721157ae682-87126e97f78mr50237547b3.26.1788578800363; Fri, 04 Sep 2026
 20:26:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-5-songmuchun@bytedance.com> <20260903125312.16B761F000E9@smtp.kernel.org>
In-Reply-To: <20260903125312.16B761F000E9@smtp.kernel.org>
From: Muchun Song <songmuchun@bytedance.com>
Date: Sat, 5 Sep 2026 11:26:04 +0800
X-Gm-Features: AcwNN1UeHEvk3zYctxqOtU6UT64a-Esa9ORnfEzCr_q1R1rkedrEbgma7jX-zEo
Message-ID: <CAMZfGtVhb8MMTJGPgsfo7a2VFEGS84VP--_dA5ffY_KykEV53A@mail.gmail.com>
Subject: Re: Re: [PATCH 4/4] fsdax: materialize pmem vmemmap metadata on faults
To: sashiko-reviews@lists.linux.dev
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 8:53=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
> - [High] Global TLB flush broadcast inside global page table lock causing=
 severe lock contention.
> - [High] PMD fault materialization failure incorrectly returns VM_FAULT_O=
OM instead of falling back to PTE.
> - [High] __vmemmap_materialize_page dereferences a potentially NULL PTE p=
ointer if the DAX device is concurrently hot-unplugged.
> --
>
> commit 9e2a623911317e382af87ef795b2fc34f1686554
> Author: Muchun Song <muchun.song@linux.dev>
>
> fsdax: materialize pmem vmemmap metadata on faults
>
> This patch opts pmem FS-DAX into the shared read-only vmemmap mode and
> materializes private metadata before inserting a PFN into a userspace
> mapping. It shifts private vmemmap allocation from device registration
> to the first DAX fault for each metadata page.
>
> [ ... ]
>
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 1fbba0d21c13d..89377301d51b0 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
>
> [ ... ]
>
> > @@ -1877,6 +1878,10 @@ static vm_fault_t dax_fault_iter(struct vm_fault=
 *vmf,
> >       if (err)
> >               return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
> >
> > +     err =3D vmemmap_materialize_page(pfn_to_page(pfn), pmd ? PMD_ORDE=
R : 0);
>
> [Severity: High]
> Is there a risk of severe lock contention and RCU stalls here?
>
> When a PMD fault triggers vmemmap_materialize_page(), it loops 512 times.

No. It loops 8 times not 512.

> Inside that loop, __vmemmap_materialize_page() acquires the global
> init_mm.page_table_lock and performs a synchronous TLB flush:
>
> mm/sparse-vmemmap.c:__vmemmap_materialize_page() {
>     ...
>     set_pte_at(&init_mm, addr, pte, mk_pte(candidate, PAGE_KERNEL));
>     flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
>     put_page(template);
> out:
>     spin_unlock(&init_mm.page_table_lock);
> }
>
> Could this cause the system to become unusable under load due to sequenti=
al
> global IPI broadcasts while holding the global kernel page table lock?
>
>
> [Severity: High]
> Is there a race condition with DAX device hot-unplug here?
>

No. The FS-DAX fault path is not relying on that SRCU lock to protect
later struct page accesses. Before dax_fault_iter() is reached,
grab_mapping_entry() has already installed
and locked a DAX entry in mapping->i_pages. DAX invalidation/removal
paths synchronize
through that entry and wait for locked entries before deleting them.

> The prior call to dax_iomap_direct_access() acquires and then releases th=
e
> DAX SRCU read lock. By the time we call vmemmap_materialize_page(), there
> is no lock preventing the DAX device from being hot-unplugged, which tear=
s
> down the vmemmap page tables.
>
> If that happens concurrently, __vmemmap_materialize_page() will find
> pmd_none(*pmd) is true in virt_to_kpte(), resulting in a NULL pte pointer=
.
> Will the subsequent ptep_get(pte) dereference this NULL pointer and panic
> the kernel?
>
> > +     if (err)
> > +             return dax_fault_return(err);
>
> [Severity: High]
> Does returning dax_fault_return(err) on a -ENOMEM error incorrectly trigg=
er
> an OOM kill for PMD faults?

There is no reason to fallback since no memory could be allocated.

>
> dax_fault_return(err) translates -ENOMEM to VM_FAULT_OOM. If this
> allocation fails during a PMD fault, shouldn't it return VM_FAULT_FALLBAC=
K
> instead, allowing the kernel to gracefully split the huge page and retry =
at
> the PTE level (similar to how dax_iomap_direct_access() handles PMD fallb=
ack
> just above this)?
>
> > +
> >       *entry =3D dax_insert_entry(xas, vmf, iter, *entry, pfn, entry_fl=
ags);
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903122128.12=
264-1-songmuchun@bytedance.com?part=3D4
