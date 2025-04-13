Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65561FECAA
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584743; cv=fail; b=mQF3LXxLjxDkMgWXvLGKC9KpG3tqUpLNp28UZcftuncEJbJT4rZ/XM1aKzIx97DPHyugTuQoPtD6sDBRA+zLR7IjHau9c5A6NgK0KXvVHbYgqB4zenbm7+Fjd0NhkTuQdydvsGBJGe60xrf5++eFK9qUyhx1yGW8nmdmMfxs95A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584743; c=relaxed/simple;
	bh=dCYaC5ZWrBF0vEquEYwJKxfuBnfC5MhdfQ924/0X7fs=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=cnkIOAVv0AeZXxDRLqTQSVrdtC7qMaq1kBERgjt6BXnMnToE4ZWSDl5WfaV/SeU1sQpEwz7FcV0SvT8OKopKNNixBDRtQoqBwdyZp4fccm6Xyr4O2ZKHyvnLZxRumi58zYVAkSrpCFTr5VrW7TnMLDvdA7NwgpWgkSDBc/4Do/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a8vdKp4z; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a8vdKp4z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584739; x=1776120739;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=dCYaC5ZWrBF0vEquEYwJKxfuBnfC5MhdfQ924/0X7fs=;
  b=a8vdKp4zevryp/St1FC/dKOtWi1dGCe4gcqH+zJBjzTIc5PK/eOYlfGK
   51YH9w6rWHR+kmpBf21apxqCXfoic3Ww8RB7grKOna0YZ+Zl/Oh/g2Veh
   w9a2N9xJ1oObFj+xXaX08MOQ9y2Vd4+FRvaR06SvlO9tPopq40M6SSAHf
   RkaKBMwz2iiWcX6GXYSQ7CC0UrSCfLxNJjKV2taWMSqJDM4VfYmU/qDme
   HxMxGMU+BVlci2fH7DO+Q6HwWVligl7EQT3gGE/nbwQOGU7mZRbd24+Pv
   oTDHP00v6mF8hnYagj40ViiYNlZuJ+CwRgFYQu/j7eNrpvdt2+N3agWB0
   g==;
X-CSE-ConnectionGUID: BuNRbhaNQI65kzfIuRxV5w==
X-CSE-MsgGUID: L9ZvZL2mTGCUghFfXAqLqw==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="71431120"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="71431120"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:19 -0700
X-CSE-ConnectionGUID: iGdH7j6pTMm1kr09iDUwog==
X-CSE-MsgGUID: 3RMnPZcBRQ2whXn3tcqVjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="134405565"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HZqrdEpxJjKtvuA0wKO25q9MA90BHPDMXLsTvgc/fiW1vyL5LtCQ6NCdj4KkSK6WTk+hqCAtQJ8SpQmAAc3EWfplbWVmAEYcyOMlJgikX7Wf0z4dFD0MhAEiYsedGECuR0dkx8unqH3EMXboZh7HLra7MoG99uAVIte1L00h/nerB5iSwpHAYa3MJq+yMuKcEQWj0RjQcnW/BV0DaPNgl4X0WeDCJ1RAGsosciVMpFH3mdMIQSUHK3oGThmXs/S2syNB+NxbB2MYI/6/wMWXvdhQb8mrdkWiyIAfD1kDZgUj95wg0h6jKGEUBRFYqt6XwZNAtn/mLhKtBc6EVn8yiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ba2T0ZfLf8iYDHabMe8oJgPLPkgGNb9IiUzF9GEIk4M=;
 b=ZYTK2+kYFBYkruJqi29Hres6GAFpBYR1cXT0X+EAErLJcgBV4E6S90s5b7ZAeSnp3R4DaHM80H7h1J0VtSKwoCRF5YoSAGMnj3MF+tiE1v8tgUuJ3nxhgIL14zOOL3yhgpdpqtRMJwy+b7xRIuoFDY7dw8mHFzB7neILsyrR2MKGfrH77d93e5qh4TTHBO6g2Mkp3RQRnYfserHYjXGcg8zS4TmZ1v2VeIhhirdd5ySbI4wZb8WtmGHLoJAc6LZ1eN5vIkxZTM8YouSWcXcgEYCPL40urzFOfHLHwgTE68yV/IlHRdOyreGPCuJqG7pYnUoXgSATWThjmNQcwhaTgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Sun, 13 Apr
 2025 22:52:02 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:02 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:20 -0500
