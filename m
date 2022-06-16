Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDC615B7
	for <nvdimm@lists.linux.dev>; Thu, 16 Jun 2022 20:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655411442; x=1686947442;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=RwX1zHaExWyu4whAoN7450IMitmDOdU5NmaD34NMCFI=;
  b=WGVI+EjSC1AXgUlWFdXFfdsJWTyTkeqB+DBcVxEchOd3DuhTU5+JIq/n
   jTxsDhDiRDgWFM5cBeak/yD4wxFJhetm3u3f5IyHcO/oN+ZRyfotjS5XT
   4qDspEt3kfliv4nqphKi0ZI4PgIPJe8D6xnDLXla98ipSB4UwgXALMVdA
   yRFnd4SfCVRYteAXhnP9V6A0rgCk0xbHFh+2547If9d/Iv5l0alsp+oqB
   9k6O2raBl5ZCKaWzWYrSQhqOQxevT6rJRdxo9vqDEdILpCr0pY3RA38Yv
   T3NZVCd3ZrzepqsTCLVxlG+BU5ZtYddFzfdTDKrycXXXA3tpZi+HuMpw3
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="278141594"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="278141594"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 13:30:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="589800886"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jun 2022 13:30:41 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 16 Jun 2022 13:30:41 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 16 Jun 2022 13:30:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 16 Jun 2022 13:30:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Np3HAKYU6vqpGd4nx0zXI+kVQR5vkCso5OPQM1AQbH0StBhcEdVUM+IM5ajt1D9Hg+aGuTqXTGb6ipaIRrVC2q4kqm4M8nQMYt8/zSYZma8iQDlrfxn0/6wQCg72RhpQnCiM9T78jGVDrVM+q32AZyxP9nBK9HmdwMQYKZDoRLH1wnKnWZX8Tb6l0f70B2Df2YsqhbMb9lDRGreoAOMZ7oPo6XPCFy+BjWFVB7/p74oVxEIwZlKsm8XIxuQ6Y2N/bwJZ6IOeUvfHPYcoQ9pFDtfcpqYmXom6FDHWk8ry8Hb+G8f3Hc6IL3Vu2PBGym0mVhS3Sw6+EqdlLY+2UGFmSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8qivTynn9/sTF2GDfR9e/rAKSc0A5bG5+cZawrTxTc=;
 b=ocgOXU9WhgBJhisPnPOAOQ7ccRo0id1BBjHNXKLbd40eTGX5hWLhcq33hUqevH+EFQc7gmrYFmeUQUcqKaZauzw7ZH4gV8agUS4v8EYq5Wq7CU4vXawQw6GZ8FqlG/lofcf0T80gXNL3escPKhXw12tjUmW2usqqLUjzoiKPHwdpk4rQWLKvwXAfcsIS9qQnUKectaM0mP2BsO4a5KApBiEhcqc893AAnz5rmoJ/MVnE1sLEcE7w08ooelarIt1F3i/dG4Mn7h+YcU/exyz6kKAFb8hMg9wn336rbWaultMQE3Q8I6ABswCCiKwacwaBEsAp7tIUN9WK0wL1aYrnIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM6PR11MB3242.namprd11.prod.outlook.com
 (2603:10b6:5:5b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 20:30:39 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf%7]) with mapi id 15.20.5332.023; Thu, 16 Jun 2022
 20:30:39 +0000
Date: Thu, 16 Jun 2022 13:30:37 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH] util/wrapper.c: Fix gcc warning in xrealloc()
Message-ID: <62ab92ed68a0e_734c329441@dwillia2-xfh.notmuch>
References: <20220616193529.56513-1-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220616193529.56513-1-vishal.l.verma@intel.com>
X-ClientProxiedBy: MWHPR17CA0051.namprd17.prod.outlook.com
 (2603:10b6:300:93::13) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89475ef7-8980-4c60-1fae-08da4fd7137a
