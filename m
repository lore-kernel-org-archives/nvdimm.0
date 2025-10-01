Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92DD2868BD
	for <nvdimm@lists.linux.dev>; Wed,  1 Oct 2025 22:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759357728; cv=fail; b=kSGGhTE1dpviR/KwEgXzb/S28VmF0PwcmuBNRjYgbm2faeUwehDgllzmdVIYWjo5b+cWlPrgf3On9rSZKTgAhphT+BklhQLQpQdw4pR+TlpQ88m/jZQeuy1ulnxQhI076de4puKYEcIOcCkZC7OS8u3pxeleL71BLPTSlbD6mx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759357728; c=relaxed/simple;
	bh=3ur7Ka4gjOnYSkDLUUiGa0QypM2IgmmH+t/EMotsmkc=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=tRrADHQ7cTc2p66s/ZL4xw0+g3cDFBfJR8udrvIco4Y827dUvNbl9cFosvUMnVUDqb4RGqoyAncPXQg00wFPq4KyPrtcwG5DqEq7CNmSezz+vODcmjUxp4gj1Ai2qI+fGfCmbEaWe6kZFG0rH/LXnwtJj0QuUC/FvkpeznZYHzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VjvjT3LM; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VjvjT3LM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759357727; x=1790893727;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=3ur7Ka4gjOnYSkDLUUiGa0QypM2IgmmH+t/EMotsmkc=;
  b=VjvjT3LM8XDqdnzuPGsVB8OiRjrKyZ4ycWenxSeSSElglpajfPXj/QEP
   BUnnmyjr3NrNlv7uN6ccbPWcGcLIa2Pb1gKHw66CmeRarVhLcmRUAYYKz
   /4io/DQLRiAazQydR2PekMNkPB5QecVGMkqMuUQz18Ir9lwNgXW4mEOfz
   DOqqYFgEMyLzvGW9UtpSxUhaeG+u1Vv1EWyQMBVelFWT9CYKoQKkf+SlA
   x94g14nU+z6MBRJK5pamONkc6qay2YzbjkEGZsF8bTuWUb7HCTcCbWptC
   EOTM8+xP+1PkjO4JVxVY7PM0ky4rctuAptCwiLciknkU8K98wmT6IkO1C
   g==;
X-CSE-ConnectionGUID: W5g/FwxtSQGb962NO+lqFQ==
X-CSE-MsgGUID: 1HOSk2I1S+ScK2oU/zV4Wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="61353268"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="61353268"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 15:28:47 -0700
X-CSE-ConnectionGUID: s/ro2aMHThyOOKhzoazpfQ==
X-CSE-MsgGUID: 6SNXGzISStaAsAuViR4r4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="178013656"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 15:28:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 15:28:45 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 1 Oct 2025 15:28:45 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.37) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 15:28:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NebSftrVcvGqIRIjV9y1tD8CGwvKbIos9YO9RKOgBKp1zDgvZ/wHlvPTnYzbjx6ULQhflWqxlesHwUAFwxRCNwg5bOKlx+8o/rtemjbQ26aknGl+81yfXglTA3TJ+/mvKgsUZ7Fe+J6wL9YOORnrbvfXVRE1n5D+xSqRsuHCZkORqFX5kkPVwGDynrLI5AXnBXYi0Aqohy+HVDoGS+b6o4gOjUJyWUVtaF4cwO63KLYEmB9KVzGrSkG1sK/maY23vmF02ixpEYoaueifYu0gf4QDSjycQIZVcDBGX5QylJ4+gT3WTp7CCmLtPxbwvCM4jmfEUVrJrC2aQT8teVYj2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ur7Ka4gjOnYSkDLUUiGa0QypM2IgmmH+t/EMotsmkc=;
 b=Gen8N1KXp/4iS+UwfKNEl60sgKFur//9pmCT9RiKVvOeoA5bBOSJFissjv0sAWWzpDE30FJnGopy7p+FNkKBU/dnF8p2Ia7T8jGJzN/VgisgjJkXrDTBMp/f6hph9PvFDVKwtBzr8z4qqIW9tq1Vx1qrMGe/5SoAdRqxLu0Kw/+4AwD1Xxu6Dujd91tkynqqbJiRL8678mIUM6ge22OWBFAno75Gvynk+JMlJ51XMKyxJOJmCG1qg5KzE7l0HE11GbpiaHVY5KcHtWI+GnD+3Cyh9Xx7F/tpsQpNuED8G9lYuN4Epv73Kt5ZjHtuB/zbSMJFawlokzMtBiKf2tGMwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH8PR11MB6563.namprd11.prod.outlook.com (2603:10b6:510:1c2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 22:28:34 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9160.008; Wed, 1 Oct 2025
 22:28:34 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 1 Oct 2025 15:28:33 -0700
