Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338672D0C7E
	for <nvdimm@lists.linux.dev>; Thu, 14 May 2026 16:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778776885; cv=fail; b=i0loV3xkCM64IJLxQUdGBO78xkAF1tTye4cshM2gWIgdmA2Wl/mEZseemFzmNAVw8qNkRe57DtvWGbIh97zS0hMtOx70Sv2PyxX+aCq33Eh0Yxe60bnV+QDoh29VeExA3NFeNDifJpRdC4dY1GBR0cIbFhRxocez4S8u6sNCnK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778776885; c=relaxed/simple;
	bh=Ts7J2j8xw5VtGZ6ZB2dODebKjm8NyAXUpwb7vQC//Fk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eIqdCYmgyxYFuaMFRpmTObK9Y3iD1qZrqQpMdPT7BIyKh08wC5JSmFvRmlC0//Xjk0YyJFuUIKInSs4zB1TRVohhq0tNtQH4/LK+A85zWgXZQly1bkbq1uf8oH5IFn3fu92FhzIzwyNypKMeHV/Nsr1Uwfq+jWyZtS7EkLDJNkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FwIDuhsx; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FwIDuhsx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778776884; x=1810312884;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Ts7J2j8xw5VtGZ6ZB2dODebKjm8NyAXUpwb7vQC//Fk=;
  b=FwIDuhsxNzjIhTC0VMlurBVyrnYs6X4UzUo+gRhg1+BrgVUwh5PxbivM
   ma8Dm+290qcmL3dFR1iuAEj4J+sMWU6qS+X6FicpiISsVPmwX6zpyTaEr
   QF7Ug1sT5rqi2RDORS6xnvgCgTnIaaoXqKWunaBGM97odxxckyVU4BBNJ
   MAXCFESX1er2+jqu8SVrlQWAqyXM4srlqcWNJRrwaobbYqGc5GN9rhFVZ
   UY57CVlCp0im4V5BVTpN0IC/f15F0qizDLdzfpPiRR9Ghwgs6nTRKhmgT
   pf+WvMcLsX2FOshK1vt/gh970NPbZo3y8OOoBlfa7LyNDoj93MFlDK4xV
   w==;
