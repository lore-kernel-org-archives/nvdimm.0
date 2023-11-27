Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446BE34558
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 17:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lphN7TDb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701105234; x=1732641234;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XWVSKxZi77nUhuJecDgBuy/zZ4Dw87noa7n/D+hGpMg=;
  b=lphN7TDbpUn31BoWPV+8YGaYG+LUNm8hjdVk5oYtdq7hzAbp9L54xqVT
   kCpvRRsLEayk3ISp/5VCQeNx09Y7r6PuBrRUOnlBWfo0lucGWGHNfcziw
   kToi6nVnLxFTAlgRotGi63pM+TN9YLa3L5z1gccu6N9r2HsmwOqeO79Ov
   AWN40DSR+oDewSgdfdKmTdYpG8zmeWbhFGCJQeeal/OeSWr2HV3j6mN1K
   x+bx4vsvawEf+H/HbRWZKPcZrIX6suXbI7ImBfAr/ld0kT9izhbrkKiu5
   vPppO4yWORHCtWy1l42eG4EQfY33Eyjc0yY+h8Di0+lbbBy8JZd8nfBnO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="11443717"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="11443717"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 09:13:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="16351673"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 09:13:53 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 09:13:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 09:13:51 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 09:13:51 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 09:13:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wwr0wska5p9D2fsnJQPzac2lgabvOrf6K0YX1bTUnwfoh2eT9LkLbx0GJpAlHELEC5+dZipVCAIgn2givEQ/vQXv7T8dfb6Hrs5rVMyOjOH4dUs0XvGPwfJQrBljVDuD6XhMofx7ckuKdLzTxF6BhatFvhY4K3QB1vfQjNQZcogBNaHMBqIE/kh4Tit40bPwe91tcluLObBjR3iff9cx0su82Ix8nBkPwhvAj28E7cnBA2HhvlO2wrVM4Kcr8Wge52u+n52cW/rxT/M2mwdsVd0+OvxManTcO0QrL0C1PaQ0cyMOHddqjQzAcxdz9ziW115Y8zZvAjTthj7JBRyWLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Kxc0uG9CuUZJ1MuvzR9CvfFuD/7CBGi4S9YZEoc4U0=;
 b=f2Ff5pfcNd3XWoN/osfM2PZaDz4zbxt1f9UWmerwpJ4nKE1iCJBKzODF5ABziuAVtTm/VhsrweiLcKl/JvfRpkx1dOHx9qM24wXTOHy40jaG+dHJtYUKf9Tt6eIoK4G3LuFwPaJ6q8tLK2F2+5X5SasGkIODi3N1gUlC2OYhLhM8RjUaV4uC0DU4JRagJPI+7JqxTtc7S5DYYmVftcaOE2t9049/4NX0QOKAdOC2Qnsn7VFMzsv2xUrVkUVw7T8pKB1wWw918yRj2FGTS/hO+U67mW7P6dSQ0diJODCimccBwC/wbar6CTTMYWlI3iehpxPTRZIc2taXMbZcqUoahA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by LV3PR11MB8579.namprd11.prod.outlook.com (2603:10b6:408:1b6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.28; Mon, 27 Nov
 2023 17:13:49 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1%4]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 17:13:49 +0000
Message-ID: <1c5f9602-7226-42f9-937c-671947ccdb73@intel.com>
Date: Mon, 27 Nov 2023 10:13:46 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [NDCTL PATCH v3] cxl/region: Add -f option for disable-region
To: =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo5YWo?= <caoqq@fujitsu.com>,
	<vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <yangx.jy@fujitsu.com>
References: <169878724592.82931.11180459815481606425.stgit@djiang5-mobl3>
 <4910174f-4cda-a664-62ee-a6b37f96efac@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <4910174f-4cda-a664-62ee-a6b37f96efac@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0237.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::32) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|LV3PR11MB8579:EE_
