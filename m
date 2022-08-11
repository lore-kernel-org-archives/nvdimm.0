Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EE828F7
	for <nvdimm@lists.linux.dev>; Thu, 11 Aug 2022 23:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660258942; x=1691794942;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=2JmoPz0MrSFJUsCxCZ0v5Zjlzu/JRyTODm43VrL0RXw=;
  b=nRxSdL6/FEuWVy7Bmr4WkoDTWvxFko60NB7EmzY9rQNYf/e30YyEmV0a
   qFomswvY90FDfTqzSvfa5s/9OjVOWJ/giZw4XgjSgntxIN+T41B6Ql7Qo
   pZRtZ0V5D5jgv8JFKpA+j/waWyCi4ITpgsBDDiup3VRSNumb8D5L5YZKb
   V6s689HtcwKHT2i/PMMAgqYeKqxcbRWwPaDxegNBIwyTnLgPl2lnGhXhg
   5yzoT1lPnA/OLSAdxqXizWWEAEYoazu8SXqAuYwJW9aPbjw1h9s9zsSbn
   +lxOEcaL9AyjdykzhwAcojtZp/XRVn0dX6cNHZ4PL1UKbaHPGAuSFGHi3
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="292742291"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="292742291"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 16:02:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="665587757"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 11 Aug 2022 16:02:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 16:02:21 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 16:02:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 11 Aug 2022 16:02:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 11 Aug 2022 16:02:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5AiBQjFQYJMTFbTPmRZ4PQcKWNs3bAoCdskEkp9WFn0aHN0xvGrLzZBIQ4DoD1PcqWKSDz6H0eZ6y+3a+GVxQaLDY3XDFsjJu+7gXFaUpa3Mt3eItOW8bM4RmzLxpPrpuQjkrVF1xH2kVZU12SjjjEGAO5uM2pydHqf412xpLM5SBzSrESwyQ75PePSlhNvhLGlwKopF01QIw7GISX1hW8lOUATeb+A5vCXZH0VPorjdYENbNJm4YiRqL4Q6YlkZInNoaLCQcF4UJvhTrj5ehOEuSgH0+VvvXL6h/xhdS6eea78B6Vs2YtUJoZZ50n7qsg84KXGGkPhA7U6Ug6RsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N/lHqoGIG2GpyIOF4lofbnAsskRZAqhTyrycVwZkQNs=;
 b=lA7gSFNkmfq0YABTRz7gsck3bdF2m8MIXXyMmZyS7hHuDKrd7mlGQMYZgwzQ0B9fHK+NPuPCWEywHasOu+vLJbcrZ01Ydf2FL/3yngPW8MXPwJFSba2f5K6rK5Ap8OMS4INu7tRAxDpxCXh+EvcJYRTHgD0KMRmBC5znSlRnZRXLfQ991wF3ffuCKggR6OChkgbwpydunUngwt+e0vme67zHZLWKsg27kY3sTTYCM+mmaEwrMibQNiaKNQyLy4e4CJJpuW/iJWywRy0DDbRu4Mw0xuWb5zPiChgJkOCA7ZrdOLr1fzqe2y8y07owVh32rUk0G/DJ6vHyUbhozCs8hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MWHPR1101MB2350.namprd11.prod.outlook.com
 (2603:10b6:300:75::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 11 Aug
 2022 23:02:17 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5504.024; Thu, 11 Aug 2022
 23:02:17 +0000
Date: Thu, 11 Aug 2022 16:02:14 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
CC: "Schofield, Alison" <alison.schofield@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH v2 06/10] cxl: add a 'create-region' command
Message-ID: <62f58a76c6324_3ce68294e0@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220810230914.549611-1-vishal.l.verma@intel.com>
 <20220810230914.549611-7-vishal.l.verma@intel.com>
 <62f559b843501_3ce6829439@dwillia2-xfh.jf.intel.com.notmuch>
 <128f99454b44519c6ab356b680206232b5e597ba.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <128f99454b44519c6ab356b680206232b5e597ba.camel@intel.com>
