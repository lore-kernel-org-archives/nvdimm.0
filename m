Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908EB2C9C
	for <nvdimm@lists.linux.dev>; Sat,  8 Jan 2022 02:27:51 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id s1so7279194pga.5
        for <nvdimm@lists.linux.dev>; Fri, 07 Jan 2022 18:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Y9sTkwueG6bsJtbI7aXj47QmCW3VCqvOwcpsUpdDVg=;
        b=IdVzOf+EUp/v+gDOF7F5MsS5922XtOGLeBlHBcWXp4ITG4qGdjl5h12cgXmg48Gkth
         iAG7cc0RY5cf8UzA6D9QuU+TNSl91XOBzArwXeVKSH0WWdBAioUls77LmGLWoCeFX4Tz
         v/X3o7OBTr2uHO2wVKRqyRIU+g/j81tICyoAsyBdRupNZSijo0Ztzxv5dGBskFEP6SbR
         pMVtUgAN5pNzD7wMJ+YhBqQjdoEw7y0/d6RTccqyH7SGmncVHe4ESWZse8vOv2j2Gmu5
         oLo8/V5k4nc6s4DhhbmQ8nGBEapRfIg6kEnwPDCJqtsilomWxEnV58qD9B+sc/Tzgu/Y
         8s3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Y9sTkwueG6bsJtbI7aXj47QmCW3VCqvOwcpsUpdDVg=;
        b=C6dtZl4ce7oirWSp6K32fqk3WPvfJTKFOxehdYVyS5MrgRbPPSOzY8BSjb3xM+nlpE
         neJNHBVouXBJYClRh2MNxVv+/3QU2Jn8SZtd8TmFz9skDuztP6zuoG0w3XwWCrI9xGE1
         +jNZ/Lc4iHiAoGziXCEiClD7W4dhSVUEIOkTq41MAQz1dJ9BnWE8oayTXupgVAvWPmlr
         j/3E0A2/6rEguPoLnyzHSUSYb4qp6DgzZRKlK1N+yl9vTOgdkFvRiTwM+qVYCZZQxnoR
         uFKkgwJt3PFd69ktL7emb4xEOPHNxMpzwIKEIgapSYyX6p237Fudyo9OMajP4vyeMN5z
         bUqA==
X-Gm-Message-State: AOAM532PsIZMKxiOfZblt1mvuruE8G1RwMjVFPkCHlefJV89cIENxLLh
	7k6/3iRBWOKcou9WeKze9+IwgXLi+/QDKxhgEBrKAg==
X-Google-Smtp-Source: ABdhPJzGpfUTvlE3/xo6/aKgzHNu1O3aNt+i28YimlDweSJtG8u1rlYc99h9ZChonqjblXJxurbE0VkoW2RC2ZH1dDA=
X-Received: by 2002:a63:710f:: with SMTP id m15mr27618879pgc.40.1641608870970;
 Fri, 07 Jan 2022 18:27:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1641233076.git.alison.schofield@intel.com>
 <fa45e95e5d28981b4ec41db65aab82c103bff0c3.1641233076.git.alison.schofield@intel.com>
 <20220106205302.GF178135@iweiny-DESK2.sc.intel.com> <20220108015121.GA804835@alison-desk>
In-Reply-To: <20220108015121.GA804835@alison-desk>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 7 Jan 2022 18:27:40 -0800
Message-ID: <CAPcyv4jdt-936WpqNQv7hR2oPSFHbqsCDs40JgBJBaxZ-tHPJw@mail.gmail.com>
Subject: Re: [ndctl PATCH 5/7] libcxl: add interfaces for SET_PARTITION_INFO
 mailbox command
To: Alison Schofield <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, Jan 7, 2022 at 5:46 PM Alison Schofield
<alison.schofield@intel.com> wrote:
>
> On Thu, Jan 06, 2022 at 12:53:02PM -0800, Ira Weiny wrote:
> > On Mon, Jan 03, 2022 at 12:16:16PM -0800, Schofield, Alison wrote:
> > > From: Alison Schofield <alison.schofield@intel.com>
> > >
> > > Add APIs to allocate and send a SET_PARTITION_INFO mailbox command.
> > >
> > > +   le64 volatile_capacity;
> > > +   u8 flags;
> > > +} __attribute__((packed));
> > > +
> > > +/* CXL 2.0 8.2.9.5.2 Set Partition Info */
> > > +#define CXL_CMD_SET_PARTITION_INFO_NO_FLAG                         (0)
> > > +#define CXL_CMD_SET_PARTITION_INFO_IMMEDIATE_FLAG                  (1)
> >
> > BIT(0) and BIT(1)?
> >
> > I can't remember which bit is the immediate flag.
> >
> Immediate flag is BIT(0).
> Seemed awkward/overkill to use bit macro -
> +#define CXL_CMD_SET_PARTITION_INFO_NO_FLAG                             (0)
> +#define CXL_CMD_SET_PARTITION_INFO_IMMEDIATE_FLAG                      BIT(1)
>
> I just added api to use this so you'll see it in action in v2
> of this patchset and can comment again.

Why is a "no flag" definition needed? Isn't that just "!IMMEDIATE"

Also BIT(1) == 0x2, so that should be BIT(0), right?
