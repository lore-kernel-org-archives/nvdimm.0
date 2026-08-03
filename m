Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD9F296BCD
	for <nvdimm@lists.linux.dev>; Mon,  3 Aug 2026 13:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763303; cv=pass; b=AeR+dBBj6FaMSi4N/J+w26e6P1ctNPyyNuoqb/Qu0ocYxzKArU4flVt6GthVpj9xcSCOLyeySX3/o4mAZSjqha0xOAWDKWzyKBcYYo4dn/Q5KZywLmcYxeDXreGnG4HA+AxhnrkO/ExmcVuWT3BKHKXJD/3XrK8e6kBIobCcHwo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763303; c=relaxed/simple;
	bh=Pgl5mTcqFOqWGOQn2TZduStirxwuSm2pRwIjZSucJwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hlgh5VyIKDr5S7i1WTuZHAhKYf0y1/xzvkRuzPT6JbajBWz5d2dy4wATyacZAgEG3ZAGscI1Hrz2uL/PNDxv7hbFylhOA0qHsQ3aqQRBTfM4Kt60o2D36E0Mg/LojN+89K3ECFj1oJJyhxFSV5ZUzS+ZzUhM8QCFWgJtt8JgVK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AJdh2FVL; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AJdh2FVL"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-69f2c67650aso5274516a12.2
        for <nvdimm@lists.linux.dev>; Mon, 03 Aug 2026 06:21:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785763289; cv=none;
        d=google.com; s=arc-20260327;
        b=Xg7HEniVrtZ7M7i8tCjeA7TxUAIq4S1Ljsb6UZKQ/YBBF2Njf/oxEsLAVTQ1Dp7YNx
         UfSxRzz/jZq8A2BSQDPYfiiLIyLRG/zBHoBf3zOrUJET2NevEZkTd9YuhIbaEsOv9bE0
         LEsLyj7ChtRLJQ4OvaaBKK3DUwi+I4R+y0pSOF84uYpgU2X/Ro5JZwnkWADEFbwF5sRc
         uJxURAcH59aNqTm7hXpK16QPrX/sygSQsSPFlNzj3TQnm8aiDnPaGNHOMimYCinaVk64
         4Z1sXYCFp9Wc599YLObN6W2KdDhjZdEGHbdmLWGF4OUrp1b3BI9+ohWWvHLCLwWBIm/6
         ZbPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y/+lXFVTL8yRFLlIHwc83PXR9zbnjKq/x3zTQK5cH9A=;
        fh=rbM+LGzGeNQpqZD6y9WZuiPj5441Hjk4vlBiOWF/dY0=;
        b=bUEyVLTqE4yQOUQDcXcs9cw3vljg+ydUwsrk/2jkoxDU/q04P31mvAFmqprr3uv8Ad
         nCuc0uxpCE3N3/hKkw2nZ2DcUJ+ef4f2ARzDgT/JtrvbvW0kMUKRr/lVzHvxa0wrKX1J
         VbGyLOa7tkRkMXnwEo0OJAuDTGoL9mtk8FMACOhaVrHQxJQ/kKKltOa2SlJjkzQ7dCqz
         KS16tiFOuU12+PygDvj88r5ZlbLFlX8icMpGCLTxz7yQS2gvRi6UPn9U3eByUofOOT/G
         TkiNDq1zYtcggQMrjvTKOTKdHzy5UQ8/bjXNVBiYgOqkLHdQnv/VKG+kPQzjr0jyGPv3
         Fo7w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785763289; x=1786368089; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y/+lXFVTL8yRFLlIHwc83PXR9zbnjKq/x3zTQK5cH9A=;
        b=AJdh2FVL6gWbsWLNmfIk+ct1vGc/Asc90nSEqoScqLtt5vo9uy9sHuYQvAo4MHa6e2
         5dmwi45+/YxKX8pdMVQ6qha0VBD55vskwfTHjPQVDLStBltOhsf9bnI9mMbP9dkoRkrQ
         ATXkBlFhq+eW7CSRFEDQ1RG/0XYGGmLAZMqpr+9LMr5xTf2ptXVyLW9jVA9W8zYyLGDo
         97AoWbQSreA4iyUwOfShptGG2ULH8bcaBBi4nq3jyiDPMqMOwLCYA+C5PtCa/ZrLZhuI
         aqGu+cNuhY0ijoY1T3rPr0HvYkGi+nPmVgOGXEHrskmkv7zl4yWJ4urRBYsHH/7cnDa9
         CXGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785763289; x=1786368089;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y/+lXFVTL8yRFLlIHwc83PXR9zbnjKq/x3zTQK5cH9A=;
        b=kt/fD8mPX9o6+l2ZNaFzZpA/01ofq6VQaWa53yD2IAazH9/lJaCxz4JpS8WmW3eODT
         MCtU8TYO/ZPijWshHiv0wkBnisWO5YUhUOw7DtDiJwQs+nBBFSk6JKwdd5JSAVIkVrLO
         ApqFY2rPf7gtxWyhnG6gnj7V0PlzOlbLE+plWikCPyDh3guFN2HYMsL3p4IgsBEPsxNn
         gPxeidcdv9xPNbIyCchomoYr/cfdxM3Jn1tjs+e814quQYDSeqVdpsHatZ2WOsG4Tcu+
         5aHLiXlPx/3f8NaPGPmDWlokvlm3U4BsJ5v+BgbQbf0oDMYZ+BPNIxQ6JBMrnY9OvJBd
         AQfw==
