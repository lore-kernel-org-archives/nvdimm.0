Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE251301039
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 18:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758652387; cv=fail; b=XxExK7rqjZroW0vVxpuqlW9I/PPH69FIS0sVrYQbihA6so9Wn/ZOchl/bmDUNyPRzW7i6gF1A0VSOhxSvGWM2BxS0pIOWJN2dUMssAIXX1o1RHlHi+sG59ilDh80e9KRoxYKzlxZmQvR6nuPo6fxlEl39XWgZNGJriujDt45oGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758652387; c=relaxed/simple;
	bh=Xsnq41CefuSc0SqEG0mH+5cM01vmw0caza8/6gto38s=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=j5LeutTVFz47dWvZA3i84kp8rbhLXEMCkuehIiHK3+zWLwGyfeiOzfsnhvvB0KObdhuHEaS7Vr+sGGqSl1J2JlgmZPyXLMSLIl8y8Px+8L5XZTvobClxAPrua7uUH65ISVn5zcytDCBKH6tEvEpES9OP8Ky68Czui86+xgWeAJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ii0nA2q0; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ii0nA2q0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758652386; x=1790188386;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=Xsnq41CefuSc0SqEG0mH+5cM01vmw0caza8/6gto38s=;
  b=Ii0nA2q0z59MajjwUqzPr8lncuv5qIlL06grb+Fo39pe9URHTyPzCgHP
   WqrasXzQX/oa1dx2tu/rMPWWPebJ2kK068aloIN6MEh8lgqOQA/tpz2Yt
   fny5dInPoJaMtM8rNIQJIwc7o+jANfxNUsYQu4zsMhS4jCNLKljfhd+IT
   0vRZebosDgqg7YTsSL74HlXrhVuOyFjkunSGVJnmOiofYcDiOhAjW945Y
   pGJwotpUsd23v9HxynOzDnoes+2CdQgzbHb+5wuQ0DrjIv53EUfynrVCL
   3VY7w2DQmaF6qN3GzUu2SD+uTzKrDc/lYX9zKj+u0XYngOAMZbeRMLK3V
   w==;
