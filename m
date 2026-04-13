Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFC239526B
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 21:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776116243; cv=fail; b=BHLwzsidGiidd0mLGMc+fUpGzaMFT4+3/C63yyWbgwCHo8WKZeBEN9m0TA3clYQ59NDrNyVxYtFdBSuH9kXEHLXobNom3yQe9jSGpIhPHg+zq+IYwvco1bjRrA5ECvccNtiuhV3IgFdsQz6I8U1/7G3wlgJYwf5vZ+K56wWr4KU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776116243; c=relaxed/simple;
	bh=aA8K3IQKKSZpGYirYd61j5ZGoE8FDsHJNwRWtZDpYA4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QwZbq8py/LiZgnjSZKrcuoe79uDt6odFMJppu81FfenGjFCDcbiTGw6Fd/eKk1mUE8lbj8s+k0Tj6IiYxjq161ylQhc+VC8NbnfU1o9ZpH+7zEAdEFR9ozhEwC3uh3NZV6MlbLjpk2GGJujBoy/Mf4S3Etd7BimJAwpargLAqc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kpAKPeed; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kpAKPeed"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776116241; x=1807652241;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aA8K3IQKKSZpGYirYd61j5ZGoE8FDsHJNwRWtZDpYA4=;
  b=kpAKPeedDdJMs5Y0jDU8j70qJ5X8QWfHFd85QF4YdhQbenDx9ColX7ZY
   V5100vOfTxijCNAJTdBp2fR0ST6yGQAFijqf24T2HNjnUXv1WcHo2PLgM
   N/aLdqlA8xeMs7TF2PgrclSJT3aE0uaVyf7Vo9IIN/fPaIcTjIkHhmoSd
   sNoOGdt1A5ZQW+SraSZkfBO3AyTo5O7w/cwrplUUFC0I3FNqtFmv80pjw
   cDK6YEbEIHMXDLg4abqbZRBmOEV1re4FPlWZiJMYClWgRpiVkUgphyJx4
   MGvAvJ77l4qUoCSvJYQ9r3uUvCU6LZHfVmUNsaulhTQ2M+77XAar+b2Eq
   w==;
X-CSE-ConnectionGUID: krdKBR4PRbKPcGE2UJlF6g==
X-CSE-MsgGUID: OoVYvNMgSQCmZXi0YUww4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11758"; a="77027122"
X-IronPort-AV: E=Sophos;i="6.23,178,1770624000"; 
   d="scan'208";a="77027122"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 14:37:19 -0700
X-CSE-ConnectionGUID: PgdWRmBiThubHwzak6JBLw==
X-CSE-MsgGUID: DpaXrQO4SgWC0NzZIB/RMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,178,1770624000"; 
   d="scan'208";a="223407523"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 14:37:18 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 14:37:18 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 13 Apr 2026 14:37:18 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.23) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 14:37:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XON1kGM1zTDyNygU6Ryfg2MGkKCLgE8hjMVz5hP/JBTi5/B4jsvAN+MqN6W6gkEzz937Snl4ZARVe2BxmZQW7BNb8u9DQ4tOwbyKtvnFOG/TDCQUXzPFt73AqXdUbSHjsdFYDbSizo5p4YfGNxnY5euECqV3qTq9j2HwWUkyG4dKnHc7tni687SDSLbaWbf6sdKWtlxZqes2ItV6Dm5Ow/nEhi69W5aBcCNeKyjjqF6UlT0FJ/mDXfyy5CqwKrvyCo1AUt9T36Ww2Yv2Llg/5Ty3gE3N9deE17OrJm1KQbxPBQjSGZtXVWNjTArH+MCjcqID+syEtneLmmhSqYDPRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+BzWz9K6yqK1ZcDBkPatRNQ59aVF1lxVqKStH/PUBuI=;
 b=CXqmsPkLswzyWZUJf78DrCBaKs9D2VV44rEVl8V0CRQEcSUzWFPzpPz6eRDIg124Dncnmh79MIYQCqSTwHdqqNMCO3ySBMKfJJkFNl5CBlWPzDijF9eB9Lk7gi3JvCfSrOGIr1nSJ8mK8HiPloENv0jHu3Ig90/F4cDe9B+MJ9OthFUxfst+xox7/kZY0QIDmXQ9/ih7SwNAkrV9Vhz+x7eth6SX/ZAd+9jXEEOe9HxHP8E5eWynFbMCYorQvhTcmTdRdJCBx3c2idaQxRAb0zg1gsZnN1G8gkT7cbOStgLvxgARIyNvFVrfbhst5jetsNUbTg1e4GuoReQH4sv2xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by MN6PR11MB8242.namprd11.prod.outlook.com
 (2603:10b6:208:474::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.44; Mon, 13 Apr
 2026 21:37:06 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::9618:33dd:29ce:41d1]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::9618:33dd:29ce:41d1%6]) with mapi id 15.20.9818.017; Mon, 13 Apr 2026
 21:37:06 +0000