Subject: [PATCH v9 12/19] cxl/extent: Process dynamic partition events and
 realize region extents
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-12-1d4911a0b365@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=35115;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=dCYaC5ZWrBF0vEquEYwJKxfuBnfC5MhdfQ924/0X7fs=;
 b=ewzwB3JiprOktVaqQTE2Z82vmmw0rqQfCZ2eIU1WE+uGQ4BmrippwoS+Ztw5us/NtfaSOrUnm
 7h3Kp8O/BsfAUG95z/9xzTnWAhARQbGQ3AaYZ+P0V7iuuvepLgyvxgZ
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
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: 78094907-f15b-41e5-147b-08dd7addce29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RDM2dzR5eUJ4NWlpTFRFRFo0TnJteWtnR1ZUWGJmODRuT3U2NHErWkc3WXdk?=
 =?utf-8?B?NFdrTzI0YVdmbnJROUoyeUxXQmNEaCszOUtINCswYTBxRzlkRnRRaDQxcVhk?=
 =?utf-8?B?Ri9CSjVoa3hxbnZqdHZURWZpbXBKUmV5eFV3bG1yWHNmSEkxQTllRGl3Wm1r?=
 =?utf-8?B?b1BQU3E4Y0dHaHRrdTNONXNmeHAwTzFlOE9IbUhzd0tub28va3FOUG9GVEhR?=
 =?utf-8?B?YUtxam41a0QweEZ0bTVqc1Z3UmczL1J5NmtZaFNxUXRsSWlWVFArU2haSG5B?=
 =?utf-8?B?MG55MnRncGJUYko1eVZySmtMbWIvVUVMWi9yUWdLaE9lM2w3OWdBalJjY0hz?=
 =?utf-8?B?Q0c4Vm0rMjJGTmpsNnNad3FHeWRzcUpEM2xEUGlkbHF3bnV5cWc0dVM1azVB?=
 =?utf-8?B?b2pFRUNXV2wwWUZ5RjdNMnNBaUE1ZzVNdVZRbkFRZmJJeW9BSWRObTlkWGhE?=
 =?utf-8?B?ZUZxL0hobVlNcG1yKzFnbDNXcG55QzltYlIxbm1EVm1IUlJqU29pT0dqZXJo?=
 =?utf-8?B?VU5mZkQ0bmN1M2ZZQ1dHWnVaZkZTWGQyd0tPc0w5V1hGVW13dGU0OWNWMlBS?=
 =?utf-8?B?R1d1S0RvRzFINFFoVFpwd3BmZ0FWRGh4ZVdTaFAwOHBkMnNUZmloMFNFOTBk?=
 =?utf-8?B?Sk0rQXN1UDVSUFJUd085MnE5T3laMGRJdUYxeHRGYUFGeDdBN2pkemlHM2sv?=
 =?utf-8?B?MXFiMkZHOE8va0xkM1JXbk5XZmdQOWk0M1QwYWd1RHdmU2dTcXA4SFFtVDh4?=
 =?utf-8?B?V25HNTJpRDVXQXVsbGZObEkrR0Y4cWMzV1B6Z2lLZGxxMXo3RTRyMjlscHBK?=
 =?utf-8?B?QXlITE1TTTdaSEgrcW81N3FOSDB1Yk5mMGk2azdrT2xGejFVdkdVQlMreTNX?=
 =?utf-8?B?eHE1ZHo4bHVFWFh4RU1KSDkzYzI3Z0pTeDE0MjVFTkEzTmNvdjFLSlZPWFpB?=
 =?utf-8?B?TzRxK3FETldhd0l0RXJkZ3RmRGlXYUcxL3B6YkRZY21xcHpTNlB3QVJBRzJS?=
 =?utf-8?B?eXdSUzJUSWxhSDlHOVR5c0pjejJZRUh4dFpLWVRrT21ZbWJyRUEvem15M0Yy?=
 =?utf-8?B?L2VRV1o1U2tGWE1rb2R2WjhHT3lJWVQwL1Fzc25VYkw1TjlUQlEyNjRSOFcz?=
 =?utf-8?B?c0FhSTFMZDRKcEN1OHUwekhGcHVtTjJWQ0p4V0gvZ1ZJbXpnT2tnbUxtNEF0?=
 =?utf-8?B?RVVWSlBoZlBGZ1pvZXdjZUNYa2QvYXhhZVgxaC9hTWN2dUFJNG1DVHhnUVBx?=
 =?utf-8?B?NUtQdE91K0RRMUI5aTFQbTF1empPdWZ6K1VWd0lPN1pIalFvbDJtVFd6UGcr?=
 =?utf-8?B?dzdWU3V3SEpoc0lMU1BFYUJzalN4NCtBUlFhWDBtWFpQTkFnNzVoZUNDcjFM?=
 =?utf-8?B?QUNOaGE0RElhQm9EalI3QmR6WDRyaWZycGhNNTlMS3RTcWwyQkdjWDB6N3pB?=
 =?utf-8?B?YzFRYmV5VHpXVDIwWmUzeVpTcjdDWFZTbVEyUlZablBEUzNKMFZGQW5paXlh?=
 =?utf-8?B?cFhrckdxdXZ6WmUrQ3VTNExzZytpK0F6azE0Tzc2LzF0SE93aFRFQzl0V3Q4?=
 =?utf-8?B?bUlQK2J4Z0ozbUhvWWhRcGtzMmgweEo3ZGlnN3B2V28zcjlncXIzZjk0Q2pS?=
 =?utf-8?B?dzJYSW5tZEI4OUN6Q3FJWjB1YU9EeXJpRlNVY0hNY2lvbUtqNXdlNUR4YW93?=
 =?utf-8?B?dTdzWXlsVGJPUlh6aWV4d3lNUVRVd1RwMTRQY3dxTGZTT2prWFJYOUQ5bVE4?=
 =?utf-8?B?VnROTUZjdlZOa0Ntd0s0ZkVWY3Fhd0pDL2ZIaC9PMGFFZ2o1RjdPYkg2YXIv?=
 =?utf-8?B?cE5OWWJiaTlWVGtQc3FFYkdLZlJ2VjRGMnN0OGlOaUhRT2FoNTZTL3pCMWtq?=
 =?utf-8?B?cUcyb3lLSDNXcGVqQ25ueWlYTVJhNmxMeHBXb3Avd091TzZPYkJOc3VKamhM?=
 =?utf-8?Q?lHy7o4UXGkE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVBZbnh3anpmMUJLTmpFY3cwM3VNQkpWRzcvYjdvZUpPSzAyTWtJYmdGKzJQ?=
 =?utf-8?B?Zk00WDVpOTRwdms5UDFSL29QdkhHMm1QT2UwN0pEbXFPOU02cVREUWkrRXRq?=
 =?utf-8?B?c28yS2NDSEJRaWk3L21leUY5K0cxS09oUTFJOGpoUlBUOVE0WVltT2JRdWRW?=
 =?utf-8?B?RHl0TGdzS2FncVJTbk1sODR4c0xMdGpBVXVhMHkybnlQOUN2UmlyTm1ycEJM?=
 =?utf-8?B?TVVWdmdTNWJaNGdKZ01KMXpxaXk5RTh4Tmw4Nm5kVjJlMWVZQUVvNzZla3JJ?=
 =?utf-8?B?cG5aekhaL3I5UU85ZlN3bDA0cmNKMlVVZVl0VWJ5MDZUR2YwZnpzK2hZalY1?=
 =?utf-8?B?T2FycVFham1KNWtQN1hLdnBDYTVXb2hqaFZ3RDdlbk9EOFFpNVhUY1hGeDNq?=
 =?utf-8?B?QkZWdTFhZE0wZkFuRVdlRWtIRTN3V0FGNUdheHFTRUM2VUhQRVVwbTRzTHJH?=
 =?utf-8?B?MktzdWltcjRrTWRNOFRXUUh0TlNpellHeUgyVWJYc0ZxWTJkazRwS1pIRTVp?=
 =?utf-8?B?elBkdWlpVThsei9uOUgvL3FrZDZpdUlyR1VBbkxFVkFiQ0Z5VVlPeEhFSjhp?=
 =?utf-8?B?NGE1c0hYZXdsNTFCM3J3SjRKYTJiUUM2dmF3MkNpVW5KNEcvQUxYRjVpVzRO?=
 =?utf-8?B?YUFkYjlBbysxendSNVQzUXNmQ0c4RHlkNUVxMFdFQjVtZWZVWVc0TFJMd0Ry?=
 =?utf-8?B?ankycWpmekpPMExIZDVob0pUN2hXSUVnVi9lV1JzMDBYT05oNU9GMVN5WFl6?=
 =?utf-8?B?bDc4OW56WjNrVURlc3JWWTZvQXRzYzE1Q3p1bXNwQS80R1Z0bXVET0FIeVZt?=
 =?utf-8?B?V25MbVluaktVTkIvMkNVWUNmYUVMSlVUREU4VS9CNjBIUGM4bWRjaGZ0dmlw?=
 =?utf-8?B?U2hPYVc2cFg2Qzh6d1F5UTFhMnFMdHJkanhQbjFCQ2dzQzd2MVhyU2J0UjZY?=
 =?utf-8?B?dTRuai8ycnM1MWYrZVFjQXgrZTd5Y0pTSCtLd0xoTzE2NE5aVkRwOTNZbEpX?=
 =?utf-8?B?VEt1dXNsQjYra29qR0hiTzBTZjA0djR4amtNZUxDSTI3QWhuQ1I1cDQ5N0Yx?=
 =?utf-8?B?MUhuYkc2WEh4cDZncmZmNmxQZ0J3TFlzZjU0dWUvekJUemZuU0QzWm9mYkV5?=
 =?utf-8?B?S0RVR2hHMUdhc0FZTDZPQUh3enVMMUNBbVpxSTZhZXpKakU4ZW5pNy9zcmpN?=
 =?utf-8?B?NlBCQmtpTXAyOE5nRktHd2JiRXZ4eUR6UVhYc0FOWDFydzJrWFJPWWVYekp2?=
 =?utf-8?B?a0xVMUN2T2kzY25DL0xPak5jUG5hM2FKTk5vdlhkWWMvL2lGcy9mQzNiQ3R0?=
 =?utf-8?B?MUtxTy9ncHpDVmtUNllRaWtmT21uQkpjREtRMnhuZW5yUCsxQVhCWk5ydDlM?=
 =?utf-8?B?WmxFQ1NJdzUwSG1Dc1dFTk93QndyTkdmSEs3anQ3QlcrdjFXSUFKbisxUllF?=
 =?utf-8?B?MWhHUStqVUtxSG9JRUZSTVFjSlNSODQ1ZG0veXVKTURweE9Xemd3eE0yTXVD?=
 =?utf-8?B?bXh5WDF5OVlCY0V4S0l3ak1LMnBCZEVnUjdXNldNS0s3ckwxbFNTYXRQUUtN?=
 =?utf-8?B?QlBEWHU4QlhGMUo1aS92WWR5bHVwdW11NVlsbFJFZG9rbkJJN2FBUk1xRjJO?=
 =?utf-8?B?cXVZb1gwVE56U2dwUDE3U1ltcWUwaVVxTDR6dWgvak5LUDA3K3BDaGovL3cr?=
 =?utf-8?B?Sk11ZGp2Z3I5azlhdlJoMlViR3UxUTM3aTBVZ3pTcXJMQVoxUXM4UFcwdzk0?=
 =?utf-8?B?ZXBuYURpMEFIVE11alhRNG9iZzVMTnJzRFRHUnRzZkQ0Yk9VQmRBYUkwQ2Y4?=
 =?utf-8?B?Nlg3aElFNzdtYjFGRjJMRUp6cEZGOWNSL1pPTWMvWHpnNGZiRzNwYnlKdThj?=
 =?utf-8?B?TXcwM1pjY3RUZ0dab3J5a0hxbnJUcTRTL3NidStDc1c5Tm12Q1A4VFM3dVBW?=
 =?utf-8?B?VE5WYTBYR1gwbUt4Q0tKaVltTHM4dEs2TXpwWTlSK2xRQW84TTJxczFFV2x5?=
 =?utf-8?B?dTlKS25vbXMxOXluRWtUdjBrand1d0diTU5NSDNFZnQzZEpZTXVTUlRodUlj?=
 =?utf-8?B?UU16STN3VTRJdnVXVmRZemtUeEJhNjlvbXhPM3lyYi8xS3Yyc2RPT2RLNXZO?=
 =?utf-8?Q?xd6VbfbCUWfQic15DO0t+2fLa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78094907-f15b-41e5-147b-08dd7addce29
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:02.4914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 48gQn+0XunOhVU+MqRSjub0KGHGKAfPj6ZMfWybXiTLlPYD31NrbC2qWhPBbQJVxVujBZfndmNZ2e/El4ay0tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

