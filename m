Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775BE7B
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 00:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658278497; x=1689814497;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=T7bP0GFA0x7BKy3Ynvq/lktXOhX8jE6ZpGdUzoT3CXA=;
  b=LTBsixj8hTjSwaFNPuSY/DgaQTLOH+3Om46/B1zgZMdUh5AqCKeUvgee
   hy9zLbvNAYj55uQ19cv4Ep+pd/dTe2AZA9PERoWj47tBI5NqdQK0cE7+4
   +PEUuUp0DTSImgKGoWMmtWg2EhXH6M3AaWyOlnHpTg/cUd90iQdAztykb
   W3CQZbQgjui1xvVfSyLuVsRYEquoiTHqGnO6zOMGdf0q5rJnbJ9Un35xd
   PH11MP34ny/+e9GG86b4TtEDH2MGV8sTi8D+eXf05YaOaCm9x46uuiHQ2
   /9fjoxgwKIqv2AkNr1aknIVB1FEEstpo6RcnaLm9l0Z4LLaW20XdSLAZN
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="287801234"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="287801234"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 17:54:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="687324488"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jul 2022 17:54:56 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 19 Jul 2022 17:54:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 19 Jul 2022 17:54:56 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 19 Jul 2022 17:54:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crR0wjKkyFpd1BTE/2cKSN6Agb1JoHuJbZzgStYuGqWi2CLtcIlq1m+2dq5BFRjMyi3mfMleQIASJR8f6WYfw8Mfbk1TJexIKnQz6oOI0JNyuY+vhDSUWf/4dGAPGSeWCciM2myrTUJbIxcoAvcTUBOEXQ6fbea0N3jdqMzvyMqAEwetRrO94etdqV6SR2sFL0WJxu8VtmnPbF8o0duG+Z8PRJeQEhUVlwvOhfp+IBtzuVFbNpUitu3UmfuimSNRCWrETl6k2FTBAsHU6dQCebpc1/nrmhqaM/1w0zXoe3FDo2uMmVHteWvCuNlkqViYbpRWuuQD+fByfMk4FWrdGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ldn+3ZILJFk5IJ54kehZgo7goaioWidrpxigbU3EENI=;
 b=b7qifA/s22p3huzXe1bJ4wyuRQ0BPDYGPNk5uLdlh7acFQr0NiNKrOoFYVeSnu+HV1qTFKCnqhcHMYB9AC0Cb2N8/I1Eklti5wkkQB1yeHkv3BKIvh9/8Q0s9t5AjPTbNtSOTM/xd2NjNvW5wvNDmPB2fuikQCA8id02H+c0/WZMhcnA6ysXS5nAwSPVBbAVnJvPUv/egR/wJCkQYDIjuFu0ag3gcE54KYC5Htauv1eATLzNQHNZt+qxDiogIAhgjxEF3f1UEvjS+ascb4th1EVIMRih5IBWVz8vO29vS64oPokvgu1Yz6N5spqdyf1ErPuHFv0+ZGK6Ya6R/Q1OlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BL0PR11MB2977.namprd11.prod.outlook.com
 (2603:10b6:208:7d::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Wed, 20 Jul
 2022 00:54:54 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5438.024; Wed, 20 Jul
 2022 00:54:54 +0000
Date: Tue, 19 Jul 2022 17:54:52 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH 2/8] cxl/port: Consolidate the debug option in
 cxl-port man pages
Message-ID: <62d7525cded1_11a16629429@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220715062550.789736-1-vishal.l.verma@intel.com>
 <20220715062550.789736-3-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220715062550.789736-3-vishal.l.verma@intel.com>
