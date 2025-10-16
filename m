Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A279CFC0A
	for <nvdimm@lists.linux.dev>; Thu, 16 Oct 2025 05:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760593337; cv=fail; b=CSnbEULReB0rMYzfDGZULWKVZndcsncYgkFJgltt8cTZTu+ATQ9wyJ/yCpzSTjuK1WhB16NC9/bM0wVzLRt6Cl8+igXcXBq7EzhUgknhIiUvK3/BX4oagDe1Xy1OkbOeRjd9e4poV+RWeOM4Dvav4GkicCu4CMsTWkIJ05rsDmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760593337; c=relaxed/simple;
	bh=8JmQlHS8xQ8puN3XMEIwxTgiZhm65GiaS8uS2eDUXXc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lHAsfILBbgGKq7hHcYPjtRY0bdLVMQmGk791gdOM0lDO4Bi9nyxc4f0GwaQNHZoKepqZe8TGq7Iyhut4P57DNkwj1tl/jf8EVjGLPtvJPZI0mFEbkd1Xml3Ea9tM9hVBxcmrys9q0H0gS8wSQDb6CZjD5ZgVhiu9fb6WWzGvtWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nMzgRLJj; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nMzgRLJj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760593336; x=1792129336;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8JmQlHS8xQ8puN3XMEIwxTgiZhm65GiaS8uS2eDUXXc=;
  b=nMzgRLJjN7XJNhxqInZykjDPPstQQ5ufdASpUyv9Ne/z94dIMQUz61zv
   4Pw9Wx1fdr0H+u3GiRKNm0sJ9oiPNoLC3mB3ZJod2RqSN/EtGeYzD7BEj
   wQlm03MgU6Ex4PAvizRnqD53msoTjIa+tcKZB29nHQ1+ecxGNwJHbagr2
   N969+kabOPULzHOTsDXLHZRDXDZf6liHmgYHipzrNAECDqRZsm3Ylandk
   1XR419tbOvWxB+EjekxHO0mJuOPvcl4dYBR7weuqNrmlcaCNlCwG1u9Xl
   NOfDQ4a00OLUbAa0queEYgCXjy31CxMd1pE4qqVQbZmoSpy7uW/Pu/Uuv
   Q==;
X-CSE-ConnectionGUID: TkVzqauzRU2+v0EatJxLnA==
X-CSE-MsgGUID: VCBauqR7ShqA/Khg93lHYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="62816451"
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="62816451"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 22:42:15 -0700
X-CSE-ConnectionGUID: ndnqRDDoQ8SACezkPQX46A==
X-CSE-MsgGUID: SfyAAQ9OSmW8DO2daRvODg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="182346841"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 22:42:15 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 22:42:14 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 15 Oct 2025 22:42:14 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.17) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 22:42:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U99enhJabwX+EgLlWmz7Mht/UODJ2xntTwRSWccasGyOsMCJlGhzvp35w58r7tde7gwf/FfnlYYSf5+hTFIJbBtwm4l71WS8f7NiDKj8mHhA9T2PWxC3EIwwlwgoRM7XeL7SiT11OGeZRMK4CtTY5AzlEDs2McvGWyQh3y6nxhwXqJ9EPjfx3oXi7nICU0144oTKx037/BrndJ4yDH0S8IFFWc6v3W6LEN7dHJL+P5VrnuvQ046z140FjbcE3gIR3NTNzVYLdF5DbSWidpX5ZCOCAe529fZ48SQF5+stVR001hKc/BH/jj9SmSRgXATTKjVcebkYni7Cqz6RSm85xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8JmQlHS8xQ8puN3XMEIwxTgiZhm65GiaS8uS2eDUXXc=;
 b=DgT4s5eQSSaeOC4jvkwPToqdLmJIfV1qsr8SuMybh0B59uCA65y9USJ3CncGBUzzA01VlkF7q0HfxXnsN42GoqCM+livWXbTfmybC/pTc++z0JvLHInj7qVUny+Zjl89cMI8zXibAI+fH7FpQVejKqnyGr5UvKZaivEDedCod8/t9GBEadgZTkE1IUcoIArk86/gIf/9FwkQodNITlNx6s4QQG0GiIC/D/m6kGh6NxpgJC5mdjR5+TzN77Mi5ZdzvL3MKhUi1jD0KFby5TUhmKkoBTm+d8lZKZR067rKguyHoW2J7kt1rAP97620os2AebMdZY9L28p5/0Otd0K9ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CH3PR11MB8751.namprd11.prod.outlook.com (2603:10b6:610:1c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Thu, 16 Oct
 2025 05:42:10 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%7]) with mapi id 15.20.9228.009; Thu, 16 Oct 2025
 05:42:10 +0000
