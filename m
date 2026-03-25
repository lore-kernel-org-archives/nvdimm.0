Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEB62D3220
	for <nvdimm@lists.linux.dev>; Wed, 25 Mar 2026 04:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774413904; cv=fail; b=YnZBbvcwCsnMSChkhrHR9jVGj1Tr+oYqCV8VtoWhsdAbO3to0sgPfy1vDJ3iVXbuPT/Hsz8bAw/jptHCx9111uJwefFnm0tVYGqs/Kw8uQiJyxB4MdKZoosISNl8lcjkHfr406V/jrBVtZI0EZtnQz9xVlouPY6uweoEXLNsQUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774413904; c=relaxed/simple;
	bh=0krI7tjO951t6w45CMg8j12GbhfZrKZ0YbkaWwVTj0o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jq5w9LN8iNURYfw3GTc8KMPLeW3sc1vPVVf/96h0v4alcZbhu7flXVobWEHoZHpIjTDbSC4ZGyYkm9Otz81DyfEZSFTM3d0gLwX8FD3OC2fgQSBYXCPn2q+E4LmnddZyldu/Bs/ziD2uhvw10bhkN35nRJ+kzXUvRtTnGu7lwpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dIBiv5WU; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dIBiv5WU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774413902; x=1805949902;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0krI7tjO951t6w45CMg8j12GbhfZrKZ0YbkaWwVTj0o=;
  b=dIBiv5WUotENoZwsnp/DfR0aDvKqeP/nUT81QbelRQrKeKbN/hwMUbAf
   j17Dzu9f0/gFynPtEzYCsunwFtl84KPgahpJCJwp2uEXQteXy6XXUwCbq
   hnqoGrY86Lxk/5caMETL6ZV0uM+t0Efd7MA+cg/yCTfKowDDsRfhdWsD4
   jMbZ416Ef+D4VFiL8rsV8uYHXrs6qT70E48xqcoMiJKLRHJDnSzDRu8e+
   nntlBWE3fxdVSsNavCvCz3dvReu3Vou0yjlMFkbzXhivjNDmujLUGgBrV
   JlbYMkHz1bNTUoL7JZmrqokVbkgBZbXAwCKCbyMU5z1yzV6Z+MPOZd+qi
   g==;
X-CSE-ConnectionGUID: rpcqFaTmTZGvNVL6cOB4zA==
X-CSE-MsgGUID: GeMvxlD6TwyiU0yO5WANCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="86059544"
X-IronPort-AV: E=Sophos;i="6.23,139,1770624000"; 
   d="scan'208";a="86059544"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 21:45:01 -0700
X-CSE-ConnectionGUID: VeG/YlUORVK/wRrnlrR2nQ==
X-CSE-MsgGUID: zf6EuyF4TwuhfdNyQmeIkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,139,1770624000"; 
   d="scan'208";a="248105834"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 21:44:55 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 21:44:55 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 24 Mar 2026 21:44:55 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.62) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 21:44:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JfcPcfEpfPElfYaY7U1bDQ3Ngn6DxS5RuugG/OqA0aabewF0RS1ntaPL5XbnjVkvNvS5jOXK5tl4JVvKfOQ3I4O7fgnbMOvqSGpazTJ6YWK12T+BMJehJ9/JKHxwGprsPVO1gQul+XhY6pa+1kWh/VN74jSjJn1j1Fswdz3Pw9lGUKEwFHREYIaZELj+FLT9zYBdNgB6RZwgGjXSXreHgrKf7e1MUchaT/VkEHJH+POSwmyjLoSCKjr/Hjp/FMAjGJN2Q5XxwE17hFDI9lgBEJoDeaKarB2i6GHnHWJA67fEgBTvVpmvaj+XcGmzC35aKm6AqCbJnf80CYZC9948TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEUO+coV6pqGlm3x2fZHGC752sduLkO4qThZPr7B9Jg=;
 b=SXeNT4JzwabJxXN4Nm6TrWZO8+rvU0KauRiDdonVooa9jDwoFIIcO642UAcDqppw+auamAVQ55KdO09s0FgVRuSIO0i57WdU0QoG9fTrX1jPXEO7tOg1sRSBbzVKUUCetXXVsrBSFJ00oJ+Y28ckYqwrDWaNCY2zVTxXDzGwLg7zlUxZ6Kp7d+cUvYy2+O3d1JM8BESU6/UquoENoQHoxNID+hoGQhNUV5VW5MQW26pyjxQ774Pc8R7gaIqvWFjeulQb/z0B8fusauNcWhiw2OYQW34IWW9x0U648A53JfIcjBYVrfJ5mtWPXFc/o7lvz1U/RAwygZHIhh/lIUSP5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by IA4PR11MB8961.namprd11.prod.outlook.com
 (2603:10b6:208:56e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 25 Mar
 2026 04:44:49 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0%8]) with mapi id 15.20.9723.018; Wed, 25 Mar 2026
 04:44:49 +0000
