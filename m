Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0272D53B
	for <nvdimm@lists.linux.dev>; Thu,  5 Jan 2023 16:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672937315; x=1704473315;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=z85iQK7BcnMhVjWhVA0b0fKz4EVS7q6xDD1VtnYsUwI=;
  b=Df5MvxFzoGADiD0e1opA3g//a04k72oGOxiqWpKbwPrA5y7v0zK2/rpB
   hBhYBEJnajSayKixnrzoD677X2wu0lsuwBjCMIltUL9Z5RrJOl+YeKXHZ
   OvsJ7n9svb4qiSvJN8kU45IZpAoyWUCikXEcKr/KXynjvHpSV31tHrSzZ
   mR2UL0kT95pjarQ7a1o3aXzqQb1uj4DKMry6bCRrGPJWdsx3aLZx0nRjG
   nKfzRweF+bGWTWzrsRsJvX08Cevwwcpqjgn+PUnT3fHcFl6voIGfJ3qKv
   UuWwYyfOvDebl0KWBQ/2OhAYf9cL5skQkPMSLMfMEVW0m0TPEkN2SvO9x
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="386707193"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="386707193"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 08:48:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="633209222"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="633209222"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 05 Jan 2023 08:48:32 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 08:48:32 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 08:48:32 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 5 Jan 2023 08:48:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JoPFBcLsvQm0OHjorfFmuJyQbz85t0tXwJ/IKlDgmRdgnVJhl0tfKVmWjcur5pHxvv5nUs/x6zzW+DOkdt7PPK8E6LTu1Ll3jnn8N7cikGHB+wq+PeQjQ0y4JpHXUB5lHQsAwIvo1gv1ihiWOSTuAsovU4TIsISBftmMvfei9UTL4bFRkMtvlqr6QgP3wdBaeBZJCo1rwo0LlvDUDlSlTb7K053tXAqNExxPcLY4DqvK4MzTS+tYDbdTox3mjU7Gwu/fus/8PsIvCY6cLxzPFhTEJeNMIqm6qIFjOoL+YMUFW8fQcUtKEYS8tkUHgh2uF8jtcNpUuK7YMg68XW+aag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tBlC3gdWLahX5iPwApB6ZMNkBlwSx+hK3fav7YyQIIg=;
 b=LDhMqUql4GYBQXlrkNcDkP/se33bk+AdsRc3+Ck6LTUPZeNM9GHChakbqOzl9l+NbOvst4RDAX4zF0NUtwvPr+5ARn6seV+liga0ol8O6Ze4ir+jci+qrPogknPAHBaYpXdcclb5SbaNFi7iJiLhflDsH+VulmLnrt5kEBaBWECU+5p6Tj6NZXvhC0wzSl0hiAOOBA+KB+05SRpfgig7UE/AZd95XAchbEHpqGgDIHb/W5MXf4/dRvoE3POca4sAYGr5qhKQQkn6rCDB2vZuIWiqW7JePCDc6ehMp+Y8qjWKoaCny2ylwr3eyX/EtuKQTotVGlYGOg9U00DqScBNAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MW3PR11MB4601.namprd11.prod.outlook.com
 (2603:10b6:303:59::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 16:48:31 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::8dee:cc20:8c44:42dd]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::8dee:cc20:8c44:42dd%5]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 16:48:31 +0000
Date: Thu, 5 Jan 2023 08:48:28 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: "Paul E. McKenney" <paulmck@kernel.org>, <rcu@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>,
	<rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: RE: [PATCH rcu 11/27] drivers/dax: Remove "select SRCU"
