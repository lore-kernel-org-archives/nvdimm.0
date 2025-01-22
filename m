Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A298A1B808
	for <nvdimm@lists.linux.dev>; Wed, 22 Jan 2025 18:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737568955; cv=fail; b=h0R0enuWgZR3b69tz+7LgRnIF/X9hFa7mvHj7m+8nNPBU1+KFKRZQ3nJy7obeTdhaniSvUIRz3sP5FSsU/p4MjM1K/O9V7F8nR20QyXZE3nJ49DbnhRzkj/R8tQ6eoZk6pA4bJjNSb0Fh5G7sSd2aPWQETXuEcab/xb4QUVx2LM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737568955; c=relaxed/simple;
	bh=FW6iNuy11c9IX+eEHGZwrE0pFfNZ1PTSMsUop+75xqs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZLslcb+vFKlhZJuZWL51CiUHNi2LTjTekY5Lo3K2XU7XG/YMROhSoZh/m61V2ZmyHUc0Pv+k1orccPeUR8+uL7SNoM8EpDBrtFvPsZdvqoskE4/+mIXYOjia/XFiPJhDIhGo6qC9D4TCf0Yh5uesN3OTTz5Mt7albw+Ore2icEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GSdk6zfy; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GSdk6zfy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737568954; x=1769104954;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FW6iNuy11c9IX+eEHGZwrE0pFfNZ1PTSMsUop+75xqs=;
  b=GSdk6zfyA0jREiKkcY4GJ0QZAwZhy9KfhuodjlO6unXL6k8rs0PDRBTf
   0pb7KxLOzYSF0rDAM5zuc25Uc8vlZVWIeX2+avgqF0D+O+bq6yV7F2g82
   cGEdm2llNzZ12vPEzQln/EHtZBRuhAl7jQdlp/wWqNupvR8ZjMkcsnc/5
   BLH8QqGztarkItagjH71fxsKSQzZARL+zfiJMHOGEz50DBAy8Znqw9GEk
   7FCgpLQgPWuFpy5tbDRQxx5yyIEwIDcmlSYXas1F5xf6aIC9OG+n+j15C
   +V+R5/8k8XdmGMLJqfAEbFg9YGqJFQ8ChV2r0ci6A7Uf9sKNqPjjhdiRu
   A==;
X-CSE-ConnectionGUID: kHwJAIIuQZ2Ho9l42+yHgQ==
X-CSE-MsgGUID: z1fXJD9fRoCNP4lhY1amyg==
X-IronPort-AV: E=McAfee;i="6700,10204,11323"; a="37923032"
X-IronPort-AV: E=Sophos;i="6.13,225,1732608000"; 
   d="scan'208";a="37923032"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 10:02:33 -0800
X-CSE-ConnectionGUID: 9yJ5yDhGQQeWhu1IRNPKXA==
X-CSE-MsgGUID: +EnOOuPJSralHSZR6ADkZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112306891"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Jan 2025 10:02:33 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 22 Jan 2025 10:02:32 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 22 Jan 2025 10:02:32 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 22 Jan 2025 10:02:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q/Nv8k/PP1ArVQ1/HioePMH1Nu/Ru6ZYz8fJgIruqArMiCPVW5uBwiXKrjYKLMs8SYnc+wP5uniPyetgn2uxBkQunmXF8tIV5zz7rsWTbImov0ao9a6c8kgDI3RgjOWCB4UxGyR52o+996Fglb18uO1XNybJan2NWzTeDf8N/+ndAYryHDuB3QoOd7kL5G/u1f3c0kLPsk8rI7tepcO7OXoR+lS6+N2x199aEWeQ/fwzzqHc7PeavuMBtZpq4J7u9K0EkHPP0HauWu69GVHp4HG4icbbN+eP21mVWlY2VDUDOI4KFp6dj0yLZEQ/c/yLfvTHl1JeajtGB9I87/nNaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwGS5ekTDvl2AMJyXPfKEa6LxWR7fHQNu507CbCCcOE=;
 b=euYBf+rtuzTQnKrvk6DPS28wKJRz16fzwUmeZ0umoug9cgd/wK5pENCTt8RrPRcuSBKkt1NJtrmLEoPIhvcxr3X+aIlu/K/qXuiN9zmjOi/emX3K17vuonnK3tTFkBhxf1+HcpC4R0gcJQ+qqp4X+seUtai+4kArjHOkDIyh2QH1/1vlRdKWjUaCmoFe2/pIS8a8kFbOaVDDn7NSfrQDBAlSazlyF8g5yKTpBL02PdGTJcq4bHX+FTq8Csdc4DmS++nlVTV/LNB6IsMd4fZ9PZVB48OP08TlgzbdbEqZClr0Dl5Mz0mxntOX/am0evlTcZhCyObu0emR8d5GFHclkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by LV3PR11MB8604.namprd11.prod.outlook.com (2603:10b6:408:1ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Wed, 22 Jan
 2025 18:02:09 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.8356.017; Wed, 22 Jan 2025
 18:02:09 +0000
Date: Wed, 22 Jan 2025 12:02:03 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v8 02/21] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <6791329b4b44c_1eafc294b6@iweiny-mobl.notmuch>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
 <20241210-dcd-type2-upstream-v8-2-812852504400@intel.com>
 <67871f05cd767_20f32947f@dwillia2-xfh.jf.intel.com.notmuch>
 <67881b606ca4e_1aa45f2948b@iweiny-mobl.notmuch>
 <678837fcc0ed_20f3294fb@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <678837fcc0ed_20f3294fb@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: MW4PR03CA0089.namprd03.prod.outlook.com
 (2603:10b6:303:b6::34) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|LV3PR11MB8604:EE_
