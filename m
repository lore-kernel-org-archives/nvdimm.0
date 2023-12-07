Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D4A33C4
	for <nvdimm@lists.linux.dev>; Thu,  7 Dec 2023 03:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y0R2wWDM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701920385; x=1733456385;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8rNlFj6x0HbHknYB6veRNJL2JXotcWNT8B5WnFHnVVk=;
  b=Y0R2wWDMstXDoSyHOohYt7E+UsxnK648bcjj4k+JtnlOPqGmIpVOZd1Z
   56D7b9hYCQ9LeiYKLw9HeudbU2VClMvoUVnHjaqq4UGpiuHN+naAxuH1l
   1w3k3OOLNwNSX+kHCTxXt36cwmVF5uIHQI9eWeFL7PdFOwYrp7ICP2EMI
   llBu57gQrUHjWCibxsYPWZUhqMeznMn9b/FvlP8L6vKBaiL8hTZw7CHiL
   dAcv4XopnzVTTBuRrVnP9Objk/+u+7rwl+w+CuXkW+Ogv43XQduC1ctWt
   w3VaVc5PGTChqD56UtiZQq+d6+8Bv7mOKUnKItcWkdmaIGm20vdvIhcM5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="393038891"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="393038891"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 19:39:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="19548926"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2023 19:39:45 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 19:39:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 19:39:43 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Dec 2023 19:39:43 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Dec 2023 19:39:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivrwcw/KZpsphRNisYXzDJGxqEtnZpo+91RYkSGdFCg9O1loxDVOumHnRttagvEzg6qqbqzJm8i0zO5tZFkxok40gy9NOIjV0TPfFFxh7EPaTbjoEAs4tKNDwyP/64rhvD/HJ/gvIndeWzz86HzbgIY8YLSckb5o2lb9t1JC8o3Ks/zSQ4qerZhrFD1bbpqxL2SggtotGDjIDri0t7OhHKD7R+vOdmqo/eSUUUbEpPt2Oxxh3z72SE5Tk6bxHBYreMyklXPgp3UpW7i1EZ1L2HtwMXmWO5T/0CJLCIEnv2VIF/2YJUSOyoENB5qjM4AccL4ZuqGGPb1c1/Cmg+3KDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Puulp3rGDfK99EP15+W41qiWk7Bqz1XUcGY+eVDyV1Y=;
 b=m3ZHiB9ZsJdFZAAylmBj3g1I9tGTHO6zxRj1NA+HQB5nuTd2E4UHWCanNRBll3wlxzfoKc6nUKhqepwonil2HO8Hrg3+IjGsob3fVGm+R/BxlyLTg7n2Jo5sIpi+VE5Hk++DEmkR1soS21HYDvHB/RZumYR80BCMtbaZ3uaGkoBq7YKueAG8ex40RsqY8yBblgatDb90pXtk4emBRS64V/jv+XYOtGbheTIjHbr/hIanCokc8LojtW5U9lQQWiv1LBdtK862SNsiwc9TpjszwKXr/sSR1FQb+wFmBMsRsX7MaihrKGlXA3Xw2tfNuoZsgYDtUwgkXC1xAswoY9FBXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by CY8PR11MB7011.namprd11.prod.outlook.com (2603:10b6:930:55::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Thu, 7 Dec
 2023 03:39:42 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::da91:dbe5:857c:fa9c]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::da91:dbe5:857c:fa9c%4]) with mapi id 15.20.7046.034; Thu, 7 Dec 2023
 03:39:41 +0000
Date: Wed, 6 Dec 2023 19:39:39 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <nvdimm@lists.linux.dev>
CC: Greg KH <gregkh@linuxfoundation.org>, Yi Zhang <yi.zhang@redhat.com>, Dave
 Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH] tools/testing/nvdimm: Add compile-test coverage for
 ndtest
