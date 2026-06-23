Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D265366048
	for <nvdimm@lists.linux.dev>; Tue, 23 Jun 2026 09:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782207995; cv=pass; b=uQi/hdDy0cLaRkbIbIZnnamJRskL+eLYStCMaBvH7GDJCFOieLoWv46tgcRV9w26M1aUBf99CzIDs6xXqbrvWct0h0Y41kXWrpwMu2LQVad0y46+nzqZ/bk+qP1Mfcz3Oti3VfYeTXZEDHUttxU40drdgyOCbZSpVGSWgDgZd5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782207995; c=relaxed/simple;
	bh=37450W6FYAtNA5BvRLzKphD5NkEmloE/RbhaJCvRqSA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ln8l/YyJGH9Obc4XywiliVo22I9m0gDRqo+aYiyHsfoxh2lPzVkkeM/3qFfi6aP7/vcyxupDKXi5dJc4YHfcH962kEJ0xL5dE4sfVNzBVaJVzbueulcTNSDMBfRlJT6F30L3bjYoFPYSKzpHP0U+hhjxIjPS8TjhgtHJtBcl16Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ReVcyhpQ; arc=pass smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ReVcyhpQ"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e6d14aaef8so2259237a34.3
        for <nvdimm@lists.linux.dev>; Tue, 23 Jun 2026 02:46:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782207993; cv=none;
        d=google.com; s=arc-20240605;
        b=MxIxjFYYftKH+W9S5okjZyqXbxzaWt5vKA+HDpw+RM2UfdYabvX3iA+QNr6m5MZ7As
         xdgJKR2jyxO103qpWHLZsTo9a9R2ONNovc7uFpNiJcMBAJjQm42FaAffdt7OGOtJUCUZ
         TfqN9LZiQGsB75g56gOFkTiciGJqGUe+/PuMXq9pr9WnOQSfZKWAB5A1y7hvKN5ZRSlY
         Sm8PYiSEoMV7/jr0EaHRLHpVCiGaVcmN6cvB0CD5sfK67nSGkZoWlrs+vR4xl9gGJRWr
         VrPKjy8rQjL1qpywpAp/j4o7vlUuA2xeKo4Dx2z0EwQZc7f8f65fBr1VNAPoJOJavVO2
         BqYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yv0BeALdClipLyUvwU4pgEmX5q0tg0SvoPTdnQsLUIM=;
        fh=cSbhTXLk3JhOkASlAvEysvC/jGOmZn2VwdUM+mw10TQ=;
        b=P6/AvT6Id+itE8H7dn81pJnngv9pLkLEblVm3YFsYJ3qN6vz0wD8wulHNle/squ1jc
         mGy1eVD7mGxTa44Llyd1wp3FikwX45tsoqRy76R3Lm5/OiDK1zEdsVpmU8c/fMRO6VVT
         5gFiI7y+n+412Y4Epzu+7OqdavAIpQBkfDgG7nFRDBEU6dbmA46YGQjxbwoY0e4nLybp
         Jxt+07dfUl/7bGjl70Q9D9HP5t9IRJIGqZzrJ4ibKp6slFjlSASirF0n7le6UxsYr5GY
         8jwoIiqAhfeMgc6R9HgZO1yR8I+o79K494ftMnH+CtRlaRHsu4icl1RvFAVm7bOZlMVv
         n9qA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782207993; x=1782812793; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yv0BeALdClipLyUvwU4pgEmX5q0tg0SvoPTdnQsLUIM=;
        b=ReVcyhpQr+DYqbssGJfJOAXc/ZWk09NXllSVR/o6FHa4/NK+gRTaFzj/XVikYJM9tB
         vGIDxLT6OnZgYFgrEwUzpCps74qwlcIh3iraSu/KdLx4oSBRznh4S3kkqIyZ58xGhqsM
         f8hr9c1dVumnB7nxvnjluEVvbihnmGAGRMqQP4Grjq+LPiifNOE22Q3lNq6lrfbaEMbf
         300hNyi+1c4eaHrKK9i8InP4FUW4Uc23NWz31KECqRkAf/gCwNw+siLxuO6sHMIZCg2Z
         Bb2EVcvg5Z4RWZdqXpwqJhY9hWdfsH4H5ZMnUntUSlpRwGMibVCagdsm+s3QHr6Fdbwv
         Rnfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782207993; x=1782812793;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yv0BeALdClipLyUvwU4pgEmX5q0tg0SvoPTdnQsLUIM=;
        b=r09I+My8fgtK46NcosaGW9REBzaY2W60S2Awh/jjkFCFYH+XguwM8nUhQ16TUFFj4n
         +CpbeNYQM65dULqRmL7V1WJ0idtMXmCwaMWa+InGdhhh2B7hb6ECnqmkidaSZSpD+Fca
         Th2ISUyeuPKC/Plf2W14vwYpxWNYj9fucxTXTEKd3cILrcTn/942Vxng5KUArnUl2uVw
         OAHm7IWWdOlr1bBoVAGTHDfkNrVqJY1tPjLciXbkkg+LI3xXbOOFXtduUXOYb/G/xJLq
         22f/J8jQM21p5ChtNzdxMZBPC3hJVVUjKI8ah9x1V/YiNqh4CJDqJdKL3y8Q/Gkj/klr
         od4Q==
