Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3A5D53C
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 22:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669934669; x=1701470669;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bKbKX2sdVLqlAMUCv7eU2XfCKmHd0aB9ItuTovt5V/w=;
  b=gUngk5HDFg5ocR797/oOX0jG2jt16McnpCGd9CllLMpiyeQu7zr8Tiub
   I5x2g+fAVEHZxehXxCEiZULqS5mG0bRuJ4Gli4mAhG3QacY/TQKc36d3Q
   21BpJE2CLhhvU9RJCp4qUelvYIsK1RZlQrnVFiZLOeHERH794RiJ1Iuov
   V6VQwsZdNKKNR/duwD6a5aAlJ/t89fFEK48aRdMy7/kjY3vN2fvJQjXaC
   nrhsZ7+73uJ0+O53xdhHeaZwU6xeMzP9FBfwOMCfxnHjt11z9tZsi+gQ1
   9SX8Lw9yNEAAwkfU9HYyLUBUP6G/Y8MsVu75FRlWiHwBDlz648XccMyAx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317682417"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="317682417"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:44:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="708252946"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="708252946"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 01 Dec 2022 14:44:28 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 14:44:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 14:44:26 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 1 Dec 2022 14:44:26 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 1 Dec 2022 14:44:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dt9COhoZ0M++jYHJ+MfTOlJMbKsAbK5BW0xjnWnwjJiNg7x6CG+EtG9Rjx05/A9b9VZ3G/3xHyehf91FxwW9rGUbedkCOFOhxCdHNyx/+sBB+ntZWCoEKFtHMop6SZup3Ce/lGDhI+v/1B4ZKqwmyAoIxiFzlmWmoOvRN6kg9bdwZ4LFyk20279lCCPvXSUpEKu7cIkBH75AyJJ438HJu5RF6KdZ/FjaDL487jHTNdACft1iELfLO/FaYoJ09DfhPPXJzBElM2sJA4a4yPmw4ZtUfMYJoKoQTzTsCrL1m4Z1E5EuHEKtdCCRxaTGNLWoy0z3KIuZ1EQmFJSn0/tphQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=62m10oEn4cxNfesOjbzxhC+2c5AFuls7tvksX25n9Ic=;
 b=jziMg2eZWrNfTczvsv3eGSTKcx8Q84niFqM9QQkHaE6lRY1Ot63C5xh299zGN2UGdAy/58vVbFDVgSkJ4N6BpJEERDWyN5BhxNckuPuyJdv5wOTE0RDDOQZQ/MDdW3TeLwEoHSR+QMu1IgUb/q+5kocfNAKBzvPJfGiowaP1b23YlA1hOSvy2h9QWn6UTPeJe4rG+Ok4kXhw4uFz6ddOCmbOXIxH5vfpgjOVG8CRsVfm7QeR4G8c4eVZBUjcCZ9V+bk1Oi1MtFynZ0hFNnbnECFs6l9rgy2oLgHCNAq9IE5RXNE+u5kvGI8v2vBkQbDVAfxUa4MgKedXPUtzW6jD/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BN9PR11MB5404.namprd11.prod.outlook.com
 (2603:10b6:408:11d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 22:44:24 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.008; Thu, 1 Dec 2022
 22:44:24 +0000
Date: Thu, 1 Dec 2022 14:44:21 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, <linux-cxl@vger.kernel.org>
CC: <Jonathan.Cameron@huawei.com>, <nvdimm@lists.linux.dev>,
	<dave@stgolabs.net>
Subject: Re: [PATCH 3/5] cxl/pmem: Enforce keyctl ABI for PMEM security
Message-ID: <63892e457fe71_3cbe02944f@dwillia2-xfh.jf.intel.com.notmuch>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
 <166993221008.1995348.11651567302609703175.stgit@dwillia2-xfh.jf.intel.com>
 <6bf9b135-2bde-26b6-792f-d699eebfde3f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6bf9b135-2bde-26b6-792f-d699eebfde3f@intel.com>
X-ClientProxiedBy: MW2PR16CA0043.namprd16.prod.outlook.com
 (2603:10b6:907:1::20) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|BN9PR11MB5404:EE_
X-MS-Office365-Filtering-Correlation-Id: 65e8b1ca-a9f7-494c-1019-08dad3ed97a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /gopClkGSTmjlWmv88QazG2M17XahbxthQlGk8fCZZkG291zKnFCGq+tqj0KfgTVH3Aq9KMFRsH0S57UGDMmME38ZnQmk+CzoWJ8t0HSSCUv+njdqPcU3AxziCSaklQHzMuc595bihqm3QDz2CB1wK/b8naJblUeQMzDqY2dpCTHPm3ftMj+b8zaTMsL3Kptp1XHwL/hJEjs2yWsumRAL5ZS5Wo5C6rOIcYGVPQerRVLgX+7ijwOXVaGDXLv8rVhsopgWLnvYYFKzv99JCx551+ndZDdzFm9Mtz8SKUcvUX/5OOtkIVPX6acCLZewGcOuVFtnF/EbpvhXqF/FXDk8kcwnKZReU/EzS8ElC1PFqtC9A+QggoWHYsTZk59H16Xr4S52nfa38XXdbD99vyqqXwXQhXQddBBdzgTp5AEbu1FvO6kbafZowondIJPv13AgI4Dl03YcMKBCXG9PqgzNMa19QuzHErHjaLYuGQNglT+3d7PAXWrNCU20AQCll+R6Qd/d0xREirskqnE2z64LVVzQpqyEgxXczoWhgJZasbtFQE1bmS6bui2jHMkJAV+sXy7Dmz+XJFoDV1G0Epcsc4QpzeSuZ10A6nmZ/PEN/dyemRByMvkDHvTbKJXfSvVN5SGcO7FfmYOBBp4J21zcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199015)(86362001)(6512007)(9686003)(53546011)(6506007)(110136005)(478600001)(6486002)(82960400001)(186003)(38100700002)(83380400001)(6666004)(41300700001)(5660300002)(26005)(8936002)(66476007)(15650500001)(4744005)(66946007)(4326008)(66556008)(2906002)(316002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w0Ok9/ZoaoEDMEWyY/HR0zZjfXatwHOmFq0Nsnpzx29zxdmIwmQJpLRBmCV6?=
 =?us-ascii?Q?fMc659V9j1fSAGmaOJYm2LNiE4ixjo0CU7JbkJv5r0BqAdiG9XJurlfXa+om?=
 =?us-ascii?Q?nYgHy0WYmZwAw2mPUS0e5cmhf3xsWr0My308XHrpSlfyhWhzS0BcLdzzwy0j?=
 =?us-ascii?Q?47IwkfzaslT9t6uAyYo7GbkqqmIkzpsPWFiiqOIsfUzWu7JL6CzlEGuyN7um?=
 =?us-ascii?Q?lZydctNwbCQbCdvROUM0BmpqKPWYApF5GR0KGYUjRjLyEoPA11LGaodqBcGu?=
 =?us-ascii?Q?HdHQpBKCfL5oy5VVYkiTqivtfyypzoBrDKXAi+3Z1QGKk9pGd9UOQGY6GzF7?=
 =?us-ascii?Q?p7EU+XO65qd9r5/DTSp/cnqyo+B31MPos9JUlsBBSet8VBKWucYmUH6Tpa0p?=
 =?us-ascii?Q?qN50aFfueCi16WANuEr7rfH/ZnKfk8WjFxCCAUX/ZZ5iUqapWSq/wm71cjiz?=
 =?us-ascii?Q?iquGkjeelk8RemU8OhMaSVYBJmWX7wRCX2euskpEfRjaAv1kg6OF4cHC7wR1?=
 =?us-ascii?Q?mnWDRgg7sJ6hD2xikVoFsTpByoX5/2Ya1C1Lhqj2AcPtV8lwwyYHkFaNWnRr?=
 =?us-ascii?Q?d+OPspeJsjOf9TypgtoAEDy7BMAAzG4/avjmD16UgGS9fW7OnXbxQYay8PNo?=
 =?us-ascii?Q?wJIr7CtMhX6zbBjn0ryEK/zmu15Mr09LPytTZ7g5EJbtIlANdAWVQ4jGKmmw?=
 =?us-ascii?Q?Sn21+c1Hzdkwjcvd/uCHwBwQ9vaYYsusm0gDwi14kYdKHPu6XvsywGPXgUj7?=
 =?us-ascii?Q?u/V4W7GSM/Pi8Nmkqigt4C7CpiMR7SdXI/Yeprlra5z2yk7CuHjt+X1zK3nM?=
 =?us-ascii?Q?gdcFmsrTLcgdCqfzEy7sUKembw48pqP56aC/B6PHAMCbBkLEKyMBL5COdkRN?=
 =?us-ascii?Q?dNz+JKW+vXl6Rs4p5Z/nYkPKdIkC3K+Fr9weV+PyZRW3Ud7Y+i8FfJc1K26u?=
 =?us-ascii?Q?iG+IlxP4oG3g488BakyN90xKE6N8Iv5V37CijS9aH0SCUgFnXwQAFnAkdqEW?=
 =?us-ascii?Q?M4fAiZRHUlnmCHbEGTUOFYpE5aymKrsWTVoEpOivrdc1FJQoFSxz1YYP2jYU?=
 =?us-ascii?Q?7pIFnzH9B22r40wER0jZdwrRa1hVCmYGmC2QT/LzJKcyPKp9tBy/dupqecAi?=
 =?us-ascii?Q?5iHvdtIr1MmEGDEjsPPEP7tCyPNqNzl7hLXRdMIvCGvc9kgp0GX+E2C3vAkz?=
 =?us-ascii?Q?V0fJ7t02u6/fDzETNjP8XAW0X4lg/oxWG5UOcZ5HyxUc7EtWQ7cuQY/EWFta?=
 =?us-ascii?Q?wwblWINgcyoD3cDlYhM8wl1NkLKwm4DDg9C3WdmV6IC4HJHnWUbyX3KP2Ifn?=
 =?us-ascii?Q?gLfJxrlkrxxu2fcGHl+z0Ern7KHFjXQFEdvs0M0M08FWkKGkRLt1mWYJvJJc?=
 =?us-ascii?Q?bekGcCIbthxjPp2eyBS2j6r74LC32GpOnUIWoGEPh5O/Odv/siMp+zfSkNi3?=
 =?us-ascii?Q?OrE1wlVCcwM/sZoirNvbXio56LFdKHmMN9h8hSPvNApTYh2K5VjwxUBNGORw?=
 =?us-ascii?Q?95YEuzvrTaXNyJQc3GBspgXGWoIuFfIH/bKm+Dmw0759sEmlgG/Y+EaYADiz?=
 =?us-ascii?Q?aK7mm2xB0S9HAwYSntfFvWwdJsMiT4ZQp355p+1GElnH1p0Y/qR8NRhCXQHb?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e8b1ca-a9f7-494c-1019-08dad3ed97a1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 22:44:24.4719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dm85egvHkrGksadKmSUYZgRkLCf4zZDJwe/irPHTagNGamSAal5AOI/KAyHZzzW6fYO7SNBtkPdeKcBUU2OXUZrztqkFBnc8SmxksZ6EtzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5404
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> 
> 
> On 12/1/2022 3:03 PM, Dan Williams wrote:
> > Preclude the possibility of user tooling sending device secrets in the
> > clear into the kernel by marking the security commands as exclusive.
> > This mandates the usage of the keyctl ABI for managing the device
> > passphrase.
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> 
> No need for get security state command?

That one is ok since it's just a read-only command with no side-effect
and no key material traversing the kernel-user boundary.
