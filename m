Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E0B1D1724
	for <nvdimm@lists.linux.dev>; Thu, 14 Nov 2024 09:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731575976; cv=none; b=Gd/RUHOyLsZPIUZu0q6Z5/8BoT/ky2d3wrTm5QZTsfn5nvCsdFqqUIWpfqbYl2idzzngB5iYTRFwztrpx3psav5IsUnuT53UGVPsoPB6ljlUM76zoo41Kslt5EgN1DPU/ndyefVCtDZ66qfFuSKPWWsMHjd4O6vDRN+o09n0pME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731575976; c=relaxed/simple;
	bh=NU1w+haqDXEPicku8Ol9S8ylkWjc+N2IczRGt6lLWy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BOHiZkVU77Cx9JWnXPY16NI1kmrRLMR1WL6NjIfBW/RqcbcyPlkIZ1aeVQ9ixKo91aRxBHANExopsQzxyB2QjGMNBC0EgyumLAFaOZZzzOlnDmIh3Kjwe9HxGmtZSROhv/g4oydVcPoiOJqL1N+uj4ysft27GrDxFol70p3tl1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DDhRXN8b; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DDhRXN8b"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-211c1bd70f6so4093045ad.0
        for <nvdimm@lists.linux.dev>; Thu, 14 Nov 2024 01:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731575974; x=1732180774; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FUt/EcD6vorUbwGG3Sx+YdUqBqHorJh6OABgPgdjzc8=;
        b=DDhRXN8bmfsNtqg+OJdTE+Aiokj+WaVRqZLPrVyNQL3VRQd+YSp8sdZqspclYMRAyW
         ZABeY5x7X87JjXeDHKOpLa09SJ5zopOTrUVJH+VqrrkJc6fdOz4W1gwEB1rRdi8zph/q
         QcODAj9Zgr2SxB9ZYKOGJAqwCmVOimMIFroBKM+bRWM4eRkWVTPGfLc4je9j0hU6xE16
         CJOHHh2BFwLKuyKMg/6Nh6e53QUWtgKrlkDiWxTo277x8de3Do+qGfZyCbVX0bhgEK3/
         Y+TSOjVpK4Keyu880cw5GUi99dtOgdzpnBRdU0uDR/1VEXmFejkIF1hVsPwI3zb0acaj
         rkeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731575974; x=1732180774;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FUt/EcD6vorUbwGG3Sx+YdUqBqHorJh6OABgPgdjzc8=;
        b=CEVK5mf0ZCBUaPEfKlKDP9gAx9eC52TVRcGigB0e9967Lgg7Ov946FCLDMtRLLgGZi
         8NBxKIN9UMqUVCl03z2QTbMLi8OHvGqR8ubQKbe8InWjOklwkUd+J0rY6PCTTrhjWclQ
         n0nus5PSjwIy/sZp24BQcEtVqh7EYoqoHuR5hmoQdUBvGaxDr97sHmGz/yibYSa12y4x
         XHjoXupK9RMSd17UpO8en5UdPe04kD7wmxQIP+tjNZjdlCHjzbe+09r81ChQ+uxo9btQ
         3n7WHq88Z+HgQCoLidi8nr/Ne7lL4BgemjH/5w7G/BtekFzEgCE3U+a1EkdZoA6Z5hZH
         dlyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXj/RpMel6xQbEH1HMkf5S9Yv4OgzV6acb084qvPnTlwrpzk23LYy25HNCdyvVJFsCXAeyAdGU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8JWAPMAvpwYBOZaWl075G/CKsJgNs8g5FdRk0ABCAt1qI+n40
	MbavxYN93GS6tFV9txOV0UU8AS0i6Qv85//oqreg1KfJKwkaxu8kcHxruguSbbY=
X-Google-Smtp-Source: AGHT+IFAsiiRUQ9C9JCTDYc5W3f/4gx2o3puNGPkDNQyTPO+rxV8Vtlfhiu/zcezOPbWY9TYDPq3nA==
X-Received: by 2002:a17:902:f54a:b0:20b:6c1e:1e13 with SMTP id d9443c01a7336-211c0fbf416mr39095895ad.23.1731575974189;
        Thu, 14 Nov 2024 01:19:34 -0800 (PST)