X-MS-Office365-Filtering-Correlation-Id: e6e2011a-8bc1-471b-465e-08dbef6c3906
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qMlGbPUrL/ip9erx9C33zoLlh838zOHRRO0EzMpnowEwiPJOARo42wQ7EYijZv+1T1N6tbDxDl9V5+oajQ6rZFo5CMMV1wLt8LZQ7CuJuluF5IXTIH1RZiQbS9spc1BaR05DP/ur9KKLRDpTXm0D11MVigppWoEZZDHWH00PZI9SuLoEMjwbtideTlPUdxson/p1wJpDJ4guIKKe/UJUxjgA72e0nP1NIWroq/DoPcVte3HU5bPQVk5LS+md8sEs4ghlXu4oKjBfwPm91i4kTk5XHHv+aq1bLO85BCk8wKPcDxjJ4PAD84Ahg1yQdMwBXe/XCT1nOj1dDwVKQJU5u3IOyT2bR0N/dW2UzIBFCoTc/sBJ2GJttrqPY7+DLDbSUA3kPEtb20KoPJZ5I5i66hbl9J7xsEPpOw5Vm0kkCv2Cvs5J5QX4RoyF41nENz0yP7Y4h+EwO81eLbIekAqS7o7+lTE4HoPAVhunCXRQKS2PG5D/9SiaUo/qyEoSfcaGip6xfZJVZBElxQ8Mkmxjg/Skb3XDkhyXeg12xKvbwsjwHMiJxokArx2DavX+005jlMVwT+BZ32KgCVTjXqEgVe/DqOeSOi81t/Vg2iAfG8rOoHx3BvTXbgj1uXwS/m1v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(376002)(39860400002)(136003)(366004)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(2616005)(26005)(6506007)(6666004)(6512007)(8676002)(82960400001)(31696002)(8936002)(4326008)(44832011)(86362001)(5660300002)(6486002)(478600001)(316002)(6636002)(66476007)(66556008)(66946007)(53546011)(38100700002)(83380400001)(31686004)(41300700001)(2906002)(36756003)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWFOMStIVWRmN1JhQTh3dGdtckRBbnlqVHY1dHFheGtHVElGV1hMYlBIRHBz?=
 =?utf-8?B?RkFJTGJnUFlTUXo3Vnc3Njk4bzdBMklqRVk3b1JTRE9oYUh3ZkRyQk9aUWxn?=
 =?utf-8?B?VXY4NTVtUGZmN2FXd0VKY1hTSnNucEZsbHQvNDBFT3V4TFV3RmFEOEMzc0Ja?=
 =?utf-8?B?NTZ6bGloak5sQjBGaFhMaGRBS0t0UEVVbkk3R0xEZEtMYzJuemdGS2Y1TlpH?=
 =?utf-8?B?VWpDN0lwb3kvNnBTMnJSazN0MXlRZlJwUVhRVzFkVDJ6VFE3Rlg2Y09BLysy?=
 =?utf-8?B?NUJ2UlIrM0w2NXVvNGhpeGZjNldPdDFVdlJJdk1yMlJTZkdidzlYRW5VZXFi?=
 =?utf-8?B?cGRLbzF1UVQ2eEpqYTZLMWVtYmZURTdDNGs2ZHhXUXFiWUJOS1ljdmpGODZZ?=
 =?utf-8?B?OGVVbWZsNEJkRTArMDBKalN4UkVQQlFOTFB3YmJyQXJVSXM5YlZEdUIrU0xZ?=
 =?utf-8?B?UHFrVGdYdFJVZ1RWOExUc0NyUHpCY0hlOEZSU1RtZnpIZ2phVWYyM0hiSThx?=
 =?utf-8?B?YVZ3SnVlMDEyRHI3SThvcUxMWWhDNWFmSHJ4NnEzTVM3UHV0NWVHODBzT2kx?=
 =?utf-8?B?REp6dHlBMXF2MHZqQ3d4ck5wRUhET3F3VC9xQ2tkaFFYdmdCZ2J4anJic2lt?=
 =?utf-8?B?UUtZOWRuaGhwVDN2TmFNTkZtcnRERzNGSS84RFo3UHlyK0RNZDBRVll2VW1I?=
 =?utf-8?B?cHUyaW8xaU1QWm4vL2gxdW8xSC9BMlV3MGQvUlVHbWNQQmtZVVRrWTROWm9Z?=
 =?utf-8?B?cEhaR2ZwYzJWak5NcDJEcTQxSENPdXpLb01Ga2tyL3JyeFVSTG5rNUpWMEhK?=
 =?utf-8?B?NXNQU2xjZ1hvV1BtT25ONDhvQUZoTWplWi93VVZSa3dHMEwwdVAvN1RHOHNl?=
 =?utf-8?B?RWVOUEIvWHlVMzBHTTNTNU01eTJkcDBZYmc2T2JCRFgxT2RzM3BTUFZDWHQ3?=
 =?utf-8?B?R1Evcll2VWtYRWJqYVJRNmxhRllKTUUzbUpnM1RmTURqY3pmc3RVMzR0UDA1?=
 =?utf-8?B?VXlHUDdITUxtSmVsT2Z5Z1dtU0orS3VwcnUwYWZ6QjNFUkFIRHNzSUs5WHJa?=
 =?utf-8?B?MlB4MGU0dkpuRnZGSEhIRTV3WDNxYys0L3NIT21udGkxcGFxOXR5MWNkU2p0?=
 =?utf-8?B?MXJrYitEQVRhWXZ3ZEdKamZjVmNFeXM0M3hnZkhISXZmSkVBaWkxN3BxTHVN?=
 =?utf-8?B?YnFTcjlUWnFPMU9FaG95RWQzOVQzZ3ZISXVLenhpcGk5NmdheXE4d29sRE5F?=
 =?utf-8?B?MXkvWXh0SWN6S3UrcDFZRlAxSTBJK2oxQTExaWRXc3BkY2FORzRYS1RhZVBK?=
 =?utf-8?B?cVRzckc3ZVE0MWp4MWJTTDVlN1FBb3hJNkJZR05vYVphQWMzclg4TEFCck8w?=
 =?utf-8?B?V25HYUhqanFUMnFjbE9pcHJLVEp3WURuZ2NWcWRiZVdqMW0vN2QwQUNlckgz?=
 =?utf-8?B?NW15cnBscENCbCtYYTEwb3ZiQTZXcmxhN3h0bTF6VXpsVHBwd0Njak9pT3ZP?=
 =?utf-8?B?SlhEUGplVG9kQUtSckU5Wnd0cmViNHdzRk05ZTk0bzhrODN1WlMwaGxncUlB?=
 =?utf-8?B?L1RqRmxlWkFoTUxBdE5xVkNQUlZZVXZzWFg4UllzaXBCTHEyc2JjbUdTclpt?=
 =?utf-8?B?ODRwRnBNZGVhREpLcTcwOGtxbkI4YnhOZG5BSjNTY2J0SWE3Z1VXU1hXMWVw?=
 =?utf-8?B?UWhDKzV4NjZJTWExeVJLOUk4cUFJeit3UzBFdjVxU2JITDlrZ0Y5Uld5d2Ez?=
 =?utf-8?B?Mmp3MjNPSzJWS2xWMDMrYmxXUHpFaWFwblU5dmhWeWtVdUhsSVN1MzYzc2JV?=
 =?utf-8?B?dS81OTQ2Z0dIZW5HanFQcldlNTRocmpRL0tyQkQ1cktDVy9wOGJXZTNkT09X?=
 =?utf-8?B?VkxrekJUNnBRQ1VSMzRjeFRUQUVJVm54WjRYaC8ySDF4cW9JL0pQcXhLb0Vr?=
 =?utf-8?B?OExidjFjeXNOVTdxSVFqTXViUWFFenlwVldDZ2VDaGVZNERWdTZUVnVXUlI0?=
 =?utf-8?B?UWFJNlB4MFFxZVB6YTNsMWVXTlFhbEdsL1JwNDlHR0ZScTBqMjNYVHVXL01Y?=
 =?utf-8?B?ZWVEZnBGUThzaTFsalB6dzRWa0ZnWmNQYmNlMVVQbk50Q1BqKytQc3J0cVhL?=
 =?utf-8?Q?DbzY6dDQ3WstmyqfQ/qAeU+HB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e2011a-8bc1-471b-465e-08dbef6c3906
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 17:13:49.7259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YwoulrmK2S5cZ7OTukPMLAyLva2c8qiTcAyXXe4IUORY7JqpMvMwQq2unLJguMBxN+80s+YeuArtdaVgznA+Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8579
X-OriginatorOrg: intel.com



