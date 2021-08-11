Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A4217F
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 17:42:14 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id u15so1487390ple.2
        for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 10:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IeNL9bjLZPrc6ii1+wc5VLScUfw86O349rFJBfezm/U=;
        b=xxheOztLd5to3QQ4b3JGrhLNwLiFu3lw953AppxJjNnbNfmb0CShHtylW/M2D61atI
         NDDlwlZsLFQdzo4v79tPbwI2n5Y1e9Cl8aVn55+8bh33JijRBEuQOMJqK8PojUywpTRS
         8w0Usjpv8J1tAEK53R6Q0hnaK+NsXul+/i1pUowngyFS0LTN9NXq0r2MJNCFyV/Idxq2
         T6fEDVg/LYu9zGwLzqDOSoAO9URZw/6ZjyShVhnWF+egOl7fa9LU7X9Q8ogXER53kPIs
         IseiFodVf0g8r+diWTWoYvzFl8FqyL0wnKxXk9zI2DSfrpPdsIttSGj+oYe+XWhGAURF
         Gzsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IeNL9bjLZPrc6ii1+wc5VLScUfw86O349rFJBfezm/U=;
        b=VZlc1ONaELH8a0zjv2OhUjoX5qPjThKRtzWFoYfRJ3oE83PZVzIQxB5piiOvCzTBqP
         llR8BoPMt7uu7e8IPzHVPC2e/CVet5GzLyACPSjUH6RgyIq2Qc4y3phqSBNt3XT9M5Z8
         U1Y3kcaV9TItn0eU6WqquDd8bg5sc5Dek2XMePQXsqNM+67qs/TiE+K/8ur9jVbBpuk4
         kXVMHF+w5+NvW4r6JWObAO4mmptqgcIGLwSrCDBUGZZyucI4D8wvl+rhIQcFAeGTAoge
         AJo2RQl5K2FwbjzhTHifxYTXvdPThQ3hcs9u3peaG77OFsb/U940wLwsN04uis2W1y79
         Hm5Q==
X-Gm-Message-State: AOAM533JqCvW0jfa5/IagtPFI5RZJMB9vGbDUM2d7h6nk32dWvkkgV5M
	GpEPsep7EpnEhjQ3izX3eiWIcZkiRbePyqfZySVaGw==
X-Google-Smtp-Source: ABdhPJw0MUexdq/nOVxQIMcZ0NqIOkg9tKnb0+pvNmqBdO+XZaFDnqiLD0cE9FqIyjrX8f+Tt6WDCjRMCZnCviSX7zA=
X-Received: by 2002:a63:3c7:: with SMTP id 190mr73332pgd.240.1628703734293;
 Wed, 11 Aug 2021 10:42:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162854808363.1980150.11628345983283480967.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210811182706.00003bee@Huawei.com>
In-Reply-To: <20210811182706.00003bee@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Aug 2021 10:42:03 -0700
Message-ID: <CAPcyv4iYa2FqW0V3k+Tt=SRJCBYhe6qCkTupwveGQCmvYucjYA@mail.gmail.com>
Subject: Re: [PATCH 03/23] libnvdimm/labels: Introduce label setter helpers
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Ben Widawsky <ben.widawsky@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 11, 2021 at 10:27 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Mon, 9 Aug 2021 15:28:03 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > In preparation for LIBNVDIMM to manage labels on CXL devices deploy
> > helpers that abstract the label type from the implementation. The CXL
> > label format is mostly similar to the EFI label format with concepts /
> > fields added, like dynamic region creation and label type guids, and
> > other concepts removed like BLK-mode and interleave-set-cookie ids.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Hi Dan,
>
> Only thing on this patch is whether it might be better to put get /set pairs
> together rather than all the get functions, then all the set functions?
>
> If looking at this code in future it would make it a little easier to quickly
> see they are match pairs.

Sure, easy to do.

>
> Your code though, so if you prefer it like this, I don't really care!
>
> Fine either way with me.
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>
> > ---
> >  drivers/nvdimm/label.c          |   61 +++++++++++++++++------------------
> >  drivers/nvdimm/namespace_devs.c |    2 +
> >  drivers/nvdimm/nd.h             |   68 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 98 insertions(+), 33 deletions(-)
> >
>
> ...
>
> > diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> > index b3feaf3699f7..416846fe7818 100644
> > --- a/drivers/nvdimm/nd.h
> > +++ b/drivers/nvdimm/nd.h
> > @@ -47,6 +47,14 @@ static inline u8 *nsl_get_name(struct nvdimm_drvdata *ndd,
> >       return memcpy(name, nd_label->name, NSLABEL_NAME_LEN);
> >  }
> >
> > +static inline u8 *nsl_set_name(struct nvdimm_drvdata *ndd,
> > +                            struct nd_namespace_label *nd_label, u8 *name)
> > +{
> > +     if (!name)
> > +             return name;
>
> Nitpick: Obviously same thing, but my eyes parse
>                 return NULL;

Ok.

>
> more easily as a clear "error" return.
>
> > +     return memcpy(nd_label->name, name, NSLABEL_NAME_LEN);
> > +}
> > +
> ...
