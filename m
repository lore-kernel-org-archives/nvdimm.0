Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5218314B6A
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 21:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780437347; cv=fail; b=T6khmg/9y9LK5NMQ/n3fzPIkpbDduAMFHgpZAD0OdBfLEUo4huvNBWyZsx8siNgxyUymd68IasD0Y0WVbwJ2f3rsCqhbKKIcwAmmOw3AGpoH7PqnQWinl2NiY6nyCbt94jBNoHXDOF3TYvVmzR+AjYY/86uAZ6pvw0rnI8//xV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780437347; c=relaxed/simple;
	bh=I6s0LHge9A/tP2BDH/5aBF/s+G6tWBUgvfdNHFeH1Lc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=krQkT7aTpjRk4NLZ2n28Jth9TNocYqOFlsQJ7726ccT9cPrBuQEp1Fu4XpEb/yWqbVPaULK4M+XZbInjltMA9NWFwpSLlqlxTLaoU9qYQ5a3nKId7GsXUPDFp3lKOEpcEEyt+//m3/Cprrt+uxE6vtBNxAEHIShda+uUSmKiuTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nis44gFY; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nis44gFY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780437346; x=1811973346;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=I6s0LHge9A/tP2BDH/5aBF/s+G6tWBUgvfdNHFeH1Lc=;
  b=nis44gFYRLJsUpao+h+vFz4Kk/ia54ju9vTXuETMZv8xSI0Dja6VTstE
   YDlV5tAYKZAuOPJKAwyzaZ7boTxH2UvbfTRkWqXWTABbaLDOzEgaTuhGd
   px2lTwQIc93ld904yUW4/41EVkI+hLO1Z21jwDkGghUAjnO7RrRRnzXjA
   ZVjV04bNC/MeBsBWQaSfFygHCkS0SUD+Bw3oRknhfKCSPdOKXR9r3Y+6+
   8W31/OIzJWgvAvQ0B41sRkMlFEfyU3hkhQyEvSqglQzu4BgdO2bJVuXwE
   OBFFF2IKthJakBS0xr+TxiI7QbVcASPzWyU8wikcLv6D3P3ZlS1rmhBr2
   A==;
X-CSE-ConnectionGUID: icRNiDocREe4hUyxS20SKA==
X-CSE-MsgGUID: MjJ8pFTKQvu/o6TGHPa6PQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="98800483"
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="98800483"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 14:55:46 -0700
X-CSE-ConnectionGUID: Ia9YIUCgTSmJjZeVFKBoyg==
X-CSE-MsgGUID: 8l+3FntWQ+yqHt7HPtnHkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="244116182"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 14:55:45 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 14:55:44 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 14:55:44 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.32) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 14:55:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=epiJCL5VjJxAprrwqo8XSr/i/cvQpHENxzSmMMbnMAWNECS8m0KjW+BWA6e7+3iDXX1JiurTmljmg0RmnceMydoniORS84XXqyDPTra4JOxHNfHigI2yFXp5/mIDNPI73SghYTI2J303qFdhshHbNSl5l5f9jAkCLFtpyx1xFaxMPPiRirobFGJifgkp2gSoBbC4PB6PoXsyL51uAW3yJVwNJxdQ26l+ZIc+M3wJxubXMAxnifK2sYRyB4RXZWn9TIY7zDvjbJ4YAI4Ucn1zeKfAC4vt8cZHJ+4Aji6KGtVHsHUeVYIz2kZ80qjif9MdUyvARDqo7WYpqMC9trPL3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uBrnlnzseVv0l/NmePiWxeYZ8+8vtJz6xQkgVHXty7Y=;
 b=gamG/hj4PZt4wc6Sn8vIn6SAuLzIDh5w/tVKRsBrxxRSZ1wvP20FLn98fVDaf9rHwhEDs7dgFNG+bzNG6MeBQoO9o6SF81dPJTZKjww6xl7ubRLyr4HMd93OaJtN67/0hThfthS5kATJIyPNs1IFuV+JCBQMw08qladU2gHkf3xA8eKBnSVG6TGRgBI0l/DDEhmpakQzf1zVLJdDQaS8+nofLuJaNW+31fF9CI8Ux6PuOv1xkaOXE5K2UsN/SRa6crTiQcsQkrMKxt3huaMaYKncVY1xp4aYXu/PxZ5WCrQaMRoCFNZY47bke1pCM8dTHfNjtJvg+KkgwXFCpqrRxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by DM3PPF4C5964328.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::f1e) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 21:55:40 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::d35b:e3ac:6d53:bb3c]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::d35b:e3ac:6d53:bb3c%8]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 21:55:37 +0000
Date: Tue, 2 Jun 2026 14:55:34 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, John Groves <jgroves@fastmail.com>, "Dan
 Williams" <djbw@kernel.org>, John Groves <jgroves@micron.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com"
	<venkataravis@micron.com>, "dev.srinivasulu@gmail.com"
	<dev.srinivasulu@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
