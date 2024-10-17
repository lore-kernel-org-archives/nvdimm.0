Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730D11DF993
	for <nvdimm@lists.linux.dev>; Thu, 17 Oct 2024 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729185567; cv=fail; b=ifintDuTzLrgECY7Nm3g0Vy57tw+Rxtnhl4D2VRQ6a0JZMS/J4CqW9bENhN38OlSVgIcarCABRE3H63OEaz6jiVriluY+nGJ8FDMNPkX7Qbb+sP/qTXkehLVytPUEteGcMmBkiCBJy6wakwmfRxmPRtbKv/T75/fOSbpP+e/hgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729185567; c=relaxed/simple;
	bh=YjH2cCjOiJTTspGm17gFBK5mZATokcdY2a/i4Y2+30E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CS8nHhvitse6GQ6a9++NUTLqKZFeWucmhGdQiWmqHtnQO995EhtUMlir7ihTaxmYIltEdvitkkidYjKiyeMqAVSuVEWyFDHbTP8weUMz7SCCVE760L3LCmbP7PvAIdBSCtIiE2ae7Fw5DjE+QrAxQMqcXEk8QPneLqI08QLsVeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WKpkPwYU; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WKpkPwYU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729185561; x=1760721561;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YjH2cCjOiJTTspGm17gFBK5mZATokcdY2a/i4Y2+30E=;
  b=WKpkPwYU00FXoqL/iEfwYuc1CQW3XLsc3fJczXu7nWG+Dfe+aiE8EXPz
   VUyWpdkpAjOlc534ebsBAGBZC50+ME4FYz1yIEnr/smWzoa6S0dJFUUaY
   ebNuv/Q4aEiz6S01veNAnhzkBgV6kQnW2oZPhavQfLAfbrRDKnf9gQIXG
   Yt4PvhekxLDdh8G6wo1eUVW6R0IdNnyqThDJdjigaf4zopC+6iKoG0ptI
   UTN1oQsk8naYWlaSxlvxkVJHPEpd8eKowOGbVIIm/4/jEbY9+4Cqr6EZx
   Uhl7v4dXBElGpCVUrdVfWfIVeM8ZUt+3ANAiLRhHewogl4heCsvLwx6yl
   w==;
X-CSE-ConnectionGUID: PXAKc5SJSuO5R16I6WES3g==
X-CSE-MsgGUID: 7+2O4v5EToSVnNYfjy5iNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11228"; a="32484699"
X-IronPort-AV: E=Sophos;i="6.11,211,1725346800"; 
   d="scan'208";a="32484699"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 10:19:21 -0700
