Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004B73FC7
	for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 07:25:12 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id om12-20020a17090b3a8c00b0019eff43daf5so657865pjb.4
        for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 00:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FruM07nc3pMEiGUwfNQ3BotgfBJgDCunIKGnw/A74PA=;
        b=II1m1LcPcgRJhendDycD3I9xg42vM2EVmYJth1FY1m3oKpDHnrJ+c/+0p8iN+4heQU
         wYuVAWf1OPM169BYO7RU2jkIkJtMmxPjWrDmM1qDg2qXWnIxIHWPdCDr//O5fynthB5A
         jf4qx5GHfk7gdEA0e1CwomdzlwvpHuNmmWtpz6AcHlVfZh9rCz2JxURUwLV/xL/KVyna
         DbpRpCvI7VbCLuzcOFdAuXVIt1hS/AJSEmpQKtkTX46zeM6eGvM2Fwh/PPVNaXonDMtM
         jpmcU6YsC8+FtIcYzzEF7NFc0uHCL2snd12iAh2KpjqXa6xfVm7elBEQ4+rBgTqVSnr0
         Tevg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FruM07nc3pMEiGUwfNQ3BotgfBJgDCunIKGnw/A74PA=;
        b=2PJpVcvGANHxPsFGy6hPIgyfKP3833YERVyFM+SSe4glXmF7g1fbw/OSzzUwUwCbKI
         SVCXr3UnB+E2G0ojXx4Ya0tfC+w02LwWFRdX5BfCKH1saV93e8Sn5neF8ToXoycvSzY4
         LQVTRsAwFhRpFojS7NNkDI2kRaARauN28PGGb+n8uKLinnF7SEarkoF7Tdm34Ps2F4EZ
         FPQ0Or1QXc9Lekq8+9bEysCi0/JlulccV6x9YezmHZVw/lWseeEHR4LWO925yBHWYU5D
         3DFTrek2auWXcn0FtCD2kzDLpZkd0Bn/q6QMEOGzSP7a3m/VGexIDs84nz4Nv843TB7Z
         NxDg==
X-Gm-Message-State: AOAM533tySfoJ4sJReecXnno4G3qUgkLpbHvdapJr2UYre+4m0WMCMEa
	Qzu+l+Mcxcx5oYJkbGYnqEk=
X-Google-Smtp-Source: ABdhPJyP3NjKLnmrhPFdewPwnVK37Hh3lF29nS1fTGFUdxjVXWnZxoms/ywgf/o2e1qaY2EV74oHsg==
X-Received: by 2002:a17:90a:1548:: with SMTP id y8mr1414007pja.151.1632727512542;
        Mon, 27 Sep 2021 00:25:12 -0700 (PDT)
Received: from [10.239.207.187] ([43.224.245.179])
        by smtp.gmail.com with ESMTPSA id h10sm17922027pjs.51.2021.09.27.00.25.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 00:25:12 -0700 (PDT)
Message-ID: <eab6a9b0-d934-77e4-519c-cefc510b183a@gmail.com>
Date: Mon, 27 Sep 2021 15:25:08 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 2/6] badblocks: add helper routines for badblock ranges
 handling
Content-Language: en-US
To: Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
 nvdimm@lists.linux.dev
Cc: antlists@youngman.org.uk, Dan Williams <dan.j.williams@intel.com>,
 Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
 NeilBrown <neilb@suse.de>, Richard Fan <richard.fan@suse.com>,
 Vishal L Verma <vishal.l.verma@intel.com>
References: <20210913163643.10233-1-colyli@suse.de>
 <20210913163643.10233-3-colyli@suse.de>