Subject: Re: [PATCH V6 0/2] daxctl: Add support for famfs mode
Message-ID: <ah9RVik9fE4H8Uxx@aschofie-mobl2.lan>
References: <20260526170148.56398-1-john@jagalactic.com>
 <0100019e653c6c88-44f88088-8c87-4163-b88b-b3f3fc7aa726-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019e653c6c88-44f88088-8c87-4163-b88b-b3f3fc7aa726-000000@email.amazonses.com>
X-ClientProxiedBy: SJ0PR03CA0285.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::20) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|DM3PPF4C5964328:EE_
X-MS-Office365-Filtering-Correlation-Id: 216b672f-57bb-4d2a-700a-08dec0f1ae49
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: vETLbIudNroJnJUJA7JKO12Ch2xPr6U3rIObSBlUsVx+CGpkb8lfCjLicWNaMapSbrfViggbXhawOLekTXNHq04oXAnkSxhpmEezQc3jDD1/+OfDNFNtWENw9fpllL3xAoAuQsbA49ACWH1eC04xxkOcN6PlO0mINWs8/mtQknRoh4EtvnfJyp1ExF0J3Eub+87OugYJ7vfGL1fgdfFQAl2Qiw8dLz3Px1yCDMq5mOtDqnoeli8PzsXnQxa0AHjD9k4qmQglfdXod86Rb01zX7kwf+aJ972ibOg04ONO+xGMzYU2UFtMuiuEWrVj+BA/ooJkqA6bwTXm5raa5JicbyM3xEBajTh0a13grM9qbYufmrUDr5sG0sXPB7h6knTjHAUp20msjE20ELGh/U4EIKLR230xIteEYFSWmQJFLOarYs838X7nnc6Qbp8spaGPENQHH2oFhUs1LxSofk85V3zhYCKdykUtK+IZyU7k54bZoMwbNqBNbw/cVY6jWEJ1pW9JGq/KUjKIeXMZMgaZ35sVOIzijS8dpFmuVfc2TQCol1fcOzeXhCNQXdHtAxKapCDaoGS1nJtBbosW4bP8sFQ2r8Ujn/BJ6Zg/KmKOxrOc67+eiP7QTP0g3uZzAmsT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EeyMpCxBlgeGq6dviZF4f0GkQ8lQNdKS7WERpeCDY5ePX2oi9oWFf3yNvieC?=
 =?us-ascii?Q?sQjY8rOpLKh4N96bSIRndKCzuT23Xx5mwpqpJQHBuoF1VRsQVf5gCu4ZFsIn?=
 =?us-ascii?Q?Y6Z3lRohtYqGXnLdjlkYvx4UO48U4IafbeFWgF/ReCbLvWIg9XyzDibi4XSk?=
 =?us-ascii?Q?q3aJkWND1NcorL5pKI1NpsR0/IXvUdysigvHljcaVNt76LdLhPgZ9dnH+BzJ?=
 =?us-ascii?Q?E33TKeMvy1DajiKeCBeJHW0JxcAeTxwbDlZAR97qyLqNct7VyONcJ6vSttaN?=
 =?us-ascii?Q?1GcZ5foPmImdwy1CDIooeGGG20xdMmWtX/5hIu6zfQLyaLcfASEqbsrh/Tae?=
 =?us-ascii?Q?Fm4vbKyv5sEMXQxpFejIkh8tLemGorBUxv5M79iLTVbjU2OBqVGRvvHxB/dt?=
 =?us-ascii?Q?HxbvRj0t8NAVBR+LOqQURFyFNPcV+Cy1htcHYXj4bP+tDpidElUa81/pRaG4?=
 =?us-ascii?Q?MZ/rCxokdqtpd9dm6maNE0i/UwKcv4O9RewSh1lW/RL371z/R/QFvdMSt155?=
 =?us-ascii?Q?L2mddj+IIRc1TPOUAAxd5NK8sgsW74+T4J3+LXS1tVtZaqizUIQTGmdjZc+w?=
 =?us-ascii?Q?6EQ94zkD+0VA4uwRKNb15jKZLkBHn6+rzKq+eYXSIlUU+qOaHWirwSCsI+0D?=
 =?us-ascii?Q?Kh+XsVftdoqN6aK3JZSZqkMFMMqXPfIs+fRCjvVah2BsT82eZuaa6FDgw7vD?=
 =?us-ascii?Q?sv3o3Gb7BFhRKmHMFuPku6vEiolb04zSHlVDacg++lzGfA+AD+XxVBtAYgjb?=
 =?us-ascii?Q?6Qa6r/LpcxBPGLk9fsP5u11Y5SQGJVRtonuLpS9s/bu+fe9tS/y4z1tNQGAG?=
 =?us-ascii?Q?fAmg9kVhf/eXllxZO1wlmIJdwYzLY9dfRNqARr/P0n9MC2wnXjXLdzVCtMKd?=
 =?us-ascii?Q?zRB+krMwaX9P5aPFURoK//Bd4AlBjgSb0hyX3OkCRKsvgL/iEZaekPjtsWV8?=
 =?us-ascii?Q?OlKN7S2WXvNhRhjNY585YMcMHgSYhmguTsolHZe1XbpoqqoFHR4sysGqKsL3?=
 =?us-ascii?Q?UaTfFyxzKTqXWb6AP/iaYbXnlYvUWGNG30/fLQeqvZSIarBlFafmVkV1JfK3?=
 =?us-ascii?Q?rHhPUGNZq9o1VJPTwqSh7JEtW/BoB40VVDG9ACiMHq9y4vq2/6MjMT3csnQP?=
 =?us-ascii?Q?L/hywmw4tJN0Ds/gDmIF7sFxinrP2sg4CBveHrF2PXbscO55wLn9PVZvBWo+?=
 =?us-ascii?Q?sJHGgOqZ1T+GXS3jtXturEtylV7JnfJGUnAQ5A7ynSwiHjwANTDc2jfV/14E?=
 =?us-ascii?Q?5NwCmtjJgvpzyyVCEw5xSG839gD76rHeMNO7+UMX4iV49z6EIbgRNBzPNXZ/?=
 =?us-ascii?Q?VnwFHCJCACFAndMpZd/AqxKygefSLyybntgUMK292eZCj9BIWVhLLTD3OXgp?=
 =?us-ascii?Q?WnBRCr5aPwF2e3BBg9obfddaBTBiXgDj4n3qvub2rR+/AmC5Uqiy00xjAOgU?=
 =?us-ascii?Q?aFvlM7a224+x/SwvrXFT6ncKtFI/7ZNy+e+BoEvTpcTku2jejfqTthaFK0xL?=
 =?us-ascii?Q?wIXPSv6YuUhaL13yReHXlI4mqAnbN4hJ/POQxhWlVsKCWtovL8BrGfmVaMKd?=
 =?us-ascii?Q?hiAvkr4mKDdvxQPVH6nuPBjAqelcmIg9XnoEtlee2LkcSDt/BEEG6056da+j?=
 =?us-ascii?Q?QXJP2aoGmfTNc1YtbhOOFwXvTuelwcRPH1yUBxOQM9JNiSbmgj1LnhB1nWGc?=
 =?us-ascii?Q?BJmUDZHJhf+1qJlpW4c7Ut/MznO9ewrFokjiv0fzT9dHNbRybTynhwSqcUo/?=
 =?us-ascii?Q?oHf9QOAWmgOqfzl/PFZe8hovwKGPZZo=3D?=
