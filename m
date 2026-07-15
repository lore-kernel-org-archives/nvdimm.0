Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1284C171CD
	for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 00:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784073705; cv=fail; b=tBdOTnYFh1XXEHqFZ11cnLHFVq6fdDdEk0gD3UUq2eKgX6eiWhp4enF/9KiyMlykq85PQ8Tzw3ZN2UW7X3HrF4+UfSpjJG23gMoIqKuBlFMkZq594ZMVJBjyM3uOPsiPURFwvtqVT6N6Wsjr+FntZp+NOesfkp3/DkhaSArZmzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784073705; c=relaxed/simple;
	bh=0G1xQL4i2ELUUQyIXrmmZPb3pom4htkwvJkiyUHIgiw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S3PnP7ASkpgC7cBC6sr3YBWumun6uvgTWDOuJhzM2lbKdmmpyn0/WdgTo2VO/PiAardx7DnISrYDFSMrVCufBqqLMQLifOybkpAb+uNVZP+SAZtLegGGjh8LjFyJfwaroRUs73ED6go2c4S2iIZG/HVmB/qWJNOhfnZs2AiyEbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i84NCkgg; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i84NCkgg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784073704; x=1815609704;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0G1xQL4i2ELUUQyIXrmmZPb3pom4htkwvJkiyUHIgiw=;
  b=i84NCkggZbWmcdp+mAexCG21oKEJnFITkz+tANrBffdv0QCkT5lRvZZf
   oHV1gISXV4zcCwRzTOHVr+KrqR7kZjbHB57EbisSSqeYsPD504OoCc/0/
   TLQdE3NmWeBczPMsXLjaCuHT1g/4P573gxku4BEu30pVz6RC15Y6AzzsM
   CBDBpx18AWXPg439ctUJV9QQDL0Yof42Kkx9APSAwV2LaKjBaAA+okpam
   baDJrV5C56aeEOBqwuomhuknFtujFZG43BPRlzFrqAzdTlmAlx3SCMqXZ
   c6F5q2QTGky2y16ZshZQSr0T1+umkRPd4uSEqOvPAWRdtNC9bR1UAFQz7
   A==;
X-CSE-ConnectionGUID: IznDMUVdS2mLRfxMTpf+DA==
X-CSE-MsgGUID: ooYCZMU8TE2zUx3zf8j1Og==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96215919"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="96215919"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 17:01:43 -0700
X-CSE-ConnectionGUID: qOA01BxsRtGcNdA8rX+cxQ==
X-CSE-MsgGUID: qxmVKC0PSgSKDwGkmsp6XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="253385025"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 17:01:42 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 17:01:41 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 17:01:41 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.0) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 17:01:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zBtywR/LNKTzcgGxhkUA7LmYs6wameSQ7aImQh9SLPjDpaR/3k961OKGPvdOwHREhiPifkxeZ1/BcMYv0IwGKSdSD6S5w57r9vcwpHqpP9LaNitjcOMmvwS+jyKePHoHPwTnAGR7slrT3iXmbmWR3DyXR7avVWW0/quXj7eXjURUy88l+e08FovKW95wNuAcmImFD2A7e2fT+UyaKlcrqjRtLD+Ksocv0497NGs42JywhgrWQ3c4zDG9oQOdCCCWO4wpIf7ifZ59L1uyh2TPpsMQAtkxNjPp5t4+39C3CsgqAJRe8mw3aqHRlv+eKoBgS/NeLE3PDS/H5+z9d8j/4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwQp9bfh8hS5yHDapyy7Q8TfQURmO/m5nzGykwiozOs=;
 b=N0wG9Agio44pEEt7HuR+wXcS45ooek+pw0HZ/pR8ws3Li+3XJ3hN71pdDVFP7M5fdafAj2jEEBAKuaaEFTuezQ0cck+UY6EDhXU2FU2X1V0HgRvoyM5z6ufXqE6tAk9pYIqDtgfTOjwPTQj2l24qtpXzS9minncPfEeW1PsyuiW1GKKtWPyWtVklWKohMs/W9IhwHcpLar4ea+vnjUsKWLOpS4gN/aKqSxdwBaE5KvR0T1bW8DhCgbUB6CU1kdYWKGN//u++TyiHwWMfwQiRUMUIHLgidD7p/MZajpjBYqfuVQ5d7XZxuiJUgC3pW9mIbQNF1i/lypv8FxSBx8qpQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by BY1PR11MB8056.namprd11.prod.outlook.com (2603:10b6:a03:533::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Wed, 15 Jul
 2026 00:01:33 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 00:01:32 +0000
