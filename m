Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA8323536C
	for <nvdimm@lists.linux.dev>; Thu,  9 Oct 2025 21:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760046987; cv=fail; b=WZ6cJy3SbsALcIe2AzvWEzQZR6BvqdoUsmdkW/x0WbxQgyNkC/WcsQlVeNhcdkPbWWq29CYhPb4GraCaLoKxc0uQajE1c96IztwGtJAlws6laUVF9Co+IFAGSB/KdowgmieAf+PZ1b+fukoeARYEat99mHaB0qPhperOM/HJtUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760046987; c=relaxed/simple;
	bh=0w0c0TDThBYPQKLGWE/XPR3I2/IgRMcVU6E6SUN+wyo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DeCsPnxvK7SIFWU9Lz+YIagTLMIRjojg6FeLAIa8bkuPT7fb9ZA6EQLmKQXUdIL+WmL8nrdTXqo1vANdybMTXXzao5oS2lGQEyoi3/qCIPgf+LBTdWkdZ4ENvs6R1MO30TcpyFG/JLXenShallxxfAw7a8+xVO9QHEhfU6U3uzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OoDNM/rQ; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OoDNM/rQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760046986; x=1791582986;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=0w0c0TDThBYPQKLGWE/XPR3I2/IgRMcVU6E6SUN+wyo=;
  b=OoDNM/rQ2hH7P8nmnC6Nr1TnC4ox5VgWeNYTByRji/OpVkwkaOxMkPfs
   KJiNU/OJ8vs8DJ30oZsbboVUBEImKos3m5fVFjQBvJCVZXNAlvyJWq5CX
   b8nfNmwOmPXEekgEI6mwhz0FhZ8P4/R2aDzGW2BJ0PkNdYOeHxuAjWUbp
   s3Gcz2lVY5v4zhvu4OKoE6WApVNab/ZeVTUlW4kPL+AFdPjxfyR7nNrFG
   8Vk55QkXup8g1WAZ2fNSLR+cQ4qsPjae8Cwtf6+S5ud0uWt2q/KKUyhkm
   E57n0rnkzAUpZEu4WyMrBfWCwKxGK3WNM3tlrMvfq7F5levsghoKHFdsT
   w==;
X-CSE-ConnectionGUID: SxXXS63ZS7OWb42MtARiaw==
X-CSE-MsgGUID: 4VKZrxdGRfuy3bB5phFAGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="66099072"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208,217";a="66099072"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 14:56:25 -0700
X-CSE-ConnectionGUID: kKehJtLDS0aVi3kwNL/cag==
X-CSE-MsgGUID: 483QHp37Q9OQDXqujDBzVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208,217";a="181240474"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 14:56:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 14:56:23 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 9 Oct 2025 14:56:23 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.16) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 14:56:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xUNgTtg92Ap4aSvU3gSOAL0ruj/n2V4vnB2xO713xmoC7t8UgqAZ4iVGr03Ic6ebwaO+lDJ5SVlXTaMpDsUD9c+4NzXRklqtSJPVoOHbfDzrZhbYyEiKuLpTPaIrMydJk1noC+jCuPjqTw7Untg4L1RgTJXXorL0QAgAPDNfRzFgNjHMpPgG0c87sXX9IwNcxwqCLDPp33Nw3mJuArECiQqQijaZqr9eznUZqALe9msp7QApc/jEG1KfiY8JEeOq/u4AyDMDts8fpCjSn/fhH22MGCpV3vhrmv9tEyL/pWDsNtnWN4OFsuJqKmANz1nHZgZ4iX5S6rhsvLi6dujlQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0w0c0TDThBYPQKLGWE/XPR3I2/IgRMcVU6E6SUN+wyo=;
 b=qbqz07QwITro9rknFt7Fq9Bof4nUNnhiFm2RigaU3c/jrPOQEa8TPp7YvTX1GBVJhy0rxCJMzUyNLNfSL20ved0nCAfldWa07/FlUUf2XEuOpLMfE208RyWl+96IVOe+AApp1YiT0SI/JIRu6AbGQ+NZuwySUbBAKFPoDn9KOuoYemcB/MMhEexnw/7URrFbPwa1/4TYmaqWj9u01TcsoR1iE9McGwaFUoPD7V4pWcvvXdXheUZr4uVvey5XRGqLglg5lH2PjgN5v4EdJT1sElqZionbIodxyc8Z73DJuQyOgJCHl8cpYeizn+vx4iDa2UfZulisRYutB6mXa4v2Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by CY8PR11MB7876.namprd11.prod.outlook.com (2603:10b6:930:7d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 9 Oct
 2025 21:56:21 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%4]) with mapi id 15.20.9203.007; Thu, 9 Oct 2025
 21:56:21 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] README.md: exclude unsupported distros from
 Repology badge