X-ClientProxiedBy: SJ0PR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:a03:331::23) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adff2aab-6016-4f35-60fd-08da7bed895a
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2350:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v7wO1OgBqZITrajRF9fPx+G40MarJjQrdk2O9K58hswToSszIfY33SF/gGVn9vj4g2hMwF+jThbZZp2sGQA6nL6BkHQPQkFgNazvOrT5lxVaje7dmV13J+2VIIXwwlk7EpZGDMYnwWHKmlNobGSo9yINbMf/+YScEUthIsMEokTl9wAZ/iBuEHgnP3FrDcAluso0XVPlkElh5ZTVPg9vmjDFSs59d2uzMX9QzNkpymx5QiMwZ7E4IXlV5xKpGEuV6AL02+/HH0ISQ4Lgyi9t4MfUUUyjDAaoc6iRdV/2MU1uRV3bcUStGM6IzAMSQDIhC6kpy1Hl+GM3q17fEyGwqWcLfFLyBr+xAw9dpBxTrgVTDGdd3xOV0ODpj+9hwS9NDJ/69+jvmti+52NILtWwd5ZlPcMBvEmrQcwmQw5TTjKtdBphOyz/hIPW6SPMYXOd9FvCiRfGZ4tmjvGcXlX0srajrRIHR21++eCDWZktdZmhIyGTxd9HaMKNiJAnmDcrFUD0V41V8vK3OKC2gpzUscxxoDoqcGqBQf855DFE96lPqtwxNIALlCPWKTDQmXXvm9XjNba42doUSpEXFsdPfUHxEo43GxlOgn29kyqvS+//+ezQWz9nEkZdTweOgi5HXOZm9FGY8Rt8OjxfPG6pRnxRmP5z2uCkOdptG+o/PR6Q0gHQdCU59wK4ZPmYRjGmZol39tIisp8tmYIm5e6RJWdMNsxEFHvU0MV9KoylRWwlSy/0pQYouVYYLaJcNiFU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(39860400002)(346002)(376002)(186003)(107886003)(26005)(41300700001)(86362001)(6666004)(6512007)(9686003)(6506007)(83380400001)(110136005)(54906003)(4326008)(316002)(66946007)(66476007)(2906002)(66556008)(6486002)(5660300002)(478600001)(8936002)(8676002)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?XKJ75gtWYp/4w8SstvUhCXLZftqugCJz6O5mY4PY/k9UfNWvLVgkh4B2im?=
 =?iso-8859-1?Q?IzIYu1hXKMCncXxZwAAt9j7T5qRTU0b1nFGcyoT1IL0zhzYf2sAjZTeqtf?=
 =?iso-8859-1?Q?3Df+TYWQcQ1s0pJCHRn5EM3/u9eKeb1stbCWZwkyv9r0S/9DPlZwkVAC2w?=
 =?iso-8859-1?Q?3SJOazyf56sYGGqhESnCJKK+qbraZ4t2kfiBX+Z1pxUQA6PaPlNLISKWG5?=
 =?iso-8859-1?Q?InWFlkNh8JfDMaM87jnqSCyTeRAzuUKzr6xJsqzHNfCjA1Blq6Sao2FVgX?=
 =?iso-8859-1?Q?J035MJ1cXty+1VbehcH00jMbIGXMN72bf71ZYx9Ec+BCLFznuo5wx491V/?=
 =?iso-8859-1?Q?Lq5FXaVt1ibYQPmxt6qdiTNr3KC6J4/bm8SfIWSjtR+G+dhSgStfygFkqe?=
 =?iso-8859-1?Q?TcB4pbNMorkf+EZ+OPy11XLzyoI+EdUDp5ZLxjpBwsvjGdCej7heE2805W?=
 =?iso-8859-1?Q?RozzAwaKnxUsI7U39T63wfoDUd59T4zYOdZ04+fXW1eFg26ZpC5SSqi4Z2?=
 =?iso-8859-1?Q?8kBZ/vSA7MuWvoNjRsamtlHPyxux831ngByNeGuyqP4B5w4acfODS9sb2G?=
 =?iso-8859-1?Q?ZFbXFBEFptg/ebhXflJ9vubXSrNglXa0UJv5IZmzx+O4ocW+kJ1vqRSHV6?=
 =?iso-8859-1?Q?6yXC4gY5oneEomymjbpuYD72dJNoa8rq/RDhfxtFrCVnh5GQ09mG0H6Tac?=
 =?iso-8859-1?Q?b+Rz0gxVFjMpjjZAyTioFa4lSgIDcQSZDyZG1V3/E2V/E40hXW/1CNIn81?=
 =?iso-8859-1?Q?mhrGOLjNms6sqO6s+qz7bwODXuFiwWWq7P/irPueuolIdu6fgSY98FuPKK?=
 =?iso-8859-1?Q?SnBt6MYtDRhFab2l0eRRMUq4qoHpX6XS3/UsyDmxEGFJqvMBo2ceDUKId2?=
 =?iso-8859-1?Q?2l22DYn5e2Rmn4Q/Yw/RB0jHzgiM73YaE7saLVz/lFVyTExvflQtV7HRLo?=
 =?iso-8859-1?Q?OfVDtBfN5oiS6O6S/DQ8sU1mM6wNKBJZbBiztivVDYKSn/8uwRXw5Aat4K?=
 =?iso-8859-1?Q?vuyzX6XyLI/9ZCD5x9y5WfwTmdOxgo4rhgp8OTfmh9DBtpAFJMBjU+I6/C?=
 =?iso-8859-1?Q?DVnJTQLB4KsDDh+VLddI9zfx4fLmnGx6hklyNqH+dJV7G/r3aDfkx+sE2u?=
 =?iso-8859-1?Q?OZ648SE2SZoqetnY33wj0t1t2LeIAJSxc6f2QX6EUFYTg3VhWiP72HVQ8f?=
 =?iso-8859-1?Q?xZKf7crKhHCp6Mtb0p3nmD0TYSmbIJBBnbXJIE1jbGgMOAkSKTUzXWwDeB?=
 =?iso-8859-1?Q?yg8MgRUR6gA8vs52Jezphpsvnayd87VOhIfUvkk2dd0C8teZLfnaKf7utA?=
 =?iso-8859-1?Q?YB0yBKUnDdw+XMvleu0jmP07BXOXlCIEyRUB5iYgciqOw5rRdqP3qePt7p?=
 =?iso-8859-1?Q?NEkMUyTynGGg2BrUaFWljdltW7XV8CCRI8bL2kOMoHhCIWBMOxW0o652ZY?=
 =?iso-8859-1?Q?PPPik4mEx0fjeFj4i+A6EJPAOFrON0cIach+UlSzTjjil5lxPfvuBiQgSh?=
 =?iso-8859-1?Q?2HdPVaAy5aZgWaPyFcHTXobbhQw8ahziqNccpMzsZm4fierQaMzcI0HJQ6?=
 =?iso-8859-1?Q?b2+Nn3PR/HMBlJrAwBZSZpO8QOs3+lymoJKjAPe/nMnsNJ2g5QgfH0M5bs?=
 =?iso-8859-1?Q?VvpefWETmo22toPiDCqlNA0gYbobLrnRqZl8sxliY+pK9zuZXgiBXECQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: adff2aab-6016-4f35-60fd-08da7bed895a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 23:02:16.9619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wqretnE9WNLmlsVKnk1xPSNAH1tsfqyNE81ahaN6euktriMRXGlNtxvJu0KgD+Mo9u4wF3QhpYwgu/+HOWAsJurc2HcTM6DRb5JC955mNI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2350
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:
[..]
> > > +-m::
> > > +--memdevs::
> > > +       Indicate that the non-option arguments for 'target(s)' refer to memdev
> > > +       names.
> > 
> > Are they names or filter parameters ala 'cxl list -m'? I.e. do you
> > foresee being able to do something like:
> 
> Hm, in the current implementation they really are just names - I just
> use the remaining argv[] as the targets array, but..
> 
> > 
> > "cxl create-region -p $port -m all"
> > 
> > ...to just select all the memdevs that are descendants of $port in the
> > future? More of a curiosity about future possibilities then a request
> > for change.
> 
> This sounds like a useful thing to do - perhaps with the next bit of
> porcelain additions.

