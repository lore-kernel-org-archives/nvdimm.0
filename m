Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C161101
	for <nvdimm@lists.linux.dev>; Wed, 26 Jul 2023 03:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690340752; x=1721876752;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Ac3M1GbzlRT5++1b4pL8NIEyZ2PXTx/3eagbNYXhSno=;
  b=R4beFMB9uOT3Lxa06dQMdYqeEIhAulAmctRTPjIODa9xmE790Nh4NPzG
   L4hpQ2olVrwB8O52bPd0UaVXCDD3K0dKDzrHdBawhEBLlOFqSRVrwjBze
   MAl7kcOXQ8Kdk9nNH1H1wjoLUdrTvWUtawEwDTgZ1OJ4aoVddODF8czjb
   82wnOo/1t71PjZP9bizw88KMGO3X31HhW5gWehDA0RDCoLyyHxTqc2FMe
   whSlVWqzh7N6/C+M0ncKUOPTBu9RPGz/lf2IX/kYP/KB5J36UJgq7JxbE
   NiFuzWhgfucV7joIFyqen6KJxYE48b0PAC4KlQeksMmC6UyRGUATfk3tJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="431702948"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="431702948"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 20:05:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="850270711"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="850270711"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.251.14.85])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 20:05:50 -0700
Date: Tue, 25 Jul 2023 20:05:49 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH] nfit: remove redundant list_for_each_entry
Message-ID: <ZMCNja5S3tnNBm79@aschofie-mobl2>
References: <20230719080526.2436951-1-ruansy.fnst@fujitsu.com>
 <ZL7/mctQSQ7rtK3X@aschofie-mobl2>
 <32cb262a-8ae6-60ba-2032-f02973f44a1e@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32cb262a-8ae6-60ba-2032-f02973f44a1e@fujitsu.com>

On Tue, Jul 25, 2023 at 01:33:18PM +0800, Shiyang Ruan wrote:
> 
> 
> 在 2023/7/25 6:47, Alison Schofield 写道:
> > On Wed, Jul 19, 2023 at 04:05:26PM +0800, Shiyang Ruan wrote:
> > > The first for_each only do acpi_nfit_init_ars() for NFIT_SPA_VOLATILE
> > > and NFIT_SPA_PM, which can be moved to next one.
> > 
> > Can the result of nfit_spa_type(nfit_spa->spa) change as a result of
> > the first switch statement? That would be a reason why they are separate.
> 
> nfit_spa_type() just gets the type of *spa by querying a type-uuid table.
> Also, according to the code shown below, we can find that it doesn't change
> anything.
> 
> int nfit_spa_type(struct acpi_nfit_system_address *spa)
> {
> 	guid_t guid;
> 	int i;
> 
> 	import_guid(&guid, spa->range_guid);
> 	for (i = 0; i < NFIT_UUID_MAX; i++)
> 		if (guid_equal(to_nfit_uuid(i), &guid))
> 			return i;
> 	return -1;
> }
>

Hi Ruan,

I see that. I was questioning if the type change as a *result* of the
first switch statement, which does that acpi_nfi_init_ars().

I don't think it does. I'm only asking if you proved the correctness
of the change because I'm guessing this change is tested by inspection
only. Maybe not.

Thanks,
Alison

> --
> Thanks,
> Ruan.
> 
> > 
> > Alison
> > 
> > > 
> > > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > > ---
> > >   drivers/acpi/nfit/core.c | 8 --------
> > >   1 file changed, 8 deletions(-)
> > > 
> > > diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> > > index 07204d482968..4090a0a0505c 100644
> > > --- a/drivers/acpi/nfit/core.c
> > > +++ b/drivers/acpi/nfit/core.c
> > > @@ -2971,14 +2971,6 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
> > >   		case NFIT_SPA_VOLATILE:
> > >   		case NFIT_SPA_PM:
> > >   			acpi_nfit_init_ars(acpi_desc, nfit_spa);
> > > -			break;
> > > -		}
> > > -	}
> > > -
> > > -	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
> > > -		switch (nfit_spa_type(nfit_spa->spa)) {
> > > -		case NFIT_SPA_VOLATILE:
> > > -		case NFIT_SPA_PM:
> > >   			/* register regions and kick off initial ARS run */
> > >   			rc = ars_register(acpi_desc, nfit_spa);
> > >   			if (rc)
> > > -- 
> > > 2.41.0
> > > 
