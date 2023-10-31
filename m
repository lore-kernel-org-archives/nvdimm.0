Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8252030A
	for <nvdimm@lists.linux.dev>; Tue, 31 Oct 2023 16:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EKlGxU/h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698769453; x=1730305453;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lzzr9IPuKMyrsRqwcHhnwFyGKhKyIv1NQP7C18rMSBA=;
  b=EKlGxU/hx2eWb+q65tl3jAjCk98CgXoFTRKEdx9Env6T1jlNuV6x9bKw
   7ZflKNWAYydUus/r9cURHYzWUyO5faf4af+cg4foFjnwU/L+Nhdrxnd9M
   JlXelvi3N2G+VPZhNcmRUN2d4D+GxOO9Flk9XsRufzIXuGfyx/k+Ih+Ms
   er9i/qdPQJkeDQ1Ibd7D3VDfAI9L/oZIAzJLrMsxWKB7Qr5xZGakisFbk
   xO0APWrkOKXZlmsFNXOgmDaA8fUvMEm4qOIOLGskeRgUGDunVn5UlI0Wv
   dht9e9hiqwPaYjdjWoym95kr2hOI/1UY2xR0yDJZ4uZb0jgNYt6Cga3QA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="391193684"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="391193684"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 09:24:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="1092061209"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="1092061209"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2023 09:24:12 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 09:24:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 09:24:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 31 Oct 2023 09:24:11 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 31 Oct 2023 09:24:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFtO3ZRH2GPeO86wCIKPvcj0NFJrwK82ujbez5neQueRA5UJ+AJrG18NGX14guNbCFuotQwsSDsohQVv651QGcutaknbQdtWL90+tyaOQ7TLIFJdtkv+vUIXeuZYcjT9iTh1vVcxFYx7rzV+DsMTDdpxsn1UoOOyofXAEqkIgI1KCqpzprFrlDv39p+wgtWvaldiFe+pLXT9lnZPNKYZRDtloVSRExQu+X8bH7GVRjvg+WkiakxhX7nn+vLTLyk6SjDaVLp9w9SQCI7Xu6ktLVoW4r2wR1zKcuPiTELhFNMdUBfvY15TIRvcEUvOZgQkLmjsd2ymXrlsT1+G1c6pTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AoXBTOZbbNXIYBzF9iSI/OZfOjjTJQcrCnFkhF0MAFo=;
 b=nExyaZsffqoTfQ+OHslVvKe4p3Yxgx/zbFLZIcGYJXq4coNh1SKynPX+uxbmt2FThgtk7dUdctpdiI0R+JkVzLUTwrgRfZddIoQ5H6q6UwoFcVPHEGy4Py/dpp27ZWJb7xmJmu7Q2NbdsIXqwsKMBNZRowb0LQGL4lEdQHQ/nwIXVnMc2y18jtm1twDPnW6QmDFWc32+Hr1NKxcTgMNSG9k5CbTeRd70Nc2RlOvVpCoPve2J0rs6My4+7ZHX/DHaE6V2Dedk3DtagAuFubTc5oYI8da7wQ+xMx0wGFn3dBgabwrx+dWmp53O80++9Z6UnM8dxBqVOfOT5brNtEfwkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by DM4PR11MB6141.namprd11.prod.outlook.com (2603:10b6:8:b3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Tue, 31 Oct
 2023 16:24:09 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::28a6:ecda:4bb7:2f9e]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::28a6:ecda:4bb7:2f9e%6]) with mapi id 15.20.6933.029; Tue, 31 Oct 2023
 16:24:09 +0000
Message-ID: <2073bfeb-2e8a-44cc-8d52-45c10b9b852b@intel.com>
Date: Tue, 31 Oct 2023 09:24:06 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [ISSUE] `cxl disable-region region0` twice but got same output
To: =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo5YWo?= <caoqq@fujitsu.com>,
	<vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