A dynamic capacity device (DCD) sends events to signal the host for
changes in the availability of Dynamic Capacity (DC) memory.  These
events contain extents describing a DPA range and meta data for memory
to be added or removed.  Events may be sent from the device at any time.

Three types of events can be signaled, Add, Release, and Force Release.

On add, the host may accept or reject the memory being offered.  If no
region exists, or the extent is invalid, the extent should be rejected.
Add extent events may be grouped by a 'more' bit which indicates those
extents should be processed as a group.

On remove, the host can delay the response until the host is safely not
using the memory.  If no region exists the release can be sent
immediately.  The host may also release extents (or partial extents) at
any time.  Thus the 'more' bit grouping of release events is of less
value and can be ignored in favor of sending multiple release capacity
responses for groups of release events.

Force removal is intended as a mechanism between the FM and the device
and intended only when the host is unresponsive, out of sync, or
otherwise broken.  Purposely ignore force removal events.

Regions are made up of one or more devices which may be surfacing memory
to the host.  Once all devices in a region have surfaced an extent the
region can expose a corresponding extent for the user to consume.
Without interleaving a device extent forms a 1:1 relationship with the
region extent.  Immediately surface a region extent upon getting a
device extent.

Per the specification the device is allowed to offer or remove extents
at any time.  However, anticipated use cases can expect extents to be
offered, accepted, and removed in well defined chunks.

Simplify extent tracking with the following restrictions.

	1) Flag for removal any extent which overlaps a requested
	   release range.
	2) Refuse the offer of extents which overlap already accepted
	   memory ranges.
	3) Accept again a range which has already been accepted by the
	   host.  Eating duplicates serves three purposes.
	   3a) This simplifies the code if the device should get out of
	       sync with the host.  And it should be safe to acknowledge
	       the extent again.
	   3b) This simplifies the code to process existing extents if
	       the extent list should change while the extent list is
	       being read.
	   3c) Duplicates for a given partition which are seen during a
	       race between the hardware surfacing an extent and the cxl
	       dax driver scanning for existing extents will be ignored.

	   NOTE: Processing existing extents is done in a later patch.

Management of the region extent devices must be synchronized with
potential uses of the memory within the DAX layer.  Create region extent
devices as children of the cxl_dax_region device such that the DAX
region driver can co-drive them and synchronize with the DAX layer.
Synchronization and management is handled in a subsequent patch.

Tag support within the DAX layer is not yet supported.  To maintain
compatibility with legacy DAX/region processing only tags with a value
of 0 are allowed.  This defines existing DAX devices as having a 0 tag
which makes the most logical sense as a default.

Process DCD events and create region devices.

Based on an original patch by Navneet Singh.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: rebase]
[djbw: s/region/partition/]
[iweiny: Adapt to new partition arch]
[iweiny: s/tag/uuid/ throughout the code]
---
 drivers/cxl/core/Makefile |   2 +-
 drivers/cxl/core/core.h   |  13 ++
 drivers/cxl/core/extent.c | 366 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/core/mbox.c   | 292 +++++++++++++++++++++++++++++++++++-
 drivers/cxl/core/region.c |   3 +
 drivers/cxl/cxl.h         |  53 ++++++-
 drivers/cxl/cxlmem.h      |  27 ++++
 include/cxl/event.h       |  31 ++++
 tools/testing/cxl/Kbuild  |   3 +-
 9 files changed, 786 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index 086df97a0fcf..792ac799f39d 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -17,6 +17,6 @@ cxl_core-y += cdat.o
 cxl_core-y += ras.o
 cxl_core-y += acpi.o
 cxl_core-$(CONFIG_TRACING) += trace.o
-cxl_core-$(CONFIG_CXL_REGION) += region.o
+cxl_core-$(CONFIG_CXL_REGION) += region.o extent.o
 cxl_core-$(CONFIG_CXL_MCE) += mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += features.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 76e23ec03fb4..1272be497926 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -45,12 +45,24 @@ struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
 u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
 
