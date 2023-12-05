Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038836E585
	for <nvdimm@lists.linux.dev>; Tue,  5 Dec 2023 21:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CPFzfWrI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701811350; x=1733347350;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=uz6aFUBtF0mNhSVGGl88BZKxF+a7aD/3j+vYLQ+fIZw=;
  b=CPFzfWrIxF50qybS4KSm0coOdf1WHYBvbCHjMzxbgDON/64j7/dkYCrq
   h1svzaUX/7DdwnDdPbr/2ZtAj8eGpHJyrkAfaegW2LNs9UvwcxcWCHLqR
   5FBLwcmKdm7MD/n6UqPVtSf65JYfUTZFGu9Ei/55cXBuiA9gnmlgOlnBp
   dNrDb/cjl9+PbfMvjsjs2xwYkKsyjgKDwQ/Xx2SzdOZbOQYaSj/66BOZ5
   oFexsLUNZXGA981tUZJ7ffZWmd3fB8hj+LAkuqrI6Gos1MciINguFmorL
   j9bqJhyHWzOXKuNGeGY+HZ2S//bSMAvO23HrBA6790f3d3qg+DbuD+Nk3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="384369927"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="384369927"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 13:22:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="914941102"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="914941102"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 13:22:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 13:22:29 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 13:22:29 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 5 Dec 2023 13:22:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iWHzsD+uYTKMMCbXLOC/odq69pssH94jjTMWkXG9fclQeSSal8sZYz1UzYoMHm/ZLZHJEF6APWf1THpgsP33eHRd3/zuAx2uf7AgbBF17UlLsnNE32Ao1vBwUfLNcgYexuxT6xELgsJa69uxDlK32tWtNVU/fJ28Y1MxIRTEgbCEMCG4uNVFIQhNQp8n0Clsa/v1SqbKAnHdHEHwrYe0kw36Z51OkBgSoKn6YbOf5gjVBVVKrftARtcB9ThYm5R5d/c08YVkUctX111bhOEPe3hpNOaMAQKLalq6BsFdDC/dStfqEdk7bnPZxoufofwsglT4YUQHS1XLiK3qfiC/Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2lVKHJkp/27Jv2qt5g3Ms/QQTRmwWQa587Nx7P8l2E=;
 b=CKx44eqHbsfeGZJLmpu8h3ZcJnSwe8M8nirk9si0nZp5VWtaYBc16N7vPEdAneGvqtvEp7zu3qVB4M/lXIoYnymJxMPrVZ4nRqX0jK8noj2eXtD40B48OwfZIH6g8gej2XvMQAWnu3jm/bj4WFRhLZHq30QDodeKs4D/iKuQAVQhAqKV/B1M+KkvftoOwPPhZu8eESfyExQYEEjXHUcqqaPV6gS64i/tKmw/4be7Y8IQaPHkhnLpxDoKsDs0djcw7V8VBChwU0urxnTdT87gRp+yZbqDtg5S/3G/xazAYQD+svhj+zJVDdGUgvs2PWgfY7oODHs7IzBDSdFqRmOpRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA1PR11MB6735.namprd11.prod.outlook.com (2603:10b6:806:25e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 21:22:27 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::da91:dbe5:857c:fa9c]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::da91:dbe5:857c:fa9c%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 21:22:27 +0000
Date: Tue, 5 Dec 2023 13:22:23 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl RESEND 1/2] ndctl/test: Add destroy region test
Message-ID: <656f948febeb0_182977294ec@iweiny-mobl.notmuch>
References: <20231130-fix-region-destroy-v1-0-7f916d2bd379@intel.com>
 <20231130-fix-region-destroy-v1-1-7f916d2bd379@intel.com>
 <ZWo2f2eWVtsJrYD9@aschofie-mobl2>
 <656e14d8285f7_16287c29422@iweiny-mobl.notmuch>
 <000bba54c1a3cde1aa63bc8052c01e745835468d.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000bba54c1a3cde1aa63bc8052c01e745835468d.camel@intel.com>
