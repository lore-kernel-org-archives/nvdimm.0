Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAEC3BB22
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 01:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730771629; cv=fail; b=U5pNmVtXpZ8W11MqwSdRUiF0EfQS3KoBYltiomwqevexpEiIEIalrx2feuittoFqZHAIWSqL9TSBaUmLFDkH1Q2uMLn92QqU5FF3CIo0eiv+vwcJGud3LWPIaR3nZSqhbo0BkfyGzroLZYeMYxNquGGfS7ecD/QjPiJrxzh3oHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730771629; c=relaxed/simple;
	bh=r6+a2Oz3qhIEkUNA8Sy5qqemWYw9GB/Dk2A315niMKI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Cy2oUwtuo+uw5mHTq1m0bWdqxYpCwhglklo0yMUbWbYAB3akjtaLj0gdhZ4R14S+H5haBA3+85ELT3HPhY2ZPzvUrhyQ+ijTmVTgu7hHfFfskBQ15P3jGH9B1bWGA5ncvvKyl3tzXmo/XxrXgdL/NRdA9ZKiKhxnx5DXRQ4K0V4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P9DBOaPC; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P9DBOaPC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730771627; x=1762307627;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=r6+a2Oz3qhIEkUNA8Sy5qqemWYw9GB/Dk2A315niMKI=;
  b=P9DBOaPCTgIUNgGaH78XWN/Gm8GDWUT6JVq70oJM74XRtvwW+/BEpwMI
   uTJpF0kd4ogl/1wpFr0JG7vooYMgxQ4nQ+FTNoEziTPJ4GsWDLp/De3AL
   /VOGqtwgYgVwS6L6FNxf3itOAAxw/R7Byr1qh85jwP1WfBgBFRHxKL8Q5
   KirDHDXUM0aGbhkJEOpXXm3QHFjAxYEhZRbPaR2cniqLY8maL1NgXYYLz
   z3fG81I1RKEemXabML0Gt9H+xDnVFaEbH2NsgHwjF3cb+q+CLbyans1ax
   VDh0ULgVFH8Y4Yc8psRLcGmSz4YkPBrvnbeZxApJTlEpEacm/amhRtWht
   g==;