Message-ID: <63b6ff5c6b954_5178e2945b@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
 <20230105003813.1770367-11-paulmck@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230105003813.1770367-11-paulmck@kernel.org>
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|MW3PR11MB4601:EE_
X-MS-Office365-Filtering-Correlation-Id: 16d1ee3f-dc07-4bb3-a31c-08daef3cad12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ISRKk+g12hwvmLeheCjORzPZnigkZPeq+wAgtEn1/tzIgAa+24lSWhiTIvjt1nkwNCjcO8KblhV8oVfTHLf08w2AIGClTIo1kKKt8ZYuxYmPAtXENdmH6/41FajYmMKL5T6p4RkyBxZxRSH+kfehgICZoz5dwyAj0S/1SOc5qOe3uEzcw5ziplyq+kOswUNN+qNjTMdp5aGFvLr+tKvA8okrzT5Xqg0izk+n2g4+g8onjdHgXHMOj0qjluQV2ludJLmw39mjl+y00F8IVHnRKyOI02XcXS/9MSoRu9RT/l1I1pHN6nM1HSxcjHRIAkLZvSKCsUvsAeE848nDTqrnLnuXrDlONl37Ve5hspgBbR9TWtcnpnKgPU0glQ40HGnnTNg8YIryASsRWOnB0vrzVTTLO4JqZpVt8416uIPB7zntYczwVUcblyZdfUzf5n6SnalOe2Q1Pth4V/25qS7Od4epavoQSmSlzJ4Q/PNbFl4tHAMxBbpVtzVLULzu4tBsf6okRVrdSmJOKflurFnfd7iEjAuMJeFYSEDVatZjPfX/FO44pipv20y5oVAJ6/cr6o7IhFOY3ay5nkFNgrYjIEn5ODH+fuYPy/AgWmdD9jysjsU0Ov62b6atSNaCAM/+GyLwkxYSpS1kf1MEO/x3zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199015)(86362001)(82960400001)(38100700002)(4744005)(2906002)(54906003)(41300700001)(5660300002)(4326008)(66946007)(8676002)(66556008)(66476007)(8936002)(316002)(478600001)(26005)(186003)(9686003)(6486002)(6512007)(6506007)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UW9Qpi0aaA+dxNsaunfFiUxn9S94XlwNZOHySREWlWAAez6fffCYTXBQn2sc?=
 =?us-ascii?Q?jcKJBQJtkZFeGE69j71gQ9hFyDGcW0L3tX7lGrip+0hZp1WsuYj2np4yFEpk?=
 =?us-ascii?Q?a8RsieGnoQCYSUoobxKVOYD9XZtDRF3/8lVL0baZsr6lGo2DU90nC4f/ttLA?=
 =?us-ascii?Q?Jwe3bdoQrx8SuhhJyQnzS3skbk2Kph0Hl2t3KNA8w8I6jI/93QDBkkbyeQyc?=
 =?us-ascii?Q?jNupX0x/X+SD854Zlj/5xkegMDscpFFtkCGTTX8i7b2ya4SImVyCkQaKProY?=
 =?us-ascii?Q?1pVEYblUmKn2xMRdlZCVLD+RdworkFLQW13vQ1LP2pmQ8JR7zo39ogx/8SXF?=
 =?us-ascii?Q?IENBVeoMcJKj5sj3tIk740kJ9Bc3nD41VcfFN+Svbn5NMn+xf4oQYK6/AV8V?=
 =?us-ascii?Q?e2HH5BGDGLWIaklc7Iuz4y6mOZisE7cHwR/sU9zAsDygTc7K84S1YxMQCIg/?=
 =?us-ascii?Q?Jxxk7UZI5nm44Bz9tlVFy+mKE2ZcPJ/uhBsAztyVB3pi/+5LNVl0MPQ1BTtD?=
 =?us-ascii?Q?pr0HKC/ZUbcD5GDctXL3IiEzMSY6GHlBdutB9ExG5nG0/DEjfIqPPMLykbZX?=
 =?us-ascii?Q?OGJOcpQhsv0hwBfloJ35K+FFwxE9J65FMmAPNWHfp1gAUtAbjdGcsfzfkPrU?=
 =?us-ascii?Q?ScjHC1rhuHz11vxLFxlWXe/mYmWDNJvIR/+e21/ZNw8CyEba8u/jckP+Zo0J?=
 =?us-ascii?Q?MNaBNJASpUBfoXSx1vZfRsDYTgDkAlUiTdvDRKPOM+KsXSlPYD630P8Q2Iiz?=
 =?us-ascii?Q?8qDu5fQhw0uSjbANBr363eQth+5RjYMVJiuUFrlR5wzarjlNSdGUMcXxELCo?=
 =?us-ascii?Q?z5zj+lnFzk/kBUo9LlkdX4ROSx07Ne6RZkd9OkL/fIpn/dxmXptiu4ilKkkr?=
 =?us-ascii?Q?GJH0hq2NVGeKDtaYIZBk5yy52Hrvd6fUfXv0ACMyjxR7R5QYyBZHS+4hKthO?=
 =?us-ascii?Q?YWklkQitSJHw02ewyaD33Sg1NFZ2krS1nv+cn97/f+tj7Y97qmoPJP/b4v6t?=
 =?us-ascii?Q?oxgggj0iEARfd05ZWGjot4g5MjdbvCRngrvSczilQagDgWpKMx+flhADbZrw?=
 =?us-ascii?Q?R0xuWLrtmEUvX9R0eRgFaUJmdDH01xItsrCeIOh0Cac5XzMaCL0gTNuqHvQC?=
 =?us-ascii?Q?EgUzc0Y1SPQpx6dbS+JfxbOQ/9H3bxBfRNEqojqAnhIWHAmYybxxRlGuPTgS?=
 =?us-ascii?Q?++FfZ2ru6qsH8TRUffI0C3FMj9nE3PQb95wUneDHEfYKKhW90ACFJaWX21eK?=
 =?us-ascii?Q?6WHGtNNx5b1Tbs+mm1GishC2FugE9Qpzn5seZzb+ePRdw2SW5blrcqPWTHXM?=
 =?us-ascii?Q?73HsP4emGxwUZmSNbJWMFcEjuNok99NaKe0mTCK930FmfcRR5Fq522myce8S?=
 =?us-ascii?Q?fUf1GsG5oM6kjUtzU2JdJpHV36qThNirbiWJ4/noJptImd6sFURKLEbhRitz?=
 =?us-ascii?Q?/3wHAYISD7m2E3KXdMup9DkPCRzQySwAUsPW/hEW0d4VlLy9frJJxwMR6hX9?=
 =?us-ascii?Q?vJOuDgXX+8HE+1xGbn17APp7HcX7AiOEk2NFuKV/5uh6cI41hNJX4hmpqHHj?=
 =?us-ascii?Q?004TDekgh4qbYqKKXk+9PDC/bAlEcLaIXdOVZg58IrUgiCtZFzzD5A3VUoCw?=
 =?us-ascii?Q?UQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16d1ee3f-dc07-4bb3-a31c-08daef3cad12
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 16:48:31.0852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f6Dq5tFJy2UuRdJ/MjpUtF9e64meUEYqYkLhRZYLyQzdwYeGiUwXP14DY0MVqPdGR2OwJICV54I2xhEKlecuXoDWEiCLkI2pqGwUi+EcA14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4601
X-OriginatorOrg: intel.com

Paul E. McKenney wrote:
> Now that the SRCU Kconfig option is unconditionally selected, there is
> no longer any point in selecting it.  Therefore, remove the "select SRCU"
> Kconfig statements.
> 
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: <nvdimm@lists.linux.dev>

Acked-by: Dan Williams <dan.j.williams@intel.com>

Let me know if I should pick this up directly, otherwise I assume this
will go in along with the rest of the set.
