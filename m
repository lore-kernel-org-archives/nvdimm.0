Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA70419539F
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584723; cv=fail; b=Kxy3/bbOzV3heBwx1/ETmCsMgHTQqxOYnFZu4po7f8DuwuliJl95TPjS+4P8w8nubkmY36vhgJQcyaWQBDdHc9okJaphntAZIHQjr3tkaNY720EiNmW/TNyedPaDL5gonX1RCf43aZMXFwReYTOF8nHz4r/RfRa7RjEPO6bdOAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584723; c=relaxed/simple;
	bh=V3fWJr3Em3iZQf2yytjyz4d5nf/SXSyrd7uDfepAKP4=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=Y9i/5esGhXQMkUUyNYV/dXZYs/CE6mz1pmCJeLPA0EP06/NpVTFwydXDZ84izZKvo83T8X18TjupkDMH04dyURUEa2DN8ibke5v69rSoFp1dxQtDm2jrYvgKQtWhn4gsx7Al2eQNcuLEMHzLUFVragAZpgTRUjJEzIlpnGA6AjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MqS2Zc9T; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MqS2Zc9T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584721; x=1776120721;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=V3fWJr3Em3iZQf2yytjyz4d5nf/SXSyrd7uDfepAKP4=;
  b=MqS2Zc9Tq3OuGCNV7/PK21yuqjeIi3f2lYIhV0aKdt3+UewZ+7Wvl9w8
   7us+RAsqFZome5OPUEhw6lupFbyczkNrQTR+TqeLyvf+ARMx5WlQ8ZNxj
   x1pT3by9R1q128e+5yE0UkhUWtgT/QktsoEQj4SJQ+74tAznWmfwS0ZKA
   yUp6ZMH/YF2rlUTiBng2hgdYj+M70pZ3KKqaKnoodtIwqRHellH6OJVGm
   cHYcT+cWS2S5Pm3n5c/+x/tpzE/ce8kgof1OXISiNNMbBffo1QVKndekx
   34rv4YcyfLbhYF8PW1D1ChxPV6joPw/4bmP+b/q9gTh3Kw0S9wtHSBLLO
   A==;
X-CSE-ConnectionGUID: uX5eDUv8QreMr0MOHl3zeg==
X-CSE-MsgGUID: IiZHN0BpSbm3e5ahDMRxXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280891"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280891"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:00 -0700
X-CSE-ConnectionGUID: xVHgEbcBRbWcSny/L7WzzA==
X-CSE-MsgGUID: 64Ik891lQGq1Y9+T1Ul4BA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657430"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:51:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:51:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:51:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:51:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DWEJtkC5NvYYRQS+rchlsHU3+eIR4vYAeMxNmlXurb5oBWbf41FW/liNyXdFNLVJq1RMtfH2fQKeoLg/yKDan7eNO+gll7MAPbNlmQGkDgllHh/yZsUXV7k22rUqPq7zPyeFaWV8e9AOFnDH5yEtbWuqjSN86JWlJzfURt2zn6py6FNuUnqzyP8ZMgsRAUnzWuKxR+C4QLcmyOf8jE/Gidd3g01cMyul6/nSoobQTgle/e8/NjsyWwcEHHrHfM+1AM9UdDS/pN5CYyXLBcviCOO+2HIWhi9zLNLD/XOmeXqrMKTASnCeBv+ls/VQioDNjeOFv40ZEMdRjqbQrmSZnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xKw2/RAcdXZWQN02V1z9yzRy7CXyZCgrhub8YtJUy/o=;
 b=org9c99KH4OuPNz/QYzuwrnrHVWv62+veCeA12J+cOPoOTm8iQ+z6i84ekUjL2yclaYhaBT1Xv/1YFwE4vfayBuhbL6eYNl8t3XrOq6s3PuSaZTo6sBW38Btyd/F6Jw7zWnd0hBBFEGEFYIO5BLqbuG2B4xGl4eexm/54IR08jslhmBgtipl5Xs7aff6NkbziIawV38V17TAX1fJJn7hxvo0L3mK12WRLHa4hNwZDmFEWTdh3N9oWiUlx0naQpGeMESx/PivPt0X2Wb/c0hD2Rp7GvPIVK2PbeZO/m0FNnWeYsu7yS9pR0JeICwlByXyVfIEAcqze0lkL8oV+0gh4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.28; Sun, 13 Apr
 2025 22:51:47 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:51:47 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:11 -0500
