Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395B12F28
	for <nvdimm@lists.linux.dev>; Fri,  4 Feb 2022 04:26:11 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id x3so4128414pll.3
        for <nvdimm@lists.linux.dev>; Thu, 03 Feb 2022 20:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qNO8XI0s2IJe0dOG++UNZPM+4qBVHP9LahgM133K508=;
        b=F33tz2gW5xc+H/zo8drJNNoYOl5wWG4oYZOYKPKkqoLlCV1LTAXK4I8i1rhkUFhPg3
         xNdeuMQ2fsuPezb1NVm8BKn1Q77zsjqYWno0IO+aiwcEEsJ6P5JSKpxw9kx1LnYLlIu7
         mPeJEDe92aWYyHKc4YTNwg3u95JrARl3C06DMHUVckI7XOFgaozT7feSDOK4ueMvdzwt
         Q8mbO8ci6SzLV5c5wRfUFRBVfmnc+gMI9oeSV8kH8yaZI1z+ZKYA7gOvU9GN0UfTKcMU
         b9Uzzu2Bp4292NQnk7W03v9cxnHcebhdYINglNfaeeQkftzTGvGIcwnvkz9zOW/lbrGO
         TCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qNO8XI0s2IJe0dOG++UNZPM+4qBVHP9LahgM133K508=;
        b=DHbil8wd+WchFXFmVyY4azziYJM6AbvJkwMr5/qnNcPV1NjAc9rr7yIY0ZKD99NjrM
         ENwymBiSYrrNO80giOp9C638x3Si5hmYe8W8/iVRdIYWzEd2t8cN3sZl289rZJLcVdvU
         KnKYt7+U1wcMxIt+sJvBIae2UODnCapMBuRGFB6RZAPiqwuySF11ne10ul00HrbGMaUu
         Pt32bfmTOh7mZ1Iv2PlmpIrwWOKuTwqC+aj5Dza9I15wST1KTFinz0iL5DMP++tw2BT5
         DHMrkW3w21IZYWVcRfKrXUK6x/i/NvtXy+6zgsBw/wd60iOURdADEomB3UlZWWjqzTHB
         e/4A==
X-Gm-Message-State: AOAM530oN3Sbf0FVmjbGglJU09lqtWabYQ+vnbc0rEdpJoNq1PnNtnKh
	6EMeWFGgtH84mR0U0nR152WwyDB5xZ9QGT0yqAbMqQ==
X-Google-Smtp-Source: ABdhPJwqyG+G+9GgrIrs1fMv3a+GqhlWXZ0SovqqjLooA08PQJQWr7FqJSewXVV+gWYIby0fPFo2Z9M/9sb26O8QRtw=
X-Received: by 2002:a17:902:bcca:: with SMTP id o10mr1350771pls.147.1643948770583;
 Thu, 03 Feb 2022 20:26:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298428430.3018233.16409089892707993289.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220131184126.00002a47@Huawei.com> <CAPcyv4iYpj7MH4kKMP57ouHb85GffEmhXPupq5i1mwJwzFXr0w@mail.gmail.com>
 <20220202094437.00003c03@Huawei.com> <CAPcyv4hwdMetDJ-+yL9-2rY92g2C4wWPqpRiQULaX_M6ZQPMtA@mail.gmail.com>
 <20220203094123.000049e6@Huawei.com> <CAPcyv4gJozea7aDg+KyKdwEbSO5PV-rUUGC5u-6NNTHA755etA@mail.gmail.com>
 <20220203180532.00007083@Huawei.com>
In-Reply-To: <20220203180532.00007083@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 Feb 2022 20:25:58 -0800
Message-ID: <CAPcyv4hDLVye0UGPchHP__n+_hdNL1ZFqPawcz47hoOePBuggA@mail.gmail.com>
Subject: Re: [PATCH v3 31/40] cxl/memdev: Add numa_node attribute
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 3, 2022 at 10:15 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Thu, 3 Feb 2022 08:59:44 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > On Thu, Feb 3, 2022 at 1:41 AM Jonathan Cameron
> > <Jonathan.Cameron@huawei.com> wrote:
> > >
> > > On Wed, 2 Feb 2022 07:44:37 -0800
> > > Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > > On Wed, Feb 2, 2022 at 1:45 AM Jonathan Cameron
> > > > <Jonathan.Cameron@huawei.com> wrote:
> > > > >
> > > > > On Tue, 1 Feb 2022 15:57:10 -0800
> > > > > Dan Williams <dan.j.williams@intel.com> wrote:
> > > > >
> > > > > > On Mon, Jan 31, 2022 at 10:41 AM Jonathan Cameron
> > > > > > <Jonathan.Cameron@huawei.com> wrote:
> > > > > > >
> > > > > > > On Sun, 23 Jan 2022 16:31:24 -0800
> > > > > > > Dan Williams <dan.j.williams@intel.com> wrote:
> > > > > > >
> > > > > > > > While CXL memory targets will have their own memory target node,
> > > > > > > > individual memory devices may be affinitized like other PCI devices.
> > > > > > > > Emit that attribute for memdevs.
> > > > > > > >
> > > > > > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > > > >
> > > > > > > Hmm. Is this just duplicating what we can get from
> > > > > > > the PCI device?  It feels a bit like overkill to have it here
> > > > > > > as well.
> > > > > >
> > > > > > Not all cxl_memdevs are associated with PCI devices.
> > > > >
> > > > > Platform devices have numa nodes too...
> > > >
> > > > So what's the harm in having a numa_node attribute local to the memdev?
> > > >
> > >
> > > I'm not really against, it just wanted to raise the question of
> > > whether we want these to go further than the granularity at which
> > > numa nodes can be assigned.
> >
> > What is the "granularity at which numa nodes can be assigned"? It
> > sounds like you are referencing a standard / document, so maybe I
> > missed something. Certainly Proximity Domains != Linux NUMA nodes so
> > it's not ACPI.
>
> Sure, it's the fusion of a number of possible sources, one of which
> is ACPI. If there is a reason why it differs to the parent device
> (which can be ACPI, or can just be from a bunch of other places which
> I'm sure will keep growing) then it definitely makes sense to expose
> it at that level.
>
> >
> > >  Right now that at platform_device or
> > > PCI EP (from ACPI anyway).  Sure the value might come from higher
> > > up a hierarchy but at least in theory it can be assigned to
> > > individual devices.
> > >
> > > This is pushing that description beyond that point so is worth discussing.
> >
> > To me, any device that presents a driver interface can declare its CPU
> > affinity with a numa_node leaf attribute. Once you start walking the
> > device tree to infer the node from parent information you also need to
> > be worried about whether the Linux device topology follows the NUMA
> > topology. The leaf attribute removes that ambiguity.
> I'll go with 'maybe'...
>
> Either way I'm fine with this change, just wanted to bring attention to
> the duplication as it wasn't totally clear to me it was a good idea.

If the bar to upstream something was when it was totally clear it was
a good idea... I'd have a lot less patches to send.

>
> FWIW
>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Appreciate the discussion.
