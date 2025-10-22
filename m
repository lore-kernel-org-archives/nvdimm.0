Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5F11F4262
	for <nvdimm@lists.linux.dev>; Wed, 22 Oct 2025 23:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761176296; cv=fail; b=AoPYHDWAs2B4Dwai6ORHuW1XHfZVegWsVgS8AYS3qtfPhKzifCFACNuUOBX+4d7T2OUFlyGMBmA4GEve6qLIVSJaP1ymaES+5Ulr2IzSpMt9QR+CsoMNgcDNGiyXKcsVTldn0kWpkj0ws4Rxny+8mMZ0DOreN3BjVxtEmRzJdsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761176296; c=relaxed/simple;
	bh=EdUXDRKe6Na54LAnGyk7pbqn/LP1T7M6z/mvUHFnGf0=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=JthrAViPunRfGyEN1ZdjZrp5L+vOamfA09O2w4eqRiv+irDzNGx1R/uaYUM5h+l19w+EJ/0lKkx63N5aPcdOIHlGVX0BfKlHkZ9jwdNCNa3rWhrODJvU7GTKtT9uZJxjrGiAmbh5TuLfhjAcgnR4lipe4tOShWSm8tUBwaNZRPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rzdiskkf; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rzdiskkf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761176295; x=1792712295;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=EdUXDRKe6Na54LAnGyk7pbqn/LP1T7M6z/mvUHFnGf0=;
  b=Rzdiskkf1zKzTcE+WnUN2Ek1ym8xWeiOWPv5exukfJOcNH0SI7vHRVxr
   OElPXDSjrxVYSdn9gvql6zp7GTzuJIHrxQQnhu6fAPx0oR1y7QYXUo+Uq
   ibYZLduxnaRo7T2LdolL2WZtd577GOUf7T14VElrw375Oc+BZ28npSd7R
   sLytUJscXm8aQ/cOgMu8Bd4gap2iIHYORYzMSWGuPec1pjOYbyU0NVPn5
   ncIR/+YcB3XVsKu2OJmh0OOulNZXG5/vUlzVtAarKVW8cqdOmHOtQamqs
   m49zQv5ZMfXo3Aud5OQsgm/U/MpoRwdqq9EM6tYLKWvl6sE6b2wfPKiWJ
   A==;
