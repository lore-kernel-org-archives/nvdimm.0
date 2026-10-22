Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792706446;
	b=SO4CQkcHmhgFfHL0xX+IjTlYG4XUBLhOogA+HM/bOAqx1qNHjP+IPsqlszdlSK13k27U
	 LWHKMaDHmp88bLn4ZutDTI1eUL9TbZX0scf0xHYU3JvSdhUWvQzJIzKOUiHwt3SwosrHv
	 rfVIRH6cN6SpwLnHhbBv/RivQKN4v+CBd3mUsd+6rxqOfn0QspGLu04pzvaYj3omhWMp7
	 JZd99ycpSasEbVshvn0t8F9xVxtzmOu5qcrKRhqveh8FE+h0nEVhEQfn8I9/cZd6+FPXj
	 txVXqt4X8hKaoEyT7jqL+gmGd1AoyABsjVZ0sV/jRHtzZBw8EXVDOCnJKxX2DXl5KeQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792706446;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=bA6Mp3X7SIpQDyv97ohjEWSuBfng3HFYxYMMMdP4id8=;
	b=0ksTBi2Na3ynzTiNu2yZKJPB0vAXG4yrBuNx0wLkNXVPWH/4EcnRVW+wn/Q3mBgQKbQs
	 BPWvdty/nt3WlGm2jhMY2ZvEj6uTKsaJB9K4wz7M8Ei/me/h9Sp3PYFYd7JQlo/3fsI0c
	 y7lRrOk7R6roOKqLNVR+NYVnK9rIvqhUTKhof3TLlw92C2N8fNkXiZita19Qxhi9SkUpb
	 KzDyizP12VTDzaJvLw0YXG9ERcc7er3G2oGFznW3bbRU9TPQFNojLkpY0RQxR0ls/kEF6
	 wD7t2jbaJTlyAkFlVnSFMMoNmrX/OKTs8zFVtOsv0dbdgptF/Oo7TTZuEwWAsWKaBig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dVYUyhr2;
	arc=fail smtp.remote-ip=192.198.163.12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BF8606A31A
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 22:00:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1BF8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dVYUyhr2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792706445; x=1824242445;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IpKlya92XKvDpq2g8rihCmcdp/YmnKG1ECfXh1lLpvQ=;
  b=dVYUyhr2XxxyC80GCv3itcUM7Ir6f/z0E2157FDSrpqGFdDRgkfjHY2x
   amQ8d/immPLZGkozk0U1F+J0WexY/mQ+70NDaAHVgCmkJtS0Q52DqX1YG
   dBDq8pkeGPxgzUvPm094/LpSyoTg2vIvlstGwFzij1hgLOpEdOb9PHZo5
   lstAYaLKPgkTaXs7yYos3aBqYig7ozx+Nss9UBm+pk4b2O8gEntqS9Afg
   HSCWyeWXlJswLk6W0I3gCoP/b9EXxWsdP6Z5LygXgSADM6yx1MuosKFtJ
   jBamgXDtwLvFxCtGlyezuVL+bHwt7od7/d1OnQfEpOr6qUxlxV7zgW/4a
   Q==;
X-CSE-ConnectionGUID: XmbeasM6SZyZCvy7QAjiRw==
X-CSE-MsgGUID: euCxTBe8QTiXQohnjvBzWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11943"; a="1369515"
X-IronPort-AV: E=Sophos;i="6.27,173,1787036400"; 
   d="scan'208";a="1369515"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 15:00:45 -0700