+int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent);
+int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent);
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
 				 const struct cxl_memdev *cxlmd, u64 dpa)
 {
 	return ULLONG_MAX;
 }
+static inline int cxl_add_extent(struct cxl_memdev_state *mds,
+				   struct cxl_extent *extent)
+{
+	return 0;
+}
+static inline int cxl_rm_extent(struct cxl_memdev_state *mds,
+				struct cxl_extent *extent)
+{
+	return 0;
+}
 static inline
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
 				     struct cxl_endpoint_decoder **cxled)
@@ -129,6 +141,7 @@ int cxl_update_hmat_access_coordinates(int nid, struct cxl_region *cxlr,
 bool cxl_need_node_perf_attrs_update(int nid);
 int cxl_port_get_switch_dport_bandwidth(struct cxl_port *port,
 					struct access_coordinate *c);
+void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range);
 
 int cxl_ras_init(void);
 void cxl_ras_exit(void);
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
new file mode 100644
index 000000000000..6df277caf974
--- /dev/null
+++ b/drivers/cxl/core/extent.c
@@ -0,0 +1,366 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  Copyright(c) 2024 Intel Corporation. All rights reserved. */
+
+#include <linux/device.h>
+#include <cxl.h>
+
+#include "core.h"
+
+static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
+				 struct cxled_extent *ed_extent)
+{
+	struct cxl_memdev_state *mds = cxled_to_mds(cxled);
+	struct device *dev = &cxled->cxld.dev;
+
+	dev_dbg(dev, "Remove extent %pra (%pU)\n",
+		&ed_extent->dpa_range, &ed_extent->uuid);
+	memdev_release_extent(mds, &ed_extent->dpa_range);
+	kfree(ed_extent);
+}
+
+static void free_region_extent(struct region_extent *region_extent)
+{
+	struct cxled_extent *ed_extent;
+	unsigned long index;
+
+	/*
+	 * Remove from each endpoint decoder the extent which backs this region
+	 * extent
+	 */
+	xa_for_each(&region_extent->decoder_extents, index, ed_extent)
+		cxled_release_extent(ed_extent->cxled, ed_extent);
+	xa_destroy(&region_extent->decoder_extents);
+	ida_free(&region_extent->cxlr_dax->extent_ida, region_extent->dev.id);
+	kfree(region_extent);
+}
+
+static void region_extent_release(struct device *dev)
+{
+	struct region_extent *region_extent = to_region_extent(dev);
+
+	free_region_extent(region_extent);
+}
+
+static const struct device_type region_extent_type = {
+	.name = "extent",
+	.release = region_extent_release,
+};
+
+bool is_region_extent(struct device *dev)
+{
+	return dev->type == &region_extent_type;
+}
+EXPORT_SYMBOL_NS_GPL(is_region_extent, "CXL");
+
+static void region_extent_unregister(void *ext)
+{
+	struct region_extent *region_extent = ext;
+
+	dev_dbg(&region_extent->dev, "DAX region rm extent HPA %pra\n",
+		&region_extent->hpa_range);
+	device_unregister(&region_extent->dev);
+}
+
+static void region_rm_extent(struct region_extent *region_extent)
+{
+	struct device *region_dev = region_extent->dev.parent;
+
+	devm_release_action(region_dev, region_extent_unregister, region_extent);
+}
+
+static struct region_extent *
+alloc_region_extent(struct cxl_dax_region *cxlr_dax, struct range *hpa_range,
+		    uuid_t *uuid)
+{
+	int id;
+
+	struct region_extent *region_extent __free(kfree) =
+				kzalloc(sizeof(*region_extent), GFP_KERNEL);
+	if (!region_extent)
+		return ERR_PTR(-ENOMEM);
+
+	id = ida_alloc(&cxlr_dax->extent_ida, GFP_KERNEL);
+	if (id < 0)
+		return ERR_PTR(-ENOMEM);
+
+	region_extent->hpa_range = *hpa_range;
+	region_extent->cxlr_dax = cxlr_dax;
+	uuid_copy(&region_extent->uuid, uuid);
+	region_extent->dev.id = id;
+	xa_init(&region_extent->decoder_extents);
+	return no_free_ptr(region_extent);
+}
+
+static int online_region_extent(struct region_extent *region_extent)
+{
+	struct cxl_dax_region *cxlr_dax = region_extent->cxlr_dax;
+	struct device *dev = &region_extent->dev;
+	int rc;
+
+	device_initialize(dev);
+	device_set_pm_not_required(dev);
+	dev->parent = &cxlr_dax->dev;
+	dev->type = &region_extent_type;
+	rc = dev_set_name(dev, "extent%d.%d", cxlr_dax->cxlr->id, dev->id);
+	if (rc)
+		goto err;
+
+	rc = device_add(dev);
+	if (rc)
+		goto err;
+
+	dev_dbg(dev, "region extent HPA %pra\n", &region_extent->hpa_range);
+	return devm_add_action_or_reset(&cxlr_dax->dev, region_extent_unregister,
+					region_extent);
+
+err:
+	dev_err(&cxlr_dax->dev, "Failed to initialize region extent HPA %pra\n",
+		&region_extent->hpa_range);
+
+	put_device(dev);
+	return rc;
+}
+
+struct match_data {
+	struct cxl_endpoint_decoder *cxled;
+	struct range *new_range;
+};
+
+static int match_contains(struct device *dev, const void *data)
+{
+	struct region_extent *region_extent = to_region_extent(dev);
+	const struct match_data *md = data;
+	struct cxled_extent *entry;
+	unsigned long index;
+
+	if (!region_extent)
+		return 0;
+
+	xa_for_each(&region_extent->decoder_extents, index, entry) {
+		if (md->cxled == entry->cxled &&
+		    range_contains(&entry->dpa_range, md->new_range))
+			return 1;
+	}
+	return 0;
+}
+
+static bool extents_contain(struct cxl_dax_region *cxlr_dax,
+			    struct cxl_endpoint_decoder *cxled,
+			    struct range *new_range)
+{
+	struct match_data md = {
+		.cxled = cxled,
+		.new_range = new_range,
+	};
+
+	struct device *extent_device __free(put_device)
+			= device_find_child(&cxlr_dax->dev, &md, match_contains);
+	if (!extent_device)
+		return false;
+
+	return true;
+}
+
+static int match_overlaps(struct device *dev, const void *data)
+{
+	struct region_extent *region_extent = to_region_extent(dev);
+	const struct match_data *md = data;
+	struct cxled_extent *entry;
+	unsigned long index;
+
+	if (!region_extent)
+		return 0;
+
+	xa_for_each(&region_extent->decoder_extents, index, entry) {
+		if (md->cxled == entry->cxled &&
+		    range_overlaps(&entry->dpa_range, md->new_range))
+			return 1;
+	}
+
+	return 0;
+}
+
+static bool extents_overlap(struct cxl_dax_region *cxlr_dax,
+			    struct cxl_endpoint_decoder *cxled,
+			    struct range *new_range)
+{
+	struct match_data md = {
+		.cxled = cxled,
+		.new_range = new_range,
+	};
+
+	struct device *extent_device __free(put_device)
+			= device_find_child(&cxlr_dax->dev, &md, match_overlaps);
+	if (!extent_device)
+		return false;
+
+	return true;
+}
+
+static void calc_hpa_range(struct cxl_endpoint_decoder *cxled,
+			   struct cxl_dax_region *cxlr_dax,
+			   struct range *dpa_range,
+			   struct range *hpa_range)
+{
+	resource_size_t dpa_offset, hpa;
+
+	dpa_offset = dpa_range->start - cxled->dpa_res->start;
+	hpa = cxled->cxld.hpa_range.start + dpa_offset;
+
+	hpa_range->start = hpa - cxlr_dax->hpa_range.start;
+	hpa_range->end = hpa_range->start + range_len(dpa_range) - 1;
+}
+
+static int cxlr_rm_extent(struct device *dev, void *data)
+{
+	struct region_extent *region_extent = to_region_extent(dev);
+	struct range *region_hpa_range = data;
+
+	if (!region_extent)
+		return 0;
+
+	/*
+	 * Any extent which 'touches' the released range is removed.
+	 */
+	if (range_overlaps(region_hpa_range, &region_extent->hpa_range)) {
+		dev_dbg(dev, "Remove region extent HPA %pra\n",
+			&region_extent->hpa_range);
+		region_rm_extent(region_extent);
+	}
+	return 0;
+}
+
+int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
+{
+	u64 start_dpa = le64_to_cpu(extent->start_dpa);
+	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
+	struct cxl_endpoint_decoder *cxled;
+	struct range hpa_range, dpa_range;
+	struct cxl_region *cxlr;
+
+	dpa_range = (struct range) {
+		.start = start_dpa,
+		.end = start_dpa + le64_to_cpu(extent->length) - 1,
+	};
+
+	guard(rwsem_read)(&cxl_region_rwsem);
+	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
+	if (!cxlr) {
+		/*
+		 * No region can happen here for a few reasons:
+		 *
+		 * 1) Extents were accepted and the host crashed/rebooted
+		 *    leaving them in an accepted state.  On reboot the host
+		 *    has not yet created a region to own them.
+		 *
+		 * 2) Region destruction won the race with the device releasing
+		 *    all the extents.  Here the release will be a duplicate of
+		 *    the one sent via region destruction.
+		 *
+		 * 3) The device is confused and releasing extents for which no
+		 *    region ever existed.
+		 *
+		 * In all these cases make sure the device knows we are not
+		 * using this extent.
+		 */
+		memdev_release_extent(mds, &dpa_range);
+		return -ENXIO;
+	}
+
+	calc_hpa_range(cxled, cxlr->cxlr_dax, &dpa_range, &hpa_range);
+
+	/* Remove region extents which overlap */
+	return device_for_each_child(&cxlr->cxlr_dax->dev, &hpa_range,
+				     cxlr_rm_extent);
+}
+
+static int cxlr_add_extent(struct cxl_dax_region *cxlr_dax,
+			   struct cxl_endpoint_decoder *cxled,
+			   struct cxled_extent *ed_extent)
+{
+	struct region_extent *region_extent;
+	struct range hpa_range;
+	int rc;
+
+	calc_hpa_range(cxled, cxlr_dax, &ed_extent->dpa_range, &hpa_range);
+
+	region_extent = alloc_region_extent(cxlr_dax, &hpa_range, &ed_extent->uuid);
+	if (IS_ERR(region_extent))
+		return PTR_ERR(region_extent);
+
+	rc = xa_insert(&region_extent->decoder_extents, (unsigned long)ed_extent,
+		       ed_extent, GFP_KERNEL);
+	if (rc) {
+		free_region_extent(region_extent);
+		return rc;
+	}
+
+	/* device model handles freeing region_extent */
+	return online_region_extent(region_extent);
+}
+
+/* Callers are expected to ensure cxled has been attached to a region */
+int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
+{
+	u64 start_dpa = le64_to_cpu(extent->start_dpa);
+	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
+	struct cxl_endpoint_decoder *cxled;
+	struct range ed_range, ext_range;
+	struct cxl_dax_region *cxlr_dax;
+	struct cxled_extent *ed_extent;
+	struct cxl_region *cxlr;
+	struct device *dev;
+
+	ext_range = (struct range) {
+		.start = start_dpa,
+		.end = start_dpa + le64_to_cpu(extent->length) - 1,
+	};
+
+	guard(rwsem_read)(&cxl_region_rwsem);
+	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
+	if (!cxlr)
+		return -ENXIO;
+
+	cxlr_dax = cxled->cxld.region->cxlr_dax;
+	dev = &cxled->cxld.dev;
+	ed_range = (struct range) {
+		.start = cxled->dpa_res->start,
+		.end = cxled->dpa_res->end,
+	};
+
+	dev_dbg(&cxled->cxld.dev, "Checking ED (%pr) for extent %pra\n",
+		cxled->dpa_res, &ext_range);
+
+	if (!range_contains(&ed_range, &ext_range)) {
+		dev_err_ratelimited(dev,
+				    "DC extent DPA %pra (%pU) is not fully in ED %pra\n",
+				    &ext_range, extent->uuid, &ed_range);
+		return -ENXIO;
+	}
+
+	/*
+	 * Allowing duplicates or extents which are already in an accepted
+	 * range simplifies extent processing, especially when dealing with the
+	 * cxl dax driver scanning for existing extents.
+	 */
+	if (extents_contain(cxlr_dax, cxled, &ext_range)) {
+		dev_warn_ratelimited(dev, "Extent %pra exists; accept again\n",
+				     &ext_range);
+		return 0;
+	}
+
+	if (extents_overlap(cxlr_dax, cxled, &ext_range))
+		return -ENXIO;
+
+	ed_extent = kzalloc(sizeof(*ed_extent), GFP_KERNEL);
+	if (!ed_extent)
+		return -ENOMEM;
+
+	ed_extent->cxled = cxled;
+	ed_extent->dpa_range = ext_range;
+	import_uuid(&ed_extent->uuid, extent->uuid);
+
+	dev_dbg(dev, "Add extent %pra (%pU)\n", &ed_extent->dpa_range, &ed_extent->uuid);
+
+	return cxlr_add_extent(cxlr_dax, cxled, ed_extent);
+}
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index b3dd119d166a..de01c6684530 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -930,6 +930,60 @@ int cxl_enumerate_cmds(struct cxl_memdev_state *mds)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_enumerate_cmds, "CXL");
 
