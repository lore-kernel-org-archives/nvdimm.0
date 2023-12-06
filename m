Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D9370969
	for <nvdimm@lists.linux.dev>; Wed,  6 Dec 2023 21:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bVPnu52B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701898680; x=1733434680;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CTY/ZT2pUjRzzIqfa9Hz/NXozJgzUBwTyjvFkI9tNTE=;
  b=bVPnu52BMiJJ26utxLAw0PpqSysGyrTmJ+XWT0Puur3IYV9bYLzQAckN
   T4n2SSfJE/MDfCNiNyTaCGaqWODFcP3M6NUMFa5yB2xyLoLxQpNsepT/9
   xFmxwcgDTlkqewVhWnDGDgn6ka7M7l558VARcfE4Up2z4Bv1piSS6oGCu
   fCmwpMwxPrsn9UGhiqP+rwkykYwNnKajvPpY+F71SqqJZiETtJYPDzdEJ
   MtybbokSohFzk8qldfnLxiCIKVkD8ovP+Ugtwj8GCUkf0/KclzUiFiDyW
   IC7tj8txNatUUaYZUozF1FU7R0nXPTwoMl4Un/1qh+ktuAByyz7hZp2Vc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="1205930"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="1205930"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 13:37:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="915324878"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="915324878"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2023 13:37:59 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 13:37:58 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Dec 2023 13:37:58 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Dec 2023 13:37:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdzF2HbibGa1VdqKnpSVcaNx//ixTl7+G+t0pHcYO3+OFteQfTA0hJuTMItRdSpZKzwzebtBZ0UQv8wF/B8AuwowwOVmSo6x2Q/LceW9/wJEnTDXHlScCw84WoYb73Kh/oDXAj4jo8Y74HNMq9bEFkFen6QDyTDE06WxOhe+YOqwnh9kY5l5CdHGkBNtXqfVUB/wYH9As0frDhmAabOIwU0Fdx1egjDgcxPBj3JAfqLXD+R5RrfS6d8RcE/8vWYjTRFRV9Qiof1hmaz9Kf+uSScld4v33a9Fl7gA2Ik3zSK72oPSeW61WkjyVWtHmyX99IJVWXRXjapKtdHq2IBB3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O2OhzMImR25xpl/yb2YnHdSNWxT6EXcIg34k10o3tl0=;
 b=PbdrAuLMgjKBwlHHk+k27zG9l4ZepOQ6iBc2+DJG5afdU6uZh8ZATUsliop0IwR6sUC3qtBTiaOZTzi00sN5LVSZ7rkYWeiR4QudWA9gymeMB9mCtwqQdV0ykPbwU3acicqM5flj6akLmrWO8f72qn0haVxjO5+HZTAuFcMP0XRrx35D5AhX8v+TE/clxwZaYLwcZ2m569oyN3Xh2ugoRm1yc2gpP81lzTNyhx9ZlAiyn3NV+yXsUmPMx+YFnj8v6NunfNZ2lmREjXVjArWZRxd+J0E4CR+xpR62OZs04FM7jvKnMGE7wrSPvkSYZz4K4YP8eyJOoGdIhkoNfqtYeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB8264.namprd11.prod.outlook.com (2603:10b6:806:26c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 21:37:56 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169%5]) with mapi id 15.20.7068.025; Wed, 6 Dec 2023
 21:37:55 +0000
