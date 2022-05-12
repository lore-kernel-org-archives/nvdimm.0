Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D889533C2;
	Thu, 12 May 2022 15:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652370631; x=1683906631;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LtzNjIgaLmlN01m0X99eoeCvuTc9SqpMdkrdBj/FxSM=;
  b=IUN8J5StENK5Uxvcy/kzFION8KcHV+r+oQnOJGQz+EmGDsAUvVKuiiZB
   t5eikc+MidLvRN/zTmjL6P39jl/U0w6niU4hhN/ERxxKl2JLnNdiZmRW7
   3zqH88AQg1FIO7lcSgnm2eW3LG185IlxOMneLaBdobkYML9N1QUNMLAcJ
   0LeWpbl9Dj722evF0VZG5l/+K8kwoDb6v1mygDQOrraA/4p2okWPN0g3W
   pLkAyK6oUJoMo3x7YGc1gLEVVajMQTt67RxSXIi5c+Rwd1seoMJnGPT8x
   ru5eMjsEFFTnFRCwksq4HMgAe26vM0t+xUBLcvflIdP6/ND+xPmD36o6O
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="270166901"
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="270166901"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 08:50:21 -0700
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="636891796"
Received: from wcogara-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.129.107])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 08:50:20 -0700
Date: Thu, 12 May 2022 08:50:14 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: Adam Manzanares <a.manzanares@samsung.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	"mcgrof@kernel.org" <mcgrof@kernel.org>
Subject: Re: [RFC PATCH 02/15] cxl/core/hdm: Bail on endpoint init fail
Message-ID: <20220512155014.bbyqvxqbqnm3pk2p@intel.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-3-ben.widawsky@intel.com>
 <CAPcyv4hKGEy_0dMQWfJAVVsGu364NjfNeup7URb7ORUYLSZncw@mail.gmail.com>
 <CGME20220418163713uscas1p17b3b1b45c7d27e54e3ecb62eb8af2469@uscas1p1.samsung.com>
 <20220418163702.GA85141@bgt-140510-bm01>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418163702.GA85141@bgt-140510-bm01>

On 22-04-18 16:37:12, Adam Manzanares wrote:
> On Wed, Apr 13, 2022 at 02:31:42PM -0700, Dan Williams wrote:
> > On Wed, Apr 13, 2022 at 11:38 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > >
> > > Endpoint decoder enumeration is the only way in which we can determine
> > > Device Physical Address (DPA) -> Host Physical Address (HPA) mappings.
> > > Information is obtained only when the register state can be read
> > > sequentially. If when enumerating the decoders a failure occurs, all
> > > other decoders must also fail since the decoders can no longer be
> > > accurately managed (unless it's the last decoder in which case it can
> > > still work).
> > 
> > I think this should be expanded to fail if any decoder fails to
> > allocate anywhere in the topology otherwise it leaves a mess for
> > future address translation code to work through cases where decoder
> > information is missing.
> > 
> > The current approach is based around the current expectation that
> > nothing is enumerating pre-existing regions, and nothing is performing
> > address translation.
> 
> Does the qemu support currently allow testing of this patch? If so, it would 
> be good to reference qemu configurations. Any other alternatives would be 
> welcome as well. 
> 
> +Luis on cc.
> 

No. This type of error injection would be cool to have, but I'm not sure of a
good way to support that in a scalable way. Maybe Jonathan has some ideas?

> > 
> > >
> > > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > > ---
> > >  drivers/cxl/core/hdm.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> > > index bfc8ee876278..c3c021b54079 100644
> > > --- a/drivers/cxl/core/hdm.c
> > > +++ b/drivers/cxl/core/hdm.c
> > > @@ -255,6 +255,8 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
> > >                                       cxlhdm->regs.hdm_decoder, i);
> > >                 if (rc) {
> > >                         put_device(&cxld->dev);
> > > +                       if (is_endpoint_decoder(&cxld->dev))
> > > +                               return rc;
> > >                         failed++;
> > >                         continue;
> > >                 }
> > > --
> > > 2.35.1
> > >
> > 
