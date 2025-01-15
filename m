Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7F620ED
	for <nvdimm@lists.linux.dev>; Wed, 15 Jan 2025 02:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736908561; cv=fail; b=rhDj7mc7sJAjAvkObENA/l6a3WmQSFn57IOcufLyNw1k3tIdOuZBTHMlVdDRQdfaBTdZh9E+HnP3+aNKVrjxqLF4h+yH0vzmmo0BlqGtTkPnEKwUFiWHPMl8jpJvyy790r1guEDZ8l3CtBFR2hRsrgNNm3q43XM4cXsP3mv4OS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736908561; c=relaxed/simple;
	bh=gsHK8yKrwOIssaqBnfbpJPjUtdT0S7qfHN6vDWJTz4U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=smAAfB+xMaeKMgNteD7dAHGUGRGiMmLj6At2WPb6P0ncPLZpKmSmLXnqznTg43smEVuVVz35KD2KYIQupomCWOrtI8+YvtrXwXeOSgaY7JcDoVEPZaquS4/cacpDCMV7rrlM3zX62ark8shyw9X99zD329zqGKEwfpb0Ofpjl34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QIBKM2K1; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QIBKM2K1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736908559; x=1768444559;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gsHK8yKrwOIssaqBnfbpJPjUtdT0S7qfHN6vDWJTz4U=;
  b=QIBKM2K1ZogBfayCtQMlSjUB0SZ6D5pnJBtO5poo5W6cPhREAI5Nj7uK
   p80iLLXRxmPMf465lPXmJrOTIzs7GCj/3J/b4aXuQzWhkdgyRq3Am4noc
   uJi34vI2vu9rt6GdcGwlO2IEZ4ODqWSx2W4mZXOoEdXsKlDUEdDofaKud
   XUbW2u+slv2t3JUFFUn9TxhTt/IIlaYOoLyjN7q4FKFNMVUb6ZzJpPT/2
   fGdktvuL6J6SekcF9Gz7N3fYFlAkNFveMT7aN1TPkTs+NwnY9KGOkEUSH
   ERkFYMid9THVXfrPmHwgOnJyaeNxl5uteMYyX8hGIuzbdEMhg03t6CmSt
   w==;
X-CSE-ConnectionGUID: EuWXgJ+3R0WU2QhSjjfoNQ==
X-CSE-MsgGUID: COOXe986SBCHccfLsEl5CQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="48637634"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="48637634"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 18:35:58 -0800
X-CSE-ConnectionGUID: pTI5oNhjTnSo/KA2gArzEw==
X-CSE-MsgGUID: q0HqrQ19RxesQVCG321VHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="104863561"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2025 18:35:58 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 14 Jan 2025 18:35:57 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 14 Jan 2025 18:35:57 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 14 Jan 2025 18:35:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jK375qYjl0B4r3FES2hvR61BO7M2eUhtijDj/kQalhV+0Cwda7DsdSpEuTPs8Z9p5iXt65PLL4ce7wwYgascH8qeS8/AixuWMlywczmdkUW6nkJFWwSmJzpSxXidYJ5fum2VDxM+48OKe0O3ExjYVUjCEhcHT2d0tEOq0+Y12o3X2UQdyL8l8LLuju/m7fr7brIwrFMwB0niWDwHbt1m5PKkbN4mhqW5VXvTtLBbvIId1puKwvTiAnHlsn8n9ZODjXRouVYU0qN4paIp6OfPcNm5rCm9EhFiDZwURVaL/jRekkn1RE4PKjR9Drc+Quvwgq+2OYqN8x/j5fzTKAGovA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z7H+2tWrxlb7CFpN4ApVSS6fwFsH+VyqukqgA9knnnA=;
 b=BJ3qEtvql9G13RBE5+ZlsWrAILr+wt1rImEHgkVehhx3XsJTUbM3qUBnLaUEgjz7JCvNY/gSUVz/VGwYRyqwkvt2Sbpg9u5ANV7ImPaoAc1ngGoOnrjmA1Vp8dZ1gymerasVtkOAPPRfNp2p3/Br8Bt6+83+IGfW05LOkCVkJswsEZ8LEDboZpguZ9nYqCMcMiEtpaz3gBH555hY/8WCFwJxpzmVBK6rmkV1zlL47khLZTmAGXxPPQiiYH1VpE9oZtMiSy0IcriQXocFZQX3TWYm5cZ9hM0mb+iiKQ0yRMczi11aPQ8ISc8FsXjbrUuAcE8bslw6oCEQwv1hEvgndg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS7PR11MB7691.namprd11.prod.outlook.com (2603:10b6:8:e4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.12; Wed, 15 Jan
 2025 02:35:53 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8356.010; Wed, 15 Jan 2025
 02:35:53 +0000
Date: Tue, 14 Jan 2025 18:35:49 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, Fan Ni
	<fan.ni@samsung.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v8 02/21] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <67871f05cd767_20f32947f@dwillia2-xfh.jf.intel.com.notmuch>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
 <20241210-dcd-type2-upstream-v8-2-812852504400@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241210-dcd-type2-upstream-v8-2-812852504400@intel.com>
