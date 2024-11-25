Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9471B0103
	for <nvdimm@lists.linux.dev>; Mon, 25 Nov 2024 14:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732544897; cv=none; b=Pd0Z5nBJ9J0wZrWYCXc3t2pMA+9Jkm+ydes7QMHvRw2WyfhzANgTSuR4icF8vAx3hpqzsRiX8riXQlSsBvkDEpDjfwiuwroXy1X+lt/9ckDYLgh5sVCmX1MUpNsnrx2w0gsGYyD/oU1d7EOovRbJKB78STonwL/gV6cniF8cW5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732544897; c=relaxed/simple;
	bh=Qf3XtGHQ0/jTjJ43p9AVdX2cxiPbXJVauEKR2OPlEZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P4TIVv5KcLBrsXoCiFtiiGl6nlrx5QMdw+Ks1GmYl556qwKSw89KN6aCYUNrblGUjWQ1PIz4neHZx8oRqTsiBngY5xRGzziImzl4nXJD86J4zYmumKYHN2DrEngrrU76bZW+TY8XkTpv+9k5n+FvhGazKFYR8M0agyfK/1WXlW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X25WD7Ri; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X25WD7Ri"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2ea8b039ddcso3553113a91.0
        for <nvdimm@lists.linux.dev>; Mon, 25 Nov 2024 06:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732544895; x=1733149695; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WSVP8dLhnfmOPUZLQquRunhFtYrfA4jCVwxh5IIYTUM=;
        b=X25WD7RiXWU4CWTp2wiB22MtGlrvqcNtZxL44ij0DWHX74IcryGgsnOSgKocOW1FyP
         6Sfl5MiWa7XnudVk53K1iKJFpwNNvytpxjN0bkaiISVkouqPBeQ3OdzMMX455tvXCZgW
         Xm8S3AfMzKh8x+cdwOwSIjxu8NFxKqrRZqUABNe3236JExsKVG4qPXcK8CsBXtmi3/VK
         bQyUQUYJ2Td4kACt72DQ/z3qDufEGL7aVwbycAZjrs5blXpi+fCVlVU3SbZsXpFOcTBy
         poV2sjKvM3uW61+PebbIjZYFBZ9KZKVTajQmvlERxg1HqHfooU0tKEEGwEq9HQ+R8zja
         w8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732544895; x=1733149695;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WSVP8dLhnfmOPUZLQquRunhFtYrfA4jCVwxh5IIYTUM=;
        b=ODpn+Sg56pNu+weubMumjBNZ63NY1+9J/xQW//O7RCVkUwtf3OxNAEjvcGEJu8mt2S
         dFLh3DgXCIIxtHobARN3rHfLNlpo7IMRoqUDkZgoG+vpYsxrXcL+QAoZmpqcvIa5goOk
         x/hgTtioDmK9WJUH8HGhAAEwnd9pGr7h9aFo36d+SUI08CuCvdAoCTkNqiGccBrgl/G5
         XHBA+F7tv4Xq2457TDz27YYZfrinyg4eu7FLjMsF6LsGmWhv3xfGIOArbiSAKjsvPR2N
         9HcMTqtgoFyTTv7VIaH8uRf85UBxh7882sBjukCqb1uN3GllkCAuaXBanvLIlK8A4Ih4
         uaRA==
X-Forwarded-Encrypted: i=1; AJvYcCUsUabXbiJbJCyTWRzcpbORYNYEexUlDRMSnqroRztkHQq9Hl3nFZJmSwx/Oj1OWa3+xKdPUnA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGNiNDyPfPLup82s3oerwUh+m1U/5ZLgwH2YLwA1QVTOJT/NC5
	iRwRwkZu7vamu+rd2FIVouFROXHRgsA3Jp+TlUrsobZPYNCEyst/
X-Gm-Gg: ASbGnct1O1e7gDXYm4A0ciRBfFWc+FAryjZV3/lfXl9Kpqfg4mUyx8fG993sjL9oqdu
	PAxT4D49idtEvqbMXubqbSVxcYQTLhYe6wDE9vNdC6tPEYR/F6oxJDKBmzk4X5+sRVEWRnRBRfB
	MGFXmP2B5nsSr3J75b4k+D6mFBYFJcO9O1eWC4pL3OYfl05K7VM/Qz7SvTMlD/zZcICMCCkT1lc
	3w98ApoS0N/Do4a0vPSWe7QsRzpt6iFaTFgtxQxvQdEaLe44hOl6I6WDLYDC403