+static int cxl_validate_extent(struct cxl_memdev_state *mds,
+			       struct cxl_extent *extent)
+{
+	struct cxl_dev_state *cxlds = &mds->cxlds;
+	struct device *dev = mds->cxlds.dev;
+	u64 start, length;
+
+	start = le64_to_cpu(extent->start_dpa);
+	length = le64_to_cpu(extent->length);
+
+	struct range ext_range = (struct range){
+		.start = start,
+		.end = start + length - 1,
+	};
+
+	if (le16_to_cpu(extent->shared_extn_seq) != 0) {
+		dev_err_ratelimited(dev,
+				    "DC extent DPA %pra (%pU) can not be shared\n",
+				    &ext_range, extent->uuid);
+		return -ENXIO;
+	}
+
+	if (!uuid_is_null((const uuid_t *)extent->uuid)) {
+		dev_err_ratelimited(dev,
+				    "DC extent DPA %pra (%pU); tags not supported\n",
+				    &ext_range, extent->uuid);
+		return -ENXIO;
+	}
+
+	/* Extents must be within the DC partition boundary */
+	for (int i = 0; i < cxlds->nr_partitions; i++) {
+		struct cxl_dpa_partition *part = &cxlds->part[i];
+
+		if (part->mode != CXL_PARTMODE_DYNAMIC_RAM_A)
+			continue;
+
+		struct range partition_range = (struct range) {
+			.start = part->res.start,
+			.end = part->res.end,
+		};
+
+		if (range_contains(&partition_range, &ext_range)) {
+			dev_dbg(dev, "DC extent DPA %pra (DCR:%pra)(%pU)\n",
+				&ext_range, &partition_range, extent->uuid);
+			return 0;
+		}
+	}
+
+	dev_err_ratelimited(dev,
+			    "DC extent DPA %pra (%pU) is not in a valid DC partition\n",
+			    &ext_range, extent->uuid);
+	return -ENXIO;
+}
+
 void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
 			    enum cxl_event_log_type type,
 			    enum cxl_event_type event_type,
