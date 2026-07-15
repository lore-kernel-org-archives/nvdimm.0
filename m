Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887522C9D
	for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 00:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784074006; cv=fail; b=DL7o+X5kx8UCpHZQC7WUN9qA/w/ftW9rBvpWR8r+JPHAwMToyRRR/H1arQmovvLYuPQzFeR88JDC4abcMnCH7TkRKgQgJjy6AyZ8pRlAKQNg8AkGYF6ppruSy82PaomK7L5K7jud7OyjyxhBjDhv9IpZKtJatISfUzvJt2hayzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784074006; c=relaxed/simple;
	bh=f2alxsPXKMVYY9mmJbKfcN3wjIIU7kwFesFZlriveMI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jBNv7UeGWPTAfs0m4ySDcqqcQdV69/MR2zXwSWr01oAAhDykOIxeu1M2M3rbb2yIBcmwB7XppLt7/7XhOGrtD0T2Rpr6rNq9+sykaO5vVyPRd4A20/R3ZV/OPVj5PJyVxvIluRTukpKWcT+rXeppylZ32zvHNz53NvZ0zQrS+N8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L8S6L2vC; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L8S6L2vC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784074004; x=1815610004;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=f2alxsPXKMVYY9mmJbKfcN3wjIIU7kwFesFZlriveMI=;
  b=L8S6L2vCcTPXUFKZ1f8KYwbpuGcG9JrAQNW+lY+IT8aGQlt6kihJR/va
   Q60Tpoq1htreA99cO/V1EBBybqpMclVd+mPE7uQlgg90J43CWyxZzk/2J
   BKLl5REj+poiCCeFUdarkPoL5siR8jQQ6+q/+NhYEVOoJvTCi0GuQV7ac
   Oo0lNjOZyDr2UKEba7cvegtZZR737AYQtTrMlj9Tnh4EgRsuO8xc0+9bb
   1JfVvQLS8CtNgkYld14Pj5WnwOitqFtFNUe4FOddzEzeB4MCQ/u7JgOgC
   Tz6HlN9S0gOQqu95GRBkKTZ3oe616L/BeI2LDGnDHytG2eCTEFT2lqHp2
   w==;
