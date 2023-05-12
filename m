Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525F423D4B
	for <nvdimm@lists.linux.dev>; Fri, 12 May 2023 18:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683917658; x=1715453658;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=a8ap/L2GZ0TJhocFVj9MSVddp0U/CDi0GwMhbjUl83s=;
  b=j4JUw9/aPEY4r1IwPmqQkz/YCm2qmf0AMTvGRqq8u/T8F4mj3nGjNsWv
   tpQX7lxyQss0BdYFf4cRN997m8vl9SFgAtKI7/G5LyPTFmaqyup6/3Huo
   MzujT5ICMLjLJBlhYep5isOYXm2nbHSdt/IvX3mFOw/qZshwf6JWlvFvY
   j2EhN2hKhZXfmtiFtzxKm+IcrErB8Zn6Z0XC8J7Z7t/9yyMSFvZDgSPb9
   2vNneSXX7AuZ3zoYXzN0ArsLJExKo4WfN9TwL70U0XjyMlSAQ5GOGmoUT
   LQxpqLY76QqW/TgSSLY9S19ERIxSqWLkRToK9PN2ItzlEM1duDQjuSkZb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="348357051"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="348357051"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 11:54:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="730915119"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="730915119"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 12 May 2023 11:54:17 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 11:54:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 11:54:16 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 11:54:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OI6kbiSD5gD6D9dxyYDiOGeHTN+77aX/Zx4Ey2uCoXUmnPIRQ+6AnkI87ArSJ4ITBp6CErme6w1eXj27i1pJ9gbTbVRhizaMYJ3bNcha3vxTuK8M9Vunu39qC0xPxwZeQz0j1+Mboq+21A9LyXwLiZmYwS0FRFWuQfiBkAmdah/uV9ZURpXV95N1Yd6nMEMv7TMVyhkhyUD3Ym/23kjyeOZk5KaJSH04s9vcfmh76wdKhhJwTjbW6jWOQFOIyMWGtaPTLG17mFyOLwr0D26NMmaLTFkdCyzIYr19U3fuvtLmxuRbIHEApJqHgHxNwx8YoaGvZc6w1zWn8IKZ51cVkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pTDEeqpV3EH8DMySGhokc/suqO+IwEeg+sR5sbPyyGg=;
 b=TnJ8GLshHB99tDLb6udRSvanu0zRcCjXiAiZ21z32yTw1lJnPwU4E/ee2RlRJB3HhCwlZtQ6guebApFMAc6bbbsnCE/xSeIcsnAg1v/7TF8Ek5MND+fYtrj77hnmGf97POpHER3Nlmgj3rCNUk1qdNg621uhKj7tPNhWWpPFOeWuTk/qqcbap2wjmgi7FICJDflPYbUUq1aJpiNooPTRZPBDElWIebAUN0SjQTQteXNKkNZV5aLmEmKfKAYTAt4ATVmTMRkXwkieVlCA+lBP6slZxWWiFniIGFARJoIh7p0R2JcBAgLiqC/jgo3LS03LYFwjgqjvWl3pixnzJid3kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH3PR11MB8240.namprd11.prod.outlook.com (2603:10b6:610:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Fri, 12 May
 2023 18:54:05 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::95c6:c77e:733b:eee5]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::95c6:c77e:733b:eee5%7]) with mapi id 15.20.6387.022; Fri, 12 May 2023
 18:54:04 +0000
Date: Fri, 12 May 2023 11:54:01 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Chaitanya Kulkarni <kch@nvidia.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: RE: [PATCH 1/1] pmem: allow user to set QUEUE_FLAG_NOWAIT
Message-ID: <645e8b49ca74f_1e6f29437@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230512104302.8527-1-kch@nvidia.com>
 <20230512104302.8527-2-kch@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230512104302.8527-2-kch@nvidia.com>
