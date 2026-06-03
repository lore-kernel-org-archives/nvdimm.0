Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4866A2264A9
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 00:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780445809; cv=fail; b=WWrB2gluq6Ve78dHVHIbtruMnYCw4AEwt/GnxN7JtxKYoLFzdKhHNERjIhSt5eTfE0WKFLxv2F8DIVATGAnj+Y/VWdPYuF0hCQ1TwOYltiDFc6kyeBbMHnykUeX0GyYpZvZDRNjJfRp3i9ta4yknogAmQvLO/JLh88pnv5TtAMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780445809; c=relaxed/simple;
	bh=u2juqJDPoggql4+Y16rkAJuGL2/62ffPTipB13UB8SY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C1btsK7x5u1uLNB5MrOPeG++T01kmrwa+JT8u1xoydT+x18NI4FEVhDgJxnDX4ZxBR7K6EHi9iHU1MouamT9ygY2NhfPhTBkKUN6F0nanrUGmhyDyMH6r87dTwPltQtc5fC+guOFxOjLKPkWmW5fe6/8a80I2KfLBvX7OquJI74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VRuKBBnt; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VRuKBBnt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780445808; x=1811981808;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=u2juqJDPoggql4+Y16rkAJuGL2/62ffPTipB13UB8SY=;
  b=VRuKBBntlmaVbjD8EysSaWtIDLdG2nPoEPtOHVHYRz4MbqFBzjAXrf11
   4MGKUHaw8OnFpq3AxnyNhqgmEi8UrndiYAtcKfzgJS2Ya8kBNFKsXSrA3
   eKR8uS16GVIuHkPg8vtenAeebB9DuLsyP/yaY/vxirFfbBYCF7Er6pKwv
   rVwu8OBNRwv2ffrdHV63I28va5zsh9HC7HUY8OjFGR1aRAcRl3TCjkpMt
   dW2CKXiPmU/nhHNdLHbkXUIWCESCHBuXiLUUdEZ0bNXgXc7eXNjcoBo26
   ENzsVX1uBh2Mm9391/j/ClF65U2bCwu+RpArF97m8nrvAbwmW+JvLihGE
   w==;
X-CSE-ConnectionGUID: kdWbV7kkRBGI3em84OTFNg==
X-CSE-MsgGUID: r1kclISTRxSmS8LdPNbAMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="81426632"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="81426632"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:16:47 -0700
X-CSE-ConnectionGUID: Ngu1dmfeRIuaURE+PQ3a5g==
X-CSE-MsgGUID: 9QfLzMCjRIehugwdO8TzyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="267929962"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 17:16:47 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:16:46 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 17:16:46 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.25) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 17:16:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QBu7Xtz1bYTriudFlRDi9l3kJhJo1+xpq8ZVoUmqS/rvSuZMWo/YuSVYht1fic8H9hkBidCcTe5+QKY9zpQU3OrDoPZG0bYvKlx07vo4Sk3U+NtUjic4C36dF3LmOQKHR78sLFlxZLVdnWNrKUoWKqmznRAe6/ic5l+vCiPIfpmlfOHC0v9RWorDd+kwnEO58FSfm2uxnHen6UoN+L7pCZijb/LoyVFciI/Dq0Cmr36/n7YhWC/9uPMnT6ZbjZRJFzSzSKU0X7oL848xZ9UdFyWgMFaHIvXxOSexxjZJmBfdZKVClRjVW9xirBEawBYmT+aC4bHOleivA8QOZ6jFCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HJBuuxdVaK78wfc3HCTz4elgJyMR8tEfp8mL7sEqGg=;
 b=SRGimDMysaJF3R6H49jylnjTzfNn47RRpLgVDxJ/qUv/UfRn64tjMsi+yEEE48e2jWbAuAg1Gb56Y9m5X7gKvq/Uq2YNxyOWgVWhag0NyM8kB5zUM0rJC85sC5EnQFS4Ivo0XNCZBdkeiyDa+2o1L/Mq8h73toqgZKxhzizW87pdn/33ljlDDaXiqBcN/Pqs9BcmPwDdI97nkeVAbS6vzSsffgOH5gE/W/xdWet8Ey5mINQPBhrGe9rbkKcSjaSfFPfYkmVFsnZkulj1Tqe+ZeDs0VCAfaA2lzSYFGTHvEcfkRULbWJ0N7lqty6XZ2v98nlNedDpI8YyGJbYvh5FQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA3PR11MB9511.namprd11.prod.outlook.com (2603:10b6:806:47e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 3 Jun 2026
 00:16:42 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 00:16:42 +0000
Date: Tue, 2 Jun 2026 17:16:38 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, John Groves
	<jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Ira Weiny
	<iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V3 9/9] dax: fsdev.c minor formatting cleanup