X-CSE-ConnectionGUID: xpHgcDD7QS6JPgQgTs7Mvw==
X-CSE-MsgGUID: pgBDkRHmQKSakC9R3DN4Ug==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="78863899"
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="78863899"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 09:41:23 -0700
X-CSE-ConnectionGUID: SEsFQdV1RXmYAzXYIcKi/w==
X-CSE-MsgGUID: /kuUZTNRRA+9pN+xp4TVHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="261960193"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 09:41:23 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 09:41:23 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 14 May 2026 09:41:23 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.23) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 09:41:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gg4WnYXMYSSh7bHGxgOgfiKLL8hjnIhZcwb96uB4GF4ZCPKG7ReN/n3zEXYPi9NjfzYK8KGheZn0+kzbfmQXMYulBQnHylAHvi9HkrFTiadBTzjQ8b2ZfCXlPWr6NNE/nCgMg9HjHrRHy2m0lsECSDXSf/hLjujBjAn1pm48+YlbQYBymAI0C0ZOIGW0jkeRM6+9nLEG8nQZiwQysZ+WJLtJEtZvDYFpNcRUyixEJU6gDgDz/Wj0NV/i5go7jR/N75C28dYPt6HtCaFyhBGz0GBYWbMk8cjUmjIzRENkcQVKjL4zR8WHoNWyowq3OQl6O7roTbd7yQcMkvlHLHaA9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXrgLeu+HpeOCRYfaiBKWwhVDX6hhAldfIemdgI0+3I=;
 b=JzovYhGr6+IeSOWLuhoogLzMx5kkxIk17+5ZJRWMKnDfH9woSa61ikEMrZyKgUuo4YljlVkC4HtrXOrbhwU+7PdVJmKyjOHObTJxjHZz2AuaMUtLkPRa5whe2Rs8lCNqqTIFTlyptWtK56jFNaq9pRF1GqIV1LljMjPq2MPbfT8PIOX8TKYToeQujGulbUUfcwEXwLO7CBa050tluqiUhidNxVDJyA+lsu6A/9IQng8ShfawJXC9ZkKr/t5NmqmyNpbSvGvFjlhEjbYtFpTQdUnC8Bt09VQIkPqi7ECtJGwqtQJCjFU+98sfrgF2dEDitaAAUw7yc1JjGbQTZ347TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM6PR11MB4689.namprd11.prod.outlook.com (2603:10b6:5:2a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 14 May
 2026 16:41:20 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9891.021; Thu, 14 May 2026
 16:41:19 +0000
Date: Thu, 14 May 2026 09:41:16 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Tomasz Wolski <tomasz.wolski@fujitsu.com>
CC: <smita.koralahallichannabasappa@amd.com>, <dan.j.williams@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <ardb@kernel.org>, <benjamin.cheatham@amd.com>,
	<dave.jiang@intel.com>, <jonathan.cameron@huawei.com>
Subject: Re: [PATCH] dax/bus: Upgrade resource conflict message to dev_err()
 in alloc_dax_region()
Message-ID: <agX7LCdvy38_z4Pt@aschofie-mobl2.lan>
References: <20260514093208.13110-1-tomasz.wolski@fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260514093208.13110-1-tomasz.wolski@fujitsu.com>
X-ClientProxiedBy: BY5PR16CA0026.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::39) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM6PR11MB4689:EE_
X-MS-Office365-Filtering-Correlation-Id: cf315451-558d-480d-9ff3-08deb1d7a020
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info: LoEVQa72LaqANjiCLNAFoNO3qT6yOxlqKoOqaRzWaPfhBDGYB0L0WRC4CrGVu2rRCOu8QTdwwfc4N7ruP2EvspzQedKBLjym1pkM3FF3q0EQu+JQa9CHLJ+u94wM+5SP23D9gt8YWMFBDy9rifQDu5qfC4QUwe9LWS2X+IOX511/jubGyIqpR6+4DgOAwChKgiyqCGCeULmwuVtSRzpc86Yh3DVN+UWpWZamEGgFDsW5P8GRpAHQdGwhbaODHdWhblwOWKPWyU54rapsqX3gnLneyGBy0MvUX5e9XSv5JYeT0zorZMi++IOFoocxHqYznu3hJnBM7PWVHI0anX00Hi0QgimmlT7RrtD5Jm4aa1bf2AFeHYVLFDa/xd2ai/QdUP/8dlbtHObfUyuwm+spTKjiSutqtPqQqgnMF0kBrqTKyHWwkPm3YiNeaQIRIIct17vfU/y0O8KpI5jkylfN7X+NP3lNtx0RsK9hVOBKCM56WHTsFpO6RVCWLkVbgEl8Tmdw710MAWYB00MPEjMKAIlPmY1xgPI8nTyJ4/Hy+7+ZXdjQtZlsGz3KRiHCJK2wacbUsPBfegbJ3lNcGJwas1k3TVL1dbZYmOFpKUJxVp1XzkuGxjgoQMxqRcaqkqZ4BjPN1GbPiIHjlwWkxllYL5conwmEL2XzBqcBkTm0WzWSh9lOmROrOJsY051KMdQY6ssyQ9hPJcEoT6gig+mZKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YU9JYThYQlpGeWdITG9mV1I2UE5SY2ZGVVpWMEFtRkpqQzl0a25Odm54M09m?=
 =?utf-8?B?clg5ZVRyOWo1QTFydEFWcDIzVHhKOGczVS9FK3N1d25vNjZvdUNNUTFvUjFQ?=
 =?utf-8?B?a3doeE56ZTVqd0Nyb2Vtc0ZzY0I2dE13WGxLYzUzU0tqdTdYcGg2MUpJQ1hQ?=
 =?utf-8?B?SXVHeW5kOVpVVXpjOU80R2pzMkxYMWlEZ3FRaElNT3RzdEFucUNtY25Qb2dw?=
 =?utf-8?B?cTVFS0xBTkhjWEFReXhta2pUTmprbWloWjZuRGd2SGY5aVpNbkFSbGVoNkgz?=
 =?utf-8?B?bGVZbjJDc3UvNldtb3YvdzRVTFF2bVJuaGJxRGUrOWY2QWN5aUE5dW9pTURw?=
 =?utf-8?B?cGZoQXlQa0c0eFFKM3JjcWRNaHZvMTJkVlVodm50d3QyS2dUT3lzNHN2UHZj?=
 =?utf-8?B?eDZ1ZEpNbStkaTd2ZEtVamF6cVNHWmNqVE0weGcwWjB6WjZacTRnSEErWThO?=
 =?utf-8?B?Y1RUR0tqMGtxSE1WZDdOeURCc0NYVG8vakJIRjNVam1GODlkOHd1ZGNzZ2cy?=
 =?utf-8?B?cWhhSlRFQTVHNTMvRk42UWtWaFpNaFF3WkVmQmt6aEYzQ2NXVEJhT2YwYnJX?=
 =?utf-8?B?aGlpSVhjZEVXbys2dnE0TXFrVWRBZEJtMThUTG5IbWNvdGVsK2loeGlWMXkz?=
 =?utf-8?B?VjcwNFMvempEM2FTcEc2dE11ZC9qK1c0Rlg3L3RtZjRSUGx2V1M5QjE2cloy?=
 =?utf-8?B?Zi9TUmFvdnd2U2hkNUt5ajVZbWhTYzlic1pNVEsvNDR3SkY3Q2VJQ0x0NXpD?=
 =?utf-8?B?U1FuN0l2Y0xZR0dhbzh4aVJFR01zMUpWd3lHZEhlMG1pS1Q5alh0STZXTXRH?=
 =?utf-8?B?VXJwd004b3BXYWNsZEc1SGZGRlFyaVFKUGI0Ym1FSXdVNm5VS0gzQ29aTk5x?=
 =?utf-8?B?VUNoTGRnc05CK2s2T3VyQ1lwZUZWcTBZR1pkNmIrMlhxSmg0azhjY0RuRStV?=
 =?utf-8?B?WGdRMjBzOWFWb0ZVOXBaTW1xOTNsSlZ1Z1BoNmFTaFRlQVEyTkthVHpGckdH?=
 =?utf-8?B?cDZDRTdrbGZNazg2TmJRMjhDbGJCbVNhTjJhVWhVRjZuRmRCQ3NmeDduaEhR?=
 =?utf-8?B?UjV5aU4wU2JoTmpVQkcvazc2eDRrQ1ZLL1ZTT1lCNDhKeHp3dVdsZ0tIcDRH?=
 =?utf-8?B?MFB0THVJeTlxREY1amRCbndPZFNGRDJDNlRTNjlkWDdFTElvSUdYVWh0N2I5?=
 =?utf-8?B?SDlkek1uRUMvc2Vqak5lMmhKTllSYUJhSkp1T2VJODYzTGZXZm83RGYzSW9t?=
 =?utf-8?B?dEljUVVPbDYwSHJmMkdxYndyeGI0MHBHblB3TzM5OTVMRlRkdVY0dWlTbFR3?=
 =?utf-8?B?RFJtREFkWTIwbTNGbCtNdnIxaFR4L3lTRGxiaE1WbHFMUUJ3ZmgyUm1IWEN1?=
 =?utf-8?B?cDFnUVN3cnpQblI0SStHQVhtSkphU0xQbTBCaEtjWHFoc25QbWl0WURFamUr?=
 =?utf-8?B?TTFudWxTTnU2eGs1VGJqNEZRdmltT1ZWOUl1VUQvVG5nUzU0cFdxUjFtaHJK?=
 =?utf-8?B?ejcwUFhNLzY0L2NNK3BFSEVtMnp3MERMWmhJNVhlOERvRDExcDQ0QVBOWFdl?=
 =?utf-8?B?SHArUUpOSk5qTWpzYzJtQVk0REp2RHhjMWVGaW1YVmpWV0FOYTEwTmcyTzZt?=
 =?utf-8?B?eFJZTitKK05vTUNxYjFid0VSeGZDYmsrUGdTb3VReUxabGx0dVJqVGJpRWcy?=
 =?utf-8?B?MWxqS3ZISGFvK0JzTHJlbUNkTGR0K25FUU1uOEtyUjNHZk1IWS9kSUJHc2Er?=
 =?utf-8?B?dkRLU1lKV3N6RVcxeU0yRW50REo1c1lHdVRNMzRYdTJwcHhYd3F3TUJZTmlN?=
 =?utf-8?B?eTZIQndJUzBlZUdHWUFxRXRwQ20zWGNCcHA4TzJPYXBtV0x5V3RmSkJUMFMy?=
 =?utf-8?B?eS9sS2c0QTlJYU9vVFhNOXZOMG5EN1YzcklmazgycWVzSzltV25lVTN4SE1J?=
 =?utf-8?B?bEwwcy9iRmQzMzBZNmhuVitjT3NudGFReVFncXFzdEN5T01RRVVFRGdnSnRo?=
 =?utf-8?B?WEExNFpHQ20ySUdTOWNjeTNISXV6dEN1OUpmZDROczhYaStZREFEalljclRN?=
 =?utf-8?B?Y1B1Zk5lZExIT1hKUUoxQXJFRlhISDJDWjZLOWg1YlhTMm9mWWVmVU1NN0JB?=
 =?utf-8?B?c3BEWkV3K1NhYkpzWUdtQzRQMjFlQ3NNK3hqRUVucDNLTzJuZGxVRjJXdWl2?=
 =?utf-8?B?alhuTXZTVXR3bDFSZzJ1cEc2b3pOYU5idUFua0czbTNmQTNoMmphOFd0Nmgy?=
 =?utf-8?B?RUxnS3BSRVZMRnp1UEhNenNLUGxOeVhvbnpmT1JBbHd1WkVSYnRIRGVRUlB4?=
 =?utf-8?B?elcvZTdSRGkyRFJGeGMwTkhFSjRZV1c1amNrOWNRV2NzQnN5emxnTVBwTHBL?=
 =?utf-8?Q?nN+sUGnhsKsAo+Mk=3D?=
