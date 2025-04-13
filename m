Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB681F30BB
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584727; cv=fail; b=C+SroxEXNGxxYpWE3I8HQb2L3drGzRX6LoOR3dEikgrTWmXhCRjjmIGSvFzpZuhIpTQ4YBu9FXEiwAPfAqRwgozC16ScpiXgvLnds8UC5jcr/OX2C+3urXeYecu7Smcij8EK/UVeezZfXzTjW96HppaqDgqEOnlTp9S6EzL0ip8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584727; c=relaxed/simple;
	bh=iluJfpsU++oIIgnjHnQQGAMSzSadvi007rxv3Yc4G6U=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=rUaxvstP91WRM0KZTLvEdR3073SCfOqukswdURYdSZA3uLXgLsg2MicdJYv+pNGipNgxz7891chHszWUbdgxiKRG1WeDpbRMmjA6FZaaQ8j4w4X7k4GfvBbSd1BzOd1t7f7YjD35HVekfIVTVI7MmDzLa/6KgsxlEMREko1MafQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b+QnFiB5; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b+QnFiB5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584725; x=1776120725;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=iluJfpsU++oIIgnjHnQQGAMSzSadvi007rxv3Yc4G6U=;
  b=b+QnFiB5ckAKcjfXsnEoEdJSiVCT8qm+/qIB3X63XTtYNsXUPbWQn6Jo
   xOC1otsWZDdFsngKF2APhQzDcDhBXqYMZuJwBft1Lc9Cjq0Xdj9L7fwcu
   ABx26vl0Z8OBH7i+0/f9UZZyBpOlyIoaoq9odsZxVvAIOS92krslJziLr
   C2+frVD3i9SrGoWS4rqoyqQInBTxIZqbn4eZj1WLwNReZIZPm2ieAsVx4
   OlVqsvds3rhfgu/c/S2No2v9OO8FIqU1rVIRAsGe3ItCd5A4Cd/aqOUhi
   JDst0h3MW327hPxMJjSF2Ml79UlSd7yVgOlHOODrH01qPJTBCFI3YcBOJ
   w==;
X-CSE-ConnectionGUID: zmqNjOUaTmSmsrDAHmaUCw==
X-CSE-MsgGUID: AvaSmOYtS6CqTFVf/Izx5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280914"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280914"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:03 -0700
X-CSE-ConnectionGUID: RSqqwHBiTEOjVt3h32dqdQ==
X-CSE-MsgGUID: pAmz1rqtRuuZy+xcQ3PAPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657471"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I1D3WTP2TykNmNbIS4YsN27uUoWPjtQZit3EQUUooVODRuFNej7gGwykRtRWzuUd5+BNMTLmj/5ocTEzJmiqafFqQ/zVMlHM3LkuXuC8JGp7HN6Nxi6eaWs3sqtws9tWL3FtmdM7Cyqpmo98kGpTHK13PJeo3BkIxwHRCO8ORQfix+AY4veUPOKBFqjw6wYKwGuvvUr1pO4XvoERMTm6Fxf3yZBpT8Tg61FrHu4tHQAb+tNjzLS6AJ64sz2W15p2utZVW8rmQAukOVNstNm20BYAS+m3vdM/sQKv8pLzsvpZ43LoSSzhUaXc99bJiok0Pudf4AbVUxLiiT6G8U3GwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YouiFuSf4pyrHsNUvpkk19Of+rZKju0AJBO992m58ZM=;
 b=BQq2vJglEjs/1GVHsH51zrYYPrtsFjbX9sHMaZFO3zGacbcnTaTi8ksCPtXbBSYVvCZYPWJRFMjSsg1Es9qB+jzrXeqcRExxYyxA4sOnmC2ZAGpoGAzWAaLlrLqJXSW2hphnYjrV5Y+ZWj1l8q3mYKEKQnla+kKY2WzLUYY7rH88u1FBa7uFRFu5QcvUM64wbSaF2ZtKdHH+kblfi2zsfr5DF8Zz90BSQLKGbxtnN9c4v4NcRa81u7hatRiayMRwKqrBi70XpcvU5MopX9IESjOuzTG0HuYq5LTIMQtcmUBo9R3V8/3SJUe8AoPVs7bOOd1qDEWW/TGfpLfQRvYY/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.28; Sun, 13 Apr
 2025 22:51:55 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:51:55 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:16 -0500
