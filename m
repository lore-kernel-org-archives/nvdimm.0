Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50445425CC6
	for <nvdimm@lists.linux.dev>; Mon,  9 Feb 2026 19:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770665948; cv=fail; b=ANjASXhsOtlX9yLFRO1XeMCquQ1I5kLYHemTaLd7Jq+Zca4Y7mG2YPWTSeOtrGdoeGyeNKndYR9wJFH0QSYHKXJvrsp8OYsgrSQFdmi86nM1SvumTb3mXknZ7LHcAlp301wdOTZBOG5rWvt/GssmzecdeQI3PYSFTsXjct9b8Eg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770665948; c=relaxed/simple;
	bh=r6ph6jHUeN4B1ETxTXTtwB/vkc8NujPpPOgZDUYzNmM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hImfh8LhsSchOkuzfMspJ/wzuuMp6EgwhTR6ngW/cXiq/L9uOVstqpPVV4DgEibMmYX6mYP2GsK0QshZXCHP4RcEfcG4CmNxcgxQYSM+fodiSnB9k/dU3x9r46nJa6/pQRZmhAxqmFxd92f1ianYWJMHoMu27KM177MKYMUop9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eEkQd0js; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eEkQd0js"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770665948; x=1802201948;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=r6ph6jHUeN4B1ETxTXTtwB/vkc8NujPpPOgZDUYzNmM=;
  b=eEkQd0js7i6BgWy/qVaLMy556Q+vTyXFNMoNIbMVPWcaaOj8w5Mu12KJ
   juPqQwSUJXqWIsleuwcy8Hmv39mpGARXvbN+sH34URB9WIwr7htSfL7Z1
   FORNjDPcoO+o1QvimkMgsEVV3tFj2CrH4mglzMYWy0KgC3ADZU6lNxxLL
   ZXXZyCAuK3wtncmsIL2BDt3FbPL1f8Tj5WsmoLCcRIlepNJKZGP/wHh7K
   ZrOEBPSnMdek2dPdnJmBI5wcPsKmbK/LA4w4OkWoTKyztdoND21joOCq2
   GSkEdHHFHrVIVfDR3n/jN1yFdXynQL47exjYOSlUYo9sZbue+lCQ8Osyr
   g==;
X-CSE-ConnectionGUID: ZGMcpEmmS7udW6mG96Td/Q==
X-CSE-MsgGUID: Mhhh0lCIQo+dmhhDA64qZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="82891488"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="82891488"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 11:39:08 -0800
X-CSE-ConnectionGUID: +N6NIYrUSruhM5Vizb04iw==
X-CSE-MsgGUID: kcBprz63QDGWhV8rGUig+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="216071045"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 11:39:07 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 11:39:07 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 11:39:07 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.48) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 11:39:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zJFy6WIclu67HooLfGBXMeBJtbw4xX1EqfS1u0jmg4ct/BPNs+koU4Vl8cZtOhnG/zHz1w+l6eGFRlwZxfOFdmPlxuoWgOslBhgxhgq2e9VA4bF++XKvwRAl1QAz6ZJSpN9IiYBnqtKWiC0466A3QRg2h5MFaMzMu+egttKxZUxkkAOlee91rYlfOP918A5QG0c55OIzwt3WrZWmp9uLO9GUTHmh9SxTK+UmO1ZW3SkDOYQevaxhoVl1ngEX7I0ZQJNj4eo7fFvU/N9PQwhrqwWeMhRqCHOPNkM55ngVO30RzoP78dmFVBe//ztQgpyURRK4+W3E+pryP8JdXgRy3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFsFUMHN1laxaXnnRBaEVPcItu98JNS8vY88TsbiizE=;
 b=vRWFjZv9tB3vaiY85WldbG/Y0owg3WmtJc22fDXb1wgw62JvtzWflmuG2PXDEMzodrnJFqn0Ahv/AdGH8XWoynfeowFKCvm2GwzD7mnhfYQlxlqTtFlIECXmwsKL4Ej+s7PiAVelaopFIoICVo0igIeNf9ls9FKmPlOT55tRB/Lo4Vy+0N6WeedmX/k4mLxX+X57DNSMf10/p6aMKckiP9CRZe+TdPCTT01GR3/I6BUh87npIBNarua7vvA5IkioOXLB1mz4DLI0EzbDr7AahBAoJc3EYaP1qIBIne2AUEYtBwNnmuEgbdGC/cjskOm6CQgFimOfCEEAhaCdvaD0aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CY5PR11MB6488.namprd11.prod.outlook.com
 (2603:10b6:930:30::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Mon, 9 Feb
 2026 19:38:58 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::1340:c8fe:cf51:9aa2%2]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 19:38:58 +0000
