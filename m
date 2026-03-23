Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17BE3DFC68
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 19:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774295704; cv=fail; b=cthA67lnrS15ZVmHVgQ0Ub822b5gIVMvBmNAm1nOXjDDNWHJsN5wRBSh+V6TwAOKUcVDhfuYSG9TZoRmIW4CebiZ/5J84zk5/d4jFxNwVOjm4C9iY8WUUOeFj1m6t5nOlWSFuQCShLCc8Ao90ku2uoS+YfaVIE89TmUZ5T3mTsM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774295704; c=relaxed/simple;
	bh=tjU/JdiPX7gES6KQm21cpr1je4QTjuXciyQtIQtakaI=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=ZXrQa9P4avPxw9h4+O6Zq5i8R95dhbJwAn3opAL9dInElpWosJrYA6CMTYOiEKoyYgqpkfc6AI3tAPNzQYBgTVSfvrjuV2n66XXpYVPK07chRzRsz/ognDMgXex/LCYcFNyl1E4VwxAw6ruvZKprknabvDaQ/3DUeveCCDDI/cY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lmO6Ea6K; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lmO6Ea6K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774295702; x=1805831702;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=tjU/JdiPX7gES6KQm21cpr1je4QTjuXciyQtIQtakaI=;
  b=lmO6Ea6KFGdn92RmrjzdPMytVKDAkBYSdcCwfPcMJgnSvaxi5wILkZRQ
   8MGMeTqmig+sDipGG96L5zklyYud60FVGgBCNscJZTKfUZ2bpLiITUduW
   vqlkE/I+yE8ZUX3kzloEB2sDUo2Fok1TzvEmJ7aAwGFPUNDXlymkSMPXh
   zrZlIpD2NaohHyYSsqfTj8bCHtdo86W3JPgrKNSuZmBEpeo/TFer4JRBi
   ma7BOX3HWPv0uTGmdyn27mJtk9diw5u9+2xxjLGqIXtWp5HOiOU05IaAz
   fWAzrpm6qqa9AFipGGO/z/1v3MaGzTi3p8ACvg/EUxIQZEs2autx9U+AP
   Q==;
X-CSE-ConnectionGUID: l8FW838nRsGJr6tNG95OOA==
X-CSE-MsgGUID: 3TK4K2C1T8i6t+1BTBCKXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="92876671"
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="92876671"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 12:55:00 -0700
X-CSE-ConnectionGUID: oECTAq5/TwCxC09Xebii1w==
X-CSE-MsgGUID: 4WPM3cWASl6Dn4vsOJlp5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="247837765"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 12:55:00 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 23 Mar 2026 12:54:59 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 23 Mar 2026 12:54:59 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.21) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 23 Mar 2026 12:54:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bn3jfhlQ8KKtnCO9G1l9uK187RtGDXm15yfZxJbPqamF2SRxsrsDqbe/5bNWzbs6FVZ60AuxkYKtF7P2NaBJh8Te4Xyxo2oKAvYpbEJNSRS7mO5s8mMBHGykQudBEEbYn7abCMRZrF8NtR6yoZs/d4RAIHcwI8KSGAKfkLP8R2/1yS0V23RAI6VwavjhqT5tE1yDLAg+kmAA8m2KNDIKs/0La8yzzEuwTMMCY0WFVit2D1qyew9k0KTdCCIsw+dy3aDeN84gmdGX/c9bsjXBDiU4t8cKGHl8yTLCMTB1Ut3GhoanMqAvjzEyppMRhtC3XXnihGu173WlT9GQyLIMpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVJOHigCTG8bpM//Je616h4kLMs+krQP+AjpiKHkPDM=;
 b=FRGR4dMJean2Cz4dMyG3dxNmbJdi1LVcOy+U+aJ0fkGUAe1Q4NZQTLbO86Hnd34IEeZq6Ww053QUP6tyNhFAFjwq5c4w6Kp0I3YykRuqSFOMobT+WB5lE7zp0sUKXxTJ4Atf9dqYaN0IDy1aEzuELP8n1j3M4yfOTyc9OV9L1FWm+i6Yk3aDTjS6U9NQt8Z+j1hz1RIIqxsz1GjXmoCRdlFHQEX/X4FtUDlwbaqEUMxuiEOlGd/3wC/fGjQ7hKfH1facDGfYa9X7RhOSCmXlfnwxpmtIXNc30ir7tz0zL2Y7wX1cbKO2R7YGcph7dt8wBALvOLzJsU9eM07gJ+vXzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by BL3PR11MB6459.namprd11.prod.outlook.com (2603:10b6:208:3be::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 19:54:55 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9745.019; Mon, 23 Mar 2026
 19:54:55 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Mar 2026 12:54:52 -0700
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>
CC: Ard Biesheuvel <ardb@kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, Yazen Ghannam
	<yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, "Ying
 Huang" <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Zhijian Li
	<lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, Tomasz Wolski
	<tomasz.wolski@fujitsu.com>
Message-ID: <69c19a8c66fd3_7ee3100e3@dwillia2-mobl4.notmuch>
In-Reply-To: <20260322195343.206900-4-Smita.KoralahalliChannabasappa@amd.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260322195343.206900-4-Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH v8 3/9] dax/hmem: Request cxl_acpi and cxl_pci before
 walking Soft Reserved ranges
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0262.namprd03.prod.outlook.com
 (2603:10b6:303:b4::27) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|BL3PR11MB6459:EE_
