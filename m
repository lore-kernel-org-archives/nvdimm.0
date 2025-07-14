Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D50212B18
	for <nvdimm@lists.linux.dev>; Mon, 14 Jul 2025 22:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752532050; cv=fail; b=UlR8I0HRrgZf/Q5aF64kECqZhBcAkJz6FeQvP/5HG9G4CKFJSA2Ck8ZHZUiJm/I59K3VTE/wKJGeSS0MgvgCd98c+ZtF0Js+sqL50j6n9auOw2HwdI0TehDVNno0B2HVp0SeQZc0kzBmhsfwuL8b5rJrB5KXWjEhIQENgPKbtqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752532050; c=relaxed/simple;
	bh=uiWIMB2rmCxSjUxYQThGWrxadWEzaTUF7j6F75yMJAM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aryw9EZrQbs+QroOooH9Z55p4TDXBb2jmHu4ffXayg94A/ETTWeFKsPguk7fSoxKGYlKg7xj3kXhOfx+4k6hzZDyBTu3xoxdfF2RMzWW2azkreWNzEDZF0bYiO1iYyZkJ54mkwc/wqOSQMgO20C5+xrm6pfyPbgLHMEABMfh7d0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RoLLpgCR; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RoLLpgCR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752532050; x=1784068050;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uiWIMB2rmCxSjUxYQThGWrxadWEzaTUF7j6F75yMJAM=;
  b=RoLLpgCR27Kx4/nlWuzDT8JJAYh1XQYTDuBzcke0fTiRmAI68fCYPuGG
   JmAERWMC4LhA4BdND278818ZrDknkGG9PReh7mXkaU4GNjbHEFh73XTDQ
   YS8amOGfcA93WfMnuptc60huDL0KX7hufprvX8kyhUyO58C3Ss8o/Aekp
   WyR00/AL7oiJahQlqp1eTaGzZmBWYJbRUjJnnzDCUeVNIzYKA5j2MKxOH
   x1JAh7ylPWQA7s0cHxlsmNDRRvzbWgkDYNEWTdXxysWw0BGDcRrusJ41D
   BU6b7Q57n1G/advNnlgTVXDY7rXdyx+8QMUp6ksgYv3ucqW38WuJNjtCv
   w==;
X-CSE-ConnectionGUID: zK7e8uyVR5CDY5LMPHfv0w==
X-CSE-MsgGUID: tvxKmrVCS3+yZHHeFSwI5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="65805426"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="65805426"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 15:27:29 -0700
X-CSE-ConnectionGUID: ENrBAsbuRwG99cQcyLmGgg==
X-CSE-MsgGUID: a+EkvOiGQ9uzp0M6+iYjgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="157393365"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 15:27:28 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 15:27:27 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 14 Jul 2025 15:27:27 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.80) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 15:27:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fCOcEM4YCJTvq7P52s/GkaadGQTe+kOCsQ4KkTWgS7KPHmiIRktwUr4MXxdeAZNGitB/chaXgSAv/pdK/aI2s/KTL+TmwkEOmoqSWXpEOm8ozSrcMPcBXkXaPqDmD7j8FGpbOeXTQQiFKLNInrUm/CAGXYciqtMX6xs4f2x+HCu34mvCGkTDMzjbg7FBq+VukHh4N5YhyHHz1l9KX2IzRZ/MioIB+86CxpWKax8oLDzWoMnE4wSZ6kNvs9bXaYidhn5vbwt8TCzUIwygTv1GSLadaG0t+Fhp9D9bfEUXcOsgaG+Np9K1hE6MqRpYLT1wh3yM2BHiePkG6b0vLODppw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uiWIMB2rmCxSjUxYQThGWrxadWEzaTUF7j6F75yMJAM=;
 b=fCVQPQfbsslX0UUM1yg+do2md3z6kpbuzahgi7ZMYrO4p3WlfA0K0vSjbK0t82RMsLBUqi0E2vEQjPzuYi4QkzMbxxGgpKGC5vqp6i9VPlsSdtFByHv8iIHrncQlMT084ELCKpmfI0rekc9eRuspaH0a9KY+K1Bc5sZxwUcqxcjtDl7J/xMfnieWQWwYELRe6tYJBTb20lTRpLb/tRAa7YGLi8zd45V0ZtpS58P1zDs7aMuGQZ5zFgxuv4RKfKdu8dKXF25NUBAL8s7ZOci3FbPLiimDVt7yuWsmJ/4oHjeqz0q24m2hDbZHmB8nDnL8qLPa1sa0hPcm//J4+RxcoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SN7PR11MB6996.namprd11.prod.outlook.com (2603:10b6:806:2af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Mon, 14 Jul
 2025 22:27:23 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%5]) with mapi id 15.20.8901.033; Mon, 14 Jul 2025
 22:27:23 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Schofield, Alison" <alison.schofield@intel.com>