X-CSE-ConnectionGUID: wEr+Fq7gTo+IC9P0C5YmiQ==
X-CSE-MsgGUID: sshQBdmIRa6fwfPtO9ABBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,211,1725346800"; 
   d="scan'208";a="109434482"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Oct 2024 10:19:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Oct 2024 10:19:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 17 Oct 2024 10:19:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 17 Oct 2024 10:19:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kDI37RwPETEFV+eIeFy9fvv9QfGzIN57vlX3S/nBLIPoIeXYvYccbtOCDOp7qG0pL1VLfC/fo11aZXcHO4jtSUzLfCLwv4JKbBOcCDbVgy/ralTpYUJ/A6WiSUxKXM6D46pigUDV2dURXBJ7Ur3BPuzMd0S/qmq9E9VHB0G0ouIGYxTBkPh5SmsXSdmtKozpMr7mMY3OLC6TLq+SaAoCdsB49z/7a0AmKTv9zGKcJuML8u+mLXsprsAwyrN3sqBUTXHj5jO3j1SBwIwQh2G+d+PHVwCi6TJevtk+L4MRHixVkaGXE0O1WFYwE8cMQb1otF/kVtp5xFMMAuaOVj8q+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GltnkeFdJ3oHbWop2Uh4YU/0sivFoaNIphZOrGUh0Lk=;
 b=ytwlFtDaE0moqIQS2eR3w3AcRRob0NqXQTzYR9rd1iEW8OQCCjVzV+lueg6Ipq/kboDah4LZMVFahNBQIBql4StxozPEXVYFh+cpIOM+EUK1L28UrtEOV3N/G9xyjOq6LyC62/p7c9Hml+Ph46a7nqhq4ttx+JKRFpubDOWElAZums22rHugzsfYhqtPzQootfjULJMhmGxvRymWcvI+96t4wpET6brNCgvcn1PYevWW9PO+Xtr+H5yO+HsutbRRhTFgmQW4yg3wdh2D8O6kTkDc0QvIPGcvQbcvyBlkUNZJ3GlAyG7qRfP3HzTFhIm0PDGOQZYdDy6dxAGO1kq6nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB5247.namprd11.prod.outlook.com (2603:10b6:5:38a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.23; Thu, 17 Oct
 2024 17:19:17 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8048.020; Thu, 17 Oct 2024
 17:19:16 +0000
Date: Thu, 17 Oct 2024 10:19:14 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Jane Chu <jane.chu@oracle.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
CC: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH] dax: delete a stale directory pmem
Message-ID: <67114712590a2_10a0a2947e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <20241017101144.1654085-1-harshit.m.mogalapalli@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241017101144.1654085-1-harshit.m.mogalapalli@oracle.com>
X-ClientProxiedBy: MW4PR04CA0053.namprd04.prod.outlook.com
 (2603:10b6:303:6a::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB5247:EE_
X-MS-Office365-Filtering-Correlation-Id: 71b2a63e-39e9-48dd-f157-08dceecfd44c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Q8eniW3GYqlx31FRzRolUTCm82mxSCFqMv+ZIWUs4teeGP56aFue7bolijN4?=
 =?us-ascii?Q?q2Pt5IzfWdWm9CuO6DyT30efiN4TipxCjfuRef8lz83zalcp6adbMJpXfmWK?=
 =?us-ascii?Q?y/+MlhNwpGSG9NiKVk4xemdtnezjjdXWvkzCvMCxdcpI7iO9maifdPR7us+s?=
 =?us-ascii?Q?JXA18IEVeuZDwaPhji8wGYdYozFiN8bW5fqqrEQvXQOTAW89nNA7pwYa01wX?=
 =?us-ascii?Q?prkX797BvR1Y7EukawEXPiaapmvrBTrtolXjw0OXjGpMebsHQ8eIvPwV/W/V?=
 =?us-ascii?Q?fBvsMIiy7AToxsrcL2317SeuM/hFaPIFQVBOIPas35R0HhXda6p+dJFd7CRO?=
 =?us-ascii?Q?1e8DPZdGr30RIFJUbjxHxa8sFET94PwQnor/cQrQ1I7EuqFnJfqE3bb+cumB?=
 =?us-ascii?Q?MiEm/QvY+ICeIU+wrPUVmDHCnGDDKFIgi7Mu5yapfwoabt5XB2cnFaqFr2Sp?=
 =?us-ascii?Q?iu3Y0D86vrb1xRsH3/jqY+tGNSwUSSU1OTSxFEbcvAO+ozOsv4ITutMmrNsX?=
 =?us-ascii?Q?Py3jc5h03FXhBxyuG5jwhmcGZVLhoCvkKFWTLje02IVZ9eTuV1BtO4bfZl8F?=
 =?us-ascii?Q?xE/luHzHNtSJpKKDli1XF/0IyscbkfSFFX1brPeEdT2i+a/TN7Hv/cmWHkX3?=
 =?us-ascii?Q?ajT/+COPB5T/DAhiyxGYWmATkWR5Xg24KCxrm6qoYrwXOjMZa5jqyNRuurxm?=
 =?us-ascii?Q?kks2FOLdQWad2DaMsL7LyZR3Sp9Kfnk4SEyvk/OofZKqPrkoQi46/Z3frBj9?=
 =?us-ascii?Q?QG5zJPrM/JMriWExLNnJRdpkuJrszQHqXyDnbP+vgif9ERQCu9VMdbjM0PLx?=
 =?us-ascii?Q?J7vWFzu1/CakjMboFu/dLBaA+/xruoo+D1CXJXZuM5VaxI6Py1Ss7PKSsJLa?=
 =?us-ascii?Q?Hu1c2avmCDDusBOjDqx8Sjv/1rxLl3CrwDrYAFFHldfU4/fESzSJclBqn5WT?=
 =?us-ascii?Q?Nco4sJTRLSk20h3fLFih1oracNFPqbg5YKSlPgvnpP7XDXsaPIx9JfRapZEW?=
 =?us-ascii?Q?yrmjUKFMk2xz3BzTUZAt/tvs4W344C2qrSY5DoY5d8qA8XLPNdrA1qrrNaPg?=
 =?us-ascii?Q?F7LaZH1scl9/Klq4Duos09Eea2BE9m0Y0PiyfdPrJRpeULuuA2wFBx0ZxcD0?=
 =?us-ascii?Q?0Sa3GYX0pRBPwcbxsuayqOcra1qMdWzk2l/hvmj/YoB2ccutXH5M39e6U9Kv?=
 =?us-ascii?Q?qvX7eXUzzqCtEli10jBWsmLSq7eep7acvJddc0DsM+dZO7CNXAcoJKeST3ry?=
 =?us-ascii?Q?qPsS3pUSH3ENMBoL6qu9AGstiAZkvxdLPpkImUkfYg/yDDj4Z15UuR8he5GF?=
 =?us-ascii?Q?e6YmRynK5jEUyEAW3HfqhLi5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E9ZgQo7cV8NcCrYakKIsVj14L0zcvG9Yn0Hleg8AfuNDhfA2yrNPkw1ecwKM?=
 =?us-ascii?Q?EN9cykPk0yJCRgAv9xS1vfevcKMAVxomcCTHq9OcXhV1376dLZCLVMOymFYe?=
 =?us-ascii?Q?6P8Kfck2krzi9Y5YpV9gzZD83NNL1RF6arzH9vJL9aJPvc9rMxDg8j4xldyl?=
 =?us-ascii?Q?UEpG6peBN6Wbk90gCfCkSK5JiGb/3SJAG8fLndYNNYvo55Mp+SKhAEtct5bb?=
 =?us-ascii?Q?RrCzwpVjJ3B9UQ2SGcV13KNYuHsJ68xQNs7QVIqXG7T+4ll9TwDS/M1uguAX?=
 =?us-ascii?Q?dp7AZWuaTFKBc/5CAs8FXohIHUgi0qfczGpGBZ7lUo7AV/TbrX0cdRIjerj+?=
 =?us-ascii?Q?2wKstwjvG2vN3vLSqyZqtmuuhTJ5OflzgOD4kZjx6VuEHgtEmGMHrCxkT+4A?=
 =?us-ascii?Q?SRxXmI8SrYPTVuVUsehjSTauS1PmvnL74oyaX2d584BeycfGfPUUWHBIwg9X?=
 =?us-ascii?Q?jRi3KOCuFw8O+RTm+t7J4RzHKf/U1tpMcvS8eB9YDU7ek5GCRk01PkuZaJVO?=
 =?us-ascii?Q?0bQM3xzMFs52T6/M4hnfXw8P/i8WhUgoyJIXNm3FaPrZDN7AR4y0RhwTLhb0?=
 =?us-ascii?Q?GioYX4CXg6kMlanrO2O6IJBMQ5MlOEc0xwM/kWB9OeiaKqoMsdRwb2FMKXQR?=
 =?us-ascii?Q?GUh0UjRHX6HgHidXWOkt4izahJ7/PxG/2yDIMZS+fqpSCZFqLR1ncTBkvfvf?=
 =?us-ascii?Q?2CGOjQH3FsHAU59w3CFzusNT/+YK21WgdZpuxLpmoRcrUE8bgjg6kQ7+fcvF?=
 =?us-ascii?Q?Z9Ol91Y51mhicnDzrkGk0mAlRb+TJVR48K8we4WjyamOtlXP7SV6k/6Lr7GH?=
 =?us-ascii?Q?Py6+PcC0S3l3bdT6xd/gW1J7dQzKsRR3HLsucUaFH3l4SXJFwb0G4CT66oli?=
 =?us-ascii?Q?dX2Fb741UOmZ0arlp8YKsQQ/zuXEsGl3YIIk0EBCeNyCbpGx7YqloBRHakQp?=
 =?us-ascii?Q?MCnxgE7dHceA5yUoazSSan9M9EUV8QvM7sks3QRlSd2Cz5yC+2QV4shyYU1L?=
 =?us-ascii?Q?OwDRx1WEDC+vDHvVfyPpUvundMnvPdLsEY+4p22nr1UMJIfjLva9XfBdORpx?=
 =?us-ascii?Q?6+APnR4qfyuN4VxjGz+fcdb3TNsP/FiseHRafPS2SYxADdOM7DrbCiRCdASo?=
 =?us-ascii?Q?OtDR/w4mGecWZQxSLlv+nXLG0qS0oCBiKsfWnXIviXUYiX9LBsdH2pZK4bgB?=
 =?us-ascii?Q?19RRvGXQUWBixzfHdnXenJXJ6nVevlPGxqA+CORTBBgsU1yAvgJMKBHxXZiZ?=
 =?us-ascii?Q?oNM5AJiB07DmG2QEIMQPTTeFOVKIwTRu0zG3eOv6FJ+W6PQu+23y3eifG60f?=
 =?us-ascii?Q?wvTIJVpcFLp30sFEC+YPkywd8F2f95UofhczDRT6SuIow82w8yvoak8+X2Ov?=
 =?us-ascii?Q?A6vuu4e6AAUrywqKCF5BWf/YxDpDfVlzm/z5qCWqvwE54feJ0wu5XQgM9tao?=
 =?us-ascii?Q?nIpNF76OsNZjqOIpPh+i7XJpz/ob+n8HxHb2XuyiEnuTZfD0giYRJDkE3rgH?=
 =?us-ascii?Q?VpUcXwSTi2gtw9cg08jey90CWnhVwfDwhGl32egVaSx853KBn0SIUPzf7EX1?=
 =?us-ascii?Q?lC7jw+TwujRU9DX/rwVk9Sm95aKMqLk5studFHZg6Dpj2Rb2HL9AbgVml9y/?=
 =?us-ascii?Q?Ug=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 71b2a63e-39e9-48dd-f157-08dceecfd44c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2024 17:19:16.8591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rCbE8MzJlIOkvQIBrXf44o5VJAShuUGvL58068emXOVZjupz3MH59/sHWcf0DucOBjZd29AeioJKbfFQf7DPkd0esZ78uQ8SWl8gundp1YA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5247
X-OriginatorOrg: intel.com

Harshit Mogalapalli wrote:
> After commit: 83762cb5c7c4 ("dax: Kill DEV_DAX_PMEM_COMPAT") the pmem/
> directory is not needed anymore and Makefile changes were made
> accordingly in this commit, but there is a Makefile and pmem.c in pmem/
> which are now stale and pmem.c is empty, remove them.
> 
> Fixes: 83762cb5c7c4 ("dax: Kill DEV_DAX_PMEM_COMPAT")
> Suggested-by: Vegard Nossum <vegard.nossum@oracle.com>
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> ---
>  drivers/dax/pmem/Makefile |  7 -------
>  drivers/dax/pmem/pmem.c   | 10 ----------
>  2 files changed, 17 deletions(-)
>  delete mode 100644 drivers/dax/pmem/Makefile
>  delete mode 100644 drivers/dax/pmem/pmem.c

Oh, indeed, good catch.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
