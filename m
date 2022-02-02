Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BB82F29
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 15:44:50 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id v15-20020a17090a4ecf00b001b82db48754so2152309pjl.2
        for <nvdimm@lists.linux.dev>; Wed, 02 Feb 2022 07:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nGLMWM6Y1bKurzXYC7D1UpkKTONcroCJv+sUS8+G3fk=;
        b=oAsuNoeuBakCdBEHynR3D8MON2hWZXsKI9XI297BBNUhha9c5YL8xp0RCdMb8JU+/k
         ieW+QU4GNQqS6tdyJcoU27SbO29Y0ANPws4KLSzMa/M3CSP8C0wZKBwczBLLw3gPnNAN
         Gl6cZyMGNMFWjboPOPGFZtz1LNlSqjmBOf55RkOfHZzI36rRUBekQHNylrwPdS6ljBg+
         fjpSn/M8F31lQorK+FtiHoJjVSPDQ6eewGwlZPXsUljURYxNzEbTZ1uLwVx57muEeyIY
         7mUbwW6n+qnN0pxVKKhvuFbQWfS1lylV5SAQJt8d1EDFzucGM5+CwnURCeX0Ni+iUl60
         4WzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nGLMWM6Y1bKurzXYC7D1UpkKTONcroCJv+sUS8+G3fk=;
        b=cShcLVkz3EpUY5LW6DxxxStn4l3SBPlR8m4Cs1kFCd0g4LNNj7esU75ccEEkni6Rsu
         9DISYhZz6krqzqIJvSwxnrt7x/vc6kS1TgLP+bMHL8UwR1/El1WJkwo5R2wffH97k8lN
         /53WuoA3zA/iXc0UMMFNIDn6lZtRLm5dbyEyqgzpq4Kun84I87TuuzY1UlCTbDKdiqyS
         sR1P/jc4o7nC1zqTJrZqO7RopJ00cz9MzkiX8RgCax9rBFYtXoQnMHqxKp4SNZUAFTjU
         smOziOH5lCJ5G/X2mcaExxZWF7BV4RDoWPNQwFqati9qY5Q636hTnqf5R9U02yAJLdwd
         blxQ==
X-Gm-Message-State: AOAM531ftJKbohJ7Pt6+I/Q4SNpDzBE514SlM43ES6qcZC+DOL9R9TPl
	bSWBwtfxfR+ja2XKvm362wAedhlbAcGUZCvHCk8UwQ==
X-Google-Smtp-Source: ABdhPJyfNfM+gsqWl5W1Qo2NaPXgRGSdgmEDd2DqFNA9P0isGwV8K8W3Z3JrGGkyrmxZ/kz8+YCi0/483ncGEhKz54Y=
X-Received: by 2002:a17:902:7c15:: with SMTP id x21mr31615433pll.147.1643816689833;
 Wed, 02 Feb 2022 07:44:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298428430.3018233.16409089892707993289.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220131184126.00002a47@Huawei.com> <CAPcyv4iYpj7MH4kKMP57ouHb85GffEmhXPupq5i1mwJwzFXr0w@mail.gmail.com>
 <20220202094437.00003c03@Huawei.com>
In-Reply-To: <20220202094437.00003c03@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 2 Feb 2022 07:44:37 -0800
Message-ID: <CAPcyv4hwdMetDJ-+yL9-2rY92g2C4wWPqpRiQULaX_M6ZQPMtA@mail.gmail.com>
Subject: Re: [PATCH v3 31/40] cxl/memdev: Add numa_node attribute
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 2, 2022 at 1:45 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Tue, 1 Feb 2022 15:57:10 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > On Mon, Jan 31, 2022 at 10:41 AM Jonathan Cameron
> > <Jonathan.Cameron@huawei.com> wrote:
> > >
> > > On Sun, 23 Jan 2022 16:31:24 -0800
> > > Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > > While CXL memory targets will have their own memory target node,
> > > > individual memory devices may be affinitized like other PCI devices.
> > > > Emit that attribute for memdevs.
> > > >
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > >
> > > Hmm. Is this just duplicating what we can get from
> > > the PCI device?  It feels a bit like overkill to have it here
> > > as well.
> >
> > Not all cxl_memdevs are associated with PCI devices.
>
> Platform devices have numa nodes too...

So what's the harm in having a numa_node attribute local to the memdev?

Yes, userspace could carry complications like:

cat $(readlink -f /sys/bus/cxl/devices/mem0)/../numa_node

...but if you take that argument to its extreme, most "numa_node"
attributes in sysfs could be eliminated because userspace can keep
walking up the hierarchy to find the numa_node versus the kernel doing
it on behalf of userspace.
