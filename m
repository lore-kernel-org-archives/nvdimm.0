Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2D84A2F
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 15:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663774026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0zDFMiPHPy86k4ur/CUBB97B4MwXnibyATpgZf/KAv0=;
	b=IPqgTKRR3stvgDgSKzmlwR+TM9rsy43prjOwCoPnx247SA4X98n8wP1uQwaaWkWbZ2cWwO
	iUyYwikMQy6Bsv9sZesm3QgC6Km5VBewDTfFKlSZni7YkTE/YvUdrqDAUFyFGBhx/Sb24h
	A0Zph5244nxGEd/Be+W7sz9vDXybOGg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-263-iLRQQKBQMZiknwhB6TBLjw-1; Wed, 21 Sep 2022 11:27:05 -0400
X-MC-Unique: iLRQQKBQMZiknwhB6TBLjw-1
Received: by mail-pl1-f198.google.com with SMTP id e2-20020a17090301c200b001787cf4aaa4so4047217plh.14
        for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 08:27:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=0zDFMiPHPy86k4ur/CUBB97B4MwXnibyATpgZf/KAv0=;
        b=S8wwkBLBU+mmUBofRxyLMDL36ZM9JTjRBJFVCPNL5ptyIB2+rxs/oj+/QsNT2XT2pf
         Vv220NoxNNIBuHFfjgJz+XiyVBTVfqPwdN9rbZbRHWoqOEgke6l6Se7v8za7jsyqQc0M
         iBlkZk7c5Wj86MvP8ZRnOVo+bW3MmRMYPAWRkR5+D+lHDFiiYWvZ93kOz9z22TDOkYdt
         81PNBIhT02g2IeOqQAk0/FOt4HjoJIeedbWdiIBcRbfHVNbyMAB7aeltSDSo3KHggjnB
         b0s82CN9NTPi6n4IxenTMJf/p3JdGtEDbD5/oYez983/0JqHRfynomupcXXp5nkM1wYt
         TbPA==
X-Gm-Message-State: ACrzQf1pBelwfsozsKTG7N5JmpIoaSXO5v1dOGkPERpphXpkFf0i4/t1
	FfWfvtefbjJbAOMUav2DVUFtmqT/m/mWrqk99BTXRZ/oEXeSyzgmYHRMeEkpCbNubwh6FovPZiX
	boJ4sHVp8LZLXzP83SNCblvLPE/Wft3yh
X-Received: by 2002:a63:2a57:0:b0:439:42f4:97e1 with SMTP id q84-20020a632a57000000b0043942f497e1mr25125328pgq.190.1663774023919;
        Wed, 21 Sep 2022 08:27:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7VJNbxmuLH6fUT1ABCUyZhYPXk83mEuylyorFQVWU8hbMpS3FRpZbAcSsIPX8Awmxao/EYed6Yu0XbbfZgVf8=
X-Received: by 2002:a63:2a57:0:b0:439:42f4:97e1 with SMTP id
 q84-20020a632a57000000b0043942f497e1mr25125311pgq.190.1663774023609; Wed, 21
 Sep 2022 08:27:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220721121152.4180-1-colyli@suse.de> <20220721121152.4180-5-colyli@suse.de>
In-Reply-To: <20220721121152.4180-5-colyli@suse.de>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 21 Sep 2022 23:26:52 +0800
Message-ID: <CALTww2_-K4nf7wYsa6z4YsT=Ma-59iGkiKia6nZLAH4nreeMVQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/7] badblocks: improve badblocks_clear() for multiple
 ranges handling
