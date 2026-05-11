Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EC437F72A
	for <nvdimm@lists.linux.dev>; Mon, 11 May 2026 21:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535664; cv=pass; b=Ul5zbOPrYjHH9E/PvaJNBGy8WL12RwfrEHSJuWfjdLz+UX3KpODRa5cII6g9VYPdk3WOiolbrVbTZhWwDpEsCoAJil7L/pArEYPHgESB7bL3lNtC8I7asW3ISRapplIG32xrDXr1P9ykpesUM8cdm8X+1vIZ6luWNyYKlZ2ncgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535664; c=relaxed/simple;
	bh=lJB7fD+0kZedYjEQATwAZeKYQRfTKZQy5z9HB8/efo8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OAthhN2QZ1akTyBHABZAXMoxLM/LFx9fQJU8xkfWRumBvF0YJwvkPnI96rfYE0EuStA2c1LLqi3WmKqa+DMIWSqoacHN7JfQaXTb2tTmO/EfaJSqEjEypHIS2X18sPUg/TvWrekcBKRBDS8ylfq96S6MTyey/GxkyeP2M5LlTK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amlalabs.com; spf=pass smtp.mailfrom=amlalabs.com; dkim=pass (2048-bit key) header.d=amlalabs-com.20251104.gappssmtp.com header.i=@amlalabs-com.20251104.gappssmtp.com header.b=wdRbhRcR; arc=pass smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amlalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amlalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amlalabs-com.20251104.gappssmtp.com header.i=@amlalabs-com.20251104.gappssmtp.com header.b="wdRbhRcR"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5a74ac8b40aso4442473e87.1
        for <nvdimm@lists.linux.dev>; Mon, 11 May 2026 14:41:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778535661; cv=none;
        d=google.com; s=arc-20240605;
        b=ZNDmTScmQbaUl1J3ANX+NFcNgwElvSVJRpI/5EtOAt0TeGfE6Mf68cL3AestPHoDVz
         Vs7jyJ2ECkxJMuLJIGGmr9YCoF+4Sq4D6gOPTN2cIlP6U7GJdwsIIkpXJeeG5R/ikpEa
         vAfUsosY+YEdMIzRcq2P9y/Hlo7S5dzcpEyzv4CaGdb1Z5jJddRsNWCgHEmtCQ/Cggxb
         vPm5AKbS4KibT2mubrz3wgbCDBYg+LDcgwgcdLPvl+U9TTsLWzCuiw830uox9ldX+WDa
         oBoWp/EgU90Gjw3RLY/rIhB218qp6vAasP5KJ2lPoWUVOnfKPG/6elIFO+dFmuCnD4Kg
         CL7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nXGS2COif/6iKudvleqhAUyTu2yl4tq3AvaH+a188Uc=;
        fh=MD9efS4A1spc/ZLfG2TU2+FCD7nshn5KuJhmK3S3Ju4=;
        b=BoygOKOllu8LOvcXG/NyyhzEVrJuOon5jXJzAKlt2uxkcN+f/DuLSbHJv66tX3O7Da
         eR6x6oGaXSGpvSjsBV+eGv+PAwR7HwrOglCfEG3F4mHilFUPIsAdf6IJ2v+WoLZItMki
         ClGK1xNQ+utotBTT1Jll4/9C60WdptxjhZHUP/AsWPBB71gDq62D6Ur5P5gcCYmodXkl
         Rjt7dFLSK9b3fFp0jt2zHjsEAO9sCbIFp/0cEzW53PaRA7HPRaWBZDvKrNgHr7Y1LLRg
         AWa05OfCN0mJ3tbeK+GuPEsO1Mq0GHKTCNkDDOivdfixG9QCdpZylGCiJtBM3YHv7KDv
         q1zA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amlalabs-com.20251104.gappssmtp.com; s=20251104; t=1778535661; x=1779140461; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nXGS2COif/6iKudvleqhAUyTu2yl4tq3AvaH+a188Uc=;
        b=wdRbhRcRdcfYgL9dtU+ed3yCnPnNVl3BLcIgUQhYkAkuIMDto+6Rr6hhxHTygzDsVe
         8+IYbdUhLmSJXGAAIl1hDiAAzwKmj83HDELAMbKTuoei1xCKeRoQfZQxF+2plaP8XkVg
         BdD6/kLLsdorTLqRRnMebmPM7WxwN5sGgx0r0KY4qgB5C8nYzsEGsB48PakXx+tKhTJS
         xhwBP7t4+kyP79YQai9jPNsbWCE4IJR8WhU6LSiC76wvGa4/CmUSSb6p8akSxTQntn+i
         mrGK1vN6pqhMgjaYAQ/8cI1uUc0NGYMNEvHF3prd/qmuYQ70u6z+9NLZP0JT5DQVcNIY
         v58Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778535661; x=1779140461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nXGS2COif/6iKudvleqhAUyTu2yl4tq3AvaH+a188Uc=;
        b=W0pyQejw/HmgDqYTsqFd6iSjQD26VOYYApNbCLMUkDp0dgG92Mi4+/Hv5wuuzTP6eC
         P3kW8rjCGi6k2y91FSwvfBjmr7UKms7oH+0eT7nrqoaL7n4VOlPWbqLHzEPFnG8LrZhT
         klRsT7c8m33kWfGC+xx3XRmU4pRtoDiPUwtfXeKtXz63DdsxIUdT36sCGUWkHaWyLyuw
         P324LsX86jvvDzGjn/woXKhkUvSd3xf9fmkDE0owoDioMiqEgtgY5M7KCwQwQyIZwBO2
         jTxKULNmgiPbQAewC/BARRsPesd0Od2ipg9DN32XzhOgIjO+d0AkrFKnux69RBBzmzNx
         YTUQ==
