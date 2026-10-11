Received: from mail-yx2-f10.google.com (mail-yx2-f10.google.com [74.125.224.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ACF397692
	for <nvdimm@lists.linux.dev>; Sun, 11 Oct 2026 08:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791706514; cv=pass; b=eW+cMA8vEA0RJJfFniubExZQingEMTzaEETlApvfZHi2ECQiUM3ORWFIpDiUfxah863o9eN4aaw+sMscYJwUtBmV7SJYFE2/BegrRf1bDeXByg9rIHR4pf/j+eukHxey0dkVC61i+X0L4xTW7Iho1r9xdzhZl5gwBYJjfK73mhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791706514; c=relaxed/simple;
	bh=jvQVAqen3TTXhHlWzW8Yi27M4FmKSROMr6iRyVCzJYY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p4HhDmAZq42eStvp8h+FV+QT3keZcNOsNmdXDyCg5n24aNDMRNVPWWOUiMHriLSz3wxCsiOq3fifoiFSu93UTKnthIKy6yCAcsXx29wKa2rftKwjkKMYix3NWfB3X/IRl0QlbrhdUYY9NreIB0qt5DnScruW2FxJ4nWcTxaQL+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EIPSc8NY; arc=pass smtp.client-ip=74.125.224.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EIPSc8NY"
Received: by mail-yx2-f10.google.com with SMTP id 00721157ae682-88b9012eaa4so2560827b3.0
        for <nvdimm@lists.linux.dev>; Sun, 11 Oct 2026 01:15:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791706512; cv=none;
        d=google.com; s=arc-20260327;
        b=VSvslBCHRoZ+8xGC5cf+TsYftRGvb/mPD3AEgj6HQCpnVChKaqL+Hi1ldYanZapOgR
         +f9VS6AVf8Rcqg3ESOP4TYhsfdWSUEG+Gela8RnrVBN0+jzpDYuAn+3uS7YgyuNhytDc
         wauUWO1G3p3ALjePVFSFEfxKRk4tKQttnM49fP+gRDoeTgGfVCAAJZ0hk///3mf663s+
         y0WlGKQeYvBaBPxG1LFyg7GC8chy+Ej/qNo8qyq2EbTqOIGOim77E0pwJ7+rrt0NLa7D
         sUTIflZQaCKX4yKDiG3QGI0ZyTxneqZ+5IoVTbWsuEzEvonPv8OtgbPbA7NNUs4dt4Ck
         Y/8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LRH1T/SuDX3O/SwrQ3G/RC5/ugI0lcXz+k7cvM+F5i8=;
        fh=m74ElSqHazzSng+Mltoi5J3j8qED2+GBqGz/HsIcJkA=;
        b=hnauHAR4rrnpHMew/szoKnKz2nY8fs1AszkVw2WzpH8YZwuHr6KwA9LVIn4+sSlvnD
         VR8UAcIz6BNyURnmOFvn77+Yy5EAdFAGboGfc1jcOpH/q4Vz+y72OceouIUJBv57d5jA
         qlAbQGvdpkROOt2Ixv2XhL36KmKp+ZLf93iO2JjTvu4amC78GFJmB9gmOP1xnzAU5JtZ
         nh92TWDXtfPrJ7GOycE8cuK/7xPOwTfLe2onwweFt7A0o4aoO1nm47MBPkSmS9Bht7ft
         zMpDBxZOFluarrkXj034PfXrnwheoZLRgeI8sm7QdZVXIO5++yl9vhB16WMYyQfYYL+L
         jZAA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791706512; x=1792311312; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LRH1T/SuDX3O/SwrQ3G/RC5/ugI0lcXz+k7cvM+F5i8=;
        b=EIPSc8NY/QzIyOZ0YbubDB6Ra6wpyJK5A7rnJNadh0u0HpX18ayvrf4SkzO97zFBon
         hBnZ9l/q2rrpBEzwMz0gkPw+ELWAnJf64LFlFdfqMJ1RVomHdktQkSQmS5BrM1jbK5NG
         TO02EPcrlp9hBiuwrFovMZ4F3FxjGyJpNo4i1Ql55HvKH1eFuuIj85xrxc/PtlppDpeh
         tvg4B3gImmRYc5s8PEkoc2g+l0tJn7/lvpwwJr4OTKYP3bIyHAwlzkm7yl0mLbtGCSuN
         VLteWnBXgPg1gGbgJNxrWzknizxlI426TWq0aA4r8LOC46pZ3sb6p7VfKYk3BRRvxEmP
         +Zxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791706512; x=1792311312;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LRH1T/SuDX3O/SwrQ3G/RC5/ugI0lcXz+k7cvM+F5i8=;
        b=tkCvRMwzBskIMDqllwuiisUm896s6sGhifV8uMhBMtVsuCoo0O36prr6qg7Au/xg6i
         yq5U9VpPbvKegiAZwvjr0fqWODsNZAsr0i+yJ2H+AGRmSgYxwdx2UISEGKAnKcCpHFOI
         G8z7mgNu/ugI9HdEhdUsHl+4ywBIKVo9dut4zQ4PsS8buNjmFAv5H/MjrIPhBS/XkVMC
         96w1ZjI4P4mkbNhbAK67qWTqpu1f4PptZ0RlwOLSkdbIF3P9lbOuH8wVkSYNLhdPWjh4
         LM8ArV9EU7Y/IyeMkgqm/bFvLZFDVD1prew7zUn9zWPNyNIlofhfgsU9TDlXNFeADlSu
         gJJg==
X-Gm-Message-State: AFq9FYJnWi0MVNEywU8M83XfZazJw6RwEsvTuWIc0meEGyEQmDfL+zyn
	KN+ZiSsD+Aw/3T30p5s3E9MEuBBYBiIkmTViKqf8SXCeOs3ONfeVV22C2NvDAdBeWeKXV7rg62t
	ZMyPt/vUlsFAldOVekKzmQYdfLV88Fk583IjFB03C33w9mA0=
X-Gm-Gg: AYBFou0ti5LO0qLHrQtzqH6Xn02dmbhhOYBAtxtGcNzuwooY7e1BRSh9+VFQJKiQcCP
	498KGSDcsBo8ve+DwcpixE7RHBWvaXt5cdGMPdRrl9qgsGNQasOOTxkbg4Bhy+T/2Q9duifKLND
	FRT7LHsldRK5qp8IsCRvzAgs+W1V2HWFFEMdf5LnTneqgef7HSl5GQW1y68Sukuh6NSVw6a3I8h
	sBhjYstZaOUlWTgXb/AEV7+TTZMC12mSyk7nITe2BPkVd8aQmwhoIC1ViMRLPzvp+v+DW+1zoMZ
	7B4Zk4Yjn1tJffE+tsnRxsvtybzLn42HAq3K+ECZU2FzfX5iF5BfCnM=
X-Received: by 2002:a05:690c:f14:b0:893:845c:429d with SMTP id
 00721157ae682-8b07ee76a2emr21536587b3.52.1791706511637; Sun, 11 Oct 2026
 01:15:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261011064840.1296-1-jianyungao89@gmail.com> <sashiko-outbox-167100@kernel.org>
In-Reply-To: <sashiko-outbox-167100@kernel.org>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Sun, 11 Oct 2026 16:15:00 +0800
X-Gm-Features: AclHuK9pz8m7Y5rfNsR-C-A-4FIzud9n3CRV2Cis1VmBKZZ1E4Eun5zplH2oehI
Message-ID: <CAHP3+4ARGMUd1Cyyb+_5vpKA+8Km-BdgCZZfirmqQZrZ8spm+w@mail.gmail.com>
Subject: Re: [PATCH v2] dax: fix dax_range_compare_iter() to use correct size
 and address offset
To: sashiko-reviews@lists.linux.dev
Cc: nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Regarding the first issue (`dax_dedupe_file_range_compare()` drops
error and returns false dedup success), this is already addressed by a
separate patch that changes `return ret` to `return status`:
https://lore.kernel.org/lkml/20261010021010.19575-1-jianyungao89@gmail.com/

Regarding the second issue (memcmp on IOMAP_UNWRITTEN exposes
uninitialized PMEM data), this is a pre-existing issue unrelated to
the current patch. The current patch only fixes the size and address
offset bugs and does not change the handling of IOMAP_UNWRITTEN.

Regarding the third issue (CPU soft lockup due to unbounded memcmp),
this is also a pre-existing concern. `dax_range_compare_iter()`
operates within an iomap iteration that bounds each iteration's length
to a single iomap mapping via `len =3D min(len, min(smap->length,
dmap->length))`, so memcmp typically does not run across the entire
1GB dedupe request.

On Sun, Oct 11, 2026 at 3:09=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
> - [High] fs/dax: memcmp on IOMAP_UNWRITTEN exposes uninitialized PMEM dat=
a via dedupe
> - [High] fsdax: CPU soft lockup due to unbounded memcmp in dedupe
> - [High] fs/dax: dax_dedupe_file_range_compare() drops error and returns =
false dedup success
> --
>
> commit 035a3cbae242fa7d9d78dcd078b21ab3eeaecc67
> Author: Jianyun Gao <jianyungao89@gmail.com>
>
> dax: fix dax_range_compare_iter() to use correct size and address offset
>
> This patch fixes two bugs in dax_range_compare_iter() when calling
> dax_iomap_direct_access(). It corrects the size argument to use a length
> rather than an absolute file offset, and it adds the page-in-page offset =
to
> the source and destination addresses before comparing them with memcmp().
>
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 08adeaed2baf1..7bee4314f905b 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -2190,6 +2190,7 @@ static int dax_range_compare_iter(struct iomap_it=
er *it_src,
> >       const struct iomap *dmap =3D &it_dest->iomap;
> >       loff_t pos1 =3D it_src->pos, pos2 =3D it_dest->pos;
> >       void *saddr, *daddr;
> > +     size_t size1, size2;
> >       int id, ret;
> >
> >       len =3D min(len, min(smap->length, dmap->length));
>
> [ ... ]
>
> > @@ -2205,17 +2206,18 @@ static int dax_range_compare_iter(struct iomap_=
iter *it_src,
> >       }
> >
> >       id =3D dax_read_lock();
> > -     ret =3D dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAG=
E_SIZE),
> > -                                   &saddr, NULL);
> > +     size1 =3D ALIGN(len + offset_in_page(pos1), PAGE_SIZE);
> > +     ret =3D dax_iomap_direct_access(smap, pos1, size1, &saddr, NULL);
> >       if (ret < 0)
> >               goto out_unlock;
>
> [Severity: High]
> If dax_iomap_direct_access() fails here (e.g., from an I/O error or a siz=
e
> issue) and returns a negative error code, does the upstream caller
> dax_dedupe_file_range_compare() incorrectly mask the failure and report f=
alse
> success?
>
> When this function returns a negative error code,
> dax_dedupe_file_range_compare() handles it like this:
>
> fs/dax.c:dax_dedupe_file_range_compare() {
>     ...
>                 status =3D dax_range_compare_iter(&src_iter, &dst_iter,
>                                 min(src_iter.len, dst_iter.len), same);
>                 if (status < 0)
>                         return ret;
>     ...
> }
>
> Because ret holds a positive bytes count from the loop's earlier iomap_it=
er()
> call, a positive value is propagated back to vfs_dedupe_file_range().
>
> The VFS intercepts the positive return as a success flag, bypasses block
> remapping, and reports a successful deduplication result to userspace eve=
n
> though the remapping aborted early.
>
> >
> > -     ret =3D dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAG=
E_SIZE),
> > -                                   &daddr, NULL);
> > +     size2 =3D ALIGN(len + offset_in_page(pos2), PAGE_SIZE);
> > +     ret =3D dax_iomap_direct_access(dmap, pos2, size2, &daddr, NULL);
> >       if (ret < 0)
> >               goto out_unlock;
> >
> > -     *same =3D !memcmp(saddr, daddr, len);
> > +     *same =3D !memcmp(saddr + offset_in_page(pos1),
> > +                     daddr + offset_in_page(pos2), len);
>
> [Severity: High]
> Does this code expose uninitialized PMEM data if the extent is
> IOMAP_UNWRITTEN?
>
> While dax_range_compare_iter() explicitly checks for and skips IOMAP_HOLE
> earlier in the function, it fails to check for IOMAP_UNWRITTEN.
>
> As a result, the physical PMEM blocks for unwritten extents (e.g., from
> fallocate) are mapped by dax_iomap_direct_access() without zero-filling
> them.
>
> This memcmp() then directly compares this uninitialized data against the
> target extent.
>
> Since early-exit from memcmp() is measurable, could this be used as a
> timing side-channel to extract previous persistent memory contents, as we=
ll
> as causing functional deduplication failures when comparing logically-zer=
o
> unwritten extents?
>
> [Severity: High]
> Can this memcmp() cause a CPU soft lockup and RCU stall?
>
> When called via the FIDEDUPERANGE ioctl, vfs_dedupe_file_range() can cap =
the
> deduplication length to 1GB.
>
> Because DAX/PMEM mappings can be contiguous for gigabytes, this length co=
uld
> be passed directly to a single synchronous memcmp() call here without any
> cond_resched() yielding points.
>
> >       if (!*same)
> >               len =3D 0;
> >       dax_read_unlock(id);
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011064840.12=
96-1-jianyungao89@gmail.com?part=3D1
