Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE63C1514E2
	for <nvdimm@lists.linux.dev>; Mon, 22 Apr 2024 17:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713805685; cv=fail; b=WU9ZGhYpAaXSDJ2uR+cdXMTH8pfcMbd8gPdlPjA3HQ6YqTrqy6I4BpTCf/9Lt/YtUgaklrbX7IWz3ZjKQch7VBqaKBb1qSpBIIQiZha0m1F3mdpEO7tnff0pk31I7AwKMoUEzG9gocAhL4cbaTIj4JWI7RANtCZPEA6Lc8dS7Lk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713805685; c=relaxed/simple;
	bh=BTl0CwEwrLnuVL8f1rGtGjDsCncxVAvti6NXw4arrkU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I879O+Uc15WodNYQMsD2mfn6bjjCRXnEYbFTFObnZnCaa2wsFJHSBOYeSEu+Xh/Zs60jFj+GxHiC4ECCPRoqnGdbRVeSt7jGGTImj7OOdjf+72eWV0t1lVExWo62PYy3L0DBLfCmlAFrySChQKw/7xOrh2c2HcXaTRDiKyphc6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LojsaY2I; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LojsaY2I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713805684; x=1745341684;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BTl0CwEwrLnuVL8f1rGtGjDsCncxVAvti6NXw4arrkU=;
  b=LojsaY2Il3lcg+twdRaawZ0jl7nC9WyAoM3IKF5QqC/n0Q7xcSEH3ltT
   hR0B24dlz2tNS7lC9mUnegFCFqThsO9fcLafMNwSvaA/vT6SZhK19fySl
   nMvrB4dke7hBaYvzN0UuAjtQZqThs580mPs2BMkL2eMKdlfgrUZBsJUV4
   87SPu6UTlglkV7lDuUxg6bF2U7DGVIxaNyrw0ZPl2z+OV0CWolxFhHB3q
   u8DA/Fhl6FdIvfjpkp+6mSHL7sAOdynGdnLXxeMh3nWZsr4Cpviy8o1Zb
   ZpSiQjERvNNyZJpMsQe9TmuGNYugkIsOtjoy6U3OTbuYD01pqTtjqpf5C
   g==;
X-CSE-ConnectionGUID: X97ktuyWTGybS443pv9V/g==
X-CSE-MsgGUID: 0wjPB2UjSr+O9g+h4apCpw==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="26871740"
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="26871740"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 10:08:02 -0700
X-CSE-ConnectionGUID: DU23qxTPRjS7r26r82tiew==
X-CSE-MsgGUID: jBJdS/8BR0C0OgDUxCUecg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="24152986"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Apr 2024 10:08:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 10:08:01 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 22 Apr 2024 10:08:01 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 22 Apr 2024 10:08:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cB3KMMv/434ATS9w0ZIjbyzjFDx+RxT0KL3qjScUHUMnT4jCBuVBTpxNp4LjGiyNasfMAqqmxNtEIsqIXyHkIbE8+nbIJQeEBnXDuS5p48kL+EtH/iCl56Hy9jdG/OKba95zuLyC4L7N8nLAif+zrayROISlMhxa3Azvwf9rMW/c8c12zVSDWu+u0E4tsclkmlOBuBVUZ5qH1GdGl1ZlkVBC3tCFm31lbp+xswDgcM6aNJ3lqMsTMb9/dBDoaexUfPmF2cgdgyG/7el+OwFLoSHpPHJNk6IirXQzLiEggrYdV2bIGPSdbqAJdc8XAiL6l2A4qvCA0ApPF1gHa7JaCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BTl0CwEwrLnuVL8f1rGtGjDsCncxVAvti6NXw4arrkU=;
 b=IRKsbPllVmlw4tZ8jLfOD7UT3OAFihCM8gYxvPeeJN6DAwOvOGSyIZClVq3qRb1cHQyttRjfUuESP/orkyZcAGoZmOqp/373PSZ2lRQo1P6lXmSehCGmWJ5RVRhfpvC8KBYYn/7k3ZK74tgZt6eRRZPeIInd8po+SpMs7NZGqfTjsm9xSTP5QRKnCibHqZAtdI1hHSNQChCDpRT1IKdrsYPhrabzep7ZrejzmTi387UTFLz/AAVJ+jAcwG9TZmo5K5U8OV1Q3jrDQWMLLETbCnEkaTAsVYnfikRxzMjOI7rIA7C3OMs1q+Ld6BmDznwo6WIhDb7hZNfrlorj6AE3+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by PH7PR11MB8252.namprd11.prod.outlook.com (2603:10b6:510:1aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20; Mon, 22 Apr
 2024 17:07:58 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::ed72:f69c:be80:b034]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::ed72:f69c:be80:b034%4]) with mapi id 15.20.7519.020; Mon, 22 Apr 2024
 17:07:58 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] cxl/test: use max_available_extent in
 cxl-destroy-region
