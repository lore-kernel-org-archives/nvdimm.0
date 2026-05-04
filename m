Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81834384253;
	Mon,  4 May 2026 22:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777934083; cv=fail; b=qQ+h9afKk5H5wymD6NLy9YRMIpd5oQ6kkyywzMcoUdl49yvOll1I81rVO/g5Bscu2nrYrIi84GnzS9ykcrbyDNWAZeoLJT8y+NXoUvkQ5umuTpJklOUDnveRUTle4+v8IAkPd67PASqwhTXs8HN5hhLfuS7zQF3TbrzYcv7Bs9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777934083; c=relaxed/simple;
	bh=Pb5Wmz24NZENNfaOaUFBuBEwvLZT0OA0L8L7/uPUieI=;
	h=From:Date:Subject:Content-Type:Message-ID:To:CC:MIME-Version; b=co6Xj4u/me1UOXuB5Ok7FmEKH61IpuXG8cQ5aNV+vRB0GmAdrUbtu2tjkE+LZgcVPMy3Wll85s+zNJ3hkZOhUnL1A5FIL1d05g1iuzUQM/y9wkKJA103xLw5m1FmbFVJreCU9+qYRWRw7ku6VODzvDbgmfb3HtfvFU6ROn2sb4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nYofWvUj; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nYofWvUj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777934082; x=1809470082;
  h=from:date:subject:content-transfer-encoding:message-id:
   to:cc:mime-version;
  bh=Pb5Wmz24NZENNfaOaUFBuBEwvLZT0OA0L8L7/uPUieI=;
  b=nYofWvUjhNAvcE5jVkqAsn350PQubxH1cFUispb+Lo3h89vfcJQnekLv
   6QDJAZts9O6gpEq+zRg8/uddy2z3EYuKc37ifQ9MD7MgTbnwPgXqpIPOl
   FXjHls9FkrK7reCJPYXiqy8fuHA+dSwnky4E1wFwjCOTMBwLjNC/l1S1n
   dpicHRo2lmJOpAcKvcuchb2L/534dqBte1XMCDjMgbAETNX/GZbgf+XnJ
   GKhlanr+nFFzABQfplJt62ImU0H7BGzubs7N0j7L2DgBLjMeQZKqkAWiV
   sPfbVWq69xR4noCjb4AbN4ym3KpTY/Blvx50TtpySiE0cS67xocycaw7v
   w==;
