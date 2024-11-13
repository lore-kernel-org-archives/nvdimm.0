Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFAE1AA792
	for <nvdimm@lists.linux.dev>; Wed, 13 Nov 2024 09:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731488778; cv=none; b=EeYrvRFBm/BCKizznHBppuJe5PUwdkcGAaxp4uli49AOZDC9QpoHDbllPWsfOZ6i5RWBDf3ObP+ErgyRv5qHQKwb0LjEZPhKwt15Fu2yVB18ZhwgD/EkQSxcFsK0V/Hr0ZQy8VcJXNK99L43ATAEpxb8AOjP11ZpCMIPysTnLpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731488778; c=relaxed/simple;
	bh=8mmggMnuem4ngZVnWODeAvZk/jEMDw94O9PO4QS1Qx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cGD7+6IB9wRMrV7kbPLYc+u+tZhaC4l/5EcI/BDuuOSxrx3caclf8RAkgNXflCn0k4Hm6GT339BRRyTPtNhtIbmxmFBAJvSd4MZRJgDnZCD1yivoYYy5nMrb9YlEPiuqcxCC0/23WI5KnldPlskpRyOE1Q/w4D6aHqRm8Uuc7s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xn7ZIQpl; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xn7ZIQpl"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-72097a5ca74so5552539b3a.3
        for <nvdimm@lists.linux.dev>; Wed, 13 Nov 2024 01:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731488776; x=1732093576; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+I+VueqE1fhRquKRS0Z9am0cKm07A/xqHYx9ptqJ2Ak=;
        b=Xn7ZIQpl57jsGXMR5I8mCG2mnnaS5i8Ph7zvEx/AMGXEXWP00YcwD5htjRRWdx9y2M
         aEHLZLX6PHUMCivfgVjbj7saeSCEJOaGUHBbZnlyWKDDKzQpoapUkU0+Evl0wWiZJLoq
         kXQvfC6eQ1zGm9Ab6rdYPIslL0fgKq4PbBFFuvogEUPsL0IEsc7eZtWMIdLEVBpeRszz
         BaWHITXKNsEjIWmu6mfBjuksES6U3z2NCJAzRVoVeoLuTH6d9iaY2bSrntKOKuaW0f+Y
         HgMK1OsiblluHmc9Mrx+dtx9vIZOrw1QUTlCAMOgNCouiTlPhFtpv/ir2FGZZzIVR6uB
         ykyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731488776; x=1732093576;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+I+VueqE1fhRquKRS0Z9am0cKm07A/xqHYx9ptqJ2Ak=;
        b=mct4Nj5htnetH+Bzbi8x3HAml/z7oP3YnP4sb6N60/IVXbQqH2cnkQ7FofsAvVJtzN
         RADJyOUs458U2F5SQjl8/WeZrxsAtgrfbc5R1XNOVzIikz/uIXPPXgz0eSO58DDjgHZ9
         ZFvU/5Wh/+sRlHlJVLROql/u2JgRqdDvrq8VupG9VEvRv8KxFa6mCSPnIZRcfwXkGQSR
         +6rVvDlijb1Z3lb5frTPxYSMHLOokec2dU71fTLeNvLtjfquZK7PfWKMxmAop3ZjyI+q
         x0n5AdsNI3yI8O5vbNyWsF2L90ORByQo07KiPhYN6NOPY1TF/DMPP1wbBQkbiHUiuBxe
         gMyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZwqVPDl8dTWfwmi8f5QK3vTIdVwYPpQiuymywYG8OnFzunySGIsQYsucSbLw/KS1W+w4H+j4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8ljixO0V0xqgHoczMmQRuMxc4TWDRiMLc97ur4GFi+ZcFpnnr
	Sd93gi4S1OcOzN2K67j0g+Dl3Xcj64HBcIfhpliFtxAxphfWijoO
