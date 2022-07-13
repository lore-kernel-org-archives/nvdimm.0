Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5F446B3
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 16:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657731311; x=1689267311;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=dPfGW0UyqMe+1fiDDDGUfRIXpjrnn1BJ+nJMEw8I06g=;
  b=hLNIScQxrkDLEIImiilfyZID+kb7VZUAH6p3hSH/LiulIlttg+ik2ACM
   voHRzmR3aXON1pqZWxtWNeEouhjTkn7QNN3T3PEyO2fCJPL7OHzR0lPO3
   US2XguQ8i36LQDzBpMPzDT8yEROz3U3k9a1TS6o6T8mxf6EAHyTMkTXNm
   U+aLjYhHZ384Ikq+WD00lrXWaTR/rOoHgkJJa/EBgS4rXDgqWFSfmSWtW
   GQWncpsLpMwv+q5fJXohs29uAnORRv/jM1IGpdaLpPTwXJXqAXxgDO5MA
   uEcOt+Gz+Y9JypnaWpL0aHg3jxWM5sdCJv+Oj3ZtnHNJK5BvNDGVaZhKC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="346963962"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="346963962"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 09:55:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="685237067"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jul 2022 09:55:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 09:55:09 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 09:55:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 09:55:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 09:55:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5oPhpIRAIn4CuP9f2nr6ZK3GOmeFaGP0PqpTd62Qe5mSBTBK9MX/GbLPsd5NQK+DNKCa3CP3ZgU4xqMm1oe24rNfjN+VKqrGetXlCgBJkCPs3pH6HKGv/UgKzcNJAc+E0v7mmT52KRA4HNft6Rqik1h26nqnXjBNbhxM0bAkVM2/KQFAPgCvJy9v4byR1J62WLUFcfrRA7XHi4SvA8c3mvTdF7EJdim7gulL8zbpSAQV2Ve73M5ceUe19T8QNNvcK4L7Fv1a73eo+K/t9XinN2Y+ekIm/1h+23XU3dcNS02eJwXRNL+RoxkbjWLZ3nGwYwVpGfKSfYzmNs72zgv3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xbBg3DgIshsWBzlYgO5BtSobz++pwUuQRyNzDdmJVYg=;
 b=cDIANRLxr0RL2fy+qszXMzyYpdFtxNgg0J3ADKrzj1fzUf8AJMnyBWhHMrvVOB6kK6Tt+Syf5UMp1pzeJdPaFrsZm15GktcEc8belEox3W6UjX5NlGVKIWwi3KdkcghRBFIXtHumUnoIBIy+/wsivyYBpuoTIeXYbdVEliVk1vztz5W9mIDDEN63GUzPlgnyRJexaMF4XD6FUaSJiKW+vHUUdnFwxBiGwhfgwskFsKLZEVnygWaI6dpZXB9/UB+EoxgzBVevBn5uTTzpVFFHaIY4eY/comFB/QdqtIEqFAPabMyTUQEOU7k/21e3TVC89A0uI2gNSSBTe2FhB49UnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ0PR11MB5021.namprd11.prod.outlook.com
 (2603:10b6:a03:2dc::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Wed, 13 Jul
 2022 16:55:07 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5417.026; Wed, 13 Jul
 2022 16:55:07 +0000
Date: Wed, 13 Jul 2022 09:55:05 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 09/11] cxl/memdev: Add {reserve,free}-dpa commands
Message-ID: <62cef8e9e8ac6_156c6529454@dwillia2-xfh.jf.intel.com.notmuch>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
 <165765289554.435671.7351049564074120659.stgit@dwillia2-xfh>
 <cac1d3a7a7e6515b2db0ce7ee73db812686d3407.camel@intel.com>
 <62cee31e25d52_156c65294f1@dwillia2-xfh.jf.intel.com.notmuch>
 <e0e83c8e3a45b432ed1747b0b8442a7a11db8579.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e0e83c8e3a45b432ed1747b0b8442a7a11db8579.camel@intel.com>