Date: Mon, 13 Apr 2026 16:40:59 -0500
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
Message-ID: <69dd62eba432e_20039100b5@iweiny-mobl.notmuch>
References: <20260327210311.79099-1-john@jagalactic.com>
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com>
 <acrpbBt5UsWEiEbm@aschofie-mobl2.lan>
 <69dd576924b0f_24f910029@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <69dd576924b0f_24f910029@iweiny-mobl.notmuch>
X-ClientProxiedBy: MW4PR03CA0327.namprd03.prod.outlook.com
 (2603:10b6:303:dd::32) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|MN6PR11MB8242:EE_
X-MS-Office365-Filtering-Correlation-Id: 668d9bda-3db5-4d5e-5bc4-08de99a4cf3e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: 3QeOaBjCOD9/DyAA/91ujkgjchwDbAmph50X9gN1qgDOkrhlgpqwdFWBOQ0al7Wrwl/FRYTCDHVNP26fUL8PaRytUrgJ6hf4YtE6ZspnfR1MnjI/BKK8wDWMT1LKa6AnzZq04KTDjOCbzFVGg3aJ7A0ZQkTB7oMT58UQMWy92bmscY4HU/OZxKowDKYdjFwcEGjdUyR7c9Cql2SSsBS1WOq49ZCRGhoR0XubS3clR9JgpTwIsL7yRZj0YMo5Cjj9KCVgtCFh//An+JIXiJ09iYnodoasTFzaO+mNTWEeKeAzmPYXGDrV1wAd/SWgqtetYXGlz+qkvOAe15pQj2JTXaK+J5YFhmUKab7NbmI2UaZ2mbbCip5tVUPOTeKhb8Ky5LveKWoxSP+93/PIVmTe1n3ac9nrS/8SYNozaDF4JejnP02tPitHZaLp2t4pFqicnEm861ku9kb6RaozgUkN1x33mx8omGXv0orYUDaJ2UANTTZ0ER9KaIwTUZGtmz/mH7+cHGqTqtuV8nxIq5Cf0REqlOnmoFPbao+4PLaJWrtxxxjEltOp5kyddu3BOqo0Zkukt8bZ8iK1FTCisQt+gEWvrnJ4wL3AwBS1/ZULXNlVnpk9tnPd/9ut4VFRVYJKQ0lzauaxO/FCFwDhPwVG4BTSf0GKQOL/ihvdGnzr+OJZ5u7I5OMItEpVCQPBSqUoGz7T5xC6gH7DwbCbAzTBoRV+oTudcF4JpkXJFMyB/Cg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?deiiqDCn8umNdkG9dqfW//uOLt/FJl+K1KQ0LrGjSmBzdG83Cq/FRVGCNMwa?=
 =?us-ascii?Q?V8iES1WJVzlO0YckzE0aqB5et7LO5LQVlRNYbk9Wh+KigM/JQTyeTOwFqr6Y?=
 =?us-ascii?Q?RQp4LO5s0a8HhiKoA3caKNetotsdx9RbyuKBQMTpzq2tKUKuuisYJroep3zp?=
 =?us-ascii?Q?Du84hm9T9j+l2+dmJH13N8TI2H0FjfEM2kH6GRTRTvlNXFFsOgFu12E0NqVP?=
 =?us-ascii?Q?q+SQ7iqRk5wISg7FAIr+0uS4/h5jShoRlbx5hVC029Yg58OqqnF15AEq8vyg?=
 =?us-ascii?Q?UTX2aZZB4UGnyT6UgPzvWgPKiZGJGPcA3j1lodZBo0DSCGPb3vGIrG1con0W?=
 =?us-ascii?Q?fYXoYixTR36cOhdc00zRfHLGUV9kcDdBnnvoz6+kthQ+kFbi9Y4nmkcM2awa?=
 =?us-ascii?Q?n9xiDUpiI4tj//JRQEXPEuOEajce2nx2BMO/sbIIEtIozrpTlNepYutCl+Us?=
 =?us-ascii?Q?ZjqxrhIsQoty95wxwoadFr7UirvDHblP88bXfmpvEXpVXOW3If5c3Nvu5m6b?=
 =?us-ascii?Q?olN8SMYlU7nWIW+gs3QT6PtO+mJNhcJSAwzNG6G6Foz5IgjWhVwtRRmIs9NM?=
 =?us-ascii?Q?oj5mRpjHytSb6bA/uerq0QklLMtYTF9T3a748Gf8GlyAWjHtc8hSrTtY9GBz?=
 =?us-ascii?Q?I/LzZcOX8xHEb8JOjE88t4a+4k+nIIc8Y56BGQexo97SO6ofgMPEaW0OgPv2?=
 =?us-ascii?Q?JEIliqRMHBlssNVeQ88KYqupBBvg5JsOEAtNavb3Fz7XIGDNvwXMIC33Ogh/?=
 =?us-ascii?Q?o4kaEQmy3J0I47/JnE7sFJ+usCGKrCrW+Cw9JcSC+TvHm13I2oagqDxtGVU/?=
 =?us-ascii?Q?dMI5IKHgfu/mpNQ8ymomTu5UNmHfbcvIG0GBwKia9A4yZ32KtmiouiuTZbL0?=
 =?us-ascii?Q?j0OWqz8K3fdWoJScOM+j2niJCTk8+fxLqtZGa/QYxx6nNaIBQ/0Kjy6uZ0JA?=
 =?us-ascii?Q?avyazUYFG81RbAK0RnQWiOC1bkwy8y6zOBQc+Yhnwc7FjEAkCcipCHkULjcY?=
 =?us-ascii?Q?RIZw18Qdnt1PyaQK01sGxK4hIr8xP2GsE932VYUU3nNAvWpvBy5WMcHkL7mi?=
 =?us-ascii?Q?mjzoiOj6sILTFDHWWQ+nzx5tnaAiePkCzpaCU1xYSr3Yz47CKhSJStnFaxNv?=
 =?us-ascii?Q?f0uLWvNkHlnArp8fVEuWjx1FElno0u9hMHJSSr1Axpd4HCOJxs3M9xGK+NeP?=
 =?us-ascii?Q?08n34N+C/bgDaz528B8XUxNg5o0e+zKweXQqKXKngoiEyALQI019cD6j+UTE?=
 =?us-ascii?Q?1Mn/nRHdEtoZzCMNO6qAy0UMC3NsEV8cM8AD0Z0GnwBv2ltEYatTVGo94L0u?=
 =?us-ascii?Q?/LobdB1zxv4yNtpvtepcXM1/hkNSHz91CnNGH4zLKGV8RLWoyo3+lv8+8wY/?=
 =?us-ascii?Q?OR8Jl9CjbzmFzMZUpnMy/0No/1d0yIXmeLtkKw92Wv1lOyAzCyiXqJKfrISx?=
 =?us-ascii?Q?Qxk1M3uVItQygCgwUe9aWVtdX9qCt1S1aAVmtMUfe38O0pxNu8x5TkT+kDnS?=
 =?us-ascii?Q?EALuB3vT0orQUUD5mt4uLtNXDa+Y2yd3miFzjon4VgiRsZGwPI9ZiQdgpvAh?=
 =?us-ascii?Q?VjgDPpMBLrwYyAodljLzeS7q+0GPycL76md/FIY0GsrroSpNZ+Ea90lB3aWc?=
 =?us-ascii?Q?8T9K5deUppyHdrVuEdqUaX0KnPVDJ20wJM5bCXGaezKHQYnPAk8edJhU+UPO?=
 =?us-ascii?Q?NwLVJyxvmoh0jtCysJ+s27JkBH5x8rI73rje9z3wClpmDkkOSO5LZhmITFHA?=
 =?us-ascii?Q?8uA3Nhf83A=3D=3D?=
