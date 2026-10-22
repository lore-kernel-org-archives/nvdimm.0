Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792636467;
	b=A2ZMTbDDmhl80SpSpDhGiQ9YXp4ux/Jgjx5dIORahU+jM2KfQSqBGRKAJ/3Z4l+n323g
	 MpXOsnpqs6k5kb3hJNYhfipGWbpGsnNa4SMEZ/nTMXdgBDeiwcpBYzaKIMUVbo2t50UOC
	 tONQFo8/6v/bU1SnEPwxCIkzNkTn2RYc+LGSZ4kJS5gGsTpYyKXWHe02U0zAYSwgWHZd1
	 kZ+schmYHzWQC06IurDFrlWnOmBhJaa/T+s1IHLnyWJIQV3RVmoFCcvJK6mNmU0lX2Uw8
	 QZgSBirgM+WbIZGWQGpqGgitX2cw8becg/SQs1Q8T0dLf40JPB5upSQq/v0U7SZPnjA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792636467;
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
	bh=XeU2kSdDCX7nDw7fczgOVu5JaZ+HCdIxK+grfL4/tBo=;
	b=3nBOs9fXZw4d7tDJxVfLrjU2pu0lF7FZxwTyZHAl+fJ+X06FwlDKaKFAY5FntNSIBQ7U
	 ivYLWrw6KEMTKFZ5/xXsOutEkNgP9jVWR7oMUnIaPXkVqWgJ49dLM7MQLBviGdVvDP326
	 mK5Uub4UcBZj+BTutU149elpVi/71MGMp2Xp1cbQ94jWhzNlx2cxReq2IdjVyVVgltugD
	 2u6aQev459bsCDNj92lvX0Zupt6J2nuFlZOK3zvkZbbU1KVF+hHaYOsMl58R8zZGh8Bq5
	 NjA39Ji6ybnwfZiW+GlP6seqsi6sFocNCs4C1pgfjCbHXUXFaD1WB0Iy5uUBHCLQ+YA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Gle8LUUb;
	arc=fail smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A128606A319
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 02:34:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A128606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Gle8LUUb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792636466; x=1824172466;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ShF1D7WjVzg3wzHQLxn53r7hTgdd0sBdyjQUcz2M0ow=;
  b=Gle8LUUb7GNi6mNKfQVvAWhcjUUFXNa+ifDBw2n0dLz/4RF/wuZ1U4Sd
   a09Aw/Wq7k+3mAgh5QisL4CEiLD9arJtKp/vEegvs3x8VluXhj8l6vJTn
   OQhVMOnpxi62JLsR4a5QEYzWqVwttBhXx9iHHRc925T1QRoOFe5Bgvmoq
   7j3FIgPRyYaKH7URwU6y/xmp6XSviKbpUICMhFxAhynJEIjXsk28Lzw+b
   zFNpDuvXvD/9bSI7J/DuekXDTcjottkY0qGDOoApWChvJ0v1p4E5yTNAw
   pgEqKtnSxkaBuIoeQXJ+9kk2NtKGyYq23LjjbEJ6frb/ontb3N/IkmqKv
   g==;