X-ClientProxiedBy: BYAPR11CA0099.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::40) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33ff56c7-9ccc-4597-f653-08da64f070dd
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5021:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ig1Y3flTIqy86WqFurboP76XaCar36v3dIfViVIVevWTbcDphTQoL80qw3aPeOlKNLuH9suX9AllRnHaITi8otBAIMbLbot9sknfoeQHbUP/aJhK4hPo/hac0g6nyNR513azrbw3EiXDBuKlr+esJ++PMmRvR5Ibnnu7ZB4rNws67S23fOsneTJgLLhm+7/Vk0PI6lJg/RFlcKdPubrNaT1ND20l3NRkjRdqvartzUky5+T1cvtjtMiWh6QF9yagaenyZ9zYcwTZfJBrX2MFuTRhYs+JHybr0zsfX8kTOQMXlmQnDlUyuT5mgBUpLf+Xa8zAX3I+55pantl6fs4p5rS/6+VB7qDnSH8p9ysdhLg/Mpl5p2LsgEb7Jwa1zX/tmV8WXqvPLb2/acnLN/tBZgGqjEjYm8YeP0PIVMksE2xo4Va3ZatWsijWovtCuoRwwb/4zHNFbtdpgGfpix9o/HKSEGk/1dBKox0z5gLNTfUWrAgTc78d8PolGcjwGrEfpazasFqCJ5whN1qwb237u5K/u00zn3l0eChOD1UK2Tf9Eze62v/QQ5FoG+ywX3GS8QcfWmaeDyf2JBCado2XDA5UyRJAb6KBhLEdxNlOYA4KZtu8mrewrcuX+FPhRb+PAr4f+/EUpIK2zWHZNxYe7XdmpSv1bMdmG4Bt4CzhEb3tMQ9b2hEhnQhPMsSRpuvyqwoF9nk4xdZ5PlFiR+Cpip4m1kmobefvIkpfGU/6iFIxfd3hkdkqmi0HWraJczZseZBXYJMu4Cpyg8zhmOfPEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(366004)(396003)(346002)(136003)(316002)(6506007)(110136005)(6486002)(54906003)(41300700001)(26005)(2906002)(66946007)(8676002)(66556008)(66476007)(4326008)(186003)(6512007)(9686003)(82960400001)(86362001)(83380400001)(8936002)(478600001)(5660300002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?IuVC17shMWDIr2nCNnQVyQY0PwOeQZTtznZftuX6N6f4hM/DUfNcJ8fw2i?=
 =?iso-8859-1?Q?/sJHZDgKAN8yG31YMf93NTl0tCfFHgwpqIZsje+j3AgeQa1hEYvBnIRpMh?=
 =?iso-8859-1?Q?SfXc6YlVHTMhb+sg9+Sm6lF8w9/TiYplvBizLHlJ4OPZ4fbgxXyITduQGs?=
 =?iso-8859-1?Q?oo8pVPWV/kZcU/v3/1bGFT+k0b7sRDep/C+5Pd0XlP/eio/5h2uW4Qb+uY?=
 =?iso-8859-1?Q?7vOYtnUvQBoS7AsbH5OIgMOfZbWainlaMC5M4XycXQlfCiB9tCiS7SB923?=
 =?iso-8859-1?Q?6g+dnl0LBbvzgkH5d7Z1aVLuz3DGgfaVCTCXFtm0XKnTlxgxYuFxIB+y02?=
 =?iso-8859-1?Q?0CzrKqquIRj+oBVW1j60su8OZaUe9E4n2fxjYpGQlrZFuJ/qTPv4WbtKXQ?=
 =?iso-8859-1?Q?zEvSsiXB7XTTpQRR/y5bXPd4micxLAjQl3EC0NjD5eGPlFcKrzG4Llpnq9?=
 =?iso-8859-1?Q?4RuhNbgss1PreM5vqJWVP7cBkbZ2lzsC/Mdnn35eEydoTp1zm6Mr69jbwd?=
 =?iso-8859-1?Q?1EixOr9vcH961yCAazsjbcqWGHD9qZN8iTnUZzwEKhlOfuOBeDyvt9VBWR?=
 =?iso-8859-1?Q?BtGMfTum10+l3FNxVGnzDozTTmggGu2LvUBfo2eiGbh5veZzWFtSgzPYA6?=
 =?iso-8859-1?Q?uQ/AA2nXAvgcqDnN/R2Ldj/5QA6zo+1Rle41DIh97+7yJoBQ4tgAcLf0Yg?=
 =?iso-8859-1?Q?3n+7epv9ENnVuAnlZ8CF5s3i5R4F0MMu1Oze3hIZ445jHJ+Jxn2CJv/twG?=
 =?iso-8859-1?Q?WYFcht02NzzjEngkTxXnskgQ+95ErrI0Si/34Fy9X8SZaPU6J8u51GigF3?=
 =?iso-8859-1?Q?0UMcf4vkVMCNSJ/CPvy8PN3I+203ZGvtljG1c7Uz+/DjNH8eQ6I/20Rb5Q?=
 =?iso-8859-1?Q?vhKUMv50KGQDggo8tjxp9G6AlpsN/UrEQPj9W0ubHrthFuLnAFWsrJZz77?=
 =?iso-8859-1?Q?F41ackjGNKGnFKP+4wQlDFOV9nSCJckqreojUx5oo/89z/FBpOhBmmtDA8?=
 =?iso-8859-1?Q?fke+LPiNMrsJApOh8eAAk2vCVlaYrMG/q4DjrjbUWOhdkHGX/eeq0OPFiy?=
 =?iso-8859-1?Q?4cZoGpm0KfwRD8KeDgFdNEOJkkrJT1ge0UZVXvAVMGgeQ1RIUyvrojNO0l?=
 =?iso-8859-1?Q?IQPGq1fZs7VFgeiNoNBDTUcUAswh7fc17wBgFjFl64+E0KAW4WRpSOBdCc?=
 =?iso-8859-1?Q?dtanQRx+2FKPTHxnYqu4F+T8ql9MOOY5RD331VZmBlorYMG1cF8YAYbX4r?=
 =?iso-8859-1?Q?1RVAtuKuvXthR4SZ/zr3ZsUn5tZwmuYSLPu6NEA04lIfcoudi9uOsryrCO?=
 =?iso-8859-1?Q?x0FjNURyxYkyloq8c6taKJLVxZv7RDiFVUueUUjc81mv3pG+XpETxcWpc0?=
 =?iso-8859-1?Q?EZh1FMWETmY2mnED821M6jmV/4Ihhp4XQpJOm2vhtDqNwJAcXvhJLsYWLD?=
 =?iso-8859-1?Q?K7GKh2Kcdf436nkwCuV7ujEolm5vPuqrZhpOppBPwEiw3Bs/cPftrIj8PE?=
 =?iso-8859-1?Q?K6KVEkOx453psMRaP7kGgvaVfdh7ZQuh59kiXWwF509gLJKkrt8ZNdc497?=
 =?iso-8859-1?Q?d7j9d7ZJBuyR+6xbrDslluTiC8qwyumFkbWLP9LNKoHg+HKO/EVej924Pm?=
 =?iso-8859-1?Q?H37BG1Qnig0c0itt4E6DoNAxk8Jw/GMjvrq8LruQFscW/zohpnr7+Jpg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ff56c7-9ccc-4597-f653-08da64f070dd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 16:55:07.6275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xeqw8kM+xzin9J0ma65MMbRjHpDxT6LaPxWWIObPma/YNzA63PON4LnywF/qjghtTf61yYDGTu1n4tFOMA4dp0VVgEJDcVKCTx23Qe6eS3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5021
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:
> On Wed, 2022-07-13 at 08:22 -0700, Dan Williams wrote:
> > Verma, Vishal L wrote:
> > > On Tue, 2022-07-12 at 12:08 -0700, Dan Williams wrote:
> > > 
> > > > 
> > > > +
> > > > +       if (cxl_decoder_get_mode(target) != mode) {
> > > > +               rc = cxl_decoder_set_dpa_size(target, 0);
> > > > +               if (rc) {
> > > > +                       log_err(&ml,
> > > > +                               "%s: %s: failed to clear allocation to set mode\n",
> > > > +                               devname, cxl_decoder_get_devname(target));
> > > > +                       return rc;
> > > > +               }
> > > > +               rc = cxl_decoder_set_mode(target, mode);
> > > > +               if (rc) {
> > > > +                       log_err(&ml, "%s: %s: failed to set %s mode\n", devname,
> > > > +                               cxl_decoder_get_devname(target),
> > > > +                               mode == CXL_DECODER_MODE_PMEM ? "pmem" : "ram");
> > > > +                       return rc;
> > > > +               }
> > > > +       }
> > > > +
> > > > +       rc = cxl_decoder_set_dpa_size(target, size);
> > > > +       if (rc)
> > > > +               log_err(&ml, "%s: %s: failed to set dpa allocation\n", devname,
> > > 
> > > This patch adds some >80 col lines, which is fine by me - maybe we
> > > should update .clang-format to 100 to make it official?
> > 
> > .clang_format does not break up print format strings that span 80
> > columns. Same as the kernel. So those are properly formatted as the
> > non-format string portions of those print statements stay <= 80.
> 
> Oh sure - though I thought it would at least drop the " devname" to the
> next line. (Just checked, looked like it does).

Of course I only checked the 2 previous log_err() in the quote and not
the one you directly commented on, will reflow.

> 
> There were some other non-string long lines as well, e.g.:
> 
> +static int action_reserve_dpa(struct cxl_memdev *memdev, struct action_context *actx)

Ok, will reflow that as well.
