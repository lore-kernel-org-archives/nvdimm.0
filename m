Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF062201011
	for <nvdimm@lists.linux.dev>; Wed, 16 Apr 2025 15:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744816237; cv=none; b=KykSe079m+Hp8mzidPgI6vqWSaP7dJHUDdgCCjNVXb3qHcPX1s/q3Hwkzc0GgltnEhCAJkuCDJdmF8uJT/UE13nxl/SMV1VE9K4Avc7uUVWj3OYA0+MkQpp/DOp4UZJqMjarBdv9kkWZvFv2MUchq5CjO6BLkThLwO5TbWZl464=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744816237; c=relaxed/simple;
	bh=Ide8UYFDeeWAs1T/7pbZuBK8NGXCkQz+pW9bPws632E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OkY3MVsa1hZj0iB0Qv9KyoN/pOft9vlJeyE3Z7Wd3parAtLiRlD+bXKc/kwpm4yUmvVICmoSuwN/1re6/RNA7PIMq4JCTNWm3WNxkMYkn1URejH79kifeInY/sXSWUl1yJ3WYwWKoeVn4wRVXEKGd017sti8KUZvfYsMOgmDRHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uGJzaZu/; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uGJzaZu/"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-85d9a87660fso571867839f.1
        for <nvdimm@lists.linux.dev>; Wed, 16 Apr 2025 08:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744816235; x=1745421035; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j0/VAqjkF1TxpYnRhzPRlf8Ce1qx0Jj3f5VBhpm09qo=;
        b=uGJzaZu/tOElJ+2yDkCl9UpRaYtRqgvI0JGGT0FeVS+yzbXc21b+TL5UQHNL7uEPyo
         ahXu99ionRdfT4cOsd1/vaUJnkNpisTlJgpJfWrrmuiyzzlw53EKCz1p81Qrn+AQApCu
         RZH7FIKCEuNIwpKYv8MMeP0eXb3WpGSGVWKswK/WZNcYGWCbbFqtM1dkLqtPbkXhIVJi
         2NS4wzUw9ehyWlz+5NGq4LK/TdMiD8IbM4I0YTApqg78e2VG0LDOlPxnzQXZBb2sUOBb
         +3LEDcsFsKHABGKisyPGMpmj4L0NjuVvdhDdCXZUgl1wba5+Ti2TT2L4oC+RV2pdCcpe
         IlSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744816235; x=1745421035;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j0/VAqjkF1TxpYnRhzPRlf8Ce1qx0Jj3f5VBhpm09qo=;
        b=fnuGy5rUJdsipRMvJqZmuXYwTH0NAjN9th0vU0UcRw1B/6VUq/vFipsI187T/hO2Nj
         +5zJh5Tyji1D8mMxmeuisTm6WYC0OgHO2Im3lmTUODlCsSHMX0nBM5pIufakBygiEqpa
         UCjxu4BSmK1XLVaCGX4dsK/osV5fWeislPUn9YJL5Wm/DgvJeXwk0TcC/2rRwYFpqO1u
         urZMB56c4psY+IUyMg1YmEcZzHlgMmoRUKl+iPg9S1XS+1J16o3vjp634hTBMZ0Pz8Al
         lMk4r6r9rWxpkDSGbJ90O/gdS7tJVqn/BDXKQHmkuf7kRfuNkZ7ou1w/263MME4PXNSE
         pj2g==
X-Forwarded-Encrypted: i=1; AJvYcCWDYa4c+ccyrUj+Tmp5b+jIN9c3vp2K7BPbr/KbLSzH/lILBBHN1QvZkHcrvKsM9E/+CbxGy58=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+U0a2S0Js5KRl+/NVRPI2kTmsfh8JW/6UWNFdvi1FEe2Z6DqO
	lyzmpAA3hDtAvivemDENFTxIyPUXs6/YgxlTs2Yf7m4M2sDQO/HaPgwjm73RKIU=
X-Gm-Gg: ASbGncuHUoidz5WdxeoTOXqV94WySDkhtXpcu+n1llwoxnAOvO8ay17eGVgRHenda7z
	JPc5YxiLEFBUCqphcHykHKO40cGQPk692WClGfEOLhY/llF8kqsUygxkUsAnokvhunTvIje8zHc
	BFY0bJYFWJtcCP+OdnwLvllW+vt39WSYAWzs8r/b69UCCHTVnK3OrFwGJt4NQi/v3AEvMaLtJQY
	S4eOrDVsJwwcUHSnyjEcHrs615o0VpHWhCHASLml6TsZa2daDRKPiMoEx6x5JzQTP3YrPmQhh+i
	ejDZGRN17PKXMBejmwXYTEzMO1hpwLwWEYsW
