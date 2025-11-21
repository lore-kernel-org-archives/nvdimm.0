Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116BF29408
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 00:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763686742; cv=fail; b=mcPCwjKoYiPXYeeP4fq/aqS6kPw2OoTrQGVsadT0SNy1tv+fO1lshtQeGEhnVqLjauWo+VoSJNff/qKxvi3U4ijSFazKoFA1S1O708NLk+EW4RFgk9XHp82omI8Oa2EBpGh/7n9VbtrqCHycCpkVeY8YVLwL5uwdHOuVVUK/v1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763686742; c=relaxed/simple;
	bh=hPZ/GieJlGFEzuQdiAWWnqeS9NM1w2wSwfMUI8YN1h0=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=HgEfM066D8QlkXFpoNADwr2YswSabMvMeSwgKdMWDfkb39r2mzDDxCVmdOtWtJ465H3p0gtzc5FZ6wFTr9PyiZ2u8k+2e54RouMBZ1ThM1NYKsvJVP36uflcZOvsJer9YLVZF2pcIzF+e3JjMi06KPwt6c+6yz7cRsITAu/CnFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WCu8swJr; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WCu8swJr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763686741; x=1795222741;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=hPZ/GieJlGFEzuQdiAWWnqeS9NM1w2wSwfMUI8YN1h0=;
  b=WCu8swJrltlhrd0OEvmvMcAMrJcIbPDDRsj6RXBp3Ccsbs/IhGfCexLM
   giWKbvVOe19hNUYgfB2G8cCJkqBnoGQWkdHe4k2cBv+wRWzEsMcuGeq/q
   sJafiKd9+pi2YTH2sCUagRU8BMcukZXuaXwyBgSii5uD+kkuJgPE6gg5c
   jDrALTByLirE9YoMNNJpHtfUlpzn94OQOP9aplvdywOpPB93SJsEcL6Sh
   +IXe48pLNNx8YteSdTO1yZUcmoqsnq6RKKFQnOq3RwwkSy+Yb4On3xgp8
   TfIO3wwIS8nVpY977mmBHeranmc/mPc7aHmPWT74WIFdQVLGZbEMz8kKp
   Q==;
