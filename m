Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C4F8F6F
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 20:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670531020; x=1702067020;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=elLlA5dQLxYd6otwFjxxcdsfaSJ+NszZ+U29tGvN0vk=;
  b=OyKsoIagPLV80PzqcQZG8zgpHeQph8i/61Z+qNdywGHP2o8qi1oo3KKc
   6+uIdoEPo4XJPyEZv2dmV9thUz6sRCp5vivF3h1QSwVN7tbX2ch/d1ZtO
   EFSOvoYP4/8M+sGWqBD1LHwHpGp7ID9E+HHvWodI0M0wsP3XtPJLn8ked
   t5bSzrdY35smzVEk9wDRUbWrXzl07f0l5w3lqihTfF1boMY8sZgSBN5AS
   Hal/fyk95yDEKptJ/UVqRPlzRkUckurj6SjQabf/CsPRN0yIrYgo6MHtC
   Lnmxp7rBvn47C34bcCjUR6gSowWrMReoXXEVSlOf45OBkJ8bsGNaIEQWd
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="319156107"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="319156107"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 12:23:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="821482505"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="821482505"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 08 Dec 2022 12:23:10 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 12:23:10 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 12:23:10 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 12:23:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFGMC3zUFB7Tlmpxjufm+Zepxpnvud4Go611nZ7nxpSHC7uQbYzvN+4oip/Do/faQaUY3aq8VHDDrVG1L1mMR72XIImM8JDhFPF4CgTo1KlPQz1sSN/fJoQOM2/0lI0QJnN7t1gWYCUOjpaH2Z29qe/2gCHriap5UlDF/tl/We1c1ygtLw/mffsqFax4G9ihM+RP9xvQmoMz4cxHEPEiU1BVaAYx0AwfeJbUzvruSBLElhdSAcG4WhEQDDIobohtwho4Mg0Nn/pVL59JpKHzFFDe2Nuzs4H1FPRi7OwK2l6MagDPa7htbKsT9pQciX0RSNkrFHyrxCV7Hv9RcvhCzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=beQqm4fT+wBfl4cFex3xcBjFdm4G5s4e8v76jctgdss=;
 b=jJnFhRCFitdMmPDi7HttEjPePa4o3L33xRz44zj1BL1bQyqiKH3UmbOLh1/4LhVBgY/kfm74FNxCt29OoxkWJZVJUsqSvLtYQ1HfKobY+bxIZ0i/Qkf0Kip2NVmYdjir8wfeOfnxr84tvqbpmmKDVs4+YLAvi6GYyVhJKKSGJlYnMsUe3C0vzmsYasAmTCzrjj/eOKJAqrQjvueEB0ILAYOsR11wso4qxWT7JXiyY4OkGU+Lcfrv5Z4CGGce+v6sm4pRCWMnmeLiNqPPkirnO34Jc9xW+nVQDHsEsMsd44A6My7GvTMWGwXrZ5FHfBZWdBOpiamdTokQwDkAU5kIpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM4PR11MB5535.namprd11.prod.outlook.com
 (2603:10b6:5:398::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 20:23:08 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 20:23:08 +0000
Date: Thu, 8 Dec 2022 12:23:05 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 11/15] cxl/region: Use cxl_filter_walk() to gather
 create-region targets
Message-ID: <639247a9d7008_579c129440@dwillia2-xfh.jf.intel.com.notmuch>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
 <166777846906.1238089.13466320510516058152.stgit@dwillia2-xfh.jf.intel.com>
 <07dc26a831b0b93f28db45729972a23d19f21205.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <07dc26a831b0b93f28db45729972a23d19f21205.camel@intel.com>
