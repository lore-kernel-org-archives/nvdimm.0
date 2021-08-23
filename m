Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAE93FC2
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 21:10:22 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id v123so1758638pfb.11
        for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 14:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kERAiQoYaUiZLUwWrv4bOyfnlzgpfin7j02w+F9IvyI=;
        b=lt4AXvvtTufuHda/bGjNiZxhwiAm/AnyRlhljPx5+BrAEe34p23FhAtHB3HYEPECjI
         jZJJBRria/KJ2mzQ9LOwyzbCZoSDaOdQR0S9CRFr6soYOqwb/+FUoQUrKf/mlQY4M/No
         ndC3I1GeQjlJMJ/jw/JblYnAZq44iy2TYPyqnbJDRkcgjClk3LC8P4WfyaypwNTJEmKy
         RnigTJKYP/gKvnicdNOGQq68auU7dv4psI4APDrepknd32ykDnbq7z6T5MQJv19mjiWP
         +i8XIcGhUKXqKHEMe1QF0XZeeTc5nlVkb6dsFL2GNpG0DZg+xXbWpj/FUtsMz52eKKbN
         kD+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kERAiQoYaUiZLUwWrv4bOyfnlzgpfin7j02w+F9IvyI=;
        b=P7PB21CPezFryZ+fkcxvbJpwUdHJDFQJuFtSf0+mbdWCU6AnP1zmM+zZEK/YxViWM0
         QXdsf4GpeLlam/go/dnNl1KahKC7I338krB0P5VtokKM0lwTv05f+CbF3/4RyVbt0MaH
         Wm4LfdvO/B1Uty1bh9ls6DxbWCkUm/W9iKoIM6aoZ8ZGuJZe6NIOqYf+o+iL1qGUrrjY
         yBXJc4qZPnoDb3pCEBxPuvYDn7vhDctuYDBkdkBDiMRDurWsyNjEP7n/QU9MKQwlyvPM
         Ca6uOZXqzzVoCRGgyykdcmjnIWvKXXNbdQ3RSvHs/547o538N2eHDbw+6Lng3mhiHc8H
         dgfA==
X-Gm-Message-State: AOAM533PMI4/pFUBhdKIvv8X0lpRBIYZC5t5wEd0ZgCC4DrRIZ9/3lNa
	ugeUCgXH4AGPLtW4eRdi/qAA0ch3u7Zwu5g9tZcu/A==
X-Google-Smtp-Source: ABdhPJx+EAx+0+aNllv7PT9bB+oTaqYHbUG37U6GeVa/xR+D4Ew0wB0pvGbJbwzWaANuG+iJwDebQ2Xozd6MWf+fMBg=
X-Received: by 2002:a65:6642:: with SMTP id z2mr21533804pgv.240.1629753021975;
 Mon, 23 Aug 2021 14:10:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-7-hch@lst.de>
In-Reply-To: <20210823123516.969486-7-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Aug 2021 14:10:11 -0700
Message-ID: <CAPcyv4jHYL=TYW-_wF3uTnfzDbGuLqSm-P5Uw+w+jyd89J11Sw@mail.gmail.com>
Subject: Re: [PATCH 6/9] dax: remove __generic_fsdax_supported
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 23, 2021 at 5:42 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Just implement generic_fsdax_supported directly out of line instead of
> adding a wrapper.  Given that generic_fsdax_supported is only supplied
> for CONFIG_FS_DAX builds this also allows to not provide it at all for
> !CONFIG_FS_DAX builds.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