References: <dc013f7b-2039-e2ed-01ad-705435d16862@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <dc013f7b-2039-e2ed-01ad-705435d16862@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0031.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::44) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|DM4PR11MB6141:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f147fdb-5284-4890-bdc0-08dbda2dcf1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bPHyEH6s0eTfcRu76xv7XuoGEBPMPbUm0sS8RqVu1CU7uD9M0aOkKOqlnJMglXK3mHNk9LUxO7cgBvSblv1ITa6erMo8JXbs4r6xo4NgE/C7RJParh09MPMF8w/57tmceCFMR4b1g2gOLsr/ajBfcfOl3qL5PQ+Y10N9nYiHuXOxyKgQJtf/4WruTmGAvwI19PodGLz+MZKRYiozuimU8w8IxMgHZFdWNN7H7fHYqs4ujml2roTHFIDHEZD7/Y44gVKO71kVLYyi7wJxZDR+X6R4mPG8Q7TCOxBMGbbOyTPU4pctTXNFpjocCFaCbxC/08O2ZEAMjcqZ+raWeWjqu1JVHCU8VAU4Sfq0y9foR2mwJirafGPzYAcCdCIEB22d7M6IzQOIYIg3XBtEAHoIdBzOk0p2ZBpMTviGN1BwH1KqCH+Ajyjj09gKFsJLCG1IYBG7uWvt3Ar6zIGm4XkZBQUJfPxA6jr58fQV5AVrhQIiIKKTLoDW7J6Vh3SVqD7849/fhTxUqsA3Mehl0iXcVhtbKx2tvc+0dBjW0c3HiaefzaJ4jO9AFoDlXCHkPi+uI55FK31hQUrkTKYN99EDZqvcUJh8i3LJvDyJ5Nzpug6lNLNHYNz2N5pdYXUC/Fx9WV+Z2AOjhnMOU8xQTzkWSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(346002)(376002)(366004)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(83380400001)(41300700001)(5660300002)(66946007)(2906002)(36756003)(31686004)(31696002)(2616005)(26005)(86362001)(82960400001)(38100700002)(6512007)(6666004)(6506007)(53546011)(6486002)(478600001)(316002)(6636002)(66556008)(66476007)(44832011)(8936002)(8676002)(4326008)(81973001)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWI3L05qUXZ1NWprY24rcS93dEVPYlhnY1FMM256aFhPSGprT2huTXN0NnFp?=
 =?utf-8?B?NlNWYzFEelY2aEgyZ3JTekIvNWttZ09DNEhUSEt3N041OXQ5ekk3YS85Z3BJ?=
 =?utf-8?B?ZTAxejZkSkYxbDZIaHlUdlFXS0tSd3k1cjFHa1Q1cEMyTm52NDQvYmpJeHVN?=
 =?utf-8?B?dFhCNW5LQ0Z1bVpSVC9aTDRLNmx0ck9VZWJoRzkxa0ZiWFFodnU0azladFhK?=
 =?utf-8?B?UWxSYUJJeEZhbkVwY29ZVGdiRlljWS9xbzBVZVA1dDZVemRwbnNkTmJMNklQ?=
 =?utf-8?B?blNRemFwZU9rSGtRdC9DYzhYVFpZSXFCYXBmcVdBeENScFpvVFhzVDBkZTVR?=
 =?utf-8?B?QW1tUmxXWS9oVEtINHl0TnhTVFFKQW9rSmEyWU5SWUw3ZVlVM2JTK1Boc0xX?=
 =?utf-8?B?TTg1eHVpRC93c1k4Z2pISXEwVHlUSDFCVFZXNFVETW5VYit4UGRjUkFGREdF?=
 =?utf-8?B?YjZvbWh6ejhaN0xlbFNici9xQVY2ZWF3NFhtNENGNzdjTVBvUy9mdStTN2J3?=
 =?utf-8?B?L0w3WTR1KzJZL09aNzIzdnR1ajl3UTJ2QlA0ejBKanNDQXJHcWkycEZJbS9z?=
 =?utf-8?B?TkdwYWh1UnRoZ1NJMno5bnAvTFBqa3hkcUVBeEthTFE4MVduM0E3TTRVY05v?=
 =?utf-8?B?c0Q1NnJwMncyOE5DSEtGVGZHbEJzeWJpOWNqTEhCY2RWUTF6QzFZM3BZRW1K?=
 =?utf-8?B?SnQvRVJoYnc2dm1DOC9JcXJFeUplcmJUZWYvbmw4cmgySWNsaFpjR0phdUFV?=
 =?utf-8?B?M250ZURaQ1ZSb1BDS1NIUEk0cTQxQkV2Q0cxNjNZSGgrdzRwWk1DMnJ6K0U0?=
 =?utf-8?B?ZzFlUDNRMUorWFpleHBxTy96UkhhY2ZiaXZaTGsxTDdBOTFCUzNNeHJiQTJx?=
 =?utf-8?B?UkRjV2NRRlhYUnc5Q09yZm9xMDA1SnNOTzM0dTFYdVpOOGlQbjllSUhVN2x1?=
 =?utf-8?B?ckl1N1FrY1JYNDQzUUpMTUYyRzBFMytmbUpLanp3OStVSHhSVWkvdDkydEpN?=
 =?utf-8?B?c0VHSjhPampKeTdRTmIzZTdGMDRrKzRaS2trUUFGbEVTUzdKUzJqenFiZnov?=
 =?utf-8?B?RXFJWm4zOU1rL0ptWWs0SGZMWDQxNE43cjdTSVpWaGRVaHJEczdpakpEN05q?=
 =?utf-8?B?QmVhU2VYRndFb0ZqUjdHMmVjenNaQ3A5SFZoeFdFcHd4eDZ3OXl3eitZTm5z?=
 =?utf-8?B?ZGphSUxMT1pma1BqZGdyUHJXVjBXUGdFSGswWjdqMVZBMXpwdWZsQ1BWZGVh?=
 =?utf-8?B?WWVTTlhmbHV1Qm9GWGkyZWxnU05mUW1oWWJJYnVaTEZTdHNwYjRKa25GSjRh?=
 =?utf-8?B?anZRNE1nOEoxYWYvb2NONzVzQWROOHNkaUlEWkR4TDh6ZGl2YytKOVNYTTFN?=
 =?utf-8?B?RnJ1WHFDNEtyRUZtQXVtcURJdUJBNFRkTG9zYkQyZHNuWlZ2aXlBRGI2YjFj?=
 =?utf-8?B?WlJ5NWN2ZDVnbjh0cDdTNzBXTG5HeC9lWUJiV0RnWWRVS1VDYlBqaHI1Y0ta?=
 =?utf-8?B?eXhNcFZZd1g3c0FFY01sMldUdFhIWE5YOFdaZWJDRjhuczA3UmxiUWlNM1Jv?=
 =?utf-8?B?cnRKY2RBeXJYaXhINERmZ3ZaV3dmcEE4UlliOHdUZkoxWURiS2N1MFZPbUJk?=
 =?utf-8?B?N09mWjRtZFBzdGo0SDQxakQ0d1cxYVo3MmRNQnRSV1pOSnVsb3Y1TW9HTHVZ?=
 =?utf-8?B?VE5XREdjRkRQb3ZERUg4Y3Fqc0xzVkQ5eXNKa2lWY3BYdmx4dUN6WEl1dDZq?=
 =?utf-8?B?WUtvS3QrUDhGVkJiSlZQM201N2NvaDNUY0tSR0tzeHpGdnhaaCt1NExXd1lL?=
 =?utf-8?B?VG92c2RGdVZHV0xCOHNvL282dFpPdW03bHVrVG43UGE1eWRhN2VzMVA1S2E2?=
 =?utf-8?B?MEtlaTdNcXNXVjFHeC9aSWRnTzVBdjQ5blRTN21QbmRSV3BxdkFER0p4Y2JP?=
 =?utf-8?B?Q3R2K3N6Rnc3cnBlM09nVGM0VnFWR29DS3BocElScmFxS3VjK0VqZFF0Nlpo?=
 =?utf-8?B?Ukl5YUNkOU1ZZTRGWVMrdmQxYytOTmxVTmN2RlgyOEJqcUMvakV4Zk5HK1ZQ?=
 =?utf-8?B?cCswYXVaWjU0VUZHMUJZNVhESUhmM0hyaW9WRktiaHFnNzZpelFxVGhpdm9m?=
 =?utf-8?Q?C4Oiq89sUtTnHCdeHZbxX84TU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f147fdb-5284-4890-bdc0-08dbda2dcf1b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 16:24:08.8939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z7DIkpqpQf8XpJe5UB5Gk1v2+6qPVCNLEd3/TGrLvEEj/Q5+HD5f4cBbh104mZZzSLz7JirOh1C59xQRag5D4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6141
