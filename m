Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C60142901E
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 07:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785311972; cv=none; b=ofCQHzb+qibsGmyb1QLCNR1favy3nFnisyz5MBliTcK5krO3HTkL1Ow8ziN7UoS8i+tA3A9fNFRrGsfs4kzu5EjRj3T5LMOMPxFO/lETbJzUsuE58FEgkQ1tUOTJOqOvTZ+GIYrh7v/F8TrHgX7SMdl2qjc/1DarFezVq5X5CQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785311972; c=relaxed/simple;
	bh=IvZkXKAaJ3qto63ByJqwB/Pqe8jV7U9Ac1mrfqxjOAI=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hNrZhQxTnhvvGnXNlQxJzg0ERLFjCVwdSDUXHWGYJbjkYCx8l3/qf/XJpqrckxJ/nh7hHsn3CqGI6mP3H5TpPZtemAMAU5xjivuXPyUHIpAZqdu39IdLxtmXHXwK7eij13s2SyLLChK0m29HxdFEqtwN4Ls5MfprhSi+APfekaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mq06v37r; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mq06v37r"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84a2c90e383so1483897b3a.0
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 00:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785311970; x=1785916770; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=y+pt8D4B66zZRU8DzGcBGgfx1THqisEYsOCpc1gf1Dw=;
        b=Mq06v37rn0D/AE+9pBk8WYzeZwk0SkTVEQoj2+3U8i6DKGmWSAO/4PdIISy25HQ/pW
         nEJsoKpzDcDouX06+bItp3hDxzxmFf5Xk1f1tQhy/mt7ml6iiZk7L+lWXlTeJ0K1loFm
         XFReFLDsefRZin257e9s/hFFgZocj5Prjb+QMKVXG6O5s4zzAmmmEfGYSZGU7SUmv52S
         MrYi8j+Ku8A0l39EtR18lxXh1jox27n0zpCMlJbvvCD69YeUoP/86q5r5hN5jEse1j/j
         ilvis1rTuEw+CnSiEScK1uytNPAsiE18LSSUTkN2jAMTTymWd7y8mUwfKGyHQYvUfvyk
         AcYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785311970; x=1785916770;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=y+pt8D4B66zZRU8DzGcBGgfx1THqisEYsOCpc1gf1Dw=;
        b=R+btDN9Ph/iIkQQ+oTWukbL4ZBKj/Vephg9YrlfABthrRt9F9tRNbyLScrWuEW4NS+
         4pvUQQV+IFtTKrXqjTgbbWhbvMuE+Gb8DClIVIVTgw494H9+1VrFMwpZmeP1fuE8Mc0b
         1CIg6Jcs9E+rUuv2xzHbLb4df1Vne1vz49WrYVcTL3KVSG7Am1FC2SUriQ5kP/m3JJbI
         iMyJNi3O+75oUK9gutsKpmfOCN4OvGTXznI+QcWSEixPgGPjjbGhnsgGVYmow8jTc/AS
         1wzGLfRtjtAqlPU/po4N3rTYYAgovh7mvyPgWNdBuHkOBnapWAIxmHKcTHhnFVTXQgK5
         4k1w==
X-Forwarded-Encrypted: i=1; AHgh+Rr8+D1fu+bNU+TkrWn4l+XzUTd2WPOrzKZpwFLyS34nREHaK8dxknOUlk8vZSs3hj56E2+i9ZE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwKpeW/9b6JRbU0VDeRU9Z7LnqvHDNLZj7SFYfCbE25peeXjtLr
	XlY93/UicUiRncda7TEVBTrOskjbMNbl1mi2MxzJfbdHUwGWGV7O6uA3
