Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45CE3714E
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 18:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MHWy6v2i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701109510; x=1732645510;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DZyK8/B7L8PvmTnYLwQe/fNZ3zG6xdLcEaaaYOmwce4=;
  b=MHWy6v2i0zj/RVxd2WE1kOXK8OTVIkjUDwd8wq0QLZP3ouBgc+op2wyb
   1dtg5ZHD3vPBVlRAq7SoCPn+U//KkwPR98q3xi7BgQXQ6w4r2cA4d1FEu
   4wf0PIT6Baic+bSnt2y8R+bytaQ2YtwnhAesNUJioFhSG93rjx7eelSHe
   +ACM3/xAioDZBM4hpiLG+uDpe0dPys+ODdGoIiUYF3yR6G1+VfsIcpZsu
   snJt8mm3ty/hFdDuZgQhTtsw8WBlcPk5XgGGMhlQiP0l+uxS5tuTIYb4C
   LpzFoeno91grKcWMxTju07YdG4HaNAGtHjecOMxugF6/BFUpd1kJddcRH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="391642119"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="391642119"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 10:25:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="772015221"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="772015221"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 10:25:02 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 10:25:02 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 10:25:02 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 10:25:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXw3hg2cWYxwNzhcrrbrgvCBZzoTzkrJMVx8789uFG+9juUYponM0B7scm/Q/QK2MN+vFSSd8daANlpPPY0aDzng9LPOkHUjYUgJ1+dkulmvEbWBbD5iLLCMaErOP1DFq+Bvvrw91GwXDUkGrefoZlKXIuRKuCGx1ZDe/wU3MDYnp8cJfl9C5JKtT5nsMWIaAZD0ncK7AkpbM6RBsG6/dRqZ9vDZBOhM/9j7x7RN2SK2EVEiFbbgTIfNr3dKYOhkMLQiDJw8OfM47ko1Cnx49B74TV3TGG6DiyHb1h9/jm7O6XlPORB1jCswqyCqnFFeueiAlL9h5hKlhKF8+A3Nrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5eF3E78xLUTQO/7Xz//7tWMX1PUAtGkozC1r47QtTQ=;
 b=Uj9gR5YDzij/OXS9+n7tfBqy0Lnb8ZdhwxcTX4EwyT32rRK+ZU6ocTeYdY8GgC+qU7uCiP84xKB7SFidWoCTsWnfGaJtAeKBCgnLmwlqPnwYFbeS5Jzwme8vp/UDbwbzwqJzIGP2RXAUnNHoqHdNShauJ+bvRcqbKqkST8Iv8Gqih8cSz9U6euN9PoC6ys8FRaL6LKni8+dBf6MoMK0xFnf/bPVQM40oT53Zumq+WZHFpbK3vw+PJHeg7c4++ub6iXjdkK6w7PxyoWnPe1a8HbVYBnjomsteVYqZN4ynaPTeZAb/GBbMVbAISLvn33IMgG4A0D3+qAQ360wl2FkW1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM4PR11MB8157.namprd11.prod.outlook.com (2603:10b6:8:187::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Mon, 27 Nov
 2023 18:25:00 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::d3b2:2f2:701e:e8c7]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::d3b2:2f2:701e:e8c7%5]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 18:24:59 +0000
Date: Mon, 27 Nov 2023 10:24:57 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>, Dave Jiang <dave.jiang@intel.com>
CC: Yi Zhang <yi.zhang@redhat.com>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <vishal.l.verma@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH] ndtest: fix typo class_regster -> class_register
Message-ID: <6564def948512_56b3529472@iweiny-mobl.notmuch>
References: <20231127040026.362729-1-yi.zhang@redhat.com>
 <8d6fd371-e664-47ab-b8fe-c7d8d0137b4a@intel.com>
 <2023112729-aids-drainable-5744@gregkh>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2023112729-aids-drainable-5744@gregkh>