Date: Wed, 15 Oct 2025 22:42:07 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<vishal.l.verma@intel.com>
Subject: Re: [NDCTL PATCH] cxl: Add support for extended linear cache
Message-ID: <aPCFr7DRU8qXOg1A@aschofie-mobl2.lan>
References: <20251014183613.1699995-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251014183613.1699995-1-dave.jiang@intel.com>
X-ClientProxiedBy: SJ0PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:a03:333::22) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CH3PR11MB8751:EE_
X-MS-Office365-Filtering-Correlation-Id: d7b0d557-3052-43c4-8b84-08de0c76c066
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?pYoSlalxCg9ooURWLoDALR16Bu3RPxdc0dBy0tnyXF3oX8E4Mdyy42IYdFk8?=
 =?us-ascii?Q?NQs8ASnlRtCiBzX8RpI1DHQQCsKF7VlimTb74UTr2ZJ0VtcbU92r6ms4A05+?=
 =?us-ascii?Q?RIFiAh+ChPDLnoKnsu4yfwXDmsTFLc16oe2XhD91Y2rTw38QxAS6TY63alCo?=
 =?us-ascii?Q?S7TjtaZqQZdzYPW2VdxIfbYTfKGWi6yKANBvtdT/EvlWv+//YvID3JPvKQN0?=
 =?us-ascii?Q?pEj5FFNbGPi1PGdr+tJZ7P6hlBo+2KvV8HkwSLU/mMoSdFi+fosh+qX8lrwr?=
 =?us-ascii?Q?nqng4S4hK1UFUJGKigvqCzImEsZ3ePvOBFpN06Of2iGLK2fOmy0bVeTHdIGt?=
 =?us-ascii?Q?gl52OTiz+4zF9VodVf3s4/JFd65m8nLQV2FfCwREZiFll08WyZiQEY5/mY/X?=
 =?us-ascii?Q?6c+CplcaoYsKk/KwiRF6OQh7OgHTgkIoNyW1ZGbM6Qv4mpotBdCbJYMQZDNs?=
 =?us-ascii?Q?htqZvRPeCvD+u61b/kz4Acqxm+zQbac2vwpORcZWWEL0P4eiMGUoW+FLdl6M?=
 =?us-ascii?Q?0ZWh7GxDl9lNFRf1/FSbMWydxUHSaPKV3vcXD30b3KFqiok0P88rJmjpqSUA?=
 =?us-ascii?Q?xBfpXoKilwyYu3VwBmR334FDkSN5eoKwLUzANoOrx6qjA9UW/sjuxFet7Ghl?=
 =?us-ascii?Q?TQ2u+4hS3Z/41fOr6NWXwBiSw8FAySyDl47Bp+XAq8B221Css1IVba4J5er7?=
 =?us-ascii?Q?f28nbUTumsk+M2OBCJXdxFpeS/cwYHy5va8JSbN9jcjHdBC+AYg3/U2CqHoJ?=
 =?us-ascii?Q?zMmJnMcKidM2WoHPiohEZcndoWbSSMYx2AjUHlkyZpHuXMszVCdurJmXo3/L?=
 =?us-ascii?Q?lwOJQEQzmVZdcy3I+D95+hald2kDdNrEqQKTMxzWOF9W18lKMH+1XtHPveZZ?=
 =?us-ascii?Q?EqIXUR6acUvQbyvU7sk246moCZHNd6LELvqim3rEsy0Z9lWY9mCNQnw/kL1j?=
 =?us-ascii?Q?3G5KlASbARC3sRTTEfm7Cetp60t/6X4nuVcFnJLw4+ZSw6cTrvq7ng1Nof/D?=
 =?us-ascii?Q?FFHhx6cCu66kLr7uLQ27tfbacDDwDjQOVL9zXXO1d9X6knKFr4iX8zkdv9nc?=
 =?us-ascii?Q?gz4LOLHfhv1Ul9sM9BjdRgmTMRPDUfhEfoDvq8UsPQGVAuxNKDsq1fGqrRAi?=
 =?us-ascii?Q?iRcgEqazaDEcsfi5kg1QhOHoumWdZIoaEbuSQ0wxeWRKt2sBr3EPmsZ+o7Px?=
 =?us-ascii?Q?yhu61ggrbKYOo/hOxMsskY872LDv2NTcf+x3BlNyqE4m5+i+u1A6OJS+16lI?=
 =?us-ascii?Q?8zcqRxIItkBmHYe7bkbT/tsp/iiS+Z6iFnNwAYa5qf7VkJuuT5mIGf+J0FIj?=
 =?us-ascii?Q?IWUoSI4dgW9vKSZUif8FWiUKxU9YtNAUespPJBNNe5RwgU+MS/IW+YQ7HfRH?=
 =?us-ascii?Q?Kk9kpFsz5tyCgBlydrYkV4Ts2pQE/OcEZGRdClo7A44XGWKeTk5sxh5M+zyw?=
 =?us-ascii?Q?J9kFdRvG32vjNDxqTcDfsJtDhZPG/FY/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0r4O9RmIN1M8WrhLnQ2+FTyQa6ZLTdVTGWnx6FiO5lu9wL+4hWZS4xRtiId5?=
 =?us-ascii?Q?rP3WD2eAT9YFk1Nzzv4VzmrHj0dWiEpt2QMyr9YB7Ychb5/CXTCbvM8F/tp3?=
 =?us-ascii?Q?0UeuS0PGaW5yopWjPb6+KVizY7LmkJVFf0rf2yGAovdkwgENpVDZxYzdv99l?=
 =?us-ascii?Q?FcXVIWVZKgW+++Yt6FIXqlAN1Wi7jmwR1dRhblvuflfw6qA+KPQ6SmN3BDA7?=
 =?us-ascii?Q?Y/ZC0EdZ9RxOUPCKXwh/6tDM5CbOZbVIdipZ3XWLjYva3wodong2tZwZmr5K?=
 =?us-ascii?Q?EqZXyWIPDbNEhezSVWR1ns3vNFZbFKco74hllpxqnNaB+vnLFz8Bd2pOseph?=
 =?us-ascii?Q?QIK+okGcrFQyAyhjT3IOAY00wkTMCal0EaIlJ0VNAzxCSQgGNsfIY0cIOUeA?=
 =?us-ascii?Q?Dn53fTevbQ8n3stlhGJILToXYY1LbUuPElrgZTrLy4Zvu4NeD5sAzKros4wU?=
 =?us-ascii?Q?RT8/Lefslbpez6VmRyKFbhVX2LupuEieiQ8TaZS/WeKlpxvMVA4C/dUHzRQr?=
 =?us-ascii?Q?62TuMAo2BkMcrYTxnBIG1xh2kegS9ZFPPYzMGSIc258yhgMMjlGSgF4HQLY8?=
 =?us-ascii?Q?IGiaOQXS53mXahgL4Il2Gu3AtA8u/MtVQSrYrbz/7PyDP0j9qhvOWYAI2Mwu?=
 =?us-ascii?Q?U3SkJWBMW0KFoJDgDmGobrHO9/W3Sxj8UlsEcEqDkVWjdE1MSH8ii7QhdnA9?=
 =?us-ascii?Q?Mgy9uTIYCfeTQ3mhMwhldNvb2Nr8T6QFi5IJZEXzruFd5bkEhmJtjTEFZNqO?=
 =?us-ascii?Q?fDDbDtXL+CkMTD6niYj9gPiy/15BptENPtmTtUQfvKVwsJUCyZJm7Kjq4aUN?=
 =?us-ascii?Q?hVJh8cAxwIGMVSsY8K6tyAoreskABnslwWAGRk0bDZ+G0aGvrUany4OYtlBR?=
 =?us-ascii?Q?h7ZAJt7zxDuMUTSrtCatL5gAh+6z2E2pqg+X855xfV+MDMZMRn8rtvnMEciZ?=
 =?us-ascii?Q?539guTabxEx+JRanVnaFbFqwXsU+4r1DHopkpHzWuRlNmMPf5oloxyVd2rjX?=
 =?us-ascii?Q?AdBd+YxYsCps/idJEySMbLymKj8zxIFMbdqLXqwPJGa8BOGsN2/Eu06tbWwL?=
 =?us-ascii?Q?7IK6qhRN2OJN0xquNuV4eHEOo/wRMQYLSewwny1SKM7SsEt4O8fTlKObyOyn?=
 =?us-ascii?Q?h3A4GbFFaTJ9LwBPfyrUeReh0ALRDgnkxf5BOfaGcABXc4hTX3Rz+I51mpQ3?=
 =?us-ascii?Q?bqQcCE0vTk071M1nhI6Ak4u7BxgruThfMj5sAeyIJpcJByl7hoR2cx5VD8ka?=
 =?us-ascii?Q?uay5wX5Aq5HnuM3vEKthxpAlLoPjLQL3ECSINAL4xIBNM2nF38k0MTW83gye?=
 =?us-ascii?Q?DuHLuahymr83YfTZ6NHDZ4Rd3PVE++D/S3AdtHjYnsFHvoACgQibxZhmCPGk?=
 =?us-ascii?Q?CbV+yyMT/7Czfl1XAbt6KoQaqLypHQsADCthUG8+9rpO2m911y1cey++tb2v?=
 =?us-ascii?Q?9clyPT7POIm7nYZKE3pF12zS1rtEQTO6XgIw32ClkITd9t4WqnenL8rBfm5c?=
 =?us-ascii?Q?myNDynUJmmQJg0ofA4unMSjuZkmpfwPnF3R5VDgdSFP57d8B4pd5dGVAJoby?=
 =?us-ascii?Q?FzfOFt+THx+5AyZTbv0uwFbxcIs3Q8dWsYkrNA3/MJfFT1o//sviDnzWJYQk?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b0d557-3052-43c4-8b84-08de0c76c066
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 05:42:10.8251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LVx9S7LhONWK/T6P89T8sV0jemGRGSfRIs9KlCxbXzVRphaAVMgOG6IHWnFq/tYRd2p1OVkxv3OEXB+DMrf7kQXvr/Uf/gR+9Gt0ueEXiC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8751
X-OriginatorOrg: intel.com

On Tue, Oct 14, 2025 at 11:36:13AM -0700, Dave Jiang wrote:
> Add the retrieval of extended linear cache if the sysfs attribute exists
> and the libcxl function that retrieves the size of the extended linear
> cache. Support for cxl list also is added and presents the json
> attribute if the extended linear cache size is greater than 0.

Please update
- Documentation/cxl/lib/libcxl.txt
- Documentation/cxl/cxl-list.txt

Otherwise, looks good!
