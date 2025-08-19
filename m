Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B01248F77
	for <nvdimm@lists.linux.dev>; Tue, 19 Aug 2025 19:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755632109; cv=fail; b=mM+9REGgW882nMAPCnRlqlYwG9tAQgdoBrnN2zSn5b/GJIzSwP9pyiWK4ph0r/vL1dpr++wx6nuROKW5nlC8PzkW788+UACMSrzkRFDqzFBzEGvFXxt5DJOCecVpWysAhxZJmUhiD2rLhCnOGSSUvf/bGWv7b9T5q6ck66h2wpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755632109; c=relaxed/simple;
	bh=g4rO49mGD7fzPASB+0Jd0DxJQHh0D02Y95Ufh0Clfs4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PR/AFiG80N1HFQM0XxI1yN7sL4mdJB2G6ignw/ikCFe9dG4hNzF9smW2+FnLQOXmYMT0g4cuh4c5bMBBo2/bfrZEGdoTFZco41dCHf4jlOC2ACEA0h2mPscPWjI5vJHJu8ltH2E/mg5xa+SYCjKLUGQVRs6w26GaQZbf7GuvNBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dOb8KTXP; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dOb8KTXP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755632108; x=1787168108;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=g4rO49mGD7fzPASB+0Jd0DxJQHh0D02Y95Ufh0Clfs4=;
  b=dOb8KTXPV6Iw7A2jzuVJseOy6UTI3naZ+9pf/jCvECkq7WZrgnIHrzQb
   C3IEa2MW7l/KLvlI0UejKLwkGI/OT8wIZ8ZsIkN7u+PEto9okieZSZ9c4
   6wxxL+i90ViOjyBfaX0V3e8wvEtOIx+fHW21ykQL/7jZXFEzraU8pnR6s
   B0057jp4uukvlll7C3+fP7R2sej7jzU3uCmY9TaDKTnjdWX8VZvABD5R8
   aihoqcVmwlU4PvRe5PC93JwMvct3N7PtEQ/aBF46I+TsXTbAbr/aeqEWD
   7qB8TMcbFCskCe+2SzNEYMQ8Y7HngjmfnMwrQMDqjzLJEBQKLmyub0fRQ
   w==;
X-CSE-ConnectionGUID: 8sbqJOeYT+CdZnmH1eJM4w==
X-CSE-MsgGUID: vLOnvhvaTeux6o1qsbfOgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="75341515"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="75341515"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 12:35:08 -0700
X-CSE-ConnectionGUID: hlyNjB8eS3CSHezCPRrEiQ==
X-CSE-MsgGUID: UxO3wtPmQbusXLLRC4bKZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="198933012"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 12:35:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 12:35:07 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 12:35:07 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.58)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 12:35:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OJdSvmgOVj/6Op6BaBCTnCFlTHO3/Y7UlURpy2c7WLgd+jhpYuwd9ry8Ec+U5FD3Q+EpDJzjKd1x7o948XwtXh6sxAYRQHeLo0NgywGJrWvBleXywF90dqLfHph3gJad6IoeCZOK24ZLvZKFvD1qLk3pgi22Mg1r+wi2BaE0/O+3DGpwMo0D2q5gLkj/kJdNbnRBTHEMHbpPARzGkNn83iKVoE1ULWzXRQSNzBkoo26cLi1+zSak3G3cGgJKFQLtkE6FD7QGHEMSHU7Cw5AGNnqNKuforujigoaIiY7elnFneBPxGkKJnWt/9E616KYH7Hn4LNbDScZVoB2N2jknng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqXL+Apca9WRi3qJVZYQ/ZUhqO4NJvbXHiHLj0Iiztw=;
 b=llZpQK6QqTNKqqHh5JZJXrtRITc4HGx7nw5TSUsAtN5VgyIiq/ocHL/gic3xoeICvvi523VDxQUFhdFD86kundREBDXZtNdA1F46IUmMAj3NgSN0ahWqkwSWNFHj0VvSwIgCTMQ/8p1i1XRuKZhYfGw/OD+Zy/ATz5qXz5ROFu5rc8vkqsYQJdPfyGLfQ3ZNGaFns6ruA7VTZRTtKHAnZ6a99BRXLbiO6EzGH3D6BvX7ij1LddlOFEAsIE6mUhj9XjDbNj/A4xE/rZRXcxHh+W+0CJfZtEiMROVt8HszJN3OG4geIWJ15+pAMS3daZeEmDM96pJcZwwHGb6N0mfAPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SJ2PR11MB7518.namprd11.prod.outlook.com
 (2603:10b6:a03:4c5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 19:35:05 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 19:35:04 +0000
Date: Tue, 19 Aug 2025 14:36:48 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V2 03/20] nvdimm/namespace_label: Add namespace label
 changes as per CXL LSA v2.1
Message-ID: <68a4d250ee63e_281ac7294fe@iweiny-mobl.notmuch>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
 <CGME20250730121225epcas5p2742d108bd0c52c8d7d46b655892c5c19@epcas5p2.samsung.com>
 <20250730121209.303202-4-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250730121209.303202-4-s.neeraj@samsung.com>
