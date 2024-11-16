Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A76A47
	for <nvdimm@lists.linux.dev>; Sat, 16 Nov 2024 12:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731760882; cv=none; b=TQKhYntLDc1XygY9UiOVpdkAq4tIXnYnvwkVsEGVAvghOhOpiYoPJQdVIqERmey6I9YoefR/xolULD1eu0R4V489MmqU7TL4jBUvF4DxrKEG3tBqm4/NhGnzZrcc09IYoWUnQd/mgGZvBcqVGLhz789CIaw8Gx12uI4lmQRYg5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731760882; c=relaxed/simple;
	bh=3+EQXZdxkZkhS9V2BEsUVD2fzNOhXUHdEA1GAH1AxoY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oczkO/ODhveDD7VR4mKbFtreVcBRKhIjIDOwzUJjv87KmynWJAy4NJddLr/5xEd+xlFVG0h1tdDl6EDCvvwixuQZb1EoNMm4/NxQ8Oqxv0tMs6LTcBXZBrN2MKpGLMQ5zKLPJ1VIsjihuECHA7EmOVHLcW0L0ozFNlOrGSZfQ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZsGf7pPa; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZsGf7pPa"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7edb6879196so2018704a12.3
        for <nvdimm@lists.linux.dev>; Sat, 16 Nov 2024 04:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731760880; x=1732365680; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7LCynoPn19dfCOHYqjru4yO7txCVRlW/xym4tzc5li4=;
        b=ZsGf7pPaXctARCMTnVfLJWxZhdVw9kDSkok4myk2d3jfSgnBR8OOU5Mi2Emqoo5dOH
         0offzaYYU39ZoqtMyJHk90SdSNP0tM1MQf4EHqAMrPjwpk2ZD26Gs9lZd+AIGQPWhvbR
         cjz82o4OJACPCuwmHhSy+GpF4vvE2jZo/sNDoy13KvSFfqt0wXABy4Q72a1iC6Phoi2u
         M86i7rUNPu1nnz+NzN6Ll30k3cNoSW4LT1n8J+sK3/aDWYift98Hj/U/zxhWtz6UHsVR
         NTCBqvxkAa+n5LUHc5mg4rLNUM9dsj3GPbZL6QG8FlwrEK0ZVf3ojcUwzXgLIUfn9loB
         2RLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731760880; x=1732365680;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7LCynoPn19dfCOHYqjru4yO7txCVRlW/xym4tzc5li4=;
        b=s4bWmMmB+bWcR4N1xCrl6RS54xCuQDWuJiqWwOO62/6YMQR1Zrhtlh+QiqmhQVWTQf
         jbv4fBHFjiQgL4ie9SXnQn3sdARwANKtNlONqRKCRg3//0+WZgGKT2klVPqeuW9f0iuc
         cE+q+DtfjBL0fqAzS8C6jGtMGa1xyxTFI2+K1zipJmZeQi71Doz3BTYDs9AGHkG7XY2K
         mmtpyXxpXwOAXChmxnbPGc4NlF59/sERYXunRSSLPPrN6tyTI1NkLVzzLKUrmtkdreEu
         gaDESGgodMmy85OlloiQ4mOUReCsfTlfoWRHxeDaq8FPmI/FoIa6bjtX+v+sLlpffK+s
         W6pA==
X-Forwarded-Encrypted: i=1; AJvYcCW4d6X6G4ioKNgoDOdEatfiEAdnmjC4xmbU076yINaReBBVZcZf/cm1ha57mhF91uqKGN637iA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzA69npDZRKTdetjy1a704CzuBzRcmrLZaYCoLds+TQNMk6Ty94
	bBNVh00kffWsRUwtprHnSDSoh9deXbRzYM73xJocBuWRVKlGiGJM
X-Google-Smtp-Source: AGHT+IFs8EVfbw/QPULwfxkPOjAL+2s+zFhdIlynzF5Ui08rwGCnEWCd6ZyIupLPaGgcqrO1DBKVgg==
X-Received: by 2002:a17:90b:2e0e:b0:2e2:991c:d796 with SMTP id 98e67ed59e1d1-2ea154f2dbdmr7998426a91.9.1731760879745;
        Sat, 16 Nov 2024 04:41:19 -0800 (PST)
Received: from [172.18.38.232] ([14.139.108.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0dc305dsm27190125ad.44.2024.11.16.04.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Nov 2024 04:41:19 -0800 (PST)
Message-ID: <b943d500-438a-44ef-876c-53846c2198c0@gmail.com>
Date: Sat, 16 Nov 2024 18:11:13 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] acpi: nfit: vmalloc-out-of-bounds Read in
 acpi_nfit_ctl
To: Ira Weiny <ira.weiny@intel.com>, dan.j.williams@intel.com,
 vishal.l.verma@intel.com
Cc: dave.jiang@intel.com, rafael@kernel.org, lenb@kernel.org,
 nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
References: <20241115164223.20854-1-surajsonawane0215@gmail.com>
 <6737a14cdd16b_29946a2944e@iweiny-mobl.notmuch>
Content-Language: en-US
From: Suraj Sonawane <surajsonawane0215@gmail.com>
In-Reply-To: <6737a14cdd16b_29946a2944e@iweiny-mobl.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/11/24 01:00, Ira Weiny wrote:
> Suraj Sonawane wrote:
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
>> buf is not NULL and that buf_len is less than sizeof(*call_pkg)
>> before accessing it. This ensures safe access to the members of
>> call_pkg, including the nd_reserved2 array.
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
>> V4: Removed the explicit cast to maintain the original code style.
>>
>>   drivers/acpi/nfit/core.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>> index 5429ec9ef..84d8eef2a 100644
>> --- a/drivers/acpi/nfit/core.c
>> +++ b/drivers/acpi/nfit/core.c
>> @@ -454,8 +454,15 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>>   	if (cmd_rc)
>>   		*cmd_rc = -EINVAL;
>>   
>> -	if (cmd == ND_CMD_CALL)
>> +	if (cmd == ND_CMD_CALL) {
>> +		if (!buf || buf_len < sizeof(*call_pkg)) {
>> +			rc = -EINVAL;
>> +			goto out;
> 
> This goto is wrong.  This will result in ACPI_FREE() being called on an
> undefined out_obj.
> 
> This should be:
> 			return -EINVAL;
> 
Thanks for catching that. You’re correct about the goto issue. I had 
initialized out_obj to NULL in previous versions but missed it in this 
patch. In v5, I’ve re-initialized out_obj to NULL, to avoid unintended 
access. Here’s the updated patch link: 
https://lore.kernel.org/lkml/20241116114027.19303-1-surajsonawane0215@gmail.com/ 


> Ira
> 
>> +		}
>> +
>>   		call_pkg = buf;
>> +	}
>> +
>>   	func = cmd_to_func(nfit_mem, cmd, call_pkg, &family);
>>   	if (func < 0)
>>   		return func;
>> -- 
>> 2.34.1
>>

Best Regards,
Suraj Sonawane
