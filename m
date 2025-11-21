Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E0C2F12DC
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763745166; cv=none; b=gfhHhNS6YK3ID8FrsumTgF8P9VIZhTnCWe20LIa8I5ziO1ULpVTF1UOOCtJTSb3fupjHSKPgEHo6I3rRZFOTXORykyv2RVqXbVCP16TsBgyAbNDAibSX8XJx6Bhlxm3MchOL1gdda0wSd/ngJTLYPkEnXiGshTOt9f1GLgWh2Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763745166; c=relaxed/simple;
	bh=4knX7UdpV5PqcFPGudPF/uxcuJbYSUmyGMDEJIBJ6aQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RqH7snMgsOqAlyX6W7s1Q/Go/wYG+G6UZw2/jVpTgwrs6tHp9L01OXa6UVZOTKnBxmEblXVWx77y6VKqw5j3ipP7c4tRAl/3Z0m4Khnp28vx+YF9zhdS5ue5ndzGAioqah91x1lsyx1yOb0pOFgHRTeSo6gm3ECI8eTc0GBrRIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MGYsuK2O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MGYsuK2O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763745164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FRU2qLfbf/wNhvSHqqWH92nPqYewb6NVEbhZtNPwvUI=;
	b=MGYsuK2OT1bhcvlmnhzrM3LO07R/cufFkPFl9HQdnTegJ6fEAdxPEurgSgf7DsIoUsxawX
	ukcywsvoelhkWQIn6IbwxK7bfmfA+nxo1KxUXoQSOZJ3n4ihBilew0WY16u+7ntkgz+Bc+
	HKZnHCvKbY7T2w6QhUtSa9PeZIvWVPY=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-r5FjVxHeNCqMmGX1hWZnhw-1; Fri, 21 Nov 2025 12:12:40 -0500
X-MC-Unique: r5FjVxHeNCqMmGX1hWZnhw-1
X-Mimecast-MFC-AGG-ID: r5FjVxHeNCqMmGX1hWZnhw_1763745160
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-787e3b03cc2so33528277b3.1
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 09:12:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763745160; x=1764349960;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FRU2qLfbf/wNhvSHqqWH92nPqYewb6NVEbhZtNPwvUI=;
        b=BaM4FURFho95inxIJE3wLjXTPGVaqxckyLAAwav9y2yrPZD5QyCiJizSaOnDOjv5Gk
         xFhl/hrZdCCCSvldZVwJJlEMqKyFR2Ro4CRhZOd/0LBeVNjd90w2HIS140pX0/bFJUG7
         n0jcBV5BuKdGRVk67CABecWuRxxFK6SarFJVJslM9zlKZF7hq+Bub3q2Pno3+48uzmG1
         9SYDcjRu6mRO4We/P0lmNzqrkRXZZuvbx4wHiDWnZaH0mb+94GSTy6/VxLmZcwWlVdPe
         8Cd1AVl4a65Vt0y0KimPBCmtzN7W3SL365ebHDnQ3YfoeSaP5rkrudlkQ2qB+fvMAOp3
         bNzA==
X-Forwarded-Encrypted: i=1; AJvYcCXUlYXn9tYUEcAnt/b8CCzDG6g9UpWaJrWpjA3+XfxApuiQAAUTpsmUhevPxxLoPhJ7CCOn3dE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyfx2i80zadl77Mm08rqd1DtIqQdBdWmtlMIVsJT4VquhikV+fU
	DlWJ0SiP3R4NgqSYl4dSYYKvI/N6e3JXnQ+mYC/7JvB2hDo7Xct/irvxMzsPFNqW2wqrx3C5xU5
	lvrAkkcGC5BdDoLu6yi7H62OFhofe0VKKuAGo23YlLmRIeMAKjusfdQMbf1jji9LoAAkVSxuvsW
	bh1cCGEl8HFHXovp4fMcW6T+bzg8Ob0L0o
X-Gm-Gg: ASbGncvKCxHOzsn1BDW+xovqzjK1vy9rh2ZPgrXH3MhNBULGrrNxdsn0r/VpB+wr2Hd
	a/nSRB+GCLl9R293gkwz6s62mHqoExWbT1GlktOXH9WfSdNOfy437OG3RIueb3qRDq6TQ3AtluD
	3thSqIScN/eX11V9sUJigF9aNyFHi/mtZAyZqUbUHmoTmBh2QLOJKsIl8MB8/0XSNZ
X-Received: by 2002:a05:690c:4c09:b0:787:bf16:d489 with SMTP id 00721157ae682-78a8b5681a0mr24167027b3.62.1763745160075;
        Fri, 21 Nov 2025 09:12:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFJMtLvkeHiv5tBcVk8Zunn6fcLBfbMFj2OlEQ7sDWssH1e01yWoO2IMY4KicgI4AI0qMGjQLfshccde2mHq/o=
X-Received: by 2002:a05:690c:4c09:b0:787:bf16:d489 with SMTP id
 00721157ae682-78a8b5681a0mr24166847b3.62.1763745159764; Fri, 21 Nov 2025
 09:12:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn> <20251121081748.1443507-3-zhangshida@kylinos.cn>
In-Reply-To: <20251121081748.1443507-3-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 21 Nov 2025 18:12:28 +0100
X-Gm-Features: AWmQ_bnhlFe4bz2evbPrSI0Jb0EHnrWDpAVAemzJqi8jgCPnPPGI5CuseKDcbLY
Message-ID: <CAHc6FU7eL6Xuoc5dYjm9pYLr=akDH6ETow_yNPR0JpLGcz8QWw@mail.gmail.com>
Subject: Re: [PATCH 2/9] block: export bio_chain_and_submit
To: zhangshida <starzhangzsd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, zhangshida@kylinos.cn
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oiZeYMi7reIwyPRph0IKFTCfnOtHtbUf5rdoWukM0ZM_1763745160
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 9:27=E2=80=AFAM zhangshida <starzhangzsd@gmail.com>=
 wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/block/bio.c b/block/bio.c
> index 55c2c1a0020..a6912aa8d69 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -363,6 +363,7 @@ struct bio *bio_chain_and_submit(struct bio *prev, st=
ruct bio *new)
>         }
>         return new;
>  }
> +EXPORT_SYMBOL_GPL(bio_chain_and_submit);
>
>  struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
>                 unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
> --
> 2.34.1

Can this and the following patches please go in a separate patch
queue? It's got nothing to do with the bug.

Thanks,
Andreas

