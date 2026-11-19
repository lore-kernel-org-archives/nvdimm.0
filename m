Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795118092;
	b=kBrQVC2BXQgtSM8RZao1lps/dqwo4rlvb21rmuuu/qrFD5hQx8rMUOohXc7yYaUdlh5v
	 BkR8zsQSJ1k7+vl6Q6Lk23ijBlvTLBdcX5U3kARHFuZPXUMFQPXZ0oCOXrESVpbmf+eN2
	 5PAVua+XcOTJ2HmpcM8bSS5JHhEl2FwyyiOLGS/OtUrIXynyE1gVTPQD3/IlFOM9fQ4bM
	 P7ucViolBliwYuD/sOERrl8nSUM8cH5T/+MeAmTVFD2UnDFACIo4lItcptVICZ18LiSDm
	 qqT9Jvf4nVeF+NFkemyB/Sz1q0W88Hu4Tak3j9WE7MYuxG68GedN8Y1lKPky0we2esQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795118092;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:In-Reply-To:
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
	bh=9q4QTi5AE9Ch4nXzg0i6rdUl7rDE5PnGXDmchUbpMwI=;
	b=4l8P9Sv7HEK9lG/0NMubxCarQivm44MB5Y7YdrmYVDBIsm+FKQh+oY9eV/nAHTtMZVJP
	 aPRiHOCJt7lEmzrrIJHae9E/zMo5yivT41B5OhQ2Z+jdPNnT1j112ZSoiUxW9ZXrg8z5/
	 2xGUbZ4p6AKB6uwQ/D7+w8bc1YKTd3GcOh0FzLiFUUpzS+pqZOLNQ8olvp1ouGbQ9oGfd
	 ILYasdRidrLdttS0BU7t6um1GRSjvvmhCwRHBEzNd5Rx3c4/aOp5MWokNhLEGzRNc3WrP
	 9kY3/MAppxueCWLffQHbzsVpF7UhDZ7zFsOggAEK6b4PNYrd1fXyN1thHEQuT57U5iA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=d7DTFLOM;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=Y2B4YUGE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E64606A32C
	for <nvdimm@lists.linux.dev>; Thu, 19 Nov 2026 19:54:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33E64606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=d7DTFLOM;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=Y2B4YUGE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795118091; x=1826654091;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=chLCVL5WGt80wpotvSSymb918OgzgGcc6nmgNJMsv+Y=;
  b=d7DTFLOMKjXG2Wa9D0L+IhfbX32S8ymnvfB4jNSMQnh3F++/7dNbGS7H
   H3B2EEWCefTxVUWvznGkEmyxvU98oVXi3NGJUbB2V5EU1pIbAgEeWNOMI
   MsXc9R7pyluPT0sL04DEefM30FByO7H66NSr896vJmW6dUKrTecNiAgKo
   IJYs/QetkBmc9JPxizt9ih6qAZPPdb+z9YtBJrUmrzWAKDDPgqyIEQiGA
   9xYm2Pc3sX+ZztBb2jZLhcDXR//GholrblgNOQPX/6cLv+F047omO89C/
   b+7Lv3mfSitjo+cW/0JA8cXvz8560Ya0WBK87syD6l34fxVkugqa3SqHM
   g==;