X-CSE-ConnectionGUID: MntrVVSqSaaG9tEVj79TYw==
X-CSE-MsgGUID: 6yv06FOpRh2Je2gLmsC2Hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="72232252"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="72232252"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 17:06:44 -0700
X-CSE-ConnectionGUID: 6hy/xv/jSJ23/DMHbdLoDQ==
X-CSE-MsgGUID: pcp0obA0QDS8aV9PDZDE+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="249637040"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 17:06:44 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 17:06:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 17:06:43 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.65) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 17:06:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BRMyOC0+xdgQ0XeVP2UPFDoQQbZsUvsiP0/+WqHkmwS3WFe7jsSYB6bJoyrFFxJa7HkPwUB3fHRp0jJ2D4cMrBataF2PpHA4KQDP8J4TE8lPm6K3KMr+kOKp8dnXPrnsVdvYsY1R+SPkPR6eaVe7r8v9CP0nGk+4tufmqBrIGN8+DOPVUeRNH4IUAivJI4rP4U72e01spQfRfcRys0RaAKa5F2A0holZRW1flJaEnGgV3d2xak/CRYfrwaiR1QNd+i5FiIoOou2z+RneU8S9VXgWbr6ayFszJ1bXDwqupILk4a6MZkKpYETYpyWotsEDiIY0Ao6Q1wi5DMrEaDz6SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ynMLT0qOrDxhJdJOaYlLYH82jqxOfaL1IBBhKz+0Q8=;
 b=KbIotlgqeNPN85mH1Xcow6wsLmvVIhnjNcdwChukfP7wQwvLpwGsoFtg2oVzvm0JU4XgWTU/bSfSIq/e+Z5B6GNysVZn5C+gKens/91PB9Y71w4OH0nqo2M2W1jcEqH53K6bws3EI/hH6FYZLrNHsPXrDBXhIaDAoY0SQHeT4AiQYCbLAXjK3NbWUHKayVk2llAG/oE8b76e6wcyyMW+7lhR5i0xYHGoKB1s3gXGFEOpgnII6LuGEyUnAqLbY+JxMMsi9PYSrWQHd6yWFb9oOXrYdfLTqRR8CSvzXX8o3hwCZZdTJBK6ywo9/y6nn6bcaS7sIp/mY0GIKY6oce40aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA2PR11MB4796.namprd11.prod.outlook.com (2603:10b6:806:117::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Wed, 15 Jul
 2026 00:06:40 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 00:06:40 +0000
Date: Tue, 14 Jul 2026 17:06:33 -0700
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
Subject: Re: [PATCH V6 0/10] Fixes to the previously-merged drivers/dax/fsdev
 series
Message-ID: <albPCdtgNi6sDIsJ@aschofie-mobl2.lan>
References: <20260615160531.17432-1-john@jagalactic.com>
 <0100019ecc080a68-8dc0c99f-ab17-4aa9-83d9-490e9c97ac2e-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019ecc080a68-8dc0c99f-ab17-4aa9-83d9-490e9c97ac2e-000000@email.amazonses.com>
X-ClientProxiedBy: SJ0PR03CA0260.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::25) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA2PR11MB4796:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fc0365c-7489-44be-74e8-08dee204f115
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|4143699003|18002099003|11063799006|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info: Q/QNoqUS8UkCxeONmuLrKyQ5dGYXd0xrjgSeGNLb29oSHmBt5lWq/vXSv16MK1X4Bq1o2U7bO/9WNhTWS+wudbv/UbxMcGB8KKpiIZiGJyI84MYG5CGNzR7jSQ+N25exND2KOgfjlqlGAX6uSXPFw7FYvl3Yr1CxfI9SbZ2BQHQm7xR7J0pKD4SSNNy25SOYooNFjd2fOZwATyKgbiOF85QjotWAy1Qfw30M5ayLd6pfS2SuOiSUaulZw1QqfarRoOF+DUxuKrnTGmf5h4UPIJ2GAJVEK/f9Vq10uy5mq6z9isVbTDu2TxUvmGY9OZm3RIrj8FwKIKfxihpziYwOMWmT3+6Gb07yVvrcKD70oq93x1Xvnp2J+TcR8/XdCdK5WGs4/7b2T+QPf17JEW3hQVCz24KHqXCL7/N21Gfj47eMXoOI12v8PYrEllCSFb7M0oR//khWYKHAJQlPDRec1OIVFOJdYDit5LPM/mqETUdrShyx2n4njq/IfsorPvlbpbY00Xs7eUNec9FyIvWlwx+CdYrAjQ3c80cW1cSwmUemrT8l5bmXCjxzxvz+tACN8vg/K4ctzn2pzoMUZIjPNQQwR88TKiXHG6/coR431gQUDiC5OUbuqAJu4oIaJrKkixeOjgW2knCsV4R6jF4c5rgeRtxPClIoDEQevrM92Yc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(4143699003)(18002099003)(11063799006)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PdPEBJtMP2lr/y1/j854Bq8PHUT2S6A08OfRdXY/+IYRFwpsLwxrwNuvyV92?=
 =?us-ascii?Q?bxB0ZtHHMSIPdbPeTbKHgR9azeQIKbLZY9xmyb0QO/EC1WaGY9Kev9TXT8CT?=
 =?us-ascii?Q?pezqYmt67yjhw0kf9b2Adq4kFbAsG0Qqv1nR8FSWKvGwYIl7rPBj3MJMWlid?=
 =?us-ascii?Q?CSgKld9lCkLZ8bFcPWU0wOMfe9KrghcugTF1nbGW5wzoMiTBr6tZnMqmX/lN?=
 =?us-ascii?Q?Sz4ZNOu2smooy8YwM/6vyYxiAtMjekvbwAXpt3v+6dCaPpoezhCr85VqlS5C?=
 =?us-ascii?Q?YrxgMLbEfIxS/F2Kg3G8TnTJy/zb30qSTST+Ggh1QMfr3+6JMaq5V4OQDcLR?=
 =?us-ascii?Q?I2UL7kPVxBm65G7Wp5c4Tb3p6SATUwWbqbYWmqjCh8+SekmKDmwxfcEY4I9m?=
 =?us-ascii?Q?XqAS3orHnQmjSFaIELuz2/Y+337DY9SP/KBC8Ze66K65Ewd6AdFlC61BQivp?=
 =?us-ascii?Q?Z+PlooGr/8/UqUSE443nsYjcYhRTAOqwyFNyqMamSQVMP/uUWW0TeaDara2C?=
 =?us-ascii?Q?6cYNeh11o0GkdwctvwuzU4sFM9idbvHVH+WHfKWSUEXxpc/CqNnF+vnipFZs?=
 =?us-ascii?Q?GE90Ja9Fd8zgQ3XJrZ3TyWaccQpZo7lASPuaJeX9ZyLneSa/bjXS+vy5eVUo?=
 =?us-ascii?Q?+cfczCPs2j4Dn1kVj+J5WhvrG+9gnlNlNP67Bmr5lqpMkIThUDCcuSEkgQ0w?=
 =?us-ascii?Q?b/yzGnzCxkfvopTsYczJLxQAZAS/PxsalpKbS7SGBjO+kl+BfZqfOL5rjA04?=
 =?us-ascii?Q?OCuJ6g5bUL6sHQj27aIHP9EMz+tz98G2HpBZvV2lV0okx6zFZ5Zt9zW9Ouzi?=
 =?us-ascii?Q?JrC8jO5Z9WULpk1GdByJLhS0RTrPMmd4Zkq5xp2KMm1RGVVgCY/8UE+6Lgnz?=
 =?us-ascii?Q?JjPvqkC6M5ikgbYRUpvFWI1/5Ya65h7sigE/ZY+OzEjCaleJpLY6IlSErkqa?=
 =?us-ascii?Q?sdKr4ndB9W+ijG4UtBowxCp0wSxDy9t/u6d0iJrpG0K21yve6LhHVQKf5hO5?=
 =?us-ascii?Q?cp1lPxB0xeRM9JtQpe/iE1hIKK5Z9AiYBJz6KO1OHQ8gjtiYVr8IVa+RKKRL?=
 =?us-ascii?Q?RevwX/rYMJoACe6XY9vLbk4MF0TB2JgpGB0xmuovraHRlJVd2CFAfIdlyiLr?=
 =?us-ascii?Q?szmndMfxE5jgMmOO/44A4KtWkT7u3B2nenWMNVREexOQLBSzdpG3JXyBv6ma?=
 =?us-ascii?Q?/y5sjQOubUHhyz8rh4c7Xg25PaHRM/lUNR2KmqsKIlmMnPZL1s+uVhDxuE2E?=
 =?us-ascii?Q?D+2v70xrZbAMMb4pD4JgYJmvH3bYzT6Gouw+roRhOWvkpyB9NLfMXOvOpH8K?=
 =?us-ascii?Q?mXf9nP3iHvKOERPgkx3CFSZI/171CFks/my/H9taKebBs/3qyES3mGES0POD?=
 =?us-ascii?Q?Qd6z/DEzvo/L2PbgEL65SUVIveHNGJNPs1FZp1m/wivYI1V+7bUSoevcYwOw?=
 =?us-ascii?Q?0DUVdJz/TEOcXMqmk8U82HUZ16Dh4cytXHYlCEVXx1Gpjhb2u0B/6TIVuYCP?=
 =?us-ascii?Q?Welvj8gkngJN9So2FJjJBMyn4uptinQfLg3L/67PPoiwa4EzrzyHcEjq7sL3?=
 =?us-ascii?Q?X1Q3JJ/VK4stGIE4fJOt0MWcuO1/GDlFe+/ZodP0pIxS/YvavSib0bxp755f?=
 =?us-ascii?Q?phtZZMyktvfo2YJPzZmjPmldkmsdtfZ0BT2KXOM92NGk/HOQt/mBLLUvup37?=
 =?us-ascii?Q?XZiXl6iwM1rK/pN2ePEITM7M6omzaOuJAB9E988+xE6D9krU4cmLF+Wc126H?=
 =?us-ascii?Q?wf7oB1jVnSx4nMSD8EHyN9OQgQhPbD0=3D?=
