Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1B5174C0
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 08:36:53 +0000 (UTC)
Received: from 82-132-229-125.dab.02.net ([82.132.229.125] helo=[192.168.252.81])
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1qJ8rQ-007GRe-Sv; Tue, 11 Jul 2023 09:36:40 +0100
Message-ID: <c49505f7-6756-5184-6a1a-044a278b7f60@codethink.co.uk>
Date: Tue, 11 Jul 2023 09:36:39 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] ACPI: NFIT: limit string attribute write
Content-Language: en-GB
To: Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org,
 linux-acpi@vger.kernel.org
Cc: nvdimm@lists.linux.dev, lenb@kernel.org
References: <20230704081751.12170-1-ben.dooks@codethink.co.uk>
 <249aa741-4b1e-ebdc-471a-3e5a634fad32@intel.com>
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
In-Reply-To: <249aa741-4b1e-ebdc-471a-3e5a634fad32@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/07/2023 19:34, Dave Jiang wrote:
> 
> 
> On 7/4/23 01:17, Ben Dooks wrote:
>> If we're writing what could be an arbitrary sized string into an 
>> attribute
>> we should probably use snprintf() just to be safe. Most of the other
>> attriubtes are some sort of integer so unlikely to be an issue so not
>> altered at this time.
>>
>> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
>> ---
>>   drivers/acpi/nfit/core.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>> index 9213b426b125..d7e9d9cd16d2 100644
>> --- a/drivers/acpi/nfit/core.c
>> +++ b/drivers/acpi/nfit/core.c
>> @@ -1579,7 +1579,7 @@ static ssize_t id_show(struct device *dev,
>>   {
>>       struct nfit_mem *nfit_mem = to_nfit_mem(dev);
>> -    return sprintf(buf, "%s\n", nfit_mem->id);
>> +    return snprintf(buf, PAGE_SIZE, "%s\n", nfit_mem->id);
> 
> Why not just convert it to sysfs_emit()?

I'll look into that.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html

