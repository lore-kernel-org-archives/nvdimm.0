Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467F662C
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 04:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670472872; x=1702008872;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Aw+AUloHqgNtHqYxHZHW7dqu/7T/3wFT7n7fkirslbQ=;
  b=I1aJhJMOWpanKm4cbbLYXz24JNiw+NMQlUDNfVyV2xyhed1BPFc36zW5
   LBy5f6klsGAKzJtZ3s9JmqhjO5qtwUwVnAGP0CmJOHy/CUgctZNC6z75x
   JUOiI37/NDc7YmsVwFQLLTLL/VI50FwFzkZx159fJIQmogP39nFfS1bpf
   zo9B3sPs1Yriq+0Zf+gEvjGCyH7WOohe1U9S811YI3k39qZ/cRawPUPt7
   3rqo2idu9oNwCidap/oVxQRRZSBqqAdtvJLGebfQcz1U+Mt4azJmnJxDq
   HG2SZ3pcHptAAhr6p+sLW6/1G/m4Xl9lCDGHxQkvT6vlYorWqXtMxOhoW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="317076034"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="317076034"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 20:14:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="648986670"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="648986670"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 07 Dec 2022 20:14:31 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 20:14:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 20:14:30 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 20:14:30 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 20:14:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZmcuKFdTd9CQx9/T3NYtybUBlbSD+Au2o4Aap/K7II6U7UhEQruCSfonCid3Rg4x8N1yiP34TYq0Ha+hpyfnx8lxC3zjJdV7nqrUcnM/qiMJr989rs63Zk4dBIHhktmZHklha/WajfDIc3b/rWF7VaZLFlGLboIUsNJJAdS+V//Vcsv0bVaD0qPmvGWfo/DZkIlXTmBV4b7yCuaLsTFQbSQZ+1WCscfSULia392K+m3pOuUGjmDC0f3/dP6C3lDrfK+fxxTVmxnoKi6fgdapxp6Po1SZOZXhVWCDEQtLtPZ6cQpSVmAoEaOAqHv2/xXs8CBPPGjyqS/DQ6GocZ/1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKSQ6jVkvwQNLya7X8/bSJs4Ex5hDLzGxV/fS4tv3Ps=;
 b=VZAV/xQZaBY07s1fHneMmwsLj05qcoY47zEQEosTMWz8LOU61GLP3AVQmLt3Qtam5w/2Xdnwgm+xQsnxAD/MaJdT9rj9lhNEUEzlWisu/vp6jSSljwsdNk/4LrAiHBfeXXM+pdgI75eRxW0A2wSUhyIx2lUFM0q1KWmuZy/ZPaiT8tTWjIb9BhH6HL1Qn1eThQinhtMsDPY95e+Ip51fBJ6Wd88EsoX9EorkOs+STw1lGP27zIgzUZb8ZKHi/nIyXHVUGJCfF04fnf6Be7aa67R8DJFq8s1H7wM8gEikPwxY/nfbxDqovmf5Fq3KShmME23pFeMoCMhRCSCrdYO+xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CH3PR11MB7893.namprd11.prod.outlook.com
 (2603:10b6:610:12e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 04:14:23 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 04:14:22 +0000
Date: Wed, 7 Dec 2022 20:14:07 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 06/15] cxl/list: Skip emitting pmem_size when it is
 zero
Message-ID: <6391648fea99d_c957294d9@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
 <166777844020.1238089.5777920571190091563.stgit@dwillia2-xfh.jf.intel.com>
 <Y2mLGxdAAQjcflbq@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y2mLGxdAAQjcflbq@aschofie-mobl2>
