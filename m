Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795117933;
	b=Jri3DDyWOntkkIhvq/m+9qtqjt8ibAGr2QAHLOgH0nY2a0wiWYnq+QHjTiCa+aGj0lt5
	 pqlNsYaQOMLhYSpNOMlhIT+a2+gk+iQruvWammMBPLpHGRG9y7ivt5E/0o6Iai0oBCBjT
	 4YazbpJ6p1bdEw76I9a4wVyA7AA4G0AlCkg9vnYCb1CFhQZNlOL4+0RrmRihr5BJIV74p
	 lMFM9ysPdyYOibewwBmTtWaMPIX9JMF0Me0qgitmlSoRDhgEHZvci5+57UL2P6FPWG5wQ
	 LACUYm0KYIHgWnxBYaBSPHAhLx4aY8XWDodHaaDXDs9Wlt05ZPSE3++ue8ehLK/qCog==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795117933;
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
	bh=jKHJjfDG6eFfuJQjjIUvXvKKJNFl0YQcKAOC66s1Io4=;
	b=qdaNcIopiN139aos1VnFFlVKREduIwP6JKRCTG4HgG8uDwk38ikeFkPZaBgjXS46xPrB
	 yu754QQb9M2vSiPNnNQxEgPx3oHId5GoHHI+mzn/IveDMLnkbSqJK7QpP7SR+bZA3Cp2U
	 bf/j2N/TZITA4YdNsRHvqohfyYMEljWM1XSX85AGl5cLLmMMn1TQJlcF7eTi9dx3WAQVH
	 maKpDhR3R7A3Hxg7pb/IoRk6425dww/H0gtiPIBUbfCBekzNzfgb8hBbg3j0cT7eXGWSs
	 6mi0Uj+rR1TeqnBb8TFgBNl73tAPJhBLadB56cZHUPhJcV/XCluMAAJDFSI12RrLNVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="V/Doijm1";
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=i3IIr0al;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D7B606A325
	for <nvdimm@lists.linux.dev>; Thu, 19 Nov 2026 19:52:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12D7B606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=V/Doijm1;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=i3IIr0al
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795117932; x=1826653932;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=4MMTjMWXRRIKrPBX+T2SqmeHcfYF6sVmLEigzXrYVrM=;
  b=V/Doijm1lUYAfR7j6pxwVV51XkCqwMjxtm4KGwzINIX4dYYNZX0cc0Rs
   FLBhnK3hs0qkqO5IgQvLPonGianTV7VnPZH2zAvr1tYPc5RrhJCZ3R/wg
   TE/5zeeePYEvYNPXsEqDg00A4LLumghzkMOy5uSfpprSwHGHm+GQO4QD6
   GgVgSfweWbofx4eHyxQx4LJKOMNAQPTCQuElqY6VF4aQ9HSjm3m3E1Ad+
   BxgMBIyjdpldyiSN/obhD+EBdmDtnQB5XSZjCsUIRf0281OMMovQdfR+U
   iB3Jqql/kgJqDwpmF/sPER82UvM5OnEkilw8MD1cqFgUPTkYFE8TiBIvd
   w==;
