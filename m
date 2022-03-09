Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5B15107
	for <nvdimm@lists.linux.dev>; Wed,  9 Mar 2022 19:59:24 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id mm23-20020a17090b359700b001bfceefd8c6so39012pjb.3
        for <nvdimm@lists.linux.dev>; Wed, 09 Mar 2022 11:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qY0faMoU6BxNREoouDEmmFkWjqNRWbbfGDDwPhgFlaA=;
        b=ivyOe9HAmFp+PudsjkLZ5tKnlEZ4emhasp+yGMoOTg2U2ZJIqZkPIaXk1sql1I9WK/
         nUQOffCU0ssrR/N1lWHZbUwROdhkUx1NUNSBwt2M8X/x7LR6luljUNwitO9CtXykihEV
         7kMFECvdyoBIRJtwymkhM3klne+juuikdSIPpr4gNHAkjhB3bjU74tx0mu7aEZVFWwbD
         84UlWp9k042Z8eHBdTXX0QlWCXBn+wKUPfpEmZeHi+kLP8NdiYFPshaM0E0/HqMx5RqT
         ep+KpE+k3C30Da7hHMeIZR2O29RGOwYnk4gzbgAodkdGpUcAefZkLPIMO8V8FjE+ryc6
         PukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qY0faMoU6BxNREoouDEmmFkWjqNRWbbfGDDwPhgFlaA=;
        b=1Se7nksrNCEtIa4MF0NLs7vtwe4OiETbLmPQValDUhQA+/gxRW1gt95ynuYFWviQOz
         rRfBxDHc8m0qDt60+2S9KV8xtTrd1iYaaTJMlDbKeYS+/T9SNO2z9ywXwgt6a0wjnT6S
         XlYf/iK5qNvHrNdIg8aeuSQ9JvbbkS5334oERan2itDiPEvAnVtH0UR8IDJFW/shl55P
         z4ZVdeWEUTvTNcB952HQVz044c0UjDkWzsAMHt3YamVlqoHO1nTXIUlIHFzO5cAT+wqg
         jBE7w+7QhfP8lvXgeKfb+qyIZTOQ3ATVHF1sdMTr2BAnO+x39g4B4q+eEHGJNTy1qWsJ
         zZqA==
X-Gm-Message-State: AOAM531mCZNT3YF6JHB4YEn3BTsJRNDfHdDSlWrRY2VjRd7nzfToLbCI
	PmvUUoJoBsU8tumMxoliU411sL3+ed9c9JkHiY6P4g==
X-Google-Smtp-Source: ABdhPJyybkU4/zl86lxMdAicFm/HAASMobJ7TCzsCf62cS4iwKaWjXHvqPPPTaNM0MIrxlS5E1MmhGpaOR/XFMKMpRw=
X-Received: by 2002:a17:903:32d1:b0:151:da5c:60ae with SMTP id
 i17-20020a17090332d100b00151da5c60aemr1327115plr.34.1646855964287; Wed, 09
 Mar 2022 11:59:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164610292916.2682974.12924748003366352335.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164610295187.2682974.18123746840987009597.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220309182650.00006b28@Huawei.com>
In-Reply-To: <20220309182650.00006b28@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Mar 2022 11:59:13 -0800
Message-ID: <CAPcyv4iw+7WzAWykbsF+4pv9a8p0G8c6Bw5fk-JGfLZQX=susQ@mail.gmail.com>
Subject: Re: [PATCH 04/11] cxl/core: Clamp max lock_class
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, 
	Rafael J Wysocki <rafael.j.wysocki@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Ben Widawsky <ben.widawsky@intel.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-cxl@vger.kernel.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 9, 2022 at 10:27 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Mon, 28 Feb 2022 18:49:11 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > MAX_LOCKDEP_SUBCLASSES limits the depth of the CXL topology that can be
> > validated by lockdep. Given that the cxl_test topology is already at
> > this limit collapse some of the levels and clamp the max depth.
> >
> > Cc: Alison Schofield <alison.schofield@intel.com>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Cc: Ira Weiny <ira.weiny@intel.com>
> > Cc: Ben Widawsky <ben.widawsky@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/cxl/cxl.h |   21 +++++++++++++++++----
> >  1 file changed, 17 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > index 97e6ca7e4940..1357a245037d 100644
> > --- a/drivers/cxl/cxl.h
> > +++ b/drivers/cxl/cxl.h
> > @@ -501,20 +501,33 @@ enum cxl_lock_class {
> >       CXL_ANON_LOCK,
> >       CXL_NVDIMM_LOCK,
> >       CXL_NVDIMM_BRIDGE_LOCK,
>
> I'd be tempted to give explicit value to the one above as well
> so it's immediate clear there is deliberate duplication here.

Sounds good.

I also notice that clamp_lock_class() should return -1 when it wants
to disable validation, not zero.