X-ClientProxiedBy: SJ0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::23) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM4PR11MB8157:EE_
X-MS-Office365-Filtering-Correlation-Id: aa4bfb3f-8047-48c0-3d69-08dbef762a3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lZAIAeta7bjmeVbGohqj6MOl626q67KCAzeCO+LXeVRVp3btok2oKKYAjyoFGSRORWfSbLiH+ufZbsytR245AxcuRvRs/Z79iklaexf4Mz3CL6ixZOj6+7lrK7/5PI9gqD+JCAEczDZCrki+a3FQ20ecWLde8HVKaMlIfWXPkrRwsg22dG6gigtf5psVsdmh5DRtBjD/dj3xBBIph8N1oBRaHn9Av3G89qYyg0bLoXnO5PCRKHS1NeWr5tKTA27jXN6hlhryXz0+6UwiI2cQaosv9l2rUB6v4zTzbKSWJcVk5juM4VGsFinHgImnWQJ25BP5jHaE77nzqVa9MDHbjLEQJOg8P6P5yUDbyyOfssdrZSTzrMWHq6tT14eFD7xsTnWfO+JgNxL46k6YMV0nnaypuE1ssOmFE9/pYA5IW+uGzz30M1v7mqAk38LGkjq7hluQ85blBIKTsQ0GkOXUzyttqCYb/ctY8Q3CYDL1K2w6QYXV3vIEnyefD8JU/Jqwg8K86IMzB1INl+l1QqnunDuT5T5kO/ok2rT/dRv3fGAn8oZErIj4acYC0XbvFuVQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(376002)(136003)(39860400002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(107886003)(26005)(6506007)(6512007)(9686003)(82960400001)(4326008)(8936002)(8676002)(5660300002)(44832011)(86362001)(478600001)(6486002)(110136005)(66946007)(66556008)(316002)(6636002)(66476007)(38100700002)(41300700001)(2906002)(558084003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/LwM6WhadjfyRO79fp0KJgbtofkBxgDO48TDUT/a1PAqodjYIB4yTN5e45R0?=
 =?us-ascii?Q?Y5GmVZhcgy03FsU7Oan0JV/bINnByaGfo/zWx3zb6b8NXa7oy2y4i37kn45d?=
 =?us-ascii?Q?z4qULQferurKf0U9bfpEAqHTJJ5iTJdShL75RSHzArA9DwTtGqybx/kYl4g2?=
 =?us-ascii?Q?r7IN+65aYqutUZCN8DttNOwBEMHl1TAgWMVKfRDg3aSWkmjyF3xeMyAEbW8W?=
 =?us-ascii?Q?JZor+9+0Rz8VNEIN4Fc6R9QZGVNj7FYqzzwDR11Yk1yBEjmZr1G0yxsRyeJQ?=
 =?us-ascii?Q?V9LKuovZuBL6bOzIqm2Aeptg6UWD6bvn1UxmrwnN33+qxP101Fyb7vgkH92t?=
 =?us-ascii?Q?uT0W+cPSt/Wa1e07zt0k0XRlmoVReDXOc5AbaXWt3xp3gw56v9uVpz4ul+6m?=
 =?us-ascii?Q?Z0xN0I4WW9EQ6Q6losvnuyZST4QPq/PJfA3guMNTdGcdtCAEhbMPrlBIkRER?=
 =?us-ascii?Q?hPPRjEPZ1zzlpYOak49LWq/DVwbewaZAn1yOcDtuEqek1C0Ssbqo1Hno+N4H?=
 =?us-ascii?Q?aMYmjkzni4jrFu9RxIc1wA0vYs6+vb4kyIUSEiqL/jDFfjeOAt4RPGN7fyJp?=
 =?us-ascii?Q?Z1Oyyn7fivetMNab186fLYEQ73z3zjsyoPOeucvTwzNSX79WirSuNbHMN/yR?=
 =?us-ascii?Q?jmPPet6fIfJ85HdTvjfffW5jbFxD3ubeupnlhm4fkfp6vIzmnwkX1Mjmhube?=
 =?us-ascii?Q?i3jlL6yHy1DHqOERs5v7bBUYNmJI4JZy+G5Z+iemXBlge3tClK5KiEt8+Tdm?=
 =?us-ascii?Q?7+5v+EMjahWO4tgbRGqVbjhvG2QXlCzmYg7tk1i4ArRC2lBpSSewYiToG3Yb?=
 =?us-ascii?Q?tF84l7FYxQLNIsB9mnd5987uyPJW1lN7RwG0XEOyEA5jZ4gqNd/wp5qqRdf6?=
 =?us-ascii?Q?t3lYYJ/DsO+wV6qvDqrrtp8/i+dw7QPcj5zMWG6yLBAVWu+cxJTfwN0iDsrc?=
 =?us-ascii?Q?ydOsn+60KNz7v72HeBh2rRylql9a6qJI1h87GaiFI9Kgj30nPVaK+y580TTN?=
 =?us-ascii?Q?kQUaW/ZYmnKstwwmDBycZ1g4p7azXP36WVczywijJhEq+5YDy+kkrTtjfcjt?=
 =?us-ascii?Q?2ZKs2JOPumLd6sA5Xkqt1f0FR8lFVxxvWmzfEUfyLvJW8XzbP1pMlSt0+jJK?=
 =?us-ascii?Q?PBbTmRliC0qLn/NQddn1H6i/G4Eq5tlfWdOR/orH/u0bdNbXBJqeX3n/rVnI?=
 =?us-ascii?Q?UKkzxmE9nkBEttzghzKhJp9yzGTbeuftPrvV0xash0GNHoiWn74YN+7vyG9V?=
 =?us-ascii?Q?YCTUiCG3BskNNCuGSOATTSTwzu4iQ6KGm4c8yDd5U4g2l4FZktNczILNanYy?=
 =?us-ascii?Q?qOExNS70E5tgvps8Fk14XmkdPXj4MuHgE5vwiEYj4B27Q5Uz0xyDxX9hwX1Z?=
 =?us-ascii?Q?5eQovfwDykZfweNwfxjhtURaCX4UJJD9q9cauW4VvxJrdZoml7ES991nYpCg?=
 =?us-ascii?Q?sRmUPbdVVgZhAzVdXjupGjKZFE9bH/6afSjI8tmhISNiPpkFwhSQPJhws+aY?=
 =?us-ascii?Q?9znn1lwIWJGHuhOaPyML4RAuqP5RAq6FOCtZsAok424m+vD1mIiiltV2IOVC?=
 =?us-ascii?Q?cDrSydoByBUyGt4166BdJjXGA9c9Xqz8j1IQFnP8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4bfb3f-8047-48c0-3d69-08dbef762a3f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 18:24:59.8359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7EfEpFe8OPzGC+y6qtX20ptK5C0ag1q5WF1e/LOIQjSNq9ezuur12hGea/85Z/Le6IUL+49U9qS+mhqusV/ZQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8157
X-OriginatorOrg: intel.com

Greg KH wrote:
> On Mon, Nov 27, 2023 at 10:00:14AM -0700, Dave Jiang wrote:
> > 
> > 

[snip]

> Ick, sorry about that, obviously this test isn't actually built by any
> bots :(

Indeed.  I'm looking through the tests I ran now.

> 
> I'll go queue this up now,

Thanks,
Ira