X-CSE-ConnectionGUID: MuZqnP2TRxuiRNyUM1YJsQ==
X-CSE-MsgGUID: kDib2h6dQzCOHcwsWO0zzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63375951"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="63375951"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 16:38:14 -0700
X-CSE-ConnectionGUID: yEw4WMVDQOeeBd4J8/6v0w==
X-CSE-MsgGUID: ai4hrMjeT76JuOZ/Nsc9jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="189275373"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 16:38:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 16:38:13 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 16:38:13 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.13) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 16:38:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rNafHufhb6VwIW0jvmcPd3TJEnOmVj6y4jhMr4KByG5vUGGFPKMd4q9ZD2u7fArLUFw5PA45DtTxeBOP4BnTuzlvzFi8g57Y97q/xAcuVCbIuyNzY6taolGBQq4coqwbBLXlMRiH59PnojWKe328OBV07+l1NfQJVd0q+06/o5vs9fpqq2Acb8l2WqUE2nzhLzVP2gOmUbhDjDgdwpKZvR/ai8D4jBHt70o9gbiikd+Ac4aRLndCkisIT9731FRq9rxyWpCi76Hl47PVp54FFCCl00X32OYXhj/S40og67Z5Zbg6bhusCSOF1y9HRXnSSmQ6T5eZLC/80yEELIDpWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V5C5K1QAFkqUQ4shgfiPmDYYc5yGzQlqkBBGc4MWrTA=;
 b=e92JUkhT/JhQYkybVyw/mL+1WgOeIUcyMIRwnkTmdkdKYoBE0naIZ8IJc5BEhBBI0mwX8/BSHGdXZCEMJgOymkKDlkd3+TSC3sbC+qv8t4eBNag6ElcFAp/DtvzFC6i3dTLsTU9GxAo1QdQ2CU0qDsBqidh4ozVUI5Kw79E7vT5qLEhlzomrrgXO4V1er/sHJKynHQqn7lqMmHlQjhfOxJeNAKUM1vAch4bZvrzx0RFrrGtuwIbzxPR9Hlznkj68U9Gt05v/RwPoFsHjh067jGnoxQvIf27A8dbeX4eCugkhP08Ksk7Fa1sf3pI51+Nr4rW3Z5rC91ewxdS4hoZBQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB8083.namprd11.prod.outlook.com (2603:10b6:8:15e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Wed, 22 Oct
 2025 23:38:11 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 23:38:05 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 22 Oct 2025 16:38:04 -0700
To: Michal Clapinski <mclapinski@google.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Pasha Tatashin <pasha.tatashin@soleen.com>,
	<linux-kernel@vger.kernel.org>, Michal Clapinski <mclapinski@google.com>
Message-ID: <68f96adc63d_10e9100fc@dwillia2-mobl4.notmuch>
In-Reply-To: <20251002131900.3252980-1-mclapinski@google.com>
References: <20251002131900.3252980-1-mclapinski@google.com>
Subject: Re: [PATCH 1/1] dax: add PROBE_PREFER_ASYNCHRONOUS to the pmem driver
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::7) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB8083:EE_
X-MS-Office365-Filtering-Correlation-Id: c869f9f0-7598-4e3d-f9a9-08de11c40c72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZmFCalpram00Und3bDdkbHVYejc1Y0REUTFzbzU4MzQ5MTROR2M4Vm1wRlhD?=
 =?utf-8?B?Qk52NHJWcWJYdUpsdkFNMXJrZ0pHRGJTd3ZFZFpNSVpzVk8zTnd0bzEzMHZT?=
 =?utf-8?B?dnM4T21HQlJ1U3psaldBQThYaWJwcjhhQms2RGR2UDJ5Y29NZkxvRkhGR0Jj?=
 =?utf-8?B?aXQ5Y3ZpTHE1WmVhWE9ucjJWNU4vK1FMeTEvUGIzTVhsL3d1S0ViRDJjajVN?=
 =?utf-8?B?aTRYWTlFYnZ5bHhzd0xBdTFsTFQ4citSdVhZZFZGR1FCdTJXaUVURmVGTXli?=
 =?utf-8?B?NkEzMFBNd2R3OEVtUXJRK1o0bzI4WCtra3dlT1NjbTl1aG5pUG5oWmNaUzJl?=
 =?utf-8?B?S2h1REpiU2JRZ3JOTFVOS2w5RFhVQVl5ZXdzNGJuejczU1BtQS9qSzlqQytl?=
 =?utf-8?B?MEkvZGoySVAwSXFXdkw0SUV5eUpLOU1sZzlSWnlJUWtEdkoxbWQ3QjJvREJz?=
 =?utf-8?B?UG1CKzg2L05XV2ZEcWZiVjhBeXVDK1dwdDhDbDlaYjNWdER4d295d2c4UUFo?=
 =?utf-8?B?T2RqTjU5QWxLbkloK0xTTGxvSGpsV1JxbExKVkJXazlWUzlBNEQ1MTNQempG?=
 =?utf-8?B?TzZZZzR0VHg2MnpHdXZpR3J1NGtyb2lUTS9iOWhjTHdOaUVsOUpkYW9GOCtU?=
 =?utf-8?B?N2VFN25ENTZRTTgxQzlRd3VTUmdSL05CUlRzTEYyZTBqUE1WVDNWWXlpVkhK?=
 =?utf-8?B?NTFSRVB1TkVhRGg1eXc1b1RnNXJDWFdqTmFqR3Q1bXJ1eHdlUkFTRXk0U0FM?=
 =?utf-8?B?WmdKTnR6b2o5a3g4R21LMXZrVDBQY3hxZFZncTc1ZFU0WDd4MEczQkkyeTIy?=
 =?utf-8?B?VFR5NkVEc3JqWUxvMHA5Wm4xMWRCdjJPbEttaFc1V3dhOFdGb2VuQXpjZ1NM?=
 =?utf-8?B?MGNTY2U5WWp6UElYWUgxS2haaG5mWUtWay9QeTI0Z1FlMk1xNThwWW1McTQv?=
 =?utf-8?B?QVF1S1dFK1pUU0hUTlU2OFQ5eDgxWGZPWjc3NFgrWndhQkRIVzVydUI4eTY3?=
 =?utf-8?B?ak9Camo2WjNqY3NqWlBTZ1Z4aXdEYXlRQ0JNb1hJMmhDQUFXWGFmUmNBcUxT?=
 =?utf-8?B?c3pXdEtMSDhkMFppWldtU3lidUxyeWtwMmxlS2x3T1BhL1ViZkxjWFN2Qkln?=
 =?utf-8?B?bVdpV1RRb0NGOWVKT292bGovcGFwVzR4UW1RZVJMdTh4aWR1Y1J5TC82QWhn?=
 =?utf-8?B?SDJXR1NuK05Ea2RtS0F5ZFkzYkwxb0FrOUVlbndDMkRIV0FkdmZoQnFaVml0?=
 =?utf-8?B?Zmhnam5VT0dYNUpwdGYzcXc1Z1llUnc1NmRVSDQyQ0tDaHlWWGhUcUJOUXR6?=
 =?utf-8?B?dHZMcTNWOFdzZEkrTXBHSzNBWDgybHJHN1FLQ0FtanpGamZMSzg0L1Yrbm96?=
 =?utf-8?B?eTJEWlY1TURZajhPUWJubE9DRElzdVRta0VCRmQ1a3V2SDdBalJFOGpqY3VZ?=
 =?utf-8?B?UFZjVkhCTm9VaUxZYXU3S2VNYVBMaWcxRGkxRk12N25BZXovald5Zzk0YllV?=
 =?utf-8?B?TDFWSzF5bDVsbmNidnRIWWVjcU85UlRTamU3MTRaaUZmRVhPai9QcGlQU1Vn?=
 =?utf-8?B?UzVVTlR0R3FEUUZ6SStVSm1mSVlqWTNENWU0YkFPK1lhR3VqaGptR3dxK2ZT?=
 =?utf-8?B?STgzUkEvU3pDVEpwdktWTGZ0b21lNDRSTyt4Y3UyekFkZngzQW1yQjZiSUQx?=
 =?utf-8?B?UG1sWExjbmZHdUE0TnhnaDZCcnlHNjBpbThJQk1tV3Q1UGpkTE9KVlBDTkhm?=
 =?utf-8?B?UG9jNUpreDRNdDlQQm4xQ2JqdmpOWituN25yMmYzdGsrRGxZT21Vby93REZk?=
 =?utf-8?B?OVZFTmdZYWloQW56b0NYdkxtam9lbXJpcjNIQlRXc0wvTDNzeTJJL00weHRR?=
 =?utf-8?B?dTFTQzdZdEZaN1pZRFc4cFE4dnBWUjFsN2IxL0xxRkhSdFNjdTdDQmhzS0w3?=
 =?utf-8?Q?lnAhq7W4Zg0LADwyHuOvN+vnqXR3a6q6?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWFMTFN1TWZscGozSFh4dklEZHFDT2JrY2t6c01tbEV5ak53N0FnWHkzMzJL?=
 =?utf-8?B?R1FFalQvdDM2QnVHUlhITXk3dEpuOUlBNGlhTEdXVlZmQzYzMXdpR0dvZkdJ?=
 =?utf-8?B?U0hYa1J6VFdBb2ZCUGhSRkhJeWRRdVh4TFdHd0RwbnRhcWJmQnd2Ym8wVlJO?=
 =?utf-8?B?TjE2Si9tMkNxZVZLR2FYSnhqSFBpWDNKSDJEL3ZKSDMydWdiek9QU3c4amFR?=
 =?utf-8?B?WEtoSStlaGxjenU0TVhNdWlBUUE1RmJzK1F4TjN2ckNnQW9pbjJuTUxRMmtz?=
 =?utf-8?B?b0hkN2hNaXdSbTNacGFUenhRYWw0UTJNazZRM282TThnQ002Um52SGUyZXNp?=
 =?utf-8?B?czdnVU1lTDRhVVJybjhOQXJjWW9YYzd2ZUJBU3FkdE9FYjB2MzhLTkx1T2Jw?=
 =?utf-8?B?LzV5bnlBRTYvRTJSb0RXVUJIUXhGbmh6MHBDaUk2R25YaEtyTHIwSkJmWEZW?=
 =?utf-8?B?S3dHMm91MnpLMlRING5xaDJRSTQ0OW1WSDVoU1h6NmdleUNPMlFvckVZZThL?=
 =?utf-8?B?ZFF0MCtzV2w0em5INFhmczdmMjExYmNNMy9mT3U2S09PTVBnR1R2RVZ6M2dE?=
 =?utf-8?B?L3ZwaS9sT0JnbWR1ZUs3aEd0T0NjTnRoRHNhZkw2ZkRLTGtyV2ozaE5VWGdn?=
 =?utf-8?B?U1VxL0pRTkdBZTJjaHRCWWF3dnBoNms2Z3QraHhSSEUrZU82UjJGZHBQZTRu?=
 =?utf-8?B?d0JLaFhWZ3pSOGRzTEs3b3lFdVJGQ0dHcERrMTNvb3lydWV3Vm9nTnNBT0ha?=
 =?utf-8?B?cGlVR3RPRVBhTllrcmc4NHZPTnR2WEF6NXd1NUVSYmxSVVpwS1l1OFFkd2sv?=
 =?utf-8?B?amtjaTJLcS9tazBabUQrbTVWZTdGdGgyYzBDZzRMNnRwQlROS1FHM1dGZlhp?=
 =?utf-8?B?Q3BvTFlGYkptUmVadUdBNlh6dDFvdlQ1ZzZNVzZabGlEc3oxNUxacUR4SnJ2?=
 =?utf-8?B?TWRwVnRRTTBOZHlKdVZYTHllSjNxbEtGMzY2QlhrRWplWDJpRlRDWVFMa2xy?=
 =?utf-8?B?YllXeTJRLzZXSU1TczdmeDBoeEl2OWVROG1PSjk2NWZRZnZhNnZzc1lZM2p1?=
 =?utf-8?B?clM4Y3puUDFVQit4aWY1UzIxL1VOS2tQUFE1ZWM2dThsdm14RGNGZkxBOFVt?=
 =?utf-8?B?cmRNRTA5R1RwQ3k1Z2hGdlc3dUcvM2w0N2YzSU9HYWp6QUlZNld4Sm5CSWIx?=
 =?utf-8?B?Y1BabDVwN0hiaHB2WEdvM2Zmdk5SRDA4OWk0YWc0bEZWT2ZRUWZwMzVocjRJ?=
 =?utf-8?B?WCtuWjh2dmlsaFFxMEJseHNHN012NkVMbHErQW8xU2h0a2dCbnY0U2ZFK1Va?=
 =?utf-8?B?cVVScTJ0YVhDTHZaU25qSG9TalpzdWZENXdxbGc3MGxhZ0Rpd1J6UTU0YUJ1?=
 =?utf-8?B?b1FoWEQ4aHBBRXE3TWo2L2Z0dXZLRDhyQUhCWStwcHN1WGFuclpYNkJaSUM2?=
 =?utf-8?B?VUk0QjZJRDF6L0YxVkcrcUJqaTYrYlNPU2ZWSXBDaWthM0tCTCtSYXR4YzVJ?=
 =?utf-8?B?V29USGUvRUR3WjFUamRqK0Q4S3VLSWN4TWU0NmpvdDBMVC9RNGc3SGxESDFU?=
 =?utf-8?B?T2Zxb3RPYngwZUVudWdneUx6aFVyZ2kzMjhvYlVHa2RNR1E0N0dhSFVVY1NR?=
 =?utf-8?B?K0NwVTRpcitRR3JrMWN3VHFVdFhvK2lmUEFya0Rya0FiR1drQTRmdlpVVFF4?=
 =?utf-8?B?aXd3dFJDMjFuY2MySHRITWdRWTJkalBFcVovQkh0NlhxMjJEWFdPYm42Nm52?=
 =?utf-8?B?TnF5aTVxMkpCZ0FDZWxqcmZhUFEvU1JtblJabXNTZXM5UnZuQTE3S3lGT1Qw?=
 =?utf-8?B?clFLMHhLMEY0NGVvY3JHZVM1MXJ5MXFoMXhWcVBNdmMrMk50QmRxVXZGRWRE?=
 =?utf-8?B?WlhSbmtJQ2ovU0JiUy9nNmoremQ5aUZwckVaWlUzeFlBaUZrblk4MHVyeWJ3?=
 =?utf-8?B?bFRtL0s2WWJ5K2VRek9iNmpaV2puSDBvcGxXbnFqTkJ6V3Zoa1oxVEJmek9M?=
 =?utf-8?B?ZUJYYmx0ZWRVN29nV2dkdDJ2b1dCUURDcEJOOHRXNmtsYjBNTDVESjVHRWlK?=
 =?utf-8?B?eVl2Y2hMMVJnSjIyOWFpdnNWMmo5TW80TUpuTzNvMTJyZUdaR3RVOG1ZL2xR?=
 =?utf-8?B?dDBWTTBGcjVYamxJUUhRajZycytrWHdKTm9xY2owUWJaK0cxNzJ3eGw2cmti?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c869f9f0-7598-4e3d-f9a9-08de11c40c72
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 23:38:05.5374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a59rIdNnF+6xJoKj4cPvcPc1h1iIWZT3aVDzArLA9g31VJRSzu2mxfqMkn0ywf9JpqG6fV+zqRBMsE1CWDSyrjFgac93JJAz0dBaLq3TS/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8083
X-OriginatorOrg: intel.com

