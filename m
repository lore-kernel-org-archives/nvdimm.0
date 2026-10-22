Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792635810;
	b=zHn02YCD4nugZ085igOa2gdwoSBfnL7sphXp5FRUOfAqS1bgxPKQgN1B+YGga38mMC3B
	 nJKtSk5L23aabsN6Yk87NTrSLCeieUffCdV+sUmspc6BUx9cH51inm9kDoONGFQP9rBcB
	 GAWDtQd+RTCu3XAAtnUH1J5b3R+dVaFrLbNOlO6XbSGSCGLiakQx09x76wHIBnGjlnwSz
	 LrVRxK58C0mNaF2k0aZ+kea2XJquz7ilLRoPBiUkNov257W/t5DOh7cYROAT1qV+o41qP
	 0Emo7ji3mqtZdOBBd13zkLZcGFS8hx1s6yIOewunUruzFmR0Enw9E5mr4ta4phkqfyQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792635810;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=+WdLeQnemA3z0nPga+NkHMn7wsgh9pRwTeS9PcnwrdU=;
	b=AyoHVriAhQU+X6dhbVFtko0SsbiA3Gpw+wyJH6G9VIihPBpI9hihebWEUMD1vgVOXTII
	 7U+JhBhB1M9t1yvSj3p4OGZNfuxrCO3tjur39uDRCEmHgubdj4tTFF/36bnGs6Cqao/c2
	 OdWwY+zgw9Psr623Qs2wFNih5bx0h3bhjO1GgGYuFzjJQLGeGgrEcVDMedgTWWqQS83d2
	 4VXVRIPGgqpUwCIu57BJ7/pKdioxmDEMcdRvRFC602uyJzYDUe5kUtb+cDa3oNffA7Cru
	 C/g2GHkgeIGpQ3+/HpI6kP1aNNihWOiw8ugro2eQiSmADedjeX9IvvckH/5KPORI8ZQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DWrwUEba;
	arc=fail smtp.remote-ip=198.175.65.19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45865606A31A
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 02:23:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45865606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DWrwUEba
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792635810; x=1824171810;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2hrnKBTp3YqwUYkCFUc0f3MfhsWnID/KhsEesLOoMSw=;
  b=DWrwUEba4wWW7wvSbZabhVF5bc0gpOPOXiBJdbYkHTS2fMGZj0h5GgWr
   nuxo/il87GGkgbcGL7+cSIcSQwvI3UOdIWqri+J76QWtG8WsDLU+4ZfpR
   V/punKgtr4fwnxkA5ldlCM5aBnHl1dIMhrQBqAScRfx1Iqaq7zCmQCZyy
   uYY6S/qOY+4RTqCwmwW5+jGxQiYump9zF7XvmliJRijsXaYd4T56rhvci
   H2TA+3S8//I78tg1AtFiwYMg+1/In9H9TvRqiXmaD7G+90LgRj3mDWqQO
   3y33jbEaytNOcLzPDWPOlqV6UiGbTBTKewHuUkmju4D9f30vtEFhTGqnf
   w==;
X-CSE-ConnectionGUID: 2bTS4y1jQDW2+qnm0/aKPg==
X-CSE-MsgGUID: HPY4gr6BQfWXuGkk0vCaoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1409551"
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="1409551"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 19:23:29 -0700
X-CSE-ConnectionGUID: tQEtiq01TVSH2A1MWu5ViQ==
X-CSE-MsgGUID: EmYD+zRtR26OMYYtWc9DuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="3588899"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 19:23:28 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 19:23:27 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 21 Oct 2026 19:23:27 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.30) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 19:23:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LA2KS/fSXGLRE6Tpx1UOUkvFnNNjlTuKjdC4c8raw6pfqy+KpWQxMOmMN5mKGd9TGUeOr581iADntFPz92lzICXm6BGLdR8hssvSkJy59plMaRgizGxuz3X/83wyxy5TIh5IHb8pRHN4wh2XnfNpoWTEzYsn9Gj6ykDRt5f7YWYdF+aYfVn60CnzQTq5cbquX9oeK9nIrD4YTfNdOXqH66o5DdcXamI71J4pKcMK4z9K9A3o1449pfFPPqfudEJId6Z7+lYY6qf7tHiK8j+881YzO77ArULuUcmDYN4QRLvZ/XZnVmkLpzDW5HW1vINvPoFFpq9tDnoU1FpJ/bcNfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+WdLeQnemA3z0nPga+NkHMn7wsgh9pRwTeS9PcnwrdU=;
 b=p4vRrr8o7WvmUqAoip2VkA223JfIZkW4AVttnVdTFMl8SYF6HSLJerR02Mw1DvDagg+54K3H13AJ5gbbnocSmHJn/bwc7dUn6oAqI4J92TCvarMbQ/PG9zdcZfvFM9PhTU2E4K1TS0kONnKXNUurBujOCFLjrdq8EF4vIprhQBs1aKOUwN6QnYnq+TflMEXPcX2NEnQf212BfraXvUe3GDdcLTqRl5aPqVvgKmw8AjxHlUG0lHxdDYy1KuNfs3ICp0L3kFo0WV3JP9t68ASWRwBvFDcC8GHwS5d8n4LLoEtsi/eZYReVuAui540Ou1trcwF2wg+fUddM+cpSDuVYsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH7PR11MB8551.namprd11.prod.outlook.com (2603:10b6:510:30d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 02:23:23 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 02:23:23 +0000
Date: Wed, 21 Oct 2026 19:23:19 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 5/6] Documentation: describe atomic whole-device hotplug
 in daxctl man pages
