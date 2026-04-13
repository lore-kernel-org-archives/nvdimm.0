Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD673395273
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 21:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776116034; cv=fail; b=c85XTo5UMwPfIc0p9JBe9tBMPxyHZoSICb5GU/xrzvaS+EbX91vGS7hh2vCNHLmGJOO2QdePeHfmMp0X8KEUIRGvjybeE6UEs+wRZskPnR+Xypg1zZfMO37U6DUhhVEaa0oHyKAoT5clw85/Grn6OEMGh4r65/FQc8RR3Bhqsvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776116034; c=relaxed/simple;
	bh=cZORhiR1+2NDHHTYenYqmXw1p/+zf6+GS5alNFQmF+U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZDI0tWQxClhVBNovqkAVki8FhhysG7YiHnzUWmcG1h3WM8UOwRlL5X0ojjs2W3DkHTUHzHp8+FUO7lLFprN9N9C8X05rscoZuJ3PyhFKo2+FzvQO4RSYX1dIEg+jlw5ElvVeolFM/zXAaIieEmzrlXc0p0V2ptDRuT8Z5iMKRZc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yo+G6UXN; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yo+G6UXN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776116033; x=1807652033;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cZORhiR1+2NDHHTYenYqmXw1p/+zf6+GS5alNFQmF+U=;
  b=Yo+G6UXN1O13jH4KnymI3fLc8pyAWLNDtc5H1r4U1p3q87UVDoEE+tPA
   QZ42ctXc2EJ4kz9f4TXssF6OvK+lNYu8fqVpO7P4c/Zw0mN0gajpmk/Tw
   NgXE5KbXeQlTdXjbu7fMM7tQmRLBEQ6l/1dDuO7zWaCcn/DMG3Q7BKDje
   UFla7vjvoiGJAQjCBlFyx3KPw5pjoqj88ApNFn6xKLPXImWHxbi7lKbbK
   wYyjyw3h3T102cv9kcnUdjb9Zk5D7dyM1DtGwV60mZiKro4Q7s0PXq0gl
   7N9mQPv4cingbRXofk7V9552MPua4oO0nUHsOJwTSa7q4pj44UH68JweP
   w==;
X-CSE-ConnectionGUID: OffAWyq1Tx+fjt29pVoN8g==
X-CSE-MsgGUID: C9MuqKcyR5eHJoZ2AH96MA==
X-IronPort-AV: E=McAfee;i="6800,10657,11758"; a="87363990"
X-IronPort-AV: E=Sophos;i="6.23,178,1770624000"; 
   d="scan'208";a="87363990"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 14:33:52 -0700
X-CSE-ConnectionGUID: dq+a+APhSmSWNqjvWc/wLQ==
X-CSE-MsgGUID: heL9s8N+Rr6MLJsTygm3Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,178,1770624000"; 
   d="scan'208";a="228858593"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 14:33:52 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 14:33:51 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 13 Apr 2026 14:33:51 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.23) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 14:33:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QWuUN2OcVKVNLDo/b7vgtaTShVQK6Uq4+1lf/g2QqsI+o4g76NyvUEM5euoF9EHUkjrtpWQpoV2DO/bCocQXZ2CbBQOPQ7V1qQ/QE2YYkDhsI+i0EJYfVUqlJ+Q0JK+rYSCrXjPQ7zEfefhbAXFWY+KnK6uJaKQ8dHKuA8OlJ+n3GLV18u3cu/iYD1bmTNHgiWSziriUuEjwe5SNqWXGr4DcTUbPwsF5HB8L4KwL4t2Q5kmVQ3Lpp+GhiwMTxwp3p3gQuLOilVTAKSx5Oj3wJ3PDAUwNgTIxylxkKm8AcJJMlzQ31XHerLq7FA17FBHx77ngHKpPjn00Kmo8sO44zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XH7iAi+S/V8eihMp6Xv6BJxYMWORSgCkpXbo/r6hvnY=;
 b=j8YI7Sj0YAG9RzE+qMyKGWUGATUn/sYYCngSiH5nFcK1mPZLp7lyK0f+dnCYIFYIkK4bMYKvLggRAxPbqGchxMGI31V0rNEdrEI8+Lc9YkUYevMvOy+LTcSen+toVqVsrSBXgxl+0zOKuwq7bVU4+6FFjJhFeAMoisVsjIstQO/e5vn0clR+Hyep0vPQA4DsXYA1nWDyXPuirAuvmoh5cYK1IzE6is7WQLXGmPxA0PSxx3Qr215yM7WZK00nV6BKbZTvfHfMVb9VMx9vY2Vi52G0r+8ZBr9seU35CeqZjBfC8nMY/Lhu5ld3EpdSJH7tcWjIvVF/Z7m7VusJZnzrRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by MN6PR11MB8242.namprd11.prod.outlook.com
 (2603:10b6:208:474::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.44; Mon, 13 Apr
 2026 21:33:45 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::9618:33dd:29ce:41d1]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::9618:33dd:29ce:41d1%6]) with mapi id 15.20.9818.017; Mon, 13 Apr 2026
 21:33:45 +0000
