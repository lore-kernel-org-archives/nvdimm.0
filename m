Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F6C32B993
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 12:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764334697; cv=none; b=hCK/svTEKBtUa7LTyofiuG1otCl95JbwWvjUnDnczGnf00B1ElRQQDbrhiIob8DJun/U5dSlUNOAOQRGmYht49V9HGu1gGeGfh12hWJO2gEx2zkWqF4HpDAvfIzS6SnVhhAT5QSFq6Dje8T+zZOHZYA1/Sm9FqNU3VaznXtzCxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764334697; c=relaxed/simple;
	bh=MuFoqSXPuLC7mZdpb7+pS1mI6Pzog4fHqbrI6/r2Fik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bk7ncsfOMFUtalOG0aibAjzWws7AD2y6bQoeoMmGW/RMLDmENhTV5QlRfgQIQXHLvx8y8IOku9enN+jG/Imo0D5fCVyo71yZDM1RN2WGioJB1quvaUpxstIGAgdxFvCpuupGZtE0718tPq5ZoIV2bKZA0YCr/KyzghFwOgw8f4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OzpsowL6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OzpsowL6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764334695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nNammxq+ggHJRHkPcyBw0qZgJjTAIfnPB/5V2CCXd5w=;
	b=OzpsowL6yPT1JSgla0yLUk+g0N8oBkW7t63Y4p2VCt2tC//6fHsLY6rLcmpEAE9RaRVESa
	5+fHC8CZFSeQYg7M0a2WxkGal3w8mnivocM1k8frNGjRWxyHqmSa023n9piAkW+SRjl30R
	7jOp7k7F7zOix9D4oXhhlKXixYFpiiM=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-K8p7iapEOCquG0LY3dcsow-1; Fri, 28 Nov 2025 07:58:11 -0500
X-MC-Unique: K8p7iapEOCquG0LY3dcsow-1
X-Mimecast-MFC-AGG-ID: K8p7iapEOCquG0LY3dcsow_1764334691
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-787c609417aso14464707b3.2
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 04:58:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764334691; x=1764939491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nNammxq+ggHJRHkPcyBw0qZgJjTAIfnPB/5V2CCXd5w=;
        b=n/rZX/vWCxlyWZT0BfYppNFbYr05TDxle4WzimH2nIgKgLV7/IqGBCSqzD8QaSxwDn
         vVynBRXIAJVU8P9zNoyimNCK88NVaug8TWxXIzEo5HuHyVTvZDmjzQCz+/xU2vW2aLtj
         hKoQEI+9f0WD6ETKyD0iafrEivVhriotUecQ+2iie5KJq5V0kEuqanF+Pq6shzT6Pn94
         7xcNFKWr1lUKKPCb2LGBExfWuSZNSmkvHMcfWJnnzCQcUhKUdCCxQI/C0dwfsrxJEEuV
         okqaJsUabh+0X39TS78+fD5mi+C1yOhsV7ZwWfnj99aPC4Pxc3tdFSmy4QIUpy4afRIX
         f7fg==
X-Forwarded-Encrypted: i=1; AJvYcCW41kpU8Zqjb3uXmHiUy1thGQngMKHvBxc8+0sZecGWheq+l8V+daXvvIiQn3SYFRM8L1e3J6M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yws6Dx0AmHscYZV4Ph7T2Jqij2LR1hxDzVIrkAaxT1z99acr4vg
	rV6ju2gK8835NNAwYiafpv7Tyar0VlT65x6nSEYnDGYJYTsKYT5LfcgjW8UHvPoVjq/AGK6OEgL
	UvN95OWX46iTBA3DtlxbRZ6gGJ3BwekXkjXhXos25sKdVM+XBOY5afDJwZqW+fSrV1dFcnADgIH
	h/c++Xww6XjJYJ3wHHFbASmlJndtvKiBx8
X-Gm-Gg: ASbGnctxpo5HNr8j723JTLwrO6JWIKKMzG6bzdccHFQg2KZ8uS5oqq3r9cfEiEkJFVZ
	VzZ/qhUyCcD+2s+zljbf9fAHtMLF0CQ3uztBQZAwblCFq/g1dILJaCaxtxbohWiqOsfNAo0jb9k
	VzYSfx/2c4tSlbT4szK87q6pRb/Bt/4REurhsIAdWWfsf1zzowbrTtJ2MjbwbvZEED
X-Received: by 2002:a05:690c:4c12:b0:786:68da:26d6 with SMTP id 00721157ae682-78a8b47f539mr225392547b3.2.1764334691008;
        Fri, 28 Nov 2025 04:58:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6o2vx3XDXGg+LlkIovRC1qPDpHivJwIyySPFZW+LOu2PT9QpULnJt3ZozP3PJjgQPuJtToIp2pCOkRf4ONwA=
X-Received: by 2002:a05:690c:4c12:b0:786:68da:26d6 with SMTP id
 00721157ae682-78a8b47f539mr225392307b3.2.1764334690627; Fri, 28 Nov 2025
 04:58:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-5-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-5-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 28 Nov 2025 13:57:59 +0100
X-Gm-Features: AWmQ_bkpqINzOqnBww77x7L-xnpoIyN1fhsiEmRMn1madN6s7Ak0j6O_sI0bIl0
Message-ID: <CAHc6FU6dmK1udCgj9vMj1ew-4+bZOK7BA47kyEgONEwGg42veg@mail.gmail.com>
Subject: Re: [PATCH v2 04/12] block: prohibit calls to bio_chain_endio
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, siangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mpCUkP--J0aIbBa7bGZbDvO7EJytYmKqt_3KsOl8c4k_1764334691
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 9:33=E2=80=AFAM zhangshida <starzhangzsd@gmail.com>=
 wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Now that all potential callers of bio_chain_endio have been
> eliminated, completely prohibit any future calls to this function.
>
> Suggested-by: Ming Lei <ming.lei@redhat.com>
> Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/block/bio.c b/block/bio.c
> index aa43435c15f..2473a2c0d2f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -323,8 +323,13 @@ static struct bio *__bio_chain_endio(struct bio *bio=
)
>         return parent;
>  }
>
> +/**
> + * This function should only be used as a flag and must never be called.
> + * If execution reaches here, it indicates a serious programming error.
> + */
>  static void bio_chain_endio(struct bio *bio)
>  {
> +       BUG_ON(1);

The below call is dead code and should be removed. With that, nothing
remains of the first patch in this queue ("block: fix incorrect logic
in bio_chain_endio") and that patch can be dropped.

>         bio_endio(bio);
>  }
>
> --
> 2.34.1
>

Thanks,
Andreas

