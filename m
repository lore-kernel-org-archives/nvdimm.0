Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F43141C69
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 18:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UFs6so3F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701195590; x=1732731590;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G+U5Wuci7ZvztSxYAOPMKJZB/M4STXMC+3ybE40Cj3A=;
  b=UFs6so3FtpeHfqiidKsveRtndadQ0BxjrWHkat7Snj/jL/bAzb5Vsc53
   tMCfSqj/4ozLdFJGQqVrG5V9UE5z+AFOdNQbHO06/NjjrVQzbc3wOCVGT
   oac6gg605TF9g1IESOkdENI8S0NyHZ7YIvdDlA4pYdof9AjF8Kpk5DznE
   AOej3pRNkuStyJSlT84u6dBM6hOH/o28xFHxPjhekBnFsqU2shiogqJPI
   VUjfZMbtvzwISb38p5ke/mNydgxvdJtOK8MpxSzUT95uqbzuokiBiKY5A
   THymRSWWImke+5yMDF9BZaDw0D0ZPnNoveHNpmKu5704muXWP76DIfVLA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="11692708"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="11692708"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 10:19:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="892155225"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="892155225"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Nov 2023 10:19:49 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 10:19:48 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 10:19:48 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 28 Nov 2023 10:19:48 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 28 Nov 2023 10:19:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1iFaXYphnJIvU1cYj/WxOqRGn4kA2ek4nwA/S396lBLKInvNJ2cpLYiRbG7/NaMvfmsy0nQ9seAlEUst6GkY+MMqxfRXYHxxwYgDpx8btLLJ+NIp2FGNB9M6S1vTMcjrvjjAuNC7dVg4mPhVdWnAKgPoToXJ4EDl+wHBgT/hsKGDJGQ3/qIeoh8Ir/5g58O32jz4XqGAqEWI9K79H1jjnLwD9UFgjKdeSCMs24MisPyE9rEhFUADYuqLf5YvCGlEKMhUpGwcG0Tl9J/WD/45odMjy93IloaEdAapW5IJic7Ay8TKoMM2hs02YI5CGS9efNyEWJZINAm4NOHQ4GNtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kyYcZ/7Ok4NB5hWxN36iTNWFuwKX72M8B9z5lThl034=;
 b=OGpiNYhiFeus/5KTywW1187kF0IaYLIZZgXcX/EvBCd/ToC00m48a9aI7dlNR9XIvnMqBvlUbT9pDU7HsWxwkqQ5e7ZFD4cb+XhIyLblRZQsHufj6Jv9lXXpKuUYGB8Gj9I8kOAeeuqOmLqE4Se5ZXSBf9bRwn3t2cfNrvgXkpuML1Nk5hwfDmriePoSen9JIsN2mxEO2UolthNaoHxACGJdsG4djoUjeuXyLXZqWDcMIxxaHB40FF1DAeN0DKf0PWiFQv/3sWjNv68ySsOyPwvEVzkuf7iTTFaX4bpQCbbn3i3eqgULdoR+ia/xLGkDniD2dHR3yMRNPiUucfkqDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by IA1PR11MB6444.namprd11.prod.outlook.com (2603:10b6:208:3a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.28; Tue, 28 Nov
 2023 18:19:44 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::6f7b:337d:383c:7ad1%4]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 18:19:44 +0000
Message-ID: <0bd2a1ce-bbb5-4ec9-a9e0-d172455d8f79@intel.com>
Date: Tue, 28 Nov 2023 11:19:43 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [ndctl PATCH 3/3] cxl/test: use an explicit --since time in
 journalctl
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
References: <cover.1701143039.git.alison.schofield@intel.com>
 <1802cf15f22fe5c284167a9186eba8f2cd3c31c6.1701143039.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <1802cf15f22fe5c284167a9186eba8f2cd3c31c6.1701143039.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0122.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::7) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|IA1PR11MB6444:EE_