Message-ID: <ah9yZt95xtV768Is@aschofie-mobl2.lan>
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165135.6738-1-john@jagalactic.com>
 <0100019e79cc759d-7a962ed0-0f9f-4ab6-b6d3-08c171fc6558-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019e79cc759d-7a962ed0-0f9f-4ab6-b6d3-08c171fc6558-000000@email.amazonses.com>
X-ClientProxiedBy: SJ0PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::7) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA3PR11MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: b0c28bba-6330-4a6a-a315-08dec10563b2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: gYHeZu5g9Tv2pV8m9e22okT0QCzWpSSctPDAWBMzwqbznNYscumq0sUa40W2i+qD9xFESgPTELP+iw+WsESdCuGi+WEutmYi1HyCKLvku3Pqv2qCj/Zj97IJih+881UK58a0JJZlskYxFDjBVztLMRyu4TccFgC5CtWWBKpsg0kmX0IB4n0CVB5oeoRnX+XorOH9PHqSdsiyG5SSZsY5kzNfwIZesW84gN+YYDZEjXBB3nShzLXVjggZYW7clkUEczzj0HQltIPilAB6ijtmbqdhxookCyxn6/xPH3oMOnSB/IrSKVYHwvByyYAHdOfXO2H/QELUfO2SwBZ+6jykQCqUmVsApmFQaCv45b1Tjd4f2jph78AD/yvQYLg5xx6w3OmAeTPPpxaXSaDiQAKZiG6A0XTiFuRxUnmd+EJN9IrMCVfixP5XT+qrv3UtqYMaUerFb9aMKxRyKoa9NQOEMkFTc747oP0i6//XUbi3zPoMTDrEewr/XZjANjHvNtM3/YDwyNXSjwbOozyRHLQ/dYg94ypIFS75j8H0Qi8dZkAIDcgB4TfPKrH1JMnOVkYTWyntoAA5oaugsy8CDf8NQ+3KgRf4wWY0NWnZNo9gp8g8AoFofdiZHdC63fQL8z4AHxV3yanjAiIDCYcZElAhkrjq/DzRMYku+f1B8NWYBC0LjDfVZEVDq/RHJtxhZC/C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tjQs+vF1pGiT8Zjz2EH6qoDS3UJMRqxPZhaHpzUc88tCxuJNRe9EE7LW4pFC?=
 =?us-ascii?Q?OBta/BVKoARV3ybju7UNZqqBSLl4sN5r1XkZL1xb+1Hx5EvoRN5gEeH5iX1y?=
 =?us-ascii?Q?ndT1YtjjcnFQios6HQ+ubNc5B07QWlC+i4/4xRQYe5tXwYRetEa4ucpAtOQd?=
 =?us-ascii?Q?Br4eVATDeq+FRdcWWsKOGJmFJXLq4Po39SPWjlhUAU8KvidE3zGPdEf6yRcg?=
 =?us-ascii?Q?fd9UlcmNYNHj49GmvIyiToG8pMlDCqAdtnQKCbkbQ+Qplq9T9Cz9ysN7tlyF?=
 =?us-ascii?Q?UV5SA/IKq9O1I30KJnkqPOHtjGxB7CDGvk0oMMwmM0/8LetaiRJZ+ygvIYi9?=
 =?us-ascii?Q?zmwF1iFYMypl8qqY4i7qnWGcFjo2FXvscDj/LrOg8Nncwhv101FV4ferk0gq?=
 =?us-ascii?Q?RIRj02m+mb/+vo5jgAZLPuqqe0RsMiWLpEhrCK/FLWiVbGtjBKHSiYcYi+4Q?=
 =?us-ascii?Q?CVwrFINuMIBwpdqXXtl7azGLsNo2xLXtDNrI7iWmmnVTE/NHVjenx15ZKMAe?=
 =?us-ascii?Q?Ds05SJu7In4/RZZwnXuRX/58ThSHXjD0nWST+ME66D3nP/8FKC0NXhU9BKe3?=
 =?us-ascii?Q?AQ6J8vSwgdj18ss1ixEAsQROqV2OR8mBvrgrbruWqGsm0ncvEcyAdWD7ifjt?=
 =?us-ascii?Q?MVDfiW8U3t64dP8ZGuRoncKbnQ2jhH/p5aGLcb/6xb8LZF+dwb3DbNk6dftw?=
 =?us-ascii?Q?PhgJUuV2cUCQD/JhQ6W/9a9VelwFAS4gBK3Pz5hyAFgn7/BzlDn5NqJ++zxy?=
 =?us-ascii?Q?Y2Hf/tjA4sQnVJHokKgTm4I9BjfSw41tXEnIVA/42sOqS5c6eCLI+Y6H85RD?=
 =?us-ascii?Q?tqpg72RcXTT5N4URwJzdJCmSM9N+UsIy85BiRIf6GZ8gYjL4YvvG2SAjlZHA?=
 =?us-ascii?Q?dM2OqWGbE4X9wCav07zTHcFdeJ+EAR3Gm8L0G0OzoBQySEvHGClfbTNUlwnJ?=
 =?us-ascii?Q?TfZF+Z3gPPJhoeDsrxtgcYL8A9e9Nlp6ESyFpu+SyT0/jxD1Bw2Iy2xTs8BY?=
 =?us-ascii?Q?F0rIefDFIZcgrbcOOSp9SEy1sf+4kZMgLuNOhjCLFqUlbAzTw8lUfHvcyXMa?=
 =?us-ascii?Q?dR6+DTxYB6T9xyZ3cUTWgU9NE8YOtGtDgr3iMyfmNyA5NPD3CNwaC88Pt705?=
 =?us-ascii?Q?g9METIjGtOs9q2OG+xOiwdDA3ZWMNVXEGvlBPt7V5cSK4gNFw82MFiY0PBYz?=
 =?us-ascii?Q?b0sM+LC8i7if8JFUzLunHd0gnqfGcrX3dNQrp3Nypuf8VHt83nSNEzDBWAh9?=
 =?us-ascii?Q?/ECcOUH0SPhLhZNsYcXP1jM/m0Edqa3ia4vLQpiK3wUGVudQw3FtI/PTo9f4?=
 =?us-ascii?Q?CDXZzI+kopFZbrlqEgbKeul4cndxw8NKpvoWidh6YVh3CdNhuqt/RWLedjSx?=
 =?us-ascii?Q?9idhluDMUpw88JnR/InDDtU5kMVCp7ANi6txjoanWBldodIgS80Zlg8XWeLQ?=
 =?us-ascii?Q?sRH+jwnW/UBpN4kB93EZ8y3qqIqzCH0V787VNMENGyXxCAElr51Oz8bjbNxo?=
 =?us-ascii?Q?+sWFEenCBjW16xTCp+I9Z+WW7wf4oDhu3rTbbbtyPhjyXeZorXrNCK+Qtgot?=
 =?us-ascii?Q?+WKBss400lVJ0VOpWtXeZuTs5+57Ym5U+IK+Bq2pPiGNJR9L7FFd3g1CSWaM?=
 =?us-ascii?Q?WD3/nc8yB4jQ0IQVAuly9lyzL30/jQ4GISWUuQhVtxqgpVDaPJkR4HP2PMcy?=
 =?us-ascii?Q?spVqV6n5HmsdNUAFvTTfJhUFGXzfBc71gVzMEo0BBrIRfsBwfOiHVSFg8SCa?=
 =?us-ascii?Q?+9YBs1LGyL317lrjWxm9Lj1fbRWUap0=3D?=
