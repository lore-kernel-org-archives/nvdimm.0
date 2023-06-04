Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8525264C
	for <nvdimm@lists.linux.dev>; Sun,  4 Jun 2023 02:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685846436; x=1717382436;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2dLltq5Z376NVzmZGcR9JD9c06sDgkoQmPdzleMsZSw=;
  b=Q8jdO1Slxt1Du3Fi2DmcsykKoDObrR3N2rj7ap4tFQXptnpKO9PtNtNF
   BqdAH0hU6VXz7ZiL5aJYhIRSM9MPTcbNnq1JeXYi+j70/9KRIj6UnRF4y
   K+f20rnx6GeeTPiyNo7CI4+mFu3j2jrRvJEj9O6AfP4QA/QeUd+1A4sK+
   gYrWeZlJS2AdExO5rt/TAeMahM7UqiNw8seruhHkhmow+t8ftfPv36+Rt
   Vxx8fWb4yCY0vCptNL7GbzQE1Hu4hvpXmch5EsyziZ996N/QCbiVRFT87
   EB0NauzZqyrhth2B9agRoNpIBczBQHlcC9Vh+4vwhnWqJBOcwIaDQbSaW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="421964887"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="421964887"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2023 19:40:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="852569062"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="852569062"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jun 2023 19:40:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 3 Jun 2023 19:40:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 3 Jun 2023 19:40:34 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 3 Jun 2023 19:40:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVlcZ9Nn4mFMVdI9X6kKJciZruUBBTQyxvj7E8T9dN3uGsIixmov2PujYpNQ1JCh+f8sv2U0bG5pCoE3iVdRvNAPSbYfUpfg+lVFlC1DvyNnqEp0hwCEW3PN1g7uyFH2oAk0pxghr2StFHM1NTLYBGmqZBPVuwmxWiXoJiH3dEihuqn4jRh+GNIFCpnuTs4YpZkMrGZOVnzzUBUaxO77hu0V1Pj4q4uTTfmoiSC4UtsQL90mUap+n5JuJljfajx2EJ8cZkSWJLVCZ6FR86EIPbat1Z+FYKJJj2NwvmJf+C8uGJsggZYxh+NujkdmpIiUVg1DUbCjpWoEPsRcUmuRaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5oAnjUB+opddBwek49GMyCZ72FOs2JUoW0afA/fzqI=;
 b=mX9TZm2Cx6YP+1MOS/bU9aZZI/bdcQ2SNO93isLUCSaaQpMpAVCdoSJjbrF+rkPjsKgK1bGTSSOXWuUHEbgHV56uybPA64VNnCCt77lnL0ECP8B0edj+AApTjK0eLUuEu6lLHN7zKLmMqtOtdEJKEVA7vhH1Z0aZtBCZ40ouLyMEzmrDUBjkeE/naA+7iFVZm4hBSgP+ZS2MAuM32wrExcQgKoBtkyaUmQyzDOtMLWtcipz1Bw5MJHDjw3s8CE5arhSDJjmUFLgMwUVMpHFOm/xTH4NCywOUBybPo/DV818c7HULekcD+9tu+xCLM4JL1jjHgJBxF+y86qUrJx9fpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA0PR11MB4671.namprd11.prod.outlook.com (2603:10b6:806:9f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Sun, 4 Jun
 2023 02:40:32 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::9679:34f7:f1b:1e7c]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::9679:34f7:f1b:1e7c%6]) with mapi id 15.20.6455.027; Sun, 4 Jun 2023
 02:40:32 +0000
Date: Sat, 3 Jun 2023 19:40:26 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 1/4] dax: Fix dax_mapping_release() use after free
Message-ID: <647bf99ad95fb_4c9842941f@iweiny-mobl.notmuch>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
 <168577283412.1672036.16111545266174261446.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <168577283412.1672036.16111545266174261446.stgit@dwillia2-xfh.jf.intel.com>
