Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58AAA49F
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 22:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669673425; x=1701209425;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yDx2R0Q5x2n1/LO5q/IaIze400Tfe95qCxXqvvfLSnE=;
  b=isTxlukXawy97+s5EtbliZw6aYdTMeVpheR0SEKtMDpY+/lX4Iypf9ML
   4FB7COHmIO4qr31GlNd9Fw/k9p9dwqSuak27J27J7Xx4VT4uoz6XrxkKz
   O7yR9kKzxPDI8UB+O6+FWM2mSaMi/6E8yJMaDaGvq3iubSwQfHi5PxF5o
   u/XbnyOrrgmcoGjaGrBIocYvXXUkxXSIm5P/dL5WGG7PtFFhyjG2XT7bq
   EGOV1FWtZGnEcy3gOa9wYlyVv1Sz3sk8b5DvdsOm5bc3O7JlcwkRON5do
   cDnFgnn+/mOWxi/mIjI/hfkTOJj5rPzPJJn+fyUUj0tO+B1qkpB9H+2Ls
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="341875938"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="341875938"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 14:10:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="888600018"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="888600018"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 28 Nov 2022 14:10:25 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 14:10:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 14:10:24 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 14:10:24 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 14:10:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqVdtiCLMb4DA+ct2nQ3ip+MF3p3SzevKGWy8xAsoyOh5JNba0bHcODSWww0CV8XHLZw1IIjUQg7eulOy6SdGmOgOdmOKVVZcvFbJu8eD6qrTK53Q0x/IvOWslAPoOyWEEelaMFBxPqWff8nV5YsRRWXIRmxvM6Afc+jgsLPUP61m/UMzJTUki/NKtuPolkmIxFclL3dzS3dAwqW6qv+IviWOrkYe/Y8BiL6+pnRlwcapgJlP26z2KFH7Xtg4fWoRUIgZLdzxloafsz8vCvBBYGGWdHkVnEqV57ad3iUWe9vm8mRY2/uTBqLQQK3bqbr5UqsCzwpcgQhlGDExYN3lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QxsFTwAJjDPWctXKNkGKKBZQi1+lsfrpdyWJuOUDPKo=;
 b=W+Cs3AhpMhgtoXwC8Hg1P6yscbEns2gbbPAYQWmSUKEsn5zSvINWG923pt1BWKc6K7jU8KaDfWaum1CqS03E6HDh5Cdkf/sN4SJkQ5iujcO20TYUMD3bc58JA9UdHHj6teueN/hy1ttep0/2FwgrcLWzFiZ1hdwj/dXByVO5W63d7fhQoG5PRa/dmQeD+4MSJZfdKwBkO7GknkqYKMboWtTT8zKWz/6DKPNtvh5RwjdkpBjazs8hmVH2CTRwICdCgn6pGINnBxiRIkSWB9nmiDFP8+osqCe7G2Ly8aAhqfKik1TPkMNft9NHuzTYy7JypANiUw2iESWlZ8sfC99QlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ0PR11MB4815.namprd11.prod.outlook.com
 (2603:10b6:a03:2dd::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 22:10:21 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 22:10:21 +0000
Date: Mon, 28 Nov 2022 14:10:18 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <rrichter@amd.com>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 06/12] tools/testing/cxl: Make mock CEDT parsing more
 robust
Message-ID: <638531ca9a392_3cbe02942e@dwillia2-xfh.jf.intel.com.notmuch>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931491054.2104015.16722069708509650823.stgit@dwillia2-xfh.jf.intel.com>
 <Y4T79QhJR2WzwEgY@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4T79QhJR2WzwEgY@aschofie-mobl2>
X-ClientProxiedBy: BY3PR10CA0016.namprd10.prod.outlook.com
 (2603:10b6:a03:255::21) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SJ0PR11MB4815:EE_
