Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A75880A
	for <nvdimm@lists.linux.dev>; Sun, 25 Dec 2022 11:40:28 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id n3so7465819wrc.5
        for <nvdimm@lists.linux.dev>; Sun, 25 Dec 2022 03:40:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZHIIoLI6GIci6V+pJYW1QHErBVX3zcPxWh+ZJQxLA0o=;
        b=okobOW/kTZmeQQJ105lVsRUYRzdFnb8XtwsmBbN+9f80M6YfP2eaX1tjCg5mCiMzYj
         jlIq5vEqHNoFwJFDREtN3Yv+cdKheXibNogHGnsDeavmfVs5SjrpIFjr5S3BORPI95d7
         t4WUzxo+fibQyyELZIlvwhtzapJjahvy3k+kGutMH30CNwfkYdSv8HhWD7yJm4P+bK0g
         k5fAyREROIOzsioP8K/aDjWGf2/huEFi7xrPjziOCCQaLC6i6tawS+h62mC/K29jZOfa
         euekkvlVHAUynoC4eWiCQL5eJhpYfGNniBIUtDTUNTbUK7L8qL6sN1tN8ynt3nFUpgH1
         EuaQ==
X-Gm-Message-State: AFqh2ko8eaOJAAA/d+3hPsCUNK60UmL+UrKyp21Qzh2ytsNgsImPJAO3
	aCcemI19FBzFkMKb9mlQ6cI=
X-Google-Smtp-Source: AMrXdXtOU+j5gb521X9u9SLkgvSyxLbk+fAjhclAlSe9w631NeEuF0qIeOMvF5fteB8K21s8/zxQPQ==
X-Received: by 2002:adf:f30f:0:b0:242:864e:c71c with SMTP id i15-20020adff30f000000b00242864ec71cmr8954222wro.24.1671968426666;
        Sun, 25 Dec 2022 03:40:26 -0800 (PST)
Received: from [192.168.64.177] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id e16-20020adfdbd0000000b002362f6fcaf5sm7652128wrj.48.2022.12.25.03.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Dec 2022 03:40:26 -0800 (PST)
Message-ID: <1d0eb8e4-a91f-4635-bac7-9bc6cefbeff0@grimberg.me>
Date: Sun, 25 Dec 2022 13:40:23 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH for-6.2/block V3 1/2] block: Data type conversion for IO
 accounting
Content-Language: en-US
To: Gulam Mohamed <gulam.mohamed@oracle.com>, linux-block@vger.kernel.org
Cc: axboe@kernel.dk, philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, minchan@kernel.org, ngupta@vflare.org,
 senozhatsky@chromium.org, colyli@suse.de, kent.overstreet@gmail.com,
 agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
 ira.weiny@intel.com, junxiao.bi@oracle.com, martin.petersen@oracle.com,
 kch@nvidia.com, drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
 linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
 nvdimm@lists.linux.dev, konrad.wilk@oracle.com, joe.jin@oracle.com,
 rajesh.sivaramasubramaniom@oracle.com, shminderjit.singh@oracle.com
References: <20221221040506.1174644-1-gulam.mohamed@oracle.com>
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20221221040506.1174644-1-gulam.mohamed@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/21/22 06:05, Gulam Mohamed wrote:
> Change the data type of start and end time IO accounting variables in,
> block layer, from "unsigned long" to "u64". This is to enable nano-seconds
> granularity, in next commit, for the devices whose latency is less than
> milliseconds.
> 
> Changes from V2 to V3
> =====================
> 1. Changed all the required variables data-type to u64 as part of this
>     first patch
> 2. Create a new setting '2' for iostats in sysfs in next patch
> 3. Change the code to get the ktime values when iostat=2 in next patch
> 
> Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
> ---
>   block/blk-core.c              | 24 ++++++++++++------------
>   block/blk.h                   |  2 +-
>   drivers/block/drbd/drbd_int.h |  2 +-
>   drivers/block/zram/zram_drv.c |  4 ++--
>   drivers/md/bcache/request.c   | 10 +++++-----
>   drivers/md/dm-core.h          |  2 +-
>   drivers/md/dm.c               |  2 +-
>   drivers/md/md.h               |  2 +-
>   drivers/md/raid1.h            |  2 +-
>   drivers/md/raid10.h           |  2 +-
>   drivers/md/raid5.c            |  2 +-
>   drivers/nvdimm/btt.c          |  2 +-
>   drivers/nvdimm/pmem.c         |  2 +-
>   include/linux/blk_types.h     |  2 +-
>   include/linux/blkdev.h        | 12 ++++++------
>   include/linux/part_stat.h     |  2 +-

nvme-mpath now also has stats, so struct nvme_request should also be
updated.