X-CSE-ConnectionGUID: TFjaeizaTSiet0TIa3Zhcw==
X-CSE-MsgGUID: 1tR5S4diR7qPThMBKGcNxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3869788"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3869788"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 11:54:50 -0800
X-CSE-ConnectionGUID: V0vt8r6KT5GXuAePDaHXCA==
X-CSE-MsgGUID: +WeTzlNISoqiwRtPtViR/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10774557"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 11:54:51 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 11:54:50 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 19 Nov 2026 11:54:50 -0800
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.39) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 11:54:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xZy7w8oxNMSmNxcGZ4+W2hSbSOe6gKJFbNHn/OKRuQP9XCiiVBEiXeylQhpkD0A0WZQqUtn3EAevkMtLfbXs1Hq1Q5rt8iHHJ7KUZWh7pe1d11dHeQ0A5PyxG4Da3BLc9IpxfpeBI8AOY7jwDuwO2ZtklmEDBvDYFtoN9N4IqtmokheSQj1rKXjtICx2rLK3vdgAF22hc2n51TAmzLCXBjbo33dQ3EN9H8ptLMx4cWaLu9S7loTKszimPmlZLzTh4q82R4ZGSEwVtFURjIdf6bDuaBCYjAlu93qssI19wpc2upGhM8wh0sXIExuWTjixpF/kW477/CM2DDjWsoG+aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9q4QTi5AE9Ch4nXzg0i6rdUl7rDE5PnGXDmchUbpMwI=;
 b=cZDTgiUrccAHnbZyNmHfuUCyH0ePNWkkDh82emNk858lZVPrXu9K1N/o6P+uOuCqIG8vdkag4GHJH8GihCMCp84ioWZbaV4pwXBAu+SSD+G+mNG2vLE7w4RWxw6X4UerMd/MP4pZFoJDkdRXUnbhB1aBpiwl2tN9l0r++arv91c3Bwg7PhaSVQ7hsvcTwiU01fUBxdsrJwpN1AedxdBiKaS+1TjD/yVqXcZjRsgFXwxVHiuucv23C5Mo+n8tCrKD0mActmg0oTvjFqD0WqCNgOCQSMYG4a+0ZXFSAcoBJd2edclyVCMAsIHED3VE3eBSdfJFDXj7ZBLI+Vn1cViHqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9q4QTi5AE9Ch4nXzg0i6rdUl7rDE5PnGXDmchUbpMwI=;
 b=Y2B4YUGEuwDIxnnrC9nfKgy1EVNpfr2ZjddliyECeMKhKm20ZyLQNOimXuVBgeHwO3rf4sGNSKmhbTbOEko/foGD5RZ0G81o7Xc6WVEJvL1P71Y8x5xYVkJo3ERE+KIgZXXj9s7QJCUemmKZoOMqsvUcyiaHzfert6GkMhuWSLQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM6PR11MB4609.namprd11.prod.outlook.com (2603:10b6:5:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Thu, 19 Nov
 2026 19:54:47 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 19:54:47 +0000
Date: Thu, 19 Nov 2026 11:54:44 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 0/7] cxl/region: create-region command and unit
Message-ID: <av9UBFln0mn_U531@aschofie-mobl2.lan>
References: <cover.1790658549.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1790658549.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0229.namprd04.prod.outlook.com
 (2603:10b6:303:87::24) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM6PR11MB4609:EE_