Date: Mon, 13 Apr 2026 16:37:38 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Ira Weiny <ira.weiny@intel.com>, Alison Schofield
	<alison.schofield@intel.com>, John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>, "Dan
 Williams" <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>,
	"John Groves" <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, David
 Hildenbrand <david@kernel.org>, Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi
	<shajnocz@redhat.com>, "Joanne Koong" <joannelkoong@gmail.com>, Josef Bacik
	<josef@toxicpanda.com>, "Bagas Sanjaya" <bagasdotme@gmail.com>, Chen Linxuan
	<chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba
	<tabba@google.com>, "Sean Christopherson" <seanjc@google.com>, Shivank Garg
	<shivankg@amd.com>, "Ackerley Tng" <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, "Aravind Ramesh" <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V10 0/8] dax: prepare for famfs
Message-ID: <69dd62225478f_200391001f@iweiny-mobl.notmuch>
References: <20260327210311.79099-1-john@jagalactic.com>
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com>
 <acrpbBt5UsWEiEbm@aschofie-mobl2.lan>
 <69dd576924b0f_24f910029@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <69dd576924b0f_24f910029@iweiny-mobl.notmuch>
X-ClientProxiedBy: MW4P221CA0002.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::7) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|MN6PR11MB8242:EE_
X-MS-Office365-Filtering-Correlation-Id: b50eae69-b2d1-4c37-63a2-08de99a45713
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: h2yWxKEd0HjFvAUWIMJm128sZ0kZLtgzRnToOVtwavUxJkiTPStANfUImPdLUdKfTIpRb0cG0pDMjVpO1aNjaX3p4MxiVqVA+Jkcs0u/voaGbi2oC0yIGKWDfhYM2H/AVKuplCpgL//M6dFXfDjaH3L1oBKjcGXVjdSnwWNDrbhoVBaGrqO3rr0Mxw0Un0chFaAfDPcJZeqr/WJgT8i1XfLxmdz/7R2pzr3NssO9+zjY5f2v/5qr/j0EnA3hrSjIu8nK06YoRDe1dIFUMaoxXao8PsKKaMaRhInavUFxOHdnspOjxH0gPm5TiShAiRxwRYJZFehHc4Rp5jPaxSDc5sTkIbdxxYJteFY1Q6o4PXkfoYc/cusVnSlWRT6lfzzC8z1wwakexmY2Q4+543ADkukCTWEnziqP13j92zgACZndoFGBzWiGQ0lZ0Frs0Ju7Radjj3F9xqQEgtI/yVj9W31heO+jQe+ixky9HRBphInsskvC1xDzN9Olu3tYXkzafJUffiS8A7S8q4i46p/l7LOMrKjq5rF806qG7KYvEFaenrb3Ep+wRPwHUgCqrkRVesZDtNMVJ8m+axxRPMPPGvp+lbAlSrFHykedyllbW7uKzKdTLm2XHB7ZDa1yX9G7u//1I0U1fieCM0iPpZt50/guHqklO3eKk3ZXiTuG3Yae5PHjnlPLfAmva8dSRq5aas4M2jymKgq8IerrofBhsXZUA+rqNsKOYs1CSZHmIWw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?owZw0iOygMIww1ldxiuzl39a5tHl9hNyi0KB6qgWo7kltAk+q57F6g9TvfLx?=
 =?us-ascii?Q?Op+whAu0MICQtFPYN2s+N059aP0+3L5bbHqWa1snp6xnYZXAKe6gyT6UqHt3?=
 =?us-ascii?Q?rylKKSR4RdGlHt/AG7IOwsgNP3oc3HIq+ub2GYo8Vc2mftoD+Z6sdZs8srmU?=
 =?us-ascii?Q?15y4MNljMk3nt/3IXHer2iNryC1TJaL6nGVltVFpIJU63nvD1BF5xlaqcgk8?=
 =?us-ascii?Q?qB61UvIeyyJWnjz7TJWhDvGATO/AY8PSTklosZLGy31njkp0boXPpKixAVQ+?=
 =?us-ascii?Q?rvsXvv1seXFYFc3l605q64ncwXUceMEsD538MLYuhY78lxZuj4GPjRrIJdYR?=
 =?us-ascii?Q?zZNcSA5nKrV/rJ5IPynDGGEhOp7fKZdlGZjPThUy6A81MtT90qXjvNTmVeoP?=
 =?us-ascii?Q?Hk2zbfbTG9/4F8Z2K/U62GcLyYEdjTUpNpB4JD44zSgU0QS+o/k/WXHeHxSS?=
 =?us-ascii?Q?vNMSuMeBQ4oCYVhcUXWjnniU4HLE4CVGTFjvRPFHWoCklCc1lqIX0k177P6G?=
 =?us-ascii?Q?fgQ7Ec5TLKFudOFqRCWdKTcXvenMbOQSAAhXfo6Qas6RtP4J0hOdeqKv2PBX?=
 =?us-ascii?Q?Segr4sGtH33IKxxA0KgTEpJKxh8LLbRD31HQl/1ypUpvABa1oSodB23s1p8/?=
 =?us-ascii?Q?/9pkjKD71POwMf91MR+FLNYKePzm5aR352gP7DKNvI0nIrXUujQv7b/gKaho?=
 =?us-ascii?Q?QUpg7ivQkyjRY+GJ7zQgCKxtILkwts1X9HD96pZvDzGiz0sxAdDedfQclz84?=
 =?us-ascii?Q?OHeK7nqBTKNao08VmnDybmyRgq2shr+/rXPO+GHsv4skVvXOu0AL0TkSFy/Y?=
 =?us-ascii?Q?CU3BwiIB1ytLA4pPSDGLqiCROQyfsZKZK/hs//6rZDTvnQPxzw/lEGA6fojb?=
 =?us-ascii?Q?h8zuIhUgeSK+cpgQwDXkQcZXGfzqNL+Kz2KyeG7xrTgfu8Vwkn3Zfw4o5ztA?=
 =?us-ascii?Q?LBbFQVLDe0PoyDiEFWH92UvHBM34MQsEfJxEjbv8fQC1q9BrC6wwEZEt6EV7?=
 =?us-ascii?Q?6qBoJXlvPVfdmcmr6J2ozTJ1aL5O6xkDT494zBUcD1ebJc5Sqo++jTaIpq1A?=
 =?us-ascii?Q?2FZXX3Zwcf8BMOR+U6ca8hutu1K6nEtL32DdHaPOKO6/ZvWp6rboWP2imZF1?=
 =?us-ascii?Q?rANWzeWXXrCim+9EN4MizUerS1jSpaD/MxsbBcxyWsKTulzoJ/2ZkXYaXQ/w?=
 =?us-ascii?Q?vDlmejiCih/HPYnI3cJ8XIn7wHg2KhNFLyeKdWkEH6dA4NxgsHu78FEEhz4M?=
 =?us-ascii?Q?lu3LeCrBjE5RXuJId4DxoV5GG9OvVBMCAY6uphZTFLYBZGIbHA8E3aKWEWy1?=
 =?us-ascii?Q?IpIadqDurlO9GCbwJ/fOO9ahKTeJozMDSqsSmQak2YVD6fQNMFY++/JnD5yw?=
 =?us-ascii?Q?bh9mYAS/E+JVD6+KJlYs+7xclKSRrV5+EZaIHzc6Pc1TPK+bmuEmWvs1D17q?=
 =?us-ascii?Q?FbWLr/k0w+maeTgN/CKOJcdu1lelLb2BhQr7dYs/XDYICP3rZgUL6JyBV+v6?=
 =?us-ascii?Q?SRXoVMCegP0TrgmR4cyV+rM0C6pXf8EO0St1j7uR5TuzrCdwi0UFC3+K7Rf9?=
 =?us-ascii?Q?e/1FkkURsaE4lnFTM+ZEj14gQAoAY6gcXNSQefMCL9TFeHwTSkOsFpu1YE2l?=
 =?us-ascii?Q?cMoN8YiJ6SelI8nDYq8AqecRkMsVYJ65d5tzcwv0E077cGYrairHnm0lwezE?=
 =?us-ascii?Q?Lh3HmK/87P9wUDnYLc9vtMoOv68tD/xmVfO+HWHqVthHHAODozsCYtCHDfcT?=
 =?us-ascii?Q?2VaI6m1WLw=3D=3D?=