@@ -1064,6 +1118,221 @@ static int cxl_clear_event_record(struct cxl_memdev_state *mds,
 	return rc;
 }
 
+static int send_one_response(struct cxl_mailbox *cxl_mbox,
+			     struct cxl_mbox_dc_response *response,
+			     int opcode, u32 extent_list_size, u8 flags)
+{
+	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
+		.opcode = opcode,
+		.size_in = struct_size(response, extent_list, extent_list_size),
+		.payload_in = response,
+	};
+
+	response->extent_list_size = cpu_to_le32(extent_list_size);
+	response->flags = flags;
+	return cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
+}
+
+static int cxl_send_dc_response(struct cxl_memdev_state *mds, int opcode,
+				struct xarray *extent_array, int cnt)
+{
+	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
+	struct cxl_mbox_dc_response *p;
+	struct cxl_extent *extent;
+	unsigned long index;
+	u32 pl_index;
+
+	size_t pl_size = struct_size(p, extent_list, cnt);
+	u32 max_extents = cnt;
+
+	/* May have to use more bit on response. */
+	if (pl_size > cxl_mbox->payload_size) {
+		max_extents = (cxl_mbox->payload_size - sizeof(*p)) /
+			      sizeof(struct updated_extent_list);
+		pl_size = struct_size(p, extent_list, max_extents);
+	}
+
+	struct cxl_mbox_dc_response *response __free(kfree) =
+						kzalloc(pl_size, GFP_KERNEL);
+	if (!response)
+		return -ENOMEM;
+
+	if (cnt == 0)
+		return send_one_response(cxl_mbox, response, opcode, 0, 0);
+
+	pl_index = 0;
+	xa_for_each(extent_array, index, extent) {
+		response->extent_list[pl_index].dpa_start = extent->start_dpa;
+		response->extent_list[pl_index].length = extent->length;
+		pl_index++;
+
+		if (pl_index == max_extents) {
+			u8 flags = 0;
+			int rc;
+
+			if (pl_index < cnt)
+				flags |= CXL_DCD_EVENT_MORE;
+			rc = send_one_response(cxl_mbox, response, opcode,
+					       pl_index, flags);
+			if (rc)
+				return rc;
+			cnt -= pl_index;
+			pl_index = 0;
+		}
+	}
+
+	if (!pl_index) /* nothing more to do */
+		return 0;
+	return send_one_response(cxl_mbox, response, opcode, pl_index, 0);
+}
+
+void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range)
+{
+	struct device *dev = mds->cxlds.dev;
+	struct xarray extent_list;
+
+	struct cxl_extent extent = {
+		.start_dpa = cpu_to_le64(range->start),
+		.length = cpu_to_le64(range_len(range)),
+	};
+
+	dev_dbg(dev, "Release response dpa %pra\n", &range);
+
+	xa_init(&extent_list);
+	if (xa_insert(&extent_list, 0, &extent, GFP_KERNEL)) {
+		dev_dbg(dev, "Failed to release %pra\n", &range);
+		goto destroy;
+	}
+
+	if (cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC, &extent_list, 1))
+		dev_dbg(dev, "Failed to release %pra\n", &range);
+
+destroy:
+	xa_destroy(&extent_list);
+}
+
+static int validate_add_extent(struct cxl_memdev_state *mds,
+			       struct cxl_extent *extent)
+{
+	int rc;
+
+	rc = cxl_validate_extent(mds, extent);
+	if (rc)
+		return rc;
+
+	return cxl_add_extent(mds, extent);
+}
+
+static int cxl_add_pending(struct cxl_memdev_state *mds)
+{
+	struct device *dev = mds->cxlds.dev;
+	struct cxl_extent *extent;
+	unsigned long cnt = 0;
+	unsigned long index;
+	int rc;
+
+	xa_for_each(&mds->pending_extents, index, extent) {
+		if (validate_add_extent(mds, extent)) {
+			/*
+			 * Any extents which are to be rejected are omitted from
+			 * the response.  An empty response means all are
+			 * rejected.
+			 */
+			dev_dbg(dev, "unconsumed DC extent DPA:%#llx LEN:%#llx\n",
+				le64_to_cpu(extent->start_dpa),
+				le64_to_cpu(extent->length));
+			xa_erase(&mds->pending_extents, index);
+			kfree(extent);
+			continue;
+		}
+		cnt++;
+	}
+	rc = cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
+				  &mds->pending_extents, cnt);
+	xa_for_each(&mds->pending_extents, index, extent) {
+		xa_erase(&mds->pending_extents, index);
+		kfree(extent);
+	}
+	return rc;
+}
+
+static int handle_add_event(struct cxl_memdev_state *mds,
+			    struct cxl_event_dcd *event)
+{
+	struct device *dev = mds->cxlds.dev;
+	struct cxl_extent *extent;
+
+	extent = kmemdup(&event->extent, sizeof(*extent), GFP_KERNEL);
+	if (!extent)
+		return -ENOMEM;
+
+	if (xa_insert(&mds->pending_extents, (unsigned long)extent, extent,
+		      GFP_KERNEL)) {
+		kfree(extent);
+		return -ENOMEM;
+	}
+
+	if (event->flags & CXL_DCD_EVENT_MORE) {
+		dev_dbg(dev, "more bit set; delay the surfacing of extent\n");
+		return 0;
+	}
+
+	/* extents are removed and free'ed in cxl_add_pending() */
+	return cxl_add_pending(mds);
+}
+
+static char *cxl_dcd_evt_type_str(u8 type)
+{
+	switch (type) {
+	case DCD_ADD_CAPACITY:
+		return "add";
+	case DCD_RELEASE_CAPACITY:
+		return "release";
+	case DCD_FORCED_CAPACITY_RELEASE:
+		return "force release";
+	default:
+		break;
+	}
+
+	return "<unknown>";
+}
+
+static void cxl_handle_dcd_event_records(struct cxl_memdev_state *mds,
+					struct cxl_event_record_raw *raw_rec)
+{
+	struct cxl_event_dcd *event = &raw_rec->event.dcd;
+	struct cxl_extent *extent = &event->extent;
+	struct device *dev = mds->cxlds.dev;
+	uuid_t *id = &raw_rec->id;
+	int rc;
+
+	if (!uuid_equal(id, &CXL_EVENT_DC_EVENT_UUID))
+		return;
+
+	dev_dbg(dev, "DCD event %s : DPA:%#llx LEN:%#llx\n",
+		cxl_dcd_evt_type_str(event->event_type),
+		le64_to_cpu(extent->start_dpa), le64_to_cpu(extent->length));
+
+	switch (event->event_type) {
+	case DCD_ADD_CAPACITY:
+		rc = handle_add_event(mds, event);
+		break;
+	case DCD_RELEASE_CAPACITY:
+		rc = cxl_rm_extent(mds, &event->extent);
+		break;
+	case DCD_FORCED_CAPACITY_RELEASE:
+		dev_err_ratelimited(dev, "Forced release event ignored.\n");
+		rc = 0;
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+
+	if (rc)
+		dev_err_ratelimited(dev, "dcd event failed: %d\n", rc);
+}
+
 static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
 				    enum cxl_event_log_type type)
 {
@@ -1100,9 +1369,13 @@ static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
 		if (!nr_rec)
 			break;
 
-		for (i = 0; i < nr_rec; i++)
+		for (i = 0; i < nr_rec; i++) {
 			__cxl_event_trace_record(cxlmd, type,
 						 &payload->records[i]);
+			if (type == CXL_EVENT_TYPE_DCD)
+				cxl_handle_dcd_event_records(mds,
+							&payload->records[i]);
+		}
 
 		if (payload->flags & CXL_GET_EVENT_FLAG_OVERFLOW)
 			trace_cxl_overflow(cxlmd, type, payload);
@@ -1134,6 +1407,8 @@ void cxl_mem_get_event_records(struct cxl_memdev_state *mds, u32 status)
 {
 	dev_dbg(mds->cxlds.dev, "Reading event logs: %x\n", status);
 
+	if (cxl_dcd_supported(mds) && (status & CXLDEV_EVENT_STATUS_DCD))
+		cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_DCD);
 	if (status & CXLDEV_EVENT_STATUS_FATAL)
 		cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_FATAL);
 	if (status & CXLDEV_EVENT_STATUS_FAIL)