X-ClientProxiedBy: BYAPR08CA0054.namprd08.prod.outlook.com
 (2603:10b6:a03:117::31) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA0PR11MB4671:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bc5923b-55dd-40e6-30b3-08db64a51061
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7orlWN2uuyVbqNm6BwRWgqRnp+V5hw38EqMFAAJfATvtcJjBpWw+eO9hL6jBI1EGMXp7FZhlDP5d0MhKahDkjJCswi2c53aTwkizchmrfaTUHdDCTsaLgqy4p0cc5TtUKut4T+/NlIEuMu230Lwh1VvwM1ivoF2gtfYfO8mTqRy5v/ceK8NdfHmoio9ij6K/rEVRczvhv7iMYTtQ1JOUej20yn2YXB3Kblgn+HlZQfezBDRMaNK7C9rY2h2OugwNSV8gDnJlSoxNze/c3Zotf/vxw95XxKPwxvU2z6Wa9hrMypXAsQzZc8t9PoehXnzVoqDgwPiKl+3I+kiXWIcMhbyRNxHWlmT1AeDskOMVOazwvnpQ7cnIQ5PNBhpgFpabLInvGr1ugO4VTZhdrM99NR8cXW52YID1piCi7xdhApDoF0rvRgkiUW0epCVxmOfEy3Q8fPCuMn6DypIGdb0iIgDy5iB+3t1Jc4I6uyUz4fu/FicXT/vCYdgnF3sgKyi7/TJDdP4Wr83DuEfxqYvddkTt1wIVLn9nkV91J4QV1opynllFhGKT3zNnhP7nIuNz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199021)(478600001)(186003)(9686003)(6506007)(6512007)(26005)(6486002)(6666004)(86362001)(2906002)(83380400001)(38100700002)(5660300002)(82960400001)(8936002)(8676002)(66476007)(66556008)(4326008)(66946007)(316002)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YpjPJuz4ovWI4N3ZgpplnHvYT7dJ3lR7yAf6czec3XYbZFDd+KcdktPaGrAK?=
 =?us-ascii?Q?rdvXQpWQgt4HSQ4gKeTnaM7VE4ytNOUYlc2tuT1i77vmChbECYnJoBxIyxl8?=
 =?us-ascii?Q?nx2dnxOxYwL8jG4XWm/8U/8vvaDfcv2KTN3uNNjples25tRExsSWqs+tqiUb?=
 =?us-ascii?Q?o5coGSZYUHKuRQGCRAi/gfhdQSeg1S2x5QhSEsuSzlOKiLrF8ApIvRjUMZI9?=
 =?us-ascii?Q?yQUpQGxnWOCt0uooRGl8KIRZdbB0Q9+iocNI9T2tLGUq/7GdWIwmZZLUvWgU?=
 =?us-ascii?Q?Q3X7l9JE8b1EK/0HLb5tTcXVS8Cm0bHVSAD26C0d2C1elpeeFzQvf7VHhIJd?=
 =?us-ascii?Q?f58ZNYyJuRz8kdO7BcuKZs9zACzxwqt0wxKd9R1BQ81ofrR0ri7/jrQbXJ1q?=
 =?us-ascii?Q?3uogZ4wnFLQFyVwHmHtOpGM6b/5YNt/BkxwEcHohCRsxe0Hf0KVYDX1BzmeG?=
 =?us-ascii?Q?POaoU9DCm/8olNESnxjeDa+mHm2yW4O1HYWrjFwv0SFy5nv9J6H0vrVYtZXE?=
 =?us-ascii?Q?rGQcGbpGmQa99T2+sxTPbEAz5yS+L5B3qFKgwb8ZAZOLs9n5114T5xYW6A2g?=
 =?us-ascii?Q?/MUicv+fHVTnbrw2NR+eiT4VnAtu51ffXMGMa9XfRXzCiXc7rOvz1Vl7k9vH?=
 =?us-ascii?Q?cutv3oY6yAQeyKhbYMKAYhCYZUDmkSNzvlwh19DsIAGISaYm1SgqcQ/W/0NO?=
 =?us-ascii?Q?fh1RYZKO/dENdm3ho/j/cTCgJU5eqGeFjjFBjX+9dCzajwxyp3GqVhrpB8WH?=
 =?us-ascii?Q?y3y6FQSSducgOqVu3jHn5O3Wp4zFLfs2EgQyuEpSAW1C6VuLj9CZ9bFi9gAB?=
 =?us-ascii?Q?wwhqGhTmKxhtcGOsyqDD878tE0/fQykbe+97ROBoGh04Zwenr2qW9so2O+aP?=
 =?us-ascii?Q?X0ozMpeNKtzrLciXLQyz5SGls4TP0/0k1s3XhwDAJFxhVQ+eMx8uB1AQr80g?=
 =?us-ascii?Q?BomtD4kJ93ugG+JUaF5mmzzC7PcaBYQgFbl3UE+SNBGxggK1fblyrz72G9NB?=
 =?us-ascii?Q?6LPcHu+ZP/4IiYJWdOAyiesyBTu99BbqrcmfwLb6VlG9uQW/CFNAfTzXj/IU?=
 =?us-ascii?Q?o0fy7McnVCEmrDTFHgvDCFGDo+/B6HtjT4H/lYV+7654z1XxSK2NiKK5mxuG?=
 =?us-ascii?Q?nssWbfkcGV8OMfr/6A32xAyjLq5XlarN/MrKq7vvusRp6TqGAAzZKQo/r8qO?=
 =?us-ascii?Q?0uoQ3ZtSeZvniQJF3cFtSJPtcC68X9JGNmviZSxHSrSLQ2gv2h+eeSIOgBrc?=
 =?us-ascii?Q?b+PY/DqptCikrSEuSOicByxIvN/4ScSERDTHzxV5/7fgs4aWMfVwP2cE+Ilb?=
 =?us-ascii?Q?x7SnJBXokAIoNOI+96MSZPJGNAjIIZTqyB8Pu5WkN+ai0ifOjVfMEoglW8HN?=
 =?us-ascii?Q?2UFgnxKOWUvUd36/QhtflAiH6atENBN4yGX0ZONJ4IGc/34lh5XriEH2+fMq?=
 =?us-ascii?Q?aYIVoHW3A1bRe1aDOiGfhX62AwWqF+GYSgVhjv/gkPzle1/HFYuwvBvhPcPZ?=
 =?us-ascii?Q?Mcz87H91wG2E7As4hoI4RcjYmkgElgGfz7CyEjrOj24Zq/+PCwdK0vI24KIf?=
 =?us-ascii?Q?8iP4G/3yl+PRi9d/oxVwTVRAkh4elApLxGTmlguT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bc5923b-55dd-40e6-30b3-08db64a51061
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 02:40:31.5793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TyO6qJmpyRBuxEz5ZoKdVsR2/irrHSCRBDrf2X8muLSDhao9MzNCG8/zJCH1wPKitzSQl6COf+zLVaVUmrmcIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4671
X-OriginatorOrg: intel.com