X-Exchange-RoutingPolicyChecked: DVY81O6PCY0QXZ8JuxCBF5O8v5AXWzizmZZggh1xVyUEGrHnBvG13HZS8vi3U6tBu5AFpF1+PkqcmQL/buv/S3Jz+LQbYXGIvbuBhxkli9nyg+lTNEX8S5Yg5cN7i0XNKgCTKP71wslWi/cQ7/0X+5CI8/O/sAy/sc7r/7z5WMkpPLK5ZHJQpnOR3ho1iMJKnHb8617Vd6n35tE0RYmSgzlr9scl+oOwT2yGimp6VBG8MNO6HC6/KdyfpWt58bnAQhxNR06YD1n5GvcsO7Vn3XFUfqZjXgLyqcDtx+KTKKi2iV+7MJsS4wiWNp+Ltla4NVr44Z6JToDT07NTDSj4ew==
X-MS-Exchange-CrossTenant-Network-Message-Id: cf315451-558d-480d-9ff3-08deb1d7a020
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 16:41:19.8173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 23XJdr7ndqwUWSjU+hUZbY2eFUqf7cSftvg0TrIXhF/3KMSxmOQA5IPSjt7kg1Ng14/D79oigQij1zkaw7+Twle34N/2lQJRPG0TmylRvWo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4689
X-OriginatorOrg: intel.com