X-MS-Office365-Filtering-Correlation-Id: f9206cb0-1422-4d87-d734-08dd3b0ee3b1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wdfOGTUyA6eOoBcKhdt6JViMvXNHs0Y8tJ1XHHzsEMxpTvZ9uWTpLcB2YbjD?=
 =?us-ascii?Q?bL002ULD2cqNByqzx63uoxS8TtoueJacksr+T280abfUHWPlCD3m7hhtiWp+?=
 =?us-ascii?Q?baTjifrA308nG0G0p55b+clTp5gL+WIdCZ3FVMTHeDdGLeXsKD9uNtYajS7y?=
 =?us-ascii?Q?mUvFOhNAN7GMDZj/CfNrKO8blMsmsMCaWu2OTezLe6QjYH9x0vbNEu7wO48N?=
 =?us-ascii?Q?LZ0JSuOxTVYbaX5Yh4JytWbrfqA93bNY5UqSkGM7eLZsmtqW8hLDP1VRBjoB?=
 =?us-ascii?Q?os9k8vbXbZEqVqwPwzLVWbxIbF91Dj81xCL8wnlAFRlpmuYFvhJwKnvZp1fp?=
 =?us-ascii?Q?KoQk845vpe6XuEX0eMHv61p0wYtHxIkMdvBDHyYOxZLSMYAPyhSRI/wt3V7D?=
 =?us-ascii?Q?IQ5GEotReeh/G+LlqOrTChXq394BjiuEWmQ+2/jn45m4kTk3hVw03GhLHIzU?=
 =?us-ascii?Q?Y1iwMBR56BJrrb+u7Y1EScv7oHQm3qgoHiFxA5c4PXunS2snXyXsy4MKP1mq?=
 =?us-ascii?Q?zr43e/CMKrPgohI6f2PCtCQOiKH6Bv5KKLBvMluHzjnRxqju7HMUsc4H1sJs?=
 =?us-ascii?Q?Qtldw/cv9SsToPjKQm6UnGJUKi5sKzOO+HiBs2q4KbrLEUKelrMcqjBgEBkX?=
 =?us-ascii?Q?MaG8Sm6lekXsLieLvuPdpMyObMd8tOez035PMQP4JiFDDblV8wsw3jPvofWf?=
 =?us-ascii?Q?POofxTDDGpeO++V9/pdXQo1T+cbPSECjC8J7JBOAKdFWinmTe85504IgF4M8?=
 =?us-ascii?Q?JE33jc54WAsdGClJHl2ktYLTy8Dym34vn7pWdqGN01yfpAhIJHZ3lZ3seoS/?=
 =?us-ascii?Q?HILWByJpjZjbYpEH7jyO45OV5J2zoD4EOMxBFMrode/IhMS68xqxxrECvTOd?=
 =?us-ascii?Q?Pj5sPYvcvgZDXoS0rxsBPWHxYp0lW34OSs/2MEwqn/WfetJmlqX23eUi7Tka?=
 =?us-ascii?Q?TG8yvrJ/mChRMp0x4xdlZTBvM/SaKEpAEza9FiQE376WUCbyHUmBOu9kp1iN?=
 =?us-ascii?Q?F4tcmRl7u3lklH9CKAx1GSlM9tGY4I0talW/9XTq8IVN8VLzomTH7QPwYAlO?=
 =?us-ascii?Q?EjqwoqyWtf0V5h4v7Y4nClb/Y253kkA+gGh5jLAjCi6zqk34/zaJMYo+PZyk?=
 =?us-ascii?Q?OJ+nKdiuVmaes1haQzjlotwYBNW7it59fbME4ZUoTSFlDP5F+VeieYUfeoc6?=
 =?us-ascii?Q?uXU1ffZcru5DtUT6TWCIfzGicDG9ysQlEwJvFq2E+OeTVUYWvg4S29W/qlcd?=
 =?us-ascii?Q?P1KHz1RL0m8ip0DvYLM8XZNU1+0ArG80yVNaCL/qHBIc6PM270hHL84PJO79?=
 =?us-ascii?Q?mhkeUChi71FrudF1XWdBIf5qAsDSiCoMIgUCbZFPR7IXMTmDanKUASeVXbmW?=
 =?us-ascii?Q?fGuXWXLAIlAgeP4Ms+B4OjzZvvXA?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FW/1Wi+VqEEwIXCLiCWAAAWLqjYrXWIMBGGYUxADZ4CUAwo5rZcbjzbWswqe?=
 =?us-ascii?Q?t6d3oopdY6rv8z0bTgU0va0KC/0JqxHFYQizmgWG/rotqiuR+VSgCGHIKVA9?=
 =?us-ascii?Q?F/0aMnVKuxa8ZLIh6+c14UE9ZRCHxzHlBI70BJT0ybEIEIrillVKFZvFhec4?=
 =?us-ascii?Q?Rh74NKi7rwrb8/vL5zGtxbXFtsGl2fW1kjLpfdKC4BQ2L16Bs7nc/wgBVyLd?=
 =?us-ascii?Q?91jElApwSyaoIvgw51rqyZc9IeGmbg7xG1zyaZsR5lw1M3J+yF0uPejl8RYI?=
 =?us-ascii?Q?CCTwQ3tItQ0JyZhWpUSSM6TlKYyJs33eEXmKjfsslwnLGAnwG3RlUk9w4BdE?=
 =?us-ascii?Q?ynCIiGlHkoCrnqZiRvBYgWg8Uk+oJiC6c6+0nWVUkZ8DAHNUWYvJqS6pEncE?=
 =?us-ascii?Q?wQVItxjDtgiD2hkm1RP+UiFTI+1AlIhjxiXBrEk0AAFfmMIsKwHuMvv94t4I?=
 =?us-ascii?Q?h5HPpCX6Zpwis2rEn4+DWwsjWRJLLEt0rLz2IeFDOw7vEVHTBgT5Rp8TK+Wb?=
 =?us-ascii?Q?nCcdv7GXZSeIaKPk+ASEI32eenWBVHcQpa46VAhTI++wMhLDbLoTbkQoOIen?=
 =?us-ascii?Q?Ydza1Y/J98mPG9OtTubBCeveZBxmJzjMc70QVkcqYtZv6knBpLcC63LxGxKX?=
 =?us-ascii?Q?bTlZbebXQFh/N+jD0v7RQ205jnnIPYL3S7NcIH2JczhTbQHe37khouoxvUNv?=
 =?us-ascii?Q?J2hLb2AqT2Rz3/vS1r3wm+XkbXHEpif/wnN+TEdxUDJp2/hTYsnXr7uMsTr1?=
 =?us-ascii?Q?jHFvybmreKWXMHJyGB7FKabCG351JI62+JQz5g4ZFBh3gMA/oRGVZQ1B8dTI?=
 =?us-ascii?Q?QhzMdTSfMDv5umFzamyX9PmKzJQfM8YN2o+VtfqYU+IuNw6nHaTtx0h03fyF?=
 =?us-ascii?Q?ffk1KAt8ZUuOUkjbM+3oiQeWYrqkrq/Q7e/7daRMpgz8XrmeYpa5PaqnPMlI?=
 =?us-ascii?Q?Da28+GWh/5PZRwOYYzQoBWFZqbMtJt3xYND1/inNqqAHxyU3tg0KO4Sr7oIv?=
 =?us-ascii?Q?oa352RkOY5Crk9AxgpciqrpLigHxj0YwSVzDDrKt9daA3Sf4IbP0DSnJ8D6v?=
 =?us-ascii?Q?lOtoIH8hddV9/6DvxQmfdCSmz86yhBwC49RrAMrJzDH50bpchCKvL178ctg1?=
 =?us-ascii?Q?sVT1zet+NPMJEeB1xwSlym/0o5onO8EPI23eW2Ed//4sY+F0pFgtqZzSZaOP?=
 =?us-ascii?Q?ieveZo7SfbNcHIDUtknjTdxwWUkj4mYJZ30+/KSKfytdRdDJzGJtnmQX5/14?=
 =?us-ascii?Q?JrDgi/uVmtzxV6Qdft+H+Fql4Gt4JPFISxXpLRmrLjeUHd6RbrAuSPq+OBLH?=
 =?us-ascii?Q?UPXD1YMOJch33khcFzx3GQL68ZHovnhi9AlWvgnzcQ/jBKP0FgtlX4S9dy+1?=
 =?us-ascii?Q?r5AR1QpfpJlfpxL4p9DN2UfwcoBM8rKPKAJKruBmJc3Nhj6kQfPyiWWvlh3E?=
 =?us-ascii?Q?XHrMQv+fSC4pf0NzLNxEp5OXBAJWYKVomtWqtzZJ3KcR92IF2RmZn4JmAtZL?=
 =?us-ascii?Q?9cSqDPtGQyizvTogMBDQK9U3uaHX+9STlvEI9X+JTocokiieRE7D7JLzD1v/?=
 =?us-ascii?Q?zF6u/lUQ0c46LXShiaCGJXAZqyNMX7ICF9EmouUU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9206cb0-1422-4d87-d734-08dd3b0ee3b1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 18:02:09.5277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17Q538ORFmAI3xHpDb1wZqrhL4SDs908ioyek+4Wllf7Q2LDXT7OHzFIJ01JUx7HsXOf2dH3LQ2qUDK9Dk046g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8604
