Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B679370960
	for <nvdimm@lists.linux.dev>; Wed,  6 Dec 2023 21:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d23frXD8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701898325; x=1733434325;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UsibzcJgnETtCYOnKUZyWdZdEWamX9GhPkSSMh6mtP8=;
  b=d23frXD8TjFaPWFxXp9IUsFD0oyRtwN+zHFk9y+8WZpUFM+hKwqRtsZV
   K9JwaKhSDVV2n/surmON15golyQZHZ2SqfAe/yin9Aeqd7lMnwYnsSmQ+
   GGCMhJ4KsZRAmUSAXh7e4ORb6iFlkoO7fm25pz3JwOKJu9MGrTfyJipGp
   LWiX6Iw8AGprENNI7KTDUzFxRJbNNKvFzEsoBpR3Pz89K9E+f7OceYrul
   dd6eWYOHG2J65iHI0ITIDrcZbGlj5IYPnt7MQDLU4UITOTiQ+rgq6zP+n
   r69g2Q+rpKumCDsGGpJ4rBIE09YYMI9ebciuuaZp7oiH0xb1F/SLjYe+q
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="458455822"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="458455822"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 13:32:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="894884393"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="894884393"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2023 13:32:04 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 13:32:04 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 13:32:04 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Dec 2023 13:32:04 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Dec 2023 13:32:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zy7AIUySU4Z6BlTX+REC7Hc2mIxFmWNEPASVZqy88XMyi0lQ534SU8ck591XNCyebGfjKOzNmewDvk3QAR41HjGv8gl1vZBSWyz2X/1LPl5xxJKQuZ69Wv7PYReu+9IUamsd1YUPYwnBvBvW3UxM8nnagSI4M4nxdISoi7yzRbJRg3DiCPDHAuLY2dkOJJ2NKwz7Rad6tDjWGn3uoZKve7/9prqclh20e5izTN/AISE4zydCy0XHnWMS7R4D+OAwtT2SOo2Ngr+fRgzKwSBqMlws3QljoIfSalEGVZ2AsWsEZTrsE9nz+NyJWdgQVKQ04kQjhTaqFA2pzYKgK7/E2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9f3EO91AKuDNwmkwjCdy6P5DbhVO47d/pFOO/KTIzs=;
 b=VC6zzzVRh22vj4gvLm7m+e0/4Z/4z52T1dQIeg+YKwAwM3parE/KLkgW7gp3PnN8eZhSDDXiYOergPhiN1AgxV5I9gDIsIgAvel+RkBOx08bndV7BdanBn/MfHGFTB8dnUDrGnLJN3hQFp8tORdYRk2xdAACw/s0i4eZI/vJuT/P0EWM3Gk/UevBTuZ971v0bdsf64e81BemsrnR5785RZBrm3EJ1POyWylsYOT3uQanPyZR1aDsMev2ZoOmtm7zB8LoY/6oAy2vWlFTFoGimc7PubSj2+/fuYqYA7HJiZlvxWOG2AuFpokRRsdFpbsa074sFdowVo6vR08hxNin2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CO6PR11MB5604.namprd11.prod.outlook.com (2603:10b6:303:138::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.36; Wed, 6 Dec
 2023 21:32:00 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169%5]) with mapi id 15.20.7068.025; Wed, 6 Dec 2023
 21:31:59 +0000
Date: Wed, 6 Dec 2023 13:31:54 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, Li Zhijian <lizhijian@fujitsu.com>
Subject: RE: [ndctl PATCH 1/3] test/cxl-region-sysfs.sh: covert size and
 resource to hex before test