X-MS-Office365-Filtering-Correlation-Id: 0536b232-6a99-434b-b6d9-08de89160e1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|56012099003|22082099003|7053199007|18002099003;
X-Microsoft-Antispam-Message-Info: xODqXWrWl09tI1dQ6phV2KPMJxcCfMV3ZikHATFZTx1zHBOOz59InlWHsyEGKkur6T/fnnp5jkvU0tAZ4lAaCEM+VUYM4IUJHsYnnbkvBMSJj24Bq0VGVtM01/wKhkEc6bTwY6zx2krfTa1aAbbs22STwhNVHqbifcqLQPWJmK1YQYFuoSuwtnqgpu4P3otu6+gFFWv+7Gq3Asp643NydgbwvYIKNEDppt2Yu4PV/7DYjgkB4Gv62GbZg9q4/8MIWrzJ0N+1rpgB4/rlPBat4xwsFZqR7ijg56SXiof6EBrtjOXPy35bXH3s+qubOaCFl7YVZnsLOsRtvIQJYHJFZp7DQfBAgIsZOra+vc+uCaQrNseCoGTKN8HwGkkg4s+rRYK9j9qPpdZunsoTQu2c4U6DOnIfUup/OoHnJJSXvaPc6Fy9BO33QcPBuUBQ+uyN4Bj8oNwp9BVVCcEWwMtdcKtUwjeHBTb75qFO/zHKsU1pqF98zoOVXdci7JXLkIVuX6WhvJxtIv56G1fTrdyQ+wL7YLYM3ySkGpHHCMXyR5BzHTdy3Pg7h2uxeVGccZq8SFSTin69N3VOyRnSIL2fQOSM1onBu/otS76AEXUs2Zd7Np/WSgNr5Nqj9Jas7CdC9CqJAM7QEnE2siI5NJuwztC8az5hlPpThvVZ851eD0SwPXu0GmDPDxzTTj6QlGk1BVF/tsjj+JBbHL4qvWw5Iifw786in4dIpwMEhYGKvMgU2sBYS2jfl+3hmM+566St
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(56012099003)(22082099003)(7053199007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnB2RFBFMWRSVGhWMU5HQW85cUlKeTdkZ05YOTFoVFRVaVJodXhDTk5iS3lq?=
 =?utf-8?B?RkpXUjNMQ2REa1Z1UXRZSE9vUmgrMUpvUW5HcGZNc2V5bXJ3TDlTOTBFZWVD?=
 =?utf-8?B?clN2Q0h6Q2FUNEpBZ2VERENLbEU3eks0OTBpRVlTbWg3SkRXeXZtMzBiME5Y?=
 =?utf-8?B?WUN0U1hhZU5nNXl2Um5rcUs0TWYrcXo4Q1FhNWRQampnb3JpOEt2OXMrRUJr?=
 =?utf-8?B?aEh5d1hnQitmOXNGb0VFTnBpZ0VZbmNiRklWZUUram1OTDZmenhxQU1WdlRL?=
 =?utf-8?B?YUtwb2hPOFZnMVJwTi9DTlg2T29jTWtrTGJaSnNMUmN4UnBjY3BQMnNLQUhN?=
 =?utf-8?B?QWM5TVhNUjRqZXJ4M0RjZUQwQVdHbkJYS0ZENWxnbFZqbzNBUzZVZ2Q1UHdp?=
 =?utf-8?B?TWRRcFB6YUk3WkUvK1VrVE9IUFFWSU1CK1NleTRTNTVMalR3Q29ZUlQ3YS8y?=
 =?utf-8?B?ajdHbkZxbytrc2Y4cndub2I5QTJacWVScUljSUNONzI5dnZnempGdUFLekZ2?=
 =?utf-8?B?WTNESU5OYWovTk5xdFVPdjVqRWxoK1JjTTRXUGo4Ylk1WW1EbC9mMEFVckVO?=
 =?utf-8?B?MkcwTXJOVzEvSVFySUZFSnJ5RjZPbGhTM1k5YmVNWTRjRXZUL0JxN01rSThW?=
 =?utf-8?B?cG14WnZJL1Z5ZFhxYWFPNkpUUVl1WjdxRmg3b0dVZ2h6eXZxcVFpbjhpclc5?=
 =?utf-8?B?T0Z5R01Cd2JXa3NDMGxFbG42MFBRZUwvTVVjcFlFQTkrT2wreS92Yjgrb2pV?=
 =?utf-8?B?cStVN2xFaEF5VURpclRHVTdlL3NxVzM2S0ZaQi95SFRTNlRpbytFb1I3U0Yy?=
 =?utf-8?B?SjRVRytDTlNkUEt4QUk2RGU3ZFFpdEUxNnVQbmZvbmRwTGFUd3FBUnVqWjdE?=
 =?utf-8?B?MW1NTXhwL2ZVTWFoRnlWT1NhdFJCVjk1WnRxSC9ReEdpR3J1T01rVmxOOVZP?=
 =?utf-8?B?MTJPMTFoemZhallFZU1oNW8zejhGVG5XaE9KVGZoenZOZFZ0WE9Pd1dYVDR0?=
 =?utf-8?B?NmpCSlZaOW01c2t4dmY3c3Ztam1UK2t4ZDVoVUZ4akdUbG1UZUk2VXRSZCtz?=
 =?utf-8?B?OG1BenB6NXU0ZXBJV3MwUWduY2FoNVpQdTRXTXppa0U5SXVEenlNeUw3RWM2?=
 =?utf-8?B?dEZwT1NQdytTTG9LQUNGR3lYM1UrVXIwU29GOVdsSmowWTYvUzVqck00WU5z?=
 =?utf-8?B?S2FuTGk2MTBYMnA2amJGS3Q0M1N2b3l6QUFHRGdQWjVYaUo0YnNHRFB1Zmh6?=
 =?utf-8?B?VGNZWktZV3NHWm5HMzloYkMyS1Uwb2dpeW5TSXpsajJxYUhSYWpFRW5GMXBv?=
 =?utf-8?B?SDRqLzduaXVnRFl4SUxsYW9hQXRHeE1TS200QUx2RTN5THp4NytjQTFrakky?=
 =?utf-8?B?b0hrN0N2aGthR0svOFhyZXp1QTAvajF0bk1Xak5LUThFUkx6UEtEa1JDdGtO?=
 =?utf-8?B?TUNXZjVQM0JBaHMwem8vdkJRbUhTWHBsNDF1Zld2cWYzMlo2ckovL054ZGxX?=
 =?utf-8?B?eWtrUEpndFdVaWZra3FHNXVlL2FKMDRCdVA1S1k4NTMya1owaFF2bENIdHdD?=
 =?utf-8?B?YXpiYW5xQ2lPWTdraTFGcTRIYkZuWE1qMWd2WmNJMVRUVHpnaWJpeDBDV1Nn?=
 =?utf-8?B?eUhYSThOY0NWSWUwN3ZRTW1SdU5mbEpVRVZpdFU5bzhEL1RoM2ZxazZzWlpF?=
 =?utf-8?B?WDBMZFk4WXZza0RJWDhUVSs2Rnh1M29qREFxTyt1aWsxYzBoM2YrVjJ2d0di?=
 =?utf-8?B?bkNWYkIzZnFscVZXQ1REMm9jT0J4cTYrRHFkd2dIdlpjQlRWT1lvdjUxY0pa?=
 =?utf-8?B?WWc0L0JOaU9QVC9JRDZWMWxMblRCc29NYU1XL0xkRloya1dvSEwwSjV5Yks0?=
 =?utf-8?B?TWMxeGlhVE9acVQ2dzduNTBpZnJJV3hwT2g2RU44b0JsUXp2dEdyVXkyZXIx?=
 =?utf-8?B?ejRFeGFLcjRRZEdJQyt6TnJTazFsL2RvMHIrMWR2Yzk1WmkwcnBseXhha0ow?=
 =?utf-8?B?eTNpaS9PQ2I1Y0FzSks0eW5qZXhoVE9zL1U4ZGJKQW9JWFVmSnhVMXp2MGVu?=
 =?utf-8?B?ejYxM3NmaXVXNjdXTGFqbnBtY09pS2p3SUd3OGlRVzBTd3dWb1VuK0pBWlhS?=
 =?utf-8?B?UlN3ZlViWVpYN3NIaUp4TVZvUE4zdStaeVFSOVlxejlGRHBoQUtpM2dqREJj?=
 =?utf-8?B?QklyTklrWkZ4Q0FkUm9KeG4vWWVRK052NitMdmp5WkdWNHdQdXZSa1VaREVV?=
 =?utf-8?B?NnFDT2Jjb0VNc2lVNEJqakowR3I0K2ZGUXc3ckJJcjBUTlpISU9GeFloV3Jp?=
 =?utf-8?B?WlBYbUtmWWo5c3dMZFJQc04xbUI4NVRiRzNrcHRqdWpTcjlxUHZQMytDK2hZ?=
 =?utf-8?Q?fmJlR16tfWSxFtC4=3D?=
X-Exchange-RoutingPolicyChecked: FMaGmqdoLxhXCIE2mRrfrvv04nYxuJmvZj6azHQpjXWoBDoisjomTASLKOb8jYdCg/8txfD/05guyY2t0l6XvGRavW2Vez9l+hwOUNUuc3hMpky2nslNNRMLALz6Ltj4rUcNuI+e1lsi7fzG8m4GSmIGZX0Jsq8S0vMu1FTzbKSA5Ro/PyDuONKGLAMxf/SoCg3209mkHuN0LBzr6psObI944SEeLsT0FABMsl73CJokSLp+bM8nnCdP2F/e2CZSc51O4IG4e1IaJwE3ay2ZXa0wXGnuSo31UDCW4njW7UN8jWlISqEB8v4cBQwsaDSSJZl9pH5oc7MRcI6WZc0lOA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0536b232-6a99-434b-b6d9-08de89160e1c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:54:55.3689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5vXpXa+PaREEMnm6PcGAVJGqmrxAC/Ssq04yLOSxZIyg3SRGCwhRvm6Ffzirp5+Qq9Z2ZWKNac6xE16xD4F93iQk46lrmVHXvtCdY7uzdj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6459
X-OriginatorOrg: intel.com

Smita Koralahalli wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Ensure cxl_acpi has published CXL Window resources before HMEM walks Soft
> Reserved ranges.
> 
> Replace MODULE_SOFTDEP("pre: cxl_acpi") with an explicit, synchronous
> request_module("cxl_acpi"). MODULE_SOFTDEP() only guarantees eventual
> loading, it does not enforce that the dependency has finished init
> before the current module runs. This can cause HMEM to start before
> cxl_acpi has populated the resource tree, breaking detection of overlaps
> between Soft Reserved and CXL Windows.
> 
> Also, request cxl_pci before HMEM walks Soft Reserved ranges. Unlike
> cxl_acpi, cxl_pci attach is asynchronous and creates dependent devices
> that trigger further module loads. Asynchronous probe flushing
> (wait_for_device_probe()) is added later in the series in a deferred
> context before HMEM makes ownership decisions for Soft Reserved ranges.
> 
> Add an additional explicit Kconfig ordering so that CXL_ACPI and CXL_PCI
> must be initialized before DEV_DAX_HMEM. This prevents HMEM from consuming
> Soft Reserved ranges before CXL drivers have had a chance to claim them.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  drivers/dax/Kconfig     |  2 ++
>  drivers/dax/hmem/hmem.c | 17 ++++++++++-------
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> index d656e4c0eb84..3683bb3f2311 100644
> --- a/drivers/dax/Kconfig
> +++ b/drivers/dax/Kconfig
> @@ -48,6 +48,8 @@ config DEV_DAX_CXL
>  	tristate "CXL DAX: direct access to CXL RAM regions"
>  	depends on CXL_BUS && CXL_REGION && DEV_DAX
>  	default CXL_REGION && DEV_DAX
> +	depends on CXL_ACPI >= DEV_DAX_HMEM
> +	depends on CXL_PCI >= DEV_DAX_HMEM

As I learned from Keith's recent CXL_PMEM dependency fix for CXL_ACPI
[1], this wants to be:

depends on DEV_DAX_HMEM || !DEV_DAX_HMEM
depends on CXL_ACPI || !CXL_ACPI
depends on CXL_PCI || !CXL_PCI

...to make sure that DEV_DAX_CXL can never be built-in unless all of its
dependencies are built-in.

[1]: http://lore.kernel.org/69aa341fcf526_6423c1002c@dwillia2-mobl4.notmuch

At this point I am wondering if all of the feedback I have for this
series should just be incremental fixes. I also want to have a canned
unit test that verifies the base expectations. That can also be
something I reply incrementally.