To: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
	<dan.j.williams@intel.com>
CC: Mike Rapoport <rppt@kernel.org>, Ira Weiny <ira.weiny@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<jane.chu@oracle.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, "Tyler
 Hicks" <code@tyhicks.com>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Message-ID: <68ddab118dcd4_1fa21007f@dwillia2-mobl4.notmuch>
In-Reply-To: <CAAi7L5dWpzfodg3J4QqGP564qDnLmqPCKHJ-1BTmzwMUhz6rLg@mail.gmail.com>
References: <20250826080430.1952982-1-rppt@kernel.org>
 <20250826080430.1952982-2-rppt@kernel.org>
 <68b0f8a31a2b8_293b3294ae@iweiny-mobl.notmuch>
 <aLFdVX4eXrDnDD25@kernel.org>
 <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com>
 <68d3465541f82_105201005@dwillia2-mobl4.notmuch>
 <CAAi7L5esz-vxbbP-4ay-cCfc1osXLkvGDx5thijuBXFBQNwiug@mail.gmail.com>
 <68d6df3f410de_1052010059@dwillia2-mobl4.notmuch>
 <CAAi7L5dWpzfodg3J4QqGP564qDnLmqPCKHJ-1BTmzwMUhz6rLg@mail.gmail.com>
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM
 devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR11CA0072.namprd11.prod.outlook.com
 (2603:10b6:a03:80::49) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH8PR11MB6563:EE_