X-ClientProxiedBy: MW4PR04CA0349.namprd04.prod.outlook.com
 (2603:10b6:303:8a::24) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS7PR11MB7691:EE_
X-MS-Office365-Filtering-Correlation-Id: bcca76ab-1427-46b7-3517-08dd350d549f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?R2XIsdeOdJfhiKI1NkZKN/LgrlWgCXj/GH3lfDxPIfMd3zKsQNU9O3zCiY/5?=
 =?us-ascii?Q?ORwMTSDOoAlDEsN/peA6Imf7FTYiW2BcK6832Dh79EzDoJ9njI2dZP7E8Skw?=
 =?us-ascii?Q?+oJ1koMGx+XepdhyActTKjXYk88nOV1SPMkUAoGEKxyRP3zMdR6GaD1+u+JF?=
 =?us-ascii?Q?2MvCftcq5n5yImyx05oHA546Mjw3tWZ/3i1WWNWe0kqNtQdLc5Geupeq2c00?=
 =?us-ascii?Q?8fHTf4Kug6eN2KPAhSjjH5Kg6oCebpsw61oHAKIBO3DwtiDk32uVDeyTuaud?=
 =?us-ascii?Q?xatkE6EtaCWmiAIt4O+pDGF1DFK/Rl/5j79qF/AoPfQUk55CkJGG750s3nmW?=
 =?us-ascii?Q?o8kXHVPM8JY5SyOII+cuUPR5HVQVR/P70TtEDRt4FIfk0Hv6Cis95VF4t6yg?=
 =?us-ascii?Q?ESBGzokOhrlQEOfXOK9GMHFriK2kfiqKvcgmGOMz2Rg6i+MnYBvHTJ3rueLz?=
 =?us-ascii?Q?F8PMndi6ytCI8/yojK/Bsp5q7MQ69oN6cMuIwtwAyjXzm/o7XZgdO4834LoC?=
 =?us-ascii?Q?NsIT/TN1F8Vk/W583OuCnDd56XZq3R7THszwF7ikD5beWUyWIb8MjsZ4FaCR?=
 =?us-ascii?Q?SV4FjX6GkndokZjSmIjKOT4PV0riz3yJ5WBKg0hLbXqh2UOlp/jpo46e8Wlc?=
 =?us-ascii?Q?P5H559BQlrgnezx6FsTIGnF4buMS6CEeF/P9XrHKBuDBwydwpEtbWecroOtQ?=
 =?us-ascii?Q?UTOFrqCpSXtRSiwgZA6iYh0BMUJy0NSTCUQKxLzL3N2Ukr6+GQzAkIULPkbn?=
 =?us-ascii?Q?gW2iXDk9/R8gUa0znuhk3dyHlKVM29aujld5obfHdsWpWwagwc9nkRSNbA+c?=
 =?us-ascii?Q?/qeVgZ5LaxH4iuPMtZbuS9peO+IvuxxAR6eEclLBJumW77+snAorfvwY/cei?=
 =?us-ascii?Q?wG459lf3VMCLN6xtg8un9sLTtTUtSkoCVsZZex5C9H5pFDKn2tDEp0xoUGfj?=
 =?us-ascii?Q?kEVI8joNIC48JBJTck7ipQ7ovDaX3t4G5vtNomG19MIo0LU1hj2MW+CPOgTK?=
 =?us-ascii?Q?oBn2ryuojS8oYx2AoqGi8gIBoXTuD+2UTKUJwLhn2/7F1OcEwFFWmorPb114?=
 =?us-ascii?Q?XYpNHiES61UvMZccFMxBJ8eSj/Bgg1YxROomOqK5aUyZr45RY6ip6M6caHkv?=
 =?us-ascii?Q?h6ZpztCSlnqKMizAU5itIG+OGIi9wCU+cB1xdi87Df9vHtR6htYy7a9FmyiF?=
 =?us-ascii?Q?rKF+EdFh7DuaoHG83Dy/WFnWsA+GN7wsDiiz4Ltktejld8xeztunsB4q93ON?=
 =?us-ascii?Q?mbRjw7vdNQQ2gSaEhj3SIGG/kzWKJg1n6Rjvgp3xLYdrPwQgAb6z29kzxKKw?=
 =?us-ascii?Q?GOWMTnVHfZX+qh+7M/MGcT7VydgqGGAL/ZMcgq7xuxzhhBi8fagBsC0RmVBQ?=
 =?us-ascii?Q?FsklOx7LDfrnDiWQicWp0TUMoP7E?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vL07E7SSOzw3cN3eqICXWnP/u7FKthcJBRZj99MYqghI/1CXwVxiT/V0rD/q?=
 =?us-ascii?Q?k7Dz1ONO3OnddlPvgvL3/TLUiLYtQUFUykiuLcKL8gQdM5Okh99goA5wKDjk?=
 =?us-ascii?Q?HZJZg0G+mH0DkSuYS0GvQS3yp9jygK0XFe3F7/jv/oTy5wBlKPxc+4Ukch8b?=
 =?us-ascii?Q?G7P8vU1Q0JhX17ADMjvxJaA+1I7SBddl3kmInEfzM3VxVrVmlWcjf+xrp7IH?=
 =?us-ascii?Q?iCgECYJcblTqpsEg1huZ3DmgdV3r9yvnUHY3eJ+HFSCokIVKfMKPDYhpaqpE?=
 =?us-ascii?Q?/ZCW4/Ogep3Vbdl66Nw5hPnu+Fht9RbZcaMUfyFQTOD7GK9xIQ4wMCZ0E+Ch?=
 =?us-ascii?Q?LRJgErjsFo8im80VCcJ8MQYAZd/Aq8BkdTFlsURubFw4/DaQrrK71XPGF0DX?=
 =?us-ascii?Q?EoQJe3KSgxgk6T1TZaizLewJwQEG/wPASb2804ahobhf4E2IIvPodz1dG42i?=
 =?us-ascii?Q?VrFpZ7UuK7mjsB+3yU6b4I1tMX5T8sdBnix3akcGrdqBc1vKaH1U+32Pz02b?=
 =?us-ascii?Q?oV3dgF81yiuuWCOOko8HVen5nTDiQ0hPkuXXiSrzJPwgj7khm34DGQqE0cJ9?=
 =?us-ascii?Q?zeFjV4bDoyGbrmU9UYqAHxudCJ10TjdgV0IZA9hiJzzOXOWlEALlE8Pcc+wZ?=
 =?us-ascii?Q?7s8wgrDD8rUXsNaByGPxk+ipNEkH5Xa+QR33I9EP98Ib8wF9XMyvLjIIA9C1?=
 =?us-ascii?Q?E1DdQfpYJizx0oZi2AarYKzhYr9vCvL0Y4APCR/aeHvRUMSt0cs/+jpZNEqa?=
 =?us-ascii?Q?W1pP+kDZgZZHGQBAcivXaIS64V2CqQz4340MJqeUSzGNc1H/QWOQo1oPknBk?=
 =?us-ascii?Q?wUyye3lG+EJLqsWhCVJJa6yEYWnNiMd3f7+4gjURQA7XP4y7Ep2/0nGocxSi?=
 =?us-ascii?Q?L2JA27vgV+RGeiaXDXfxAejwRVUKl4t8JzBz3VXtfPSSXUTn5pAMQ1kgfzNL?=
 =?us-ascii?Q?oL7Wzs0wiiuL9zuy2XCWF8pZa5Wj8zj93KDc1MxcjVkRPaRFrhHqzNlYZ60s?=
 =?us-ascii?Q?licOH45NOSc+fB6cbo2rHpSM/0MDYIPEJAGvChkLGhwxovGklXgV2FTxlxit?=
 =?us-ascii?Q?QcDElJrZUq15vbIekct7lHw7lB004ZFdlOSXiibHmrr0GpHncwog1NeJJQpI?=
 =?us-ascii?Q?HV+ncrHfuu3GNPZdCuD/taNWyMuBL6w8XFmhLcJMkC2oJN/tSiPrnR4OB3+U?=
 =?us-ascii?Q?V4kCxIbN1k835IN/rgbf8pIlLGdU8jB70gjcg71Qu3c5fG+7FekDEs+IIBCT?=
 =?us-ascii?Q?aon7zQwyzztKiDTjHIsPEUFem65y51UuL7E6h9fCyY+QT51X+PBCK6pgTqeB?=
 =?us-ascii?Q?49jo+/0scXPXGjfg/bfA4Qg4/CAQM3NqHhPCo94xgGyO4m82wEqMZBEF+G4I?=
 =?us-ascii?Q?Oc91sNxZ2Gs5DUmYcURXyRIOAIb2X2gRNjpgWiqCJESHCyJrP/h+psIa8JIc?=
 =?us-ascii?Q?6fOdkjn1a2xMYnRNG0rgtKRpKA3MqwyUHhYWgym9DOlZmkFrBB/INpKYw0hW?=
 =?us-ascii?Q?1qYF0+cQHyWUaLxMtjTRBPU/mfyMCSqTSCOgXUaouewcAywEesHzJ7w0xTXP?=
 =?us-ascii?Q?3XcP5comgs4m1wl7lPOojmltsiph9nY1y08zubdCnA8j9DiF7kHzky9mclmr?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bcca76ab-1427-46b7-3517-08dd350d549f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 02:35:52.9258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: skoTAmz106S9lBqIdDJd2HDQymaqq8oLaFlXEtAn7jRFo1XP/ix6pg1Jhj2s5l6WxfmQ7kdV2hctX1PVbhSn9cMNS3IBjWw19d8wsi8P33g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7691