X-Exchange-RoutingPolicyChecked: RNKEZ1pZdtvPi3HTc9hS+WyY2UKEEUj4TNmBEYBwaCNkgYBUusSf6CXYYGCp1BwmP/YcwGpE/T2cVBpEdw1bCCbMptHBmyivc9p/LGnDYTszdo5B+IUe6femV4zixcRHb2EE/RQb8zurCWBZbFmWCHyfPmI/dPd1kr+CvVEJgiN/teAOIZNiUHbXnYidZrLl1XJrnyiUMJ9i09r5vnkuGosIGduPgR1bbJJwJPm9V/o3p/i7QONkKgp934e4jvpWysIxgDk6LGpPg4+zK8ySxTGYW1E2I+Tysd7NCwtmnK8C99Z1x/PDOwGv7EaqXJGmdDmuA6wduxy0bOOtQDuYIg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 216b672f-57bb-4d2a-700a-08dec0f1ae49
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 21:55:37.8119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9RuCqtkb/xu+YiVboY+k6Pm/Jhnhy2yP+gZAKGtXegCvDL2LFe0guf085Vaf1XNDGwUoFAF+bvQHGcP4U+QGjDsIjTUBLpVnfcIH6WTyCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF4C5964328
X-OriginatorOrg: intel.com

On Tue, May 26, 2026 at 05:01:59PM +0000, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> This series adds famfs mode support to daxctl, alongside the existing
> devdax and system-ram modes.  A daxdev is in famfs mode when it is bound
> to fsdev_dax.ko (drivers/dax/fsdev.c).  famfs is a shared,
> memory-mappable filesystem for disaggregated and CXL memory; see
> https://famfs.org for more information.
> 
> Patch 1 adds the library plumbing: mode detection helpers, an enable
> function, and the device.c reconfigure-device wiring.  Patch 2 adds a test
> that exercises mode transitions on the nfit_test emulated backend.
> 
> This series depends on the fsdev_dax kernel driver (which provides famfs
> mode) and on the famfs kernel patch series.

Thanks!
Applied to: https://github.com/pmem/ndctl/tree/pending

with minor touchup to the unit test patch:
[ as: drop -nfit suffix on test name, wrap commit lines at 70 columns ]