X-CSE-ConnectionGUID: jfxJ3RUPQJyQxfo24dhv1g==
X-CSE-MsgGUID: 7uWsCebjSo2jTp+SXNS3Tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="78548678"
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="78548678"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 11:33:05 -0700
X-CSE-ConnectionGUID: CZk3HS6sQq6PNYxgzOt8jA==
X-CSE-MsgGUID: 54G0p/RpQDK8NPBomJf4JQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="181148346"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 11:33:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 11:33:04 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 23 Sep 2025 11:33:04 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.60) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 11:33:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kd3aIfFzfPBtwfeWZKoaRdFQBPCPH+sfVS0/AQw2SkpZ+Y6FONjzFhc84Gy17iVuryE2s/qdCVF7smImtRq1fg04QOSeaJgOFoCYZIrtZYRWLcnB/f710THEdr6dCD/gQrIu311Bc+qSvIBaIdTnG9Q7hVHhN8ow5O3rI1sT0xHGLw5wao6fWllkJmDX4T4nNUcVb5eL0bvuAKELrgO4/bWGGAcKt7izCw+MAcnnSlgWvJyFr6ATKc35UYfqTNsu/XIH/fuluMmIla+S1biXjXu6QQNNsgay+QUogHkPkOndAXGuL2vGW+UX5GaD/DDKer04K2Co6DX/EnAHIsCMjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDuk8fAHz6X3J4bSW/6UG8Uu9OvpPkXPHZJ7tkaMTRk=;
 b=n6qKc6Wd2N4TRh63GYh16cbF3zrJtQ6Yc3DKFZIVQL9ESjrKYyWCp6tcoJnkLzh5rriGU2UNhbq5ubtpmiBpxxDIn+22p2TzcXKGoz+xNeRUF9ZhSRDyEBSxOQFuO2zPTNqH589Wwkvmb5Mq8Xg8Gz0sMX+i8VFwMdOXfh2DE7ltrD/MWAnMfCPScMhWzRsfSF+vSeDqHGF93ZcpRSm6XGSqu3HmdSbmNNGEqrfWcFfMce9mDfZA2n/VlTWhiWjB/y9hXeK2CoVzz8qk1KuYgQ78jujE82vIJ6q3EleVZClqierl0rlEYg5pkFTSYYYuZHs+wivWtOhVL6kphxTTFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH8PR11MB6756.namprd11.prod.outlook.com (2603:10b6:510:1cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 18:33:00 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9160.008; Tue, 23 Sep 2025
 18:33:00 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 23 Sep 2025 11:32:58 -0700
To: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
CC: <ira.weiny@intel.com>, <vishal.l.verma@intel.com>,
	<dan.j.williams@intel.com>, <jonathan.cameron@huawei.com>,
	<s.neeraj@samsung.com>
Message-ID: <68d2e7da5206c_1c79100e5@dwillia2-mobl4.notmuch>
In-Reply-To: <20250923174013.3319780-3-dave.jiang@intel.com>
References: <20250923174013.3319780-1-dave.jiang@intel.com>
 <20250923174013.3319780-3-dave.jiang@intel.com>
Subject: Re: [PATCH v2 2/2] nvdimm: Clean up __nd_ioctl() and remove gotos
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0113.namprd04.prod.outlook.com
 (2603:10b6:303:83::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH8PR11MB6756:EE_
X-MS-Office365-Filtering-Correlation-Id: 94502801-71fb-44dc-a34c-08ddfacf9f90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UzdNaGpLWUlxbGVVVWNTV1NFUlIwRjdZbEFnL2tMVTVqL040OTEwWWZzbFE3?=
 =?utf-8?B?bHRqRzY3dVlBTmZmWituWk83K3lhVVBLT1BwUVA3MlFhWGRoQjJGVE9hb1pm?=
 =?utf-8?B?aGRhcWx5dFU2aGkwY1pEYlMwM1NabXlhS0Rad1JGY2tLNXVrQzZ0YTA3NnZE?=
 =?utf-8?B?NkNhSm5Hblc2aDFyK0NJZEJlcDhNVGhhMEh5NTd4bGNNK0RRNjA3dzNyb1hK?=
 =?utf-8?B?YmJsZ0hoNVJ0QlBnamhYNEppa0pvZStPajludlg4Q3JoT2FLOURWbjF2Z3A2?=
 =?utf-8?B?UFpyVXRKYXBKcC84UXRvc1VlNXR0Y0N1cW5Gc1NUa3lsaHpKSFFMSmdRMlFK?=
 =?utf-8?B?T0JsaXlaYVJrQkFnQ1Qwb2lnSEtMaEsrQkdXYmRLcW5YRXh2eGxVeldhUXdz?=
 =?utf-8?B?QjVwa210WDcxOG0yemttUGpMbkhlK09FR0M3aFc3aG1VVEhPWkRwbXNtRWMr?=
 =?utf-8?B?RHNPMHFmOEc3b09kb0F0VlZIRFl1NDQ3TWNnRUNEWDJWaDVjbUFUVTU5cWZa?=
 =?utf-8?B?NXVaY0w4bHFiTDZid2J5NHZUNzRMQ3Z6MzJLY3FvWmhEa05HMEl3T2lwMzNm?=
 =?utf-8?B?ejUzQ1lOMXhTNllNbE5ETHZjRmhpb3dGR1J3THk3WU9JVEdodEhqSnpHNjNt?=
 =?utf-8?B?VFI5emZYcFB4cndoTFpyT05pcWpvN0lGTkd3NmlCTHVPSnBYTXRQYTJTdVNC?=
 =?utf-8?B?L1NScU80T0E1MndSdmRmVWpObGdzVWhFRkkvY2g1dFRFOENZeUYwNy9tcUda?=
 =?utf-8?B?dXZFQTZpclYrOFdWTm5RWkp1NXRjd05heHEzMTZGVWtqV3FweGVyNjRjZmJs?=
 =?utf-8?B?MDdJYlBSVVNZcnUwVEJyTWtPMndtTHhOTDU5ZHlUY0tzWTVMck0xb1o0UlJ4?=
 =?utf-8?B?Rmk2dWJwdzFEeFZTL2hHOGF3VjRvOTdqamtnOTQ4K1M0a0U2TmNMTkRLOURK?=
 =?utf-8?B?Vm9WbkkrZHBMSWZJL0o0NmFlSVlaQytZRXhCWEEyVXdCdlJSQW5ZUWt6Y2dP?=
 =?utf-8?B?cmRvSUdmeDBEOENhTmw5cE1zRzFwdHZJbXUza0ZwM3Q0N3k2ZzJNSGtsZ09u?=
 =?utf-8?B?R05VdTQrRi9sMFdkUGYrRmhUQm5MSGRDWFByVUdWWXlzTnh0d0FkLzU0YmRR?=
 =?utf-8?B?RHQ3R0hTVDErV2plYXkxdUN2NXlFb0JTQjZNamoycWM4VlkrY1dWR3VESVhB?=
 =?utf-8?B?WEtYcUlsNTZrRUlEQ3ZRUFVVdXJYUG1iQUJTUTFGM2xpRWZIMFFoWTZjRDVU?=
 =?utf-8?B?czhTQzh3MDNYT2VjVHhDV3RnWEdEM0JVTjJoRTl3WWNUZmdrVUl5a3k1Umhp?=
 =?utf-8?B?cXZnWkRMTjI2KzlzTWtKVkplN3FwaktZeWJMbUpubU9mN2xSd0NTZHVONFZD?=
 =?utf-8?B?cFFFMEZvcHhsOEQ4OHAvenRzVzFwcmV2akdDcFB1V1Z3cWZyeU9ldEVxUmdW?=
 =?utf-8?B?Q3BqTXgxNVZjUUR4YjdYZ2Fkc0FkckhKZVpMcnhkS0lOWkFEZnQyZkw0dGJS?=
 =?utf-8?B?WjRNdi83YlVOK0pQL1F2R1A4a3Zia3VrYjRzelk0cmJCaXZMWlBGU1YrZU9L?=
 =?utf-8?B?MGRpQVlURnczeUJ0SXU2bmFlalBiZlJGUHd1MU5lV0FpNyt4K2J0azd5TGdU?=
 =?utf-8?B?VFlDU2VwWTFkRTNycGdweFdKeW9ISGhsMVN0WGY4bnplNjhUejRqemhaUnJ0?=
 =?utf-8?B?NEJYZS9jZVJXeDFxeDR0dTN0dythQmpaRDRNUGluTWlTbFFnN2tNalpXWFNh?=
 =?utf-8?B?Y3FZUStsM3pFWElmNkMwWjZpMVBVajR4RGRXRzUzalVXT0hKZGNES1o3SW1j?=
 =?utf-8?B?TkJZLy8xejNYdmxVck03QXZCTkhQMkZqMkRQNUF6STFUTWN0Z0JwbVY2c1NV?=
 =?utf-8?B?OUhxWC9XaHYyOFFGTVY2UER6THB5M3lSZVpvMVA1TG9sRkxiYStSSTBNZW9W?=
 =?utf-8?Q?CfoYCeI0vac=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXNOY0VVaVBpdDdhTHJKazJPNnhkdS8vRTBLNGhwbmpRK0lZbWlZQm51YW0v?=
 =?utf-8?B?OFNWcW5JdGQyMitiSjErUG02VkRWekI2bzUzVzhmeFQ0eEJGazBKZmU0QjE5?=
 =?utf-8?B?TStyUHFDcGY5ZWlMVjV5VHdhQkpsYjRjNEdwTllzZEdqK2N0bkZKRWVrMll3?=
 =?utf-8?B?dDdpNU13dWE3dmhuZkg0OWdVakN5UVljcTJPNXByMW1KUVR6K1ZaaDUxRDNX?=
 =?utf-8?B?K0VpQzJpblliVW9pMU1VVzdGUUFSWm9hNzI4T1UvZTNkQ2hZcm5LMUx6bDJT?=
 =?utf-8?B?WGVHVXdPcTRVQnFMSnBHQWpXUzlIbERHWjZxUEVHeko2dVFwc1YvZ2dQeUcv?=
 =?utf-8?B?YkJBQ01PVUJJSkdaRWhab01lUEx1UFg4d09Bb1QrR0hPSFIvcDB2bFZJbGhB?=
 =?utf-8?B?TDFQRGRTZHo5RW1hR1NRcVVSc3VxOFNURDFiUUJwM1ViWVEvYTJZcUdzZ0k2?=
 =?utf-8?B?cWE1YXp3Q0hCMGEreHNRS01kSDJGL1drNmcwMGVDd0F1eGhlZmd4N1IxcjhE?=
 =?utf-8?B?TFkwRTFES0FGQ2FaTVJZYW8yYlNXcFBrQi9Id3V4UEl5YXU0dU1BU0cvd0Vp?=
 =?utf-8?B?Zit1UVJEYXpTbDBsVEVDaWR3Tm5UL1JnYi9wVDRuRjgvWFZaWUZaTnNTSkx4?=
 =?utf-8?B?Zk1oMWIvcjBLem95NlZJcEUraGhRQXMxcFVsSWp3QnYrV08wbVZ6WEoydGpR?=
 =?utf-8?B?cTFvb3VhejdZSFZCT3pZbTVoMEszTWVWa25hZU5YUjE4OU9DMWFldkZ6QU9k?=
 =?utf-8?B?eVMyMjVPQ3l2eCtCQTg3c1Vac1pFVWVpaWRQYXR0N3VwZXhLc0xoLzBhQTFj?=
 =?utf-8?B?YUhFblFpbkZqakxjUnA3cUFkMUxraURGQWZ6b1h4bXdoNnoyVmU5L3ljemNm?=
 =?utf-8?B?TDhEY1p2WFYvL2srZVd5ZEV6UmIxYUdMdDZhSTJSUWRsd1ZZV1JkK2IxYWsz?=
 =?utf-8?B?Y3BST2JPVGVUYloxM0FPYXZZdjRVNExHcWVxRUxzcHRxVnZ3OVhnWHRUekJu?=
 =?utf-8?B?SG5ESVQ0L1U5SWJIVFYybVcyWTN5RllsRVhGU0ZaU3ZDNi9UWTY4dkgwUThz?=
 =?utf-8?B?eHNUWjhMUUhSS3ZKZUtXZzNnTlN4VVVWY1dVRXlzWHJLT0RNNHRYaGZtdDJL?=
 =?utf-8?B?WnlUNzM0T2kvbXVtMGQ2eFlMZXNsT205aWRDRndrYy9rZ1c1VHlsN1RHNUpH?=
 =?utf-8?B?MGpwd3hKV1kvTjlEbzFONDc3MFRiQTNicks4Wmk4U2o0ZUpCOS9ZTDg2Z3Nu?=
 =?utf-8?B?Z2pWS0NCcUNQSWVvai9sbUx3U2tONjJBNnJRRzlod2cvRHZiRkM0STFZckE2?=
 =?utf-8?B?elU0RHJ0a2FTekNqVkJXcXE5cVl0eS84ajNMTXFBcFBSMGFtb1pkV2U4Wk1H?=
 =?utf-8?B?MEltZHV4anpzMFA4L0pSRStzQXVOdTdDRGpNbG1JdTdGOXVPYWxnR1dwWkwy?=
 =?utf-8?B?TnhaWC9zNVFzV3VkS3lKT3k0Zi90Ty9ZN2Z0WmlPZHdNZ2NxMGwzR08xVkpi?=
 =?utf-8?B?czVRano1TTVWOVg3cmtXRll4a1V6dkUwajVvNmFlZncvNTBwZjJHMXBud3dH?=
 =?utf-8?B?dCtldVF1N2l6eDIyZm9HYzBqTEdXcUVsQ3RwNEZOTkg2Uy94OThuZ05yN3NN?=
 =?utf-8?B?QWxOakdLUnoyTzZkem96MFVoNU90TElBRUpIUE5tcUplVks0RDBqN1B6YlVw?=
 =?utf-8?B?R1BVRUhhUmNZcDZYblN6ditBSlExMmc5QnB6amJMR3VtSEtHUG8rRi9XZDZx?=
 =?utf-8?B?MzVFdUVDRFR5UW1SbFBVTzcyYi9hcDRzWmlMK21jc3pLUmtwQ1FkOVVLdkVU?=
 =?utf-8?B?WXZPYXlWVVNDMFBSaVF1ZStQS0hydEwrYlFoYWdQSXdmbFhJYnhaUW0xNnQ5?=
 =?utf-8?B?RzJIYVZRRHBUTGNhNjB2aXhkblRUUWtNamlqSUdPWitrbkc5UnhVeHJBWXhS?=
 =?utf-8?B?RitKY09GTmQxdWVMWXpoeC9rYVduNkExRXl5UkhLSkl1NTBTazlBUGU3R2U5?=
 =?utf-8?B?ZDQ1QWRmcTVTdGRrYTZrSWNFOWNxQ2R6MWx2dDl3cVZNSGVZc0VST3Fkazl0?=
 =?utf-8?B?Skd5RXJQZERlUURpVEIrT1RVTlJCRWMxVE5lcXNLZkN3OFpRZExVVTFXWHRW?=
 =?utf-8?B?OXp4emRYMHkzSXZ2ZXRoSW5NUjBkV2RaU1dYWHFaMVpoWWVzTFZIeFR4ZU90?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 94502801-71fb-44dc-a34c-08ddfacf9f90
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 18:33:00.0179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zQ5QWsbx1n9YS/x7K1wxw44eF/aEhgYvXqTgDxxrQnmzL1yXlpeXQChgBvtW6aVn3U47IbYLBOdrzw2yYtMZB0RCU3AKtMaEsrfE3UZCyYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6756
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> Utilize scoped based resource management to clean up the code and
> and remove gotos for the __nd_ioctl() function.
> 
> Change allocation of 'buf' to use kvzalloc() in order to use
> vmalloc() memory when needed and also zero out the allocated
> memory.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/bus.c | 65 +++++++++++++++-----------------------------
>  1 file changed, 22 insertions(+), 43 deletions(-)

Looks good, nice cleanup.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