X-Exchange-RoutingPolicyChecked: tuRIqV27uqVHj31yOEyHluaeknwE7bBzz4nNh0QAWuY2dDVQSGpDkMupw3HOwwC/Qz6GyHb9Q2mzd6uJA5UaHrhYpV60Kf5Inyn6zGY0hnRJWOFgnGuCAJ+O1Doiy82387if+u+9VBXLJarRX5U8zSzIJOFosd+VLe396oofEfLJvGcFpEvoiy2A5S0nPXKhwuWpAt+BsF/hIADB4PCjGlSnRX/WAv7ZD/imDJPNkdunAoNl6OTIAr5KkGJwlAy8oRmZADbjNaDFmyARBRnSf4eKSQorK9zHN7zzbc/NC/s758QD/xgyaeUKDyydl7D7tNKMkPtE2nFKQuOz0wnlJA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 668d9bda-3db5-4d5e-5bc4-08de99a4cf3e
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 21:37:06.6677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yBjp0J0TOwW9xMouSecYuxZHHDqfxe09zj/8fv5dHRe0ZfG0sfG+DvsaaJGlZ8cNUYmjVYevf2wxPqJwp3G3Tg==
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

John I've found a different crash with the daxctl-famfs.sh test.  See
below.

I got the ndctl repo with the test from Alison.

