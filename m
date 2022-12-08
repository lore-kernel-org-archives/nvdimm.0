Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B2862C
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 02:55:33 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id 124so247635pfy.0
        for <nvdimm@lists.linux.dev>; Wed, 07 Dec 2022 18:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+YnwWLbC1k13FDuBmbkgFl4RERtAqz8Hk2l0zfW6u80=;
        b=fU4y3lEGFEK3oscBjLkN1vxfgNM/FZidlQ+rI70OHvgxD0rXJh0EwSK3e2bczFqMkA
         tO2LwtPOEAYZtGQjimEXQ8aStoM+oHrRCZpJNDNOrJTKI/JHeBOK30eol6bW+IR4iBg5
         6bvbpaQVxY9TyhU2N+c7QQA9h+c23vE28pNce8JLnQVD9Bz7KVFAZVNBp+U4WY4PzC6f
         oXQvkaSCLJVDYLe3bcQFvuvQN3QZ2UfyLUBGJaQmSeDW96IREZIk3AzUiqppD7zsYIqk
         Vd2qy53kRGJVHi8kjxDmOkqm8yZRn4/hLIi6OYpVIqVtAFlNgX78uWUxSxkcznrsySrQ
         SZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+YnwWLbC1k13FDuBmbkgFl4RERtAqz8Hk2l0zfW6u80=;
        b=7JumNO/oqFKPAHpORim4iHT9utzk6qSI0ew7ee72XpAn84aQHOzrxQ9Uiww6T+Zyig
         ycpjgjTpwcorw13SkdmbDXcu4JAa83fKPKxh4PeSWK7nsQFYjj0Xg6+sH/gVt0R/m6cQ
         KvBBqqN1W4hwczNagaHBPc4IvMp8Cr6t1oAPGAdRpMjCFPYyMlRafBfqDLa3lcKlT7ym
         izFWGV1nJ1S4eaBuU70pOr1UbAPfIUODu6qvuyn5aHbwhzqUyt+NSZbxlhTs1CBMmT3m
         GOHVOfzhEVbjiTFGcBd6QMr+E9YSAjRaMKTCAOORTeBop9ypv6/ge7B282C6Fnwlu1Ej
         gVvw==
X-Gm-Message-State: ANoB5pmFLVJHh5m2BYhucvJj6VZzNjCwIUBql6NZ3Id/7gzit0wq534Y
	SvE3IqF/noOrLtjwD4pUbiHJCA==
X-Google-Smtp-Source: AA0mqf4GKdTwpvzKHdR+jWKD59yHhtQiQj6o4bMAawT3TKX0knE/TZzrpzeE/R5qCEqb2PjMIqK3qA==
X-Received: by 2002:a63:d151:0:b0:478:c28a:2f36 with SMTP id c17-20020a63d151000000b00478c28a2f36mr13058187pgj.182.1670468133285;
        Wed, 07 Dec 2022 18:55:33 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n13-20020a170903404d00b0016d773aae60sm15211981pla.19.2022.12.07.18.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 18:55:32 -0800 (PST)
Message-ID: <4d118f20-9006-0af9-8d97-0d28d85a3585@kernel.dk>
Date: Wed, 7 Dec 2022 19:55:30 -0700
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
To: Keith Busch <kbusch@kernel.org>,
 Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Gulam Mohamed <gulam.mohamed@oracle.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
 "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
 "christoph.boehmwalder@linbit.com" <christoph.boehmwalder@linbit.com>,
 "minchan@kernel.org" <minchan@kernel.org>,
 "ngupta@vflare.org" <ngupta@vflare.org>,
 "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
 "colyli@suse.de" <colyli@suse.de>,
 "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
 "agk@redhat.com" <agk@redhat.com>, "snitzer@kernel.org"
 <snitzer@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "song@kernel.org" <song@kernel.org>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>,
 "junxiao.bi@oracle.com" <junxiao.bi@oracle.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
 "joe.jin@oracle.com" <joe.jin@oracle.com>
References: <20221207223204.22459-1-gulam.mohamed@oracle.com>
 <abaa2003-4ddf-5ef9-d62c-1708a214609d@kernel.dk>
 <09be5cbe-9251-d28c-e91a-3f2e5e9e99f2@nvidia.com>
 <Y5Exa1TV/2VLcEWR@kbusch-mbp>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y5Exa1TV/2VLcEWR@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/7/22 5:35?PM, Keith Busch wrote:
> On Wed, Dec 07, 2022 at 11:17:12PM +0000, Chaitanya Kulkarni wrote:
>> On 12/7/22 15:08, Jens Axboe wrote:
>>>
>>> My default peak testing runs at 122M IOPS. That's also the peak IOPS of
>>> the devices combined, and with iostats disabled. If I enabled iostats,
>>> then the performance drops to 112M IOPS. It's no longer device limited,
>>> that's a drop of about 8.2%.
>>>
>>
>> Wow, clearly not acceptable that's exactly I asked for perf
>> numbers :).
> 
> For the record, we did say per-io ktime_get() has a measurable
> performance harm and should be aggregated.
> 
>   https://www.spinics.net/lists/linux-block/msg89937.html

Yes, I iterated that in the v1 posting as well, and mentioned it was the
reason the time batching was done. From the results I posted, if you
look at a profile of the run, here are the time related additions:

+   27.22%  io_uring  [kernel.vmlinux]  [k] read_tsc
+    4.37%  io_uring  [kernel.vmlinux]  [k] ktime_get

which are #1 and $4, respectively. That's a LOT of added overhead. Not
sure why people think time keeping is free, particularly high
granularity time keeping. It's definitely not, and adding 2-3 per IO is
very noticeable.

-- 
Jens Axboe