X-Exchange-RoutingPolicyChecked: XrLsg7aliF723y7DaJdsmezv3UqM0xb6rvtVh0ccfbEOD8vOvH0RmsA4FMzJqgidotsaOMoj7zBF+ezHYk7fs/BZyDpmWpND0kgtE+Hy5729LrNFCMGgcHfNHLmKrWHlYZHq0Cdv/mkFhZl+m2//IWhVdAJyOtsdkyJeSdVnNPboaHevnpenX19T0dXyJSiQQzZamR6TxrK6JY1lzHEaN6Rj2QociCcgVdOKmd6Fv/c3WEkqNAWJfCx4gFzPsqaZmMZ4Z8cHcMzInnIoTqdDk9b5o4XrOXdeB/HPTixmVC5qRS7A+spOvNLfbs5bBH6p312q6QDiH1aOQNB2ucf+Rg==
X-MS-Exchange-CrossTenant-Network-Message-Id: b50eae69-b2d1-4c37-63a2-08de99a45713
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 21:33:44.9309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: td3donmhDR9w1lGwh692W2SXJMS4MZm2leko+IOwgFHgP1MM19xe2jAui22T4V0iNywUonRpWBd/VVb2miH/QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8242
X-OriginatorOrg: intel.com

Ira Weiny wrote:
> Alison Schofield wrote:
> > On Fri, Mar 27, 2026 at 09:03:26PM +0000, John Groves wrote:
> > > From: John Groves <john@groves.net>
> > > 

