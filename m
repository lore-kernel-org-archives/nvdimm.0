Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793916001;
	b=WHgeMbxrTGoxPwlexjlPeawC0+LhVsL70LWcDR5R7WHtzVIDelKJ8GmibV87FxdpUPAH
	 b+WIp17NP8KrLE5jlVXpRxZBJTYWxF6tDz8puOOeUv9OqohNWyPY9+ngPeHMgIyILLO7P
	 F08JoHqVWB1RRUFFqdAGnNmm4dLFBy2u3mBDwGrd+X3zjwIAtQ4njl3glVHqMjXwnn5kL
	 GWoGXouL2aDuAOzy00+40MPWv7R3XFkMedZsFXi5qJtRYf45Aq00nz9npgMhL+ffjgZjN
	 taiLXOpv8f0vgbcJByata7hZXurg0/Yk2j95A7pWoX3KzjKeRVdj3hkHOtbenLB6Jag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793916001;
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
	bh=ftxaX0GanRFWoFF33RkiTsGGA3DANEqPDtS0/OxNYJc=;
	b=Vd0t1SS0qtvrRalIQxs1QIkit0woglXViz2DHUUZxXfWRU2hpkM1zeS+6t6f64PGZK98
	 4NXbr2kAtGcFKWdMM1BXm8Y27bm0jYd6WEwatXKZMEkmU7Ui551v2Fd83Cuc3vnmSjjfo
	 DHulGnfO9ixdYEKKOoujT+J6Lsf+ejOBWnCLogf1TJtngNq8h6oRoycYjnhn0ovhYAvP0
	 0Gk1scHgGbfApXsMX0NO5vVZ3ypdUoj1GNqMc2p+ZyiEcI22Mzu+NKpfj9sRIuMNXQGhe
	 H0jJaWJI30LXUhHHyvTeodnbjTirXPwIADff8+1l3Ti4Ok2Dzh+zmbnPrt4+aeNOItA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EueBYkTP;
	arc=fail smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78D8606A31B
	for <nvdimm@lists.linux.dev>; Thu,  5 Nov 2026 21:59:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E78D8606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EueBYkTP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793916000; x=1825452000;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jV34Hk0KHdtFkYIeW0GnzLKSnxT/ndnN+hCIV/9wYgM=;
  b=EueBYkTP+udE93yzXE4M1pmTb9SrfvbJrATr3bE9LiUa9GWYp11TtoAo
   N4innxUFQ8B46JOe585MG4pKE8c82B+MH4LzcRtaTB0vFMDoIVLuXxbgl
   ngS6tcq5WYpP7KRAkebiz4gXSHG/lXw1XPe7jlq+So4WOWTZ521dqylNx
   OAEfFHZf0bc6cdKLuxRynpK2ZzT5XMESk+rPydAIr23A/5Nku7pShS6dz
   U3WjRp/6d9izKfg4ZPhRj4ZjrA27Xlp6REPMDu41ZROanbbxrPPUmFYxt
   rn+Z5UwgdlRG8jbyXrjmC+pVjv53n2o/E1GdWEH2jR2mNBX20RxVqUVbZ
   g==;