Subject: [PATCH v9 03/19] cxl/cdat: Gather DSMAS data for DCD partitions
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-3-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=4875;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=V3fWJr3Em3iZQf2yytjyz4d5nf/SXSyrd7uDfepAKP4=;
 b=AyU5Sbgydhbm2qFavE2D0NLOq67cFT0qHgTrjJZn5EyonDuA4LqaYh1vyvPtk899fCRRyPfSq
 VJ4h4uy1+yoCH/MA3Qz5CTwwJOlkY4s5S2wdbdVLxqhprOY0ofY97Z7
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW4PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:303:b9::22) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|DM4PR11MB6042:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b275f08-8b81-4bd9-6ea2-08dd7addc517
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Zmk5ZmRMdytvbVdXSlRSWlArRzdDUDlZb0o3RFg4bVlLYm5oR3RRQ05oSEcx?=
 =?utf-8?B?eCtoS1N0Q0NPZ1N6UzBTZXQwZTVNWjhVVUkzbW9GYm8wVzUzSE1qTFUrOXdN?=
 =?utf-8?B?cHNJZUJVa2cwdy9qVjVHSTE2MjJwcDFyRDFuVGl4MTl4V3B0S1pvVG9zMEsy?=
 =?utf-8?B?OXc5aGdpa2wxb3NoY2JSdFdvdjJ6RGFWdEcyUG5lbDVHUFR2QnhBdjZISVd4?=
 =?utf-8?B?WFBaUkVkVWh6STBWa3RiWXRPMlVmdmhLa3ArQXJEcGJlbDR3K1lTVTA2TzJS?=
 =?utf-8?B?eGFQTk1xWWNQdm40eWVzQmhaTUFNd21nV3BMVnVYUUhLMjJtZnJ0YTRKTzRG?=
 =?utf-8?B?MGFHTVNHTkNtZUhsdDEyeU1QRUxpTTJWL0YzSVI4bXZIL2t0ZVdwVVF1UjVs?=
 =?utf-8?B?K1VzSVRYNk14cm1WUCtvV2NxZUpxN0xOeEJ5VTdHME14TUpZT01yL0JhdnE4?=
 =?utf-8?B?Q0VLZjNTbCt6SjBLU0FaQ2hVY0ZWaDZxU2VsdTZzRmk0ZGhNbDRZNXhoOXpD?=
 =?utf-8?B?VjJ3ZEF4djY1SW1ENzU4MElGV0p3cFBJbE43M3RLc1FIZ09vU0poVEtqN3lE?=
 =?utf-8?B?OVhSVWREdmJsTDdwWHh6K3pOYWZVMDAwOHNJdnRSMTZjSUZHcldUUnp6R3dh?=
 =?utf-8?B?a2p5Vmd0MHkxMWk2WGJPUXlrSFFyWjZHby9DMnhoQ1lscTBYYWpOaHB4THdF?=
 =?utf-8?B?SjZvT3hDRmxLQTYrMnlDRTV6Nit2S3pHQmF5cDN4QUt1ajJ2T3N3cWtaSHdS?=
 =?utf-8?B?RWNrMzYyY0ZsTGdURE5ZTHUzR20ybkxDdUl3WnJpVFpiMDF3M25yL1c2eDdJ?=
 =?utf-8?B?SW9RendVdnRIaUNNNWk4dTAxaEkrZjlnbmlkT1V1WWYzSkZ5VzMrUWNIZ0s1?=
 =?utf-8?B?WGNaWFd5RWgxQ0RCNEZCL0FPdW5HeWhXYUV0dGNuaXpIR2ZaVlJqUzhoSXp0?=
 =?utf-8?B?MEZIc1pxYStVblBmWlY2aklBVFYyaVo5VDdDODNUK09QTTdZMENnUXl1cVU1?=
 =?utf-8?B?Z2xERHlmMlZkbStiSUg1bWczRi9rSHF3eGRycWE1RTN0d0RYUjZNYlg1NDhX?=
 =?utf-8?B?ZWVnYmxia0tDT3E5c0k0L1BlUkhpdHNHVUJFNG0vL2dnemgva2IwUEpOR1hB?=
 =?utf-8?B?M0t3N3FSNmxITGxidXFEMUVTcHVsaExNTEhOdzg5TEpRaUNrVy9RSjk0Qll3?=
 =?utf-8?B?Z3JBV25KMllGOGJJS3dtWmZVbGhsYnJMbHNBaUxJbElLdGFMV2QwR2JaYXB1?=
 =?utf-8?B?S3hla0pIeTFIeXZpcmtBL01wWE84WW9UQXJCV2w4SEt3SWRMMHZVWlNKSXhv?=
 =?utf-8?B?TUxBSy9Pd25aM3FJajlHUGZCWm5DN3c2UURpUXZMSWtydFl3MG5WQVpKZ2hq?=
 =?utf-8?B?RDVBM3FEZzI4R1FhOVdIS2c1Z2JtakRQUDVtNGFQQ2RYNzBaRUV3YXlPR3lZ?=
 =?utf-8?B?SWpzRmVoUkxZSXR2OTRockJPTjZUbEczMHNWdXB3cDhuOEgrWVZiWGQxSzQ5?=
 =?utf-8?B?UEhCRFRnQjc5cEgxZTQ4bWR6UmoyY2ZtL3FrUlI5aUhOd29jamFEVzRHbVBw?=
 =?utf-8?B?azNZWUdpUHR6bzByOWVhZUFkWHp2c1hndkE1N0xoWFF0ajV4TlpOSHM2Syt5?=
 =?utf-8?B?NWl2cThYSGFoOU5pTG9pcGxUL0FudXJLcUhjKzNqeEthZC8yNS9GaFFsM3FT?=
 =?utf-8?B?RlBEalJOd0h4cTRVYUdpbGY3am1LdEltZzNhQzhUR3cxQXo3VU41cS9BVWtw?=
 =?utf-8?B?Qnk4NEpBS0dHNzdpQkxRV3AycEFQTGJ3U0sreFI5OXJmRHN0Vi9JUjZoc1BZ?=
 =?utf-8?B?L0p4TVlPeEdKcTZGUzBxSTF3ZFJDTHdVeGpGUHB5TCszVHdLaFFoWXlnMW9l?=
 =?utf-8?B?VUR2Ui9IMDI4L1FDQ21HQnJTaCtQdVkvOGhpWWNpVHI5VWc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlhLbU9xaTVERUJ3UkRtWm9xUlpqZ2tSYkNEblZGWUtEODZvWEJkVisvcVo4?=
 =?utf-8?B?Y2k1WU5nWXR5TlB0d21aM1loTU5RMUZoNTQ1U0JBNEtmR0dMQlZiN01SaThH?=
 =?utf-8?B?czg0SnI4bFBiMFVWdlV6ZWVweUN0VWN5MVlyampCYU9aQ1VBRVErZ1BzSDlL?=
 =?utf-8?B?Y1pRKzNwYVpSUjJzSUYxSXkrdnk5MzdYeDJEUnZCc2taaWtNc3prd3IyQ2R1?=
 =?utf-8?B?cXhaTWI2NnljM0JDVld6L0hhZ0NJN0RHa25xSER4WlU3TnBLQkZiUG5NU3hB?=
 =?utf-8?B?cmw2SXg1RGhVNFhCb20vMTBzZjdFM0NHYmVMd2xzRW1kamF1c2RUUDQ0bVFn?=
 =?utf-8?B?SXBzYnRqMDMyaDVUQURQSTBYTHYvdjl5ZXpoeGMyb3RJbWE1eDg1cUZGK3Nj?=
 =?utf-8?B?YXV1ME9QUlI5L1JzQUxsUDBGVk5KU2xZMDM5RDlodFFQQTNTenJraWVCdUIv?=
 =?utf-8?B?Q3J6Q3g0NUdsN0xDNEc2L0svNnlPNkdid01WdlNDNDNrYmdFZ2tQY3YyK0ZE?=
 =?utf-8?B?eGNKeGhlc2lDVXBxSGtReDNYZ0YrUmlMSkErZDk0aVk1SjdXMDFsN3VNWi9D?=
 =?utf-8?B?TWVUZkZ0VTlITHFxcnhRREhyS0xJcmhWVUVndVloQVdvWVFZMXNTR2NobWox?=
 =?utf-8?B?elYrbFBEWDFOdVZUMzRkM2hmNzlkK2sxTWxQV0Qvdm9lcndncWRwOFZOK2p6?=
 =?utf-8?B?TmNUbWF0L3VwZ3BKdTduVzE1NEpFSFlzYVh4SmprVFZDYjVCSkFGcTRUK3Ry?=
 =?utf-8?B?RmpPclZlM3p3Q2xONE82VmtpdDh3V3BKYm40WGREbVMyOFpvT0ovNTlwQnZn?=
 =?utf-8?B?TXc1OUdSbE1LUDh3aTQrUE1wMVVuRlRtTytRV0tyd1F0a0FnQnRjcmhRRGU5?=
 =?utf-8?B?Y21udnRSMmoralNXaldIWGk1eURBVTVENW9MNU1HS1A2REVpY21kRldpeEti?=
 =?utf-8?B?ekNyTmp5andvS0ErLzZRbFVlcUlMMEFFbHZPTXFjZjlCTzJ1YWN0Z0Mvc3JY?=
 =?utf-8?B?cjN1dHNvclVnSCtGWHRGQnd2eHMxVkxhNkNKT3hYZ0ZPWWNzbVdjdDlGK2Zk?=
 =?utf-8?B?ZEZsczl2MnlmRzQ2andGUyt1SllJK2t1WHR2OTAyT0wyV1l0Q1NGV2NwWjcw?=
 =?utf-8?B?MGc0TnRaWUJDaWUveWxza0h5cmdtdzlqblhvQUw5N3hGZzJndGE5WTdHeEhw?=
 =?utf-8?B?UkdJcVg0Y0szazdnVWNPTWUzaFRtaXIybDkwMDJrV3ZQVSsyVVpXVWNSVVZM?=
 =?utf-8?B?VUpDVkFMb1JsYmxSaWZpejR4TjJvNkdoWUJRL1VoUGFEb2VXT241RVVsM1dy?=
 =?utf-8?B?ME5adWtvQi9qTldBcHZ6aWJJc3lSQU1kOXQyZ3RWU2RxVzRXRUdQNG45dnBt?=
 =?utf-8?B?VXB5dnh2Zzg2aUFLd2J2NTZCT1pUR3R5U1JLM05EV2hUNitYK0htVGR6dlpC?=
 =?utf-8?B?cDNhVTEzdkl0emcvM1FwejlhY0tVQ1dYUy9zSlhJODhiYzZCNmRpMnhlTy91?=
 =?utf-8?B?SENjaEhKTURIWjYwR2l2aEZ0QS9KTTZITERoeWNVaWNFdytDSlJtM3cveERS?=
 =?utf-8?B?RUlZOWx1YTNyM2dzSnNxYkdhTjdWbEdDV3hGZ0JGZXVlZnh3c0RSamxRTVNI?=
 =?utf-8?B?cndqdUUrc1Fsc3VsbnYvTUhIVUhraEVKRDRkUFpSc2sxUUpZeGJDYVJaVFB0?=
 =?utf-8?B?UWNwVjJwRmJFd0JIRnM3OGd2b0k0VnVhZ0h6QWpCNXMzMEhSeUpBaTZkNTMz?=
 =?utf-8?B?MVRoc2RuRHlsOHNXL3BWeXVHUVJjK0tGU0xXVzRvQTRpc3NnT3NKRkYvNjZS?=
 =?utf-8?B?aUdvamNvaGdHMHhmOHhHQnRIb05HWTlzd2NpSmp3T01MRXY3U0o4TXB3UWE1?=
 =?utf-8?B?Wk9hc0dZeUkwalh0Y2dWVDQ2THJ1bCsyQ1F0R2s4dU0vdFk5WFcwQ0dSRlhw?=
 =?utf-8?B?L0M0Zk01QnlrU0grZ09PS2pHWFZpRFNzbXpqNVc5aFJnNVBXWEpjUkdFZ3Y2?=
 =?utf-8?B?eTNhZGhTUHVIY3p3TmdTdndWanBqOUxBbzFBMFdTVkZGT01XTUdGUmpSN2JY?=
 =?utf-8?B?UkVPK1FQSCtPTmZjdHhka0J1RzNvTzdKWTZUM1BQK1lFamFmNHNyYjNwdlhR?=
 =?utf-8?Q?RqOwwchRp5k3lOjszT1xEH0nQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b275f08-8b81-4bd9-6ea2-08dd7addc517
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:51:47.2554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tnWNTg5dVhoU2PWzio5UvYtxgSzapntFAx2J5o3z5HYKkRnwpr3+CDCpwZnHdb9ImOxNrU1PW/04+wjrCKejaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com

