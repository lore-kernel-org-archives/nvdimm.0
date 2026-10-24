Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792806146;
	b=qOhmwTYnG44zMOVDdwHJXcTzahU7Pr43NmQwHLN2oPzrCoHeHZLAFqp6oOePx413OtfZ
	 edsZfEQJgXfj6MMDE1bPe+lmntTFA9pVTbTeCpmY0Mdq8d3npDp9+cAZ+nnjYZ9FSICV5
	 fOjCPo5KUgI0oWHR0UNiVmblLqPa9P8g8q1GilVECXGxAR8i3EYcNuIhewuXlzD/+aFn1
	 hLKd2x3gsw8Hjfm8SYnw+lMgowBaFNxSv8B4fN32QWadQZYWXsEELIWlUSgybT0i+GY8j
	 JQVHRO+gTp4xpo3/QX2QNHeghISYzH7RKcjl4r6Ajb5MHuw+yfgk8S2dBGlBPe1Knrw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792806146;
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
	bh=r1BYQ/txIT1JuZSZUbYJh5hpQiYSVKE046gCxK59WrQ=;
	b=mmf2sYCpHifCEBj7to8o6+f6DWtFlxPQTS380Qfd0afCMCDZtzIsIhpJSXnShtwAIdlN
	 2gTvbEn7fUG/I6b2R8qeaJWnzhz07aFYOdLMNBVdDDR1hv09OGc0gCyfQIfPSd5aPPqdq
	 xFJcl6YkKaRIldZuiehWF2QQTTkOG4gSy7mrXRcCi+RgQn+OzAITgBBVXz8ezVga8z3BZ
	 iVu06gR+5jA5v5I+lrzT3PH+ZPqRPNAtEvYlRzw6NavGn7sdK2NJRtmc0vLlfzhGp6Dsu
	 2UY5N7xdKhEL4g+rmlBJ/vC9iFSLwuiecPbqZP1a20tKDtnci3ExOQXi+cWdjwKGOGQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=nce+quwe;
	arc=fail smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09FF606A31B
	for <nvdimm@lists.linux.dev>; Sat, 24 Oct 2026 01:42:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F09FF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=nce+quwe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792806146; x=1824342146;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KVXU/wyxBlI2n/4qrUoMHFCC5+F7QBh+gCob1lfMD/c=;
  b=nce+quwezhwnxB5+52U78uJhqGTOb2QjmwEjFwzUeoKGjWxMDyZ5a7uo
   /imSeqDiZ4I/e8e2r8taGH+Uei8tmt2qgxuJLYI0XAAYz9EhmG+fQXiwJ
   OjkR+fR/ZvhXS0l6RHL/JWF90PptHvYNgeXA6uxGlDObsB74ZnDeJjU2m
   s05LwEtvH/V00V9YKOH+p1HH6dLWxql+gHiuDVt2BDTNZRn87rgXf+vrq
   5b5O+01IHNQ7ldhWkNJbodja9yhJ/aMkekFQUvIM2pPKlhaewGCiT8jKx
   cIHxv5Z+iDlFbDoTN19PnUXRRtciJrRt9g2hxJl6LAVp1jvAyPa2T/bwX
   w==;
