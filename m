Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BBA36C
	for <nvdimm@lists.linux.dev>; Fri, 12 Aug 2022 00:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660265566; x=1691801566;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2H/3hz1viQeyZAsUklWj1oRwptipkI4zaU4VtH3MYpM=;
  b=GMev5dGhdrXYmIgxv872OeF+Sfe1ie1GwGouI0zUPV+IOWW1B3nLl9vD
   8o2bPGP4R6EbwlBJvFJSGAk2caLcZAz0CZJOBtDw/mKv9qx4J1csNfwCa
   jwNK3C+mzQoK0Z6hRdUzTS53ZY2GG+nD4sUh8CG1bqfBXmvLCsSXP+7xC
   1SuZoGxBbxO1OUyoDTp9R79F9WyQF+30Gectj05GlSwYeJ9pXFcZvXCoH
   rlxWlnLQgj58nZQs7MN6oUlZu5w9yu1GyYButLRjgvjtpDst/n4ZuUU1R
   58Fw5pk76DjYicnMQxAEbwcwpwfEYC0k0t0NBFQJEh/67ZyRi64HhW493
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="290248514"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="290248514"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 17:52:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="708822179"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 11 Aug 2022 17:52:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 17:52:43 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 11 Aug 2022 17:52:43 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 11 Aug 2022 17:52:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TANgeto/a5rkYVCbBEju2b818+EVq9nv1JeYFYeAFb/wLWnb2eXOAKDLTOcfqkvx2eevFAOvhr/44nhMKOwvrliAZ82DjI/FbnKo+9QhjcKvVUkLACAMo7rwIZOeT7Bqya7BS8fq5JJQzXXAcGMs2fO0rejouYk7RfhJf3bHrGBP7tbLw578nVdqZbvbJJ7A6n7+tYj2dH/uS4UgtUtJEHg41o6hC01gd0Yit3jA/NIt3zKpVENwdEZNtG6nXojAjGYyG8hZ07UHdZ8IGCnlZN0FmLSgOV1uXfNFisGhFdXy5wdsBizHhggJyAjkPslNmC7fNPSOeOOJt44ecEbi5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+MogFH3ERvHJY2+l2qV4ZOthsxYFZrfG6vMpM4oCUOc=;
 b=b0kPGhiuSPY2x/IleP+jYtTaPBgyMyGQ6Ua8l3HZ2Ogm/5yYZQdFF5xJiVAHlVVGkoszFpr/gQVEZiT/SmmY9ul1UYviiYOGJGTWmgqzRaoRLKqIO5ziAljoYc05QrToRo1v0AbruwfqohI13nGiSzoOt2BJu80wSfF8+yQvNqsGWmIL/0/srsxOIY30AE0hgKdnSF68HF0bCXwydpwlfH1GrdZVF294tA/SMvmxF+5cL0iYRovYMZB4BXcFuYYwDLQrffMgLwDN9CatLt885Tnw7QijQuQSKV3wJrB6lSP69G4e0JhI0T//181rJcji8d6cKShxnM+jRbsZ7o9vhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CY4PR1101MB2327.namprd11.prod.outlook.com
 (2603:10b6:903:bc::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 12 Aug
 2022 00:52:41 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5504.025; Fri, 12 Aug 2022
 00:52:40 +0000
Date: Thu, 11 Aug 2022 17:52:38 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>,
	<nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH] meson: fix modprobedatadir default value