X-OriginatorOrg: intel.com

Dan Williams wrote:
> Ira Weiny wrote:
> > Dan Williams wrote:
> > > Ira Weiny wrote:
> > 
> > [snip]
> > 
> > > > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > > > index e8907c403edbd83c8a36b8d013c6bc3391207ee6..05a0718aea73b3b2a02c608bae198eac7c462523 100644
> > > > --- a/drivers/cxl/cxlmem.h
> > > > +++ b/drivers/cxl/cxlmem.h
> > > > @@ -403,6 +403,7 @@ enum cxl_devtype {
> > > >  	CXL_DEVTYPE_CLASSMEM,
> > > >  };
> > > >  
> > > > +#define CXL_MAX_DC_REGION 8
> > > 
> > > Please no, lets not sign up to have the "which cxl 'region' concept are
> > > you referring to?" debate in perpetuity. "DPA partition", "DPA
> > > resource", "DPA capacity" anything but "region".
> > > 
> > 
> > I'm inclined to agree with Alejandro on this one.  I've walked this
> > tightrope quite a bit with this series.  But there are other places where
> > we have chosen to change the verbiage from the spec and it has made it
> > difficult for new comers to correlate the spec with the code.
> > 
> > So I like Alejandro's idea of adding "HW" to the name to indicate that we
> > are talking about a spec or hardware defined thing.
> 
> See below, the only people that could potentially be bothered by the
> lack of spec terminology matching are the very same people that are
> sophisticated enough to have read the spec to know its a problem.

