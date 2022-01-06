Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ADA2C80
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 21:21:57 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id j16so3355605pll.10
        for <nvdimm@lists.linux.dev>; Thu, 06 Jan 2022 13:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=43bguYNcabAIic4p0ZFTEKSXEEkTIRVek8KS1dujmsM=;
        b=TtIJywVxUxlo3t60j+Ks6SP2xSfOtNzItSpnF/ngb6zn/43gK0svI9qtHTAnYxPe2d
         ymAEaasqFm1py11L3clpZA5tQrXebXfgqqAf0fPECqNfELy1mbEhngdEZg5mB3Rb6cFO
         GVBHkBY3Ssk07dhltgxS8EzHbyubNEjKuScWKgqjQFwHntnsZA4Xtg7J5eErSDsApntu
         8ajJ+6y76BoUnw0aCPJGgoiRFnQw3XPPRzeoUnOAGJjnLBNSwIMt9O7AEpvMBBNOSnXl
         rc/IAu17LCYNPpZqnYGrQLb179wMWzASnI5Kjx+k3wWLEonyuJgPy+mJEucT/rUn2Z9a
         ehMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=43bguYNcabAIic4p0ZFTEKSXEEkTIRVek8KS1dujmsM=;
        b=O2rwQ4ibTz6ehUH5fyc6emLZ7jOFTOElAGDvzov6jVWrFN4BUY5Q9beM8ooQq+HhNB
         7y7LCFpnQjFptuJUHw/CXk3R/HlmcDIgFTp6l68TU4kNtgbZaC/OccPhFI4NAcSTpa0K
         F9oRv5c1ZKgacGB/LeYsRQxUtoHDbheNvCPpxTYOCWorNNX+3TZk6UKigD4ckTNS7kyu
         3sgQH5hGWn1sJorZvwq4/fGzvPDLA9i4rxVvQL+QsOYjaL8j6L87LYQeDPBpuSiIViX7
         WU6SLjrO/zIUq8oNDojbngmYpEy12eDLhD3vDX0SLrGlkjlfKmf2jcq2tsDgTxUpsCBo
         eloQ==
X-Gm-Message-State: AOAM533iw7EH+JSVdGM59j9EOhQNh7MAb/ZFku+jDjhxfRFhpKZLZjTr
	bQIUrmwld8LeYcU+s/fIVC58NfcJEgMr6p0Ap+Ck5Q==
X-Google-Smtp-Source: ABdhPJxO7FMouYy5d+vmsh0hR0mbu0I9jTvVpqc9xGGFmiPLWe/+LYfxNpIpfMV1oiY5lKfYt0qzOfndP9us22CEeUg=
X-Received: by 2002:a17:902:c94d:b0:149:16cb:22e1 with SMTP id
 i13-20020a170902c94d00b0014916cb22e1mr60103602pla.34.1641504116799; Thu, 06
 Jan 2022 13:21:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1641233076.git.alison.schofield@intel.com>
 <9d3c55cbd36efb6eabec075cc8596a6382f1f145.1641233076.git.alison.schofield@intel.com>
 <20220106201907.GA178135@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20220106201907.GA178135@iweiny-DESK2.sc.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 6 Jan 2022 13:21:45 -0800
Message-ID: <CAPcyv4h4_V+fugcbU0f_+ZJ9sALdDqAtgovoVhpjzd6cYiBHgA@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/7] libcxl: add GET_PARTITION_INFO mailbox command
 and accessors