Additional DCD partition (AKA region) information is contained in the
DSMAS CDAT tables, including performance, read only, and shareable
attributes.

Match DCD partitions with DSMAS tables and store the meta data.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: Adjust for new perf/partition infrastructure]
---
 drivers/cxl/core/cdat.c | 11 +++++++++++
 drivers/cxl/core/mbox.c |  2 ++
 drivers/cxl/cxlmem.h    |  6 ++++++
 3 files changed, 19 insertions(+)

diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
index edb4f41eeacc..ad93713f4364 100644
--- a/drivers/cxl/core/cdat.c
+++ b/drivers/cxl/core/cdat.c
@@ -17,6 +17,7 @@ struct dsmas_entry {
 	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
 	int entries;
 	int qos_class;
+	bool shareable;
 };
 
 static u32 cdat_normalize(u16 entry, u64 base, u8 type)
@@ -74,6 +75,7 @@ static int cdat_dsmas_handler(union acpi_subtable_headers *header, void *arg,
 		return -ENOMEM;
 
 	dent->handle = dsmas->dsmad_handle;
+	dent->shareable = dsmas->flags & ACPI_CDAT_DSMAS_SHAREABLE;
 	dent->dpa_range.start = le64_to_cpu((__force __le64)dsmas->dpa_base_address);
 	dent->dpa_range.end = le64_to_cpu((__force __le64)dsmas->dpa_base_address) +
 			      le64_to_cpu((__force __le64)dsmas->dpa_length) - 1;
@@ -244,6 +246,7 @@ static void update_perf_entry(struct device *dev, struct dsmas_entry *dent,
 		dpa_perf->coord[i] = dent->coord[i];
 		dpa_perf->cdat_coord[i] = dent->cdat_coord[i];
 	}
+	dpa_perf->shareable = dent->shareable;
 	dpa_perf->dpa_range = dent->dpa_range;
 	dpa_perf->qos_class = dent->qos_class;
 	dev_dbg(dev,
@@ -266,13 +269,21 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
 		bool found = false;
 
 		for (int i = 0; i < cxlds->nr_partitions; i++) {
+			enum cxl_partition_mode mode = cxlds->part[i].mode;
 			struct resource *res = &cxlds->part[i].res;
+			u8 handle = cxlds->part[i].handle;
 			struct range range = {
 				.start = res->start,
 				.end = res->end,
 			};
 
 			if (range_contains(&range, &dent->dpa_range)) {
+				if (mode == CXL_PARTMODE_DYNAMIC_RAM_A &&
+				    dent->handle != handle)
+					dev_warn(dev,
+						"Dynamic RAM perf mismatch; %pra (%u) vs %pra (%u)\n",
+						&range, handle, &dent->dpa_range, dent->handle);
+
 				update_perf_entry(dev, dent,
 						  &cxlds->part[i].perf);
 				found = true;
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 866a423d6125..c589d8a330bb 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1321,6 +1321,7 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_a
 	part_array[index].start = le64_to_cpu(dev_part->base);
 	part_array[index].size = le64_to_cpu(dev_part->decode_length);
 	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
+	part_array[index].handle = le32_to_cpu(dev_part->dsmad_handle) & 0xFF;
 	len = le64_to_cpu(dev_part->length);
 	blk_size = le64_to_cpu(dev_part->block_size);
 
@@ -1453,6 +1454,7 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
 	/* Return 1st partition */
 	dc_info->start = partitions[0].start;
 	dc_info->size = partitions[0].size;
+	dc_info->handle = partitions[0].handle;
 	dev_dbg(dev, "Returning partition 0 %zu size %zu\n",
 		dc_info->start, dc_info->size);
 
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 057933128d2c..96d8edaa5003 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -104,6 +104,7 @@ struct cxl_dpa_info {
 	struct cxl_dpa_part_info {
 		struct range range;
 		enum cxl_partition_mode mode;
+		u8 handle;
 	} part[CXL_NR_PARTITIONS_MAX];
 	int nr_partitions;
 };
@@ -387,12 +388,14 @@ enum cxl_devtype {
  * @coord: QoS performance data (i.e. latency, bandwidth)
  * @cdat_coord: raw QoS performance data from CDAT
  * @qos_class: QoS Class cookies
+ * @shareable: Is the range sharable
  */
 struct cxl_dpa_perf {
 	struct range dpa_range;
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
 	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
 	int qos_class;
+	bool shareable;
 };
 
 /**
@@ -400,11 +403,13 @@ struct cxl_dpa_perf {
  * @res: shortcut to the partition in the DPA resource tree (cxlds->dpa_res)
  * @perf: performance attributes of the partition from CDAT
  * @mode: operation mode for the DPA capacity, e.g. ram, pmem, dynamic...
+ * @handle: DMASS handle intended to represent this partition
  */
 struct cxl_dpa_partition {
 	struct resource res;
 	struct cxl_dpa_perf perf;
 	enum cxl_partition_mode mode;
+	u8 handle;
 };
 
 /**
@@ -881,6 +886,7 @@ struct cxl_mem_dev_info {
 struct cxl_dc_partition_info {
 	size_t start;
 	size_t size;
+	u8 handle;
 };
 
 int cxl_dev_dc_identify(struct cxl_mailbox *mbox,

-- 
2.49.0