X-Gm-Gg: AR+sD106xmaObAPFWRO8ri6emshDlgRdVhkA7jp0tzT2CcOu3HzDHqT9n2Kj1xynBId
	VSWTsGv+ePjrRZX9dayai02ScRW+4FvYKCxdHbrpA344yCKAgOq4/Z6Awy3myGY399sttQeF4hk
	kziLQbytw9uoZedBkWXG+huaq5thn+N4XhaXlCnVDpJGPh4WnuuR0RscLSyJb3oa7DIV33GgTEd
	eQeVGKsI3aPbVCDf/iKdjNqYeNqvp4CFFEjdehicMOWIDOs7HJu517Vi+heyD+xbtT1LfjhiQ2m
	FgpX6Y/83rKsECUs94FqnR/PLFU6lvB6CeHMw/jSDcsvdwo5BfDy1WDRkTWqUKp+rBDh2rEd/yf
	EbS8GVIemdDuoELsqnxKHeb1a182rYnu0VJZxp1hmufY/nQxEHE0/VLbglMfdfaIHP18Eb1Pgfc
	oDfYl2hAVHLVkXV8ci8RkS6PJukwsnzmJLvbZLbTf0/iHZZJsNGWydz0Z7VR5Mm6aiaNQtp3uSg
	/9w3FWIVyp/9IFOQzplRf9fi5X+g8lRnANzJJH9PpVREGcesbLub9Q=
X-Received: by 2002:a05:6a00:4c0d:b0:84e:165:da6f with SMTP id d2e1a72fcca58-84ea794a80cmr1312522b3a.10.1785311970424;
        Wed, 29 Jul 2026 00:59:30 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdb824d421sm526825a12.10.2026.07.29.00.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 00:59:30 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 29 Jul 2026 00:59:28 -0700
To: sashiko-reviews@lists.linux.dev
Cc: Anisa Su <anisa.su887@gmail.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v11 15/31] cxl/mem: Drop misaligned DCD extent groups
Message-ID: <ammy4JqjW3SB10Yz@AnisaLaptop.localdomain>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-16-anisa.su@samsung.com>
 <20260625181945.41C431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260625181945.41C431F000E9@smtp.kernel.org>

On Thu, Jun 25, 2026 at 06:19:44PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] Un-ratelimited `dev_warn` on invalid CXL device input can lead to log flooding and Denial of Service.
I don't think that's very likely but fixed to prevent future complaints -__-

Including 2 other places in Patch 17 and 19 for consistency:

Patch 17:
        - mbox.c: cxl_check_group_seq() shared_extn_seq-density and
          cxl_check_group_partition() partition-span warnings.
Patch 19:
        - mbox.c: cross-More "tag already committed" warning.

> --
> 
> commit 2eb192d0644cd71e7046e47b82d5b1422081590e
> Author: Ira Weiny <iweiny@kernel.org>
> 
> cxl/mem: Drop misaligned DCD extent groups
> 
> This commit adds an alignment check to cxl_add_pending() to ensure that
> extents in a tag group are aligned to the dax region's mapping granularity.
> Misaligned extents now cause the entire group to be dropped.
> 
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 08f51b8807c06..14ba263044f08 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> 
> [ ... ]
> 
> > @@ -1395,11 +1410,38 @@ static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
> >  	return group_cnt;
> >  }
> >  
> > +/*
> > + * Validate a tag @group before realizing it.  Returns 0 if the group may be
> > + * added, or a negative errno if it must be dropped.  Further gates layer in
> > + * here in later commits.
> > + */
> > +static int cxl_validate_group(struct cxl_memdev_state *mds, const uuid_t *tag,
> > +			      struct list_head *group)
> > +{
> > +	struct device *dev = mds->cxlds.dev;
> > +	struct cxl_extent_list_node *pos;
> > +
> > +	/* Alignment gate — drop the group if any member fails */
> > +	list_for_each_entry(pos, group, list) {
> > +		if (!cxl_extent_dcd_aligned(pos->extent)) {
> > +			dev_warn(dev,
> > +				 "Tag %pUb: dropping group, extent DPA:%#llx LEN:%#llx not %#llx-aligned\n",
> > +				 tag,
> > +				 le64_to_cpu(pos->extent->start_dpa),
> > +				 le64_to_cpu(pos->extent->length),
> > +				 (u64)PMD_SIZE);
> 
> [Severity: Medium]
> Could this un-ratelimited dev_warn() lead to log flooding?
> 
> If a malfunctioning or compromised CXL device rapidly sends DCD_ADD_CAPACITY
> events with misaligned extents, it appears this could spam the kernel log
> and cause high CPU overhead.
> 
> Should this use dev_warn_ratelimited() instead, since it is driven by
> untrusted device input?
> 
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260625112638.550691-1-anisa.su@samsung.com?part=15
