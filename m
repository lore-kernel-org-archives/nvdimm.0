Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50184210F49
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584761; cv=fail; b=YoIcrPCveyMs6E58b8wJ80QAtSmAzdSP+Q40BACMX3ex/Gs4Wbvipx+oCfX/OJUZ5rEHGq7ED9OzwDI62giO8owjd82JIVpYQ/I0ljqAjnAHDmwBf44nzb/rHR34iQXOYJ+EQZArjCR6KlDRIrQCYVHlaHcAfqgbLFv47lltWXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584761; c=relaxed/simple;
	bh=NA/pUKbWiPDsp+chBt4vNlq5Hcn+qvIslODyhCaMTEM=;
	h=From:Subject:Date:Message-ID:Content-Type:To:CC:MIME-Version; b=FwiDOvUpLqFzYP76EzlPooWJVCt8sB6OAGbVLYgXXRhivYrXCGIL3fVq06Q6O6ogAIDBW38zoymCEMzzgMl4lKgKDj/xEXXdP5l2/Oh+avUN09zA/bh66u2QScXL+VMZq/7GCnX5RnsdiZBc96mWs5UROqLY4JYtA/dXC3HVQiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EG3Tn+YI; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EG3Tn+YI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584759; x=1776120759;
  h=from:subject:date:message-id:content-transfer-encoding:
   to:cc:mime-version;
  bh=NA/pUKbWiPDsp+chBt4vNlq5Hcn+qvIslODyhCaMTEM=;
  b=EG3Tn+YInif1tfc9yEv38cuCUhQfW+AXU4kqzEBncyR3n1N/vW7iW70c
   IU/f/wB8EAJ4AbAHaTgdE0eUkj+iuD3RIcqCAIypd/EPINu/1EA/v6Tp1
   k3GYBH2PIKAyDSe5B/W/pNjf74R3kzL7UajzuZg8INJ1C09AaI/0UBzMv
   nwaubZlL/pN96hEmsrmmPnnQeXAQ5t1z63SRycTKXExVBT4dPS77Kdtx2
   ko4AC89xKzyXJYJE1aTbU4qZCkHF1GY3SathUz8DsuSQEb2xfqoWosCwi
   vKQNQcdcd6dpJh3+T6HrNhNx0pTMAfLE3jJTAdXwlqkYW0Hx1AkLcHrlk
   Q==;
X-CSE-ConnectionGUID: mUSsEX+ATgqYM6mM68TKqA==
X-CSE-MsgGUID: aZ+T7dbgTDSWkY3kILAP2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280976"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280976"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:39 -0700
X-CSE-ConnectionGUID: BchUkZa0SE+pB1MkC1P1wQ==
X-CSE-MsgGUID: DVhWJoTgTUCLBR7cSvxxIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657639"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:38 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J+HMGDHfBOhMR9bEhnITZSdQcf3brQIx8cSav7z/iA/+6Vxx+mCUtjKyrUbZoHGxdmZ7D0qTkSXILJlaBjyvZrSnX9IiLj35yKjuQV1Y6+8Hdncs8fK6BFOahZjbAhis+C0NNflj1KKBIPOxeDtQR9KFWj08QBRJh0mtEa2k7Nj5eXTdpbgkcQxbC4nLtswmUw1n4lcqNQevsJdNfT5+vaSwlJPpfndxkzK97Pr3Ti++4SY2b3FQshBins3L7yLu8seItYRVsSFk4FKxGNvo0eOQ+hUP4KxGvq3ih3uuwr2PL8iJMHPfisWUByGz8tAvcK+++PG7L+mJn3rBvPd1rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQgY7U9KHDWle90UER/NX+/Ejl7V3iDBWSqnVOPhHJ8=;
 b=gydd3ZkQp9VxpmXExVhnCWzutrHcA7xfPKBeBkE/ZQBkTovqGyWEVszFPqEO+o2HPDiEVQ2V86tKdrF+nVXPhsm/9Ae+aHUq0XCEW56L93O6ycvjDAr5KU5kUfTeVUXXyux1xRalu3G7zq6GhRVQvAZcac1P9kVvW39+SMqbUVLeO0JfP/eOWmrPEVEFQv0A2h6xrLu0HTOaxYFtRvhCct0mR3utX9uJMQjpagKgd97dLaSNM4vJy/kIcs70Zg3S8XGnuIkZ7wc505Z8SUn20egBQpSjfkpEf65jVE0uXF03GVFLJJmiOV7jI+gL8XoURe4XrQ7jN2m3DWUtByLTFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Sun, 13 Apr
 2025 22:52:34 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:34 +0000
