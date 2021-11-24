Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48DA2C82
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 03:52:22 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so3888076pjc.4
        for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 19:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6zOlc/LjY/38MNl2fNjkOvdM3xFlyfeXQW77bsVPs7U=;
        b=lAK1cPsbcZgDOnzv+wRyX5hFeuNtWn74alyzSOfh2WTiCK6b1Gd9bfDzl0+LSFYqBx
         NFA78tBSHfT8IWLc76OROAypo1vlQiiVSp+deqPBmSErFfOP18cWXFbnZCxI9VIMHHuR
         rkB6XFn/xh99StS9siD+gMovD+TGGHheUMxQDm6Fs4TRxLl6LVPgdXFahdYzrs2kgHk1
         2vtAqiLmzKNsso+noEF/MbJXbTSUoUVvNEOcLZD7XraD8UxaJOkOnpqbEwEn6rei4bjJ
         t5MvTN9s/WuPOzLWfQKYxVJtbNdZgfs/23Dfq3WeRbXM/0WgTMF9HeylQ/9xSVmw3Fc5
         g5XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6zOlc/LjY/38MNl2fNjkOvdM3xFlyfeXQW77bsVPs7U=;
        b=d4IB+S2nnxalON6gegOOgHhD8N+05NAIkiL6XDzobnhB19DPr7ZPa+x+16KTMhLpZZ
         rHI74P7/LgEiTSS84w1DPe+hOPpSM/lfGiO6t/UvpcrIxoohvUHkPscG+YtOrkI5cA3o
         VjZyQTPZMcewd54AJ2FP+a4DZv0IjdX630mWnQx50qww995N6GEdKPXmeyM+7evhoe39
         EExUbN9012kQ1CfO0QQJfiLtjXV+W4JahuOz43jlbH5angppY9vwzvzALUpWNDoRtWgM
         2CEHcpRWfqzmn31ErCrOswo0PbHxGLbdbRodFfKj9zDU8Zb8eiftcq6+iEyLaPgmnZlW
         NVhw==
X-Gm-Message-State: AOAM530TDy688OK6w6NfxRH6vIObgVxbvGOzvG7odzwgn4DiZpKBrbvz
	7fqMySNanMTl46vGvZLIVL4qz7uA+wqPpT3EznYqcw==
X-Google-Smtp-Source: ABdhPJymXNtj/xuoHYk/qKEwmz57TlRY6ykmrutCD2G8CDlG536bSV07F4JpqasRcpvkUcp5iE8OReW1Fq5UwnxXf/0=
X-Received: by 2002:a17:90a:e7ca:: with SMTP id kb10mr10703847pjb.8.1637725942362;
 Tue, 23 Nov 2021 19:52:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-30-hch@lst.de>
In-Reply-To: <20211109083309.584081-30-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 19:52:11 -0800
Message-ID: <CAPcyv4gNH1ex_6+pHmpv_pWGV8H8KomzWFtfMvtntNe++x8OBA@mail.gmail.com>
Subject: Re: [PATCH 29/29] fsdax: don't require CONFIG_BLOCK
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The file system DAX code now does not require the block code.  So allow
> building a kernel with fuse DAX but not block layer.

Looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
