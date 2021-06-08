Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAB229CA
	for <nvdimm@lists.linux.dev>; Tue,  8 Jun 2021 21:26:32 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id mp5-20020a17090b1905b029016dd057935fso131731pjb.5
        for <nvdimm@lists.linux.dev>; Tue, 08 Jun 2021 14:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kNN1i0jrT7egcOu3/Gg1Kx3fRixlSMvnvYZBcIOdB0k=;
        b=r6G1vcNcZMXWXE6oDi0tLTFoeRKb4dnpyBZqrrJbmJwhBrCDaD1I7nyzN9J+47Zcb4
         9BF+Aq+xjvhTtlyr21YeXS6lD2Tbf6jDVsiwBnaP++TOlcPVHx2vFMzTrqQU+p9LTzZ0
         rvwrXYvPKkN7RFyyhxX57RGgHaG6v67wzF+cwyK+/OpOvNiXio42o1IuJEIjHzGMnKmx
         yDdIpf/30EykF5NoLqd/ESrGLwpjySkztMTAyEem8PU41Z6XgFncxxtj1l2xBlDLp5pI
         jZok4B0WsCatTx0KTbO/e9/Ev2SxFjLF6/PFL5q5w/ivFUBkq8dJ8Q311zak2hiPFXrT
         l1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kNN1i0jrT7egcOu3/Gg1Kx3fRixlSMvnvYZBcIOdB0k=;
        b=EA37zeeqtGY2k0CCzzkD7SV+ANbtF1gG2tKn1HxUwN1SbHN4KNK/oZm32YX6Qu07YF
         PQRwjCs5f9AdgT6ODs/NcfuY9r1rREd8yLQv2f6XNUM9kqF36uMLEjFy1aRPm8TcibKH
         dnxxwb2QpegGkviThbSlGiQY2e/G1Oc+Dr7rlsMJ/rlxwrqQjezLJupq8uU9QDUGi3PX
         ECxvslQe5cs2w3LZx1a/lWd5XLdTtWeKdVBBYNsu9uf/13G7OUvGAVOG3p2W2obqW46o
         cnKvdu8EPrOpvXKjQ1ipt70PDgt9eC0Ek4YuSn0g9Em8lh5VZY/+DN9ADMCPIeLNagTR
         F3Hg==
X-Gm-Message-State: AOAM532pgjNCPu6XyI0LBzaLvHlLMLtP9oK9Rzp/1LyXJdHGxINzwvLP
	LklO2PiVB3yQDjxR7hZt8ju5Cw==
X-Google-Smtp-Source: ABdhPJyTM1saT9p8ZYGVelfuMPmeTYV1q7Z3qAgPiVEANKFqHtJZduf+t/dNGiht2a5I2zxw/1RELQ==
X-Received: by 2002:a17:902:8d92:b029:113:91e7:89d6 with SMTP id v18-20020a1709028d92b029011391e789d6mr1700511plo.85.1623187591661;
        Tue, 08 Jun 2021 14:26:31 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id h8sm5800635pgr.43.2021.06.08.14.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 14:26:31 -0700 (PDT)
Subject: Re: [PATCH v2] libnvdimm/pmem: Fix blk_cleanup_disk() usage
To: Dan Williams <dan.j.williams@intel.com>
Cc: Sachin Sant <sachinp@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>,
 Ulf Hansson <ulf.hansson@linaro.org>, nvdimm@lists.linux.dev,
 linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <162310861219.1571453.6561642225122047071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162310994435.1571616.334551212901820961.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <1b2082fc-be01-ad2f-9dd5-aa66b1c0ce85@kernel.dk>
Date: Tue, 8 Jun 2021 15:26:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <162310994435.1571616.334551212901820961.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 6/7/21 5:52 PM, Dan Williams wrote:
> The queue_to_disk() helper can not be used after del_gendisk()
> communicate @disk via the pgmap->owner.
> 
> Otherwise, queue_to_disk() returns NULL resulting in the splat below.
> 
>  Kernel attempted to read user page (330) - exploit attempt? (uid: 0)
>  BUG: Kernel NULL pointer dereference on read at 0x00000330
>  Faulting instruction address: 0xc000000000906344
>  Oops: Kernel access of bad area, sig: 11 [#1]
>  [..]
>  NIP [c000000000906344] pmem_pagemap_cleanup+0x24/0x40
>  LR [c0000000004701d4] memunmap_pages+0x1b4/0x4b0
>  Call Trace:
>  [c000000022cbb9c0] [c0000000009063c8] pmem_pagemap_kill+0x28/0x40 (unreliable)
>  [c000000022cbb9e0] [c0000000004701d4] memunmap_pages+0x1b4/0x4b0
>  [c000000022cbba90] [c0000000008b28a0] devm_action_release+0x30/0x50
>  [c000000022cbbab0] [c0000000008b39c8] release_nodes+0x2f8/0x3e0
>  [c000000022cbbb60] [c0000000008ac440] device_release_driver_internal+0x190/0x2b0
>  [c000000022cbbba0] [c0000000008a8450] unbind_store+0x130/0x170

Applied, thanks.

-- 
Jens Axboe

