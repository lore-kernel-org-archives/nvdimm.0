Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B7E1360
	for <nvdimm@lists.linux.dev>; Wed, 22 Feb 2023 01:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677030818; x=1708566818;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RksuoSPMfyWUjdr60Gdjs7v3iNBg8iOF4sUQxRpnWZo=;
  b=FX5h6HFRipuGOAXFGTGb2z3QKO0iQn+327Hvv7g4Ni/+bEeqqYHEUuPu
   8YuRwpdPRKF7vGFs9KggDgkBZ7wRGyH/Z94HsC6WOgAmZPpeqD/G1ZMHp
   wcTuO5v2kLK8n9nVm/kpm+Wppux3NWRNyZGSFa3oK0A2OypjAosjopq7C
   KzDzqMNUuiheWthNeNHEMkGOcRun/l3ksVRz+Nmgb0RsiXNuYM/mtgCys
   IEan64jtOQ9oOsi80uR1n7lVqVJoxUelSgjs3xxal6NEbw65rNPQs/Ih1
   EFnNMs5uPbZbqH2yTJ5WeJfscn29qddxbiE7Wkj+JXZu5R53V+ZYf93sD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="397497724"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="397497724"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 17:53:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="795722175"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="795722175"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 21 Feb 2023 17:53:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 17:53:37 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 17:53:37 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 17:53:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jkBG9WlLC2c/1kdcvmN4L0ecgZtl/z5Px86PULTcgwDhqAHiXu3S+N4rWHudK7dwrEF8l3huHLdIBcMVqvdtuj7Bl+nzkDu1n7axebiahLY8mNXFhrr+/CQIrh5udsehys6Qr/lF/p4VX+QO0LLPH0A5KBVa/LFet9LlaasylEiTsdhi1DL5vajsOUgbk0wgu3CAYB/LyKaOgnSuYGJ+tcWRrmv6hQfYTRU7kTPtMT5KsUJ64I/HknmTH3iX6n/WAucaUZd+KS4z0N70MicnFyyq1EDzjQJuud7koCv7/wzkmgyNw+a/vefk4xlwrdCwlRTRaNrPKXYV/q3QJvzKHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WUCYs5iOYzmoFDNMM3un40NikVXeKmMIR6k9SeBSIlo=;
 b=LG9ZtrxW06EtFAUry9ZgxQbihr23Uezxz5CsHUTqJoj3U3Pi1kNnqcMeHy1vxGQFlYcL8RuSms/4YDDOQBRkELXuoFStDi7pzvkevsrDGop2pnqTH+PEkMewvaFDPaOJnQTkof+kEEkXgrdhAKNjFfOu8Tb2owqmu8aWVUB3t85r7GjkcZnnHTGqwwIN99Uyth50/4k9re5dhMRqaNm6168FnX3PVtsU8vUjP0SxqohuINlrIsjgf7orqXvoo/xZuuMyjuzXjyv3RvLbeQx0L0rGXDM+hug+hfh5dB+MWecdBul+rLsVsRtgD9lkQIbXuDYPhlpYWRnNDIyiz/cM2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM4PR11MB5261.namprd11.prod.outlook.com (2603:10b6:5:388::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 01:53:34 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::84dd:d3f2:6d99:d7ff]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::84dd:d3f2:6d99:d7ff%8]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 01:53:34 +0000
Date: Tue, 21 Feb 2023 17:53:31 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH ndctl 1/3] cxl/event_trace: fix a resource leak in
 cxl_event_to_json()
Message-ID: <63f5759b12cfc_1dd2fc29411@iweiny-mobl.notmuch>
References: <20230217-coverity-fixes-v1-0-043fac896a40@intel.com>
 <20230217-coverity-fixes-v1-1-043fac896a40@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230217-coverity-fixes-v1-1-043fac896a40@intel.com>
X-ClientProxiedBy: BYAPR11CA0043.namprd11.prod.outlook.com
 (2603:10b6:a03:80::20) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM4PR11MB5261:EE_
