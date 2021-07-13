Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0167472
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 21:39:56 +0000 (UTC)
Received: by mail-ot1-f49.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so422517otl.0
        for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 14:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J8KTx2Ose4pii2svCA/w8VRn4cl8pFgHnIkh+CmYJ2c=;
        b=LhD8xrWH6oVe/XomegABvQ+eubfFC84EkZ5vxhsOUQYHmsiHTpAYBPi2HaYGZftdul
         iwc0Nt0gmZSe0jCxTt9a1nS8VrYWL6EKZ0keGDuY+jCOWucD9thXM3tdNc7v43c/+UiZ
         zixzPECfFeyFEKe4PoBkHgTyW+XTnBiMr86PlkPem5R4XBXKcWTQC/zEECHRTVoaDDfB
         z55n+AJ2rBrt+aKwpn6CAlZBOSUZ2qS6mO0m5feAcfbp24S/XDySFnFykQWjAVQp/vCM
         Nx+n3kCkJBaqW8tEvmMYGiLGkAYVOt8vuD6V54WEF70Ieb+6vkwWCOMHhkLHsv3sE1h/
         oTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J8KTx2Ose4pii2svCA/w8VRn4cl8pFgHnIkh+CmYJ2c=;
        b=ny3fxmUHyLBgTNRaDnT4kxMKo/AOUpqveFEGsy/prT7csc0rp7CdNCvbQMwmhiRT0B
         Piw6I2y656TX6wsPDNF5low8VFRspUXIa4fjrXv1rB+EBSEvku8b3KTZ0g11iaBMU60W
         mDkSc47AZxgBnmoTHv+sDIQp+WlHFssBFhr+aprRqAjQYNJaR5Lq0AuBi0+nvllr5j4t
         7X8B1tr42YEYGOtUgzLApYkfHAyT/xjf1a/SwOMKwgZRaYjK+yXnx3BBUUluwT0+EgYY
         VGYra63xZwtL5mZbsQC4chZ+AloKQkIw2eW/bmHZKP32kwOUU6RlbFeYxcOwAcP2iJ1O
         ukYw==
X-Gm-Message-State: AOAM531ygd9wkKqHdYiEP4Q58/J854ryBdSW3+Y298NHe5X9Nh2Nojx1
	LOq9LMbRudCPo6pb9Nq9UED3Rp1DNRnC9Ja8LIGn7Q==
X-Google-Smtp-Source: ABdhPJxBld5GnnB8xBhBT0x95VtLs5hBAuTy2WWsMchLrqn2Gwf/49bHWAk2TmcrGTERUlsC7dkwPnGsPf84Hqoyhjs=
X-Received: by 2002:a9d:8d3:: with SMTP id 77mr5328637otf.6.1626212396000;
 Tue, 13 Jul 2021 14:39:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210701201005.3065299-1-vishal.l.verma@intel.com>
 <20210701201005.3065299-5-vishal.l.verma@intel.com> <CAPcyv4iyhpSYkDKYDjWP61PaahtZrn3pGh7NnfC6jDaNbVEu+w@mail.gmail.com>
 <14151c2efffe947103b881da5bbf38212786aa59.camel@intel.com>
In-Reply-To: <14151c2efffe947103b881da5bbf38212786aa59.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Jul 2021 14:39:45 -0700
Message-ID: <CAPcyv4jpwCK5VUgpc8LBXN=ELxFLQkA7EkTENGfnYSwoHpYPfA@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 04/21] libcxl: add support for command query and submission
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Widawsky, Ben" <ben.widawsky@intel.com>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Schofield, Alison" <alison.schofield@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 13, 2021 at 2:17 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Mon, 2021-07-12 at 22:12 -0700, Dan Williams wrote:
> > On Thu, Jul 1, 2021 at 1:10 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
> > >
> > > Add a set of APIs around 'cxl_cmd' for querying the kernel for supported
> > > commands, allocating and validating command structures against the
> > > supported set, and submitting the commands.
> > >
> > > 'Query Commands' and 'Send Command' are implemented as IOCTLs in the
> > > kernel. 'Query Commands' returns information about each supported
> > > command, such as flags governing its use, or input and output payload
> > > sizes. This information is used to validate command support, as well as
> > > set up input and output buffers for command submission.
> >
> > It strikes me after reading the above that it would be useful to have
> > a cxl list option that enumerates the command support on a given
> > memdev. Basically a "query-to-json" helper.
>
> Hm, yes that makes sense..  There may not always be a 1:1 correlation
> between the commands returned by query and the actual cxl-cli command
> corresponding with that - and for some commands, there may not even be
> a cxl-cli equivalent. Do we want to create a json representation of the
> raw query data, or cxl-cli equivalents?

I was thinking it would purely be a list and association of that to
whether there is a cxl-cli helper for it is left as an exercise for
the reader. Especially when there may be commands that are upgraded
versions of existing commands and cxl-cli handles that difference in
the background.

>
> > >
> > > Cc: Ben Widawsky <ben.widawsky@intel.com>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > ---
> > >  cxl/lib/private.h  |  33 ++++
> > >  cxl/lib/libcxl.c   | 388 +++++++++++++++++++++++++++++++++++++++++++++
> > >  cxl/libcxl.h       |  11 ++
> > >  cxl/lib/libcxl.sym |  13 ++
> > >  4 files changed, 445 insertions(+)
> > >
> > [..]
> > > +static int cxl_cmd_alloc_query(struct cxl_cmd *cmd, int num_cmds)
> > > +{
> > > +       size_t size;
> > > +
> > > +       if (!cmd)
> > > +               return -EINVAL;
> > > +
> > > +       if (cmd->query_cmd != NULL)
> > > +               free(cmd->query_cmd);
> > > +
> > > +       size = sizeof(struct cxl_mem_query_commands) +
> > > +                       (num_cmds * sizeof(struct cxl_command_info));
> >
> > This is asking for the kernel's include/linux/overflow.h to be
> > imported into ndctl so that struct_size() could be used here. The file
> > is MIT licensed, just the small matter of factoring out only the MIT
> > licensed bits.
>
> Ah ok let me take a look.

I would certainly limit to just copying struct_size() for now and not
try to pull the whole header. If it turns into a larger ordeal and not
a quick copy feel free to table it for later.
