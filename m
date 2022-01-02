Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279CB173
	for <nvdimm@lists.linux.dev>; Sun,  2 Jan 2022 07:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641107077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rNvgKa7RBKZAN1BbsQtt2iLEjXM+iSNPhCbUMTDF2yU=;
	b=JnyZpjm4z58EM+GregvUUe07O0h0UzXqtPPH1zHa8o/3GX3/BPq8PvXi3SV3rvTMEOKWbn
	tMxT9IpQX7qnHGqOcTUP0R626+3BdTBLV9mDLQOGexw+VseHgVlvnprgm6sjJ86xZFumtp
	72RuSF+E49wYtZgwDVii/aayO2EdI2c=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-QnhjUxSUPBOTc_rnOM4eGA-1; Sun, 02 Jan 2022 02:04:36 -0500
X-MC-Unique: QnhjUxSUPBOTc_rnOM4eGA-1
Received: by mail-ed1-f69.google.com with SMTP id b8-20020a056402350800b003f8f42a883dso13795978edd.16
        for <nvdimm@lists.linux.dev>; Sat, 01 Jan 2022 23:04:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rNvgKa7RBKZAN1BbsQtt2iLEjXM+iSNPhCbUMTDF2yU=;
        b=6s225Kn1wdk2cKxQz2FICYIhPZHIbvunGUNKzK+ExZC5deGfltwQerqfOcj4AWey6V
         pHWWh3KS/sW+5DLh6URebLv0cLDtQMAP9Zm2XFd03os9dWAZI2o8Kzo29qgu1qqBsL54
         q2qSt54DpZqUW5/hL+5XyeE3Ij1SHmeDhf2IK1KDiMqC8+3do2ZdypDxKieul6dYqynJ
         AC69DFkug8osWQzNeuActTY19ebcP/3voxt59vN8hSFhcct91QkVbIyoFzRL9Q/Mw5PN
         qeWCONEysrNNUh3EADUZDGshILTDUtpT+OQl5sC4ZU45+RALgCSj8ISff6/rOs5I44OU
         Vn6A==
X-Gm-Message-State: AOAM532Ana71WW6AmuSNkavE3CINg/kOBKspmzHYk1iHS+wfgt+jB+ok
	LYqcm9g0hxvtHCyhvDpM5/b37kwbJdw8gwUvDEfx+rHljFP8dF5CUNzOCn4Z9kr3qbSvQi0UheK
	ABCgcgvpILPKvT6naTKZO0yC1dUltZPdt
X-Received: by 2002:a17:907:8a0d:: with SMTP id sc13mr33324327ejc.498.1641107075674;
        Sat, 01 Jan 2022 23:04:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxUIhr76bnjGItvqFPRFYIE+XdU78Fz4DGy60kqLhZt8/cvA7FCuOih75BkLEpO9m5Bs6UNO7PzGBT09Wbkddk=
X-Received: by 2002:a17:907:8a0d:: with SMTP id sc13mr33324314ejc.498.1641107075471;
 Sat, 01 Jan 2022 23:04:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211210160456.56816-1-colyli@suse.de> <20211210160456.56816-3-colyli@suse.de>
In-Reply-To: <20211210160456.56816-3-colyli@suse.de>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 2 Jan 2022 15:04:24 +0800
Message-ID: <CALTww28HF2SPrrQAaLd+H_De5F8aOemBHfU03zMVAYatb7k19Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/6] badblocks: add helper routines for badblock ranges handling
To: Coly Li <colyli@suse.de>
Cc: nvdimm@lists.linux.dev, linux-raid <linux-raid@vger.kernel.org>, 
	linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, 
	Geliang Tang <geliang.tang@suse.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, 
	NeilBrown <neilb@suse.de>, Vishal L Verma <vishal.l.verma@intel.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=xni@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

