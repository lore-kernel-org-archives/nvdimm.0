Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA671D6DB5
	for <nvdimm@lists.linux.dev>; Mon, 29 Jun 2026 19:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782762440; cv=fail; b=XlZvShjhwMf42S+S3n34HzxzEZfwJChCFZDJRI4Oga/6q1eR+oOoFhNT0qgBCSwoekkwjumHypn3byEkDDyas+iNTIq4gkEKEAynsveI2nGwzWu156YA5gJWvramr4uLoyLSGD1Mc6AGF08tWhiibyZEfn1ymfkOZDNa8EKwHiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782762440; c=relaxed/simple;
	bh=Ne1KVgJit0CxyZtPLc4ZQKYApsNErqOsvukhmok/YCE=;
	h=Date:From:To:Subject:Message-ID:Content-Type:Content-Disposition:
	 MIME-Version; b=Je2GxbScRUDj2bMXIuf4+In9R0QJWZ4b40uNCRjnRUuiQRdgxRRQFNGV1drS2m9niKZoMYZGnbx3NMWLdF9UupG+eDpjzuemVMI7O1O4OtrLaiDkr3rg+jIA4FKV+hyTNtyRQSj62MqBsi/SVE7fAM51vSJKivkMbZbeDt6CmPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QgeUEkI0; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QgeUEkI0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782762439; x=1814298439;
  h=date:from:to:subject:message-id:mime-version;
  bh=Ne1KVgJit0CxyZtPLc4ZQKYApsNErqOsvukhmok/YCE=;
  b=QgeUEkI0I6ErrHTpamX/nN3bthNN/kxjoC15izL6w69WVJvIUKpoqhUD
   QW7hnK0uggJI65wLrTOFD5hm8Q8OfCvvgqkQlEqEPUJPpv2HK9tGrBgLb
   TN0tGzEM8qP7HnB9aI8w+hk2NJrq6r7TTFluH0uUW2JlUJGpVyPqYP88Y
   uI9wPDRx41H6dlF+mdJQNknuYuEiNado2PkzI/fs5t7SiYzKnIGPWoZTZ
   Nm0gY3M+iXeMvcf5v8MNiGA9YoXujqbPWXkyT+j0M0HfHoW1/XvL6w8K8
   R9B9BmhKUKZYOL+1TfVrtnvUwkvhSsF6CWRJanw73mf33NW22gfXxHHuo
   Q==;
