Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC29D173
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 06:56:03 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F0EE21F387;
	Fri, 10 Dec 2021 06:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1639119355; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CyaE1JpY1hv5VK1kxF43YeX/UDK2PG3AVIoeKjKBuu8=;
	b=p/GvWyntmacapw2NzVALxu+ijKJKFWoDDKwEeZDewQqFlwUKXp2BJzoKuFKTnvhN6j0GAI
	KvuP2f8nd4eMLSx8gG1Xbr7v+NT0k3sHAPcH/+AnFbv7LmTi1XWvMAsr77T3T/A/K/q66I
	H4jZufqMVXjABiOvUiLeOJmV35eU6KM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1639119355;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CyaE1JpY1hv5VK1kxF43YeX/UDK2PG3AVIoeKjKBuu8=;
	b=0Anrk5kqtfUOQbhwNQnu6Tfus1lmVvo9G+UqOrbtwnkT2qtVhH/45+U1Nslg8GxfFbeVfA
	VQ8JQier4xGoomBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 48F7D13DD2;
	Fri, 10 Dec 2021 06:55:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id k69uBfn5smEmdgAAMHmgww
	(envelope-from <colyli@suse.de>); Fri, 10 Dec 2021 06:55:53 +0000
Message-ID: <809b3af2-079c-d7ce-e497-9f77bdcbd3b5@suse.de>
Date: Fri, 10 Dec 2021 14:55:51 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v3 3/6] badblocks: improvement badblocks_set() for
 multiple ranges handling
Content-Language: en-US
To: Wols Lists <antlists@youngman.org.uk>
Cc: nvdimm@lists.linux.dev, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
 Vishal L Verma <vishal.l.verma@intel.com>,
 Geliang Tang <geliang.tang@suse.com>
References: <20211202125245.76699-1-colyli@suse.de>
 <20211202125245.76699-4-colyli@suse.de>
 <20211209072859.GB26976@dhcp-10-157-36-190>
 <8f24c6f7-1799-e318-1b6c-e54083229b8b@youngman.org.uk>
From: Coly Li <colyli@suse.de>
In-Reply-To: <8f24c6f7-1799-e318-1b6c-e54083229b8b@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/10/21 2:37 AM, Wols Lists wrote:
> On 09/12/2021 07:28, Geliang Tang wrote:
>> On Thu, Dec 02, 2021 at 08:52:41PM +0800, Coly Li wrote:
>>> Recently I received a bug report that current badblocks code does not
>
>>
>>> + *        +--------+----+
>>> + *        |    S   | E  |
>>> + *        +--------+----+
>>> + * 2.2) The setting range size == already set range size
>>> + * 2.2.1) If S and E are both acked or unacked range, the setting 
>>> range S can
>>> + *    be merged into existing bad range E. The result is,
>>> + *        +-------------+
>>> + *        |      S      |
>>> + *        +-------------+
>>> + * 2.2.2) If S is uncked setting and E is acked, the setting will 
>>> be denied, and
>>
>> uncked -> unacked
>>
>>> + *    the result is,
>>> + *        +-------------+
>>> + *        |      E      |
>>> + *        +-------------+
>>> + * 2.2.3) If S is acked setting and E is unacked, range S can 
>>> overwirte all of
>
> overwirte -> overwrite

Thanks, I update my local codespell dictionary file with all the typo 
checks. They will be fixed in next version.

Coly Li