X-MS-Office365-Filtering-Correlation-Id: a3990e0f-2a9f-429f-e1a0-08de0139dbdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R0NCNE1zNUtCbVk4R0lNRTBVYmlJNkd3eWpRWDlVWWVLczd6clhZUERBTnow?=
 =?utf-8?B?R1hIMS9SSkNoYllZbVNuN0NwSXFhTXBRMTZ5dEJaSW1HYXB1OUd4ZktIM2ZX?=
 =?utf-8?B?ZFdBS2RYZHhxbWlCblc3YU9Gb29hVjRWVWZoSzhOdEgrSUY4Tm5zNFo4UElj?=
 =?utf-8?B?eXliSVJrdi9LbVFJbEFWN3BrRXpmTDNnN3lvTjhDMEdXMmRoY0R2TGZuRjJs?=
 =?utf-8?B?VzhYL2FTMktwalRjWVpiR0Z5ODdNYm5TVVBaS3J6eXVXcjQxNloxdXdiNVhL?=
 =?utf-8?B?dmxCZDFvd2RZd1hmTFhiYngyTEVwNVlBdmx3UUJWbHRqREF5WVI4Y2crNXBM?=
 =?utf-8?B?M0luRUlXdHU3dUh3YUM5cjdDVGlYVW05cGIwdStnZFBoVThYa0JDbXoxU0Rp?=
 =?utf-8?B?ZmVOL0NjQzVGL2JLU1BValJTeFVGczF0RDFJUS9ESDh2VTBGSEZSZGpRc0Q0?=
 =?utf-8?B?enpaL0ZWNWpRZGljV2Iwbm5QcHBXdFRJeDl6UDBtRFVLQXUwajVNUXV0Mkhu?=
 =?utf-8?B?VFBPUzI2b2JvakZtUTBMMitobndleW9NYXZHM3pTc3gveTNOMTU0NmNjeDNq?=
 =?utf-8?B?MWdxL2txYVJoUVNwdXdWNEZBOVNUcVlWeXJuVUFESis3RFE0L2JhM0JrQ0Nh?=
 =?utf-8?B?bzU5L1ZCZmpCU1dvNDAzVXlySGJvM1p1R0tIeE5Mc2Y0amU1ZjFMTW9adlM5?=
 =?utf-8?B?N1Z4LzcxSXBQdThtQVk1T1BGZWdSRU9xUFk3dGVnUGZ4RFg5Vmd5MXVzeFE0?=
 =?utf-8?B?Q2w4T0RNVFlyQW9EMk4rUk1XRUVXQ3RKSjVJUHh0eWdobUxjZ25jZVlscGVh?=
 =?utf-8?B?bmZIRXJuR3ZFdkw4N1ZnaG8vYWxTcnA4T2tBempBR2d5azZxZ1pFd2xiOXFD?=
 =?utf-8?B?NWxydWZDOVRvS3BEcGRmSW5xenVDTm9PQVBQQ1IyU2ZNdWlaR0M5OHRFQ0Ix?=
 =?utf-8?B?VDNTUzlIdFluYTlWckFscXFJT0liWUVmQmtIcHhJNkpzTGx6T0svUlRFbitO?=
 =?utf-8?B?U0lPQ2l0R2ZXYWh2YkNYbEJEbmhEc3NxV3FGQXY0RmVOVE1vczlBUE41TmpU?=
 =?utf-8?B?NXFqVnpnUFkybnhVUnlqa3J6WnM4MVFZYjNiMks5a3Z3ZlNFMkFXa29QOUVB?=
 =?utf-8?B?SkttK21zQ056NjFBRWNweW5TemUwQXFWanFod0VUb3hPdC82T3hqZEU1VHVE?=
 =?utf-8?B?VjliL25EL1l0bXh5YUo4UTljcFZVRHlZRnJIV2pEbVJxSlRjT2FIeDJXRDZE?=
 =?utf-8?B?WklHbmV0dkhzN0NQZkZ0eGFXN0g0Vy9NUWgwRExIK3YwWndCZkw0TUU5dExi?=
 =?utf-8?B?c05BWWdjME91LzZsQ2RvbWI1TXI1ckttSFZJMEUxRDJKRm1yUENIRW1XYTBy?=
 =?utf-8?B?TTFUUHBZZklRM3BKUnJpRVhUbS9Bak16MEFTdEo4cnBOSjJxckN2cktlbzdD?=
 =?utf-8?B?c0FVV1Fka1lEdm1HV1dOUHdZOHA0U04rRy9xa29wV2tJOGprVCtSNFhrekpG?=
 =?utf-8?B?UU9JSHhQby92OHNYRXlTd1RUSHFwS0FJTmxDaGxxcnZUQ3B6ckNmTWZ6K2pn?=
 =?utf-8?B?RG4yV2RSMzdscUo3eUE2WG1icG9lM21lRzJ0bm5jRVpHS2VwOXlyWjhIN00y?=
 =?utf-8?B?Rm9CbU4vUGFFOHUrYlFjSStvbTE0aDhlWENxbmFkZmt5MHFPekxPN1l5MHR0?=
 =?utf-8?B?K2ZqTVdFSnNmY2JxeDUwRDN0ZlZWdnpwcERwTmVDS3NVOEl1ajVyMmhkQzht?=
 =?utf-8?B?RHB3Zk1LSzJmcWVkcDlDcCtIZEJ0RFVSdHpZcHc0SmlHb2VmOUZCMFFMZGJm?=
 =?utf-8?B?QUxsSzNVdWhIM0w5MFFWaFhlUlJucHAxMzZRaDNQdE15REppTU44b3lpeDFJ?=
 =?utf-8?B?bTc0WlNGRWxXMTRHaTJSakI0NnpsYVRBSlRCK1BOZHEwbkVCMmtIQVFIYkdr?=
 =?utf-8?Q?VAbNqn4G0nW0gKkG6ErqBsaoLrm1wjqb?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzlOUFc1VmVJOHBhb1dOOU5NNHhoaVlmRnVMcFViTEhMcVNLL2RTaFJFTHpm?=
 =?utf-8?B?UGxrWloxUlVRYkVXVHFGbkQrRk9ac2RSMUNKMnozYmdMQm0rbEpyWExmTTJj?=
 =?utf-8?B?YWVyYVNRdDJjMUVSK0NvTWRmYzN4S1VGMTJqQUlWaFZybk1YSUxLZTZvUzd4?=
 =?utf-8?B?VWs1ZFhNR04zZVJnelZVZGxwY0xSOWFNMDk4TVQwdW0xQ0ZNZWhGMG9PcTlF?=
 =?utf-8?B?OW83NGJXSE9aaGJLSTdnMCt4VzFRTStuZU91eTBadkIybGFDVUFRYmREOWg1?=
 =?utf-8?B?SUt1OWFNNUNDcjZINGNaMEpOVE9kMzlSL21LM1hEemZ3TW5hYitxNFk1MS9l?=
 =?utf-8?B?eGJDc2FlbXYyVEZqN2pRczB4L0krQXdCMXhBc1BqYVNjaXNWbzJKYzZnZ1Zw?=
 =?utf-8?B?T00xbzdQYXliVDNpYjdnT0RJeWtDNy9iT3ZyQU1JOHBrbGttK2Q1SFpsaWxJ?=
 =?utf-8?B?SHR4MEROS1p5TUtLaWd4TnUvVjcxeWwzNTVEU2lVNk83bFpSQ2JwZW1qVmlQ?=
 =?utf-8?B?SnF1SEtZSWRlS3p3NllUSFpiQ1p3dHh1cTZqRU5yRUtqMThBUGlPVXpMYUVh?=
 =?utf-8?B?dURuRWtndk5CaTFhSHZYWDFXYTl5NDNNWHB6QVJBZzdIbW1KRHBwa0JBQU1I?=
 =?utf-8?B?U1RFUGVwL0h3b3dQOENmV1IrMlVHWC9zaUVLa083blFNRFAxL2ZHcHlzWnpW?=
 =?utf-8?B?UWpFZkVLejJISjVZb1VoeHJIbFpnRENydFVZSzZoKzB4aDNNaW52NHdHeGhr?=
 =?utf-8?B?RGVUbEVURWlkL3NwNTRRNkgwU3J5aG5FWlF5cExEUkpPeUxaZm5tZ2V0VXBj?=
 =?utf-8?B?VXZmU1YxdkxPekdiTkRqTUJuMmFLSUpTT2lTVkR2QUZLbDBtSU4wQVJHbmtE?=
 =?utf-8?B?NDA1ek1WVTZKaTJWa29lVStrdUxGcmE2b0VvOWRjMTlUbHdIK01RcnFpSzl5?=
 =?utf-8?B?WnZzTzQ5ZUVTa09jd1EyTlZDVHpqVGRnVUJRUVQ5blh0SDFZR1ZIUEs2M3NH?=
 =?utf-8?B?ZkkvSkQ1NldlM1JjSGJFdmdhcXVERzlveTEwWDNPUEhXZVczdDlSbmpTQkh4?=
 =?utf-8?B?N1MyU29mSS9oTUdZK05BajRib0tmU3Yrdzl3QWZXK3ZyYzhKYzFWTEMxNnR4?=
 =?utf-8?B?VkFHTEJUN0R4Q0Zha2x1MWk3Ylg5QmMrWWpUenRXVDBNUmhPd3AvaHVzd3lT?=
 =?utf-8?B?N2NqZC83ZElzOGEyeWk4aXZERzVWNld0b1kxVlJTeXR3NWJNM3djVzRtN3hJ?=
 =?utf-8?B?UDNUdldiWnoydFRROTE1WVBrWHB1bTVEUjVjRnBmU0tuVUZmbXd3djZSZXV2?=
 =?utf-8?B?R1RIVG80QUx4Q3pkT3huN1lRLzZVRVRoNGZGOEZyMVI3WEw4ZXFwT0pQNzZ2?=
 =?utf-8?B?QTJjMkNrSW9WY3RxRTVEVXN1Z1pmOXBGaHdjM2NmWHVYVFBCTjkrSDhlYzc2?=
 =?utf-8?B?LzVXR0k4MmVKVldyREJzUTJyd1ZuSDFmNW9KOEVaUm1EWmdzd2YrMWlxSmx5?=
 =?utf-8?B?bWQ2ZDhscG5EcFEvYVlaa2VNOGxJRkl0NU5jMncwOWVRT2kxckJEUWE3djlH?=
 =?utf-8?B?M1lrS0N0Qnloa0F5UVBoOVpPbXFpaDcvM1diek51REZoZFlWRWlPaXoyeHpk?=
 =?utf-8?B?MlF5SGgwdFhoV2toT0xDN1NaYnBLQjZ2c3RYRXVSZ21IWkU4bXlBZFpzUk5y?=
 =?utf-8?B?VXJhQ0V2SGRIMVE4bDNmKzhDYTF6R3BiNS9kSnZaZDlqVFQ3cFlPSVdFbUd6?=
 =?utf-8?B?bkJMSzN2QmQyaEdJendIVUZmRFV0dW9jQ0kyUU9VOTVuNllkY2FuYVFlVWNX?=
 =?utf-8?B?ZnR6UW9FS280dDA5VUthYlBCck5haFpJUkNrUnlabjJObVRFRllPRzNpQ0t4?=
 =?utf-8?B?NGNUQjI5NENoc0FjZUZNT0oxTlVpWWJMdjNQc1JEcTMzdldLa1JCbXF6ZWRh?=
 =?utf-8?B?YVRDWXRnTXBsL2ovREE5Y29Eei9tTTRIdXJ6Q3lNNnpLbmw0dlQzU2h3TE5P?=
 =?utf-8?B?eUxCVS9zL3Z4S3VxdVNIZUpVd3pHcWIwdnJMZ0hOT2RDL1BDeCs5c2U2aTJ1?=
 =?utf-8?B?SGZabFZ0ZUZLTTV6WG1BTVdGdXRQcTQ0dGQ4NWRzd3FBa3F3NCtNZ0Y0U01M?=
 =?utf-8?B?K1BCenYxcjZDTG9Sa2JvNFJlRnIweWhYcC8xUXpxRldMa1BHaERtNThnQUhh?=
 =?utf-8?B?QXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a3990e0f-2a9f-429f-e1a0-08de0139dbdc
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 22:28:34.8784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YrkSuv86AORNGFx3D4WYSjGbVgcBRF1pjMKLsA9iBWpP6tABTRtEKZtcBtecnvWpIpAPNZ3Na+EBRJ8t0QV5L/fDrAaflTN4pGgd3aOwKTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6563
X-OriginatorOrg: intel.com