Michal Clapinski wrote:
> Comments in linux/device/driver.h say that the goal is to do async
> probing on all devices. The current behavior unnecessarily slows down
> the boot by synchronous probing dax_pmem devices, so let's change that.
> 
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> ---
>  drivers/dax/pmem.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> index bee93066a849..737654e8c5e8 100644
> --- a/drivers/dax/pmem.c
> +++ b/drivers/dax/pmem.c
> @@ -77,6 +77,7 @@ static struct nd_device_driver dax_pmem_driver = {
>  	.probe = dax_pmem_probe,
>  	.drv = {
>  		.name = "dax_pmem",
> +		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
>  	},
>  	.type = ND_DRIVER_DAX_PMEM,
>  };

Hi Michal,

Apologies for not commenting earlier. When this first flew by I paused
because libnvdimm predated some of the driver core work on asynchronous
and has some local asynchronous registration.

Can you say a bit more about how this patch in particular helps your
case? For example, the pmem devices registered by memmap= (nd_e820
driver), should end up in the nd_async_device_register() path.

So even though the final attach is synchronous with device arrival, it
should still be async with respect to other device probing.

However, I believe that falls back to synchronous probing if the driver
is loaded after the device has already arrived. Is that the case you are
hitting?

I am ok with this in concept, but if we do this it should be done for
all dax drivers, not just dax_pmem.