Sure.

> 
> > 
> > > +
> > > +-e::
> > > +--ep-decoders::
> > > +       Indicate that the non-option arguments for 'target(s)' refer to endpoint
> > > +       decoder names.
> > 
> > I wonder if this should have a note about it being for test-only
> > purposes? Given the strict CXL decoder allocation rules I wonder if
> > anyone can use this in practice? There might be some synergy with 'cxl
> > reserve-dpa' where this option could be used to say "do not allocate new
> > decoders, and do not reserve more DPA, just try to use the DPA that was
> > already reserved in the following decoders".
> > 
> > We might even delete this option for now unless I am missing the marquee
> > use case for it? Because unless someone knows what they are doing they
> > are almost always going to be wrong.
> 
> Yeah I agree - it is definitely not straightforward to use, and I don't
> see a practical use case. I think I only had it because the ABI wanted
> decoders, and very early implementations had me explicitly asking for
> /everything/.
> 
> I'm okay adding a note that this shouldn't normally be used, or
> removing it entirely.

Hey, if there's a choice, you can never go wrong with red-diff.

> 
> > 
> > > +
> > > +-s::
> > > +--size=::
> > > +       Specify the total size for the new region. This is optional, and by
> > > +       default, the maximum possible size will be used.
> > 
> > How about add:
> > 
> > "The maximum possible size is gated by both the contiguous free HPA
> > space remaining in the root decoder, and the available DPA space in the
> > component memdevs."
> 
> Yep.
> 
> > 
> > > +
> > > +-t::
> > > +--type=::
> > > +       Specify the region type - 'pmem' or 'ram'. Defaults to 'pmem'.
> > > +
> > > +-U::
> > > +--uuid=::
> > > +       Specify a UUID for the new region. This shouldn't usually need to be
> > > +       specified, as one will be generated by default.
> > > +
> > > +-w::
> > > +--ways=::
> > > +       The number of interleave ways for the new region's interleave. This
> > > +       should be equal to the number of memdevs specified in --memdevs, if
> > > +       --memdevs is being supplied. If --memdevs is not specified, an
> > > +       appropriate number of memdevs will be chosen based on the number of
> > > +       ways specified.
> > 
> > The reverse is also true, right? That if -w is not specified then the
> > number of ways is determined by the number of targets specified, or by
> > other default target searches. I guess notes about those enhanced
> > default modes can wait until more 'create-region' porcelain arrives.
> 
> Hm actually in the current state, /only/ the reverse is true, so this
> description was certainly a bit forward looking. I'll fix to say what
> it actually does today.

