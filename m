Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB07E14EC73
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584720; cv=fail; b=kFzFnadhXAq/C5vkzW0SBgHIXJpJIEnV+7UxtrB6yvXRvcO7ZP9/EBgppUjnOD/5yW0BQNhOYjVMEtSUZI9qFEqZW5F9QtEonFMthbr25qQTXSgAXzoJnRcBEHYitX9Nrky99TSqq1KfcFIXgLzL+rfSiAyxJBdoI3tXMVrL26Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584720; c=relaxed/simple;
	bh=kuFpqRxuP9q/teSWR7hnUn/oSHfdB2w/5nTQSy0Kb50=;
	h=From:Subject:Date:Message-ID:Content-Type:To:CC:MIME-Version; b=oYh3BsdKr3guAwse28ffi15FO+qSG2ay332UbQSF9AJeAnQEt7F0oiyU6vq8BoMXr/1j5iKf0lj9EtBOFOdkbjrYnXQ/Ui8+Bt6tgwuk4Jv45o6vrvL/Nl1ngZQ8fWo3C1aQFHih5+mvo0JHwgO3pgzo0RROLo8DYct87oAC5cI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jOQalkqJ; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jOQalkqJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584718; x=1776120718;
  h=from:subject:date:message-id:content-transfer-encoding:
   to:cc:mime-version;
  bh=kuFpqRxuP9q/teSWR7hnUn/oSHfdB2w/5nTQSy0Kb50=;
  b=jOQalkqJtTKbdzvxSWvJ3Gz0MqeYStvqK442Rrpg8rl7rFGt0/vQq/Tj
   g12LcYQnbCOA0o+CTXxfc3PzIbRNFBjgdAik+eO++37JpbHexwoPzZYT5
   3vI3qby97oFCLke12/9QhVQ85ABSvQ8DhY8yj/1+PCltBT3rZBkGQLCCE
   7OK1XF40zDz0yZTsHNia9mQ6KZRt5Yw+t9QKIVVFZT3h40dyS4JHIOKwj
   UjGuUIDHSRjFnvvqP4AdmFpkd220ONQ6Ct6cF8SoFiRdxkKJ45W8nZmWI
   +pu7mdwW2tIsBMu9zIDBbDQ3K8bo9EnG1bbcTGWTzq36WlMDftjj6iXQ3
   A==;
X-CSE-ConnectionGUID: ks9EJvVNQwWefJzdev4U2w==
X-CSE-MsgGUID: wecujQ00QIa9/WgfDbMV2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="71431107"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="71431107"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:51:58 -0700
X-CSE-ConnectionGUID: n/6Mb6LkQzKzRIU5MfPMTg==
X-CSE-MsgGUID: ik/5wCnGSXOsshYJtf6uow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="134405541"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:51:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:51:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:51:57 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:51:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MHUMA3fbTTpVBrvHgOtFjNZM5JH3z1K6v2eoASzDGK/Nhc4gCLMNnCWGKStweUHFMXwawT3VLptorVBwzMjyLLa96dEenvnNoaqNQav3gIY5NdPVPtZOZQBX5FtcJ1EbaDPP7Im1m0zmeKTtgBa11wIt0Wa8OSJck7W+FmjNiZqmzYy/q/BTB7AT/LfFQxFv0REXnbRLZvzLP+n5zisPa1r14p0Q3REJeZ7XL0XdfJPcna1NbtVb1Y3Aqkhahla2oe/D+YFn9mUu1Dy+8XRLftdW28nDBmU0zkOYyjz4hsn/WNmGzYZc8jGrTKuPtJjXAEkylhRPzi+820ASYRtuow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISPmh7gnXNbNyw58K3xu16xeaXHsIHXfX8cJQttIzQQ=;
 b=py+q3d/TMC2LI7rm5fRkjgODxvH4RWRyGNREJ6B4UfdIDYFSgoSidT63AgrYZwxjbCk22XUPc8Iz5oj/jj+wPzx7pU+k2nYnoMl/2ejM81ETtlAvYdB8BnRN/PaCpam4lL/sGj5dr/GT7Ps+MWFlvwsHytq9hsEsd5zUCtRhCMnrWrdwSkkxKtmqc4+TiaepQHHp+osfhdPkdR1WpY04p7EvltdSNWF4HTmj3VTGHLxyzsuuVLOdk/N9sJubJwa/uE/cZ97jAg83810kf2x5mqQGXrXZkezVNttriTnqkc8oIt+Eg45bs7TfOGE8R21UgGJ32eL9mEYHObk2MItIrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.28; Sun, 13 Apr
 2025 22:51:42 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:51:42 +0000
