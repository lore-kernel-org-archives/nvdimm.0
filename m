Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0471615C99
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 23:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667865081; x=1699401081;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cuIoDSjys+EBDeewiu/khgpaSJcA2EsATfMQlvSE0Ng=;
  b=drs/k+/Hc4N1KS4MpvU9WnhXauyQ4du0MbkQ57qeK0vSyB+udhfFJOz2
   LEqsiWwc9HOhdsZy+xssQyK1uBGZHBCfwz6OKrMJwXnJHR4WeIeZSLvvJ
   MV3BPMhxeQSsEcDmFfiYtckEhHebNNiyishqUp351wLlmmOjlDEoyRNAF
   9etD2TYr1Zl1zhsNkyCSVsSxgzg0OBIs584mLqObEilRq5jG+71DTvufH
   ABrBnRFwkrYSsmrzEG5OPA0BmW3lvg0421J06OFELsN7OGFq1zmCSXQAd
   tFRH6lD8+/tk9D/ZzXhrVWepvihm35GyJlVshs25RRPVdNZ+94ySdaUyq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="290943070"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="290943070"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 15:51:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="699687207"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="699687207"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 07 Nov 2022 15:51:18 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 15:51:18 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 7 Nov 2022 15:51:18 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 7 Nov 2022 15:51:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHCESi8q/w4zCN7hYCJ7gQ+WHyVLIZbAp7qN4D8wLLT+IAALsMhL9AAZD8yzt8Hb0pPLA4KrXLYrOhdR4AT38wip3s9AjFr2nG/aO+5XmW8O5M/zbywM56gPXjizXEJnvljBGhXXQZ0666LuxAe8uiFmUHoFvgsavVUSKHB+BV0zXK5n7ROGpLqNBduDoaV8fvwEhaPulNgerU8GK2adSQJmtPpRDuU2oEk9O9D4KmeQUdJlUEKBSPXlVjowLO2c5sqOHqBF54T6pskEzIA5QaVkPUiRYyPc9wS2NFO4CwJqsTi+9ERnU543t1/D//GkD1VEp0EmDhJS9KV5TkAn/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cuLnDRyHialqxRrx56dVWgSpMPIcJjGLYl0kEQFi+44=;
 b=FuXSDi0lngX2eE9ewOPaYzm3CxqMKxwpLaRKPcGvkUcsgy6nlcx5oMfoL6jGl7v3+sEe7ij1kTGnh8FNlgwl6/zl4ZsiJl4LQGL50ZsxIEQa011qtoUSz77kF2wLS3m4V4yKbSKeMO0FMnNZQD9y5vvShc3ckRSUHJ6t1raqdwEqe9jfh6J5j7V47DLotwjsUgQnAkw44fhKbBM6lGfqokMxJXlQIxmebBOzXgipB0j8x1noAUe9mM12UvSbMKYLinhs+y4YfTM3bLOdkQZbMuWQMJWkKOmXvBBHeKq0cqrIuLr44ecSJV3Ubqm+MwT+LBgcHnwdOP2EGpSPYewV3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ0PR11MB5120.namprd11.prod.outlook.com
 (2603:10b6:a03:2d1::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 23:51:16 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::11a0:d0ce:bdd:33e3]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::11a0:d0ce:bdd:33e3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 23:51:16 +0000
Date: Mon, 7 Nov 2022 15:51:14 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 06/15] cxl/list: Skip emitting pmem_size when it is
 zero
Message-ID: <636999f27e29a_1843229496@dwillia2-xfh.jf.intel.com.notmuch>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
 <166777844020.1238089.5777920571190091563.stgit@dwillia2-xfh.jf.intel.com>
 <Y2mLGxdAAQjcflbq@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y2mLGxdAAQjcflbq@aschofie-mobl2>