From: Ira Weiny <ira.weiny@intel.com>
Subject: [ndctl PATCH v5 0/5] ndctl: Dynamic Capacity additions for cxl-cli
Date: Sun, 13 Apr 2025 17:52:57 -0500
Message-ID: <20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEpA/GcC/23NQQ6CMBCF4auYrq2ZDlMprryHcUHbQZsomGKIh
 nB3CxsQXb5Jv7+9aDkGbsVh04vIXWhDU6ehtxvhrmV9YRl82gIBSUEG0jsvI1/SM5ToQVHB1nD
 lRRKPyFV4TbXTOe1raJ9NfE/xTo3X/51OSZBAewBboiXDx1A/+bZzzV2MnQ5nq4C+LSZrGXRuK
 S+Y7dpmC6v0t82S1UZ7MuCcL38szRbV6l9KNttrDWWRV4ZxaYdh+AAGyVhmWgEAAA==
X-Change-ID: 20241030-dcd-region2-2d0149eb8efd
To: Alison Schofield <alison.schofield@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Jonathan Cameron
	<jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, Sushant1 Kumar
	<sushant1.kumar@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584788; l=2126;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=NA/pUKbWiPDsp+chBt4vNlq5Hcn+qvIslODyhCaMTEM=;
 b=2DjlTlJRVZ5WPqAX9UJK2WQwBKMtBFE0Yc4hhTE+48NDUFIzlTj7JnemdhpHAZVQjg7wxfuIn
 wUJKh3UV7iQCuUEP0CvPsEZ1IlN3iAsyo1zDUXIV/MESMxZCjDFZZGK
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW2PR2101CA0016.namprd21.prod.outlook.com
 (2603:10b6:302:1::29) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: 1eaed37b-ca01-4622-db57-08dd7adde130
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?c2MwakIzRDFEamUxdTBwZ2dVdFNJbnM3aTVEaWtSLytmeWZ0SnliVkRYei9n?=
 =?utf-8?B?MGthLzJmQ2ZGUWRaYjJpTU12V1VkR1h3R1BoVkFmOWFFazVGZWgzYnRmSHps?=
 =?utf-8?B?cEF1SU5CMDVhVUJZbVY2SkZYQzVLK3J1Wml4Znc2M3F2VHZKKzFxdkk4NWNx?=
 =?utf-8?B?TzUzQlRIaTNTL2dLQmx4QTlaZmtxUmhnWnY4MW5EOFdjdTdZUU9qWURtRHh0?=
 =?utf-8?B?WTBiZEF1UUhpQVRrRjBINmNMMFkzYWpGRitXa09VQk52QkFHMFE4NDg3QnZk?=
 =?utf-8?B?Yk9rNnhBL1pEZ3huRjhob0RDYjF4akFQNC9wdmNjTjBuMUdHck5hNi83akhu?=
 =?utf-8?B?ZFo4SUJEZUtRY0kzZldWUDZPZlJWbEh5SmwzSTVlNHZWbHlRNGZEYWJwcG9p?=
 =?utf-8?B?UzZObGpLaVFHVnZQY0RnOU5vWlZjMEVFTnNBT3BiY1EwaXVqTnh5bWpqa09C?=
 =?utf-8?B?WXpHYVlqT0hTRDhUNkphcC9nNDFLK0dURUx5Vm5YRk5hdldYWlFkRGJlOWx5?=
 =?utf-8?B?R3FsRXFkd0hHUjVjakxjUzl6SDI1WGJiakNsclhxNXdJdHZKMEdNQ3ZFQTM1?=
 =?utf-8?B?b3RvQm9sa3FkUEYyb1JiSno3OXNKcEhLRWI0dEVwNW5ycjY3YmJDd2F0L0NV?=
 =?utf-8?B?eGNjeUpNcExhWWdSRUdFVmMrcDVFUVR3b1VYeDFVcSt2VEcxNXU5allwN3U4?=
 =?utf-8?B?c2Z3QW1QNFFXVHBEYnczZUdJN2RHWU5ncjR0NThERklSVzVKS05qd0xtV0RQ?=
 =?utf-8?B?Tk03VERDYVJWc3BmN2QvQmlXNGlvQjROMzlXSUhvV3FiYXA4WlRJUEdDSHFU?=
 =?utf-8?B?MFhlWUFZazlIQUFzZ2xxWWxOcENDcGF5ckNrcC9XNkljQkx5bFJuQlRxRC9q?=
 =?utf-8?B?QnllY2E0YzZDNmx0dGdNOGFRWXJaVGhjYUVyMENOTEcyU3JQZG1qQ1pPSDB6?=
 =?utf-8?B?ekVwTWtHRElKUXN2dE9kbEtqM3ZsWDh0RDZMYmlCQ1BsSE9BZUFUZjJvRWZw?=
 =?utf-8?B?Z1pwREJETEZSZW9HTnk4bmVjUDE3cW1FbVNlM2dBN0Z4MkY5cCtWTlZZVzB1?=
 =?utf-8?B?L1VEOFlOSlBOM3N4Mktiai9qcTUvUG0zMk11MnF5blluV29hY2diNUxhR0Mz?=
 =?utf-8?B?OExTNlNaMDNFTDl6OFhyWDZWSUpWRVZpK3hiMit4S3kvZ0dESVJjZUoxQ1Z6?=
 =?utf-8?B?S3lhL2hybklZZ2dDNjdnaWlBNmlvRW53ZDd0UUw5cGtaWCtGbWJHdVF1UGxN?=
 =?utf-8?B?KzVYK2FjVG1NRWl0aGZiaWozWkh6eFRJMm5kRkFaWEpIZlQ5WlMwSzB0M0M5?=
 =?utf-8?B?eTROQXJxcDRxZVk4cGVxL1BqVUV2YXR5dnFFdVQzTzh0bytNakd2UjRnajla?=
 =?utf-8?B?cTQzalFHUTcyakZsYXJJT2tCcVJqVUM0OWV1dXlpMm84aDZBZVBkRU1XbmJI?=
 =?utf-8?B?R0EvMXhnZkdoYlZZVENhdjMxakdpY2JOUzRCRVlQQ0xBYTliNk1ZZGpCMDJK?=
 =?utf-8?B?RDN0QUZVSlpEK2dNdkFscFFXM1hrVU93RXBhTEd5VXpweUZLNlMyQUhNeE1E?=
 =?utf-8?B?VWk2YlhxNUJkeDRjRjN3aWZ6QVBlam41UU5vaitPYjNCV3hWM050VThTMmJw?=
 =?utf-8?B?a1BDeHRtNy9BYXl5a0xQRFV4bXdXWW1HU09nMG55VDE2and0c0VuN0ZGUXFi?=
 =?utf-8?B?R0lvUE4xS1VmTjFHVStZbkZKbEROYWRidUh5UmlIN1dZT1VNTDZQQUhGWFI5?=
 =?utf-8?B?NTZOUnVITFdFaW10aXUweFhRUXZQdnZRZzJucm1uM0QrQjd6MS80elhxeG1j?=
 =?utf-8?B?Wjd6RzZqdEVDTHlVaXR4NThNRlAwajUrMzczTWwraFNVODh6WS9XQVVHNGpJ?=
 =?utf-8?Q?4++uiobcX3xqk?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aG51c2ZTWTJYMlg1UWNYV1dITzd1Y1BnUjRKYjRFalFOUTNnenpSU2pQWkgv?=
 =?utf-8?B?RXkwMzBRT3RxRVVyTGFWQzh4TG1ZQjlWa2tIc1grN2lVWXJoVVFMdjNhaTNO?=
 =?utf-8?B?MEdTa21aYkppcWlaSXA3dzVudVYyUlhnNFlreldyemw4Zkg1OHhVNGxOYm56?=
 =?utf-8?B?a2xnWm9iR0w5c0JaQmpVYm1qYkNxY2FObHN3alNTK2o5TFNkcklBdU5Rb1Y0?=
 =?utf-8?B?TVVzdkx0Z3c5MUc2bDdLZXQ4Y1NlR21qM1ZXOTN4T0RRYlo4REliZ25vOXpY?=
 =?utf-8?B?UDlzeHYzZ0hHUmd3Y0VoMkp0aW02U0hFUTRqMU8veGhZNmpGbTZXZzQ0dmxo?=
 =?utf-8?B?MW9pZ3VFdkhSTlBodkFsWWc1VEVENGVaM2JCTWtEYzNqRjg5S1V0dW5sTjky?=
 =?utf-8?B?a2tYZy9FVkhnb3BGVzQ2eE5xaE1veGJNMlhZUGZoV3N4V1llMWg3bGs3OGF0?=
 =?utf-8?B?S2gwVGFyekxpSnRKZTZZM1FmRnZlNGVGcEdJS1lnOEk2VmM0VlJmSXU0Y0VE?=
 =?utf-8?B?d2ZYVHZpL2tmdTlHNDFXNnprdzhib1Uyb0M4WklHNXlSM2o4ZzJvNGpIdFFo?=
 =?utf-8?B?d054WURVQmdjRkI3U3k3U3M1QlFKU2xoenFOOThRQkZmUXZLRmdjRlJBUkdo?=
 =?utf-8?B?Si9PNDhMWGNBWmZkbGFncXpuK3JtTzBZWnI4TTViK0ZmT1dLNXlsdzcrZ3Aw?=
 =?utf-8?B?R3ExNUlKMVlaQjdmT1IxZWlWYyt1N21jQnBmUGZEWU11WDdMOHF2UkZVMG9V?=
 =?utf-8?B?SnpGdkdDSGllSzRnNHVRWGVXNjBBaWZrbjNHdTZVdmI2SVRudlUvaGNEbFFY?=
 =?utf-8?B?WU0zcmFvK1VvZ3Y1bTVTM3hjK0ZBK3oxQkJDYnpWMEJHNVhGMXgrbTRjZjBa?=
 =?utf-8?B?dHFYSGpOZm9rRTZNdFpUSzg1RzRLWVBzdVFwM0FOL1g0M1g2UDBRbDkxaHpV?=
 =?utf-8?B?NlJITnRFODRheDI2TWhTZVlMUHJRSnZzejNQclB6cnpOTjVXN20vaTBGZzdD?=
 =?utf-8?B?bkxLZG5zd3FpeTNFenJNRjZ4ZGpIR3BJTW9UWU9YckE3Tk1idGsrbWxuZlVJ?=
 =?utf-8?B?VWVXZzU4d0pZMnBEQlg3NngrV1NySWplMHR4a2ZQdklEWE85UE5rdXFUcHBq?=
 =?utf-8?B?UjlLNVBxSXdpTUdCNnIzbGwxazdyRFc0L05pajI4ZEEzd0VtNy9MOHBHNVFV?=
 =?utf-8?B?aUVmelk4c0JaeFNUYzN6RUc0Ry90eWZDWEV1eStoblFqSlBjamsxa2hyQkFS?=
 =?utf-8?B?UFF4NHZ1anJPdjhVV3dHcUE3RzlmOUtBVHFYMnpEMDFLZ1JWOTFHUGdxNGk2?=
 =?utf-8?B?V29ITkFlQUUyNjJ3ZDBRN3VjVmhieWRoRmR0UXdzR1ZoeFpEeFJZejhVK1F1?=
 =?utf-8?B?MnNqTVFyZlRLQXlSSzB0SjFpblErV0g5aUpUVHlJa1gwTUlGK3dxSHFPQVhO?=
 =?utf-8?B?dkFCUWVsSm82dVFjYUZMUVg5TVZqOTFBRElQcVAyL29PN1h2a2Q5RnlvOTYz?=
 =?utf-8?B?T000OThqaUx2MHdzTk9sUVcvbXpRSS9wbThIRzdvMUc5a2czZmVpS2FwNWlD?=
 =?utf-8?B?Ty80N0VuSzNRWGt5WjRxOWlmTVM0KzZSYU9ody9QUk5OaGcxUk5TNW1lalpv?=
 =?utf-8?B?eFR1bk1hWk1tT1gzamJoNlFaQzNLN1lkOGJGU3hZUy91NWc2Vnhwb0NROTMy?=
 =?utf-8?B?NVBJdkthVzdrUDk5Yzl4NzgwTi9GMDgxR2Y4YWwwdlBsM0ttbVQrcTJjZk9t?=
 =?utf-8?B?anlwSWszUU5ZWDBla3BjMFNrWDdJM0x2WWtTMlAxMlk3WnFPNnE2b0VYRUxq?=
 =?utf-8?B?Q1FHSHR6TEJpRzUxemI3S3FFMDM5YXdkRmt2ZTloZUl6cHc0WDMwM2tyWmF1?=
 =?utf-8?B?Uk9OditmUmxyZ09RZU50RmkrTlNzT2dpMkRHZ3FDQ0MzSCsyNm1PTkNHT2RJ?=
 =?utf-8?B?MU9mbUoyb3hscWFRVVdqSHlReU5XU2tmamZETVE0MjFJeVI1UWRvU1dqWkRL?=
 =?utf-8?B?aDRUaUZSQnJuK2dBNng0Ti9wRlRIbSswVVF0eGhhSnJrdHVjR1N6VzZRVERx?=
 =?utf-8?B?VHJBVjNLTmJqVXcrYUVBZE5wVklUR1hpR0dIcis3SjNnOXMrZ2hBR2dGRFZL?=
 =?utf-8?Q?KifEGKHgXrXzPm04gvAIiF3NV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eaed37b-ca01-4622-db57-08dd7adde130
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:34.2580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cz1Ne1meVrKB98dJc2kDwaKFrsebVmbGN8x3QDuyTJwfEZUs3F6zIs5HJ+TlkwiX5XNrghU/vI8lyzjj+S+Dzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

