Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80352C81
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 20:55:23 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id 133so6647041pgb.1
        for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 13:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s6fHiB47awPBWpjFYDqA/6sfMb3K3z3+8/CcbFBsGHI=;
        b=z+dc1lD2rCPqp9dY1vRI1BcMA5swqStK3Jc9skl3pu8pXGjExhuTmsSnJoixAFJYwK
         mzXBINPS8zqL37XEHf12KWwlHmc0LFPwC23UhSgPALZj6lqisrKpydoXpfxfp7JcmVf/
         Bxn1usbFH3iCJUDZqhglS3W/wzXb8+nbkocTOWsgBk/UILmhnuA7sw4KoJDFvXo0S5ij
         yLncVzp4BkJAcg/X9R0uVKnlzROYcgLtcvoOSUhJW2aFKaTJmtqOCopFniH5hRP1NMe0
         XAqyPh8mkSxkfUNmlymxARAEiyW6iQAhSmxJX72ABuI+vnbdWdg8FdrqJI+mOWqZA1lR
         FXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s6fHiB47awPBWpjFYDqA/6sfMb3K3z3+8/CcbFBsGHI=;
        b=cC+EPvwuQDYxNXplzxQwS25j/cRR0LgoeDUajBCuImgdeyTaBfpK9aP0Pd7SrccFNI
         QdQuvDsDMTi4haZkkpgQYBthvG6jyr7QW0SOlpinWW8LGipaJ0AUF/icLXa2T/TbBqwf
         Z7MRlcs0xDXFM/O6o+ZBQabzSHoI0D0N5jKIhTWUa/jawkWYXz1rjvD/ydg0Hr5mZq6E
         UEv9SIdOGi8+A04McVXId/+2msVYX4tDo5sbMYc9Y1U9m6rn0HpW1fdTh6bFVqQutlkr
         sIVwd64wpSsY648UnKiVyN7YCm4NwrdeQ1oSLs/5l6B+N9CnEaVr0XwHFwDJ0XiY5sGZ
         2Nvg==
X-Gm-Message-State: AOAM532dZFGB6CjjlQ3uHWDeOaCto9RvFweb87HPt6ly52JUsHyfYtRV
	5uXKUJBuZ1fEcOVXQ1ri6irGl2mBAAMPI9MZejoVlA==
X-Google-Smtp-Source: ABdhPJzM1DWVNxD1uRudT3AkakCCLUnpWkVPRgBmjVO89BHBfhak2/W8hXh7t9YEtPAvuE3NumnVu2XMqDtTCI1yi+w=
X-Received: by 2002:a63:d709:: with SMTP id d9mr5817363pgg.377.1634244923089;
 Thu, 14 Oct 2021 13:55:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
 <20211007082139.3088615-9-vishal.l.verma@intel.com> <CAPcyv4gMdTWPbLSo2+E6JzOzaf8soTwd+nzpBgcEZ-41BRJ63A@mail.gmail.com>
 <37ca5a878f72742bd85aba7989383a985e1666b2.camel@intel.com>
In-Reply-To: <37ca5a878f72742bd85aba7989383a985e1666b2.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Oct 2021 13:55:12 -0700
Message-ID: <CAPcyv4j5kYEbX_Zn2_5=J5h933e_W4vKbV7Th8RC5H4qy3r9Kg@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 08/17] libcxl: add support for the 'GET_LSA' command
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Widawsky, Ben" <ben.widawsky@intel.com>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 14, 2021 at 1:06 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Thu, 2021-10-14 at 09:35 -0700, Dan Williams wrote:
> > On Thu, Oct 7, 2021 at 1:22 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
> > >
> > > Add a command allocator and accessor APIs for the 'GET_LSA' mailbox
> > > command.
> > >
> > > Cc: Ben Widawsky <ben.widawsky@intel.com>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > ---
> > >  cxl/lib/private.h  |  5 +++++
> > >  cxl/lib/libcxl.c   | 36 ++++++++++++++++++++++++++++++++++++
> > >  cxl/libcxl.h       |  7 +++----
> > >  cxl/lib/libcxl.sym |  4 ++--
> > >  4 files changed, 46 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> > > index f76b518..9c6317b 100644
> > > --- a/cxl/lib/private.h
> > > +++ b/cxl/lib/private.h
> > > @@ -73,6 +73,11 @@ struct cxl_cmd_identify {
> > >         u8 qos_telemetry_caps;
> > >  } __attribute__((packed));
> > >
> > > +struct cxl_cmd_get_lsa_in {
> > > +       le32 offset;
> > > +       le32 length;
> > > +} __attribute__((packed));
> > > +
> > >  struct cxl_cmd_get_health_info {
> > >         u8 health_status;
> > >         u8 media_status;
> > > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > > index 413be9c..33cc462 100644
> > > --- a/cxl/lib/libcxl.c
> > > +++ b/cxl/lib/libcxl.c
> > > @@ -1028,6 +1028,42 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev,
> > >         return cmd;
> > >  }
> > >
> > > +CXL_EXPORT struct cxl_cmd *cxl_cmd_new_read_label(struct cxl_memdev *memdev,
> > > +               unsigned int offset, unsigned int length)
> > > +{
> > > +       struct cxl_cmd_get_lsa_in *get_lsa;
> > > +       struct cxl_cmd *cmd;
> > > +
> > > +       cmd = cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_GET_LSA);
> > > +       if (!cmd)
> > > +               return NULL;
> > > +
> > > +       get_lsa = (void *)cmd->send_cmd->in.payload;
> >
> > Any reason that @payload is not already a 'void *' to avoid this casting?
>
> The send_cmd is part of the uapi which defined it as __u64.

Ah, got it.
