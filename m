Received: from esa4.fujitsucc.c3s2.iphmx.com (esa4.fujitsucc.c3s2.iphmx.com [68.232.151.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E49343169
	for <nvdimm@lists.linux.dev>; Wed, 14 May 2025 06:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.151.214
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747205504; cv=fail; b=PUYIcltAhz27vi2mPUxvb10CgwjOQ1DMTBfVJ4hFcgr5T2UWhClA+kUwyXsJMN/qboWiwRXcEkIK76YxySpRGPrF1wu6tJeOWvP4dLgei37B053A6xpFjIaA3rFMAWABsrIZ9O2M0nf1/xxI0vPNIusO7tBb8j5zp4XiTXRJRq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747205504; c=relaxed/simple;
	bh=PCoUHYxc3blxWjK1GaRIXZVUV0A9ydo3dwJO/w2Trts=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A6hk1JSURnW/l0nvETE8JvDIlmZiKJ4jALsr6vb66gWF0AeKWowi4vEoCyXFfSfj+xMcRzYayrQyzKy+fckdal77agl3dRHh00+sxlVnOYT22ndbWcqT66XAX5KmYCznORghCH2kA9p3I5l9cdZI+dlNVyZWhbUcDvhxn2h4BuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=urrM1cq6; arc=fail smtp.client-ip=68.232.151.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="urrM1cq6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1747205501; x=1778741501;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=PCoUHYxc3blxWjK1GaRIXZVUV0A9ydo3dwJO/w2Trts=;
  b=urrM1cq6RCGY4VP8BXMxZuIPC+ehJxSwvutGJ7VcnWS5CnmVV52qHxES
   WqmfdSrDooM634gddDi6iaf4xKau5U4kIRlt0xMIcJlDPwxhUcnVZnwaA
   QH8ZbxRKWhisv8+mlt/3L4JzZYy4nSQMQyP3yWRZpau4HQPlQmP8Dyjq+
   UZpAgJidl0XrINYGTtc5UMhibE7MxvYSBNgzj9h7GjstiQ1qfgM953eV2
   OqDbNd2L0A97H1q7nQ3uPqV1j8BjN3jcg+PbCa8QhooYXNjSH7QDcBLDN
   VG/blrqNJBV1adXKnnxs/XwDAUT134d1tthpx3qvwT9wT6ZIQJZVERscR
   w==;
X-CSE-ConnectionGUID: ZrzlePdjRFG8Q/fboErBcA==
X-CSE-MsgGUID: z7EEXF3NQ6GHZ7Hc6PE1Mw==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="68310384"
X-IronPort-AV: E=Sophos;i="6.15,287,1739804400"; 
   d="scan'208";a="68310384"
Received: from mail-japanwestazlp17011031.outbound.protection.outlook.com (HELO OS0P286CU010.outbound.protection.outlook.com) ([40.93.130.31])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 15:51:32 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=in+UNuPcOZzGDyv+PMr2SoW9ROnFHVEf+lUme4/0dNMA1kDJzZReCOuGMVgMwAlhjzDvhnx535XpDQFm6zmjqscMisuYANXIVGN2Y++5yRvt06nHuKl6C8QCYw2S+EK2jFI8E0c0nbamruEAtj4qjbkz+7f0oeQmwZqNtD13YjnUlZbux0sCZodZ/WjCU/5sdE7twNz2DFPYtpS7i1ibwBVPVm/tC0V9IpJA1jugIHfLwY0JbUX2fRvxs2p5enLRxPFBbHUn2Z3q98fzQjHWZuKb9FCE/lofGJh2mHQPY/s2yYo65+zQlyaspMZ9ual+KuVMfUOV7lThBnL2Aa+NwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCoUHYxc3blxWjK1GaRIXZVUV0A9ydo3dwJO/w2Trts=;
 b=VBWWtA/n7F7QKoknOIwsMtXQVMXhZbPksqAtoNcVxhsMg7BeDQc7UIUVABsxznbdjSr6hSY543gEYUBlPpgXPto1w82aOFHVOTEMukZ+SMH+B8U0uPvDZlXAJjJbRIdUrYj6pJrHYrnKAEw1utpI96L1lM1QN8wEisJsgmml4nJnOQzlsByBMGeC+VIdybtw4aWDyXR6vqikMAHFT+kUbldx5UX7IyIk4lncJckrYKxVi3LM+6jU031d9CDBGZep/BlrBf71FlWkMrYwDG2rniwARBD+O9Ck6QfBnAJ8l8eKogTii0L/zjZub4+Mt1A1Lkiewhg2vAbhKd40xoTQ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by TYAPR01MB5674.jpnprd01.prod.outlook.com (2603:1096:404:8054::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Wed, 14 May
 2025 06:51:30 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%6]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 06:51:30 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: "alison.schofield@intel.com" <alison.schofield@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] test/monitor.sh: remove useless sleeps
Thread-Topic: [ndctl PATCH] test/monitor.sh: remove useless sleeps
Thread-Index: AQHbxHFkEuPiYv6KpkWgJeIy3/R7DLPRsFqA
Date: Wed, 14 May 2025 06:51:30 +0000
Message-ID: <e5959f9b-3ed3-4872-b55c-b2d3b21b54b6@fujitsu.com>
References: <20250514014133.1431846-1-alison.schofield@intel.com>
In-Reply-To: <20250514014133.1431846-1-alison.schofield@intel.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|TYAPR01MB5674:EE_
x-ms-office365-filtering-correlation-id: 91f288fa-237b-4259-c70e-08dd92b3c20b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|1580799027|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?L3JBWnZjMklXQTVLbDBoUk9ud1dFUFhDcU01cHpTdjlnUWgzbThSeHZ0NkI5?=
 =?utf-8?B?L2dnbWxHUElaclY0UkdVQWVveTVFaFlWbGR3VEJaR3B6dFhHeVNlNkw2VnR6?=
 =?utf-8?B?ZjBHNjllZ1FiRTZzMDlMRjg5anZYSUxGait6VThaS1F3RnZzWlRqeDQ3WGlu?=
 =?utf-8?B?RC9mcDliUzJwakxpMEM4Z0pBZ3BWVStOS1VQMmNhcUdXaXdBWHh3bER5aTlG?=
 =?utf-8?B?OUhMLzhFV3l1NTdSR3JHVkpmeW5uTHNmRGhaNUJEYVNGaXZLYzFWVURsQVB5?=
 =?utf-8?B?Umx6Y2JiUHhoMURkVDBhWitoa2hZbGpNcmFzc3FTMDBaQVVSOUhmOW83bmtQ?=
 =?utf-8?B?R2Y2emszbmc3Q2NjdlpvWDdlYksrQlQ0b25TekhXem9xN3lic1IwclkvbWdW?=
 =?utf-8?B?dnJaSGpDYW04a25FWXFMdUZ5cm9YZ1lQM25Icmhnazk4dE0zT21zYUJycThw?=
 =?utf-8?B?emtudzBzNm9JY2d6eWUrTUk0WnpwbzNjdStVSlZta3JPbjh1b2pmY25WTjNX?=
 =?utf-8?B?cWxaZHQ2alNWbE5KWU1RRE0vWWc4bWtZS2RuMXoxSXl5L1Z6cWhmQTFHWUZq?=
 =?utf-8?B?Z2pQREVCY2M1elVNTDRVS01MYzF5L1YwOWpLdkgwVHNtVlFuVGlCczRlRkR0?=
 =?utf-8?B?aG9UWmZaL1luejJsNnJueDVLSzRvd3JXV2phK2FDTnlNckZFaWw5dVRZaTFR?=
 =?utf-8?B?d1lsY25DZ01OclVZbkRjV1NabHJObEM2dXUwdWsyL0lqZldCdmhGN1ZCa0Vw?=
 =?utf-8?B?TGErQWFHb2tlRXE0UWRDR0tXUGdzc1UxYm5EK0R0QUVhMTRzcjZIOHlHN1pB?=
 =?utf-8?B?OEVidHVnelRZVmQ5WlYxY0VFNmF5L0lEU3I2dWhNZmVvalVHdGJhd29CRU05?=
 =?utf-8?B?R0gzbWFMcGJNMjArMUQ4VHVSNjV4TlpWZTByQ1hyTVBPTmhTMXpXZk5RM1k3?=
 =?utf-8?B?NzZHVm9NVVFMZWMwZWxzd2UyVlVzbHMxT0p3VmZPT3ZRMmJhY1JuMXptYWpT?=
 =?utf-8?B?Z1IweCtlSW02NTYvdlcrM0VKdUQvQTllVW9CM3REQmpkdU5rWmZuUVpkcHpC?=
 =?utf-8?B?WTF4TTlnRVhJTVE0M0hPMUxGZ3hManJpOFJiMk1WZGRocXdERE9pWDNJT0E0?=
 =?utf-8?B?Yk1YekxFdjFHNzNMMTdmYmpieW5zL3BvemM0S1Z6Mlgrd1J1RVVCMFhneVRm?=
 =?utf-8?B?NHZqWTF6N2kyS3VwZndTUFZrUXBPY3RvZStaMEliSjIrVUZZTUVNZVIreXlv?=
 =?utf-8?B?OHg2Q0xvS2d2TDVhYWtsTnc2elpaS3Z5K1ljbGVvTDR1M1hLNjRTOUMxNjJ3?=
 =?utf-8?B?QURtQ3JtT0RzTHhrN3piR3A0M1FGVnVzUG5OWk9LdWdkdy9XRExkaHpRNVVY?=
 =?utf-8?B?WnlFeTBQdkovUkNXNzB5NWNOdGpKbWdKa3NEMGpvamVlaERBS3RCUnZibVhm?=
 =?utf-8?B?VkZUcVR4MDk5TmVabm9RQlhBUHRnL2N0UkdnNXYvZHptUVlhMERsNnFvM3Nl?=
 =?utf-8?B?ODRrL203cWVwQkxiU3FveE1FQ3NHNWJKcG1mNlh1V0RMQ0I0eGhKN0NZc0dv?=
 =?utf-8?B?eGpOOU01MGxQK3NJZ25VZGk5YlRGWmhnMU04cDUzazlPUWFqTkxJd3Fhdk5z?=
 =?utf-8?B?NHh4SUxKZ3dKRTAvY2FRRWcyU0tTWG1iQU95U0d4UXdsN2M0R0pxaGxMclJI?=
 =?utf-8?B?NmZ0SC9oa25Vb0VlV0pIRTdRVmdsOCt3VFlXRzJiY3A3M0NnNHBOVGFmbzND?=
 =?utf-8?B?T0JQS1dWNkdQTml1K0l4dXQ4M1NlZEg2SzJNNHB2SWpwYkNkWmI2eERsTERH?=
 =?utf-8?B?YURndGxLajNKUGRHWnBiV1lEcis2WGlNSXlpeTVNNmtrdFNpR2dZMXFNRHRl?=
 =?utf-8?B?U1ZhNlp0TW5UQmY1SEVYaEJ5MWQyNUZ2NjgxT2ljdFR5N3AwYWpFRGgySU5H?=
 =?utf-8?B?KzF4Tm5wV0ljUC9QMzRTUUlhRWhxOUZlNlNjQ0MzU3BQLysyejNLTnlkMlM2?=
 =?utf-8?B?WDNXMFZHY3JyWkVhTSt1UzdKZ2dQRGJuVUpPa01STlhvdE9mNFkxNjUyV1ov?=
 =?utf-8?Q?rmbK9/?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(1580799027)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VTdKT2toN0xac2NNcGNlM1NOd25KTTNndWpCVjUycTY5VW13ZzVkMHhtdFZV?=
 =?utf-8?B?TDNmbk0rZFBKT3FJY0hhVFNmWFMvbVkySnZ3QXFhbXdCZ2U2VEpLSTh3SDRK?=
 =?utf-8?B?NTc5VFh2MFNEekFTS0JVUm8xRzkvdzZRaDF4MFEyZUdWL1NsMzJmWHd5RVVj?=
 =?utf-8?B?UDJyUDAvRzhSbWJVOTJXdG5DZGlwVHNZcU1KeGJyU2llZ1IzRDNBVmt6YkR1?=
 =?utf-8?B?ckVBaEJydGpUazRzRVEyZVZSS0ZPeUVheVd2cFpiUHVoT2Y4NDJqYVRqMFpP?=
 =?utf-8?B?KzArUEZPYkkrSjcvMUpoRW9acFVab3hLa3k4aENnYU9LdXdzTTY1OFVUMzc2?=
 =?utf-8?B?bDFENjZvQ3Ixb09pR2xkdm0rQmJsYTByeGgxbUR2YnlWT3RPMk8rRFhYZ0cr?=
 =?utf-8?B?SWM0UTFSVXhubUZCaldMVHR2Q1NPNmdESXR5U0pyajFtbVVqdjlvV2o4UjJl?=
 =?utf-8?B?SGV3ai9LZEo3bWtWaWViaThxU3VkSXdBaHQwRFJFMzRnNnlYbS92d2JmclBM?=
 =?utf-8?B?VDR4SFA5QW0vTm5YRTJWUmRWckU3QTltandhV21zTElrOU5xVjBHQVpZbGdk?=
 =?utf-8?B?Z203UFpVNURpbERJVFROT3FkL2luenJBMU5PS2E0a0lHejVPR01wOGEvRjBk?=
 =?utf-8?B?eHZ0Q1JYeDc0bjcvV1VVTWxPbkdLdGpFV1htb0xFdVo2bFZ1ZWora1M3VzZC?=
 =?utf-8?B?VEJ2ay9OSTg3N0tUVEpjWEFYeXRhdHM0MW1hdVFhZDFNclhOelBqaVVSSWJh?=
 =?utf-8?B?YktMMyszNVVxUTNpWS9KMHZqK3p2TitoUmxIZkYwYTZ4bUlxc0tpRzZDT3R5?=
 =?utf-8?B?aGRpbFN5WUxTUzE3Vkc3aG1VQW1BeU1yZmlNSm9Bb1FvdnJTeXM4VzBHdzFt?=
 =?utf-8?B?NzJLaEhyVm1PYkRXRVZkMWN0YXlBQm5DQ3c4ek9DV08wWmlMR1FZZGRDMUt4?=
 =?utf-8?B?UVFya1h3dmJsWHFBaFROZTEyenVSOUd5bnRXdWNQL3UvNFRXVUViU2lGekoy?=
 =?utf-8?B?V1JLYjRhL0JxSTJqc1VsR2pWSHl1Q0FBUlRvR24yZGwxa2wyR1Npdk1Veks2?=
 =?utf-8?B?LzNEVmJBN2ZEV1dneU5JZUlBanhhOXNEUzl5Q3dUSHRhVHRGcnNHd2Joc1Nq?=
 =?utf-8?B?MmcxUVR6RFhYWjg4RFRpUFF3ai9EMmd6S3JhaXR5Um1TTG5HbUR5VSs2TlJR?=
 =?utf-8?B?c01wVi9pM2pIWWNDL0FaUUZ0ZXNUWmhmVVJRZGFPbDBjVVlUNyt5dUhIM0RI?=
 =?utf-8?B?V3B1eEVjNE1BR0RpRytKN2dBZmNKS1Eyc3RmTFVaNTkreGY1M3BZb1VKbDN2?=
 =?utf-8?B?VjVnYWMrR3BycERzNFZ6MFVIWkwraHZuRTdlSVdsWEtQd0J0ckJlWFM3aTFw?=
 =?utf-8?B?bUsxNGIycUw3QWgvMHJtQ0lLOFVDL2cwaEI5V0hPYVJ1Y3YzM0E5VjdVZ2Jm?=
 =?utf-8?B?S1dVWm4yWk9aM3V5N3c0d05vZks2a0xwakdFNWJEU2xmdW9UYnJ6NXNMM05W?=
 =?utf-8?B?MFRSdnBwZUtsWVROa04xVHJUV0U0ZTNoNllvcmRsYkpMa3NIbWlPNVkxT2JE?=
 =?utf-8?B?aFMwSWV3UTNrK2t3S1NFeUt4N3d6SWlaNTB1SjNSd05lV2lsRmtpcGUzWXRw?=
 =?utf-8?B?QzhlNHp0b05HWmVWbFBscFA3NW5KdDhFbVVCTnlyWXhkTUFmbHFINFo1NlMv?=
 =?utf-8?B?UzlBK0U4QnAzbFM5UlVvK2hDbnZ3bitHQ0NtZzVrdFZMb0FlQTNuekRtRmpo?=
 =?utf-8?B?RWZFdlVtdU95YkVHNkFrT3FuYWxvSHZiQ1R1a2tDdy9KSzZHdmkzWTNldmQx?=
 =?utf-8?B?a0EwZWdlSWFvVXgwUGwxcVBPZUNIQ0hucGpLM0Jha3ljWEoyZTRYblN5VFZp?=
 =?utf-8?B?TDlxWVdFL3hxMFkyNk5ZQjRCcWpUcjFFUjBTYXpPOGNiVWtUTTlPVm9qVFEr?=
 =?utf-8?B?dkFaSUFPWEwxdmp4QjBFWlVvMW14K3N3dU9sM0VMNEZHeVZBaDZuMjhSV0p5?=
 =?utf-8?B?R3k5VDlJVUJUYzlvbS9JcU1wa3JLN0R2c2ZqQ2VENXJ1OEs2N21RbC85Q1NB?=
 =?utf-8?B?R0RkcHB1b3pGUUZUOC9Hb1BIN1lyd0tKYzZVSDhtejlVMi8zaXBSWWh4VVUv?=
 =?utf-8?B?OXB1dWd0M3pUTXlzVExNOEthNStneGY1UXlkOHVqa0ttT0xRdVNCMGU0QkYy?=
 =?utf-8?B?NWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <898E434EEC238049ACEA5570485B3C98@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qMLwL5Xpu99qfVZe2N9IO9e7trnIBiRIjG1ISipMQOdLLBlcQne8lr1Nz7QmnvvQjh9jA+KPr8zZjZxukiDyN0EoafTCmqD4IWicXoP4HIQ9tgSv6u/T6xcYnaJYE5IPyPsW8Co6WeTelq/iMqgsKBRUmCMVpUoYPl9ZNVsZk5Z9d3S5JLRLnqB463RJ3K84aEVkojrywB4p555ng++vQY65QSA1TRa+/FJ3Uair8u/e7h+EFpXT/GNyEmlvlK5ymRy9QmnrNYrtD4JiBDukT1U0Aal75oGpF/vqOZu5P0ZAfLyQgMMnYY91eOF+6WQbyQdTYMg6/vsPZIdM74qS13EuF6Vw7lkLv660PG7c5GS2u9KxTPgwc9yWl33KuVyiUiNOqcl8FcALMsLcsQhG5mniQ9RV6qlpqHAakkOg048QWZlYCC08khfns8A1AT4WJ9JJMrnHW+wXW3DAcjRj0IpTHmFmRUt206hcmPEnBdFgV3B/iW7EzuxvtyVZAgrGVslsBh8qjGemfr7477/5d8fQPSp2oNauYQp9OrUKG+iJQF+p4IrL072w2FiKhjUbuvKq0WG3GDpMXU8XD28FKLxIiLiPFk2VuqraO/Ioi9jNXwAAMXzT7Vgrxu6BlQUy
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f288fa-237b-4259-c70e-08dd92b3c20b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2025 06:51:30.8645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ct3e/7KxqQDKbyx4ISykM0y69QkzuRjUtvpsI3l6Sh4CXWf4RZgDi2fpnBSbx0CzSavtz5/3Brmgd/CwnpgEaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5674

DQoNCk9uIDE0LzA1LzIwMjUgMDk6NDEsIGFsaXNvbi5zY2hvZmllbGRAaW50ZWwuY29tIHdyb3Rl
Og0KPiBGcm9tOiBBbGlzb24gU2Nob2ZpZWxkIDxhbGlzb24uc2Nob2ZpZWxkQGludGVsLmNvbT4N
Cj4gDQo+IG1vbml0b3Iuc2ggcnVucyBmb3IgNTAgc2Vjb25kcyBhbmQgc3BlbmRzIDQ4IG9mIHRo
b3NlIHNlY29uZHMgc2xlZXBpbmcuDQo+IFJlbW92aW5nIHRoZSBzbGVlcHMgZW50aXJlbHkgaGFz
IG5vIGVmZmVjdCBvbiB0aGUgdGVzdCBpbiB0aGlzIHVzZXJzDQo+IGVudmlyb25tZW50LiBJdCBw
YXNzZXMgYW5kIHByb2R1Y2VzIHRoZSBzYW1lIHRlc3QgbG9nLg0KPiANCj4gRXhwZXJpbWVudHMg
cmVwbGFjaW5nIHNsZWVwcyB3aXRoIHBvbGxpbmcgZm9yIG1vbml0b3IgcmVhZHkgYW5kIGxvZyBm
aWxlDQo+IHVwZGF0ZXMgcHJvdmVkIHRoYXQgYm90aCBhcmUgYWx3YXlzIGF2YWlsYWJsZSBmb2xs
b3dpbmcgdGhlIHN5bmMgc28gdGhlcmUNCj4gaXMgbm8gbmVlZCB0byByZXBsYWNlIHRoZSBzbGVl
cHMgd2l0aCBhIG1vcmUgcHJlY2lzZSBvciByZWxpYWJsZSBwb2xsaW5nDQo+IG1ldGhvZC4gU2lt
cGx5IHJlbW92ZSB0aGUgc2xlZXBzLiBSdW4gdGltZSBpcyBub3cgPCAzcy4NCj4gDQo+IEknZCBl
c3BlY2lhbGx5IGxpa2UgdG8gZ2V0IFRlc3RlZC1ieSB0YWdzIG9uIHRoaXMgb25lIHRvIGNvbmZp
cm0gdGhhdCBteQ0KPiBlbnZpcm9ubWVudCBpc24ndCBzcGVjaWFsIGFuZCB0aGF0IHRoaXMgc3Vj
Y2VlZHMgZWxzZXdoZXJlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWxpc29uIFNjaG9maWVsZCA8
YWxpc29uLnNjaG9maWVsZEBpbnRlbC5jb20+DQoNCg0KVGVzdGVkLWJ5OiBMaSBaaGlqaWFuIDxs
aXpoaWppYW5AZnVqaXRzdS5jb20+DQoNCg0KPiAtLS0NCj4gICB0ZXN0L21vbml0b3Iuc2ggfCA2
ICsrKy0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGVzdC9tb25pdG9yLnNoIGIvdGVzdC9tb25pdG9yLnNo
DQo+IGluZGV4IGJlOGUyNGQ2ZjNhYS4uODhlMjUzZTVkZjAwIDEwMDc1NQ0KPiAtLS0gYS90ZXN0
L21vbml0b3Iuc2gNCj4gKysrIGIvdGVzdC9tb25pdG9yLnNoDQo+IEBAIC0yNiw3ICsyNiw3IEBA
IHN0YXJ0X21vbml0b3IoKQ0KPiAgIAlsb2dmaWxlPSQobWt0ZW1wKQ0KPiAgIAkkTkRDVEwgbW9u
aXRvciAtYyAiJG1vbml0b3JfY29uZiIgLWwgIiRsb2dmaWxlIiAkMSAmDQo+ICAgCW1vbml0b3Jf
cGlkPSQhDQo+IC0Jc3luYzsgc2xlZXAgMw0KPiArCXN5bmMNCj4gICAJdHJ1bmNhdGUgLS1zaXpl
IDAgIiRsb2dmaWxlIiAjcmVtb3ZlIHN0YXJ0dXAgbG9nDQo+ICAgfQ0KPiAgIA0KPiBAQCAtNDks
MTMgKzQ5LDEzIEBAIGdldF9tb25pdG9yX2RpbW0oKQ0KPiAgIGNhbGxfbm90aWZ5KCkNCj4gICB7
DQo+ICAgCSIkVEVTVF9QQVRIIi9zbWFydC1ub3RpZnkgIiRzbWFydF9zdXBwb3J0ZWRfYnVzIg0K
PiAtCXN5bmM7IHNsZWVwIDMNCj4gKwlzeW5jDQo+ICAgfQ0KPiAgIA0KPiAgIGluamVjdF9zbWFy
dCgpDQo+ICAgew0KPiAgIAkkTkRDVEwgaW5qZWN0LXNtYXJ0ICIkbW9uaXRvcl9kaW1tcyIgJDEN
Cj4gLQlzeW5jOyBzbGVlcCAzDQo+ICsJc3luYw0KPiAgIH0NCj4gICANCj4gICBjaGVja19yZXN1
bHQoKQ==