@@ -1709,6 +1984,17 @@ int cxl_mailbox_init(struct cxl_mailbox *cxl_mbox, struct device *host)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_mailbox_init, "CXL");
 
+static void clear_pending_extents(void *_mds)
+{
+	struct cxl_memdev_state *mds = _mds;
+	struct cxl_extent *extent;
+	unsigned long index;
+
+	xa_for_each(&mds->pending_extents, index, extent)
+		kfree(extent);
+	xa_destroy(&mds->pending_extents);
+}
+
 struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev)
 {
 	struct cxl_memdev_state *mds;
@@ -1726,6 +2012,10 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev)
 	mds->cxlds.cxl_mbox.host = dev;
 	mds->cxlds.reg_map.resource = CXL_RESOURCE_NONE;
 	mds->cxlds.type = CXL_DEVTYPE_CLASSMEM;
+	xa_init(&mds->pending_extents);
+	rc = devm_add_action_or_reset(dev, clear_pending_extents, mds);
+	if (rc)
+		return ERR_PTR(rc);
 
 	rc = devm_cxl_register_mce_notifier(dev, &mds->mce_notifier);
 	if (rc == -EOPNOTSUPP)
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 9c573e8d6ed7..3106df6f3636 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3048,6 +3048,7 @@ static void cxl_dax_region_release(struct device *dev)
 {
 	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
 
+	ida_destroy(&cxlr_dax->extent_ida);
 	kfree(cxlr_dax);
 }
 
@@ -3097,6 +3098,8 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
 
 	dev = &cxlr_dax->dev;
 	cxlr_dax->cxlr = cxlr;
+	cxlr->cxlr_dax = cxlr_dax;
+	ida_init(&cxlr_dax->extent_ida);
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &cxl_dax_region_key);
 	device_set_pm_not_required(dev);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 4bb0ff4d8f5f..d027432b1572 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -11,6 +11,8 @@
 #include <linux/log2.h>
 #include <linux/node.h>
 #include <linux/io.h>
+#include <linux/xarray.h>
+#include <cxl/event.h>
 
 extern const struct nvdimm_security_ops *cxl_security_ops;
 
@@ -169,11 +171,13 @@ static inline int ways_to_eiw(unsigned int ways, u8 *eiw)
 #define CXLDEV_EVENT_STATUS_WARN		BIT(1)
 #define CXLDEV_EVENT_STATUS_FAIL		BIT(2)
 #define CXLDEV_EVENT_STATUS_FATAL		BIT(3)
+#define CXLDEV_EVENT_STATUS_DCD			BIT(4)
 
 #define CXLDEV_EVENT_STATUS_ALL (CXLDEV_EVENT_STATUS_INFO |	\
 				 CXLDEV_EVENT_STATUS_WARN |	\
 				 CXLDEV_EVENT_STATUS_FAIL |	\
-				 CXLDEV_EVENT_STATUS_FATAL)
+				 CXLDEV_EVENT_STATUS_FATAL |	\
+				 CXLDEV_EVENT_STATUS_DCD)
 
 /* CXL rev 3.0 section 8.2.9.2.4; Table 8-52 */
 #define CXLDEV_EVENT_INT_MODE_MASK	GENMASK(1, 0)
@@ -381,6 +385,18 @@ enum cxl_decoder_state {
 	CXL_DECODER_STATE_AUTO,
 };
 
+/**
+ * struct cxled_extent - Extent within an endpoint decoder
+ * @cxled: Reference to the endpoint decoder
+ * @dpa_range: DPA range this extent covers within the decoder
+ * @uuid: uuid from device for this extent
+ */
+struct cxled_extent {
+	struct cxl_endpoint_decoder *cxled;
+	struct range dpa_range;
+	uuid_t uuid;
+};
+
 /**
  * struct cxl_endpoint_decoder - Endpoint  / SPA to DPA decoder
  * @cxld: base cxl_decoder_object
@@ -512,6 +528,7 @@ enum cxl_partition_mode {
  * @type: Endpoint decoder target type
  * @cxl_nvb: nvdimm bridge for coordinating @cxlr_pmem setup / shutdown
  * @cxlr_pmem: (for pmem regions) cached copy of the nvdimm bridge
+ * @cxlr_dax: (for DC regions) cached copy of CXL DAX bridge
  * @flags: Region state flags
  * @params: active + config params for the region
  * @coord: QoS access coordinates for the region
@@ -525,6 +542,7 @@ struct cxl_region {
 	enum cxl_decoder_type type;
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct cxl_pmem_region *cxlr_pmem;
+	struct cxl_dax_region *cxlr_dax;
 	unsigned long flags;
 	struct cxl_region_params params;
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
@@ -566,12 +584,45 @@ struct cxl_pmem_region {
 	struct cxl_pmem_region_mapping mapping[];
 };
 
+/* See CXL 3.1 8.2.9.2.1.6 */
+enum dc_event {
+	DCD_ADD_CAPACITY,
+	DCD_RELEASE_CAPACITY,
+	DCD_FORCED_CAPACITY_RELEASE,
+	DCD_REGION_CONFIGURATION_UPDATED,
+};
+
 struct cxl_dax_region {
 	struct device dev;
 	struct cxl_region *cxlr;
 	struct range hpa_range;
+	struct ida extent_ida;
 };
 
