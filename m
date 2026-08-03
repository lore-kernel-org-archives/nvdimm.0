Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63C833CE88
	for <nvdimm@lists.linux.dev>; Mon,  3 Aug 2026 22:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785797820; cv=fail; b=eRwo9vPHH6VusGDMiB1G1Xs+IANDTKBSHQD3xztPWghYSRjgkuyc9TIuwOVJ7yAni2zvFiqu/O8A/+uP/vKe04GSzU/TL6YvFFnMR0HKGcN6fxCSka0DWLdfqk8sMjh002Hqjq7vGwQxhFAUfvB116wk+kC9rLEIXhHbcProRWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785797820; c=relaxed/simple;
	bh=tyGSEcxQWpADYbLdKKjXo2mwbQmfNCJOMOr1DIgZz+I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gQR7yT1GQqH1OFXXqbYpS2kiO2id1fOzTn/SetdXTzgqzPdB38L8/VA7E6T+phg9uMK/RFnhlCiE0R6Sq2ROxavEeEwbR15PV98SIr3eMqN7w8OhBPGs0Uo2T07GAjUF2HQPKdCF0YpK0aIX5gdF6LYjlsB4xleyxqYfT4d++Fw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ODh0p8Ez; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ODh0p8Ez"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785797818; x=1817333818;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tyGSEcxQWpADYbLdKKjXo2mwbQmfNCJOMOr1DIgZz+I=;
  b=ODh0p8Ez/+IFJDa1pCAUSYvR5OUuA7na6LydC8Gry3v47iDoOrWR1sze
   vMI2tqfwLwH84z13m8Qxz2LNjBq3+7DmNd8L1ZX9z+TGWiktjLzYeU+je
   uhJad6iliQpws+m69rNPWPPU9kq37SBnJFyv17wqwKlAg8c1kcTTYCnw/
   FA1ZDYd8S4LyKIYMgbedmOep4QOBZnq7RuIBd9rJdtBoCQBNpjKT32RpC
   Ba0pzbHw2RNNI9uYeaKUL+ctmad3BuG1KndBJR1rhT/AVifZPGP5kj8OW
   01vt2U6jap6SN7uZN9YkC77k0qn5G5f8OIJeoVuFVjgr35CmS5+nCBBwc
   A==;