Date: Mon, 9 Feb 2026 13:42:22 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>
CC: Alison Schofield <alison.schofield@intel.com>, "Joel C. Chang"
	<joelcchangg@gmail.com>
Subject: Re: [ndctl PATCH 2/2] util/sysfs: add hint for missing root
 privileges on sysfs access
Message-ID: <698a389e5411c_c11ee100d7@iweiny-mobl.notmuch>
References: <b74bfd8623fcfc4cf1078991b22b8c899147f5fb.1768530600.git.alison.schofield@intel.com>
 <4e4ba50b1130c2a76bd2f903aa00644e43faf047.1768530600.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4e4ba50b1130c2a76bd2f903aa00644e43faf047.1768530600.git.alison.schofield@intel.com>
X-ClientProxiedBy: BY5PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::39) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CY5PR11MB6488:EE_
X-MS-Office365-Filtering-Correlation-Id: 09ab7e32-0e3a-4a69-6759-08de6812de6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hkmGmpbQclL20Tj7U4kmKAQdubOMzUyVRffjI0J+bGrhlPb6wyjJDc4sjL4W?=
 =?us-ascii?Q?8oD65hD4vjJNjZoJFnKXjvTt9Wf7kQt5kFKcC2hGtt4VPncgBPBJ8hUog2uB?=
 =?us-ascii?Q?XNM7XmG63Syy3JFU0otCRLzg9ees9kDIDyLYQt7nyGV6/PeOYRQfZvsXa6ee?=
 =?us-ascii?Q?/iw7SfIQBp9IjzZ1KjBc4P0xQJD/RImJ9pUXCKDxc6+1RLr3U82kr/3og5OZ?=
 =?us-ascii?Q?SUlgKe5YhN7DfehymTIMs1CzcNIKUdqpdaxT1VylegjDLPZmhUlLEMEpdthc?=
 =?us-ascii?Q?5rmANFIpKoVl0fJxEx5uvJf0JZ+c9eUoCpuyCVSPaPQgxyu65qXQ5+Dghc5V?=
 =?us-ascii?Q?paF2noMCWCniwT8f2DmONfvOyoqb9NGHnwjSHg1Eg13X30af/LZEkwPt74Xi?=
 =?us-ascii?Q?k1oXFSeLoYGdU4D3JNFW6rPXZGrrjAVdghJau6kcG+zpQQDg4I+ria0UbH8m?=
 =?us-ascii?Q?JfRoRuM/+3cXWxvuX7U8g2FARAVhAvImcP1qvYk8Q+mqeJ96lQ5NmU+T806W?=
 =?us-ascii?Q?tGU7MDNgfuK/EWuloj96MUoTtPvma4nFhKqdYTrVcAAA9Og7mjQL/FC31Tgt?=
 =?us-ascii?Q?KxgBbzB4MCf+Q5pE2sEfntQJM5sy0bbXpYHFhApScizlulM5H9Bp/gA2xuuc?=
 =?us-ascii?Q?4i0P2PfIyVIXDvSWjBRw2Hc7GQG42kdhxa3F8x7c5n/X14z5CqnSUFuxjKgK?=
 =?us-ascii?Q?RkU0aFAJF/yRjJoOUCN49wFKlQ/dIJoAYmI3Te5i6Q4mOwbgN6up2I3IJVWH?=
 =?us-ascii?Q?yWSKfJsQ40l5Ndrz50pIQ14Do1aQxXgpDDe9+MW/1SlSR2gY6QnvvCrSrv8d?=
 =?us-ascii?Q?tmeOR508cPk3IeNcmcAPE5q7k8674+cnbsShAwiUvx++I93dUvmcibXcwqQC?=
 =?us-ascii?Q?lL6/tFh8VHLcmlkR/TLuq2ga/Ov8zCnHla7x8M3sv1l0vKuI86csxStmgmdK?=
 =?us-ascii?Q?OlomRUBYJbWzclZdOa4mIK1iQHAueM5fri7BGFSK7D/p3tm8hbyUjPHJyJ9M?=
 =?us-ascii?Q?6g6bzs305AMuM2t4dKy6jUg+0y0KNs0KH8vY4qijs1tFB6hLVp9LlSVSL4bK?=
 =?us-ascii?Q?MuvOWFO6EpcN24Fc0H4DZoeXjPzHv34A/h+dz4zMzydhqXvUJNe2uNinOdbg?=
 =?us-ascii?Q?BFRQvAWZAdACVBKajLrooxtPOxjPWZ5KQ7bW8fH89BW3vyXGbQG6slHxFAIK?=
 =?us-ascii?Q?hcT9G2xrCpy1PKgKgm/ioSKOJWZksG2aTIg1oWxdWpWAVml/BH7UVsbxUlOx?=
 =?us-ascii?Q?icbgb6tdOuJn0rXzqPWbHHKBkOgq/nx/pq/uuZAObH/36jvH5bHXIm+uyaK+?=
 =?us-ascii?Q?UYSSmKZmhw3fbYyjQyk2yJAIwi51BKl7iC/s+nee3hPuhQ3mnYTr/KQ6IiVb?=
 =?us-ascii?Q?UKVA2zIl0WFDduxnyLo9WSvtG81612aw0Nx2WHv81WVJNoBDjMaqeWfJpFix?=
 =?us-ascii?Q?ilsfouhdgzreO/KNy/gB/hshilvHzBd6tv1WNbxUFC9j40ZfafkaHL7yBIGy?=
 =?us-ascii?Q?+6GP6JazhTTFLesGQiWoPEtzveMwx2owqqreCInDyF8Zy1+ecvtA71yYiVvA?=
 =?us-ascii?Q?oUx2kb8FTQy1acjoSnToyhhAfAa2lPOvoXPYRiBs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Iv+plpkMlsdecXLzY1Wk8gWQXdMnSDtqOP1ZFGMrgwOo1pL1MZkOR7wex3EW?=
 =?us-ascii?Q?+Oqin2Pc7wO6Kj1f8sxkjoMk+F3T2ddNpCiD83kJiP8Kv2Vma1NPI3NoWxZQ?=
 =?us-ascii?Q?DgjXzcrqHyYpo0EisboOQIYMTbYf68OlsFakaiEbT4DrvlKoPUi7o9RziOzh?=
 =?us-ascii?Q?5xEmfSS8xCt9EzZDyYsPfadvGVCMFhdSp3POboYOcCAKvWn4wJxNm2AgVmSt?=
 =?us-ascii?Q?CmqEV6C/1ZsE1d7SctqcW3CDyyhwqa4x0se2B2Xzhw8gvtYZiERLaOstf1Ov?=
 =?us-ascii?Q?+FA3Z8iN4qZvc5J9/i8VSyg9Go2frPlx7+tlqF98LO+TwnhoXo4jwHAIXkVX?=
 =?us-ascii?Q?PLUu1zkpb2vWXOJkIx0gnhT6X18taweATsSn4dcGApFWZdY0nknEVh/4Tde8?=
 =?us-ascii?Q?s87GOcKWSLBmAmjG+xpLqrZ//d59ZOfqdCKg3y2QtNbtQaVq4aanbXR8O5MI?=
 =?us-ascii?Q?o41auoehdsqdyXfMH63lwqW3T8i0371VnzAzFM9NmtBVXIcxRn/Q6pzx13v7?=
 =?us-ascii?Q?DMLbi+qb5owsNBkhFee/GCnIZoS6fg40ivPtWpRCyjvM0+9O/fiD4h3C6amY?=
 =?us-ascii?Q?eGuwEsLanDDzMaeL4yWYMmVwPX04m0wYaohvAE2HWq/wsLTFPirzuNuo4DXm?=
 =?us-ascii?Q?SlxtDGU5UQ6bAia9JU/0Ox+FRaNeRdcgIH9obMt6mQGIMSVIcNFqA+aOPr1O?=
 =?us-ascii?Q?x1ZrKjhpYi80chlvazN71nj62YYOWNTuV4YUp1oEcgldTfrYQOSXbPUZiejh?=
 =?us-ascii?Q?ZOE/bsE7tWYxgn20eF2mGUFPz9NZuMBE82dAsKNPNMz5z91K7pAMPN7ysMTD?=
 =?us-ascii?Q?iNOZfh9HcM8VsWeIA50RbPRhEd/CajMQ/qQve6+GeUdB1IJQBj5kSDKWEC5q?=
 =?us-ascii?Q?wSIyaJNaJqFGTC3rPJdZZRgRH3JuXLuZDO3VJmRXb7FQYPd4KVJ6OoPFVDff?=
 =?us-ascii?Q?6HUPDLpXooJynTN67z7g/+lpZ0SYEGtp6olzuQ1wZdND8cANK6G8BZXCExGy?=
 =?us-ascii?Q?xazkGIEdnZj8LuXZz55e2v6dH/GFMoDF6aJ85ysJT41tcXvq9NWdkSCsDlsM?=
 =?us-ascii?Q?Rni3OkrgCIzpL46XhbqqSmeqYgKQoI7DvogoaHHyfEeoVouGaLcGkxnlzfDK?=
 =?us-ascii?Q?EcEHGvNL9U34KmlyEfvpNL8PZCuP7FYv+01Wb7wIfqlJ7mmrXMs4E78ZEToa?=
 =?us-ascii?Q?je6aUjSq/pkaipHkiZKqTZPoNa3k0lTH2PP9Fzv0XwOoTUOkSh76/t1wcCsZ?=
 =?us-ascii?Q?pM8yOx46G85bLdF3SVRIx6NiDn9AeGtqjxztze5mRI4dWaqDeNmwwQB28A7X?=
 =?us-ascii?Q?JkdtsX4mZyaHo4qPIQDPzVOz6+J+KY8ysDB90dBP+Se15uKzK+2Yw+zx7yJN?=
 =?us-ascii?Q?m88KtKz7uq9WEbGQmOqittLqeRsVAJtUOuO4+q6AnK83kP71+/SEsY1s7Fdc?=
 =?us-ascii?Q?+pS8VUx1Y1d9a+FtQaG7Bwr58ybX7U+AqyOz3CWGXjgygxhbUJhhOgP5kJF9?=
 =?us-ascii?Q?D+hxoPQvf9Vv2WAtt/4x+/daPVHspXR3KkxwusteY62elVB8gNLhQM9/xjEr?=
 =?us-ascii?Q?scz2jTz9L06UcbgsNDJCRwvZelMkHTkf7QZq97DtC+6SlmvV9DWDwCf9xuOJ?=
 =?us-ascii?Q?crgLg82gxoXqGMalaUPsiQn911j0i+1oLLupwOuxg6vNAlaGe2I0msNikl+T?=
 =?us-ascii?Q?iN4yrlTbLJriAzNGeXZPa6YCDAObD2tKUwnlrS9d4Zsa/zG5myb57MWoS9Mt?=
 =?us-ascii?Q?NlsSmPBRmw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09ab7e32-0e3a-4a69-6759-08de6812de6c
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 19:38:58.4637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zmq0YsffT/ukwyjAgW7dfMUQjz6a0t39fAOFYol5bXeK2cDHb0Xi7kitkXSsFqjxIYofWrHaIssz2UxwY7xSGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6488
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> A user reports that when running daxctl they do not get a hint to
> use sudo or root when an action fails. They provided this example:
> 
> 	libdaxctl: daxctl_dev_disable: dax0.0: failed to disable
> 	dax0.0: disable failed: Device or resource busy
> 	error reconfiguring devices: Device or resource busy