On 11/27/23 02:34, Cao, Quanquan/曹 全全 wrote:
> 
> 
>> +static int disable_region(struct cxl_region *region)
>> +{
>> +    const char *devname = cxl_region_get_devname(region);
>> +    struct daxctl_region *dax_region;
>> +    struct daxctl_memory *mem;
>> +    struct daxctl_dev *dev;
>> +    int failed = 0, rc;
>> +
>> +    dax_region = cxl_region_get_daxctl_region(region);
>> +    if (!dax_region)
>> +        goto out;
>> +
>> +    daxctl_dev_foreach(dax_region, dev) {
>> +        mem = daxctl_dev_get_memory(dev);
>> +        if (!mem)
>> +            return -ENXIO;
>> +
>> +        /*
>> +         * If memory is still online and user wants to force it, attempt
>> +         * to offline it.
>> +         */
>> +        if (daxctl_memory_is_online(mem)) {
>> +            rc = daxctl_memory_offline(mem);
>> +            if (rc < 0) {
>> +                log_err(&rl, "%s: unable to offline %s: %s\n",
>> +                    devname,
>> +                    daxctl_dev_get_devname(dev),
>> +                    strerror(abs(rc)));
>> +                if (!param.force)
>> +                    return rc;
>> +
>> +                failed++;
>> +            }
>> +        }
>> +    }
>> +
>> +    if (failed) {
>> +        log_err(&rl, "%s: Forcing region disable without successful offline.\n",
>> +            devname);
>> +        log_err(&rl, "%s: Physical address space has now been permanently leaked.\n",
>> +            devname);
>> +        log_err(&rl, "%s: Leaked address cannot be recovered until a reboot.\n",
>> +            devname);
>> +    }
>> +
> 
>>   static int do_region_xable(struct cxl_region *region, enum region_actions action)
>>   {
>>       switch (action) {
>>       case ACTION_ENABLE:
>>           return cxl_region_enable(region);
>>       case ACTION_DISABLE:
>> -        return cxl_region_disable(region);
>> +        return disable_region(region);
>>       case ACTION_DESTROY:
>>           return destroy_region(region);
>>       default:
> 
> Hi Dave
> 
> In this patch, a new function 'disable_region(region)' has been added. When using the 'cxl destroy-region region0 -f' command, there's a check first, followed by the 'destroy-region' operation. In terms of user-friendliness, which function is more user-friendly: 'cxl_region_disable(region)' or 'disable_region(region)'?
> 
> Attach destroy_region section code
> static int destroy_region(struct cxl_region *region)
> {
>     const char *devname = cxl_region_get_devname(region);
>     unsigned int ways, i;
>     int rc;
> 
>     /* First, unbind/disable the region if needed */
>     if (cxl_region_is_enabled(region)) {
>         if (param.force) {
>             rc = cxl_region_disable(region);
>             if (rc) {
>                 log_err(&rl, "%s: error disabling region: %s\n",
>                     devname, strerror(-rc));
>                 return rc;
>             }
>         } else {
>             log_err(&rl, "%s active. Disable it or use --force\n",
>                 devname);
>             return -EBUSY;
>         }
>     }
> 
> I have considered two options for your reference:
> 
> 1.Assuming the user hasn't executed the 'cxl disable-region region0' command and directly runs 'cxl destroy-region region0 -f', using the 'disable_region(region)' function to first take the region offline and then disable it might be more user-friendly.
> 2.If the user executes the 'cxl disable-region region0' command but fails to take it offline successfully, then runs 'cxl destroy-region region0 -f', using the 'cxl_region_disable(region)' function to directly 'disable region' and then 'destroy region' would also be reasonable.

To make the behavior consistent, I think we should use disable_region() with the check for the destroy_region() path.

What do you think Vishal?
> 
> 
> 
> 
> 
