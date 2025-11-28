Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C62232ABF6
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764334791; cv=none; b=G3LATZofczGR1Po0fkDJTWKs/ZjlQpIdjdPBz5e1vYaKWKLKJ9gtOgOknry97+n+hgweW1awezAWSnNZjgiiEJfMt/9UWx9fq7szPqgIj6sNEaemU5BzVyCGPbzeVlW7qnIrxhPbY6ZGyOgvDK4yTC3GjX2zQf2tmnGp+zZak9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764334791; c=relaxed/simple;
	bh=5QcOkFfFDyBXYDnDanyoo0Sx7zR4bMbvdaWPFSIL9Dk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bz6feMz7eIA8wFCLrthCNdvnO87bbnvw0cgRxFMw0dqa7FPtXD6NSXbhx6M3hUIyjaYabLVuRJGOvPcTOZaGE0QwLSUbveQhpQBPEGmq+CcgxPk7X0ujahtGhHpn6gWMkMKBgngr8FSZAMASM3VAZ/AImMSs9cb9DCoShMdj8F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T8pS4d1f; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T8pS4d1f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764334788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UbnViGm0SST3AIOO/NDK6ivARfPGgq8UL5FPgRGsaTs=;
	b=T8pS4d1fsn7qpHmykIofedKAKHqMnz7z2Bf20HHr2qMmMEBdhtGyDn36ahbecBKsPT3SYW
	K8AUU8mP2p5h8n2vBsSBM58V28eqr5oe1oMWGzdfO0vFT5S0J74SCPE77ImZE/GFGnu+p6
	fiOcJvJLFu5he4MzFdDh+bNCBIvEqXw=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-GGP5ngDPPWe2on75U3FM2w-1; Fri, 28 Nov 2025 07:59:47 -0500
X-MC-Unique: GGP5ngDPPWe2on75U3FM2w-1
X-Mimecast-MFC-AGG-ID: GGP5ngDPPWe2on75U3FM2w_1764334787
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-78aaf491ea9so21487227b3.2
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 04:59:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764334787; x=1764939587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UbnViGm0SST3AIOO/NDK6ivARfPGgq8UL5FPgRGsaTs=;
        b=r90AY/NdFQiBG6vZLllbJwUiV3L5Q4EdDtSmm6b7lLMTJqr4Mew7zdAZRg/0bywAjw
         o60Da48uH9hvTBEey9Q3zQ86i0a9Pw08uC5D2SRoOJix55oDJQbSokL5H1CGd40V96sG
         6+EDkfXrOB9AbXCTnK0lUt+EMXflygVf3CTNNFia7g96EOE7nWZMIYj0P2zqMX8rxdFM
         dKo6jsupRUuwnnv5MTr70vPq1AU/Sc2fwTUYhw6UHic5SbZsKk8yDRoN6fN9lI6aeQZ9
         iFZgTmpDskLq/FTCi/1v9QFPDYSwMRNNsoAyCoIF80pZWH/sOF4j3wtUaL1uMcfzlgqI
         K3xQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUWoNdGF953WPulp1IViKuBD3vgrQbCzeQF98eAmQWSyeuhFpuh/LbuQ7C/OxX19HmUMbM0tY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSCwyzIHb52gtTo9VzH7xZjehrMXSto67ezYdBjyTpcjE2vo34
	nFvycACKdBsoA+Gvx3x6u1Err24JMmrMQc2qJcSx2AuaI3fdSKEH5kCSOgR9rWAguU97PV/76d1
	aoTchzU5P4copN4FccpBH3kw9mkp6V7uGHClbunfH7Y5P9HW9VHESxi1SeHVJKSqLUBLqe5G0+v
	BHr7tfKKerdQKlUNS3EI8mAS0Ixfbt1TyIjjbd2msbKuTGgw==
X-Gm-Gg: ASbGnct8uoCkJiq7ACb4CLNh5Dxe7SodN4dI8dCYuy93EVyCr3uP2Ev4WiVTBYjdTes
	+YI/QkhUOd4lJRUFdTCu1d19A1RmcjMU9Me/meD+QWRD1SIdS1Axr26HJ8NbBcsG1iTKU1PpBk8
	rb3aJmI1aFrspIFjJFBrfrWQE5GjqZR8D9hhlaTdLuCxCH3De67FQc9WLeEuZaVPYG
X-Received: by 2002:a05:690c:6f03:b0:786:78ab:72d0 with SMTP id 00721157ae682-78a8b47a179mr234771287b3.7.1764334786912;
        Fri, 28 Nov 2025 04:59:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGesqVOsUJELcTkEGN3hauFQ6kd2TkNnYcjHT4c1bgANcOfukNB8/4Sre15bHJPI3DpWDPFXhJhMME6PGLKN8M=
X-Received: by 2002:a05:690c:6f03:b0:786:78ab:72d0 with SMTP id
 00721157ae682-78a8b47a179mr234770957b3.7.1764334786528; Fri, 28 Nov 2025
 04:59:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-3-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-3-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 28 Nov 2025 13:59:35 +0100
X-Gm-Features: AWmQ_bmJ3AOy1Ou64bzbzmfYJle8eXItasxBb4QbS7GrXBYKV503HxVqfGGmAks
Message-ID: <CAHc6FU6H22GEQTaOh4tm_=yL7CZ-Ck4EkXtmdsn_oyAW7OWB6g@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] block: prevent race condition on bi_status in __bio_chain_endio
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, siangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9CPMCB9KLCl7uqdSQRYoTC1ESdVnPY1Jv6dAIuJ8hzM_1764334787
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 9:32=E2=80=AFAM zhangshida <starzhangzsd@gmail.com>=
 wrote:>
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