X-MS-Office365-Filtering-Correlation-Id: 57ed9c07-1239-49d6-1433-08df4676f700
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|6133799003|22082099003|18002099003|11063799006|260925021911599003|260925022911599003|260925021311599003|56012099006|261022075727099003|261026140227099003|261022105027099003|261026121527099003|261028144727099003|261021121427099003|261009223027099003|261102123227099003|10067099003;
X-Microsoft-Antispam-Message-Info: LSQJMNsyhqdwHpesOTfI/I90P8Pq/YIe+FkIl6ZGBy1U5Xcidha3ruY4iLSSCm1ASk82/pykuS/rfHPUqnpveT1qvqi/ZXBaz+WkmQUVpWaSuRnhmPJQJ0mwVDMQUSCsKy7tH/AFF5Z33QmQFRZXk2AEFZNqO8rRv7kDWAjlOQ16Vlkx8njReowcoDuJdh3gJTvRLSY7OqhMIz8anAQQtx1J+JbGqSyLHcZHMaguISN7mVVp9/z1wRNJ0nItepcGwTo2XkG4FC8w5tARHsRYZOMFmHwlvsubfziVqAL5rSLGqtDUQLEvbUfg+v/01YzDDuYui3A1/tqYxr9ZT3aOv2MK074PqJWovZSmXhXetF/XTn9DdHiTRrJky6XuX0fJ4TnKEX9P+Nm06n82ft9I7YSiiEcbFgvqXQJ+7NstbEDXBRRVgVIGYYdBUEuipGAcUE2ns/HhqH049iuVkIQUjG6GHhGnW2aaWRVMqDIjPjjW+CqHn3MZKGR3ZT6jjnJKgVYv2/AoWPH0/WUA7oWxFSkKpR/2409fd9qooUwy72kQT6mTjOutOjQiL9SsFDOjWhRHyxmbGgR3MlXGCczg6l9P4cYXgzh0o45145puioPzmAAnpbkowMouJ8twzSjf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(11063799006)(260925021911599003)(260925022911599003)(260925021311599003)(56012099006)(261022075727099003)(261026140227099003)(261022105027099003)(261026121527099003)(261028144727099003)(261021121427099003)(261009223027099003)(261102123227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9wgtl7n9L1NGF46XWUrzXtP9I35+pG7sN9d+wqSrr4cd0Al/9pGwT+0y857u?=
 =?us-ascii?Q?atnH25v5HYcIT4vUw2+V/8B/OJWNvFbr5PCl5dZdt3140vyDqbWi2qbjrVdm?=
 =?us-ascii?Q?23a68PDi0pmG71AvV9M6teNAqbU9W7POUaetVxQBWUtyo1/Q9N9d6kST09sD?=
 =?us-ascii?Q?dG11RA1Nr3os9xRT3XhEn8l/xe7Nw93XU+PsKvd+uc16/ehI7UEamBbd5UEo?=
 =?us-ascii?Q?UrUep0lmLxG7goK2edcwqb9QnpS6tR4IDNDbHPzBZztXHVA3wqb9SB5wcmxR?=
 =?us-ascii?Q?KRBXFxSLY7+u0J81E3jTxmlu+zvQozlajo6egx9OzRGiZekPt57XwG4qiX+K?=
 =?us-ascii?Q?3qYFHvajclAcbQ4N4PRwxOtapzzwdRjDVc4KRKVM+gjd7mikkQlNFrNTm97+?=
 =?us-ascii?Q?f9QvV00DzSxXmzoJjWV37WLqbMf0TkZlQyg7JH/RCIUMtfmXDboKSS2rNkbx?=
 =?us-ascii?Q?VhNuuA7l/iCHtk2a2IF/1VwDHqkVwi8Obq18FEcr2DGgYbWFy92hwfY3mkRt?=
 =?us-ascii?Q?FMwhRQyc5R42+VSKKStAKWyvxNiRKqy0UZakn87XKhyXF/SbnYjIw2oRHmq5?=
 =?us-ascii?Q?CHP4kxD+Uuir3z7m+6+1nPl5/Jb07MRvZ+Z+LNo6nTHpqDJn+9kBbWgbNNrO?=
 =?us-ascii?Q?4EmYz8Tp9uCUVn1pcDHUnK6gE4GmsogxgWU70yuV9gKxTEUWZd30iS1vcOHN?=
 =?us-ascii?Q?moavQrvPcSYgG1LToyc/oeN3etk5KydPVH0WOTTJuuREAubhzkCK2SDqwbLQ?=
 =?us-ascii?Q?P/IWdcoGn3bgxsUPqiJf4lq9zgQ5pUwCu4H0rQtD4vpbyzdKjag/DsDVEGcB?=
 =?us-ascii?Q?yP6onE9kNa4WDa8byRczJxIXhSG6BzVhNmTjEdsWM6nnWebKqVff8GuqVf7w?=
 =?us-ascii?Q?qBbQZCiCbwIXBByXxMbtW0kBFJBqC8KEgrlttq1WrbqGevqu78kPHrkCWhQE?=
 =?us-ascii?Q?6PueCAs3aFYbBdvF58rPMvosDIcbppGNNUUpDzNuDd7EoTyrRncNtHfGTdL1?=
 =?us-ascii?Q?bPVhhAeQ86KX3he77LPERbd8tnPrDx34tFG6Q0doo1xF4Dx6D+wKLOPQBHZc?=
 =?us-ascii?Q?crgwUcTv+tZsE0IroPN5Zs3GQ+oiObqmxE8/HD+Qb1BjkGOGgFewHpraXpyy?=
 =?us-ascii?Q?4DF7hIWJ5DNxeJTPSbLtVUvtNe6mZUFOQ9tURWWWduyUS0fGkdylojpz4s9Q?=
 =?us-ascii?Q?JfeINi5bCp43YhaVG5XU17h9KZJzg2ThbvyS7iJTQLHZAggciulh/g2IitKW?=
 =?us-ascii?Q?Mlts0kHHJ3dfKDoHjWA3IPl5Fpg5fkiJiAReD6oDpxnomOHDV9mer9SqbfMy?=
 =?us-ascii?Q?BAiPrWWEWJQ0yJaGSFQtzLI6PF5fHo0YeRM3WET4t/QST2kLqPD25R1/Swdb?=
 =?us-ascii?Q?DeqE1DVLCIy1PhjsZ3pEZowl1K18DJn+dlhuYjMlRWt+0Q90U36I0al2l4XS?=
 =?us-ascii?Q?MZ91fbaw4H/BBgPBrAZkSKvA4Ptkpm/TMWmJ6i1JUT9Yv4kUIqYTufayb9Ls?=
 =?us-ascii?Q?ThupQESwNqL1x9mF3rPTkn+LUViSrcr7GJpvwm32OIsVVn8j0RfO9UOeXHAR?=
 =?us-ascii?Q?RHCBWdvNdUwDRw67vRXd5wl6zAjVpGSFFEk8WUXCh162O30+ioqTu+w8TpYY?=
 =?us-ascii?Q?Hv2+NeG2ewwgMstZ+mpSvsZuNtp/NJIsrcsxYk/g02NQkK9WllvNXycLqV5J?=
 =?us-ascii?Q?9KwEp4U/7X0Z05StAdPdBVio8QKZk3emZv1Y0su/6sLn6DaNH/vO4yzGpJnv?=
 =?us-ascii?Q?03WWfHbexTOxm9mCJwp4FFYBuayIwO8=3D?=
X-Exchange-RoutingPolicyChecked: egiZDkqPsF0D5trAsaaWAQXsX3iSiw2jqE/IS4btmcblGLDgoKIDvKyAIE99/lLYlHZ7E+ClDiLd3v1tDiMAGgbIkoRaHhMt86J9KFj5Y3ehYF/LuLqPd7ZioxIZ0rwEg2tS8eUJxwW+/Mok3z0/DshV61CcRhqaY4FKvthel+DB0ktCaNkYB1bEZcvgUowf1mlJxUKzcPTAf5qhOOxOaVQCliGkwHTpOI3Euu1bSIrCIk1cBGvas8z+JMqufe8ZBAiYwM58zQW9IsbP0loeUwEqN2G5lCqrW2QENqwOZZRcejXRhbkTjRc/8l/njgk2aYp4mcOR55Z96Q8HxUFYZg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 57ed9c07-1239-49d6-1433-08df4676f700
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 19:54:47.6454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OwjG4shWHIU4FnI5+DLR3Epcip9IP8vZe2602FU7qwQlnbkWwu1bjSOH3D1yOmHWKGjWP4QvHpWdDYwA0DFYUmmjNVLycPHMLoyDz+hjrA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4609
X-OriginatorOrg: intel.com

On Mon, Sep 28, 2026 at 10:36:52PM -0700, Alison Schofield wrote:
> While working to enhance the cxl-cli cxl-create-region command to handle
> out-of-order target lists or no user-supplied target list, I ran into some
> basic issues in the existing command that need to be addressed first.
> 
> Patches 1-2 consolidate and clean up the existing create-region tests.
> 
> Patches 3-6 fix target-list parsing and validation, release DPA after a
> failed create, and move granularity validation ahead of region creation.
> Each fix adds a test case for the problem it addresses.
> 
> Patch 7 corrects the documentation to reflect that --decoder is currently
> required. Automatic root decoder selection will be considered separately
> with the upcoming create-region usability work.
> 
> Developing tests for these fixes exposed two bugs and a topology gap in
> the cxl_test mock module. A companion cxl_test series is here [1].
> 
> 
> [1] https://lore.kernel.org/linux-cxl/cover.1790641236.git.alison.schofield@intel.com/
> 
> Alison Schofield (7):
>   test/cxl-create-region.sh: fold in XOR coverage
>   test/cxl-create-region.sh: deduplicate topology lookups
>   cxl/region: parse comma-separated target lists
>   cxl/region: reject duplicate or unknown target memdevs
>   cxl/region: release reserved DPA when region creation fails
>   cxl/region: validate granularity before region creation
>   cxl/region: document --decoder as required

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/