Micha=C5=82 C=C5=82api=C5=84ski wrote:
> On Fri, Sep 26, 2025 at 8:45=E2=80=AFPM <dan.j.williams@intel.com> wrote:
> >
> > Micha=C5=82 C=C5=82api=C5=84ski wrote:
> > [..]
> > > > As Mike says you would lose 128K at the end, but that indeed become=
s
> > > > losing that 1GB given alignment constraints.
> > > >
> > > > However, I think that could be solved by just separately vmalloc'in=
g the
> > > > label space for this. Then instead of kernel parameters to sub-divi=
de a
> > > > region, you just have an initramfs script to do the same.
> > > >
> > > > Does that meet your needs?
> > >
> > > Sorry, I'm having trouble imagining this.
> > > If I wanted 500 1GB chunks, I would request a region of 500GB+space
> > > for the label? Or is that a label and info-blocks?
> >
> > You would specify an memmap=3D range of 500GB+128K*.
> >
> > Force attach that range to Mike's RAMDAX driver.
> >
> > [ modprobe -r nd_e820, don't build nd_820, or modprobe policy blocks nd=
_e820 ]
> > echo ramdax > /sys/bus/platform/devices/e820_pmem/driver_override
> > echo e820_pmem > /sys/bus/platform/drivers/ramdax
> >
> > * forget what I said about vmalloc() previously, not needed
> >
> > > Then on each boot the kernel would check if there is an actual
> > > label/info-blocks in that space and if yes, it would recreate my
> > > devices (including the fsdax/devdax type)?
> >
> > Right, if that range is persistent the kernel would automatically parse
> > the label space each boot and divide up the 500GB region space into
> > namespaces.
> >
> > 128K of label spaces gives you 509 potential namespaces.
>=20
> That's not enough for us. We would need ~1 order of magnitude more.
> Sorry I'm being vague about this but I can't discuss the actual
> machine sizes.