X-ClientProxiedBy: BY5PR16CA0009.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::22) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DM4PR11MB5535:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e429b39-bd71-45a8-9b44-08dad95a0505
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZgaVBYGMRYVEJXALvbCkATtGVXRNzFxUmGxi2E+/z4H+1xRygGxfMrOxPCcwKoNjWuUozuW1nXVuZNZE486aym+8y2bDU19Z1Kec9xUmzSqhjHfMpWaBE3vvbIVCsBmdKE+x1JZ/RrkCbsBnIriXG3m9CjEc/uoqvbXwYiweYnzgGYCCcLJczBsM0VyYCh5cDI5det5nyXZXu/LcBPmz6bx+OM0Vnk20VP2vzR0mp7FTPRZAjyQBWuKrijjNHNQgkfCFAuFsM/K66sQeM7SxIJBxvQVuTSOBPiCS79NI3KEugRvQ70ibzbBK1jUzZLXWXjIlL2SuwG9rrvdVKAgWlXe0DdSqs/3412LhjWbcE2tPCiMA/hWcYZDJfQIxmRg+PtQvrumSmy95rB7sxi5DZiCJfXk1suvJFvYz4dJAMAfCfW10wGMGdOKLvd3sbtrDHZfKPGVYRsp15dSM2fejhbfF9eL5a19maaPCwg1bXnhKo4JCMr0K3wbQ+S78wmBvLEjX+oj4mLI4KFs0xUm9w8omfsBT8umLUHssR0owDZS7wDOmELdmCVm0x7qqFzpaQ6wZuV0UEjhO9IE2KHUF3VX+Og9fr7unajZXQoalewLaOjY/tzMbahMoPHKeTuezDZtOiUVEPd1c7p7JFCvwEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199015)(6486002)(478600001)(6666004)(66946007)(186003)(86362001)(6506007)(26005)(6512007)(66556008)(110136005)(9686003)(316002)(54906003)(8676002)(66476007)(4326008)(38100700002)(82960400001)(41300700001)(83380400001)(2906002)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?iVW729NaQcwASU0BGeEUhuQ/80sg3gQJIaYfF+owpKFHDqvR0w5/oT4OnB?=
 =?iso-8859-1?Q?M9KkQzGKJ8vXKeM+cc5J2Dbqh0qfflHW3dnQe04gI87PikbV7O89khhMUn?=
 =?iso-8859-1?Q?CQRxV2QuJ85XHkSwWvMh1XY7ennJe0Aw3S45nJQSR+RkNNm3nWTYlWbtrH?=
 =?iso-8859-1?Q?kgf3SJHp9J8/+SNo/Fp+r/l6jxgZblpgihlHSs+bHY0ffNScR1GIzsW2xS?=
 =?iso-8859-1?Q?vyL0NnR+liWbx2+V4RAIiQ5ANDSmK/2WpOBPDSN25MrOCq6pnbyR/x83IS?=
 =?iso-8859-1?Q?e7ezhzL+nHUy3P+mpfdtGY7sz/JJ70p5PfH60Bswow8YEu/IBE3/Slzjkj?=
 =?iso-8859-1?Q?V1i4bkolpCOBJd1g2EiJDkNh/TLx8tbPuIDh4A9QymfVOFmElgPDRdOhX/?=
 =?iso-8859-1?Q?l6mt7/6FeBqqlNEeDTQXxN9t9zEyJGeVbLQQUFbhu11wSyWHQeb0RT7458?=
 =?iso-8859-1?Q?NAZCxphZMQtZwXxE/eZO0ea/zgVTmMPk1k7jAsODwh6qXq1XaoJgq3mcXY?=
 =?iso-8859-1?Q?h2vD0L7UOmaD/S9OIXLedbORywIUOnPPdGmtoW7+gT2hRIqADk83sQ2s7L?=
 =?iso-8859-1?Q?SlWHY11ek+uEengurWQ2Zpv83Mk6xJvGpjl0Zie3f/liiNtvQcLGsfoLmD?=
 =?iso-8859-1?Q?F0ou2etvAtW1hjUK2C8jg6wEHSRb6i7ES6tQG7RpUgHqTb/JTZO2UGkjbA?=
 =?iso-8859-1?Q?y8scoMpUtMWBugskOhq8g7ESwMb/PTabCM3oK3RF3fcoDvnWx2ebdNBDL9?=
 =?iso-8859-1?Q?3nuqwofEbvKf1iyvZle4mhKDswn27KNA6rHrNhC0AINBh2vTJZs6tvOFMQ?=
 =?iso-8859-1?Q?8A925YMdoO7pt4n3rBSg9eycbH3BTuUDVBJ+gCxw6mYAH8M/N7hwXqbdNG?=
 =?iso-8859-1?Q?V8okPpalckOqGP7wF0Tfk30JCCEFR4ugtfcgqeiGLzJ2Wp9SABgcgN9Qzt?=
 =?iso-8859-1?Q?JxPPOLC6BVJfop0ehqh5PWiW2NAyUgky5B21cdnEmmDPIEOmoowLeHXySp?=
 =?iso-8859-1?Q?uH+mBhCtBgq1QWZmBOAAbWAdZRhfHt5rV3WyIV4E5Vg3H4ssavgfvnSY7o?=
 =?iso-8859-1?Q?fQ9K+j/oHIH9Nf3RxjoEcpC6kJmNlf76qCev1Pquk/i6HcCF6d6+YM17+O?=
 =?iso-8859-1?Q?pXGNwZysR17OUqraC7iqv+qSDu5yW5mub23q+aKazThbaKrnCEtOU0Z1RU?=
 =?iso-8859-1?Q?yIJcdXNAqpwMwjjKd1frdMs6FIrN1JyIr5rhGwB7iSmzmQ9lQ519p6zWGV?=
 =?iso-8859-1?Q?bhlFtullIWgcUv9UpS1FGGZP7eSXy30y+gB3hrIV8jP/1WyG39LEYw9fLI?=
 =?iso-8859-1?Q?TCQFw8bhP0yRawiMtqiuVmsc41Joovr1sqhBAVzXXrbQ/LTu1jpC1wDXxe?=
 =?iso-8859-1?Q?yc2/3T8UH74QzT8VuCsQagg9ft6WDTN9HGrDnL/z3y8cr47T+lM02PlskW?=
 =?iso-8859-1?Q?tgwMnRDJPQjjmDsNzswEB4POB6I5JXd5bvoYmmV27DJ08r25DPeEQrq6w8?=
 =?iso-8859-1?Q?UDipijfLzmbYZBG2S0ockZvp8uI4h8IwLoGDsr6suIV+HHYRqxQuMBUmMK?=
 =?iso-8859-1?Q?su29SXUKl9cKHjo9I0U8h6obDIRC8D4OdGtazCKr6un5R0UauwJCyKHff+?=
 =?iso-8859-1?Q?c8ApOEpHNIwNkAHyOsyC8X7LlWNUSW/6vvkC+JtdILv3B6jNnMmh3Vnw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e429b39-bd71-45a8-9b44-08dad95a0505
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 20:23:08.3696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2SfPHt+yCqnIejV5ajbgCHL9izB2YORjmX0WN6P4zQVTtuyhvQXM6vB5il1Rys/vGqc7YgjygIYBEObbDA+0h4hjDxTW9XnpcnFBBJHOSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5535
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:
> On Sun, 2022-11-06 at 15:47 -0800, Dan Williams wrote:
> > > The core of 'cxl list' knows, among other things, how to filter memdevs by
> > > their connectivity to a root decoder, enabled status, and how to identify
> > > memdevs by name, id, serial number. Use the fact that the json-c object
> > > array returned by cxl_filter_walk() also includes the corresponding libcxl
> > > objects to populate and validate the memdev target list for 'cxl
> > > create-region'.
> > > 
> > > With this in place a default set of memdev targets can be derived from the
> > > specified root decoder, and the connectivity is validated by the same logic
> > > that prepares the hierarchical json topology. The argument list becomes
> > > as tolerant of different id formats as 'cxl list'. For example "mem9" and
> > > "9" are equivalent.
> > > 
> > > Comma separated lists are also allowed, e.g. "mem9,mem10". However the
> > > sorting of memdevs by filter position falls back to the 'cxl list' order in
> > > that case. In other words:
> > > 
> > > arg order     region position
> > > mem9 mem10 => [0]: mem9  [1]: mem10
> > > mem10 mem9 => [0]: mem10 [1]: mem9
> > > mem9,mem10 => [0]: mem9  [1]: mem10
> > > mem10,mem9 => [0]: mem9  [1]: mem10
> 
> Hm, this does create an awkward situation where
> 
>  cxl create-region -m mem10 mem9 (same as first arg order above)
> 
> can behave differently from
> 
>  cxl create-region -m "mem10 mem9" (behaves like 4th arg order above)
> 
> i.e. if the args happen to get quoted into a single space separated
> list, then it switches back to cxl-list ordering as "mem10 mem9" gets
> treated as a single filter string.
> 
> I wonder if we should add another step after collect_memdevs() (or
> change memdev_sort()) to return the arg order by default, so:
> 
>  mem9 mem10 => [0]: mem9 [1]: mem10
>  mem10 mem9 => [0]: mem10 [1]: mem9
>  mem9,mem10 => [0]: mem9 [1]: mem10
>  mem10,mem9 => [0]: mem10 [1]: mem9
>  "mem9 mem10" => [0]: mem9 [1]: mem10
>  "mem10 mem9" => [0]: mem10 [1]: mem9
> 
> i.e. region positioning stays consistent no matter what combination of
> field separators, or quoting, or word splitting ends up happening.
> 
> Then (future patches) add a --relax-ordering or --allow-reordering
> option that can fix up the order for creating a region successfully
> with the given set.
> 
> With this, the only two options create-region has are either try the
> user-specified order exactly, or reorder to something that wil be
> successful. The cxl-list default order doesn't seem as a useful 'mode'
> to have as it can be hit-or-miss.

