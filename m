Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB062594
	for <nvdimm@lists.linux.dev>; Sat,  1 Jun 2024 03:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717212170; cv=fail; b=HYforON5ofUt4tGYKDL4Gblxqc1RXSPC96FdP+Hm3eN91iZIOyOwj/otoD1rBqtQhJ1ir80kLAG6WIPmj/QqTlx/3wMmz37RMOAqIV18dT2Totho+AcNwPEIDfB06cSEkqxbGLA1Ax75TVQO6dlYzySqhHkNW9J8U6AL+tkko5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717212170; c=relaxed/simple;
	bh=PKKeG4I82M4WuWW9JsNJbYVJxcCihRZAwdPI2aK08n8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ou5hc6qJP/eltl4QBBuCLnxMTZQWWqFap1n3QzcXtON8zpJOtosMyA4BiL1UGY0wZwbeznHnL0/Tmz5UNv9KPQ2Q+h3YBCiiWU98B/6T08awlIgG4XtK5yRxEBQqNAX00FPwW2M8C5iFgpfa62iiVBtUCUvQdm+Wumpv8aGxY2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L5ojxIpS; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L5ojxIpS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717212170; x=1748748170;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=PKKeG4I82M4WuWW9JsNJbYVJxcCihRZAwdPI2aK08n8=;
  b=L5ojxIpSpkoADYLQ2E4F3+EwgbtNrLZeatB71IIxfgsnXPQvbjtEPP9N
   tzRDdgetE/o4Ftwp5+dOE3EfDj7PnCe8m6iuOGJSHbmk1QrBq6KT7658r
   OdkxtC3vbj3GpOYdgShtP4aaQ8jhJeSnhM9RFnxaDpscAT3uJeY7fVz/2
   M5nluRnIDhZQ63+jQ4UPhlFDgxBGltLQ9PvGvcVnFZ90BAE4czjCVxw5A
   Q4DILzXF3+peU1bg1FQ9I+eh9d9AangXiNfT5KjkbnAhZylHfpCkt+Ifd
   P+/7S4mxPJFG8QmV7RQV2517vJQpm/sirWzDp+q/1w8IIEevD54Twmmz1
   Q==;
X-CSE-ConnectionGUID: CBzAP+8mQEqqVWuCMqu+eA==
X-CSE-MsgGUID: bXxfQwNNTnWTfR3qz/o5Jw==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="17599589"
X-IronPort-AV: E=Sophos;i="6.08,206,1712646000"; 
   d="scan'208";a="17599589"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 20:22:49 -0700