X-CSE-ConnectionGUID: 4wSrbrHGRquKv1H9zc++vg==
X-CSE-MsgGUID: +6+zWTVfS5mlqLMVHxPYzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1585495"
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="1585495"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 18:42:25 -0700
X-CSE-ConnectionGUID: jxWOHdQtT1CFBR3QwDjZPg==
X-CSE-MsgGUID: pSYiRH4MQZ2z6hhBlnbYng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="3774537"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 18:42:24 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 18:42:24 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 23 Oct 2026 18:42:24 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.10) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 18:42:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hSdVcR9m1/azkOyTFZEfemOtayleILBBpIGGKl/eMRsOo6DgxXL3MLpzrujzxZTK8YstRmpQXynkzOQSjkq3Me1lfe/+ByWbavWoDjMdDEncNw49iT3IqWnEnHYF7qEN9+mR0VoPmGZTxa2sq/N5ui+9XIfuLl8TIQVM1A8LbeYyLdKlzO5u8cl4C3r8QtYWiOnFahLKDq/FRQlg4bIzL3RnN0IGabb7Id4cHy0SLnaf5V+8P55GaSw8qQ9Sg9v+Dpa1wVpxNpaUKVA101M4XM0fSPaZpr8rZsPk3cLdcGdgOXVOs907ckIcRFVD5Ld/i5lGJt8VDMDU0LytLlkn4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r1BYQ/txIT1JuZSZUbYJh5hpQiYSVKE046gCxK59WrQ=;
 b=PSqeM4Reeo9uO12ZjgcTV+LVb3OEGxPH+2j+dul2yeLXGyDLVPcNFIiGDWNKnS1VSAmc1ZcW8AAoGPXZ7qtZXgV83JZTpfq7p9LIE5tL9JruQCYWBgWB3QedXgcO0WsmEFdDSAso3Ki922WwqLgEBcUoHZyELXB+WsWs0M9MM79ASSbc0/fMa+PyxELP3avw131GXmxaH7GrmYW+WEGRlZtWwCjWoaQesK8kT2Z0lkDu5vmamtTjs/9hEEK/8AW2cbmHDg9RVqbmAdajmGFvDnJBXF/jpwmeT/Jpr5ua7ywnGWaA/mf7an6dtCRjOAzgxHfUgjfLI5SLilsNnekcdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA0PR11MB8301.namprd11.prod.outlook.com (2603:10b6:208:48d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Sat, 24 Oct
 2026 01:42:20 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.017; Sat, 24 Oct 2026
 01:42:20 +0000
Date: Fri, 23 Oct 2026 18:42:10 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Richard Cheng <icheng@nvidia.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] test/cxl-security.sh: test dimm unlock with a
 large serial number
Message-ID: <atwM8smgCGCaeqBC@aschofie-mobl2.lan>
References: <20260702003407.1611731-1-alison.schofield@intel.com>
 <akdXJgMHvXzQDHzl@MWDK4CY14F>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <akdXJgMHvXzQDHzl@MWDK4CY14F>
X-ClientProxiedBy: MW4PR03CA0337.namprd03.prod.outlook.com
 (2603:10b6:303:dc::12) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA0PR11MB8301:EE_