Date: Tue, 14 Jul 2026 17:01:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <mdshahid03@gmail.com>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvdimm: ndtest: remove redundant NULL check before
 vfree()
Message-ID: <albN2b1ay3q5hdun@aschofie-mobl2.lan>
References: <20260703135513.75840-1-mdshahid03@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260703135513.75840-1-mdshahid03@gmail.com>
X-ClientProxiedBy: SJ0PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::10) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|BY1PR11MB8056:EE_
X-MS-Office365-Filtering-Correlation-Id: 392c10c5-dbc2-449b-0c31-08dee2043ac4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|11063799006|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info: RSwlcOzsh/nZjFjOK5BnKL8nOLYuifeFsfjRGXeSqby8WmahJ9JOd5tQHe+f/4lbP8RmGNaeFdPYNXXsSfKN+mWdSmxNz5DSjpBBtAyHJ0cnKK90DBRIw4/ps+wUDxMleSkb0inLQBcBPOSF88sX27jrBTQMQHDje6VeF17p09PO5p+SK6+zAHhFH1AVOUI9op2g0Z0rZKFpfQaHCEJCmxoZ3G533kmwI25VbryZM9AESj0T2cTMROQlKPSrwTkg+RChttCeLMD7K/Y7j8GBmcH4ECoZmyn/PBCKOOSzLvvv4UcaWkwLEWb3DqJt1LxXxkAvhEouavnXSybRKVBjDXSeVzRcHZaeec2DL1tG/o+tG3ziWQ4uVD0lBMINAwmUEf6xcAM9Yu2Q2emAoIj7GHF8YF7puig1/6CCtsEhn1tnq9ZT1bPTNCrQRO94JKbYVAnq4jbawxLJnW438cJAXoU0IynvtJyyJDybV22r2JDMyfxo5ghKcYjzlmTQlLSZ7httevhyb+5zumgK2GruJslMrOv96KOx2zKp2z4ZQLx0/+G/IZ4oPSkESmo9u59wPo1MQ2KUQyCEWqTlqSPRQEiaFe32hF3LK6Hp04Nd7MRqb1qWWQ8thGYZtyju7TklKYYxcsfRb69tj/iM3rpRUlBjgA32HL7snNNWvIN1Y5o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(11063799006)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UwIRX16jiMVNaTHPBvB9c4DkUa2QWic374CRTeBFp5SEKyvZcHz4FHSWAEjf?=
 =?us-ascii?Q?tQKXL9weagEVGz0uzo7aeQ/lDEPHJ0MV/jAh3Ekp/5B8zMeVoO6je9JedIwY?=
 =?us-ascii?Q?nTz6PNuCJ/s+FjHBbwJhPq5Eu0d09ywcDZNvnzNuuS7qRuovB38ezizh0BPf?=
 =?us-ascii?Q?k5sT7D/H5H0aBOBVJ0VdIT9Tf5QUCMsATFKIc17ZkwVNPTU4DF3ajfQOW2//?=
 =?us-ascii?Q?74qi4bBrXNwH7H0Fzq+85flJfKPZ1kJs+NnCWw9xDDdUTZx/n9sDDEZ/szG2?=
 =?us-ascii?Q?On0otBfEPMt160qY/bWTND85pfFEQqDzW4lX5rjFcVhrv3mnDlKZWN83/QEl?=
 =?us-ascii?Q?KbVUo266RbN0YcgNNd9bP7NeD+QWkddtxinwK1rKH5IfD45M4PPU0n/jpFDN?=
 =?us-ascii?Q?imCNajUh1lvpyaFm7i1TCcg1Fqj3p/l1LxOd2VoOCGZSGbyFtACIWvM4FIG/?=
 =?us-ascii?Q?sgnFVAA6+mcYOAo7tp7FGK6QOCsWOjskoAVVtAUhEpZVdhX4KSK0z7CofoDG?=
 =?us-ascii?Q?c0dmSVpO2Y6VSR4RJ+FDQ6e6gGKafxQlkrnGj/jUiXEv7+BRN/l13Vej10ps?=
 =?us-ascii?Q?T17I0pLyryWeRTS3bRmtYxrhJb2ETe5cOdO5jmM5OX6ZzGmvIbr89LwykFmz?=
 =?us-ascii?Q?zLn9GG/pBdvDlMkmqBofICsSsIpfATa/oKDN6S+LNzHbm1OfPUKeBazH7hXV?=
 =?us-ascii?Q?rb5O/0OaoX546pY9InNCpR+xp6CZZXuRzFIDkMY+/LgI1FEabaH4vBTOv+ON?=
 =?us-ascii?Q?Zk0LV+4zQUnya/BeUWK6Oc+9dwIiQVtLN7JnqBerY9p8AsApauVZryddr/at?=
 =?us-ascii?Q?3o+B0I+v7Im18JDkNzUhzMJqZhzLFJv2QZ/aE6yE6uRkxacj8DlTFdW0lP0t?=
 =?us-ascii?Q?O1twPIZ1hMlYk2F+jWEKQ0RSb0sA9OHifnVp6Wq8m2NKk0Bp7Fca9p4H8Rmo?=
 =?us-ascii?Q?d5stgUolyhz5VzXqMjy2rcqH6u6LeGK7zvnyTWC0uZh305jvdwohQYkZAdKI?=
 =?us-ascii?Q?d2kCLnJsxwraYD4DMeFjEaiuRtw+ihU6+xX6tHYWckaHLVzKLq32SBWwSR5R?=
 =?us-ascii?Q?90CelBb0JaCoeI/ZGL6Doe6MIvieXB4WcVGaAc/DFuUuURvNHKC6PfrmaTv3?=
 =?us-ascii?Q?hZatqvJ9SY5HtJDDuLtNl4dt1a4b5l6PZwMy47f7nBrQQXu64muL19rKdQhq?=
 =?us-ascii?Q?sFOE+Zte/AzdgcDH0zgpjhSJcbwxCTP55fHspDwurJ1i8WvwtFzfAcD2BqBB?=
 =?us-ascii?Q?pMB61ASMBzzbtXgW5gfhgcw26ber8H0THc8ysVlEWXw5h6Q6PdLnzi19b0Qg?=
 =?us-ascii?Q?PfH69gKVamickNt6MLmPCmt9iTCko7H8Zymd0xuawAnpWCK0HQFNStf3BfjA?=
 =?us-ascii?Q?fi7FRdWYZVR1dXLP+ykD4w6iQtZBKUJT6MUaf+szzq3XsSMlw4ROdkDmQ7bC?=
 =?us-ascii?Q?3eQQrwsAPXdW+wdoDUZGi7uS/nX7LRq3xNiBLV2VGRGoHecLskjyfMbSFjiS?=
 =?us-ascii?Q?m4RHMzAQAJfzkre4tX1eIlmZCklfNxjfzrE+5duCanO16Sx73qpbuLkkeFG8?=
 =?us-ascii?Q?klgDwOB3FdLM8tA1YH3uJ0pc6eBb9HT2zN2SvN5qdim0Kpm6GTbNcmZ9REY7?=
 =?us-ascii?Q?sdqRuzUo4rO557jzm8tSiaC04ErBMY74l7MGU26Lt+O4froN9bjLXnjGj9ww?=
 =?us-ascii?Q?Ni3SHyvGcohPpK7Np+U96w3G2RfGwcpzsTGtdBb/VlCU++Yx4NUoHCXYbn//?=
 =?us-ascii?Q?PK3Q3qyutriCQ3x/hafYeMFt4o/OVAE=3D?=