X-CSE-ConnectionGUID: 3CfmsVzKTFeg2YBnUFD2gA==
X-CSE-MsgGUID: mohtuTiDQW+VTaGatIMuZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="4064035"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="4064035"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 11:52:11 -0800
X-CSE-ConnectionGUID: MP71OhjKQu+pWlCcnzHHCg==
X-CSE-MsgGUID: 5Lc13fuPQuaMeat0iZoYWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="12491774"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 11:52:11 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 11:52:10 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 19 Nov 2026 11:52:10 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.26) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 11:52:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EfRKfnT7lfEpcSqOyyfCtL2gUQ1jRBTS5AMytlTp5El1VE8ASzuylHDL6O0DHHM/YDtyvhnxA+cIk0OT54NCQ+/vdJx3wzvcZgN1c4hlH86G8WMXDme0X6CaMquFLVXGInGCBnYLAwGgkiusnYm5SDAa9Me2aJAEiOqKzu5npLG2kWygkbZQT4ReEW5IiUGhwRlUKZi9PVmJWTrYxr8P2Z+3hlC54O7ER1VAa4lUccljfLM4s/MCsd9hSNpSK0/L4+EzMvTr5iJHtp5O1bWJrKn189a5TZq7/2+p86F79wXTwfVuh7436YvvlBr7jKwgoMUw7VBtGICSkHMyb7sQTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jKHJjfDG6eFfuJQjjIUvXvKKJNFl0YQcKAOC66s1Io4=;
 b=r6lKT8NE3f0aNFHLDt2avhDVDmWx7Oj5QZe1Mh37YuTx55JXjrRJv5plhkU6W5EAJ0UJM9+PtsbMj0iUExFxV+eG9RpKJHJQtJgMbn//s9P7iw4RSiZVIpuP+o2Wb8V9oWQhNc+G97gwb74cL4OR1siP50cELAgcn/kHLv7cwbWaV2ZgaM/ivEey5EJYjtWxR0n9imDrLegKGEgn1xOrjufWVQFTr9u668wHCnp/WEBoaY4FnyFfn9GsBeTw+Z4d+zqQAge8Eh51aFpIgIz96KPN54wj/OGuNoMAi6/mxa69rr3NTdy6FDPopIBUE6xuw+flbwpURG1FdEaLbUzloQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKHJjfDG6eFfuJQjjIUvXvKKJNFl0YQcKAOC66s1Io4=;
 b=i3IIr0alMcnA98DROstn7Pc8l+VkZrgUHZQz3bMYnHJxtG80+lCrPfbgS9FzYHduNGueYC2PIKGYutjfUNFOu7x2KWRdnxCDJ0klU9AClZJ77DBstPP2zq0Wq0UVVrdM7E0nQHY2IyZteoxDtTlc3Q76ze0GC6FPT5eZ9ear0I8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CY8PR11MB7394.namprd11.prod.outlook.com (2603:10b6:930:85::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 19:51:55 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 19:51:55 +0000
Date: Thu, 19 Nov 2026 11:51:51 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v2 0/3] Add CXL region passthrough >16K gran test
Message-ID: <av9TV6k_wI8u0uks@aschofie-mobl2.lan>
References: <cover.1788489571.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1788489571.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0126.namprd04.prod.outlook.com
 (2603:10b6:303:84::11) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CY8PR11MB7394:EE_