Honestly at this point I think the code has deviated enough from the spec
that it is just not worth me saying any more.  I'll change everything to
partition and field the questions later as they come.

> 
> > 
> > That said I am open to changing some names where it is clear it is a
> > software structure.  I'll audit the series for that.
> > 
> > > >  	u64 serial;
> > > >  	enum cxl_devtype type;
> > > >  	struct cxl_mailbox cxl_mbox;
> > > >  };
> > > >  
> > > > +#define CXL_DC_REGION_STRLEN 8
> > > > +struct cxl_dc_region_info {
> > > > +	u64 base;
> > > > +	u64 decode_len;
> > > > +	u64 len;
> > > 
> > > Duplicating partition information in multiple places, like
> > > mds->dc_region[X].base and cxlds->dc_res[X].start, feels like an
> > > RFC-quality decision for expediency that needs to reconciled on the way
> > > to upstream.
> > 
> > I think this was done to follow a pattern of the mds being passed around
> > rather than creating resources right when partitions are read.
> > 
> > Furthermore this stands to hold this information in CPU endianess rather
> > than holding an array of region info coming from the hardware.
> 
> Yes, the ask is translate all of this into common information that lives
> at the cxl_dev_state level.

yea.  And build on what you have in the DPA rework.

> 
> > 
> > Let see how other changes fall out before I go hacking this though.
> > 
> > > 
> > > > +	u64 blk_size;
> > > > +	u32 dsmad_handle;
> > > > +	u8 flags;
> > > > +	u8 name[CXL_DC_REGION_STRLEN];
> > > 
> > > No, lets not entertain:
> > > 
> > >     printk("%s\n", mds->dc_region[index].name);
> > > 
> > > ...when:
> > > 
> > >     printk("dc%d\n", index);
> > > 
> > > ...will do.
> > 
> > Actually these buffers provide a buffer for the (struct
> > resource)dc_res[x].name pointers to point to.
> 
> I missed that specific detail, but I still challenge whether this
> precision is needed especially since it makes the data structure
> messier. Given these names are for debug only and multi-partition DCD
> devices seem unlikely to ever exist, just use a static shared name for
> adding to ->dpa_res.

Using a static name is good.

> 
> > 
> > > 
> > > DCD introduces the concept of "decode size vs usable capacity" into the
> > > partition information, but I see no reason to conceptually tie that to
> > > only DCD.  Fabio's memory hole patches show that there is already a
> > > memory-hole concept in the CXL arena. DCD is just saying "be prepared for
> > > the concept of DPA partitions with memory holes at the end".
> > 
> > I'm not clear how this relates.  ram and pmem partitions can already have
> > holes at the end if not mapped.
> 
> The distinction is "can this DPA capacity be allocated to a region" the
> new holes introduced by DCD are cases where the partition size is
> greater than the allocatable size. Contrast to ram and pmem the
> allocatable size is always identical to the partition size.

I still don't quite get what you are saying.  The user can always allocate
a region of the full DCD partition size.  It is just that the memory
within that region may not be backed yet (no extents).

> 
> > > > +
> > > >  	struct cxl_event_state event;
> > > >  	struct cxl_poison_state poison;
> > > >  	struct cxl_security_state security;
> > > > @@ -708,6 +732,32 @@ struct cxl_mbox_set_partition_info {
> > > >  
> > > >  #define  CXL_SET_PARTITION_IMMEDIATE_FLAG	BIT(0)
> > > >  
> > > > +/* See CXL 3.1 Table 8-163 get dynamic capacity config Input Payload */
> > > > +struct cxl_mbox_get_dc_config_in {
> > > > +	u8 region_count;
> > > > +	u8 start_region_index;
> > > > +} __packed;
> > > > +
> > > > +/* See CXL 3.1 Table 8-164 get dynamic capacity config Output Payload */
> > > > +struct cxl_mbox_get_dc_config_out {
> > > > +	u8 avail_region_count;
> > > > +	u8 regions_returned;
> > > > +	u8 rsvd[6];
> > > > +	/* See CXL 3.1 Table 8-165 */
> > > > +	struct cxl_dc_region_config {
> > > > +		__le64 region_base;
> > > > +		__le64 region_decode_length;
> > > > +		__le64 region_length;
> > > > +		__le64 region_block_size;
> > > > +		__le32 region_dsmad_handle;
> > > > +		u8 flags;
> > > > +		u8 rsvd[3];
> > > > +	} __packed region[] __counted_by(regions_returned);
> > > 
> > > Yes, the spec unfortunately uses "region" for this partition info
> > > payload. This would be a good place to say "CXL spec calls this 'region'
> > > but Linux calls it 'partition' not to be confused with the Linux 'struct
> > > cxl_region' or all the other usages of 'region' in the specification".
> > 
> > In this case I totally disagree.  This is a structure being filled in by
> > the hardware and is directly related to the spec.  I think I would rather
> > change 
> > 
> > s/cxl_dc_region_info/cxl_dc_partition_info/
> > 
> > And leave this.  Which draws a more distinct line between what is
> > specified in hardware vs a software construct.
> > 
> > > 
> > > Linux is not obligated to follow the questionable naming decisions of
> > > specifications.
> > 
> > We are not.  But as Alejandro says it can be confusing if we don't make
> > some association to the spec.
> > 
> > What do you think about the HW/SW line I propose above?
> 
> Rename to cxl_dc_partition_info and drop the region_ prefixes, sure.
> 
> Otherwise, for this init-time only concern I would much rather deal with
> the confusion of:
> 
> "why does Linux call this partition when the spec calls it region?":

But this is not the question I will get.  The question will be.

"Where is DCD region processed in the code?  I grepped for region and
found nothing."

Or

"I'm searching the spec PDF for DCD partition and can't find that.  Where
is DCD partition specified?"

> which only trips up people that already know the difference because they read the
> spec. In that case the comment will answer their confusion.
> 
> ...versus:
> 
> "why are there multiple region concepts in the CXL subsystem": which
> trips up everyone that greps through the CXL subsystem especially those
> that have no intention of ever reading the spec.

Ok I've already said more than I intended.  I will change everything to
partition.

Ira