X-ClientProxiedBy: BYAPR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:a03:100::34) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93efa04a-d117-4e9e-0254-08da69ea75b0
X-MS-TrafficTypeDiagnostic: BL0PR11MB2977:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wKkzG0+7GceMRpyJRiCzUKcpRut907/55NmbIeqKVAuD2Qmb0Bb2HzrgJtPlv3BF4Ywt2spyTnxLBp/Iafrs55NAeBAAwUdpdyEs68ZaRmQ969tADqMbPICVR6K8eepQQgSDYUk7RO4g1Y4u9yWSZx6b9931f6HpYqGBPGHMHTUfSM6Csk85jMzhgHhmcmdQk9tYw90K9Zbkrh6sXloA5rJH7QoiE0GFFvzmVCxUhwPsPO9ZvMwTD2bFhoypIs2lptUBGA/YpceI4j1NxjbQhw/BoHey3yyWWTWnDb6C2hpRBCQt9e1PRVXq4I3mey/pxtOsgGF6oWsNQ7YU6VpDXNRF07r3b4LHEzPgC4sFll8MP5fxHf/zetgvSXwAw0ZFBitmocRlw8eCEnXx/HZByHBmtdAhfJvYX02OI2jUUfHhRuBUqjHOAwwAcWqL+zFhso9zKWzwSFUxwnGhEqcxd6u8eXQtmgAvCwZdGFTqAa9EB7DkHzsyTKs2EXiQB7L5YwXej1ohUKt+ILleb6thDS2rq9QpKdkwAW8Fxlc+5jE9Tg5+FIrJtct1T/x33szv9hrzJ9MTDmABt9Hj0Gn0O7EUPEWA9gLOymJDg0yJl9r6jYgVWqkcpjLqXestpTkkCImO2cRzyp2vKrjWjsHWm53iedl2aRYyYIe8K1P4xu4psgY0J7dooQsyt48OsYMul9Z4d8jS7r6tJGVqRNi+JJ1tZcMg8PB/9DrFO8sU7ipLCak/6zhJu/k+C81l4gwU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(39860400002)(346002)(136003)(376002)(6486002)(478600001)(26005)(6506007)(2906002)(316002)(41300700001)(86362001)(54906003)(4326008)(66946007)(8676002)(66556008)(107886003)(9686003)(66476007)(82960400001)(6512007)(5660300002)(8936002)(4744005)(38100700002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RSSjX56069Uyt7CWwxVYWYkzbgPOSCCqIHSGqQi2L/D0E3nJS9EmP1vPD3N7?=
 =?us-ascii?Q?8lgJ9iW+nyB4HRNyr1dO/yvtzW1Eaoo+Ycam6ndhdJH2ik7fNZETjcjcQDrw?=
 =?us-ascii?Q?utlkDAdITW/YT/Ydd6aBr4XCHHPaDZaYYHRP5zIi+dnNvPbUUihYRkiaCX1D?=
 =?us-ascii?Q?TPHvqttplYYah43o2DmLgwp5+abMIusR3vjljfGvvy5cKDPmAzmVr/Pe/9El?=
 =?us-ascii?Q?KQnwGY97rndflN96wau45NZYHrG5Uxm5gUvqAP9I29T4JnN8sN+g//XbOyyd?=
 =?us-ascii?Q?uJuBwPMLhGoAmI0uufv6F0Npx+5wzDzI6MyioKVBz+yVnA7UyJZe4DTG16qW?=
 =?us-ascii?Q?slZWcNvnFzg1zin+BSph45/SFCpnH+qoRjOuf5RpPYtp+VpRxf6JuptKDEpv?=
 =?us-ascii?Q?bB9hl5rT8H67PXQkHPcuAiO4KUUDCKta6sDZcKybcc4VOi77nK7SpQSfRChw?=
 =?us-ascii?Q?pbqGngujGHKAxmwpJrb0xnlM4tePkxfpXZF5fvnlVjI14wUY71bh6lMGlznJ?=
 =?us-ascii?Q?QP2eQMx1zdkau+DZZLp0OBs/3KVSJjfhyGKnSCdC0ViifMc97D7vJSrEugYj?=
 =?us-ascii?Q?On0qXG8Js4MDFC7hrACi6vWdePQhmKtm3MPbHiU9nnCirzK/c2crk/6M3AzT?=
 =?us-ascii?Q?aPADj4QxOJKJRQUlImzF14srSCoEqn0y8+PxSU8mnkTWAM6RrfvNb6+4vepa?=
 =?us-ascii?Q?W4FfQKGzwFDWptKK+N6lGjJLFwiLffWRUlCD80vHPDOP16NGMfqVGCwOOcxj?=
 =?us-ascii?Q?z5sdJybBrEr+TLfs7jZrKEKWFiNRm97YcoVVjSBm41QYmkGSPoC8urCDy6FE?=
 =?us-ascii?Q?ApYRdYTE6KbKpPfUq+e5PVfGXWdKtgemA7LuyfNUV3K9Oa5sGBjlB0rwCc7T?=
 =?us-ascii?Q?0TmjYee+qDDRsH85dKgbhztrY4xVFTBY8rE7lhBd2xdimazqTNqlsHLpq/FE?=
 =?us-ascii?Q?fiYhb1Q28PYGDsIbsTsHXy7ndZLzhLy0AXrzbeIKegRMqPp7h62lWthumWLE?=
 =?us-ascii?Q?osE3pF0dNEiOI3z8+OEIaWmT/8X4uN4o5O6TwP/7t6ylttKHA7hraDwiEna3?=
 =?us-ascii?Q?wD3YiGAn7cgrk4UiFSbw8ALnJwhU4RiQQnKA4B0PILR8i9+iLATDS17Lv+4j?=
 =?us-ascii?Q?dOQ23il52+IW+cnGsjhTLBRUm9JholIgZHf9/GFMa38PqErNDGBdu5A7NKl8?=
 =?us-ascii?Q?t8zrgCXT/czUQUy9j7HEaXvk0WThbvEW0pLe0yez8BVGso/lWNJea42uxFJN?=
 =?us-ascii?Q?4/0TblRzWr4tFL84wUFQ3cg0UOXuySqtc7wFUYfvMNOU7NNmODWd4XpKRj4Q?=
 =?us-ascii?Q?WZNeVw98M0zCd03uysnfev4RanylgKgvEc9kVN4RE1nvm0MtAAqn9Y6CqRYm?=
 =?us-ascii?Q?zr4dk9jq5kH4u2r9U+sphFc1APhDlnnUCnAvBGv/ry5HuI+oTj9+FIxgJXkP?=
 =?us-ascii?Q?sh+wxAFHY83t75EwCL5oJc4rTVn1mtelfgftEQBVuCOitGKan2TLBdKZvhhN?=
 =?us-ascii?Q?lh3nF/tN46ktVnpQEOyGKNt4iJiFLWrAVVRKyINSrDpmTwCvk8anvB7D7NrY?=
 =?us-ascii?Q?f56pfcCD9ZHtoG42CJKKeYSTMZylySV/hsCgHbS3NtKh6pToz7IyEbwDH6xw?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 93efa04a-d117-4e9e-0254-08da69ea75b0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 00:54:54.5329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vNlxJtNGVK19d1ZdaZU2jPViF6tJdNr+8AxX+mGgU5vtBYwQNRdWuu9uUu06d0K+nAYDtFnU90rsRYvW99bl18Y0u2XMdxGMdDgAU5cZ1c0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB2977
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> In preparation for additional commands that implement the --debug
> option, consolidate the option description from the cxl-port man pages
> into an include.
> 
> The port man pages also mentioned the debug option requiring a build
> with debug enabled, which wasn't true - so remove that part.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