From: Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Date: Sun, 13 Apr 2025 17:52:08 -0500
Message-ID: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABhA/GcC/4XQzU7DMAwH8FdBPRNkO4nTcuI9EId8uKwSdFNbK
 qZp704yCVZKgaMj/3+2c6pGGToZq/ubUzXI3I3dvs9Fc3tTxZ3vn0V1KdcVAWlgMCrFpKbjQUi
 9HcZpEP+qICa0LRNym6ocDH4UFQbfx12Jfu8uDYdB2u79MvXxKde7bpz2w/GyxIzl9c95MypQD
 gNrg8GLNQ9dP8nLXdxf9Bw1oOn3aHABIDFpJruIlk1m+n86ZaJ1BqJx4hrkNaE/CQM18iahywG
 xCQ3H4Dm5NWG+CARwm4TJRCRGERZJktaEXRDUbBI2E7XTTQzsonZmTfCVQLCbBBfCRtd6QgOtr
 Am3JLYPcZmw7GsjzCHqH99ZXwlC2CTqsgVSbcmCMQBL4nw+fwCYopHW5QIAAA==
X-Change-ID: 20230604-dcd-type2-upstream-0cd15f6216fd
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=13223;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=kuFpqRxuP9q/teSWR7hnUn/oSHfdB2w/5nTQSy0Kb50=;
 b=tcHqaJWGAGfUXu6OPnVtDlvMkUwAG0Md7xx7heo14aGCJN2C0fNqTcbROJ4HszIWBpGJKed2/
 cRnNr+1JM9sD4Ndu5286EHNyTYpN1MBtvDoLRFtn6ozUUkZVYAsz9BH
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
X-MS-Office365-Filtering-Correlation-Id: 3815a3fe-7341-4a52-397d-08dd7addc1ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SHB2cDRGNlFjMlFpV09zOHFid3BCcGliRWFYbnY5WVdKdmYrRUNkREhTaGFV?=
 =?utf-8?B?Ni8zcUlLK0xnYUJZTjdjdUJ5WnJVQ2VpQVFYRFM2Y0VZRDdVK2lvVUY1WjNG?=
 =?utf-8?B?YnJqc1JpUjdRN0xLaG1jTjF1RlBtMU1RT0lYOS9ub1VFakNaWVU5REZheTNl?=
 =?utf-8?B?clpEbzdSUG5NUlBMN1NkTGw4Y3ZJSGlZMWNWYUxaVURRTzl1TDVhVzV3NkJZ?=
 =?utf-8?B?NjhpekM1NmlRUzB4MkV1NTUzS0dSQythS0ZIL05HeVAvcVFRcUhTS05LWHdn?=
 =?utf-8?B?VkY1dEZkQ2QycUpIaC8zREhTWDB3Y1RCdGlyamRGWVBKdjV1MDdNaktHYkRH?=
 =?utf-8?B?MmZYOEYvUC9aY3J1MDJuRy9LNnQ0V0hWelJHWkszdHBSTVFOR3RKYURPWER4?=
 =?utf-8?B?bW12S3h6V0pBcDZrUGhKMFZlYndqOU91SmpJKzJzZXo2SklIdkIzc1JuZ3pQ?=
 =?utf-8?B?OVJNVHg0ZjdvL1QxcUgwVVhsRldvTkI3OGdYeUw4QmdoWGNDRGo5Q2tGcTBD?=
 =?utf-8?B?cDhKUWNlY2d5K0Y5NUtXaUpud1liTDhuMkxLZWxwbWVPVmxTczk2TWhDWk1y?=
 =?utf-8?B?SmRZNmFVM29ZN2pDaTRkRlZrbUxiTjUrekxwL0QzN0dRbm1qMWhwUkJ4ZkR0?=
 =?utf-8?B?UkdZQlIyQ2s2UW1YaUlQbCtpYTNEemVNS0ZiK2gzMTlQWGc3aHVqVHBGZUUw?=
 =?utf-8?B?dXQ0aUpKZ1hZOXRCOS9jaWJGUW42YitpMXVWa3o3cUlMUHh5cEdoVnJ0cGtZ?=
 =?utf-8?B?QSsvd2RuMXpMZ1RTK2tnM2VWeWtjVjVWdUNmRXRJWlczNDZ5Z0JWdjZHeERw?=
 =?utf-8?B?c0JHc3BiU2ZLZElqR1BVQTFLTFVnZnJhVHdwTkNQckw3NkhoeFpHOGJ3dmxo?=
 =?utf-8?B?ZlhIaUVRNHNjazFhd3BqaC9rQWRoVTRqWlA0MjhYRmFVQXJVczBUeGczUnp5?=
 =?utf-8?B?TzJnOXVvUDN2RTdtanp1VHJ3VEZpNkVRVzlub05TcFhBNHVZMmJuMm9mc09j?=
 =?utf-8?B?WFNXUDFKUjdqY3JKbDRWOUZPcnVhMU9tUnV0NFhKWVNZSTB2aWtYQnZoWmN5?=
 =?utf-8?B?eHA2VEFsNWt1dHhEQTU0Njd5N05URUVGdmF2L1hrU2xDZFpabnZRbmdRODRz?=
 =?utf-8?B?djB6K0dUdkVrT1lpbGU4d1N3QXlkWEovNlhnTU1idWZnTXYxdUQvZ0ZaZC9N?=
 =?utf-8?B?Sm5pVGtUNjdSUG9LTkM0ellnNVpjNkVSSVVzWTdZUkFuNHUvaUJqRlI2ZDZa?=
 =?utf-8?B?UUUralIrdGphb3Q2clorbXNaT0RnVjcrTktEWjZicDFYNWxuUm5TRUhDSnp1?=
 =?utf-8?B?dW1Hck96YkVTWmQ4NVFlM3FTenNtNW5kRm5BMWRzZFQvWjhUc0VHV3VDVVoz?=
 =?utf-8?B?S3VOUmJqWEJSTVNvQzlXcVI4OW5VTG0xcFRiNmpuVGgrb0JKc0xKZ3IxN2pl?=
 =?utf-8?B?YVNIR0pkQ1lFSEpZUlp0K1Y4bVg4VTFNNHRFVS8vdmlPdGdaNlZ3Y001MGp0?=
 =?utf-8?B?WTdYbWt0aEl1WHhGZXZHM09hc3A5NWxsYXBWUTJNbElLdG9kUHdIdEhUeDg1?=
 =?utf-8?B?bmRWOXY1UDFaMWQ0eDBtQ0RXLzNFNU1qS0s1aGZvQnRSUUNweGw4UDJZQnlo?=
 =?utf-8?B?SjUzcnRCc1lDZi9rQ2JHVXM5NjN2ckxqb1BVM1pjZEhQcnVtYk5FUnFGWnlh?=
 =?utf-8?B?bUFtY2tNVkIzWkkwMElSUWlENDlIa3VyNGIrd09wM2tjWVl4THp1MUhCZUFp?=
 =?utf-8?B?M2Era0l6dFl4NUM1UEtIVUNsR0duZlFpVlE1RjBxUXZjVXc3eWxhU2lwckoy?=
 =?utf-8?B?MlhEeVNKdkcxMnI1RE15b0dnb0dYTEd3SERGdlBTanZ6eVRaVlF4MjRZYzlw?=
 =?utf-8?Q?8JuHswnq+VFpa?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RW80QWNFeUtCa0NrOGxEY25wbEZOYTR2L3BtdU15QlR5cUVGNmJ6b0xZRTBz?=
 =?utf-8?B?WmhDVFVBb1F0QTNNYzJuaUJPTmFSNit5VmUwTURWRDhwMklCTGJnN2ZjdDlD?=
 =?utf-8?B?K2Y2TjNSSUozT1Y3aE9mNTlxOFcwbUFtUXg4QTloR1FhUW40MWZEZ2ZGVkNz?=
 =?utf-8?B?c0pnNFl5aDFyRmgxN0NVemU1Qzg3aUcxSnRBQ3lYSjdOeUlsUDkzUTNsaGVQ?=
 =?utf-8?B?RzlVdjVyWlVkdHBwK3RkYm9senFvSTBMaXVCN1ltU1FLSXNSMXVNMW5tSmdJ?=
 =?utf-8?B?bm9tS3J5bGpkTE5STlQyNkp6SGxpVmVzTE1KUVBzKzE1NG9GVndJZGp6TW5y?=
 =?utf-8?B?VS80dWtNbWpxWVpQWTFWZ1JyYVdYL0Y1R3NRSTh2UCtsb2Zpcit5eGZSY0w2?=
 =?utf-8?B?MGRqTC9OUXcvMmFsQ2VGMDMzWXkzQTNNK1kwVDdHWHNQbFhENU1JUERSc0th?=
 =?utf-8?B?Tkt3dHI5S0NzTEk3VUtiUnNsbzJkSkh5S0NNeC9WTFJiYXZxalNCMjdjNlZC?=
 =?utf-8?B?bUQwTXhWbkVzOVBVN0t2R1VuWVpUUGJtNmdqWTFmdnN4LzFWYUpPbFBJaUV6?=
 =?utf-8?B?Yy9kT2RJd3FTTjlCSHgvekJsUXBoYlhUanp4Sm9KWDNjRDBzNW1PK1l2VTI1?=
 =?utf-8?B?cEFWNVFlV2YwNUlTZm9ySEE4VnpIOXowcUpMS0pObG9hakYxaTlJRWY2SGEy?=
 =?utf-8?B?VG4rajE3Q1B1Ty95R1k0NEJ0S2t3VTIySkd4VWttdDFYZTNrNmhLZ1RPZ3k5?=
 =?utf-8?B?TnRGemFFenVONjZmT2dvYnJ2QmIwSkpWSmdXbis5VDVrbzAzOFJXZGtlTk9Z?=
 =?utf-8?B?b3d6V1ROdit3RUJubGxqUzlVSThkMEJrT2JLZTV0WTNFbHc4WlFjV2EzSzM5?=
 =?utf-8?B?dDhhbEVkeUphK3k0V1VobGRsbDAwaHB5am5YNUpzaTNlS2ZZeVg1UUJZd2hY?=
 =?utf-8?B?QnpFb1pHZ0EyUlRHU1RLREdCUFBtZTNHNXlic1JWL1ZXMnlUY29JblBFWGQr?=
 =?utf-8?B?ZDlkVXNzcUdGeEYwUUJIWVhxYzdGZWI1MlNaQ2dlRFdjbGxaTVY0U1FOakVN?=
 =?utf-8?B?Q0VQSDFuQzBDM01XZ2pPRUtYREpsZEM4WXFqUXpYZGVYL0tVMEdFdzFHYkJp?=
 =?utf-8?B?L2kyekZldXBBL3hkRURPZHJWNnpuaENXZndBN0hZc2plNFF4c25xdCtuUUEv?=
 =?utf-8?B?N3dudVVrN3IrYWpGSnRraWUzYW5LdXVVbk9qK0Z5SDc2UFpoVVNGNVA3SjFO?=
 =?utf-8?B?azJBTkw3MlhvUTZGSXVBcVVRRUN1OE5FNjdqbW5ZNHdtMDllajFSeTE4Uk1r?=
 =?utf-8?B?MWkrK1lDcGdpTHVxSjRnOHZkbkFQa3BnZmJ6bVNVUE9XN21ibEdFSWhRUTBB?=
 =?utf-8?B?c1lZbEx0b0o4TEk0M0dPRnhBbDJKaW5qMW1MUUp0S0dVUnl2UHFIWkh1NGhv?=
 =?utf-8?B?RHRJNVE2V0UyOVZXVS8vTVFJM0s3MytTUXJId2pmQU91cGxLUWpKMDVxdm11?=
 =?utf-8?B?ZmVCWW5sQWdGWklHRVdPMElMZkRjcHAxQWpqM0lEOVJGa2hnYlZLNFllNFhw?=
 =?utf-8?B?Zkk4eG9FQUI5M2Y4RXV1UStHVStvNVNrNDFaYnRRQzlXVkN2Z1dhbjBwZ3F3?=
 =?utf-8?B?dkdYdHJSS3J6TCtsaTlGVjJGcGRMM0QzSVQ4b1EwUmJuQWhRWTlHSjFTSE40?=
 =?utf-8?B?WlEwcisxQnRjSGtORkZCeU9xRFc2VURkMTVBZzBKZnVxOVVHRlNlcXliU3ow?=
 =?utf-8?B?REdsN0c4OEdjYW03VUlUZGJQdzl4UFlxWG80ZmZzRGdUWk1aNkxtRU1ad3R0?=
 =?utf-8?B?eXl1Mm1leFQzTHZFMmRMTEptY253K01BeVlVTGJuV2oySWY3QXhINHdUTHlX?=
 =?utf-8?B?aDAzbzh2TWl1U0s0ZEZvS1lPaWNJM0N0TWRTU2phVFhkK1FLTHBHcmZRRUE4?=
 =?utf-8?B?cWlFdmJTWFNZSWJqZHBkSk9TK2FjaGpTZU1pSTVKMnU5RWFyODBMZGlyUjNh?=
 =?utf-8?B?cllJZVhocDAyQy8rZzRIM0M0QnFRdWdUc1J6Qkx1RHlFaFVZRmUrUk9adnh4?=
 =?utf-8?B?ZEVYVGZHT0FNYXl5RVI5SWl5Uk45UGVhUGlYdXdtd2x5OUhmMk9NM1dIRy9J?=
 =?utf-8?Q?x1uhnUmJDfMfx0GanvAWDaGGm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3815a3fe-7341-4a52-397d-08dd7addc1ef
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:51:42.1339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPPCG1n/52x+PlZliUkJiyPAb06aee4aL7wg1e3DDLqIInsfF68Bc1xN5vQX/Fv8LY4kyVrZHKXUB2aLdg2xSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com

