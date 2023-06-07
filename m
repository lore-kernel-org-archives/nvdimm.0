Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FF27C
	for <nvdimm@lists.linux.dev>; Wed,  7 Jun 2023 03:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686109499; x=1717645499;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=/RwX3gANKU50i0SZsRdxYP6cLsB/4GAiPpzjgF9/f9c=;
  b=nXmj1CGerOrOfi6LdtEfReNqXS2l3c5yIhm9GzwZkZnympnNvHbXP+ea
   gBeXVeymiTO09c1Y43SKp5JbqbaTbn52sdujdIu9tP0bIssAcGhPA1BZP
   bPJfaWCLqikfJaGkoCfYzrVwBIteLpbIBtX0lEn0C4Kf2ZM12YrdpA11j
   LpNEgmseIlG8uEE+d4VZpXEZel1Hi1tCA7CLxbLlnYjXtvFQ+/qsgppxG
   f5jWZzSuQ046zs7FqUfroHQsxiNgJQ3JcUn6f6SsaJlT+4m2JOg5Zdhr7
   Wk+3aLaIwoWegX9j7hJavfMcepHp306L99MxYhUaB1fw4nxDRckSbvRtF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="385185088"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="385185088"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 20:44:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="712433914"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="712433914"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jun 2023 20:44:56 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 20:44:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 20:44:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 20:44:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQp8xGgOTTzy8V8fhndunPB+YlAlcpYRoo7ez7s3CJWv9Ysw0DTuNSFVZpNm+JFEDHDObirPp6j6EuAFtub94o81iN1LRU+bvdnbjOOHfRntPLNKEHwahmbvtBWYOKDN0n5RAUcOIYXfOhYu9TuenQfg6Jfn3NRp0A32UwA/ZRXlE1/wyNwPmYyPO+z7qzLYiozTdDY4BpAzMLIhoxIHBvq4LVYXqp5aQwyiF5ZpNB40+ogbnZG3aJTX0cl6A8zKc6BpjTdJVn7e/WpjB4mnUl3mDsj208poKCy1dZDMD/QB1hRuQaQv0WKbC+yRa4Txw40EJzz40zauR+7PI5t8xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=24bcVHqP4pJUF4lN/L8aJJCuRutdXqBCq4bpBMAGLCA=;
 b=bCtPAqdwXJGuRP+U3qPBywwWV08x/X/cQdjBG7uuT6BMn/YwQSEnaIhk6a6ebeFjaXZ9YJwG6a7AsS9owPK/JeEWG+wdwA8tNXMDHpTDzY/no7urFQUBuojSIuQfyzb8OsCQjSggF0TPr7Ddi5LUj55M/D38fL2hhh/w7pX/sjjxKSpv0gdpn8g/y0ev+Pj9HwmQJWqQ3eB3aONhZvKbSygC7Se8A5qqHvOZLUK1Jf1EobQML993i242yu3+2bApWH/TjM4NMQAOEE1K0eArlMXexsO75eJTMH2TyMXRTIkFDOy1r7+rXpVaYVeeQPB/Ud0pRyCirEepTVRuy3a89Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ1PR11MB6297.namprd11.prod.outlook.com (2603:10b6:a03:458::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 03:44:52 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::95c6:c77e:733b:eee5]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::95c6:c77e:733b:eee5%5]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 03:44:52 +0000
Date: Tue, 6 Jun 2023 20:44:49 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, "Dan
 Williams" <dan.j.williams@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, <kernel@pengutronix.de>, Ira Weiny
	<ira.weiny@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] tools/testing/nvdimm: Drop empty platform remove function
Message-ID: <647ffd31b0800_1433ac29422@dwillia2-xfh.jf.intel.com.notmuch>
References: <20221213100512.599548-1-u.kleine-koenig@pengutronix.de>
 <6398cde3808c6_b05d1294c4@dwillia2-xfh.jf.intel.com.notmuch>
 <20230509055546.pw3rippph347hugg@pengutronix.de>
 <20230606155707.gzoj5qdb7ebf6z7n@pengutronix.de>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230606155707.gzoj5qdb7ebf6z7n@pengutronix.de>