Dan Williams wrote:
> A CONFIG_DEBUG_KOBJECT_RELEASE test of removing a device-dax region
> provider (like modprobe -r dax_hmem) yields:
> 
>  kobject: 'mapping0' (ffff93eb460e8800): kobject_release, parent 0000000000000000 (delayed 2000)
>  [..]
>  DEBUG_LOCKS_WARN_ON(1)
>  WARNING: CPU: 23 PID: 282 at kernel/locking/lockdep.c:232 __lock_acquire+0x9fc/0x2260
>  [..]
>  RIP: 0010:__lock_acquire+0x9fc/0x2260
>  [..]
>  Call Trace:
>   <TASK>
>  [..]
>   lock_acquire+0xd4/0x2c0
>   ? ida_free+0x62/0x130
>   _raw_spin_lock_irqsave+0x47/0x70
>   ? ida_free+0x62/0x130
>   ida_free+0x62/0x130
>   dax_mapping_release+0x1f/0x30
>   device_release+0x36/0x90
>   kobject_delayed_cleanup+0x46/0x150
> 
> Due to attempting ida_free() on an ida object that has already been
> freed. Devices typically only hold a reference on their parent while
> registered. If a child needs a parent object to complete its release it
> needs to hold a reference that it drops from its release callback.
> Arrange for a dax_mapping to pin its parent dev_dax instance until
> dax_mapping_release().
> 
> Fixes: 0b07ce872a9e ("device-dax: introduce 'mapping' devices")

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