X-Forwarded-Encrypted: i=1; AHgh+RqAMaSaQ4buRXIbC3icvTbvyt4qxHMikCkj0giwgnri9aLwSx7jTOfczR3GBM5b9ukVRO8dEco=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywy0nRiWORF3C/mRsnsojVfwzjqjBMg6bmvG3nqFDuXOVcGpmNV
	lKa+wFLuitxmEbkDJ8ziSJwpemsOUNT9F62rCo+4zvvTeUdUobPC/0RmB0Z9H7om+rhwuYuj8Ig
	D1Q4Ay0E1PyM5jeIDGE3xfRzY2nvIew==
X-Gm-Gg: AR+sD13xBB4ja1HkauXHdrfWfZn0LJhRl1KFk0SUuXlBpcd9pDWg2crbt9aPccksryv
	hG4Y4zH+1fWZVxKnko0npOtvEQ42/PSBzT3Hfiegu2eWeYFCY7+91YPUTPlIWTZLKb4Yh+cAZFi
	Mstrt+mDNVZbGs4f0iMtr1DJdmy28GjIRs7Ybq3V2ihS+h2GRNd9u8xVOdgyIOSC+5UlnSHLohx
	zyAZUOY5VqBA7mHNXNWRYe5laSEcM3YM1S9ITQiBXuDlnGq22hHj+Vb8GGMEu1bZ/9cd7aU1twK
	ZPe4dVDspeQHHxPW1H3YTvV9/k+Au+y2gwYysWyX1HloZoENz8/AWZXvqhhbxgqg/ZIeeym83ve
	zQkEAQwmnjAIzpNc=
X-Received: by 2002:a05:6402:21d9:b0:69c:794d:4862 with SMTP id
 4fb4d7f45d1cf-6a0a7c614f9mr7875783a12.7.1785763288576; Mon, 03 Aug 2026
 06:21:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785596451.git.asml.silence@gmail.com> <c1ab6c0db3853b339a89aee0b1a9c5ac0c48b79e.1785596451.git.asml.silence@gmail.com>
In-Reply-To: <c1ab6c0db3853b339a89aee0b1a9c5ac0c48b79e.1785596451.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 3 Aug 2026 18:50:50 +0530
X-Gm-Features: AUfX_mwnLWCAPfRurFp37qU73Xc2KDpD6en6Q3cA2kgelroMq6uNFVC_YKEZqSE
Message-ID: <CACzX3AvwBF32_ODomei3XHSZ=KtRaWLN-_Tfkwv7sV3Ssc3wmw@mail.gmail.com>
Subject: Re: [PATCH v5 02/16] iov_iter: add iterator type for dmabuf maps
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>, 
	William Power <william.power@intel.com>, Phil Cayton <phil.cayton@intel.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	David Sterba <dsterba@suse.com>, Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev, 
	nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 1, 2026 at 9:19=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
> @@ -841,7 +857,7 @@ static unsigned long iov_iter_alignment_bvec(const st=
ruct iov_iter *i)
>
>  unsigned long iov_iter_alignment(const struct iov_iter *i)
>  {
> -       if (likely(iter_is_ubuf(i))) {
> +       if (likely(iter_is_ubuf(i)) || iov_iter_is_dmabuf_map(i)) {
>                 size_t size =3D i->count;
>                 if (size)
>                         return ((unsigned long)i->ubuf + i->iov_offset) |=
 size;

dmabuf_map shares the same union slot as ubuf, so this reads the map
pointer as a user address. gap_alignment() below already returns 0
correctly for dmabuf - this should too. Checked the rest of this patch
(advance/revert/restore) - none of them dereference the union pointer
for dmabuf, so it's isolated to this one spot. Doesn't affect the
current series, nothing reaches this with a dmabuf iter yet.

> @@ -872,7 +888,7 @@ unsigned long iov_iter_gap_alignment(const struct iov=
_iter *i)
>         size_t size =3D i->count;
>         unsigned k;
>
> -       if (iter_is_ubuf(i))
> +       if (iter_is_ubuf(i) || iov_iter_is_dmabuf_map(i))
>                 return 0;