On Thu, May 14, 2026 at 11:32:08AM +0200, Tomasz Wolski wrote:
> The dax_region resource conflict in alloc_dax_region() indicates a
> serious configuration problem — two subsystems (e.g. dax_hmem and
> dax_cxl) are attempting to register overlapping address ranges. This is
> not a transient or debug-level condition; it represents a genuine
> resource conflict that an administrator needs to be aware of.
> 
> Promote the log level from dev_dbg() to dev_err() so that the conflict
> is visible by default without requiring dynamic debug to be enabled.
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Link: https://lore.kernel.org/linux-cxl/69c1a8d1c0fa9_7ee3100a1@dwillia2-mobl4.notmuch/
> Fixes: 34f80bb969cc ("dax: Track all dax_region allocations under a global resource tree")
> Signed-off-by: Tomasz Wolski <tomasz.wolski@fujitsu.com>
> ---
>  drivers/dax/bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 68437c05e21d..cd963eeeef7b 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -672,7 +672,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  
>  	rc = request_resource(&dax_regions, &dax_region->res);
>  	if (rc) {
> -		dev_dbg(parent, "dax_region resource conflict for %pR\n",
> +		dev_err(parent, "dax_region resource conflict for %pR\n",
>  			&dax_region->res);
>  		goto err_res;

Hi Tomasz,

How about using request_resource_conflict() so that we can offer
more description in the error message?

-- Alison


>  	}
> -- 
> 2.47.3
> 