I'm not at all clear what is happening at this point...

Ira

<crash>

[  519.007691] BUG: TASK stack guard page was hit at ffffc90001767fc8 (stack is ffffc90001768000..ffffc9000176c000)
[  519.007694] Oops: stack guard page: 0000 [#1] SMP NOPTI
[  519.007697] CPU: 0 UID: 0 PID: 1465 Comm: daxctl Tainted: G           O        7.0.0-rc6ira+ #68 PREEMPT(full)
[  519.007699] Tainted: [O]=OOT_MODULE
[  519.007700] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20250812-19.fc42 08/12/2025
[  519.007701] RIP: 0010:sprintf+0xc/0x50
[  519.007709] Code: 24 10 e8 37 f8 ff ff c9 c3 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 48 83 ec 48 48 8d 45 10 <48>
 89 54 24 28 48 89 f2 be ff ff ff 7f 48 89 4c 24 30 48 89 e1 48
[  519.007710] RSP: 0018:ffffc90001767fd0 EFLAGS: 00010282
[  519.007712] RAX: ffffc90001768028 RBX: ffffc90001768068 RCX: 0000000000001e08
[  519.007712] RDX: 0000000000000207 RSI: ffffffff82abab1c RDI: ffffc90001768068
[  519.007713] RBP: ffffc90001768018 R08: 0000000000000000 R09: 0000000000000001
[  519.007713] R10: ffffc90001768110 R11: 0000000000000002 R12: 0000000000000800
[  519.007714] R13: ffffc90001768068 R14: 0000000000000000 R15: ffffffff839c71c0
[  519.007715] FS:  00007fb94b807c80(0000) GS:ffff8880f9e9c000(0000) knlGS:0000000000000000
[  519.007717] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  519.007717] CR2: ffffc90001767fc8 CR3: 0000000077d2e005 CR4: 0000000000770ef0
[  519.007720] PKRU: 55555554
[  519.007721] Call Trace:
[  519.007722]  <TASK>
[  519.007723]  info_print_prefix+0xc0/0xe0
[  519.007728]  record_print_text+0x58/0x2d0
[  519.007730]  printk_get_next_message+0xd8/0x220
[  519.007733]  console_flush_one_record+0x1a5/0x390
[  519.007735]  console_unlock+0x5a/0xe0
[  519.007737]  vprintk_emit+0x2e8/0x340
[  519.007738]  _printk+0x48/0x50
[  519.007741]  ? printk_get_next_message+0x70/0x220
[  519.007743]  __dump_page.cold+0x3c/0x331
[  519.007746]  ? dump_page+0x1b/0x30
[  519.007748]  dump_page+0x1b/0x30
[  519.007749]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007751]  get_pfnblock_migratetype+0xa/0x20
[  519.007753]  __dump_page.cold+0x1c6/0x331
[  519.007755]  ? dump_page+0x1b/0x30
[  519.007756]  dump_page+0x1b/0x30
[  519.007756]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007757]  get_pfnblock_migratetype+0xa/0x20
[  519.007758]  __dump_page.cold+0x1c6/0x331
[  519.007760]  ? dump_page+0x1b/0x30
[  519.007761]  dump_page+0x1b/0x30
[  519.007761]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007762]  get_pfnblock_migratetype+0xa/0x20
[  519.007763]  __dump_page.cold+0x1c6/0x331
[  519.007765]  ? dump_page+0x1b/0x30
[  519.007765]  dump_page+0x1b/0x30
[  519.007766]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007767]  get_pfnblock_migratetype+0xa/0x20
[  519.007772]  __dump_page.cold+0x1c6/0x331
[  519.007774]  ? dump_page+0x1b/0x30
[  519.007775]  dump_page+0x1b/0x30
[  519.007775]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007776]  get_pfnblock_migratetype+0xa/0x20
[  519.007777]  __dump_page.cold+0x1c6/0x331
[  519.007779]  ? dump_page+0x1b/0x30
[  519.007780]  dump_page+0x1b/0x30
[  519.007780]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007781]  get_pfnblock_migratetype+0xa/0x20
[  519.007782]  __dump_page.cold+0x1c6/0x331
[  519.007784]  ? dump_page+0x1b/0x30
[  519.007785]  dump_page+0x1b/0x30
[  519.007785]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007786]  get_pfnblock_migratetype+0xa/0x20
[  519.007787]  __dump_page.cold+0x1c6/0x331
[  519.007789]  ? dump_page+0x1b/0x30
[  519.007790]  dump_page+0x1b/0x30
[  519.007790]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007791]  get_pfnblock_migratetype+0xa/0x20
[  519.007792]  __dump_page.cold+0x1c6/0x331
[  519.007794]  ? dump_page+0x1b/0x30
[  519.007795]  dump_page+0x1b/0x30
[  519.007795]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007796]  get_pfnblock_migratetype+0xa/0x20
[  519.007797]  __dump_page.cold+0x1c6/0x331
[  519.007799]  ? dump_page+0x1b/0x30
[  519.007800]  dump_page+0x1b/0x30
[  519.007800]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007801]  get_pfnblock_migratetype+0xa/0x20
[  519.007802]  __dump_page.cold+0x1c6/0x331
[  519.007804]  ? dump_page+0x1b/0x30
[  519.007805]  dump_page+0x1b/0x30
[  519.007808]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007809]  get_pfnblock_migratetype+0xa/0x20
[  519.007810]  __dump_page.cold+0x1c6/0x331
[  519.007812]  ? dump_page+0x1b/0x30
[  519.007813]  dump_page+0x1b/0x30
[  519.007813]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007814]  get_pfnblock_migratetype+0xa/0x20
[  519.007815]  __dump_page.cold+0x1c6/0x331
[  519.007817]  ? dump_page+0x1b/0x30
[  519.007818]  dump_page+0x1b/0x30
[  519.007818]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007819]  get_pfnblock_migratetype+0xa/0x20
[  519.007820]  __dump_page.cold+0x1c6/0x331
[  519.007822]  ? dump_page+0x1b/0x30
[  519.007823]  dump_page+0x1b/0x30
[  519.007824]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007824]  get_pfnblock_migratetype+0xa/0x20
[  519.007825]  __dump_page.cold+0x1c6/0x331
[  519.007827]  ? dump_page+0x1b/0x30
[  519.007828]  dump_page+0x1b/0x30
[  519.007829]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007829]  get_pfnblock_migratetype+0xa/0x20
[  519.007830]  __dump_page.cold+0x1c6/0x331
[  519.007833]  ? dump_page+0x1b/0x30
[  519.007833]  dump_page+0x1b/0x30
[  519.007834]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007834]  get_pfnblock_migratetype+0xa/0x20
[  519.007835]  __dump_page.cold+0x1c6/0x331
[  519.007838]  ? dump_page+0x1b/0x30
[  519.007838]  dump_page+0x1b/0x30
[  519.007839]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007840]  get_pfnblock_migratetype+0xa/0x20
[  519.007841]  __dump_page.cold+0x1c6/0x331
[  519.007843]  ? dump_page+0x1b/0x30
[  519.007843]  dump_page+0x1b/0x30
[  519.007844]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007845]  get_pfnblock_migratetype+0xa/0x20
[  519.007846]  __dump_page.cold+0x1c6/0x331
[  519.007848]  ? dump_page+0x1b/0x30
[  519.007849]  dump_page+0x1b/0x30
[  519.007849]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007850]  get_pfnblock_migratetype+0xa/0x20
[  519.007851]  __dump_page.cold+0x1c6/0x331
[  519.007853]  ? dump_page+0x1b/0x30
[  519.007854]  dump_page+0x1b/0x30
[  519.007854]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007855]  get_pfnblock_migratetype+0xa/0x20
[  519.007856]  __dump_page.cold+0x1c6/0x331
[  519.007858]  ? dump_page+0x1b/0x30
[  519.007859]  dump_page+0x1b/0x30
[  519.007859]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007860]  get_pfnblock_migratetype+0xa/0x20
[  519.007861]  __dump_page.cold+0x1c6/0x331
[  519.007863]  ? dump_page+0x1b/0x30
[  519.007864]  dump_page+0x1b/0x30
[  519.007864]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007865]  get_pfnblock_migratetype+0xa/0x20
[  519.007866]  __dump_page.cold+0x1c6/0x331
[  519.007868]  ? dump_page+0x1b/0x30
[  519.007869]  dump_page+0x1b/0x30
[  519.007869]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007870]  get_pfnblock_migratetype+0xa/0x20
[  519.007871]  __dump_page.cold+0x1c6/0x331
[  519.007873]  ? dump_page+0x1b/0x30
[  519.007874]  dump_page+0x1b/0x30
[  519.007874]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007875]  get_pfnblock_migratetype+0xa/0x20
[  519.007876]  __dump_page.cold+0x1c6/0x331
[  519.007878]  ? dump_page+0x1b/0x30
[  519.007879]  dump_page+0x1b/0x30
[  519.007880]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007880]  get_pfnblock_migratetype+0xa/0x20
[  519.007881]  __dump_page.cold+0x1c6/0x331
[  519.007883]  ? dump_page+0x1b/0x30
[  519.007884]  dump_page+0x1b/0x30
[  519.007885]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007885]  get_pfnblock_migratetype+0xa/0x20
[  519.007886]  __dump_page.cold+0x1c6/0x331
[  519.007889]  ? dump_page+0x1b/0x30
[  519.007889]  dump_page+0x1b/0x30
[  519.007890]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007890]  get_pfnblock_migratetype+0xa/0x20
[  519.007891]  __dump_page.cold+0x1c6/0x331
[  519.007894]  ? dump_page+0x1b/0x30
[  519.007894]  dump_page+0x1b/0x30
[  519.007895]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007895]  get_pfnblock_migratetype+0xa/0x20
[  519.007896]  __dump_page.cold+0x1c6/0x331
[  519.007899]  ? dump_page+0x1b/0x30
[  519.007899]  dump_page+0x1b/0x30
[  519.007900]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007900]  get_pfnblock_migratetype+0xa/0x20
[  519.007901]  __dump_page.cold+0x1c6/0x331
[  519.007904]  ? dump_page+0x1b/0x30
[  519.007904]  dump_page+0x1b/0x30
[  519.007905]  __get_pfnblock_flags_mask+0x6c/0xe0
[  519.007905]  get_pfnblock_migratetype+0xa/0x20
[  519.007906]  __dump_page.cold+0x1c6/0x331
[  519.007907]  ? do_file_open+0xbe/0x150
[  519.007910]  ? stack_depot_save_flags+0x24/0x910
[  519.007918]  ? dump_page+0x1b/0x30
[  519.007919]  dump_page+0x1b/0x30
[  519.007920]  memmap_init_range+0x2f6/0x310
[  519.007922]  move_pfn_range_to_zone+0xee/0x220
[  519.007924]  mhp_init_memmap_on_memory+0x23/0xb0
[  519.007926]  memory_subsys_online+0x122/0x1a0
[  519.007929]  device_online+0x49/0x80
[  519.007931]  state_store+0x8e/0xa0
[  519.007932]  kernfs_fop_write_iter+0x136/0x1f0
[  519.007935]  vfs_write+0x205/0x460
[  519.007937]  ksys_write+0x57/0xd0
[  519.007938]  do_syscall_64+0x106/0x5f0
[  519.007940]  ? irqentry_exit+0x6c/0x520
[  519.007941]  ? exc_page_fault+0x66/0x180
[  519.007942]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  519.007944] RIP: 0033:0x7fb94ba3473e
[  519.007946] Code: 4d 89 d8 e8 d4 bc 00 00 4c 8b 5d f8 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 11 c9 c3 0f 1f 80 00 00 00 00 48 8b 45 10 0f 05 <c9>
 c3 83 e2 39 83 fa 08 75 e7 e8 13 ff ff ff 0f 1f 00 f3 0f 1e fa