X-ClientProxiedBy: BY3PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::17) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SJ0PR11MB5120:EE_
X-MS-Office365-Filtering-Correlation-Id: b9c56ea9-96e0-46d5-da5b-08dac11af5ce
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IwDugsSHjW/B86MK5/HRrDTalqKKNJyidYGJcsoXGRuaDuxc3+5oLxHCMzHc02f7ucrKLq/zHFRZCJeDC7T8U135FarOSYc1fE5ySd1A80X5c291JAWBJrqSGs3t7lviBkf3lNIdQNiqJaf1ybEhGNbezfRbNCI9oysJ/8jrZksk58TrgmUxbXF2TqXKlLFqe0rijJ/r9Tpcb7n0Hxhsdao1yci2qQlsI1Hqw5P+ZIeRDqBN66J7mZXiqsK7fDo71xn2Zu+yGZYEMzL/7/6olR+18HbQNeLBXbpxYQw3450dP+hz8W5yKsxQWzlddmq7RigFmAUXLZM1RZhqWcI3C3QMXUb+Ko9NuNlUn8CUhlJNQ8TJRx+S7WC87IjoBAbk3CuEnhNOUhYlThFZTwmwm7qXLerEMYdl0i7GR8EutK5bX/EBb1ILRslaz5tS3DMS6VLP8kBAf282/sPgcsjcNEPztev7f7b2gvPJoy/eDkHChAF8306a2znaNyvDI9uk+91MyAlBXm5Sf/fOBq3VUZmy8v99jtf+G4ZtOz3UtLxrZcdLfHyX2Ck3pUnL7xDzjcaiG27VvgKLglx/VBe5PHMb4JJRrwBToEK2qEsoOAPoUlSsvKMF3kEfdN8xnNRNZY4Tz8MxEObcTvzg32Fie/vDmzl/QISrMzlcCpYMRLM25LJBbjujfPt5wTVGGlWfhwXH3UYHSBkmVxlAVPSj+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199015)(186003)(38100700002)(9686003)(6506007)(6512007)(26005)(83380400001)(4744005)(2906002)(316002)(478600001)(110136005)(6486002)(41300700001)(5660300002)(8936002)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VXtN8Fqswkzl2f2BVmtR3IiuCk7lp2g5503eIqjFYZMlN3cuUvBoc018jgtW?=
 =?us-ascii?Q?vAjcrp+YmswYc/EpnfRaR2wUV1E/HuXpeQaqk/yDTitDRjFpJaf+/p5TweZy?=
 =?us-ascii?Q?1IGCJ27G5HALmsXSz2ypqi9RQFctZsjd/IT1w+qqj5xB1IY2Snqj99k2uHpx?=
 =?us-ascii?Q?amHK9qkU9rrBZs4hdU+HRMfWPhfH3+NL2EgjmPz+pDlHQEWrtHPb3/6VGi8i?=
 =?us-ascii?Q?dh+eN1L0nYYsL5A/oEs/Ql3jRa2Eg/vLmbVhuKdk7YF6pxhnQxRih2bkKRwh?=
 =?us-ascii?Q?FgaruzvShgoIgReASxA8ElccaR8vNQUaVAOGqj5/Szi5zic1vjVhZ3Udj32K?=
 =?us-ascii?Q?63+iAcdnOO3GFQEKZQBwWwAQf9FOGq6wuqZbo2p43/CAKtdiw+Jby5fLEjRA?=
 =?us-ascii?Q?Jvp8H+u26n640NxmLbYnHHnDdYRx408RvtiIw9AU/EG7DUpwldtxheDRHbVP?=
 =?us-ascii?Q?NOmlDnvvU3cSHqK0yv1uox7vP7lR6mjbMyCLyO2bBmbfM991wzA9xd23PU8V?=
 =?us-ascii?Q?+eshP10+b0ksCdgYR48dx3cKMMpc7puG5u7bnXw+NzuuP8GhjUNNdpL5Hjln?=
 =?us-ascii?Q?OpSNBeA5/kU6JtJTri/8ovwlG6X+i9o9Fqk9NHINCArR/Dcipb53izH/Lq+u?=
 =?us-ascii?Q?IFWPH5oLxjLvug2DqOEeirMUbiJ6/8q1hRcg1YLDW2+XrbgWawYiiNqCa/nz?=
 =?us-ascii?Q?L3nCzxoiUEJG+qPZi8Qk4ebJmMsxWK3j55S4TgXthtlPqv9NUa6Gg3q4uZKx?=
 =?us-ascii?Q?xUVxvV4A//hWfoUDkH3+AncA1UEoIAjFw824RrYfafVADl3240n8MgcPTXN3?=
 =?us-ascii?Q?SCL5pa1cGDesdZsr1dASyS2LUPFHGWDla6oXp8SzMqVrW2R0XCjUAxAKFfo2?=
 =?us-ascii?Q?dzSkI1e7D/JlQE/IGsJkd075IizrYw2cIr9Lzu/1B9KZsKDnVGRVTS4KJ3P4?=
 =?us-ascii?Q?5fgwDYyM31BypOJZ7ct2xcJcxmlhoOuASuisa4soCB/f0YWn+sbUhv8vw4kU?=
 =?us-ascii?Q?CJm0zyaDZ1yEX8o5gC4Boy+TqjpsAsB0bEdK5IFCXBcOgWiibewbnkyn9+PF?=
 =?us-ascii?Q?IQlmghZkXDgEPsBLcXs6lwH176H0pGL8JP5rdqB8wYsEUTR3vCQHR2l0PF+1?=
 =?us-ascii?Q?Zun6lhMaNEPV2XhyBh6YgY7IJphRBTkTD0lGI19ZpZry26bxwmoqml/Hfjah?=
 =?us-ascii?Q?IMCS5ki65zQqSi8UmtVrYPU24xWWWff+ZqmnNGMFyjDXj7qMfnfedwpg4r8e?=
 =?us-ascii?Q?87UaSzWxnQrVthdACbt3Mc/HCVgb6xFch2PVw3qAN0HwF3HDGs5gdM2Vrvaj?=
 =?us-ascii?Q?BKr2XbhdFO+P+y9TfnFA4ObyOxmXPinJkyNLT96LrN4tcaJPoiPNZ3HbYjfU?=
 =?us-ascii?Q?2mFETmKQkWvD6MWg+ZKFpJaWuspBTqiDHU55KNVPHmhSDMI7clpWIa/OgRdC?=
 =?us-ascii?Q?VEptiSqCZo6Vg9PiCOgcTUCI998tHl73++WFj71r9xCRHrHxm3Bs6oMugmIW?=
 =?us-ascii?Q?psI8j0R1dVSBuavC4MwvaW6R/QC9iR4CHvTAjBJGkr1NKDNjh3kuAiMzRiXv?=
 =?us-ascii?Q?CQ94gpsDXsIzRELMa9N851Is0l1t5Re4WdDuMcG2pzuFaC7erJLPuOxSKt41?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9c56ea9-96e0-46d5-da5b-08dac11af5ce
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 23:51:16.4881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXaN1N6PF87mSMUxvyJzO7MNV/qhEwEL4g9r7lAIKM7j/GnPRalJ+yPnnTwd8MELdRa+ZgLa+zA1xTROL9VMno0EkkqpYYaw+Ek7lH+w2mc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5120
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

Ah, good catch, will fix.