[snip]

> > > 
> > > Description:
> > > 
> > > This patch series introduces the required dax support for famfs.
> > > Previous versions of the famfs series included both dax and fuse patches.
> > > This series separates them into separate patch series' (and the fuse
> > > series dependends on this dax series).
> > > 
> > > The famfs user space code can be found at [1]
> > > 
> > > Dax Overview:
> > > 
> > > This series introduces a new "famfs mode" of devdax, whose driver is
> > > drivers/dax/fsdev.c. This driver supports dax_iomap_rw() and
> > > dax_iomap_fault() calls against a character dax instance. A dax device
> > > now can be converted among three modes: 'system-ram', 'devdax' and
> > > 'famfs' via daxctl or sysfs (e.g. unbind devdax and bind famfs instead).
> > > 
> > > In famfs mode, a dax device initializes its pages consistent with the
> > > fsdaxmode of pmem. Raw read/write/mmap are not supported in this mode,
> > > but famfs is happy in this mode - using dax_iomap_rw() for read/write and
> > > dax_iomap_fault() for mmap faults.
> > > 
> > 
> > Here's what I found:
> > 
> > famfs-v10 on 7.0-rc5 + ndctl v84:
> > 	dax suite all pass 13/13, so no regression appears
> > 
> > famfs-v10 on 7.0-rc5 +
> > (ndctl v84 w https://github.com/jagalactic/ndctl/tree/famfs
> > top 3 patches + edit daxctl-famfs.sh to use cxl-test:
> > 
> > 	existing dax suite keeps passing
> > 	daxctl-famfs.sh oops w the new test at # Restore original mode"
> > 	seems easy to repoduce, maybe cannot go back to system-ram???
> 
> John have you been able to reproduce this?
> 
> Ira