X-CSE-ConnectionGUID: Y7vbInhaT8ymeHBA6IjeqQ==
X-CSE-MsgGUID: JiZmNkqhR8aSCWVB66u7nQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,173,1787036400"; 
   d="scan'208";a="3852058"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 15:00:44 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 15:00:44 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 22 Oct 2026 15:00:44 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.25) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 15:00:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EtG3qoYwDZHS5kEEKy8h4PR69zvRr3ZgE68eaT4TYD0XT/Hqp4AvfNpRrT2/a8iglhTKMc55I5cyqmmCIHfMC6VIe4rUZaGV40hvgANnqfvnlcpjtxkbyBUFQyFCrKd/N7kN3/cZMqftTJU94mFrRqiFLhlqxlg9Sx01YZ1QT12peYEgAjYo0oCc2ynSlrnoZTvL/UdSnYtQc/ktZ/fhKXYtjCEuKQeZiocDk/EETAsGwXilEyt4iuQ3ON2iLhdBvKxIB6MZc/yDu8AswzPmE5iVWurpFJO4S71Y3HHB5Ed1YRTMO+FLg1xD1lgn7bFD4Ea8ZGkFm/Te8HzE45uksw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bA6Mp3X7SIpQDyv97ohjEWSuBfng3HFYxYMMMdP4id8=;
 b=qXRDLbXR5xrNBbLB4DedAbGesV82pVYzmxirWOkDDPstZCHd+W/9a7QR/1nqKbTslTpXnR8OvuqkJAJl/ERuyU4zLG9fEQ3PQEe+mCH8R6chzHJ2sDFNiRfJWS1LeMY5Cmiwt8+8Ls6yNNG9gxVbGAx0r8rUe+dKY1/2aWSgBKOgxqcvQcTQF4hduakiFW3jGs7DJmKvQW9rU0xvlRA1A7gNwnTkvcyHmSfX+4p+2b4BB8wwwovOzOKJkgepA7BCDeNr7gtqL9G/KIvYocUx7DDiBaovKn7hop3WguV38OExlkMUL4VbNsbMLiPlBcccHPjnDr31oDXW662MkZWLeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SN7PR11MB7466.namprd11.prod.outlook.com (2603:10b6:806:34c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.17; Thu, 22 Oct
 2026 22:00:39 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 22:00:38 +0000
Date: Thu, 22 Oct 2026 15:00:27 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 3/6] daxctl: offline whole-device memory via atomic
 unplug when available
Message-ID: <atqHe2AK6Tka4t6f@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
 <20261016214248.443247-4-gourry@gourry.net>
 <atly9gd-Rsf-AoqB@aschofie-mobl2.lan>
 <179268760050.4072493.10054383256417425305.b4-reply@b4>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <179268760050.4072493.10054383256417425305.b4-reply@b4>
X-ClientProxiedBy: MW4PR04CA0240.namprd04.prod.outlook.com
 (2603:10b6:303:87::35) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SN7PR11MB7466:EE_
