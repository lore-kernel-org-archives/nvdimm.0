Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008067C
	for <nvdimm@lists.linux.dev>; Sat,  5 Mar 2022 14:02:31 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1D606210F4;
	Sat,  5 Mar 2022 14:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1646488944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZSDsNox7dNE91OHloqrgYhdMtdE0Qf/n7QOf6dY20Eo=;
	b=hQzJbwDkMsA7OKcsNv0aBXyVVezTcZr2PNB36A78sa+j+DCdxAOpdWNxE89n83pKBxBw5k
	7iodvQquvdPMinogQ+Kc6Bobi8+9xnxaV/xgbefgWXYOMgWDw/67lbnQVAQ85vhPu8xgvh
	NB2MwsDh4sTbAgDxJuQLo80hefyPp/Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1646488944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZSDsNox7dNE91OHloqrgYhdMtdE0Qf/n7QOf6dY20Eo=;
	b=+/HbeUZtpqmdvePnZCppzSQk9VIUswy8xDh3scEFtQTyKb0zPzN1VIawG3dKQ9wH3N+Kif
	47uCPMywddtlsNDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E75CF13345;
	Sat,  5 Mar 2022 14:02:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id c7p1JWhtI2JfUgAAMHmgww
	(envelope-from <colyli@suse.de>); Sat, 05 Mar 2022 14:02:16 +0000
Message-ID: <a6296031-4a73-170a-2505-dc6d902179d8@suse.de>
Date: Sat, 5 Mar 2022 22:02:13 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 07/10] bcache: use bvec_kmap_local in bio_csum
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
 Justin Sanders <justin@coraid.com>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>, Denis Efremov
 <efremov@linux.com>, Jens Axboe <axboe@kernel.dk>,
 Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org,
 drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
 nvdimm@lists.linux.dev
References: <20220303111905.321089-1-hch@lst.de>
 <20220303111905.321089-8-hch@lst.de>
From: Coly Li <colyli@suse.de>
In-Reply-To: <20220303111905.321089-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/3/22 7:19 PM, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>


Acked-by: Coly Li <colyli@suse.de>


Thanks.


Coly Li


> ---
>   drivers/md/bcache/request.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 6869e010475a3..fdd0194f84dd0 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -44,10 +44,10 @@ static void bio_csum(struct bio *bio, struct bkey *k)
>   	uint64_t csum = 0;
>   
>   	bio_for_each_segment(bv, bio, iter) {
> -		void *d = kmap(bv.bv_page) + bv.bv_offset;
> +		void *d = bvec_kmap_local(&bv);
>   
>   		csum = crc64_be(csum, d, bv.bv_len);
> -		kunmap(bv.bv_page);
> +		kunmap_local(d);
>   	}
>   
>   	k->ptr[KEY_PTRS(k)] = csum & (~0ULL >> 1);