Cool.

> 
> > 
> > > +
> > > +-g::
> > > +--granularity=::
> > > +       The interleave granularity for the new region. Must match the selected
> > > +       root decoder's (if provided) granularity.
> > 
> > This just has me thinking that the kernel needs to up-level its code
> > comments and changelogs on the "why" for this restriction to somewhere
> > this man page can reference.
> > 
> > However second sentence should be:
> > 
> > "If the root decoder is interleaved across more than one host-bridge
> > then this value must match that granularity. Otherwise, for
> > non-interleaved decode windows, any granularity can be
> > specified as long as all devices support that setting."
> > 
> > As I type that it raises 2 questions:
> > 
> > 1/ If someone does "cxl create-region -g 1024" with no other arguments,
> > will it fallback to a decoder that can support that setting if its first
> > choice can not?
> 
> Well there's no automatic root decoder selection at all in this series,
> but for future porcelain, I'd imagine it should try to match exactly
> any args that were specified, and fail if /all/ of those can't be
> matched.
> 
> e.g.:
> decoder1 - 2-way - IG:256, and
> decoder2 - 1-way - IG:1024
> 
> and we get 'cxl create-region -g 1024', we should pick decoder 2,
> create a x1 interleave under it. Does that make sense?

Yup.

[..]
> > > +       } else if (argc) {
> > > +               p->ways = argc;
> > 
> > This is where:
> > 
> >     cxl create-region -p $port -m all
> > 
> > ...would not work, but maybe requiring explicit targets is ok. There's
> > so many potential moving pieces in a CXL topology maybe we do not want
> > to go there with this flexibility.
> 
> Hm yeah - true. It was certainly convenient (ab)using argc and argv for
> this, but if we did add the flexibility of specifying a filter, or even
> multiple filters in the future, the targets array would need proper
> reconstruction anyway, and counting the objects in it would come
> alongwith it.

Agree.