To: "Schofield, Alison" <alison.schofield@intel.com>, Ben Widawsky <ben.widawsky@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 6, 2022 at 12:19 PM Ira Weiny <ira.weiny@intel.com> wrote:
>
> On Mon, Jan 03, 2022 at 12:16:12PM -0800, Schofield, Alison wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> >
> > Add libcxl APIs to create a new GET_PARTITION_INFO mailbox command, the
> > command output data structure (privately), and accessor APIs to return
> > the different fields in the partition info output.
>
> I would rephrase this:
>
> libcxl provides functions for C code to issue cxl mailbox commands as well as
> parse the output returned.  Get partition info should be part of this API.
>
> Add the libcxl get partition info mailbox support as well as an API to parse
> the fields of the command returned.
>
> All fields are specified in multiples of 256MB so also define a capacity
> multiplier to convert the raw data into bytes.
>
> >
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  cxl/lib/private.h  | 10 ++++++++++
> >  cxl/libcxl.h       |  5 +++++
> >  util/size.h        |  1 +
> >  cxl/lib/libcxl.c   | 41 +++++++++++++++++++++++++++++++++++++++++
> >  cxl/lib/libcxl.sym |  5 +++++
> >  5 files changed, 62 insertions(+)
> >
> > diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> > index a1b8b50..dd9234f 100644
> > --- a/cxl/lib/private.h
> > +++ b/cxl/lib/private.h
> > @@ -7,6 +7,7 @@
> >  #include <cxl/cxl_mem.h>
> >  #include <ccan/endian/endian.h>
> >  #include <ccan/short_types/short_types.h>
> > +#include <util/size.h>
> >
> >  #define CXL_EXPORT __attribute__ ((visibility("default")))
> >
> > @@ -104,6 +105,15 @@ struct cxl_cmd_get_health_info {
> >       le32 pmem_errors;
> >  } __attribute__((packed));
> >
> > +struct cxl_cmd_get_partition_info {
> > +     le64 active_volatile_cap;
> > +     le64 active_persistent_cap;
> > +     le64 next_volatile_cap;
> > +     le64 next_persistent_cap;
> > +} __attribute__((packed));
> > +
> > +#define CXL_CAPACITY_MULTIPLIER              SZ_256M
> > +
> >  /* CXL 2.0 8.2.9.5.3 Byte 0 Health Status */
> >  #define CXL_CMD_HEALTH_INFO_STATUS_MAINTENANCE_NEEDED_MASK           BIT(0)
> >  #define CXL_CMD_HEALTH_INFO_STATUS_PERFORMANCE_DEGRADED_MASK         BIT(1)
> > diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> > index 89d35ba..7cf9061 100644
> > --- a/cxl/libcxl.h
> > +++ b/cxl/libcxl.h
> > @@ -109,6 +109,11 @@ ssize_t cxl_cmd_read_label_get_payload(struct cxl_cmd *cmd, void *buf,
> >               unsigned int length);
> >  struct cxl_cmd *cxl_cmd_new_write_label(struct cxl_memdev *memdev,
> >               void *buf, unsigned int offset, unsigned int length);
> > +struct cxl_cmd *cxl_cmd_new_get_partition_info(struct cxl_memdev *memdev);
>
> why 'new'?  Why not:
>
> cxl_cmd_get_partition_info()
>
> ?

The "new" is the naming convention inherited from ndctl indicating the
allocation of a new command object. The motivation is to have a verb /
action in all of the APIs.

>
> > +unsigned long long cxl_cmd_get_partition_info_get_active_volatile_cap(struct cxl_cmd *cmd);
> > +unsigned long long cxl_cmd_get_partition_info_get_active_persistent_cap(struct cxl_cmd *cmd);
> > +unsigned long long cxl_cmd_get_partition_info_get_next_volatile_cap(struct cxl_cmd *cmd);
> > +unsigned long long cxl_cmd_get_partition_info_get_next_persistent_cap(struct cxl_cmd *cmd);
>
> These are pretty long function names.  :-/

If you think those are long, how about:

cxl_cmd_health_info_get_media_powerloss_persistence_loss

The motivation here is to keep data structure layouts hidden behind
APIs to ease the maintenance of binary compatibility from one library
release and specification release to the next. The side effect though
is some long function names in places.

> I also wonder if the conversion to bytes should be reflected in the function
> name.  Because returning 'cap' might imply to someone they are getting the raw
> data field.

Makes sense.