Date: Tue, 24 Mar 2026 23:48:33 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: John Groves <john@jagalactic.com>, John Groves <John@groves.net>, "Miklos
 Szeredi" <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>, "Bernd
 Schubert" <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>
CC: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, "David
 Hildenbrand" <david@kernel.org>, Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi
	<shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, Josef Bacik
	<josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan
	<chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba
	<tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank Garg
	<shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, John Groves
	<john@groves.net>
Subject: Re: [PATCH V9 3/8] dax: add fsdev.c driver for fs-dax on character
 dax
Message-ID: <69c36921255b6_e9d8d1009b@iweiny-mobl.notmuch>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
 <20260324003818.5009-1-john@jagalactic.com>
 <0100019d1d476420-6b0bf60e-3b3a-4868-8f5f-484cd55d4709-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019d1d476420-6b0bf60e-3b3a-4868-8f5f-484cd55d4709-000000@email.amazonses.com>
X-ClientProxiedBy: MW4PR04CA0044.namprd04.prod.outlook.com
 (2603:10b6:303:6a::19) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|IA4PR11MB8961:EE_
X-MS-Office365-Filtering-Correlation-Id: 07873dea-cda2-4841-18fd-08de8a293efc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: cvipf2WyWGRFn2WqhE2oHwizpS+iBbMFn0Knmr1t2utXSNGaNZiPvewsEWXdOxnglEXQk/Bt819QIo9Zm/HMzWNK5EED4vZEfyCelOSc4H9EgjdA7IBcjLhrklqZxdFzPqaLK3cimbyW3U+gQa4G/CyKNMtA48bFMmA/3Jju0wYD57tNdO11oXD8oq/FTumBGZFxXTOMqzcxIaxPs1sYujr10QYo3e1Nb3vID7xa6bh9K2OIIdPBOQoLXenOd7A5vRdN29F/9vAutTcx7b5kpplLlmp4SBweTV/lBgLgDbCUx9axaYCoOIUC+LgHY3ePk/GDodWC3q/1ShUkeo2YRIVgpgE8mwq39PY95fQyK85BRy7A4W1oHIadPSPomzyFCWex5WJ1Spm79KJtcWe3Co4Q4SL8N8BBmQh/k/13Z6kjfj7NKg+ql2dZqvBbsMBcDgnci0nA16f5QIzBfxqe5CfhoYfegTflCXw2ubJNL/nQA92u+vFIoPjz/MbOGuAaD6ebF4bxVpF831n6LfPVgFQpLbUMpEpGodGETk5DtKG9HKeNt4wvpGcAAvWnw0qhaltHRIr58ZaTPu8pZAOmSmoDp1+PThEipQtHM8FLLrjuBm6cNFERKu9Bi/eEQsOcs7VaBX3aoCQ4pbHcA7mx+wKHtf8daTL/LOfjDodrid6IRqzQWUto863ul73KUMZU6TDUFhf5qwRAuTQDaSdnqLf4Pnqa6WG0nBToHng5+Lo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?REB74AgDCpSbCf3cCI7C4fwzE1LZrDLS5dFtUhl6Po22A1yDY6PqwlZ1lTVl?=
 =?us-ascii?Q?ZIWo/7y1SMjDtKa95J/dKj9hXRX2yLvZQQTPjV9yBND9i1AWcMKIRN9WROsB?=
 =?us-ascii?Q?pfUatOq5pgH1zZgnuft/3dMt9mnZykyAsztj2ZOGwUxj/ni6UYMlEchPoc01?=
 =?us-ascii?Q?dPXojYv8aFzEsM8VWrk/1h2bIps6l/SdLl9zpzYxd3rm92c+3YMbVG9/lRPv?=
 =?us-ascii?Q?EPZ5Cj0JnyJD80au+pjrr8K3lPZjDTpHC3fifBXRs7AEqKQ+0+TW2sb6sRO/?=
 =?us-ascii?Q?8qTvy7tcwt88FEBLvplZ6hTXpLDtd5D13eJFGr+hoSv4yg59qdFdK/5GCnd4?=
 =?us-ascii?Q?Yya3wYGyo27kByQq8JVWg8Kb8rnH223rjxA9UI7GqQvWCcuAU7NTDcNvpOuw?=
 =?us-ascii?Q?+1gzdU5M/In4Qk9lQauxGDrvZfOhkvqd4/EjI8ABdma8Awd7c9GFdlrdzqFc?=
 =?us-ascii?Q?H2pKwhA/yahOz37lNnfyBbcsmkgjn7ZFAxaZNKO1BCGIQkNf8718cYfyoWAb?=
 =?us-ascii?Q?crj0XCzr/lsH9oGk/RA+INggMWQMgfXw7IldI75jJ/H0Kr/Tfy4ucIueoZwG?=
 =?us-ascii?Q?oz4AhZ18IprJUDGdOlSwFULxQ1OM+TdWQRcMEmVVnfKB1cLQRY5ZSLJiByAi?=
 =?us-ascii?Q?fPo02gpgxyFPPzBa5EPhSTTj94oQpTVnMUkor4iAM5Bqsby8YW8oL+5IdFp+?=
 =?us-ascii?Q?oaZfGH1lGwzq/Ih4OUqjaUPwGKjVj5YEyZwBQa6x5AeQhaW0KiJ4ZoPBuzKQ?=
 =?us-ascii?Q?xLq1J/9mqr9doJyRvV5gvCElzuAAMu43fPVjezkkjj9nWzMPhxNrZ21i3iEr?=
 =?us-ascii?Q?fBJGwje8qGJzsWj524P0k4OtmT8PWP3qpKlniz2bJ+2M5O7RiYo1dDvL8CNa?=
 =?us-ascii?Q?lz7ykDRT/Z7NZwT9v1YrqI+5FKfp2L6PvIzM/eBCs7pus6sLJ8a6bBftPSzU?=
 =?us-ascii?Q?BAKsiMu3d8NiPUcxNxZgtvRc7QD26ryJcSfUrphUdq3XueJU7ao1Fox+DQRi?=
 =?us-ascii?Q?YqxByP1+1d4/NqX6BbPCqRAeZMpi2cX9iyltl/N6XQwWbPTag6AqDDUJGBt7?=
 =?us-ascii?Q?Z+NtTYXuu6gAJ2xUB2k69TM5VIqOYzuV6VO/hnsqEQzmyCvDxkouy4Kze2YG?=
 =?us-ascii?Q?j6OpttYe6fxL/6OJbNbJmInzEIy08IYNFqQ8iRUur35VPmtdoxwqyJnJFu3Y?=
 =?us-ascii?Q?VXrkmhrpKyHhX0pDe1H7s9GOYwCQXXIkakx+RxL6AXtmYiPqN5+BqkL3JWGM?=
 =?us-ascii?Q?XS3EeLX0PHDfHgJwm1mwntssgR5xTgzri3Satu2NkCR4ga36hVESpYwxQmN2?=
 =?us-ascii?Q?Ini/c+lZbg4FNTjb76qsqFyC64Vqfq7FfjCLsETh6AP5nmq+VybTean3IaGl?=
 =?us-ascii?Q?d5NwddNMdwcInByTe7DB2i5hzDEZOqhjfKJmFer235HlDiQwTuKeLi4nVCx8?=
 =?us-ascii?Q?8j9fY8lYkdt7DQqLfHHDEUKhSTnrHeZ82nbFsap1pXNsQ272hlub37+cxA+e?=
 =?us-ascii?Q?d/XjpQe8gNqBYeYN12Fq9mNm265ntGR/6DEGM+8KZLDg13T/S5h3qyS9BGMr?=
 =?us-ascii?Q?AwWBf2ecujnNy3hlyA9UbWQqFFpgoTiET+OHzLnF417Pl89ofKbk3dU6V9fu?=
 =?us-ascii?Q?ZFmG/222Diuf9SulCepBZ/uf9e5iaUpvWLBYUThDqepHeoFtuI4rlKs0G3Ec?=
 =?us-ascii?Q?rbrRdmmmqbF1lmF5GXUcr6Tjf5huCYMm6sRiGEXU+rDiN98zErJph3RrE2Tx?=
 =?us-ascii?Q?QrMEDeH/5Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: tZSDzqsJRSLu/INXaxONRv3rgRVXx+CNpHqqmk12/mLZKTAsVefWIMKQw0eDVOt0OJQLURNJedFPxrWxcj6MvkjsLay0oCOTboGTML2Fd7EuhiTU0CAokcY3TF6a4fiBV3rvboIxLTmUrPTsM8Ae8aFEo75Q1tnPf3t3GVkb16I3p5B0HPIvI8jg2pXAgXVcxnfpzgGRY12R2murGgi7o32iGY+iZghPKZ9caW24crbBWpquF4kWfaXCU5YfbECqSn7/DJ9foUvvOmU+0/AAjt3RlS8DpUTqVTKD9a/rf+rJqRAAYShD9Y8NwZynbvNUmXlvrq6PXgddavFC8UWlqg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 07873dea-cda2-4841-18fd-08de8a293efc
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 04:44:49.0384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pYLLVfB8QVhmo2QNUXmn4CIWHHPnlBVsHfm7L29lmMY8wDErC94/s6BeDvGKBpjHRkX12uhyUAuaW0+yKZllbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8961
X-OriginatorOrg: intel.com