X-MS-Office365-Filtering-Correlation-Id: 54e42047-d38b-4885-a598-08dbf03e98bb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Axq4cWjjSWjT+oz9jWidhyqfGPGw6dhYyHemJov+M96Oi9+qIAAIBrmFWM9h+xbgVE0YOrgPWckaB/XF7j8H1B9cJlO6X/25NGTiqUPHKOoQwCefPSXD+acWTKWkU7YvY9SEscvxbwVVG+n9pL8DhLrfdhefJvSqA9q+79nPMFeG7MV64mN5LIvEVTQJDcMYhN49ima6iZFwtIRtNdY622+MrlCec9LKDwBadf0FcYZNiDaALJhXbRAp3EOSLYXBouKO7EATdxN+7/UvYIn9OqhEWtIFjTYcvjJ2S2BfLpfI/wzPvn3oMeQ5PxpITzxlxG2NZADzN3DDwj5Fe0jvzqVSTibdNwRLwjOGHvcUPW/Sw9uGxoN1DX5dshx9ptO6Ntn2dQwkb9DX6DtUhv9+iGBBR1/oIwLqV37+4QQDkB6XDRDjTuYqg/VzId0gNmdcp7SPDntAGfLOo4pV6Mao1m1PGRaP2spGYya6ukd9jIUUXeCPfaMj34sbBGWp9xnuNURax4cy76aFxNB1bdVInWBaHGCWwjizh4anP9xIz8oqaYPGmngjx+kfk19UaspgWa0azss5kVs0MCFRszmTB2BtC000tW1ILrfRq6NTEhgAqrItWsB4q6Oz1y95Wrz5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(396003)(136003)(346002)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(2616005)(26005)(53546011)(6506007)(82960400001)(8676002)(6862004)(8936002)(6486002)(4326008)(5660300002)(86362001)(31696002)(478600001)(44832011)(316002)(66946007)(66556008)(6636002)(66476007)(37006003)(38100700002)(83380400001)(31686004)(6512007)(36756003)(41300700001)(2906002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1VpM3c1REdxMlpTS213aEs2dld5VWhPVXdSL3AvU1FUZ21RNlZwU0VZVDlt?=
 =?utf-8?B?ZXVNdlVMZjZPTnRwZjJTVnNzK3ltSGNzY21mQmdjSzNqZlNSUzVoV0NHNFNx?=
 =?utf-8?B?NVMvNjRSVDZtMkdjZzZyOWRVaWlTRHBpUlhHTkgrU3JSb0JWYy9sMzk3QmdP?=
 =?utf-8?B?OGp0OUJwSkY1WHdqdTc1bmtlenZjMzh6WS8yUEFGVzRCOUhORG9hc1l2SzlC?=
 =?utf-8?B?MjNQbFNYZEM4QmpTSW5veVBFbDBueldJVXNiVWhaSUlBU3R5ajFBWWdJZERC?=
 =?utf-8?B?akRFbXpMSWhDQlZjWUk2akttS0JyQ2ZIQ2M1YURDcWtOcTVlQVh3WWwzaU55?=
 =?utf-8?B?aklsOG9mRXVhOVRaSEUybkxrcnFLMWErM1ZwVVROSGxLU3BJQmZKMFNUNDBk?=
 =?utf-8?B?bmE3YWk3TERpRVJidG1JQTlsVWYzTCt6Q0hmYm1JZ0hGaHRMdlFGNkRRcG5O?=
 =?utf-8?B?RVpOUDBVZUpzd0FUOUxIVVB6dWxmVWlxUlE1WlZZa2hkQ09EaUxFQmlOeFhN?=
 =?utf-8?B?MkRQdlU4S01OMHRURFpiSFZ6Q3VNZ0lLai9sekNaNFhpaGIxVFcrdUdZVy80?=
 =?utf-8?B?V1FSVE1LSWFVSVhOSFEzMkRtZUZXLzhjUFZHaU9aZU1RcUJqd3hCa3Y4NnVl?=
 =?utf-8?B?bTFiUHE0YWpsV3RzYmlVTmFmbU1qOEJmc2pSbzNmSG9CV0pHd1htL3cxSWc3?=
 =?utf-8?B?ME5aaENiZXczL29sOEozclVCV3pmTHBPMzA0dlYrSVIxSHNXN2tkbS9LRGNR?=
 =?utf-8?B?N0VJNFhITjk2dGZMMGRpcEhsWmRETEMwdENtUXdhSW1tVzBKWVdMS3BURGFC?=
 =?utf-8?B?YzhWak5VUm16NDAybUpET0tBaVUyNEt5MnlsakZ4Tm1xZkRxOVcwdS80cHhz?=
 =?utf-8?B?MFp6ejNHZk4vK1ZhbVlxUFVhRERPS3pJRmhuaEE3MnAyd01sTGl0T0J1aVVC?=
 =?utf-8?B?Z0ZRYWlvUkNiS1U3N1ErTmhyOUkrNWR6UnBsdmc4d1ZGTVM5MHlVeXU5bE55?=
 =?utf-8?B?dXd2T0tjSURiL2tLdDgxZDlnUXA3d1BOdVhoeGNhRHY5V243bFd5Rit4dEp1?=
 =?utf-8?B?RGJrcU55MG1UZmNOQjYzejJtOGlZYmxtM3dLcEtLL3E5d09mTEJRV2dvditB?=
 =?utf-8?B?U1FBbG9mTFMvRkx3RklpOWJ0VHdVSVlLL0M3cGZTQmZ4K1FiOFJUYTcxVHFo?=
 =?utf-8?B?TGhvdGJDazdXMTE4R0xjd1ltWTN5WjA1Z2RDTVJ5bjRDK2ZsVTJib3JqRUVN?=
 =?utf-8?B?M1VEa2Q4MzNWTldTUjhjOCtxRzFMZnZrcFFmYWhVR081bWs2eitvUVFxYk1O?=
 =?utf-8?B?VTJPMC9xcmZCekVobHVYUDFRT3hBNnhOZEN6ZFVRUXJRalRMVjdkdHBnQktR?=
 =?utf-8?B?L3gxMnZCVEUwOUxDWVJ1d0FpMkRzVXhESjl0SVJPb1VWdzJ5TVVXM2NRdGgx?=
 =?utf-8?B?NnlJNldiQzBRWitwZ2lBdU03Q1N1d25LdEVaQm5WMmpYNGNycXZSWm4xMXBD?=
 =?utf-8?B?cFZxKzNmT3NqYUgyalU5clhDbWMwT040N0ZKSkRpWTNtK2hrTkpSTmdhWHN2?=
 =?utf-8?B?cjZUZExzNXZ2WHorcnpjQVZmY1ZabzV0VFAxUU5TbnlEU1hVc21SVmZsSzV6?=
 =?utf-8?B?ck9QSkN5TXRpK2xsMTI5ak5IM1BxNGdVcjF2a0dWMHN4QnJ1YmJ5RmZkN2FP?=
 =?utf-8?B?L2Q3ZHc1ZTlSeUcyajJqSUk1YnBQemRHODlTSm9uSkJQNlQ5QUx4dHBhQXFh?=
 =?utf-8?B?eDU2V21yVTc0SElGRWFjTWQ0Q3l0Tk91bThDZHkrZDYrRC9BTVkvUTZ0dlNE?=
 =?utf-8?B?eWhCcTg4ejBab2xvTlcyRXBFT1JrMEN6UUNialpkT0F3dmNjSk1jR0lvZm5l?=
 =?utf-8?B?SFVjVHpncG9rd2VqL1JwUmhVRzBSWTNYcFZmbldVRjZhV1ZpeVpMS0JBTHd1?=
 =?utf-8?B?MjBLRjcrcWRaaDhIeGlJdE1xUDhhUDBuMmxxcnl2bERpK0pHUG83ajBSODdn?=
 =?utf-8?B?K2RNZjdway9VWmFCVUZ2M2g2a0lEL2hIQWp6b0g0VlFsT3dZeCszNmtvT1Y3?=
 =?utf-8?B?bWd2UVpNU3RFczJWRC9xOGFwem1GdHVibXhvWms1RXZLaHlLRzVNMHYreDNI?=
 =?utf-8?Q?KKEvhOMstjbD2hhzcSjOwDHNq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54e42047-d38b-4885-a598-08dbf03e98bb
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 18:19:44.5570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2XPMNFHbb+0NFk2Y8h/SbZQ3anAwWTUF/8DtoUKD0gAGWNf+RlzD6Sjb7eJRn+KRYqJsrEp+vBg4TYik7JfFUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6444
X-OriginatorOrg: intel.com



On 11/27/23 21:11, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Using the bash variable 'SECONDS' plus 1 for searching the
> dmesg log sometimes led to one test picking up error messages
> from the previous test when run as a suite. SECONDS alone may
> miss some logs, but SECONDS + 1 is just as often too great.
> 
> Since unit tests in the CXL suite are using common helpers to
> start and stop work, initialize and use a "starttime" variable
> with millisecond granularity for journalctl.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  test/common | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/test/common b/test/common
> index c20b7e48c2b6..93a280c7c150 100644
> --- a/test/common
> +++ b/test/common
> @@ -156,7 +156,7 @@ check_dmesg()
>  cxl_check_dmesg()
>  {
>  	sleep 1
> -	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
> +	log=$(journalctl -r -k --since "$starttime")
>  	# validate no WARN or lockdep report during the run
>  	grep -q "Call Trace" <<< "$log" && err "$1"
>  	# validate no failures of the interleave calc dev_dbg() check
> @@ -175,6 +175,7 @@ cxl_common_start()
>  	check_prereq "dd"
>  	check_prereq "sha256sum"
>  	modprobe -r cxl_test
> +	starttime=$(date +"%T.%3N")
>  	modprobe cxl_test "$1"
>  	rc=1
>  }