X-MS-Office365-Filtering-Correlation-Id: b64c03e8-c960-4bc5-b559-08df46769014
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|261022105027099003|261102123227099003|261021123027099003|10067099003|11063799006|260925021911599003|261026140227099003|56012099006|261021121427099003|261028144727099003|260925022911599003|260925021311599003|261022075727099003|261009223027099003|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info: 5AzZDriqD8kcMkSFTH0kamKCu2QOQRCWzJIxfOKYKA4++sBAdIkxymdzsT6M669u/MhKapybg3/bHynBi7i/NS0+la9inka/ErA98bUueF+sWqXLav0DW7OXuyhHhQXqDntTgeV6CMk1w0cs6Tnomd/Lc/PiWHAETVB79d53NiuJOXGxwoNwJocKVukaSR2KF8LqGze9oLk9bzAVKhFfj+rvj0N9ms8GKn0fKswj01y8nXv0UOBHRby86hDYgxk7o7cVMfjXm8V8tb0zVDaePPDJA7vuYPLo65+HeMdY95P6py+qLlLIHpNboDZ/MpOfur16Tm5o7FFy6CspWUm80bzSdq7s1ykmjxiddl/yolZ0gjfn9zs12GZdu5MY9drct+zN5b1CogPWTgdkEEE1jOS+Wv7/8I5sWb8Tv8KkP71ocqAELhcIBc5G0CpHdwu3r49ZHbSMXISep4niqZNBzvra51frXEr0hL7ThUPxa960Z+jN1arWAG/p/oCbbumQuLB2q2Zvepy5PlECa6qZYHoI5Q6nSDBnltocmI+ajoJffv3+kO8TMugh84+JO5FZxJOQ+668tOTelb6yxbt6c/CvIz9OumyIIFIXSZTCk5Emu5sWX/mR3teB0QpAN4nM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(261022105027099003)(261102123227099003)(261021123027099003)(10067099003)(11063799006)(260925021911599003)(261026140227099003)(56012099006)(261021121427099003)(261028144727099003)(260925022911599003)(260925021311599003)(261022075727099003)(261009223027099003)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VCU+k+Pc4YF3yfVelSLiGj0jDUbeOcalki8iT6d3GunhteJF76MPuXM560fg?=
 =?us-ascii?Q?3wRRJYGtNCNzWq63SwqdOs3vTsqbkUUn8nMbF9E5LtkvN/80IrN/5Z9obv4v?=
 =?us-ascii?Q?e7FqrxgSPSxxM6Q2qUiuqBpvu3mNYVlgpSIju1Lytgtab34v/OwAx7dBJNwx?=
 =?us-ascii?Q?AZ05yJiTFUHUDrzVD7uVXSrQWA9OgzdQyoivBz3Op75hx4mhgEcvHzMMfFx5?=
 =?us-ascii?Q?FEzDOysx2OZcn3V1XeU0pdfGyqiUxNKdL42FpFAekn9IUPq+I+CKGGzFk6UO?=
 =?us-ascii?Q?QcrWeFvLexMds8hlBVtCxF0reHV6qrSrFCqUxdncxKRIi2g+nCz+f1shmDjK?=
 =?us-ascii?Q?nzhzoVErVvGCxm9kQA+ZelDMnZFlgKhn8CajUDXYCtpWfOJn0PB2/Mvvd+Ux?=
 =?us-ascii?Q?Lxc96tMfpCjv3hiS9FVx4H0u7leXTb+W8TUPgQZPswbrGY67fBA+nr5ODpuK?=
 =?us-ascii?Q?CA8LSyIte3E/OacqWmKzMwyrQYyW9ijyf835xOl5QDXXCv5fGHmmodY9SMEg?=
 =?us-ascii?Q?88fVAn+LPzxwg2zcbutUl7x8Pw1RNpFD8qWgVnrkFaPExairZMF9jZCZDxq1?=
 =?us-ascii?Q?6NwIjjaKyJjv5KtFv2QEqGz8AGvORdAIXZtfnDGeqdapyUnY/Q5BDn/OMV/H?=
 =?us-ascii?Q?33jiBHEL8b7R0m54lppOqNor44fMQw+aU0DcjB6Uk/Emze1F8j4BWz3c+vGl?=
 =?us-ascii?Q?PwaGNUAod6TLVKfe6uyR2IcDYZ6vaO53Hjepl72kfg/iYOZsQJBN2uRUiD6D?=
 =?us-ascii?Q?bgOtlBAo3apWOXa1hIpXoho5CHHE92yTBmiGuUv/UzagByB7G4zsKhKUKD00?=
 =?us-ascii?Q?hCFiAw62PkfJlj5pKaHnQFR8fHqrR9MTakL7tmk67LNko8rDh8geMoJOd4Pt?=
 =?us-ascii?Q?MQJ7Sk9df8dZMJVNUbMbF2I/hfk/zm9agLQeMIHYMfJx1uvgDA5ngISVNOop?=
 =?us-ascii?Q?xx6tARuuMgZ37R/zl6TZfuFgvHn6apgY7YufSKQL25OobLrmDZVS3hiIzzaB?=
 =?us-ascii?Q?+O2TyIfYNFBYOheMp9139v9jp6mo3o6jFZsIaBjVYW+wK0UkyJSJ+U4cGRqX?=
 =?us-ascii?Q?/1d63UYgc2epK8IirlIWIbpcCu1Aaj7q88EfEeVtPROYQlBdmJbN6lMKpZKQ?=
 =?us-ascii?Q?EHaFO8RKNdL/bRMdW41vsHNhan4282QnmgTplNKNZCKbF5eNEJKNRYxWPdR5?=
 =?us-ascii?Q?Xq6Q4ut1vwDG05x215Mbg+I3gRPKZesQpU0zMGVSMzuTDbjs3pplhslrbvbB?=
 =?us-ascii?Q?9DUhSNU+V0lqtPq5OBsNktZAwaaQbgyiKsnG03ETgN9b0rjfBJ1enFQVWPts?=
 =?us-ascii?Q?UsRkL1TF6qo3hqI4SrK8BbWJFFm+CMnclOLJtSk1UBIsRngWU6utTtFGipdr?=
 =?us-ascii?Q?tKVLUAQXGCVHesqR3P1KZlPkfO+ANsl9bIAEp91dNkLxorav7aebWHN6WWr9?=
 =?us-ascii?Q?CXEuyw1qdnAdY6T0G4g1kwo+7vq8duX4jDrav7J1Lrvr8dONE9eHeThScA/9?=
 =?us-ascii?Q?Emg2DGg4GI51v1XwwyNPvNCI7xN0PhRq8LrDm+j0E6wvNYYHh2DMNs+4dcuv?=
 =?us-ascii?Q?U/jcxZ3zoRsCbr/UQ4CmY1L/1w0T++6nRcvI2vXYcr8rG+a5jbLOiNvmExxC?=
 =?us-ascii?Q?ICz2fXHN6dGYT0BDQbgxpLT4ixb0wdS9irdEWE3Rgdy3qiRNIHN7jrri+78o?=
 =?us-ascii?Q?b/czWa7nYAqV3TbwDDYZHbXnh1eI5BV0Mfi/DrmIdKbBNcwenyxdgzITvnqZ?=
 =?us-ascii?Q?ADMEcnnWKkBnIVoUBdKLhWlWqOjJ77A=3D?=
