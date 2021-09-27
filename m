Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C437129CA
	for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 08:16:38 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A909F1FF54;
	Mon, 27 Sep 2021 08:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1632730591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EX5b2PoTJyve491JeLW2N7TfMIYrD37foMnGr9CA/0w=;
	b=rKyLH5uL9Cj+5X6l5/QRZY/PiRqBJ6UzOmpYP9JzcNqrrqHcOeoCVYhbJl7TBs004Qdqua
	MSuqFPVfF0N7/YfniGlmwGi14iA3E6hEQlFg2ObxCUmQ31vQ3NvKubTC84FjuNlzRPoc2a
	1RHgzsPF8Wt9JpJasJP6vrgajSAEhLY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1632730591;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EX5b2PoTJyve491JeLW2N7TfMIYrD37foMnGr9CA/0w=;
	b=VJUy5/syye5jIsbJ3kProycBldLTpI2ktTMoIrZxxKZk1/fykHONwU6+Bc7FaE4N8/BgOP
	xoBKI72jxh64cDBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 461EC13A42;
	Mon, 27 Sep 2021 08:16:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id aiz+BN19UWEsRwAAMHmgww
	(envelope-from <colyli@suse.de>); Mon, 27 Sep 2021 08:16:29 +0000
Subject: Re: [PATCH v3 3/6] badblocks: improvement badblocks_set() for
 multiple ranges handling
To: Geliang Tang <geliangtang@gmail.com>
Cc: antlists@youngman.org.uk, Dan Williams <dan.j.williams@intel.com>,
 nvdimm@lists.linux.dev, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 NeilBrown <neilb@suse.de>, Richard Fan <richard.fan@suse.com>,
 Vishal L Verma <vishal.l.verma@intel.com>
References: <20210913163643.10233-1-colyli@suse.de>
 <20210913163643.10233-4-colyli@suse.de>
 <8efbe758-74e4-32ea-d41e-639b750b27c0@gmail.com>
From: Coly Li <colyli@suse.de>
Message-ID: <8c1f4bc4-20c9-4711-4038-c23be7ae9a80@suse.de>
Date: Mon, 27 Sep 2021 16:16:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8efbe758-74e4-32ea-d41e-639b750b27c0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US

On 9/27/21 3:30 PM, Geliang Tang wrote:
> On 9/14/21 00:36, Coly Li wrote:

[snipped]
>> + * 2.1.1) If S and E are both acked or unacked range, the setting 
>> range S can
>> + *    be merged into existing bad range E. The result is,
>> + *        +-------------+
>> + *        |      S      |
>> + *        +-------------+
>> + * 2.1.2) If S is uncked setting and E is acked, the setting will be 
>> dinied, and
>
> uncked -> unacked
> dinied?
>

You are correct, it should be unacked.

>> + *    the result is,
>> + *        +-------------+
>> + *        |      E      |
>> + *        +-------------+
>> + * 2.1.3) If S is acked setting and E is unacked, range S can 
>> overwirte on E.
>> + *    An extra slot from the bad blocks table will be allocated for 
>> S, and head
>> + *    of E will move to end of the inserted range E. The result is,
>> + *        +--------+----+
>> + *        |    S   | E  |
>> + *        +--------+----+
>> + * 2.2) The setting range size == already set range size
>> + * 2.2.1) If S and E are both acked or unacked range, the setting 
>> range S can
>> + *    be merged into existing bad range E. The result is,
>> + *        +-------------+
>> + *        |      S      |
>> + *        +-------------+
>> + * 2.2.2) If S is uncked setting and E is acked, the setting will be 
>> dinied, and
>
> uncked -> unacked

Yes, thanks for pointing out the typo. I will fix them in next version.

[snipped]
>> +/* Do exact work to set bad block range into the bad block table */
>> +static int _badblocks_set(struct badblocks *bb, sector_t s, int 
>> sectors,
>> +              int acknowledged)
>> +{
>> +    u64 *p;
>> +    struct badblocks_context bad;
>> +    int prev = -1, hint = -1;
>> +    int len = 0, added = 0;
>> +    int retried = 0, space_desired = 0;
>> +    int rv = 0;
>> +    unsigned long flags;
>
> orig_start and orig_len are used in _badblocks_set() only, we can drop 
> them from struct badblocks_context, declare two local variables instead:
>
>         sector_t orig_start;
>         int orig_len;
>

It's fair, let me change it in next version.

[snipped]

Thanks for your review!

Coly Li