A git tree of this series can be found here:

	https://github.com/weiny2/linux-kernel/tree/dcd-v6-2025-04-13

This is now based on 6.15-rc2.

Due to the stagnation of solid requirements for users of DCD I do not
plan to rev this work in Q2 of 2025 and possibly beyond.

It is anticipated that this will support at least the initial
implementation of DCD devices, if and when they appear in the ecosystem.
The patch set should be reviewed with the limited set of functionality in
mind.  Additional functionality can be added as devices support them.

It is strongly encouraged for individuals or companies wishing to bring
DCD devices to market review this set with the customer use cases they
have in mind.

Series info
===========

This series has 2 parts:

Patch 1-17: Core DCD support
Patch 18-19: cxl_test support

Background
==========

A Dynamic Capacity Device (DCD) (CXL 3.1 sec 9.13.3) is a CXL memory
device that allows memory capacity within a region to change
dynamically without the need for resetting the device, reconfiguring
HDM decoders, or reconfiguring software DAX regions.

One of the biggest anticipated use cases for Dynamic Capacity is to
allow hosts to dynamically add or remove memory from a host within a
data center without physically changing the per-host attached memory nor
rebooting the host.

The general flow for the addition or removal of memory is to have an
orchestrator coordinate the use of the memory.  Generally there are 5
actors in such a system, the Orchestrator, Fabric Manager, the Logical
device, the Host Kernel, and a Host User.

