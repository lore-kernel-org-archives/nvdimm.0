Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C02B1D61A1
	for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 16:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731689958; cv=none; b=jx0aX+uFF3C2iZWWHCF7HaFulCtwMhVRVQpmbiwUc7AmGrxS0uAbm9/B81qb+kpiOc+z6yBWzNL8OMJQh5tpQgP8tWfEV3p08+wSuNkEn/KRfA352pgEFW4uayi70TB1he3k9ogv9VOQo1W8McdNC1GKIVzpsGKxWEZsCqK6bJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731689958; c=relaxed/simple;
	bh=dOBnJCqCaWZUjhxd2LK7dRHfKa39/Gqlsuh+gHaHxMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N9reIuicsz8QS5wkK2lfQ8k30jQGbY/RszBZZN3+/XZrzsDJzTQy5AFQlvZIeSgtq4OGjEKIcyqaxT0EgTeRFRYY1Sse527V4x/T/1Qpr2z477Jrt9tvrMn+mgAkPjZnZmNQa/sL5wZV2iTxDbmNqUNB5tZ9ka1fqiDjPLGE128=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lux0wDco; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lux0wDco"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-211a4682fcaso15618005ad.2
        for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 08:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731689956; x=1732294756; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5My4RsjQqVpFcnn6C+E7zXPeOJ7hSHgTRe960WZ9eQ8=;
        b=Lux0wDco3tow7WekDIxHibL+xE8EDD3sseNg5jN545ulYNT304cMYyAwsJNiA+hKyZ
         XOsF8WO/c1a3rkNfiw9h1dZialcyhNZlcdUPA8aV2qn7i0t7oQj+hIklMPLw+MqNpI6U
         lKMQexuoD4q1kIsxFbRZfHYajsCJbwzYP4Ekvwx9ZGSuEUaa84BKcZ6x4tmqdbYJtOS9
         R+NHoN+hKrWVqAKhuddrs6f1477l9V4VRSaBrnUallvMPpLXNOzdc84vmXag1cE/lz1z
         LXjyr8cfE5puri35pq0zUu8xl5qoRS/GFg6LDMPBET21EGsK5VhzVHWxnLixKJ9BXbP6
         Kutw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731689956; x=1732294756;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5My4RsjQqVpFcnn6C+E7zXPeOJ7hSHgTRe960WZ9eQ8=;
        b=DNCNcM3lA9E+DRUUgcPpxF42CnPQSCF+UXxAgfCNXzvQEeWdQpDTLVmkxa6r/CDBE/
         CIah1qNIHRLymXTBnWjEw7T31xWeTsMZa7kno3wtX7JRbsecJdxM2Zk5isHMSsQWnW3b
         ZdGb+vjF+QSalhvz4+4ITvVHr3hvKg9HsxN6ANNzIsfDjFnM6oF76s5nhQtHEmWvb/1/
         eNk0o8j5hRKLXBQV+b7rIkRoetJiQXzTBhM2RfkrznCQWVnp7qzoZQvFxbj0esRyqbSQ
         tGp151F5yfSSs3YXrHvtDP1DtJNT9vQ08zE/MEsDQiEMA9k+yu5jMxRiI6z4MYfFaQ7W
         ygfg==
X-Forwarded-Encrypted: i=1; AJvYcCXNR9kdzctoJ0VQdr927QMw7ereEghPmzpMLGkfhOAKCqqkWrWYJaVRU1ExPDVLhC2x3J6ek4U=@lists.linux.dev
X-Gm-Message-State: AOJu0YypQmf79Iq45jlknOkrcx3d7YAjU3jPMMUJlq0wSbWXzPXn4Q/t
	pwIBYcTiXSwmy2SSFll0H0LcHi76k6e1/QUw90VL0LIkSTPZI5mL
X-Google-Smtp-Source: AGHT+IE89VkCeLragNsInNsnFoD3XvhKObDCdMphxIgayw0eyZC/oYovPrx7FAYAPhzN0nuu1Lrhzg==
X-Received: by 2002:a17:902:d48e:b0:211:e693:90df with SMTP id d9443c01a7336-211e6939443mr9041615ad.46.1731689956450;
        Fri, 15 Nov 2024 08:59:16 -0800 (PST)
