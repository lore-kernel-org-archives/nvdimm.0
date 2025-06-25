Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F5935280
	for <nvdimm@lists.linux.dev>; Wed, 25 Jun 2025 22:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750890305; cv=fail; b=mwlQ4On93+ZP6OzouOxCmubHxIrqC/bM9UXgRT4fnVJHiTNFnN3OLNL2PPVxUb67yN40jBCtXpOO/pIfXeuwvUExYNoc51omMppEwuawb1Pp8kr1ufVsdRta2c23SJzYxm0zOkFooYEmWsr/EOpXxepfdxLMiVe8mrVdFB/fALQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750890305; c=relaxed/simple;
	bh=bKysMxEImWdVOj1EoOt7O9kj3vxMWcrJcniv38x4gD4=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=TQjZolDtWlKZ0aC4ndW9L+gttjN/x5ZrYEA6Ou/jF9jVwpodijugaeqgJZ4mpllplaEogsjfhkbJp1o0lkgDhBtREmjScCy4v+OTbAiOKhywuYGPpuqFL0u9kgbL21SfQSmpoWDrV6uDCIwitVY6dxtcD2uIemgSqzRPnoWfSkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IBdKiZuI; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IBdKiZuI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750890304; x=1782426304;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=bKysMxEImWdVOj1EoOt7O9kj3vxMWcrJcniv38x4gD4=;
  b=IBdKiZuI5nBUq8tFDnbdz6imry7IDVyszcmBXLkaNb69ujgTj7Q5oeQr
   UueTYVzlIDQYrnoAn/XKFxtNULGXOvoch2SRNPV1d2ww1QkzOAz6PBzR6
   qUbG/fZWeiyz+R515htvhodxiEBa8kj7zBgwRdNb/BruuzUrkeGJqisBW
   e/re0CNdRlP/9w6LvsIQPWz4Wdt6gceVCTfn7IL/3GrLN85tycH2p9ket
   bx7X54T2i4829sY2BzOr2CHmqR1N+/9NCq8Dov5YIsqcM/biY/cYpl83W
   cO8mLvapG9+3d8B7oyFeTZftlRyaoa4YUzA7J6e6lWP7nLNCOk1p4JaFT
   g==;