X-CSE-ConnectionGUID: D9dVak2mQHKMJVqN6AU53w==
X-CSE-MsgGUID: O9vwZJwdQm6sYIkGwnwh+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="103881825"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="103881825"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 15:56:57 -0700
X-CSE-ConnectionGUID: b7fJ2/oNQqSujSJ34dI2fA==
X-CSE-MsgGUID: gF9rqj2+TJiDE4dRnJVBWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="285982753"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 15:56:56 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 15:56:56 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 3 Aug 2026 15:56:56 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.19) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 15:56:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vEj6N7rqBR4q5jrwnFQnRfx5pm4AKOkuwPRhj0rWSH6WDkS69OopAqAAkBCYR7xWPCsnUYTKMhJfcwX7fJO/R/e38TpoP1DeUWuXQp3OKmFNogMuSRC6onha/MPotgsYyzJDgO4FSExVFM4D0Jkpqh4fr5R6dgKyeoQGbwVIT+0cdO1fa0Cj1K9UbmqXwBYRFB39TlY/KyOd+eua2iXCGQN1PwdInYGC8rfJv7zS5Bpo/nZ/r/1Gwz/n3a/eQmpXMPRG4zwWzzv0zPiLge9iGZIgxF1Pv3Bcf0lRq5UAFiPngvc3f6ncHCTQ/p2s9EnYB92NB+UEPr3d9nx+QhVDMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IDqWaB0CQiB2rZUctJsFyxFylAZ/RTBctdySSatZb54=;
 b=tAAP2fmnyuN38G5KbiT8lGP+dk7YTPP9hstww7woHr8Sjnn1lcIXN+6r2tojOpwEUPxZXAq6uqFYA7WnsjgSapXBqks1ZoTuZypUb5RHqxvlstATI7W1RQ/DhlemTbK2e3B2JZh3eNlZNMuBGBwWJGEkVlAWqwQtAayQD4Tu+EBpV8tcpMLjaM5fJYoM3rII5JrE5U27AclGHFqQ2XIB8tNfP4iym9hgAW5mKYTtwpZYhmEGLiYY6qgU85QLycROYT4uS5o8lXxLaqCNxWzxZN4ZRxotONwWPe+eyAKpbTSKCvpqWiHNxMm6YYA/qaK3Rflwxz1Qf4+W3Ah0NVh0mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SAWPR11MB9547.namprd11.prod.outlook.com (2603:10b6:806:4e3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Mon, 3 Aug
 2026 22:56:47 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 22:56:47 +0000
Date: Mon, 3 Aug 2026 15:56:36 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <jic23@kernel.org>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
	<ming.li@zohomail.com>, Vishal Verma <vishal.l.verma@intel.com>, "Davidlohr
 Bueso" <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Wonjae Lee <wj28.lee@samsung.com>, Junhee Park
	<jh9934.park@samsung.com>, Heesoo Kim <habil.kim@samsung.com>, Anisa Su
	<anisa.su@samsung.com>
Subject: Re: [PATCH v12 3/8] cxl/cdat: Gather DSMAS data for DCD partitions
Message-ID: <anEcpHwmkbGWB9ej@aschofie-mobl2.lan>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-4-anisa.su@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260731084901.1512819-4-anisa.su@samsung.com>
X-ClientProxiedBy: SJ0PR13CA0130.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::15) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SAWPR11MB9547:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f86aae9-8d62-4fd9-0de4-08def1b27f00
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|4143699003|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: X/dGWF6zaSyk2yelkcQafzj8wgIHlt2Vy5VAiMu4/bs0aVM73V+kGjyu6FbIfw0HXxyGajkhGVWQYV9Kdi1wNuvl98QClrqcommT/P1VkfeNbA13/4g9KzRkP7/GRqpggvxo3sDtDSTCWLnEoJHta6AiA5+KpF/beR2UamQsUZqW/7cqHM2nZ8U4JWopOE61/JtdjU2cDv2LveG3Emtsy5pSEZ5KLwBJDFDgodldRe55nqIHp43IT8ziIHQitKoZMRBnrfF3iudi+n15og4KAWj1ULlT8YOBpbZcVaVMO9r9X8VZ3JBlHdfPlLIdQhc99mS7j8DPCjYTRxKUMfCzxyUsdYj9VfB/ub2Mk8emYoW4c2e+Rm2PtA13wziZe4MuVW9nUjg8FyS50a+OFY9GZ/jdRLIhu6AzyzKg/S+uBYnbcE4sWtsVerVlNzrsHoQmO0cI7qNFBKzeDaqrU+scHbez16q8KNGn7pdP2sbx+Vmia5odvEPsgG55jV8YnotMMUiZ0IqmD30J/oRLnG/cvRg162ID6G2mlyFdxibLZQ4Qpirp4UpVTvZcXmn+e6V4QXAhugqXsE6vndyOLn8vXn2miLBt1tzt9f3GPYaGX1YMRtB04ccQLT+Mec8F3Qahdx4mBjfl8zg2zNpdY9mAWMiPbwlBDI5H1iZZwUDLjRU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(4143699003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ApAf2nCiD/i/32bLiLy06fOjVmIEwJVlDMfyj6IA2ryW56ufvKyz12JCouFf?=
 =?us-ascii?Q?7T50q+BoqRwxE4PIfny+ZKVIHceAmRaEBpG9wwdr7XFeE3p1QLg509K4okTx?=
 =?us-ascii?Q?4GLI67E8KLybvIFrlR7m11I99OMA8qfwBQ94yv6GCz0QTlF+5i1PJdl4V3t6?=
 =?us-ascii?Q?1QyPW5V7D56iDsZxBQn9aWvknz3dkRhADiss/iAxEudXn3qK5adh4frTlJxb?=
 =?us-ascii?Q?Eo0Cjpfi9YixhRSrCI1BnJYZ/bb/M1aPO+Nbyp4usd39N5jZ+BtdMaqIFBTh?=
 =?us-ascii?Q?hEB+syeHwHT71bJ2miHWSV0+2LGSo7XynOgMzIFBR0vouOjxWLI9sdIVphm/?=
 =?us-ascii?Q?3UlWWVUj0nlnqUnLWaW0MuqOyzFCnDHrb5HTZ7gz4oL5zdLL90IKNMpdpCz5?=
 =?us-ascii?Q?nmkd1dnNR89kSLhcvFmjaIrdpXQQJgA27U1FrzTGTfHUe4J13WrEFvelcIE7?=
 =?us-ascii?Q?vL7g5Goo6APntosc5uoZRNz1Npg6XZ1DQvxeamjECQV/bhzdFwOQRIh1G1/z?=
 =?us-ascii?Q?PyH6KGSC970l6xz/FQnU9veibMKyi0oYuZi4w/kMPehRXK4KQPMxGH8RKyIG?=
 =?us-ascii?Q?RcYRb13BTVPKRWQPv2VXTJmKCU/qzgIu++xrm2htcCqdPOSlEJ13+s6ylaGf?=
 =?us-ascii?Q?SLL9sjDVA5vehWigitFf00r1bV05da26k8gsJO6EJKzzOsPc5NMLHuexSFF9?=
 =?us-ascii?Q?0e/DivvyASoZR+N7SRuNaCNdjwVjMmP7hBu0PfwTxBJWAZ2Be5IO7s5vMFXM?=
 =?us-ascii?Q?pLzPUbjgG7ZkBCqZGbYqsh/CzECwqh0CtpG38xrAfzCuEVqZesqdILToQpjW?=
 =?us-ascii?Q?/xnMoaUCfQ0HP/62fRx6BEaur61hK7RSAxuaUhiE/3Ynz5FmIn0gNlMShCkJ?=
 =?us-ascii?Q?5a89qExn2c1O6epRwbvIIr8KohcCcDABirAaLYpwN2d7UF7nGZGyubvkGFpS?=
 =?us-ascii?Q?CGTYDRFAhzvlfA5i1613fbAdMXkq4ZV1SIkqeHmzIGvtBplzqJ+lB/p0hq2W?=
 =?us-ascii?Q?73a9Eb6a6ijlmhIQrtl1fvLRY5sea5KVYskE1hXjDeEyXU/zv6XbqM0Zq2BT?=
 =?us-ascii?Q?UjbyWd4I7+6LjsFwxdCTZ3tSZ71TGDO+EH+mJg3sutTc9snUXwxFqjw4FwCI?=
 =?us-ascii?Q?2aPwS51Kk6kuI7udj0N0Fzu9/BlmtIQC3cuyNGqZx1mFO5nPVOPfnJCPLSyQ?=
 =?us-ascii?Q?5I6JQ5Ha1fYp0ceyFFvEDAA2bZ9yPTZOfNpJLxdueKYX89u6oc/IhEEImd/i?=
 =?us-ascii?Q?jIxmG+766ZzLZqs+GbKlvBs99HigLSwhP5dFuUn9pJKMC+KXkqn6EI/44LR4?=
 =?us-ascii?Q?wipXD9p1w936QwBg7esEspnD9UAWkrOChekaPARsObSlBIKK5m+rcLcVRMWm?=
 =?us-ascii?Q?CraA2Kq4O/tdbQVNGUQ+vExkiQ8KrtLqZc98r1OpU2ETfcDOm6EHapEaobIZ?=
 =?us-ascii?Q?xERvTGaXnuYIyRO/RDkbVHm6to36hyg3C4lz6pi7U8mpAxDkCJf0dSZXIj00?=
 =?us-ascii?Q?vyg2zckn6YDBC34teJ/7lHnSOO8qIcpUTXZf2HlVbkLwjZeg9E5ZK7mFVL+F?=
 =?us-ascii?Q?uT7s9yksnjC0Vv2UWMO4UIsIf5PHuDYGiVyvzqpipg13TcuspdJxOnCHxiug?=
 =?us-ascii?Q?hlc4yF7Qcj7HMRiWwBSOw9axQTXhrR1yVh3P8pOPKOtkZIj8OY4rPvvSGB1T?=
 =?us-ascii?Q?uhrZx302kFmgoTOGJWJE8h1m6XNFurUW/93qZR6wtSphY2zOmDA84qdfqH8V?=
 =?us-ascii?Q?ASsAkQs3ZpZUp37ufnN4/gJVlV8s9IY=3D?=
X-Exchange-RoutingPolicyChecked: MSv8R/OS8BqsJWrouvmY0nIwWLWhmEbcYkeC/TwisLd9hDnMJXyrlmgKatUdOvSc7Q2bDv4bacrqN1Ln2lyukWYGaYw65Nf5zl48JLNc8tfIavbjk9zK6Iv5lxVH/uH0RHz7c6PFzvRDuT77/a+6xQasPmjv6AeDGUsszkhW+6a15LPCql7GPktpP3/89BA5DQc64g5KCKgfyZeJG/+1TyCAHp1nD6kQcjWCY6Ian1Q1T6GnPyj3VXkft6HZSRACVOGsWe3iCXuhCyrhFfHNzXQrOqyAcf0Eqf5Ou00vMl9CbDYEOMiF5HpyoMqxGfz0q/3ML8uH0ItSDt02nKBMRA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f86aae9-8d62-4fd9-0de4-08def1b27f00
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 22:56:47.2445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TKaa8A4ARPisnY/9dS7l3xbnXZLn7j9Ik+HlCQx1ssUmsd8piyTd4e+TvG4P9PCSJIQb+33+sLmk/9iuz/RIpWGFdSbIlLy4+SpcsXTkwkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR11MB9547
X-OriginatorOrg: intel.com

On Fri, Jul 31, 2026 at 01:48:08AM -0700, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Additional DCD partition (AKA region) information is contained in the
> DSMAS CDAT tables, including performance, read only, and shareable
> attributes.
> 
> Match DCD partitions with DSMAS tables and store the meta data.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Co-developed-by: Anisa Su <anisa.su@samsung.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/cxl/core/cdat.c | 13 +++++++++++++
>  drivers/cxl/core/hdm.c  |  1 +
>  drivers/cxl/core/mbox.c | 22 ++++++++++++++++------
>  drivers/cxl/cxlmem.h    |  2 ++
>  include/cxl/cxl.h       |  4 ++++
>  5 files changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
> index 5c9f07262513..37136b2cf7e4 100644
> --- a/drivers/cxl/core/cdat.c
> +++ b/drivers/cxl/core/cdat.c
> @@ -17,6 +17,7 @@ struct dsmas_entry {
>  	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
>  	int entries;
>  	int qos_class;
> +	bool shareable;
>  };
>  
>  static u32 cdat_normalize(u16 entry, u64 base, u8 type)
> @@ -74,6 +75,7 @@ static int cdat_dsmas_handler(union acpi_subtable_headers *header, void *arg,
>  		return -ENOMEM;
>  
>  	dent->handle = dsmas->dsmad_handle;
> +	dent->shareable = dsmas->flags & ACPI_CDAT_DSMAS_SHAREABLE;
>  	dent->dpa_range.start = le64_to_cpu((__force __le64)dsmas->dpa_base_address);
>  	dent->dpa_range.end = le64_to_cpu((__force __le64)dsmas->dpa_base_address) +
>  			      le64_to_cpu((__force __le64)dsmas->dpa_length) - 1;
> @@ -266,15 +268,26 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
>  		bool found = false;
>  
>  		for (int i = 0; i < cxlds->nr_partitions; i++) {
> +			enum cxl_partition_mode mode = cxlds->part[i].mode;
>  			struct resource *res = &cxlds->part[i].res;
> +			u8 handle = cxlds->part[i].handle;
>  			struct range range = {
>  				.start = res->start,
>  				.end = res->end,
>  			};
>  
>  			if (range_contains(&range, &dent->dpa_range)) {
> +				if (mode == CXL_PARTMODE_DYNAMIC_RAM_1 &&
> +				    dent->handle != handle) {
> +					dev_warn(dev,
> +						 "Dynamic RAM perf mismatch; %pra (%u) vs %pra (%u)\n",
> +						 &range, handle, &dent->dpa_range,
> +						 dent->handle);
> +					continue;

Seems like the above message needs to say that the DSMAD handle from
mbox disagrees w CDAT DSMAS handle. Those (%u) that are handles have
no description.
With the above mismatch and continue, the loop exits w found still
false. Is that really true?


> +				}
>  				update_perf_entry(dev, dent,
>  						  &cxlds->part[i].perf);
> +				cxlds->part[i].shareable = dent->shareable;


why is shareable assigned for every node, and not only DYNAMIC_RAM_1

>  				found = true;
>  				break;
>  			}

Above nesting can be improved. Inverting range_contains() to unindent
the main body. A 'part' local pointer would reduce repeated indexing.


> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 0ef076c08ed2..7f63b86887f4 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -477,6 +477,7 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  
>  		cxlds->part[i].perf.qos_class = CXL_QOS_CLASS_INVALID;
>  		cxlds->part[i].mode = part->mode;
> +		cxlds->part[i].handle = part->handle;
>  
>  		/* Require ordered + contiguous partitions */
>  		if (i) {
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index d79019fbd790..a6cdea9f4080 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1357,10 +1357,16 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_a
>  {
>  	u64 blk_size = le64_to_cpu(dev_part->block_size);
>  	u64 len = le64_to_cpu(dev_part->length);
> +	u32 handle = le32_to_cpu(dev_part->dsmad_handle);
>  
>  	part_array[index].start = le64_to_cpu(dev_part->base);
>  	part_array[index].size = le64_to_cpu(dev_part->decode_length);
>  	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
> +	if (handle & ~0xFF) {
> +		dev_warn(dev, "DSMAD handle 0x%x has non-zero reserved bits\n", handle);

I don't see reserve bits for a DSMAD handle. I think this check is valid
but the message has the wrong constraint. Expect it is a CDAT constraint.


> +		return -EINVAL;
> +	}
> +	part_array[index].handle = handle;
>  
>  	/* Check partitions are in increasing DPA order */
>  	if (index > 0) {
> @@ -1536,6 +1542,7 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
>  	/* Return 1st partition */
>  	dc_info->start = partitions[0].start;
>  	dc_info->size = partitions[0].size;
> +	dc_info->handle = partitions[0].handle;
>  	dev_dbg(dev, "Returning partition 0 %llu size %llu\n",
>  		dc_info->start, dc_info->size);
>  
> @@ -1543,7 +1550,8 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
>  
> -static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
> +static void add_part(struct cxl_dpa_info *info, u64 start, u64 size,
> +		     enum cxl_partition_mode mode, u8 handle)
>  {
>  	int i = info->nr_partitions;
>  
> @@ -1555,6 +1563,7 @@ static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_pa
>  		.end = start + size - 1,
>  	};
>  	info->part[i].mode = mode;
> +	info->part[i].handle = handle;
>  	info->nr_partitions++;
>  }
>  
> @@ -1572,9 +1581,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
>  	info->size = mds->total_bytes;
>  
>  	if (mds->partition_align_bytes == 0) {
> -		add_part(info, 0, mds->volatile_only_bytes, CXL_PARTMODE_RAM);
> +		add_part(info, 0, mds->volatile_only_bytes, CXL_PARTMODE_RAM, 0);
>  		add_part(info, mds->volatile_only_bytes,
> -			 mds->persistent_only_bytes, CXL_PARTMODE_PMEM);
> +			 mds->persistent_only_bytes, CXL_PARTMODE_PMEM, 0);
>  		return 0;
>  	}
>  
> @@ -1584,9 +1593,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
>  		return rc;
>  	}
>  
> -	add_part(info, 0, mds->active_volatile_bytes, CXL_PARTMODE_RAM);
> +	add_part(info, 0, mds->active_volatile_bytes, CXL_PARTMODE_RAM, 0);
>  	add_part(info, mds->active_volatile_bytes, mds->active_persistent_bytes,
> -		 CXL_PARTMODE_PMEM);
> +		 CXL_PARTMODE_PMEM, 0);
>  
>  	return 0;
>  }
> @@ -1638,7 +1647,8 @@ void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
>  	info->size += dc_info.size;
>  	dev_dbg(dev, "Adding dynamic ram partition 1; %llu size %llu\n",
>  		dc_info.start, dc_info.size);
> -	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1);
> +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1,
> +		 dc_info.handle);
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
>  
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index a9782939d82b..eb1e6f7a2038 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -140,6 +140,7 @@ struct cxl_dpa_info {
>  	struct cxl_dpa_part_info {
>  		struct range range;
>  		enum cxl_partition_mode mode;
> +		u8 handle;
>  	} part[CXL_NR_PARTITIONS_MAX];
>  	int nr_partitions;
>  };
> @@ -853,6 +854,7 @@ int cxl_dev_state_identify(struct cxl_memdev_state *mds);
>  struct cxl_dc_partition_info {
>  	u64 start;
>  	u64 size;
> +	u8 handle;
>  };
>  
>  int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> index 87c2bd73df21..baf0132c70a3 100644
> --- a/include/cxl/cxl.h
> +++ b/include/cxl/cxl.h
> @@ -141,11 +141,15 @@ enum cxl_partition_mode {
>   * @res: shortcut to the partition in the DPA resource tree (cxlds->dpa_res)
>   * @perf: performance attributes of the partition from CDAT
>   * @mode: operation mode for the DPA capacity, e.g. ram, pmem, dynamic...
> + * @handle: DSMAS handle intended to represent this partition

What is with the 'intended'? Either it represents the partition
or the match failed.


> + * @shareable: Is the partition sharable (from its CDAT DSMAS entry)
                                   ^
				   shareable


>   */
>  struct cxl_dpa_partition {
>  	struct resource res;
>  	struct cxl_dpa_perf perf;
>  	enum cxl_partition_mode mode;
> +	u8 handle;
> +	bool shareable;
>  };
>  
>  #define CXL_NR_PARTITIONS_MAX 3
> -- 
> 2.43.0
> 