X-CSE-ConnectionGUID: SAvhX0+cTQCanImkQEG+Og==
X-CSE-MsgGUID: meB5KaG7Shq0S00QKWfc9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="94965796"
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="94965796"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 12:47:18 -0700
X-CSE-ConnectionGUID: FJ75jRh9T76hIjq+VcPvog==
X-CSE-MsgGUID: POf8l016RxuP/uPU0mAkYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="255646305"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 12:47:19 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 29 Jun 2026 12:47:17 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 29 Jun 2026 12:47:17 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.68) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 29 Jun 2026 12:47:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rc4NTJNLPMdpidi3GApwpcXQQGcHuMuwam3PFUBvX6Z4R6rRN+Ai6egJel9NkSgB0ACGO/hfubjZkIRMdM+E2Z7CTUDveYsCG+hbWduCD1Cn7m6mg+X2s783mc7VZglajJur7G/uAYEd00mCHPR8E1eWH1z7jca1x6sfGJbMJGZvn+TRfH/MNLX6pdtUzevioMYzmCxQykk6mOz8lgLXygtoikv6DdPCrhTDf3dXs6BTgcPKe8N71QoFEzAZNHy+RlfLDA07etey9FL/bXYdFAmZ05mLLUqGTiDKa20RK591/wLMoZGllHPjiZBmcJNgzoXFh9aB5qPYo1FGlQK1Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pv5NAuE8sb1rhmhtqaeewrOEP4Wmfwh2fKFTnMsCtn4=;
 b=L9besyWX6scGbmz0sBH0nmkrlWD9zNWdzIGxWgRWerULtV0u5X69ak7GouJibDBhsQv7NEZsf4CVHI+/4Q4NyKPJORKuAjR24gxqS+XCOjMzoT+pl00pgLq2zvVdVrbz9D/gcarAU2DMx4aIg0JaoDJKs1YnWHYZALAnWyukh6jhtwwx62VuDBqKqwbNzffDPwgK6XmKYbKFsFkHapLT2cxQEhPgbWaSwljMa1g05jL8XWvJ4idJu0rJWqdbWzhJogkdNCcKxekW7DHY/Ifvkib3vpdebeGlQCYw5aTKy2hjofJZWz7ewqieWgCgPs2KoKRoMfBjz5+dXpbNigmfAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH7PR11MB7076.namprd11.prod.outlook.com (2603:10b6:510:20f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.18; Mon, 29 Jun
 2026 19:47:13 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 19:47:13 +0000
Date: Mon, 29 Jun 2026 12:47:10 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: [ANNOUNCE] ndctl v85
Message-ID: <akLLvn_yqxyr1mRq@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: BY3PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:a03:254::7) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH7PR11MB7076:EE_
X-MS-Office365-Filtering-Correlation-Id: 762efbc1-cedc-44c5-9032-08ded6173755
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: 4NpV6oGDlsFYFlaC2etpR9cailqi0b9GmjjhY63t3GrTgSHmOnYecF1eueQ4jaHkAQj2jInb5JDPXCV4l3TD0iFYFP4/ajU4fZfwLOB8hX2tb04ovJGbtxOfPTeS3GKjTni4h/xm8S/2OdIwLu0hPjoXlYte6kCWCuJQ4xocYAAuRbwVtjQdEmAP8aHKcgeqKoX5YbILlBS73Fj8kIbvS83BF3R1Kp/ktXPKUbYkOIFivUH+AXC6Py8LP9osIJRiskFe6J+00scOm9FvYIkwiVAexTnhw06kc90927xI1FKGPViUljfHO8F7KzzzlrHb1uKUa8MLjzyqhan7eBEGUdqESOvqvXXTn8m+I3WyvbYieO66o5dOFvlPR/WS9ZiJe56NgGFTsGjECzgjEf9MUow62LeFoowiH0MDOaANsaIl5DEKhzZi9NRMSHTvAkKmSgMvFQxjOclrM75HvUnPKQUEHDVut9ayjs3ffvgTwZ+hy6mGGSIUeya68ivKJbU4P/HTAWqee5wfdVgoOsHmEHoi2ma9C1X7B/yIvbDklnTNlD2fSaD10VmEXeYcaCxCblm6WEB3INtJsmhkYNpdPaKA0oj/DyrCLCNbFk9dIW3YJueh5LlDFAuuytnqqFwHN9WqCeoq837QKrVla27/+jQmfvVMgTCLaoIf/ZHVnXM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m7zMQGJ9RfAj62uNR+63I+rCnRipEQPmsuhtXCFoUNt1Rv3B+Xt8I7B8+kZ0?=
 =?us-ascii?Q?w/Z6WeOnOo/eOtbZqgFLRF8f966rRhOJSOn6QgYgKTTc7kSRV71jzrigHHcC?=
 =?us-ascii?Q?2RN2K2I6glUw0oMmpRDlwMcS1vClx/u4xQr5PlsdyECWAg9m0VekvczEsx2D?=
 =?us-ascii?Q?jrl4rsZmjkBfqFmtWp6gMf2zksHs6dIHCkJmO6CA01brcFVZtVMRreT9SdOg?=
 =?us-ascii?Q?y9DFH+kR6QXhx7ocblIbUOEXRm9DuIgnBxLV7e477oIFt5Bdldjo/+Fl78Ko?=
 =?us-ascii?Q?Y+h89JgcIdG4bNJIMjVWmso2VZGLMDT0GzFQ686AyxTJcXnSlmf8PvAfFbAu?=
 =?us-ascii?Q?m3M6++U+GP+rUCsiB6TnfX4/jx6+4WkJ2pRlLjJbtN3bNPp5geBpH+taN466?=
 =?us-ascii?Q?KwVAE4QHxSIyRzuC0evCDGwA1/qF+rNfqt4GgoD8Za1iGk4LOHsVjieFsBQW?=
 =?us-ascii?Q?gm5oyPCs16zlBfC2sdJ2XcBOt6hrNVJZ97OTV5HQC9Zyvr6QoJNGmFAE+zzR?=
 =?us-ascii?Q?/pL0OtCLweIhLzFOOyQSmqt0/5w97Ej8uW6bu0n6KNQlmY2VWrGWLG8NGV4m?=
 =?us-ascii?Q?4NY7ziO6lqFUsEB/yfvfEC8iuYod2m/7JV7CM5eBfhAQOIsSMz1ssTjpRpEM?=
 =?us-ascii?Q?kXGlmVgv33Bz/mWMV7pcbBbF4OWOC+yvCoJurBIhvH3QJRb7VjNeaPgWMG7z?=
 =?us-ascii?Q?z+2oGS7tOmbVbZGwFn6MVh7yiKLfguCcoQ+v54tX1X1irrgEl3iVqw2EeGaX?=
 =?us-ascii?Q?4yxPMrdIMnP4jIKjQb8XkUZkNANPLlLB0f9zZiczxXIZ/SejJvCfhVyGk3wH?=
 =?us-ascii?Q?DtwCeo5YTp+WxbEnm+XkKR2/M3iSeK6Ayk1f7QsP3O74xRMqLY3Awj/V0vAz?=
 =?us-ascii?Q?x05n4waZzbYWdjJ1j7466IVwIpQopkk79ct3/O2OBaZLAZxKSRik1OxV9lEG?=
 =?us-ascii?Q?8mQsqtuQfowEJWc/hZa5TVeGoz5yJxoztu91LeKIezMNEE/FmhKI0Pw1ER5F?=
 =?us-ascii?Q?EIf0UkInurl3dE5SnVqHS5amWpQRNONsSKTG7e5VJweDkDo/tVyVCvpGTtZE?=
 =?us-ascii?Q?Z0vmFZwA8V8rS6bfJEramdt9XUypQ7oaJ+n838VsAe7n5nm6koZwAjNdytlJ?=
 =?us-ascii?Q?wuRHdTzhBERDfVwy4wroblhTxHTY3Y3+HDfKgWonNkD18zkNaY2rhlAy/EaZ?=
 =?us-ascii?Q?CBxtswZBdFBSgyeFxaKemthc0eW+E/olbPjilKdz8EmdC0nir0XnPP1J3OUa?=
 =?us-ascii?Q?CeV4Os0R+u/tugm3mvjnjyquNf4WmjgWYaV/Wh6Nahgo9L2yoAiueHg5bksA?=
 =?us-ascii?Q?DKWbpLkGX83a1VpO/57QT1791JPdBMLn5JGWi+UW+DJR4x9bT+qCwqYBVqf3?=
 =?us-ascii?Q?VVsaZPLfx1suTYizv5YAGDxCESxgBFFMtKuTYOp77GM5SAl3G+YQ5cnkQ/2R?=
 =?us-ascii?Q?pn0a7ev2DzR3yLgfext5Fe9JvtOK7xlYG9bXcIktcbFCX5r0eowgVnV+6goG?=
 =?us-ascii?Q?ASmVw1eXP+A1dnUPU5SKbff7rHx3m45GiUfzFKMKskpnvpTDKE5BAzq0RRNG?=
 =?us-ascii?Q?XAsDC9PSOQvYlmVECbQIqE0LgDUD06h/LKpqinJH4JRcNYEggtSnHfeXjKlG?=
 =?us-ascii?Q?xk8rCqBopHw6o+r8FpYzt7t5uhdjwehuQX4wh9SoiKIt5dvxozZYHdbMVzwF?=
 =?us-ascii?Q?ML3rsPlaGxjxzsnB/BUV/JbDVgIGzIs36M+iUpGE2LmjpjBUKSPJ2IJA8PHV?=
 =?us-ascii?Q?vqzfvflhJSb5QgJCcUY4wucHeoBJdtw=3D?=