Date: Wed, 6 Dec 2023 13:37:53 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, Li Zhijian <lizhijian@fujitsu.com>
Subject: RE: [ndctl PATCH 3/3] test/cxl-region-sysfs.sh: Fix
 cxl-region-sysfs.sh: line 107: [: missing `]'
Message-ID: <6570e9b1524e8_45e0129469@dwillia2-xfh.jf.intel.com.notmuch>
References: <20231123023058.2963551-1-lizhijian@fujitsu.com>
 <20231123023058.2963551-3-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231123023058.2963551-3-lizhijian@fujitsu.com>
X-ClientProxiedBy: MW4PR03CA0150.namprd03.prod.outlook.com
 (2603:10b6:303:8c::35) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB8264:EE_
X-MS-Office365-Filtering-Correlation-Id: 3da26cbc-73d2-493e-e719-08dbf6a39bb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OyUgb7Hx209GQCnp1TRCTRlYgogTlYwcBt46aCR6I+HiwfBjnrf+EUS78Zgk407Fau6gQemGXJ4Fbax7YCUZOPq2Lo6YekQrOmIziKiMTElNNdyi0z7UGWKjqgfFmyOx+qKy3Hm2dLFQNu22uyN4D29ZgU4NKNrSd1WGxqjxm3gqUYmxvvYSMKmopR5Qs5Qq6rEZwJUFKWeji5p1pqZ31xZjDrWxm4WWW8B9nspXfzAzlw5sfVLJ1JmKkuj+JYn/+xqNGbHPaWOBBYjDr2VYC8xnunqgsR3x4d7b1TGyoNf/B52pQdkFDhKqvRRMLgFlQUdJS1gBNBp9cpO1P6FtqfErlUjZBp3O5uAeHd7PkLo6Gzo9h04UsiQK7z/ApqP0TljYryw6cRyn7Hz5msseZMXjDyRsrQE27w2eVs4JgUy2yvTorMcHnSN1TgYCziVuzmGq+w4gMgnhY26Dtd2F09WpMj3CLUd+Psfh5JsPP9wOl/K52Dm+PHTuMvJMdaEdnvjY4l24ZivdxvTDzl56REfUVX7KKHcJcELbm8kTDWuLy6WYeFezKi1HyPplSIv1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(396003)(136003)(39860400002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(478600001)(6512007)(9686003)(8936002)(8676002)(4326008)(66476007)(66946007)(66556008)(38100700002)(316002)(83380400001)(26005)(6486002)(6506007)(82960400001)(2906002)(5660300002)(41300700001)(66899024)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TwWso7gg0j93LjsBbU9yAU2PJuiHgY+TRVs31JiJ8Jo97t3xcKMwuBmLtlxV?=
 =?us-ascii?Q?onIeH5DB9tdhgqGyldaAZw0vCm4wKuaYEP0ykm8Q2RUF+WjHwNoGonsKJkpL?=
 =?us-ascii?Q?uo7onIaxGWYbZuH3FlzUczm8vUhgXbKnoCABH4SU3H4Mg2Tm7Y+FGBQ8Uwyi?=
 =?us-ascii?Q?IX1kVokhOdo201NSY2dQVgRpS+QV3SyYSfx9gJk5iMtQy/dzlWcijv4tB6QV?=
 =?us-ascii?Q?kwVnf0O73ArE7CrJqOKa6cQbzcTIhBwTtN6vJ7TV3QhitqI58GCRFw+i3Qlg?=
 =?us-ascii?Q?ZsfKjQH5hm2f0y8S9rRwdGHpQ7175LncmdEdHcxcPuHqgee9xFYHh/WR6xjE?=
 =?us-ascii?Q?Er6uIKdo1t+q2VwdleXNgKCo/oU9vT7faREKju2cY++OHIbwRKuK7UK7qsU7?=
 =?us-ascii?Q?HehLQtrAnjhp0i+XpJwhBXH1vU421QzWBVGYDEyJY/w3uixfPsAGZvJ0pvzi?=
 =?us-ascii?Q?1bQd8VwRRWJINryhs/OIlR6sRNJnlhvzbrYYV8CQS+U/QZGk6/Adn3Hqaa8j?=
 =?us-ascii?Q?TWS+RYtVVwYoBkE0ovPk1bDlPX/SHbCx1apbFdvw2dOv5i5K5MaynOqjAOxb?=
 =?us-ascii?Q?+N0v/DVyPcJn4UT3UWbh/ojrFyNR+uRmNOLV5IL95QCNuOsW04uUetnarxNZ?=
 =?us-ascii?Q?xS1eFzPSqWsxSxncKJ1Cqt1AXiXxcoOgEEkRMJ3Lu/6l957nH/tPC2eW92OC?=
 =?us-ascii?Q?30SMI+n/ODtYTIkV7T4b+muRqFQZoyrQVUZQxKJLx2DjV6xNitD/rFstwZdU?=
 =?us-ascii?Q?DARJ/cDIR1lcPUNPXeKmj0ig5uHfzsWDzPEJEJUq11HGO+J7qh94CqF4AsJB?=
 =?us-ascii?Q?k6q8zX8Jx5iAyRq/rrSNp+1OdArh+qsJk1IZxP2xoyhBZITqPj/Y2UVthFJc?=
 =?us-ascii?Q?VrTNimnkFfXOW43ImF/+vLd64mf9EJT6MbGDxQ1hhqJYfvUDQQpuUntY0QU1?=
 =?us-ascii?Q?Dig3BxnqLYeU3UcPugMND6q8kSTKCay+a5VGHqgSo0i+NR1yyeV+TDuMYidT?=
 =?us-ascii?Q?8z2/rRpip83yZh/UVzWNXJM8JzMFeoEqM2+8rffY/60U8GweEbb/L9ppFwdn?=
 =?us-ascii?Q?1BOba/q2suJCs1ErCCQNbbhuxFG6n7Au7abL3a8eurbtYPw3SYl4pcj8dNQt?=
 =?us-ascii?Q?k/ZpwFSmN6ngNIuz5+Hok+sFv25NA1O8/uvUcwbUvimurL27ndp4S823lBUa?=
 =?us-ascii?Q?q1JcB534vDP4SEkZKb94ZK3pDtLS0xf4oenmXFlVEVOLTmaIZCtSaYI5KhCQ?=
 =?us-ascii?Q?C0yIobInoRdsGrg/qeIbcyxeQm8IKGYZhEoPtNtbkoUFBZgdA2Yl3BNEjOXg?=
 =?us-ascii?Q?mxNmSeBwwudAWzEePJ/D00eEKwfjbOD66FWDXR96v7vKMX3SyFTTGL8GgfUC?=
 =?us-ascii?Q?IgPp2/tAPbXaIAr6qfxSM19jO25nfl1dsbhnUJmf2bW1dv+J533n89a02xwR?=
 =?us-ascii?Q?ihkbxRUwCQvXl8PeEpr4NkxsO/d727E0H7GR5j7F+e2DjCrTkSYxcz6qsyXA?=
 =?us-ascii?Q?KaKshT5u9oykQ1Rscv+ZtXbB+oaeduQa3C5R1qM3zIphivVxURX01/y0EkAE?=
 =?us-ascii?Q?o0Sh2tN1h2Bxip9Hu6+qT5nR/WBHpegtIENNay7Hs8Uns9uUgVhHQ0N0Fxzd?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3da26cbc-73d2-493e-e719-08dbf6a39bb4
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 21:37:55.6609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KyUaGUah50DZBj+TkjHCPq1EhmErmPWNGyk5jY0lNuW+JYZN1TwMl5A4/tA3QImOdpjn43EDzJcMR2CfNY9RmBqcjYWIp33y2qlkWySd3Xo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8264
X-OriginatorOrg: intel.com

Li Zhijian wrote:
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Please no patches with empty changelogs. Commentary on the impact of the
change is always welcome.

Otherwise change looks good to me, and I wonder why this error is only
triggering now?

Acked-by: Dan Williams <dan.j.williams@intel.com>

> ---
>  test/cxl-region-sysfs.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
> index 89f21a3..3878351 100644
> --- a/test/cxl-region-sysfs.sh
> +++ b/test/cxl-region-sysfs.sh
> @@ -104,7 +104,7 @@ do
>  	iw=$(cat /sys/bus/cxl/devices/$i/interleave_ways)
>  	ig=$(cat /sys/bus/cxl/devices/$i/interleave_granularity)
>  	[ $iw -ne $nr_targets ] && err "$LINENO: decoder: $i iw: $iw targets: $nr_targets"
> -	[ $ig -ne $r_ig] && err "$LINENO: decoder: $i ig: $ig root ig: $r_ig"
> +	[ $ig -ne $r_ig ] && err "$LINENO: decoder: $i ig: $ig root ig: $r_ig"
>  
>  	sz=$(cat /sys/bus/cxl/devices/$i/size)
>  	res=$(cat /sys/bus/cxl/devices/$i/start)
> -- 
> 2.41.0
> 
> 