X-MS-TrafficTypeDiagnostic: DM6PR11MB3242:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB32421FE2942F7EBCBE22EA97C6AC9@DM6PR11MB3242.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MMoHciIHTrOnghQvrW0wTJvClsI/ek29p7DA1T7V9G/TkhUSWfmjavGt86mo1gOFJ+VfeqoKh3vTd1ZmAZEzfwFxNQ7Lk5TdT7zH79OUnSb1fzFaWr8KckWhZVU20P1x+i5JALVV1AlGl3InB01wp2R3VUYcuLaCYAE2yYHyMIe3yOT5/LhIiG9qXj4smBeB9tT4OdRd7esxG8LtdvrKT+MtdAkDnmh+/O9FewgJOls/uabb2wm1946i1roPwzlPFNvbp1GSARSHfJzuNeNpnjwzBnVuxEPkDawmLZSGZH641srCV3FZcgP1roYnURZHaIlvBdE7qMAtGU9QbxeI+thxfkb/fB3ejc05qhCRDA94hfnM3ZvrknxlUugGRIlfFURupZ3tXclvW3eJkqPiyhH55uma6MI+7Hhy2zu7KLIGNL4upSfX8MOA8DWb9rK61tLiu93KZAMv3hDXG0WDFdozsDSTsmfTGNPyguDzQiygUrhnuXPWBw17Bhgr8wlGHgCGC7Zpbzs7PW2Y74YGuC3Y+dG06w2bR++h77P6zahn6u3p651C4+s/JIOeGZFL3lsmJRdOEEOwMqTGQXmmxzo2iY3C7i7hrn0fPbxrD+JtKsudhOhw2rQnU6DJn4MfkKQZxOVufV5YuUcy5C00cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(26005)(186003)(6506007)(107886003)(316002)(498600001)(6486002)(66946007)(8936002)(83380400001)(54906003)(8676002)(66556008)(4326008)(2906002)(4744005)(82960400001)(6512007)(9686003)(66476007)(5660300002)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1RIKzdQV3hBWEVsNVlZR2ltTmc2RzNrazd1U3NSM1NLcFhnaUdHZlRVaTZI?=
 =?utf-8?B?MnJkR2w0QzZoWWJzbWovOHlpQjNUbXRqcFpSK1hWdkxhbzhCREZJWlNLYkNH?=
 =?utf-8?B?RjU3NW16bGFvTEpGZzRyTW80RGkvMEo4bG42OXF1MVNobUkzQlIxdXMxTDFn?=
 =?utf-8?B?RS9VeHFpRkRIUGl6M2pBVUZPZkdpVHVwSjhodjVFOGNNTS9jbmRIbkNYTkl0?=
 =?utf-8?B?TGhSZ0ZxTGM4dnRiSS9SV2NjZnVWOERNYU9hcEsrVCtSa0FoRlpQNGdzYnJR?=
 =?utf-8?B?MTZ6bitRWkMwc05BSDZzRDZndTZGdjFKemNEVDBDQVZFQjdta0NtZ1JTbk5m?=
 =?utf-8?B?SFpaWmFKOWZWWDcwQkRYd2YwY3B2WHFnWStESVdnOUo1MnhTQWg4QnJkZWJW?=
 =?utf-8?B?a2xWRU41d3hKaFpvNTk2dGFQMUUreThYSXNrN0syaGh0UERXUC91OE9Tbkh3?=
 =?utf-8?B?MjVwYnNHbStjSlZ1UHF6SU9WZGFkbkoyS0Fqb1lZdENqdXRxeG9DVjI0UjRC?=
 =?utf-8?B?TXVBaUhraHd0amcyRVhsTC9oUnBWZ0dqWDRKZm1CRE0weWN6dExnUVMrYUNo?=
 =?utf-8?B?QU8rQnNpUFJOL0JDZUZCMHgxR2dvY1JDVHZFTHlia2hTOFBnK0ZyRkh5NTZl?=
 =?utf-8?B?SDlpbkdiNjREUjhhMGtxbXdVWWM5dlR3djRaRWVSMlNiU3ZJTjc0bzUya2hH?=
 =?utf-8?B?SzBPVnQ4c0RqekpmcXMyU1l4TCt3dWoyOWlrNzJ4cnF1ZFd6SkVvSmUrMnFw?=
 =?utf-8?B?cjY0UVdxekhUNGhzcmhJTjVNeExmbHVtQmdBVzR6V0s5aHpobCtxSm1IcVp0?=
 =?utf-8?B?TTFRbTlrbnNNeThsbnVLL2dJbExGOXh1bkFnamd4b3BsSjNtYnU5RXJTN0o3?=
 =?utf-8?B?aGlHb2tUMW5kckFIUzgzQ1JRVGVna2IwVk1YRHkyaWkvclFRSEZVRi9YY3Ir?=
 =?utf-8?B?YU9sWUpndWEzZVZVRlM4amhDQ2xsTmtuK01mMTVFTVMyOGY2aGk4YkhFS3Fv?=
 =?utf-8?B?bDdoUXBmTmZVRlNCQWJmNXdjUFNFMkJRYzdhQUtEcVZXWENISXFYb3FOMjc4?=
 =?utf-8?B?N2J0RVkwMWIzQTViRjVpNDA1YVF4Mkd1UCtmcHBaVUxSQVdaeFNUYkVVZ2Zj?=
 =?utf-8?B?MUVtdWwxODRNMkpLK1BiZUNuQVVNc2ZGRzhycm9MN0ZRaGIrK3lPWFBIbUNN?=
 =?utf-8?B?TWRSaWhEemRVTm84RWNSTVVvRndObFl1ZXNJL3p6Ky9ZdU15WWVVaGNwQkZl?=
 =?utf-8?B?cXhuWTB0aU5PQkF4ZjkwRnRaTXBOL0F0S1hBMEtMWHRPWW81VW9BRGJRRXNR?=
 =?utf-8?B?OGZIYmhKblJCUXRycVJzZkIzWW45YkF2cnVBcERMcFJsUHpsWXpUY2RiWTJI?=
 =?utf-8?B?c2VqUFFNeDR3ODlNQzF0VStPV0NVNzE5d2pUV1owNS9EZjVrc0YxOEsreVVT?=
 =?utf-8?B?UGFZNWhlQ1k3WDRkNFpPeG9hNUNkRE9zTDh3T21CTE9sbmhFRXN5VFFnZ2Vu?=
 =?utf-8?B?bWdaNG5pc3E4TVlsUXdOS1VSS3JtUDZlVXo1Q0NyWWZtaXBoaHNIZXR0bExi?=
 =?utf-8?B?blh0UUd1QjNXdkIwanllblRXVExtK2V3TFVmU0VaM1R5RmlvV2JQMlVGYzdF?=
 =?utf-8?B?dzNpbC9Id3JQUVBUdHFBSXcyWHpNZDVPaUNEcEhJSHgyMDFGaGRoQ3RLcHBt?=
 =?utf-8?B?OVZZWWdlVXcwR3pZcmFXbTdnOG45Lzc2TGh3ano1QmhWV3piTmNkSXh3N3dh?=
 =?utf-8?B?V2Rrd2s1UDM4TGlnYzJ6QklNbDNrSnpIWDc0RjI5UFk5NFlUZzArNUFSYlpy?=
 =?utf-8?B?ZXY0MGxVcExZT1Fta0cwbkxsTTRvT2d0YnVLVnhtTDFGQmRXT3VNc0NNejI5?=
 =?utf-8?B?cktoMWVSYWdaZzNuMnpNMGh5bGdLRmpvdmZQYWliZE1oOWF0eWszRjJldGhi?=
 =?utf-8?B?QTVMOEVNQjQyRTk3ZWtIcjFxa2ltODhqUUw3SlBwcm1RQmdlcFpIK3B3RU5E?=
 =?utf-8?B?c2x5Z2VPVVdXQ0lPV0plSnNMWVlKSjhJM1pKTTZiMlVzS3FudEsrUlNwTlpG?=
 =?utf-8?B?ekFHcjVaL0ZQcDdpWlBsMStvSGdoTjNUYzdsWkEwandXNTNpS3FaM2tpSkZN?=
 =?utf-8?B?N0dEemx2ZVlQdE1SNmlnMk5rTk16UlFHUmgzVlcxY0t2RUt1TGJpQUNkUkxX?=
 =?utf-8?B?ZmR5ZUVhSU1FQVMrK1Z6QUVqZVNJRUtXYnpydFBLdUJKZGluUjBCdDRRZEg4?=
 =?utf-8?B?Y3VHUGh4V2dVMW9rdjNYWVZ6U3VHOHJuaStyOThEVStNcDR5bkh0ajNKZkRu?=
 =?utf-8?B?THJMUVRHQXZkeHZZSWR6R0FsQU4zdlEwcDVNV2grbldzM3FFMW9qOFdRWDJW?=
 =?utf-8?Q?tg9EIvz3Y/Zvj0QU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 89475ef7-8980-4c60-1fae-08da4fd7137a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 20:30:39.0929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pbnzjClLHFLl3BMnkR2yfsbP0TRtnZL/ZOezzBKlf/wZiGSjaVmsjPQ76/PfyNW24Du00mVs13YjDq9ba/Za3h0niFKJZ7bHSkGRU6KBmlM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3242
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> A GCC update (12.1.1) now produces a warning in the xrealloc() wrapper
> (originally copied from git, and used in strbuf operations):
> 
>   ../util/wrapper.c: In function ‘xrealloc’:
>   ../util/wrapper.c:34:31: warning: pointer ‘ptr’ may be used after ‘realloc’ [-Wuse-after-free]
>      34 |                         ret = realloc(ptr, 1);
>         |                               ^~~~~~~~~~~~~~~
> 
> Pull in an updated definition for xrealloc() from the git project to fix this.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks like a faithful reproduction of what upstream git did minus the
memory_limit_check() infra, but we can think about that later.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
