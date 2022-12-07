Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1300423B8
	for <nvdimm@lists.linux.dev>; Wed,  7 Dec 2022 17:08:53 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id i83so5769342ioa.11
        for <nvdimm@lists.linux.dev>; Wed, 07 Dec 2022 09:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+r3z2TzChBc0Vs/D1sJ6f4Z6Cq8sqK5Sifftb2ph/uA=;
        b=sqgK4uVgdukFxIDxOvSAAyQFpMopVm99bZ5YD2B/lQFb1XglqtMEdjzv4zSPvnedAj
         PlIMswBqc8UYikh4BdgySLaWBAmwPQLCA+DlUrsRTHy+/Y4trGeyfTrXAjWjIXqmWBgX
         hTw2LZQ0rDXoDM9eo98BrRubaVVwABlt9qLRJHkrq14N5qdMHboXlGZVVHnZrW3foxss
         cYd/kgCu+72av+pycZz+zetKRaKEH7IpVSwk9xgVJsZMOfSPMFagEGeyCzFLMIh9/Jhd
         GCY129UD4jcHF5FgAomHtHxC6KVv+ObkjnkDwWHBHgewjgg/JqQUNZeIdPzgrsE+ubKz
         hDYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+r3z2TzChBc0Vs/D1sJ6f4Z6Cq8sqK5Sifftb2ph/uA=;
        b=lhUpTiKQwzXV6UzgIc7LPJCohY9QcoBaa0BDCrdmkoCjhD3qqBr5fPJqeTC4T0xbb8
         qhcDRTEohR7PV806y0mJYgibiwwqNHo4RvbubnEO/Db4uFu4fOVGfI4gyg+ZANfRPyyf
         1ieNoF8jkycNFKdzQ0nds9THiCELpGz5eMXbYii6LWjU67KJpkq7BMi8QJnDpzd8HAxc
         Dr+pELZeLwO1SIgxtD/p1WU85asnfEhaYIvDOuMtg3xMb6PzT+kAoz+s+bA2KIqAxRI6
         +7w3G+Iwrh/tgDjNIlX/cF8YNC4mh0latAv45HLvenN5dOCaCNVg3AZOPp7qoddX/tUB
         bqeA==
X-Gm-Message-State: ANoB5pnqRQAUgb5zhKLBBndYgkymOr1GsM6TOChCi8Vfi4UtL2N5PlTY
	1jt+Kmnj1u33b8GhPIa8GsSVeg==
X-Google-Smtp-Source: AA0mqf7yLejbRNfqMUu3ilEvsYdDj7YhVkPipELjA6VqWKNVXZJlTdAqiTcfQmriCKmlYB7qULxDWg==
X-Received: by 2002:a05:6638:1124:b0:38a:171a:dee with SMTP id f4-20020a056638112400b0038a171a0deemr12454949jar.292.1670432932906;
        Wed, 07 Dec 2022 09:08:52 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o27-20020a02a1db000000b0038a0c2ae99bsm7327723jah.18.2022.12.07.09.08.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 09:08:52 -0800 (PST)
Message-ID: <eaf4f9a8-dfc6-402e-4a1a-732034d1512d@kernel.dk>
Date: Wed, 7 Dec 2022 10:08:50 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC] block: Change the granularity of io ticks from ms to ns
To: Gulam Mohamed <gulam.mohamed@oracle.com>, linux-block@vger.kernel.org
Cc: philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, minchan@kernel.org, ngupta@vflare.org,
 senozhatsky@chromium.org, colyli@suse.de, kent.overstreet@gmail.com,
 agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com,
 ira.weiny@intel.com, junxiao.bi@oracle.com, martin.petersen@oracle.com,
 kch@nvidia.com, drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
 linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
 nvdimm@lists.linux.dev, konrad.wilk@oracle.com
References: <20221206181536.13333-1-gulam.mohamed@oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221206181536.13333-1-gulam.mohamed@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/6/22 11:15?AM, Gulam Mohamed wrote:
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

As mentioned, this will most likely have a substantial performance
impact. I'd test it, but your patch is nowhere near applying to the
current block tree. Please resend it against for-6.2/block so it can
get tested.

-- 
Jens Axboe