John Groves wrote:
> From: John Groves <john@groves.net>
> 
> The new fsdev driver provides pages/folios initialized compatibly with
> fsdax - normal rather than devdax-style refcounting, and starting out
> with order-0 folios.
> 
> When fsdev binds to a daxdev, it is usually (always?) switching from the
> devdax mode (device.c), which pre-initializes compound folios according
> to its alignment. Fsdev uses fsdev_clear_folio_state() to switch the
> folios into a fsdax-compatible state.
> 
> A side effect of this is that raw mmap doesn't (can't?) work on an fsdev
> dax instance. Accordingly, The fsdev driver does not provide raw mmap -
> devices must be put in 'devdax' mode (drivers/dax/device.c) to get raw
> mmap capability.
> 
> In this commit is just the framework, which remaps pages/folios compatibly
> with fsdax.
> 
> Enabling dax changes:
> 
> - bus.h: add DAXDRV_FSDEV_TYPE driver type
> - bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs
> - dax.h: prototype inode_dax(), which fsdev needs
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Suggested-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: John Groves <john@groves.net>
> ---

[snip]

> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index e4bd5c9f006c..562e2b06f61a 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -81,6 +81,10 @@ static int dax_match_type(const struct dax_device_driver *dax_drv, struct device
>  	    !IS_ENABLED(CONFIG_DEV_DAX_KMEM))
>  		return 1;
>  
> +	/* fsdev driver can also bind to device-type dax devices */
> +	if (dax_drv->type == DAXDRV_FSDEV_TYPE && type == DAXDRV_DEVICE_TYPE)
> +		return 1;
> +

In building up a topic branch for this I notice that this breaks the
device-dax test.

1/1 ndctl:dax / device-dax FAIL             0.19s   (exit status 250 or signal 122 SIGinvalid)
...
Ok:                 0
Expected Fail:      0
Fail:               1
Unexpected Pass:    0
Skipped:            0
Timeout:            0

Have you run this series with all the ndctl cxl selftests?

How exactly is this supposed to ensure the fsdev driver does not bind to
a regular dax device?

This can be fixed by reloading the fsdev module thus pushing that driver
later in the driver list...  So we need to come up with a more reliable
method here.

I'm holding off pushing a topic branch for the time being.

Ira

>  	return 0;
>  }
>  

[snip]
