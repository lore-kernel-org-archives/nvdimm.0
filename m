Received: from smtp.smtpout.orange.fr (smtp-30.smtpout.orange.fr [80.12.242.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47932F33
	for <nvdimm@lists.linux.dev>; Sun,  4 Sep 2022 16:05:11 +0000 (UTC)
Received: from [192.168.1.18] ([90.11.190.129])
	by smtp.orange.fr with ESMTPA
	id Us7LoN8WyXFXxUs7Lorkc5; Sun, 04 Sep 2022 18:05:04 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 04 Sep 2022 18:05:04 +0200
X-ME-IP: 90.11.190.129
Message-ID: <e82700e0-c27e-926f-cf07-11620afffea4@wanadoo.fr>
Date: Sun, 4 Sep 2022 18:05:02 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] nvdimm: Avoid wasting some memory.
Content-Language: en-GB
To: Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
 nvdimm@lists.linux.dev
References: <8355cb2b720f8cd0f1315b06d70b541ba38add30.1662299370.git.christophe.jaillet@wanadoo.fr>
 <6314b859df5e2_2202c6294f5@dwillia2-xfh.jf.intel.com.notmuch>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <6314b859df5e2_2202c6294f5@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 04/09/2022 à 16:38, Dan Williams a écrit :
> Christophe JAILLET wrote:
>> sizeof(struct btt_sb) is 4096.
>>
>> When using devm_kzalloc(), there is a small memory overhead and, on most
>> systems, this leads to 40 bytes of extra memory allocation.
>> So 5036 bytes are expected to be allocated.
>>
>> The memory allocator works with fixed size hunks of memory. In this case,
>> it will require 8192 bytes of memory because more than 4096 bytes are
>> required.
>>
>> In order to avoid wasting 4ko of memory, just use kzalloc() and add a
>> devm action to free it when needed.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   drivers/nvdimm/btt_devs.c | 17 ++++++++++++++++-
>>   1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
>> index fabbb31f2c35..7b79fb0b0338 100644
>> --- a/drivers/nvdimm/btt_devs.c
>> +++ b/drivers/nvdimm/btt_devs.c
>> @@ -332,6 +332,11 @@ static int __nd_btt_probe(struct nd_btt *nd_btt,
>>   	return 0;
>>   }
>>   
>> +void nd_btt_free(void *data)
>> +{
>> +	kfree(data);
>> +}
>> +
>>   int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns)
>>   {
>>   	int rc;
>> @@ -356,7 +361,17 @@ int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns)
>>   	nvdimm_bus_unlock(&ndns->dev);
>>   	if (!btt_dev)
>>   		return -ENOMEM;
>> -	btt_sb = devm_kzalloc(dev, sizeof(*btt_sb), GFP_KERNEL);
>> +
>> +	/*
>> +	 * 'struct btt_sb' is 4096. Using devm_kzalloc() would waste 4 ko of
>> +	 * memory because, because of a small memory over head, 8192 bytes
>> +	 * would be allocated. So keep this kzalloc()+devm_add_action_or_reset()
>> +	 */
>> +	btt_sb = kzalloc(sizeof(*btt_sb), GFP_KERNEL);
>> +	rc = devm_add_action_or_reset(dev, nd_btt_free, btt_sb);
>> +	if (rc)
>> +		return rc;
> 
> Thanks for the analysis and the patch. However, shouldn't this be
> something that is addressed internal to devm_kzalloc() rather than
> open-coded at every potential call site?
> 

Hi,
it would be fine, but it is not that easy.
(read: any idea to implement it is welcomed :) )

I made a try a few weeks ago. See [1].
It triggered obvious issues spotted by 0day robot <lkp@intel.com>.

In fact, "making clever things" in devm_kmalloc() prevent using 
devm_kfree() (or would require some over-engineering).


Greg also argued that it is likely that devm_  allocated memory does not 
happen that much.


I posted today a few similar patches as the one above in different 
subsystem to get some feed-backs whether open-coding it in "interesting" 
places make sense or not.

Spotted such places is not that hard with a home made additional check 
in smatch.

CJ

[1]: 
https://lore.kernel.org/all/92ec2f78e8d38f68da95d9250cf3f86b2fbe78ad.1658570017.git.christophe.jaillet@wanadoo.fr/