X-ClientProxiedBy: SJ0PR13CA0065.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::10) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH3PR11MB8240:EE_
X-MS-Office365-Filtering-Correlation-Id: 21d3bb46-6e1f-4cad-843c-08db531a4190
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TQscndW71UplXezOeg6IdWTwVqSaIm0a/WS/2/+IMXYuxiE0fG4g+4d/JKYYX9z7kdKaoWExxclmCw9sZgIZuvEu21Xobji8MK/6UY+jG4Jc9Q9p9nHp2Xm3hvFVrqK3pGK8OfVwzWhSsFqqjuA1HIVV63/CugyHL28rEtj5DsyOBca0rQraxK4lALLwWlm0NhsrWoX5ufj3yAdaU+M4Mt3unXW51/t7r0yIUcpUZIGW0XSLD+WD2AbjLZL4gaTr69RmNQzDnLcUoJ9QZmVYa1WPaSG4Zwio2Bhn2yVUeLR8mJ2hRxKI8Z5+IVqZPbVZJWtfY77E4lQd6u6NO5p+dGVti14X5GdilCHmuJzBdpmRmHaONtc7dH/JNq30u6ZqZofC2dF835RdwVlVJ6JlpU34n45fd9goQsG5CyTNcvp1nwA4c2PuqQ38Z/ZN6oFJiX7lXpD65l4vBd24uyRdjA3Ls6LsDtpCpFurnDgGK1LdZ3CT+V/hOEV1AdLDKJqgs3CL4FfSYwkByL8VhX1sPcDrJpiNFtJF9AMeVtHqj9JrpqsVbHdVtqE/oP6z9JtE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(39860400002)(366004)(396003)(451199021)(86362001)(26005)(6512007)(186003)(6506007)(82960400001)(316002)(66476007)(41300700001)(6636002)(66556008)(66946007)(4326008)(5660300002)(83380400001)(9686003)(38100700002)(8936002)(8676002)(478600001)(6486002)(6666004)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1vSLaqvhN9V4JfL8mntIPTndNr2uDu+1VGy1psd97M65IbVFlYhlu+pqR9xc?=
 =?us-ascii?Q?WGlH3nEz5jO11PxcyFuji+LKtqqyUo8eKbbIdtR5itfkoGHcz1qFrXtlgCd0?=
 =?us-ascii?Q?CGcXB2xWkt3CvndaKHefm2jem+gsBa9iKw+49gwR+jQNk5XuYtv9Ih6D4Nvm?=
 =?us-ascii?Q?lAvvqwyG213anUAqG5PMRs2JboQ/0yBzeRQ0/9cMKonjIrOYIrcuhJPHnxaA?=
 =?us-ascii?Q?fGhdoQGJammI6vjS6V5oC90ZMmoZILA0l0uMGFNuQwkfbZNRN/s14f3y2xFf?=
 =?us-ascii?Q?ksAPQYGqRdId83VFJSphWsqGWGjd1jhiZ/Gx75M8+RSG+ymEAEtprJ8PrF+O?=
 =?us-ascii?Q?+9uuj4VnseP+6VNal7UF9+HqoMbtnG+DjSzz9KB0B+QbFc6gyPrB4m4A+zWL?=
 =?us-ascii?Q?H/8JjMqGInd0/veq2XZQHZIBcJsQHTglZsp9XQZvIPEQ31KNXTQQynT+wLI3?=
 =?us-ascii?Q?/IfBHnB6hAtNcfo/R726CxP/zWFpvgtcJpXQWgL9V9E11DI3BkVVl1/K44p3?=
 =?us-ascii?Q?Rt48CEqH84FGWitYpGC9CoS1xd/sENf2Pt9rXjMDbh2tU0CmnvKOFGamKsg6?=
 =?us-ascii?Q?ipXOg2qE8Jzovb5L+7omSPfhu1bQn5lRqfK6JqzuprhyMvF/LSoB34Yv4W7d?=
 =?us-ascii?Q?fG2zfGK89GX22Ah5Zo+BzTcPyc+qETs335D6pH3FlQAaQhDJczKSkfZCFTzH?=
 =?us-ascii?Q?aOVWDUoPTn5ck1fAc0esQUrxtAIauGCHTE9AdyyDFBQfizTcsTsvPPuNirTO?=
 =?us-ascii?Q?EhUHbWPRHBk6CB82Aamfqnq4e3wgT2SzMJ0BAP8X9PG0cAgx3SK0BueY8VDi?=
 =?us-ascii?Q?HscuQJswqPY4rsDnjbOgc2KR3EueBqT5Ha9OJaVTUl9nj2FX387DYdLriVU1?=
 =?us-ascii?Q?cg1t6D/wPBKShK31zlxXqFfXSW28usLIzHM/5FsBdOmqyniE7FRQaUSsEIv7?=
 =?us-ascii?Q?VEd1CF5UF6/9QEcbb1QyYBEJz63g0DM2jV4U6aKe5s1ZC0rYbqxRJj1XqiTc?=
 =?us-ascii?Q?nbEisZ15frLOYIiN+IYEc7/in0TeE0ReK/dJMmeN1P+T26UkXnkmBNmFsS27?=
 =?us-ascii?Q?foW3E8GSk7kfeNHghPTquKxpruTSWAfsgcvNgnAqf8IoOrkJ3kxALPlqDR8Q?=
 =?us-ascii?Q?XwGHCldeTjORhi64PanIQvirahELwUsvPDAw3QbeIxRzvkbzT567Wx2x7rvc?=
 =?us-ascii?Q?WJkRfaZwZDlRelFPJDxGjgFfHGnerR5CgCgu6m8VILyoT8w59jgNXodwpLUs?=
 =?us-ascii?Q?Y4KJyqdN2kUsFUaj5ikpenJ0qnIuWE6oRxuSJZ9Yohx9c9XQN+j+ovkW6Ydh?=
 =?us-ascii?Q?7ITDoaXnMadNz2vOkJqA8a2EkPF8JvTmPCONyCtX09tG6PfTyPVna0oh58Z0?=
 =?us-ascii?Q?QJiebrQXLgbAw8H7gClTnSnoplWArX4WlVetuFH/jPtmi2p7B8H7UEKc9lc6?=
 =?us-ascii?Q?e2QETuytLCsHfwXwwhQhvX3mynQHNYMGYxMzOhBsbX17kxQUynt/8zCb+m9J?=
 =?us-ascii?Q?efHQ/xcmi74iTx3ILQQ6j3lyBULER6emkTH3EICvHGXd9xbNZ22GgsJEKHZ2?=
 =?us-ascii?Q?2xjlpAM2csfT1ff46A+OrhsdR9PM15v2bDy1kSKh8ZDU77kry1DvlQRw1z+f?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d3bb46-6e1f-4cad-843c-08db531a4190
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 18:54:04.1153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ErAWgNDvfVhegrKQ3n4QRSu0cs2f4Qz3NpHx7bNrHTZMQQY9js0b+iFL7dHSVdNHdh/po6q4cm7eMm0lOhX8yDRZaz9UoTdzu8+qHZO2LOE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8240
X-OriginatorOrg: intel.com