X-Forwarded-Encrypted: i=1; AFNElJ9TRz38u5ADpsMh9LPALdB5hUkAxE5DNrgScl4HXDP3nQbh5u97zOuop+qQKCgCSpDPNMaqcEY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwCHZkV2evqMzbQF6u8eCKj5A4vnZJXndAoi0Po2RQ3Y2mrb7RW
	m1ulQp+JzELme2RWpebUVkj4QYH5ApxvKIhzGVBZw16FXwvW09TMrKPpluvv+9E55/932O/x2zr
	dNIK53rG+xVkXxzbwkSJF3DMFo+QT2ObhrtFxF+6oV6I=
X-Gm-Gg: Acq92OFAsdYrPvmkux3VYYNnuaOjmBEzKGXtTamHNcKkIp2kf45SaN+sMo7uMjIvQ38
	p9ncq4toluN9W6m4ZCTHDlm6XcBWWUv7DjDFYkU9vs0QTwUwKtA9mquQgoSHg0GguOocn4mgWi2
	xmSMl/ABpgFwF1Rn+9qPpm1hQtvAI1/DWcz2v/FWZHZn9YdJURgypL1ovluwcK8ryTHbliXryK9
	zJZNpBBU/ntD/fikIgPnTm/JTYCNy6YAxljbGNvfZEP+V0chzQ87dGiIDpRa/3NzuWzmP0VQ1zt
	lJUaDLpJeu6lYuGUdIJ/7qjPR5F3Vs5dKMcHeg==
X-Received: by 2002:a05:6512:acf:b0:5a3:eb4b:37a7 with SMTP id
 2adb3069b0e04-5a8b6c9c525mr2973242e87.6.1778535660345; Mon, 11 May 2026
 14:41:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260501233933.2614302-1-souvik@amlalabs.com> <a708a295-9d80-4538-9d12-53c12820f9ed@kernel.org>
 <af4SR5-QwUCAClR8@nvdebian.thelocal>
In-Reply-To: <af4SR5-QwUCAClR8@nvdebian.thelocal>
From: Souvik Banerjee <souvik@amlalabs.com>
Date: Mon, 11 May 2026 14:40:48 -0700
X-Gm-Features: AVHnY4IWwwENmh7P5b_KrrZMmOGLtrgr6q2JnnDVvjY__BAFZLDH8ZYDhGP0lUc
Message-ID: <CANCY+o6T8eSnkw_mETH=kd9JDxp9tguHWnaU7L6Bp-sJMpniSw@mail.gmail.com>
Subject: Re: [PATCH] fs/dax: check for empty/zero entries before calling pfn_to_page()
To: Alistair Popple <apopple@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, dan.j.williams@intel.com, willy@infradead.org, 
	jack@suse.cz, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the review, will send a v2 with this feedback.


