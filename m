Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE7010E5
	for <nvdimm@lists.linux.dev>; Fri,  2 Sep 2022 03:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662088960; x=1693624960;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DTZMHpyqzfwAJU8A6VJKe4MMTGWm/vcbl9FNfwnsHgU=;
  b=ESc6rmfMTimz97aV5GDHnThLyQdXeminTF1Ct+2r2E6cFDqJUETVvJ6x
   lDrwdFS5afvnLBGS2ul8KaYDa7axsVQloNguOAIEf97GRHQsBfGOpuUzU
   IuimuE/N4b+Xij0myIkuoeL2CbvtvH4LKtKNA7NIKBYHtezcVwibwcraF
   pqeJRWRuHnjrYlqTJKwralU97sdHvZx6wJDY2dVsVFzauem9Ct7z0Y9FS
   GS+urcj+x6leJAv/PKpZi0o0cnXgJ+b8CFRGPeru5c1w0ntrmJ8sQIRRe
   I8egwvkriHCNWGn7vM2IpaSpl9VF/4pQslf1TA54iFTf/LnJZQ4cQN4Bc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="357600441"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="357600441"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 20:22:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="858091356"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 01 Sep 2022 20:22:18 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 20:21:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 20:21:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 20:21:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7u51DELsAkL3CHMqs1GH7V2yyM3hQrIFXTkDRfzY+GTHTwAKmo0BOx7Eg4BkSEbmSAdWh1YumS12Hh+w1ar7ToK4qz7aWaaLSHFKnIq+UanNGfjVSTfT5lO3eJhM5tdeLYbezfi4KCeKskRr7VUxUMpZuG4fX4lATrgZvoTbvcY/OzOiCtLwmsvZabhbnswUCjaTw8AqxbZVJ7VUCpUo47ryk4J8C39gGcdS0NuqZoaGkzSFrNL1qd5u07SfFjnw71wHXb8etOAzG28zpGXiFxOvxNxdkDv5V2cfczkReTHblsG++yOLXpAu+O91VjtbU0HosDjO0vv0J0Ux+5gHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i1LdiNe0u2srYIJMV9fgixQf5EdqItxKQTmsSCfsgzw=;
 b=mHhkkNQrEB36MBurGr1Kz8HgsIjbP47ULIp7nTsP9cFyg0gC34cASPuGnpNIpBszaxE1iCi4xXSkqO0GLmjltENV2HAbV/imbaUFUH6EdkOYwBawVt/gxpLjrds69Q9+8pB1l73RennZvOP25nGC5Y/pWxwqtyNRMeaH52ZlZTNclssnavEqzXGIX/b9a4QwV1BolLTE4mGjQlFlOVh+vLG4lszaMU+TZ5Tmw3jOGHmPr2M05ZcBkX1G5UalkiMQ17K7gbo83KiOFw//0IT1/HW6hmavPJ2/O6iBIkF352xQQ2PtK3pi5fTap25UW4DsT8wfMpHGRHNkjiFRA3mPKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by MN2PR11MB3933.namprd11.prod.outlook.com (2603:10b6:208:13d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 2 Sep
 2022 03:21:57 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::2896:319b:82a1:a4d0]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::2896:319b:82a1:a4d0%6]) with mapi id 15.20.5588.012; Fri, 2 Sep 2022
 03:21:56 +0000
Date: Thu, 1 Sep 2022 20:21:52 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: <cgel.zte@gmail.com>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>, ye xingchen
	<ye.xingchen@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] nvdimm/namespace:Use the function
 kobj_to_dev()