X-Exchange-RoutingPolicyChecked: EuGYOS62NWAg3FfAR3VXyfviZ+mvdOwjK41PAbAg2cr/Ws3t0Zyy9F6Hos6dNEzGxP6c4uIaSx2LmradsU2gJTYEtDJIR9ecXeltwyv33JJMBqg1d5kxFX0fsxyyOZOXJ+sLCxvE93ygyoI5Lqp5BFXMK3KlFG/7OOmr54SKJw2/g59uYASIlBhWbh1P6elOwJRY2CS1wMNHHCWFnIy9lTRmc1ZUIuYfmjY20G4La/bBd6LgiUsiAws5UDh0Y/aN50ap3Ackdjd61fWXGRXrdFLBoyI9ypNZNZFBr+8hp0hBQoJ0rdQ2v+GM5lftFR7eqxscXvmrVLjHt0dRLZ5rdQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fc0365c-7489-44be-74e8-08dee204f115
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 00:06:39.9545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLltIXbcq2t/w0PoRtqxnp42c8lVXh9FXJ4IirIHZpzP9DEmMRI6bEE6+Kenb9jTOIGiURTpNOFs5C2+EAti+2hutQ8T2EmIC2ZN4GfzIAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4796
X-OriginatorOrg: intel.com

On Mon, Jun 15, 2026 at 04:05:39PM +0000, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> This series applies bug fixes (mostly found via sashiko) to the dax/fsdev
> series. It has been soaking in the famfs CI pipeline and 1) won't affect
> anything that doesn't use drivers/dax/fsdev.c, and 2) doesn't affect any
> known workloads -- although the bugs would have manifested when multi-range
> DCD dax devices are a thing (soon-ish).
> 
> Most of the series is confined to drivers/dax/fsdev.c. Two patches touch
> shared DAX core in drivers/dax/super.c: patch 8 reads holder_ops once in
> dax_holder_notify_failure() to close a double-fetch NULL dereference, and
> patch 9 reorders fs_put_dax() and adds a WARN_ON(). fs_put_dax() is used by
> ext2/ext4/erofs/xfs, but only holder-passing callers (like XFS in-tree) will
> see a behavior change, and only a new warning if they misuse it.

Series applied to libnvdimm-for-next:
https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/

