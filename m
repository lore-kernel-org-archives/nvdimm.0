Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795203025;
	b=iN2KI4lsoC9EITPUQvW+BkTWY6usA2zRjjm57kV5lOAr+zRmIaP/SUY+Z+AUZlCzpax5
	 EU+vTKakddzE3+idSa6jmjMHnUNx6RtwcE+kHwAQwPtFCz56M7A1phodmIJTEhVKUsPko
	 4P00X6juJGx2rkUKlnok6laIQV8oYDzwGENddKwrnM75MtAsVx8ZdrbuhBU4WEAHWh4BX
	 /XBXmP6z+d/MxPuPRloi3q2eXdEVxM2jOhfxd81xy3iEu7rMG/mzx/Sj4B9I5gOZM7tqg
	 5FoL0o0pT4NJZ5B7gKZ6vN3Jm1kMFlPdcNt9MxTzjBIvm5EZrtRyURSXlI6OLVlCFEA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795203025;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:Content-Type:Content-Disposition:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=88hVIojzLBMrrB+Zpic0Uowc95rIv7m7zexWiw+7JmM=;
	b=jTqR5iKRVlDnUfn4es+crBGUtN/BIqvu6g7tpIYAziUtipvmDWLZuNnHxL97XWTuDrVs
	 3ftjlcA98PLarZyGIWxLbbnHgMdWBDCt7OgJVdijtYk4aRUNEvsWX+Wp8i740Kpkv3hjl
	 3wT+XJOoOgPC2vWKN4lU3v+XOAQRo20q1HEXKUAreBpPNaqE9k9lDsmWNDH8sTRBRgRdY
	 8fmJNSGh2A+o28QfsC8k1hd4n91vy7EOByVUb/t9ymhir3gA2dDGWFY0KcjLgZEpZ6GLj
	 ijzO/EBHRXoNOwr74nKXQDaaF2bSzJ8HOw+ixEcqL6U+k//sr/Omm0gYGA72KcwsZNg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jwnVNWZV;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=jkvuzt8d;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D528606A6F2
	for <nvdimm@lists.linux.dev>; Fri, 20 Nov 2026 19:30:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D528606A6F2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jwnVNWZV;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=jkvuzt8d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795203021; x=1826739021;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=oQ62vYZi3aKUDi9MfdC6/VyNRcjWi4MTxWdkULHQUYg=;
  b=jwnVNWZVlftwegpiGb0zmdiMGO81yqS0yhy9O1TDkUlJJXBurLHH83JZ
   YPe1+RsmGZ+/OBSvuDo9cN/cFVnQ9kzXEQZv32t94luQhDfyeqP4klZY5
   T7zlLRaLxyNnetFlkNYATtYdpE5b5MNJWbtp374mRYfGD96Yh3u79vE59
   Ep4ZmrChorTlM4ok0SlwhaCRfos6smOZBvg1AtHdfHdMYwxPBClY2lWSS
   IBH18R6lR6+ZcBIEoZO1wL49RXKgW2vZIci8PtUzHx1WPz0LKYAwHli+9
   iwTWkZJxHolSCtM2A2CkijFU+4F71KzNb3thrQbp1XbtI3Fw5cao5Rh+P
   g==;
