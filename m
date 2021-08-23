Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F113FC0
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 18:47:41 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id x16so16157827pfh.2
        for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 11:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r54pHmxmjGri522v1PTJT3wgqKLwaTSuYN7KqNeOshc=;
        b=ON0Ulal5HgyBW6cTYVJVpFVeEknnHV2b+ct6UfJ6exaBr/kDhaiOpzwwr8mE1X+ftG
         yPgh8gE6jDzcJ1g7pOYTIqOpKhhBy6qoKCVzKNWbCsH7nerKcTiz/0qRdPflFtj7rpOn
         TOutZH8U7o3//PAf3veh4KzsMBh+k7AtIBWx7p+96JYNtLQ4WL5AvSqPt+4VLJq0Mwhu
         IK8GuHp767hRzY4t5tJUgyDxieGLHIocbNliT5hx4QE5MzhfhbvhOkfbhc2w1sYCCdpk
         IZH5DRWYU6KH7vcc4s642VXtiosILos3qzTun3RQGz0Wijao65Kdp4C/SA0InLbTkXnt
         9baQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r54pHmxmjGri522v1PTJT3wgqKLwaTSuYN7KqNeOshc=;
        b=EFDXNbSVzJnkQ9FD+w5jt1E/rQlcx8h7IuueO94jJbTp1vludpXTcLtwHbJ4x0ydVG
         29hFlKlzWwfFZH9UMN+ORkpwJRi1PKt7SvTFQIK3/GSzLYj/VyPtoPwm3O4Z7nFmYsRD
         vTKfhv2nl4/oRg+GeYTlzbsWidyzCiNoh4WBLyriv4td8UFdnWpvm6Jg3BJEeSX7lwZ5
         rypL+UsdFZEx+L+c5bJGgvUQbAlTjq0uDkGzX/44RQ1Ank1pMyHTiR6K30kdooJnavac
         ePoZ+3XLJO824qvzWVdYLQYoxLlnPeMvFCwphvPAItje/2AXmXbLlV1QY5Z4nSn7ZfFo
         Dmhw==
X-Gm-Message-State: AOAM5301A82rz7HVRSDaFI8u63H42CRER4SKPGNvOyITlXib9qEydH/M
	6S+Bu1GyBxoXdhUwGFwRteb1lKkUuV366/drNxX5yA==
X-Google-Smtp-Source: ABdhPJzDVavO1D0cuxFMJfc7vAR6mGcyWNFXeb0k5SW+uv+Pt4QHySWz8XFkNATSzrUwGSt4zomLq2aChoPEcZrN8qg=
X-Received: by 2002:a63:dd0e:: with SMTP id t14mr32045829pgg.279.1629744460943;
 Mon, 23 Aug 2021 11:47:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-3-hch@lst.de>
In-Reply-To: <20210823123516.969486-3-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Aug 2021 11:47:30 -0700
Message-ID: <CAPcyv4jGqOh3bq=5bgkAaOjp5SUOVGKQyXYsPsurtGtDiY2a9A@mail.gmail.com>
Subject: Re: [PATCH 2/9] dax: stop using bdevname
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 23, 2021 at 5:37 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Just use the %pg format specifier instead.
>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