X-ClientProxiedBy: BY3PR10CA0023.namprd10.prod.outlook.com
 (2603:10b6:a03:255::28) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA1PR11MB6735:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d6d79d3-3772-44be-8580-08dbf5d847d0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iNh0Eiz08BCpE9tIqdKybcpOdzBjDqX5mOoKvRjeyNHI5QGjL5qfSGVXrEPY/qN6jej1vPl/cd3NeJff9gKQPQB++jylN7DVjsbhYBkcTmdPI885/AQnqeBq11E9hGJQrCj6LJ3LcBZbLqBarVnk/zHqVmdv4QxD++S3CAGgNQN4n2rwT7j4seZCoGxvQZ5rZX+/IVQkKEw4Vc41LMyCdwEP56jWjkB8AjSzYDgcLhvsxnluM69eS2iuie/uo5PWX2FeJ7NDFemPDBg+FMiPdq1UQLa6861rjFmfFvQ+JdNgc/Yl7RNqfUz/gL9KLanC16rzjqJE05WgP3qBjnG+r4U3Cqk3PX7GSyl5qAWVRFGg4DVFJ5mgHie+W8Qm5GHcEUI0f/QuT1vO/Y2ivFTspGIkh/y4aFhFIlIPM/fw3cfnqzdSkoSuxOC8D03ybqaKToREZqH1EmF9X6EFWZPFYS6yUz0ZhSWjWZ7Qbypd0G+tEskfs4YVl7Yh8VKGs/KLi3+AIdh+sRUVOEupXJSQQijyFlLdcTXXPDv8o/O0Lqhpw8tSW/U+Ge92ZoKknub1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(396003)(366004)(39860400002)(376002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(6486002)(478600001)(5660300002)(6666004)(54906003)(66556008)(316002)(66476007)(66946007)(8936002)(4326008)(8676002)(6506007)(110136005)(86362001)(44832011)(82960400001)(83380400001)(38100700002)(41300700001)(2906002)(26005)(9686003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?xFy2H1G5aF0W2niY7Rwi0IkRopRF/X5Q1/EpmuqJJrA5TZn9guYZErLwVE?=
 =?iso-8859-1?Q?J0dKHWBb3jsoXwMw9JDqsLaFOyNro/5mJRpnPuqJthOFy0Vp06omzbYmxc?=
 =?iso-8859-1?Q?/QBh1w8NaOenI1kM3SjSVSNc2suvkEnoTePj34FYd8B4HFcigR7Vh9A2+2?=
 =?iso-8859-1?Q?E8cJOI+1Fe8OF1OvblCF4hNGsHhvwAdIrwbKuIg23pspgJKzuSFVBl+sKD?=
 =?iso-8859-1?Q?TYlWhibteJBHYuP2IsKXqRRpZ+1l9X+SDBpdelwpVqox1I2LPZUUlmZxm+?=
 =?iso-8859-1?Q?ZqnFjJVDzoziy2McS/nYNJ8CGWZCrJod4Cd7lPUT5ZGdjoLVNHC5dNH0+4?=
 =?iso-8859-1?Q?RjVsaq7MOzyfpaQK11s4dXAExLXRKktlB3VtvNMY7PJX4S1sRbqXjd2k03?=
 =?iso-8859-1?Q?OhwzYhcmfexb6pAjrzKESiRV+MM9C7tr4qM51yUVSp4MiWGpDHOMrFpdrD?=
 =?iso-8859-1?Q?XFiu2s5pWndNziLW8oKK5EfqXaRqKLJ8/MMUdE/19WZ5GmNgTX1yqyWJ7S?=
 =?iso-8859-1?Q?ZrpZZmARR7mssWwrYbt6nCnSouX/hCkh1sABloFECPGPPcROvDEBKScj2p?=
 =?iso-8859-1?Q?XGT5OlIVuJjhU1Pg3uIdL0JFLFUnzikG6ZJvTQWDJjC96mf4JrOp8RfXiu?=
 =?iso-8859-1?Q?IyeLfTJc/6UjdjgfYNYZnRiwHgcWX/kQkqzlimjelH+iwh7URX7OGoL5Ss?=
 =?iso-8859-1?Q?JuTf5OXBe6BAxsGaBKEAdrXgRhDPfg/9iNAB3UEekoVgWHLxwNSr7tCYTy?=
 =?iso-8859-1?Q?GqYoxN0KxQfA2e5DmcWGfQNLFASY9jptpe9oRyWoixcJTEMDanV1y64VDj?=
 =?iso-8859-1?Q?YWnSNdOgZrMI8O9r0gfSlYpqcTUd92noh4y4wvIbt7NF+n3R3j1CoQQTYF?=
 =?iso-8859-1?Q?Tt+KQd7PCyxpiHvhTTd1j++oLN2owa7SCMQdHIUrHoqJ5/X/kSNV78lPRQ?=
 =?iso-8859-1?Q?qL8B8gGsEuQSKIN9rPdOYcAhVvV9YlhfmGBfDqhQpNMVUu38tXuEk/bhc+?=
 =?iso-8859-1?Q?JTrGy462rG4kxRhvT0PZvOgYXej4fwsWGlmVJdy9bbT2zABPzoIccNO6iz?=
 =?iso-8859-1?Q?2knR1hYGwY1yqojIFc8gqHBxMLb+SbTvurRwqqgnhkSzeekQRnTkRyIKk5?=
 =?iso-8859-1?Q?1bGTTeUVce0SBSXmLXz6O836fDdgrqEp2oico+C1708SKbELVKY4Ya0U9/?=
 =?iso-8859-1?Q?HnD028PslttGRVtthJczYTraNp7G6ymyl1tRtdY+esree1HAfoc0xSZrFt?=
 =?iso-8859-1?Q?AuBlVfVcaTwYKepcQeiNcw52l7gPTLCKXALJQ9p4ry1LVnZCkj3mj5SUEY?=
 =?iso-8859-1?Q?QxQ25WWT6NVJ83c0e/1pBVEHLbeBDxa0NKgXIOYe/AzG+BzlSDhdtypzrP?=
 =?iso-8859-1?Q?3yZVNhpO7uyPbvlJZBHNwkJ5zG/bmUHUMscLS9Im7779UXa99XF8GD/x1r?=
 =?iso-8859-1?Q?C0Rvpa358yejRqpZ6Fo3iQaLT+dB4+COYCqY0i/etWv69vXKmaLePEIi5L?=
 =?iso-8859-1?Q?CPEmo6+HH0TR9SoCsJ+URlMcQeXUoz9w0+cYM2aL81aCVBpA5OhokJ0EPq?=
 =?iso-8859-1?Q?Hj1LfLKhx3l1WuQv+kFctiktfmb/YQC4aW0vD/vwIx/yivstpY6YMwYDDA?=
 =?iso-8859-1?Q?rQZo1YKhX/yFNtThbXgq83CnW+coHvjGuj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d6d79d3-3772-44be-8580-08dbf5d847d0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 21:22:27.1685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9B/UKPtVM9QhLRSCqcg6RPn/XfFcJcIz2B2XzdvAfbEBKWfOMz6ns04oI4mFWb2vDcmLSaEd7aLGHsWD4X78lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6735
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:

[snip]

> > > > +# Find a memory device to create regions on to test the destroy
> > > > +readarray -t mems < <("$CXL" list -b cxl_test -M | jq -r '.[].memdev')
> > > > +for mem in ${mems[@]}; do
> > > > +        ramsize=$($CXL list -m $mem | jq -r '.[].ram_size')
> > > > +        if [ "$ramsize" == "null" ]; then
> > > > +                continue
> > > > +        fi
> > > > +        decoder=$($CXL list -b cxl_test -D -d root -m "$mem" |
> > > > +                  jq -r ".[] |
> > > > +                  select(.volatile_capable == true) |
> > > > +                  select(.nr_targets == 1) |
> > > > +                  select(.size >= ${ramsize}) |
> > > > +                  .decoder")
> > > > +        if [[ $decoder ]]; then
> > > > +               check_destroy_ram $mem $decoder
> > > > +               check_destroy_devdax $mem $decoder
> > > > +                break
> > > > +        fi
> > > > +done
> > > 
> > > Does this need to check results of the region disable & destroy?
> > > 
> > > Did the regression this is after leave a trace in the dmesg log,
> > > so checking that is all that's needed?
> > > 
> > 
> > The regression causes
> > 
> >         check_destroy_devdax()
> >                 $CXL disable-region $region
> > 
> > to fail.  That command failure will exit with an error which causes the
> > test script to exit with that error as well.
> > 
> > At least that is what happened when I used this to test the fix.  I'll
> > defer to Vishal if there is a more explicit or better way to check for
> > that cxl-cli command to fail.
> > 
> Correct, the set -e will cause the script to abort with an error exit
> code whenever a command fails.
> 
> I do wonder if we need this new test - with Dave's patch here[1],

I'm not sure.

> destroy-region and disable-region both use the same helper that
> performs the libdaxctl checks.
> 
> cxl-create-region.sh already has flows that create a region and then
> destroy it. Those should now cover this case as well yeah?

I thought it would have but I don't think it covers the case where the dax
device is not system ram (the default when creating a region).

Ira