To: Coly Li <colyli@suse.de>
Cc: linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-raid <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, 
	Geliang Tang <geliang.tang@suse.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, 
	NeilBrown <neilb@suse.de>, Vishal L Verma <vishal.l.verma@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 21, 2022 at 8:12 PM Coly Li <colyli@suse.de> wrote:
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
> index ba126a2e138d..d3fa53594aa7 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -330,6 +330,123 @@
>   * avoided. In my test with the hint to prev_badblocks(), except for the first
>   * loop, all rested calls to prev_badblocks() can go into the fast path and
>   * return correct bad blocks table index immediately.
> + *
> + *
> + * Clearing a bad blocks range from the bad block table has similar idea as
> + * setting does, but much more simpler. The only thing needs to be noticed is
> + * when the clearing range hits middle of a bad block range, the existing bad
> + * block range will split into two, and one more item should be added into the
> + * bad block table. The simplified situations to be considered are, (The already
> + * set bad blocks ranges in bad block table are naming with prefix E, and the
> + * clearing bad blocks range is naming with prefix C)
> + *
> + * 1) A clearing range is not overlapped to any already set ranges in bad block
> + *    table.
> + *    +-----+         |          +-----+         |          +-----+
> + *    |  C  |         |          |  C  |         |          |  C  |
> + *    +-----+         or         +-----+         or         +-----+
> + *            +---+   |   +----+         +----+  |  +---+
> + *            | E |   |   | E1 |         | E2 |  |  | E |
> + *            +---+   |   +----+         +----+  |  +---+
> + *    For the above situations, no bad block to be cleared and no failure
> + *    happens, simply returns 0.
> + * 2) The clearing range hits middle of an already setting bad blocks range in
> + *    the bad block table.
> + *            +---+
> + *            | C |
> + *            +---+
> + *     +-----------------+
> + *     |         E       |
> + *     +-----------------+
> + *    In this situation if the bad block table is not full, the range E will be
> + *    split into two ranges E1 and E2. The result is,
> + *     +------+   +------+
> + *     |  E1  |   |  E2  |
> + *     +------+   +------+
> + * 3) The clearing range starts exactly at same LBA as an already set bad block range
> + *    from the bad block table.
> + * 3.1) Partially covered at head part
> + *         +------------+
> + *         |     C      |
> + *         +------------+
> + *         +-----------------+
> + *         |         E       |
> + *         +-----------------+
> + *    For this situation, the overlapped already set range will update the
> + *    start LBA to end of C and shrink the range to BB_LEN(E) - BB_LEN(C). No
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
> + *    For this situation the whole bad blocks range E will be cleared and its
> + *    corresponded item is deleted from the bad block table.

Does it need to add 3.3) here to explain when length of C is bigger than E
Or we can change 3.2 to cover these two conditions. In the codes, it splits
situation 3 into two parts.

> + * 4) The clearing range exactly ends at same LBA as an already set bad block
> + *    range.
> + *                   +-------+
> + *                   |   C   |
> + *                   +-------+
> + *         +-----------------+
> + *         |         E       |
> + *         +-----------------+
> + *    For the above situation, the already set range E is updated to shrink its
> + *    end to the start of C, and reduce its length to BB_LEN(E) - BB_LEN(C).
> + *    The result is,
> + *         +---------+
> + *         |    E    |
> + *         +---------+
> + * 5) The clearing range is partially overlapped with an already set bad block
> + *    range from the bad block table.
> + * 5.1) The already set bad block range is front overlapped with the clearing
> + *    range.
> + *         +----------+
> + *         |     C    |
> + *         +----------+
> + *              +------------+
> + *              |      E     |
> + *              +------------+
> + *   For such situation, the clearing range C can be treated as two parts. The
> + *   first part ends at the start LBA of range E, and the second part starts at
> + *   same LBA of range E.
> + *         +----+-----+               +----+   +-----+
> + *         | C1 | C2  |               | C1 |   | C2  |
> + *         +----+-----+         ===>  +----+   +-----+
> + *              +------------+                 +------------+
> + *              |      E     |                 |      E     |
> + *              +------------+                 +------------+
> + *   Now the first part C1 can be handled as condition 1), and the second part C2 can be
> + *   handled as condition 3.1) in next loop.
> + * 5.2) The already set bad block range is behind overlaopped with the clearing
> + *   range.
> + *                 +----------+
> + *                 |     C    |
> + *                 +----------+
> + *         +------------+
> + *         |      E     |
> + *         +------------+
> + *   For such situation, the clearing range C can be treated as two parts. The
> + *   first part C1 ends at same end LBA of range E, and the second part starts
> + *   at end LBA of range E.
> + *                 +----+-----+                 +----+    +-----+
> + *                 | C1 | C2  |                 | C1 |    | C2  |
> + *                 +----+-----+  ===>           +----+    +-----+
> + *         +------------+               +------------+
> + *         |      E     |               |      E     |
> + *         +------------+               +------------+
> + *   Now the first part clearing range C1 can be handled as condition 4), and
> + *   the second part clearing range C2 can be handled as condition 1) in next
> + *   loop.
> + *
> + *   All bad blocks range clearing can be simplified into the above 5 situations
> + *   by only handling the head part of the clearing range in each run of the
> + *   while-loop. The idea is similar to bad blocks range setting but much
> + *   simpler.
>   */