Subject: Re: [NDCTL PATCH v2] cxl: Add helper function to verify port is in
 memdev hierarchy
Thread-Topic: [NDCTL PATCH v2] cxl: Add helper function to verify port is in
 memdev hierarchy
Thread-Index: AQHb8rPujbg7xvpbM0+q4R0Rz+dvUbQyN4QA
Date: Mon, 14 Jul 2025 22:27:23 +0000
Message-ID: <4da519268938070b448f56d55535f0e3ea4585b0.camel@intel.com>
References: <20250711223350.3196213-1-dave.jiang@intel.com>
In-Reply-To: <20250711223350.3196213-1-dave.jiang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SN7PR11MB6996:EE_
x-ms-office365-filtering-correlation-id: 66740091-6bd7-46a6-9aa3-08ddc3259ad4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?S3BzMGI4NTVEVVd4TVVmTzV1T25HMERwYmJnTTFYVXpuR0pLcUFKOXR2YVRJ?=
 =?utf-8?B?YVFzR3B2aFc3Ni9xeGFUYkd4VVVjd1Z4OXBiaFNiL3NwN2Qycm1hYXNHNmQ2?=
 =?utf-8?B?SnE3aVp3WFhKZnRJbnNqYW8vRCtRL1k4bktwSlp4ZnBnZFJWUGovYzBnZ1pZ?=
 =?utf-8?B?cGpGaFhMRmpucHIvNmZWb2p1c25kUXNHYTRVaEpTY0RrcnJqU2w4ellaeHRK?=
 =?utf-8?B?SHBPS1d0a1FDQjdwMGJKckN6UlNrem03MGFQWVpkc0EwcitGMnBCZmRxTW43?=
 =?utf-8?B?QzBXR0pTd1pIZHNJSzFWelJBclpHMkloK2poQy9aMVBsUnNFcUpiM0dFWVZ1?=
 =?utf-8?B?L2tLaWdkOVl5WFJqT3FodmVKMDRDek9Ib1h2WjR1U2o5ZTR1STY5SFQyOUp3?=
 =?utf-8?B?SFYrd25KNi9iekFXL2JhT3hONWgybFNOYXJobHhCQzZIcFBLNHJFbHpYQTBN?=
 =?utf-8?B?MitxdUhBaXZ5YjB1SkVHRzl6OGs4VkZyeEMvNm16YkdGZ01KS005RmRvOXl5?=
 =?utf-8?B?WTVmQTFuajVqLytWUEg3aWhwSnp1UURaM3NLRXJoK051b1FhNStwMUR3dm1k?=
 =?utf-8?B?bnpHbENvbDFuOWlvWDJ6cUpKYXFYMWd5VU9yc1BSSEJETzNNT0hSOS9TWFU5?=
 =?utf-8?B?eFNRMTk2TndjRTBqL1ZJc2NaRll1SHBXUHFUM25nTVcrT0o1MEI1Zm1paUhx?=
 =?utf-8?B?UlVCZ2xSUkZuK2hEZjBWSWs0Rm1lTVJMdzZzVDljTWkyWk9URlZzbkdzenNU?=
 =?utf-8?B?UTI4azI5Z2FsMzlPSGhZUGEralpsYUdMeTBoYVhrd3M4RXBzYVhvRHJHRmZv?=
 =?utf-8?B?dTJUeVpObFVCWWdTdzlSdSs2ZnpTSTNiZmQyeFplWWF2NEV2dnFHUFUrYUlQ?=
 =?utf-8?B?VWxKNTh0TzhZMEN3STYvL0swL3d6Q0VtSUZLSVJDQVl4YXJGU2JsK1FVSG1D?=
 =?utf-8?B?TzNtNDZlekVNWWsrWkNlMzlhTi84QW0zdWg2Vkp0UUtDbGF1ckJDT0JRTXoz?=
 =?utf-8?B?SlNFZGM4Vld0bE42SG5tbmlvTmhpdHVDVk1FRTZyKzZZbmVLWElYZjJURWZB?=
 =?utf-8?B?bUZvZWxLVXpWbjBoZXErcjNPTit0ZStWOGw0Q3g0eWVQbFVCRGdSTmgrdUpD?=
 =?utf-8?B?eUhjVTlOeStYaXFnMHJOa3NJZnQrUkFiUzZ3c3NlUkVKaE5Sd0dNRGZkdFlu?=
 =?utf-8?B?Nlk0S1VPSFQ4WXhxZXJna0xRZ2xiRlVmZEplVkRWZGFHZmZPdzdRaTgxLzdI?=
 =?utf-8?B?RlR3Y0pQbTFnSGJGek9NSkV4bDhlTFdBV0ZBNWxBQ3htNjl1Z0tGZHIrMW9E?=
 =?utf-8?B?VS80N1hMOFdBUGFIWFNJbnhsa3BwN2k3Ky9LUWhMZG15UWhydUlnd1MxZXM5?=
 =?utf-8?B?anoyaUNZWVVMdWk0L3N6V0FYb2k2bERhbzI3bGEybytNRUZ4T0V5VFRCN0hp?=
 =?utf-8?B?VXBmc2FYaUl3TUJDMEJjdnB1OE1ReUpXQXBoZzM1b0FsNE1NbG0zaE1GRVRo?=
 =?utf-8?B?R3pCLzVrcitJM1NBUGlDazVtTWZreTVDRVNMQkxnaWoxSkErYWF6STBBWktX?=
 =?utf-8?B?c3hTQ2RRNEhWSUVNSFJxNW4xY2lkdHNodDZhazl1Y1NTVkZkSWpzZjA0b2Vr?=
 =?utf-8?B?Tmpjc1BpWHJXSjVsZDhBaGx5MHlSRERRYTB4aHoxNXROYmpuSkpOVUMyc2ZB?=
 =?utf-8?B?cjM1V2NYeEFBWWwwdHd0U1VQVG1KaFNVVE9rK3FVVWk5QThGYTBRTERGNWRY?=
 =?utf-8?B?S1Nrd2RaWEgwbExteURrWDhLdnVraGFHaEl4amN4UEZDYzNsMlBLaVVZZ1FE?=
 =?utf-8?B?OElLS1Q5aUgyNGZlNW9NblZpZGk3SDM2eTVEVlZXMExSeEtTOTFaSTNRR01v?=
 =?utf-8?B?dHlSdVlsK1hUZVZ3aHVqR0VtMlNtMGtkY1pRVnNxbFM0RG5ONHNySVZDM1BT?=
 =?utf-8?B?alVyb3BmWk5ESkpRWUFWeVNHNXYwMjdIRFo4SXFRbUFXb0lZbjlOTm45RzdX?=
 =?utf-8?B?ZXFYZk1ZNkVBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGpxMFdhQ2Rxd1RZVWV5aTBLTkJVN3lJNFNEekNSNVhsdS9pcGxnQy9Yd0tw?=
 =?utf-8?B?N0FtSUFQMFphOVpLelpRdDRlL1V2WGFvQjB1czZXdTJzaU44L2lrdkRERjFD?=
 =?utf-8?B?bkhVS2YyWUZWajVLVEZnZzZCRVFjdGlWc1dOS2w2NkZRSGg0R1RMZTJQcE9F?=
 =?utf-8?B?MDFRT2dEZHhRUHJCd1VUS3hpc3poZk1VYUwycTIrSnc0bzMzZHFHTnhBK2lz?=
 =?utf-8?B?N3MxRVlOSWFHUzJ5Y1AvcXppNDQ3cXNJR1F1MjIxT3JFcGJkYjl6T29qMUww?=
 =?utf-8?B?Q1BqVUFSUmMwRkVYMXVRbzBQNSs2RlQ1TXRIK3lwa0s3aENDMVcxcXJodXR5?=
 =?utf-8?B?UDhGZnB1em1GZlpadWxWbXIvcktyTWVySUxoTHJLYW41WlQrN0ZzUU5Ram1w?=
 =?utf-8?B?bW5QRUNPQ0NQOUxFc3pTVXl1dGZYUEdQTTNvV2ZmUkdoR1l6QUZHRGhncGJp?=
 =?utf-8?B?RERER2VyeXA3ajdtVDdiU1d4NG9DZjd0bGkxdm5XOXg0ajFoQzhHVkIrSUsx?=
 =?utf-8?B?MVJHR2M0Yk1Ncno0VDRKUmpCb2t3YnBLNWpoWUpQcUgrTWtNTFZDcnVYOWZv?=
 =?utf-8?B?cG5kWFNwMUNNSkN1ejNaSzczWS9HY2tHakdmNUZ5ci82MkRHMUxNL1R0UHJD?=
 =?utf-8?B?S2FqUUhRR3pDa0g5dlhNVjMxM3NjYm5QMS9Dc2hodzUxbVlBSFE5VEdXdjRZ?=
 =?utf-8?B?UFBFVU14VWpTeUNveUVubHQ4L2tXNjIwcS9CRzBnRWZjSGZKS0JyenM2cHpv?=
 =?utf-8?B?a0dTQWUxYU1DSGdaZ2FUbVNiaVZ0WDlCZnI1anJvaXBKdlVJemYwSU9RZXVu?=
 =?utf-8?B?YnZrTmJJTkN6SmhIamo1bWdrenNEMW5aSDZ1cXpSd1BHdmhUR3h6d05LT3BJ?=
 =?utf-8?B?aU9HaDdPeTQ2VmpheDFCbVloMFg5SjMyWUEralRncDg1b0lUOWhPbEpIUmd3?=
 =?utf-8?B?M1BHRmVRTFFGUWVaUzZESE9aeUVHblRrdFBnLzBGMjlSTDNFc01VRTM3RzVS?=
 =?utf-8?B?RjB5TmhNUjBIVERKZXE3TVpKMXlwQzJoVzBHc1JiODlZTlZ6cDQzVmZ1V0pz?=
 =?utf-8?B?ckNIVUlEYXIzQWJMeVhEYUg4VjlMUC9EU3ZxZnhJZjBCTFBpSGxwYVdvVkRt?=
 =?utf-8?B?Y09kd1l2NzN1T2x6Rml5T09jbWRCeDNDblF0OEY1N20vb21GbTFwazF4ZzBt?=
 =?utf-8?B?Q20wd0l2NXJ6a0Z5Rk5RbHJyeW5rYlRIZlNud3A4dlgwZzdPSWU0a3dTa0Jp?=
 =?utf-8?B?VjY1a25LR2swSmJjUTZZNFRIWW9Dc3owWmwwNUJiRHc2MGduV05tSEFhTXdB?=
 =?utf-8?B?cHpHVWdKU3NkTU9USnpjVG9GaGMzbEdlUG82ZWRHUGRVeVVlVE1JY1E2TEdl?=
 =?utf-8?B?Y1dlRi9PZVUvNTM5aG9yN2dSdVVLQ01BdVovV2ZCa295TDNEWmVLdUl2dHFX?=
 =?utf-8?B?WFlJQlg0ZC9hb3BUV2doVW9EYWJ3SFRmcWJyQjdEZXNNSlh4VXVqelhDdXNE?=
 =?utf-8?B?QjRiWE5QUlFEclphdzMzeW5TdkVHNGhBd2ViY2RhNXlvT1FmSkxMZ2M5aFhz?=
 =?utf-8?B?N05QaFAzbGc0V1V4bDRPQkxpWnVGTU5HYy82dUNuclBQY0wra1NEc0dmdDJu?=
 =?utf-8?B?Q0RFZzU1ZEhXZUV1dTNHdW45dXhBWGJoQWJHL0xpa0FET2dWNGdLRGpESkcr?=
 =?utf-8?B?WHJVOFJjTWdJZGIxV1psZkRwUEFtY3g1cW1sd1NzaTd2eXFvVGVjTHlVME1N?=
 =?utf-8?B?RlFMSWhGY3BDdjRycjE1bE85b3lrV05LR1ArQ01iVXB1LzJkTjEydldaZTVI?=
 =?utf-8?B?M0c5K2Nrb2p4cWpuYktvUVFtOXN6NlQvQStkaEVNcmc3RTlxdkd3TFBRMzFr?=
 =?utf-8?B?ckRNRkdnVWpXbmsybnZlNU5DbDlVWmlQeDZudzNHS0RvRVRKcDhvYUZVVkNx?=
 =?utf-8?B?NEZhdER2eEhBMHBNNjB5NElmODlKbDJZaGFWcmZvc2l2bVp6NGhCWERabnB5?=
 =?utf-8?B?MEVoN2lhU3Irc1dlSE8xNXVkNVpoSjlvbWpGSnBGK1NSNWV4UkRjbHBDMUpL?=
 =?utf-8?B?Mkdma3dqU04rRGtTY1BxT3Y2dzhoaVFzUm5tLy9wTWkyc1RWTzNhOUV4YlFT?=
 =?utf-8?B?Rk9PcVRtNmRMOWhJZVZldzlyemF3MzIvTldHeEo5eVVmcWRuSXV3bDQ1WGww?=
 =?utf-8?B?N1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B81EB3B147E31842AB22271A7BCD619F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66740091-6bd7-46a6-9aa3-08ddc3259ad4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2025 22:27:23.5139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WkvLjnH0YgdeaBhaoLtN71DG40a8QjrKL1YxfaMpkldSgqipC9vkAXv4u4VWJcBnzDQwIZZ6YYPKu/+6fnv/nNL00oaPaTpLF38QJYuYbKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6996
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA3LTExIGF0IDE1OjMzIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiAn
Y3hsIGVuYWJsZS1wb3J0IC1tJyB1c2VzIGN4bF9wb3J0X2dldF9kcG9ydF9ieV9tZW1kZXYoKSB0
byBmaW5kIHRoZQ0KPiBtZW1kZXZzIHRoYXQgYXJlIGFzc29jaWF0ZWQgd2l0aCBhIHBvcnQgaW4g
b3JkZXIgdG8gZW5hYmxlIHRob3NlDQo+IGFzc29jaWF0ZWQgbWVtZGV2cy4gV2hlbiB0aGUga2Vy
bmVsIHN3aXRjaCB0byBkZWxheWVkIGRwb3J0DQo+IGluaXRpYWxpemF0aW9uIGJ5IGVudW1lcmF0
aW5nIHRoZSBkcG9ydHMgZHVyaW5nIG1lbWRldiBwcm9iZSwgdGhlDQo+IGRwb3J0cyBhcmUgbm8g
bG9uZ2VyIHZhbGlkIHVudGlsIHRoZSBtZW1kZXYgaXMgcHJvYmVkLiBUaGlzIG1lYW5zDQo+IHRo
YXQgY3hsX3BvcnRfZ2V0X2Rwb3J0X2J5X21lbWRldigpIHdpbGwgbm90IGZpbmQgYW55IG1lbWRl
dnMgdW5kZXINCj4gdGhlIHBvcnQuDQo+IA0KPiBBZGQgYSBuZXcgaGVscGVyIGZ1bmN0aW9uIGN4
bF9wb3J0X2lzX21lbWRldl9oaWVyYXJjaHkoKSB0aGF0IGNoZWNrcyBpZiBhDQoNClN0YWxlIGNv
bW1pdCBtZXNzYWdlIC0gc2luY2UgdGhlIGFjdHVhbCBoZWxwZXIgaXMgY2FsbGVkDQpjeGxfbWVt
ZGV2X2lzX3BvcnRfYW5jZXN0b3IoKSA/DQoNCj4gcG9ydCBpcyBpbiB0aGUgbWVtZGV2IGhpZXJh
cmNoeSB2aWEgdGhlIG1lbWRldi0+aG9zdF9wYXRoIHdoZXJlIHRoZSBzeXNmcw0KPiBwYXRoIGNv
bnRhaW5zIGFsbCB0aGUgZGV2aWNlcyBpbiB0aGUgaGllcmFyY2h5LiBUaGlzIGNhbGwgaXMgYWxz
byBiYWNrd2FyZA0KPiBjb21wYXRpYmxlIHdpdGggdGhlIG9sZCBiZWhhdmlvci4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IERhdmUgSmlhbmcgPGRhdmUuamlhbmdAaW50ZWwuY29tPg0KPiAtLS0NCj4g
djI6DQo+IC0gUmVtb3ZlIHVzYWdlcyBvZiBjeGxfcG9ydF9nZXRfZHBvcnRfYnlfbWVtZGV2KCkg
YW5kIGFkZCBkb2N1bWVudGF0aW9uIHRvIGV4cGxhaW4NCj4gwqAgd2hlbiBjeGxfcG9ydF9nZXRf
ZHBvcnRfYnlfbWVtZGV2KCkgc2hvdWxkIGJlIHVzZWQuIChBbGlzb24pDQo+IC0tLQ0KPiDCoERv
Y3VtZW50YXRpb24vY3hsL2xpYi9saWJjeGwudHh0IHzCoCA1ICsrKysrDQo+IMKgY3hsL2ZpbHRl
ci5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMiArLQ0KPiDC
oGN4bC9saWIvbGliY3hsLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDMxICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gwqBjeGwvbGliL2xpYmN4bC5zeW3CoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA1ICsrKysrDQo+IMKgY3hsL2xpYmN4bC5owqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMyArKysNCj4gwqBjeGwv
cG9ydC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDQg
KystLQ0KPiDCoDYgZmlsZXMgY2hhbmdlZCwgNDcgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMo
LSkNCg==