An example work flow is shown below.

Orchestrator      FM         Device       Host Kernel    Host User

    |             |           |            |               |
    |-------------- Create region ------------------------>|
    |             |           |            |               |
    |             |           |            |<-- Create ----|
    |             |           |            |    Region     |
    |             |           |            |(dynamic_ram_a)|
    |<------------- Signal done ---------------------------|
    |             |           |            |               |
    |-- Add ----->|-- Add --->|--- Add --->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Accept -|<- Accept  -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |<- Create ---->|
    |             |           |            |   DAX dev     |-- Use memory
    |             |           |            |               |   |
    |             |           |            |               |   |
    |             |           |            |<- Release ----| <-+
    |             |           |            |   DAX dev     |
    |             |           |            |               |
    |<------------- Signal done ---------------------------|
    |             |           |            |               |
    |-- Remove -->|- Release->|- Release ->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Release-|<- Release -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |               |
    |-- Add ----->|-- Add --->|--- Add --->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Accept -|<- Accept  -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |<- Create -----|
    |             |           |            |   DAX dev     |-- Use memory
    |             |           |            |               |   |
    |             |           |            |<- Release ----| <-+
    |             |           |            |   DAX dev     |
    |<------------- Signal done ---------------------------|
    |             |           |            |               |
    |-- Remove -->|- Release->|- Release ->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Release-|<- Release -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |               |
    |-- Add ----->|-- Add --->|--- Add --->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |<- Create -----|
    |             |           |            |   DAX dev     |-- Use memory
    |             |           |            |               |   |
    |-- Remove -->|- Release->|- Release ->|               |   |
    |  Capacity   |  Extent   |   Extent   |               |   |
    |             |           |            |               |   |
    |             |           |     (Release Ignored)      |   |
    |             |           |            |               |   |
    |             |           |            |<- Release ----| <-+
    |             |           |            |   DAX dev     |
    |<------------- Signal done ---------------------------|
    |             |           |            |               |
    |             |- Release->|- Release ->|               |
    |             |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Release-|<- Release -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |<- Destroy ----|
    |             |           |            |   Region      |
    |             |           |            |               |

