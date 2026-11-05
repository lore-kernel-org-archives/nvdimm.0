Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793922526;
	b=UzfRphBKnqwqA/S5/zRavCyY+zkRTqlzt8vxFpVT0xlC/c9opTECYuILD+YlJXLnu20Q
	 +75RDgclCXJYqa731fRveV9oys+gYlouOBrbhf7GvpwDOJLe+cAK8vMouVWWoKsPEtfOu
	 Y1K5w4DKp6L3/a7xV55ABE7V6c4cYRIKL3h2VV+buHVqUWG+9YSlYHssgX/LCAgLO62NL
	 W1qu4alb/pWIHmBKPvb5Se91MhUZ1g7nrwV1EFvAia+jLMcF6OM5TY5z95XMJcvz8xLv0
	 +AJRJtO5fOHdT2emVNXyGHVh4uLNJ/NdBpmxtMTqmifikVlaDOk73L1QCgvc3rEIDDQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793922526;
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
	bh=wwAeDGlifiHPEm3zXMbtYED1yqK9MLOoLUjK44KuilQ=;
	b=h5eNXX8UbWNqEaD6LHb3GELnW2rS3WJjUBOiUPYIuydMW4ArLoi7h6Tx48QBHpnA6/GR
	 Fgk1PE1fCbqBvgNTdY8oG5YyIu/ufuQUIhX8ADivXqDB2XQ2elwi7nuPesnwJ9IZBbOWo
	 kYEKg677jGw64EgpPC7CwSqcI6Q0+1mv1qBJY9GJpATHFfslz7ZjgL4jkbvU0i8n10km8
	 J1VyQ77anztUqmi4w85HIReK0lv1rXfXzqr8f2EwkDPLSU42LVyfx7RiuiJgqJU1wlB53
	 gzhUZ9LsyMXjfuHtpx8tiIxOstW+uW+DdNa4o6WW6sPLt7BZE2uaxZHXFbsytaIYbcQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fXYZmCbE;
	arc=fail smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC41606A31B
	for <nvdimm@lists.linux.dev>; Thu,  5 Nov 2026 23:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEC41606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fXYZmCbE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793922526; x=1825458526;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tOibdezExG/Ys53A9IWzjNad93n4XtA5ndJoVmgxj1A=;
  b=fXYZmCbEbYI9xZs3/ho8C8iaHv4vS01Mhhs/WJmleblLnMKNJ8O+EReO
   SHqTiBPPkl0DnF3kDFgcH8o+qFAgjMMVR0vuREPkIw8YE7J/JKkQWlMrV
   WLbXsV5w8Uu3sq5ECaLBjavKjUmBtK7FjcIUVRb1rexx2Mx/NEroQfX8z
   fDSCeIwGfNJJAfPGOOSb0uhzOh0cpRRvBGo5poJEpYc94sy7hJdF/nab9
   tdzYwGsOJjtA5qTojY3ERwqfjHK5AD5y677ggc75DaQvo6P2tgAF3/Jlo
   QoFsw4DAi10QD7sYV4UQkElaJ5p4Jg5B01UjwCmjmLOUMFUMG3cXoD0I+
   A==;
