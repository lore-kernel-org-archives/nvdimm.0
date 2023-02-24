Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A77F7C
	for <nvdimm@lists.linux.dev>; Fri, 24 Feb 2023 07:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677225324; x=1708761324;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=OWFC1gFywPgP3kUP8m2Ld4GklF8w7D2LFM46ihXESS4=;
  b=l4EX1L2e0bsqyVW05wbsRaGVsCCD7SJOwYoxDZc4aUGL9ylQWttfo7dH
   qlb8b4T0jNZw4o8SONRedsUnPU2gIIiH+P9BmAky3v4wlgN5SDpmPce8k
   R+MXEV9c4D5hJW4TrDCURuS/n3OPZNRTfnmBRsqLgNxudiJjI3Tcxh2Kn
   NVo95+hPhdtgjwJinB1uIanLXUKGpdlzX4454nbcKZAp7F7QyO8abbFJ5
   jGeV05APHY5naTSNzTRteej71YZU4mWPgoX8cxD9AsbZsX/gwyMF3h/NG
   8aHxZtsEB5jPaXtYgG5dABmSUk0NWXWMYETNwMFTcOfa08KW9ndPzurvG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="331154335"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="331154335"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 23:55:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="846867416"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="846867416"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 23 Feb 2023 23:55:23 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 23:55:22 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 23:55:22 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 23:55:22 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 23:55:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANsg0kWip7s+fOxrLPZRz7Mvd6NoRwzME4h67igiEOIM95C+tRsoxfgymGkqZV/nLS0K+QunB0Cf8lXvo5W4JVR3BH7Hm6NekYCVdJ1IT9bjj/IoTiFAURNOXhyILuy3VhFo2roO5Xhow1N4CilmTdHSbVEtGagd7tw+5G01S8wGN58S5iTRcmH42UbVoJhNn8MoBsPz5CVtLwGiJ3KQwOD19yt5iiV97HAHo8UrKnJpMxRVwmhGZLaPYD2LGjUWqfs7pg+32XLEvkEvYl3rszdUrbBT1PcBTvRz3d+UmCA/7xmjrNAC5YrDcVBTusUGYHbZkgxohBCnxckotZ03kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99g+uqTSkLjNQ5xI5oo8RdAXn/C1Eh8pSGJP/TORkBs=;
 b=jHDprWwQKe1jiaLUNG7Lt0qSElKflPyjpo2r/zBz4qAQxhgp1Ncj1F4NHLzhh8y6C4IN8aDOXoZ1ittPw6DcPdgxVkJgPFzdocW7EnSszlEnRXsbvoeyypc17yOk19HOSdCD+r9ME4PJRPXoBhQ0uOfqimssD4jw2siy9RF8YQVlAk9GMZPgQUuueHW979a+KDj3fJ1ojtK1pHvr/RQyO8wGo+rfU5W3tE1rBxBixMpSTR8iKDq3Ks6lFJSWHLBC+u3dpIu5BP8wIDs5B+179w+Xp074Wzu6KgsIv/uMYoCeq9kBJmq4NHOGI1zewVKWCxWWML6TkX5nx7y5WrW5iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by MW4PR11MB5936.namprd11.prod.outlook.com (2603:10b6:303:16b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Fri, 24 Feb
 2023 07:55:15 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::84dd:d3f2:6d99:d7ff]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::84dd:d3f2:6d99:d7ff%8]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 07:55:15 +0000
Date: Thu, 23 Feb 2023 23:55:11 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>, Dave Jiang
	<dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 2/2] cxl/event-trace: use the wrapped
 util_json_new_u64()
Message-ID: <63f86d5f44a19_20c82e294d6@iweiny-mobl.notmuch>
References: <20230223-meson-build-fixes-v1-0-5fae3b606395@intel.com>
 <20230223-meson-build-fixes-v1-2-5fae3b606395@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230223-meson-build-fixes-v1-2-5fae3b606395@intel.com>