X-MS-Office365-Filtering-Correlation-Id: d7b471bc-2686-45f9-b178-08dad18d5725
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fRjOQRmcXzovUnjePLtDovgw3TUXIDaVEv5G3yCwOmoN6poNjA75ghygQ67wHu4tA40RlBTSyLOcRoNFvRaWn7MTkH/W4U/Gibhdr2k8OIGpX8e5wAuEUnZqFLZw9Omx3pwx71tttchPedXd8Xyb0ktyq+6H8kTBjryrPS/ioxg7sMQ/unfZnIkujbz3HNDluEiWJDkv1cu/O3TQAGL5F3UWs3NG4NPh9U/tSl/M3dK1CQvhqjGrNmQiuhp/Va73k1TB6V1JPCBuYRjWKCD7BlXFFelMjPJWEzMpwruUayjtlol6GTcMNuvyhub3PX9pmrA5tJ+93ciso/6pmi4qJ38wupLlfajJhztC40nrvGNR/bD+fxVyKFNd9UNWVvdwSKXJavjNC4pE+zD8NImOgzXsSym2EuVyWcynjdUe8+W9aJ4BMQwdhKay7Ilbf9fRWBP5adeqoXNFAod4F3kYRL0UXPz2M106M5Mq/LiekqAynOl1mZak6BH/Mf1Yu/Pj69lpwWeLHMRpQqelyUB9kTXRlLzsY8Gc5W0vPhwR1bdLJWOZDkQUAi2uZlzGFnkKL3OuOYS0oWfrLKNiO9ZLiUo7ySxaJU0o+SlnNkXUNun9IOlDxjlvjsLilRm/gUBzvhmKC7QJ50Xw8EW5b2Iafw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199015)(5660300002)(66556008)(66476007)(4326008)(8676002)(8936002)(41300700001)(110136005)(66946007)(6486002)(2906002)(316002)(478600001)(86362001)(9686003)(6512007)(26005)(6506007)(186003)(83380400001)(6666004)(38100700002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B5/qhYUN5A13q7Yi7jNVqVdc3DQa3X8xgqTdaCFlCHogwDKz+5IN5s4ymeFH?=
 =?us-ascii?Q?mNJbh9ohXf4D8JFZ6skW4nVBrU0Pj8jZUwzeWxzH+Gr9Hbfa8ZUaO+8aUzOD?=
 =?us-ascii?Q?gXwiRJMzDmgPd55f8ro2aAuKfmsdNBTzIYIM6OWJtYq6yGDcN9ax+I5Iid+d?=
 =?us-ascii?Q?R9xko33ZO99/JU5SE11i+fPbdUuotZUHr1k0+bC/mNNUjJKW9fV9KYIYlwLV?=
 =?us-ascii?Q?X+JGfOzgVStKF5wvCdmrprPtdqQ90opyPF7N44einU18syP3W3l5EwiQcZ/t?=
 =?us-ascii?Q?+EBMHQMU04jwz1SlWZa9t1GfstfQCg7UTUbIAQN1i5QR6ZTTvhY4WQfkAPZu?=
 =?us-ascii?Q?k7F4B/buw0J3pNv405x8f9VywVgXYrP7vbvhRqu+UZV/ZYjqk6fanBIfVfe4?=
 =?us-ascii?Q?h0oqco6LfwLNWnj7sWBAHW/bXPgrWJXPJrBNywXwdK5bhMgzEw8rAw6dcpiF?=
 =?us-ascii?Q?J26mOl1w9m7z18yekWMMaeKm1DLSkXW4kHcy/xyrAA23M66ija07UwdEY6Ef?=
 =?us-ascii?Q?++zUyOLUte4oN6lcB+U1SUywOn+N8dSuvnXrHc7hbdpSBncN0F06n/FdX9Ek?=
 =?us-ascii?Q?ynF239YofsECFlWsU78+79AtKVvJphCrnC0cd+wuXotIw5a9We5y49+xnmXo?=
 =?us-ascii?Q?UqxxLUnrCoGWlVu08M0Q2vl3DBK8yoKCz/RJkHoTnqYBqZWJOr7SJIQEFFbm?=
 =?us-ascii?Q?H6hqJNB1yqjEYVJ7pofpp/d1dYGQnAYyzCRfn33kAuOkcfx+Me2BEkiQiwhT?=
 =?us-ascii?Q?gQA0MJMDMtL2+7Z64GG0UaDYk1ZjgygpVIEk3Q7pZAycPsBtngS8ePvaWlZi?=
 =?us-ascii?Q?nkU6uLzUx17iZlNxdsZ98xwkhgZ0rqHKmXjk7ZygjRESFROlc+G3nOxNWZ8v?=
 =?us-ascii?Q?ZOuTgVUf24XaoMgeIbW4s9B6gaI2wU47LLfSDxdhYuprdSa6bjyjO2s6y3dr?=
 =?us-ascii?Q?7c3XLbh+vAMN/U6gRuNo/VF8jO/r1plfrvWk4rgZ1tSTUMtPyrkNJLtMYX7B?=
 =?us-ascii?Q?nvgT7UdHLc+y0HGB31Ryfi+IC5ziQV68rDie6fB2U589afF0uNiMAtmCANTt?=
 =?us-ascii?Q?LlApE4UJ+MiNOSlUSXfsXb5mQDPfqbLBTgaNvm0pHEn0fL6wdNLxvEafv1H/?=
 =?us-ascii?Q?luXC8MT02W36iqKJTja6ZJNTTScuwr1MrKBtzdlNaK0vnhIa1tjUH5L5ki3x?=
 =?us-ascii?Q?Wxyk+0YcnF7Rqi/1T9BxjvyYVsUgKvJMiLSPcMcRhy5gR8qvJFpm9tdh9r8G?=
 =?us-ascii?Q?OrsMzsq98lPvBpB3w992pa/zRxxBomuBrinAFY4SXsq7zf3BcNma+K7JfIyG?=
 =?us-ascii?Q?bkEPRERflPs3soaFXcOzdGQ+ASHzN0Y6Vay/3WxReEGBqHxTWAbJcZGfr4K2?=
 =?us-ascii?Q?XhtMgr2OF6c0F9J5pIU2hACXarxajHbonWu+KTpNlEVSCXyjo/dkYFsxxwLS?=
 =?us-ascii?Q?kZiz7PSpZZg1/ANIgKVldFhuIs5eFXlO6kjRzfnJ0SxHVBAHnruZtUclJi/f?=
 =?us-ascii?Q?YSF+kTbyl8h0w0kzdAEB91anisRuUMD1OZWZHAzxBQFmibNjTD/FTZdB+T1f?=
 =?us-ascii?Q?o8Kn09bNnUvGVI5XuTwyO5XzaiE4qDldwsk1KxZmrCubFagSUfGy1X7kBcCd?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b471bc-2686-45f9-b178-08dad18d5725
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 22:10:21.0747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pWSLaaQ0aMpxNoLQac06ag2YftDlmCUmyNI7T+sFYA9FHhji/fKzwFT9AMG86F93LpXmGhulqKVJXX6vI4s7zdOach54wFOiJwlJSzdLQGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4815
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Thu, Nov 24, 2022 at 10:35:10AM -0800, Dan Williams wrote:
> > Accept any cxl_test topology device as the first argument in
> > cxl_chbs_context. This is in preparation for reworking the detection of
> > the component registers across VH and RCH topologies. Move
> > mock_acpi_table_parse_cedt() beneath the definition of is_mock_port()
> > and use is_mock_port() instead of the explicit mock cxl_acpi device
> > check.
> 
> I'll ACK this change, alhtough I don't appreciate the code move and modify
> in the same patch. It hides the diff.

That's fair. I'll go ahead and just forward declare is_mock_port() which
makes the diff easier to read:

@@ -320,10 +320,12 @@ static int populate_cedt(void)
        return 0;
 }
 
+static bool is_mock_port(struct device *dev);
+
 /*
- * WARNING, this hack assumes the format of 'struct
- * cxl_cfmws_context' and 'struct cxl_chbs_context' share the property that
- * the first struct member is the device being probed by the cxl_acpi
+ * WARNING, this hack assumes the format of 'struct cxl_cfmws_context'
+ * and 'struct cxl_chbs_context' share the property that the first
+ * struct member is cxl_test device being probed by the cxl_acpi
  * driver.
  */
 struct cxl_cedt_context {
@@ -340,7 +342,7 @@ static int mock_acpi_table_parse_cedt(enum acpi_cedt_type id,
        unsigned long end;
        int i;
 
-       if (dev != &cxl_acpi->dev)
+       if (!is_mock_port(dev) && !is_mock_dev(dev))
                return acpi_table_parse_cedt(id, handler_arg, arg);
 
        if (id == ACPI_CEDT_TYPE_CHBS)


> The commit msg seems needlessly vague. Why not state what was done?
> Something like: 'Accept any topology device in cxl_chbs_context'

I do start off with : "Accept any cxl_test topology device as the first
argument in cxl_chbs_context", but I can move the rest to its own
paragraph.