X-CSE-ConnectionGUID: qvSzz1PNRxCgbF0alqqDPA==
X-CSE-MsgGUID: cETJXmOkTL2R1fkhDubW2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2738025"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2738025"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 15:48:45 -0800
X-CSE-ConnectionGUID: e0YffIRdSeyxKlDVUONpdw==
X-CSE-MsgGUID: E4hGpLCVSV+aNxQQVUzJqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7126926"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 15:48:46 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 15:48:44 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 5 Nov 2026 15:48:44 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.37) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 15:48:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kRjiyH0uvy9pIzcxbz7sbZYHzB7qdwEvMG4/adOBKOwPNbxO09/taN3cBYPyN5wcH4ccX/xDNL7ARXl9Ag6RX+JJQviwo3xZR0kU01qcC5YfBJO8OaWka6bik5C36IhCVMoQVuZNkb/9JGr2jBZg5bQFKs/XuP/iK9YZd+GegCCWpckSjak2aXuA/7IvnlS9j/33mFvD8e8xooZiezAJROKk4xm7Zkii67poUtt6w0Ju3Xw8d/xsx1rIKHMcrlpgbhnaKTc5wL4AhDTNbTtrVY823jeMRrI90kpY1OFQJJXfYZqHwyaWFZRDHHRRaSkP5DE3OfL9so3pp5GLrBCG5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wwAeDGlifiHPEm3zXMbtYED1yqK9MLOoLUjK44KuilQ=;
 b=n2eBB/628m6DbnjnYlYeK5zATpc/RK+yP9bx3Dhch8cFNxrsS3m80TnboN063juyRP31FUcQCEZxhMEnNJaBDFpe3ahBlWABWUTd3f7XqxbIpvkdkWGuN0NxNP2TDyi0boid4Vfd9IzuVyeHSQMP1Gowr/EH9on09SeLs6nh0QWa9sZrSLl453JpbHCd7pjYZ1nUY71m7h6hl4F3iEXG9mgbR1v9VwI3TLB5doisSr4jBCg4ypScds98ubbpJeiBHDUQ5sE/xNnc5HxjbZhK86SmG3pRvotmZ2dhB8BBjh67AUl2URB3C2NDwA2RoAVwL9hUH+UMzx6nj3gQTQD54g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA3PR11MB347531.namprd11.prod.outlook.com (2603:10b6:806:52d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 23:48:43 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 23:48:43 +0000
Date: Thu, 5 Nov 2026 15:48:39 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Avi Weiss <thnkslprpt@gmail.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
	<dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH] nvdimm/pmem: propagate personality discovery errors
Message-ID: <au0V17R6deHr_CWd@aschofie-mobl2.lan>
References: <20261030181111.2614274-2-thnkslprpt@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261030181111.2614274-2-thnkslprpt@gmail.com>
X-ClientProxiedBy: MW4PR03CA0132.namprd03.prod.outlook.com
 (2603:10b6:303:8c::17) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA3PR11MB347531:EE_