X-ClientProxiedBy: BYAPR07CA0049.namprd07.prod.outlook.com
 (2603:10b6:a03:60::26) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ1PR11MB6297:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c46bc2-55c3-4b15-5220-08db67098ce8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aW0RK4WjTsrKm71xxSZjyMa4czg2f3np9J03iYK3rNf/WUp5WZDQ4kc1nUyrFliy3RW7Cfg/Q4j04yow6IELM5R3H3lNbRDogIAGDYNqyaSk3I9+TwgRIB6/woHc+wpayAXOWDGK4P5fLJqYudzMcj7yocE1sbIn+us7LM+UZBf0T6MAzgVSYtSFRoPECL2IWEXziyM+glbd9/DvmV3YSpEqJT6rI6+rGJltec/vcf1qkgvumDl3icrDSECFHOIzjBywOP5q8EuQCfhX8oxa45xfadttOv8OYxLz4OlKtQjIdjX+pGS3zv4f60d8zPkZuw34/Cm5FtYH3q5Kca/tEcW3yQ3fuIG7UZAxBM4flxFGXpb9BL4vVB8J2elwEa7/yWQgc0W2w1XvJbUIYh1IVES2ux3kTo715oq1Jry//h9a+eZ7+1epVWKYHApkug+1b8qZtyKcAuot3X/vdhPB9zdJNiJWNm5CXd+d7givvmtp8988gBzd0C9a14rR/3hMYjGrzve4DiuY3IQAAtb0rSkoZMifQEb7sgx3S+ku5qw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199021)(4744005)(2906002)(86362001)(5660300002)(6486002)(6666004)(186003)(9686003)(6506007)(26005)(6512007)(478600001)(54906003)(82960400001)(110136005)(66556008)(66476007)(4326008)(38100700002)(316002)(66946007)(8936002)(41300700001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?+5SZRxlL0H6N5F4ZQv3eW4wMEy/HPC0XfwbvMsSfGVHQ3RPu4uc46K+JR0?=
 =?iso-8859-1?Q?96451idys8O8xpmQ5sQ8NCFoOZpeoq/ttnGqskSw1xXLonJR7ugdvKzjeU?=
 =?iso-8859-1?Q?Xl0tN5WNqCCRXWSZUdreydSfzsXat7mb6o4nf4rg8NcGqsilKGCYpKJwqL?=
 =?iso-8859-1?Q?8kqWC5oWC5c4b/2bFgOChd18KfLugLCvfPo6VkdG3FO2SAzMJz8Jv6QSp9?=
 =?iso-8859-1?Q?Y2L/A+g/E3RzrFWrgG4AjqeSn3TXp/OwdxbDSeoMTtyhpELfOK/X4UViPB?=
 =?iso-8859-1?Q?d9x8EATpzc61pllPZYKkwxPJRvtnvpSNyWRjI89jO8pmUplltyoWPuzsSY?=
 =?iso-8859-1?Q?rEJWn48VtvbbYrpMZ3g1qt3apBOhw6RR2pjXD3AnL8wEFY3At2tPMtAP7L?=
 =?iso-8859-1?Q?Ig2s3vfth85QHU/KpFpZXfF1krocWluPpLL9B8q/hx1xjaMJgYH/3h17Jx?=
 =?iso-8859-1?Q?DiZBkzS6S/p2uEyOijWMLQiGAPgGKxviq5XexblM39GVWI1QvaFbDOxChD?=
 =?iso-8859-1?Q?Phbqo/3psR0dyCMbmnPdjJ7vBV+c/GcYPCV8mpshiF48SuXGtrkAgOozby?=
 =?iso-8859-1?Q?EEfCkts3ooUttbUUJbRjOZpDPAhdj7ydudVLfjFtRU5SCjKEZIveZx4n8M?=
 =?iso-8859-1?Q?4McOUKwa1PiECSuhrN2j9oXEgo25hcI4o92D0NWDA3AZhYbBdBh0Uu/kj4?=
 =?iso-8859-1?Q?wZkq9K5rShlI/PLBRkacjbKqCNp6hABshiusO6J7HiaDLIEoVNHJJGshj6?=
 =?iso-8859-1?Q?JsKMgVUj1tEq+riV4lN1ypZrGYwsjECozxFKIhH37WZFbrQ3mIJOQ2nwrp?=
 =?iso-8859-1?Q?SpRY5SWR+icymiSHDdrw1yxO6LSGcHkBDzTihm874AHn+8LOQj+SdCWZHc?=
 =?iso-8859-1?Q?zcmICBSThMk6fkz7w8VFDgzM9E4uf8xXvHS8Z1hIlMBel9/YYmIkrmpQNU?=
 =?iso-8859-1?Q?eak/DeRBxFFCKBzIh8Tbj6tvP0WFhDLjXao9z3Qg3ENbofaLPtbjullXrC?=
 =?iso-8859-1?Q?QYJJabGpu0pZd7VnT9P3sEg4+8vTH58NoRjtG9aDfBWW7Mw8em68eH/rsV?=
 =?iso-8859-1?Q?lT/LTMBNW6+0mVh7WfVFOfthwVucshIMeFZzL3uSjxNnVXEGbM13SEtMoI?=
 =?iso-8859-1?Q?EVU/r8EI9PwPcy0WXI4nxmhFVoRBV0m6Njia1562X/f1O+T3+sPwUt6Z5b?=
 =?iso-8859-1?Q?NRT7aC35vsoZdVzfliwbUszWh+30/Co0SDR4dE7MJQxOxGcPtcuV7UK/UG?=
 =?iso-8859-1?Q?l1omdoP8cpw2+PWEAC5c9JhGBUgUMXKlONMghsu60yaowlyiytAW/EvJqf?=
 =?iso-8859-1?Q?b8NCD9Der/eNrwbPR2+6/p0wWynnO67Z7rkRbNgSoUif/Vujeqwsv/8RmI?=
 =?iso-8859-1?Q?Vi5kVd1zbGMjuQ2LK8U2bG7l4kPfEBgoNjcKLdr16NuqZWbldGStNxm+x3?=
 =?iso-8859-1?Q?yUCqNNd2D/LE1NYos7kTYizlLphjnMevinJ2ojfWBhSP4MXutznwkGAiTb?=
 =?iso-8859-1?Q?IsNnZTtmMkjYkq47L0MaEcx1bgkk29J64kP/9wrl2PZS1XIfXabIf1615x?=
 =?iso-8859-1?Q?491Q/FJaZwg20W7pj38qwgVgAnfTrRglD0k+oMn8cYbDSuVZtjZORWJrc2?=
 =?iso-8859-1?Q?t0+3DDEOv7S8v0S6lMc7fvoMmo0Lrk7oSx2usvCTeDgcsWtkFIE6xqbw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c46bc2-55c3-4b15-5220-08db67098ce8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 03:44:52.2601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNTPapTYj9BZO3zNurj5l1RS9mptAm3Vq2g9K7nGxW+yKpZb1IUJPyD7uFifR8L5vrcih4m0h2/9M5oFBl0xf1qPA0TASRp8Z4RqdIOnA/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6297
X-OriginatorOrg: intel.com

Uwe Kleine-König wrote:
> Hello Dan,
> 
> On Tue, May 09, 2023 at 07:55:46AM +0200, Uwe Kleine-König wrote:
> > On Tue, Dec 13, 2022 at 11:09:23AM -0800, Dan Williams wrote:
> > > Uwe Kleine-König wrote:
> > > > A remove callback just returning 0 is equivalent to no remove callback
> > > > at all. So drop the useless function.
> > > 
> > > Looks good, applied to my for-6.3/misc branch for now.
> > 
> > It seems it didn't make it from your for-6.3/misc branch into the
> > mainline (as of v6.4-rc1). What is missing?
> 
> I don't know what was missing, back then, but the symptom stays: This
> patch isn't contained in today's next. :-\
> 
> I found the patch in the nvdimm patchwork
> (https://patchwork.kernel.org/project/linux-nvdimm/patch/20221213100512.599548-1-u.kleine-koenig@pengutronix.de/),
> it was archived. I dared to unarchive it, maybe that helps!?

Apologies! I queued this and then did not advance the branch. You should
see it in linux-next shortly.
