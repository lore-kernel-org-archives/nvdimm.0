Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C4368
	for <nvdimm@lists.linux.dev>; Thu,  9 Dec 2021 01:58:55 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id u80so4033190pfc.9
        for <nvdimm@lists.linux.dev>; Wed, 08 Dec 2021 17:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L1T5kw0pZcNts8FOP/PfwU4eyj9hIko4e2Jf8qhaR54=;
        b=Am1lWsGbBD8k6Gs6ODuIUg2RL/OgQkiCvVyy+TGCnSjjaya/C4UIEKYczYZJInND5q
         NEzMQSYXefk8ofo6cX1eYWFf2M2u+mDOgvBGYc3A6CY5UsLMIfWle8rnVwAT/EMp+XMg
         ifeiXM1HzJSNTrIpPCZCNL4yKEhvyICcW2qRrW0Lm7Mv9lRiMb9GjV7EfoQri/pY4miw
         BX6KoiLnmZel7/Tf1dRQguVFSpFyshdj4rnQrdiNlmyR8RTeMPZtRbV39xo3Uw5kv6Kn
         rycicUNV+7xlGGVNkkM0OfwBaIMyB6/tQG+z5NoPSHzta5JiglKPceqAoC+2B9Qd6s/L
         NjHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L1T5kw0pZcNts8FOP/PfwU4eyj9hIko4e2Jf8qhaR54=;
        b=fBCzMjI785LhlwMFJDi0mpnWK7dbLQGQSFkNq2x4lT4rSgG5zJVhavgXhnGdZPcwME
         nAEI71Ap+OEIjhq6fPvlK3ADt7wvur/QRnX6A36UGCcxTZcSgpqAYfGcU9Djq1YfRekd
         h7BLHkEB1sJ2/+Rr785tqJV2C6ZhHpQwjXPTBgPp/tfO/OThKMQOg5RBsL3hFeOHzoPE
         fLOxMrs170+o9RAN59KpuT0BMa4dG55AqQFOrtRiJ5lM3PfuXiRenmHNqoQOr90GSY3z
         B2A9Fdmn3tjZDukJVvyC5OKUVBWUfUvISGoG0lcrvdkjtpe9gy4pM53Q/9OUWBw4wtQ/
         lprg==
X-Gm-Message-State: AOAM532teEF0//sBg2mhWSzIUss49ksEXtHqWvJ3Zo8zCwQqdIiwzIDU
	/hqc+eRCB6gN9UUiApoewMa2L19rWbsIP6+c0nrKFQ==
X-Google-Smtp-Source: ABdhPJzAnoM9tgR/eh2HsITyJR3hItduz1eHZo9++I+GO7sFsnQRiKr7UiulUnv9YeK06rwF3wnyl2FTdM1vcsOiXQ8=
X-Received: by 2002:a63:c052:: with SMTP id z18mr29045322pgi.74.1639015135135;
 Wed, 08 Dec 2021 17:58:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211208091203.2927754-1-hch@lst.de> <20211209004846.GA69193@magnolia>
 <20211209005559.GB69193@magnolia>
In-Reply-To: <20211209005559.GB69193@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 8 Dec 2021 17:58:43 -0800
Message-ID: <CAPcyv4g3OG3cSpOEm9J1HLZjzRBhSWotSyV5RZxt5FYV_0=Knw@mail.gmail.com>
Subject: Re: [PATCH] iomap: turn the byte variable in iomap_zero_iter into a ssize_t
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 8, 2021 at 4:56 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Wed, Dec 08, 2021 at 04:48:46PM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 08, 2021 at 10:12:03AM +0100, Christoph Hellwig wrote:
> > > bytes also hold the return value from iomap_write_end, which can contain
> > > a negative error value.  As bytes is always less than the page size even
> > > the signed type can hold the entire possible range.
> > >
> > > Fixes: c6f40468657d ("fsdax: decouple zeroing from the iomap buffered I/O code")
>
> ...waitaminute, ^^^^^^ in what tree is this commit?  Did Linus merge
> the dax decoupling series into upstream without telling me?
>
> /me checks... no?
>
> Though I searched for it on gitweb and came up with this bizarre plot
> twist:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c6f40468657d16e4010ef84bf32a761feb3469ea
>
> (Is this the same as that github thing a few months ago where
> everybody's commits get deduplicated into the same realm and hence
> anyone can make trick the frontend into sort of making it look like
> their rando commits end up in Linus' tree?  Or did it get merged and
> push -f reverted?)
>
> Ok, so ... I don't know what I'm supposed to apply this to?  Is this
> something that should go in Christoph's development branch?
>
> <confused, going to run away now>
>
> On the plus side, that means I /can/ go test-merge willy's iomap folios
> for 5.17 stuff tonight.

This commit is in the nvdimm.git tree and is merged in linux-next.
