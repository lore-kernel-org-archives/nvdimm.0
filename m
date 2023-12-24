Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C124015CA
	for <nvdimm@lists.linux.dev>; Sun, 24 Dec 2023 01:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DTS1OBEF"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d3995921e4so8478455ad.0
        for <nvdimm@lists.linux.dev>; Sat, 23 Dec 2023 17:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703381935; x=1703986735; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8o58fg24j79Vn01YA7a95D9+0/2AQpw8VoS8XNe4N/s=;
        b=DTS1OBEFnBm2HR8T6npJtxMbYPfKX24ZVNkiuk8jagvWqWuF8K/W5aJ5EDtwHcKjZV
         pWNowtat2Nc1xgPMGY8M31ycKARyK1Mj+EMGa4xB0kMKunTXxjygkAADDYGve1jmBbtA
         PnboShApM9ktaOmqqXP4vNmOi62fwxWkafdnwb2U7mUF/RxBa43ueohc1vDNIRfHABGv
         QAVe4PA4IrXNnDrr68A6+Orr6AkTA+mUik/Z4u1dKvN4h/Uoslp8MZ5WfUSM+VwkLrtl
         qt+dz14CJPlGAzO5pQqaXITuGO5GP5G/TAbfUnCJ+3Q/Dv4MBn8mvJR9r99yn9dETuH1
         VKzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703381935; x=1703986735;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8o58fg24j79Vn01YA7a95D9+0/2AQpw8VoS8XNe4N/s=;
        b=tQoZ9M2pT1h+7FnRSi4nFJxRH+uez/Q8yBIfd0kx2I1u8IKmigMBOFLvAn+YtKI+FR
         Z4Wz1/ytqYMlyB48zcd50zbOTKXOoQTxwsZowoMKAzPoS5IefuvKW+LwvSS06kB05a1m
         J20huF8hNETVW3qus83FFrcA39oJ+ApfDWBT8sLBIKxJFj4mZOBb6HKQJWQzOPDBl+Dc
         MRKeTfeqbQUspGiwSzipRuQQSP0Etdc1DyzUKPRk/mgL2fhFdq20czv4gDYxLNDiQLek
         95ZYQ+btxQGPIwVCM+Td/mCr1fvyTDMFQ0JIT1vK3kyB7RRDVTmR+7KW4vWTCaqT/b/T
         8bow==
X-Gm-Message-State: AOJu0YykLfuxzZ/vd8H0laCFPjz9vEp13+SlQp6Uo7znb96JPyYn1Pzq
	Uq6p0qUxurXQqFVwluntogo8/BzB4c8mnQ==
X-Google-Smtp-Source: AGHT+IGcBRlYvOUeEkZB1lDf1c0cqfAzC1SnR/inTNftXSxRSnKcqY2F7byFuFTF/1FSSlhhHAbEeg==
X-Received: by 2002:a17:902:f68e:b0:1d3:e001:5953 with SMTP id l14-20020a170902f68e00b001d3e0015953mr6700658plg.5.1703381934994;
        Sat, 23 Dec 2023 17:38:54 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id q17-20020a170902dad100b001d3eff0728asm5683196plx.78.2023.12.23.17.38.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Dec 2023 17:38:54 -0800 (PST)
Message-ID: <0eef6feb-4775-4249-af74-9fccb093b6bc@kernel.dk>
Date: Sat, 23 Dec 2023 18:38:52 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] badblocks: avoid checking invalid range in
 badblocks_check()
Content-Language: en-US
To: Coly Li <colyli@suse.de>
Cc: nvdimm@lists.linux.dev,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Block Devices <linux-block@vger.kernel.org>,
 Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Geliang Tang <geliang.tang@suse.com>, Hannes Reinecke <hare@suse.de>,
 NeilBrown <neilb@suse.de>, Vishal L Verma <vishal.l.verma@intel.com>,
 Xiao Ni <xni@redhat.com>
References: <20231224002820.20234-1-colyli@suse.de>
 <A110805F-3448-4A87-AE70-F94A394EA826@suse.de>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <A110805F-3448-4A87-AE70-F94A394EA826@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/23/23 5:32 PM, Coly Li wrote:
>> 2023?12?24? 08:28?Coly Li <colyli@suse.de> ???
>>
>> If prev_badblocks() returns '-1', it means no valid badblocks record
>> before the checking range. It doesn't make sense to check whether
>> the input checking range is overlapped with the non-existed invalid
>> front range.
>>
>> This patch checkes whether 'prev >= 0' is true before calling
>> overlap_front(), to void such invalid operations.
>>
>> Fixes: 3ea3354cb9f0 ("badblocks: improve badblocks_check() for multiple ranges handling")
>> Reported-and-tested-by: Ira Weiny <ira.weiny@intel.com>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Link: https://lore.kernel.org/nvdimm/3035e75a-9be0-4bc3-8d4a-6e52c207f277@leemhuis.info/
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Geliang Tang <geliang.tang@suse.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: NeilBrown <neilb@suse.de>
>> Cc: Vishal L Verma <vishal.l.verma@intel.com>
>> Cc: Xiao Ni <xni@redhat.com>
>> ---
>> block/badblocks.c | 6 ++++--
>> 1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Hi Jens,
> 
> Is it possible to take this fix into 6.7 still? Thanks in advance.

Yep, we're still a few weeks out, so not a problem.

-- 
Jens Axboe