X-MS-Office365-Filtering-Correlation-Id: b8b47c46-4d65-444b-abb8-08db14779adc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O/SdiEdWxEyvM0mMzluYyZmI6YEcxD4H9dBwsrt553nqnQoL5Pke9+afKX9RvXsWzqxKJuh65uC+6NueGMMGVPBWdloK1/q8F6hcgArYTLdqVMvVERdCmOu17CQGOqoFJUsb36jZIAsR4Q2ifMprTINjazegzJ9nmtk/b7lSTwqz7ivMigIfTXNBMQggTJIMCLAx+qGIUyiw8BPySREHTcpcGLUSDbTLTT35OJ5jUz7WdtLKf+FT/yDbfhXRaIWW6vUGgNFCYQ7gYudJau0+8n1qGYmFgUrq+TDA4tm1xHH8DT7jIE5hhby7qlxlUfun6O/ST2YCJ+fXQF7cTCcJWOIxHd7eCDPl9Y6ubroGtBls83o2DLSxuTz1RJ2aDcz7IafuJnTj4AcHAbB9yOLl9DZX/h+PZdIYX4WWPFhTtZE7Jov7gwWWC275r/ilcPRpONzewC+q9E/7cwmT8aped83xOS2S/2soMkGv1Ie+Pjr9nwL47XxkHYUWi4vkE487+6A8tqph4DTAKOJKeMUr5DvTDqA6AF/ZN3Y4uRg4JBZFoQUejaUAbP/hQT8iDxMA9X9SP0Fkb4gMHuIyReenTyFSb5ZGevovO5VpdMAaDBSPF6I7STIIx8F3XLxzCbV129LirjthgBlnD5hSDVMZaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199018)(41300700001)(9686003)(6512007)(66556008)(8676002)(8936002)(66946007)(186003)(26005)(4326008)(6506007)(66476007)(86362001)(5660300002)(83380400001)(44832011)(478600001)(316002)(54906003)(107886003)(6666004)(6486002)(82960400001)(2906002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fxhCKVK2nyZO5y6NTvpbHaDxTyZYJD0bJPDIquHUm1EhtfiFoX0d0AjG9f7Q?=
 =?us-ascii?Q?wmOjtPH2SCbrroJa5ZtgEUCGJi/OAqrJi8+JxOBIbqu2XvsSB8LXhyguzJ/q?=
 =?us-ascii?Q?RkqLlrR6AncPd2I77sRw6me5K8sG85V21A7ND7BTewXplISdHo5tq7oQAMen?=
 =?us-ascii?Q?03UMeRyjLXRYhaD8lTevtcMUSh/Tz9dHeSs0p02yyELkrMMRwnjKhBlforxz?=
 =?us-ascii?Q?dTDZpBipbuwIT6aRwZ3teBNciTuP8hZrr5I3cujPeUt2BBUbP1y1l0mIVRpc?=
 =?us-ascii?Q?o39EXiIsPdDQ3eoN86543IyZCUr0JQVg7+8EZpkR+lSftqgXZgvlvKzWO0my?=
 =?us-ascii?Q?G6yGtnI7iwmvckLmTXpd+ZP+Gfzv8a4cGUBAwNvWCLADbl/LVhwCnxvjDA6A?=
 =?us-ascii?Q?r0Hg4Zm+tov7TdusphIGMDhknmUyI9ep8TgGjic/EWPTXKX0iWvynz6P/yMh?=
 =?us-ascii?Q?Hs2PaLa4ddWNPyshtd+i4Vk+YU618uAAnRzs6q+VI9cNd0PIv7f13s4xSwjn?=
 =?us-ascii?Q?uCSlytBaewjQ17e18PwnJ10Ur43PalPS3e5DT5AD3XtX4zkwPsgHd58iJKzc?=
 =?us-ascii?Q?UiNVZv9gPaKdhBGkFqtS8N2ObDdwQ+RoCFh8DsjYQd1O0+ACNkhS96CUCfRO?=
 =?us-ascii?Q?Ff8B7H6TK3SqtzsebkbKID4BT2blkpxQJWMKCh2bhtXpXmXLgH/NpdOK84Km?=
 =?us-ascii?Q?XKPbITHnwq17+7D0LypDX76o66WHK1HZpRjZMB3DMmQ1bWWscnAz8Ru4C6h7?=
 =?us-ascii?Q?BeHcR2bDy5iZ4PkE8CaBeGj9jLTaf2Jd4kxWHvVOR/oUVmETK1Z7uhhOE0O2?=
 =?us-ascii?Q?EN0Awm1DKQhsQvrIDtQZJrT9mdIOGLVsp//oNzHH22Wdrae+n16KTkvQ6gSO?=
 =?us-ascii?Q?Wt3yyzJBFp8vaGlUeRE3ZUQlV1PfE0xidQf78BBYDOBfXB4U9Wvmf+bp7iLB?=
 =?us-ascii?Q?roxVIJmqCJ0MwNTbkgxAc547RiTCggzAwcDooy7nBMk9R7VL0QmvEdwouBvU?=
 =?us-ascii?Q?+PA65WvQS3Kc1RUhhC+EHitxkwfNcXh26TsbvrfwHZ2n85iEJCv08Pf0mpyB?=
 =?us-ascii?Q?3CojvANJ0BnHCkTgFLaunAYg9fNKDigSzSTEwBG2gGPnBTTwsT+TbHif+Drk?=
 =?us-ascii?Q?L2o4FqbMHaORSKPBIVnQfkmXHY6IDEWtMfVK54lbsV0Hx32bRJqrqi6Z2YEK?=
 =?us-ascii?Q?2CBpcIKIPcLJ7EoXBFXL2a2m4Kz1NGMhtmLcYb1+rOU4yBULcio/TMhBODVA?=
 =?us-ascii?Q?HhT7oHz3Ya4nXOgAvoVg39RcBaHM00Fks2f9JrMsUfopiCmXlpSLyPsBxAZQ?=
 =?us-ascii?Q?ZudfRmERiGWvggpYHEcyasQHFymSntUp+E3fJCJEbRrXpF1aWGQnHwXlyNQ9?=
 =?us-ascii?Q?pPa+WPs6bZMp/Qaq9/7b1VAZVaUkn/5LhWNBIlOVdR+NZT6K8TvDrnxMz+us?=
 =?us-ascii?Q?GOAghd09EarVk9kiMLIOw1y6lrcOvy1tstWEwa0u7gV/BebONfpjytjU3mEX?=
 =?us-ascii?Q?PNs0V28HYPnyQSy1W1+aSQ1ntSYZVHy5Kpr265zsDCNel1rHHEsPFoK6lLyy?=
 =?us-ascii?Q?NZsGiCfXa0B3ZYPRPfEj7m/XZxjD02m7d4EeGzR2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b47c46-4d65-444b-abb8-08db14779adc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 01:53:33.7217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tAbUbq76hRxipJmqokUDgp8hp9oPJQg9ZQCYBmcRGPzd4AtDwF0/jLv3WUFsmM+No2tGmLjY8gK5J0PKwE7xYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5261
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Static analysis reports that a 'return -ENOMEM' in the above function
> bypasses the error unwinding and leaks 'jevent'.
> 
> Fix the error handling to use the right goto sequence before returning.
> 
> Fixes: 8dedc6cf5e85 ("cxl: add a helper to parse trace events into a json object")
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/event_trace.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index a973a1f..76dd4e7 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -142,7 +142,8 @@ static int cxl_event_to_json(struct tep_event *event, struct tep_record *record,
>  				jobj = num_to_json(data, f->elementsize, f->flags);
>  				if (!jobj) {
>  					json_object_put(jarray);
> -					return -ENOMEM;
> +					rc = -ENOMEM;
> +					goto err_jevent;
>  				}
>  				json_object_array_add(jarray, jobj);
>  				data += f->elementsize;
> 
> -- 
> 2.39.1
> 
> 


