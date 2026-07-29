Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513C746982B
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785344013; cv=pass; b=DswkGs//35FF+E8OeSjBvATVmcYy1KDwafuupgwbcThN8fvkfZb2Q29PLxaewkv3vhSLcNWAvZZQcUvnfC6uy21jSw4NIzUQBBiYaWKA6dS8zasc8LqyhJgwgUd7zoUn4QKYueM71LqCfN9jmvzSxi8hYpOdtdrJrPnv0SbQuzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785344013; c=relaxed/simple;
	bh=/YYV8EJ3uAY8vVlHWLu4xPFSaaoxJidP5IaWXw3aYyM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qPK/ede2tgN+1tuX+5oa+I7nF5UvTSn7RtKGSLv80gx5Cw+klC8wmgOF8LRmGyKU6xkkgCAOBBvpCH0Fjy41rixy3k10JSnjfSLGv7alu2240KN7gJy+Y4BBY+KXj2Q1tgXukB+JeoE/3PnQCx1pR/4g0MtPF5qL9WsNSgO5sjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VUa4DUnL; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VUa4DUnL"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-69fab5a852cso1789415a12.0
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 09:53:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785344010; cv=none;
        d=google.com; s=arc-20260327;
        b=m4FDkUYIh0HnUnPDNbCaUIfBRN4gyuW5z2XSr4FMz9jseS5c+BuNWJxITmqk5WeSMk
         kgwqDwPlwM1bh3MbCV9rIZqbWbAzWhyCdUush1p3Pu1V7AWiJgwm493sc4KXzVIKJdWR
         tzQL1bvOuVpwNWxXx1+4JTxJGAt1jnp1XbYjIfmBQTrQloJnWgXChtcARw1iPU6t0xvd
         Hl2AkX9CMjXuIlZK6/Fu59o6pNCDTjoL7RNjSSiGpBtzc6hXCclEha7efKdutBv+GoEw
         5cPrl0lg1COGoEHWDoh7Ki5EqXmMnMQyL/9STUeTMFLNVqLqY5qN65bokphE5PAEF8gy
         nRIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iRO7Ed4PohyaBZ/SmZ+npcgI12Qnh1MLhDgk3TF8jow=;
        fh=eBEjEhZxW/zDuuicONMvQPQTpoGN3dbqmJSUhgwV6/g=;
        b=dgnmlDHyWugspm/ercszX/1mpjnWuKDhPih+l48xzQHi9kgij0S++aJnWo4EwP2046
         Vbh+rH0w5oam79E8H1rsAakKiSFlwscJ7DjmehHo+p/DxcHQo0rA/whfpimNiipVwH2Y
         qGz533x8FV7jydY0ywNy2+B49lJgW8pNYsfXBbVu09uHUtL9GHoDVOTIotax4JAWOUOR
         zbgcUmyrabr0/uqwIqdeuEWRK+p5AIrPwfWJ6wgOUO8lg0kfxFe84xCKrDkFQR+aFvfD
         OYKCARJp1YFbNvNuzG4cUpRXWYc10vXmiCw16WDQN3fbzU1q4ITXvwA0z1EdgYKLxqJh
         2Qmg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785344010; x=1785948810; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iRO7Ed4PohyaBZ/SmZ+npcgI12Qnh1MLhDgk3TF8jow=;
        b=VUa4DUnLOwJAp82inCc5111as4d7Rzd6+gfIcgYZuvD7N3LxnAEVrC8pF39WkiOvC+
         ujWnUdzylfe3EpXq7pn7nCaKWaKpnH1p4XA92UD3ySyLNtJ/yYiCifn9h8t6h7H7CspD
         jivcyuzaEm3hQUoqqQRglqMyBkC1Vw+MMEyApLtqi/B/f/1BJVFoTU/BTcfvKLlTra/f
         Hh0AgDmUz71FovxMAFbdUlq7pf80NZXyQok51gyGvIP0wvIrOffGeQN7D3HY0ZJamY38
         WxL5rerGJ/MT91+LsZGpsipmxMm+qpLhfwmStKqLAF2gmoMM0hcG9ZCinyzfXXZnHA8T
         mB5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785344010; x=1785948810;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iRO7Ed4PohyaBZ/SmZ+npcgI12Qnh1MLhDgk3TF8jow=;
        b=GS6r5VlYtuHlnOmcrezlo7AM8sFvu2Y1W0hRYGnqBWoz4JwmofrIJTWsw1qNiqEPhj
         5JsGEFSwc6bax3pFEYdROrmfPxn2IvpJwWxyuLfV1A4XHstL0tXkbMLSbfWzoOoUtjNH
         lyPLYYXWHkm3BrW4uHNyZ/mlAK7JjbHSUMQO9yu5UIqCwiFxjhUueuqGf7cN5iD0x0Id
         Zjz9WCo073dP/LSd4irlX9Dztwu5kxkpHDmjETiJJNbG0aZOuKdIO7CXIP/xs7nb611H
         szhbrW7voVO/vMmpc9bh47dyTCKK4UEsUh273NlaYptVGFuBsuJ3u2lUD1rYZJ+z+Z51
         CYog==