X-Google-Smtp-Source: AGHT+IG9lQIK5sXneDabYlnfRgSCtZ39ELSyEdyUKJIaRYq5uFV6x1HjDv9FC0Ieo/MZkxOXm+Y0Vw==
X-Received: by 2002:a05:6602:398c:b0:85b:35b1:53b4 with SMTP id ca18e2360f4ac-861c57e6f93mr262149139f.12.1744816234774;
        Wed, 16 Apr 2025 08:10:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505dfd731sm3641805173.88.2025.04.16.08.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 08:10:34 -0700 (PDT)
Message-ID: <d3231630-9445-4c17-9151-69fe5ae94a0d@kernel.dk>
Date: Wed, 16 Apr 2025 09:10:33 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/11] pcache: Persistent Memory Cache for Block
 Devices
To: Dongsheng Yang <dongsheng.yang@linux.dev>,
 Dan Williams <dan.j.williams@intel.com>, hch@lst.de,
 gregory.price@memverge.com, John@groves.net, Jonathan.Cameron@huawei.com,
 bbhushan2@marvell.com, chaitanyak@nvidia.com, rdunlap@infradead.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-bcache@vger.kernel.org,
 nvdimm@lists.linux.dev
References: <20250414014505.20477-1-dongsheng.yang@linux.dev>
 <67fe9ea2850bc_71fe294d8@dwillia2-xfh.jf.intel.com.notmuch>
 <15e2151a-d788-48eb-8588-1d9a930c64dd@kernel.dk>
 <07f93a57-6459-46e2-8ee3-e0328dd67967@linux.dev>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <07f93a57-6459-46e2-8ee3-e0328dd67967@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/16/25 12:08 AM, Dongsheng Yang wrote:
> 
> On 2025/4/16 9:04, Jens Axboe wrote:
>> On 4/15/25 12:00 PM, Dan Williams wrote:
>>> Thanks for making the comparison chart. The immediate question this
>>> raises is why not add "multi-tree per backend", "log structured
>>> writeback", "readcache", and "CRC" support to dm-writecache?
>>> device-mapper is everywhere, has a long track record, and enhancing it
>>> immediately engages a community of folks in this space.
>> Strongly agree.
> 
> 
> Hi Dan and Jens,
> Thanks for your reply, that's a good question.
> 
>     1. Why not optimize within dm-writecache?
> From my perspective, the design goal of dm-writecache is to be a
> minimal write cache. It achieves caching by dividing the cache device
> into n blocks, each managed by a wc_entry, using a very simple
> management mechanism. On top of this design, it's quite difficult to
> implement features like multi-tree structures, CRC, or log-structured
> writeback. Moreover, adding such optimizations?especially a read
> cache?would deviate from the original semantics of dm-writecache. So,
> we didn't consider optimizing dm-writecache to meet our goals.
> 
>     2. Why not optimize within bcache or dm-cache?
> As mentioned above, dm-writecache is essentially a minimal write
> cache. So, why not build on bcache or dm-cache, which are more
> complete caching systems? The truth is, it's also quite difficult.
> These systems were designed with traditional SSDs/NVMe in mind, and
> many of their design assumptions no longer hold true in the context of
> PMEM. Every design targets a specific scenario, which is why, even
> with dm-cache available, dm-writecache emerged to support DAX-capable
> PMEM devices.
> 
>     3. Then why not implement a full PMEM cache within the dm framework?
> In high-performance IO scenarios?especially with PMEM hardware?adding
> an extra DM layer in the IO stack is often unnecessary. For example,
> DM performs a bio clone before calling __map_bio(clone) to invoke the
> target operation, which introduces overhead.
> 
> Thank you again for the suggestion. I absolutely agree that leveraging
> existing frameworks would be helpful in terms of code review, and
> merging. I, more than anyone, hope more people can help review the
> code or join in this work. However, I believe that in the long run,
> building a standalone pcache module is a better choice.

I think we'd need much stronger reasons for NOT adopting some kind of dm
approach for this, this is really the place to do it. If dm-writecache
etc aren't a good fit, add a dm-whatevercache for it? If dm is
unnecessarily cloning bios when it doesn't need to, then that seems like
something that would be worthwhile fixing in the first place, or at
least eliminate for cases that don't need it. That'd benefit everyone,
and we would not be stuck with a new stack to manage.

Would certainly be worth exploring with the dm folks.

-- 
Jens Axboe
