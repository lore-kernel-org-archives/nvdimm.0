Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D07F2CA5
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 01:24:53 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso868180pjm.4
        for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 17:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/dGCfVhT++w2Hx6ftbIxEvafxuyl5d8bN85+m8dx7Do=;
        b=ALizp1nMToyERVLAdtQUpuvW9hHW54sIRjRqkGkxl7slbPNJWO9kWHV2rJarN+LcUF
         kHYDpxCO543iNRyFf3PSnmM+bQ78hurdlNhyyj/4LSTLBX0pSe5ShFbaX+P7HbQMIBQl
         jXbMLQUWynkgxd39dfuiJRZ6n9SJRYPTJLwE4JNNA6fXc90IRQXfBVXKGFYehiZJuo8l
         MVhLYnqOtBcY51vBN37vLClOmiuGNW++hEHetc5jBzGUSERAqsVU0UKjytKQAf8Ktz1U
         9s6oIivd15l5jO1HTW8HYy3J8WaWULPGsDALKE9nvhrPWACZS3yy2ktI0dcwktsjx/0Q
         lcjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/dGCfVhT++w2Hx6ftbIxEvafxuyl5d8bN85+m8dx7Do=;
        b=TcfD4OC14II5UTzZkcumbWV4KiwN5ARwUjRDSyU51R3L6BfiBul53IvtqQr1m4M7+6
         BbPZ+YMKklPVyxe69buW8rtjye7roKYVwaqaBMTyJYI+RA/0qZzS3bQhMPNprwFMc/1r
         MvEtLeL2T9J+bUxuy/Cvwp9RKAH+W+DHOjDVNilgnwbCBP+RMmO9KjPJNXT4djtvBZGO
         7I8GA227f1bMm9d/BWN9CU9vOqBWAIOc0FKllR8cIXuiTGXQBI0JEPW+bH5zb9/a1pbA
         Cyl2Wy4DghHn4ASuvLFcbO6lE10udoJD5oT0yJtOdOloQ9IPVIanpPBNo8qXhbor8bmQ
         /SBQ==
X-Gm-Message-State: AOAM533BXRaYiNoGNa8ZxUKSe+zLlzfH6P2eq949uniyEOp6TlF1Qbpc
	W1lExV1Aj1A+HbP4UVQXtsPgVTIGzK48RdCbghWr3w==
X-Google-Smtp-Source: ABdhPJxe/2hpc7fujLSVasJiSX0gGlYlsr511Vqqs9RbMsZiRIzL79paSdVBIbTKCeel09/v3Hse5yDJDcAZ2piVT/I=
X-Received: by 2002:a17:902:7c15:: with SMTP id x21mr23855697pll.147.1643678693035;
 Mon, 31 Jan 2022 17:24:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1642535478.git.alison.schofield@intel.com>
 <e98fa18538c42c40b120d5c22da655d199d0329d.1642535478.git.alison.schofield@intel.com>
 <CAPcyv4j4Nq1AAxH2CybQCH3pcBpCWgCsnY5i=OfKQXd_C_3xWA@mail.gmail.com> <20220127205009.GA894403@alison-desk>
In-Reply-To: <20220127205009.GA894403@alison-desk>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 31 Jan 2022 17:24:45 -0800
Message-ID: <CAPcyv4h5+sMSKh-seNbmmTVuNzs5-8FTWUoYHw=LWtSrSNq1=g@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 5/6] libcxl: add interfaces for
 SET_PARTITION_INFO mailbox command
To: Alison Schofield <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 12:46 PM Alison Schofield
<alison.schofield@intel.com> wrote:
>
> Hi Dan,
> Thanks for the review. I'm still working thru this, but a clarifying
> question below...
>
> On Wed, Jan 26, 2022 at 03:41:14PM -0800, Dan Williams wrote:
> > On Tue, Jan 18, 2022 at 12:20 PM <alison.schofield@intel.com> wrote:
> > >
> > > From: Alison Schofield <alison.schofield@intel.com>
> > >
> > > Users may want the ability to change the partition layout of a CXL
> > > memory device.
> > >
> > > Add interfaces to libcxl to allocate and send a SET_PARTITION_INFO
> > > mailbox as defined in the CXL 2.0 specification.
> > >
> > > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > > ---
> > >  cxl/lib/libcxl.c   | 50 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  cxl/lib/libcxl.sym |  5 +++++
> > >  cxl/lib/private.h  |  8 ++++++++
> > >  cxl/libcxl.h       |  5 +++++
> > >  4 files changed, 68 insertions(+)
> > >
> snip
> >
> >
> > I don't understand what this is for?
> >
> > Let's back up. In order to future proof against spec changes, and
> > endianness, struct packing and all other weird things that make struct
> > ABIs hard to maintain compatibility the ndctl project adopts the
> > libabc template of just not letting library consumers see any raw data
> > structures or bit fields by default [1]. For a situation like this
> > since the command only has one flag that affects the mode of operation
> > I would just go ahead and define an enum for that explicitly.
> >
> > enum cxl_setpartition_mode {
> >     CXL_SETPART_NONE,
> >     CXL_SETPART_NEXTBOOT,
> >     CXL_SETPART_IMMEDIATE,
> > };
> >
> > Then the main function prototype becomes:
> >
> > int cxl_cmd_new_setpartition(struct cxl_memdev *memdev, unsigned long
> > long volatile_capacity);
> >
> > ...with a new:
> >
> > int cxl_cmd_setpartition_set_mode(struct cxl_cmd *cmd, enum
> > cxl_setpartition_mode mode);
> >
>
> I don't understand setting of the mode separately. Can it be:
>
> int cxl_cmd_new_setpartition(struct cxl_memdev *memdev,
>                              unsigned long long volatile_capacity,
>                              enum cxl_setpartition_mode mode);

It could be, but what happens when the specification defines a new
flag for this command? Then we would have cxl_cmd_new_setpartition()
and cxl_cmd_new_setpartition2()  to add the new parameters. A helper
function after establishing the cxl_cmd context lets you have
flexibility to extend the base command by as many new flags and modes
that come along... hopefully none, but you never know.