X-MS-Office365-Filtering-Correlation-Id: b41da7fa-fba7-44fe-f1b9-08df31700ad0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|18002099003|22082099003|6133799003|10067099003|56012099006|11063799006|4143699003|261009223027099003|261022075727099003|261021123027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info: ebNEcIym/DeZ4l3wVnK383+sNnmDo1LbPOZqfH04QWld220oXBUgvSO7lZtYyfkQVvRe2ET/aDnB3N6BAS8eEpeADOPmqDj28iKBBq/LKqEOPbRO55YgyTqI6oU5H73waKNTyGcRulIoyFbNo3MTyjdk2kS9IlAxFx4upfnC/sNajRga61/tJ+5jqYNEwlRHfRV0P0FwcD2fLYDL5crzrm4AEHaySTvvuug+CBFykdo2WytNeIM9TYM75rUVaZYfdmv93+AJuxBjjtUubmg9219j/hGoxrIMRYcbqZXj7jVORfdEKZQv/f8nD2Mjso9YS5Abgi5IzRlGJrXsrocIzjiYYFF6jX8dNvkwjgdqct1/jdC6BRDUSFIkS4YfmEvtXNZerqcU1+HDo6Z8hV84ZyGHjzaaoVTchvI11V/a4QMeFv+sE3yYoBbov2UDrWkaBWDvU25e0bZH7JvoBS4oNvLdFkhprKC5fIxUXI/4Gkfhh2jI+T/BzqIZqAvxVe0EWXa0TsMCwhNqrO34mrhY/Z5qlU2vMNfenyNrNFJcralKy3jsJVdorMpXbqIbkY+U66fZE4FMCdeyZbKU17e2BOoDamLwWyp/pJzHLDLDXIBeQ2ZdWKnNY0/cOgNjNuVD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(18002099003)(22082099003)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(261009223027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wXsbEePzsC4oxpIaMjrRhvokNPAdEPw1ZieEJxRXHdDx8wBRxWH9M4sFtm7l?=
 =?us-ascii?Q?yNyQ4Vjr3K4vs06ZCvVZvebiakBITjSp+rvn4+Zh0vqHcfT+2SROyU2/kR1l?=
 =?us-ascii?Q?I96hGkBJ6Q4oPpiKy/WXZ60lF/JQItxa+lkARIMTsX5YXVCEHKjxk9XVG7c2?=
 =?us-ascii?Q?G9Sc7a0hyGz+6egmd5ZaNoa1fQcf/JaMAMnyaX2aBDwyd03QN6DCUUlRhcfg?=
 =?us-ascii?Q?x3DM8kn/P7Z5vkPEgB2KcyTxmGkZMudXvzmq6gNTM2nsvHLtHdT6dOqb7W89?=
 =?us-ascii?Q?/SYNdGJ+iPCHP6GPiorEv7i5enNYg4LwBtKzKy/dhYyTxDlGOvsRGvr3Auj+?=
 =?us-ascii?Q?mHOqkDaXYS2vZHUq5JIUYF7H/y/bjYOFBKUDjIg50fLvP7/ZDLDiYlC5h8zn?=
 =?us-ascii?Q?oLiDHKIjMlp0CR3nJ+CI/u+SFvq+iOYiJXNujUVacg3UKSXEH9JA4qSXKARW?=
 =?us-ascii?Q?2fFBwjQYG5YZ+PgwIlyvMGI8kiRnNKoKGiEdtIT8nEiZ65SksT1cAf1vHOUD?=
 =?us-ascii?Q?rgSJcmXbID7BAcuYtYlix9xuk2EtWRl1791QP+PThsPFs8p4a5KTFUr/Qm/i?=
 =?us-ascii?Q?6SzklKBDovF701TutU5fQXDjKUmsRQoaE+P8UyPR+r1CZVYlDCUivAzU+67p?=
 =?us-ascii?Q?vdLHSHH6xJSMcbcJe38J30lkRcQXJ3W86N75BUlvhWS+cH8HlBkAuWp4XFK8?=
 =?us-ascii?Q?m5vlNphJQcTqZfF1dkP8ERY5cspzEv4wyLh6oH59jX0TAWz0DjKz1mjzk2JR?=
 =?us-ascii?Q?WHGq4Z6E+76dSYj4FpomYqVQgBEsw8pfVemHziuwj9G9kvGhComvT0AooirY?=
 =?us-ascii?Q?UDMtuhig1CU7p3A9lGgZ2R+nL4Ka0++09PWjYM4k8ImtlxoHmbVbZb/6lo4U?=
 =?us-ascii?Q?VEfbkVGkX1clckLks4yLw1VihLM/Hlq12T9Oa2jz4BNwjyeFtNRPc+kiPOB9?=
 =?us-ascii?Q?gDAKtGO9W70M0QN/fMZBtJX5vmJ6X092zaT5tWRFO45CStV68XfSK5BMoA2C?=
 =?us-ascii?Q?QPesmgDlPvEoE/gSJ/FI6vEhe4ooR8E78yRIAQMhqs6n82dS+zJEj5g+n8oI?=
 =?us-ascii?Q?9wgoG5cWOQRjJxlWkz/P8WrWUZ+KJUULtuPXjqzjWl14nx1+1ot2jyTCNVwl?=
 =?us-ascii?Q?LEop+rXM28QqHo10fMQvaUsInS5uy616VeKC+M50dKfuduY+szkgKekBWUtK?=
 =?us-ascii?Q?njPfIGZrLibTx5/g2Y++qoPb1xMBTIoBVv523UI2TJNaajSoqW95EP14RbHs?=
 =?us-ascii?Q?ybiX75GABobIVuv8bnT8aUJehZHvUxloOWUm5RI5DFVfmy/ofDAiqyB1QEBc?=
 =?us-ascii?Q?lFMbajmnU45WiyWmGpV34ZmP77U6lcOvCw/qDrOSChbN/Qtz+6r6z04mX6w4?=
 =?us-ascii?Q?dPWIxBy3Afi9fPUN80xmZXfH5GkC+7Ycc0IyWih2BHgNSL6kkgxkNw+/GEVu?=
 =?us-ascii?Q?+Nr+dFFSOVLu1blj3xujzK8Z1+L22TbKv8naegWHd2zqQ8eH/I4jeZYs5NaZ?=
 =?us-ascii?Q?pSSdO/iBtZtnnI1WuHHun2QkNTtbifOD6OSummpWV1UVNEB2BzdvH+DxBQ71?=
 =?us-ascii?Q?pvNfrmQ7ePFd1n0C2EMB/g7Jr2XBnomtGMGXreZXUEFRuCNSONfSc5K8208D?=
 =?us-ascii?Q?sBxy2IBiI15m3lAm1dLi9qdZA1W31Zj1aQv8bJZXTGaw1IfZ7/DYOaR8TI8V?=
 =?us-ascii?Q?5CnTDZG+2ZMr+EQEsKMz8XJW5d4VAhBgLZeK5LeTA3ixezncEBe9heI+2a9U?=
 =?us-ascii?Q?O7yrWk8/WEjbTN0Tud+m7YlvePbWwiA=3D?=
X-Exchange-RoutingPolicyChecked: Qnq6GuIlNlYaditB3GceN3YVdvjnmhQB4YD9CrfbI+12r0hXKUnWeUzJYLXyBuXKABVKUgy3rzOBnFmD6nxhyewVAm8k64SteKJ0WLak1xlhZM5aSW8l8PVX9BOQjWD/l54O7szcRxwcqrGm2ssRNvWpV/yPlG7rvbL9EXr1q3Q0IYe+6FxuyhF8UCBTN7GnkH8K+UVNm579LGhNKylHBrG0KztxVaVVvx38hj0MDw3zOyXsdEyY04G5ya7cXyFd1A58ums/zC6Y6ACZ2nXebE3mYmoT/0Pif6SOtvElZjW3PFrcYjRbBG04/vtOkf0fMD+hYWiPglBO/BG8WaHHHg==
X-MS-Exchange-CrossTenant-Network-Message-Id: b41da7fa-fba7-44fe-f1b9-08df31700ad0
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2026 01:42:19.9560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BTng8mkd+rdrXx/GrOz/YyZj5SQb5MpU7r0EkANQmhpM//ov2iHP3I+Kg/08vRDAnp8m2X7xpPqKf3D8MrZVpUhQhh9pb+bTCNAWgmPFL6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8301
X-OriginatorOrg: intel.com

On Fri, Jul 03, 2026 at 02:34:36PM +0800, Richard Cheng wrote:
> On Wed, Jul 01, 2026 at 05:34:03PM +0800, Alison Schofield wrote:
> > The existing CXL unlock test exposed the hexadecimal-vs-decimal key
> > description mismatch once cxl_test mock serial numbers were extended
> > to 10 and above. Serials with bit 63 set expose a second formatting
> > problem in that the kernel formats the decimal serial as signed,
> > rendering it as a negative value.
> > 
> > Extend the existing "unlock dimm" test to repeat the unlock against a
> > mock memdev with a full-width serial that has bit 63 set. Refactor the
> > common unlock sequence into an unlock_dimm() helper so the signedness
> > case follows the same test flow as the original key lookup case.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  test/cxl-security | 24 ++++++++++++++++++++++++
> >  test/security.sh  | 16 ++++++++++++++--
> >  2 files changed, 38 insertions(+), 2 deletions(-)
> > 
> > diff --git a/test/cxl-security b/test/cxl-security
> > index 9a28ffd82b0b..39b7e001ce08 100644
> > --- a/test/cxl-security
> > +++ b/test/cxl-security
> > @@ -9,6 +9,30 @@ detect()
> >  	[ -n "$id" ] || err "$LINENO"
> >  }
> >  
> > +# Select the mock memdev whose serial has bit 63 set. Match on the hex
> > +# spelling of 'id' because the value exceeds signed 64-bit shell arithmetic.
> > +# A 16-digit hex value with a leading nibble of 8-f has bit 63 set.
> > +detect_big_serial()
> > +{
> > +	local d i hex
> > +
> > +	dev=""
> > +	for d in $($NDCTL list -b "$CXL_TEST_BUS" -D | jq -r '.[].dev'); do
> > +		i="$($NDCTL list -b "$CXL_TEST_BUS" -D -d "$d" | \
> > +			jq -r '.[0].id')"
> > +		hex="$(printf '%x' "$i" 2>/dev/null)" || continue
> > +		case "${#hex}:${hex:0:1}" in
> > +		16:[89a-fA-F])
> > +			dev="$d"
> > +			id="$i"
> > +			break
> > +			;;
> > +		esac
> > +	done
> > +
> > +	[ -n "$dev" ] || err "$LINENO: no serial with bit 63 set found"
> > +}
> > +
> >  lock_dimm()
> >  {
> >  	$NDCTL disable-dimm "$dev"
> > diff --git a/test/security.sh b/test/security.sh
> > index d3a840c23276..72bb570142ed 100755
> > --- a/test/security.sh
> > +++ b/test/security.sh
> > @@ -144,7 +144,7 @@ test_3_security_setup_and_erase()
> >  	erase_security
> >  }
> > 
> 
> Hi Alison,
> 
> Just a question,
> Does this cover the reboot or load-keys path?
> setup_passphrase() leave the large-serial key resident in the keyring,
> the this only tests lookup of an already-loaded key.

