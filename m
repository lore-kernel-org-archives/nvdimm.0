Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8593615C99
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 23:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667865047; x=1699401047;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ECIHdADLlDKJlB6pZnpwR4E+NvaYS7CGAJq+Lmzmqxo=;
  b=KJnKvwztCCat7Bdv7bSkkr+e/epuPlhEnCqy0ACT9e6OwWrspnQMDGS/
   0lFbCZbSPF1vpBeL/BfxCSXiuf0RNVySb5D4HI5bIWm11ywRhgMh25exG
   FPy4Q/QIopqjQUbM4jkXXcPEDLZejvaH7bUozyDrKdk9EQip0NnzQj9wS
   ofG1p4Wm3FeIenys2PyJAb56pDBMj5zNfDXQRPYIHJ6a5jDNhkBp8uQFv
   Hh1DqAH3OTXZo3155VH+MjTcLgWiLyoPnar8tdOezND5K/EM9cbGbrogX
   TuphMWwWimYsc6fO/uqradq9W510SAw7ZaMGBPBNSjXNdJ9UwN3e6fDfl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="308176788"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="308176788"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 15:50:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="699686949"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="699686949"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 07 Nov 2022 15:50:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 15:50:42 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 7 Nov 2022 15:50:42 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 7 Nov 2022 15:50:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWmvka9C0KWP0Z9o/UHRMZ2nyiRaDix4MDqj0RKYJw4RsYA+vpdliaaFeLC5UfhEqL4FlFsXZfYSjd3ZVb6kzynCTxCcEWa+zK5rRKF4LzygOkuGmy5iIMghDiGx6TlEXAn2fwAUtvnZ5kUSCu505MNaVvGoPh4JRvu0SrxWKkYHTsBYHPs+NCEtJa5i6w3h0gZ60fAW8OJBwaDUP8XwujYA2C4CBPf9b5r1e3lLQPoM+u+KQAEIZQhL5NGLXbdx0Xeq6AIg/v7qxuEUx981nR4yqfC55Gm3li4PEdswa6qGQrvbqYXsXk1VpmfCtKxgXHaoq7W5a+5GPBBxWImBtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3U6vVlmFASHlsBaJLaBAc5gOtMMLML3V76GxWUs7L/w=;
 b=foTSBd04ioHn3G/v8jk5imq8p/d3UKAYEbTu4FQ0QyeV9dbM5I0nXlXEkFLJ8eB12YkneuvE3RKbwBWyBlijQ0p/WSAxmG7oTupG0h3nKqEnimkG1rPoCHnjAbnRTMov36TMNMJZc+ZDUb8EsctvQgVbtwAQTTm5Jfi1wMVQWd/j2oXFS6mf7XUkkfhhk0OdqwuJncE75+RiFZpZNtPvOXkMrhhTG/lS3vhzucuSI5IV2MbUOPBtoqgrf0HFTg47e+Uv1dkyQb2UqxkoXE87jyk0nQxEqiphTdTOYZf+uabGDdE22RXic/qxXDgYxESPmrLBougAS2w5be0QZAzl5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ0PR11MB5120.namprd11.prod.outlook.com
 (2603:10b6:a03:2d1::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 23:50:40 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::11a0:d0ce:bdd:33e3]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::11a0:d0ce:bdd:33e3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 23:50:40 +0000
Date: Mon, 7 Nov 2022 15:50:38 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 09/15] cxl/region: Make ways an integer argument
Message-ID: <636999ce3bd89_1843229460@dwillia2-xfh.jf.intel.com.notmuch>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
 <166777845733.1238089.4849744927692588680.stgit@dwillia2-xfh.jf.intel.com>
 <Y2mKDV5MG3OZqwau@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y2mKDV5MG3OZqwau@aschofie-mobl2>