X-CSE-ConnectionGUID: J4Fb7EKOTJep5ymRvGVCLQ==
X-CSE-MsgGUID: 33pB3HyzT/eQGvuiIdEixA==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1261821"
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="1261821"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 19:34:26 -0700
X-CSE-ConnectionGUID: Xvk6uG3+Qsi4K8R6T6Defw==
X-CSE-MsgGUID: KhmNsN5RRGC7R5DYNG6XxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="5053282"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 19:34:26 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 19:34:25 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 21 Oct 2026 19:34:25 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.64)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 19:34:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IpNk64ZVstSuD25osDzFnh4PR5YKzkkLUTdpBZ2L7t57loZLAdj5AJM9VyrAyei99XYMqu5fsQxgxtCyGOeZiMYqyyAyjplYNt8R8s352/SI93AnVhGZTrFF48bV1hieRKRKMIjXgMjbhUQ8tYrD2mSsdwG2qXGosc4g3kHSRbWOOZpvZ4XjQp360MHj1Ps2zzfGUu2ScsehXvbVE0g8eiUy1LE+GPeK/bFaqAprmIgadeeCCxxRIWMlvcJv9D5CL019BKpFXrgF3MjjNc/3RnFr0XWBwbZhYPN1DlVQquil613JrkSla0FH1IhgGO/ElstAih5uUaWym402uE/Yxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XeU2kSdDCX7nDw7fczgOVu5JaZ+HCdIxK+grfL4/tBo=;
 b=yJQwJqAIeOJURTmV6k3soJ78bU/guCxKFesTmjGMkTzC3KRLiDdiPRtYehnGAMG1m4YEORc7KPwzEFI7Q8HhFqRYyxLF3iygoCn8xPaLd+xMLixoWjn5crSisghgbs8hFh+fuQRsqsbWQQ92nNgf8QHV2IKfABh3VhqXTBne+kteoy/CdIdQaMqy3BSUlfuOC+RhJeOgJtcdre09fT6QQzO+IN2VyMNquRDS3Y0F40YQ+JjpTQFSZ6McJD/PU1kemLof670hXm63ngfYdxFnkppzVdrkiONCNeXYS11AwD4kAm0m6pDFj6/7hrCLX7F+W72bYdRciDAdeteDKCvQXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CY5PR11MB6235.namprd11.prod.outlook.com (2603:10b6:930:24::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 22 Oct
 2026 02:34:10 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 02:34:10 +0000
Date: Wed, 21 Oct 2026 19:34:07 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 6/6] test/daxctl-devices.sh: cycle offline/online to
 cover unplug and replug
Message-ID: <atl2HyXaNB6-6j8f@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
 <20261016214248.443247-7-gourry@gourry.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261016214248.443247-7-gourry@gourry.net>
X-ClientProxiedBy: MW4PR03CA0226.namprd03.prod.outlook.com
 (2603:10b6:303:b9::21) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CY5PR11MB6235:EE_
