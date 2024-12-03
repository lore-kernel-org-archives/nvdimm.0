Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EF319C543
	for <nvdimm@lists.linux.dev>; Tue,  3 Dec 2024 09:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733217497; cv=none; b=jKpRjFNuXufsKRTZb0AMOUhq+b95cVHNVZPR/lAjdyT1hp2knx+VsGe6BlRyujCeMWImYXi+mRWH7shnLtmZvETQI8AVakd994ZacnlI2u0bL100ObHuIeCafvZ94FBasSAeJkzvWmkFnEld6RpBhs11wqdNWxBV6ghVHTtwQ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733217497; c=relaxed/simple;
	bh=6BXbAOjCw5aBhHqklYbSDlSHWUFzfTiI55oePrqS2pU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fVzlxLvud7YXCJU/7j+nEX5v6QoYGyoKJXrmr5lApDFAvRhseJp0JXFxLAmcBpheIRU2Nkt6fVK4ixucWUzHnhTA8TRk8t1+nCVlTg33+HyMIors8NHXHKM4PLTaY7ojP7jG/bfVgQgIod+zmuBv+fB7dwQ0iJ7Jd9ZvEWMN0TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QFFULqp3; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QFFULqp3"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-71d551855c2so2164040a34.3
        for <nvdimm@lists.linux.dev>; Tue, 03 Dec 2024 01:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733217495; x=1733822295; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3rH15lOfc44plaRCzN7FQcIPWREiXBgWt55OFo1yciQ=;
        b=QFFULqp3PyWvyMxyh2f+4jWwZcZoFs/blnrLrBBGsKn9nUHTZbjv8nZ2ZKfh4RVUq4
         QGRESZo0JYjELNXfuPLmg2avw3vWj4NZTWdIHHRMiJ2L2b0iCYuTBb7FaT3ivjA0UKN5
         nPsNUSpVYx02i/4mMvXTvGPhOnsdosdaPqNfYIMG60EhY0XAXra6vVMXhNvlg8ky2Meg
         X2ewpmXNwILoOohLeIuFSVjeisH0lG3iAOrqvc3wNkX8+mik8K+Xvjw/fbXmEaG4UP9n
         CyfpJZ6/XFlyVuWkLpMSKPOPHDxHof1JJsd1YW/6ZtPjvavWert/lpuqbzijBuYCYoVa
         SygQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733217495; x=1733822295;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3rH15lOfc44plaRCzN7FQcIPWREiXBgWt55OFo1yciQ=;
        b=NR2BCHbnWp1wQof0Xi7qv1gHEsnNob5fBcarpx1qBU4RvjJDBNfU+osByXm6XzIXTh
         4Xp97o1x4BGTZ9VyHiU0dhkZ9C6m62pUAloLNT8mpCflfUvGA/KvCLH7yaPPkQOVJf/7
         8KP7DCufwZKJp8zfUSdu6ZfBqOUOX1C5WDBmYXWQUUEHl2FTqYrCWw9Ej9ajuiYCiahS
         KUszuqL5uzG3RS0MBJp7DzFDEAapQpf/S4hlzVyNIV4LZQ4xj3lsCGcTIexrziLSi/UH
         J4/vdzcH0ONQzl5WZFUyaPi0XPo52a9GMRs4A7oXUyYrnSbHLUQw5JTjLnfBeafgoPJh
         zKiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXO5RCgc/gDPe1IhoFspCWoOCNdyYotglEgVlPnF48r+HLDubuDJG/vZBrW890jYP1K25Kh/M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwbxWDDSAvBxcK2Xdv92yUHaqfoVvmgaeWj4XFOxZjbYZ0Xwqmy
	aTpz3CsHFdVTSyjnJqE88Xto8AAECai3LnCrinWz+4F6Ti8E9C+w
X-Gm-Gg: ASbGncthX7vq+KesaO1kwtpQT9wrXeDeK1jSoYwDCWFnnbWOoTZg8hyhmN308V8B7Vc
	1J/3fCrkd50EDol/9CvN+PMjTnOv0KESp2+69ePuQ6x04p+XdBs7M9btvc/pXwnKwBUj8h+FTrs
	CQgthiT78myI3lOvfm9utPmGaK9H6dUU1SIatpttm2628L0JtM+5B0xNyRCtmjycoK25d5sfRYX
	I5ddbpptRHNR2SaBbI6pZSir5+8QaFnmAfjw1YV/BkhaZOklBjfXnPIQJG2Ea8n
X-Google-Smtp-Source: AGHT+IFCdQvpqgQFplX/66sYo3+F4QadcwYNDBOm5oyPuaoASMuYeKuCMbE6x08pAqORVgImfi7tWw==
X-Received: by 2002:a05:6830:648b:b0:717:fe2d:a4e4 with SMTP id 46e09a7af769-71dad6d27f0mr2281039a34.19.1733217494946;
        Tue, 03 Dec 2024 01:18:14 -0800 (PST)
Received: from [192.168.0.203] ([14.139.108.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fc9c39f4d7sm8001378a12.69.2024.12.03.01.18.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 01:18:14 -0800 (PST)
Message-ID: <25cd49b5-eb6b-4c8f-899b-71005ef0c4c6@gmail.com>
Date: Tue, 3 Dec 2024 14:48:06 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] acpi: nfit: vmalloc-out-of-bounds Read in
 acpi_nfit_ctl
To: Ira Weiny <ira.weiny@intel.com>, dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com, dave.jiang@intel.com, rafael@kernel.org,
 lenb@kernel.org, nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
References: <20241118162609.29063-1-surajsonawane0215@gmail.com>
 <1813d5d3-6413-4a44-b3dd-a1be4762f839@gmail.com>
 <674ddfa6abc4d_3cb8e0294cf@iweiny-mobl.notmuch>
Content-Language: en-US
From: Suraj Sonawane <surajsonawane0215@gmail.com>
In-Reply-To: <674ddfa6abc4d_3cb8e0294cf@iweiny-mobl.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/2/24 21:56, Ira Weiny wrote:
> Suraj Sonawane wrote:
>> On 11/18/24 21:56, Suraj Sonawane wrote:
> 
> [snip]
> 
>>>
>>>    drivers/acpi/nfit/core.c | 7 ++++++-
>>>    1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>>> index 5429ec9ef..a5d47819b 100644
>>> --- a/drivers/acpi/nfit/core.c
>>> +++ b/drivers/acpi/nfit/core.c
>>> @@ -454,8 +454,13 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>>>    	if (cmd_rc)
>>>    		*cmd_rc = -EINVAL;
>>>    
>>> -	if (cmd == ND_CMD_CALL)
>>> +	if (cmd == ND_CMD_CALL) {
>>> +		if (!buf || buf_len < sizeof(*call_pkg))
>>> +			return -EINVAL;
>>> +
>>>    		call_pkg = buf;
>>> +	}
>>> +
>>>    	func = cmd_to_func(nfit_mem, cmd, call_pkg, &family);
>>>    	if (func < 0)
>>>    		return func;
>>
>> Hello!
>>
>> I wanted to follow up on the patch I submitted. I have incorporated all
>> the suggested changes up to v6. I was wondering if you had a chance to
>> review it and if there are any comments or feedback.
> 
> It just missed the soak period for the merge.  But I'll be looking at it
> for an rc pull request.
> 
> Thanks for sticking with it,
> Ira
> 
> [snip]
Thank you for the update.
I also appreciate everyone's efforts in reviewing the patch.
Thank you for reviewing the patch.

Best regards,
Suraj