Received: from [192.168.0.198] ([14.139.108.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0eca2d9sm14520685ad.90.2024.11.15.08.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 08:59:15 -0800 (PST)
Message-ID: <b686dd59-29a0-44ac-82e1-86c26abda915@gmail.com>
Date: Fri, 15 Nov 2024 22:29:10 +0530
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
 <1cab2343-8d74-4477-9046-7940917fa7be@gmail.com>
 <f13b285d-cf5b-4edf-a7d5-933ccd20556a@intel.com>
Content-Language: en-US
From: Suraj Sonawane <surajsonawane0215@gmail.com>
In-Reply-To: <f13b285d-cf5b-4edf-a7d5-933ccd20556a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/11/24 21:12, Dave Jiang wrote:
> 
> 
> On 11/14/24 2:19 AM, Suraj Sonawane wrote:
>> On 13/11/24 22:32, Dave Jiang wrote:
>>>
>>>
>>> On 11/13/24 5:51 AM, Suraj Sonawane wrote:
>>>> Fix an issue detected by syzbot with KASAN:
>>>>
>>>> BUG: KASAN: vmalloc-out-of-bounds in cmd_to_func drivers/acpi/nfit/
>>>> core.c:416 [inline]
>>>> BUG: KASAN: vmalloc-out-of-bounds in acpi_nfit_ctl+0x20e8/0x24a0
>>>> drivers/acpi/nfit/core.c:459
>>>>
>>>> The issue occurs in cmd_to_func when the call_pkg->nd_reserved2
>>>> array is accessed without verifying that call_pkg points to a buffer
>>>> that is appropriately sized as a struct nd_cmd_pkg. This can lead
>>>> to out-of-bounds access and undefined behavior if the buffer does not
>>>> have sufficient space.
>>>>
>>>> To address this, a check was added in acpi_nfit_ctl() to ensure that
>>>> buf is not NULL and that buf_len is greater than sizeof(*call_pkg)
>>>> before casting buf to struct nd_cmd_pkg *. This ensures safe access
>>>> to the members of call_pkg, including the nd_reserved2 array.
>>>>
>>>> Reported-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
>>>> Closes: https://syzkaller.appspot.com/bug?extid=7534f060ebda6b8b51b3
>>>> Tested-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
>>>> Fixes: ebe9f6f19d80 ("acpi/nfit: Fix bus command validation")
>>>> Signed-off-by: Suraj Sonawane <surajsonawane0215@gmail.com>
>>>> ---
>>>> V1: https://lore.kernel.org/lkml/20241111080429.9861-1-surajsonawane0215@gmail.com/
>>>> V2: Initialized `out_obj` to `NULL` in `acpi_nfit_ctl()` to prevent
>>>> potential uninitialized variable usage if condition is true.
>>>> V3: Changed the condition to if (!buf || buf_len < sizeof(*call_pkg))
>>>> and updated the Fixes tag to reference the correct commit.
>>>>
>>>>    drivers/acpi/nfit/core.c | 12 +++++++++---
>>>>    1 file changed, 9 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>>>> index 5429ec9ef..eb5349606 100644
>>>> --- a/drivers/acpi/nfit/core.c
>>>> +++ b/drivers/acpi/nfit/core.c
>>>> @@ -439,7 +439,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>>>>    {
>>>>        struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
>>>>        struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
>>>> -    union acpi_object in_obj, in_buf, *out_obj;
>>>> +    union acpi_object in_obj, in_buf, *out_obj = NULL;
>>>
>>> Looking at the code later, out_obj is always assigned before access. I'm not seeing a path where out_obj would be accessed unitialized...
>>
>> I initialized out_obj to NULL to prevent potential issues where goto out might access an uninitialized pointer, ensuring ACPI_FREE(out_obj) handles NULL safely in the cleanup section. This covers cases where the condition !buf || buf_len < sizeof(*call_pkg) triggers an early exit, preventing unintended behavior.
> 
> ok
> 
>>
>>>
>>> https://elixir.bootlin.com/linux/v6.12-rc7/source/drivers/acpi/nfit/core.c#L538
>>>   
>>>>        const struct nd_cmd_desc *desc = NULL;
>>>>        struct device *dev = acpi_desc->dev;
>>>>        struct nd_cmd_pkg *call_pkg = NULL;
>>>> @@ -454,8 +454,14 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>>>>        if (cmd_rc)
>>>>            *cmd_rc = -EINVAL;
>>>>    -    if (cmd == ND_CMD_CALL)
>>>> -        call_pkg = buf;
>>>> +    if (cmd == ND_CMD_CALL) {
>>>> +        if (!buf || buf_len < sizeof(*call_pkg)) {
>>>> +            rc = -EINVAL;
>>>> +            goto out;
>>>> +        }
>>>> +        call_pkg = (struct nd_cmd_pkg *)buf;
>>>
>>> Is the casting needed? It wasn't in the old code
>>>
>>
>> I tested the code both with and without the cast using syzbot, and it didn't result in any errors in either case. Since the buffer (buf) is being used as a pointer to struct nd_cmd_pkg, and the casting works in both scenarios, it appears that the cast may not be strictly necessary for this particular case.
>>
>> I can remove the cast and retain the original code structure, as it does not seem to affect functionality. However, the cast was added for clarity and type safety to ensure that buf is explicitly treated as a struct nd_cmd_pkg *.
>>
>> Would you prefer to remove the cast, or should I keep it as is for type safety and clarity?
> 
> I would just leave it as it was.

I have submitted the patch with the original code unchanged(without 
casting) by testing with syzbot. You can view it 
here:https://lore.kernel.org/lkml/20241115164223.20854-1-surajsonawane0215@gmail.com/

> 
>>
>>>> +    }
>>>> +
>>>>        func = cmd_to_func(nfit_mem, cmd, call_pkg, &family);
>>>>        if (func < 0)
>>>>            return func;
>>>
>>
>> Thank you for your feedback and your time.
> 