[  519.007946] RSP: 002b:00007fff47c8ddd0 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[  519.007948] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb94ba3473e
[  519.007948] RDX: 000000000000000f RSI: 00007fb94bc21a3e RDI: 0000000000000004
[  519.007949] RBP: 00007fff47c8dde0 R08: 0000000000000000 R09: 0000000000000000
[  519.007949] R10: 0000000000000000 R11: 0000000000000202 R12: 00007fff47c8e3f8
[  519.007950] R13: 0000000000000006 R14: 00007fb94bc67000 R15: 0000000000413d88
[  519.007951]  </TASK>
[  519.007951] Modules linked in: cxl_test(O) cxl_acpi(O) device_dax(O) fsdev_dax kmem nd_pmem(O) nd_btt(O) cxl_pmu dax_cxl dax_pmem(O) cxl_pci nd_e820
(O) nfit(O) cxl_mock_mem(O) cxl_pmem(O) cxl_mem(O) cxl_port(O) cxl_mock(O) libnvdimm(O) nfit_test_iomap(O) cxl_core(O) fwctl [last unloaded: cxl_acpi(O
)]
[  519.007962] ---[ end trace 0000000000000000 ]---
[  519.007963] RIP: 0010:sprintf+0xc/0x50
[  519.007964] Code: 24 10 e8 37 f8 ff ff c9 c3 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 48 83 ec 48 48 8d 45 10 <48>
 89 54 24 28 48 89 f2 be ff ff ff 7f 48 89 4c 24 30 48 89 e1 48
[  519.007965] RSP: 0018:ffffc90001767fd0 EFLAGS: 00010282
[  519.007966] RAX: ffffc90001768028 RBX: ffffc90001768068 RCX: 0000000000001e08
[  519.007966] RDX: 0000000000000207 RSI: ffffffff82abab1c RDI: ffffc90001768068
[  519.007967] RBP: ffffc90001768018 R08: 0000000000000000 R09: 0000000000000001
[  519.007967] R10: ffffc90001768110 R11: 0000000000000002 R12: 0000000000000800
[  519.007967] R13: ffffc90001768068 R14: 0000000000000000 R15: ffffffff839c71c0
[  519.007968] FS:  00007fb94b807c80(0000) GS:ffff8880f9e9c000(0000) knlGS:0000000000000000
[  519.007969] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  519.007969] CR2: ffffc90001767fc8 CR3: 0000000077d2e005 CR4: 0000000000770ef0
[  519.007971] PKRU: 55555554
[  519.007972] Kernel panic - not syncing: Fatal exception in interrupt
[  519.008404] Kernel Offset: disabled
[  519.083400] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