Sure, then make it 1280K of label space. There's no practical limit in
the implementation.

> > > One of the requirements for live update is that the kexec reboot has
> > > to be fast. My solution introduced a delay of tens of milliseconds
> > > since the actual device creation is asynchronous. Manually dividing a
> > > region into thousands of devices from userspace would be very slow bu=
t
> >
> > Wait, 500GB Region / 1GB Namespace =3D thousands of Namespaces?
>=20
> I was talking about devices and AFAIK 1 namespace equals 5 devices for
> us currently (nd/{namespace, pfn, btt, dax}, dax/dax). Though the
> device creation is asynchronous so I guess the actual device count is
> not important.

I do not see how it is relevant. You also get 1000s of devices with
plain memory block devices.

> > > I would have to do that only on the first boot, right?
> >
> > Yes, the expectation is only incur that overhead once. It also allows
> > for VMs to be able to lookup their capacity by name. So you do not need
> > a separate mapping of 1GB Namepsace blocks to VMs. Just give some VMs
> > bigger Namespaces than others by name.
>=20
> Sure, I can do that at first. But after some time fragmentation will
> happen, right?

Why would fragementation be more of a problem with labels vs command
line if the expectation is maintaining a persistent namespace layout
over time?

> At some point I will have to give VMs a bunch of smaller namespaces
> here and there.
>=20
> Btw. one more thing I don't understand. Why are maintainers so much
> against adding new kernel parameters?

This label code is already written and it is less burden to maintain a
new use of existing code vs new mechanism for a niche use case. Also,
memmap=3D has long been a footgun, making that problem worse for
questionable benefit to wider Linux project does not feel like the right
tradeoff.

The other alternative to labels is ACPI NFIT table injection. Again the
tradeoff is that is just another reuse of an existing well worn
mechanism for delineating PMEM.=