X-ClientProxiedBy: BYAPR06CA0040.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::17) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|MW4PR11MB5936:EE_
X-MS-Office365-Filtering-Correlation-Id: feddd6c3-09b5-4b2a-0f7b-08db163c766f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hC7IMPQby9QsfTgqeKe3utLQ7VjAbAwmQizaj6I+YTTVKorDJkmkgbmzhdK8QCXA/Y13navD0P/DOVEwOsaXxXOHL16SbX0NLQ0NWwrHNaGPtAzl55rCzXqMehA8EwkpYkoNeso5hUDS4m8EtvtyGXNY5M8jLm/zqCXkiLFcouut5ySdeDtUup0Wb6hlMm9f3rqsscXDDf+8aHglNwu7Ahoure6KRnYXSh8Znwx/QBkzY1gROcaSELFaMMhCI/L0oW1FpO3rhc0gnHO2NY+x/Gy+e550bCFw4ajHPjIwv4ijX3vnLKnifeUSq42qToxptRe6Fz1mvNTG+mjy2VJPlX7ariqkxPoQI+j7HV+9U2wDqFWI5qFePuHNIYQn0HZJEwWVApw/5Ptp035EMu5+2sKak9cfudHnq1JJj7OH4Bp5hYEqbpm5tx8O+XhOSGdQBscsw9PwddzZSEpmzxKBXavkUx7WpGFZrqJss44FkrqdTZWVxytqZR1VvJSJ8EkmVQPe26hpP+CzaD7b2c0HwQon6Q7BMv+BA3FwoYqzl2AMhAmTBRXKBqPYIO++iNRKdk4mW3t8EDkaMWRO+1mu8rbk8fv4fYizJNeyAbliwqSTrxh1aZL4FvsP9xUeKfXq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199018)(54906003)(478600001)(8676002)(41300700001)(66556008)(66946007)(66476007)(4326008)(5660300002)(8936002)(86362001)(6512007)(6486002)(26005)(966005)(186003)(82960400001)(6506007)(9686003)(44832011)(2906002)(316002)(6666004)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?e+8zXek8j8caEtm++aaTOnpu/6VjEqtuxP3UU3KBNSUxAm3rTetGToJe2E?=
 =?iso-8859-1?Q?7oJ01BtPPsFT7Nn2eqa4Ly68zCKRNpflMuXeC+viNzYs1sc/3FoS4z5y23?=
 =?iso-8859-1?Q?tk0D1CUbh5CXUbOAdUYyNZ8JF+Wv0Uaa2Otv5cJj3EiMB10Yn3Aoup2nBV?=
 =?iso-8859-1?Q?APIyMKnjEOvyENU9Rbcosl5b3OZuhxwgy9SJeP3oZf8C69pQZZHtxG0TUM?=
 =?iso-8859-1?Q?c5tUSlh2XmqtJdqj6oqr8v2UBHD6HdITyRmav0xvDlfxnE6x9VWiZMQZ3B?=
 =?iso-8859-1?Q?QDmsmUb2Ge28ZYk8UddeVx28dcKL/c5n2Ji/YSN27XDiLsKdcTw0uWSVtQ?=
 =?iso-8859-1?Q?KhtQGF+IGAkqEGCLFV7+rUL2IMUmmlaH+R6ifAf0LfJmdyJKYUFf4tx+Nm?=
 =?iso-8859-1?Q?PL7ENEOWHOAIbzsW5WoWoj4qWdgdB3gANTmyApgFfpjGc87K6BH+ZoyZQ6?=
 =?iso-8859-1?Q?CP1nnADrqdzgV9qeox/xAMuc7gZIpfVn/ALuCLAPf1ROY5mB0pC3ife7TN?=
 =?iso-8859-1?Q?9x7RYuuUSIuJJOF+Lo/umOWfyQClvJtv/yMzbpBS70fOwYvF0HhRUDKwtW?=
 =?iso-8859-1?Q?XU/0INrIw0cFCJf4zrsaN+uz0pFSbYJLIFyE2oMdoFu02qzB69vvwsPQk7?=
 =?iso-8859-1?Q?bMv64MfdlRH00tqOxTTiMudJh+nrny1cX3RHfQkcg30TgYhE7KK5iDhZ35?=
 =?iso-8859-1?Q?G6HOXz1ScY5TXZfJaWDkZwFW6cLtKsj7gTeryOO6uhHBYVCjGvht6lULk7?=
 =?iso-8859-1?Q?MHuDfCNYYAlhMM86PzTbk9659zS45miztYpDNAK1IKDKbmL3I+ZYCi/h1n?=
 =?iso-8859-1?Q?2rg4oCwwrvHRVNDNuuznQIg7BYAUp+QgnZAwKa4TkNFF7APEgeU4+V+mrS?=
 =?iso-8859-1?Q?n5JCOz1tnW7mpKKOdY/nnS0zNjty2EDHUnymvuvwUyFRTrP70Jyl2rsTKu?=
 =?iso-8859-1?Q?JKF9EsFrvhBjnYLf/R7LWlmiRyHu1ty91lNqkY/8cE25IYZWR1PRqvrEYv?=
 =?iso-8859-1?Q?SM/NV1sfGPgmF6FEZn54QxCMQxmRbS8kICBxYe+YH6HboJjTwszK7bd0+f?=
 =?iso-8859-1?Q?XyhH2sJvftFUYnLWLVOjTPX2BBuWn8dlhW1F848tg5kof5196BA8iPq2nG?=
 =?iso-8859-1?Q?zKWvQhIx49IDvhlvdhxFoD/hY/HjxtqzgsqxGXeG1sEzrYaorVGZPNzI6t?=
 =?iso-8859-1?Q?WHDPf1V5Pv95gQ96lthwD8il/hcnVhljz9dgl8uLKVt1jeQIFNolbjNI6u?=
 =?iso-8859-1?Q?ywzEKRot78cleVwPXF+VB6wp8RmM2dAA4ZK5YN4MkqNsYOSF4jOgMfa5KR?=
 =?iso-8859-1?Q?UQuvmEnpZOByqX4JnL6MMwtqIKR0dZ8xeAIcO9YDMqcUJQ2/xEbp3R9ZHN?=
 =?iso-8859-1?Q?Sq3AJeqtWMLEJIhZh5HeZabk6ICbxO3jIEUrWo1UUNUnTJ2G9cqa0nTpbx?=
 =?iso-8859-1?Q?8NtGxg124xX3u1Th2UdSbsM3FvaIP/ggR4/bOqXJ6qOFRPIQsG9rllDYIm?=
 =?iso-8859-1?Q?6jCiUHAy2nmAS1Haup1K+rWWZDpzQkZNO+IiGEnHfUm03wDiNqIDS+b3vT?=
 =?iso-8859-1?Q?5n9kh1FxodaW43j9/4oGt1D6P2RqwdP3laIX/7GI8JGqEOv5cRuB9OyPP8?=
 =?iso-8859-1?Q?X1DrfjG0ocNeOULsUZC1CO4piy5tFxydbf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: feddd6c3-09b5-4b2a-0f7b-08db163c766f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 07:55:14.9376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhGThFUhlAejTjeqjV+SFnxGcUS7IRGgN9jM1Es3YufS+2XEI6pnxM3lBNGva+jxeQr4xCpxt50qKZ3Q+eJdfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5936
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> The json-c API json_object_new_uint64() is relatively new, and some distros
> may not have it available. There is already a wrapped version in
> util/json.h which falls back to the int64 API, based on meson's
> determination of the availability of the uint64 version at compile time.
> Replace the direct uint64 calls with this wrapped version.
> 
> Link: https://github.com/pmem/ndctl/issues/233
> Fixes: 8dedc6cf5e85 ("cxl: add a helper to parse trace events into a json object")
> Reported-by: Michal Suchánek <msuchanek@suse.de>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/event_trace.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index 926f446..db8cc85 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -25,7 +25,7 @@ static struct json_object *num_to_json(void *num, int elem_size, unsigned long f
>  		if (sign)
>  			return json_object_new_int64(*(int64_t *)num);
>  		else
> -			return json_object_new_uint64(*(uint64_t *)num);
> +			return util_json_new_u64(*(uint64_t *)num);
>  	}
>  
>  	/* All others fit in a signed 64 bit */
> @@ -98,7 +98,7 @@ static int cxl_event_to_json(struct tep_event *event, struct tep_record *record,
>  	}
>  	json_object_object_add(jevent, "event", jobj);
>  
> -	jobj = json_object_new_uint64(record->ts);
> +	jobj = util_json_new_u64(record->ts);
>  	if (!jobj) {
>  		rc = -ENOMEM;
>  		goto err_jevent;
> 
> -- 
> 2.39.1
> 