X-Google-Smtp-Source: AGHT+IFufLTuaitJ9nQtmqz7t8i7uh0sbUQmWkdKOKws642qgOc+M31tKFhD6xSC8RMnZwHG/iKq0g==
X-Received: by 2002:a05:6a20:43a8:b0:1db:f099:13b9 with SMTP id adf61e73a8af0-1dc22b9275cmr29765775637.43.1731488776109;
        Wed, 13 Nov 2024 01:06:16 -0800 (PST)
Received: from ?IPV6:2405:204:20ac:21b:f7dd:e473:be3f:2c8f? ([2405:204:20ac:21b:f7dd:e473:be3f:2c8f])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72407a1fd2bsm12678697b3a.167.2024.11.13.01.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 01:06:15 -0800 (PST)
Message-ID: <d777ec88-f8a8-499c-b9de-9efefa638eb6@gmail.com>
Date: Wed, 13 Nov 2024 14:36:08 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] acpi: nfit: vmalloc-out-of-bounds Read in
 acpi_nfit_ctl
To: Alison Schofield <alison.schofield@intel.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
 ira.weiny@intel.com, rafael@kernel.org, lenb@kernel.org,
 nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
References: <20241112052035.14122-1-surajsonawane0215@gmail.com>
 <ZzQwXXSwioLsG8vv@aschofie-mobl2.lan>
Content-Language: en-US
From: Suraj Sonawane <surajsonawane0215@gmail.com>
In-Reply-To: <ZzQwXXSwioLsG8vv@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/11/24 10:21, Alison Schofield wrote:
> On Tue, Nov 12, 2024 at 10:50:35AM +0530, Suraj Sonawane wrote:
>> Fix an issue detected by syzbot with KASAN:
>>
>> BUG: KASAN: vmalloc-out-of-bounds in cmd_to_func drivers/acpi/nfit/
>> core.c:416 [inline]
>> BUG: KASAN: vmalloc-out-of-bounds in acpi_nfit_ctl+0x20e8/0x24a0
>> drivers/acpi/nfit/core.c:459
>>
>> The issue occurs in `cmd_to_func` when the `call_pkg->nd_reserved2`
>> array is accessed without verifying that `call_pkg` points to a
>> buffer that is sized appropriately as a `struct nd_cmd_pkg`. This
>> could lead to out-of-bounds access and undefined behavior if the
>> buffer does not have sufficient space.
>>
>> To address this issue, a check was added in `acpi_nfit_ctl()` to
>> ensure that `buf` is not `NULL` and `buf_len` is greater than or
>> equal to `sizeof(struct nd_cmd_pkg)` before casting `buf` to
>> `struct nd_cmd_pkg *`. This ensures safe access to the members of
>> `call_pkg`, including the `nd_reserved2` array.
>>
>> This change preventing out-of-bounds reads.
>>
>> Reported-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=7534f060ebda6b8b51b3
>> Tested-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
>> Fixes: 2d5404caa8c7 ("Linux 6.12-rc7")
>> Signed-off-by: Suraj Sonawane <surajsonawane0215@gmail.com>
> 
> Suraj,
> 
> The fixes tag needs to be where the issue originated, not
> where you discovered it (which I'm guessing was using 6.12-rc7).
> 
Thank you for your feedback.

> Here's how I find the tag:
> 
> $ git blame drivers/acpi/nfit/core.c | grep call_pkg | grep buf
> ebe9f6f19d80d drivers/acpi/nfit/core.c (Dan Williams       2019-02-07 14:56:50 -0800  458) 		call_pkg = buf;
> 
> $ git log -1 --pretty=fixes ebe9f6f19d80d

Thank you for this detailed explaination.
> Fixes: ebe9f6f19d80 ("acpi/nfit: Fix bus command validation")
> 
> I think ^ should be your Fixes tag.

Yes, I ran the provided steps to verify the commit ID ebe9f6f19d80d and 
verified it.
> 
> 
> snip
> 
>>

I'll update the Fixes tag in the next version of the patch. 
Additionally, I will re-test with syzbot and submit the revised patch 
shortly.

Thank you for your time and feedback!

Best,
Suraj Sonawane