Implementation
==============

This series requires the creation of regions and DAX devices to be
closely synchronized with the Orchestrator and Fabric Manager.  The host
kernel will reject extents if a region is not yet created.  It also
ignores extent release if memory is in use (DAX device created).  These
synchronizations are not anticipated to be an issue with real
applications.

Only a single dynamic ram partition is supported (dynamic_ram_a).  The
requirements, use cases, and existence of actual hardware devices to
support more than one DC partition is unknown at this time.  So a less
complex implementation was chosen.

In order to allow for capacity to be added and removed a new concept of
a sparse DAX region is introduced.  A sparse DAX region may have 0 or
more bytes of available space.  The total space depends on the number
and size of the extents which have been added.

It is anticipated that users of the memory will carefully coordinate the
surfacing of capacity with the creation of DAX devices which use that
capacity.  Therefore, the allocation of the memory to DAX devices does
not allow for specific associations between DAX device and extent.  This
keeps allocations of DAX devices similar to existing DAX region
behavior.

To keep the DAX memory allocation aligned with the existing DAX devices
which do not have tags, extents are not allowed to have tags in this
implementation.  Future support for tags can be added when real use
cases surface.

Great care was taken to keep the extent tracking simple.  Some xarray's
needed to be added but extra software objects are kept to a minimum.