X-MS-Office365-Filtering-Correlation-Id: 14203c5e-fd99-4ef5-59d7-08df3b97527c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|261021123027099003|261022105027099003|261021135927099003|56012099006|11063799006|261028144727099003|261009223027099003|261021121427099003|261026121527099003|261026140227099003|261102123227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: gtzPKIQ1eJKAO84Bl5cEx1RSb9eR+rjckdk3oDFYB2+eFaXNvkfc3tag2uy1s5ioOYdf0wd4IIaj/eH3Si+Bf+XKl773xw79ME5m5yLbXjgHgTUIo3imL2a93R4ZdFJdDqTCYD+QPSZkyaJSk29iHHovXEcS/AKL0DRd0c3UdTCAPVkdQ8Rt0NyAeT1UY9jmP0EcDmQfcR36x7HwTrjHYeCPIXpEvq4cRcAswT+5hVGeUgYg0akSXWfaiTnFZQiDsWgrJSa/GnVLZPiAe1EKKTKXisuZXxiDk5QFk5YW6MMNgbdO6M0gN2AWW9g1hlIHmK3bEN6k/riouyA3C0BbUHZoHpkfVhn1dNTU5ZUyyAx1RukEXTbVLeK402ARGvkdgFuXevY//tkFy88wYNL/MzhVDMY8mf/urqzOj2kPBZ3JiZ6upGTGUZ7AkUvZRI77JvV2lAIT3fKiqh7sGTouBBvJ4nWVHXHwnEq62asH0MU5B3qef/34eVTYFqCI6zbGkAzcCohlAQtnNeqT/1Eonw/+MuTZLrxFBMrn7PPE0AifPMgn2PBVKW2/iF5nFMB0X/TLPLGWejI/Tx+6QDcvMREsi7II9hIRFt4wgAHJgAIVI2QGkZOd8z8txwAogkqrAGdkFrr/WtHlSPmPqt+kRlU8vWFxfYtoJ/xmbAcc1CM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(261021123027099003)(261022105027099003)(261021135927099003)(56012099006)(11063799006)(261028144727099003)(261009223027099003)(261021121427099003)(261026121527099003)(261026140227099003)(261102123227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N+r/eATx3kdxXUH9implpQclQMYEwg/vvtcwzg0WJF4eOIVdxygffCBX1f1O?=
 =?us-ascii?Q?8PgKyJmV6awR9QXSh5huFx1HRvNMPcyGb2xY1zrN+5K38pFusf8GYEcWETYm?=
 =?us-ascii?Q?UWzVY7MfJJ620JS5brMqDXztex51i10uf1lRKT3l+VRpbSG+LHE8FnEHLXJQ?=
 =?us-ascii?Q?KOMSt6nnttzbIxKHvwlvr/Vtf1Ees3Lz0yIA6X81VH/eqwrHZEPRpNObPlqp?=
 =?us-ascii?Q?gEKUakhqO5rogjioYU70PLSU91Lc9r771hRXvXl8rzeuq2DJpreszRPny2CU?=
 =?us-ascii?Q?hjrVSurB5Hy6opWNKY+in07bu8/YfmsTuEbnHEYwcys1KduSAiukUviPsIW2?=
 =?us-ascii?Q?Fbra8ZzX4ZWGuJySOKmLb2BBSyfZKlRJocCN38ninphf84cMUAmnhNSG/z68?=
 =?us-ascii?Q?T5u85TQ7yCucTFUdWn8vlRBWofuz3vMD7AN8wj7tobZut8jJk1zeXG7aBokC?=
 =?us-ascii?Q?dHZf6r5dB0VzxJZUlkW8PmxumrMoSdfH3AvRusTj8hOxqD9LT/ninMqUXkyv?=
 =?us-ascii?Q?bqFj5gRx2fpEp5Pyc18PFs7Fzs7EIY95n16xklyNHPASlvAi5seMxRS/dWSQ?=
 =?us-ascii?Q?PjjzWiaNHkFJAlVDQHClR370OprSKbMGPINgVGKFmVo+KjvsOwRs/ngEOizI?=
 =?us-ascii?Q?jJ0QevcrzObRX3PgP9GGedtr+8q7eO+ZtEQ6cvEqTLtZs2hRGzGbfKcMftwZ?=
 =?us-ascii?Q?a2dFLpYECuvDKz5Ctd+O6YKqqgq/rkmG+u3f3zTV9qPkt/QXEmTcjvYSshZg?=
 =?us-ascii?Q?dZmQy6Yu4GvhW6UkdMLk0u4y6g9n0am9WpeliwctMmH/C2Amtqdk4ZiI6orj?=
 =?us-ascii?Q?WVSip6YZfFcE3Pv7+67GrcNUY9AKYAIUsqQcOu+yTU78DemM7YWau5RVcNE9?=
 =?us-ascii?Q?7zEnMMfB8YckClly6WRHAgwuBQnPVlgr9Fi2zdxRsCww3bWQR1ZctBU5Ra9T?=
 =?us-ascii?Q?yPGmrOL2Ngw1b6TmHgKUwkn1ihDgef+FFPip9v3PjEtjZnF+20SbVWWnghyJ?=
 =?us-ascii?Q?ru88Q7J75TDJY/iCjZvGuncHpDCsb6mpHBIf/AyHHrhyGb0QqME+XxS+Zgej?=
 =?us-ascii?Q?lBS4qd7hITGjiDgVp0qK/02IOxQEZI0xCuDPmiqr0j0EQLbgFpbDz+BHvMqJ?=
 =?us-ascii?Q?DXnCsh5o49D9LhipiB7h4p65mI3Qtcq8fK5snPQkc7GH7tuPi+6KZbQSRt5t?=
 =?us-ascii?Q?VXbbNm+AbyNa3PaBDDMwL+fhXJSvQqCi8Q5u7Bf+ykrOhRl8RJaBpjZNa6YM?=
 =?us-ascii?Q?jfaf75Yv2zY2tMEG8dCvLMdX7+lWZf3Jr8iE4XfEDsSl8Ly1tVRPnLFN1BR2?=
 =?us-ascii?Q?sbog+jiYuKFyQBuKYqx1TE7GSCw/AIOIoG8Rr0kMA1WGIYB/2Vj7CihKnXfq?=
 =?us-ascii?Q?37YPHpMgFyqpGmwnfc8nslhfVjvXQR7CiAf53G+u+sOZG8jd7EEcfvs+AuTU?=
 =?us-ascii?Q?MVeAMDMpyR4JyV/jNRC88Ai1M3BJMuj2WtThXdfC4K6IdABldVZZox+4xjRF?=
 =?us-ascii?Q?3Vs81kNQN7VfQzq7iSSYkzW5eWBOCnzDf6NTvOOznB82NbzvhwdSiFOLuwLW?=
 =?us-ascii?Q?unHH+Js/kb11LtH7E8yV1UzgJj0DrkXy+Zegtpg6CPwlwgFQKneNUTpm1Zmx?=
 =?us-ascii?Q?1oMDnce1bGDQ+sVMf6SZGHqXPYVm0HfWqp0VYN7pu5duEjuvCB0HBhqcj5R8?=
 =?us-ascii?Q?nRaWCvIrqGqNxUQBrxx4gxS2YTBVqNuK2u3TLG/gn7ugVZBF/mp4MQnrE06n?=
 =?us-ascii?Q?MbmrJF9EDy6/+6wJ9Wz9Wj9cwPDF8cA=3D?=
