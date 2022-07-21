Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C5628EA
	for <nvdimm@lists.linux.dev>; Thu, 21 Jul 2022 18:51:18 +0000 (UTC)
Received: by mail-qt1-f170.google.com with SMTP id u12so1993900qtk.0
        for <nvdimm@lists.linux.dev>; Thu, 21 Jul 2022 11:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ABlARo1q4W8MWl8fMSyyIWAkJhcwdZqRLERUMRVV8y0=;
        b=a3Dipqi7DP4aUkldrHp93ne1O6cTrWtFJpNvlTOIVlXo01XvWSk4dz1tX3rtPQH3F2
         jAZAdCSavV3Sqgbsz0881u6GS2ltM95tIgUSEsp0f4tJQdjSNgtsu7Jm0vYtk0N2CT3v
         Aif0YgWwWfuK44GRHXwEJRP03Ftyu1B4VkWa6AXBbpGhQcxyIz58MrwLQXzV7/YOGDWD
         JA9n9g/1CRGRGhplF8rk7GYAdQ3ph3PTTW9VPSa4A+IG/q+1eI6r6yd63bvqVxvRoThu
         CFd4/soAUrj26JEa+N7OTRsMBMcMiPKeKZJ6e4cI5qyemzqeYxtA9kaepAZ6wNVIN7X3
         sMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ABlARo1q4W8MWl8fMSyyIWAkJhcwdZqRLERUMRVV8y0=;
        b=CqK6sFkAqh49Fhs9tESC++q7z8TpoE7D4B/syewKVOGmg9P2GRNMgw4c0uUX7qp+4F
         nxmwtEHoOSJZDdqAWx340kLk/jP3QFxoVS3NAuaCE8qDyrnNrSolZ0pAR6NzcW2p5wWa
         MGIGzI9cHFGgPUMTbJr5C88NrCwhNdJdm5C+dmagZ+CAFsdBOc7G1R9co0A4LfPnpQ3z
         pxvE8/vNkcyKh47mXZMlh1UYz2iTGbmnVIg3+b0Ngl9rKAG83G1eaDZJ+NPd+RdluwoC
         V5gSDu/crYafjbgHYyHc6kIHcxvOXvWF9wMMHR0k0KHC/qPvXHaIEA1E9XHDPUNjqDAQ
         Vz0g==
X-Gm-Message-State: AJIora8WDSmnNnZxrk8pOqeocRJGRFk8XCi6k9zoJpwYUzFyevC/20rP
	Mq7LS+lr6opOdvXRXqLTzuJXtA==
X-Google-Smtp-Source: AGRyM1tSQawsbfCG3JVFskJrFAyZkEyE7wpSkmlKeLjG/ZzroPfTxIM/UKxdVXtcFB6JavtqQFxOGg==
X-Received: by 2002:ac8:5a12:0:b0:31e:f233:50f1 with SMTP id n18-20020ac85a12000000b0031ef23350f1mr15963077qta.229.1658429477857;
        Thu, 21 Jul 2022 11:51:17 -0700 (PDT)
Received: from ziepe.ca ([142.177.133.130])
        by smtp.gmail.com with ESMTPSA id q5-20020a05620a038500b006b5e833d996sm1745532qkm.22.2022.07.21.11.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 11:51:17 -0700 (PDT)
Received: from jgg by jggl with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1oEbGW-00022g-2R; Thu, 21 Jul 2022 15:51:16 -0300
Date: Thu, 21 Jul 2022 15:51:16 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org,
	jhubbard@nvidia.com, william.kucharski@oracle.com, jack@suse.cz,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	ruansy.fnst@fujitsu.com, hch@infradead.org
Subject: Re: [PATCH] mm: fix missing wake-up event for FSDAX pages
Message-ID: <20220721185116.GC6833@ziepe.ca>
References: <20220704074054.32310-1-songmuchun@bytedance.com>
 <YsLDGEiVSHN3Xx/g@casper.infradead.org>
 <YsLHUxNjXLOumaIy@FVFYT0MHHV2J.usts.net>
 <62ccded5298d8_293ff129437@dwillia2-xfh.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ccded5298d8_293ff129437@dwillia2-xfh.notmuch>

On Mon, Jul 11, 2022 at 07:39:17PM -0700, Dan Williams wrote:
> Muchun Song wrote:
> > On Mon, Jul 04, 2022 at 11:38:16AM +0100, Matthew Wilcox wrote:
> > > On Mon, Jul 04, 2022 at 03:40:54PM +0800, Muchun Song wrote:
> > > > FSDAX page refcounts are 1-based, rather than 0-based: if refcount is
> > > > 1, then the page is freed.  The FSDAX pages can be pinned through GUP,
> > > > then they will be unpinned via unpin_user_page() using a folio variant
> > > > to put the page, however, folio variants did not consider this special
> > > > case, the result will be to miss a wakeup event (like the user of
> > > > __fuse_dax_break_layouts()).
> > > 
> > > Argh, no.  The 1-based refcounts are a blight on the entire kernel.
> > > They need to go away, not be pushed into folios as well.  I think
> > 
> > I would be happy if this could go away.
> 
> Continue to agree that this blight needs to end.
> 
> One of the pre-requisites to getting back to normal accounting of FSDAX
> page pin counts was to first drop the usage of get_dev_pagemap() in the
> GUP path:
> 
> https://lore.kernel.org/linux-mm/161604048257.1463742.1374527716381197629.stgit@dwillia2-desk3.amr.corp.intel.com/
> 
> That work stalled on notifying mappers of surprise removal events of FSDAX pfns.

We already talked about this - once we have proper refcounting the
above is protected naturally by the proper refcounting. The reason it
is there is only because the refcount goes to 1 and the page is
re-used so the natural protection in GUP doesn't work.

We don't need surprise removal events to fix this, we need the FS side
to hold a reference when it puts the pages into the PTEs..

> So, once I dig out from a bit of CXL backlog and review that effort the
> next step that I see will be convert the FSDAX path to take typical
> references vmf_insert() time. Unless I am missing a shorter path to get
> this fixed up?

Yeah, just do this. IIRC Christoph already did all the infrastructure now,
just take the correct references and remove the special cases that
turn off the new infrastructure for fsdax.

When I looked at it a long while ago it seemd to require some
understanding of the fsdax code and exactly what the lifecycle model
was supposed to be there.

Jason