Message-ID: <62f5a456a416b_3ce682944b@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220812003653.53992-1-miguel.bernal.marin@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220812003653.53992-1-miguel.bernal.marin@linux.intel.com>
X-ClientProxiedBy: BYAPR01CA0019.prod.exchangelabs.com (2603:10b6:a02:80::32)
 To MWHPR1101MB2126.namprd11.prod.outlook.com (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a950245e-e563-4c50-b3d1-08da7bfcf577
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2327:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p57Bfpvchh5/JBQlp65B4A1baV+sLXfdPhstcfJAp2v0AsATWl4dzOb2F754o6VzeMEitvWqINp1smLMG+u0kYS0my7QwbfqgwKCubMlJX6hWgrNDAsCbU1KrfgrmfRW1Aa1kQ8lv5LvR3zISOU+HhDDrBhWZgCE2YxXbSkuK4CcGuq7Vt/vnegYv6h8eE+n30abAR/ESUG2poMq+09V0fYjt60LIZ3J1znUQYLrN6VPVfQO1s5rmPomdWeNJnEnS0/3BVliWiVahNPN4nhWg6TkJaYXxsSzveqCbLmr1uSI1gluGNRQNgGdY9OpGnb1N6/+qOdUYgIe+x2xoMO5Vlp+3s6S00eMBIKXtlVji680qHh/P4HoVf5heNeTOwgefSGt+IeCmUzSz/5DzePM7sTIQvTk+ul/G7aFPeEnTne2mjT5EGv3KhWZ3Utiyxt9wPDcPgmZ5n8ofnkzFeyNeNqr2ToSrD+VFEXAbcaQqXjTezWwb+FQYCuz8Lawj2WDBQrXI04nejzcgheRqla+BWrEbjDa9dFPRMm4M2oVGS/x6vi125+cvQabqGpk13zOXvhltP6U+ujxOvyFWQyQ5lNLCQjvDwdNq20qKbF4ZSzITHQ9iB4v638jLgWpCGwTHDc3MDZqXApJyzYAEc0e930N1JkvCghTziiyRkEKkjeoCDOUTvR7MYCbmQCAKwQ9nVJY3XWnqJML/X/cK4khXLIWddsNwB1vSCUyIhc6OR/Y38SS1rmItA52jNDW/vSY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(396003)(136003)(39860400002)(366004)(38100700002)(83380400001)(8676002)(86362001)(316002)(66556008)(66946007)(4326008)(6506007)(66476007)(186003)(41300700001)(6512007)(9686003)(26005)(8936002)(5660300002)(4744005)(2906002)(478600001)(6486002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D48sTnhReyblv7xTcQE8I9ct9XGNNSiCRL8lvx6TiVbuKrISO0YSScutfxaM?=
 =?us-ascii?Q?GRZqTCo719UVafuMQgxsiPegKb18RuT13xYVLfLdf4rDPXWu+k60Ye6Fqv1a?=
 =?us-ascii?Q?Dk6386mO1pasHU188wJusTUlO12SL6WdejZm+WZ6A49ZlM37uw1wyvkfPpKm?=
 =?us-ascii?Q?u9yNReEgu9MiB/h4FL3GWjpHHEP4J5sLMEbG3COfBANNkUm7CFDcHT5D4cEe?=
 =?us-ascii?Q?VVqNWCjMKTk+qpFGJQEjtEdCLnf6QJLeNHBO4TbXqXdVZF88MeO0jtLFfhBL?=
 =?us-ascii?Q?5ZfzIYUiPWg3/34wuZxh0ic58AZ2fzoNzR7RJTfjtOfCiUzPfwFSAvkhbrFV?=
 =?us-ascii?Q?/Y0kkUEFbTlp1aQhTM7vHcz/VafHRIu6tZS+yUjqH/1Hv12oXqBQ8C8WtnlC?=
 =?us-ascii?Q?Hl+7HDGBXvyCTEH2SF84XTkS4Fw501uv4PGxdKt3BC9Qvjnz4tmCXtQjKmB+?=
 =?us-ascii?Q?rQYYJ2kAh/TpmNPUzCNXxksYkNewjCKWboH2MWg6orrQ6gLf08kFiigoac2w?=
 =?us-ascii?Q?/05GYAQlF9cKBo73/0n4GnkQW7GJ6hqKyT7X6/56o3K0IsGRosSs98hyAqWp?=
 =?us-ascii?Q?+E2F3a3Gpd4oknPCZ9uQhrijq3v2JOjlJiYnNb7gMKZOSvUyGon2cleYMl7n?=
 =?us-ascii?Q?HzztBjVJuSOKTpQGRDipSOEAE4aNVrFg2vh1IIGCLkDIqLNTRO553c+qTXwy?=
 =?us-ascii?Q?2UaVwHS/B5llIseQCzJ5EQV9BdRj9k20ZCYQD2hPilan8bTG9RnughBPFfeY?=
 =?us-ascii?Q?74l3+v3Ku61CakaZRsULlRLDnHi0afarTDKH72lQjW3Gws8eQFTfdVxGYOcE?=
 =?us-ascii?Q?fOZBD0Vk7fLnypkw9TAv8rTE57eBLR2MmYuedGX6Pwotk9Nsi2P8vUMrDISF?=
 =?us-ascii?Q?CHWNvnBeSKgBgkbNX+DUWTr9Mz8RoVjQNdR1WK3xA4k0t4/l7lSkAy5RDZzX?=
 =?us-ascii?Q?FmnZx0S1ig/gqWOeVpwuNKHpj8HwDwsO96r/csPw1NJMgTBCr5NwkHUw6c7e?=
 =?us-ascii?Q?aq8rCUvuWg1tpHNXnUqnxBiyw6gH5QGSRgw5ZQSFlFyMjbrI/+X/Ww59pwWx?=
 =?us-ascii?Q?x7vouHE6wNsydOTxTaUJkXSwUPSjXlN0dKem3U1ppV0bZpI3CahVzDQDSejj?=
 =?us-ascii?Q?RXNfEMgtXjZ8Dnt51M8Jv6ceBtqSxRG5K1auVxBTVzz3uFncDCRI5NEyHip1?=
 =?us-ascii?Q?9wKAQEmrzPjC/EtKReRsRAevD4RtiyTDzYhssCgj+n+L8JVV3Lmd2Qc9l+1e?=
 =?us-ascii?Q?VkeKLUIsCrG61Z+59g2uuhTDfKSTlG90/d6c0R3EdC5k7/W5PsM6j3c/tJO6?=
 =?us-ascii?Q?Z9F7uxkhs3k6R60Cx7rf95U9t+zufAZ02DEBgDJclXVXdZk6Dg5f3pSAxQ3Z?=
 =?us-ascii?Q?ks8I1KDgGCI6F9DVzGw3xLdQwlYuYNuIrZj4UR0vxTjYHHDQD0JSzdo5LbbY?=
 =?us-ascii?Q?psj8wW3nGOPuYQGicrlkYg1ocR+bzhhzmu8xzEaYjcizmiGxzgfezknTRFd4?=
 =?us-ascii?Q?urErpnxHhtzjeUyT4RKVApRXBs6VeB50CjZhPGG3Z+65Yt1nxMiO1GRkyFEO?=
 =?us-ascii?Q?b62qWASMeBovnb5V4nNZGkNbn9ZACfSDUZMMAQfzdcg4uYJn4RvIiDgPp2c+?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a950245e-e563-4c50-b3d1-08da7bfcf577
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 00:52:40.7677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L1HlgTKslw5iL/obY82sDQSOz1TbVEEts+qTnJmyAF/xt2/9xBFcD3kT6ixWTYmvbgKxV88cdlkrb10WPDsAz6G4t5Jeva2uqWCaAgqrWpk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2327
X-OriginatorOrg: intel.com

Miguel Bernal Marin wrote:
> The modprobedatadir is now set as a meson option, but without a
> default value.
> 
> Set the default value if modprobedatadir is not set.
> 
> Fixes: 524ad09d5eda ("meson: make modprobedatadir an option")
> Signed-off-by: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>
> ---
>  contrib/meson.build | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/contrib/meson.build b/contrib/meson.build
> index ad63a50..48aa7c0 100644
> --- a/contrib/meson.build
> +++ b/contrib/meson.build
> @@ -26,6 +26,6 @@ endif
>  
>  modprobedatadir = get_option('modprobedatadir')
>  if modprobedatadir == ''
> -  modprobedatadir = get_option('modprobedatadir')
> +  modprobedatadir = sysconfdir + '/modprobe.d/'

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