Souvik Banerjee


On Fri, May 8, 2026 at 9:44=E2=80=AFAM Alistair Popple <apopple@nvidia.com>=
 wrote:
>
> On 2026-05-08 at 19:15 +1000, "David Hildenbrand (Arm)" <david@kernel.org=
> wrote...
> > On 5/2/26 01:39, Souvik Banerjee wrote:
> > > Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> > > added zero/empty-entry early returns to dax_associate_entry() and
> > > dax_disassociate_entry(), but placed them *after* the
> > > `struct folio *folio =3D dax_to_folio(entry);` line.  dax_to_folio()
> > > expands to page_folio(pfn_to_page(dax_to_pfn(entry))), and page_folio=
()
> > > performs READ_ONCE(page->compound_head) -- a real dereference of the
> > > struct page pointer derived from a bogus PFN extracted from the
> > > empty/zero XA value.
> > >
> > > On systems where vmemmap covers all of RAM that dereference reads
> > > garbage and is harmless: the early return then discards the result.
> > > On virtio-pmem with altmap (vmemmap stored inside the device), only
> > > the real device PFN range is mapped, so the dereference triggers a
> > > kernel paging fault from the truncate / invalidate path and from the
> > > PMD-downgrade branch of dax_iomap_pte_fault when an entry is being
> > > freed:
> > >
> > >   Unable to handle kernel paging request at
> > >   virtual address ffff_fdff_bf00_0008 (vmemmap region)
> > >   Call trace:
> > >    dax_disassociate_entry.isra.0+0x20/0x50
> > >    dax_iomap_pte_fault
> > >    dax_iomap_fault
> > >    erofs_dax_fault
> > >
> > > Close the residual gap by moving the dax_to_folio() call after the
> > > zero/empty guard in dax_disassociate_entry().  Apply the same
> > > treatment to dax_busy_page(), which has the identical pattern but
> > > was not touched by the prior fix.
> > >
> > > Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> > > Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
> > > Cc: stable@vger.kernel.org # v6.15+
> > > Cc: Alistair Popple <apopple@nvidia.com>
>
> Thanks for fixing this.
>
> > > Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>
> > > ---
> > >  fs/dax.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/dax.c b/fs/dax.c
> > > index 6d175cd47a99..6878473265bb 100644
> > > --- a/fs/dax.c
> > > +++ b/fs/dax.c
> > > @@ -505,21 +505,23 @@ static void dax_associate_entry(void *entry, st=
ruct address_space *mapping,
> > >  static void dax_disassociate_entry(void *entry, struct address_space=
 *mapping,
> > >                             bool trunc)
> > >  {
> > > -   struct folio *folio =3D dax_to_folio(entry);
> > > +   struct folio *folio;
> > >
> > >     if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
> > >             return;
> > >
> > > +   folio =3D dax_to_folio(entry);
> > >     dax_folio_put(folio);
> > >  }
> > >
> > >  static struct page *dax_busy_page(void *entry)
> > >  {
> > > -   struct folio *folio =3D dax_to_folio(entry);
> > > +   struct folio *folio;
> > >
> > >     if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
> > >             return NULL;
> > >
> > > +   folio =3D dax_to_folio(entry);
> > >     if (folio_ref_count(folio) - folio_mapcount(folio))
> > >             return &folio->page;
> > >     else
> >
> > Makes perfect sense to me.
> >
> >
> > What about the usage in dax_associate_entry()?
>
> Pretty sure the issue exists there as well given this code path implies w=
e could
> pass zero/empty entries there as well:
>
>         if (shared || dax_is_zero_entry(entry) || dax_is_empty_entry(entr=
y)) {
>                 void *old;
>
>                 dax_disassociate_entry(entry, mapping, false);
>                 dax_associate_entry(new_entry, mapping, vmf->vma,
>                                         vmf->address, shared);
>
>  - Alistair
>
> > --
> > Cheers,
> >
> > David