Region extents are tracked as sub-devices of the DAX region.  This
ensures that region destruction cleans up all extent allocations
properly.

The major functionality of this series includes:

- Getting the dynamic capacity (DC) configuration information from cxl
  devices

- Configuring a DC partition found in hardware.

- Enhancing the CXL and DAX regions for dynamic capacity support
	a. Maintain a logical separation between hardware extents and
	   software managed extents.  This provides an abstraction
	   between the layers and should allow for interleaving in the
	   future

- Get existing hardware extent lists for endpoint decoders upon region
  creation.

- Respond to DC capacity events and adjust available region memory.
        a. Add capacity Events
	b. Release capacity events

- Host response for add capacity
	a. do not accept the extent if:
		If the region does not exist
		or an error occurs realizing the extent
	b. If the region does exist
		realize a DAX region extent with 1:1 mapping (no
		interleave yet)
	c. Support the event more bit by processing a list of extents
	   marked with the more bit together before setting up a
	   response.

- Host response for remove capacity
	a. If no DAX device references the extent; release the extent
	b. If a reference does exist, ignore the request.
	   (Require FM to issue release again.)
	c. Release extents flagged with the 'more' bit individually as
	   the specification allows for the asynchronous release of
	   memory and the implementation is simplified by doing so.

- Modify DAX device creation/resize to account for extents within a
  sparse DAX region

