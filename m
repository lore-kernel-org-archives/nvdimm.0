Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC913454F
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 17:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R9p9BmiF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701104422; x=1732640422;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+KRvK2C0Jpa/5XzwUPCqhMclBVg8KAOnxc8/07h0SWE=;
  b=R9p9BmiFv/ZJ1sTH3wGG6zGb5u5eDIhYKUc57BM1Vgf0dIEAplujEcJk
   moPzq0TDF1J3Z2DSkKMx9gLYq2/uKQNXEwQEX1JhvBeYSjzpb6x5DV9Qg
   I93Zye37VCKkUCNvb4aUZyFQTVd3wT7iX3fzvMPcl/MSfJHMRhO4FJfwA
   sqCajwKp1OY6tvD8Wam+AGYX3epyct6wiJvq5fFbBxelib2AbXQvAQgCB
   WWQ1DWIkV9ZY5gcgm3bLL8CAiYdqC3ZRxjHjsnxN4Zk7GPJeS4bWCFJbX
   yVkF9iUgbkN//fjvc9vSvbDvOawnyx2VzgU7LqOLBX1ZMi1gEh0fWHbFb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="391623049"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="391623049"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 09:00:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="761655347"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="761655347"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 09:00:20 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 09:00:19 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 09:00:19 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 09:00:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMCmb8xQj0NJrnMz5CuUoqMYk7/CCbD71u2LTtjOzetwCTCQjrAQvt5EzgtQHlqmn2HpMG2EPJOnRM+BYW7TYclamZLYczkmaMYt0jCPMhcfx8ugYa9AAOARB6LWupxXgWUDNcrpOzJ98zQ9kliD4z4J83ioOauceADM3yR6BaFlZe/1XjsMwNGZhvrmZMCNM637aRNn6BrVbPabjRVINYtGaqdm5FWNH6PqEdpbG+q6mYY4NPo6fgWmJqdGQoeEPB0llbWbGbj+f+J3wbJIR/noK6J2L2YdwoqygznnKqE5IC4kWrnP7dXu6Fw4eRVJY6Ph/ZnBTq3X3nI3QO4ZNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbJ9tlYaeIb1j8efLCjsvWyytjewGHSeXu/1I3VNT9Y=;
 b=jTO6oB2qwcy8NjoyaMrHkXEihDVZX02Q/BmunINrh++AvtrFLSs9GxUUi5lEga07g1YcFnT82m32x7JPV1tmt+oEE4/E7gas/HvLBAQA8jk2/hPpxcfqW5y9uhDFntZUVgcQwsNlbBBUkHIp8dPKmrgr5AQNZViJqDn03PxXgI/Z+XaQyRc64fsgI4znZxJuBIO/eVlLF7hUX7z0Z4PKQZuShLhOZowpdXZWjhE2YDONX0JXvV9GGahXnqJYbF5OUPwdjqJVc1OXehg4ivm7FHKyw96iCGa4JA24/E+gfT9GjfF/kH95DAIAhVr8c97KKbzWxWnEuMvfks4553bsZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by MW6PR11MB8339.namprd11.prod.outlook.com (2603:10b6:303:24b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Mon, 27 Nov
 2023 17:00:17 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1%4]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 17:00:17 +0000
