Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5101842
	for <nvdimm@lists.linux.dev>; Thu, 23 Jun 2022 04:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655959045; x=1687495045;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/A/cJYuJMgXT+oRBUPBZ99cuD5tr79aP2zDUUZy9NBA=;
  b=KQ+D7LuYE/4f0LtAcmaTzCYU8DOdgMVaExC0tILsje/O39IOpxtwPA0U
   b+GgiHHfaXvCgJFJ5rArmVMJNWXk0jqalOFaL0PmKc7tUif76CcMayHFZ
   PWXZSdh72YWUmS+yPuEpV1cNmsKK5pDSR2jQar+wrM880ar0tHd08t8Nr
   5LUipak0YM6WumJ8hvliesDbd1HwS3x50ISTIqrnfHheyTzzlIJTou5t1
   53RLbO286R/DkUE/b7K9qzh+FdQHki8BFt1RRMQ8gFgFdYbzzXaYYTk3+
   Ldv2h8CWqppdlyP+xhOmvFpZR+i0fJTSZSvvXPbIpI2BnhnD606RILm/5
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="260439891"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="260439891"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 21:37:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="834455337"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 22 Jun 2022 21:37:24 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 22 Jun 2022 21:37:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 22 Jun 2022 21:37:24 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 22 Jun 2022 21:37:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EuED5GlF1YdGGUnUccKIbXLERyyLXz4+PtYn5U3gDAnlVjmfHODY/T0WOKkt2USQkMLC/kb3lGGs+aXxIMIEcuK8r/5co4bWLrXkqZOGTaTKhEb3Yz/At60aOcZZEQdYCmA0kuer7YQ1BEAU8KqBxfgbecy9jrOZ7PvYxxgXNe3ALvT2uwSBfpjF6gE+nFGOBy77zfDT2V7owjwZi08o+QQuGM9wuDxVsjSOAE/plGBMh/KtE156/lPbuz/6aZmA8UeE5PomnP4Mpq4Q5nsglGjHo7JLjmJ7VsuGVFFmVcil3cmGDQxuhi/kkH0fW15Ygn8uikTAexNiQx0Igc7kag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/vwiwCVEfmIZ39jCXL6ac8YOg2CoPSLCnKafVk2NMs=;
 b=ct6xoPeTx9bTZW12QscnLiTIZMJGcNbDFKPVnG5AoXopbvW66nXipk+t2JHsa2lrIvljZux99UXgwooR4XoNE2HgJw2UdEKwtsHlP8enzHdvVNe0AEfHedvNAPPE/31TGoEuY6CN86/XvIRe9xoFoTXwnxc8wWNt5j5+RXlHVb//Q92uJBCRke8h+/70drqAYgV9RaG6b2RNNtVbAQUl1wb6AWL8udeccD3ATf2mu1hFL2zt6skaOkIIJz3nT7VpWaqDpozv/ENsdrzm9P3oSXTrUygcXFeUCVTM9fPlUEPZMz6w/VlCGsjqZxipD1IZW+u91a2Px8QQe139cEiDSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SA2PR11MB4938.namprd11.prod.outlook.com
 (2603:10b6:806:fb::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Thu, 23 Jun
 2022 04:37:22 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf%7]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 04:37:21 +0000
Date: Wed, 22 Jun 2022 21:37:19 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Chinner <david@fromorbit.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "jack@suse.cz"
	<jack@suse.cz>, "djwong@kernel.org" <djwong@kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Gomatam, Sravani"
	<sravani.gomatam@intel.com>
Subject: Re: [PATCH 8/8] xfs: drop async cache flushes from CIL commits.
Message-ID: <62b3edffc887c_39a8fb294ac@dwillia2-xfh.notmuch>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-9-david@fromorbit.com>
 <2820766805073c176e1a65a61fad2ef8ad0f9766.camel@intel.com>
 <20220619234011.GK227878@dread.disaster.area>
 <62b258b6c3821_89207294c@dwillia2-xfh.notmuch>
 <20220623011757.GT227878@dread.disaster.area>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220623011757.GT227878@dread.disaster.area>
X-ClientProxiedBy: MWHPR19CA0020.namprd19.prod.outlook.com
 (2603:10b6:300:d4::30) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e50dfa3d-6bca-4ef9-05a2-08da54d20fdc
