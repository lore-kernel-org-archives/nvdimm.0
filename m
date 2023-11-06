Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36864156E1
	for <nvdimm@lists.linux.dev>; Mon,  6 Nov 2023 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="lTPSNvd6"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40806e4106dso29423455e9.1
        for <nvdimm@lists.linux.dev>; Mon, 06 Nov 2023 10:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1699294541; x=1699899341; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lf3MJg4rdvAfKEuARU7S/KWx4iZciTo315WH3I2AEME=;
        b=lTPSNvd6N6G/Zdl3k2In5b2u5vE+QlZJ1gy9fxa07R0aY+KTtlMbImwd0FCG9UyiWt
         TACdOtPrRGce5G0t5VZuYulkpYi3ZXK/5OGVo3J+O9P6xwz5p6aTUNYW1f/HMZYafGwz
         15RJp9Cl34fkr8LgfVUWOq04RRzyu7TkSouNN+FlAx6N6CjM1QRUxv3u0FZcIambBniu
         YunYRaykmq8Bnbr7x3SVLLeSyqhgr45lGrOs39dt68+5a7GyM84GiJVVulMGj5bIqrWA
         jX5y4EswS9kguN2XmtgEUpzE+Ycm+KL3lr604Od2Kpr59Z4kMo3y5utIty4RrnBcklQH
         Aj+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699294541; x=1699899341;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lf3MJg4rdvAfKEuARU7S/KWx4iZciTo315WH3I2AEME=;
        b=PwnEAo7smwu3/Px9/J0rnBVOFW55jgsFcUs3ULLuNe7CFDNz9wqxxskhq86DM3Xlsx
         vbIBRwA2WBCCt7Iy+ugm+cloS4GqjDmYm5QB/FEnR83z+K9D2QjGtnXpmfnr6nNNGACZ
         qgjygAGX4JgclLJdEtoK3UqDu1/Ge1dRFZlxS3eko/8gDF6/eH86Q3JvOAAqgqUDKC1T
         wJA1VfzB8falBuB2xUF0M9C/fhBtn4FpFr35+ltY//zB26ss1plG49bqh95rX3SwTM8V
         gXDgKmTRg6OV7MuxXRnYWWUclykrt4OTooO1a5Z4R+W72y8DB/wvJvLzTnWGPEKIQHzL
         mzwg==
X-Gm-Message-State: AOJu0YzMRykU97ST9uvcmk8702mFe5RWu0wv/m+++ch6/r97+2wgc63n
	okcVSa7FlYYKnqqlbxnPAtsRPA==
X-Google-Smtp-Source: AGHT+IF3fXq7vHAvazsquZcnkPuD9l44U9V8qAOKm8OzrNTAFXUYFTEP0Ky4PYRkfC5cpWBiMweXEw==
X-Received: by 2002:a05:600c:45c6:b0:405:3924:3cad with SMTP id s6-20020a05600c45c600b0040539243cadmr361508wmo.15.1699294541471;
        Mon, 06 Nov 2023 10:15:41 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b5c7:0:cc4:fc61:ba1d:d46c? ([2a02:6b6a:b5c7:0:cc4:fc61:ba1d:d46c])
        by smtp.gmail.com with ESMTPSA id v6-20020a05600c444600b0040651505684sm13125607wmn.29.2023.11.06.10.15.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 10:15:40 -0800 (PST)
Message-ID: <454dbfa1-2120-1e40-2582-d661203decca@bytedance.com>
Date: Mon, 6 Nov 2023 18:15:39 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Conditions for FOLL_LONGTERM mapping in fsdax
Content-Language: en-US
From: Usama Arif <usama.arif@bytedance.com>
To: dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
 nvdimm@lists.linux.dev
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 Fam Zheng <fam.zheng@bytedance.com>,
 "liangma@liangbit.com" <liangma@liangbit.com>
References: <172ab047-0dc7-1704-5f30-ec7cd3632e09@bytedance.com>
In-Reply-To: <172ab047-0dc7-1704-5f30-ec7cd3632e09@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

We wanted to run a VM with a vfio device assigned to it and with its 
memory-backend-file residing in a persistent memory using fsdax (mounted 
as ext4). It doesnt currently work with the kernel as 
vfio_pin_pages_remote ends up requesting pages with FOLL_LONGTERM which 
is currently not supported. From reading the mailing list, what I 
understood was that this is to do with not having DMA supported on fsdax 
due to issues that come up during truncate/hole-punching. But it was 
solved with [1] by deferring fallocate(), truncate() on a dax mode file 
while any page/block in the file is under active DMA.

If I remove the check which fails the gup opertion with the below diff, 
the VM boots and the vfio device works without any issues. If I try to 
truncate the mem file in fsdax, I can see that the truncate command gets 
deferred (waits in ext4_break_layouts) and the vfio device keeps working 
and sending packets without any issues. Just wanted to check what is 
missing to allow FOLL_LONGTERM gup operations with fsdax? Is it just 
enough to remove the check? Thanks!


diff --git a/mm/gup.c b/mm/gup.c
index eb8d7baf9e4d..f77bb428cf9b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1055,9 +1055,6 @@ static int check_vma_flags(struct vm_area_struct 
*vma, unsigned long gup_flags)
         if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
                 return -EFAULT;

-       if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
-               return -EOPNOTSUPP;
-
         if (vma_is_secretmem(vma))
                 return -EFAULT;


[1] 
https://lore.kernel.org/all/152669371377.34337.10697370528066177062.stgit@dwillia2-desk3.amr.corp.intel.com/

Regards,
Usama