X-OriginatorOrg: intel.com



On 10/29/23 23:41, Cao, Quanquan/曹 全全 wrote:
> Dear Linux Community Members,
> 
> I am writing to seek assistance with a issue that I have encountered while testing [Repeat executing the "cxl disable-region region0" command]. I have provided a detailed description of the problem along with relevant test for reference. I would greatly appreciate it if you could spare some time to help me resolve this issue.

Hi Quanquan,
I've reproduced the issue. I'll take a look.

> 
> Problem Description:
> 
> After investigation, it was found that when disabling the region and attempting to disable the same region again, the message "cxl region: cmd_disable_region: disabled 1 region" is still returned.
> I consider this to be unreasonable.
> 
> 
> Test Example:
> 
> [root@fedora-37-client memory]# cxl list
> [
>   {
>     "memdevs":[
>       {
>         "memdev":"mem0",
>         "ram_size":1073741824,
>         "serial":0,
>         "host":"0000:0d:00.0"
>       }
>     ]
>   },
>   {
>     "regions":[
>       {
>         "region":"region0",
>         "resource":27111981056,
>         "size":1073741824,
>         "type":"ram",
>         "interleave_ways":1,
>         "interleave_granularity":256,
>         "decode_state":"commit"
>       }
>     ]
>   }
> ]
> 
> [root@fedora-37-client ~]# cxl disable-region region0
> cxl region: cmd_disable_region: disabled 1 region
> [root@fedora-37-client ~]# cxl disable-region region0
> cxl region: cmd_disable_region: disabled 1 region
> 
> expectation:cmd_disable_region: disabled 0 region
> 
> 
> Thank you very much for taking the time to review my issue. I am grateful for your assistance and look forward to your response.
> 
> Best regards,
> Quanquan Cao
> caoqq@fujitsu.com