Message-ID: <6570e84ac75da_45e01294bd@dwillia2-xfh.jf.intel.com.notmuch>
References: <20231123023058.2963551-1-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231123023058.2963551-1-lizhijian@fujitsu.com>
X-ClientProxiedBy: MW2PR16CA0066.namprd16.prod.outlook.com
 (2603:10b6:907:1::43) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CO6PR11MB5604:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b925867-bd3a-4a75-0efc-08dbf6a2c723
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OOsIsdvStg5dsq2JnaGzOWDeQItSX5xpiwS34rRRLZgvA+h/jxs+qedVstCf5TPRkRVfyJEpzclXIY7La3QtJlhsBDhgX67P/+cjFKx96zf0fJyVG7HRy3MebaP0EGjGqkgSE3lQsAKsuvvMDkr+HeI4+B4mIqVlBpfZcAx5i5xPpVVFeX/MGI9sc/K8HmLLyQz+2z9I6bI5Mhn010KZB48uaUFnsr6WDxDL7rLmUMkMWpecXRlDnG8uW/8E7ecfO/0JGXXNTmP2tg5k4elushd5pUu/tVY5DbWdUCPUD/S6w+WdC3D3okmmi/fe2B7CUOEv9deK71bkIZcnFTVP/HcCqEmycz0KJrk9vwizFkUfK1Di6HcqggGAzGPrbceJ9tn28JLMnJy+9rL2RjRksb4t5jpWDrm3m9PERo+5RC+1PJdOdRiIopY4tpd2qVGrCs6bKEAksXF9Dz6bhyYjxNuRE7MYbkOdfDviGA45gg+bKYMscsgbRVtdYFnuUyzXYvr2ETaL/GhR2GPEFZmIJ+3JUPolKAZiycsnUKnyTLo5HCiUojM+3kkIZXCuQLW2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(396003)(376002)(366004)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(6506007)(9686003)(6512007)(26005)(66476007)(66556008)(66946007)(316002)(38100700002)(83380400001)(478600001)(6666004)(6486002)(4326008)(8936002)(82960400001)(8676002)(86362001)(5660300002)(2906002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/VNG637RmnWSKxXy9kvqxw5pdSIfrPaVm0sOst2F2ajVTRSnU+gc8QbcFPb0?=
 =?us-ascii?Q?4zWhVTdSPgwdT+Cf38hhnBq/KR+9ipCXWewaoSmsx1U7oRZOTdKV+uyg+n6T?=
 =?us-ascii?Q?PDg6SrYgwAc7BMYMKzfxdpSQmOSkGjDEl0lierf1hPc2kqdqaGja1Gqi5Zpp?=
 =?us-ascii?Q?J0p2zZ7VZ1mIiKeJeEp6LXrPUd14VldmmpPB2ciPnsRlYUPTvaeg0vINM6m1?=
 =?us-ascii?Q?j/wV9R/6ycrP/bGyRVq5AQQyXq3gIWCud3v9ZXcdHLunVCRWxubSPPy8bkZU?=
 =?us-ascii?Q?JV+9eJJRmHaGbMXWRYkKIa3jlrsTF3kfdBR61lRdZyGcLuKcjwuqSVc2Z74s?=
 =?us-ascii?Q?KZ6fufi9BLWfww9bGNMj+wjiGT7F1OXRfapt5f/gRcuDUjsEwieHHBtntbKI?=
 =?us-ascii?Q?RcYr6QVWwE3b405MI5LvmUJkhAAH2/8DzyXs3n0YeUlFi0gRbnsAs/wjDlMc?=
 =?us-ascii?Q?/2pr7ovJfC7Gs5jqIMpjFdPfV1vQxbQ91eWobIvMwBxzao+FIsyi2k3FDk36?=
 =?us-ascii?Q?MHmr7qSfGag4Xl+rXFZpVeDLbt0ncbwXrpHTKZdkd/5bQrrC834cR47hGsIl?=
 =?us-ascii?Q?ovDShOG/7VT6yA3DaMf26ppSHRg0SCgJVBYWDtup44wf0tnrsIjiMWB7F3zy?=
 =?us-ascii?Q?DpdH5o2BPh3kHv5EW2jdXOEJly884SnjiNnVQUpfwqMdsKMHe/WMKPguAMFx?=
 =?us-ascii?Q?fx1uG9DLVHrS6dMpUGepw7Wul2nENkz2xoxfBw5oiGpimAdJ7X4Q2u7Di9yK?=
 =?us-ascii?Q?bVlGvAyfZeQunSOcXXhg7krtvOkJdAELrYXH8lB7wfhtit95fBqPv50y/FUq?=
 =?us-ascii?Q?jO6i8DgnZTFY8lyzPgNZWdZoXYhFRiqmM0ebEDzlk5Yw25OQxi/HlqvNiHZ/?=
 =?us-ascii?Q?WMkZ5CNnsR9Lizd1oURtz6N7ZSk/hLkQKtsBuyerHrEXC9HyLvCWVlBrrsdT?=
 =?us-ascii?Q?5f1Z8UIdBecbVMxnwpuwAuoH4/e+IHQFPtDk79BJACkLH3atHr/4PkMj3Aeg?=
 =?us-ascii?Q?VdTR8UlsPVsQHctTchDc4vmMgob0555h6wn9pcRPt/HUlVYZ3MPMc/pBFOb9?=
 =?us-ascii?Q?g5zb9oznOie3UE6wE+p65TZ2v5EseW6a3aMVzJ/SnFTP3HurIiRPdKoA9Reo?=
 =?us-ascii?Q?RxhDMTKIpcYkBpbOdiwsa1l2rh+AZngUAO8GPkW23P+kb0YbKb8zd8ozo+ur?=
 =?us-ascii?Q?AHmq/cyDAuu27Vn/IoWpk6lS9j1Tfm0I9d+qBUosJw4ucySMn19QU2WvMzCv?=
 =?us-ascii?Q?mQER2teGuvA/kUvqShkSyHOEktoDB3fsjdB1YdoGEdiXFnoIb3aZl8xH+ktJ?=
 =?us-ascii?Q?aNnA2ox+8Pn5UEuJd26mAyq8Tw6+GqehOOUKiGOz8WyaoPWhSHTh5epa+tKA?=
 =?us-ascii?Q?/1XbsG/CgmoN2IXKo2/Dq41ewmAsdXHHrq4k1FGwoQY+AL+/0syUrDK0NHZd?=
 =?us-ascii?Q?UkvFC9oLZ086SVodnunRIgG52ERUKphQjGKvpwmmDwIQUWSFPIN8XnRa0N70?=
 =?us-ascii?Q?xA36WQEvyyfW56VYmpHQ3MYjGbatApktd+urihHeRwxSDzR9Swh9jepSWNpp?=
 =?us-ascii?Q?iquKa6pyrSCHmwyGBK4sDdoAB063chCKEQlxzYSev9bHi6ipxpmjDXlGCnFq?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b925867-bd3a-4a75-0efc-08dbf6a2c723
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 21:31:59.0838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GndHURQUJyQeV8DHr3BcePv+a14plJvwCeqAhvsRJPKido+bhwGJ4Yh5XZUMrZ+KLV/lDFNEcmb3ZhKnAJZ5TZGRSDo0OcjvAgXy9RgzFlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5604
X-OriginatorOrg: intel.com

I would summarize this as "Fix hex vs decimal confusion"

Li Zhijian wrote:
> size and resource are both decimal

Please always describe the "why" in the changelog including the
motivation for the change and the effect of not applying the patch. I.e.
how would someone know that they are hitting the problem that this patch
fixes. Sample output usually helps here.

> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
>  test/cxl-region-sysfs.sh | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
> index 8636392..ded7aa1 100644
> --- a/test/cxl-region-sysfs.sh
> +++ b/test/cxl-region-sysfs.sh
> @@ -123,6 +123,11 @@ readarray -t switch_decoders < <(echo $json | jq -r ".[].decoder")
>  [ ${#switch_decoders[@]} -ne $nr_switch_decoders ] && err \
>  "$LINENO: expected $nr_switch_decoders got ${#switch_decoders[@]} switch decoders"
>  
> +decimal_to_hex()
> +{
> +	printf "0x%x" $1
> +}
> +
>  for i in ${switch_decoders[@]}
>  do
>  	decoder=$(echo $json | jq -r ".[] | select(.decoder == \"$i\")")
> @@ -136,8 +141,8 @@ do
>  	[ $ig -ne $((r_ig << depth)) ] && err \
>  	"$LINENO: decoder: $i ig: $ig switch_ig: $((r_ig << depth))"
>  
> -	res=$(echo $decoder | jq -r ".resource")
> -	sz=$(echo $decoder | jq -r ".size")
> +	res=$(decimal_to_hex $(echo $decoder | jq -r ".resource"))
> +	sz=$(decimal_to_hex $(echo $decoder | jq -r ".size"))

This feels like overkill, I think bash arithmentic operations can handle
hex conversion and decimal comparison...

>  	[ $sz -ne $region_size ] && err \
>  	"$LINENO: decoder: $i sz: $sz region_size: $region_size"
>  	[ $res -ne $region_base ] && err \

...i.e. does this solve the issue?

@@ -138,9 +138,9 @@ do
 
        res=$(echo $decoder | jq -r ".resource")
        sz=$(echo $decoder | jq -r ".size")
-       [ $sz -ne $region_size ] && err \
+       (( sz != $region_size )) && err \
        "$LINENO: decoder: $i sz: $sz region_size: $region_size"
-       [ $res -ne $region_base ] && err \
+       (( $res != $region_base )) && err \
        "$LINENO: decoder: $i base: $res region_base: $region_base"
 done
