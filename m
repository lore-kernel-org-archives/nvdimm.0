Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792810528;
	b=HqE6nZTDJ0tsWXPaC0O7Mq2AtXjXPHPlfccKBUvBw2Y5NyRtsNFa0lSS/PZzWT/DIFEt
	 CLxxcjTdaO488uIu3GHPN5d31FIeKPmgc9GwMWHrWdpQ4Y0+f+u+FzOC8wLojKcHTbNTa
	 uhVX0/ijq3Rrye/H9uQJ7YnYXFuS0B+lEVdpIU4k3nt2Lg486OUeKHXoPMjHSN0GKyA6P
	 6hpJP+Ld7OtcdINr0GHcU6ZI96HCL3aX+4fiujGVkULei8mIQfTRtCPvmi+bU5KdXhx0F
	 LHykpFGLiFRaOWfB9JLU4obL6XniiAyTz+kCrdELifYs9s7IIuqyQmtZp3FPI6RHcIw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792810528;
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
	bh=sECzdClEfGIeT+qMMfwXmhS5ptbmqxJgUnzEgDga224=;
	b=B3gmXpPEGHHsz0k6yjUWoRPuvmHgGwoIuNppw8nXy/CeY9eP4rE99hAixJLsT8vo2Pws
	 EV9SR2LFtEEKq00QleU5L8X8gFU9HoM8y6VR9gI2GZcW4T+1CFnQdDy2ijWVppQjhFmJa
	 sylfAo1zxIrWFjdF07eudVPFPJaeAvtJv4arhIZ4xDPt9EwHd9kNK01xB7BapWVUrO2P+
	 NwS7oZ4pzUYg7ii9/mKMeqQZ0UyYD4x/qAAwXm/blY9ctgdB4h+ZxIWSVb05mSTTnVyDb
	 5Ocxthl+cCipZR4y2oVrqvjsW0nYC2MNTjJVFYJ/BiJCCsp7JvYK1xP8Ri6NB2GlCWQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="Mx/RMP2q";
	arc=fail smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF06606A31B
	for <nvdimm@lists.linux.dev>; Sat, 24 Oct 2026 02:55:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FF06606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Mx/RMP2q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792810527; x=1824346527;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NRkHLPZWUmrOz4R8/+CyxAVN/dapcPfpJkAvebbIOvk=;
  b=Mx/RMP2q+qgkUkYM0JWx2u4lRx+4CPBSsYjsVFL7CNK2fP8ifBh+IqXO
   kmE53+yMvIAz9aZJFmNwm7VO0wbUpYcdihBbn7zoXbzRRpMS6rV7PaP3d
   Byl5LujJDAkweFskBJxcEK4bxMDvm44KwEH89dUv02BzJ8UgsPjyKnjGm
   /84M3ucppPKXrzpHOadRJO/FIl6CaAjY+8zBJB7oBAaqHDHizdzrfk+o7
   leTj0mdHu1xUdRI4XL2rcgW/wxK8XfI+0XAB55l+DjzA1o5xlWL/X8ILC
   gDQ0lv7p3ad6I9dTBdjoVOmiUa0JfFIwdHPqisEzPEtrDiRRB5iQ0o7vf
   g==;