X-Google-Smtp-Source: AGHT+IGHciRYAqsEoY+AXmAdv95wOzs8u9pLXgMOFRX3xePzc95shLnnHTASUBw9vTsO9x2paV/+3w==
X-Received: by 2002:a17:90b:4a92:b0:2ea:5c01:c1a4 with SMTP id 98e67ed59e1d1-2eb0e427a67mr16907227a91.20.1732544894866;
        Mon, 25 Nov 2024 06:28:14 -0800 (PST)
Received: from [192.168.0.203] ([14.139.108.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2eb14397a6fsm6492612a91.51.2024.11.25.06.28.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 06:28:14 -0800 (PST)
Message-ID: <1813d5d3-6413-4a44-b3dd-a1be4762f839@gmail.com>
Date: Mon, 25 Nov 2024 19:58:06 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] acpi: nfit: vmalloc-out-of-bounds Read in
 acpi_nfit_ctl
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
 rafael@kernel.org, lenb@kernel.org, nvdimm@lists.linux.dev,
 linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
References: <20241118162609.29063-1-surajsonawane0215@gmail.com>
Content-Language: en-US
From: Suraj Sonawane <surajsonawane0215@gmail.com>
In-Reply-To: <20241118162609.29063-1-surajsonawane0215@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/24 21:56, Suraj Sonawane wrote:
> Fix an issue detected by syzbot with KASAN:
> 
> BUG: KASAN: vmalloc-out-of-bounds in cmd_to_func drivers/acpi/nfit/
> core.c:416 [inline]
> BUG: KASAN: vmalloc-out-of-bounds in acpi_nfit_ctl+0x20e8/0x24a0
> drivers/acpi/nfit/core.c:459
> 
> The issue occurs in cmd_to_func when the call_pkg->nd_reserved2
> array is accessed without verifying that call_pkg points to a buffer
> that is appropriately sized as a struct nd_cmd_pkg. This can lead
> to out-of-bounds access and undefined behavior if the buffer does not
> have sufficient space.
> 
> To address this, a check was added in acpi_nfit_ctl() to ensure that
> buf is not NULL and that buf_len is less than sizeof(*call_pkg)
> before accessing it. This ensures safe access to the members of
> call_pkg, including the nd_reserved2 array.
> 
> Reported-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=7534f060ebda6b8b51b3
> Tested-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
> Fixes: ebe9f6f19d80 ("acpi/nfit: Fix bus command validation")
> Signed-off-by: Suraj Sonawane <surajsonawane0215@gmail.com>
> ---
> V1: https://lore.kernel.org/lkml/20241111080429.9861-1-surajsonawane0215@gmail.com/
> V2: Initialized `out_obj` to `NULL` in `acpi_nfit_ctl()` to prevent
> potential uninitialized variable usage if condition is true.
> V3: Changed the condition to if (!buf || buf_len < sizeof(*call_pkg))
> and updated the Fixes tag to reference the correct commit.
> V4: Removed the explicit cast to maintain the original code style.
> V5: Re-Initialized `out_obj` to NULL. To prevent
> potential uninitialized variable usage if condition is true.
> V6: Remove the goto out condition from the error handling and directly
> returned -EINVAL in the check for buf and buf_len
> 
>   drivers/acpi/nfit/core.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 5429ec9ef..a5d47819b 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -454,8 +454,13 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>   	if (cmd_rc)
>   		*cmd_rc = -EINVAL;
>   
> -	if (cmd == ND_CMD_CALL)
> +	if (cmd == ND_CMD_CALL) {
> +		if (!buf || buf_len < sizeof(*call_pkg))
> +			return -EINVAL;
> +
>   		call_pkg = buf;
> +	}
> +
>   	func = cmd_to_func(nfit_mem, cmd, call_pkg, &family);
>   	if (func < 0)
>   		return func;

Hello!

I wanted to follow up on the patch I submitted. I have incorporated all 
the suggested changes up to v6. I was wondering if you had a chance to 
review it and if there are any comments or feedback.

Here are the links to the discussion for all versions: 
https://lore.kernel.org/lkml/?q=acpi%3A+nfit%3A+vmalloc-out-of-bounds+Read+in+acpi_nfit_ctl

Thank you for your time and consideration. I look forward to your response.

Best regards,
Suraj Sonawane