Subject: [PATCH v9 08/19] cxl/events: Split event msgnum configuration from
 irq setup
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-8-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=2631;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=iluJfpsU++oIIgnjHnQQGAMSzSadvi007rxv3Yc4G6U=;
 b=4ksVC3g/3tEirb+WH7N3h465FU+jX1FXL+aIj5QnuVEdZ+lAUir9vifMLKND8+PDnUSr+/tPI
 Y21mG9OA/XBDj3poiE+6mVzsupZPTUEcljr3cmX+yrxnZUKLQaP7t79
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
X-MS-Office365-Filtering-Correlation-Id: a88790ab-a0db-4891-b932-08dd7addc9e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T25iRUZNM0xMZDh6ZTNhOG8xTVNHWWNBOWVyQmwrTHRUdGluV0JIL3lvd09T?=
 =?utf-8?B?Wm9Zb3JQalBLdUhnY3FCMngwM3pINXBpM3NhdjhIQm5UZm9SRHV6K2ptbHFO?=
 =?utf-8?B?b1QzU2txTGR6NTFON3B5bG9DM25IR0NHblJobVJ0UVZXcTRTWFpURnE5RUZG?=
 =?utf-8?B?K0twL1BPRXZYOVF1YjhVd01KT2lFVjg4V0s4aTRacUU5UCtNWmdNTDZlN25n?=
 =?utf-8?B?aWU3ZDFuS3h3WFZONzlaZXNOekFCWmN4VTRRbXJMVjNVRzZ4MitwajBYaFFN?=
 =?utf-8?B?blE5ZHJwVHp1TmMzaVVVUnRGVDBQbWJDNW5IYitXRnZGdW5tU3hlMHRPZUw3?=
 =?utf-8?B?akdsVWtyR1ZBZE8yS0h6Z0MrTlkzQzIrd2JhQUF4RnBSUEZkSHdZbXBQMWhX?=
 =?utf-8?B?WGtPQ21weFZKeTBDblArZG1LQnpNWFZnakljd254Tm9kTmcrNm5lK0hjc2p4?=
 =?utf-8?B?QjIyN0tja2pWWFFKS2VkOURiSHRUS2hQcm1qeVNiNEM5ZmZaZmV2ZzFZN2Vi?=
 =?utf-8?B?bWFXelBhd1AyeHBjUDVvS3ZQWERnUVljVDBOOERKYXRpWGtia3Q4UjB3MVBa?=
 =?utf-8?B?WVZOSVl5VlZ2L1RFUTZzWXFBTUI3NjQ1aW5MSzhMcEQ0SWpjUytMT0o3cTRs?=
 =?utf-8?B?WkV6R3NKQStwSmhwRVNkOWxjejNoR0lleHFvMWRBT1AyaVlJVU1EMWFncHNK?=
 =?utf-8?B?UEo2a1lYUlpvZk01MFZuRlFpTm9DM0pOZ0dzQStBSllSMTRndmlYYSt6SmJR?=
 =?utf-8?B?NnNEUjZnMUpLcjRocllMc0p0Z2xLOTJhbHdlaGRiR1ZodUdsYXNmbC9UenFY?=
 =?utf-8?B?ZjN2RjZ2WFppRU5WVWlud1NxcjlUcncvOWVnRGk1UjJyZVBlaXZwMnZ0aGVY?=
 =?utf-8?B?OUhZMElQdDVEbE5tNHlZbnBWc2MwZmhVOUlEMis2MVZmbkxYcVpUWm9MV1FO?=
 =?utf-8?B?MzhZYjhiOFQ0RDRoZGR5UE5HYyt0d1drZktnRUY4Um9HUHVOZGtqUENRMDJP?=
 =?utf-8?B?MkdxSDZ3b3UxazV2dmVkMDl6WFlFTkdpTTY5ZkZnbkhrYVN2WlBkdjQ0eExR?=
 =?utf-8?B?d09nUnNQTmo4SDJDRWY5MFVBWlRCZGltaXBsam9BbmhTQS9paGxSWk5ON0gz?=
 =?utf-8?B?aVRMRTRqVklZb2RiZkZnbENPY0ZzeUFldWpyL01lYmRCc3FRMC9tYmg0UTEv?=
 =?utf-8?B?MTFicE12anVFUEFMM0NoUWZrVWczL1A4OEpyc3Nabm1LT1EyU0JrVTNPWUxW?=
 =?utf-8?B?S2tVUFMreXFxajZoK1I1cnd2TFBsbmxQMU42VndYcmVORmljT0Ftc3lVblFQ?=
 =?utf-8?B?VWozN3hFVkNlOFJSck8xOEpTckY2Y1VkOVFTUVlJbkdUN3lEMWg1U1p2NDBM?=
 =?utf-8?B?UkxzQUVNbFVscERCanZ1OXo1OU9BTVZoS2pTaWNaR0ZYVzg4aGpUK3FBejQx?=
 =?utf-8?B?RFl5aDh0S3UwbXMvS0RsdUVueGpTTTc0RnhoL0FtWVhwaC8xNFFyK3pNeFg3?=
 =?utf-8?B?QytpQ0pZZVphU2RjQWZtbnltaUdDSnlObzk5Z3IxK3Znbm5ueWpVUEJUWmdr?=
 =?utf-8?B?OXBDV2U2eitkZDJ1VlJkU0h5VnpXa0VFOGhlNE5zZkxoYU85eFJzaGFWZGxp?=
 =?utf-8?B?VVpPTlpQLy90c0ptVEI5bnlGLzZ5NEd2L0hKQVc5TTA1eXFCWkdDbjFaelR2?=
 =?utf-8?B?QlhuL0ZmNDBTVXFyUndDQ2tZcGZjNnZpWVBVYTJFUHN0OTV0SkNDckJDN3Vv?=
 =?utf-8?B?Nnh5VWZHRU9CSnF0RGVTVDYvVWs0bVJScWo4eXZ0UkVRLzdFVUYyeS9SUGpx?=
 =?utf-8?B?cyszaGh1KzBOTms1QUhBTng5VG9oRFZLUktaWGVRQ29qMzMydHFqTnhpSUdV?=
 =?utf-8?B?UXowc1hFY0E1cjZ6eTFFUXJUVFVMdlpBM2dBREZWa3E5cFBTUmd1c1FEK09W?=
 =?utf-8?Q?o6I5jafosvQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejU1c05zNWt5NkRvVHBLUUZWbU1qYXViNVg2Vk5UUEpOUFRvZ1Rqay8wSTlv?=
 =?utf-8?B?WnJaUVVUZ0dkcGhxY1VJOWhOQWxaQ0JrRUdKMUpHdVBvZU9ZdG93cko0Tk84?=
 =?utf-8?B?N09HVUpWVEhjUWMyY0t3WjVqZkJZL014d3Z2VFhKTFBhZzdZUGxYMmN2OTV0?=
 =?utf-8?B?RTliajhXTmt4TTBxbW5sVG5jaHZoS2JCMkE5Mkk0SjhFdGZYbGpvdzFXT3Ax?=
 =?utf-8?B?UGczZ1l6NUJ1K3dhc2gvdHd3Tmx0dUFvdEphaS9sMThDVzQwaVZrMEdicTZP?=
 =?utf-8?B?VHd1TVpaVyt2bGg5Slp2NTJQOHFxOWJYeUMzL0QwM0F1Qytlbzh6Qlp1OHlY?=
 =?utf-8?B?WWExaTVlQ2YyK0pmaDhMY2hIUWRmTDJza1IwemFFMWpDMkNxWUJIWU13SHZx?=
 =?utf-8?B?OSt2WHF2Q3NBMk1sR05RK2YvREZwZWxnR2ppQ1IvRFpVaU01dE1lZmxDOWdl?=
 =?utf-8?B?cytZQVJFbm5GYjJHdUREU2FRbXUvOE4vQ0hJTHppbjB5eThKWnJZUlFuTlZ3?=
 =?utf-8?B?QWgvU08yM2dKdXJUdC94a05ibHl5dGtDUjNlNk8reUpQTXdTTC9xek5JeTU1?=
 =?utf-8?B?YnlCN1FsVU9uRUFxSWdFMEJnN3NXanh2Q3RFVVRFYnpESmQ4U0xNL3p5d2FQ?=
 =?utf-8?B?QmwrQmo0L3ZvVHAxTlNnalVpdXpBWXM0aHU0RGQvQWE1RjkxTnIzVlVmcjN2?=
 =?utf-8?B?QlpVUzhMTGRZbTBhd2FTYkpWaCtGaEJwTmhPUm04a21vS1dEY1Jvdm5vVmdk?=
 =?utf-8?B?RDRnUk9sbGNXcjNDM1djcElWTWdkQnFONUFlSWoySmF5aUQ3bW9sYXc4RDJz?=
 =?utf-8?B?bURrSThJQUNyQjRUVWRBcXowTnZnNUljQU5NVjM5SlljT0tESGUwK2JQOFpH?=
 =?utf-8?B?U1lIRjFkL3lYR3FEUEkxU1hXVVhYcFRWVmF3Um4zS29KbTNvVjRuTjdLd042?=
 =?utf-8?B?ZUN0aFZMQXArNy9JVU5Gak9Oc3VRRFJ4dURkV0FkMm1LQUN1cFh0YUZjZ2NT?=
 =?utf-8?B?SThabkJJNGdWRzJoWDZXMXEvVy90SDBwYTdGUGV2aVN0ZURhWk1lSUFyazA4?=
 =?utf-8?B?aVZjRjFDckN6aEhrWXFLeG9UaENVczhRVWw4MmhScVlvdG1aaEpHeVIyblRY?=
 =?utf-8?B?ZDA0MTZWNnRVQ1M2OTZZYmJWUkduV0ZLSFBqenpvV29EdVZTeS9kQWN3OUVZ?=
 =?utf-8?B?bXlJRzF3ZWdySTdXbm9vTXZYaTVXM0picDhIaTkrYkREVTVsLzdUM2RuZ05S?=
 =?utf-8?B?VVVJYXFOb2tQcnJKMEFCN3FQb3NLTVZTWWtIaXkvQnZWQ0sxVEcwN05FME4w?=
 =?utf-8?B?ajJKWm56UCtOMlFHWjFRMDRtd01KOGFzRUJ5SjBpMjNEdEhGTWh3Vm1GUmZG?=
 =?utf-8?B?RFRBMHRFeGg0ZVhGdnVVeWN4bHkrbTFvRUZINFUyU3ljQ3N5OVp2dng4b01U?=
 =?utf-8?B?NWZaWEJtZk52NVBiL3hEQUd6NWZaNnZSdFJKbEhmRUhjYi9NVmF3bEs2U3Ax?=
 =?utf-8?B?M1FMTVJ5WU1yOVZ0ZWV3em5YMXRzaEtmZTBvajBYUWs2N0VoaE5JME9TcGQw?=
 =?utf-8?B?czhiTmg2Wm5GeHJHU1Z4dzlVYzdBeTZTdDVKY0ZnL0JmOW5YbG5zNnFSNmx1?=
 =?utf-8?B?ejQ5M2NMWUpVMk5zaUFHTnNSYjRYcmpUVWVYVm5sTlR0MmZvam5nOWd2QVBx?=
 =?utf-8?B?WGJBYWltaHFqbTJTR1BTMklISHhiWmRsY2pRQlN0YmZocHpoVXpXZXUyM3ky?=
 =?utf-8?B?bHRoRTlTaDlFWDFQbUEzSkJJZ2Y2TlhwRkIvVWVDbkRwYUdDUUdETWlVNm9l?=
 =?utf-8?B?RTdzUjJIRTFtSFRFMWowcGZVWng0TFdhNUFhbytBZDJQeXByamtaaHpLZ0hQ?=
 =?utf-8?B?SGJTVnE3MlpOVnlaUUxvV29wNm9vK05KNytkQUtINld0OXg1TGJidXFsdlVH?=
 =?utf-8?B?V3UzVVlSTkEzQkdhcGplUm5TempWMlZKbFg3U3MwZUxOeE5LcHdWdUJueDVY?=
 =?utf-8?B?c1FQR3BhYU4wem53bDF2eDlwQmJQYWZueDUzblA4WVJ5Tlc1ZE00WHR0NERT?=
 =?utf-8?B?Y0x6Zk9SY3JaQm9VaGxYS1ZFdFVqRCtMb3VHUmlvYXpsamdEMUc0eFlrZnFu?=
 =?utf-8?Q?2bOUBl+3FOY6tNMU7a9+EB5ay?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a88790ab-a0db-4891-b932-08dd7addc9e5
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:51:55.1929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lij58BCKBgJ8UPZLXHCFCp080M+PmQMYbvZ3PoNFy/UznMfZBTMeQBFuGJjHFNV0ges1iqCkV9t98/4Krg8vbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com