X-CSE-ConnectionGUID: p5+1GWH2Rh+sQg8vJZwUjQ==
X-CSE-MsgGUID: z1Ij0e4HQn2linsfx2fC5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="83165240"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="83165240"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:59:00 -0800
X-CSE-ConnectionGUID: TmWCyki9TmmlZ+009hD00g==
X-CSE-MsgGUID: rr32VqBQRbaHk05Jhqb6Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="196673329"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:59:01 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 16:58:59 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 16:58:59 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.30) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 16:58:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wDcaFiiypkCPWbNNNp9q8njvFIMkmdOSjqFZOfSb38GIlscQYy1HkgtFHC5ZJIjDsI87kNhaQRjDPcX7qzxgLthYEpeBn207RxbfbW8I6QaYbDOAQTojllm4AM5jsl4mH/mCxRdQnB/ItIwxBQfiB/t97MO+o3MSsNc3xOD7zoBbzBIhdVuVs5wqr6QCdNDepKxTKHqxrN6gQcKLQfOruN0y+cP8f14XlAiqP0FxHwwQ/TTYBW4IL3S8lyVKdtovBRvvNYe+GWNI3pBN1dLw4gv8RYNHlFGAXsvocOq6UpxbivQvbBh26SzPux+3eiLmaLlgSwF14/nGNtvvMsMOYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhv+NGN7BgkSyH5UuFmxfMY2nNWzH7uDRubAANmUTM4=;
 b=Qrys797WvFMs41zk7LkZOAh/w0y4XY1xGAAB48BTo6wTuwwLEg1Hlpjn9q9qv2lLQsqqeEw4g1Di/D9h62ne6w8+CKcTh1C8sDD7/RuOtJur8mTTlY2eXZlD8drRDEWOXnD21p2pOzSoS91ye9+ooFN7Ofz/SF17kGofPPnUdYr0m/ngB8K9vXuLYsZiOkfrrzMOndXmiVObdjaz1DhFy4BE7I6iuVbUSQ1PhHOzqzrabTNnYj0t1SG/cdwUl9K6hEyq2ka3psqrLwssdBNZ7gTKx1lkU/QccbOr+XFDKqLF1zrzMR4uN5OyE6BUxPnZsHQ2EFysaxH33MqLmVOXCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA2PR11MB5018.namprd11.prod.outlook.com (2603:10b6:806:11a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 00:58:57 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9343.009; Fri, 21 Nov 2025
 00:58:57 +0000
From: <dan.j.williams@intel.com>
Date: Thu, 20 Nov 2025 16:58:55 -0800
To: Michal Clapinski <mclapinski@google.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Pasha Tatashin <pasha.tatashin@soleen.com>,
	<linux-kernel@vger.kernel.org>, Michal Clapinski <mclapinski@google.com>
Message-ID: <691fb94f7aee9_1eb85100cd@dwillia2-mobl4.notmuch>
In-Reply-To: <20251024210518.2126504-1-mclapinski@google.com>
References: <20251024210518.2126504-1-mclapinski@google.com>
Subject: Re: [PATCH v3 0/5] dax: add PROBE_PREFER_ASYNCHRONOUS to all the dax
 drivers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0344.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA2PR11MB5018:EE_
X-MS-Office365-Filtering-Correlation-Id: 52a8c6de-e719-4a3c-4942-08de28992661
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QXFKZkZzY0lFM20yYmJRY0RIM0xoaElLZjgzWEZscXBDZGFRdjNDeUNPblB2?=
 =?utf-8?B?SkkzUmtFcEtCaFlvdjVXb1lxY05aSU5RMHkxaXVhWHJNV0JCdjRDN0t1ODR0?=
 =?utf-8?B?Qno1UkhZSEpJUUZyMnRDNlZRUDk2bTVQa1hycGt4UWJVZWpLTEhQVFRKWi95?=
 =?utf-8?B?RVV1dnlGVmZUaXZXTXNXcVFtTTRyRTRDOEwyUjR1M2ZpYkRCeTV1dWFMcDhl?=
 =?utf-8?B?enJkeEgxZGtpQjkxcWtRWGhLQ2pPV3ZybW01dDNuM2RrY0QrZlU3ME9tVTBW?=
 =?utf-8?B?eHJxbEx3c1NLRE93VlVmMEVma3pzRWdlOG9ydzBSWjJBdlYvOVFtU0w0UkZl?=
 =?utf-8?B?RU1CcVZBRURtV0FQd3MvaTZZL3FTS2czRmkxZSthbFBZOG5QVkhLZXlqcmpm?=
 =?utf-8?B?TGtKVGF6RmRBSVdSYVZkM1lnTXNPWHdQRVowNjA4R2REVmdpMkdsVVRZY0Zx?=
 =?utf-8?B?RzFwQUtxQ3U1Q2wrclk2NmhRVk1mcUx3WTlwblo4eUhwc1lrL3VWbFExOUIv?=
 =?utf-8?B?OXgrQk96UFRYTjV0VnZ4Q21XTnlCTkVFZ3AzSGZQdG5PNW5WdkNvVXBwcnQ1?=
 =?utf-8?B?aUhGL1JuRHhpQ0ZjSmtmRXhqdjJsSkNWOHdGa28xL05KaFZ0eTZyaURscjFv?=
 =?utf-8?B?SXY5UTVPYklXMHFqY1FzM1d2SUEzWEs0cHF6STlaUnNmTlJKbjQ1VzEvcDNW?=
 =?utf-8?B?dHVkL0d0Qm5KVlVqZ1I2UWJtQzJFWDB2aXdJVWkyRUxSMzI0SkkxZmsvaFFL?=
 =?utf-8?B?RVV0Qm1UaFlEazR4bDdMMXZXcHBBa1Q4SGErSzA1NUtYMXl0WGNLWE84R085?=
 =?utf-8?B?UFNXRFcwRVBwalNHbDIvTlVjQ2MzUjgweWZmT0dicmVTS1pQYlgrNnRJZThU?=
 =?utf-8?B?dFVnVjgybmUzZ3paYkFpWmVPd3MvL2IyQ0R2VEFvTmZvM2s1RElQTjVCcmN3?=
 =?utf-8?B?OW80akJvQ21MVTVBdVdpUzBlQW9oY3d0MXZ6SmcxcERHZ2pwaTFzdG9FenAz?=
 =?utf-8?B?aytWcUFkbERvYXBSTEh6cTNVMmpOUTdqd2R4K3dzb1QzcGN1d2hOOXM4SVpt?=
 =?utf-8?B?TmFueHl0UHdIcjlKbUt1ZlVrVWp6YnBEU0ZZT3RFN05LUEZ6U2dtQ3MxS0RY?=
 =?utf-8?B?L05NKyt4bWxUWEdRcG84SGxYUncvUVhjTGZpY1NMMUtpMWVtd3VZbVlaeDNw?=
 =?utf-8?B?L0lhL3pCR0cxamNKa3djRnNpN0Jwa3BkYjdDUnFPaDhuY2tCL0h0R1Q3dG5t?=
 =?utf-8?B?OTR1RG9SczdvWWJRVHZPUWwybVhmYWJndms0cEl3VWdhVDNKVVFLOWtLclZp?=
 =?utf-8?B?Vm5PNU5Sa080QmtrNzlySDNncWVmbmM5NERZWGFXUlZBQzVsTjRoa08ybUFW?=
 =?utf-8?B?TEtzbk5GNlNlbUJjRVVoNHZuYjkxNFcvVkpuS3dIRjZ0eW0yTzhWaW5nQ1Jn?=
 =?utf-8?B?M1VtazZqZ2VhczdoaW5iT0Z1TDM2SXY5SGVuY2ZCQVFSaW5jNGV2QzFwemJC?=
 =?utf-8?B?Q1ZMMS9FRmlnWnF3OVA4Mlh3NTVqYW0rTE1abDM2dkQ2NjRNeXFnZDhPRmxR?=
 =?utf-8?B?bzc5UUg2VDNUVkZIUi9Yck9MekxESDNFWVdNc0NuekRWWEttTVJjaUNFWldi?=
 =?utf-8?B?cDkxUFF6czgyZHo5VkRFbmpORzF2MWdvMWZ6cDVkdjYxZDR6SFpIWXFYMDRP?=
 =?utf-8?B?a1FtSUE5QkI0UnlHVEpEVUJlYytQMXdFckhqY0dlZVgzSGJ2ZHBGaVFoODd2?=
 =?utf-8?B?T0E4NkI2VFR1YWhaRmlOaUQ0ZHhGN3d5bFpEamlSelRWZHVIWTdiV2ZOcTdK?=
 =?utf-8?B?M0FMTSsxbGFYZTFoLzBJZHlYVEtzYVJ2MEw4V05RY1kvYmdQeVc1NnBWeSs3?=
 =?utf-8?B?bEErWUJ5T2dkVHN2ODUyVW43bzZHTUhpYWVjRDg5cG9LeDlpR2VaZ2k2eGZh?=
 =?utf-8?Q?JKD2qah7E/KIcYyoy4Ek5ZJrG4YOvkse?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzZaenVVR0RXVE85K3dpV200Qi9jZFJ6VVgxbEE5ck0xUmFYRkxPOXgzcGFv?=
 =?utf-8?B?Q3doMHd1SENHYXQ1UmlWVE1wdWYrSnZJeHljSlBxa3BlVFQ2N2o1bTExdW9l?=
 =?utf-8?B?SVFyZTlMc0VNWkswYSt0QTJzU2Q2WnNJeHQ0cUUzVXo3WmI1elRYMUhoS2xv?=
 =?utf-8?B?aURZdnZTeU9TdWh5eUU1ZHJYOXRrRC83OE5BZXpnb0JUV01UYWJXZExUWFd3?=
 =?utf-8?B?TThybDA2ZVBxRXpUSTRCTHJoM1Bha1d4V2NiR2RiNStmMWtuVG5wYjJ6cGdS?=
 =?utf-8?B?aTlwSW9pcEN2UDZpVURYY3pGSWM1RXlGdE0vTUlocGJhYXgxcE92d3JQNmx3?=
 =?utf-8?B?U0oyMTNJZmRlSFAvR1RiNE41YXg2K0phaTJpajJmUnJKUGo0SHNUei82QXRH?=
 =?utf-8?B?bC9UcFpTR3l0aXBDdjNHU2h0bzdyc2NXaU1wU1VBN0d0dzR1bGhuNmNMcFVs?=
 =?utf-8?B?Kzc2RG4veWxSdnJIeG9nakRYSjNIQm9jYjhmMExrTVJOdmNwbC9jMjg0OWpw?=
 =?utf-8?B?M1YwdkxCSHIzVEJXRGp1b2o3RFBrKyt0dS9mR1E5YzdubjRnVVNDWDJ5QUNh?=
 =?utf-8?B?RjNQQnc5Tm5ZTDFwK2xTZlk4VGpzOHVuZWxLelFtaUhxLzJ0UmN3cThsK0Jz?=
 =?utf-8?B?UXA1ajRUKzFsdDB3RFQxZWFqNVYrSHpEekMyUWpuU3h2eTcwY2dCcmRUeFFy?=
 =?utf-8?B?Zzk3c2xVZDA1MG1UclZhS1owUUVrTDk0ZEx2N3JZeEJIcjg2RnFiT21OUXpI?=
 =?utf-8?B?K3cvK05lc0o2RHhIcFZ0T0x6akNrdW9kdURvVlJVTmhRWnFrNXIxVFNnVnBl?=
 =?utf-8?B?cDZUYTJaREpzNDl6WU03V1lqUE14YVhtdFlJZjBabUc1V3N3NytsY1ZMMHc5?=
 =?utf-8?B?RFV5WHdxTmlpK0U3NExvcU8xeEphTWlXZTg1UVVZUFFaN01oemo4L0hCL216?=
 =?utf-8?B?aHNCakhqL2x0aUxXZE9ZQXpzN0RrcnlzRUtlTTNkdW5WejltMHIxU2hkZkJ0?=
 =?utf-8?B?dWFOT1R2WUVOVElYdm4zUUlXYm5sRUJEOWRJQVlNaVZvdStYVGIyY3NqYkpD?=
 =?utf-8?B?N3RteWFnNUo2bTB1QU1zcWUzd1EwUmQ5MTZjVmJlQSt6Z2t6cDA3dU0yYk9C?=
 =?utf-8?B?MTYvRmxwTXN2OU53TG9Gd1dsTGRUNjAwb212R3hOQzBEKzNMYUxVOGRHSHJW?=
 =?utf-8?B?T0hNNEpENDJMM0QwNCtTK1QrRFlFVWFwelVOak5hakNYbll6ZUxJSTBhRk1X?=
 =?utf-8?B?QWt3NmpERTV6bnJxMlB0SWNuT2VKZVNzQ1JVNFRVamUyMmJOVytJWjdqeFRE?=
 =?utf-8?B?c3A5citjdjkxZE1GQ1psL3dFZGVDMzFTL3N5KzJBWVBMU1pKK294aE0xN3dV?=
 =?utf-8?B?Uk1zWCtYSEpkc0E3N2wwWmg5Z3Z3WEN1SDZYb2x5QS9TeFZsenMxUmRBTnVU?=
 =?utf-8?B?R3ZKK3p2QWpJN2tmUDc5QTNGUDNhZ0pOS2tXZ2EzWjR6VG1mSU5MZGpzTnZl?=
 =?utf-8?B?SXc5NjV0aHluelQ4RjQrck1ObXJIVFhyd1l6TGs5dGs0ZWx2b0Q3NDVmbUpx?=
 =?utf-8?B?T1hCcVdsMXVaa2VvdVVLZENpKzhqTEgzZnNoS3luNjVTZmFtTlVVaUppV240?=
 =?utf-8?B?RVp3bUlUTm9RcWRqOEM2RDhPMll0MDcvKzg3bFg0bEZqNndEVXZ6eGZwZCs1?=
 =?utf-8?B?SGFjUWp2dFZtaFpHRmdMY1FWS1RwNzJGVUtLeXJrWFYxc0xYSmovVnRSTUQv?=
 =?utf-8?B?YmszMVFFcm1vQmxhYVRMTU1pcEp2eFBLVkorWlpWUks1ZVFCZmptNjZsb0Z6?=
 =?utf-8?B?enpvWFU5RVVBRDNrY2J4elFyOElWUm9MT2ZVQjI4NW94WldtMnVndjcxdmxp?=
 =?utf-8?B?MmVsNytyZGFpdGNrcTJHTXlERTZlMWRyNVNIdTk5Y1ZpWGZmNkQ0M0x4Tjln?=
 =?utf-8?B?MmpwQm0yejdmUHgveCtGdVhVTU1LSEVhblBJRlNHWENSVFJicEpGSGlxUEJQ?=
 =?utf-8?B?YytNZGh3THBpcm4xM3NJRHZBcjVTOUNnb1pDSjVSS2gwbTlLZENGc0hUTS84?=
 =?utf-8?B?VnBpdFhTQXFEVnVhU3RJYVl0ZjVOQmhHakFiNHA2bzY2eFhLbGg0L2pzWjJj?=
 =?utf-8?B?K0RBZUZySDJMbitYM0hiWTFydi94RmJYTzNqNGZQMkFOM1hWa3lsY1VRd3hz?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 52a8c6de-e719-4a3c-4942-08de28992661
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 00:58:57.4640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bHQNR0uOjBE+8Jlkdp6m3q5yMhDMy+keQqR5pdLayoTl+V2GEFpvLA898v0N2Qe3LSO6JJgf/0me0uDP4Ek9utxBRqgMDEBtWJi0R5Eh1D8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5018
X-OriginatorOrg: intel.com

Michal Clapinski wrote:
> Comments in linux/device/driver.h say that the goal is to do async
> probing on all devices. The current behavior unnecessarily slows down
> the boot by synchronously probing dax devices, so let's change that.
> 
> For thousands of devices, this change saves >1s of boot time.
> 
> Michal Clapinski (5):
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the pmem driver
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the kmem driver
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the cxl driver
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the hmem drivers
>   dax: add PROBE_PREFER_ASYNCHRONOUS to the dax device driver

After seeing the trouble this causes with libdaxctl and failing to find
a quick fix I wonder if you should just go through route of eating the
potential regressions in your own environment.

I.e. instead of making it a problem that the kernel needs to debug for
all legacy users, how about you just boot with the command line option:

   driver_async_probe=device_dax

...or add the following to your mopdrobe configuration:

   options device_dax async_probe

I.e. do you really need to change this policy globally for everyone at
this point?

I do want to improve this, but I think it will take time for libdaxctl
to get ready for this flag day.
