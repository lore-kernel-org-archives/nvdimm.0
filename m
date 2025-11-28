Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1C9328B5C
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 13:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764335495; cv=none; b=cphm/SMkmmkcTfiaVEhuVIhfkHFbMg9054sqRh48NnWDsjDiX4rqDHXuxKvpwHWaZZhYzTY0mO4tooXw65O5XX2rBIC/vDr6kQPgLJ1PuHlsOcdOqjDH4H8WecHMfPq8cnj8A/6ctjn12x+VLXa1KEzAfqaSMH/RCS7UEZxe4yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764335495; c=relaxed/simple;
	bh=cT5VambQLzg4yYEkETS1DAEPp4cL0vkJ6BivaulYb7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VWrt8U/6vgGChEGm20T4gprTzXe6qS39bhJvIyymaTdUfwjZMulYr8DHiZJ0ZY8xWUkvENdHlEUegPLOUIgML5wnvX3nRbc0e3mES0NwkzbLlQ15+UrifRZ60oz+eqchhxpRImjzxRJ7tnh3nqqGANoI5nEar5jzwfgjcOgO2zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NIygpMCj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NIygpMCj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764335492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cDb8wvl+/S3cs8WDouA4IaIUDYl/lhw5kT6xFlbeDqo=;
	b=NIygpMCjROe06ApYalrjCwRGN6G2Tx+linFraEADItEpQw2KNmtseValASb2gjO06Aw76q
	n1FD02DdItSdCyNLrX400ubJ06v/7QuXk03zt3yYqPeTo2DW/sTEKRYaCG2V9XX/LqKz6H
	ia/Dj+q5XlYYmWUNeQDjF/EmM7g2jfs=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-neeyRcEAMWWCWJGo-61y3A-1; Fri, 28 Nov 2025 08:11:31 -0500
X-MC-Unique: neeyRcEAMWWCWJGo-61y3A-1
X-Mimecast-MFC-AGG-ID: neeyRcEAMWWCWJGo-61y3A_1764335490
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-63e35e48a1aso2084419d50.0
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 05:11:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764335490; x=1764940290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cDb8wvl+/S3cs8WDouA4IaIUDYl/lhw5kT6xFlbeDqo=;
        b=edAcp5LM+xofhYBcF+D17R7tooNJch/5B4vWuZikRh3aPLx52F5LxCuLGCyVQNJ00u
         jraDau6dTlXBQUE43hRBqpbx5rNrxExnUmM3NLQIcVlJ8qyKHmHy61kCovdfktgySk5R
         CRiIAmg3iF8utuoIVViRcVkhuocBbIWbOAr482ccDlmbd2of9GR1Wcv6pszU7/7aM+Yb
         vN0h6FA3//3LVPkPZXeLViCQWbVieLtEagFlX2+Vxdz6YVDSBKRkpNswMs/m52MT9T8W
         IH/u8SBrHFs6lErkOXfaSSszV8fXYFL1PsKpkXPPpTUrGq09X2VCbH2tLZB4nWWRooAZ
         dtJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVF1gUMrQOAFXKeRVOveTU85AP84vk9A0KdlTnmQHO2Lo+Zecr7a1NPGcz65WxcR8BqhRivUpg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKtGEvceAuH8wySYKjVYVficD1PFD+6oDvKbAT/GofxoV7EbPr
	LbtjOFYIaF3x2Cz03i+6CqFeHKjfQd2Hq+EWuHEwVVqMCDT6iXFAiUIfznq4tPT7Qyh92jPo+QN
	DX/VeOpm4u2++m8ylV6CjergOBpBFD1xKeW0DsZcBUVbwJ0KD8CzMuesKXFWik4Qrq+1st/4Q3n
	qXyP8jEYjkFmydEBkkX6LupO40Ku1Y0kSz
X-Gm-Gg: ASbGncub7KdUY+BWBTAwmeo6FnkLwCQ9upze8+EYM8lIXZj44nIxquP84x54eZNk4y/
	C/A8MDeb3sBvs7LxFfMvM831pdd1H0JuMwiJy2hI56TnJNKwJYRV/K59fHXIsqyXvZvY7/d6cMr
	990A6Ze2qscd1r7GyrXSkpotLnzzQaYQd8F5nPW2msxztk/JC+ehzNstD0TVRzyRlw
X-Received: by 2002:a05:690e:8d2:b0:63f:bd67:7c52 with SMTP id 956f58d0204a3-64302a48446mr15103911d50.29.1764335490415;
        Fri, 28 Nov 2025 05:11:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpYs6Bqkkw2QMj53nrShI4JIcUgw0aEZxMMPQ2h/FT8I7boFY7Ao7pNuY9j2sTWaBF/Hvop1CT06FKU/ZbYVo=
X-Received: by 2002:a05:690e:8d2:b0:63f:bd67:7c52 with SMTP id
 956f58d0204a3-64302a48446mr15103893d50.29.1764335490100; Fri, 28 Nov 2025
 05:11:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-3-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-3-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 28 Nov 2025 14:11:19 +0100
X-Gm-Features: AWmQ_bmMbDxUx7xf6l9s72idOADcxGPBv_GTFewzDFs5Yo-0xMy2x8K16_Wfsjs
Message-ID: <CAHc6FU43FWMYm2y2b9EvrFzsJdOn55s2QOMxCfRiHKVMVRqQaQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] block: prevent race condition on bi_status in __bio_chain_endio
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, siangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _-7SRYutdgrFFeovVnm2oSrwmv4-BCKcEz5IKSZNC_4_1764335490
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 9:32=E2=80=AFAM zhangshida <starzhangzsd@gmail.com>=
 wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Andreas point out that multiple completions can race setting
> bi_status.
>
> The check (parent->bi_status) and the subsequent write are not an
> atomic operation. The value of parent->bi_status could have changed
> between the time you read it for the if check and the time you write
> to it. So we use cmpxchg to fix the race, as suggested by Christoph.
>
> Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index 55c2c1a0020..aa43435c15f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -313,9 +313,12 @@ EXPORT_SYMBOL(bio_reset);
>  static struct bio *__bio_chain_endio(struct bio *bio)
>  {
>         struct bio *parent =3D bio->bi_private;
> +       blk_status_t *status =3D &parent->bi_status;
> +       blk_status_t new_status =3D bio->bi_status;
> +
> +       if (new_status !=3D BLK_STS_OK)
> +               cmpxchg(status, BLK_STS_OK, new_status);

This isn't wrong, but bi_status is explicitly set to 0 and compared
with 0 all over the place, so putting in BLK_STS_OK here doesn't
really help IMHO.

>
> -       if (bio->bi_status && !parent->bi_status)
> -               parent->bi_status =3D bio->bi_status;
>         bio_put(bio);
>         return parent;
>  }
> --
> 2.34.1
>

Thanks,
Andreas

