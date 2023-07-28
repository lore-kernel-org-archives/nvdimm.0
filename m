Received: from mgamail.intel.com (unknown [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CF17C
	for <nvdimm@lists.linux.dev>; Fri, 28 Jul 2023 00:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690504539; x=1722040539;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sSnZkujj4ASR7VeYfJEOaUTq348xN8arGI3cfpUKHzk=;
  b=Zz7BdTWF6m+/u94SGqCc5VCnnWMGjIqmDYoPq0rE7j74gQjo3MxGiihV
   NALD2dPPIW/uF780omr9pWwlBpaB6IjF7Xo8RYtAreYXCmSJjZYfVUS/g
   Gmy/EEDrViw/lSF9MRgaGtq2O44pd4Q+bJqvPfqjKTmr++b6RqTNyCHzc
   krc8ZvdDb7U6Yv2WB0mEWoX/Cx4lSU7RUlgfFTDTBHrrNmBTJMBSJBEM2
   m/xjcYEIH1INkDeYnVtV9T1kmHD2ZsJnMVJm4q3xt+r6O10eRZYnwNqvU
   owGfZVmQdWTxyvyjx3l2Fxgr3YRU/eOeU/plSRVqREzJ6p0IN+cKELIlF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="371170506"
X-IronPort-AV: E=Sophos;i="6.01,236,1684825200"; 
   d="scan'208";a="371170506"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2023 17:35:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="870642484"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2023 17:35:38 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 17:35:36 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 27 Jul 2023 17:35:36 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 27 Jul 2023 17:35:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 27 Jul 2023 17:35:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8Nnu0FNzzM212eiWwDKL791hz9Bk6JCHefeS+uj9WAWpAbpncnLv5qntjc6hry15hMmVTC1chGWpGl/KSIOrVsU3s+tjrltIrOweDZylMqoF/9B4OoD/x2bokGBC8/vPS8j+xIu+d4m5GGebpzbk/yLb0JcX37f58IJGKfpiZ3We4IH7+zfTlbWAONd8/sNJ1gbKs1VG2mUaEljD90Dkkp8vlCbUWd9b0HDAAHnkz8KTaAJHa1Rvpv0Z0g9jE8VyIKc+5Cw6T8ru/bGWIKxdsma3ONej4KzHZzDi6b5HlUMANjmxNoCc0gYze3el3NTusSt8hc/UpaEqo+qNTIzRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1mrE7sgcADLiVyxCtVqYhicQhdUG4POwMwJ01IPikus=;
 b=HelDfVwBHElXmXKBZVFX95/UfLgi/gnMZXstiaw5TBhuoQb3Efq+6tFSZBHbxZS+72PfhB/qByYw0qPWPyZi/PqKqtywD1+8dn5vMa92hK19wi0YLEsi52NK/y4q5EZjHKHT22OVmODYge8hrkiLAqrBl9OV+cHmxn4jxISMZytnnkoCMe7Am/L+buaJTryQmYyCfCUoRZGLkIQMkU+krvD17iI1osWCGTYyv1UDWt1jCB/ay3mczOs9dnJqqsk6N7QuKnQl9zgU0N9z24Kj4E+L5tJGzcsKVw7tWwvBSQSFDaXLQiu25lbUxaTxVF7uTqJIIwIrqvIwln5FwkZwXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by PH7PR11MB7148.namprd11.prod.outlook.com (2603:10b6:510:1ef::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Fri, 28 Jul
 2023 00:35:32 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::be6a:199e:4fc1:aa80]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::be6a:199e:4fc1:aa80%6]) with mapi id 15.20.6631.026; Fri, 28 Jul 2023
 00:35:31 +0000