Message-ID: <YxF20Lh9yG6NQc7u@iweiny-mobl>
References: <20220811013106.15947-1-ye.xingchen@zte.com.cn>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220811013106.15947-1-ye.xingchen@zte.com.cn>
X-ClientProxiedBy: SJ0PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::14) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07c83aa9-56fc-4ec6-95db-08da8c924a5d
X-MS-TrafficTypeDiagnostic: MN2PR11MB3933:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SP31rloig+2CsD+Qxpo+7xdOrwjMHFB3vDUgphnurGWvWZ28tfr74QNq0vwQQeQDrn0JXTJJvYXE0l3bebM83nt82l7E9UM1cyDfhuX5xtpufntDnPk2Nd7SnLbtI+t3b0wZUOJK9yCypfs5WFWlVvWupQPcLH0rdvHRrKNo5Ct83g2JnZ93TPXTFaqy2tx/NU3TzNjXshGLQVVvYY/fZLuErm5kpvYLU7YQO7oT+pwLWD/GffXYiVU90OEkTnOF37i5f8qEJ9JIlemvcZ5nMoiigBcFrHY744bciEgous/khXwIbBm5Cn/y4Pm/adjhfnA0BxXvfdVpx2ilh+i8TsGMV2/FkCPJahYzHYuAzToP4EEzdgcNR0b3b2eWDdQKDod5+hwf2rkiz2kuG7zycUYuQX7lfwY2I+UbnGEHg2NvJbxtqnkEHcYFrVD7b6KR4pmGzf32LArMB9YgxGlP6av0ai1PTZ2mh9apxiiMvevC4mjw0zBpwIOQX1wSlYZd3+D5ofcISwoQY1sbeqTfIUoLqyAiW7ibUwKDLyzRmId4fR19dSB+LvzXi+Cqm4uZ3Gh05bmtu+fVmNv7kh6ttelAD3IddlmbJQcGXCnFx2/VBvO3Rxb1Yxm/oOSEgzgCF58Y2ZOeEVJE7Aysyi4aoKe0b183MN7CbSS2SGJBVX2MvIB7eOy4aYeo9bAVTB0Q7E2/fzIawjjX0JDvOUZ/4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(366004)(136003)(346002)(376002)(39860400002)(316002)(66556008)(66476007)(478600001)(54906003)(6916009)(33716001)(82960400001)(8676002)(66946007)(4326008)(6486002)(38100700002)(8936002)(41300700001)(5660300002)(83380400001)(2906002)(6506007)(6666004)(86362001)(26005)(9686003)(6512007)(44832011)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C+YlqCUoJJJdGqJ/96uQ3FIUZ9ed09OF1odE2hpuwGYcbOD9MMdC9RaEstXo?=
 =?us-ascii?Q?aZcTPc7lnpBOdPu9KssDA1SbMCjNYrjJGKQhTwr2/Cvmt4WGd08YH4XmyYan?=
 =?us-ascii?Q?x3WPknl9Zuta/qhS3CoWlA7o+FLsB4LH6ax242vdpG0HuhDMuy/U6qb4gmLH?=
 =?us-ascii?Q?HeCCj/5dW+94s8Jc6yxDCGymtyyfWS2v7X4zvGPZuBTxvJ86BmJr/HtjHsxq?=
 =?us-ascii?Q?AGM06sfoDzrws9uf6Sgs7+HNvvl5HEaphiNV2lldT4aaZh4YNnODh+0wrgud?=
 =?us-ascii?Q?ni8j6qKVQNfSDXE/F/CDF+YmG+7IDewyjUPa389e+MkjYI4hDmqLSDiAKhhD?=
 =?us-ascii?Q?U7Ff5GQqZedGSIDy4vl6ea30fS5ruwcfBxre7cb+Z05567g663mWWAoOlkSh?=
 =?us-ascii?Q?jF8UELxDSnn/cuXEX8ml8QafhAW1fu/9xQcIdu7nduczkm7kFzZ5TmPAdunf?=
 =?us-ascii?Q?1Uh3ABumpbnCuLJJbMqsC+S9qLK8huzwruD59Y7DwZD4nsyd24NvRFt6Vm1q?=
 =?us-ascii?Q?VZoL8gEiPCraFwStOxLi79BDhjH+1A776gfmB2l6kmz+X2+9wf5wS6Qi98Ob?=
 =?us-ascii?Q?pIFo6p8zs2AWM+CnxbSU3ZKoTrBUq/D9sdy/cgqCPAiARtDviyhhW0j9W+xA?=
 =?us-ascii?Q?E8apoaGYw51SMuUIIrDivyEDD6utVK/DF7pCdFc5EcfryYjLzt5sJld0Q0q3?=
 =?us-ascii?Q?MqYvBuYNdsdvkdD2+26FGp4QHXLfCeXVRYEhs3bo1H5DjRYL+ebQk13IOT4p?=
 =?us-ascii?Q?0i96Is53b5jwzezjUx2AijvDIMXUW7Hn5GnYjufX8WuGXhz9R5Inaqud5CDs?=
 =?us-ascii?Q?VZqRZ00P9uMAhrI/nJT1R2TRmc7ZWlmGccp2rcj8GOUD1uGeAw/KnYUFqPa1?=
 =?us-ascii?Q?TLq3gxYXasmjrtnlKRceKVImk2337JuO3mU3Aknn585c7dqlWTq7cYWLP/kP?=
 =?us-ascii?Q?2twgd7YcbaT+MpIRzOcnngx2iRRt9x5/LxW9aaFVxBJAGKLluAr5d52sTK6f?=
 =?us-ascii?Q?Y2WSGTUHbMrsLsLWD9oYNhcHqm1f+G+xLQATdfActwiwtkY/pRiwBFT6WpbD?=
 =?us-ascii?Q?IqGKR3c11mYHeIkuMl0nwZS913VE42d1POygmXEXV1aDTCEbpHadDjHeQ4gT?=
 =?us-ascii?Q?dz7QQ/dzycZcek+twA+EnnNVCsys64RfgBywsL+9NcStItMWgScOyoN0xJh3?=
 =?us-ascii?Q?R4Syy1GrapCubBSdB52HrkQym5SPITQQ5lKrsgiqRvxgbzBxt7atkQSqYQ2W?=
 =?us-ascii?Q?3Qz7liLWmfCF7awfTEN92Q8UQd7FABzvrUa/VWp3/2wV6jANsqYLoTZPdbj5?=
 =?us-ascii?Q?SZOTFFrmLsi1NxiQNQF20MUeHltv7pFR+g3KziObmXkcKsAPwaOl/qhe4IsS?=
 =?us-ascii?Q?Rf8nZDVHrj+w8gR6sx27ByPx68cQq4p0om7UQRXLCBNhdot9vFC5STjJfBE6?=
 =?us-ascii?Q?nJdyQlgHul5q5wCSNF8QUIq1fCIZEPa6vMZ7MilL+CSMwD8T6o6Bi9ikIY9v?=
 =?us-ascii?Q?kQTN8Q1DuvbfuPTOrjNzgXbHSf/QgxqvhdoYULfITmpgx1scDEuX8s2Km948?=
 =?us-ascii?Q?39kCoccbCPyEfvIr+xzgS/okMw66bquGlvdJcQTr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c83aa9-56fc-4ec6-95db-08da8c924a5d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 03:21:56.8826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L8h3aZSBH4gX4/ERiCq5++UdD5Y8BsOpnaJVLMoVbLSRzn85RJpFnPTyHwBJnZDiFRh5wK1QnZqTERuEI9QgJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3933
X-OriginatorOrg: intel.com

On Thu, Aug 11, 2022 at 01:31:06AM +0000, cgel.zte@gmail.com wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Use kobj_to_dev() instead of open-coding it.

I see at least 5 other places where this pattern applies in drivers/nvdimm.  Is
this some general conversion being done on the entire kernel?  If so why not
convert entire drivers at a time?

Ira

> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
>  drivers/nvdimm/namespace_devs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index dfade66bab73..fd2e8ca67001 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1372,7 +1372,7 @@ static struct attribute *nd_namespace_attributes[] = {
>  static umode_t namespace_visible(struct kobject *kobj,
>  		struct attribute *a, int n)
>  {
> -	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct device *dev = kobj_to_dev(kobj);
>  
>  	if (is_namespace_pmem(dev)) {
>  		if (a == &dev_attr_size.attr)
> -- 
> 2.25.1