X-CSE-ConnectionGUID: TgMjvTtQRCmm78rK82XzYg==
X-CSE-MsgGUID: w6Ntu4moRZq7BbXbTi1vBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="78662380"
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="78662380"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 15:34:41 -0700
X-CSE-ConnectionGUID: BCUJEkDLSVWhKPKS9lOOxw==
X-CSE-MsgGUID: 98qZfXNiT+yO67yMMfShNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="231269982"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 15:34:39 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 15:34:38 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 4 May 2026 15:34:38 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.29) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 15:34:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D/tLhIkpLOlOf92qbp/wAfJepdD+W5LnIYmJXGED17ZkqXzscBMzkx3DhuicrQKhKNHs7dQn+E26Ibjy+RAniUzfLZJuY0UFe4/vhVcCuO/9DZkLUPcdG4UD2+tbl1atpdHW08alEdhudAx+x1tDA2JFopzWYlBnFdQZ7SztYkbvevRSJm4rcx5FSY6BMfQquU8cOnAS0r9qZmNSxHcW24xTae7+LrQsrU5HqATkkWx/57PiTzObUzOrWiP173bSfz71FtDbMOTf6F7rmM3wFZxPwV2YMHiwrVCzXvvQMc1kYiQO+grj5afhOkqk0r8sGrt/137jFnOAeRzOGTa9Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1V0lhfktJ7oZ6Q7K3M0XCE0r8XPR0Rreba9jnyhvpKw=;
 b=NsEV2BuDDWkS/Gr0mTS0bU6DCg6VzArHeg+ZYebMaOOvhNQIkDXsHjrBxW0KB1H8BwVCZOfQEy8nHdPZRKWri4ZvSN5bnm3J2FHY4z0I8O+l2AZkowgcCPNWh6KgG38RkZf1VLw498F1VSVydUNczL693mgB5e2xNjtGMx8+JyMpb/KRucjIwoZVWFjNWwFQ9V9V335cJXLcbor/Zs1DNQjjl18kSEwOSBxqYFpqfq7dVg+5CJx3lQuRknqOcIVGtG+2h42U/8wx+D6uht5yc/KJ63pY9aeSGd/VqP9P2IWeFOrSSmIOsQMMfVhZ+oziZjqAJHxDDvbXAfJjLoJXyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PPF99D0888FA.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::f3d) by PH8PR11MB6658.namprd11.prod.outlook.com
 (2603:10b6:510:1c1::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 22:34:26 +0000
Received: from DM3PPF99D0888FA.namprd11.prod.outlook.com
 ([fe80::c5b4:32bc:f94a:990a]) by DM3PPF99D0888FA.namprd11.prod.outlook.com
 ([fe80::c5b4:32bc:f94a:990a%5]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 22:34:26 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Mon, 4 May 2026 17:38:10 -0500
Subject: [PATCH] MAINTAINERS: Update address for Ira Weiny
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260504-change-maintain-file-v1-1-6679b030d3e0@intel.com>
X-B4-Tracking: v=1; b=H4sIANEf+WkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDUwMTXahobmJmXgkQ66Zl5qTqWqQZGBubGJuaGVomKQG1FhSlpmVWgI2
 Njq2tBQAuwKn2ZgAAAA==
X-Change-ID: 20260504-change-maintain-file-8f033435619b
To: Dave Jiang <dave.jiang@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<driver-core@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Ira Weiny
	<iweiny@kernel.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777934317; l=2282;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=Pb5Wmz24NZENNfaOaUFBuBEwvLZT0OA0L8L7/uPUieI=;
 b=B94/LFhLX3tL5STpWiqSWc+soYQBT4xbqIVaYUkIC10zyvxATXC+7/oy1aoeHJDaXWGh0+Lad
 oc2wo7njpyKA1mKoFzNTrweSrg9D4jq9gX4jYM4dqJpTJE2PavpiIRw
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW4P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::23) To DM3PPF99D0888FA.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::f3d)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF99D0888FA:EE_|PH8PR11MB6658:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c253d84-9f6d-4063-a0a4-08deaa2d4bf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: aQ7MwZE96JA1EpesyczDz/VKT/Iv00NWaMEJCwGWw7JzVf8mQqzy50EDzUKVQymfu3BJh9aBufpcsdY4xey8p6ZLpJ/sLRgQVneum5CiNbdDocJsD997f3GQlKT6k8XJY97ntMExfArp1noxQamSGq/UyapTCvM+yy1kk3+SbRVslGOpe8j0LfNy5LiIW/2BTjHuUsgmXF8G/QmEN1bvRb9cT9P88KXvN7CANGaPuB2yscJ4VVujm1HEtkWaz9Uky2Z841+PpOcon9Ti9PYwAoWTBdA/+lBNDor18DNaRUiwoDQ0By63WeY6xkYpYAerZFhHi2f7HMFm87g4nnRkyf6F5XJ8h6pjQyfk1EwR1yghJaR5+xiRDQy1CRPVEcST1XDtITIHUrlk3koiR+vL3cF6CvwKLGraW3JSRPJ4Sw7XEp2SFLWonYgO2xymH2RoYTsXjLNrb1k5qbI0CgTstIplkRTCS0M0/aMR2xkcl1BQLMX4QUs5ngS98uhv4hEpmV91v171WMS0khwog0GciGMRjxQ66pOe3lwInHSDnEuft+keR+AHM4UmEnXXmT+OnaWfQqaQrVOUz8Q/jytNsl2TDMXOmUEQVGZUkg1bjv6G56BEAnEM2JRHTKf+sf8GxUvp3AuNBKmV6QTyeSa+bVFBv9rkTz3Icy+K1Mcf5LeXlND9Nsj7d5Z8AAN5t21AUlVZ2dGWHOKyIF+mtTBA9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF99D0888FA.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFBSK2xKOXEwVS95akhuN1BrQVhveHpjWklDVlorMllORERmblZnRkNOcUM1?=
 =?utf-8?B?MFU1QTZqc3NkM29UMnBLN2ZwSkNyMlFhdDRNeDR5ODJtWnBrajRxR0E5Rm5M?=
 =?utf-8?B?dEd0eS9ENlRwalZLSjJwdDZCWDBCbk9VQk5iM3Z1VVZDMlM0Y2YwNnlGTFhQ?=
 =?utf-8?B?anFHM2J5MmNTNVNoQXVXMnJDZ0FGUUVBZkNEZHNpa2hYejhxc1FXM0NzZk42?=
 =?utf-8?B?dDUxUlp1bmhnTG1JR3hjMGNJc1JlanpTekR2MUNhR2JQTHpkbFJDT3N0K1hX?=
 =?utf-8?B?MWJ0WllyalJuZThtUUJ3cnJ4TENKcTJVaUQwY2RYQmp1NG9aV2RlcVF1bXRU?=
 =?utf-8?B?c2h1bTg1QzBpVTQ5c0djdXJkZGZzbk8vNGJJMFhMNDhZMEorSElSMHJlLzAy?=
 =?utf-8?B?bUk0WFhWcm4wYXpOdXYzd1M1Z09WYmVleWNtMzZtQmwwY1JlZE8xMUNTcTE2?=
 =?utf-8?B?VTl4cGMyUEpUUUI5SS9NZGEwVGhrdlVYZzlJdStZMWVSMGQ5K0owTXpNRkN5?=
 =?utf-8?B?bS9Nc1Uyb2NzVmNDWStzNGdlQk1EZnc5dWlKYjV3UkIyYS9iNkZQTEVKZXBH?=
 =?utf-8?B?WWdCa3ZvYWhycmlZUGdKeVBKQUlNb0s3VUtCcG4yenZhWnlacXpmMy9tUnla?=
 =?utf-8?B?NTdWcDZmb25wUGJWam1IamIraDdqR1MxeEJtbEkxak51U216d3hsYjVubm00?=
 =?utf-8?B?eGFhWXRjd3REbG9pdjRIbEdxRVFIV3FwNWQxeGJJNXhpaUI4K0JVMDc3aFp5?=
 =?utf-8?B?a2dzMm5JcmRQeXRDR1ZxREN0cE1uNDNqWXRFK1htQWNFUW9iVDB0eWhFR1hy?=
 =?utf-8?B?OE1WQk5IMDRlS095NzEwWEplVWFFUmpoWTFpS0xpbzlaVHdLWXFmR20xLzhG?=
 =?utf-8?B?RjZQTTlRNzBmSXI3a3h5UDFBMWRycUpBOHc1T0hyT0RCQjFuZ0lMTzZLME8z?=
 =?utf-8?B?ejc0MkJQcmV1TGRwZzRPUzV1Y2J2YUpSNW82TE1IM0EyNEp0TWxUVkgwMkdz?=
 =?utf-8?B?aGtWd0xpOGRNU25NeEpiTGZaSnZJYkdCcW0xNnc1dkpvT1VVUjRsK0o2elhH?=
 =?utf-8?B?YU8wRVc2YmNTS3JRZitSZndwK2xhdFZ5eTZLYm96OWVSOFhNUm9UL2x3UGwv?=
 =?utf-8?B?c1JvcGMxbHFhc25vK3FnWDV6YWxhYXJnTXYvWVBWSTBvc0tmSXR2ZlFhMWg4?=
 =?utf-8?B?eXNibFdHbTNncU0wY1BUeXRnNlF5dDhBSG9GSEJzcXhwYllDSGVrZkFoTUdz?=
 =?utf-8?B?WmxTc3FzMUozVktIYndENkhQOUZGMXhvY295QVN1R0gzT3IrRjQzQ2lRM2VC?=
 =?utf-8?B?L0RxY0t4dXROSHFIWDBXSnZpNXVDZmFBTUQxaWhwbjE0LzdaRlB3a01CYkRq?=
 =?utf-8?B?STFpNjNmS2JXU2pjRENVaDJzZkpRaWwyRFpMbStSL0ttYlgyK3E4djN4UzJG?=
 =?utf-8?B?V21lSWs2ZWNPREhqZUxhMGRwOEpRbEprMy91RmNjTFNXcWhsdkluUWRmbzZ4?=
 =?utf-8?B?NDg4ZWJFUTk0a0w3N2JaT1NuVzQ0NDVlY2RFSXpQWWprWTFLREg3UUlpNUdY?=
 =?utf-8?B?UWxhNEF1d2x2MWpUdXVuNXF3eE9mNy93ZXFCMTlKMFR2cTEzMjJTencvdmw5?=
 =?utf-8?B?ZFRwanpZSXZRQlMvMDFvMzdpQzhiK05SWmhiMkdUV1k0cVNuZklrcDRFQkxk?=
 =?utf-8?B?czBlVUJCeGNsdzR4LzVpdUs2b0hSWk1IVTM3c2NDYkdEOVBjanpOajhtKysr?=
 =?utf-8?B?OWQ5cnZVeHdwQ2VSVGhJSC9yZmR0NmUxeDk5NlBiQzh0OWI0aUExNjdQeTRE?=
 =?utf-8?B?TE0vNVgvSENISTNMaUtnWHlzNDVDSXJZZkRQUDZnam9OWGFVU3B1TU9lU2Ir?=
 =?utf-8?B?U1dkNmVtc0RTcEhlZFBFZDFoWElWNkE1SjZpMWZIUTF1Nmp0TjVyUDh4ZnJk?=
 =?utf-8?B?VWNLa0hhSXZwWE1UT0RDWTVDR2pPS3FPcWs0eHRzcS85a04zeEczWmtDN2Fl?=
 =?utf-8?B?L3RWS2dxaTQrNENBbCtldkxodndLMUpGVFU3dWVJamxJWER3c0VHUW5ld0Rk?=
 =?utf-8?B?SlJmYUtva2pveTdhZzZjaXltQUtPbUZQb21obkZmcUx6MDE5bUVjckErOXBo?=
 =?utf-8?B?WE9QNXBqNndmejlBUSszc1JGQlNCejFoaUhkT2pEV2krOE1tbXNwMG4yT1Bk?=
 =?utf-8?B?anh5WlRPdjlsaFQ0S3kzOEhOM2Q5YlpiUEJ3R3c3c2dMSWY3eGdKWmpYMTVR?=
 =?utf-8?B?SHpGRFRuazNpVGJUOExMYmZOdGFlV3FBYkZTYXJxcmlPaFhRRWxNTXhOU09V?=
 =?utf-8?B?VVd3VmZxOVB5WmRrQ2tKLzZVa0pRdzdTK1ZsUVcyWEsyeWZPTXdUUT09?=
