Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAD829CA
	for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 08:18:00 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9CC9A220B7;
	Mon, 27 Sep 2021 08:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1632730673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zGL/AMe26hmAIklf9HbbaB1fkOCI1nKEMJa0VhuyrZg=;
	b=VP+ovcQ35C+CrLSKQ3QLLeawqkoxFoBvpKmZYgQ1zKhEmObNj8c6BO+aaWkiFkW0DTu0eq
	QgPhEU/v3WpVe2jdupbqwcleCICMaXAhNLYTC0lRMu+Bvt1lpyT8spT9PqT1rZKVnhS/41
	4RkzhpPseqqDtrkEtFZkhOUshikFLto=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1632730673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zGL/AMe26hmAIklf9HbbaB1fkOCI1nKEMJa0VhuyrZg=;
	b=Zck/hcOT5GU0qM+t7QHk+KwnLsbOtRs64yLXCIeBds7UZ/fTeZmiJHmH0DlswYLo4cDcI9
	NTU9Cxpca+qHaIAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AEEEC13A42;
	Mon, 27 Sep 2021 08:17:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id zO+cHi5+UWHlRwAAMHmgww
	(envelope-from <colyli@suse.de>); Mon, 27 Sep 2021 08:17:50 +0000
Subject: Re: [PATCH v3 2/6] badblocks: add helper routines for badblock ranges
 handling
To: Geliang Tang <geliangtang@gmail.com>
Cc: antlists@youngman.org.uk, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-raid@vger.kernel.org,
 linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
 NeilBrown <neilb@suse.de>, Richard Fan <richard.fan@suse.com>,
 Vishal L Verma <vishal.l.verma@intel.com>
References: <20210913163643.10233-1-colyli@suse.de>
 <20210913163643.10233-3-colyli@suse.de>
 <eab6a9b0-d934-77e4-519c-cefc510b183a@gmail.com>
From: Coly Li <colyli@suse.de>
Message-ID: <e1becb07-00a2-db5a-e8a5-89db2fcd25ad@suse.de>
Date: Mon, 27 Sep 2021 16:17:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <eab6a9b0-d934-77e4-519c-cefc510b183a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US

On 9/27/21 3:25 PM, Geliang Tang wrote:
> On 9/14/21 00:36, Coly Li wrote:
>> This patch adds several helper routines to improve badblock ranges
>> handling. These helper routines will be used later in the improved
>> version of badblocks_set()/badblocks_clear()/badblocks_check().
>>
>> - Helpers prev_by_hint() and prev_badblocks() are used to find the bad
>>    range from bad table which the searching range starts at or after.
>>
>> - The following helpers are to decide the relative layout between the
>>    manipulating range and existing bad block range from bad table.
>>    - can_merge_behind()
>>      Return 'true' if the manipulating range can backward merge with the
>>      bad block range.
>>    - can_merge_front()
>>      Return 'true' if the manipulating range can forward merge with the
>>      bad block range.
>>    - can_combine_front()
>>      Return 'true' if two adjacent bad block ranges before the
>>      manipulating range can be merged.
>>    - overlap_front()
>>      Return 'true' if the manipulating range exactly overlaps with the
>>      bad block range in front of its range.
>>    - overlap_behind()
>>      Return 'true' if the manipulating range exactly overlaps with the
>>      bad block range behind its range.
>>    - can_front_overwrite()
>>      Return 'true' if the manipulating range can forward overwrite the
>>      bad block range in front of its range.
>>
>> - The following helpers are to add the manipulating range into the bad
>>    block table. Different routine is called with the specific relative
>>    layout between the maniplating range and other bad block range in the
>>    bad block table.
>>    - behind_merge()
>>      Merge the maniplating range with the bad block range behind its
>>      range, and return the number of merged length in unit of sector.
>>    - front_merge()
>>      Merge the maniplating range with the bad block range in front of
>>      its range, and return the number of merged length in unit of 
>> sector.
>>    - front_combine()
>>      Combine the two adjacent bad block ranges before the manipulating
>>      range into a larger one.
>>    - front_overwrite()
>>      Overwrite partial of whole bad block range which is in front of the
>>      manipulating range. The overwrite may split existing bad block 
>> range
>>      and generate more bad block ranges into the bad block table.
>>    - insert_at()
>>      Insert the manipulating range at a specific location in the bad
>>      block table.
>>
>> All the above helpers are used in later patches to improve the bad block
>> ranges handling for badblocks_set()/badblocks_clear()/badblocks_check().
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: NeilBrown <neilb@suse.de>
>> Cc: Richard Fan <richard.fan@suse.com>
>> Cc: Vishal L Verma <vishal.l.verma@intel.com>
>> ---
>>   block/badblocks.c | 374 ++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 374 insertions(+)
>>
>> diff --git a/block/badblocks.c b/block/badblocks.c
>> index d39056630d9c..efe316181e05 100644
>> --- a/block/badblocks.c
>> +++ b/block/badblocks.c
>> @@ -16,6 +16,380 @@
>>   #include <linux/types.h>
>>   #include <linux/slab.h>
>>   +/*
>> + * Find the range starts at-or-before 's' from bad table. The search
>> + * starts from index 'hint' and stops at index 'hint_end' from the bad
>> + * table.
>> + */
>> +static int prev_by_hint(struct badblocks *bb, sector_t s, int hint)
>> +{
>> +    u64 *p = bb->page;
>> +    int ret = -1;
>> +    int hint_end = hint + 2;
>
> How about declaring these variables following the "reverse Xmas tree" 
> order.
>

It makes sense. I will do this in whole set for next version.

Thanks for your review.

Coly Li