From: Geliang Tang <geliangtang@gmail.com>
In-Reply-To: <20210913163643.10233-3-colyli@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/14/21 00:36, Coly Li wrote:
> This patch adds several helper routines to improve badblock ranges
> handling. These helper routines will be used later in the improved
> version of badblocks_set()/badblocks_clear()/badblocks_check().
> 
> - Helpers prev_by_hint() and prev_badblocks() are used to find the bad
>    range from bad table which the searching range starts at or after.
> 
> - The following helpers are to decide the relative layout between the
>    manipulating range and existing bad block range from bad table.
>    - can_merge_behind()
>      Return 'true' if the manipulating range can backward merge with the
>      bad block range.
>    - can_merge_front()
>      Return 'true' if the manipulating range can forward merge with the
>      bad block range.
>    - can_combine_front()
>      Return 'true' if two adjacent bad block ranges before the
>      manipulating range can be merged.
>    - overlap_front()
>      Return 'true' if the manipulating range exactly overlaps with the
>      bad block range in front of its range.
>    - overlap_behind()
>      Return 'true' if the manipulating range exactly overlaps with the
>      bad block range behind its range.
>    - can_front_overwrite()
>      Return 'true' if the manipulating range can forward overwrite the
>      bad block range in front of its range.
> 
> - The following helpers are to add the manipulating range into the bad
>    block table. Different routine is called with the specific relative
>    layout between the maniplating range and other bad block range in the
>    bad block table.
>    - behind_merge()
>      Merge the maniplating range with the bad block range behind its
>      range, and return the number of merged length in unit of sector.
>    - front_merge()
>      Merge the maniplating range with the bad block range in front of
>      its range, and return the number of merged length in unit of sector.
>    - front_combine()
>      Combine the two adjacent bad block ranges before the manipulating
>      range into a larger one.
>    - front_overwrite()
>      Overwrite partial of whole bad block range which is in front of the
>      manipulating range. The overwrite may split existing bad block range
>      and generate more bad block ranges into the bad block table.
>    - insert_at()
>      Insert the manipulating range at a specific location in the bad
>      block table.
> 
> All the above helpers are used in later patches to improve the bad block
> ranges handling for badblocks_set()/badblocks_clear()/badblocks_check().
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Richard Fan <richard.fan@suse.com>
> Cc: Vishal L Verma <vishal.l.verma@intel.com>
> ---
>   block/badblocks.c | 374 ++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 374 insertions(+)
> 
> diff --git a/block/badblocks.c b/block/badblocks.c
> index d39056630d9c..efe316181e05 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -16,6 +16,380 @@
>   #include <linux/types.h>
>   #include <linux/slab.h>
>   
> +/*
> + * Find the range starts at-or-before 's' from bad table. The search
> + * starts from index 'hint' and stops at index 'hint_end' from the bad
> + * table.
> + */
> +static int prev_by_hint(struct badblocks *bb, sector_t s, int hint)
> +{
> +	u64 *p = bb->page;
> +	int ret = -1;
> +	int hint_end = hint + 2;

How about declaring these variables following the "reverse Xmas tree" order.

> +
> +	while ((hint < hint_end) && ((hint + 1) <= bb->count) &&
> +	       (BB_OFFSET(p[hint]) <= s)) {
> +		if ((hint + 1) == bb->count || BB_OFFSET(p[hint + 1]) > s) {
> +			ret = hint;
> +			break;
> +		}
> +		hint++;
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * Find the range starts at-or-before bad->start. If 'hint' is provided
> + * (hint >= 0) then search in the bad table from hint firstly. It is
> + * very probably the wanted bad range can be found from the hint index,
> + * then the unnecessary while-loop iteration can be avoided.
> + */
> +static int prev_badblocks(struct badblocks *bb, struct badblocks_context *bad,
> +			  int hint)
> +{
> +	u64 *p;
> +	int lo, hi;
> +	sector_t s = bad->start;
> +	int ret = -1;
> +
> +	if (!bb->count)
> +		goto out;
> +
> +	if (hint >= 0) {
> +		ret = prev_by_hint(bb, s, hint);
> +		if (ret >= 0)
> +			goto out;
> +	}
> +
> +	lo = 0;
> +	hi = bb->count;
> +	p = bb->page;
> +
> +	while (hi - lo > 1) {
> +		int mid = (lo + hi)/2;
> +		sector_t a = BB_OFFSET(p[mid]);
> +
> +		if (a <= s)
> +			lo = mid;
> +		else
> +			hi = mid;
> +	}
> +
> +	if (BB_OFFSET(p[lo]) <= s)
> +		ret = lo;
> +out:
> +	return ret;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' can be backward merged
> + * with the bad range (from the bad table) index by 'behind'.
> + */
> +static bool can_merge_behind(struct badblocks *bb, struct badblocks_context *bad,
> +			     int behind)
> +{
> +	u64 *p = bb->page;
> +	sector_t s = bad->start;
> +	sector_t sectors = bad->len;
> +	int ack = bad->ack;
> +
> +	if ((s <= BB_OFFSET(p[behind])) &&
> +	    ((s + sectors) >= BB_OFFSET(p[behind])) &&
> +	    ((BB_END(p[behind]) - s) <= BB_MAX_LEN) &&
> +	    BB_ACK(p[behind]) == ack)
> +		return true;
> +	return false;
> +}
> +
> +/*
> + * Do backward merge for range indicated by 'bad' and the bad range
> + * (from the bad table) indexed by 'behind'. The return value is merged
> + * sectors from bad->len.
> + */
> +static int behind_merge(struct badblocks *bb, struct badblocks_context *bad,
> +			int behind)
> +{
> +	u64 *p = bb->page;
> +	sector_t s = bad->start;
> +	sector_t sectors = bad->len;
> +	int ack = bad->ack;
> +	int merged = 0;
> +
> +	WARN_ON(s > BB_OFFSET(p[behind]));
> +	WARN_ON((s + sectors) < BB_OFFSET(p[behind]));
> +
> +	if (s < BB_OFFSET(p[behind])) {
> +		WARN_ON((BB_LEN(p[behind]) + merged) >= BB_MAX_LEN);
> +
> +		merged = min_t(sector_t, sectors, BB_OFFSET(p[behind]) - s);
> +		p[behind] =  BB_MAKE(s, BB_LEN(p[behind]) + merged, ack);
> +	} else {
> +		merged = min_t(sector_t, sectors, BB_LEN(p[behind]));
> +	}
> +
> +	WARN_ON(merged == 0);
> +
> +	return merged;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' can be forward
> + * merged with the bad range (from the bad table) indexed by 'prev'.
> + */
> +static bool can_merge_front(struct badblocks *bb, int prev,
> +			    struct badblocks_context *bad)
> +{
> +	u64 *p = bb->page;
> +	sector_t s = bad->start;
> +	int ack = bad->ack;
> +
> +	if (BB_ACK(p[prev]) == ack &&
> +	    (s < BB_END(p[prev]) ||
> +	     (s == BB_END(p[prev]) && (BB_LEN(p[prev]) < BB_MAX_LEN))))
> +		return true;
> +	return false;
> +}
> +
> +/*
> + * Do forward merge for range indicated by 'bad' and the bad range
> + * (from bad table) indexed by 'prev'. The return value is sectors
> + * merged from bad->len.
> + */
> +static int front_merge(struct badblocks *bb, int prev, struct badblocks_context *bad)
> +{
> +	sector_t sectors = bad->len;
> +	sector_t s = bad->start;
> +	int ack = bad->ack;
> +	u64 *p = bb->page;
> +	int merged = 0;
> +
> +	WARN_ON(s > BB_END(p[prev]));
> +
> +	if (s < BB_END(p[prev])) {
> +		merged = min_t(sector_t, sectors, BB_END(p[prev]) - s);
> +	} else {
> +		merged = min_t(sector_t, sectors, BB_MAX_LEN - BB_LEN(p[prev]));
> +		if ((prev + 1) < bb->count &&
> +		    merged > (BB_OFFSET(p[prev + 1]) - BB_END(p[prev]))) {
> +			merged = BB_OFFSET(p[prev + 1]) - BB_END(p[prev]);
> +		}
> +
> +		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +				  BB_LEN(p[prev]) + merged, ack);
> +	}
> +
> +	return merged;
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
> +			      struct badblocks_context *bad)
> +{
> +	u64 *p = bb->page;
> +
> +	if ((prev > 0) &&
> +	    (BB_OFFSET(p[prev]) == bad->start) &&
> +	    (BB_END(p[prev - 1]) == BB_OFFSET(p[prev])) &&
> +	    (BB_LEN(p[prev - 1]) + BB_LEN(p[prev]) <= BB_MAX_LEN) &&
> +	    (BB_ACK(p[prev - 1]) == BB_ACK(p[prev])))
> +		return true;
> +	return false;
> +}
> +
> +/*
> + * Combine the bad ranges indexed by 'prev' and 'prev - 1' (from bad
> + * table) into one larger bad range, and the new range is indexed by
> + * 'prev - 1'.
> + */
> +static void front_combine(struct badblocks *bb, int prev)
> +{
> +	u64 *p = bb->page;
> +
> +	p[prev - 1] = BB_MAKE(BB_OFFSET(p[prev - 1]),
> +			      BB_LEN(p[prev - 1]) + BB_LEN(p[prev]),
> +			      BB_ACK(p[prev]));
> +	if ((prev + 1) < bb->count)
> +		memmove(p + prev, p + prev + 1, (bb->count - prev - 1) * 8);
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' is exactly forward
> + * overlapped with the bad range (from bad table) indexed by 'front'.
> + * Exactly forward overlap means the bad range (from bad table) indexed
> + * by 'prev' does not cover the whole range indicated by 'bad'.
> + */
> +static bool overlap_front(struct badblocks *bb, int front,
> +			  struct badblocks_context *bad)
> +{
> +	u64 *p = bb->page;
> +
> +	if (bad->start >= BB_OFFSET(p[front]) &&
> +	    bad->start < BB_END(p[front]))
> +		return true;
> +	return false;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' is exactly backward
> + * overlapped with the bad range (from bad table) indexed by 'behind'.
> + */
> +static bool overlap_behind(struct badblocks *bb, struct badblocks_context *bad,
> +			   int behind)
> +{
> +	u64 *p = bb->page;
> +
> +	if (bad->start < BB_OFFSET(p[behind]) &&
> +	    (bad->start + bad->len) > BB_OFFSET(p[behind]))
> +		return true;
> +	return false;
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
> +				struct badblocks_context *bad, int *extra)
> +{
> +	u64 *p = bb->page;
> +	int len;
> +
> +	WARN_ON(!overlap_front(bb, prev, bad));
> +
> +	if (BB_ACK(p[prev]) >= bad->ack)
> +		return false;
> +
> +	if (BB_END(p[prev]) <= (bad->start + bad->len)) {
> +		len = BB_END(p[prev]) - bad->start;
> +		if (BB_OFFSET(p[prev]) == bad->start)
> +			*extra = 0;
> +		else
> +			*extra = 1;
> +
> +		bad->len = len;
> +	} else {
> +		if (BB_OFFSET(p[prev]) == bad->start)
> +			*extra = 1;
> +		else
> +		/*
> +		 * prev range will be split into two, beside the overwritten
> +		 * one, an extra slot needed from bad table.
> +		 */
> +			*extra = 2;
> +	}
> +
> +	if ((bb->count + (*extra)) >= MAX_BADBLOCKS)
> +		return false;
> +
> +	return true;
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
> +			   struct badblocks_context *bad, int extra)
> +{
> +	u64 *p = bb->page;
> +	int n = extra;
> +	sector_t orig_end = BB_END(p[prev]);
> +	int orig_ack = BB_ACK(p[prev]);
> +
> +	switch (extra) {
> +	case 0:
> +		p[prev] = BB_MAKE(BB_OFFSET(p[prev]), BB_LEN(p[prev]),
> +				  bad->ack);
> +		break;
> +	case 1:
> +		if (BB_OFFSET(p[prev]) == bad->start) {
> +			p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +					  bad->len, bad->ack);
> +			memmove(p + prev + 2, p + prev + 1,
> +				(bb->count - prev - 1) * 8);
> +			p[prev + 1] = BB_MAKE(bad->start + bad->len,
> +					      orig_end - BB_END(p[prev]),
> +					      orig_ack);
> +		} else {
> +			p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +					  bad->start - BB_OFFSET(p[prev]),
> +					  BB_ACK(p[prev]));
> +			memmove(p + prev + 1 + n, p + prev + 1,
> +				(bb->count - prev - 1) * 8);
> +			p[prev + 1] = BB_MAKE(bad->start, bad->len, bad->ack);
> +		}
> +		break;
> +	case 2:
> +		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +				  bad->start - BB_OFFSET(p[prev]),
> +				  BB_ACK(p[prev]));
> +		memmove(p + prev + 1 + n, p + prev + 1,
> +			(bb->count - prev - 1) * 8);
> +		p[prev + 1] = BB_MAKE(bad->start, bad->len, bad->ack);
> +		p[prev + 2] = BB_MAKE(BB_END(p[prev + 1]),
> +				      orig_end - BB_END(p[prev + 1]),
> +				      BB_ACK(p[prev]));
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return bad->len;
> +}
> +
> +/*
> + * Explicitly insert a range indicated by 'bad' to the bad table, where
> + * the location is indexed by 'at'.
> + */
> +static int insert_at(struct badblocks *bb, int at, struct badblocks_context *bad)
> +{
> +	u64 *p = bb->page;
> +	sector_t sectors = bad->len;
> +	sector_t s = bad->start;
> +	int ack = bad->ack;
> +	int len;
> +
> +	WARN_ON(badblocks_full(bb));
> +
> +	len = min_t(sector_t, sectors, BB_MAX_LEN);
> +	if (at < bb->count)
> +		memmove(p + at + 1, p + at, (bb->count - at) * 8);
> +	p[at] = BB_MAKE(s, len, ack);
> +
> +	return len;
> +}
> +
>   /**
>    * badblocks_check() - check a given range for bad sectors
>    * @bb:		the badblocks structure that holds all badblock information
> 