X-Exchange-RoutingPolicyChecked: byGfCzIzNlvu0JaTvJXS6A5c7zK0MQqGUmkvmEzQ8mibLZcZZFUbsTZaOxOJ9rwLAVhh+JWVSVArzWcEIqYRwakxOefXzs2SRlCfpp9dcta6os5vIeyD0e/hsRlrN5kPyF13/GjQ8Xl4/3WfwjVT6FSPVenl2Sgjy0VGBKyPtrM3XdMJGmsgJTWP6jfDYlYT/ntIQOj5kbTkhXzzJlIH4yDP1y1QO/iC+zbIMQPuAlo9mABNF9Nl7ZVpADh/o/P2xrjiNipV2NB9I99ZxNpD/9Qbs+mxS8QiqSditMD301cLjhxxVUbgVbJtuYBvS4pmQPIK9fgUJcCJp2paQ605Mg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 762efbc1-cedc-44c5-9032-08ded6173755
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 19:47:13.6250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X6Bs+F4Xzz3XUJi81oUyOLE3UGS8poJgBMLyXnn7vmVse+v/wGxvMIry5Q/ijTNHN1mylosGfpHMsvIgOv3UmUZZalFecQSVnboQ0VWKfno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7076
X-OriginatorOrg: intel.com

A new NDCTL release is available:
    https://github.com/pmem/ndctl/releases/tag/v85

This release adds userspace support for new features introduced in
the 7.1 kernel. Highlights include support for the Fabric-Attached
Memory File System (FAMFS) in daxctl, a new FAMFS unit test, a new
Soft Reserved range handling test (cxl-dax-hmem.sh), and test access
to the cxl_test module's new region replay capability.

Users will also see region locked status in cxl-list, more robust
handling of cxl-destroy-region requests, and additional updates that
improve overall quality and unit test coverage.

Shortlog:

Alison Schofield (11):
    test/cxl-topology.sh: verify dax device creation for auto region
    test/cxl-destroy-region.sh: prevent false pass when no decoder found
    cxl/region: prevent partial teardown on out-of-order destroy-region
    test/cxl-destroy-region.sh: test out-of-order destroy-region handling
    test/mmap.c: check mmap() result against MAP_FAILED
    test/mmap: move detailed tracing behind -v option
    test/mmap.sh: reduce fallocate size from 1GiB to 256MiB
    test/common: add helpers for CXL region replay testing
    test/cxl-region-replay.sh: add test of region replay workflow
    cxl/list: apply bus and port filters to anonymous memdevs
    test/cxl-sanitize: avoid sanitize submit/wait race

Chen Pei (2):
    ndctl/test: make fwctl dependency conditional in meson tests
    ndctl: add key_type parameter to ndctl_dimm_remove_key stub

Dan Williams (1):
    test/cxl-dax-hmem.sh: validate dax_hmem vs CXL collisions

John Groves (2):
    daxctl: Add support for famfs mode
    test/daxctl-famfs.sh: Add nfit_test famfs mode-transition test

Li Ming (1):
    cxl/list: show region locked status to user