This series can be found here:

	https://github.com/weiny2/ndctl/tree/dcd-region3-2025-04-13

CXL Dynamic Capacity Device (DCD) support is being discussed in the
upstream kernel.  cxl-cli requires modifications to interact with those
devices.

A new partition type 'dynamic_ram_a' has been added which cxl-cli
needs to know about.  Add support for the new decoder type.

With DCD regions may, or may not, have capacity.  The capacity is
communicated via extents.  Add region extent query capabilities.

Add cxl-test support.  cxl-testing allows for quick regression testing
as well as helping to design the cxl-cli interfaces.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
Changes in v5:
- iweiny: Adjust all code to view only the dynamic RAM A partition
- Alison: s/tag/uuid/ in region query extent output
- Link to v4: https://patch.msgid.link/20241214-dcd-region2-v4-0-36550a97f8e2@intel.com

---
Ira Weiny (5):
      libcxl: Add Dynamic RAM A partition mode support
      cxl/region: Add cxl-cli support for dynamic RAM A
      libcxl: Add extent functionality to DC regions
      cxl/region: Add extent output to region query
      cxl/test: Add Dynamic Capacity tests

 Documentation/cxl/cxl-list.txt   |  29 ++
 Documentation/cxl/lib/libcxl.txt |  33 +-
 cxl/filter.h                     |   3 +
 cxl/json.c                       |  67 +++
 cxl/json.h                       |   3 +
 cxl/lib/libcxl.c                 | 181 ++++++++
 cxl/lib/libcxl.sym               |   9 +
 cxl/lib/private.h                |  14 +
 cxl/libcxl.h                     |  21 +-
 cxl/list.c                       |   3 +
 cxl/memdev.c                     |   4 +-
 cxl/region.c                     |  27 +-
 test/cxl-dcd.sh                  | 863 +++++++++++++++++++++++++++++++++++++++
 test/meson.build                 |   2 +
 util/json.h                      |   1 +
 15 files changed, 1253 insertions(+), 7 deletions(-)
---
base-commit: 507cdf47bab05e148086ef6b7e3aad278d051f14
change-id: 20241030-dcd-region2-2d0149eb8efd

Best regards,
-- 
Ira Weiny <ira.weiny@intel.com>