X-CSE-ConnectionGUID: anNZDssYSmW4BfcnWGXk3Q==
X-CSE-MsgGUID: X3+yjPfzQ1CVX1oP5UOC1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41889070"
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="41889070"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 17:53:47 -0800
X-CSE-ConnectionGUID: fiRANsaYQz+RKMmZia2NBg==
X-CSE-MsgGUID: Jq5mPsA8R7m3L5Z7GvUHGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="84649013"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 17:53:47 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 17:53:46 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 17:53:46 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 17:53:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eYelxfFUmZxuxHStRLrlMvbR0OjZqB8/pi/mAF8Vq+Rsm4X+YoYc2Y85ZQzBmzAjCs0PEEqAK7M7zNev5LgQewcjHTDXJxRA9xUANe0ovR5rN2SsLucwG9LWD3SyUsbqrWY2Z05spPoNOamyWI72eNftZfuRDothwWq/9GVQKQwCGdweAhMiDZACirMKehoiMbEJMnhyjWQvYZZsDDs17Zs1hiYKmTi39WuZV6RlIt9KJati27mP1sJFU0LFO/xfGuG6WQg5p3XFKq3NpjCN2nG6yDA8UW5pAhkqIlpqUtDFuPi83oyXOYoFiCT7Cd+oXdw3Z+mM0el36G52Eswuyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ViksTvV+fpIIGyyQb297wQIAsGa5KiBQazC1Mld4XNk=;
 b=pZq4xJffS1rzPy52xeDhp29vBb6qBmtbBHSoqft7GvR1MJSLWMBtWyfqxZSyPQpBCn+PMMljyH7/ybYjQWhehv9fh3Wl2D1fGUELsVYfuKFlbfazN+LS24qtP72SjkqQeFDqPp3JTxJUsT1GOD1fbqkIFJGCaUyR6TOZATrepRHDQMdzQCq7UIQ3AHdosRJWbIWFqAYwOjiuDcuGP/2RznKQSuug7uKv3hBimRvOmYJttRkJV2N1Z7OclYlDN9wTdE6N9XXIMrL13w5BEh19+vD4N9iBJ1BvxWk69ar32unuXwezxTKtUODnqtsELEaTmwR/PDt3woSHIKxqTZxkag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by IA1PR11MB6322.namprd11.prod.outlook.com (2603:10b6:208:38a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 01:53:44 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 01:53:42 +0000
Date: Mon, 4 Nov 2024 19:53:32 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>, <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Navneet Singh
	<navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton
	<akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Kees Cook <kees@kernel.org>, "Gustavo A. R.
 Silva" <gustavoars@kernel.org>, <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH v5 08/27] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <67297a9c20e69_146e6529477@iweiny-mobl.notmuch>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
 <20241029-dcd-type2-upstream-v5-8-8739cb67c374@intel.com>
 <20241104170957.2vxxpnjwvmaiwrt3@offworld>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241104170957.2vxxpnjwvmaiwrt3@offworld>
X-ClientProxiedBy: MW4PR04CA0197.namprd04.prod.outlook.com
 (2603:10b6:303:86::22) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|IA1PR11MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 77b1ad25-68bb-4fa5-fe8d-08dcfd3cad0d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?kM0SIfjyCUX2rKDNFF3S/2yjKpXxVMZ9qFCQnk6w/SChpb9I3RbWiHg0YXmQ?=
 =?us-ascii?Q?WXD1b7s9MxQaT8jr8oxl2a6GqtAF4PAHt9izFiSopzHIOGLpQTtcBeUfD1s9?=
 =?us-ascii?Q?j4McmEE8bFkrKcmp91iJU3UAGcDiAede1yyanV1iNmY8/Krg1jcnvY4Bvu47?=
 =?us-ascii?Q?xJefwZyxd1y1muJc4xoZY2m8kHTA+k8xzyQzlQiFAMAiqNfd5eOE2BWEVRjh?=
 =?us-ascii?Q?Wzb8+J1mC6JyPk4E4jyLAe4cef79Eg+DSj5pmpoJp8pBBu5hShntyAKLo878?=
 =?us-ascii?Q?dJ4cbWTbcLzRb1w9eln0LXWCN2InuXxIg8ZfW++5fnHMsqMvAbgj8hUcgaND?=
 =?us-ascii?Q?Tqf9eMBiDVEKb37GxuZtN/sUSqs4D8C1uv2BqPL29hF7tpkevt9mPL7ncU8F?=
 =?us-ascii?Q?qUyCWtlJ/zMlwyb8qTj4BhgJWF5+xoxUxPOhgnG69T4Nw6wMDcACKHoLkUOS?=
 =?us-ascii?Q?C3JcjNaWcI9qD63Wk/PEP7iGvZZecJy/PSvXJ4k+noZaT6NDyLF8MpjD0lSt?=
 =?us-ascii?Q?VKtE0itDPLHK4xc9QvcoVDg0j4B3j8oRPcW5LCUzoKVUYsRMJ3cdEl4Hw/A/?=
 =?us-ascii?Q?uYezBqqkChTqKVVvqI27K/eqJAKuycc24XwV6x5X7y+SYDZP911TxaMhtwpz?=
 =?us-ascii?Q?cJ3t/VHh8G1Pq3xWLr5HWOEgWIlHdwxsBbydC9gC2awML/AGZxp2TaJQ6gAB?=
 =?us-ascii?Q?iaWwKJgffVbiG6z4vdFooMB97A9oyNcAueLHlHFG24Z61ndZYzFUzRhlp8wY?=
 =?us-ascii?Q?j3ueHByzE/IIkJrnSzve5utC55HpxFqLCViawR0jvFBlw1j1sbAaCz52evnG?=
 =?us-ascii?Q?5ydZhLDc7BBKw6+kxcPrNxqWSPxYd0f0r7ZzTjOxbuIyvUvCtYcieuEugbd7?=
 =?us-ascii?Q?hqIgffKBRYEh0r9O1Imnh4QIlafhE0mOT+rHjpezBeF28eVLc16wLaOFCZuL?=
 =?us-ascii?Q?uQcx2iyARQcU0Gj65tfbaPPm3ZsNQpAVV7Pk4nU1yxayxpTR37GJ0XSJUmMO?=
 =?us-ascii?Q?5lrDxh9XaNbecGIVAT1hNjQjYy3w9JNqMYSbuzgWc1wW989eMxAPf/VKVImW?=
 =?us-ascii?Q?XHWfoba1lf22WMZMg6E78aNyk6SoO4mhnt/Ivf6veIkRw/NdhpRmQJtgtSC7?=
 =?us-ascii?Q?jVtytHrOHwrzfiSw6w8FyVZIu3A/RlHrOiS2AsWb3VJYEsoB4QSadR4/7V99?=
 =?us-ascii?Q?4kbSz+K/AUfNKZCwoaBQKBxAU0KDEtszlF67OYL0r0BQBEK0XzfHgVgoPK9+?=
 =?us-ascii?Q?gR85sGyQuFb0Dn+Snvar5vDJU0dkzorLrRV4hpfhkqBTq4yiek6WgV+vgeK3?=
 =?us-ascii?Q?A0Q=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FHhG8Uht/xJYMV362gUD7TXd7GjzREeKO7tLBlXfukwFsSdgQSU526cwnzw6?=
 =?us-ascii?Q?f9P1KgFUaXGeUnUGw6Vle08QVA8GfPVr3zG7f6cyXXdp7BKRjFsm6IM1+Tjr?=
 =?us-ascii?Q?4zTNbi1XiwUtZA1//sshz3YFsgCaJGtlAd8n/yClWisY5AfvHMP6OMfqlP6n?=
 =?us-ascii?Q?GgD+HUR8n5N7XAzI7q4fPbiDhtxHj2jmtpQerxnSht8grCT39Il8eoyADCAF?=
 =?us-ascii?Q?HXcXpkEYqmlAscL5SND3F+aes78g1ZFzYnc4GGMVPe2xK9pk9NUHc94Tx9ng?=
 =?us-ascii?Q?BsCG4nXa1rd81oy/qo893d21bObxqMThdJXY5CB2/8eKs4TjUqSwgfct0Ez/?=
 =?us-ascii?Q?BCQ+h4OXzDuInL4Whj2NeChrlIDQLaO58GfY2tDxUpVqSCLAlkUHmtx0bQsT?=
 =?us-ascii?Q?cF6VCno7lyKnIBIDTallcQM2UGp2DOsao9EheQNswK36DIB2nmrOm9Khq7bm?=
 =?us-ascii?Q?Y2jZTp8AxbLDePsc1hbetEF5rvUXDN9aO6oMfhxrUG4/k8m/9DnK9FQotxZ0?=
 =?us-ascii?Q?emfTnI+2Si4LM5Ej4G4F0ZSVXZwQJ5ZfnnGlCWhVjwdGp3zcUpOrCFoMat7D?=
 =?us-ascii?Q?GyumL1B6nx52OKzGbWVrui2H7jHj93kftbO1oCxAlh5PmByUF5cRsCe6vGJt?=
 =?us-ascii?Q?G+BYKQnsCfXnAbyZ4ObYJ+y+rPkBt4VCVjm7EIDGbtDf8D6WWcdNjM8OEok7?=
 =?us-ascii?Q?oPSVLIWBXEdAr4mWHP/ygIS8dE+WvNiT6EIUlswkSWeAr057rz5ZKtzJPwyZ?=
 =?us-ascii?Q?HrlyR94BfIq+/cQvB1HEiOHk5TWz/+LjHVmhGNKpcVBSE0CmgVXMFkzpjtew?=
 =?us-ascii?Q?SAgG+AtYgyQWiSHLrz+bAAJU1JEOjAJgiBt8rraqLpTTMWqNdi++Of4IhKqo?=
 =?us-ascii?Q?8OHz7MbBt/1eQwf87hgtiDQ/6QhIIqC8TkEEuF2DuNhhaE7NDXHeQDt6S23D?=
 =?us-ascii?Q?lV07YzwChnf29H6KaMxuPcnY5jkg1MLHkxU56OdfyOPI37+L4q70ZTxrdUFq?=
 =?us-ascii?Q?1rJD+y2llWmEavsDyMQeDl19PP8fCug4frHkwjS2frb1DGsCfd+barNtt+4u?=
 =?us-ascii?Q?7EXA/rKjMFWLfuhSgOg/8iaRGoqZtJX3cxxLjEpRT91ovlHtul6AY6tlzWTq?=
 =?us-ascii?Q?YlGChN7/RssXBuHoavZ2rkkrW4ne5/fk66HgJkfAplR7eyZ2zc3KeX10nBr7?=
 =?us-ascii?Q?Q4+keDVpJOKqxVG2f9YF7UbnWFD6NQQP62ADCdM2RDm21+ldKcY1BOzfM8VN?=
 =?us-ascii?Q?p44H2YpeXOJj50b/4JP/2aLeE9ki94nQOdeyztJKl2erVKq9eZacj90QAR6J?=
 =?us-ascii?Q?HebFNgzQkMczcBEcpz4UtJ8UBi36qJ7QjK4MIkSCOAU65N8rH6/0S65Wl8rq?=
 =?us-ascii?Q?iHsiEhDJdvR+vcNlprg3NF3OLFJ6EQhuhpZT9dkzzKxwj7vvPlRL5cQ8cCKJ?=
 =?us-ascii?Q?1E3R+1LKcpTu6xW18S3xGCNZtrxWnGWnVgIH8/MHWBUFv8+PjyKrXhfSIovh?=
 =?us-ascii?Q?N1PWMYgKZvmVP9s0sf1CuHNm4rjfSgGo2iVuQQJYK3MOrNwEFK2c2Mf4vokT?=
 =?us-ascii?Q?m31/nVQr4MGD9O2KtNTevK8QcT/xo1BJZMfJb+q5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b1ad25-68bb-4fa5-fe8d-08dcfd3cad0d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 01:53:42.4561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RUqy4zpNxeUhCjTfrCVn34BgGAHuVk3zIzpi5w9fsB+LmX7KtoMn1qISxe7fL5ZjXmiJKwCqoC6mzcwoJ/tLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6322
X-OriginatorOrg: intel.com

Davidlohr Bueso wrote:
> On Tue, 29 Oct 2024, ira.weiny@intel.com wrote:
> 
> >+/* See CXL 3.1 Table 8-164 get dynamic capacity config Output Payload */
> >+struct cxl_mbox_get_dc_config_out {
> >+	u8 avail_region_count;
> >+	u8 regions_returned;
> >+	u8 rsvd[6];
> >+	/* See CXL 3.1 Table 8-165 */
> >+	struct cxl_dc_region_config {
> >+		__le64 region_base;
> >+		__le64 region_decode_length;
> >+		__le64 region_length;
> >+		__le64 region_block_size;
> >+		__le32 region_dsmad_handle;
> >+		u8 flags;
> >+		u8 rsvd[3];
> >+	} __packed region[] __counted_by(regions_retunred);
> 
> s/retunred/returned

Thanks.

The bots caught that too since my compiler was too old to test it.

Ira