It only tests lookup of the already-loaded key. The failure was in
the kernel's key lookup, not load-keys. Both setup-passphrase and
load-keys install the same key description derived from the blob
filename, so the kernel lookup is identical.

> 
> The failure being addressed occurs after reboot, when the key ring is empty
> and ndctl load-keys reconstructs the key from the persistent blob.
> test_6_load_keys() exercise() that path, but only after detect restores the default device.
> 
> Could this case unlink the large-serial key, run ndctl load-keys, and then
> enable and verify that the device unlocks? That would excercise the
> persistence boundary relevant to the reported failure.

Test 6 already covers load-keys, though not with a large serial
number. Extending this test would cover that combination, but
wouldn't exercise a different kernel lookup path. I'd prefer to
keep this test focused on the kernel fix.

The separate migration issue involves blobs saved under the old
kernel's negative serial number. That requires a kernel upgrade
and is documented in an ndctl issue [1]  and a just submitted
load-keys man page update [2].

-- Alison

[1] https://github.com/pmem/ndctl/issues/299
[2] https://lore.kernel.org/nvdimm/20261024011706.552346-1-alison.schofield@intel.com/ 


> 
> --Richard
>  
> > -test_4_security_unlock()
> > +unlock_dimm()
> >  {
> >  	setup_passphrase
> >  	lock_dimm
> > @@ -158,6 +158,18 @@ test_4_security_unlock()
> >  	remove_passphrase
> >  }
> >  
> > +test_4_security_unlock()
> > +{
> > +	unlock_dimm
> > +
> > +	if [ "$1" = "cxl" ] && check_min_kver "7.3"; then
> > +		detect_big_serial
> > +		unlock_dimm
> > +		# Restore the default device selection for later tests.
> > +		detect
> > +	fi
> > +}
> > +
> >  # This should always be the last nvdimm security test.
> >  # with security frozen, nfit_test must be removed and is no longer usable
> >  test_5_security_freeze()
> > @@ -241,7 +253,7 @@ test_2_security_setup_and_update
> >  echo "Test 3, security setup and erase"
> >  test_3_security_setup_and_erase
> >  echo "Test 4, unlock dimm"
> > -test_4_security_unlock
> > +test_4_security_unlock "$1"
> >  
> >  # Freeze should always be the last nvdimm security test because it locks
> >  # security state and require nfit_test module unload. However, this does
> > 
> > base-commit: 5fcbbee57319e718bf522436ea6595bd0f71296c
> > -- 
> > 2.37.3
> > 
> > 
