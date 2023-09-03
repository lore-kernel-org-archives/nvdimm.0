Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9FD7F
	for <nvdimm@lists.linux.dev>; Sun,  3 Sep 2023 03:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693711594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TZR6UqSfyDVUdOMGlEnQu1srEV25P1bhKFmen9s1My0=;
	b=JHfNkXvcidMTlataxXdv6iU6RJiwQC5RJiyoDtw7cr0LFeeCymudioW2vKUezDVfJl5ut+
	YxOGZ8SKSh40KVliRc+pg0rKTYbkz/yMnCKQkId5knauC6f407ib1qh1Ethcdv2CyQe9dc
	bGgCfFEQRYjgsQVnVpm01IJ92+Rx6GE=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-RGKeaQ63OdiRDthBL9Jylw-1; Sat, 02 Sep 2023 23:26:32 -0400
X-MC-Unique: RGKeaQ63OdiRDthBL9Jylw-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3a7292a2a72so474319b6e.1
        for <nvdimm@lists.linux.dev>; Sat, 02 Sep 2023 20:26:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693711592; x=1694316392;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TZR6UqSfyDVUdOMGlEnQu1srEV25P1bhKFmen9s1My0=;
        b=fCMvwuHYBxII/+VUYNDQ08zj6vQWx5/EmRx1FfsGcgC80qgw3iC5QJFn5+aunr454c
         zVAsl2oPBRE3/f6alZe79bQu9tI/SGXwEBEg6ckqgUfKx6MZ7MST8MFtnWKmDLa4EyBc
         eAhbReSHD/wEQmxT4rm4Im8bBpOIqli9ui9bxQVFVIf6Ov/0BB/2S1dEPloP8fXxVSVD
         FsP+vgtIXZjhz9sSUd+7StP3heXCfHSHbuhGofVZGrHWbYjB0y/kXmEjM/QXN8fKKO1E
         DV25M0PqijIBTm+F0gko8wZppY7+u8VYPMjooAAasIFAzjtamiJw/csWY28m0Xwx0DN+
         eR4g==
X-Gm-Message-State: AOJu0Yxu/NHteg7ZjHp+A+D5EV/jEpD+ojOJz0QDpRBFaC0QmYQri7GX
	KD+wf7GPouEAdkLRToBvteiUbBRHfgE6lvI+fiy8J6Ebfa+I61Ep8Oli5CKIf+MJ+DOHQeR4dw6
	ZZerswBppTebk7SB7NTG2lgMgz2JE2zRi
X-Received: by 2002:a05:6808:1308:b0:3a7:b011:8960 with SMTP id y8-20020a056808130800b003a7b0118960mr9115798oiv.40.1693711592175;
        Sat, 02 Sep 2023 20:26:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHuP0qOl/h2uTVtTEjYCVaD2ep5xs4NccB7TrUchHjD0APd8UhXTisae12wfggdA+s41YM4TUxDqv1DDjKyOrk=
X-Received: by 2002:a05:6808:1308:b0:3a7:b011:8960 with SMTP id
 y8-20020a056808130800b003a7b0118960mr9115777oiv.40.1693711591959; Sat, 02 Sep
 2023 20:26:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230811170513.2300-1-colyli@suse.de> <20230811170513.2300-6-colyli@suse.de>
In-Reply-To: <20230811170513.2300-6-colyli@suse.de>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 3 Sep 2023 11:26:17 +0800
Message-ID: <CALTww2-KtrwjKSzMBwdgqwAcF5sSKNR3m=R2TMVuA7HscdeZqA@mail.gmail.com>
Subject: Re: [PATCH v7 5/6] badblocks: improve badblocks_check() for multiple
 ranges handling
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, 
	Geliang Tang <geliang.tang@suse.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, 
	NeilBrown <neilb@suse.de>, Vishal L Verma <vishal.l.verma@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 12, 2023 at 1:07=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
>
> This patch rewrites badblocks_check() with similar coding style as
> _badblocks_set() and _badblocks_clear(). The only difference is bad
> blocks checking may handle multiple ranges in bad tables now.
>
> If a checking range covers multiple bad blocks range in bad block table,
> like the following condition (C is the checking range, E1, E2, E3 are
> three bad block ranges in bad block table),
>   +------------------------------------+
>   |                C                   |
>   +------------------------------------+
>     +----+      +----+      +----+
>     | E1 |      | E2 |      | E3 |
>     +----+      +----+      +----+
> The improved badblocks_check() algorithm will divide checking range C
> into multiple parts, and handle them in 7 runs of a while-loop,
>   +--+ +----+ +----+ +----+ +----+ +----+ +----+
>   |C1| | C2 | | C3 | | C4 | | C5 | | C6 | | C7 |
>   +--+ +----+ +----+ +----+ +----+ +----+ +----+
>        +----+        +----+        +----+
>        | E1 |        | E2 |        | E3 |
>        +----+        +----+        +----+
> And the start LBA and length of range E1 will be set as first_bad and
> bad_sectors for the caller.
>
> The return value rule is consistent for multiple ranges. For example if
> there are following bad block ranges in bad block table,
>    Index No.     Start        Len         Ack
>        0          400          20          1
>        1          500          50          1
>        2          650          20          0
> the return value, first_bad, bad_sectors by calling badblocks_set() with

