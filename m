Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16ED318D
	for <nvdimm@lists.linux.dev>; Wed,  6 Apr 2022 01:22:59 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id j20-20020a17090ae61400b001ca9553d073so1197921pjy.5
        for <nvdimm@lists.linux.dev>; Tue, 05 Apr 2022 18:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GpAHmbeaClOABfDOq4xnFecCsaGHIekoRhkFacwUlXs=;
        b=DTGX679OZ1qKODLoERzJPs9u5x0CQ7BYYUpa2ouElTHNgAKbPpKoCPRTExB81qQ2US
         94dbMKZq/YmOeyWFp2JbpnvKA0jH4iSww8lz1A4p4C92e1wGL/hPVnaXi1g1ADkUAp6P
         RNhUno+35Z8wecDtsPPgH+m4yLNmQXPQLqx3+K7wiP9W7njPgLJqsTd3C7bY0GOn3iL4
         DU1KcaQsM6ar/F3C6nMFoc7ou3I3CvJEUZey03r8p0CmPUzHrg/bmaACtqdejQJ4iant
         V/TCZoYpa1rMEzqemePJkaBICzpAtqcCLdOPBkkwkXyPjciIJJUh7pdnmRJymCr3P0SZ
         hABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GpAHmbeaClOABfDOq4xnFecCsaGHIekoRhkFacwUlXs=;
        b=aLDMBTZiwROU96Yha0WCEuz2HyP+SRBI3DamjfELJuNTj9wd+lEAv+jfQTsUubo9bJ
         r+34NcAX5tZum0/9LVuTjS7feFx1mx0k4pel8Dea+DBcINnIReBtjef0mk+JJ/6L4WLg
         pv8QfDx+4MrvXbYyXg7H+LIwbxMEi8gWD0ChRpCrQcVSoCk4y0xVhDMI0kIZzLSg4DBk
         cMvG9wJ3rb+6WGtFj45lCRREIEPdXRBP3tpAtZOS69dHBWMhVqcL1RI1X7rQAtmjtUWu
         Qbr4Zy0u0cfhF8qoHCUbf56rf8GNxnlIFlhv6b0BlSR8eiUg7/yXVhc8o0CUDKh9jWqG
         4DHg==
X-Gm-Message-State: AOAM532c9wDrcjdOy3PTOrzRNJvPo78L1vWz/v3e2SKecM10qttARPZ9
	YiZzwSNwFUQyrU0mZt0VBWX0s/PVgHAQ3zSH0fqWyg==
X-Google-Smtp-Source: ABdhPJy2l3ev5j2Q7pkZUUiX17H1f2uX0JiaFPO6bc09C7QOxwwhFdxA05PXl7UqsyY9sLkpv+RVessbAtwzpZwLwNA=
X-Received: by 2002:a17:902:d512:b0:156:b23f:ed62 with SMTP id
 b18-20020a170902d51200b00156b23fed62mr6252643plg.147.1649208179456; Tue, 05
 Apr 2022 18:22:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220227120747.711169-1-ruansy.fnst@fujitsu.com>
 <20220227120747.711169-2-ruansy.fnst@fujitsu.com> <CAPcyv4jAqV7dZdmGcKrG=f8sYmUXaL7YCQtME6GANywncwd+zg@mail.gmail.com>
 <4fd95f0b-106f-6933-7bc6-9f0890012b53@fujitsu.com> <YkPtptNljNcJc1g/@infradead.org>
 <15a635d6-2069-2af5-15f8-1c0513487a2f@fujitsu.com> <YkQtOO/Z3SZ2Pksg@infradead.org>
 <4ed8baf7-7eb9-71e5-58ea-7c73b7e5bb73@fujitsu.com> <YkR8CUdkScEjMte2@infradead.org>
 <20220330161812.GA27649@magnolia> <fd37cde6-318a-9faf-9bff-70bb8e5d3241@oracle.com>
In-Reply-To: <fd37cde6-318a-9faf-9bff-70bb8e5d3241@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 5 Apr 2022 18:22:48 -0700
Message-ID: <CAPcyv4gqBmGCQM_u40cR6GVror6NjhxV5Xd7pdHedE2kHwueoQ@mail.gmail.com>
Subject: Re: [PATCH v11 1/8] dax: Introduce holder for dax_device
To: Jane Chu <jane.chu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, david <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 5, 2022 at 5:55 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 3/30/2022 9:18 AM, Darrick J. Wong wrote:
> > On Wed, Mar 30, 2022 at 08:49:29AM -0700, Christoph Hellwig wrote:
> >> On Wed, Mar 30, 2022 at 06:58:21PM +0800, Shiyang Ruan wrote:
> >>> As the code I pasted before, pmem driver will subtract its ->data_offset,
> >>> which is byte-based. And the filesystem who implements ->notify_failure()
> >>> will calculate the offset in unit of byte again.
> >>>
> >>> So, leave its function signature byte-based, to avoid repeated conversions.
> >>
> >> I'm actually fine either way, so I'll wait for Dan to comment.
> >
> > FWIW I'd convinced myself that the reason for using byte units is to
> > make it possible to reduce the pmem failure blast radius to subpage
> > units... but then I've also been distracted for months. :/
> >
>
> Yes, thanks Darrick!  I recall that.
> Maybe just add a comment about why byte unit is used?

I think we start with page failure notification and then figure out
how to get finer grained through the dax interface in follow-on
changes. Otherwise, for finer grained error handling support,
memory_failure() would also need to be converted to stop upcasting
cache-line granularity to page granularity failures. The native MCE
notification communicates a 'struct mce' that can be in terms of
sub-page bytes, but the memory management implications are all page
based. I assume the FS implications are all FS-block-size based?