X-Exchange-RoutingPolicyChecked: B05dzCTxjZnNxshyuGyIfEYI3isLND8cvgqYs+v3yCTQF/RTGb0VqjdjIcOzXIBdT2YGlqw3ixzsRm7aaPcv5UDx5u/o2CMYAkPV7kU0TUMhmuPvDcbedzVwM0t9F1yLu8tFhSMr7JKB5fJ3BWAOvqRf5Sju/dpHGzHiU80wMcVex8IXAG60btgahbcmgQ0mEjnJd+QAjSRzJWx+emVsN+Yx7wlPrYF/a8HHPY8Qt4efR/Sm48/gSfmNigoy5uXCyLKhr9FA2knE3/AU6J5GYpniCod21KumrdVB4AmTXOsTaqdSjQ4O8B3wgN49/90qeUsQHrxSuLBP+Vzu7cDh8g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c253d84-9f6d-4063-a0a4-08deaa2d4bf1
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF99D0888FA.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 22:34:25.9593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AoEyqx6sapwDq087cRwIaeccTdC9mPWHWNi3umkA6mXxUTZQF8dMBNW4FZXJF+2pTKuWHweF86kO8eaBCY2uVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6658
X-OriginatorOrg: intel.com

Update MAINTAINERS and .mailmap to point to my kernel.org address:
iweiny@kernel.org