X-Exchange-RoutingPolicyChecked: Msk9+qEjVi1nhvjkzQ1xOCHapJrgdTCRO1nzsuHCKG9j6xQ7qwT3bYyAv8hSrZ2krNYFtI32s4MzvNo0yF6ZXXfwbJUrZkl48N8ysoE9mbGQHnPwDuFfifyIsaBnlIT/T6tfiAWf8M7oqnJR2915i3ckVYoI7awzBkAo7vQ8+pto7hV/OySkheLPgRnrFGThFOVyg9B7w9YL+V31+CCL+1Zts83uOxvjyMKZFVPC4RX8puRylqBEP+pHjVLbmHYa8V7bMAjJ0Pm2c58cFcsLoH8gtuLhYcpu1FMQJQuFxsSBO16KDa7fVHQIsnlFc0wnkFPZkPFJB23ZU+L6i89cIw==
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c28bba-6330-4a6a-a315-08dec10563b2
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 00:16:42.6077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZma9NveadRnYaZI9+lkZXEgL5QGRTvrm2wjrxlivPUBkU4ejYcwD0kXQ7lfGTvTMWIolMXM0cswIS98xB4gCvMMtH8PEBhwjMDwxVAVVwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9511
X-OriginatorOrg: intel.com

On Sat, May 30, 2026 at 04:51:43PM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Address some comments from Jonathan that were missed in the merged
> series. Fix line wrapping in fsdev_dax_recovery_write() and
> fsdev_dax_zero_page_range() signatures.
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: John Groves <john@groves.net>
> ---

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
