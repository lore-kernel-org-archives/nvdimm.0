Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0798D8F51
	for <nvdimm@lists.linux.dev>; Wed,  7 Dec 2022 23:08:36 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so2877647pjp.1
        for <nvdimm@lists.linux.dev>; Wed, 07 Dec 2022 15:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8cz7FtbLCIk84E/qnSv5m0mZi4Cb+DIbSaYsI85FKRg=;
        b=z0pu25Bh6lANc0vEMiG/HKWj9wjGOe0DGZ9yVvU+wlDuUwFfWTPOgmTMc04vdyWrDK
         xxyeRrGHYPWLBTA64PeNhooNwo5IemAT07uSptNGLPWmGOcpvPG+CCRIo58YgA0xxT8/
         zrvKfmswk1mUxWDgjzwvgojydqQVXozavA4U18EgKwoZOQ5gSqfykxY7aPYx5eDXS87F
         JA2DyJq8WGcotbiLTGXd0UOrjYZcUFZWzF4mhOiVSCjUaPWPFwOUNmHpIdMs9slp3YTz
         lhVdxatG4h6NP3Uhf/eRKQ6Gr8h5dn4VhYsEO0jfyl9vgBGAqzBmbwAPHc0WSmiwp+Dv
         2znQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8cz7FtbLCIk84E/qnSv5m0mZi4Cb+DIbSaYsI85FKRg=;
        b=1RV0q/WuK88xcKCz0VTR3ulQXSmLLyZS6grPUJCB+2ap8z+QPvOgwBLfTbvxFErH5q
         z+0uhrirCGmhNLMAtN4MrkgYh3eC2U3cbPnAaNfGAPuP1664YWc5TVTXNxKxMcD5Oy6U
         NYDwJ+D68+fUUve0SOad1dfHt9AfHT4OG0k1mvSDZKkhbxfsO7KfyT9BMUsf8R6fMOqQ
         mpWSiGDsCzH8zIIoZgV0bs2KvpdikY5mcHFxk/wzUHRekHIIZd2zBjsleCsfMlm/kRaO
         RPWpuQHaLJXESHKxEKGvi0zywizkvleFnYIlVE2f+1nlnPv2nBn/L46CZuSfehBrkAGC
         0pmw==
X-Gm-Message-State: ANoB5pmZiZoSlZV2QZ/hybB89O2x7WvkoRcDTBMr9HIMdTx56+YqYF/5
	P1FbKUH0/ZmOIDK3IbyDYY6jGQ==
X-Google-Smtp-Source: AA0mqf6NChvQ+6VGxcj9TuOceBjh4tzkE39hbYJ44cM567wbm+gRoT462mEspyLU7F6tqEVSBYhuIQ==
X-Received: by 2002:a17:90b:3687:b0:219:468e:88ac with SMTP id mj7-20020a17090b368700b00219468e88acmr47734105pjb.105.1670454516121;
        Wed, 07 Dec 2022 15:08:36 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u126-20020a627984000000b00575caf80d08sm14105794pfc.31.2022.12.07.15.08.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 15:08:35 -0800 (PST)
Message-ID: <abaa2003-4ddf-5ef9-d62c-1708a214609d@kernel.dk>
Date: Wed, 7 Dec 2022 16:08:33 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC for-6.2/block V2] block: Change the granularity of io ticks
 from ms to ns
Content-Language: en-US
To: Gulam Mohamed <gulam.mohamed@oracle.com>, linux-block@vger.kernel.org
Cc: philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, minchan@kernel.org, ngupta@vflare.org,
 senozhatsky@chromium.org, colyli@suse.de, kent.overstreet@gmail.com,
 agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
 ira.weiny@intel.com, junxiao.bi@oracle.com, martin.petersen@oracle.com,
 kch@nvidia.com, drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
 linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
 nvdimm@lists.linux.dev, konrad.wilk@oracle.com, joe.jin@oracle.com
References: <20221207223204.22459-1-gulam.mohamed@oracle.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221207223204.22459-1-gulam.mohamed@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/7/22 3:32?PM, Gulam Mohamed wrote:
> As per the review comment from Jens Axboe, I am re-sending this patch
> against "for-6.2/block".
> 
> 
> Use ktime to change the granularity of IO accounting in block layer from
> milli-seconds to nano-seconds to get the proper latency values for the
> devices whose latency is in micro-seconds. After changing the granularity
> to nano-seconds the iostat command, which was showing incorrect values for
> %util, is now showing correct values.
> 
> We did not work on the patch to drop the logic for
> STAT_PRECISE_TIMESTAMPS yet. Will do it if this patch is ok.
> 
> The iostat command was run after starting the fio with following command
> on an NVME disk. For the same fio command, the iostat %util was showing
> ~100% for the disks whose latencies are in the range of microseconds.
> With the kernel changes (granularity to nano-seconds), the %util was
> showing correct values. Following are the details of the test and their
> output:

My default peak testing runs at 122M IOPS. That's also the peak IOPS of
the devices combined, and with iostats disabled. If I enabled iostats,
then the performance drops to 112M IOPS. It's no longer device limited,
that's a drop of about 8.2%.

Adding this patch, and with iostats enabled, performance is at 91M IOPS.
That's a ~25% drop from no iostats, and a ~19% drop from the iostats we
have now...

Here's what I'd like to see changed:

- Split the patch up. First change all the types from unsigned long to
  u64, that can be done while retaining jiffies.

- Add an iostats == 2 setting, which enables this higher resolution
  mode. We'd still default to 1, lower granularity iostats enabled.

I think that's cleaner than one big patch, and means that patch 1 should
not really have any noticeable changes. That's generally how I like to
get things split. With that, then I think there could be a way to get
this included.

-- 
Jens Axboe