X-CSE-ConnectionGUID: N/JWck3tSimZnnxWRMrKBg==
X-CSE-MsgGUID: Z5Q5IcSXTFq/cu/eaN0T/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1577054"
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="1577054"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 19:55:26 -0700
X-CSE-ConnectionGUID: aRllaKcSRzaW6H2c5xoYMg==
X-CSE-MsgGUID: 6m6z00GmS5SiuHlxAsvACA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="3728873"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 19:55:26 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 19:55:25 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 23 Oct 2026 19:55:25 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.18) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 19:55:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XE/zscLktrW0mFu27OazWm7gWtxCMjf/T9/xytbM78rMX+yuQc7pY9oFMD4fRwIU+1kFaVNp0v5Es9Eq4K26rbbNqNQ9AK1r7ogLmMARHB8VxiDQszH9G70NGYE0i+r+eyjDVQhiTyoWbmSOxPEqYv3x5a6Nk377H0oA3lzJ6R9buPx6yJ+aJvhRgRHPwlnGTJLUhOCXHtnr58BoQSEJ10CXdfi6rRzYfskvk6VPd+3GWjJ+QOpji7ih6JzezqQPpYp11rbMEspC5aO6jMVmfwynX+/6QidGalID3zaSJPPCFHWzINtK8q/NN4VbQPZBVhWbFdqeaXFHhBdFSQ+KGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sECzdClEfGIeT+qMMfwXmhS5ptbmqxJgUnzEgDga224=;
 b=emyp1vf2uYCoT2oqG7yghxjWX0KmAzEvA9W+CuQ/RPzpcarQYfSHBE0GW7LNaVx7P6bEwCnLPF1Hd8BPZXbTyTflFUch+tKNB2a3GlWT0gzoyRLemIEgh5w1GRwarfuM9pe7fd8IhkvUNXPEM6o8voKhojJtKBN0+b+Box5uQotr6UivnkN7/QCasWkVnH0NeG4lEY22Xzwpk/z44pFiZcneGKKPafxXAYmYUj8odSC6AVOZp/H6ITt3W0YOVwVeBhS6wPuyViGeBXV4htEwjdlJrKwzYu5gVmOnJruncw1vT1Q7fUnTfBVly4svsaNIEJihNFWVgH8s4rWehGMxOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS4PPF2F49754B6.namprd11.prod.outlook.com (2603:10b6:f:fc02::1a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Sat, 24 Oct
 2026 02:55:23 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.017; Sat, 24 Oct 2026
 02:55:22 +0000
Date: Fri, 23 Oct 2026 19:55:19 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, Richard Cheng <icheng@nvidia.com>
CC: <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 2/2] cxl/list: list locked zero-sized decoders
Message-ID: <atweF7k2bPbgjQPf@aschofie-mobl2.lan>
References: <e144468706798fc68df3be13d1e3321486aca901.1785462417.git.alison.schofield@intel.com>
 <018112d2f7890f3a3f38cc96aee5cf98cf5f3a9d.1785462417.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <018112d2f7890f3a3f38cc96aee5cf98cf5f3a9d.1785462417.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0083.namprd04.prod.outlook.com
 (2603:10b6:303:6b::28) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS4PPF2F49754B6:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e8976ce-b3fd-4d96-7aa5-08df317a3f20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|261022105027099003|4143699003|56012099006|5023799004|11063799006|261021123027099003|261009223027099003|261021121427099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: Kj5G5wkWFC8S9yOS/04f2WmA9VsQetOAi2Cl8eKWGTqXK7OndZ4b+KQQo7dofrukRaxqNJ2BNO3GW8yUMEZi0OyCBbCpI61KTMH0bb/RtDbOMjDH2wyiqxK0y6DLBZMIcBEfrs2cb0U0UagkhH0w4IuwyVdhnxHuAb/5c0143ld1eQHUhiJ2j7h1sqN4X/fRpSyN19KTSiAjeeKkbQkyp8/N1jXyp9lUCMI7NRHhvyOct/5q/62A4Hvm8rOpYSF/JrzukS5bTCBeckZwCWzzc8GOSU4yUEmWktBkrDqa0GMndnkhAHVGZ8fe17xhtAo+bzmRal1UqX1CKqC+hUdjJlI0ZlOuFHWQByWb/y9TKtaTeuDsVVZ3FuQJlQZsGZgW+BZlksJpQ5O7QjrmwQMYOqHkNf4OFKGTwbidlDJr3miAxDkysefrvek8yPFpGm1JDfm0KH44jKwCyCZ35rtl0Tfp1QBnpUOmpiMq6hucv+MGhEX/0JU8z9GPDWwwT+vkqKyqfQ6Ze/LAL9xggubb0IIMZYGRzhnykuvg3+yXb28q1BHFRg/QglHRXTOYHxkU99iHMycL+telkXTL1PJ8CWhycRMN/ORBZlGc4fKxrbMXQUbdVSP1Z7qwW0BNwygiDsi868xpdxvgKZPg7jU6myXdo9IIi6XZkTrqC03rF1Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(261022105027099003)(4143699003)(56012099006)(5023799004)(11063799006)(261021123027099003)(261009223027099003)(261021121427099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/UlWbX0puB43kyfgX4jz7eCTqMR0EKIZO1RB/EDNIVqRRd4MxvoC5at9Y1Mi?=
 =?us-ascii?Q?nq3mprETz5ZS60dFjsUOUWy1OmOG8E8Wi8mlGCqq8wek0uTxBa9lNBzHgCsg?=
 =?us-ascii?Q?aihIaSTufnv/5V0kw1MCDoSyfwn7Lg3sS8tH3K2y1pv95zyBsWPSABLwjOt5?=
 =?us-ascii?Q?9BOFiz2DhWyKIMR5zjRMv6VodwoYnPGc56b6BVHlIIPWtswEp09sp9IhdFuY?=
 =?us-ascii?Q?OvqJzPf/ILjLiZdafVBlD0ofx8+L5MX4+BSjgq3pBOEFXRE/sRterQ7zE9h9?=
 =?us-ascii?Q?b8xMkAVvkAoadK2ioDBKKPhEfCsFTgYzNFaVZItTGOF0KcVSbhiwd0ksTUI7?=
 =?us-ascii?Q?Sa/VWf8l49xA27LG8SA7Jx7kqYqcm0EqvT+p5PoBIbBY2PPGrwYbhdXmWLE2?=
 =?us-ascii?Q?aGADLRzofSnQ7cZgkPBYUsS7jOvXVWONSUu22JzkRSUAsji/QmFdeHpNL0Le?=
 =?us-ascii?Q?z7mQzgPlrNgqYAnMnUIML9iHF+HNgnNyRZgk87/sl5ww2g7t9MqpMtlynHwd?=
 =?us-ascii?Q?Q85tcZmgvnQDTNiPVNRsW2VH7kexIbtikpvfed0MbVQpcgNB1TJOIMXmwpMM?=
 =?us-ascii?Q?iX5zDaLNBhSgwm3IRLhOCtB6GdZAjQ6IQ6TAHHVB6eohK736tvQiIt+b27nn?=
 =?us-ascii?Q?GFDA1nWQziNAEucAMSdot3J94qfTyfYAQ/2dWOPiHQoVtyukGVCsFTHmu1K4?=
 =?us-ascii?Q?O2/qIIkJAzkIiuEWxKl32tVz5jJt4b+vHjjJFxvK5KEKDdAeijn9noO7ania?=
 =?us-ascii?Q?svf7DWayptWcYjbXDYscSAOU2voF0M6xpd9sRnyP6XH6gRlmc5pXvfDtzyia?=
 =?us-ascii?Q?8CiCnBec+nVyc4hCWPMaS6f/SEYIITiQ2uHS0CbNuJnQWE7n0v9AgLWp2q0B?=
 =?us-ascii?Q?uIg34HqsjYabN34zblWzmb2ef0SBxFaV3WAEFDQ7IvYHnhxdeYIGH0AZDbwN?=
 =?us-ascii?Q?5EMmQAQXmjjw0QTX8/ZoBTc5Y+gJpoX38Ez8dhG8W678ryf5mH5FlnhZgF8j?=
 =?us-ascii?Q?A7/lQMkeICCLx0EIFp9PXLobgzRTu9OTxn3Z56LwvRwrm00MZ5b5OaosgyFd?=
 =?us-ascii?Q?0JOMBfEDpDgY5GwxH6ajuJbPajBb+queoFy3kTYJeNIhDCzYxj7KXQPNOK+t?=
 =?us-ascii?Q?DWsiYaOHrWeaQZ3zwhW1xad+/c+3kBnqjTO/8t5iUB955CE7pMzy6K0GtVyX?=
 =?us-ascii?Q?wQqVA5MGckDmFiFaY/bIDjhB5KKFnEKzdnVH6mRpTjm19N9ViVx6mnQiFOd7?=
 =?us-ascii?Q?wi/pwN12JktkpyLsqZCkMujqqY6P2O6RoWq4SROZhVdPO047cENWpu8nxx0p?=
 =?us-ascii?Q?JzGccV+ZB3hBtg9JrrO5/2Y2DxTpDXALsSwtmPfjE0nQRm5/FEcvZWoV7U7N?=
 =?us-ascii?Q?mQDehJtIHI23E2v3eZctwWSQw92jWEk76e+23dFuwlQPH02Rezf7sI26eWpF?=
 =?us-ascii?Q?xY36tAKBbuwfe42LIfJnlhmmg1cIgUXtEyRgjRS2OW6qU6Hwd9H26yMevDYw?=
 =?us-ascii?Q?QZFl+sWiXcM4sz47gbMKzEi70R1P5QG+5eGrsYXBD59h++7jsKsNNiAinByE?=
 =?us-ascii?Q?+33/AgfSFWV+ZytejKPts01Cy5ZXRlXIpXUKnpQ18YTAG6t1w82vQIorN7Pe?=
 =?us-ascii?Q?5c0jIXaMH8p41pX++CgW64ynpJ7j2fRXNN45S6Me4Ar1WyG1OVpyZLUAwhOO?=
 =?us-ascii?Q?PuQjqrDSCR9ClLZFWV6uB5Qy7gLRN4dnvlf8zb2tJFIRJDAbDlHqLeoY1r1e?=
 =?us-ascii?Q?FPIMmkbEDmakODSS0/JVTS9VMaaUmX0=3D?=
X-Exchange-RoutingPolicyChecked: 18ANYpsOgCu/FPrroeU0XD0cdMDitMqR/p5lbAMT/LhQjR5E1n23m3gDoBetj/JPhSJfqwFnqkZpcwYXad9ivGmzpfDDzPNzjrNPF+EuYcSTXzAbR00HN9YeKoCJpR5Q8yIMbw6Hns7W2tDsDvVRp1ZseYVCWql0vXVhohJCV0UFbGPJ4Z98jW8pBb5RGiv/3eNo43MoAbyvXArKmEOlN+303EoOLmPQpq1YiEvL63bQzVgaMzjYyrvaWx7zPoDrn6vnhL5SDK70vtzOuwCRANExcb1YXI5JU9Od0Hoexk/V5GPkzJCPkDGG88CsetFysCoPcrCH450IAADQiUbq4g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8976ce-b3fd-4d96-7aa5-08df317a3f20
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2026 02:55:22.6239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oHIP8yXGrNPLciGRIrv0ERbnjFnSMhFcqZGYR22lyQQhatWd8kq+I0UlXgtoqomKHCwx5Na+hezpz7mCQy+b8cYeK8P03eJPsGAbEq/5Nr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF2F49754B6
X-OriginatorOrg: intel.com

On Thu, Jul 30, 2026 at 06:55:20PM -0700, Alison Schofield wrote:
> 'cxl list' hides zero-sized decoders unless --idle is given, assuming
> they are unconfigured idle slots. That assumption does not hold for
> locked HDM decoders, which may legitimately report size 0 while being
> committed by firmware.
> 
> Do not suppress locked zero-sized decoders from the default listing.
> Combined with the "locked" field in the decoder JSON, they are visible
> and distinguishable from idle, unlocked slots that remain hidden
> without --idle.

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commit/e252f4cc0792

> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  cxl/filter.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/filter.c b/cxl/filter.c
> index 5d634d3b2512..e6d45ac7b9e6 100644
> --- a/cxl/filter.c
> +++ b/cxl/filter.c
> @@ -847,7 +847,8 @@ static void walk_decoders(struct cxl_port *port, struct cxl_filter_params *p,
>  		if (!util_cxl_decoder_filter_by_region(decoder,
>  						       p->region_filter))
>  			goto walk_children;
> -		if (!p->idle && cxl_decoder_get_size(decoder) == 0)
> +		if (!p->idle && cxl_decoder_get_size(decoder) == 0 &&
> +		    !cxl_decoder_is_locked(decoder))
>  			continue;
>  		jdecoder = util_cxl_decoder_to_json(decoder, flags);
>  		if (!decoder) {
> -- 
> 2.37.3
> 