Downgrade from maintainer to reviewer whilst doing so.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 .mailmap    | 1 +
 MAINTAINERS | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/.mailmap b/.mailmap
index b78aa092b4bb..61d101ce9696 100644
--- a/.mailmap
+++ b/.mailmap
@@ -446,6 +446,7 @@ Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
 Julien Thierry <julien.thierry.kdev@gmail.com> <julien.thierry@arm.com>
 Justin Iurman <justin.iurman@gmail.com> <justin.iurman@uliege.be>
+Ira Weiny <iweiny@kernel.org> <ira.weiny@intel.com>
 Iskren Chernev <me@iskren.info> <iskren.chernev@gmail.com>
 Kalle Valo <kvalo@kernel.org> <kvalo@codeaurora.org>
 Kalle Valo <kvalo@kernel.org> <quic_kvalo@quicinc.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 882214b0e7db..d30ab65ece8a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4255,7 +4255,7 @@ M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 M:	"Rafael J. Wysocki" <rafael@kernel.org>
 M:	Danilo Krummrich <dakr@kernel.org>
 R:	Dave Ertman <david.m.ertman@intel.com>
-R:	Ira Weiny <ira.weiny@intel.com>
+R:	Ira Weiny <iweiny@kernel.org>
 R:	Leon Romanovsky <leon@kernel.org>
 L:	driver-core@lists.linux.dev
 S:	Supported
@@ -6426,8 +6426,8 @@ M:	Jonathan Cameron <jic23@kernel.org>
 M:	Dave Jiang <dave.jiang@intel.com>
 M:	Alison Schofield <alison.schofield@intel.com>
 M:	Vishal Verma <vishal.l.verma@intel.com>
-M:	Ira Weiny <ira.weiny@intel.com>
 M:	Dan Williams <djbw@kernel.org>
+R:	Ira Weiny <iweiny@kernel.org>
 L:	linux-cxl@vger.kernel.org
 S:	Maintained
 F:	Documentation/driver-api/cxl
@@ -14686,7 +14686,7 @@ LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
 M:	Dan Williams <djbw@kernel.org>
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
-M:	Ira Weiny <ira.weiny@intel.com>
+R:	Ira Weiny <iweiny@kernel.org>
 L:	nvdimm@lists.linux.dev
 S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/

---
base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
change-id: 20260504-change-maintain-file-8f033435619b

Best regards,
--  
Ira Weiny <ira.weiny@intel.com>