s/badblocks_set/badblocks_check/g

> different checking range can be the following values,
>     Checking Start, Len     Return Value   first_bad    bad_sectors
>                100, 100          0           N/A           N/A
>                100, 310          1           400           10
>                100, 440          1           400           10
>                100, 540          1           400           10
>                100, 600         -1           400           10
>                100, 800         -1           400           10
>
> In order to make code review easier, this patch names the improved bad
> block range checking routine as _badblocks_check() and does not change
> existing badblock_check() code yet. Later patch will delete old code of
> badblocks_check() and make it as a wrapper to call _badblocks_check().
> Then the new added code won't mess up with the old deleted code, it will
> be more clear and easier for code review.
>
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Geliang Tang <geliang.tang@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Vishal L Verma <vishal.l.verma@intel.com>
> Cc: Xiao Ni <xni@redhat.com>
> ---
>  block/badblocks.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 97 insertions(+)
>
> diff --git a/block/badblocks.c b/block/badblocks.c
> index 4f1434808930..3438a2517749 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -1270,6 +1270,103 @@ static int _badblocks_clear(struct badblocks *bb,=
 sector_t s, int sectors)
>         return rv;
>  }
>
> +/* Do the exact work to check bad blocks range from the bad block table =
*/
> +static int _badblocks_check(struct badblocks *bb, sector_t s, int sector=
s,
> +                           sector_t *first_bad, int *bad_sectors)
> +{
> +       int unacked_badblocks, acked_badblocks;
> +       int prev =3D -1, hint =3D -1, set =3D 0;
> +       struct badblocks_context bad;
> +       unsigned int seq;
> +       int len, rv;
> +       u64 *p;
> +
> +       WARN_ON(bb->shift < 0 || sectors =3D=3D 0);
> +
> +       if (bb->shift > 0) {
> +               sector_t target;
> +
> +               /* round the start down, and the end up */
> +               target =3D s + sectors;
> +               rounddown(s, bb->shift);
> +               roundup(target, bb->shift);

The same question here. It needs to set s and target?

> +               sectors =3D target - s;
> +       }
> +
> +retry:
> +       seq =3D read_seqbegin(&bb->lock);
> +
> +       p =3D bb->page;
> +       unacked_badblocks =3D 0;
> +       acked_badblocks =3D 0;
> +
> +re_check:
> +       bad.start =3D s;
> +       bad.len =3D sectors;
> +
> +       if (badblocks_empty(bb)) {
> +               len =3D sectors;
> +               goto update_sectors;
> +       }
> +
> +       prev =3D prev_badblocks(bb, &bad, hint);

Is it better to add check prev < 0 as setting and clearing badblocks?
If not, in the following overlap_front check, it'll have problems when
prev is -1. p[-1] will be the last one element of the array.

> +
> +       /* start after all badblocks */
> +       if ((prev + 1) >=3D bb->count && !overlap_front(bb, prev, &bad)) =
{
> +               len =3D sectors;
> +               goto update_sectors;
> +       }
> +
> +       if (overlap_front(bb, prev, &bad)) {
> +               if (BB_ACK(p[prev]))
> +                       acked_badblocks++;
> +               else
> +                       unacked_badblocks++;
> +
> +               if (BB_END(p[prev]) >=3D (s + sectors))
> +                       len =3D sectors;
> +               else
> +                       len =3D BB_END(p[prev]) - s;
> +
> +               if (set =3D=3D 0) {
> +                       *first_bad =3D BB_OFFSET(p[prev]);
> +                       *bad_sectors =3D BB_LEN(p[prev]);

Is it right to set bad_sectors with len?

> +                       set =3D 1;
> +               }
> +               goto update_sectors;
> +       }
> +
> +       /* Not front overlap, but behind overlap */
> +       if ((prev + 1) < bb->count && overlap_behind(bb, &bad, prev + 1))=
 {
> +               len =3D BB_OFFSET(p[prev + 1]) - bad.start;
> +               hint =3D prev + 1;
> +               goto update_sectors;
> +       }
> +
> +       /* not cover any badblocks range in the table */
> +       len =3D sectors;
> +
> +update_sectors:
> +       s +=3D len;
> +       sectors -=3D len;
> +
> +       if (sectors > 0)
> +               goto re_check;
> +
> +       WARN_ON(sectors < 0);
> +
> +       if (unacked_badblocks > 0)
> +               rv =3D -1;
> +       else if (acked_badblocks > 0)
> +               rv =3D 1;
> +       else
> +               rv =3D 0;
> +
> +       if (read_seqretry(&bb->lock, seq))
> +               goto retry;
> +
> +       return rv;
> +}
>
>  /**
>   * badblocks_check() - check a given range for bad sectors
> --
> 2.35.3
>

Reviewed-by: Xiao Ni <xni@redhat.com>