X-MS-Office365-Filtering-Correlation-Id: 33f86af3-10b3-452e-c7fa-08df2fe4f41d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|18002099003|22082099003|261021123027099003|10067099003|5023799004|261009223027099003|4143699003|11063799006|261021121427099003|56012099006;
X-Microsoft-Antispam-Message-Info: d+TXYZWPlQDS1SNFA/YBfuOF4jZ8pHE4OVViK3M0wsZ2B8R1MoNkna4ndsP+XmWmqfm0XxAgI1w+vWP5OuXG/OoGsS8kUlzBdXWq8mbK+KOGUbgW0EgMib3ntIuujs73tk7wC8JabdnE4W2gtsnkKE72uV1GU74KCFRWxFPzxFhfOFmbjkXKwZoPFu+5LNwiQ1WpyUfEWKEy22j78wmHv+0ST4CEPxIV5Z9QYx4283AVA11wW8HIahjapgoQcdAiX0hgcQVE0ESez92NvcKxxf0A3Dlk2/KJaILc0T2uPiX/OfHu3FnhEFD4CWjNtDHALhO0L1vrIT868+VRonpKronzjXWuuGCoIja25aI/kK3msFmpp6J+1x92E+LJCrJdN2p6Fbq85fZGXfO4alm228COoaoPWELA8Sok18zvBlIVDAPUdbVpuyouE/9rFAmlHUa7atmw4shUWAz7rHA2jgSt+TEV+6nqfbeQQDou3d+MKtBC6ZKZFs+y4Xt8l8hdxH41I/CRUfDZ5CPJ/niXEKTY1tUGmh2GvxTFlvmL8NqL4WppP/HEn6GMOMqOGZCCPEMfMkBAEa+/kXHZh6a4qQSz5ud2s3sCQPLuprpy13j0HpSUDN9aMkElLLvs1qrBtsvoqUSa2lbg8XUreb4QkMxhkQJgtbXhhHTziJT3NwE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(18002099003)(22082099003)(261021123027099003)(10067099003)(5023799004)(261009223027099003)(4143699003)(11063799006)(261021121427099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FJ8MNEWOS/tNqg/PhegDM1RvcAzm3zuIV1Bd5ALfL+ZOIvwZW2/0MZzWCzou?=
 =?us-ascii?Q?hBFeuGxvtoNACpzTqdWXJxkm6YIgETmGtItN4oDi7FOxpjNnoi+6G5OB5Y+J?=
 =?us-ascii?Q?xuINFdyiwKqK180MxjKrlK7T2uxH+SvOd9Qy0+L0mmTuApDy7pXBuQ6qY03y?=
 =?us-ascii?Q?2VI42XOC5Om2gvoKYWLmqMtfrLSXFGzKNCJ9cIakdlcW9GIToSU6kVAe6bA+?=
 =?us-ascii?Q?LIIFkwEiT53MMAKHjgWS6drjFxmp31cJaX07GQJohrY2KgXBOH1Yii136nda?=
 =?us-ascii?Q?f48F9ACmOjcxCrdCv+/pN63qaxqWMVhKKw54IqFH1mBJahs3Qk+WVCHQuN1p?=
 =?us-ascii?Q?5j6Uidr+PggjKoHu66XMp6K7hMte5i2Cqg/lfH/QXhhaKEWB2dnXMUcWGDG7?=
 =?us-ascii?Q?6OmOkEypdjebBl0s8ySEp1VCYGOPPI6IFshdPfgdG54c6XyXpehzvYHu3ztW?=
 =?us-ascii?Q?ZSPtd9Acg+sm1K6zxBZqclYFyFW/XME9THc9NPjtKb+g2+oDokpIXsbNlDRt?=
 =?us-ascii?Q?lOyE5I5Apew0rf7LxwYeLtxkSDd8tJTDPQqwks7thYVKvjb/ndI4g+1rbqup?=
 =?us-ascii?Q?ifec7VGWnS4IwWHm6gQSCzYEHElef+RyUXRUUD3sczLBmJbCYJmS0im3NbKJ?=
 =?us-ascii?Q?PHTO9ilNSmZUjxtq0/pPC5uizYauqDxKkKiDnsc/NOBN0gK/Q0kBTyXUolKz?=
 =?us-ascii?Q?FPaVgk2N0z8MY8FrrAFTtj2o+6k7mhS5y693WNFPJwtmZofco4p9KZowreYZ?=
 =?us-ascii?Q?65ukg+0UErtzncuojKPNjd1v88hn9fu5HGOfLn1LEJuSAHOKFEiOZnU8xQdU?=
 =?us-ascii?Q?YW8FU9NABGxzPwdg/D90Ar+dWCT6qvdmY4r6WZ5Kgrk/1bAoHHw6OeEhY5/P?=
 =?us-ascii?Q?9k5URXxqIW7SxdjvCawTnPCJ9VYqehsBvEW2Qyez9FfOnOOm2nxmnTP2KrcR?=
 =?us-ascii?Q?43/ZVb6xKiytyNYLlep/sHaYOCdIhs2nJ/wwmO+F8/wxMHCH6eoViNdQCC8m?=
 =?us-ascii?Q?PjBjJ4Kv63o92nDad38yfO9jAKrrxIovvQdGVdiefTaTvOdOkNaLg8f7SMaW?=
 =?us-ascii?Q?5DQSR3WOaGQ1UUNi8X+KntHnf2XSEopSLvjAQXrdJZ3J17g09zMLWVJbNSdN?=
 =?us-ascii?Q?5/g5gV3n5/PovUNPwwhPF2Ckojd5MT8gZt+SqiWXJnmHKg2QHAMu7H2Prau+?=
 =?us-ascii?Q?OH7Ipf6rqC8ttdDI8BB0iYjR9z98sPVOenFHWgrzD8lpluYvohIzBR7B/72G?=
 =?us-ascii?Q?c/1dJDBuVVdHjeTEn8tUDuNBvMOxamCPOE5lvRv0JbaNeeVAPK2WdCAvwIhA?=
 =?us-ascii?Q?r9fOhLcjYicx3J+oEgomndt74ImHQCbTA/GA31zVVUzXSX757Ph97lTu568J?=
 =?us-ascii?Q?Rd16nzEvjrvmznwnTso+pN74ZNGbHqcx2umWhygpRmgAusXy3aq050/8b0zV?=
 =?us-ascii?Q?AofZT3C9m+Pq+akvkUMWVNBcuUtFld66eLQm3klXHk7pwbHQvv7E3i4L0cTv?=
 =?us-ascii?Q?83MVYujccSLfevCCcSnHtNIytiRMUe6syKFNMq1vE/uwSt7ZpLqUGqeo/eUR?=
 =?us-ascii?Q?QN6TfPW/xs5G9ER4TC9xy5yCM7+gWCZMuP6gx/EiMgW+kN0mZ8COER7IxQxt?=
 =?us-ascii?Q?Nx3//Rp5snBbcrju5fOhbob83BeOXxJZaUVCcbtKHSyALJXanUzwyjg478t/?=
 =?us-ascii?Q?XWDfCiau1MF8A393PlY2uKgTQLwelSobMvAurgJ3rR10fqnVTjXgkZNvy46h?=
 =?us-ascii?Q?/yi9Yh5tW61v+mJPSyUcdzULJ/lGRYY=3D?=
X-Exchange-RoutingPolicyChecked: ErF7ppth0ZlAtX0ImFbKLoeADhCqbikcEILN8G/O0pkQwV4TPFgeKfhzKoHX20bDPhKmSQCfHQxpEUAYHqyfNyfzHsqkrSUKqI8xqKbucCQ38gS8QZP7jUHzg45OKTwkPRJlo96WbQPa0iJK3P2ymoxCV1jd2PkJng0SnLLKy0CmNlvZGW0Y/x8/Sau45/Soa9wJJeSuvVI/eOVayU41IgJRva19xZHoRTf5nRYbrqsc38jxwyN+UIVtd0nzBCokObwhJOum6WTXYUakdO3JvD6CditC0kQLH41AXFKa7Kf1AJya2nCD++RcHyAIt3elwoGKp1AFS7c9Tgp75UmX2w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f86af3-10b3-452e-c7fa-08df2fe4f41d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 02:34:10.6240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VlW9lPunXFxrxgq5Q3UP9HGXtWUe2IVf5QXhvsb/mjaa6mw5TuAUXCq7pRPc9FgbBC/DpqSJQ8sindwyCcw20ReW5zv0zOE/CQxdKNMkkIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6235
X-OriginatorOrg: intel.com

On Fri, Oct 16, 2026 at 05:42:48PM -0400, Gregory Price (Meta) wrote:
> From: Gregory Price <gourry@gourry.net>
> 
> Repeat the online/offline pair to cover onlining from 'unplugged', and
> check that offline-memory unplugs an already offline device. After each
> step, check block counts and, where present, daxX.Y/state and the
> 'hotplug_state' reported by 'daxctl list'.

Hi Greg,

Please change how the tests handle the absence of the new sysfs attribute.
If a test expects the new interface, a missing attribute should cause
the test to fail, with a clear error message. We have had problems in
the past with tests silently not executing letting defects go undetected.

Note that we don't require backward compatibility for the unit tests.
The utilities must continue working with older kernels, but tests for new
functionality should fail loudly when that functionality is missing.
(I'm aware that not all tests follow that guideline, and they need fixing.)

Please also leave the existing test cases as they were and run the new
state-dependent cases last.

A few stale state cases would exercise daxctl behavior that the kernel
selftest can't cover - 

  - Offline one memory block out-of-band, verify that daxctl list
    reports hotplug_state "inconsistent", then verify that
    offline-memory still leaves the device unplugged with its blocks
    removed.

  - Offline all blocks out-of-band, then verify that
    "reconfigure-device -m devdax" succeeds and the blocks are removed.

  - With all blocks offline but the device state still reporting
    online, verify that online-memory falls back to the per-block path
    and brings everything online.

For "blocks removed", please check that the device's memory blocks
are gone from /sys/devices/system/memory.  ie verify in sysfs directly
independent of the libdaxctl code being tested.

About multi-range devices-

I found that libdaxctl undercounts memory blocks on multi-range devices.
I'm posting a separate fix and test for that. Nothing in this series needs
to change. I'll cc you for review.

Our ndctl emulation can't exercise multi-range hotplug, but the kernel
selftest can run against a real multi-range device. Could you add coverage
there, including the partial-add case where the kernel reports success
even though not all ranges were added?

-- Alison


> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  test/daxctl-devices.sh | 53 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/test/daxctl-devices.sh b/test/daxctl-devices.sh
> index 659428d..cdb13f6 100755
> --- a/test/daxctl-devices.sh
> +++ b/test/daxctl-devices.sh
> @@ -67,6 +67,40 @@ daxctl_get_mode()
>  	"$DAXCTL" list -d "$1" | jq -er '.[].mode'
>  }
>  
> +daxctl_get_online_blocks()
> +{
> +	"$DAXCTL" list -d "$1" | jq -er '.[].online_memblocks'
> +}
> +
> +daxctl_get_total_blocks()
> +{
> +	"$DAXCTL" list -d "$1" | jq -er '.[].total_memblocks'
> +}
> +
> +check_memory_online()
> +{
> +	local total
> +
> +	total=$(daxctl_get_total_blocks "$1")
> +	(( total > 0 ))
> +	[[ $(daxctl_get_online_blocks "$1") == "$total" ]]
> +}
> +
> +check_memory_offline()
> +{
> +	[[ $(daxctl_get_online_blocks "$1") == "0" ]]
> +}
> +
> +# skipped on kernels without daxX.Y/state
> +check_kmem_state()
> +{
> +	local path="/sys/bus/dax/devices/$1/state"
> +
> +	[[ -f "$path" ]] || return 0
> +	[[ $(cat "$path") == "$2" ]]
> +	[[ $("$DAXCTL" list -d "$1" | jq -er '.[].hotplug_state') == "$2" ]]
> +}
> +
>  set_online_policy()
>  {
>  	echo "online" > /sys/devices/system/memory/auto_online_blocks
> @@ -100,7 +134,26 @@ daxctl_test()
>  	"$DAXCTL" reconfigure-device -N -m system-ram "$daxdev"
>  	[[ $(daxctl_get_mode "$daxdev") == "system-ram" ]]
>  	"$DAXCTL" online-memory "$daxdev"
> +	check_memory_online "$daxdev"
> +	check_kmem_state "$daxdev" "online_movable"
>  	"$DAXCTL" offline-memory "$daxdev"
> +	check_memory_offline "$daxdev"
> +	check_kmem_state "$daxdev" "unplugged"
> +	# again, now from 'unplugged' where supported
> +	"$DAXCTL" online-memory "$daxdev"
> +	check_memory_online "$daxdev"
> +	check_kmem_state "$daxdev" "online_movable"
> +	"$DAXCTL" offline-memory "$daxdev"
> +	check_memory_offline "$daxdev"
> +	check_kmem_state "$daxdev" "unplugged"
> +	# an already offline device is unplugged too, where supported
> +	if [[ -f /sys/bus/dax/devices/$daxdev/state ]]; then
> +		"$DAXCTL" reconfigure-device -m devdax "$daxdev"
> +		"$DAXCTL" reconfigure-device -N -m system-ram "$daxdev"
> +		check_kmem_state "$daxdev" "offline"
> +		"$DAXCTL" offline-memory "$daxdev"
> +		check_kmem_state "$daxdev" "unplugged"
> +	fi
>  	"$DAXCTL" reconfigure-device -m devdax "$daxdev"
>  	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
>  	"$DAXCTL" reconfigure-device -m system-ram "$daxdev"
> -- 
> 2.53.0-Meta
> 