Yeah, that timebomb is probably not something I should leave ticking.
Fixed up now, but with the 'fun' of C string manipulation.

> > > 
> > > Note that 'cxl list' order groups memdevs by port, later this will need to
> > > augmented with a sort implementation that orders memdevs by a topology
> > > compatible decode order.
> > > 
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > ---
> > >  cxl/region.c |  274 +++++++++++++++++++++++++++++++++++++---------------------
> > >  1 file changed, 175 insertions(+), 99 deletions(-)
> > > 
> > > diff --git a/cxl/region.c b/cxl/region.c
> > > index c6d7d1a973a8..e47709754447 100644
> > > --- a/cxl/region.c
> > > +++ b/cxl/region.c
> > > @@ -40,8 +40,10 @@ struct parsed_params {
> > >         u64 ep_min_size;
> > >         int ways;
> > >         int granularity;
> > > -       const char **targets;
> > > -       int num_targets;
> > > +       struct json_object *memdevs;
> > > +       int num_memdevs;
> > > +       int argc;
> > > +       const char **argv;
> > >         struct cxl_decoder *root_decoder;
> > >         enum cxl_decoder_mode mode;
> > >  };
> > > @@ -99,16 +101,148 @@ static const struct option destroy_options[] = {
> > >         OPT_END(),
> > >  };
> > >  
> > > -static int parse_create_options(int argc, const char **argv,
> > > -                               struct parsed_params *p)
> > > +/*
> > > + * Convert an array of strings into a single comma-separated-value
> > > + * string that can be passed as a single 'filter' string to
> > > + * cxl_filter_walk()
> > > + */
> > > +static const char *to_csv(int count, const char **strings)
> > >  {
> > > +       ssize_t len = count + 1, cursor = 0;
> > > +       char *csv;
> > >         int i;
> > >  
> > > +       if (!count)
> > > +               return NULL;
> > > +
> > > +       for (i = 0; i < count; i++)
> > > +               len += strlen(strings[i]);
> > > +       csv = calloc(1, len);
> > > +       if (!csv)
> > > +               return NULL;
> > > +       for (i = 0; i < count; i++) {
> > > +               cursor += snprintf(csv + cursor, len - cursor, "%s%s",
> > > +                                  strings[i], i + 1 < count ? "," : "");
> > > +               if (cursor >= len) {
> > > +                       csv[len] = 0;
> > > +                       break;
> > > +               }
> > > +       }
> > > +       return csv;
> > > +}
> > > +
> > > +static struct sort_context {
> > > +       int count;
> > > +       const char **sort;
> > > +} sort_context;
> > > +
> > > +static int memdev_filter_pos(struct json_object *jobj, int count, const char **sort)
> > > +{
> > > +       struct cxl_memdev *memdev = json_object_get_userdata(jobj);
> > > +       int pos;
> > > +
> > > +       for (pos = 0; pos < count; pos++)
> > > +               if (util_cxl_memdev_filter(memdev, sort[pos], NULL))
> > > +                       return pos;
> > > +       return count;
> > > +}
> > > +
> > > +static int memdev_sort(const void *a, const void *b)
> > > +{
> > > +       int a_pos, b_pos, count = sort_context.count;
> > > +       const char **sort = sort_context.sort;
> > > +       struct json_object **a_obj, **b_obj;
> > > +
> > > +       a_obj = (struct json_object **) a;
> > > +       b_obj = (struct json_object **) b;
> > > +
> > > +       a_pos = memdev_filter_pos(*a_obj, count, sort);
> > > +       b_pos = memdev_filter_pos(*b_obj, count, sort);
> > > +
> > > +       return a_pos - b_pos;
> > > +}
> > > +
> > > +static struct json_object *collect_memdevs(struct cxl_ctx *ctx,
> > > +                                          const char *decoder, int count,
> > > +                                          const char **mems)
> > > +{
> > > +       const char *csv = to_csv(count, mems);
> > > +       struct cxl_filter_params filter_params = {
> > > +               .decoder_filter = decoder,
> > > +               .memdevs = true,
> > > +               .memdev_filter = csv,
> > > +       };
> > > +       struct json_object *jmemdevs;
> > > +
> > > +       jmemdevs = cxl_filter_walk(ctx, &filter_params);
> > > +
> > > +       if (!jmemdevs) {
> > > +               log_err(&rl, "failed to retrieve memdevs\n");
> > > +               goto out;
> > > +       }
> > > +
> > > +       if (json_object_array_length(jmemdevs) == 0) {
> > > +               log_err(&rl,
> > > +                       "no active memdevs found: decoder: %s filter: %s\n",
> > > +                       decoder, csv ? csv : "none");
> > > +               json_object_put(jmemdevs);
> > > +               jmemdevs = NULL;
> > > +               goto out;
> > > +       }
> > > +
> > > +       sort_context = (struct sort_context){
> > > +               .count = count,
> > > +               .sort = mems,
> > > +       };
> > > +       json_object_array_sort(jmemdevs, memdev_sort);
> > > +
> > > +out:
> > > +       free((void *)csv);
> > > +       return jmemdevs;
> > > +}
> > > +
> > > +static bool validate_ways(struct parsed_params *p, int count)
> > > +{
> > > +       /*
> > > +        * Validate interleave ways against targets found in the topology. If
> > > +        * the targets were specified, then non-default param.ways must equal
> > > +        * that number of targets.
> > > +        */
> > > +       if (p->ways > p->num_memdevs || (count && p->ways != p->num_memdevs)) {
> 
> This falls over when doing something like
> 
>  cxl create-region -m mem0,mem1
> 
> as @count ends up being '1' from the single filter spec passed in.
> 
> I think doing a 'count = p->num_memdevs' (below) should fix it - we
> don't care about how many separate filter specs were passed in, once
> they have been combined, and the resulting memdevfs collected.

I think it matters because if someone typos something like "mem8, mem8,
mem10" we want the tool to validate with @count at 3 even though
num_memdevs would only return 2 in that case.

I am solving this by turning the @count argument into an in/out that
gets updated to be the number of individual elements of a target list.
Where @count is 4 for this target list on entry:

  "mem1,mem2" mem3 mem4 "mem5 mem6"

...and 6 on return from collect_memdevs().

> 
> > > +               log_err(&rl,
> > > +                       "Interleave ways %d is %s than number of memdevs %s: %d\n",
> > > +                       p->ways, p->ways > p->num_memdevs ? "greater" : "less",
> > > +                       count ? "specified" : "found", p->num_memdevs);
> > > +               return false;
> > > +       }
> > > +       return true;
> > > +}
> > > +
> > > +static int parse_create_options(struct cxl_ctx *ctx, int count,
> > > +                               const char **mems, struct parsed_params *p)
> > > +{
> > >         if (!param.root_decoder) {
> > >                 log_err(&rl, "no root decoder specified\n");
> > >                 return -EINVAL;
> > >         }
> > >  
> > > +       /*
> > > +        * For all practical purposes, -m is the default target type, but
> > > +        * hold off on actively making that decision until a second target
> > > +        * option is available.
> > > +        */
> > > +       if (!param.memdevs) {
> > > +               log_err(&rl,
> > > +                       "must specify option for target object types (-m)\n");
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       /* Collect the valid memdevs relative to the given root decoder */
> > > +       p->memdevs = collect_memdevs(ctx, param.root_decoder, count, mems);
> > > +       if (!p->memdevs)
> > > +               return -ENXIO;
> > > +       p->num_memdevs = json_object_array_length(p->memdevs);
> 
> Per the above comment, either
> 
>  count = p->num_memdevs;
> 
> here, or alternatively, the interleave ways validation shouldn't use
> @count anymore.
> 
> > > +
> > >         if (param.type) {
> > >                 p->mode = cxl_decoder_mode_from_ident(param.type);
> > >                 if (p->mode == CXL_DECODER_MODE_NONE) {
> 
> <snip>
> 
> > > 
> > > @@ -664,8 +738,10 @@ static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
> > >         if (rc)
> > >                 return rc;
> > >  
> > > -       if (action == ACTION_CREATE)
> > > -               return create_region(ctx, count, p);
> > > +       if (action == ACTION_CREATE) {
> > > +               rc = create_region(ctx, count, p);
> > > +               json_object_put(p->memdevs);
> 
> Should this dereference happen just before returning from
> create_region() since that is where cxl_filter_walk() was called from,
> and is also where p->memdevs is last used.

Yeah, not sure why I had it outside.