Thread-Topic: [ndctl PATCH] README.md: exclude unsupported distros from
 Repology badge
Thread-Index: AQHcMwnGmXzwMboAOkqY3DSfeiRAnLS6aQKA
Date: Thu, 9 Oct 2025 21:56:20 +0000
Message-ID: <ab8bd3c22f4cd0de61b676a466bae209ad9ab5a8.camel@intel.com>
References: <20251001192940.406889-1-alison.schofield@intel.com>
In-Reply-To: <20251001192940.406889-1-alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|CY8PR11MB7876:EE_
x-ms-office365-filtering-correlation-id: 63269888-c09b-4707-a9b7-08de077eae97
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|69100299015|366016|376014|38070700021|13003099007;
x-microsoft-antispam-message-info: =?utf-8?B?cnpYalJpdFhObE0yYi9LR1Y3dTdFUktTeDlJeTN5T1dxL09sKzZqYVRYUkhy?=
 =?utf-8?B?VFQveVZUT2xuMVF4N3BRUVlnQ2J3QjFEN2RoWTI0bng5TTkyNWI0U3ZYZFNZ?=
 =?utf-8?B?N1M3WlhpSzRGeVZyYXgzbkZQZFgvZGhQYTlvK1d5RWR3WUdrWE54SGRiWlNL?=
 =?utf-8?B?a2hxd3NyY0FNVE0xVWZ4QUN6OVFiaSsyZkRwbm9NUkRKUDBJNDF2eE1GeTZr?=
 =?utf-8?B?MDNoYXIrcWdsbWVzR0o0cGl3Qzk0T0R6TC8xWGI2UDJYYksybWZ6Vk9wWUhm?=
 =?utf-8?B?R1FDS1NHdnc4U29kVjdmU1F4MHVOdUNrU1JWc2U3ZzFoZTFRczhEU2NGV3Jl?=
 =?utf-8?B?ZDdBeGRqajl2WDg0T3l3QmNyeURjQjVDcEhyaHphQU1SZ0grNjVqRk5yNnF0?=
 =?utf-8?B?clNQc2NUUHpOY2RCazdCYWpzOXdqbndlY2YzUGhOZ25ndldqb0ZSQnlDTE1v?=
 =?utf-8?B?bG9ZdDFnclVoalhvV1Q2bDNFR01HeTA2S202Rk1ETE1RL2hTREhmYk9neC9H?=
 =?utf-8?B?QlA3bHdiUTl0em4yeDhsV3Y1cURlS2kwckt2R3l4UGMzTnYvbzhjem1QN1Zm?=
 =?utf-8?B?NDQvWXRVMHVxcmtaZDVCa0xmRVVCN2hSUTVPd1hMTTRCWHBCMTU4aTJzTHFp?=
 =?utf-8?B?YThnazF1MFVodWgrcE44NXdud3pZWDZvbVRraktoSHNwdVJSY0k3aEUwT1ZM?=
 =?utf-8?B?VVNXWjYwNHpOYUUvaUt3WUxqQTBRMXNWNWZheGluQ3JUY0dLM1JVQlViYjhS?=
 =?utf-8?B?c3ZQclEwT3Q3dVhVL3hYWUJzb3V1ZGI2OTdtNkl6Nlh6YU9oRXlFbFpiYVVM?=
 =?utf-8?B?NklHdWpXUmFXNnhFS0o0V3MydHB5czFUMjBOZ3ZkZW1DWGtDTzVtSStvanNE?=
 =?utf-8?B?QURDUGIzVE9oa2w2K09ZaXZKU1VzTmNDWjdGbUh0MFhZVDAzdWxPVnVsd1RE?=
 =?utf-8?B?Njh5UXdwWjUyQWVKaXpCUURjYzRXNWFHZ1h3WWtJVXpVcTRTRS9zM0FoaDVP?=
 =?utf-8?B?OVJaMC9sRVN3VmgxL3ppYXFMZ1VUVmdJRlRLTDJZTGtPSGh5U1hHRVpWMzB1?=
 =?utf-8?B?bjY0aHMzZzVrNFUvM25wUU5OWUFtcFdXQzB6YjhzdnBCdEQ0ckxpRDdmbXhS?=
 =?utf-8?B?SUxYRW5ZbDFib1VuQ2NTYkJYejZobFdnM2pzUzgxUWRRbE15UEhXWGpTRVdn?=
 =?utf-8?B?R1ViL0JRUlNnQVdESTdkMzFMNnFBZVBUa1UzV0VXeXJjdEVWekMwdmN5V01n?=
 =?utf-8?B?dFdDZURlU2Q3Tk5FWTBHV2tzMDQ3T2lnZ2p6bHpuSXk0cWcyL29OcFh0Vmxs?=
 =?utf-8?B?SDI2MWlmVVR4L2NTdmFXQWphWGU3VzRSb2RZc01vbS8rNTBGaG9zSjVpQzdL?=
 =?utf-8?B?aFdvYXJrc2FEOVRycDNSdlQ5b1FCbEtTMjZwcVNJbExnaTh0K3o1Q0FTU3pH?=
 =?utf-8?B?MlVGWDdIVDRNdHdKODBvTWt3WE9KV0FObStZcE5paTFrRVVNd25pQ2NhaE9a?=
 =?utf-8?B?U2drSDVrSk5xV0ZzYVIzaHB2YXo2NVUvMURIY2tmajZ3dWo5OHh4ak95RC9V?=
 =?utf-8?B?enY4U0Q0dnVHZ2U0ZHcrL2wxY3BoV1Z3bXlpbmZ1Rk9WbzAyM0lUTU5sVnIz?=
 =?utf-8?B?U3lXU3Z3NzEvblc5cVQvanpDV2kvRVVpd2lLTjlPbm9HSkd3N2J4REpjU2l5?=
 =?utf-8?B?dW03T2oxc2x5U3ZQUnRNSG9aV2UzZmJpdkJWNVVqTW92S3lxWjJleGlzSVFR?=
 =?utf-8?B?bmMyREdxT1F2SU8zTWdXZUhxU3VVYkhJejNrSW1GeEVKWXhtTUdadTNaVmUz?=
 =?utf-8?B?RGlvYXhUOVhCaGZJODBuTEt0d3hkWE5LS1VGK2hlZEZIY1FINnlUd01kSGNj?=
 =?utf-8?B?Y1NHTVVDWWpRVU5SeTdER2RzczhSZG8vOFhrR1Q3WkhRenVrNFVRZS81b3pn?=
 =?utf-8?B?OFZWU1hWYTduemkxWDlXRktHMnZPS0dmdmJTTkhsQkdsQkFDUWNkMnJkYUVX?=
 =?utf-8?B?ZHNvYXhrVlNBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(69100299015)(366016)(376014)(38070700021)(13003099007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ym1aWFNlRkZSTG9scnJnS21BbjhzeGdtcURlRHQvcWE5THpnVWNwYUJSTE4x?=
 =?utf-8?B?bUQzcE1zMm5tOWo5YXluTW8yMmx6eW9sUzVEWU01M2xXUkZpREFKZVZZTkZZ?=
 =?utf-8?B?czFBU2Nabm1EVnQ1V0JhU0VWQ244bmx4eC9uejNiZU1kYUxLMG5JbmkxdWRm?=
 =?utf-8?B?dlVEVXVEZW9Cd3RkSmxpdloyZ0lDdlozNmRyUGtnU2JiY2FPT3cwa0w3UXZq?=
 =?utf-8?B?S1YvT3V5ek9EZjlNZ2dwZ0hxeDlDRnNEbkwxVmk0QXR3VHZkK2FRdU9GUy9K?=
 =?utf-8?B?OHhaLzNGTWYxeHNMRVpGckFXN1VJbGNacVdRNVJuSWcyTGVpaWxBQjNZeXhw?=
 =?utf-8?B?V00zc2Jzem5JeXc1aml1aTNxOTN3MjBtaGtFckFmbnNabTBCbEhsM3RrTGhM?=
 =?utf-8?B?Q0hpSzQybDdIK2pDSEV3SnROdUhYU3dXdEVNRlpxNFg3T1VsOU1OMmtXYlc5?=
 =?utf-8?B?VGx3ZHlhNmlPV2x6eGt1bnYzQnViNHFmSnV3dWRSVW5CSGJaU0Z3K0VnZGJj?=
 =?utf-8?B?TCtyc3dwWm1CTWRXSkN4VGtBTGZoQTF0OGt4YzZCTGZUTXNSczV4UGJTU0Ix?=
 =?utf-8?B?VUo4b3FzUWhKUEtFdGhUcWRRREtSYVVYamdaRzR2RG91N29KMUJxNDZacFRs?=
 =?utf-8?B?N2IrcklFQUtuaVNzTnFWVXpvWGxVYktlT3ZsNlIyUEovWlRmclpUbFNBQ2l4?=
 =?utf-8?B?OTFYRFRMSEppanh5NHdzdXhYR3JWNXV3V2xRUEV6Ylhhc2VXQ2c0MFRrVkph?=
 =?utf-8?B?SEVvbWFwSnVVL01HUHlGVnRZSC9HWDBPU0h3ejl5Q0x0WDcyZmlYdjNsVFl0?=
 =?utf-8?B?WUluTUlaT05WU1VzQmphTDFORFB1SFY5Uk1nd3F6T1VLNmRvN0VNZ2NjVGow?=
 =?utf-8?B?T21NR1BLNVZXZW1iY2l1T0hNdlY4R0dMNm4zajcrOXIwUjl1WFFzbHkwUlNm?=
 =?utf-8?B?cmx1elNjQWZZR1g3QmM1cmtnRVdER1o2dDc3NHR4bkRBY0ZUVUIzWlI2YWww?=
 =?utf-8?B?SGwrdFlyYXIrK2k2OXpxUXo1TzlLVThtbjJjMjg3QTNMTXdGcHV6OTZGM3ZY?=
 =?utf-8?B?RWdLOGptSFM3TVFjWkFteVAwblVEbUcxRkEvaW1ucFNSUWp0Wm80bEZ3blg3?=
 =?utf-8?B?Qnp1TVlEY0NGVHJNcUZuT0xIcm4rbnVDQjUyMTdhK2dYRSs0UU11NFEzNEpN?=
 =?utf-8?B?Q0VqTEhXbTN0MGMwbTg4RTdzcGc0QzYyWXBHYlorUHRvMFZCT3lsbUtOQ3F6?=
 =?utf-8?B?TVFDazlyVUI5NTh6eG9JTEZCZFZaSERieWpTczBsN2s4RTE5NU5lQ09GS25x?=
 =?utf-8?B?dm9IUnErcy93cE11SzFIMVZlRHg0WG1DWTlCZkxCclp2ZHRYREpZUmUxY0pp?=
 =?utf-8?B?ZDRvV2hUbEltUE5OSjhJTnBrSWFqTlVkYllObE1JNkFxQW5FTDhNL1l6c1dZ?=
 =?utf-8?B?cEk1RkFoV0NNUHJqcklOZnZSUi85YVl4WXlyVjBXcjQ0eTVsTDZJQ29LVDZ3?=
 =?utf-8?B?aEFnYkVHNER0MGsyejRxaTl6eHhnSFJWRW1OYVJ4NXhlWjh3SmZsY09QS0sz?=
 =?utf-8?B?ZDFzNVF1b3Q3aGZoT0d5aWFWWVhBWmRibHJFekFLNWcxaWRSQzJpRmxCS2hv?=
 =?utf-8?B?QWZjSmJGUGkvOFhWK3hYZ05DdHkzWXBHUXk4MGt4QXJwR0R6alVIWUJtcE0z?=
 =?utf-8?B?NVVpdCtzalJqZmVpa3pydGV5QW9obWFaNVh3TVhiN0xuUWpWY2ZlRlk2V1lK?=
 =?utf-8?B?SXgwNUFuTVgwL3NvV2k4alpRajZGVWRzZUNkREladlFGMVhDSEZoWjRPM1Vk?=
 =?utf-8?B?VllPODM5QVR4d3BkUDMwalpsVlRKTE1UdEpjRDRQRzRkd3NoQnNFeHRUTDd6?=
 =?utf-8?B?alN5UzFMcVRrNzVKV3FBbzF5OVRSZ1VUc1VpUWtoSWVTeUsxS0p6eWxZMU1V?=
 =?utf-8?B?MEVxNVlKeU9SbEVlMDllTDE2OGNnZlJUUTk1T2VFOW15NWRGSys0OVhWOHBt?=
 =?utf-8?B?VU8yakhxNFM4Z0ovOUljVHpob2ZiL3gxcTluS3l6cnFvSVU5UVNEQW1jdlgr?=
 =?utf-8?B?TEx2cmViUzVLOUw2bUJOR3g5NmVGREkwUlZFUmFmZ3FVZENPVldINFpkWnNh?=
 =?utf-8?B?cCtxU3IvNVVuQTh3NkNPMWpJWnNmTmRIUXpiVlpadHhEWTh3MmNySXhuVVJW?=
 =?utf-8?B?T0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <739EEACBF4C12B4FB6F010993077C972@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63269888-c09b-4707-a9b7-08de077eae97
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2025 21:56:20.9612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Qkq4cifophcdYyrLIbPGWz7QiuKHKr7urjL9gC1wNS8hYchzRqYCZL6/AWjTt9qjjtDgbsKHRddJlbLxC9Ckx4/Ixb9ReMwBb17371ME1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7876
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEwLTAxIGF0IDEyOjI5IC0wNzAwLCBBbGlzb24gU2Nob2ZpZWxkIHdyb3Rl
Og0KPiBUaGUgcmVwb2xvZ3kub3JnIGJhZGdlIGluY2x1ZGVzIHRoaXJ0eS1zZXZlbiByZXBvcyB0
aGF0IGFyZSBvYnNvbGV0ZQ0KPiBvciBubyBsb25nZXIgbWFpbnRhaW5lZC4gU3dpdGNoIHRvIHRo
ZSBleGNsdWRlX3Vuc3VwcG9ydGVkIHZhcmlhbnQgdG8NCj4gbWFrZSB0aGUgcGFja2FnaW5nIHN0
YXR1cyBtb3JlIHJlbGV2YW50IGFuZCBlYXNpZXIgdG8gcmVhZC4NCj4gDQo+IFRoZSBmdWxsIGxp
c3QgcmVtYWlucyBhdmFpbGFibGUgb24gdGhlIFJlcG9sb2d5IHByb2plY3QgcGFnZVsxXSBmb3IN
Cj4gdGhvc2UgaW50ZXJlc3RlZCBpbiBoaXN0b3JpY2FsIHBhY2thZ2luZyBkYXRhLg0KPiANCj4g
WzFdIGh0dHBzOi8vcmVwb2xvZ3kub3JnL3Byb2plY3QvbmRjdGwvdmVyc2lvbnMNCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IEFsaXNvbiBTY2hvZmllbGQgPGFsaXNvbi5zY2hvZmllbGRAaW50ZWwuY29t
Pg0KDQpMb29rcyBnb29kLA0KUmV2aWV3ZWQtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVy
bWFAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiDCoFJFQURNRS5tZCB8IDIgKy0NCj4gwqAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9SRUFETUUubWQgYi9SRUFETUUubWQNCj4gaW5kZXggMTk0M2ZkNjZkNDMyLi5hNzFkYjI4ZjYy
ZmIgMTAwNjQ0DQo+IC0tLSBhL1JFQURNRS5tZA0KPiArKysgYi9SRUFETUUubWQNCj4gQEAgLTQs
NyArNCw3IEBAIFV0aWxpdHkgbGlicmFyeSBmb3IgbWFuYWdpbmcgdGhlIGxpYm52ZGltbSAobm9u
LXZvbGF0aWxlIG1lbW9yeSBkZXZpY2UpDQo+IMKgc3ViLXN5c3RlbSBpbiB0aGUgTGludXgga2Vy
bmVsDQo+IMKgwqAgDQo+IMKgPGEgaHJlZj0iaHR0cHM6Ly9yZXBvbG9neS5vcmcvcHJvamVjdC9u
ZGN0bC92ZXJzaW9ucyI+DQo+IC3CoMKgwqAgPGltZyBzcmM9Imh0dHBzOi8vcmVwb2xvZ3kub3Jn
L2JhZGdlL3ZlcnRpY2FsLWFsbHJlcG9zL25kY3RsLnN2ZyIgYWx0PSJQYWNrYWdpbmcgc3RhdHVz
IiBhbGlnbj0icmlnaHQiPg0KPiArwqAgPGltZyBzcmM9Imh0dHBzOi8vcmVwb2xvZ3kub3JnL2Jh
ZGdlL3ZlcnRpY2FsLWFsbHJlcG9zL25kY3RsLnN2Zz9leGNsdWRlX3Vuc3VwcG9ydGVkPTEiIGFs
dD0iUGFja2FnaW5nIHN0YXR1cyAoZXhjbHVkZSB1bnN1cHBvcnRlZCkiIGFsaWduPSJyaWdodCI+
DQo+IMKgPC9hPg0KPiDCoA0KPiDCoEJ1aWxkDQo=