X-Forwarded-Encrypted: i=1; AHgh+RpNo0AsugSA3POLE+XL+YfT/ye0u9+0Uwcf1ioOOUZhjHh24xSAxjZFNI5JIyV0UkHyPVp/Ces=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2Xr5ZcgmXj7rxm/dg8X8drq41qVCt1zu882rcP1cBIbgsjE9s
	ZDAmSdrHgq/vKM5C5FaRJF8B7+CZchbKxE/soVzP+FTQXJxjehOXQcz/gy49MRU2DpcRomYfboq
	VALVA5GcvgcAZp8eX7UCao9iOTAU+YA==
X-Gm-Gg: AR+sD12eKzrzBib+1CgxCC93pOS3qACCV4c4z7N99bfZal66iiR2lBWQqrUmQgnYX9d
	qJrqK6CbY4Cnlw31hWf6whLBYWH+/AJgZ0Hb5sONTpr0F8miVzPhhcZblCzMDJVUVks5rw44TbR
	3hYvnV3LTwBHdLi4eGGUELQ59CKMLqV3o14vAbatw2uAD/KVHmHNSPZeJWhuGPmp4/hWWXu2D7B
	GJ8fEAIdYdQwHkcC6M/A2MM8vOF6pcEc4E8mF8kyW/wTLUyU0mn/rhqF2+QyDzPiF6Rckzmp9n2
	kbYBjO7I4A/pyp7cyLzxwrSscSndpbn9tjoUxX7sOV8UoVg6rveF2++ZQN7A5PvVuELmyPvSY2V
	P3KUVLEHOH3WvsLEXxg==
X-Received: by 2002:a05:6402:5018:b0:698:ae69:3992 with SMTP id
 4fb4d7f45d1cf-6a0349ec697mr4404066a12.16.1785344009469; Wed, 29 Jul 2026
 09:53:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785274111.git.asml.silence@gmail.com> <CGME20260728213020epcas5p1721e72ba5544abf0b61482da005120d9@epcas5p1.samsung.com>
 <26dcd0ae5c87a3ada5710b14b6894ef343cec6fe.1785274111.git.asml.silence@gmail.com>
 <583fdfb2-5368-467f-a388-6d388859c995@samsung.com> <0df2f832-e8a8-4fdd-a5b6-e08657c2891f@gmail.com>
In-Reply-To: <0df2f832-e8a8-4fdd-a5b6-e08657c2891f@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 29 Jul 2026 22:22:50 +0530
X-Gm-Features: AUfX_mw2n1ETd8ASN5Vcu4oMSqcqp6oKyV0zFdoD8l7zvxibNrqO80gPOx-5lV8
Message-ID: <CACzX3Atj+hJmF+Au1Yw5KMk--EHy_J=7Yof1aQNkUV0hCrdVEA@mail.gmail.com>
Subject: Re: [PATCH v4 14/14] io_uring/rsrc: add dmabuf backed registered buffers
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: "Anuj Gupta/Anuj Gupta" <anuj20.g@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Sumit Semwal <sumit.semwal@linaro.org>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, David Sterba <dsterba@suse.com>, 
	Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 29, 2026 at 7:37=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
> >> +static int io_import_dmabuf(struct io_kiocb *req,
> >> +                       int ddir, struct iov_iter *iter,
> >> +                       struct io_mapped_ubuf *imu,
> >> +                       size_t len, size_t offset,
> >> +                       unsigned issue_flags)
> >> +{
> >> +    struct io_regbuf_dma *db =3D imu->priv;
> >> +    struct dma_buf_io_map *map;
> >> +
> >> +    if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
> >> +            return -EOPNOTSUPP;
> >> +    if (!len)
> >> +            return -EFAULT;
> >> +    if (req->file !=3D db->target_file)
> >> +            return -EBADF;
> >> +
> >> +    if (req->flags & REQ_F_DROP_DMABUF) {
> >> +            map =3D req->dmabuf_map;
> >> +            goto init_iter;
> >> +    }
> >
> > O_DIRECT is checked only during registration; we should recheck
> > (file->f_flags & O_DIRECT) per request.
>
> Nobody should be able to clear O_DIRECT, unless I missed something?
> And fwiw, io_uring wouldn't be the right place to do it.
>

fcntl(fd, F_SETFL, flags & ~O_DIRECT) on an already registered, already
open fd succeeds. The consequence is that subsequent I/Os switch to
buffered I/O and cause silent data loss. Something on this path needs
to reject this combination.

> --
> Pavel Begunkov
>
>