X-Forwarded-Encrypted: i=1; AFNElJ+pmpATptXGeZzxGi1wd3O9KJyyFhHEHt+SSDngBw5/+CgR5BaNsP/PeO3LuCroGuk4a0vV34Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHbk+yxDmksLTcrbT4H9KyfNVwzOWQ9LA9SItqsmM7Nr6Zchoe
	wgns9hB4y61qZxm/9xpxWvOgrcAGHPVoZkaHPPiIr092qlcY1q+uo55ZYSXzL9qo+fDzQEG2nd1
	DPJncdKPXYSokTq/SCZNICkGWEyOnm5ldAYUg
X-Gm-Gg: AfdE7cn/BzYBlIes9l8TZE36QgOFOckNMNuyBmPtojtFQ5UoGOQ0yp3VaTG4+iiUkfn
	PizMULLGKMmcVN72QaaBxEs/Ws0LXsGAwmiN1IQqvl7+18mWsed7VMf1grwZxQS5N5cfAmBYuwz
	WwFpyPIRahpzpBq1bt5Azf82Jey+mNHwbQhYatFhovlGB9ZaG4gA8CelkzDAOsUl1mnEiYVnMB6
	qn96XHD1wyjzyWHdPA3zwn3wWaVMvDAII8fX1tC7xFJhtf/9YwVgb0b2MbpN4LCw2dac+pRs90=
X-Received: by 2002:a05:6808:11c9:b0:48b:9987:ba17 with SMTP id
 5614622812f47-48f62c24e11mr798270b6e.35.1782207993042; Tue, 23 Jun 2026
 02:46:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260621130246.2973254-1-me@linux.beauty> <20260621130246.2973254-2-me@linux.beauty>
In-Reply-To: <20260621130246.2973254-2-me@linux.beauty>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Tue, 23 Jun 2026 11:46:20 +0200
X-Gm-Features: AVVi8CdODMw4si1bRIcvd7rg71p9Rlcb8aYNMExjt_doJRdh8NW0AmYupBG3yIE
Message-ID: <CAM9Jb+hf6KEWRKtWr6PQByRQ869jL6Ws7J_ShFjKY_YicTbS_g@mail.gmail.com>
Subject: Re: [PATCH v6 01/12] nvdimm: preserve flush callback errors
To: Li Chen <me@linux.beauty>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, virtualization@lists.linux.dev, 
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> nvdimm_flush() currently converts any non-zero provider flush error to
> -EIO. That loses useful errno values from provider callbacks.
>
> A local virtio-pmem mkfs sanity test showed the masking clearly:
>
>   wipefs: /dev/pmem0: cannot flush modified buffers: Input/output error
>   mkfs.ext4: Input/output error while writing out and closing file system
>   nd_region region0: dbg: nvdimm_flush rc=-5
>
> The virtio-pmem callback can return -ENOMEM when async_pmem_flush() fails
> to allocate a child flush bio, but nvdimm_flush() hides that as -EIO before
> pmem_submit_bio() converts it to a block status.
>
> Return the provider callback error directly. The generic flush path still
> returns 0, and pmem_submit_bio() already handles errno-to-blk_status
> conversion for bio completion.
>
> Signed-off-by: Li Chen <me@linux.beauty>
> ---
> v3->v4:
> - New patch.
>
>  drivers/nvdimm/region_devs.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index e35c2e18518f0..0cd96503c0596 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -1114,10 +1114,8 @@ int nvdimm_flush(struct nd_region *nd_region, struct bio *bio)
>
>         if (!nd_region->flush)
>                 rc = generic_nvdimm_flush(nd_region);
> -       else {
> -               if (nd_region->flush(nd_region, bio))
> -                       rc = -EIO;
> -       }
> +       else
> +               rc = nd_region->flush(nd_region, bio);

IIRC this was introduced as a generic populate error type since a
failed flush can also propagate host-side errors, which may not be
relevant to the guest.
That said, we could still consider handling specific cases like
-ENOMEM, unless there is a better approach to address this.

Thanks,
Pankaj
>
>         return rc;
>  }
> --
> 2.52.0
