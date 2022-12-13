Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F85279C9
	for <nvdimm@lists.linux.dev>; Tue, 13 Dec 2022 19:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670958592; x=1702494592;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=V4AAV6ziyGFSXzNTGwMe4/a3bkmezIiAyGqOXz+/51M=;
  b=n2gfczR1HGXgGDWGKk4n28SNc09sfZh7yaVMGwF4GlRQUKVYEOMA8S0t
   9KQqJ8SeDOG3IDVbzJBoOqqLSWbYR/n7D2dCANMVe1RAl3ytunleNDdp8
   V81F1T/s6NWZNPiQ4c+C0U6rpyOsbiAJ0lt5Q67TGLtLucPePNU21lXGX
   KfwFxIx8fGgSbcdrnJURGsKCl//fb7kSd//A3AgXfPDfeinDkLACOaYh1
   vVcHAV3bMzZme2ZqEKlOSPXYH9wHZgOnHZAo4dZJSjzB31eSIquueEI2z
   ovNpMsvAxEXSh4F9yIYWDvBRPUyCNzscyxhsmXkXg0Ztg5pkxJ1iZWYjn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="316921639"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="316921639"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 11:09:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="791031659"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="791031659"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2022 11:09:29 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 11:09:28 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 11:09:28 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 13 Dec 2022 11:09:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mw1y+1nfzJRutpT/HYOGXQlqyD6vwZ6YGB3/JIGP5DBx8lkcic+OTfnNPWQO0RgjUmOnkFJjD46TQixaddbR0Z6hJTMVUO5MjyiR4r4zTfzkeARv4x75MEZ812EufSvcaA0teO6ZQDju4VAHL/rb1Ve3O0ghTE69ZP4tdtNzpNv120Oxjv267oBFCHUMqIuLwDJ0UTtjGZZJ9qiUDQ2JfF5gzcRnZc+X2e2QNCqegWtCoPY+pCYhhjdXtyrbdkxyDWOMSNhDjUmyZeqHzayoK+VA6nDuld6CBfb8yW4d6oOPjLWc4UjH6tQAraElT4TPofcjRNlYJ/gjfpnQZqIJ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7toDxHKhhowyHfEkkwKzngORQdz9kh+3vbx04h3V14=;
 b=BM/nje17aAr+iD7iWC4YUTh21yfQd6TXqykNiime5qxyRjdR+pdNaHMUhJZU3CiTV9H9ub6WRMcHVdJ2wwviXEi7yOiH+u5Ocmy+aP02NHjR/1GO3V1xkfSFHTxpsYUDvcN1hhcQ5nu1XQIHWsRgY8j0oETZ4AeG+1u+we7C7RUK/tOXdoCOwv6ojSaeH1vjfFZQTxrxhdoKCOlFx/EIDE3W+o4f4isj020l1Y7dVgaKh5k8hf8a7nzsNWbNMdWbsRTgS4g4XqnJ6uura8cmVeAqmC91sNlQm6xOKTV5n079m+xjoPG7b/JhT/iw68S9pnk9E2AfP4T6HMYfoN/eBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SA0PR11MB4624.namprd11.prod.outlook.com
 (2603:10b6:806:98::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 19:09:26 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 19:09:26 +0000
Date: Tue, 13 Dec 2022 11:09:23 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, <kernel@pengutronix.de>
Subject: RE: [PATCH] tools/testing/nvdimm: Drop empty platform remove function
Message-ID: <6398cde3808c6_b05d1294c4@dwillia2-xfh.jf.intel.com.notmuch>
References: <20221213100512.599548-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221213100512.599548-1-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SA0PR11MB4624:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f1dc01b-6db9-4c31-d896-08dadd3d8d1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qUQJB86KwNRbvu+Vxiu/8VNbVOgY9zf6tVWMo5wy01emfsDauMA12/HAnAg1thAiJy58Fg9pl+pnai4lvWCvx2iQ91h3/DHZeIi50+CN1R/89X6diO6ne8kX8kskcXTsTa4Sdm557ZHiXc/sr1fh9kXMhFvDGndTC3qyx1rH9B7ymaqU3veBBC1X+iTttJT1r2a34Sw/4eNaPPxTTmLI1qoiIsFAqpXf9UKAcS1b0w3yO3f7FA74PE1YslhZstQaAJt8pjE+gxUgUuR+ZzNukqhYFgBBUJcl7659GrMMZc34KM50M0PUJ2ShbFsG3j+mchyaWpAJQE2D8NdW+gi0usOuIGD4qdFFW0qfyp8KbzEdSZ+BurTMWxXWqwR4lCx82yleWIddBtIYV56TYpVyksSybDMbYO/vYpnLUpRb3USgofFgwQeQAKMDt4kbQNvxQAS8eZevj7lIA0AD8wdSSEHb5pPGroLodNSJ62PEfFUvgZvlSO7jT++2BXJ8PgGY7iL87VYEhQcdIkQB+HLrNJwRr7GU9fw1VmMQqmc5ziDyRGYt9+Cl0Wkjkz/7AL3MmaDU53PW2yQ3nYYp/+oDsw3Wt/aZKVBOslEoGAUMshMGwdQUG7iVQYC5rAt6lukZgi7ruHdUcl/p/d5uUueb+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(316002)(558084003)(26005)(2906002)(6636002)(6666004)(110136005)(186003)(66946007)(6512007)(478600001)(8936002)(9686003)(6486002)(38100700002)(82960400001)(5660300002)(86362001)(66556008)(8676002)(4326008)(41300700001)(66476007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?VNvyVxGUEtIiK9NZ3VkIz4fU90TERgGJG8J9nbz83YFXEfwL3+1g7K2PGd?=
 =?iso-8859-1?Q?5hSoTV4vZmJN65tg6D+HP7PAwd9dyzkPcAlB2hvP1uJFSMoJUkHgFFTVeM?=
 =?iso-8859-1?Q?2x0kW46TN+ovn8LvMPww6krj3upWSeMv9Lqz2KJlNnh2POEJv8UUGGyKdL?=
 =?iso-8859-1?Q?pxQbX3UJ2ylCdpdzQ/7QeEcak2lXXXqDXXpehWHUtdkj3h+k/ZL+4mvXpd?=
 =?iso-8859-1?Q?Nx8Ogc1ycLw5A+1y20KdW8kHMh78lG+xNKGWIGQBI01zA+6JRhrX4710k3?=
 =?iso-8859-1?Q?g41tu02dsUxL7VQenVImeHJ82SbvNmI4qXzsb948abD0fqGSb0hlmA/+e3?=
 =?iso-8859-1?Q?FyVKj5zyiW71EvRFcyl4+DpYYCqGDGVQ3UwPkT/62fghPcs/zyXUT08ebX?=
 =?iso-8859-1?Q?ziqG1q5u6PZjcEZRKllZ8HRC0DWv4HvS6LJyJHUrPapJWmatADIkBTRDba?=
 =?iso-8859-1?Q?9FyyjwR8cH2JcJTBcDPex4uvpnzYE7C1JKiqway4UGU/vihT+Rz9JkAG9F?=
 =?iso-8859-1?Q?2s43usSx57mP0xiWP6GhDQDaaPI9yJEEDsHaCuATnSYiI3Q5VXkpj4loV8?=
 =?iso-8859-1?Q?7JuqUjGjcyarwJi/OEsz+AcgAFZXWgT3rLxNnU3u4ICxKh3/4SyoUuf3hW?=
 =?iso-8859-1?Q?8craHrnD+NIWUV8HK97OUyMpIUeDCpCigHQuMExoZ14+utqnZSpG4PLnGB?=
 =?iso-8859-1?Q?C9LWYlCcx31RYcOeiaU3jlEkVhfjI4Qx4ODud+pJW5Gv7TYeYx5MGGKWT5?=
 =?iso-8859-1?Q?Zev0R8J37dufdkzY7S30xvRuOXSG0FFdWONnEgjDGiaOzsyDUExv7CBb+p?=
 =?iso-8859-1?Q?If2s3ykV+fuJzy10m0n1pN47F8fgIOaRt32t1jbl7rEW/OBKgec+ymHkKd?=
 =?iso-8859-1?Q?YX/IbGrECLl1s4bkrpvj3mUszgVePqQS7s5ozoqf2kcxXKNsQ6pOw0bJW3?=
 =?iso-8859-1?Q?671XZm40sxH1y8ZCG0Gx9UEdZqOr48ZDNyZ+jEu9JJxJckf4DaiMjRbZXx?=
 =?iso-8859-1?Q?iRGIrVKiFYv5PjmINyKe65lIemxpxhbyQZ9LcJcF9eUTWz9Auaw9xViQxn?=
 =?iso-8859-1?Q?LQ9bkJAwGuciuCQl0FmeiL6rFh3UFIXYl7yeygi30RBEP3ZDsTETDimnqv?=
 =?iso-8859-1?Q?INxXgKgpUbjcUVsZ+nOBfUp+ASJ5DSmTKhtJcEa/pW1DM/rYzlj7ErO9A1?=
 =?iso-8859-1?Q?u9S+RfEo3hokBuoA5RqUvwEAPs9m11yeCIr5PuHPp4RgFSWcr4veu6+cbI?=
 =?iso-8859-1?Q?NsLI/q0yi2ZV9hVy0i78bAEedCh2T2TKDBolWG+V/fdX223E8OWzBGkoY5?=
 =?iso-8859-1?Q?GZlf2y0hiymzCcVtaqz2SsHiQ9IDj4AxOawrzLQlp4TOIrYtX16bhRbISm?=
 =?iso-8859-1?Q?0wtQSBzFMki+QRky8KAimeWig42iUYpUKVGFkDtxPOa6e5nLe4yeqxuWA1?=
 =?iso-8859-1?Q?ewMKWqhY+ck6zROKoZKBgTvcRlGHkqPUDNGhw+nw3Ga7g5SSry7aekKYZa?=
 =?iso-8859-1?Q?yQpqqNQ5k6yEUiH6dyM4Z8Cl7JKjJ5PaS35pRQ9X3LFBakUYrMYPoBcphk?=
 =?iso-8859-1?Q?eQ933fdmHMs2jryUK+hDn5+LokIGP4jJa68q4Xno2VMXB/bs5gwPoUZDUK?=
 =?iso-8859-1?Q?IX2aqiwvgXnuz5IbMWV7Nwrf+SIUERBX1MZxykZ9Nfok+y+btHE6xA6w?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f1dc01b-6db9-4c31-d896-08dadd3d8d1f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 19:09:26.4107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 54tEKv0jq+3nJP91nqJAW472eNpLKfYgEOvYgmSW4qdaqR5U8JsTU07VGVARUoIDNpFBWAK8RS+9n+arH/P3gChqQ8UgtrKOHI1vkUp1gRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4624
X-OriginatorOrg: intel.com

Uwe Kleine-König wrote:
> A remove callback just returning 0 is equivalent to no remove callback
> at all. So drop the useless function.

Looks good, applied to my for-6.3/misc branch for now.