X-ClientProxiedBy: BY5PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::35) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|CH3PR11MB7893:EE_
X-MS-Office365-Filtering-Correlation-Id: d21f0825-38b1-4f02-d362-08dad8d2af93
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hOAVEuFHP4di5nQgEfwLMivcgFnD6diGSr3K/W7R7ZsAdeaxKOOSbZWrJEwt5cBAmhWDT+T0cRlcWAomvGZFbiEodtL1ACHgz+cDCIUYMTpaKxFwfLEvXMRYMq48VnpIdnaDLeCg+X8YCzzuaSGCFKCUiQaeZdpR++ZUzxslqvUEB/PLHp2y3w810EeWNlKQ2rFBVLXKXItMwfPBB4iJ8jFE/05k8LMtl74yEnKddtm+Xfigabt+2f22BiA4EkMQv/QGQDpLp4EhF4rPOc4/TeAwnKq84Gqkpw5Tb/ofcssfDmyznrVAM4A/RqAFPc0LZFXdUnvNXyft/uPQ58HOjguxretxh16v64vmCtbKLgH95xwNBjoCj9lI2dc0QNiVosnLbiSpZNFESSK/OdyGkyHu5ja2yUxo4LNc+K8OxWbJaC9Bi7xG/cdqzx4L2c42rfKKXtvFwKHNB0bWQCZ6LIwbFRyk2kjY/XXv3ldn79AY5ARfxMs8Pi1JOrOY/On3AhzZ4W56lIR8eus8jCtXGSE+m6MNFC/bHnkZyk/EXclhHHRhmy1eJC7BW7zwOrLYLzal0nLtr9FfFqgzFC5xNJ+8j510kyhQ6KXn4K0jpBkXHnlla1n5m54r5iBwQ6skGMsC0u+B2ci9mzz2zCL2dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199015)(86362001)(6486002)(6506007)(478600001)(8936002)(26005)(5660300002)(6666004)(82960400001)(4326008)(316002)(41300700001)(4744005)(83380400001)(6512007)(2906002)(66476007)(110136005)(66946007)(66556008)(9686003)(38100700002)(8676002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hbZ7atkxlX9dSTVqlFzKQsSiUOEyiG4ViR8wGAQey9SaVWh9yn/gtIshF7ul?=
 =?us-ascii?Q?3aoNsVbRjJjZ8ePOgfmAlKKNETeWFsF7njDfiQ7N6Y6DQ4VQ2qxbXVZbiM+O?=
 =?us-ascii?Q?nrFnOcgAHwVCGI58ifd7/8s+sgm6prCeWPDNwD881HUReinMeicP74ww5zZi?=
 =?us-ascii?Q?ztnEu2JJ683sPcRLASJNTTCViC4Ls0uHfAfYCoEo7T8d9V5K87lu9i8eE8MX?=
 =?us-ascii?Q?G/wxUkdJMDUs6xEmqcDJokp9KaUEFWEtYEILMGAujzDfYkkHcFgeKZ7zwOqX?=
 =?us-ascii?Q?/i8h/v0WyOwMsXySa7aIMzgTpp+wMyCyBuPFSyM1wbOOYqgHw4jGkPHcz47r?=
 =?us-ascii?Q?SetorHHmzK/5tM5hFP3P931DnSOJHT6zYvQaPmluvQxaP0ov2R2btsckJpYo?=
 =?us-ascii?Q?QrBWyN5RRZ7JvuGC/SvK34z4MevHvQxzgiIwqAMKVaqThsECqkjXRCJBgFAs?=
 =?us-ascii?Q?TZWcgsOv3+e/J30U6EXv68+h9JUdzbjhtf1We9+/WkeS5/IUMFKp5LwleaNp?=
 =?us-ascii?Q?xwR9uZjQv07fYJI+m79RxSuQkoz1DXVu6qya4Y3kwgYBxQkcvnUtghVIzdvw?=
 =?us-ascii?Q?S3xwT8uByPnfITIplt7Q87XoIhZOkUbQexOml8jfHG1trc81EqjHuL5zOJF7?=
 =?us-ascii?Q?tyUWkKy22CHBb8I6ZahpzikJ96zRW4tEjZbHz7DS0bGmqrz5zLRmC5eMFZnz?=
 =?us-ascii?Q?W5yfhLZK9j/cUUUm1aKshbiqPdqjSHOAlc7RfuVuG5D2JuTxkxlzgVj3NnCI?=
 =?us-ascii?Q?Af95SCcJPl+2qgo9b/f+K3wEk3BRoKJwD2VsdyWjowf5sZsEDFF/OUN8s+L9?=
 =?us-ascii?Q?w2HGDj6LREVPoMzrJB5RQ7vZ/oiiq+OgQRAHOpKG+bSRx8HcbVHZ+buM8yhb?=
 =?us-ascii?Q?D/D7RQpr5DeeQhTiClbB+RatLNfVdkFUpR/j4ZvnonDWqVLiQ8eK+SNRxpDw?=
 =?us-ascii?Q?wjyroj5zpf7psGgOd/70mev1V4wT1FlZ5w/RAfLud4QxaOnRLnUTs+sPbgfr?=
 =?us-ascii?Q?VEDBmaK70jqJp/vvwVEFTIo3KpW4bAT3/7lelV+rYDPDIriwGTXxDuqk3n2f?=
 =?us-ascii?Q?4K4sal97gbxnKTUZxsm8PH2mCaPBLJkZ9WYw1vmHMZMgG7C9kT7kdtS+1uTv?=
 =?us-ascii?Q?+lr1rCvxPX66Mj/psNEFLFFj38vzXwAnYURCJTstbSRZrAm1iyiWC9iGLVwJ?=
 =?us-ascii?Q?wEQ2WWST0qFgiPwD+xLoNN3TQEDRewALom5YxbH/6dvYDXTbvDQn5bqZGTCM?=
 =?us-ascii?Q?9fq6RG14bsG78vvYdBIQFklx8a5bHez+zLgFg68SsIIpa8S5soJ29+HTBDsr?=
 =?us-ascii?Q?rY2/aPeGR+wv/DfJuH9D9BCwRjon6XZBQ8GsROFC6c1pdJVzHYilFxROueAw?=
 =?us-ascii?Q?57OB8KroYCJXwkEQ+j3LDb4Z7+6tw4FQXxQHlQJkxnJZ/VEbd2nJh6xvNE4e?=
 =?us-ascii?Q?M9SuOrn66TInuZYaOaFgVorXdcxNLI625oHp1snlaSoonQ4Ppu4OM2Z/ke4c?=
 =?us-ascii?Q?0YZtgmXY9gRLFpVdD9t3+B//MqQupKX0QlRLhmawOlWI/DRARnYuNi1V5WMB?=
 =?us-ascii?Q?TTvYq99FZX87631Mr2hoUkZ6zmaVfI36TIuAAnOBK9uewMEnssQm0qW9RdbD?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d21f0825-38b1-4f02-d362-08dad8d2af93
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 04:14:22.8653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IpYKNZ+4nAsZwyibBr2OlvE+tbmv0SHzM02qR746sVur0aS8drnzrIBUx0pulyKqlicsORN15X1Zxq1nthfiaxoCRkFC7ZDtqtWjOd363ZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7893
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Sun, Nov 06, 2022 at 03:47:20PM -0800, Dan Williams wrote:
> > The typical case is that CXL devices are pure ram devices. Only emit
> > capacity sizes when they are non-zero to avoid confusion around whether
> > pmem is available via partitioning or not.
> > 
> > Do the same for ram_size on the odd case that someone builds a pure pmem
> > device.
> 
> The cxl list man page needs a couple of examples updated.

Good point, done.