X-CSE-ConnectionGUID: Q5OntF7xSr6foNDcAlSaZQ==
X-CSE-MsgGUID: YAl6P03bRI6q2YvPVzuMKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2624064"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2624064"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 14:00:00 -0800
X-CSE-ConnectionGUID: fthuWJdKRtO981xHhgIrXg==
X-CSE-MsgGUID: QH4o9TjIQTuX0NHAd6pGZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7437851"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 13:59:59 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 13:59:58 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 5 Nov 2026 13:59:58 -0800
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.36) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 13:59:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XV1z5wS5PhWLAAOxkEq4yJZJiqj1n+rWGSRGE4m5XA0vX1lo0nmSUoMxw2dX59JC/x64Q3mDeFLedaOw0iOG5flqjWEYbmHMoINTLU72JUaicXxaWKDijkXZJFSEwPywg0OfXIvoHzvY61lgIOc1uAxqyC2mCf6iOuZ7XKfHqZorkR3G30MxhBsQ58nTdjaoUafvfOyhqR4g3JHpH9gZLdgCT+HW2PN3OW9iXwao80+tgYPDQhNtEmeSb103VKlm/UPCkE0m7qyC7h1E2y6J7KrptAVosM0nW4ls6ctG2gl7S1xAUNGkl+za6ua9N5UIx2+VhRp+mxJZrD0zhvjalw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ftxaX0GanRFWoFF33RkiTsGGA3DANEqPDtS0/OxNYJc=;
 b=gX37atSfXmORi+tYdGHfqxc5vPnJBBkN/e4Y4DL5q4O5QbU9i+ZBD/NHJRzizb89RW/BGwtx0OdDQ0Sfl1o+I4m/VNUNmvNbK2aaVWzv8kJrvXf7mw8iyvr+MVrq+suxRHZn4lT1bhyt5eQxxMdeNcx8H4mE0GG0hEQ0Sk51C1gbfIGWmyP5Nzj5bfe6a7HS/xpnNg3j84PZA+usx3prRnW79kDHBnYb9vz97mxbY7Mu/YyS5KHoEnqLtN/VbB2EQoHZE8jTHixvQkNxGRoPlsSoVqOMgBMWWgd/JaMnuPZ+GEOfAgpHfN7k5YksgTfQUyBwKj95cD9pYSl6m/SchA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by BL3PR11MB6459.namprd11.prod.outlook.com (2603:10b6:208:3be::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 21:59:55 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 21:59:55 +0000
Date: Thu, 5 Nov 2026 13:59:52 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, Gregory Price <gourry@gourry.net>
CC: <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v2 0/4] libdaxctl: Fix multi-range memory block
 handling
Message-ID: <auz8WKiGebL_L37m@aschofie-mobl2.lan>
References: <cover.1793315621.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1793315621.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR03CA0170.namprd03.prod.outlook.com
 (2603:10b6:303:8d::25) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|BL3PR11MB6459:EE_