X-OriginatorOrg: intel.com

Ira Weiny wrote:
> Devices which optionally support Dynamic Capacity (DC) are configured
> via mailbox commands.  CXL 3.1 requires the host to issue the Get DC
> Configuration command in order to properly configure DCDs.  Without the
> Get DC Configuration command DCD can't be supported.
> 
> Implement the DC mailbox commands as specified in CXL 3.1 section
> 8.2.9.9.9 (opcodes 48XXh) to read and store the DCD configuration
> information.  Disable DCD if DCD is not supported.  Leverage the Get DC
> Configuration command supported bit to indicate if DCD is supported.
> 
> Linux has no use for the trailing fields of the Get Dynamic Capacity
> Configuration Output Payload (Total number of supported extents, number
> of available extents, total number of supported tags, and number of
> available tags).  Avoid defining those fields to use the more useful
> dynamic C array.
> 
> Based on an original patch by Navneet Singh.
> 
> Cc: Li Ming <ming.li@zohomail.com>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
> Cc: linux-hardening@vger.kernel.org
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes:
> [iweiny: fix EXPORT_SYMBOL_NS_GPL(cxl_dev_dynamic_capacity_identify)]
> [iweiny: limit variable scope in cxl_dev_dynamic_capacity_identify]
> ---
>  drivers/cxl/core/mbox.c | 166 +++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/cxl/cxlmem.h    |  64 ++++++++++++++++++-
>  drivers/cxl/pci.c       |   4 ++
>  3 files changed, 232 insertions(+), 2 deletions(-)
> 
[snipping the C code to do a data structure review first]

> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index e8907c403edbd83c8a36b8d013c6bc3391207ee6..05a0718aea73b3b2a02c608bae198eac7c462523 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -403,6 +403,7 @@ enum cxl_devtype {
>  	CXL_DEVTYPE_CLASSMEM,
>  };
>  
> +#define CXL_MAX_DC_REGION 8

Please no, lets not sign up to have the "which cxl 'region' concept are
you referring to?" debate in perpetuity. "DPA partition", "DPA
resource", "DPA capacity" anything but "region".


>  /**
>   * struct cxl_dpa_perf - DPA performance property entry
>   * @dpa_range: range for DPA address
> @@ -434,6 +435,8 @@ struct cxl_dpa_perf {
>   * @dpa_res: Overall DPA resource tree for the device
>   * @pmem_res: Active Persistent memory capacity configuration
>   * @ram_res: Active Volatile memory capacity configuration
> + * @dc_res: Active Dynamic Capacity memory configuration for each possible
> + *          region
>   * @serial: PCIe Device Serial Number
>   * @type: Generic Memory Class device or Vendor Specific Memory device
>   * @cxl_mbox: CXL mailbox context
> @@ -449,11 +452,23 @@ struct cxl_dev_state {
>  	struct resource dpa_res;
>  	struct resource pmem_res;
>  	struct resource ram_res;
> +	struct resource dc_res[CXL_MAX_DC_REGION];

This is throwing off cargo-cult alarms. The named pmem_res and ram_res
served us well up until the point where DPA partitions grew past 2 types
at well defined locations. I like the array of resources idea, but that
begs the question why not put all partition information into an array?

This would also head off complications later on in this series where the
DPA capacity reservation and allocation flows have "dc" sidecars bolted
on rather than general semantics like "allocating from partition index N
means that all partitions indices less than N need to be skipped and
marked reserved".

>  	u64 serial;
>  	enum cxl_devtype type;
>  	struct cxl_mailbox cxl_mbox;
>  };
>  
> +#define CXL_DC_REGION_STRLEN 8
> +struct cxl_dc_region_info {
> +	u64 base;
> +	u64 decode_len;
> +	u64 len;

Duplicating partition information in multiple places, like
mds->dc_region[X].base and cxlds->dc_res[X].start, feels like an
RFC-quality decision for expediency that needs to reconciled on the way
to upstream.

> +	u64 blk_size;
> +	u32 dsmad_handle;
> +	u8 flags;
> +	u8 name[CXL_DC_REGION_STRLEN];

No, lets not entertain:

    printk("%s\n", mds->dc_region[index].name);

...when:

    printk("dc%d\n", index);

...will do.

> +};
> +
>  static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>  {
>  	return dev_get_drvdata(cxl_mbox->host);
> @@ -473,7 +488,9 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>   * @dcd_cmds: List of DCD commands implemented by memory device
>   * @enabled_cmds: Hardware commands found enabled in CEL.
>   * @exclusive_cmds: Commands that are kernel-internal only
> - * @total_bytes: sum of all possible capacities
> + * @total_bytes: length of all possible capacities
> + * @static_bytes: length of possible static RAM and PMEM partitions
> + * @dynamic_bytes: length of possible DC partitions (DC Regions)
>   * @volatile_only_bytes: hard volatile capacity
>   * @persistent_only_bytes: hard persistent capacity

I have regrets that cxl_memdev_state permanently carries runtime storage
for init time variables, lets not continue down that path with DCD
enabling.

>   * @partition_align_bytes: alignment size for partition-able capacity
> @@ -483,6 +500,8 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>   * @next_persistent_bytes: persistent capacity change pending device reset
>   * @ram_perf: performance data entry matched to RAM partition
>   * @pmem_perf: performance data entry matched to PMEM partition
> + * @nr_dc_region: number of DC regions implemented in the memory device
> + * @dc_region: array containing info about the DC regions
>   * @event: event log driver state
>   * @poison: poison driver state info
>   * @security: security driver state info
> @@ -499,6 +518,8 @@ struct cxl_memdev_state {
>  	DECLARE_BITMAP(enabled_cmds, CXL_MEM_COMMAND_ID_MAX);
>  	DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
>  	u64 total_bytes;
> +	u64 static_bytes;
> +	u64 dynamic_bytes;
>  	u64 volatile_only_bytes;
>  	u64 persistent_only_bytes;
>  	u64 partition_align_bytes;
> @@ -510,6 +531,9 @@ struct cxl_memdev_state {
>  	struct cxl_dpa_perf ram_perf;
>  	struct cxl_dpa_perf pmem_perf;
>  
> +	u8 nr_dc_region;
> +	struct cxl_dc_region_info dc_region[CXL_MAX_DC_REGION];

DPA capacity is a generic CXL.mem concern and partition information is
contained cxl_dev_state. Lets find a way to not need partially redundant
data structures across in cxl_memdev_state and cxl_dev_state.

DCD introduces the concept of "decode size vs usable capacity" into the
partition information, but I see no reason to conceptually tie that to
only DCD.  Fabio's memory hole patches show that there is already a
memory-hole concept in the CXL arena. DCD is just saying "be prepared for
the concept of DPA partitions with memory holes at the end".

> +
>  	struct cxl_event_state event;
>  	struct cxl_poison_state poison;
>  	struct cxl_security_state security;
> @@ -708,6 +732,32 @@ struct cxl_mbox_set_partition_info {
>  
>  #define  CXL_SET_PARTITION_IMMEDIATE_FLAG	BIT(0)
>  
> +/* See CXL 3.1 Table 8-163 get dynamic capacity config Input Payload */
> +struct cxl_mbox_get_dc_config_in {
> +	u8 region_count;
> +	u8 start_region_index;
> +} __packed;
> +
> +/* See CXL 3.1 Table 8-164 get dynamic capacity config Output Payload */
> +struct cxl_mbox_get_dc_config_out {
> +	u8 avail_region_count;
> +	u8 regions_returned;
> +	u8 rsvd[6];
> +	/* See CXL 3.1 Table 8-165 */
> +	struct cxl_dc_region_config {
> +		__le64 region_base;
> +		__le64 region_decode_length;
> +		__le64 region_length;
> +		__le64 region_block_size;
> +		__le32 region_dsmad_handle;
> +		u8 flags;
> +		u8 rsvd[3];
> +	} __packed region[] __counted_by(regions_returned);

Yes, the spec unfortunately uses "region" for this partition info
payload. This would be a good place to say "CXL spec calls this 'region'
but Linux calls it 'partition' not to be confused with the Linux 'struct
cxl_region' or all the other usages of 'region' in the specification".

Linux is not obligated to follow the questionable naming decisions of
specifications.

> +	/* Trailing fields unused */
> +} __packed;
> +#define CXL_DYNAMIC_CAPACITY_SANITIZE_ON_RELEASE_FLAG BIT(0)
> +#define CXL_DCD_BLOCK_LINE_SIZE 0x40
> +
>  /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
>  struct cxl_mbox_set_timestamp_in {
>  	__le64 timestamp;
> @@ -831,6 +881,7 @@ enum {
>  int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
>  			  struct cxl_mbox_cmd *cmd);
>  int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> +int cxl_dev_dynamic_capacity_identify(struct cxl_memdev_state *mds);
>  int cxl_await_media_ready(struct cxl_dev_state *cxlds);
>  int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
>  int cxl_mem_create_range_info(struct cxl_memdev_state *mds);
> @@ -844,6 +895,17 @@ void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
>  			    enum cxl_event_log_type type,
>  			    enum cxl_event_type event_type,
>  			    const uuid_t *uuid, union cxl_event *evt);
> +
> +static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
> +{
> +	return test_bit(CXL_DCD_ENABLED_GET_CONFIG, mds->dcd_cmds);
> +}
> +
> +static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
> +{
> +	clear_bit(CXL_DCD_ENABLED_GET_CONFIG, mds->dcd_cmds);
> +}

This hunk is out of place, and per the last patch, I think it can just be
a flag that does not need a helper.