X-Exchange-RoutingPolicyChecked: ZmW6Ok71kK+5lg8p2nQDMPhKcrLQmGp5/+yHbA3eedSt8pOPVQoN4jp98a+eimLZ5kAOT2G9HE3yCcK7xz5Ry1efRk8332s3fEln6N9c0/ObBCbl+50wtXFF6848uRbyln8DNUazzOMXQtE1RcMKSqS8utQRPj6WK5us5RPbBTKVKpQwlrefv9ZO9cSA8uTy1WoO8cCsG29PKj55kywa8UT3OmgXcbvMLi1zCEHdWrGgN9LBn2TXkZjfI5AwxkgOGX2vnOKIUIAk02H9y8QDBc3ZBJ9E3GMJHZsFw7TNZRtCCYc9+1CPWpSGBaVf2u82Z64tBQ7NweRuMI30YJJdWA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 392c10c5-dbc2-449b-0c31-08dee2043ac4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 00:01:32.8450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DwhRRCzcj69ScexHBTfY/ShOh8kESuDc5fEV1UyCs+wiVvEOdzITxadV2xE88ugG3YDKE4TJkS85z1LkPPHOBwQYUPOCa7v2mHpkxq84ya4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8056
X-OriginatorOrg: intel.com

On Fri, Jul 03, 2026 at 07:25:13PM +0530, mdshahid03@gmail.com wrote:
> From: Mohammad Shahid <mdshahid03@gmail.com>
> 
> vfree() safely handles NULL pointers, so the explicit NULL check
> before calling vfree() is unnecessary.
> 
> This issue was reported by ifnullfree.cocci.
> 
> Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>

Applied to libnvdimm-for-next:
https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/