X-Exchange-RoutingPolicyChecked: 1lSlTtPN05WOs8LWT2RZQcu8+R/w6qQWmrLtRQTt5IEbeBy+xFzrCYebtT4iWtH91fcO94A+MrGrkqES/fHKcwaOyjyld0OToGFTrgDksGy01it8Y+ViM+Ceu+BuVRpfv7uE0RGW2BSIsY7YjbYEZp5XS0PDk8YaX5UZFzpRXTG4cJ0weBkWSEz1s6OFUxrNXt4kQCyQmQuHDRtzSqNF7oM9UrP2Uk+bcgra4i+VOhUqmiMhPityzm0Rkuv4Qfb0XSdLEEXrK/cmQ405VYkwTsLnlcFQ+SIil09n7i5YvHixe+9pSFlSITOFYh9io7NVmLQWh6udgSwCtzXIfn1LYQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 14203c5e-fd99-4ef5-59d7-08df3b97527c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 23:48:42.1319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TRVNgvQldbilKnqeZImIEPq7zh+3vw1Y4s7qtOmEg6VhdNO+dWoUQTKlABPVmHaEo9Yp1CMKznrDLAuufx+RjhGqoNKVSN5QA/quQuoXyRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB347531
X-OriginatorOrg: intel.com

On Fri, Oct 30, 2026 at 08:11:12PM +0200, Avi Weiss wrote:
> nd_pmem_probe() ignores errors from nd_btt_probe() and only propagates
> -EOPNOTSUPP from nd_pfn_probe() and nd_dax_probe(). An allocation
> failure such as -ENOMEM can therefore be overwritten by subsequent
> personality probes, allowing the namespace to be attached as raw PMEM.
> 
> Return discovery errors other than -ENODEV and -ENXIO. Preserve the
> existing raw-PMEM fallback for those error codes.
> 
> Fixes: 8c2f7e8658df ("libnvdimm: infrastructure for btt devices")
> Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
> ---
>  drivers/nvdimm/pmem.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 0766a6949b28..78acc9b0b1a0 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -632,6 +632,8 @@ static int nd_pmem_probe(struct device *dev)
>  	ret = nd_btt_probe(dev, ndns);
>  	if (ret == 0)
>  		return -ENXIO;
> +	else if (ret != -ENODEV && ret != -ENXIO)
> +		return ret;

Hi Avi,

Thanks for the patch! I think it could be made more complete.

Does this also need changes in the discovery helpers? If the btt_sb
allocation fails, __nd_btt_probe() returns -ENODEV, so this still allows
fallback to raw PMEM.

The pfn_sb allocations in nd_pfn_probe() and nd_dax_probe() appear to have
the same issue: nd_pfn_validate() returns -ENODEV for a NULL buffer.
Should those allocation failures return -ENOMEM too?


>  
>  	/*
>  	 * We have two failure conditions here, there is no
> @@ -647,13 +649,13 @@ static int nd_pmem_probe(struct device *dev)
>  	ret = nd_pfn_probe(dev, ndns);
>  	if (ret == 0)
>  		return -ENXIO;
> -	else if (ret == -EOPNOTSUPP)
> +	else if (ret != -ENODEV && ret != -ENXIO)
>  		return ret;
>  
>  	ret = nd_dax_probe(dev, ndns);
>  	if (ret == 0)
>  		return -ENXIO;
> -	else if (ret == -EOPNOTSUPP)
> +	else if (ret != -ENODEV && ret != -ENXIO)
>  		return ret;


Suggest updating the comment above nd_pfn_probe()? It says failure
to initialize the pfn superblock advances the namespace seed, but
nvdimm_bus_probe() only does that for success or -EOPNOTSUPP. With other
errors now propagated, that wording seems too broad.

>  
>  	/* probe complete, attach handles namespace enabling */
> 
> base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3

Please base your v2 on a linus mainline tag, like v7.4-rc1.

-- Alison



> -- 
> 2.43.0
> 