X-MS-TrafficTypeDiagnostic: SA2PR11MB4938:EE_
X-Microsoft-Antispam-PRVS: <SA2PR11MB49380ADFDA77E5EAFD9DE725C6B59@SA2PR11MB4938.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1S30nxDWj7O0tYAy18tbOWYjBrxenOEpW+bls15U6RpDIEO9SUWn5no8fgl2d3vkXlU4bG3shhbIuooNO4nXYGimck7FbIBwthw8nuiPpaDsTBmronWVCYXrKD8BhSKGZPxKdTpa4wggUFG1vz6JONrB/qBYYao0zA5J2UZ/SGwzp8gPxnw6kKjEL9nUrCJJppjrqPpdsmRf/brwSA5qPHcLKcNgA7fjav5t2PAco/tYyIkZq4RMVkrtyK/taY4XUrSGo8aM8Jdm2L8N5Zt7AxtznCCmKGfwuJC2UtsMjfT2VhfOSm6Jc1/rZ9nGOK8wfTM7OxYmJjgUQmVMRDlbc4ko31loR0f0JKTSBKXXCaNMBCleugqG9wDKssRH8QzlW+ZGmNCRKlSXS4nk32JF7PdwiEGycZkcXudwp21+j8yizwPoSYTGmdVlyjptb+oDHr7dfPZIOVXwwObmR2z1QJXUYhEz14t0HG2CkmcmBrLlo9GV6jmHbMIdqXfNqlYFRcalcLQIvHKN8q+V4inGlHUi+mCtZjc48joOPWHmO/HOQaxoTOGY+4COYJTe3dyFoKn8XeYREe3uBPa92juDc+nqTlbgpx1HT+5tGk49AbwP41ovhxQuR0eLF2R62GbN9JRlJjC6G4mhXyuHZoMl5Xbfm+bNQ9dCBFlaEUaWy+QAO1D+r70NCZPgD0c4NWXXFrbP15yp0A/rMEAEKdE70A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(346002)(366004)(136003)(39860400002)(5660300002)(6486002)(110136005)(54906003)(316002)(4744005)(6512007)(66476007)(82960400001)(4326008)(478600001)(66946007)(8676002)(66556008)(41300700001)(9686003)(2906002)(6506007)(86362001)(186003)(8936002)(38100700002)(26005)(83380400001)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s98D3PpkSnjn02NI/McEIMBseYqcPLaxfGRKIZIfgtZbd8URuPCI4YCpwERs?=
 =?us-ascii?Q?mCOPRNJaKzjqOQcBxbUxY+vdd3PB/8FxNvEk9BuJHx7vRCYqUHzKJZEQzFZI?=
 =?us-ascii?Q?oqsH5r0fTwem4jp2Q/rouwY559veRNhNDXo3rX+IfYkp7j+ktzsGXqPuhY+E?=
 =?us-ascii?Q?CCwsnar0LiH+O43Wzu2F2twVcGJ9aKK4IDuAENmxo/jiN0QJR19buj3onQe8?=
 =?us-ascii?Q?+WEQmSgNvfFyu3bkhghi5hXixhunwSfF5mUcHIcR+53q2Lb0rkvYMToFiq5R?=
 =?us-ascii?Q?QuRhL8+UD3XDGX7VbNefvjtBvR1i52+QjdVwt53yq2YXtXTM3cNBDdBDyHOw?=
 =?us-ascii?Q?M0Si4XRWGCulewQvbHiLB3DINgI9UugdxlVo7QQKSD0Ohf6rGhiTKPrsQdy+?=
 =?us-ascii?Q?BsgZNgVtk5U5f29wTrjIti6wb+hd7b5FpJI+hyIt78tAO4zRDP+6Lh6tEuoy?=
 =?us-ascii?Q?2ghU1S0ebLg9dQPn5Y+tv9O9u0MctZGGOUcAMEWRESi6N5by8PmziPkyla2E?=
 =?us-ascii?Q?zFY9Hy92y3dNd0ehpiHcQETkO2pbPP7ZtRcq1FX1Fv2QDlLnzReT4ejtiL9L?=
 =?us-ascii?Q?SKIPZkLpX/BO/eI6ZQQb51IcMve0CdWCvVAeKSy09sv7mowBonOZHpi8cXfe?=
 =?us-ascii?Q?q8e83N2hq0d3v57E432ON3i7coL4ghVKCHyX/u1D/o1PK8E4rwwg91/NZg4M?=
 =?us-ascii?Q?Y1u4INb2eSkUYrCM0gKsb1Tsa7CC8oVAqoN890gGcn4+IRNcpk6fd9HUU/TU?=
 =?us-ascii?Q?FZaiBTcL/sltvkxpkgL2ayepa9FADKoOW4gbXKoA7nrEK35d4v8W+dT0lzt0?=
 =?us-ascii?Q?+AviIzPS8mW02S9Q4m1n2+fEr9w0WvSktubjE+zZ7QliNBsf24Hb1naGLWGO?=
 =?us-ascii?Q?71NlWuMJHbkQEsv9cerGt1gJ69hQ/aEzzKIhHzue0EnwLBiYTPOBDoq6SU8Y?=
 =?us-ascii?Q?2uwOsSqW+Y/dVPBFVKu5VN1WIiqLtK/mz1EsNHmpqavWLGgRHGdgupomVPTH?=
 =?us-ascii?Q?cmc8Ww5c/RWjZ3fvYnMxkIPveaLIdb+HLIwkoreJtIQocPdxSrh0fLjECETG?=
 =?us-ascii?Q?t41xRHvKMD6BMne9Gx6TTPXRdf3paeTf5SDsAzZ+tYK7mH7sEPBdGYYwM5SV?=
 =?us-ascii?Q?J8Aepj8wfVQXU9hRdde3Rym1QRNm/VT0G2SbrNZkcEz6Meg+K0P/Oy2BpQ3C?=
 =?us-ascii?Q?Aw1bxrx0+ZXV2HpwoBmLHdEOW0MyikWj74ybSkxHlnGcP5t96x9ZmcGHgWMc?=
 =?us-ascii?Q?aA+txVcUOCu6rBiE1Vc6dnFUgVvubgcqUhCnqfTm774p7iW+B+yG1F0r8dBZ?=
 =?us-ascii?Q?6lUD4rkTMUVbKb440d6ieRJJqYSJE7zxrOClLL2Qk4PQnI9/sJXXxPaeMNpM?=
 =?us-ascii?Q?lLSnlr6OD8UL8DX0PaGzCo0TaC8yaxr1IQg4n0WwiR4dNUOIRQZ+2wHkLFG1?=
 =?us-ascii?Q?YjUZpDU1Z/3F7xFNGfp1KumCesHcAFALSnBAw7GVOHeUqB/VtVfOT6ZDsJZn?=
 =?us-ascii?Q?KPicEkJf7dQT7iMLCC4d6QhZji+CzKURLRveG2c/m478z44fX4yfUZgube3I?=
 =?us-ascii?Q?n4Sh/h4boLxUt1e3PqEtvIUSlU6TubBFoUfzo9//hf1rZC2MNlwVdb25bKpf?=
 =?us-ascii?Q?a+cUIirmu4EZOWQyiUGfVxx9vQ24Q9DUXwafiRMtMUhwe9cnwnitgLFWh2pU?=
 =?us-ascii?Q?ZGCy08sXQ5C2YoRBrf+mbo28xXUHOfYwlZYcP1jJor26h1BvNC1jqtYX6+oy?=
 =?us-ascii?Q?2F9+1iMUN/NK9Z0HXb8Vhce23ktXzNk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e50dfa3d-6bca-4ef9-05a2-08da54d20fdc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 04:37:21.3539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OhGRbkNHoV+t4uKWujSTz2C4hxfEq3K+piUGqa4NZKDe95EMQFOKLkOdbBGCMMeBNmkalX4pMSdbx4OqM6jFsAkuV9tmpvRFTfKT1nZRJpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4938
X-OriginatorOrg: intel.com

Dave Chinner wrote:
> On Tue, Jun 21, 2022 at 04:48:06PM -0700, Dan Williams wrote:
> > Dave Chinner wrote:
[..]
> > One experiment I want to see is turn off DAX and see what the unmount
> > performance is when this is targeting page cache for mmap I/O. My
> > suspicion is that at some point dirty-page pressure triggers writeback
> > that just does not happen in the DAX case.
> 
> I'd be more interesting in the result of a full bisect to find
> the actual commit that caused/fixed the behaviour you are seeing.

Ok, the one-shot-in-the-dark revert guess indeed runs the risk of something else in
that build modulating the failure.

Sravani, lets attempt the full bisect for this to add more confidence.
