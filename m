Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855B1168
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 18:53:50 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id h1-20020a17090a3d01b0290172d33bb8bcso4492935pjc.0
        for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 11:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ON3G2Z6IWRorYbI97FcTafr8gCZT6sggkTN1icobpk=;
        b=pkDZFtRLQwbBtNqMZyPA1OmkeOUvPmbFoAzp0UMvyyanmkFouYVfZom/abUYk+MjC6
         0NsKbNFt5/8XDgUDCFSYeOYyYsiwhdAAaaN7dw8QXLrmmVZ9LftqfAiFJOHDBvXHqJfT
         VUVTX/3u7IPk+kT9iZwtODwuXo7+5SzMJ7JdqIBpyCpuf0tfz7odFsH+PpZnQ8R4KX/O
         C6ymQX0+Oi0TcSxuVkXdCYj2qBlcLS3AXKbatfV8xtedl3ulQi+GJNwi1AsGagPp4UeZ
         UeeE1z4yuaqNpo5KZZGeFJDMd584PRDm+lS7rwUSvQHIIwYBtP2v31KZ8KC3wGNe1/ar
         4tIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ON3G2Z6IWRorYbI97FcTafr8gCZT6sggkTN1icobpk=;
        b=Rha13A5APAeom5ThZfrYVWmy19hbfbLSim6l4sZQhunt8/twFl7WhPVL9QqlE1f78A
         46FRn83slXGFAeWDB/4t+2rkZBiXbm+K7l+abfCi78h0LAIoLJwSBPArooj2ZieSbvWJ
         PnIF999GA7e9vUVyw7hpWqdAQ1SWz759G/iZySEXGva189Z9SGER+m/2iXag40LmoqWn
         m3dNY4LabrYzR6cAqd1eRRq8vmuMZn0O0W8RVzcrF4x1cyQZ8CC9VXNtuEZMrgI5p2aU
         9p+0RRJNeed5YAGYd4pSDV1xgSqCh2YFeRNyLcgbuq27X757EuKRmnVne7rMT41MXqzI
         GhYQ==
X-Gm-Message-State: AOAM530Hc3fguWl+ES7tg9ZSpsP/huc1RGCTL3XwMn3gX6mc4ZZgJXmy
	Qxvhxyc3umxTRKvFYUV01BqGNm7KLppOTAsd2JZ5vg==
X-Google-Smtp-Source: ABdhPJyuGQ9xsCXZvs6+UQ6iAMwgNXhSfTcIqqM4AhaRqRxyRQ1LvNcFDPJPswtUyBOmcdyHxDHKS3BNHr0JcLDv5mU=
X-Received: by 2002:a17:90a:2f63:: with SMTP id s90mr5030539pjd.168.1626288829940;
 Wed, 14 Jul 2021 11:53:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162586035908.1431180.14991721381432827647.stgit@dwillia2-desk3.amr.corp.intel.com>
 <87mtqo68e4.fsf@vajain21.in.ibm.com>
In-Reply-To: <87mtqo68e4.fsf@vajain21.in.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Jul 2021 11:53:39 -0700
Message-ID: <CAPcyv4jjv=VMLdHx-vJb5b5NOZHQY=_qzJ5Ym+zNa9A22zj9Qg@mail.gmail.com>
Subject: Re: [ndctl PATCH 0/6] Convert to the Meson build system
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 14, 2021 at 11:47 AM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > Autotools is slow. It is so slow that it takes some of the joy out of
> > hacking on the ndctl project. A fellow developer points out that QEMU
> > has moved to meson, and systemd has moved as well. An initial conversion
> > of ndctl to meson shows speed gains as large as an order of magnitude
> > improvement, and that result motivates the formal patches below to
> > complete the conversion.
> >
> > Given that this change breaks scripts built for automating the autotools
> > style build, the old autotools environment is kept working until all the
> > meson conversion bugs have been worked out, and downstream users have
> > had a chance to adjust.
> >
> > Other immediate benefits beside build speed is a unit test execution
> > harness with more capability and flexibility. It allows tests to be
> > organized by category and has a framework to support timeout as a test
> > failure.
> >
> > ---
> >
> > Dan Williams (6):
> >       util: Distribute 'filter' and 'json' helpers to per-tool objects
> >       Documentation: Drop attrs.adoc include
> >       build: Drop unnecessary $tool/config.h includes
> >       build: Explicitly include version.h
> >       test: Prepare out of line builds
> >       build: Add meson build infrastructure
> >
>
> With the patch-series got working builds for ndctl/daxctl on ppc64le using meson/ninja
> Hence,
>
> Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>

Thanks!
