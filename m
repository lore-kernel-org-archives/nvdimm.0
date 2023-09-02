Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB6E3C24
	for <nvdimm@lists.linux.dev>; Sat,  2 Sep 2023 14:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693664523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q0MEcVRB3Kv8Ca24dEWgECSqsy0wPzPeJFLMYREmpig=;
	b=dzZEeVuInf+L2UluIY7peYEB24IVOY6ZS2ObhyIcfBCnfkWtWROYXmErfMpmu8l5uJDR8x
	cKNGCP5W2HZ7gL7e7qPV4RU/UJPLh+PfqupXnd5fICrSdCItAetoUoIcpMsHY0eyZ9k2PU
	H5Ek2ckz56u5+FmUVzKX772M9yWG6II=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-F1t7ByM-MO-9MirrTCGW0g-1; Sat, 02 Sep 2023 10:22:01 -0400
X-MC-Unique: F1t7ByM-MO-9MirrTCGW0g-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-26f49ad3b86so3219325a91.3
        for <nvdimm@lists.linux.dev>; Sat, 02 Sep 2023 07:22:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693664520; x=1694269320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q0MEcVRB3Kv8Ca24dEWgECSqsy0wPzPeJFLMYREmpig=;
        b=OS8O3QSvNtWxF8kyYW6b9/R0FwncQYl9cj8NmUimTiRL9hSzy7dNzYVEbd+RHwVGo9
         p/z2MOJS7mfwdxSUURz7IEg64pvCvnJLyDgQ0h1m33oPYKciv6tish+qNRGnPVtiDyCK
         AiYa4pdWTVyT+Jm0kuPNlLZHgV6bgUPafuzOdR1Hg9R0pEdQP7LyEssigWAJTYOYVxKa
         TI8lNhc+01XLYS8BENylLlYYy8Ag6MXqMl+B2saQGaP9gnb43xI2fnmNvQBloLvNpZXe
         aHoZdJtVbwikU8o4guEAqmoMsDm5YYygq0NSmQlu0+XF5cO++6feODYTs/mb5YtN8a3t
         c7Cg==
X-Gm-Message-State: AOJu0YxPRciEs6pFDfRCNiQzLF74wufONkTUmrX0Mbrue6/sdXTzsFFP
	pWfJs5rLHtA954+GEWigX6urt4h7u+sFPe5eY/DfnuUDLYAlKlYx2mz+8kft60OirH+ALxcgGra
	rjzoa6otLxM31YOBBBr9ZRSUDx/2Kk5xX
X-Received: by 2002:a17:90b:886:b0:271:af7b:7c5e with SMTP id bj6-20020a17090b088600b00271af7b7c5emr4185056pjb.44.1693664520068;
        Sat, 02 Sep 2023 07:22:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyM3C0YRgll5ImEQ7881S3eAhd7fi6+pnPMQ8CdThH9xm3lXPItaY4W8DSQP3vITwPbnLzP92jDzQl+bWcBQ4=
X-Received: by 2002:a17:90b:886:b0:271:af7b:7c5e with SMTP id
 bj6-20020a17090b088600b00271af7b7c5emr4185041pjb.44.1693664519662; Sat, 02
 Sep 2023 07:21:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230811170513.2300-1-colyli@suse.de> <20230811170513.2300-3-colyli@suse.de>