The categorized situations are a little different with setting bad
block. Is it better
to use the same way as setting bad block? So we don't need to consider two
categorized ways to avoid switching them when reading codes.

>
>  /*
> @@ -937,6 +1054,214 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>         return rv;
>  }
>
> +/*
> + * Clear the bad block range from bad block table which is front overlapped
> + * with the clearing range. The return value is how many sectors from an
> + * already set bad block range are cleared. If the whole bad block range is
> + * covered by the clearing range and fully cleared, 'delete' is set as 1 for
> + * the caller to reduce bb->count.
> + */
> +static int front_clear(struct badblocks *bb, int prev,
> +                      struct badblocks_context *bad, int *deleted)
> +{
> +       sector_t sectors = bad->len;
> +       sector_t s = bad->start;
> +       u64 *p = bb->page;
> +       int cleared = 0;
> +
> +       *deleted = 0;
> +       if (s == BB_OFFSET(p[prev])) {
> +               if (BB_LEN(p[prev]) > sectors) {
> +                       p[prev] = BB_MAKE(BB_OFFSET(p[prev]) + sectors,
> +                                         BB_LEN(p[prev]) - sectors,
> +                                         BB_ACK(p[prev]));
> +                       cleared = sectors;
> +               } else {
> +                       /* BB_LEN(p[prev]) <= sectors */
> +                       cleared = BB_LEN(p[prev]);
> +                       if ((prev + 1) < bb->count)
> +                               memmove(p + prev, p + prev + 1,
> +                                      (bb->count - prev - 1) * 8);
                            else
                                    p[prev] = 0

> +                       *deleted = 1;
> +               }
> +       } else if (s > BB_OFFSET(p[prev])) {
> +               if (BB_END(p[prev]) <= (s + sectors)) {
> +                       cleared = BB_END(p[prev]) - s;
> +                       p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +                                         s - BB_OFFSET(p[prev]),
> +                                         BB_ACK(p[prev]));
> +               } else {
> +                       /* Splitting is handled in front_splitting_clear() */
> +                       BUG();
> +               }
> +       }
> +
> +       return cleared;
> +}
> +
> +/*
> + * Handle the condition that the clearing range hits middle of an already set
> + * bad block range from bad block table. In this condition the existing bad
> + * block range is split into two after the middle part is cleared.
> + */
> +static int front_splitting_clear(struct badblocks *bb, int prev,
> +                                 struct badblocks_context *bad)
> +{
> +       u64 *p = bb->page;
> +       u64 end = BB_END(p[prev]);
> +       int ack = BB_ACK(p[prev]);
> +       sector_t sectors = bad->len;
> +       sector_t s = bad->start;
> +
> +       p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +                         s - BB_OFFSET(p[prev]),
> +                         ack);
> +       memmove(p + prev + 2, p + prev + 1, (bb->count - prev - 1) * 8);
> +       p[prev + 1] = BB_MAKE(s + sectors, end - s - sectors, ack);
> +       return sectors;
> +}
> +
> +/* Do the exact work to clear bad block range from the bad block table */
> +static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
> +{
> +       struct badblocks_context bad;
> +       int prev = -1, hint = -1;
> +       int len = 0, cleared = 0;
> +       int rv = 0;
> +       u64 *p;
> +
> +       if (bb->shift < 0)
> +               /* badblocks are disabled */
> +               return 1;
> +
> +       if (sectors == 0)
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
> +               target = s + sectors;
> +               roundup(s, bb->shift);
> +               rounddown(target, bb->shift);
> +               sectors = target - s;
> +       }
> +
> +       write_seqlock_irq(&bb->lock);
> +
> +       bad.ack = true;
> +       p = bb->page;
> +
> +re_clear:
> +       bad.start = s;
> +       bad.len = sectors;
> +
> +       if (badblocks_empty(bb)) {
> +               len = sectors;
> +               cleared++;
> +               goto update_sectors;
> +       }
> +
> +
> +       prev = prev_badblocks(bb, &bad, hint);
> +
> +       /* Start before all badblocks */
> +       if (prev < 0) {
> +               if (overlap_behind(bb, &bad, 0)) {
> +                       len = BB_OFFSET(p[0]) - s;
> +                       hint = prev;

s/prev/0/g

> +               } else {
> +                       len = sectors;
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
> +       if ((prev + 1) >= bb->count && !overlap_front(bb, prev, &bad)) {

If we only want to check if it starts after all badblocks, we can use
bad->start >= BB_END(p[prev]) directly. It's more easy to understand
than !overlap_front.

> +               len = sectors;
> +               cleared++;
> +               goto update_sectors;
> +       }
> +
> +       /* Clear will split a bad record but the table is full */
> +       if (badblocks_full(bb) && (BB_OFFSET(p[prev]) < bad.start) &&
> +           (BB_END(p[prev]) > (bad.start + sectors))) {
> +               len = sectors;
> +               goto update_sectors;
> +       }

Can we move this check to overlap_front situation

> +
> +       if (overlap_front(bb, prev, &bad)) {
> +               if ((BB_OFFSET(p[prev]) < bad.start) &&
> +                   (BB_END(p[prev]) > (bad.start + bad.len))) {
> +                       /* Splitting */

If we move the check of table here, it should be
                    if (bb->count + 1 >= MAX_BADBLOCKS) {
                           len = sectors;
                           goto update_sectors;
                   }
Then it can do front_splitting_clear directly.

> +                       if ((bb->count + 1) < MAX_BADBLOCKS) {
> +                               len = front_splitting_clear(bb, prev, &bad);
> +                               bb->count += 1;
> +                               cleared++;
> +                       } else {
> +                               /* No space to split, give up */
> +                               len = sectors;
> +                       }
> +               } else {
> +                       int deleted = 0;
> +
> +                       len = front_clear(bb, prev, &bad, &deleted);
> +                       bb->count -= deleted;
> +                       cleared++;
> +                       hint = prev;
> +               }
> +
> +               goto update_sectors;
> +       }
> +
> +       /* Not front overlap, but behind overlap */
> +       if ((prev + 1) < bb->count && overlap_behind(bb, &bad, prev + 1)) {
> +               len = BB_OFFSET(p[prev + 1]) - bad.start;
> +               hint = prev + 1;
> +               /* Clear non-bad range should be treated as successful */
> +               cleared++;
> +               goto update_sectors;
> +       }

Can we do this like setting bad blocks? It can check behind overlap
after the loop?
So it can use the loop to handle the clearing bad block until the end of it.

Regards
Xiao

> +
> +       /* Not cover any badblocks range in the table */
> +       len = sectors;
> +       /* Clear non-bad range should be treated as successful */
> +       cleared++;
> +
> +update_sectors:
> +       s += len;
> +       sectors -= len;
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
> +               rv = 1;
> +
> +       return rv;
> +}
> +
> +
>  /**
>   * badblocks_check() - check a given range for bad sectors
>   * @bb:                the badblocks structure that holds all badblock information
> --
> 2.35.3
>

