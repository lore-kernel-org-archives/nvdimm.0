Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA1623A6
	for <nvdimm@lists.linux.dev>; Tue, 12 Apr 2022 23:22:46 +0000 (UTC)
Received: by mail-oi1-f169.google.com with SMTP id 12so313080oix.12
        for <nvdimm@lists.linux.dev>; Tue, 12 Apr 2022 16:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cXG2uBz6lRa6SmsxOh4UHnvAS1v6j3gtk2oaRONS+x4=;
        b=VPl1Lq9jWUOfdQHl/1KZuWWM6wCjlya9ZIm56mGgKOGxFiC5BaCc1BSVeUdc1pyItB
         BIIRsGb7m/uTTFP7EQ9bwdIRf6Qc2mw3gELQG2VwZAg2xJ2tVel9MI1+ME9SUoGaJ8Ck
         Z8ts0Cz8Sv7S9Fzd/Im/JfbGqbs45u5Dpd4A8hT36LVn0vEKF5gJNhz9Xj3HxeT5GFx9
         3orzrVLxvjY3XUMpiLuJPsctZxiLUWVgCZp6UZHqMNblOrfxFCYbsUPAtL6PjFLKvIYv
         yR16Pm/ZW/nafNyxKUqk8z/2UQ0ECbaF4NEyEpOJWqi+m9FgHi5wKcizOSX3GGI9F65b
         O8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cXG2uBz6lRa6SmsxOh4UHnvAS1v6j3gtk2oaRONS+x4=;
        b=iVcILUR8hyCjBI/QpJHRih6tGGwENCO/ze1pGbSWcItrJo9vkSNYBbetZJzpUmdUQm
         Ue1ae1SW5x95kLyke9HmuHfvYMBmtjRpyj73hfXddgrfpGdM7mkEHb6eWVxnAk0M3zbT
         GMW7o0k9yrCIoNu2krNWTGTWF8ge8nDrJ3k9YCRTYx9LuOjj6IfW2XwCBnu7/8Q5hZAX
         dNBeRad1kXRF0bDPlsuyzsS7x5OLbGpgMaoV6CvWcg99MVrDU40vcUzy3SJ4dM0nCn04
         RV8qDCsbjLAgvVSDF1KzdvGezxt1dhTMaxUwUqYwVLKxRLMka0C51ValugapbwMc8jam
         2Ehg==
X-Gm-Message-State: AOAM5300KDCVDTjLLyUdHTR6up6+QuqTsa1DH4q4BkzXJZB3Jh/1bV/U
	ekyoOuaQqIMAMZWmqPdLkmGvZ3c4ccRtEUNASTle9Q==
X-Google-Smtp-Source: ABdhPJzEsDa0QPWqZoKnqzlrHygJjKtOSvpADAV6Jhisjm10RxdCfr8ioS/LCXNm6BQQZeX47QnFzwejPCzwj9rtzOk=
X-Received: by 2002:a05:6808:1154:b0:2da:2fbd:eba9 with SMTP id
 u20-20020a056808115400b002da2fbdeba9mr2979048oiu.133.1649805765445; Tue, 12
 Apr 2022 16:22:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220410160904.3758789-1-ruansy.fnst@fujitsu.com> <20220410160904.3758789-2-ruansy.fnst@fujitsu.com>
In-Reply-To: <20220410160904.3758789-2-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Apr 2022 16:22:34 -0700
Message-ID: <CAPcyv4iqHMR4Pee0Mjca2iM6Vhht8s=56-ZefYvpBmxuEi0Q6A@mail.gmail.com>
Subject: Re: [PATCH v12 1/7] dax: Introduce holder for dax_device
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, Apr 10, 2022 at 9:09 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> To easily track filesystem from a pmem device, we introduce a holder for
> dax_device structure, and also its operation.  This holder is used to
> remember who is using this dax_device:
>  - When it is the backend of a filesystem, the holder will be the
>    instance of this filesystem.
>  - When this pmem device is one of the targets in a mapped device, the
>    holder will be this mapped device.  In this case, the mapped device
>    has its own dax_device and it will follow the first rule.  So that we
>    can finally track to the filesystem we needed.
>
> The holder and holder_ops will be set when filesystem is being mounted,
> or an target device is being activated.
>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.wiliams@intel.com>

I am assuming this will be staged in a common DAX branch, but holler
now if this should go through the XFS tree.