Chaitanya Kulkarni wrote:
> Allow user to set the QUEUE_FLAG_NOWAIT optionally using module
> parameter to retain the default behaviour. Also, update respective
> allocation flags in the write path. Following are the performance
> numbers with io_uring fio engine for random read, note that device has
> been populated fully with randwrite workload before taking these
> numbers :-

Numbers look good. I see no reason for this to be optional. Just like
the brd driver always sets NOWAIT, so should pmem.

> 
> * linux-block (for-next) # grep IOPS  pmem*fio | column -t
> 
> nowait-off-1.fio:  read:  IOPS=3968k,  BW=15.1GiB/s
> nowait-off-2.fio:  read:  IOPS=4084k,  BW=15.6GiB/s
> nowait-off-3.fio:  read:  IOPS=3995k,  BW=15.2GiB/s
> 
> nowait-on-1.fio:   read:  IOPS=5909k,  BW=22.5GiB/s
> nowait-on-2.fio:   read:  IOPS=5997k,  BW=22.9GiB/s
> nowait-on-3.fio:   read:  IOPS=6006k,  BW=22.9GiB/s
> 
> * linux-block (for-next) # grep cpu  pmem*fio | column -t
> 
> nowait-off-1.fio:  cpu  :  usr=6.38%,   sys=31.37%,  ctx=220427659
> nowait-off-2.fio:  cpu  :  usr=6.19%,   sys=31.45%,  ctx=229825635
> nowait-off-3.fio:  cpu  :  usr=6.17%,   sys=31.22%,  ctx=221896158
> 
> nowait-on-1.fio:  cpu  :  usr=10.56%,  sys=87.82%,  ctx=24730   
> nowait-on-2.fio:  cpu  :  usr=9.92%,   sys=88.36%,  ctx=23427   
> nowait-on-3.fio:  cpu  :  usr=9.85%,   sys=89.04%,  ctx=23237   
> 
> * linux-block (for-next) # grep slat  pmem*fio | column -t
> nowait-off-1.fio:  slat  (nsec):  min=431,   max=50423k,  avg=9424.06
> nowait-off-2.fio:  slat  (nsec):  min=420,   max=35992k,  avg=9193.94
> nowait-off-3.fio:  slat  (nsec):  min=430,   max=40737k,  avg=9244.24
> 
> nowait-on-1.fio:   slat  (nsec):  min=1232,  max=40098k,  avg=7518.60
> nowait-on-2.fio:   slat  (nsec):  min=1303,  max=52107k,  avg=7423.37
> nowait-on-3.fio:   slat  (nsec):  min=1123,  max=40193k,  avg=7409.08

Any thoughts on why min latency went up?