Message-ID: <b11713ca-a7a2-8cf5-fd6d-f77562dd5ff4@intel.com>
Date: Thu, 27 Jul 2023 17:35:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.13.0
Subject: Re: [PATCH ndctl] ndctl/cxl/test: Add CXL event test
To: Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
References: <20230726-cxl-event-v1-1-1cf8cb02b211@intel.com>
 <867b567f-45cc-d6f1-d5f4-cc68a80406b3@intel.com>
 <64c308bc9a6e9_368368294fb@iweiny-mobl.notmuch>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <64c308bc9a6e9_368368294fb@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0072.namprd17.prod.outlook.com
 (2603:10b6:a03:167::49) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|PH7PR11MB7148:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d61a08c-d1b7-4b94-7c92-08db8f028c9a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lhtLmXgRPwxdSl9u9lyefFCkpMbv5T8UdGxdaEDLsx4uk/CiwNpTYXJHv5eH+EKpOMxrRpSQwMq7oJP4v33p6a4ss131/9OZ8deyCS+2hfE51QmX0Sef+rhdh8m83NGkAuBtcI8zS6CBvqoVUyxLuP+ilLknFzNzMnFLIWGx4mwZREbGqZEpDd67Cuon+3etOE+E9AxkVpcvh6OwIgk/vIPdH8yRxqkjfuthyvfSDBakit+lC8TwtT9DGoAP0me1UneZ8QWi47l+jjccY+EqxBDTXLMFiNt85k45ZhYVUWwHpjN3ndBDIf6OWgGwDVhBdsNZ7W90gnPFP5xe6bEXw3JjAATVhf+Wwl3EbXqL5jghC30cb1TaWotUYCzn3tc1FBZfSyZ7YjHwEqE24VURhw3Gwr0JCLCvpbNC0IoaCG4k5Fk1Hf7sCdEnlKXF3S2r1AX0R89iTxoiZWzLWVvrpQcP1xXjBNPq1l0ZNKAPjgl18Dv1g+064cf0U4bKaKTPdLmiJdfuQwRkIIEDdthstyoqOwbErqO2QvhhewfppdvOHoMUllvaOsowkbcdStCPBrzvFBWjFe/DCf5e5d1JYmQIxBZxgUiFE/s51hEmy6kFqdV16+H5alUg+uxboUokIC06Rg+1//aAXPmwNdmBqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(6666004)(6486002)(82960400001)(478600001)(53546011)(6506007)(26005)(6512007)(66476007)(66556008)(66946007)(38100700002)(6636002)(110136005)(54906003)(186003)(4326008)(31686004)(2616005)(5660300002)(86362001)(41300700001)(44832011)(316002)(2906002)(4744005)(8676002)(8936002)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1dRejBTbzM0aS9IZEg4NnJLNXdQVC95K3pRQXFQMkgrQld1UFduMUk5cnVp?=
 =?utf-8?B?OGNsS0RUcjRPblVTQm9UYm15RktuenpqV0NybkY2RUVOTFpVZGJqejB4c2Zr?=
 =?utf-8?B?TndTVXNtQXdOMThOZG83MmEyd1FHQXVPMXA5dTNqYnkwQ3JzREJCblpYNGhp?=
 =?utf-8?B?cEVuL2JuOGVYRnJ5dDhBTXJUVVkwNFNGSzhBdjcweEkwRzVsb2lxREZZbjBX?=
 =?utf-8?B?U1VVSjZZTTlGTWpFcHpSSU1QVGUzdFBKeWRtWlU2V1kwQ2lobkdFK2k5Tys2?=
 =?utf-8?B?anRGWmFndHN1MTJCTVdKYS83TjVHQWR3RWJyUFlkQ3YwYU5GS3lXNStMV05R?=
 =?utf-8?B?aldIdkRzaTRKbERCUnhFMXN4VDR3K2VOQVVGZTZlcUsrRFdXcHNVQTMweDg2?=
 =?utf-8?B?bVFlcnM3aFdDWTdvVlduQ0Yzc1c4V1ZVbHBPdndaRGFkVzJMR21vb3R3TEdv?=
 =?utf-8?B?NTU2RVExWFJjeEZtcWdHODYrdDdIdFIwc0RoNzBkZXdjZ0FtU1F5bWZPQitJ?=
 =?utf-8?B?TFJzeXpoVi9YSWNRVEN3cnNlNXpvVVVuWjRsODRzTFBFK2IzcUIybHEyblF3?=
 =?utf-8?B?NFFoQytLeWlRM0tlUW01UFRkYmwwL25TSU5RRHNidzRsaU9EUVVMUG5XVkNG?=
 =?utf-8?B?N1BMNVljT05FSWlkb0JQbUgxK3NreFo5Rkp0SVloUEIxdVBtVHJPMkt6VkUv?=
 =?utf-8?B?M3FnYnU5UnpaVUtVNk9JWmdRQkRLTnduT0xHNFRZa3RUU0NydTlnaXBLZWp3?=
 =?utf-8?B?T3d0NUJDM0ZwNUhyRnVHUEkyZWJRMGplYUhUWTVJczd5TTZGTG5jeldQR3o5?=
 =?utf-8?B?bVQ5b1dacVd6aGM0L1hkMFRXRGRYbVdGRmkwMDRISHJJbmd6d0VPY3BDYThZ?=
 =?utf-8?B?NkZtZkFtbUUzQkxGUjUrUjdyTE9PNHhxYy92cCtQcW13TXZMMVhtYlNQNHpY?=
 =?utf-8?B?czJIVzZkUnNuUmYxNlhFYWhYaVFHbW5GZUM2UXNmN3NzN1c1TmY4U0dmNFpO?=
 =?utf-8?B?RjlSaG9vR3J0eDJpUnQrYzhnbk5KUTBtdXZ0a1pUalpiUHZEYmcvelVVTi96?=
 =?utf-8?B?V0tDKzdsUlR1THlsZ2RHTHZpVHlCWEhXRWQ5Umc1MDRFUkJDdlFWTmUvNE1u?=
 =?utf-8?B?VjhXSG5uVllqMVBBVzFZSTZzWHNSb05jWUZqb2huczR5ZGlZeHlPU2hSMzRD?=
 =?utf-8?B?SWIzM1ozSnZSK2NmZ0lCZHBKR0ZqN3FvZXk2Z0draGtwNWM1UTNZVUZPQm8y?=
 =?utf-8?B?WUMwOEhwcmFIbkRzSDNoVXJFS1puQ1FSRk9ZZXR6L1Z5UjVFVDRPaWtldHU1?=
 =?utf-8?B?cHNmYnR3NFdFc1N5akpnbHhLZVQxSWJ3bmhWSGFKdnpDbjdXdXp1ajNsQk5T?=
 =?utf-8?B?cnJMQitHb2hFeDB1NUxTWWlZaVNpU2F3OE9vTWRxWEQ0d0NGQzRnT0dxT0tY?=
 =?utf-8?B?WDRsN1JzUU5uUC83dDdQQzlPRmZnRERNQ0pkRjg1WjdhNXBTUWN1ZUlucmNH?=
 =?utf-8?B?a2lOZ1ZoWkRSWXB6SjF0Q2FKK2RoTDkxUkF6R2RqeXZFVGtlclpFWkl5Mk9Q?=
 =?utf-8?B?dzQwMFZaQmlkWWd0ZlBPY0tEam1keGh5MmNWcFFrdlNXVFZMTDVWQ2pNb0Qv?=
 =?utf-8?B?RmlZQzEvTkFXekd2ajVmWFdySGJZTGltRUJFQ20vWTZXYnBiWGJuOXFuQTVZ?=
 =?utf-8?B?YU40MnNPUFJTOVBYOWZ5MGJHMEtkeStUNnZTUnNtczFXZ0Z1M0ZKK0VtRHcx?=
 =?utf-8?B?TzYvTUt2UUxJaTMzQzU2S0hxR2Y0WXpGUVluZHNyOENNRFRNOVBzU1NLU2Y1?=
 =?utf-8?B?WFdvakhnQk5xdDQ2TjF0NlVXdEpUbFlnNERqaEVMQUFKSmpkQ21PR2kvTmg4?=
 =?utf-8?B?MFdwRkRrOG5TdDFqdngraHlNYmZUdHdQRGxMNlNBamdhZ3BQbGN3dHprUks1?=
 =?utf-8?B?cEEzRCtNUkx6Z2lIa0VQWnZ6TmdMUTcxT1JRdXJ3c1A4UGNKLzJKYk9qVmp2?=
 =?utf-8?B?QXl1Z3FCajBBdVRIaUJBalBRVjhQYm05eGZIdkF1TDVEazI3akFrNU9lUzBM?=
 =?utf-8?B?YTkxRThDQ0UvOFF5bE5GNXFSQlB6Y2QyaG43SlBQYSt2akxZVWVIaytPS3F5?=
 =?utf-8?Q?KI8AxnmyL7AqWIUdfQPl8/mFt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d61a08c-d1b7-4b94-7c92-08db8f028c9a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2023 00:35:31.6462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z5rRN6aOHvg6eWgITo7NV9cVQykz6zkRHLg1lxMsvLOxVJiXtU/bizBZJxTP3mV5+LzcjWly29t1WeOaFzsb1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7148
X-OriginatorOrg: intel.com



On 7/27/23 17:15, Ira Weiny wrote:
> Dave Jiang wrote:
>>
>>
>> On 7/27/23 14:21, Ira Weiny wrote:
>>> Previously CXL event testing was run by hand.  This reduces testing
>>> coverage including a lack of regression testing.
>>>
>>> Add a CXL test as part of the meson test infrastructure.  Passing is
>>> predicated on receiving the appropriate number of errors in each log.
>>> Individual event values are not checked.
>>>
>>> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
>>
>> LGTM. Have you tried running shellcheck?
> 
> Never heard of it...  searching...
> 
> This?
> 
> 	ShellCheck.x86_64 : Shell script analysis tool

I think so.

> 
>>
>> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> 
> Thanks,
> Ira
