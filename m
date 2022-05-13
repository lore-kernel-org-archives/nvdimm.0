Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7583D6A
	for <nvdimm@lists.linux.dev>; Fri, 13 May 2022 15:03:20 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id x12so7742841pgj.7
        for <nvdimm@lists.linux.dev>; Fri, 13 May 2022 08:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XytFC2Z5iVPi2C1MP2lv30ZVX0j/6NEGAjE2mbGa0Cc=;
        b=tXgYWk3ZyVA9JlGcKd1Lf/2xwKd6iEs1cpHW/g//3bv60j5eMidvq+nTXelUsTEif1
         c2ibqTGSgT9c8i2td/0NDxeoMi0vl8Z1Z/7xEA11KldrU7lj4dn7KqWqaq9UaRNOuAGh
         BbaGieGTs5W0D/MrzM/Zdz9b+pHsvq9E2UKv9tFz4iTENwlyZJnSWsmvoUPy12FNnu9k
         VgZW2PSHARpfF+AfS0C/DPZVy7q8Png/BTryMqi0P68D4VRZkIEx3vFmCTzW8AHw9qsE
         idspq1gzge8AHBwCITSm8lX1TGm5VkCYuELOBWKZA0M0Y37z/t+z113UIQN+5VafSN47
         tLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XytFC2Z5iVPi2C1MP2lv30ZVX0j/6NEGAjE2mbGa0Cc=;
        b=JvcnKx4n9Yw2oS/1rtQMjtFaZEyxR5InQeMFb1Qfb3ywj7EUW81i3/ad/pPKUOl37B
         yvnMdlF5pf87jJN4nhpi1JylzoyNhUYzagQNaXqsT7DtpLR9ttJoUzs4mOM8sb4QUnBS
         QB1STevqw66SnXejxOUJNoPb+At5aQYM1i2FgoAaZjq6lYXErUy6TKkDAnABstmfiEjJ
         lRcHIzrEMA3eZZ/HFqABYKYZjudDqkbwoAUHYmWTAXvOiuMNmS4QN1BRN+cYBoCrS28p
         8ZSCO6VmJ6yGt7Fdh2zL90s1SDkQPzL72AJu54sKROKONZS9XPd8vI9enUDvHcKX/Y1y
         uDxA==
X-Gm-Message-State: AOAM533myuvbMywJN2P+rDo8nPrVxiAOl2PQ4dviqQU13WYN00/7gh9i
	Iyv3kjEUrwiJQSxQu6U3OJXpiEZmEWnnaeo1ccBcJA==
X-Google-Smtp-Source: ABdhPJzi+JExvEgJ0APtRGWJdZorJ1KMkKsx4BPomwSMWOpmxbNOK9R2qrBToUnt4yiPN8Uzoad4bMJGW6AFs2W2N3s=
X-Received: by 2002:a63:d504:0:b0:3c6:ab6b:fd2b with SMTP id
 c4-20020a63d504000000b003c6ab6bfd2bmr4338449pgg.437.1652454199874; Fri, 13
 May 2022 08:03:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-3-ben.widawsky@intel.com> <CAPcyv4hKGEy_0dMQWfJAVVsGu364NjfNeup7URb7ORUYLSZncw@mail.gmail.com>
 <CGME20220418163713uscas1p17b3b1b45c7d27e54e3ecb62eb8af2469@uscas1p1.samsung.com>
 <20220418163702.GA85141@bgt-140510-bm01> <20220512155014.bbyqvxqbqnm3pk2p@intel.com>
 <Yn1DiuqjYpklcEIT@bombadil.infradead.org> <20220513130909.0000595e@Huawei.com>
In-Reply-To: <20220513130909.0000595e@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 May 2022 08:03:08 -0700
Message-ID: <CAPcyv4hHGVzW_B7B4LHYL9TXPmuuyJA+X0YrCUS=DQVhdpWrCQ@mail.gmail.com>
Subject: Re: [RFC PATCH 02/15] cxl/core/hdm: Bail on endpoint init fail
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Ben Widawsky <ben.widawsky@intel.com>, 
	Klaus Jensen <its@irrelevant.dk>, Josef Bacik <jbacik@fb.com>, 
	Adam Manzanares <a.manzanares@samsung.com>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, May 13, 2022 at 5:09 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Thu, 12 May 2022 10:27:38 -0700
> Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> > On Thu, May 12, 2022 at 08:50:14AM -0700, Ben Widawsky wrote:
> > > On 22-04-18 16:37:12, Adam Manzanares wrote:
> > > > On Wed, Apr 13, 2022 at 02:31:42PM -0700, Dan Williams wrote:
> > > > > On Wed, Apr 13, 2022 at 11:38 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > > > > >
> > > > > > Endpoint decoder enumeration is the only way in which we can determine
> > > > > > Device Physical Address (DPA) -> Host Physical Address (HPA) mappings.
> > > > > > Information is obtained only when the register state can be read
> > > > > > sequentially. If when enumerating the decoders a failure occurs, all
> > > > > > other decoders must also fail since the decoders can no longer be
> > > > > > accurately managed (unless it's the last decoder in which case it can
> > > > > > still work).
> > > > >
> > > > > I think this should be expanded to fail if any decoder fails to
> > > > > allocate anywhere in the topology otherwise it leaves a mess for
> > > > > future address translation code to work through cases where decoder
> > > > > information is missing.
> > > > >
> > > > > The current approach is based around the current expectation that
> > > > > nothing is enumerating pre-existing regions, and nothing is performing
> > > > > address translation.
> > > >
> > > > Does the qemu support currently allow testing of this patch? If so, it would
> > > > be good to reference qemu configurations. Any other alternatives would be
> > > > welcome as well.
> > > >
> > > > +Luis on cc.
> > > >
> > >
> > > No. This type of error injection would be cool to have, but I'm not sure of a
> > > good way to support that in a scalable way. Maybe Jonathan has some ideas?
> >
> > In case it helps on the Linux front the least intrusive way is to use
> > ALLOW_ERROR_INJECTION(). It's what I hope we'll slowly strive for on
> > the block layer and filesystems slowly. That incurs one macro call per error
> > routine you want to allow error injection on.
> >
> > Then you use debugfs to dynamically enable / disable the error
> > injection / rate etc.
> >
> > So I think this begs the question, what error injection mechanisms
> > exist for qemu and would new functionality be welcomed?
>
> So what paths can actually cause this to fail? Looking at the upstream
> code in init_hdm_decoder() looks like there are only a few things that
> are checked.
>
> base or size being all fs or interleave ways not being a value the
> kernel understands.
>
> For all fs, I'm not sure how we'd get that value?
>
> For interleave ways:
> Our current verification of writes to these registers in QEMU is very
> limited I think you can currently push in an invalid value. We are only
> masking writes, not checking for mid range values that don't exist.
> However, that's something I'll be looking to restrict soon as we add
> more input verification so I wouldn't rely on it.
>
> I'm not aware of anything general affecting QEMU devices emulation.
> I've hacked cases in as temporary tests but not sure
> we'd want to carry something specific for this one.

This is another motivation for cxl_test. QEMU is meant to faithfully
emulate the hardware, not unit test drivers.
