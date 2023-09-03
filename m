Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9E1623
	for <nvdimm@lists.linux.dev>; Sun,  3 Sep 2023 01:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693706207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NJRYhvJDKBaltmNYLDrfsqfnou2QTSqLmngVWzWMn8U=;
	b=YxlJG3njqwUjnpn03YqPvCTCvj0cfaUDT6MlO6DDa3brzHA8U9yQnPU5SdvxapcqFLybsy
	kTHMqyl+HpbQ0lL3PEggzrq99Y8oFmzil3EmD4AHxg15BOmJ7bZU5iEo7QaYkzHjhc8v9V
	yMikWKALRLa1GZZftctjh5XbWRFrwYk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-6526eESmMn6FSG3fJZjN5w-1; Sat, 02 Sep 2023 21:56:45 -0400
X-MC-Unique: 6526eESmMn6FSG3fJZjN5w-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-26d1f0d9b3fso531462a91.1
        for <nvdimm@lists.linux.dev>; Sat, 02 Sep 2023 18:56:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693706204; x=1694311004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NJRYhvJDKBaltmNYLDrfsqfnou2QTSqLmngVWzWMn8U=;
        b=LbXcnFVi/7txQ3HqkdU9YeIz5pjK2d4+l1pN0FzOB7ttCXOXf8CoxQF/8wt8QzarYw
         Loki8N78vjESADcs346irBdknOI4TeC7aU7JCNVFjSSn/Jhpr2okgkWCukLEb7snI6w0
         qigNVmWk2aBDogoY6OLCIpIr8a/r/BqFQvZB47UowDCBPzT5wCACXo/33ddVmCCR/spT
         rRrPizcRUWD0swdZ9jA9tq7DUcXKDoIJw0FC3Ot6FBsKjdCUQCnCuHEN3KNF3g9COLlO
         WAa7/AOq/HQuw5jfIrCKYc3vZeRH/+/uOspn+gyAf/BdmflaFXjsL4+3kCerTvgQDX+y
         Zfxw==
X-Gm-Message-State: AOJu0Yy+XxghSUsnlPk7d55rnKKHlAZWRpzXT/AVghwsV/7j5iwYLWEy
	C3MHPkeSeA04SRn6prydb2NUv4oYNwhmSuvW5IBhMuOuP001PEZsL5HZpXpjkueQdUbA387VDFB
	WFBqt50d65b5tm+3blb3KpnbTZ72DErgF
X-Received: by 2002:a17:90a:588e:b0:268:6339:318 with SMTP id j14-20020a17090a588e00b0026863390318mr5689974pji.30.1693706204576;
        Sat, 02 Sep 2023 18:56:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXf/oHLIUMLonJEklPqm4tMCsvxovZVxpcl1tq7mioMRZ1ITB8SA94Eod3IbYO2KjQPvaejfvSi+tjG0qD8No=
X-Received: by 2002:a17:90a:588e:b0:268:6339:318 with SMTP id
 j14-20020a17090a588e00b0026863390318mr5689959pji.30.1693706204223; Sat, 02
 Sep 2023 18:56:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230811170513.2300-1-colyli@suse.de> <20230811170513.2300-5-colyli@suse.de>
In-Reply-To: <20230811170513.2300-5-colyli@suse.de>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 3 Sep 2023 09:56:26 +0800
Message-ID: <CALTww2_50M_PD58Wb4j4qJ3OpDUQuFXs_iRNAbgCDc0V_cPPbQ@mail.gmail.com>
Subject: Re: [PATCH v7 4/6] badblocks: improve badblocks_clear() for multiple
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
> With the fundamental ideas and helper routines from badblocks_set()
> improvement, clearing bad block for multiple ranges is much simpler.
>
> With a similar idea from badblocks_set() improvement, this patch
> simplifies bad block range clearing into 5 situations. No matter how
> complicated the clearing condition is, we just look at the head part
> of clearing range with relative already set bad block range from the
> bad block table. The rested part will be handled in next run of the
> while-loop.
>
> Based on existing helpers added from badblocks_set(), this patch adds
> two more helpers,
> - front_clear()
>   Clear the bad block range from bad block table which is front
>   overlapped with the clearing range.
> - front_splitting_clear()
>   Handle the condition that the clearing range hits middle of an
>   already set bad block range from bad block table.
>
> Similar as badblocks_set(), the first part of clearing range is handled
> with relative bad block range which is find by prev_badblocks(). In most
> cases a valid hint is provided to prev_badblocks() to avoid unnecessary
> bad block table iteration.
>
> This patch also explains the detail algorithm code comments at beginning
> of badblocks.c, including which five simplified situations are
> categrized and how all the bad block range clearing conditions are
> handled by these five situations.
>
> Again, in order to make the code review easier and avoid the code
> changes mixed together, this patch does not modify badblock_clear() and
> implement another routine called _badblock_clear() for the improvement.
> Later patch will delete current code of badblock_clear() and make it as
> a wrapper to _badblock_clear(), so the code change can be much clear for
> review.
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
>  block/badblocks.c | 325 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 325 insertions(+)
>
> diff --git a/block/badblocks.c b/block/badblocks.c
> index 010c8132f94a..4f1434808930 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -330,6 +330,123 @@
>   * avoided. In my test with the hint to prev_badblocks(), except for the=
 first