Thread-Topic: [ndctl PATCH] cxl/test: use max_available_extent in
 cxl-destroy-region
Thread-Index: AQHagHcmPOTirBXUckS8Ewfn9X7N6bF0rk4A
Date: Mon, 22 Apr 2024 17:07:58 +0000
Message-ID: <7a8214e2f84e333784cf9e7ecd851ccbbb93f3ec.camel@intel.com>
References: <20240327184642.2181254-1-alison.schofield@intel.com>
In-Reply-To: <20240327184642.2181254-1-alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.4 (3.50.4-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|PH7PR11MB8252:EE_
x-ms-office365-filtering-correlation-id: 16a35820-4cae-4c60-f827-08dc62eec248
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?eGRUSFVKWDc4d2VBVjM4eEd1cTNreDZzYkdacml0MmRrYXU4QTAza3VNcWhR?=
 =?utf-8?B?bVVxMUkvVUpLR3VIRVg2ZHNvRHBid29FTzEzTTQveXJvMEJXSXgzOUczT05G?=
 =?utf-8?B?SldrM1lteUFLZjJXLy9RMFJONVZBZVhlV3l4L1VkNEppM3c5TUYyZUpGRFdN?=
 =?utf-8?B?Q1pBSVJSQzRnalV0QlIxWEQ4V3owcnhKS0NnVU1hdXhibTBnd0IzRW01amFJ?=
 =?utf-8?B?d0pSZnIrVldNTDZ3TVVOalBnYTdQUHJWVHRLejJqYnl1bDlUVVUweTkycGM2?=
 =?utf-8?B?RU16ckhSTjlMRnI2VDV4dkRFQk5oY0ZoVHpYMDljRXNBdnc2M3lJQy9rd3R1?=
 =?utf-8?B?cVZpcXRIcnkxWmlRWlpnTG94dktudnIwd3NaRm5aRTJrVjBuWWN1UnZrcVNO?=
 =?utf-8?B?TWRNWUhkU000NzIvWlRjQ3QxM3NvQTZ0RisvekloajdPWlhXRVVzeUllSnpM?=
 =?utf-8?B?VVVrK3YrcG1icFBBVXBxSnV3eXhGTkk5WEZvZ1VqU0xlUFN0SDMwRi82blcv?=
 =?utf-8?B?alp0RDlXWmFhaS9CdFJLTVlvZEtFbWE4c3VCbFFGNEp5OGpQQ3FramlhQjJM?=
 =?utf-8?B?a2JHdWtsd0JxMGJGTzN2Q1MxOGQzYVZnS1Z3WVdRY2dHMDdOQjgxOGd3ckc4?=
 =?utf-8?B?c1JaTEVZV2xvemZPS3A3WWE0V2JacEk3S012eGNGOCtSM3grUXJOOXlsLzFz?=
 =?utf-8?B?ZVV6UlZpT3l2dGx2KzVyWWZkcG92T0VLbnZRUkJITVJCUTM0TVAyRENteWxp?=
 =?utf-8?B?QW5TVC91eGNacVdzWVBNUjczL2JwWWZyVVdtUU94c254QVI3V0xUZVF1SWoz?=
 =?utf-8?B?R0E3RTl1SHRUNjd6VUtBL0xCSXdFMThqekJPSWZDaGw5UUI5dWlITnhTZDZG?=
 =?utf-8?B?dXNhd0ZOUVhjV0JCMlFsQ1JoeUN5cUZnaG5zajViK1d2OHdzQk5pNzRuSGp0?=
 =?utf-8?B?OEg1V1cwNGNFQTJnalN6bTF0R1pJdWlNZXA0VG5QOUY0bDBEMjVYWnpQZGFS?=
 =?utf-8?B?RFpBaXVNZmswLzlkdGJWM2xmZDJrVVA5QXY4eUx1K2ZKWSt6R1F4bVE3Vmg1?=
 =?utf-8?B?LzNLUmp5SFdWZmpRc0VnbVp0ekhpRUxFbDM3amppYURPODhub0s3ZkdEV1c2?=
 =?utf-8?B?d1BlV0c5ZWxpTUwySTROQkh6ZHE5SnhGMnUvcSs4eUxwTTl4NGV2ZjRMSDVx?=
 =?utf-8?B?VGs4YmRmUHhhN0xPU2lRK281UmJaTk9IQUdqYW03THpnSjNVU0M4em9LL1No?=
 =?utf-8?B?S3Nob2VZODl2NzRRQ3VSUUo1RU1GUnhHcmlneWxYYitFNC9KTXpYQnVYdUhW?=
 =?utf-8?B?SG9qcDBuNzJtUEl0SmpWSy9iK0pLR1N1S1NRMnRTam1sL3ZGNDNKTUd6UURo?=
 =?utf-8?B?ZVNuZzI1N1BxVFQ5VHhZblJjeWphdGwxWFZkSE90VlhoS29xWFlvd3ZqSGVl?=
 =?utf-8?B?dXRLTlVlZkdlS3VVaXJ3Vkdzd25oamRHKzVUNUN1MEVRdkdzY3haQmxOa1Mr?=
 =?utf-8?B?ZE8wVTFSRVk2ZmRGdXNUa3IzZXVoZTNqYk1vWWR4K3I0REtMV0RRbFhERnVX?=
 =?utf-8?B?MEZjWWI0Zm9EMWVuSTh0RWlielZLaHRheWtjck5MTmJXbWF2aTVZd1d4dWdD?=
 =?utf-8?B?ajNxQXlsWEpIeG9pY3o3SDhESUxnYlUwRTZRNFc3cDMrdW9zdm1wc00xanNr?=
 =?utf-8?B?VXF2SDVOUG5SMmF3NFh6aldaQlFzR0RCYUhkUDVxUG9iSVZnU0l5QWJ0cFd5?=
 =?utf-8?B?MTc2TVBWOG8zMFNXYm5hTHVKL2JGcVB1RElNRFZzYks1ZnhCTitXSGMwUmNr?=
 =?utf-8?B?cGhqbHMwaFRQRmpLdC8xQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2RGUklVVzVORUoyZTYwb1FGTWcxaFdJZ1BFQk1JY2NNK29NVDBOdHJIUkZL?=
 =?utf-8?B?Skl0TUZ0VmFDaE1kSS9RT2FzempOQXBwUTR1WVhkZzJhSHFGdnpHWksxL0Fq?=
 =?utf-8?B?K2JwM054aDdhWG91QzJiNlM2M0pnUE1EeVNoOEdaMTdIZEF5dnovSEtBd3Yw?=
 =?utf-8?B?VE9tSGxtcnduUW5UaUdoZFZWT1BiV25BUU1VSGRJcWY3TDJKTlpGQmM1cU9U?=
 =?utf-8?B?eStSSDJNNGQwZ3JJRDdXb1U1M0YzM3BNZlB6NUluNzNWNHVHaGtSeWVYZ0Ns?=
 =?utf-8?B?VVcxZmFxcE8zdGsyaE9PL3lTakRvUnRrRDFDY3ZQVmg5YW4veU5IRTNTUzUr?=
 =?utf-8?B?cWhEenNwVWxOUnBLNDVENVhxeFlUMnc4blZLbmlmRmprRVpSOFRMdVk1eDdN?=
 =?utf-8?B?VGxnNCsrYWlXOW4vTTdhM1Z1aGN2a2NFMGx3TmUvSUFnWWVjWjJ3clU1SVov?=
 =?utf-8?B?ekdSNG11WHNMQW44dGRsZXZwRUVVMFp6eExHa0F3SkZ5ancvMm9uVldqczZR?=
 =?utf-8?B?K0tuOFl1MDVVVmFlVWJLcW9rZjBwaGNYRTZRZVQzOTVseGpxNWU5Rm5GLzZ1?=
 =?utf-8?B?K1hzMDEwZVU1UGlKa2JrKy95TTFiNkdLc0ZCRHQrRXYxSmpSdHJ1NkMzSmlM?=
 =?utf-8?B?SThUNGRvc0twY04wNjR6NWpVa0hOSGFNQUtnbW9IMUE4ejBaUU4rSUs1aGpw?=
 =?utf-8?B?TVdLTWZ5dkJUNVRxOGZZaGNQUWVLNWdIa1hqRDVjZ0dQcE13RCtibUx1Uk8r?=
 =?utf-8?B?SDVXUkRVMU9vRFFJdXVVMkZFSzljWEgvb2lvS0tTYzVhY1IzRzh6VU5iT1c3?=
 =?utf-8?B?YlI4WVVPWCtZK0lhWU1seWRYOUdSUHE5ZTJoZTBkeFozdjdvN085ektZdkdW?=
 =?utf-8?B?VVhEVFRlRlh1MjVXQ3lwdVlDSGRRcmdjdDB5cytkby9ycUFmVS92VEtpZ0dR?=
 =?utf-8?B?MjNUS21sZjB2aUphK25sOFZDZGxUdGZjaHNqbU5udnFkNVZYUmk2RWR6VzdD?=
 =?utf-8?B?bkRNSkJaR1lCVkNsTnltZzdrY1o0bUQvT3ZPQmpDQnZ0ZDVRTWo3YXJ0N1du?=
 =?utf-8?B?djdJUkZLdWpOT0s3dFBDSlh5Z2dFQ1E0V05jWkVvYTFGQ0RZUjlSa0t3NVdh?=
 =?utf-8?B?WmUxUGJsb2dqZkdqTGw2R1Y5MHpQK2hOL0xNVm9DTWo5OXVDR2grN0t2bElK?=
 =?utf-8?B?WElRbVRYd1B6V20zcERtV21qY3k2RUpLUmx3Y1R1QmU5YUp3WHNRNUJkeGpa?=
 =?utf-8?B?VnBSai9nQkt3ajd6d3RncnBTT2VOckdpWkI3YXZPSGVNV0lOVEp2RzVITSsy?=
 =?utf-8?B?VzNIT0U1VERwOU02LytoQ0JRK2I0cHdoMVM2ekpzYitKY1BDODYxU3FaZytr?=
 =?utf-8?B?VmdFOEZBVGlZZ0dqNGsyR0xoSW4zQ1JyZU1xRmhyWTJ0TWhBOWFRYW91S3hl?=
 =?utf-8?B?cXJ0Lzl2cVRiSDJ6OUpkTGZkcWhkRlU1YytGaDlhamd3NjBjUVBZa1Uycmsy?=
 =?utf-8?B?UEt5Q0ZhYTNPczRmNGRwZXUxN3NhTE8vYzJVV253SloxSlVkRnB2NnVjeHF5?=
 =?utf-8?B?L0pwU1lLT2RKRHBOM1A0TnliV1ArVEdvQ203bG9wajJ5MHBmVmhTU25XY1ho?=
 =?utf-8?B?T2l1THdxbWcwT1dpc1NBelVEeFdiZzU2b0RybXlSanRFcEdCWGVFVUNQRkM5?=
 =?utf-8?B?SEg4VG5QQmxaUitXUnNkNVVhaENyVjNaNzg1cVl3ZVd5cVAwV0lCb2lxTDE5?=
 =?utf-8?B?dTBQMnlybkhPTWlrd3FNVERQcGFVNC82b0tkVVA4TW12L3RyK0Q5NEkvRTk3?=
 =?utf-8?B?Z00yWFBGTTBLOVFoMkNZUkc2UVpEdC82MTRMd3ZXS0cyb3FaQ0ZYeFovTzI3?=
 =?utf-8?B?WUFFMzdPVDFGeEE1MzltVmNNU2hxbzduVVcrYzFZWVg4RHZJbHE1Uk5LRm5V?=
 =?utf-8?B?akJQa3c4Ujk1Y1FkUXRFejBGSzhBajI3TnBEbmw5ajlReWlHdXAyMy9URHBI?=
 =?utf-8?B?UitPeDZmRStEN3pmNUdzeFRNaXBjMi92Q2drNFpGcmtzajQwa0JhK3Y4aDE2?=
 =?utf-8?B?cFVCR1pCN05LdGFxRi93NFNBaTB3amNjZjRTb0JmeEtKMmdyUnpwcncxdG9X?=
 =?utf-8?B?NmNScm1CWVhnNEdLVmxjcVZKOW9LaHNrSGQrenhFaEZoQXZiNnhWeTE0SXBJ?=
 =?utf-8?B?VEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F85628E8578B84BAEF3CC93F43D636D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a35820-4cae-4c60-f827-08dc62eec248
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2024 17:07:58.0876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xSjjbmH3Vawaelkv6HpiTqSbli7g63F4CEIohqz79Umuy6Moc3RRDlVf9EceBSEqbFIRVH4v879qCjCakyZPkgZTF6neqy+cLF8zQU/dyMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8252
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAzLTI3IGF0IDExOjQ2IC0wNzAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KPiBVc2luZyAuc2l6ZSBpbiBkZWNvZGVyIHNlbGVjdGlvbiBjYW4gbGVh
ZCB0byBhIHNldF9zaXplIGZhaWx1cmUgd2l0aA0KPiB0aGVzZSBlcnJvciBtZXNzYWdlczoNCj4g
DQo+IGN4bCByZWdpb246IGNyZWF0ZV9yZWdpb246IHJlZ2lvbjg6IHNldF9zaXplIGZhaWxlZDog
TnVtZXJpY2FsIHJlc3VsdCBvdXQgb2YgcmFuZ2UNCj4gDQo+IFtdIGN4bF9jb3JlOmFsbG9jX2hw
YTo1NTU6IGN4bCByZWdpb244OiBIUEEgYWxsb2NhdGlvbiBlcnJvciAoLTM0KSBmb3Igc2l6ZTow
eDAwMDAwMDAwMjAwMDAwMDAgaW4gQ1hMIFdpbmRvdyAwIFttZW0gMHhmMDEwMDAwMDAwLTB4ZjA0
ZmZmZmZmZiBmbGFncyAweDIwMF0NCj4gDQo+IFVzZSBtYXhfYXZhaWxhYmxlX2V4dGVudCBmb3Ig
ZGVjb2RlciBzZWxlY3Rpb24gaW5zdGVhZC4NCj4gDQo+IFRoZSB0ZXN0IG92ZXJsb29rZWQgdGhl
IHJlZ2lvbiBjcmVhdGlvbiBmYWlsdXJlIGJlY2F1c2UgaXQgdXNlZCBhDQo+IG5vdCAnbnVsbCcg
Y29tcGFyaXNvbiB3aGljaCBhbHdheXMgc3VjY2VlZHMuIFVzZSB0aGUgISBjb21wYXJhdG9yDQo+
IGFmdGVyIGNyZWF0ZS1yZWdpb24gYW5kIGZvciB0aGUgcmFtc2l6ZSBjaGVjayBzbyB0aGF0IHRo
ZSB0ZXN0IGZhaWxzDQo+IG9yIGNvbnRpbnVlcyBhcyBleHBlY3RlZC4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEFsaXNvbiBTY2hvZmllbGQgPGFsaXNvbi5zY2hvZmllbGRAaW50ZWwuY29tPg0KPiAt
LS0NCj4gwqB0ZXN0L2N4bC1kZXN0cm95LXJlZ2lvbi5zaCB8IDggKysrKy0tLS0NCj4gwqAxIGZp
bGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL3Rlc3QvY3hsLWRlc3Ryb3ktcmVnaW9uLnNoIGIvdGVzdC9jeGwtZGVzdHJveS1yZWdp
b24uc2gNCj4gaW5kZXggY2YwYTQ2ZDZiYTU4Li4xNjdmY2M0YTdmZjkgMTAwNjQ0DQo+IC0tLSBh
L3Rlc3QvY3hsLWRlc3Ryb3ktcmVnaW9uLnNoDQo+ICsrKyBiL3Rlc3QvY3hsLWRlc3Ryb3ktcmVn
aW9uLnNoDQo+IEBAIC0yMiw3ICsyMiw3IEBAIGNoZWNrX2Rlc3Ryb3lfcmFtKCkNCj4gwqAJZGVj
b2Rlcj0kMg0KPiDCoA0KPiDCoAlyZWdpb249IiQoIiRDWEwiIGNyZWF0ZS1yZWdpb24gLWQgIiRk
ZWNvZGVyIiAtbSAiJG1lbSIgfCBqcSAtciAiLnJlZ2lvbiIpIg0KPiAtCWlmIFsgIiRyZWdpb24i
ID09ICJudWxsIiBdOyB0aGVuDQo+ICsJaWYgW1sgISAkcmVnaW9uIF1dOyB0aGVuDQo+IMKgCQll
cnIgIiRMSU5FTk8iDQo+IMKgCWZpDQo+IMKgCSIkQ1hMIiBlbmFibGUtcmVnaW9uICIkcmVnaW9u
Ig0KPiBAQCAtMzgsNyArMzgsNyBAQCBjaGVja19kZXN0cm95X2RldmRheCgpDQo+IMKgCWRlY29k
ZXI9JDINCj4gwqANCj4gwqAJcmVnaW9uPSIkKCIkQ1hMIiBjcmVhdGUtcmVnaW9uIC1kICIkZGVj
b2RlciIgLW0gIiRtZW0iIHwganEgLXIgIi5yZWdpb24iKSINCj4gLQlpZiBbICIkcmVnaW9uIiA9
PSAibnVsbCIgXTsgdGhlbg0KPiArCWlmIFtbICEgJHJlZ2lvbiBdXTsgdGhlbg0KDQpXaGlsZSB0
aGVzZSAhICRyZWdpb24gY2hhbmdlcyBhcmUgY29ycmVjdCAoYmVjYXVzZSBjeGwgY3JlYXRlLXJl
Z2lvbikNCmRvZXNuJ3Qgb3V0cHV0IGFueSBqc29uIGlmIGNyZWF0aW9uIGZhaWxzKS4uDQoNCj4g
wqAJCWVyciAiJExJTkVOTyINCj4gwqAJZmkNCj4gwqAJIiRDWEwiIGVuYWJsZS1yZWdpb24gIiRy
ZWdpb24iDQo+IEBAIC01NSwxNCArNTUsMTQgQEAgY2hlY2tfZGVzdHJveV9kZXZkYXgoKQ0KPiDC
oHJlYWRhcnJheSAtdCBtZW1zIDwgPCgiJENYTCIgbGlzdCAtYiAiJENYTF9URVNUX0JVUyIgLU0g
fCBqcSAtciAnLltdLm1lbWRldicpDQo+IMKgZm9yIG1lbSBpbiAiJHttZW1zW0BdfSI7IGRvDQo+
IMKgwqDCoMKgwqDCoMKgwqAgcmFtc2l6ZT0iJCgiJENYTCIgbGlzdCAtbSAiJG1lbSIgfCBqcSAt
ciAnLltdLnJhbV9zaXplJykiDQo+IC3CoMKgwqDCoMKgwqDCoCBpZiBbWyAkcmFtc2l6ZSA9PSAi
bnVsbCIgXV07IHRoZW4NCj4gK8KgwqDCoMKgwqDCoMKgIGlmIFtbICEgJHJhbXNpemUgXV07IHRo
ZW4NCg0KLi4gSSB0aGluayB0aGlzIGNoZWNrIG5lZWRzIHRvIGNoZWNrIGZvciBib3RoIGVtcHR5
IGFuZCAibnVsbCIgLSBhDQptZW1kZXYgdGhhdCBkb2Vzbid0IGhhdmUgcmFtX3NpemUgYnV0IG90
aGVyd2lzZSBlbWl0cyB2YWxpZCBqc29uIHdpbGwNCnJlc3VsdCBpbiAibnVsbCIgaGVyZS4gZS5n
LjoNCg0KICAkIGVjaG8gIiIgfCBqcSAtciAiLnJlZ2lvbiINCg0KICAkIGVjaG8gInsgfSIgfCBq
cSAtciAiLnJlZ2lvbiINCiAgbnVsbA0KDQpTbyB0aGlzIHByb2JhYmx5IHdhbnRzIHRvIGJlOg0K
DQogIGlmIFtbICRyYW1zaXplID09ICJudWxsIiB8fCAhICRyYW1fc2l6ZSBdXTsgdGhlbg0KICAu
Li4NCg0KDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlDQo+IMKg
wqDCoMKgwqDCoMKgwqAgZmkNCj4gwqDCoMKgwqDCoMKgwqDCoCBkZWNvZGVyPSIkKCIkQ1hMIiBs
aXN0IC1iICIkQ1hMX1RFU1RfQlVTIiAtRCAtZCByb290IC1tICIkbWVtIiB8DQo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBqcSAtciAiLltdIHwNCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNlbGVjdCgudm9sYXRpbGVfY2FwYWJsZSA9PSB0cnVl
KSB8DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZWxlY3QoLm5yX3Rh
cmdldHMgPT0gMSkgfA0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZWxl
Y3QoLnNpemUgPj0gJHtyYW1zaXplfSkgfA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBzZWxlY3QoLm1heF9hdmFpbGFibGVfZXh0ZW50ID49ICR7cmFtc2l6ZX0pIHwNCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC5kZWNvZGVyIikiDQo+IMKgwqDC
oMKgwqDCoMKgwqAgaWYgW1sgJGRlY29kZXIgXV07IHRoZW4NCj4gwqAJCWNoZWNrX2Rlc3Ryb3lf
cmFtICIkbWVtIiAiJGRlY29kZXIiDQo+IA0KPiBiYXNlLWNvbW1pdDogZTBkMDY4MGJkM2U1NTRi
ZDVmMjExZTk4OTQ4MGM1YTEzYTAyM2IyZA0KDQo=