X-ClientProxiedBy: SJ0PR13CA0065.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::10) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SJ0PR11MB5120:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a44359d-928d-4e56-96d7-08dac11ae05c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N+NLSCWYWt5i7dCJ0Oufe7W0wRQq9u128OQG1oBLITwzJ8memWq0sm1EYF2lElKykGCm2FS9d0wNvpB8oOWGC4yqNQsx8RleynHVkMy1jmpqVxMvU7MEHj2V8V2Bq3UlfTHUUIeFihM5YInCHwgkMbCqRr9avRVNLQf2OuZGvFMtUaEUIVqZaOUzocWMTZVZesGkqsdutGRwvJXxu4hRas9hTi2NV/uXWRlEnsP6cB8lpBT6F6IhEuDaw1zWwNOc6FnHA4XNN22Yw9MgXYqMYCtAcpnY9FDDTMJWOCeZhkywoRhMFKjBnc2RatMDA0XgSb7759K7qfHZluPKp2KjMcOl38wBBLtjKaSIb5AcfnAL81u7NXOoKcM+DDIRw9dP734gpmHKg2aDr9tVndkmc/XLpr+A75Y4IjAxvlL4ZNY6g257472kwnawpNGBtuhw+WIJ6TP35bHPmlIlWPjOy6FlI06+1+u+Vny/c/hzoNFlIHiwZ+WiZHNLEcwrrU7g+/bdNq6mgwGEa2f9jNAj6hym/3yiYx/Vojb+hB/WxrsKs0tFjqioGREXohuekrD8gOsenVDrJlumO1bGXLvJMKCboyuvzCMmRExaCJ1851SAdi658kKEJBEqQS5au0WHniApe9VwEwXdlrzEtr5Wn0zv/JvRSGvD5bEVFLG1N9X3JmBTZSOw1KfnmfPlF6HwZF4j2Rre2HnR/EaNkHXYPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199015)(186003)(38100700002)(9686003)(6506007)(6512007)(26005)(4744005)(2906002)(316002)(478600001)(110136005)(6486002)(41300700001)(5660300002)(8936002)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CDWYVjHuRt9w/LvHREKdI/aFK1nq6dTMee0h5P7bWi+GGyPv0fzEFFUvL57g?=
 =?us-ascii?Q?IAcB0x/oQkVrn3kjAjQCiWLfFMUHb8JTXiYb5xJTGY6DOZuQl3pumtsJb7ar?=
 =?us-ascii?Q?U/pVf7O10IEfw50/5hS5OJRZW2N3z4m8jKobnL8yU3sSyqTnVFFCRXMahH4p?=
 =?us-ascii?Q?BMpXkKxagKjPmAFoXuL92Zt1e/fk+RkapM3DHcCZFW6wUTvh02IHV1LA+u8n?=
 =?us-ascii?Q?tlnzN4w0YlJKZ0rqeumknjrrvPQz0wu6rHOf4dS82i4XcZki4D1ZQfDlkQ+S?=
 =?us-ascii?Q?GmmxAjXEvAuKPYaIWXIYVNNejJsICcqUh27avl0nuNDTwp4RrBK21br67mZS?=
 =?us-ascii?Q?3zCGclo8a+j3OQ7i1OPfavrA4lrbb2asrj3fKHJG2DSMwv1RlXF6zryLDjl3?=
 =?us-ascii?Q?73qqKqwWxoZ2hyTdyscPJXIyPQs0xaqwyM9nhhoppgn1RGs0/bjT/Ah3uXAy?=
 =?us-ascii?Q?xF2bHxaa5q0wcmwEmUG6otjXe1twHJGFmSGhx7gZT1s+A8Vbjzv9yWI67Ia/?=
 =?us-ascii?Q?zAwsAVRJr0+6l8+m2AHTS0aS5CxJa9TQQWHQNnn/pCw341dRPHJ69rKAulW+?=
 =?us-ascii?Q?PebS1NlJzwd5DDcpjIykeVfQ6vdTiyas6n0gLTSfrc8yYJjBq9YOX+1RLDhD?=
 =?us-ascii?Q?/WYvwilYJkZlQmhNlt3jhisxjI4ofZ36YZrXdCJspMrcrThF6EZCiK/jutLn?=
 =?us-ascii?Q?YkE5abuesS5qhJGWBTG4vKH/p2DkYxmZGPrIfsXRxwBPRhbULR+zxXecFziF?=
 =?us-ascii?Q?Jtr5mv/av9N7esjikGJqHj9J3ubjIdD5Mnp/8Xu7qqX/8EfUgxNFxjX+gYGf?=
 =?us-ascii?Q?s/ikyBmCY1QpGOZboPssOHjVssQKCP+zu/n2VC5w/lxpvPhuWBYyD1SZ7pLl?=
 =?us-ascii?Q?FR4kxxp7O6ihSKsrm/j4jHWuEeH1LXEHgJa7UwKJv4NnXVY868F7u6e1E8yg?=
 =?us-ascii?Q?WD9xTiUwy82GVVvLMVruKMaNU1slyNFb5vK7psZucAcKsMZldJsyfc6UWNRT?=
 =?us-ascii?Q?imZCv+3GilT2rGhny8ZU/8F1eeW/XXkynF540qv5I8+CjW4LzBNtqU0YOMw0?=
 =?us-ascii?Q?zUJq+V3Sm7UDloZ5I3OMVjs4tHDQRcH2M+uE65OxPdOM8lKOzD17SUEzS4fB?=
 =?us-ascii?Q?x3I9aXrMjpo18oKP+GiwAxIcXDHLRa+XaUfkCNbIaiNr3ALSAItzVmeDyapZ?=
 =?us-ascii?Q?0/8yfpsOQvJOoVKrKNxu9upFyo/bMKZWin0bYEZr3ak1NRG4rDt9cI6eYoZp?=
 =?us-ascii?Q?zPYwCWhCjRvdAlc3oTNgRbbgZIihewyDB2OvLSHoeBSSVreybutuuxnW4k74?=
 =?us-ascii?Q?1j4DGZHf1E12fV8yUdr2lqAXbzl1oN0+kNUW5qdUvKmAS7vFaKmmxsWx4yJ7?=
 =?us-ascii?Q?ck7tiUxWP1GKxkhdRRtd0C96GxllO1xGC1ivQX2XNLnIEsjsq8BJJ3RPgx0D?=
 =?us-ascii?Q?Vcz6tgqBvymh3C5fwbo5RAWa5EiZLn2W9QxT4rLPMlJbnqian7zh26BKGZCU?=
 =?us-ascii?Q?lnVmVyR1IpwqbNcwSAGpTscou3rXCDzVZhXTQiHA3WqpW+01p8uH7aWqVaMW?=
 =?us-ascii?Q?RJKZP3s5ncxCvkzXt5A/3bRf9uKJSZGOfyTqKdr6Q5Bgj/chQmbxkhAkt1oG?=
 =?us-ascii?Q?NA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a44359d-928d-4e56-96d7-08dac11ae05c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 23:50:40.4914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cO27t0sOiWE7eOaWEq8OI1+QC+uMzb/zaik4NbHftuTlCZ4PrHt5I5wFIB1VivNfp0zdO+oaEmp8CONkcYl+NaLO2QXdTUpUMZDmK1Qd7EU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5120
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Sun, Nov 06, 2022 at 03:47:37PM -0800, Dan Williams wrote:
> > Since --ways does not take a unit value like --size, just make it an
> > integer argument directly and skip the hand coded conversion.
> 
> Just curious why not unsigned int for this and granularity?

Mainly to avoid signed vs unsigned integer comparison with a typical
'int i' iterator variable.