>   * loop, all rested calls to prev_badblocks() can go into the fast path =
and
>   * return correct bad blocks table index immediately.
> + *
> + *
> + * Clearing a bad blocks range from the bad block table has similar idea=
 as
> + * setting does, but much more simpler. The only thing needs to be notic=
ed is
> + * when the clearing range hits middle of a bad block range, the existin=
g bad
> + * block range will split into two, and one more item should be added in=
to the
> + * bad block table. The simplified situations to be considered are, (The=
 already
> + * set bad blocks ranges in bad block table are naming with prefix E, an=
d the
> + * clearing bad blocks range is naming with prefix C)
> + *
> + * 1) A clearing range is not overlapped to any already set ranges in ba=
d block
> + *    table.
> + *    +-----+         |          +-----+         |          +-----+
> + *    |  C  |         |          |  C  |         |          |  C  |
> + *    +-----+         or         +-----+         or         +-----+
> + *            +---+   |   +----+         +----+  |  +---+
> + *            | E |   |   | E1 |         | E2 |  |  | E |
> + *            +---+   |   +----+         +----+  |  +---+
> + *    For the above situations, no bad block to be cleared and no failur=
e
> + *    happens, simply returns 0.
> + * 2) The clearing range hits middle of an already setting bad blocks ra=
nge in
> + *    the bad block table.
> + *            +---+
> + *            | C |
> + *            +---+
> + *     +-----------------+
> + *     |         E       |
> + *     +-----------------+
> + *    In this situation if the bad block table is not full, the range E =
will be
> + *    split into two ranges E1 and E2. The result is,
> + *     +------+   +------+
> + *     |  E1  |   |  E2  |
> + *     +------+   +------+
> + * 3) The clearing range starts exactly at same LBA as an already set ba=
d block range
> + *    from the bad block table.
> + * 3.1) Partially covered at head part
> + *         +------------+
> + *         |     C      |
> + *         +------------+
> + *         +-----------------+
> + *         |         E       |
> + *         +-----------------+
> + *    For this situation, the overlapped already set range will update t=
he
> + *    start LBA to end of C and shrink the range to BB_LEN(E) - BB_LEN(C=
). No
> + *    item deleted from bad block table. The result is,
> + *                      +----+
> + *                      | E1 |
> + *                      +----+
> + * 3.2) Exact fully covered
> + *         +-----------------+
> + *         |         C       |
> + *         +-----------------+
> + *         +-----------------+
> + *         |         E       |
> + *         +-----------------+
> + *    For this situation the whole bad blocks range E will be cleared an=
d its
> + *    corresponded item is deleted from the bad block table.
> + * 4) The clearing range exactly ends at same LBA as an already set bad =
block
> + *    range.
> + *                   +-------+
> + *                   |   C   |
> + *                   +-------+
> + *         +-----------------+
> + *         |         E       |
> + *         +-----------------+
> + *    For the above situation, the already set range E is updated to shr=
ink its
> + *    end to the start of C, and reduce its length to BB_LEN(E) - BB_LEN=
(C).
> + *    The result is,
> + *         +---------+
> + *         |    E    |
> + *         +---------+
> + * 5) The clearing range is partially overlapped with an already set bad=
 block
