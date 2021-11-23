Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EF22C83
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 21:50:03 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id q16so269411pgq.10
        for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 13:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TYkPf9vJ648gXjsCEnGEexU4+Ifkiqg1wwbcGn6CCJ4=;
        b=Zg2lBRkAMXF8A+wvUtTCMUUrMwJSgDxXgPFdIJ6mN7vtPUcxzmlaWcpTf9u8Q3z98h
         X/Q6JeK0cyueZaLleVAsw/AXaT4zKEIJmobxui02H2iRJwR6JQ6k+7ohKUH/xkhZtcrk
         AUpJh1ywhRU6oaywvvX2nXCy9HlVnkwENOYB/cohnRCUpdHTb0Po2TpaAZ5v/3eSZpRI
         8V3uh9/QGNOkIwreJn4bL+pCGYZydEDpnqKywmkmy4aH4tbxUO5DJdIr7F4HLJ2A0sqA
         ygzmFWm5Okq9v0BfBD825f1vPnJFQ6RvtJm08BV2t1iAQ4uh6Zl3udb+YoU4MJmQj7Nw
         WjVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TYkPf9vJ648gXjsCEnGEexU4+Ifkiqg1wwbcGn6CCJ4=;
        b=4qZArZC2ccAlUT+k8u8YULdrlP61bnqMRfivLW/T5WGizOiV1KXBKj6em9xIp6iudy
         XbpC9vyFCd6qGc7spK+WFTuJVTtxCfdrOYjmhkDAQrQYvkv6TmAWo9FZ0Bfv8ZcsAg/5
         9VwIDJjdzWLZ0S+/fc9DRMrioRpEOI7LECKSeyO4RnBzfM1s3vnZKxA+ZLqlMBjDMlL6
         NPD03oeF5I24/HOwlBl3kRVg4NdDqKTnQ22/ovQxomXpO0otwmZkF0E3h4i+6qkOPfNx
         EJwEzDXaEyhU2hx32bWnRaTR11YRWA8ZKzzYFg0sG0HmD9BN4cU63J8gMj7Xn4u7NJpZ
         Z7ow==
X-Gm-Message-State: AOAM5305xxOjdwkJzLArPOYsLqfIUOvd5Na6nkRtrovJoU1yctoInDaA
	C/ssf5GchAHgSofFSSoYgo81bDRPu5lo/xhXpuofRA==
X-Google-Smtp-Source: ABdhPJyGFtcTnW/NcVjiSH5pncdxregmswvMZp0GGEC99SZ7f8Vh58bATLOZJ9aYCBUx/N4xWCbII0nzMB7q2Ks2bo4=
X-Received: by 2002:a63:5401:: with SMTP id i1mr6259530pgb.356.1637704203058;
 Tue, 23 Nov 2021 13:50:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-21-hch@lst.de>
In-Reply-To: <20211109083309.584081-21-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 13:49:52 -0800
Message-ID: <CAPcyv4htTDV10OkdXfWJzES2dUdm+7PDsX6LPYSxEYFnNVeMwA@mail.gmail.com>
Subject: Re: [PATCH 20/29] ext4: cleanup the dax handling in ext4_fill_super
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Only call fs_dax_get_by_bdev once the sbi has been allocated and remove
> the need for the dax_dev local variable.

Looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
