Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207B72FAF
	for <nvdimm@lists.linux.dev>; Tue, 14 Sep 2021 18:08:12 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id y17so13096218pfl.13
        for <nvdimm@lists.linux.dev>; Tue, 14 Sep 2021 11:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k9PxsZ21TMFgLLF0L2gUpvlI6cDD53wFPAgaLTB+XZk=;
        b=EtkYdovPkUAqBGYBMV/7mIUMYafZXKV7FFOx1Eo9T+DNZllqQcM08/9Aa9D2ZXNf4l
         w1kdtl2GAzyR3vvt31PqwgQUOJDy4Jw9RBfcvx1te46XTc/5spuoa++/T9u/svVYyXxQ
         UEE8iSjREUmHg9xaeOsO6xyKCzMCPzJzTwZK8ePPy2hVDcZqBRzVH1gg4GJHJ3xNUgMk
         vAa97L+zRbLTFfkS978BjQpdrjSsUKvxf7bEvntsaBpTLIUAmCrayWh1f42LTdjyqrEU
         YBtZXxChI9S8b2nlWi6zdLlo31IRr61jMeqfvanbtSO+oJ7xTTmgN8DdaNP9HDun4LLv
         3dQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k9PxsZ21TMFgLLF0L2gUpvlI6cDD53wFPAgaLTB+XZk=;
        b=IN/KYVBBzgnKkv/4TIRFBQ9kCKoXYEhmKchalJJMFQIF2Bzvlf1JEE3TayVI5N6/6Z
         EnRhTf4HQ+hg0pgKexKDAXnF7bUQT7LKYgG1mEyDFraLRFUsYLol1zUPZ04gQi4a4iXR
         kZQxyq3s/5wRd5iSQZ0ZNUanNWyh1IV5yRwaz9FqJcEwG/fMjEuKaMK7rXkN/Pa3BxLe
         6iK7Gl67U4LjcxFzqER57jtfO3KdWRxJf7J03oF7QZDCPdLD1YuGJ5FhKK/fWnk9C6zT
         QRoOnzlzhB2U678ILC8OOSbVVyPtTCc94pbuubCnDf3o5QuJiICmh9TyU2Wm8GAfRa6n
         s3VA==
X-Gm-Message-State: AOAM531fYcwOvT+mOLJKvarY4pw15jar8Erg1ui7p2k8+1hqM2f3AABM
	yMOHFMz5N/zxt/l6D7/i4eV4OyCG2xiasrDyE3wtzA==
X-Google-Smtp-Source: ABdhPJz9mG8P5EDTOy6LB4Hv2QFcJ1IJlbWwfVxK+eJw0erAqDCKYWGO8EbEz+7URLfC8VOWJDtNCjSo042FDpVoonc=
X-Received: by 2002:a62:6d07:0:b0:40a:33cd:d3ea with SMTP id
 i7-20020a626d07000000b0040a33cdd3eamr5883336pfc.61.1631642891548; Tue, 14 Sep
 2021 11:08:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YT8n+ae3lBQjqoDs@zn.tnic>
In-Reply-To: <YT8n+ae3lBQjqoDs@zn.tnic>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 14 Sep 2021 11:08:00 -0700
Message-ID: <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Borislav Petkov <bp@alien8.de>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Jane Chu <jane.chu@oracle.com>, 
	Luis Chamberlain <mcgrof@suse.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 13, 2021 at 3:29 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Tue, Jul 06, 2021 at 06:01:05PM -0700, Dan Williams wrote:
> > When poison is discovered and triggers memory_failure() the physical
> > page is unmapped from all process address space. However, it is not
> > unmapped from kernel address space. Unlike a typical memory page that
> > can be retired from use in the page allocator and marked 'not present',
> > pmem needs to remain accessible given it can not be physically remapped
> > or retired.
>
> I'm surely missing something obvious but why does it need to remain
> accessible? Spell it out please.

Sure, I should probably include this following note in all patches
touching the DAX-memory_failure() path, because it is a frequently
asked question. The tl;dr is:

Typical memory_failure() does not assume the physical page can be
recovered and put back into circulation, PMEM memory_failure() allows
for recovery of the page.

The longer description is:
Typical memory_failure() for anonymous, or page-cache pages, has the
flexibility to invalidate bad pages and trigger any users to request a
new page from the page allocator to replace the quarantined one. DAX
removes that flexibility. The page is a handle for a fixed storage
location, i.e. no mechanism to remap a physical page to a different
logical address. Software expects to be able to repair an error in
PMEM by reading around the poisoned cache lines and writing zeros,
fallocate(...FALLOC_FL_PUNCH_HOLE...), to overwrite poison. The page
needs to remain accessible to enable recovery.

>
> > set_memory_uc() tries to maintain consistent nominal memtype
> > mappings for a given pfn, but memory_failure() is an exceptional
> > condition.
>
> That's not clear to me too. So looking at the failure:
>
> [10683.426147] x86/PAT: fsdax_poison_v1:5018 conflicting memory types 1850600000-1850601000  uncached-minus<->write-back
>
> set_memory_uc() marked it UC- but something? wants it to be WB. Why?

PMEM is mapped WB at the beginning of time for nominal operation.
track_pfn_remap() records that driver setting and forwards it to any
track_pfn_insert() of the same pfn, i.e. this is how DAX mappings
inherit the WB cache mode. memory_failure() wants to arrange avoidance
speculative consumption of poison, set_memory_uc() checks with the
track_pfn_remap() setting, but we know this is an exceptional
condition and it is ok to force it UC against the typical memtype
expectation.

> I guess I need some more info on the whole memory offlining for pmem and
> why that should be done differently than with normal memory.

Short answer, PMEM never goes "offline" because it was never "online"
in the first place. Where "online" in this context is specifically
referring to pfns that are under the watchful eye of the core-mm page
allocator.