> + *    range from the bad block table.
> + * 5.1) The already set bad block range is front overlapped with the cle=
aring
> + *    range.
> + *         +----------+
> + *         |     C    |
> + *         +----------+
> + *              +------------+
> + *              |      E     |
> + *              +------------+
> + *   For such situation, the clearing range C can be treated as two part=
s. The
> + *   first part ends at the start LBA of range E, and the second part st=
arts at
> + *   same LBA of range E.
> + *         +----+-----+               +----+   +-----+
> + *         | C1 | C2  |               | C1 |   | C2  |
> + *         +----+-----+         =3D=3D=3D>  +----+   +-----+
> + *              +------------+                 +------------+
> + *              |      E     |                 |      E     |
> + *              +------------+                 +------------+
> + *   Now the first part C1 can be handled as condition 1), and the secon=
d part C2 can be
> + *   handled as condition 3.1) in next loop.
> + * 5.2) The already set bad block range is behind overlaopped with the c=
learing
> + *   range.
> + *                 +----------+
> + *                 |     C    |
> + *                 +----------+
> + *         +------------+
> + *         |      E     |
> + *         +------------+
> + *   For such situation, the clearing range C can be treated as two part=
s. The
> + *   first part C1 ends at same end LBA of range E, and the second part =
starts
> + *   at end LBA of range E.
> + *                 +----+-----+                 +----+    +-----+
> + *                 | C1 | C2  |                 | C1 |    | C2  |
> + *                 +----+-----+  =3D=3D=3D>           +----+    +-----+
> + *         +------------+               +------------+
> + *         |      E     |               |      E     |
> + *         +------------+               +------------+
> + *   Now the first part clearing range C1 can be handled as condition 4)=
, and
> + *   the second part clearing range C2 can be handled as condition 1) in=
 next
> + *   loop.
> + *
> + *   All bad blocks range clearing can be simplified into the above 5 si=
tuations
> + *   by only handling the head part of the clearing range in each run of=
 the
