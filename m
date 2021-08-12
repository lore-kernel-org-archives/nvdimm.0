Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36E76D13
	for <nvdimm@lists.linux.dev>; Thu, 12 Aug 2021 21:16:46 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id gz13-20020a17090b0ecdb0290178c0e0ce8bso10049348pjb.1
        for <nvdimm@lists.linux.dev>; Thu, 12 Aug 2021 14:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OI8ci1d+dgNUl7Aw4253qYdgeFkxko6seYQQ/yrt9vs=;
        b=o2U/J85TR/Tx9W8qdUBhkkuV8NXqchJ5I0yi6yk8CvtTSDcfWVtz1KybX/x8fSvbSu
         IAjNWXkSHe8xe4TJm4H+vX5NKB/mcqEjIO7p9nvCRBNOQVjK01zMsd5OkVVppT13gKyS
         GRQ6XK0G9l8FL/iObdX5C/rUdMPrlWz4NvLou9PssoyC/bMZdZRZMX8kd++jNjscHduS
         rJu6SJ1KnZh5RmmLdXA051r/CTa7g+vkPXViVSe3eDmZa/OMx6wQ2WGNfUw3bWdGNiYh
         ADBin9h+y7gKXqXR3B5CD95ddY5Fc52cWE+671gLPcfFxUmYF7+S0t9g1rr9eejLemG9
         7YhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OI8ci1d+dgNUl7Aw4253qYdgeFkxko6seYQQ/yrt9vs=;
        b=iUEKb+wLDVsf1oYOT3Mka51vXyr/8gb2eKOW7yfeGpvU0P7XyGiwAKLbznX43jjXWK
         V5V0nNH8obOUIISOG3A55uY1ydgYbCxG2EWrDF5Yym/gLT9hGrlLvp69otnhPHfd/1nP
         xJTDlXPq00wOQUNVUQyM6U/lr8tCutA5DHKve0x5EKBRB4/mC6Hdcf+WqzBOQI7Pa9ds
         AXdhqRf2s3bbok5DhuS5s6GqBjKsuCuyr0FYtO6lzRPk3WrOXutzrYF9NygUQss528Da
         7HB1kW3aY6L0s1yHCAm21rOnG+O/hO3pPgw25fgJKjlqoqyl+KsqQD76rhZOX69FrcjL
         AbNw==
X-Gm-Message-State: AOAM531J3mT3tNukF3df3ZVtb3i3nRXKglrfUQYte4BlGWFniIqHqgHa
	jn/eiYE9QsqbHGisWHhX0ZK+faiHqPD74g/7k/OwPg==
X-Google-Smtp-Source: ABdhPJylnW6ytZFm8epat8ifd7GnDxw4hWnv4IOThF+qXZp5Fmq/JvilixkVjGU+WSp20WKQcAf96uAPHDTlCi27V+0=
X-Received: by 2002:a62:5f81:0:b029:3c6:abad:345 with SMTP id
 t123-20020a625f810000b02903c6abad0345mr6036127pfb.31.1628803006055; Thu, 12
 Aug 2021 14:16:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162854812073.1980150.8157116233571368158.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210811191319.00006d64@Huawei.com>
In-Reply-To: <20210811191319.00006d64@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Aug 2021 14:17:50 -0700
Message-ID: <CAPcyv4iaEcQSSHN=d5Gr03w7EX+CgRnU7geQiCprao8fqtUdcA@mail.gmail.com>
Subject: Re: [PATCH 10/23] libnvdimm/labels: Add uuid helpers
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Ben Widawsky <ben.widawsky@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 11, 2021 at 11:14 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Mon, 9 Aug 2021 15:28:40 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > In preparation for CXL labels that move the uuid to a different offset
> > in the label, add nsl_{ref,get,validate}_uuid(). These helpers use the
> > proper uuid_t type. That type definition predated the libnvdimm
> > subsystem, so now is as a good a time as any to convert all the uuid
> > handling in the subsystem to uuid_t to match the helpers.
> >
> > As for the whitespace changes, all new code is clang-format compliant.
> >
> > Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> There are a few interesting corners where you have cleaned out a pointless
> copy before validating uuids. Perhaps call that out as a change in here
> as it isn't as simple as just replacing like with like?
> Perhaps I'm missing some reason that was needed in the code before this
> patch.
>
> All LGTM.
>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>
> > ---
> >  drivers/nvdimm/btt.c            |   11 +++--
> >  drivers/nvdimm/btt.h            |    4 +-
> >  drivers/nvdimm/btt_devs.c       |   12 +++---
> >  drivers/nvdimm/core.c           |   40 ++-----------------
> >  drivers/nvdimm/label.c          |   34 +++++++---------
> >  drivers/nvdimm/label.h          |    3 -
> >  drivers/nvdimm/namespace_devs.c |   83 ++++++++++++++++++++-------------------
> >  drivers/nvdimm/nd-core.h        |    5 +-
> >  drivers/nvdimm/nd.h             |   37 ++++++++++++++++-
> >  drivers/nvdimm/pfn_devs.c       |    2 -
> >  include/linux/nd.h              |    4 +-
> >  11 files changed, 115 insertions(+), 120 deletions(-)
> >
> > diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> > index 92dec4952297..1cdfbadb7408 100644
>
> > @@ -1050,7 +1050,6 @@ static int __blk_label_update(struct nd_region *nd_region,
> >       unsigned long *free, *victim_map = NULL;
> >       struct resource *res, **old_res_list;
> >       struct nd_label_id label_id;
> > -     u8 uuid[NSLABEL_UUID_LEN];
> >       int min_dpa_idx = 0;
> >       LIST_HEAD(list);
> >       u32 nslot, slot;
> > @@ -1088,8 +1087,7 @@ static int __blk_label_update(struct nd_region *nd_region,
> >               /* mark unused labels for garbage collection */
> >               for_each_clear_bit_le(slot, free, nslot) {
> >                       nd_label = to_label(ndd, slot);
> > -                     memcpy(uuid, nd_label->uuid, NSLABEL_UUID_LEN);
> > -                     if (memcmp(uuid, nsblk->uuid, NSLABEL_UUID_LEN) != 0)
> > +                     if (!nsl_validate_uuid(ndd, nd_label, nsblk->uuid))
> >                               continue;
>
> The original code here was 'unusual'. I'm not sure why it couldn't always be
> validated in place.
>

Correct, I noticed that too and cleaned it up, but you're right I
should have at least noted that in the changelog.