Message-ID: <atlzl3h4cslBaV6j@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
 <20261016214248.443247-6-gourry@gourry.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261016214248.443247-6-gourry@gourry.net>
X-ClientProxiedBy: MW4PR04CA0255.namprd04.prod.outlook.com
 (2603:10b6:303:88::20) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH7PR11MB8551:EE_
X-MS-Office365-Filtering-Correlation-Id: c082f682-0545-40cc-5ddd-08df2fe3721e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|56012099006|4143699003|5023799004|11063799006|10067099003|18002099003|22082099003|3023799007|261021121427099003;
X-Microsoft-Antispam-Message-Info: udWj37XekkRQsZG06zHiEEbiG3GsLqEuiK1VZuIQnXMVYQHVCKIeKeYbBGNsyPo9vN4sm1g1ph9+9/FTZmY0dSxxWz7/J2bEeHgp61sAkN5u241X5IHOrqmYBgyHfwZWXMaYK2UynDY4YIJv7PIeTqnHkIon5qD6tpxmRbtLYNzccmzddq24cSOPFsu2wjEQKYZRw09Qxy1c+90KSx1BH8nbkNepnTROL6uyz4GupyTUuMyMVdnmEvSrsTO6m7qNSEjxY6yVjAwTpm/wsE/jlFXDotnc9xPGe+jxYHGXQQv9VrAY+uU4bUMvI8nYbWivQ9lCxscFEy+E36fLBN4ksjdM+xw89tWVfUwuf30IexpRQM2JjZW+zfm0CReuww45bSWThPdBNuacprE+gdxEuWG11vPSyISNg9A3qzJgSC1ALXwk49u7pHWRYC82wax2CiNpoRrqG15X3cLkhXR23EcBdFRMDACYCaG0GmyDQGlCOnNelmu8G2L8uS3paOfVFiqhoXUqh1H6BCqfWHv88Y7UiD0xS/tQGIeScTFqKx4JSxFCdIyFYSwlaRi7hYWjURHelIAwpJVr8UGxX0rUVGckYJPMOwzmlWbCB3fqI5xCeeGJVdqSEhEtc773T8H6kaCb/DJHu5o5tMAbg4V/Y0rcM8YY+cwJLM8Sx42AFLc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(56012099006)(4143699003)(5023799004)(11063799006)(10067099003)(18002099003)(22082099003)(3023799007)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1v0puNl6IlxsdKxiR2J0SGGpF11sPAp3BIMnsR19fKCPNxA4aKqeEOy7TOLM?=
 =?us-ascii?Q?B8rvKO+4sjWGoagTjNyoXIWYDyPbM0vta5H1+JCpSUVHX1Eoi7GunR5p6zBe?=
 =?us-ascii?Q?/so4HjQg0+ya2/lHGPxZzvGICa0b1silMJ1FuTDM+ARKmAO8i27e+EV4Sr5p?=
 =?us-ascii?Q?mQsSz3N9N6ZvNCgQy1shxqiEhF8gdW8nDhRXyFuWMtJS0hCiFvhjEhXhyPG/?=
 =?us-ascii?Q?Df+h39J4AbLK0P75blv/Uf9qrwzhmk0nXKCNs9i/J0gJF6C03sF2qDL63nkn?=
 =?us-ascii?Q?1XIoDjbLUFCYQW2f33p37LXK+cZkcHf/ngSDidkqf9OHNrfiIOsW+QBRHuv8?=
 =?us-ascii?Q?sKP2pBrKO9SLYx+Fu0Or/WBDx2WEdBlFm1yxwSh/jA7yAzeoerXTuP4vFKdQ?=
 =?us-ascii?Q?6dHTVVKFPaNz4+yGvIkhaIR5YgD41Na5ZooWP9xYgjMzqJJOa9wNnkPuWot7?=
 =?us-ascii?Q?nqL4EiSl4ahR6kAVkFF4gLHvgCEISsqdQPVVQ7SiGdUxejhqHf8sUfV2kwK7?=
 =?us-ascii?Q?0nwPbqL1SVajHNNy5DvZFu73xc/rHx78yuhvXSmGghpEuouZ03ObvN2g6uvB?=
 =?us-ascii?Q?RLIQnu4dnY3ojUjWqDI6qyXNoZcXkJwHddqQwzuJ3XlfUCX5SVQZ94nTjhfm?=
 =?us-ascii?Q?ZCLO83SzevQ7Cyh/XHy9FOcrCzDzS1zS76RNjQs//+Hz83gWg7+Cv6VPi7oc?=
 =?us-ascii?Q?Fi5677+tdq19wXli1iPLsZ23a/woZhZyhImUu7CSjBEY3ctpYm8tuQGkmS0n?=
 =?us-ascii?Q?5smzhvqpEEE+zEyA6mMNfT51w7KIwE4gLZ/XOX//kaayqPb56LtVCrec9d4D?=
 =?us-ascii?Q?arhQ8pwY0YQFtRTkQZQqLtxOddsVCmoel5+oaU/N6BWKsPk0SYje/av3qdEU?=
 =?us-ascii?Q?o21ZnOIqhx1U00p2rchsq7RWM3F93JhIk9UCOR/gF6CMuIkKW+lESJUPxtLD?=
 =?us-ascii?Q?mcUX11+fzy+wcB3px49BdSSvivHDNOXZ/dSSx/97aa6bluqw7DLVy8g9vnhZ?=
 =?us-ascii?Q?cdM+VBGxLDPkLYM89FUr32h8NogWG0pq1D1AAmJW/LywrSBI2QOnM8NomwkT?=
 =?us-ascii?Q?+FSTk/IwOMP5w0bOlFIyDhQcdReaGsjJrOZwWs+uydAHAmzPKVQToBbL1p3R?=
 =?us-ascii?Q?7sJvWJEp8Rd9YR++86aT0WZgxvg0NJF8tSCBzrlcT019/p4ApVmCMq5/Ulkg?=
 =?us-ascii?Q?C/peQG8Rrm6k4gXD04/xP3YGZDD3YLAb18Z1yxQX6HeA4pKIed9bOhvNWrJ/?=
 =?us-ascii?Q?JUBMlG4NCGvr9GV9dChGzrlavEpbm4V0qOB4h2AZC45Nii8uabQKDhqkn4qa?=
 =?us-ascii?Q?QAJGp7XaxyaL0WjcfGpTCvoaQ2FqfMWGnLnDHmn6hmWuFUHQJeAMY4Cz4Gns?=
 =?us-ascii?Q?iwojthoNwTDroJx+qX5lrpSUpYy0Hz2zaApwLlzSoLy/DFcYJEIOXqO/wxtL?=
 =?us-ascii?Q?+nk3vL/Bs9QkBUE4GYdXUZA4wG6o6CllmX6/4+l/wi4joH/NxbqvjZeT1E9I?=
 =?us-ascii?Q?f2vPC9xltkCQWx3f4vL+AehkeLdw83UjXS3srAhhX7TMeD4hQsJ2f6VIetZ/?=
 =?us-ascii?Q?GgD5LjcPGYsg3l6aGCMgIuO3E+XZn5GhysPAyLzPErwYDvydaDmNTLejl/Hb?=
 =?us-ascii?Q?piwta03EfQJfFAyWIEV4T7Zhg1WSEy1dj32uAY0TDcaahFiku4uNwK9Xtoy9?=
 =?us-ascii?Q?xyPyBj2Refnv/UH/7gdYgu2mZMHWo+oYldwrSFrsfZ8yDsFVi+3tdba2nXoH?=
 =?us-ascii?Q?gF25hw1GdEcWD0RayaKkLB1ikaOQGTs=3D?=