X-CSE-ConnectionGUID: VkZsS/ffRL6qi8vPQRT0AA==
X-CSE-MsgGUID: Gvm0R+CgR8W4/TISTzxcOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,206,1712646000"; 
   d="scan'208";a="40888365"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 May 2024 20:22:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 20:22:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 20:22:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 31 May 2024 20:22:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 31 May 2024 20:22:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaBLkBZcmYHjZZLFMAppCQbl9O9pm2H5KNTAa+KCOqOBpOslhZ6I8NyR0g146qlp2Fu8jYz7nLPDXxWV84qYYf9bo+xfK9DzRFCFItiC2+AMY7IbgaelvQQ/D6lDax9sgLeAbFRrOmRfHq8iTwdwJMhg+sD1rwbOCto1vZnbVL/xDgRKfAjksWp14GUUT1KvTy2fGDetNIXkQFq/tbYsBy/8JQDdYeudAqMwCPuQY0Fmp+dw/WiXkwX7uT387iUFvBv7wMqXCFQBqu4tmwQygqNuP7cgvXzG4JJJdmQBdSFPOCVBldUTBLkklYreAKejbsp3HO1Xqas62VVPhhqztQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=19nra0uPaneGRmteVkdIx3ifmapMfZy/4ZLnIFlJ8xw=;
 b=dIfLNTsaYijnrB/wBxQ08XDZ18ewyCepkNMr0Sj4ovqOHoYf7izkVqjR2L2s5dO2sEG4OqFw1OsjTblYIA0kJS07PTZr9vzkaO2bLSJhudaboqRs7DjDLmvqJTuHK/C6JTEHRmtbizX0pw+JCEpHV3XG7Nk5NlhkFIoHAajr8MGAVixcz/CzttsIowM3RsJs51z2gA5Mu5EJ0V7oCZd5l1QyBNREafYubEvCIWNEiMAr692X3Qu0/HukD5WJ73xJxRKzlLqp8ugkFt2lqqOxXuT/T8EpF2pa3RV7L6L3d8R/Pqx/6PY9F0XapAUMWLe+If9i9naH/i2DmkBeGaxdwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN0PR11MB6060.namprd11.prod.outlook.com (2603:10b6:208:378::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Sat, 1 Jun
 2024 03:22:45 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7611.025; Sat, 1 Jun 2024
 03:22:44 +0000
Date: Fri, 31 May 2024 20:22:42 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dongsheng Yang
	<dongsheng.yang@easystack.cn>
CC: Gregory Price <gregory.price@memverge.com>, Dan Williams
	<dan.j.williams@intel.com>, John Groves <John@groves.net>, <axboe@kernel.dk>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
Message-ID: <665a9402445ee_166872941d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <ef0ee621-a2d2-e59a-f601-e072e8790f06@easystack.cn>
 <20240508164417.00006c69@Huawei.com>
 <3d547577-e8f2-8765-0f63-07d1700fcefc@easystack.cn>
 <20240509132134.00000ae9@Huawei.com>
 <a571be12-2fd3-e0ee-a914-0a6e2c46bdbc@easystack.cn>
 <664cead8eb0b6_add32947d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <8f161b2d-eacd-ad35-8959-0f44c8d132b3@easystack.cn>
 <ZldIzp0ncsRX5BZE@memverge.com>
 <5db870de-ecb3-f127-f31c-b59443b4fbb4@easystack.cn>
 <20240530143813.00006def@Huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240530143813.00006def@Huawei.com>
X-ClientProxiedBy: MW4PR04CA0164.namprd04.prod.outlook.com
 (2603:10b6:303:85::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN0PR11MB6060:EE_
X-MS-Office365-Filtering-Correlation-Id: 35116f61-f083-427f-bf6f-08dc81ea1a7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?M2MvUk1scW91NEliWG9DbWF6SG13UjN2V1RUSTZiZXJtcXlvMEFhcGdSK052?=
 =?utf-8?B?cjJlSU5ObHl0YjZ6bnhSc3VacmkyVHE3TGFLL3VoMEFmNG0yWmZRbWVwMlM1?=
 =?utf-8?B?SURKcnlqV2t4Q1dXQlo2cnpsZUpaL3dqZVY0UWIwK0NNL0ZzaWlnOCtub0lV?=
 =?utf-8?B?RHlnMlY4SU12dDZuS2dmaWtVN08wcFNIS2tXT0JSdGkzS1BnRS9vaE1CWjdq?=
 =?utf-8?B?WmxCMVVjQ05jOCs1c2JsTFpEZG1Wemt3NEs0RXZ4YnJKeS94cm5RNzZPWWxa?=
 =?utf-8?B?WGR4dWhjZ1E2SU9QYVEreklTeUlGSzlhRnc1Qk9PS0ovd3VvTVA4ekN1STJQ?=
 =?utf-8?B?SGhxelNYK2t4NC9tcG9paVFXNllON21PdzIrOUhTeTNVSzVJV0p3QnZpY21J?=
 =?utf-8?B?YVFDNUg0T2RPM25DdXViTE15TDlRQlZGNkVnWHd0T1Njb09zcWMwNUZDOVlk?=
 =?utf-8?B?RHB0NjZiTURSWkFRNHBiZU1vN0JubkU3Y1pQV2hQNEJJYm9LUmIyNXcxVStx?=
 =?utf-8?B?WTZZVXV2dHYvM0VlNFhqLzI0RSs1VUdveVp5NFVITGRFVE5IVzEzNFdhVjRu?=
 =?utf-8?B?TCtXeldLVDRjQ1VoYjh0V3dMQysrY3NpYnVrWFdzUEs4NlhUNW93Ti9QRW5L?=
 =?utf-8?B?ajdOZmNqSFpnWm9IeTAwZHdIYUJRVXdJYVNidXdWbFNYaHMrU2ZZR21QSXpl?=
 =?utf-8?B?SnFvMTBDb3VlUjhJcm4rcEp3dy9ZOVRSalJ0OHc2MlBMQTVCdkJCeHlQUWsv?=
 =?utf-8?B?U2F0R1FVQ29iTVY0SERkRWZhRVk1RVVXWDVTdjZaemdYNGZ6VmFGSm0wZmE5?=
 =?utf-8?B?K2gwc05JQzc3WUVURDFQUUE5Q05XSSs0Ujd1YmQvL2dKcDkzNzIzWWpmNmdP?=
 =?utf-8?B?bFREbGhDL05ILzR2Z0FaYmdJa1A5YVJYR05EUngwY015STFPV2NZK2ZVVGVw?=
 =?utf-8?B?UzVNTDFOZFBMYkw0NG9hTEpKc0ZTazRXaHJpOVQxaWcya3E4OVhqYzB2d0Yw?=
 =?utf-8?B?NGtyRGpGOUdTUlcyRkZaQU91YlBtOGhZemdERTV1WExPbFg2c2hQNzVYOW1h?=
 =?utf-8?B?VTNWVnU3MzZlTWJwMDdYVVhUcy9tRVY0NEZ1ZnNFZ09aOURhQ1JFM0lWWEZL?=
 =?utf-8?B?ZXB4akNWVVQ5RXFwaEZqRGpnTkpUckpERTE3MWdaYktLMndGQlFGSXp0SWFp?=
 =?utf-8?B?Ykt6ekF5TVdQczlEdDc4cEJVWHowVm4wNTB2bFkxdDIyakhFaGdkeXNWTE05?=
 =?utf-8?B?UEdZbmYzakpJaTBGREZITzNsa2FVeGpZSys5MVlnVVZOcXUyMnFGNmtTVmds?=
 =?utf-8?B?NHVoT3ZGaUhUZXVLYlZyQ2ErOW44Q252T1ROQnhjM0pWd2I4bk0rSkRMMGdk?=
 =?utf-8?B?K1pFNnBuQXlGeWN0UlZWeW00TW1CN2lsSFlNYWlqT2U3RkVRNHBHK2lXY1Qy?=
 =?utf-8?B?eUMzVElpbTJGbnBNNVhOdnZQRXl0Ym9WZmQwYkErekI4bFJYMVpJa3ZDS0s0?=
 =?utf-8?B?WVQ2dGFXSW1vQi9SOGpaN0xLRjFHaFJZa0F1K1J6LzNwM29aS3dBM0lFVlQ4?=
 =?utf-8?B?TndTTE5FTHhRakV3NTZMaG1IQUNSbHZwQldDeE9UVVBUOURjTkYwR3pxRFda?=
 =?utf-8?B?ZTlZRHBHWVMxcEJSd2dmKy82R3lsVExiZ3B4bGU3ejNKVlBNMEROcGxpQy9n?=
 =?utf-8?B?dW9sQjdnQWJHSnNGRDduSk5XbFFNbU1UcHN3cTltNXlvVzhnbks1cXh3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlpaVEpZc0JicnRsbG8xYTRiRld0djUzdDBYRzVtVHVjSlZGdGkxU1lqWVpN?=
 =?utf-8?B?dTRiN2d6bUkxOHdFLzlhWVpCWXllWEZWR2dXOU5nWUtPMWtxYitaR1BJbTJs?=
 =?utf-8?B?TnpaVjJDNHJtU0c4NlNMQ0N5ZjFVV3RZblRwL0lJbEhJSW5ibU5FaHlBRVht?=
 =?utf-8?B?bExURFlnbk93NnlqWjVBazhEaktOTDRIRmNPblM3Snl4NEt0dFFEUGs0YXQw?=
 =?utf-8?B?cjFMdHRDd1hTV0h4SWRUL1ArZnNNeGlPNDlYamdmZEZSb0hqNnE2RmNEKzlK?=
 =?utf-8?B?dWN1Z3Ewa1pNcnBWVlJHL3UvS0VDQVBqem1iWUV5RS9XTUlIYlZGdmZEU3oy?=
 =?utf-8?B?SGg2RzBNZmR2VWgvZXFkOFZIUGVLTHFoaTdQcUJqL0NYL2xEZ0g0WlNPU2VM?=
 =?utf-8?B?a3hHU0dwTEdMenE1TExXTzdROXUvY1ZtNGNEbktvdkkwZmdFRCtndXRVbExq?=
 =?utf-8?B?a1M3RTNmektDN3dGV3VCNWdpOExDS0hjeWNWMy94QURYcEdxdDdiS2FtSmJj?=
 =?utf-8?B?ZGR5aHgybTVZek16YTJYUHdJOVRDSW5TMUVoeWZyWWJXS0NrbGJqbU91clYy?=
 =?utf-8?B?bWNIK3QwWWRFTk1yNzUyWUljODdVenVrQmFPSDJvc1N6Wm12UXYxS2ZWb0VW?=
 =?utf-8?B?ZUNSTy80SCs3encxWnVCQmtUenlXY0xlVHZ5YWFSeDZON0FxaFlDb1lkMHVB?=
 =?utf-8?B?RlMxWVNPMmlsaEYxVG9GZmJTLzg4YUg1SkxmOUZxMFQxZXQreFRHZ3N5bE9u?=
 =?utf-8?B?bi96QUZaamp2ZjltZnl2YVJNRXhObVRhWVBWS05RdnV5a0ZGa2FNNDJpQVUy?=
 =?utf-8?B?TGpUOHMwclVYcDlCQkxROHh5dkxoVW1WamVnc3ZGaEhwZ2NrVE10blBqLzRS?=
 =?utf-8?B?L0tDVWV4aUR3UkE5QlhUalRSZGc5MllMdzBCbW1aZi9GSjZld2ZsRnl6RmFw?=
 =?utf-8?B?RUxCeHduRXl0dUEwa2NLNHZXVWVlOUdvNk0yRmFma3BGNXQ1NGEwQmFrampt?=
 =?utf-8?B?L211RnFLQU5wei9zbmJQMlJKazZUZ0hLSkJCS2hWR2xzWUdUVFA1bFZhc1Jm?=
 =?utf-8?B?OGxVZmFmVGZCeTZFYVRCa2gxWnMvdjZObjRUNml0Ti9ObEZpV3lmOUhpUm4v?=
 =?utf-8?B?NGtSWjBDWU9kRU5yZFlEcjRORHJrelBNUWJLbFNuVWdiNk5wNCtqakJtZU10?=
 =?utf-8?B?VXVTZndzTGw1N3JVVzVhSDZ0enM4dWhxZEVMNXR1OCtHUVBzTkZkeEphZlBC?=
 =?utf-8?B?eENpL2piYkhqRi9oMGg0bzUydzBBbkFqT1RpaHIzV0YzR3BiY3MxWUpralBo?=
 =?utf-8?B?K2lmbEM0UE5ua2NpOXk1UXBrYmF6WU9IZ2N4eisvTkY0OHdNV2FEWmZBcS9K?=
 =?utf-8?B?WmZtSHB6TlJGVnVyZEdCQWQ1Z25xTWxqS3lGTXlYOHRHOVVRUmpsa3FJMEJL?=
 =?utf-8?B?MXpJK1RHMWtVZHpaRU9raEhvcDFNKytiSnZMN05ScTRSRitxUGRybnVMOElm?=
 =?utf-8?B?eERBa2FiUDBwMDRHYm9kOFNsem8yYjY0bEJac1g2MWRHNUdzV050cHJ6bGc5?=
 =?utf-8?B?dTlweHJUWmN4c2Y2NUkyY1ZrTFBIM0RSbjczVFF0eDd0NFRldTlJMldzNzZE?=
 =?utf-8?B?djlmV0dhU2o2clNDK2UvaWRIR3d4Y1pOb2pxbHRMZTJFUGRtOUl6Ym9ZUVNG?=
 =?utf-8?B?aEdySnQyMFFYOGs1azhvTXlsRUxMdDlKOUJDUm1CZTMwSnViTGQ0RUZEWjBm?=
 =?utf-8?B?TUlWUENBSER4eTFsSFNyM2JFK2NXOFMxcS9QSGNNakhPYWlSRlBtOGEvQ0NO?=
 =?utf-8?B?MHN0TENaaGdqaHF5MEttNHJvWGZJTm9QYUR4cmRiT09NRGc1OHpOUTg2ZFlY?=
 =?utf-8?B?V1p0MTVWZldXeXFESmJyVkNSdDc2RnM1TXp5dlAvSk92YVBPU3pITXl0NUcr?=
 =?utf-8?B?QWt0TjI2TFdEWGdTbm5ZZTU0ZzdFcGZjbCtsbFhyTVVLRGpCWEN5NE1BL2lI?=
 =?utf-8?B?UkJ4Um5MaVYvQ0EycW5rN3BwNnA2eHFiZHE3U3BVY3ZVSENneHlWWExmSTVy?=
 =?utf-8?B?bTIxa0NDVVFrbm1iNDVzQ1QrS0d2M2NPdFFGOGxvMWNxYmUyQ3BtMTU2VWdI?=
 =?utf-8?B?Z1oxRDh2MlQ5d1FHNzM4N1RxbWp4WGxuVDZRZENzdjlXeXFtcnhxTmJxNlhy?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35116f61-f083-427f-bf6f-08dc81ea1a7f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2024 03:22:44.8386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mDucCJjhpr6AFlzoxQ05PfaSH6VR+E2nwSzo2cO2lZfsYkRiAZi6WJxQ+FZNyI1do2XTWzQe2fLj7McaELpInQNbx0a8KPZcOFv8heiaG6w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6060
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Thu, 30 May 2024 14:59:38 +0800
> Dongsheng Yang <dongsheng.yang@easystack.cn> wrote:
> 
> > 在 2024/5/29 星期三 下午 11:25, Gregory Price 写道:
> > > On Wed, May 22, 2024 at 02:17:38PM +0800, Dongsheng Yang wrote:  
> > >>
> > >>
> > >> 在 2024/5/22 星期三 上午 2:41, Dan Williams 写道:  
> > >>> Dongsheng Yang wrote:
> > >>>
> > >>> What guarantees this property? How does the reader know that its local
> > >>> cache invalidation is sufficient for reading data that has only reached
> > >>> global visibility on the remote peer? As far as I can see, there is
> > >>> nothing that guarantees that local global visibility translates to
> > >>> remote visibility. In fact, the GPF feature is counter-evidence of the
> > >>> fact that writes can be pending in buffers that are only flushed on a
> > >>> GPF event.  
> > >>
> > >> Sounds correct. From what I learned from GPF, ADR, and eADR, there would
> > >> still be data in WPQ even though we perform a CPU cache line flush in the
> > >> OS.
> > >>
> > >> This means we don't have a explicit method to make data puncture all caches
> > >> and land in the media after writing. also it seems there isn't a explicit
> > >> method to invalidate all caches along the entire path.
> > >>  
> > >>>
> > >>> I remain skeptical that a software managed inter-host cache-coherency
> > >>> scheme can be made reliable with current CXL defined mechanisms.  
> > >>
> > >>
> > >> I got your point now, acorrding current CXL Spec, it seems software managed
> > >> cache-coherency for inter-host shared memory is not working. Will the next
> > >> version of CXL spec consider it?  
> > >>>  
> > > 
> > > Sorry for missing the conversation, have been out of office for a bit.
> > > 
> > > It's not just a CXL spec issue, though that is part of it. I think the
> > > CXL spec would have to expose some form of puncturing flush, and this
> > > makes the assumption that such a flush doesn't cause some kind of
> > > race/deadlock issue.  Certainly this needs to be discussed.
> > > 
> > > However, consider that the upstream processor actually has to generate
> > > this flush.  This means adding the flush to existing coherence protocols,
> > > or at the very least a new instruction to generate the flush explicitly.
> > > The latter seems more likely than the former.
> > > 
> > > This flush would need to ensure the data is forced out of the local WPQ
> > > AND all WPQs south of the PCIE complex - because what you really want to
> > > know is that the data has actually made it back to a place where remote
> > > viewers are capable of percieving the change.
> > > 
> > > So this means:
> > > 1) Spec revision with puncturing flush
> > > 2) Buy-in from CPU vendors to generate such a flush
> > > 3) A new instruction added to the architecture.
> > > 
> > > Call me in a decade or so.
> > > 
> > > 
> > > But really, I think it likely we see hardware-coherence well before this.
> > > For this reason, I have become skeptical of all but a few memory sharing
> > > use cases that depend on software-controlled cache-coherency.  
> > 
> > Hi Gregory,
> > 
> > 	From my understanding, we actually has the same idea here. What I am 
> > saying is that we need SPEC to consider this issue, meaning we need to 
> > describe how the entire software-coherency mechanism operates, which 
> > includes the necessary hardware support. Additionally, I agree that if 
> > software-coherency also requires hardware support, it seems that 
> > hardware-coherency is the better path.
> > > 
> > > There are some (FAMFS, for example). The coherence state of these
> > > systems tend to be less volatile (e.g. mappings are read-only), or
> > > they have inherent design limitations (cacheline-sized message passing
> > > via write-ahead logging only).  
> > 
> > Can you explain more about this? I understand that if the reader in the 
> > writer-reader model is using a readonly mapping, the interaction will be 
> > much simpler. However, after the writer writes data, if we don't have a 
> > mechanism to flush and invalidate puncturing all caches, how can the 
> > readonly reader access the new data?
> 
> There is a mechanism for doing coarse grained flushing that is known to
> work on some architectures. Look at cpu_cache_invalidate_memregion().
> On intel/x86 it's wbinvd_on_all_cpu_cpus()

There is no guarantee on x86 that after cpu_cache_invalidate_memregion()
that a remote shared memory consumer can be assured to see the writes
from that event.

> on arm64 it's a PSCI firmware call CLEAN_INV_MEMREGION (there is a
> public alpha specification for PSCI 1.3 with that defined but we
> don't yet have kernel code.)

That punches visibility through CXL shared memory devices?

> These are very big hammers and so unsuited for anything fine grained.
> In the extreme end of possible implementations they briefly stop all
> CPUs and clean and invalidate all caches of all types.  So not suited
> to anything fine grained, but may be acceptable for a rare setup event,
> particularly if the main job of the writing host is to fill that memory
> for lots of other hosts to use.
> 
> At least the ARM one takes a range so allows for a less painful
> implementation.  I'm assuming we'll see new architecture over time
> but this is a different (and potentially easier) problem space
> to what you need.

cpu_cache_invalidate_memregion() is only about making sure local CPU
sees new contents after an DPA:HPA remap event. I hope CPUs are able to
get away from that responsibility long term when / if future memory
expanders just issue back-invalidate automatically when the HDM decoder
configuration changes.