Dynamic Capacity Devices (DCD) require event interrupts to process
memory addition or removal.  BIOS may have control over non-DCD event
processing.  DCD interrupt configuration needs to be separate from
memory event interrupt configuration.

Split cxl_event_config_msgnums() from irq setup in preparation for
separate DCD interrupts configuration.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/pci.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index bc40cf6e2fe9..308b05bbb82d 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -715,35 +715,31 @@ static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
 	return cxl_event_get_int_policy(mds, policy);
 }
 
-static int cxl_event_irqsetup(struct cxl_memdev_state *mds)
+static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
+			      struct cxl_event_interrupt_policy *policy)
 {
 	struct cxl_dev_state *cxlds = &mds->cxlds;
-	struct cxl_event_interrupt_policy policy;
 	int rc;
 
-	rc = cxl_event_config_msgnums(mds, &policy);
-	if (rc)
-		return rc;
-
-	rc = cxl_event_req_irq(cxlds, policy.info_settings);
+	rc = cxl_event_req_irq(cxlds, policy->info_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Info log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.warn_settings);
+	rc = cxl_event_req_irq(cxlds, policy->warn_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Warn log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.failure_settings);
+	rc = cxl_event_req_irq(cxlds, policy->failure_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Failure log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.fatal_settings);
+	rc = cxl_event_req_irq(cxlds, policy->fatal_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Fatal log\n");
 		return rc;
@@ -790,11 +786,15 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 		return -EBUSY;
 	}
 
+	rc = cxl_event_config_msgnums(mds, &policy);
+	if (rc)
+		return rc;
+
 	rc = cxl_mem_alloc_event_buf(mds);
 	if (rc)
 		return rc;
 
-	rc = cxl_event_irqsetup(mds);
+	rc = cxl_event_irqsetup(mds, &policy);
 	if (rc)
 		return rc;
 

-- 
2.49.0