X-Exchange-RoutingPolicyChecked: JWPPrdXfE4m69DhFADEBxETplbGdj3NotF45kIJDJET/ems7UiV6/CppubSwDGAXLBMrZwNPAe+D0X1TjqK5+gZht8B4N69t83AqSeUg1qrAqlB6yun7qfwK1qleUhKI1OCgdbCXlgrPwLuIk2TmPkgTjIlpvtH1MweZ1IeqBvMV/yFdsYKP0fBBD7GXZHNiiZPdFkdXcg0SWT/9BE5Vnuuqeg+7dr4HChwEyW5LdhwgqwsZ/Yk7pf51yNxv8BS6vYOccDdB1+nvIlSpJHYZPt/veVZJQ3K1Jv0Apw/b5VXKVvAtlzRyG4BHsvxSN9lf6M16k9cZnZ2swbdEjW8lrw==
X-MS-Exchange-CrossTenant-Network-Message-Id: c082f682-0545-40cc-5ddd-08df2fe3721e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 02:23:23.0662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yttSFYvy0lDTqpBmN5Bl2c46M5YvPuklrJoIt/rcAkTrRwhMCXv+O64uJl2YoNnSR+c8kzcrVWOiGaSO70THKCxyyXe7FWfEQC539KsQRyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8551
X-OriginatorOrg: intel.com

On Fri, Oct 16, 2026 at 05:42:47PM -0400, Gregory Price (Meta) wrote:
> From: Gregory Price <gourry@gourry.net>
> 
> Document that online-memory and offline-memory use daxX.Y/state where
> available, that offlining always removes the memory blocks and how
> that affects reconfigure-device, and the 'hotplug_state' attribute of
> 'daxctl list'.

Hi Greg,

Can you add hotplug_state to sample outputs in daxctl-list.txt and
cxl-list.txt?

-- Alison