X-ClientProxiedBy: MW4P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::20) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SJ2PR11MB7518:EE_
X-MS-Office365-Filtering-Correlation-Id: ba1d9442-1f57-4cac-2994-08dddf577f17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?u4MUWMHVaQg0a8NPRpgHGlznE0zRqXGvZMutkdCJIASpT6cUIWaif9LVchqM?=
 =?us-ascii?Q?hiGvU9vbHNoeIC/Xyn22Iz9mo9xnBsi6ok3KwsgxaPnyTCTS3BfZ71VU/KDT?=
 =?us-ascii?Q?1+g/jiZ1pcOPHiJv6ntmlF6hfeGMp9ivXGuE6KiZ2qqDKQhZfAX9mEGm7iY9?=
 =?us-ascii?Q?ZYnQvN+3dVR9WrPl/pRO/UuepohOWCqBkqBdvNA2UvzDDJyzS39lqVIIj957?=
 =?us-ascii?Q?Z5CGX3fF8THx5ShNxM2E+8ulgvNeRq5aeLDh54zIyri3jvqjtO9P7CzVqjYR?=
 =?us-ascii?Q?Bx2czVoU3RefQd852GiLD+ZrnEroQ2nH5+sk6qVJkCVdQaJ3J98brvXlhy0N?=
 =?us-ascii?Q?ZvIKVWKlX1uS+ffB+nfZEXRXc7q3s2k+/v7ek+pKbbzSTA3yZoIjz+3MR6ob?=
 =?us-ascii?Q?pReja5ZqXukFkzp4D0iXvqhmwPgjepQvZm2yaxMledQiWdOoE1GQQGYo9t/b?=
 =?us-ascii?Q?Zlt3cQJb/ifgzntMHkplawe4s8BbO26u2jD1mUxmB1fLyhlXlTP03m26eMWD?=
 =?us-ascii?Q?fxfintd0LMIMSdkARLfPj9mRRFWE7EM2KZgDkKuYYkcAWb0g72A8M20+FNaA?=
 =?us-ascii?Q?mYPmAWgfjzq0EXjN8or0euTh7x+RjuFaRNRuo7LFVL04uxwTisqwg7U2YWSc?=
 =?us-ascii?Q?v33TKsd7u0RaqIbN3Yq/DjxAXU1BU7lX1fkTD6k/5bO2H8nRL+84+pT4bE/q?=
 =?us-ascii?Q?2e0M2eALg0/GVreNHexr6fRoJgYKIN0BUq9i5BNFElk0tqVgXR1noJBBYZ1w?=
 =?us-ascii?Q?IpLKGBo+7w4posg3WVTVc4z3U8ehaNGbwxf9aRrkXE5mXRxExg3K85cRI5zv?=
 =?us-ascii?Q?vk71LUG+aazkirqJzszGRA6uJJpfZHkhKV2BThsNnYL2VQnJqogJt7Tn+BvJ?=
 =?us-ascii?Q?8EpfgG33wbhWBm+uQ31M3FtVv0OPPWC+/IGpDjY++19JQWNDpL+zS+GT1o1M?=
 =?us-ascii?Q?3Fzzin3FxSVO5F4TL55f7mdOOcPYp5sCUE04XewBHwGgORPWxBEmhC03n8Q5?=
 =?us-ascii?Q?WVbh6+IzU0Na8BcaWcP8iMTnrI7y86jpw6T4IR35W62wa/2NwGbjpNiegK4S?=
 =?us-ascii?Q?C03v3I4Jd/Oyo22bdOwKDQkSBJEOsRk9XriFJ4UgDbfiyGJPM45cykh2Vy4/?=
 =?us-ascii?Q?2PK5iGERVOCS5Z/d54gnevGoQB1qbZD7Ra1/cvgiF27sJotCKs2RymwkrAWo?=
 =?us-ascii?Q?N7G5/WmqIEWYTeY9B+SlDd6NB2NWCGtJNnWdvARX69oAkyzczV0i+D7ma7AD?=
 =?us-ascii?Q?ist7F9I/steq45RaR5ax84wJma5nYWe3dM+EhFCOsEIXJy1vmHJn79R91jzl?=
 =?us-ascii?Q?PWDZNZ2jf/NTgWIFOnzd/nTg67Cc95hpkzMCoU3ZA16Cpn18vM0k+NpqQzZq?=
 =?us-ascii?Q?S+KYV6E2Ggvu9gm7RQruVQ5py4Uc422LAYBS3F5NTnXPti7MXQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j+BuDJHvEEpNBDNvPx6ck30/bMyCyEACsYnYh4N9iw9kQPzq7jqvt6F93Oew?=
 =?us-ascii?Q?d8juZFuY836ezSGoS45keN28/btkiOHQTsYbeCO0x5U17+m/XflwY3P1a/Sw?=
 =?us-ascii?Q?PqN0JdUR7c1CDDTgqY3MgIFAAbvetL/4yy1NX92Xx7s85+BoxifJX6teBS2U?=
 =?us-ascii?Q?Ps6i/mTJzS931nLgjnruE3Fvc49wVWUwvXNlV3cOOutLt7EOgjDYqwsFoMaL?=
 =?us-ascii?Q?RvppyswBOobSZghJOkjGesiKcOUgRT0U2f6vmd0en1GKWfdsiNe91Re267n2?=
 =?us-ascii?Q?QcfNFvV3+Z35Vx0dGT//Vk/FBEF7VdVFeoDxHICdcYub5HPfvbdKk/luwkFR?=
 =?us-ascii?Q?0OMCs9zV+lIfLWoQjcp4zF2z3IpQ+gnZC1FR8ahbRup2W8d6Ty+Xpa/hu43D?=
 =?us-ascii?Q?GxkFkmANlUZXcXmYv46VxknNV09v1zMcIrzuREzmb7kel9830Hhne8bV1PJJ?=
 =?us-ascii?Q?MJg80TH5q+54my9Bvy2yg9/dM/YIm5TNeNIt7+fLJRfRWHRCDxJ7MyFvNRAZ?=
 =?us-ascii?Q?h6B3ooVUWBMNUJD8cMGK2kbPY+KBXHRSQuwIxd+BJJj4hkjrzH3B4aeoLDKR?=
 =?us-ascii?Q?DmC4zKj8wokWbEiHb6KL1ISV0jek3z1P4tKkKaTcL42QPuRqq++gIOefH5Hc?=
 =?us-ascii?Q?EBQvf+qD+gYItuGLC8XE8tLGnQcYDZRAoIC1VJX+/vf+xL1t/gd+UBNSeOtm?=
 =?us-ascii?Q?zop4z01usRD2lrNr5IOrKPzq2+IPV+BHXGexhxU4KaBxJw9lHJRL2M0XaBqz?=
 =?us-ascii?Q?3gofGnSgsuI8WswZymWBAgFfUC7Z3qzHvPgd97KZ+3n/TipBvaHdZKQDNGs5?=
 =?us-ascii?Q?1hmGpehLvoGPVC6X9eMXUHb1MCQ8WMQWu1A6Ruks8Wrccr1jebNy9gg1vSxn?=
 =?us-ascii?Q?0BS1w9rUp61fBVZmWE/xDJ9Q8lTS/A21j6AS+Ggh4z1u3RhZvFpFP6G6J5M6?=
 =?us-ascii?Q?SvWDCig2T+zAXbQLbtjaBRINrCQ1t/la+EZN7aPMbZPdWpYY5wdE6YJK/ovu?=
 =?us-ascii?Q?WHcpV6d5hFa3HdKCCBJtNhO2Iy91+o2J7vDrEkdooYTzYMAFMQz+a70h4dzI?=
 =?us-ascii?Q?RSC/BbZ5m6uq1VKLkaC/cgQQM2PrAZ/MCjibfCsw1MEXxH7bGlQqm9LkiIY6?=
 =?us-ascii?Q?TmJYn+p8E8hOtXOiBCMrtIefjHgoKWXR1lLJ1VAbsf401oP5TP+8Izp0fM7L?=
 =?us-ascii?Q?x6MRDnSe4PdV0PnDeKMKSou97OnYUYXGnwiZFwelK/PwC7qLh4p3AN+2kGXf?=
 =?us-ascii?Q?Cz9pyV4xcSaTEBO0WgO20cm9n+x4MEd65y2BeH+4yX8QVOAY2ky/m/WgdawX?=
 =?us-ascii?Q?yxZctHTuU0QCfvEMBQ1aHll5ySi8bgV3xwIYE/SUvAuFOlcDo3ik8ADzWpR9?=
 =?us-ascii?Q?6U0gIUI3GgEvDeZ6xOUS5IXj3grwjNIn70N6At4JfqOtltdv9I8tR8Do19ai?=
 =?us-ascii?Q?g03baX4PH99UorYbeT+E8sTd5N8acYHakvsfWuFdVjMISKf8mvFUypUa46Uu?=
 =?us-ascii?Q?VLJT/fffDGLCsfEBR9kFtzyC3UlMYUqvgUsBxTglz2cGXxNqYVRnU75okgwD?=
 =?us-ascii?Q?afZ/DOrYOKDMiYg879gQPvB+6LChic0YswOtlVKD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba1d9442-1f57-4cac-2994-08dddf577f17
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 19:35:04.5304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jqMPAITH2hQy8niijp0sPhnr1FrDKThNY6weXcQu46cC+XnQGCW8rSQvrp+3I3vNVdwKtnCAj8YNK8xxl0bNtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7518
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
> Modified __pmem_label_update function using setter functions to update
> namespace label as per CXL LSA 2.1
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

[snip]

>  
> +static inline void nsl_set_type(struct nvdimm_drvdata *ndd,
> +				struct nd_namespace_label *ns_label)
> +{
> +	uuid_t tmp;
> +
> +	if (ndd->cxl) {
> +		uuid_parse(CXL_NAMESPACE_UUID, &tmp);
> +		export_uuid(ns_label->cxl.type, &tmp);

One more thing why can't uuid_parse put the UUID directly into type?

I think this is done at least 1 other place.

Ira


[snip]
