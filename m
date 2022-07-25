Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2C720F3
	for <nvdimm@lists.linux.dev>; Mon, 25 Jul 2022 16:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658766135; x=1690302135;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=S83Mu4MAFRJdaxVIKN5dKJ19gKm+pUN/OkouxhUYhwI=;
  b=BWzN8ls7N+be0f8IUrtN4HzFpJgcNECw4kI+LIQgDsX3BgQA86dNiaRt
   Yt/7s1MHS2Sa0RNEiLik5sGvkM9aXCAYePrAUxm5PkDFm8/OxbwGCl1EJ
   vffrxldRjDG8V5cQCyacYGoHdUb9Rvn3LPsLLe6gJ04T337bXcYzOXRuB
   fcpAF31lpHuBIofN3oaImuBkPTsVzS/KBc5tm5aDaQmaq0e6BsQ1GL6LB
   V4pVn9wGdkgGATSRvZ5t0i6VDs+97DrgVFGEDrc04AsNtjFV9eYLh/giZ
   YU53TSG4f9I4me7IsAOR8pxdsDI2Y2MKYFfKrqVdDeXeZmS8yUdsLQH7/
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="288495337"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="288495337"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 09:21:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="599659935"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 25 Jul 2022 09:21:57 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 09:21:56 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 09:21:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 25 Jul 2022 09:21:56 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 25 Jul 2022 09:21:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJbhNtwM0rUUqaZv4YydyaKBcmou5zvKLZG3DFJzKLplnWxCL91nPgM2iCSkIEKMHQpPmyW9+z926RO+UnqjEPDI4XOJ77zfcQW1dhjuMHuPZTFEKZKB9GxM05oRtDShO+UOzDKtyRyRURSH0oUwnSbBfmHCa3camdJzlhrPsCrkvDXDvVtEjzIbvMRHusF0fHMTHVS+DfrGF4UjalegWewUyqQ+De1jp5IxG7NXloMGLO2PB5gPG4MTOZ3x95hdYouYlTElWHooi1rF0GLaFFD1PgYoUMFhTauEILwDgK2/cjilWzizvbBjNCQtqazbsCIfbOsqOmZ4JQUf+eXFcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2bCtYzznDfAAtxNCb153JMWYfTcJM6RCWMB2iM5qzc=;
 b=MsxT3hEV2yxLvpZ/PkUZkAq6+OJ1jiTZOSCHloOY43FijxfcHeXdYFuy/YociFukhdNWSgYuDfFIV3D0Fwarm7p3znXPmgvnIYGmuu46eec5t1nw2A2rSY8B42fm3ZKBpxNJfTjdDlU9K5arJLSkz5FP3w4Fj7w5pjZ/hsqdjzwsk7Um2Fe+LgI8ivtWgkz02B4EW5S3sf26hXWLGev/rc5h58bdLHuE2T+2eEZncO2w3HiLHfFm9NNdfaUuMZVIgG0Hdn8hz/VoGcH/scmrD2XQkNMkphzPoAZO02KdTOJWBO9e+l2XD+hzfHjVSwlFyIMOowrmuswwONphjayREw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MWHPR11MB1997.namprd11.prod.outlook.com
 (2603:10b6:300:2a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 16:21:54 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5458.024; Mon, 25 Jul
 2022 16:21:54 +0000
Date: Mon, 25 Jul 2022 09:21:51 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Eliot Moss <moss@cs.umass.edu>, <nvdimm@lists.linux.dev>
Subject: RE: Building on Ubuntu; and persistence_domain:cpu_cache
Message-ID: <62dec31f33ac6_1f553629495@dwillia2-xfh.jf.intel.com.notmuch>
References: <c8297399-4c99-52d9-861a-62fade81cda1@cs.umass.edu>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c8297399-4c99-52d9-861a-62fade81cda1@cs.umass.edu>
X-ClientProxiedBy: SJ0PR05CA0084.namprd05.prod.outlook.com
 (2603:10b6:a03:332::29) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb2228cb-9f60-467d-aff1-08da6e59c97e
X-MS-TrafficTypeDiagnostic: MWHPR11MB1997:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MwGIgt5+skCIj+U4mD6qPHVUelVApwVErCG3ifrJQnaRxZgKb3qMGjc7jIYo6PV+w/uPng6TqHApCGq5sVGJiGmqt2h/3Y2rl+X0oHgF3h1TaCPOeUN0IlKqLj71A33aBQNlwc7x1iCSnhtKsJHAQlFL9qTCzrr3OR0ePK/a1A9AnrQOo6rjyfUgb031/HkwYBg/JT9xBhJTD7GIaaI9PhOfI1+hHZGa/mt3L5WZ+FWkdJLkHePWc55dTstqR64DVrm+FOJE2M/floSmg4UGgxkr13KSru6EYOlSMP1vULeJ+WmaizZfdMdcioiYX2c042YzhVh6pM644jX8y2ZuRv9n7YUgGHPC7F+579F9aMrtOTLFm7SoxnmdSzG8oCGpF+rZ6AbECsaHv7tCayr1LiLQRlMdtl0ac0uz+ArHqWNSN1v8nAc6joA8uzfhd/l9f9p8oejn/zFHixnw2kveGGdHXSx//23OE70CrCCODdI/rr4xiJEDjH4YHwCG3ZpM6Fy2PK9Hre7OAQziAmePacTHnmnvPzMOF9WW2suksOXrUwuyrtIZJYG+Cl47/ztazc6waZkPdvlHUesL3GWEBFPw5K2GCyZEYGThv8XLlgB2H7dFPbm7akRyV06o55N9h8cGkv66wEkBD4mpz3StEv+w91H2AA/9n4WE2WuX4nJqO9fTiPGtVBdXLTMGkzJZx0S+pR8C5n4q6jZWrojpD1qmoBJFis1LfpZSwPOZYBpReA4loajIPBJfbI8AqYY3U/vl9ykOOdpISwbZS5muwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(396003)(366004)(136003)(39860400002)(86362001)(8936002)(82960400001)(26005)(83380400001)(9686003)(186003)(6512007)(6506007)(41300700001)(6666004)(316002)(6486002)(966005)(8676002)(5660300002)(66946007)(38100700002)(66556008)(66476007)(2906002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s2QYWbTjmKsCssGdHvtEMeY7O1atTi3n3uSAfAR918ZwRpAIsGl6sYtdkgHP?=
 =?us-ascii?Q?TcEM+ZsoAKIUGl0sM8rFAJk7v7a9mD42aLuv5u2tdVek4gEon7p1i3u9jgJc?=
 =?us-ascii?Q?xXz1i1wDMMMy283RpKncraZoRoei+koRDKfXRMXqk0374WaWfnITWd8CsdD7?=
 =?us-ascii?Q?nb46uw/aW5v2MoPzfkg5NgsVPtAk+gRCyrstWGVwtBzt2igXHR6uZVNoZbD4?=
 =?us-ascii?Q?N6yqAXZev3sbiXY06XpSADBuZ4kBP+KAyhGU5YDpUYPX3fhjUhO4Ocw9s8BW?=
 =?us-ascii?Q?tLSI0/VEk9Nb0JgW1TK9QdADRGq1bdcYn0jYpI2UuSG8gga0zXSKvUWqC+x2?=
 =?us-ascii?Q?6Enx6I+fkqP/JHQJmwfDhYqWXNp6fgJqp+818DDzLzHbDAJ5SL4Av6yRxTfn?=
 =?us-ascii?Q?MUyRg6WOczIfIDDpBZrlwz3BArsamPU2Amwj1gD/WYwJ4TY87LGIZeizsMPM?=
 =?us-ascii?Q?YB+G4x1Jt+hjAoWGwJotGv5j9MqVHXVAB/C8bPbyMfGlRKKqGriraZQpHBwT?=
 =?us-ascii?Q?xFII6OtFqTiy/AD5eP4ilh2Z664ALbdHP2hM09WS0tkpJKaA48KCrLSHxQ7Q?=
 =?us-ascii?Q?qKSNBADhmcdpFkUk1BMBHlhbwkg4TBlDDQh42D4BrKwiT/+wmoGuOBrWTEeC?=
 =?us-ascii?Q?CvXvg+GS+6yBcbW3k0ZmIkvZWfR5fmJYf8lZxXOo0BRgTqUdjcCvyrHl6K9x?=
 =?us-ascii?Q?I22O7mqpWtLHCxTwwYt1NF/oFmd0/Qps5xFlm/qbxQdud46SQ+XLr0VlLb/I?=
 =?us-ascii?Q?5gZzs4FXraybtbzedSgaD7shsxNttPxCyG0TkZ2Nmmqt9XCWnHhAHU0a4Iy1?=
 =?us-ascii?Q?jyIJPiKZPgEfQklcOk0lSrZdvfDg+SlxhqCoFuVbYXmGUBMoj2VNw63WvHtp?=
 =?us-ascii?Q?KB3SlytGK0FhyuGMQIfPwQ8DJSQy93wWfEehMv/s/jHogjNwFH2m2iAxQ7gi?=
 =?us-ascii?Q?pKjBe7rVQw8zMNkwsTlfSgAgy2XJRkN4O7d/M0QQx64B+hdZ1fitJ2Omz+Ei?=
 =?us-ascii?Q?IGE0XAfhIS3nPPRcmyurYBziTiIBEBWJcmM523O3Kxhae5ysZWDbwixYJyEK?=
 =?us-ascii?Q?W8gjkttKMbyliGPf+yk2+2kyORIrtmUAD+PUe59+gjyZLPQUxJXe5rgVwJWa?=
 =?us-ascii?Q?koetSm2oqiyyiSIImLJUJNI04HBLHKZETotpEyiPkF/E2RSuyrPmJy58pmwD?=
 =?us-ascii?Q?HV4QdRw05LPHoepbvxa68WwDSVOrJBbb3e47snV/ScsU/3sviVhg1F4WJqYR?=
 =?us-ascii?Q?MqXNH40eeGy+c5dpNMre6PZw/634sPwZ+IcUhs9MUIIL3LB/d/1VxLdu87x3?=
 =?us-ascii?Q?ItuCB0BPwKXmfMYRTd66sW2gVozFT9vKhFzgQShErjAKAcX3Np5mRZ8jEcEl?=
 =?us-ascii?Q?KZZF94pruoaMOmV2zROA55ObUDMqNqouiY79tK+Q0MwRkSz4/BhUrHNv8x3S?=
 =?us-ascii?Q?n3f+CIg8/nBlbHIhz0T7U+0XYFzhNCGz+CV3EmUlSMTEN0NqLlZFGrJKeSVl?=
 =?us-ascii?Q?ar7xVfWfRE3UanM84yXCXCkRc87Q4WGFb+ksYJJ8EChiPololo+X9TSb7bgU?=
 =?us-ascii?Q?Ld0AuAgMYSKJx1fgEoKtORuFFaTTIgEWEiyU6C8pMH3Zk4hnGsMjPDLjvF3S?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb2228cb-9f60-467d-aff1-08da6e59c97e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 16:21:54.3326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Fi/nu340FXvoHBY5TvZFXVxZLfp6vFy7zfBmCLqSwQaRkNC11v1rM62y3Yhwn2qpEEo9aLhCEZ4/KfJOxlQE5Ubat+hOmQwyX1ZtL1ePBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1997
X-OriginatorOrg: intel.com

Eliot Moss wrote:
> Dear NVDimm folk:
> 
> I write concerning ndctl verion 72.1+ running on Ubuntu 22.04 (Linux
> 5.15.0-41-generic x86_64).
> 
> The system is a brand new two socket Dell server with cpu model Xeon GOld 6346
> and 4 Tb of Optane DC P200 memory.
> 
> I am able to ue ndctl to configure the two regions with one namespace each in
> fsdax mode.  Here is what ndctl list --namespaces -R prints:
> 
> {
>    "regions":[
>      {
>        "dev":"region1",
>        "size":2177548419072,
>        "align":16777216,
>        "available_size":0,
>        "max_available_extent":0,
>        "type":"pmem",
>        "iset_id":-953140445588584312,
>        "persistence_domain":"memory_controller",
>        "namespaces":[
>          {
>            "dev":"namespace1.0",
>            "mode":"fsdax",
>            "map":"dev",
>            "size":2143522127872,
>            "uuid":"ed74879e-4eb6-4f88-bb7f-ae018d659720",
>            "sector_size":512,
>            "align":2097152,
>            "blockdev":"pmem1",
>            "name":"namespace1"
>          }
>        ]
>      },
>      {
>        "dev":"region0",
>        "size":2177548419072,
>        "align":16777216,
>        "available_size":0,
>        "max_available_extent":0,
>        "type":"pmem",
>        "iset_id":-3109801715871676280,
>        "persistence_domain":"memory_controller",
>        "namespaces":[
>          {
>            "dev":"namespace0.0",
>            "mode":"fsdax",
>            "map":"dev",
>            "size":2143522127872,
>            "uuid":"64c75dc0-3d7a-4ac0-8698-8914e67b18db",
>            "sector_size":512,
>            "align":2097152,
>            "blockdev":"pmem0",
>            "name":"namespace0"
>          }
>        ]
>      }
>    ]
> }
> 
> What concerns me is that it shows "persistence_domain":"memory_controller"
> when I think it should show the persistence domain as "cpu_cache", since this
> system is supposed to support eADR.

FYI, I notice this topic was discussed on the 'pmem' list:

https://groups.google.com/g/pmem/c/K35X70fzAMw/m/5qEhhzb8AAAJ