X-CSE-ConnectionGUID: 6dnITnQeQ2G1GVRTEX1CDA==
X-CSE-MsgGUID: vo9p4AllScy90J0O2kU9Lw==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="53047585"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="53047585"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 15:24:47 -0700
X-CSE-ConnectionGUID: ijcCFimbRSCFTPkr+dFWYA==
X-CSE-MsgGUID: hFpo0giXR0eo71RZ63/LXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="151861854"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 15:24:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 15:24:46 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 15:24:46 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.88)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 15:24:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M+sjPqNb/7ZECpmFMtCV0YQCwmmFVzk0pyavKp3l6EYArC49rVyBcbIhY+o+AQzgig4OXnsf9wojmjQr6TgK2fBZNmb14VXZjyqZSvpvqk5GwZshfeMiTedsy6h6yDD0QCeBGdUagJSOdVVGs0vKPwMPaIjAaN1dAfrV4nhyfF1PQupJwM1KNTQPYrJKWbGZoST0t1tLm0IFqH+OtneGeFvv3h1FbbHoSJ5B+Mv80tQgIDjgEhw5PH0YBbexTJA/Jqwczykn9CP4Z95iakc+IAC1CxtcQRqWO5BKplD/xbNenXl86skSrCIUPrhSRdycdmPnjLzXDR0r+mO1Jhltmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wGdHKnp68uAEePfoeCrD89Wr4BeZJrhRKwlp+yBs3pI=;
 b=Xs6ELv8YoBVXXELqbzbupsItqFGKP6uYrRAmaN/V0QO8XB9JOB/0846YFhmFa521w/gfBGX3gPRWOiPcrxjJQVdTxAFNmMEYfbywv6dT++FpqvBRjLyp9NNKO04EG04NiyMW71G/eAFH6E/gq4S6AAcTfBKetOh5QrGFEThGNx2+PciOXHFS38wXWeil9nfq4GSYc2IdYX8ImnLpxlsC4fqY4Stcx62WlO9MFyIK3qK7p3XM/kNT3kqQ+NFRj1IhmUNF8eDB5d1EZeRU0dCKDK5gaY9wqps5NCccTJGlSPsYmNUojcuhePgxYtILw5OdU4jgbFi2NMsMvCIxZNuXsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB7418.namprd11.prod.outlook.com (2603:10b6:806:344::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Wed, 25 Jun
 2025 22:24:44 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 22:24:44 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 25 Jun 2025 15:24:42 -0700
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	<dan.j.williams@intel.com>, Kees Cook <kees@kernel.org>, "Gustavo A. R.
 Silva" <gustavoars@kernel.org>
CC: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Len Brown <lenb@kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>
Message-ID: <685c772aa7cc1_23a2a10080@dwillia2-mobl4.notmuch>
In-Reply-To: <ade0c2e6-0698-4829-8c7e-cec3c486aac7@embeddedor.com>
References: <aEneid7gdAZr1_kR@kspp>
 <202506250950.31C8A58E@keescook>
 <e0adad17-5d4f-4309-9975-81971597da65@embeddedor.com>
 <685c5d0062f2b_1608bd10051@dwillia2-xfh.jf.intel.com.notmuch>
 <685c653a6fe42_1608bd100d0@dwillia2-xfh.jf.intel.com.notmuch>
 <ade0c2e6-0698-4829-8c7e-cec3c486aac7@embeddedor.com>
Subject: Re: [PATCH v3][next] acpi: nfit: intel: avoid multiple
 -Wflex-array-member-not-at-end warnings
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB7418:EE_
X-MS-Office365-Filtering-Correlation-Id: 1770de04-8fbd-42dc-8bb5-08ddb43715d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WFFWWVNJNFNKNkFzR2Q4ZkY1TFBQTEd6V3lEUGVOM3dEMG1sWHVva21aOU44?=
 =?utf-8?B?bHFzZU1rKzI0TC91eGdDbDBQVzBkZE5pUndKVkcxU0V2dEk3U3JoM2V2YXAz?=
 =?utf-8?B?ZEpGdTBvWTRaQ2h4eXkreVRNclRDYURYbXdCN2VjVTlCa2NOcTNlbVc0T01o?=
 =?utf-8?B?Z1AzM2JlNjUreG1JcFJWMzVFV243U0xpRjBxY0c5WmtLYjRJN2hQS2Fhdlcx?=
 =?utf-8?B?MlRsODV5Qk4yTEJ6N1FCRnlJeVZCakNLbjdaUVNadFZxeVh4TXRFMmdqWTh0?=
 =?utf-8?B?RWRHeTFZMGtOWG50V0xMek9DVWdHNHBEWGlicVJ3SnppTnFtR3JDaEI2VnNL?=
 =?utf-8?B?M3UyaisyVExsL3U4eW10Lzc0SER5d3ArOUwxSFpEOUxaek5JckNZWFE0b1hm?=
 =?utf-8?B?N056NzdYNUxhT0hoVE9rQUJWdWM3eldiMCt0NnpvVW9pWlZDWHdXSkVRRlVN?=
 =?utf-8?B?cUpkdkNkUWZpaVQrTitJMzk3L1NuSUFNRHlaQkJlUDA3c1lXNVI5cEhkLzVm?=
 =?utf-8?B?QnVpaVlleU9SODhKQjN3MzNubWdIZWhhZUd0RHpUcnpuM0lvQ3hkMUoyZ1Z1?=
 =?utf-8?B?djg2MUNxTG1hdWJrMlcrVEd3RDJIeWxNT2xQR1R0TFpLUE9jcXR3dmRFNlJu?=
 =?utf-8?B?REV6YXp3M0U5MHZNU0dtdkxLQXp2aEY0eGtVaUxRZm9TaWp0UUJvYnh3MG5G?=
 =?utf-8?B?V1J0ci9Gc1hHMEFhZXhxY1h5b2hNcmFVcGtQRGxLZVFmelRBWWxkcXE2VG9U?=
 =?utf-8?B?bEtvVVByb01YQTg1QnBGK2E2MkwrYm5DLzhVSStoUURDb3p1VVhBTm1aNEJ6?=
 =?utf-8?B?Rk1raE5uUGpDa1RyYWFKVmRvYTJqUGxrbG90eG0zU0FaRDdCYzhVOTRySm5w?=
 =?utf-8?B?K3lIeGVZOHRhWnJ2VG9lMnBLZmdJalJwMWdpUm5XK0Q3WUtheDh1ZjEwMDJz?=
 =?utf-8?B?T0pFMUNldnBjUTB2N3pKd3pIVUNtQ3MzcXZsK2E5ZkdXdXRycDFETFhvZ0NN?=
 =?utf-8?B?REVFVFNLeFhsdWNxOTFzci8rd0NKaFZvL1JnaStlcC9qWXJKTElMNTRJVTRO?=
 =?utf-8?B?WjQ1MENDaGR3aUVsOWJZNC9nbmJpZ2MzZ1R5RFZjZUJaYlBNMUpUTXlxei9F?=
 =?utf-8?B?L3NBaFNTMjZ0eXF0RkdQenRSQW5IMVQ1SDVaaVA1ei8zVysrRzVJYUNockNp?=
 =?utf-8?B?dVI1VzA0eWRiODd2QjFPbGZKdmhQenU1VllScCtaWnlNVXZXNWtQV1ZxSlhM?=
 =?utf-8?B?cGFoSC9vL3NiNEsyYTZocjdRL2Y3Z0ZGOURSa2Y5a1FTWjdJZlFwUnZ2UGZV?=
 =?utf-8?B?Zkh3YTBMdXhIdEsxSFRTb0VnTnpIQmJ3WXVOOWlnTkpNV1M2bmd5RFFpVVYz?=
 =?utf-8?B?a2RHRVFyc1NaNmQzRFZnbmhQRENGbTJwa0lwUjdWcFFyYVkvaG8rVEw4blRz?=
 =?utf-8?B?ZE1SbjNHUElVMGtCUEk4QTd6cVJpWG01Z0Z5eno3Tnp5TDdTdGoySk9KK0l4?=
 =?utf-8?B?L0wyV3FvRkluaUVFd1d0bEpkT1lrQ0p6R3g4T25aUTV2VnRSUUtKRGJCUklH?=
 =?utf-8?B?M0o3MStEdE0yYjFNTCt1c2F6MkNEc3BSTFBOOE9Gb1d2K3EzTWRScVEyNzZw?=
 =?utf-8?B?SFE4UGdKRnAvWXZaS1c2K3YrQ3E5d0lPdHF5NlJTMm04OEpNdUtqVVhtSEtm?=
 =?utf-8?B?Um1ldHUwK0tVM3pNOW51ekxrV3lGdVVLTEdzeVpoZklrMllyUzVWcjFyUFU0?=
 =?utf-8?B?SVFpWFYvS2ZZa3NFN1R0UDJ0SWZTNWEyTmEzSkoxUlo4eEtsZG1PUlkxR2d1?=
 =?utf-8?B?NkdUbDdFNDhlWTFNdzdZUkFpNWtQR0JhekdDSlpHRHZHQUhxdjNNU2xoR1JV?=
 =?utf-8?B?R1p2Wk9uTWd4WFp4Vk1leDVsdGtENXV3c0J3OXltUTBIY0RjVUNtOGZqT0JT?=
 =?utf-8?Q?GotpVkBGN+s=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajF6allNR2JZcDBkd2hyY0E2c0VWUWZMc0NaaTNtRmV2bE1pQ25icllZZWhr?=
 =?utf-8?B?UE9OR2VDN2RvWThYSzllTVNjZk8yTjVSMXlLcEEyL0FkMFBkbEVBb2xPNmNN?=
 =?utf-8?B?ekw1UUdNMkVpUys2TkE3WGdpTEMrazh3Z0M4Z0hJenpraFFsYlJPSldUckMv?=
 =?utf-8?B?YnhodFBvWWRkV1VBV0M2Z2YybFhwRnBmQ3Vvb2xlMFZrZndkSlZMM1Z5ZlRx?=
 =?utf-8?B?RTBhYzVOdHBlSlNxa0IvMGhUVEhXei8xbTYzUTlIT3N6YnQzRkU3RkZBMjlv?=
 =?utf-8?B?VGVIS3BDcmlmTkJybFJ3VXZ1SjNrOXdSODZZNENjcVBDZE42WXlDZUFUOXVE?=
 =?utf-8?B?T3dPbjRwVjVLRE1FOGVrd3Z3SXdveloyNWpmT1pQSXNkVDJKM1hNRUJIOVA2?=
 =?utf-8?B?R3M4TStCU2daaWU2U3djUFV4ZkJERXVGNkNTMytsd3h0YUxnMW50Wk1KSys5?=
 =?utf-8?B?aHFCTWtPR1dSbzJiRHAxV1VWVHNSdjR1Y0JFZGllbFNvenVSeXViTW11Mzlu?=
 =?utf-8?B?dVMybnBJQ2VnMEsyV210WTdLNHpOYmJqekV6Sy9qc2xtSFVUZWs3QU4rZDJM?=
 =?utf-8?B?WXRzZGlyL29yblc1Mm1rYU5ManNCYUZZY3pZYlNGK1lRMUhHd2RHN2YzSjEz?=
 =?utf-8?B?SS9TVWZFTzdTZmMwNGRWSDZWakYzMTFySXRrcHc5cnFUcXBuVHBwM3lMcG9p?=
 =?utf-8?B?UkxsSkRna054UFpIY3FweG5xSW5iYTFteVBkWkE5RlNPQ21nbldhSFIyNXFV?=
 =?utf-8?B?cy8yRm9ZbGtxZ2QvN2JURUtTWCt4OEc3amphTTF1RnZUZVNrY21FSzcrdWF6?=
 =?utf-8?B?eWpJMDA2UmxBMVlEM1ZScDYrRzBqZ08wSlJlVllDWkl0YXdBN0d3WnVSZFhC?=
 =?utf-8?B?S204eG5lbDZEVW5yQmMxeldMc2NvR3NnYXNDZHRVdWJhUmVDT1hSa3FVZEY1?=
 =?utf-8?B?emwrY3kzZGphUXdSa2s1Wk4yMWVwL1ZKWE1zbGlGdWdObW5BK3Z3L3YwZ1JT?=
 =?utf-8?B?c0t5MTB2UkwyYTAxakEzTEJ5VVdsVldONlZybzQ1RHNRdmVZeDh6YkFyYlFO?=
 =?utf-8?B?Y1czZjN5blMyNUFBMXBrVWdPSjd0ZFBleXBiaVoveUVkZzhoRHdnZkM2dDl3?=
 =?utf-8?B?WGIrK01lcXM3MHd0N29IQUg5NGNhbmxUSFdFN0dsU3FSWUd6SnlHeUUvMC9P?=
 =?utf-8?B?VDNjNUI1bjlycngyOGFCRU0zbGtkTnBVancvaGRudTFOZCsyclZtYmJrOVht?=
 =?utf-8?B?SkRYS1BGcE9DUVlFL01FNllUNE1jVmdpc0F2T2NuVHZkeUQ4d1cwdW5pNllO?=
 =?utf-8?B?Qm1Ici83UGlaSUUzc1JPcFEvWExJQThYWTVqK3pJTVBKc2R2bDl4WmhwYXVv?=
 =?utf-8?B?blRVR0VqS3ZrdmJwSTdrWHpvajdXcC8ySWlpa01sQWFiSXRaMElJaWtVOUFn?=
 =?utf-8?B?eUE1cmJFOVFBUkRFUmVDeWFkUGl5V010TFh4VmZEZFdNK2JoeExJd1M3Nnp3?=
 =?utf-8?B?OEExMkQ1S0NMNFJZV210Y1FWQWdMYk5yRyt1QmxhQzNjcm04VHZNa1EwbHNv?=
 =?utf-8?B?bGhmQytuWTF3dXRPNzVpWmpnY1BqYTE2bFRRakJCcDc3SVpoaG1sU2Y5cEVo?=
 =?utf-8?B?ZVNVZ1lBQ2d6TTFLZ1F2TXhwZkNISksraWhicnhTSnFoZGVBWDFUckk3N2FS?=
 =?utf-8?B?TlJjdnFTc2hiZTFJdkY1YnZxSnh5cUluTmErMmZFTzlzd2FkdDJpUGR3eDR0?=
 =?utf-8?B?QWs4elJsdjE0YlZkYU5FZEoyTlpvbnc5TDVybHdLa0I5cStMaVVBMENEV1lm?=
 =?utf-8?B?TXZJNFFsSmdXUWZNMmdHcllyVDdaNjhPTC83SkRTZ3RWRHpYZDBHaUVGQVA5?=
 =?utf-8?B?RlE0eTRocG5FWGx0QzQzM1lraG1zTUtjUkx4VUJpMlN5T3lMdGZ3U3huYUt4?=
 =?utf-8?B?RzlhZ2ZYL1BvN0hlSjMrWjJiMjBBUWFEb2ljREg0OHdJaWNVOHJGRmoxd1RU?=
 =?utf-8?B?MDJkYVVlSEN6cS8zajRYOVZXd2VWQWNlb1VUVFlyMEgvQjE4NzBhVWR1Yzgx?=
 =?utf-8?B?ZldhcFAwdmRKcFdLcDJWTWVZTm12UjNNMzVycWRiMUFVMHhMWGgxajhZTFVJ?=
 =?utf-8?B?Sm5rREQzMGZtcmVqMTdVRUNJeHVucGRqbDJVVGxWNVRvZDEwdk9PQkdIZzdL?=
 =?utf-8?B?Z3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1770de04-8fbd-42dc-8bb5-08ddb43715d5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 22:24:44.2087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: elvp71mzxZP37zdMmZQFk1eMduSv7qxbcO0rZw554HymgNHrhXV5KQQuFseD707dp2Ce129vh5udjhQDZ9qN5YdoTSOqGmvhUJ5wqp5/pdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7418
X-OriginatorOrg: intel.com

Gustavo A. R. Silva wrote:
> 
> 
> On 25/06/25 15:08, dan.j.williams@intel.com wrote:
> > dan.j.williams@ wrote:
> >> Gustavo A. R. Silva wrote:
> >> [..]
> >>>> I think it would be a pretty small and direct replacement:
> >>>>
> >>>> 	TRAILING_OVERLAP(struct nd_cmd_pkg, pkg, nd_payload,
> >>>> 			 struct nd_intel_get_security_state cmd;
> >>>> 	) nd_cmd = {
> >>>> 		...
> >>>
> >>> Yes, this works. Hopefully, maintainers will comment on this and let us
> >>> know what they prefer. :)
> >>
> >> Hey Gustavo, apologies for the latency here. I think TRAILING_OVERLAP()
> >> looks lovely for this if only because I can read that and have an idea
> >> what it means vs wondering what this _offset_to_fam is about and needing
> >> to read the comment.
> >>
> >> If you can get me that patch on top of the TRAILING_OVERLAP() branch I
> >> can test it out and ack it to let it do in through the KSPP tree.
> > 
> > Just to move this along, I gave this conversion a try and all looks good
> > here. So feel free to fold this in and add:
> > 
> > Acked-by: Dan Williams <dan.j.williams@intel.com>
> > Tested-by: Dan Williams <dan.j.williams@intel.com>
> > 
> > ...and take it through the KSPP tree with the TRAILING_OVERLAP() merge.
> 
> Thank you, Dan! :)

Uh oh, I spoke too soon. I saw most of the tests pass when I sent that
mail, but the firmware-update.sh regresses. It passes on vanilla
v6.16-rc3 and fails with both the original open-coded _offset_to_fam[]
approach and TRAILING_OVERLAP() conversion.

Let me try to get some more debug info.

The test is:

meson test -C build firmware-update.sh 

...from the ndctl project:

https://github.com/pmem/ndctl