Message-ID: <65713e7b2b509_1b283929427@iweiny-mobl.notmuch>
References: <170191437889.426826.15528612879942432918.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <170191437889.426826.15528612879942432918.stgit@dwillia2-xfh.jf.intel.com>
X-ClientProxiedBy: SJ0PR05CA0141.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::26) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|CY8PR11MB7011:EE_
X-MS-Office365-Filtering-Correlation-Id: 395297aa-ed81-408f-b1f5-08dbf6d6256b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pFL7F9R24mwuE8mBO5DML5v6jlO1q4uYsDJXZoRjX1kbp6VHzb1l8Wd2LwM0c6VnuEmppU4EI4lQFwA27+BLavvEIUQ5DHbt60PtEx6OvFLoZmwlqHdlCW0rVloEPJVnrfqJVfAu2jDhipwvPygcOJFUXBDRpYYYJHYb4xgRur1fWvtb3UkVCVsK+IWC+6g4ZH1tvN2ovBBa7k0h/Lc42lvaIdi/ucgykIoZFogcwFs4rSUvKytv2C7HjDtVVSiub9vZNL8JN3pcQzi3tWToD0ONRwE42F3dnWcZIBlmHjFKIUdg8HZ66McKMwg1Rlp7DQk5PnOXiVyQaNOIGJLBiWON/06eUovFiodtpcgIdJCsoQqYqDUA1J4X+h6ykKjkhCSEvzOw3O/qqM4sNAYb0yDNu7F2KYqpgrCSKQGq6fl1h+EXxpp2OGCf19HY3Ix9LkeYz+ZbGvWQya/zJmU4udP6HjgH/u6oPsOAxpktu9gUkUC+keazwPGt29Py08eAX9O+gXB5xTIeorL141RCRIGHoo780xcMaAkvkZRFxpM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(136003)(396003)(366004)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(41300700001)(4744005)(86362001)(2906002)(5660300002)(44832011)(6512007)(9686003)(107886003)(6506007)(82960400001)(26005)(6486002)(478600001)(966005)(38100700002)(4326008)(8936002)(8676002)(66476007)(66946007)(66556008)(316002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aFbdBKlj1J9+wxECwn13Cbn1GkuLRasdHuG+C+Plxc6/jtvCYjp5zxii1CJG?=
 =?us-ascii?Q?WINBiMjJoB/RYk4IU2av3x2SC6yj65G9m3sz0Kbzorv0sQEmF2/xNI+8h2sG?=
 =?us-ascii?Q?LHcXZuT5sWtDZ3a/oyzzkZha1L0NkEpbk6UNO6E0D80B2hxc+7Vx8qss1w/y?=
 =?us-ascii?Q?a0gQftEF9OD9tjkNezQMIUu9OpbrfoFbcj0TplcX11fTVTHh7qVRN+rYMPgj?=
 =?us-ascii?Q?LJXJa2sQnhwV+y4IsOs9nZjjbMLwAPyIp9hFhJh4LxeSsYTBZBe2hJAlS/1h?=
 =?us-ascii?Q?1C7V2RUYmoHTLnfkZ5P8O2fqflSDBoinYFcHlkpUTd2DDgtzQ1L8lWJPQbYI?=
 =?us-ascii?Q?6v95FSwZh/igSx5H6QbSlqaabX9SOPPs2motvsvRWYOoCqPOD5o5gp0XxDLK?=
 =?us-ascii?Q?HR1ldQ/Ofmr98A/vL9rRQqrdhwWqV+t6OcEdT+dZaHJXxx6lFHfZAOe622h+?=
 =?us-ascii?Q?3l6LV89CeGBtrf0iaWwpgu1w9l3+Vk4M8WjErFiy7HjV75mdi6DBKqO/BD40?=
 =?us-ascii?Q?FH2Vh3RFNH3J3yUgb0S2A3MuX92cCFUggIyf2hb0WrjX6F0W+bLUiWIS0ntO?=
 =?us-ascii?Q?s7knoEAMSIT1FHBwYmKWegMVRH4gUH9ajgRBvjvicEp2WB71GqDtSr3+30Ly?=
 =?us-ascii?Q?anSD4WN90qbMruFthYMQqZdEM20Gez8lTbeJqGBVYnSnlBqSo2boMbaFLSXL?=
 =?us-ascii?Q?L9X5HYnG9AHqmdM8+SmTl8yYxhMPInJ94oBjXKLZOl6wU7MJr/MfMkupjWLW?=
 =?us-ascii?Q?f5Ir3WXPdnGC/YVCRO5vhh9vUiJlLO64IRpyPUvAHRmOMBda5nqTI0NnGn3E?=
 =?us-ascii?Q?xrgoe+hKDU2ez8G+DNouzl43DNqJFE+xlBRarSpmDrS1bkHCclcCkWHGMTe7?=
 =?us-ascii?Q?n6+UNg/p1PJN5qJshO2ZBQ0KHQ2OXeBzXVr+GtHEgGcbb0xRuKW4SjpRFn64?=
 =?us-ascii?Q?XEFsS/EsPRZFzZf6xAfns1mfqOFge6RRIrGhb3m31ptw+0M1Dram456nv6pq?=
 =?us-ascii?Q?8k2p0NaH7TA8Xda7ZoU+9/x4v2xP+JWQ0XltNvWLi4QgeCtdcdWjoBdDBekz?=
 =?us-ascii?Q?uGY0QBhXvmBEWg2bQ54X+KO3CjgPg5s6qY+inX5Fmt0AS8+RbWpWZJhZXhsB?=
 =?us-ascii?Q?lqRoyWMsxqth1/BvZCQz0+x+wRwyZ5EMksHmHykfasOgt9bBU+MyEvTZC7Ox?=
 =?us-ascii?Q?7lONdbIH1J6s8sdr6V8nUMdiBGxih1O/T7jS2Y5LXKhnAM85j2tMmK8TdoWn?=
 =?us-ascii?Q?E5rAPsaa3auggq6f/8OsLEZnSBTYCuSUSpx3yVYb8ZsLNST68kbW53SdFrqY?=
 =?us-ascii?Q?0FClxekD+tckENx0Kd3ebsgpOUfezG5fR9LgLvypb6VScKRIohU2Of8ai6sc?=
 =?us-ascii?Q?6jF7iJOlmSki5fppPLDhMYsRA/si0CknBZjlIWJFTaUyICE3gKGUJ3M3dZ/B?=
 =?us-ascii?Q?Q1DIOkt0XBHh1wpUKD8UNT2IvGXRhM4+/rOZgQ+JZGNeWJgGJXOehBBXs2eL?=
 =?us-ascii?Q?+Pa54Az0Iu9sZY+AvVDFm+2NKxPEbEf64u+M9K0AbeeGDNCefKgD4R730nn+?=
 =?us-ascii?Q?/5ak9PTtCUens9hTvS0IJRv5MkfRt1eBsUwH9CSJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 395297aa-ed81-408f-b1f5-08dbf6d6256b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 03:39:41.6261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tdtdZa/irTC0EHhgBXwTjoTVN6MnOX+lIBynvvjLdnjT6iu30t4sleG8aL+YfVe3EQD9PhXtqShrwh2b8vVLHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7011
X-OriginatorOrg: intel.com

Dan Williams wrote:
> Greg lamented:
> "Ick, sorry about that, obviously this test isn't actually built by any
> bots :("
> 
> A quick and dirty way to prevent this problem going forward is to always
> compile ndtest.ko whenever nfit_test is built. While this still does not
> expose the test code to any of the known build bots, it at least makes
> it the case that anyone that runs the x86 tests also compiles the
> powerpc test.
> 
> I.e. the Intel NVDIMM maintainers are less likely to fall into this hole
> in the future.
> 
> Link: http://lore.kernel.org/r/2023112729-aids-drainable-5744@gregkh
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Yi Zhang <yi.zhang@redhat.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