X-MS-Office365-Filtering-Correlation-Id: f2255df5-04e0-49ed-61e3-08df3b882000
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|261102123227099003|261022105027099003|260925021911599003|260925021311599003|260925022911599003|11063799006|261026140227099003|56012099006|261021121427099003|261009223027099003|261021123027099003|261026121527099003|261028144727099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: 7Tydgdnk3o/jrNsTSy4L4scnJniljYFeKnJ4hQxDtPYECRX3KNSJp7iaQJJoDyXZ2alS7cSgaADnr+fvL9ZSx02RMT7e1tr2uXpBF0ADLRXQdT6MyjZ3OBkLNhFPYa+N/t9YCPc3Ur2rCbDFneUNXpmX2RVKPqaHAPdzWhg+p99h4+druU3rCprzQAkvWS//0iX0sF95ubw/xelC2UVxwmgVivQXb7EXTBQIBlzlF53eOramC0pYMrFmoFL02n4UQzHzl/cwLKReOsdxHa4rUJ6oEj0S9uELN3bnAXhrWB5ZgieJq48B+PQ8AwZvZzTDQCXFqoB5GylKElZaI2dcCqkUY389nbJDAp8RBggkfYUKKQrvvsU6gYRL8y1XeQPvz9adf5WokW3JrgXxeeMt5gJAip1Czd2Onu6Wl7SlDr+uaaPCfdFz9poOCALmr5t4NzgnEZ78bjrT2DvmSBU21cGcwcEczgO67PGQYabkyG1txT28opyDJy8ETx0uS3WRa9xWPUJmG5Q2SYuTDVVe1ORN0tE6f3GrjFnFSkB8U8jqfAUFIO4xCkBXVS+dYleAgl5vZPsLzDcf2c9P6MV3tP3YJcoeCoC0765Upmtj4PgP664VQPR/dIdqZf9Olyfy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(261102123227099003)(261022105027099003)(260925021911599003)(260925021311599003)(260925022911599003)(11063799006)(261026140227099003)(56012099006)(261021121427099003)(261009223027099003)(261021123027099003)(261026121527099003)(261028144727099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?toKONF/a88115N2Cp1HKtz83i1wUWrZVb6YmpBS9ngkovSgkCYXXt5GguG/K?=
 =?us-ascii?Q?MkBwtDTj1HdnlFLMHjwbYH9N05SdDXymnOHRg4LhZFyOiql1Pe36d0m42bJl?=
 =?us-ascii?Q?UT0GHonpwwuWQMIFsyDjZFSSbzqWRiuQdW8as/58vlR3XDTcT2CjM21GRuGV?=
 =?us-ascii?Q?B2JAw5ATx2gor5sUhf6TdrdITnqhhdyL8i4LqfsBtXM4WYc3VH/wmrw0DooL?=
 =?us-ascii?Q?POFFrYj8pEo+ZzC8MNo66XA5Djmw7/Du6IpA0jU4lhoNisbIS+biAsyPw0KJ?=
 =?us-ascii?Q?Enify5tvR53x6oemk7/UJ2kX/qv/T0sj4UnUbFam5OZZ55comevl4wme3HkV?=
 =?us-ascii?Q?PEyPFYjCJD5ZnTtOdZCg5U1M1qzb4qPnVQ40+lr0KlElb8kxyAkhr/jnnGpV?=
 =?us-ascii?Q?myW/sgn1jEvPi/YaqURdahnXlb7WvBMDNs3wtG24B+ksOqmb5fbJWygSf88G?=
 =?us-ascii?Q?laEvIeEoTgnpDAfjBKMW2ag5ZG6QeIWUMLqWCD6laRHDC8EY4U9wDyyGUqlh?=
 =?us-ascii?Q?3gb/8T3mhRfTzGQs8vEQDvfeRvUD9/H+ltUuSrfZDmu1nbGT7uFAyLJhWybo?=
 =?us-ascii?Q?+Ps7qeAPClrwir9FI4GVfWSjRFHvMLxAPn9qcu2V2HEBkWTiMQUiidQJaDjP?=
 =?us-ascii?Q?08OeVNqYsaoloyWcGUHih7+x0/+w7bs2Sn8RtkP69w2MYaoLrXkFUjB1yItN?=
 =?us-ascii?Q?l7zCCXaCnCVUAxHxjFlAgp3LvlBsZFxhlgijYUynALJVEKe6bXm21RM7bbbD?=
 =?us-ascii?Q?0Va0qyvHvWAV4EvEP2OeO20KxdTdqru7zDs+bBQCZv0cyAO+6nQUEkqWG+Mv?=
 =?us-ascii?Q?TjGRDL2HcEvckUUrJw174J/Ro1RfKhAARwzOtqQ888gOTcz+I561m8pxz1ps?=
 =?us-ascii?Q?Wt1S3zFnqrq3obHuZ66+SkzL7bCFisoqFncXbwYdZUzUNq4ZLpfMHVtHXVJ8?=
 =?us-ascii?Q?PrFkKE4Y6ARvccRdtielaJ7MTSMY2cL5nJKRY9uT6wDLk/WDKxP1rM7FzrNH?=
 =?us-ascii?Q?1ZhHRi2KPHD1VBJKlOkVbK3OZYa7uOu4J3dOetYA6IB116EK5XCIHM9w9t3D?=
 =?us-ascii?Q?uHk3b/MFSb1BfvnqPkEKfneR8C+qHSiHTbRDgqo4a9hXVV/N6SQdOHHpY7Ck?=
 =?us-ascii?Q?k2CZf2fG4tnuWtQ/CuaAKqiD4AGsGT8V5cB03dl7orxU7rJu3nuQNsEIZci9?=
 =?us-ascii?Q?ZDbdcINjbMhG5cpMifZUA5HF42PYURDcwMTBLWnIDvjRTfijuQZ/BPYJCO4c?=
 =?us-ascii?Q?oO4jlB5Iyvxd4Gjt4Kzkutws4zf6Gqi6Nr1PKwoT9f9fztlk/zQKw8ufAxDn?=
 =?us-ascii?Q?uQcIimTwNXND0RLTLF5kwxPL2amGfDFHR5CxqWQnl9pjLJuMip4WEzGbhzYc?=
 =?us-ascii?Q?CHE2Pd4qx2/8+3Ay77TJso0cDxby0nJpGVUoVVrU1SIlYzdFagrJ88WKDU8n?=
 =?us-ascii?Q?9ymgiN+xIUzqa+1s5DKJJOa01++egpuCrySc3PjOFprVBwQEa9T9Q74d8PIl?=
 =?us-ascii?Q?O5/N5hySpifFXZ/NKhUiahyaw1cMYeb9w9C2M6VXD5fIOu0f+LdgZBH1YEXp?=
 =?us-ascii?Q?KqFnJkoGN78ck84euRSHsMxb0U5+1OR/Yp9/vo1EQbE0DyaT3icjBnOcp6BY?=
 =?us-ascii?Q?H/t0U6k+WGunJ1t1TFXZzT2YHqSJQ8DFkTnGM7SJD9kqaLUat9mXh07ZpaGv?=
 =?us-ascii?Q?NW8GcGpnmRA4PWjq/7EP7439yGEIE9BJGQEmdbA0u6vvrdKyE+hvI2OvAfzy?=
 =?us-ascii?Q?84PB6Fi3DVeZrUtMRHqzcDrnQ2Sza9k=3D?=