In-Reply-To: <20230811170513.2300-3-colyli@suse.de>
From: Xiao Ni <xni@redhat.com>
Date: Sat, 2 Sep 2023 22:21:45 +0800
Message-ID: <CALTww288HQ+hdxtDTNvVyF0q5Bsj3h96YDp2c7qq_TUEDW9wuA@mail.gmail.com>
Subject: Re: [PATCH v7 2/6] badblocks: add helper routines for badblock ranges handling
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
> This patch adds several helper routines to improve badblock ranges
> handling. These helper routines will be used later in the improved
> version of badblocks_set()/badblocks_clear()/badblocks_check().
>
> - Helpers prev_by_hint() and prev_badblocks() are used to find the bad
>   range from bad table which the searching range starts at or after.
>
> - The following helpers are to decide the relative layout between the
>   manipulating range and existing bad block range from bad table.
>   - can_merge_behind()
>     Return 'true' if the manipulating range can backward merge with the
>     bad block range.
>   - can_merge_front()
>     Return 'true' if the manipulating range can forward merge with the
>     bad block range.
>   - can_combine_front()
>     Return 'true' if two adjacent bad block ranges before the
>     manipulating range can be merged.
>   - overlap_front()
>     Return 'true' if the manipulating range exactly overlaps with the
>     bad block range in front of its range.
>   - overlap_behind()
>     Return 'true' if the manipulating range exactly overlaps with the
>     bad block range behind its range.
>   - can_front_overwrite()
>     Return 'true' if the manipulating range can forward overwrite the
>     bad block range in front of its range.
>
> - The following helpers are to add the manipulating range into the bad
>   block table. Different routine is called with the specific relative
>   layout between the manipulating range and other bad block range in the
>   bad block table.
>   - behind_merge()
>     Merge the manipulating range with the bad block range behind its
>     range, and return the number of merged length in unit of sector.
>   - front_merge()
>     Merge the manipulating range with the bad block range in front of
>     its range, and return the number of merged length in unit of sector.
>   - front_combine()
>     Combine the two adjacent bad block ranges before the manipulating
>     range into a larger one.
>   - front_overwrite()
>     Overwrite partial of whole bad block range which is in front of the
>     manipulating range. The overwrite may split existing bad block range
>     and generate more bad block ranges into the bad block table.
>   - insert_at()
>     Insert the manipulating range at a specific location in the bad
>     block table.
>
> All the above helpers are used in later patches to improve the bad block
> ranges handling for badblocks_set()/badblocks_clear()/badblocks_check().
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
>  block/badblocks.c | 386 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 386 insertions(+)
>
> diff --git a/block/badblocks.c b/block/badblocks.c
> index 3afb550c0f7b..7e7f9f14bb1d 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -16,6 +16,392 @@
>  #include <linux/types.h>
>  #include <linux/slab.h>
>
> +/*
> + * Find the range starts at-or-before 's' from bad table. The search
> + * starts from index 'hint' and stops at index 'hint_end' from the bad
> + * table.
> + */
> +static int prev_by_hint(struct badblocks *bb, sector_t s, int hint)
> +{
> +       int hint_end =3D hint + 2;
> +       u64 *p =3D bb->page;
> +       int ret =3D -1;
> +
> +       while ((hint < hint_end) && ((hint + 1) <=3D bb->count) &&
> +              (BB_OFFSET(p[hint]) <=3D s)) {
> +               if ((hint + 1) =3D=3D bb->count || BB_OFFSET(p[hint + 1])=
 > s) {
> +                       ret =3D hint;
> +                       break;
> +               }
> +               hint++;
> +       }
> +
> +       return ret;
> +}
> +
> +/*
> + * Find the range starts at-or-before bad->start. If 'hint' is provided
> + * (hint >=3D 0) then search in the bad table from hint firstly. It is
> + * very probably the wanted bad range can be found from the hint index,
> + * then the unnecessary while-loop iteration can be avoided.
> + */
> +static int prev_badblocks(struct badblocks *bb, struct badblocks_context=
 *bad,
> +                         int hint)
> +{
> +       sector_t s =3D bad->start;
> +       int ret =3D -1;
> +       int lo, hi;
> +       u64 *p;
> +
> +       if (!bb->count)
> +               goto out;
> +
> +       if (hint >=3D 0) {
> +               ret =3D prev_by_hint(bb, s, hint);
> +               if (ret >=3D 0)
> +                       goto out;
> +       }
> +
> +       lo =3D 0;
> +       hi =3D bb->count;
> +       p =3D bb->page;
> +
> +       /* The following bisect search might be unnecessary */
> +       if (BB_OFFSET(p[lo]) > s)
> +               return -1;
> +       if (BB_OFFSET(p[hi - 1]) <=3D s)
> +               return hi - 1;
> +
> +       /* Do bisect search in bad table */
> +       while (hi - lo > 1) {
> +               int mid =3D (lo + hi)/2;
> +               sector_t a =3D BB_OFFSET(p[mid]);
> +
> +               if (a =3D=3D s) {
> +                       ret =3D mid;
> +                       goto out;
> +               }
> +
> +               if (a < s)
> +                       lo =3D mid;
> +               else
> +                       hi =3D mid;
> +       }
> +
> +       if (BB_OFFSET(p[lo]) <=3D s)
> +               ret =3D lo;
> +out:
> +       return ret;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' can be backward merged
> + * with the bad range (from the bad table) index by 'behind'.
> + */
> +static bool can_merge_behind(struct badblocks *bb,
> +                            struct badblocks_context *bad, int behind)
> +{
> +       sector_t sectors =3D bad->len;
> +       sector_t s =3D bad->start;
> +       u64 *p =3D bb->page;
> +
> +       if ((s < BB_OFFSET(p[behind])) &&
> +           ((s + sectors) >=3D BB_OFFSET(p[behind])) &&
> +           ((BB_END(p[behind]) - s) <=3D BB_MAX_LEN) &&
> +           BB_ACK(p[behind]) =3D=3D bad->ack)
> +               return true;
> +       return false;
> +}
> +
> +/*
> + * Do backward merge for range indicated by 'bad' and the bad range
> + * (from the bad table) indexed by 'behind'. The return value is merged
> + * sectors from bad->len.
> + */
> +static int behind_merge(struct badblocks *bb, struct badblocks_context *=
bad,
> +                       int behind)
> +{
> +       sector_t sectors =3D bad->len;
> +       sector_t s =3D bad->start;
> +       u64 *p =3D bb->page;
> +       int merged =3D 0;
> +
> +       WARN_ON(s >=3D BB_OFFSET(p[behind]));
> +       WARN_ON((s + sectors) < BB_OFFSET(p[behind]));
> +
> +       if (s < BB_OFFSET(p[behind])) {
> +               merged =3D BB_OFFSET(p[behind]) - s;
> +               p[behind] =3D  BB_MAKE(s, BB_LEN(p[behind]) + merged, bad=
->ack);
> +
> +               WARN_ON((BB_LEN(p[behind]) + merged) >=3D BB_MAX_LEN);
> +       }
> +
> +       return merged;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' can be forward
> + * merged with the bad range (from the bad table) indexed by 'prev'.
> + */
> +static bool can_merge_front(struct badblocks *bb, int prev,
> +                           struct badblocks_context *bad)
> +{
> +       sector_t s =3D bad->start;
> +       u64 *p =3D bb->page;
> +
> +       if (BB_ACK(p[prev]) =3D=3D bad->ack &&
> +           (s < BB_END(p[prev]) ||
> +            (s =3D=3D BB_END(p[prev]) && (BB_LEN(p[prev]) < BB_MAX_LEN))=
))
> +               return true;
> +       return false;
> +}
> +
> +/*
> + * Do forward merge for range indicated by 'bad' and the bad range
> + * (from bad table) indexed by 'prev'. The return value is sectors
> + * merged from bad->len.
> + */
> +static int front_merge(struct badblocks *bb, int prev, struct badblocks_=
context *bad)
> +{
> +       sector_t sectors =3D bad->len;
> +       sector_t s =3D bad->start;
> +       u64 *p =3D bb->page;
> +       int merged =3D 0;
> +
> +       WARN_ON(s > BB_END(p[prev]));
> +
> +       if (s < BB_END(p[prev])) {
> +               merged =3D min_t(sector_t, sectors, BB_END(p[prev]) - s);
> +       } else {
> +               merged =3D min_t(sector_t, sectors, BB_MAX_LEN - BB_LEN(p=
[prev]));
> +               if ((prev + 1) < bb->count &&
> +                   merged > (BB_OFFSET(p[prev + 1]) - BB_END(p[prev]))) =
{
> +                       merged =3D BB_OFFSET(p[prev + 1]) - BB_END(p[prev=
]);
> +               }
> +
> +               p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]),
> +                                 BB_LEN(p[prev]) + merged, bad->ack);
> +       }
> +
> +       return merged;
> +}
> +
> +/*
> + * 'Combine' is a special case which can_merge_front() is not able to
> + * handle: If a bad range (indexed by 'prev' from bad table) exactly
> + * starts as bad->start, and the bad range ahead of 'prev' (indexed by
> + * 'prev - 1' from bad table) exactly ends at where 'prev' starts, and
> + * the sum of their lengths does not exceed BB_MAX_LEN limitation, then
> + * these two bad range (from bad table) can be combined.
> + *
> + * Return 'true' if bad ranges indexed by 'prev' and 'prev - 1' from bad
> + * table can be combined.
> + */
> +static bool can_combine_front(struct badblocks *bb, int prev,
> +                             struct badblocks_context *bad)
> +{
> +       u64 *p =3D bb->page;
> +
> +       if ((prev > 0) &&
> +           (BB_OFFSET(p[prev]) =3D=3D bad->start) &&
> +           (BB_END(p[prev - 1]) =3D=3D BB_OFFSET(p[prev])) &&
> +           (BB_LEN(p[prev - 1]) + BB_LEN(p[prev]) <=3D BB_MAX_LEN) &&
> +           (BB_ACK(p[prev - 1]) =3D=3D BB_ACK(p[prev])))
> +               return true;
> +       return false;
> +}
> +
> +/*
> + * Combine the bad ranges indexed by 'prev' and 'prev - 1' (from bad
> + * table) into one larger bad range, and the new range is indexed by
> + * 'prev - 1'.
> + * The caller of front_combine() will decrease bb->count, therefore
> + * it is unnecessary to clear p[perv] after front merge.

Hi Coly

A typo error: s/perv/prev/g

> + */
> +static void front_combine(struct badblocks *bb, int prev)
> +{
> +       u64 *p =3D bb->page;
> +
> +       p[prev - 1] =3D BB_MAKE(BB_OFFSET(p[prev - 1]),
> +                             BB_LEN(p[prev - 1]) + BB_LEN(p[prev]),
> +                             BB_ACK(p[prev]));
> +       if ((prev + 1) < bb->count)
> +               memmove(p + prev, p + prev + 1, (bb->count - prev - 1) * =
8);
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' is exactly forward
> + * overlapped with the bad range (from bad table) indexed by 'front'.
> + * Exactly forward overlap means the bad range (from bad table) indexed
> + * by 'prev' does not cover the whole range indicated by 'bad'.
> + */
> +static bool overlap_front(struct badblocks *bb, int front,
> +                         struct badblocks_context *bad)
> +{
> +       u64 *p =3D bb->page;
> +
> +       if (bad->start >=3D BB_OFFSET(p[front]) &&
> +           bad->start < BB_END(p[front]))
> +               return true;
> +       return false;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' is exactly backward
> + * overlapped with the bad range (from bad table) indexed by 'behind'.
> + */
> +static bool overlap_behind(struct badblocks *bb, struct badblocks_contex=
t *bad,
> +                          int behind)
> +{
> +       u64 *p =3D bb->page;
> +
> +       if (bad->start < BB_OFFSET(p[behind]) &&
> +           (bad->start + bad->len) > BB_OFFSET(p[behind]))
> +               return true;
> +       return false;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' can overwrite the bad
> + * range (from bad table) indexed by 'prev'.
> + *
> + * The range indicated by 'bad' can overwrite the bad range indexed by
> + * 'prev' when,
> + * 1) The whole range indicated by 'bad' can cover partial or whole bad
> + *    range (from bad table) indexed by 'prev'.
> + * 2) The ack value of 'bad' is larger or equal to the ack value of bad
> + *    range 'prev'.
> + *
> + * If the overwriting doesn't cover the whole bad range (from bad table)
> + * indexed by 'prev', new range might be split from existing bad range,
> + * 1) The overwrite covers head or tail part of existing bad range, 1
> + *    extra bad range will be split and added into the bad table.
> + * 2) The overwrite covers middle of existing bad range, 2 extra bad
> + *    ranges will be split (ahead and after the overwritten range) and
> + *    added into the bad table.
> + * The number of extra split ranges of the overwriting is stored in
> + * 'extra' and returned for the caller.
> + */
> +static bool can_front_overwrite(struct badblocks *bb, int prev,
> +                               struct badblocks_context *bad, int *extra=
)
> +{
> +       u64 *p =3D bb->page;
> +       int len;
> +
> +       WARN_ON(!overlap_front(bb, prev, bad));
> +
> +       if (BB_ACK(p[prev]) >=3D bad->ack)
> +               return false;

The comments say it can do overwrite when the bad's ack and prev's ack
are equal. But it returns false when the acks are equal. So there is a
conflict between the codes and comments. The codes are good for me.
Maybe we need to modify the comments?

> +
> +       if (BB_END(p[prev]) <=3D (bad->start + bad->len)) {
> +               len =3D BB_END(p[prev]) - bad->start;
> +               if (BB_OFFSET(p[prev]) =3D=3D bad->start)
> +                       *extra =3D 0;
> +               else
> +                       *extra =3D 1;
> +
> +               bad->len =3D len;
> +       } else {
> +               if (BB_OFFSET(p[prev]) =3D=3D bad->start)
> +                       *extra =3D 1;
> +               else
> +               /*
> +                * prev range will be split into two, beside the overwrit=
ten
> +                * one, an extra slot needed from bad table.
> +                */
> +                       *extra =3D 2;
> +       }
> +
> +       if ((bb->count + (*extra)) >=3D MAX_BADBLOCKS)
> +               return false;
> +
> +       return true;
> +}
> +
> +/*
> + * Do the overwrite from the range indicated by 'bad' to the bad range
> + * (from bad table) indexed by 'prev'.
> + * The previously called can_front_overwrite() will provide how many
> + * extra bad range(s) might be split and added into the bad table. All
> + * the splitting cases in the bad table will be handled here.
> + */
> +static int front_overwrite(struct badblocks *bb, int prev,
> +                          struct badblocks_context *bad, int extra)
> +{
> +       u64 *p =3D bb->page;
> +       sector_t orig_end =3D BB_END(p[prev]);
> +       int orig_ack =3D BB_ACK(p[prev]);
> +
> +       switch (extra) {
> +       case 0:
> +               p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]), BB_LEN(p[prev]),
> +                                 bad->ack);
> +               break;
> +       case 1:
> +               if (BB_OFFSET(p[prev]) =3D=3D bad->start) {
> +                       p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]),
> +                                         bad->len, bad->ack);
> +                       memmove(p + prev + 2, p + prev + 1,
> +                               (bb->count - prev - 1) * 8);
> +                       p[prev + 1] =3D BB_MAKE(bad->start + bad->len,
> +                                             orig_end - BB_END(p[prev]),
> +                                             orig_ack);
> +               } else {
> +                       p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]),
> +                                         bad->start - BB_OFFSET(p[prev])=
,
> +                                         orig_ack);
> +                       /*
> +                        * prev +2 -> prev + 1 + 1, which is for,
> +                        * 1) prev + 1: the slot index of the previous on=
e
> +                        * 2) + 1: one more slot for extra being 1.
> +                        */
> +                       memmove(p + prev + 2, p + prev + 1,
> +                               (bb->count - prev - 1) * 8);
> +                       p[prev + 1] =3D BB_MAKE(bad->start, bad->len, bad=
->ack);
> +               }
> +               break;
> +       case 2:
> +               p[prev] =3D BB_MAKE(BB_OFFSET(p[prev]),
> +                                 bad->start - BB_OFFSET(p[prev]),
> +                                 orig_ack);
> +               /*
> +                * prev + 3 -> prev + 1 + 2, which is for,
> +                * 1) prev + 1: the slot index of the previous one
> +                * 2) + 2: two more slots for extra being 2.
> +                */
> +               memmove(p + prev + 3, p + prev + 1,
> +                       (bb->count - prev - 1) * 8);
> +               p[prev + 1] =3D BB_MAKE(bad->start, bad->len, bad->ack);
> +               p[prev + 2] =3D BB_MAKE(BB_END(p[prev + 1]),
> +                                     orig_end - BB_END(p[prev + 1]),
> +                                     orig_ack);
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       return bad->len;
> +}
> +
> +/*
> + * Explicitly insert a range indicated by 'bad' to the bad table, where
> + * the location is indexed by 'at'.
> + */
> +static int insert_at(struct badblocks *bb, int at, struct badblocks_cont=
ext *bad)
> +{
> +       u64 *p =3D bb->page;
> +       int len;
> +
> +       WARN_ON(badblocks_full(bb));
> +
> +       len =3D min_t(sector_t, bad->len, BB_MAX_LEN);
> +       if (at < bb->count)
> +               memmove(p + at + 1, p + at, (bb->count - at) * 8);
> +       p[at] =3D BB_MAKE(bad->start, len, bad->ack);
> +
> +       return len;
> +}
> +
>  /**
>   * badblocks_check() - check a given range for bad sectors
>   * @bb:                the badblocks structure that holds all badblock i=
nformation
> --
> 2.35.3
>

There are only two places that are not important. One is a typo error
and the other is a question about the comments. This patch is good for
me. Thanks for the effort.

Reviewed-by: Xiao Ni <xni@redhat.com>

