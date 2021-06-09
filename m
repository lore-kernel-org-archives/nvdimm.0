Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6966129CA
	for <nvdimm@lists.linux.dev>; Wed,  9 Jun 2021 15:10:02 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id n12so19681243pgs.13
        for <nvdimm@lists.linux.dev>; Wed, 09 Jun 2021 08:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IBXcSszBYphaifHgOC2J5NicZzuUQ/7ILUQKgpfvwwk=;
        b=C2gl0t8sa0OyDrmf3CGQvVpN7nKMUYnmoNEFFTwsu1rvQew7e5y/VeHC/86fkQDjj4
         kS0WkTlD8Ceci0rRgBKGIOxxqx5mmfAnsGvIW4D2hP0H2CT8FkfLRyfO4wnEn3CRImXQ
         6hODDRY2KZ2bteVDwMEgv89PWnibSd6Icuq5M/TzFpQgWtOnTzVmHILLuywqqKJ8IWvN
         /GmlpLSyFKiWDVC3wFptS7roPpZxXJqRptRC78LSgz5Q0HQe6Gdy7IRSYoP7kDF1ahzd
         BhDgkaAtBM/PIMwxNDJcCpkOKifkUn+sZTr+VKvHFOtBW0z2aMry+BxYol6/GICuQnbX
         Bomw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IBXcSszBYphaifHgOC2J5NicZzuUQ/7ILUQKgpfvwwk=;
        b=rVGt0Oh9fKNp1Uuw38RHYpfWOQC+OdOWNp3OP4Luh5aHe6C5pKF4wnx58v9xBp4Vhs
         8XaFSNesKx5PAhRidGvtQQoLzEPvDXjcvSWti4ak0I4mjv5zndvplrE+eG8G3f/XVFVz
         T8KVSZlvCj30Dm5BUp3Wv9s3OBePnOe9WVIP/aw4Seg5WLjZO8Z8lkmCXmIAy03MRC0l
         LuCyFxfGLLbuaNcLfzq4djrZ13DI4HuvZ/1q8blNPUNgUP5p4Q3uqVp/4jMLQMpa732E
         V3WuOD/Bmp/rtJ/Y1LSIOMhJV8w8vgKb6MMegPwJJ9c19StQstZVmxp7MT45o3DZwgUu
         +wjA==
X-Gm-Message-State: AOAM530sqLJTKfvOswHMjYGzKNzWfRIQ/CXUjAQeqTNB9U6AZ2r5PQeg
	dZqRyOU2wRrSwYmD/HyF5Ew05Q==
X-Google-Smtp-Source: ABdhPJz/wOFlRsZKTXHwHzYsamAIgxhiZCMsps1pYK3Xqq2UY0/65dNFjGGQY7E5ydXHaeMf6n8wUw==
X-Received: by 2002:a63:1114:: with SMTP id g20mr132875pgl.385.1623251401815;
        Wed, 09 Jun 2021 08:10:01 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id u14sm77968pjx.14.2021.06.09.08.10.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 08:10:00 -0700 (PDT)
Subject: Re: [PATCH] libnvdimm/pmem: Fix pmem_pagemap_cleanup compile warning
To: Dan Williams <dan.j.williams@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-block@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20210609135237.22bde319@canb.auug.org.au>
 <162321342919.2151549.7438715629081965798.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d3a32947-80b1-3d12-e96c-88f599d486a3@kernel.dk>
Date: Wed, 9 Jun 2021 09:10:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <162321342919.2151549.7438715629081965798.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 6/8/21 10:37 PM, Dan Williams wrote:
> The recent fix to pmem_pagemap_cleanup() to solve a NULL pointer
> dereference with the queue_to_disk() helper neglected to remove the @q
> variable when queue_to_disk() was replaced.
> 
> Drop the conversion of @pgmap to its containing 'struct request_queue'
> since pgmap->owner supersedes the need to reference @q.

I folded this in.

-- 
Jens Axboe