X-Exchange-RoutingPolicyChecked: rDKZDNYpdqbu/yv3Ouu5b2JvmZWPsdHfEJjGXfsdAWFV4cycr3hewwGwT3qJsFpndSBeV6VC1b0+lZ3sQI085grxwaNEzbWRxUzisztk3xneyl3HaQE7c0De+c7I8MgVYK3pb5O9lJcsmO4bVeQexkxHrxJ3L9qrUVlZ4i12qONkH6nlCHCb2ttHDYVQKGtsulxt8xwZp0qwXaRuGsn0a46WSB6Blgu0AUXP636keNXJoUO76YkLOoPczxkM4oN8yRJeEt7V+RHRXiUhAHQJqYHy86m3GVsnFkVarYrEvQhLEgl/aqFML+e1Ewe1Rck7te2kU0rocMOzkV/Idw6VaQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: b64c03e8-c960-4bc5-b559-08df46769014
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 19:51:54.9356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A4wLp3tFwRDhO+5Z6FuE3HJFxrmXglv9xvuwtVrhL2jC9aolEHuMIYf6pfbjT/psK+eqJAHWTKwxwoEsCdJ+Fca2mxLgY1myU3ZumuymlMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7394
X-OriginatorOrg: intel.com

On Thu, Sep 03, 2026 at 07:52:54PM -0700, Alison Schofield wrote:
> Change in v2:
> - Skip immediately if test decoder not present
> 
> 
> A companion kernel series,
>     "cxl: Allow passthrough decoders with >16K granularity",
> fixes region setup for valid topologies containing passthrough
> decoders beneath a wide parent interleave and extends cxl-test with a
> topology that exercises the issue.
> 
> This series consolidates and simplifies the existing region creation
> tests, and then adds coverage for the new topology.
> 
> Based on: https://github.com/pmem/ndctl/tree/pending

Applied patch 3 for NDCTL v86
https://github.com/pmem/ndctl/tree/pending

Patches 1&2 were duplicates of, and applied w series:
[ndctl PATCH 0/7] cxl/region: create-region command and unit test fixups
https://lore.kernel.org/nvdimm/cover.1790658549.git.alison.schofield@intel.com/

> 
> Alison Schofield (3):
>   test/cxl-create-region.sh: fold in XOR region coverage
>   test/cxl-create-region.sh: deduplicate decoder and memdev lookups
>   test/cxl-create-region.sh: add passthrough >16K granularity test case
> 
>  test/cxl-create-region.sh | 163 ++++++++++++++++++++++++++++++++++----
>  test/cxl-xor-region.sh    | 129 ------------------------------
>  test/meson.build          |   2 -
>  3 files changed, 149 insertions(+), 145 deletions(-)
>  delete mode 100644 test/cxl-xor-region.sh
> 
> -- 
> 2.37.3
> 