Message-ID: <8d6fd371-e664-47ab-b8fe-c7d8d0137b4a@intel.com>
Date: Mon, 27 Nov 2023 10:00:14 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH] ndtest: fix typo class_regster -> class_register
To: Yi Zhang <yi.zhang@redhat.com>, <nvdimm@lists.linux.dev>
CC: <gregkh@linuxfoundation.org>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>
References: <20231127040026.362729-1-yi.zhang@redhat.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20231127040026.362729-1-yi.zhang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0054.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::29) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|MW6PR11MB8339:EE_
X-MS-Office365-Filtering-Correlation-Id: a421e9ae-76a1-4dad-b467-08dbef6a54b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wypapbCiidDe3qxZ20nHQFmuYgrlhbRW7tiCF5p1M5ajiubR2EP/j7LeKg+QvI7l7VmMzPIgf2N4BARckcmj6abYvvVW1ML0sx3XGAVwXrSi5N5Ga/K28GTkO7YuZn9YEYTE2FVerFcHIHW0CMf8r3fpkZPj3x3BoEYIbah/+GHTxDid/S0F5yQDZidw66OBXYYb6ZI7RWt7lqu0eaw6ZIIS1I38FSGPN7y+r4aph7AEXn78t31i8dgi6hEx89bGPm1fd1YRz7Na1iMLSjd/57qCGtLAPMjDpLTYsj3s8Fi0NVg0wxKNCvGURXQclM//5S7841CKCPR6VHspFcUUtwxSq5ycfuAGHmZncgj6PCr6lQvfl6WkfMFzXl8ZqUvfl2Th94HiTkUpP7anp+ZPyexEi2buNNelu+b+fFGQYl3Q1WW/0kXOOt16OUb+iZbhOcKL5sV7XA6pAo1l9YAnciVhSusFs37MAGoZhM5Sz2mfg9F6iFx4Xd0abBkBPYOEdH1gic1I7mDRz6iOwv4aHjnKqdrKBln6fF4or30tj/bfrWVYgdil7lH8a5BGtKSap5gBFTxNJO137gay096w6u4COdID3RAesjQ+tXRvpy7Ig+IGkzDV1J8/v1EuRrC6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(396003)(346002)(39860400002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(83380400001)(38100700002)(31686004)(4326008)(8936002)(8676002)(82960400001)(53546011)(6512007)(6506007)(6666004)(66946007)(316002)(66556008)(66476007)(86362001)(44832011)(31696002)(6486002)(5660300002)(478600001)(4744005)(41300700001)(36756003)(2906002)(107886003)(26005)(2616005)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djJlKzJVYjhZTmZsSGhpVTZNVVVscy9SRDYwUXRqTXJxeXBxajdwUzlyNW9L?=
 =?utf-8?B?bTRDWVhPVlRQbGhxVlcxelBxWm5rRXNRaFNrcGxLZmFKdjVvUjJFUllYdUpH?=
 =?utf-8?B?M3dzRVh3blpDK2REcCs0N2JOWXQ0eDA5SXNiZXVmOVF6em11cllOdUsrcy9u?=
 =?utf-8?B?MGdjZkJKL0Q4N29zZFNWWHcrS3EzUEhiZzVOWE04S01yNUNoZk5qK1lZMVdm?=
 =?utf-8?B?Rm9NaHJqT2NKZTlJbENraUJBR3VYQlQyajVNelpSM0QzNXZTdmEyaEt5ckJQ?=
 =?utf-8?B?Vzl2TnNRMGFibWlibnlud3hlaElrTCt1TXdSWERyaVl6YndGNVpiRUNPUjFj?=
 =?utf-8?B?Q0twZHM2VzRCNHVBbFFQcXd6YmEwQlJXZzlUTXJqeHJqdjlsTWxiRmJCTGVa?=
 =?utf-8?B?YzgwalNpYkJIYmZ1MXoycUdjeTl0b0xYbndKQlNZVkExaUc2M0pBb29oV2lL?=
 =?utf-8?B?NjhkZTY0SXJab2JNcWt0VFV0NjN5dGhwY2lPcExjWnRlakZ5RDZTb0ZUa0gz?=
 =?utf-8?B?MkR1UlU2TkJxSUszYVJLOXExcU1Ea2gxaGJveTUvTG9yaFlIMGJJclNtOGRa?=
 =?utf-8?B?TU04OXRMMnRISzlzdUZMRXBOejdQUUNaWklaTTVndGdWU1daSk5ZL0pxYlJq?=
 =?utf-8?B?dTVoS1RjUlZQWnVEMm1ENEMrTHlkeFRZVHYwdDdNZW1xdHdYTVdVUmtwYk42?=
 =?utf-8?B?VS92bXNUL2ZoNHdoSi90UlhObTd6cldhWjJJck55UFo1QzAwS3hkVSsvRFdM?=
 =?utf-8?B?TG1Nc3c2ODRRZzdyNHRWdFluL2dwSCt0RGhDWlVRRmRpLy9uQisrVmllbjNW?=
 =?utf-8?B?NThXaEZ4SHN3Y0JmM1B5dDhnYWt1eWRmQmlsV01rbmtFcE1jVk1RVjdhRmxU?=
 =?utf-8?B?T3RYWUtvZUdOY3FmMW9SL1dVYU9FVmJTbnE1SExhR3ZTL2dSR0d5VTdMVkFJ?=
 =?utf-8?B?dm8wZUFTeEU2T2QxMENjYU1EemdjZVV6UVdRUG80UktoVy9iVW45WFBZNE53?=
 =?utf-8?B?VzlHV1MwSVQrSzkyT1lOT1owYTcxNXVaK1FhaDIyL1VxbE00bzVrNFB0ZllF?=
 =?utf-8?B?cko5bGxVMG9uMDNEMDF2bVJVUWt6NExLUVdnc3Z0OTN1bXhOcWNZU2x6RURJ?=
 =?utf-8?B?MTdzS1J0TllCaS9pWTUvckNCN2RXSE45N255OTd5WVRQM3FLWFpRcXlyT053?=
 =?utf-8?B?c09mcW95VTFZR2hqSXdNWm80T0doSW5RZkZ6ZFJkY3JxVWc5emlPS05yUTBD?=
 =?utf-8?B?c0R0Ykg2NUVkdTd3OUFMVWJDbXZlcDhSZGJmL2VmUkV3aWYydXZ5VElVY3BT?=
 =?utf-8?B?UlJFWlVwYjgya0FGeE1OWmE4VDl0UlBXR1VoTnF2WEJob0dxVkZ2NXJLMGhw?=
 =?utf-8?B?ekVwWkpZa1hzY21QakhTK29wNFNCeVBoelMxSjlROUNnT0cxdkZhSCtBb1RC?=
 =?utf-8?B?WjY3a0RTVmVReWFNUWpzM0pZdFZhR3EwSzBmdzhUMHVTaTVPVndYdDZRNEhB?=
 =?utf-8?B?Q1EwdTdobjM1MFRuanFMQWZQOWRUN1NyOHR6cUtoaTZubnFNUUxaSzByNFFH?=
 =?utf-8?B?QS8wSTgvVm1NNjJPaDBzQU56NkNUQkdtbC84cXVqb254VVNQc09RdkxHNjlq?=
 =?utf-8?B?bWM0Nys3dnlSRXExS0NjOEl1K3Zoc01DT1pXZUF2THlRcTdaMHZTeVRYSXdh?=
 =?utf-8?B?SGFCdkJtTEZzRFZDMk9YSE9nRVVFTnNOYWphRllLWG5aOEJJeFdKOElkaVB0?=
 =?utf-8?B?YWRQM2pZaUJwNHAzVThhUFQxKzRZUDJTdnlmeTNENCs1cnZ1R0oxSzNML0Ji?=
 =?utf-8?B?aGhjZTBHcEN1SHNpTzltMFFhbGdrVUc5a0E5QkVBZWhZTmVubFNqcXhCK2tx?=
 =?utf-8?B?MFRiZ3BPUzZ0SFhETEdFZHFiZmE4cllSYy9uRUhOMjJ6blUybklqNWtnOFRS?=
 =?utf-8?B?OEQyNXQwVHJ1c3pueHZFZFk3eEZyVWlkdkVsc3J3cytpUWROdU5adjU4eGNl?=
 =?utf-8?B?Mlg0T013ZkRnWXZKaDB6eWtNR0tJaGtUQVdxUmh4VVFvVy9uMUh2NEpZMXFN?=
 =?utf-8?B?bGZYVG42SUFZakRlRENWbEQ3WnRybmtTQzl4QjdnL1pLUzhnb3NRM0VmeGZY?=
 =?utf-8?Q?XA/oUozLoRHZVEVqkaecYUwFY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a421e9ae-76a1-4dad-b467-08dbef6a54b1
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 17:00:17.1642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A6QTiC+vUuaKbmFKSI+atbCsISgrYHELnUUVR9MY+UK/H/7mj/iw0B039DoJXvzdD1Wex1A10ZG3IPI0dtlGJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8339
X-OriginatorOrg: intel.com



On 11/26/23 21:00, Yi Zhang wrote:
> Fixes: dd6cad2dcb58 ("testing: nvdimm: make struct class structures constant")
> Signed-off-by: Yi Zhang <yi.zhang@redhat.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  tools/testing/nvdimm/test/ndtest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> index fd26189d53be..b8419f460368 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -924,7 +924,7 @@ static __init int ndtest_init(void)
>  
>  	nfit_test_setup(ndtest_resource_lookup, NULL);
>  
> -	rc = class_regster(&ndtest_dimm_class);
> +	rc = class_register(&ndtest_dimm_class);
>  	if (rc)
>  		goto err_register;
>  