+/**
+ * struct region_extent - CXL DAX region extent
+ * @dev: device representing this extent
+ * @cxlr_dax: back reference to parent region device
+ * @hpa_range: HPA range of this extent
+ * @uuid: uuid of the extent
+ * @decoder_extents: Endpoint decoder extents which make up this region extent
+ */
+struct region_extent {
+	struct device dev;
+	struct cxl_dax_region *cxlr_dax;
+	struct range hpa_range;
+	uuid_t uuid;
+	struct xarray decoder_extents;
+};
+
+bool is_region_extent(struct device *dev);
+static inline struct region_extent *to_region_extent(struct device *dev)
+{
+	if (!is_region_extent(dev))
+		return NULL;
+	return container_of(dev, struct region_extent, dev);
+}
+
 /**
  * struct cxl_port - logical collection of upstream port devices and
  *		     downstream port devices to construct a CXL memory
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 34a606c5ead0..63a38e449454 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -7,6 +7,7 @@
 #include <linux/cdev.h>
 #include <linux/uuid.h>
 #include <linux/node.h>
+#include <linux/xarray.h>
 #include <cxl/event.h>
 #include <cxl/mailbox.h>
 #include "cxl.h"
@@ -487,6 +488,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
  * @active_volatile_bytes: sum of hard + soft volatile
  * @active_persistent_bytes: sum of hard + soft persistent
  * @dcd_supported: all DCD commands are supported
+ * @pending_extents: array of extents pending during more bit processing
  * @event: event log driver state
  * @poison: poison driver state info
  * @security: security driver state info
@@ -507,6 +509,7 @@ struct cxl_memdev_state {
 	u64 active_volatile_bytes;
 	u64 active_persistent_bytes;
 	bool dcd_supported;
+	struct xarray pending_extents;
 
 	struct cxl_event_state event;
 	struct cxl_poison_state poison;
@@ -582,6 +585,21 @@ enum cxl_opcode {
 	UUID_INIT(0x5e1819d9, 0x11a9, 0x400c, 0x81, 0x1f, 0xd6, 0x07, 0x19,     \
 		  0x40, 0x3d, 0x86)
 
+/*
+ * Add Dynamic Capacity Response
+ * CXL rev 3.1 section 8.2.9.9.9.3; Table 8-168 & Table 8-169
+ */
+struct cxl_mbox_dc_response {
+	__le32 extent_list_size;
+	u8 flags;
+	u8 reserved[3];
+	struct updated_extent_list {
+		__le64 dpa_start;
+		__le64 length;
+		u8 reserved[8];
+	} __packed extent_list[];
+} __packed;
+
 struct cxl_mbox_get_supported_logs {
 	__le16 entries;
 	u8 rsvd[6];
@@ -644,6 +662,14 @@ struct cxl_mbox_identify {
 	UUID_INIT(0xfe927475, 0xdd59, 0x4339, 0xa5, 0x86, 0x79, 0xba, 0xb1, \
 		  0x13, 0xb7, 0x74)
 
+/*
+ * Dynamic Capacity Event Record
+ * CXL rev 3.1 section 8.2.9.2.1; Table 8-43
+ */
+#define CXL_EVENT_DC_EVENT_UUID                                             \
+	UUID_INIT(0xca95afa7, 0xf183, 0x4018, 0x8c, 0x2f, 0x95, 0x26, 0x8e, \
+		  0x10, 0x1a, 0x2a)
+
 /*
  * Get Event Records output payload
  * CXL rev 3.0 section 8.2.9.2.2; Table 8-50
@@ -669,6 +695,7 @@ enum cxl_event_log_type {
 	CXL_EVENT_TYPE_WARN,
 	CXL_EVENT_TYPE_FAIL,
 	CXL_EVENT_TYPE_FATAL,
+	CXL_EVENT_TYPE_DCD,
 	CXL_EVENT_TYPE_MAX
 };
 
diff --git a/include/cxl/event.h b/include/cxl/event.h
index f9ae1796da85..0c159eac4337 100644
--- a/include/cxl/event.h
+++ b/include/cxl/event.h
@@ -108,11 +108,42 @@ struct cxl_event_mem_module {
 	u8 reserved[0x2a];
 } __packed;
 
+/*
+ * CXL rev 3.1 section 8.2.9.2.1.6; Table 8-51
+ */
+struct cxl_extent {
+	__le64 start_dpa;
+	__le64 length;
+	u8 uuid[UUID_SIZE];
+	__le16 shared_extn_seq;
+	u8 reserved[0x6];
+} __packed;
+
+/*
+ * Dynamic Capacity Event Record
+ * CXL rev 3.1 section 8.2.9.2.1.6; Table 8-50
+ */
+#define CXL_DCD_EVENT_MORE			BIT(0)
+struct cxl_event_dcd {
+	struct cxl_event_record_hdr hdr;
+	u8 event_type;
+	u8 validity_flags;
+	__le16 host_id;
+	u8 partition_index;
+	u8 flags;
+	u8 reserved1[0x2];
+	struct cxl_extent extent;
+	u8 reserved2[0x18];
+	__le32 num_avail_extents;
+	__le32 num_avail_tags;
+} __packed;
+
 union cxl_event {
 	struct cxl_event_generic generic;
 	struct cxl_event_gen_media gen_media;
 	struct cxl_event_dram dram;
 	struct cxl_event_mem_module mem_module;
+	struct cxl_event_dcd dcd;
 	/* dram & gen_media event header */
 	struct cxl_event_media_hdr media_hdr;
 } __packed;
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 387f3df8b988..916f2b30e2f3 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -64,7 +64,8 @@ cxl_core-y += $(CXL_CORE_SRC)/cdat.o
 cxl_core-y += $(CXL_CORE_SRC)/ras.o
 cxl_core-y += $(CXL_CORE_SRC)/acpi.o
 cxl_core-$(CONFIG_TRACING) += $(CXL_CORE_SRC)/trace.o
-cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o
+cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o \
+				 $(CXL_CORE_SRC)/extent.o
 cxl_core-$(CONFIG_CXL_MCE) += $(CXL_CORE_SRC)/mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += $(CXL_CORE_SRC)/features.o
 cxl_core-y += config_check.o

-- 
2.49.0