On Sat, Dec 11, 2021 at 12:05 AM Coly Li <colyli@suse.de> wrote:
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
> ---
>  block/badblocks.c | 376 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 376 insertions(+)
>
> diff --git a/block/badblocks.c b/block/badblocks.c
> index d39056630d9c..30958cc4469f 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -16,6 +16,382 @@
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
> +       int hint_end = hint + 2;
> +       u64 *p = bb->page;
> +       int ret = -1;
> +
> +       while ((hint < hint_end) && ((hint + 1) <= bb->count) &&
> +              (BB_OFFSET(p[hint]) <= s)) {
> +               if ((hint + 1) == bb->count || BB_OFFSET(p[hint + 1]) > s) {
> +                       ret = hint;
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
> + * (hint >= 0) then search in the bad table from hint firstly. It is
> + * very probably the wanted bad range can be found from the hint index,
> + * then the unnecessary while-loop iteration can be avoided.
> + */
> +static int prev_badblocks(struct badblocks *bb, struct badblocks_context *bad,
> +                         int hint)
> +{
> +       sector_t s = bad->start;
> +       int ret = -1;
> +       int lo, hi;
> +       u64 *p;
> +
> +       if (!bb->count)
> +               goto out;
> +
> +       if (hint >= 0) {
> +               ret = prev_by_hint(bb, s, hint);
> +               if (ret >= 0)
> +                       goto out;
> +       }
> +
> +       lo = 0;
> +       hi = bb->count;
> +       p = bb->page;
> +
> +       while (hi - lo > 1) {
> +               int mid = (lo + hi)/2;
> +               sector_t a = BB_OFFSET(p[mid]);
> +
> +               if (a <= s)
> +                       lo = mid;
> +               else
> +                       hi = mid;
> +       }

Hi Coly

Does it need to stop the loop when "a == s". For example, there are
100 bad blocks.
The new bad starts equals offset(50). In the first loop, it can find
the result. It doesn't
need to go on running in the loop. If it still runs the loop, only the
hi can be handled.
It has no meaning.

> +
> +       if (BB_OFFSET(p[lo]) <= s)
> +               ret = lo;
> +out:
> +       return ret;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' can be backward merged
> + * with the bad range (from the bad table) index by 'behind'.
> + */
> +static bool can_merge_behind(struct badblocks *bb, struct badblocks_context *bad,
> +                            int behind)
> +{
> +       sector_t sectors = bad->len;
> +       sector_t s = bad->start;
> +       u64 *p = bb->page;
> +
> +       if ((s <= BB_OFFSET(p[behind])) &&

In fact, it can never trigger s == BB_OFFSET here. By the design, if s
== offset(pos), prev_badblocks
can find it. Then front_merge/front_overwrite can handle it.

> +           ((s + sectors) >= BB_OFFSET(p[behind])) &&
> +           ((BB_END(p[behind]) - s) <= BB_MAX_LEN) &&
> +           BB_ACK(p[behind]) == bad->ack)
> +               return true;
> +       return false;
> +}
> +
> +/*
> + * Do backward merge for range indicated by 'bad' and the bad range
> + * (from the bad table) indexed by 'behind'. The return value is merged
> + * sectors from bad->len.
> + */
> +static int behind_merge(struct badblocks *bb, struct badblocks_context *bad,
> +                       int behind)
> +{
> +       sector_t sectors = bad->len;
> +       sector_t s = bad->start;
> +       u64 *p = bb->page;
> +       int merged = 0;
> +
> +       WARN_ON(s > BB_OFFSET(p[behind]));
> +       WARN_ON((s + sectors) < BB_OFFSET(p[behind]));
> +
> +       if (s < BB_OFFSET(p[behind])) {
> +               WARN_ON((BB_LEN(p[behind]) + merged) >= BB_MAX_LEN);
> +
> +               merged = min_t(sector_t, sectors, BB_OFFSET(p[behind]) - s);

sectors must be >= BB_OFFSET(p[behind] - s) here? It's behind_merge, so the end
of bad should be >= BB_OFFSET(p[behind])

If we need to check merged value. The WARN_ON should be checked after merged

> +               p[behind] =  BB_MAKE(s, BB_LEN(p[behind]) + merged, bad->ack);
> +       } else {
> +               merged = min_t(sector_t, sectors, BB_LEN(p[behind]));
> +       }

If we don't need to consider s == offset(pos) situation, it only needs
to consider s < offset(pos) here
> +
> +       WARN_ON(merged == 0);
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
> +       sector_t s = bad->start;
> +       u64 *p = bb->page;
> +
> +       if (BB_ACK(p[prev]) == bad->ack &&
> +           (s < BB_END(p[prev]) ||
> +            (s == BB_END(p[prev]) && (BB_LEN(p[prev]) < BB_MAX_LEN))))
> +               return true;
> +       return false;
> +}
> +
> +/*
> + * Do forward merge for range indicated by 'bad' and the bad range
> + * (from bad table) indexed by 'prev'. The return value is sectors
> + * merged from bad->len.
> + */
> +static int front_merge(struct badblocks *bb, int prev, struct badblocks_context *bad)
> +{
> +       sector_t sectors = bad->len;
> +       sector_t s = bad->start;
> +       u64 *p = bb->page;
> +       int merged = 0;
> +
> +       WARN_ON(s > BB_END(p[prev]));
> +
> +       if (s < BB_END(p[prev])) {
> +               merged = min_t(sector_t, sectors, BB_END(p[prev]) - s);
> +       } else {
> +               merged = min_t(sector_t, sectors, BB_MAX_LEN - BB_LEN(p[prev]));
> +               if ((prev + 1) < bb->count &&
> +                   merged > (BB_OFFSET(p[prev + 1]) - BB_END(p[prev]))) {
> +                       merged = BB_OFFSET(p[prev + 1]) - BB_END(p[prev]);
> +               }
> +
> +               p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
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
> +       u64 *p = bb->page;
> +
> +       if ((prev > 0) &&
> +           (BB_OFFSET(p[prev]) == bad->start) &&
> +           (BB_END(p[prev - 1]) == BB_OFFSET(p[prev])) &&
> +           (BB_LEN(p[prev - 1]) + BB_LEN(p[prev]) <= BB_MAX_LEN) &&
> +           (BB_ACK(p[prev - 1]) == BB_ACK(p[prev])))
> +               return true;
> +       return false;
> +}

could you explain why BB_OFFSET(p[prev]) should == bad->start. If
bad(prev-1) and
bad(prev) are adjacent, can they be combine directly without
considering bad->start

Best Regards
Xiao