X-MS-Office365-Filtering-Correlation-Id: 3be21115-f307-4600-45b9-08df3087e83d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|56012099006|4143699003|11063799006|10067099003|261009223027099003|261021123027099003|261021121427099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 5oWsYqY5LdSL/O4jNxvBpWp9d8hxrJURCnB1mhmXzhidC7RULJiV9NcGU3FLwWxKLinl5DAQ4JUjzEEIAy9f35O2CgQmm/XZLHNm+PkK7A/DWWNMTiJzicNJ+Iy8s6qO7lPjJLT4p4jVCuwVSIbFpCxnPcRVSxqpsbuqzcC7MwXhwUkS466wCcGZnxwcmc74+Ju5qrqHO0wu0BHWbpHeIg5wCnRuBfgCYx0fBUWCkKp0ygF6/jncadlqdGELyaEBXfkzSMeZhuR2QcWzw6ET4yLoNnL7VKoxih5ScYINnOIokZtXZIe6DC3adPekXHZd7N8DWrVakHGxI9EclOYsEBjdRhEsgVPn6QdjKDhBy/593IbYNXJPGQUmNe9t3f3n20RCyBm91bFMwiEjOvAHCoszqmybvZ7HvX2qIsLDcJPiFMx4dsSwMdSaN99mV8bsVr2z0LKhr6R9kGaoiz2zbqy7LQXtBdabTABVxqIubo5gS4k0gaWaU58sYEpvycxvKPHFpeIxtGBwUrXd9A15bqNxsleKfuuNnOrkeahqAIV/CRlNSpVE7ntZyPRE2mOVyCU0rKpmWPPWnTMd3GKzXAQ2/Z0hu1BPSRfQie/w090kdRQkdumv+bXPaObWc7C+LzQbuGwjswcfRjjV++pU2ZJJrRcvvOyScAJNz2NrPCM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(56012099006)(4143699003)(11063799006)(10067099003)(261009223027099003)(261021123027099003)(261021121427099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UwS9AwQFcARuVyHDwrwrWPbnZrDt4G1HyO2zZW7GvSMNkCCGiz5iKBuoSrf4?=
 =?us-ascii?Q?XpcpniFPa52Z55g5m9D3BR29YWYEk6yh3OAVNXfJPaXSi12JHoS6jZtxb5tT?=
 =?us-ascii?Q?6sK7AJruR5sa7v1rwuKhaPS0J8sqTkENMTRHJLuK7279nBjKbkVGp+cAa/LD?=
 =?us-ascii?Q?FHQaj5gcsNKH4gfCFCglRCAqh7PYjL+FkuXm9lZOvPJGDkGXo9CkCAvNtESC?=
 =?us-ascii?Q?9e1s8P8eAw3GjOknJRMqJUNkpT6yDuA2ld+nbo6Hzo2PtoEgScLRngEicq4V?=
 =?us-ascii?Q?6lgLMRnYy+HByfafR9DBDG5JCSapCktXnCF7U6vvoHJGoTDXh2w9N5Xke7Ab?=
 =?us-ascii?Q?YdJGmo5fiWidb0TUuLUNKQCVgsFP9cAng2rSzJeFV7REWCIelQD1ye01XnXk?=
 =?us-ascii?Q?oZ907qc96hMxT3KdhA0mw8MfkNqa6r6YDNna+Gk2iazhewAxL5V8f15AHSYE?=
 =?us-ascii?Q?FeluekdYsqvj7PrKAdMRHW2pc4qvEHT3x1piI1f1332EWkXB5gYrJaRk7/cK?=
 =?us-ascii?Q?mcmMYMEFBbKup+hDsJhE4jexj42fab6MxDozTNY5sQHnuYKvzHfUEPhXBoVG?=
 =?us-ascii?Q?27cA/0Al93CUKIGbgAnUUuW9/r3GuswfoJckxjOcALgxFLsEzvxcyMtarcMD?=
 =?us-ascii?Q?SAVpPNU7rsYp62er7rh2gO/ZLpehMWDW08p3e8q+rya/ZkmjMLxBQin5bO5p?=
 =?us-ascii?Q?2Sk+YbOVUa6l1spV0Flz8G5oWCHwTNRXNi/GOy2741ctL/UsxdtFRikYsYbp?=
 =?us-ascii?Q?Uf1A2b+fFuAUWwCF4XfKaK6uy/hidDRq9mprYMKUOCokp3G0u61e6PF29FDI?=
 =?us-ascii?Q?CUsW3f0vkQUalZdgskfgz0Tl1YRXGELQhnE/qd0bO5i19PH49i6IyFGcf5Jf?=
 =?us-ascii?Q?FXtBuMnQ1jDxelOc+ghTkqWtZ/q+nDMoU8jLoyw1V+kDPDBzjrIfbNeecLjz?=
 =?us-ascii?Q?Rv6xCW1NOBiVUXoYNC4BfUCnNUlDvpd4XfTR9+emH3eWjxmdDRuT1E338PGU?=
 =?us-ascii?Q?lH8XeiBxBw+KHLtXxdsILb3UxVes5KjdcmBm2syUow7jTJg2M0kR+YAFbw1+?=
 =?us-ascii?Q?XCvFIBehOpTRA0CfodeJqrKQE3Ii9VWZN74e+1fUcok6oyrJ4zdMUZIGFBaB?=
 =?us-ascii?Q?A/7nhiALYsDKpIjju52cESdwVFhPR4ynThAmLIrSWWcA0yxZwEe5r8Hy0bvg?=
 =?us-ascii?Q?Y1U7nbtxPZaWebhmAwFwMuTwHAdbKFAtQumRsMa48/oa6xfTHeEgT9JgLjPY?=
 =?us-ascii?Q?Y9uVyWk3SxBAaAvlI2wqwjItqY/SVEIj4Lga2oBrgx6BZupHr7shMBsk3VUp?=
 =?us-ascii?Q?9yxh2cfyCK6mANINkRyjwsmZ8zhV+eWZ4wGSKpV+nbjI4VkNWfv+yKe2ygLS?=
 =?us-ascii?Q?MAuUkfh2AAnaTQtmMl6a2CUvYTJfaaH37PsKfBTyMhxjOiiC/Nc8OPzGrDyW?=
 =?us-ascii?Q?Z/OdVtu6bGjZ96GvArWGAt+Lp5qN6+S5SuTpotCMbjs7sW3NLskFLd2gmbct?=
 =?us-ascii?Q?q+n3bI3S7tNAMyVnPBLE4cQm0eMWekE92wCB2CEybJLYif7UtDsDvfmU+qSm?=
 =?us-ascii?Q?Sm27UIiI6UpPR/RnbtBHAFbDOPk3ndmqxPK2hr4A1UL9Jzc9M1wRuwB7J3K0?=
 =?us-ascii?Q?o6LGN/32RoZAa16w3eEtkWGbYujSPVQxBFbi+SWB0PUF8wf6J02uXZsTcvCX?=
 =?us-ascii?Q?WBG/T3LUg7pDFoasQ8kFQzIe/5IlGt1DscLM5gLaCr7j5m4C27yf6ySXpnH6?=
 =?us-ascii?Q?VSOhJb1EaV3gaCFpDFAzOVirP84TB+g=3D?=
X-Exchange-RoutingPolicyChecked: 4bV4W72xiaImw7c6d0gjt8subenJ7SXlpZ9KnYOJ1COHoWB+VokQdCmgrpzMvVYmvEb/OZu/Bcy32jqBJwS4iZFCgrSt9FZHNkYDzlXmZkHAiUQjgresz5LOuog/croPw8BMNoQGaMfmkW2nrRA6G1Wp+V8bJ/Nbi60XrvEPhNBGQT8oi/jyPVAfq/YYYMMpWcLVRYborg2NkSg37gAIwHqobb2vauqZbIeeP9ACJl3HFzC356GRJ0kQV4gHUIEQP6nXY/42ktLHP6CVPWLuwcjeRqe6EMPsjuKVgBxlS2jKGAy4tnfDx4+Z/CNnBxpHLm3qum1bFcaOtYcpicqgtw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3be21115-f307-4600-45b9-08df3087e83d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 22:00:38.7142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYQpMq+YsygwpEQGHj41hmdTntkeAEY9R8fzN5hFRnxL8002wBUnlWuPq21qllJoCPfDcPoKuKKMbX0NePqmBsNX3BUCd9lBxlVCdr6E/vs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7466
X-OriginatorOrg: intel.com

On Thu, Oct 22, 2026 at 12:46:40PM -0400, Gregory Price (Meta) wrote:
> On 2026-10-21 19:20 -0700, Alison Schofield wrote:
> > On Fri, Oct 16, 2026 at 05:42:45PM -0400, Gregory Price (Meta) wrote:
> > > +	/*
> > > +	 * Unplug atomically where supported, even if already offline, so
> > > +	 * no agent can online blocks before a later unbind.
> > > +	 */
> > > +	state = daxctl_dev_get_kmem_state(dev);
> > > +	unplug = state != DAXCTL_KMEM_UNKNOWN && state != DAXCTL_KMEM_UNPLUGGED;
> > > +
> > 
> > Hi Greg,
> > 
> > I see you called this out in the cover letter, and that the kernel is
> > deliberately combining offlining and removing memory to avoid the race
> > before unbind.
> > 
> > But, this does change the behavior of the command "daxctl offline-memory".
> > Previously it left memory blocks present but offline and now it removes
> > them entirely.
> > 
> > Should offline-memory keep its existing behavior of leaving memory blocks
> > offline, and use atomic unplug only when reconfiguring the device?
> >
> 
> The kernel explicitly does not allow `echo offline > dax/state` because
> this just creates the race we're trying to resolve.
> 
> I suppose my pushback is: why does it matter that daxctl offline-memory
> changes in this way? If daxctl supports the atomic interface, it all just
> works. It's a bit more work (additional hot-unplug) but if the memory is
> already offline that's not that expensive.
> 
> The only scenario I could come up with is having two versions of daxctl
> fight with each other (old - no awareness of dax/state, new - uses
> dax/state) but is this a real concern?

My concern isn't about 2 version of daxctl fighting. It's about
preserving the documented behavior for "daxctl offline-memory". And just
generally, if there is no need to change it, rather not change it.

From the daxctl offline-memory man page:
If all blocks were already offline, print a message and return success
without actually doing anything.

It seems the benefit of atomic unplug is w "daxctl reconfigure-device"
path where memory needs to be removed before unbinding dax_kmem. Could
we limit atomic unplug to that path?

To be clear, I don't know if that (limiting) is doable and I also don't
know if any current user would care either way. I'm just defending the
documentated behavior (FWIW).

-- Alison


> 
> > > +	if (unplug) {
> > > +		rc = daxctl_dev_set_kmem_state(dev, DAXCTL_KMEM_UNPLUGGED);
> > > +		if (rc < 0 && num_on == 0) {
> > > +			/* already offline, unplug is best effort */
> > 
> > When num_on == 0, another agent could online a block between the earlier
> > check and the unplug and that memory would then be removed.
> > 
> > I see this noted in the commit message. Is that worth documenting for
> > users?
> > 
> 
> Yes that's intended, and yeah should probably update the docs.
> 
> ~Gregory
> 
> -- 
> ~Gregory
> 