> + *   while-loop. The idea is similar to bad blocks range setting but muc=
h
> + *   simpler.
>   */
>
>  /*
> @@ -946,6 +1063,214 @@ static int _badblocks_set(struct badblocks *bb, se=
ctor_t s, int sectors,
>         return rv;
>  }
>
> +/*
> + * Clear the bad block range from bad block table which is front overlap=
ped
> + * with the clearing range. The return value is how many sectors from an
> + * already set bad block range are cleared. If the whole bad block range=
 is
> + * covered by the clearing range and fully cleared, 'delete' is set as 1=
 for
> + * the caller to reduce bb->count.
> + */
> +static int front_clear(struct badblocks *bb, int prev,
> +                      struct badblocks_context *bad, int *deleted)
> +{
> +       sector_t sectors =3D bad->len;
> +       sector_t s =3D bad->start;
> +       u64 *p =3D bb->page;
> +       int cleared =3D 0;
> +
> +       *deleted =3D 0;
> +       if (s =3D=3D BB_OFFSET(p[prev])) {
> +               if (BB_LEN(p[prev]) > sectors) {
> +                       p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]) + sectors,
> +                                         BB_LEN(p[prev]) - sectors,
> +                                         BB_ACK(p[prev]));
> +                       cleared =3D sectors;
> +               } else {
> +                       /* BB_LEN(p[prev]) <=3D sectors */
> +                       cleared =3D BB_LEN(p[prev]);
> +                       if ((prev + 1) < bb->count)
> +                               memmove(p + prev, p + prev + 1,
> +                                      (bb->count - prev - 1) * 8);
> +                       *deleted =3D 1;
> +               }
> +       } else if (s > BB_OFFSET(p[prev])) {
> +               if (BB_END(p[prev]) <=3D (s + sectors)) {
> +                       cleared =3D BB_END(p[prev]) - s;
> +                       p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]),
> +                                         s - BB_OFFSET(p[prev]),
> +                                         BB_ACK(p[prev]));
> +               } else {
> +                       /* Splitting is handled in front_splitting_clear(=
) */
> +                       BUG();
> +               }
> +       }
> +
> +       return cleared;
> +}
> +
> +/*
> + * Handle the condition that the clearing range hits middle of an alread=
y set
> + * bad block range from bad block table. In this condition the existing =
bad
> + * block range is split into two after the middle part is cleared.
> + */
> +static int front_splitting_clear(struct badblocks *bb, int prev,
> +                                 struct badblocks_context *bad)
> +{
> +       u64 *p =3D bb->page;
> +       u64 end =3D BB_END(p[prev]);
> +       int ack =3D BB_ACK(p[prev]);
> +       sector_t sectors =3D bad->len;
> +       sector_t s =3D bad->start;
> +
> +       p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]),
> +                         s - BB_OFFSET(p[prev]),
> +                         ack);
> +       memmove(p + prev + 2, p + prev + 1, (bb->count - prev - 1) * 8);
> +       p[prev + 1] =3D BB_MAKE(s + sectors, end - s - sectors, ack);
> +       return sectors;
> +}
> +
> +/* Do the exact work to clear bad block range from the bad block table *=
/
> +static int _badblocks_clear(struct badblocks *bb, sector_t s, int sector=
s)
> +{
> +       struct badblocks_context bad;
> +       int prev =3D -1, hint =3D -1;
> +       int len =3D 0, cleared =3D 0;
> +       int rv =3D 0;
> +       u64 *p;
> +
> +       if (bb->shift < 0)
> +               /* badblocks are disabled */
> +               return 1;
> +
> +       if (sectors =3D=3D 0)
> +               /* Invalid sectors number */
> +               return 1;
> +
> +       if (bb->shift) {
> +               sector_t target;
> +
> +               /* When clearing we round the start up and the end down.
> +                * This should not matter as the shift should align with
> +                * the block size and no rounding should ever be needed.
> +                * However it is better the think a block is bad when it
> +                * isn't than to think a block is not bad when it is.
> +                */
> +               target =3D s + sectors;
> +               roundup(s, bb->shift);
> +               rounddown(target, bb->shift);

It should be something like this?
s =3D roundup(s, bb->shift);
target =3D rounddown(target, bb->shift);

And patch 3/7 has the same problem.

> +               sectors =3D target - s;
> +       }
> +
> +       write_seqlock_irq(&bb->lock);
> +
> +       bad.ack =3D true;
> +       p =3D bb->page;
> +
> +re_clear:
> +       bad.start =3D s;
> +       bad.len =3D sectors;
> +
> +       if (badblocks_empty(bb)) {
> +               len =3D sectors;
> +               cleared++;
> +               goto update_sectors;
> +       }
> +
> +
> +       prev =3D prev_badblocks(bb, &bad, hint);
> +
> +       /* Start before all badblocks */
> +       if (prev < 0) {
> +               if (overlap_behind(bb, &bad, 0)) {
> +                       len =3D BB_OFFSET(p[0]) - s;
> +                       hint =3D 0;
> +               } else {
> +                       len =3D sectors;
> +               }
> +               /*
> +                * Both situations are to clear non-bad range,
> +                * should be treated as successful
> +                */
> +               cleared++;
> +               goto update_sectors;
> +       }
> +
> +       /* Start after all badblocks */
> +       if ((prev + 1) >=3D bb->count && !overlap_front(bb, prev, &bad)) =
{
> +               len =3D sectors;
> +               cleared++;
> +               goto update_sectors;
> +       }
> +
> +       /* Clear will split a bad record but the table is full */
> +       if (badblocks_full(bb) && (BB_OFFSET(p[prev]) < bad.start) &&
> +           (BB_END(p[prev]) > (bad.start + sectors))) {
> +               len =3D sectors;
> +               goto update_sectors;
> +       }
> +
> +       if (overlap_front(bb, prev, &bad)) {
> +               if ((BB_OFFSET(p[prev]) < bad.start) &&
> +                   (BB_END(p[prev]) > (bad.start + bad.len))) {
> +                       /* Splitting */
> +                       if ((bb->count + 1) < MAX_BADBLOCKS) {
> +                               len =3D front_splitting_clear(bb, prev, &=
bad);
> +                               bb->count +=3D 1;
> +                               cleared++;
> +                       } else {
> +                               /* No space to split, give up */
> +                               len =3D sectors;
> +                       }
> +               } else {
> +                       int deleted =3D 0;
> +
> +                       len =3D front_clear(bb, prev, &bad, &deleted);
> +                       bb->count -=3D deleted;
> +                       cleared++;
> +                       hint =3D prev;
> +               }
> +
> +               goto update_sectors;
> +       }
> +
> +       /* Not front overlap, but behind overlap */
> +       if ((prev + 1) < bb->count && overlap_behind(bb, &bad, prev + 1))=
 {
> +               len =3D BB_OFFSET(p[prev + 1]) - bad.start;
> +               hint =3D prev + 1;
> +               /* Clear non-bad range should be treated as successful */
> +               cleared++;
> +               goto update_sectors;
> +       }
> +
> +       /* Not cover any badblocks range in the table */
> +       len =3D sectors;
> +       /* Clear non-bad range should be treated as successful */
> +       cleared++;
> +
> +update_sectors:
> +       s +=3D len;
> +       sectors -=3D len;
> +
> +       if (sectors > 0)
> +               goto re_clear;
> +
> +       WARN_ON(sectors < 0);
> +
> +       if (cleared) {
> +               badblocks_update_acked(bb);
> +               set_changed(bb);
> +       }
> +
> +       write_sequnlock_irq(&bb->lock);
> +
> +       if (!cleared)
> +               rv =3D 1;
> +
> +       return rv;
> +}
> +
> +
>  /**
>   * badblocks_check() - check a given range for bad sectors
>   * @bb:                the badblocks structure that holds all badblock i=
nformation
> --
> 2.35.3
>

Reviewed-by: Xiao Ni <xni@redhat.com>