If the error returned is EACCES or EPERM why is strerror() printing the
string for EBUSY?

This does not make sense.

Ira

> 	reconfigured 0 devices
> 
> and noted that the message is misleading as the problem was a lack
> of privileges, not a busy device.
> 
> Add a helpful hint when a sysfs open or write fails with EACCES or
> EPERM, advising the user to run with root privileges or use sudo.
> 
> Only the log messages are affected and no functional behavior is
> changed. To make the new hints visible without debug enabled, make
> them error level instead of debug.
> 
> Reported-by: Joel C. Chang <joelcchangg@gmail.com>
> Closes: https://lore.kernel.org/all/ZEJkI2i0GBmhtkI8@joel-gram-ubuntu/
> Closes: https://github.com/pmem/ndctl/issues/237
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  util/sysfs.c | 31 ++++++++++++++++++++++++++-----
>  1 file changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/util/sysfs.c b/util/sysfs.c
> index 5a12c639fe4d..e027e387c997 100644
> --- a/util/sysfs.c
> +++ b/util/sysfs.c
> @@ -24,7 +24,14 @@ int __sysfs_read_attr(struct log_ctx *ctx, const char *path, char *buf)
>  	int n, rc;
>  
>  	if (fd < 0) {
> -		log_dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
> +		if (errno == EACCES || errno == EPERM)
> +			log_err(ctx, "failed to open %s: %s "
> +				"hint: try running as root or using sudo\n",
> +				path, strerror(errno));
> +		else
> +			log_dbg(ctx, "failed to open %s: %s\n",
> +				path, strerror(errno));
> +
>  		return -errno;
>  	}
>  	n = read(fd, buf, SYSFS_ATTR_SIZE);
> @@ -49,16 +56,30 @@ static int write_attr(struct log_ctx *ctx, const char *path,
>  
>  	if (fd < 0) {
>  		rc = -errno;
> -		log_dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
> +		if (errno == EACCES || errno == EPERM)
> +			log_err(ctx, "failed to open %s: %s "
> +				"hint: try running as root or using sudo\n",
> +				path, strerror(errno));
> +		else
> +			log_dbg(ctx, "failed to open %s: %s\n",
> +				path, strerror(errno));
>  		return rc;
>  	}
>  	n = write(fd, buf, len);
>  	rc = -errno;
>  	close(fd);
>  	if (n < len) {
> -		if (!quiet)
> -			log_dbg(ctx, "failed to write %s to %s: %s\n", buf, path,
> -					strerror(-rc));
> +		if (quiet)
> +			return rc;
> +
> +		if (rc == -EACCES || rc == -EPERM)
> +			log_err(ctx, "failed to write %s to %s: %s "
> +				"hint: try running as root or using sudo\n",
> +				buf, path, strerror(-rc));
> +		else
> +			log_dbg(ctx, "failed to write %s to %s: %s\n",
> +				buf, path, strerror(-rc));
> +
>  		return rc;
>  	}
>  	return 0;
> -- 
> 2.37.3
> 
> 


