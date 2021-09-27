Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C63F3FCF
	for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 08:23:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0979D22098;
	Mon, 27 Sep 2021 08:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1632731030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=37o9ue6D55euseY87j2eVtMIU2ZEOiSWr0h3uppibpo=;
	b=mEmCCoa0naAO9rk9L+BWrTdgk5YyRGEv2i7pHHtnBn/1JVcWsTME3v//EfgkuFmg2tK6WX
	eKJyywKRLghT3BAj+3YGyt5iCDsMWiO3tNq2tAXkOOjsVvxhevMfx0A7DSckyzruz4f5O5
	6N2WE65afKo51F8kjRzsO5i/SZG0LnA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1632731030;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=37o9ue6D55euseY87j2eVtMIU2ZEOiSWr0h3uppibpo=;
	b=NsvW0sX2DUOMXz8fou8QufETZ23R0NJX0guAOpKhK3DsWM5cfAUmxlsrXsNpfOa9mUDfS2
	KvhBVZsWiRKF2uDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2218913A42;
	Mon, 27 Sep 2021 08:23:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 9/86OJJ/UWEzSwAAMHmgww
	(envelope-from <colyli@suse.de>); Mon, 27 Sep 2021 08:23:46 +0000
Subject: Re: [PATCH v3 1/6] badblocks: add more helper structure and routines
 in badblocks.h
To: Geliang Tang <geliangtang@gmail.com>
Cc: antlists@youngman.org.uk, Dan Williams <dan.j.williams@intel.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
 NeilBrown <neilb@suse.de>, nvdimm@lists.linux.dev,
 linux-raid@vger.kernel.org, Richard Fan <richard.fan@suse.com>,
 Vishal L Verma <vishal.l.verma@intel.com>
References: <20210913163643.10233-1-colyli@suse.de>
 <20210913163643.10233-2-colyli@suse.de>
 <e0fc4902-e8db-b507-651b-d930a74702ef@gmail.com>
From: Coly Li <colyli@suse.de>
Message-ID: <b0960871-1fc6-ed76-965c-7b0adff6641c@suse.de>
Date: Mon, 27 Sep 2021 16:23:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <e0fc4902-e8db-b507-651b-d930a74702ef@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US

On 9/27/21 3:23 PM, Geliang Tang wrote:
> Hi Coly,
>
> On 9/14/21 00:36, Coly Li wrote:
>> This patch adds the following helper structure and routines into
>> badblocks.h,
>> - struct badblocks_context
>>    This structure is used in improved badblocks code for bad table
>>    iteration.
>> - BB_END()
>>    The macro to culculate end LBA of a bad range record from bad
>>    table.
>> - badblocks_full() and badblocks_empty()
>>    The inline routines to check whether bad table is full or empty.
>> - set_changed() and clear_changed()
>>    The inline routines to set and clear 'changed' tag from struct
>>    badblocks.
>>
>> These new helper structure and routines can help to make the code more
>> clear, they will be used in the improved badblocks code in following
>> patches.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: NeilBrown <neilb@suse.de>
>> Cc: Richard Fan <richard.fan@suse.com>
>> Cc: Vishal L Verma <vishal.l.verma@intel.com>
>> ---
>>   include/linux/badblocks.h | 32 ++++++++++++++++++++++++++++++++
>>   1 file changed, 32 insertions(+)
>>
>> diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
>> index 2426276b9bd3..166161842d1f 100644
>> --- a/include/linux/badblocks.h
>> +++ b/include/linux/badblocks.h
>> @@ -15,6 +15,7 @@
>>   #define BB_OFFSET(x)    (((x) & BB_OFFSET_MASK) >> 9)
>>   #define BB_LEN(x)    (((x) & BB_LEN_MASK) + 1)
>>   #define BB_ACK(x)    (!!((x) & BB_ACK_MASK))
>> +#define BB_END(x)    (BB_OFFSET(x) + BB_LEN(x))
>>   #define BB_MAKE(a, l, ack) (((a)<<9) | ((l)-1) | ((u64)(!!(ack)) << 
>> 63))
>>     /* Bad block numbers are stored sorted in a single page.
>> @@ -41,6 +42,14 @@ struct badblocks {
>>       sector_t size;        /* in sectors */
>>   };
>>   +struct badblocks_context {
>> +    sector_t    start;
>> +    sector_t    len;
>
> I think the type of 'len' should be 'int' instead of 'sector_t', since 
> we used 'int sectors' as one of the arguments of _badblocks_set().


OK, I will change it.

>
>> +    int        ack;
>> +    sector_t    orig_start;
>> +    sector_t    orig_len;
>
> I think 'orig_start' and 'orig_len' can be dropped, see comments in 
> patch 3.

Yes, I will change it in next version. Please review the new version latter.

Thanks for your review.

Coly Li
