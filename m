Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DDD29CA
	for <nvdimm@lists.linux.dev>; Thu,  9 Dec 2021 19:20:50 +0000 (UTC)
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1mvOIK-0002D4-EG; Thu, 09 Dec 2021 18:37:29 +0000
Message-ID: <8f24c6f7-1799-e318-1b6c-e54083229b8b@youngman.org.uk>
Date: Thu, 9 Dec 2021 18:37:26 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 3/6] badblocks: improvement badblocks_set() for
 multiple ranges handling
Content-Language: en-US
To: Geliang Tang <geliang.tang@suse.com>, Coly Li <colyli@suse.de>
Cc: nvdimm@lists.linux.dev, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
 Vishal L Verma <vishal.l.verma@intel.com>
References: <20211202125245.76699-1-colyli@suse.de>
 <20211202125245.76699-4-colyli@suse.de>
 <20211209072859.GB26976@dhcp-10-157-36-190>
From: Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20211209072859.GB26976@dhcp-10-157-36-190>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/12/2021 07:28, Geliang Tang wrote:
> On Thu, Dec 02, 2021 at 08:52:41PM +0800, Coly Li wrote:
>> Recently I received a bug report that current badblocks code does not

> 
>> + *        +--------+----+
>> + *        |    S   | E  |
>> + *        +--------+----+
>> + * 2.2) The setting range size == already set range size
>> + * 2.2.1) If S and E are both acked or unacked range, the setting range S can
>> + *    be merged into existing bad range E. The result is,
>> + *        +-------------+
>> + *        |      S      |
>> + *        +-------------+
>> + * 2.2.2) If S is uncked setting and E is acked, the setting will be denied, and
> 
> uncked -> unacked
> 
>> + *    the result is,
>> + *        +-------------+
>> + *        |      E      |
>> + *        +-------------+
>> + * 2.2.3) If S is acked setting and E is unacked, range S can overwirte all of

overwirte -> overwrite

>> +      bad blocks range E. The result is,
>> + *        +-------------+
>> + *        |      S      |
>> + *        +-------------+
>> + * 2.3) The setting range size > already set range size
>> + *        +-------------------+
>> + *        |          S        |
>> + *        +-------------------+
>> + *        +-------------+
>> + *        |      E      |
>> + *        +-------------+
>> + *    For such situation, the setting range S can be treated as two parts, the
>> + *    first part (S1) is as same size as the already set range E, the second
>> + *    part (S2) is the rest of setting range.
>> + *        +-------------+-----+        +-------------+       +-----+
>> + *        |    S1       | S2  |        |     S1      |       | S2  |
>> + *        +-------------+-----+  ===>  +-------------+       +-----+
>> + *        +-------------+              +-------------+
>> + *        |      E      |              |      E      |
>> + *        +-------------+              +-------------+
>> + *    Now we only focus on how to handle the setting range S1 and already set
>> + *    range E, which are already explained in 1.2), for the rest S2 it will be
> 
Cheers,
Wol