X-Exchange-RoutingPolicyChecked: 280QLuL2gY2wWw69wCymrkrRM+GKtEvV8cAFgAWzwcUl9II2N9vGHAgb+AO6ta8u308xdZ1Vs4qh/7btCaPkD/6mUvPz05Z+Kfx3HgbvUF6oNc9+3r37qolqs8RPXSnrecfGPDdzPWAAoMsgiaO6FDywzYXVf5Qx9zMQ8v3YfvVb88OfVJpOQUzEIJ8QwPenMn6NeSfDbm6sHDytr35FcJScISwh05BR6y+4Tho99vu9ahfXd9V8SDhp4py/JP/v7so7/eQWrv07q4DT5PGva3GoDv1vn9MLFGiKz9++qLxWW6oeqhFkPcy8MZ+3EL7s3Pud9O/MOIdDH041zDdB8g==
X-MS-Exchange-CrossTenant-Network-Message-Id: f2255df5-04e0-49ed-61e3-08df3b882000
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 21:59:55.2558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbLW+tKQCG/gwFsn73xVT7m0HK2M8fYVHTSj79KInsme7YOIT1A0gHLkCuaNYxBJ0qM/EFM5nEnxZ66HUbOzE7dKDBIVRt0UU+eiEhE/5D8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6459
X-OriginatorOrg: intel.com

On Thu, Oct 29, 2026 at 04:43:59PM -0700, Alison Schofield wrote:
> Changes in v2:
> - Patch 3: Reset errno before each readdir() (GregoryP)
> - Link to v1: https://lore.kernel.org/nvdimm/cover.1792695259.git.alison.schofield@intel.com/
> 
> Review and testing of Gregory's dax kmem atomic whole-device hotplug
> series[1] exposed an existing libdaxctl bug when handling DAX devices with
> multiple physical address ranges.
> 
> libdaxctl identifies a device's memory blocks using a single contiguous
> address window, even when the device has separate ranges with gaps between
> them. This can exclude blocks belonging to the device and include blocks
> belonging to another device in the gaps. As a result, daxctl can report
> incorrect memory block counts and potentially online or offline another
> device's memory.
> 
> Patches 1-2 address mapping reliability issues discovered while fixing
> the memory block ownership checks.
> 
> Patch 3 corrects the memory block ownership checks.
> 
> Patch 4 adds regression coverage using a two-range DAX device.

For the series - 
Applied to https://github.com/pmem/ndctl/commits/pending/


> 
> [1] https://lore.kernel.org/linux-cxl/20261016214248.443247-1-gourry@gourry.net/
> 
> 
> Alison Schofield (4):
>   libdaxctl: handle mapping initialization failures
>   libdaxctl: tie mapping cache lifetime to the device
>   libdaxctl: match memory blocks against each dax device mapping
>   test/daxctl-create.sh: count memory blocks across dax mappings
> 
>  daxctl/lib/libdaxctl.c | 98 ++++++++++++++++++++++++++++++++++--------
>  test/daxctl-create.sh  | 58 +++++++++++++++++++++++++
>  2 files changed, 137 insertions(+), 19 deletions(-)
> 
> -- 
> 2.37.3
> 