Received: from [192.168.0.198] ([14.139.108.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7246a6e6fe8sm817929b3a.62.2024.11.14.01.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2024 01:19:33 -0800 (PST)
Message-ID: <1cab2343-8d74-4477-9046-7940917fa7be@gmail.com>
Date: Thu, 14 Nov 2024 14:49:26 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] acpi: nfit: vmalloc-out-of-bounds Read in
 acpi_nfit_ctl
To: Dave Jiang <dave.jiang@intel.com>, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: rafael@kernel.org, lenb@kernel.org, nvdimm@lists.linux.dev,
 linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
References: <20241113125157.14390-1-surajsonawane0215@gmail.com>
 <c69d74f7-4484-4fc6-9b95-d2ae86ead794@intel.com>
Content-Language: en-US
From: Suraj Sonawane <surajsonawane0215@gmail.com>
In-Reply-To: <c69d74f7-4484-4fc6-9b95-d2ae86ead794@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/11/24 22:32, Dave Jiang wrote:
> 
> 
> On 11/13/24 5:51 AM, Suraj Sonawane wrote:
>> Fix an issue detected by syzbot with KASAN:
>>
>> BUG: KASAN: vmalloc-out-of-bounds in cmd_to_func drivers/acpi/nfit/
>> core.c:416 [inline]
>> BUG: KASAN: vmalloc-out-of-bounds in acpi_nfit_ctl+0x20e8/0x24a0
>> drivers/acpi/nfit/core.c:459
>>
>> The issue occurs in cmd_to_func when the call_pkg->nd_reserved2
>> array is accessed without verifying that call_pkg points to a buffer
>> that is appropriately sized as a struct nd_cmd_pkg. This can lead
>> to out-of-bounds access and undefined behavior if the buffer does not
>> have sufficient space.
>>
>> To address this, a check was added in acpi_nfit_ctl() to ensure that
>> buf is not NULL and that buf_len is greater than sizeof(*call_pkg)
>> before casting buf to struct nd_cmd_pkg *. This ensures safe access
>> to the members of call_pkg, including the nd_reserved2 array.
>>
>> Reported-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=7534f060ebda6b8b51b3
>> Tested-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
>> Fixes: ebe9f6f19d80 ("acpi/nfit: Fix bus command validation")
>> Signed-off-by: Suraj Sonawane <surajsonawane0215@gmail.com>
>> ---
>> V1: https://lore.kernel.org/lkml/20241111080429.9861-1-surajsonawane0215@gmail.com/
>> V2: Initialized `out_obj` to `NULL` in `acpi_nfit_ctl()` to prevent
>> potential uninitialized variable usage if condition is true.
>> V3: Changed the condition to if (!buf || buf_len < sizeof(*call_pkg))
>> and updated the Fixes tag to reference the correct commit.
>>
>>   drivers/acpi/nfit/core.c | 12 +++++++++---
>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>> index 5429ec9ef..eb5349606 100644
>> --- a/drivers/acpi/nfit/core.c
>> +++ b/drivers/acpi/nfit/core.c
>> @@ -439,7 +439,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>>   {
>>   	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
>>   	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
>> -	union acpi_object in_obj, in_buf, *out_obj;
>> +	union acpi_object in_obj, in_buf, *out_obj = NULL;
> 
> Looking at the code later, out_obj is always assigned before access. I'm not seeing a path where out_obj would be accessed unitialized...

I initialized out_obj to NULL to prevent potential issues where goto out 
might access an uninitialized pointer, ensuring ACPI_FREE(out_obj) 
handles NULL safely in the cleanup section. This covers cases where the 
condition !buf || buf_len < sizeof(*call_pkg) triggers an early exit, 
preventing unintended behavior.

> 
> https://elixir.bootlin.com/linux/v6.12-rc7/source/drivers/acpi/nfit/core.c#L538
>   
>>   	const struct nd_cmd_desc *desc = NULL;
>>   	struct device *dev = acpi_desc->dev;
>>   	struct nd_cmd_pkg *call_pkg = NULL;
>> @@ -454,8 +454,14 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>>   	if (cmd_rc)
>>   		*cmd_rc = -EINVAL;
>>   
>> -	if (cmd == ND_CMD_CALL)
>> -		call_pkg = buf;
>> +	if (cmd == ND_CMD_CALL) {
>> +		if (!buf || buf_len < sizeof(*call_pkg)) {
>> +			rc = -EINVAL;
>> +			goto out;
>> +		}
>> +		call_pkg = (struct nd_cmd_pkg *)buf;
> 
> Is the casting needed? It wasn't in the old code
> 

I tested the code both with and without the cast using syzbot, and it 
didn't result in any errors in either case. Since the buffer (buf) is 
being used as a pointer to struct nd_cmd_pkg, and the casting works in 
both scenarios, it appears that the cast may not be strictly necessary 
for this particular case.

I can remove the cast and retain the original code structure, as it does 
not seem to affect functionality. However, the cast was added for 
clarity and type safety to ensure that buf is explicitly treated as a 
struct nd_cmd_pkg *.

Would you prefer to remove the cast, or should I keep it as is for type 
safety and clarity?

>> +	}
>> +
>>   	func = cmd_to_func(nfit_mem, cmd, call_pkg, &family);
>>   	if (func < 0)
>>   		return func;
> 

Thank you for your feedback and your time.