- Trace Dynamic Capacity events for debugging

- Add cxl-test infrastructure to allow for faster unit testing
  (See new ndctl branch for cxl-dcd.sh test[1])

- Only support 0 value extent tags

Fan Ni's upstream of Qemu DCD was used for testing.

Remaining work:

	1) Allow mapping to specific extents (perhaps based on
	   label/tag)
	   1a) devise region size reporting based on tags
	2) Interleave support

Possible additional work depending on requirements:

	1) Accept a new extent which extends (but overlaps) already
	   accepted extent(s)
	2) Rework DAX device interfaces, memfd has been explored a bit
	3) Support more than 1 DC partition

[1] https://github.com/weiny2/ndctl/tree/dcd-region3-2025-04-13

---
Changes in v9:
- djbw: pare down support to only a single DC parition
- djbw: adjust to the new core partition processing which aligns with
  new type2 work.
- iweiny: address smaller comments from v8
- iweiny: rebase off of 6.15-rc1
- Link to v8: https://patch.msgid.link/20241210-dcd-type2-upstream-v8-0-812852504400@intel.com

---
Ira Weiny (19):
      cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
      cxl/mem: Read dynamic capacity configuration from the device
      cxl/cdat: Gather DSMAS data for DCD partitions
      cxl/core: Enforce partition order/simplify partition calls
      cxl/mem: Expose dynamic ram A partition in sysfs
      cxl/port: Add 'dynamic_ram_a' to endpoint decoder mode
      cxl/region: Add sparse DAX region support
      cxl/events: Split event msgnum configuration from irq setup
      cxl/pci: Factor out interrupt policy check
      cxl/mem: Configure dynamic capacity interrupts
      cxl/core: Return endpoint decoder information from region search
      cxl/extent: Process dynamic partition events and realize region extents
      cxl/region/extent: Expose region extent information in sysfs
      dax/bus: Factor out dev dax resize logic
      dax/region: Create resources on sparse DAX regions
      cxl/region: Read existing extents on region creation
      cxl/mem: Trace Dynamic capacity Event Record
      tools/testing/cxl: Make event logs dynamic
      tools/testing/cxl: Add DC Regions to mock mem data

 Documentation/ABI/testing/sysfs-bus-cxl |  100 ++-
 drivers/cxl/core/Makefile               |    2 +-
 drivers/cxl/core/cdat.c                 |   11 +
 drivers/cxl/core/core.h                 |   33 +-
 drivers/cxl/core/extent.c               |  495 +++++++++++++++
 drivers/cxl/core/hdm.c                  |   13 +-
 drivers/cxl/core/mbox.c                 |  632 ++++++++++++++++++-
 drivers/cxl/core/memdev.c               |   87 ++-
 drivers/cxl/core/port.c                 |    5 +
 drivers/cxl/core/region.c               |   76 ++-
 drivers/cxl/core/trace.h                |   65 ++
 drivers/cxl/cxl.h                       |   61 +-
 drivers/cxl/cxlmem.h                    |  134 +++-
 drivers/cxl/mem.c                       |    2 +-
 drivers/cxl/pci.c                       |  115 +++-
 drivers/dax/bus.c                       |  356 +++++++++--
 drivers/dax/bus.h                       |    4 +-
 drivers/dax/cxl.c                       |   71 ++-
 drivers/dax/dax-private.h               |   40 ++
 drivers/dax/hmem/hmem.c                 |    2 +-
 drivers/dax/pmem.c                      |    2 +-
 include/cxl/event.h                     |   31 +
 include/linux/ioport.h                  |    3 +
 tools/testing/cxl/Kbuild                |    3 +-
 tools/testing/cxl/test/mem.c            | 1021 +++++++++++++++++++++++++++----
 25 files changed, 3102 insertions(+), 262 deletions(-)
---
base-commit: 8ffd015db85fea3e15a77027fda6c02ced4d2444
change-id: 20230604-dcd-type2-upstream-0cd15f6216fd

Best regards,
-- 
Ira Weiny <ira.weiny@intel.com>

