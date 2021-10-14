Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BF129CA
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 22:45:43 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id 66so6832438pgc.9
        for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 15:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BpiXG1Yl0ThCLgVz+F0jOoMh/5lNAaOmGG+RbsQZLSc=;
        b=MfoH1/ifaw+6wvCrMF4O5wCotwtpyE9bkjv0KFgCxM9eVFR2UHt7t1ks9/BK4sh/oe
         Zy8t1jc4VqM0EWYCuWGVsW0mlyvVRWourQInL4M2uTZwSaywmSUWHK56Uvv9C50G6AYI
         fxJdM5q6UnGji7TERwiIn4Um7nh7HqHhkME3miDDTGX1EZePhpjGE67JldiMTxVHa77G
         gFpyWTwAejFigmSNCQiO0LPjpdl7VX9cWQ7/Hbi8ac3LdJkBIpJqq0Fd0JplUoYOhDi9
         moUs2ZkTAMH2ZAukZTaJI0Cusjbs36IJUtNH5rfOZE+ZavWMW9HE7uR4ddVpx0/uyYVb
         JEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BpiXG1Yl0ThCLgVz+F0jOoMh/5lNAaOmGG+RbsQZLSc=;
        b=fVN5NPGJ9BAjIvwWOy3F7MhYp0K9mIGOHIqfq6JnS1FNNNqO+31ckZTkL+1MdiSr5T
         Acrc03pdQDvkgmK5VJ9+ddLEFez7VFPBhXvayB13CZwb0/4RNZ0FLzcCcuRcxYrzuHWc
         jCJcdsclYVtgfHJgpZipZqoArpYdR6ZlO21f38fawAaYxLNmS1bTrB7H4+vwNbvEVIr4
         1OwsjIhDKybxfaDih+qcaIgJkOxgFexm9VTwZWUdyc/U3bj7cbc+PvYGvmM4uEEVMN5V
         gCETz0P701WG2dtRk6FFB5AOzRY2eeCSGOTxITsB+qeAHM4XUqhb6KUnBZSPPXJ1+nrV
         tNQA==
X-Gm-Message-State: AOAM532oIev9A0tWtZqIEsWeuv2vG2QjLu9/Zd5toMUlXpHOjuhO5stJ
	tKkUrTOa7/of/lThtS7RFPkr//yU+EAgb+rMDvV9Tw==
X-Google-Smtp-Source: ABdhPJxEWCZAmSI63PU1P62Yhzt4TaQZl1QPxVezai1VO1FI0Gtcu3LKSlZGQCDetWEA91ivAKroX+TdthBatDUJ1tM=
X-Received: by 2002:a05:6a00:140e:b0:444:b077:51ef with SMTP id
 l14-20020a056a00140e00b00444b07751efmr7592708pfu.61.1634251542563; Thu, 14
 Oct 2021 15:45:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
 <20211007082139.3088615-13-vishal.l.verma@intel.com> <CAPcyv4h49Cei27qLAL8oUmcpa=Su_VArrAEzGwt3VSbpCoxYTw@mail.gmail.com>
 <6637d78d46c03296b7c31452becbeed6236a8c83.camel@intel.com>
In-Reply-To: <6637d78d46c03296b7c31452becbeed6236a8c83.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Oct 2021 15:45:32 -0700
Message-ID: <CAPcyv4iqdcyAs_vv8Vtg5iC5OSuJEP6zbTjtZKV7o3K6M6iiUA@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 12/17] libcxl: add interfaces for label operations
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Widawsky, Ben" <ben.widawsky@intel.com>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 14, 2021 at 3:25 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Thu, 2021-10-14 at 14:27 -0700, Dan Williams wrote:
> > On Thu, Oct 7, 2021 at 1:22 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
> >
>
> [..]
>
> > > +
> > > +CXL_EXPORT struct cxl_cmd *cxl_cmd_new_write_label(struct cxl_memdev *memdev,
> > > +               void *lsa_buf, unsigned int offset, unsigned int length)
> > > +{
> > > +       struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> > > +       struct cxl_cmd_set_lsa *set_lsa;
> > > +       struct cxl_cmd *cmd;
> > > +       int rc;
> > > +
> > > +       cmd = cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_SET_LSA);
> > > +       if (!cmd)
> > > +               return NULL;
> > > +
> > > +       /* this will allocate 'in.payload' */
> > > +       rc = cxl_cmd_set_input_payload(cmd, NULL, sizeof(*set_lsa) + length);
> > > +       if (rc) {
> > > +               err(ctx, "%s: cmd setup failed: %s\n",
> > > +                       cxl_memdev_get_devname(memdev), strerror(-rc));
> > > +               goto out_fail;
> > > +       }
> > > +       set_lsa = (void *)cmd->send_cmd->in.payload;
> >
> > ...the cast is still nagging at me especially when this knows what the
> > payload is supposed to be. What about a helper per command type of the
> > form:
> >
> > struct cxl_cmd_$name *to_cxl_cmd_$name(struct cxl_cmd *cmd)
> > {
> >     if (cmd->send_cmd->id != CXL_MEM_COMMAND_ID_$NAME)
> >         return NULL;
> >     return (struct cxl_cmd_$name *) cmd->send_cmd->in.payload;
> > }
> >
> Is the nag just from using a void cast, or having to cast at all? I
> think the void cast was just laziness - it should be cast to
> (struct cxl_cmd_$name *) instead of (void *).

I'd feel better about that to have one explicit cast, then an explicit
'void *' cast just to get default implicit cast behavior.

>
> Having a helper for to_cxl_cmd_$name() does look cleaner, but do we
> need the validation step there? In all these cases, the cmd would've
> been allocated just a few lines above, with cxl_cmd_new_generic(memdev,
> CXL_MEM_COMMAND_ID_$NAME) - so it seems unnecessary?

Yeah, if there's never any other users of it outside of the
'cxl_cmd_new_$name' then the validation and even the helper are
unnecessary if you do the strict type conversion.