X-CSE-ConnectionGUID: ZLbrnX15T0aoEohJlWTOzg==
X-CSE-MsgGUID: 3Q1kNDlxRyWKoIZ2Ivjyjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="4094751"
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="4094751"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 11:30:20 -0800
X-CSE-ConnectionGUID: VQmQhj4FQ5CbV9lZAdUTtQ==
X-CSE-MsgGUID: jHxnfKh6RYS4VgEnvemY5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="12768984"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 11:30:20 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 20 Nov 2026 11:30:19 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Fri, 20 Nov 2026 11:30:19 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.46) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 20 Nov 2026 11:30:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UutmVygNRSDq9RA8fP3bkKISkAIbVYnLOvk8Foc3b35N9pAKNJlHseWRy9lLdrqzv6ZnviVhPAl72wja2+4+aZDq/NoZq2FPTcv1v5zLfRM0Q+2rrmBZSCdDH2Vx0tQr4jKlFYO3O0noZHNJtV2qSJstb3ld9s7jFFjAIQPAMRpVxGp4bg9QIESKVvvJBxp2lE3SRKJ4rYjldr/ElIqxiOcBuKf5PssdwVGmjmDhEFG9ZDLqJkfSb1JqWbLWs3T4TG8tDe0AFDsvn108+koxeIPxia3HuQMsPqPlXTd/2VcT8pg6uNhmDCkNzmrlRQdRAOjbfVFEAjoJi+KbIzjE7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=88hVIojzLBMrrB+Zpic0Uowc95rIv7m7zexWiw+7JmM=;
 b=wG2W0TUGhNMCbLyk1l5RKjwH3jKqfG6kbjnLq5h+Ukl2u7ff+7gzYu3KKtGw2W901ich2dzX9BAZ3xFrFMO3utcaTMfPWk6ENRr00Qz4nohPbk4O1zRG/uOwhNcBpgBDTAfHdeMHqFRXkLCLo59BEdhDW78D8tpZlvN8bF/3Jz7wYfKrt5GrSUiIWp/fJT6KWQ6jhQ4Pksr6HO1iPwtMBTKFcyKdzyfJUcbzFaIi0Vf46DWSJ6pztwYLt5QwRdKPEI+5+skNnsErdji78U9u9TSFFlVXKRnPOxeMBeCk4PYQC9wlD4L8tuVFLvZiejqNBJbTbpTkSUcMnB9cyhd5UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88hVIojzLBMrrB+Zpic0Uowc95rIv7m7zexWiw+7JmM=;
 b=jkvuzt8dXC+tUziViftCj/I3AbI6EMtavi0GFDKBFPJANhqwonC2XuEkasMgM78Ky1a83al0O7X4W+TuOTGZrBTLOrddK8WfMaluMIoPxqLi+UkVF8DgDetLj8rLMfjm8vVQlS2HzK/DbHZ+WaAnYXqt0weL38K3dlKBLHXuL2E=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SAWPR11MB9921.namprd11.prod.outlook.com (2603:10b6:806:54a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 19:30:15 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0615.013; Fri, 20 Nov 2026
 19:30:15 +0000
Date: Fri, 20 Nov 2026 11:30:10 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <dave.jiang@intel.com>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <vishal.l.verma@intel.com>
Subject: [GIT PULL] NVDIMM Fixes for 7.4-rc4
Message-ID: <awCfwssDI7SG4Bpc@aschofie-mobl2.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: MW4PR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:303:b7::24) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SAWPR11MB9921:EE_
X-MS-Office365-Filtering-Correlation-Id: f44cf85c-56fd-404b-558b-08df473cb37d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|18002099003|261009223027099003|261021121427099003|261021123027099003|261022105027099003|261026140227099003|261028144727099003|56012099006|10067099003|261102123227099003|11063799006;
X-Microsoft-Antispam-Message-Info: OVKR6fVn1h0JRqBrETeZ/AQzaF651mZLLlKII/iqbMm6XgslpmoEqAG6JY3Wi5iAftCdjGOvet38T3SkM6p8vESmIIXQ2QLTD4GZneM4KIph+i0o8i/dFTB5KLfVaGuESl2w0X96Asxz6ZGoCc4Hr/wfNtkdo5mT7kDzbU3DAv+DC9Mly8uQCC+y0TKpm7QGoFR04ktYxzQrX7+8Z1354xsAX6J/qTtCKp24ZMAgX3NLQbreQZZU9afreHNcCIu93+cd0UbX58GfHlBLnJ80bVSJa6n+Q0OY5QyQBDqb82l7QL3w6cXbqzBiu3x8MuKUbSXB4USFQBsD63npi92gE7xtl3Oh84UrIM39nnDUS/qfNmm9UiekJFX2A5mWhm7Ll0wpiTRYo2teqKY0H2KNuCZW3254dI2zujVlhGByDeZJTYsJ82HQUX02witV6lMUxPw+jiu5VdNncNrgDvOK5g7mJ4IoANz+xhOgFif6JR/nHsKN6F9qFyQZEOIz2gmP+s4cfmKNETdo0eKPe4dsEXqYbqJ8zjxQrVDON1G2Od4fC0ehQXieeN9m0eYm8H7QVC0bhp/DXo3M+6MlQfai+RwUeif+X2o2IeZAtX6Af3D4Lcdq3eM9TcO1YcH/w3tqul1/+Xp4ibYkU6RdljFqDWJOxMs8F9oKL7U9P/gvoH4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(18002099003)(261009223027099003)(261021121427099003)(261021123027099003)(261022105027099003)(261026140227099003)(261028144727099003)(56012099006)(10067099003)(261102123227099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zhl2Nut793oo7+8EvOvbEYikxIghHyTqreaqG2WqeCb4SwS2K+EeAYO+EK+c?=
 =?us-ascii?Q?m/UfeU5MVTbjIqxS7cFtGVPtd+XyHH7vd0xHfxVWvUYa5zfR/HO4kgm5TSzc?=
 =?us-ascii?Q?7/aq49B16CL6X1jTjA+Xg1iaLiIgp49TUd3XSwYm8mTR5UPwkCIEhXWDfCUE?=
 =?us-ascii?Q?NEJWpcrokbHVmFicZ0WlayHbSLyUn3u0zt9+BCSkFo1HZNSZoONYfpeqgBb1?=
 =?us-ascii?Q?AlFvqbGUee3slo7ogMnfgnHCcAuBUA1SaJDwbQDtJiMs1UcbLkseiKGvKPAM?=
 =?us-ascii?Q?mOmMYTaDbRc/shNq/UwmYjgBLTnfKfcB2CZs+9yG+34hA6ZkZoHonTehUX8k?=
 =?us-ascii?Q?E57/C/9UpZNtZGSl/P+ri1fKHMHvuXh3qzaEUZSsPlePydNQRKFOtz6gUB8r?=
 =?us-ascii?Q?U14XjgO2v+pkVt/wSWfWZaoNDKwDiQIKEXTRH5/hjs9qEWdZ9MflxT/YWyOu?=
 =?us-ascii?Q?6J6nnw7qHdDZoBkRj0yiwkBbpQv/6Dh4ncWS4fxeKiy4hV1xzdedrhJTFL6b?=
 =?us-ascii?Q?C0AKVNE/tAih0K3IqbsGozTIbcQh59K/18WzACXzilzX7THbKShTew337aXn?=
 =?us-ascii?Q?PyrlJmBfkKp1y9XTTcFuRJvaFXmuOzZgZJXH72QypC1h99y6hUBtgxn4BX9M?=
 =?us-ascii?Q?BymeE5V7wom66Ksmu6UbB+MtSZST9D8DFwfXLOqWS3IjKuMQyom1+j+v9nN5?=
 =?us-ascii?Q?z06Lx+jFpOoSxcCmjUWz3qbJ8eBCoeOnAX+6UEtbXNqRLgkC1hvMlIi4mA4r?=
 =?us-ascii?Q?8smiQhgzzzEUouXYp/RjXUT+2+eBzoQ1T/5dNHHU0RlzwQiA8Go5tP/ojE1H?=
 =?us-ascii?Q?3Khdv3I4W6YaJNgbSE9WaSiva6Qz/xuhIaBNvfOVmNpO3qdEF9g3RV8uTDeq?=
 =?us-ascii?Q?eAtZ1F6O6NRlCjG8/PFoOANgs7XGqoz/khvnEQD71SbobWoK+VjEXv2VVRFU?=
 =?us-ascii?Q?0516ApM4lAZMUJy/iI5X0nsIhN5u4MG1O/HkHBffDYVtV9Rq17dqChYoT1sx?=
 =?us-ascii?Q?pjBJLh2vMBEVHl2dyoOC/c7G5wiHHs3EponO/KVph251DD/fdwDvEkBHv01D?=
 =?us-ascii?Q?9uxKKt0D73uAzgfK1SthJf/TNcaApBm0mqsY3Di2Z5z4jZrLulf/HoBJk5lf?=
 =?us-ascii?Q?ZoMY3m8isOhAlzlGTOsxqUthpUKcYMr58Wn2fMIVyoaZjGwZIfCrzlCqqs9K?=
 =?us-ascii?Q?N2/XyooN95gL/gptNDv9OUSlXKL1eQf4sNeC42knYlcTU7JnOi6/d9p/YOIi?=
 =?us-ascii?Q?5xNC7wkGrrIKm+gN66MWxDSxqgpgZxWexIkSFSNz1/PWEYfSUqaYvFzpHmFq?=
 =?us-ascii?Q?5rD/s4AYR2moL1y6MOUTHc923DjLQJdtqSkrsqlNAMnLvaV/6QkWG/KPyhqu?=
 =?us-ascii?Q?WkMMU9/DXXHeGjuYEz74f8jlQSX3w2Y9VVQtmhPOyttQODbE+F/cbbQVMxwJ?=
 =?us-ascii?Q?Y8RNgAQ6OBSb0YuOewUUhZHxPixXVtlOXR3beYHoExmOGSFGN3F6laLEjped?=
 =?us-ascii?Q?9Eyn4F0JtECI4spSEkpqbbxRnCflvZAMJpNxTn5cwTz5mHp0RRO6kOXMPLyb?=
 =?us-ascii?Q?Nl+v5guv6a3rNzMRuhjL1Wtuw3a5TEDx1EBhaimpGTdVRchv4pIWk10FhLLH?=
 =?us-ascii?Q?T1OEP4Dmcf+G/FOVsxxtfXo7oTrH6L/i4IsiAZu/G9wV/oqi89aOh/YRA42E?=
 =?us-ascii?Q?FVuoX1wC0YD1E8DGag63hqvVdSU6yFwQyDte7xiUDbusdKvV87gaM3f0jAyP?=
 =?us-ascii?Q?z1iOl1vqE3Y8l9Cv8/O6OqtdieW8FGc=3D?=
X-Exchange-RoutingPolicyChecked: oZJrFBbK7CxeTkzwSOkwnArc931+fslOXdaGmHPZQsBXAY+OZ7tneSs+MC4BVMOcEhC2T9id8LoTxHKChctgaFEVVQWTX0LJJpBjdFOZYhf3lhz63iJ0pj9UkIMQDJMvAwOkoe2OsOLOCLEFl7sPb79pOBHIP7NAY0xaJb56VkLV+C6iptgrvPLj4eAUNmcYQc2JIw31xd2ZxkFHzKDIXiy0M+qahwMmcvmXdzHOh8Oanr8GXHqJmo+v5BvWW5WXvDJmOr7AhRqAWV6dA8QfyG2J9uUFDQPrC/GcEQY0N3oNvpDAN/NiLbEz5OKLAPhdCVzQFDslYiJET3WGGza18Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: f44cf85c-56fd-404b-558b-08df473cb37d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 19:30:15.3036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WxBlR1ymomQWYfdJv3xHSgcDabgqcY5Kk4A+8wRqQscUCeMtjCmv822aOFRMo4P4pGMXSMZUQI9VTtSDeFJv9SoSOgvrjSpjr/oN1f/OjDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR11MB9921
X-OriginatorOrg: intel.com

Hi Linus,

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fixes-7.4-rc4

...to receive a single nvdimm fix that has appeared in -next for 3 days.

Thank-you,
Alison

---

The following changes since commit aebb7274476403040d582c61478df8f4a7bf9cd3:

  Linux 7.4-rc3 (2026-11-15 14:30:11 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fixes-7.4-rc4

for you to fetch changes up to 5a277aa7eb4d4f1f05534d6c3dcb1a9fa4f6b8f2:

  nvdimm/namespace: Nest mapping locks under the bus lock (2026-11-17 16:01:39 -0800)

----------------------------------------------------------------
libnvdimm fix for v7.4-rc4

nvdimm/namespace: Nest mapping locks under the bus lock

----------------------------------------------------------------
Dave Jiang (1):
      nvdimm/namespace: Nest mapping locks under the bus lock

 drivers/nvdimm/namespace_devs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)
