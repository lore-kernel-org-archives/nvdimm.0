Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C111E377010
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 21:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774300180; cv=fail; b=pbGp3UQrntFZh8+ESJBCU4/Ut71Lk4gt4AE09PpgtmPOGZSzAU8nqhWUxO0l90zIVZSJRh9itDY8T4yZ1oh8Are/kD4tqsA3CS8MnhNOfnZtqu7dWyRYHP0xKR6A6IzrONSmB2cuenssoUyfag7dQx7g2sMxpLeArPIzMQAu9ro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774300180; c=relaxed/simple;
	bh=MQsS0nPiU8MbhBzgCGlCEzKFDUnNbWxm+ioaMErbVf0=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=JeqPihJFhKGS2MReRWEFFQXIWk1IXo1+g/NScsgdR6naFmBG3CSTnrMdVrc1mv2NH/69n1b6hvv9qoSmvp+TL9g3aujKyojXITDqJKoKnmOJJBakolG57faNAeUVnSszxDKpYMAy0VwqxpzsXkhAimXXsOgF5yZyR4bBNgUtd5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GbzhK/ny; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GbzhK/ny"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774300180; x=1805836180;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=MQsS0nPiU8MbhBzgCGlCEzKFDUnNbWxm+ioaMErbVf0=;
  b=GbzhK/nyA8DZbhrKA5EOhAXdryr6Xnf1l+stajjGeOJ2LtSJThq7437+
   Jh07P5d5uZgw5quJpkLKxMsZtv+1gZT7KPkQ1XTGUn95RblwOHUTOXE2y
   qW21KLR7ZFDw5NFp9vWOhwv6OJDvf/KGh2tnCeUgWj5bVwiKEcAUX6gqb
   ucJT3fxn4DJXbj1bBYu1yBOg6L3RZu3DWQ63Mjx+k2VkwUOg8XAZyEmmD
   72GNQVO/Mr/9QQIn2f5hp8WpDMqqSmIGvtfbJ9MPzSLKc0/wEj74LaAZ6
   LiKVrjFurTOPa8joeZzppKZ4LoswA5d8+3oWiStjeBhPOXeMKGc2V0a2q
   g==;
X-CSE-ConnectionGUID: wgSL5pYeQwer7QIxV12s8Q==
X-CSE-MsgGUID: nPuO1ZghQZuwGo7k814bIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="75020465"
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="75020465"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 14:09:39 -0700
X-CSE-ConnectionGUID: 5Omld4yRSCCrNCS2E5q6hg==
X-CSE-MsgGUID: A8GmrQmaRgqT/50zcRHIMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="228625312"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 14:09:40 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 23 Mar 2026 14:09:38 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 23 Mar 2026 14:09:38 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.55) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 23 Mar 2026 14:09:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aprP392HuFfcd8/gG+ffsKVE4L291OleESoTAEGYcqJugDQx6AZ+zxzoFsJIGbqRjSXD+X0Mq/XwhhgQU2nqOEGvMDggcqFhV2co1FKB1ITetTGC8EC/aCGJconoYLbJoDsv6i/uxL9eqVdnyhRm6rtOq+AEthvyhZYT0rdhiLNwC4NNdwWLjvwwJMzLuBdovxTiEfssliEtLE88ywyziOKKQxnCx9dRVFRrYPbX8qXeK+AMpzHOTt2N31cNaW11VCmKdvlRP3G376jBK+QbSbb5eNEIUDHW2EkzU/F4PdL+sYPbW56UKImCNbQnYSkrmuAZ6xUgfx2gdxtK1ZtTAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGdwn0LGb5/VFLmGIPiYNTCLoTPi3HKf9ABfDgxuAHw=;
 b=Bzs8R9varAo+sH5SaLlXeiFdOheQQUp34m71U3lEnfNAtqnorvqMLOuozCz7M7FRCqnMou7/4dSj4oR44yY5uVjNf/j8c0URN5oQUhjTkrI6DDWDKTQnFT3QXXvus/13VNdG0jRlpKRPRV1OYokUpJCRb9dkYpmaSMAYG38hydI7MSyy+ayLlqN5p5yt1DyC284RVuejGQNHljGzMmoqL0hE5/L2vN/aMJC+3hbNK4aqnklCsooVSkQciXRvkdnNKVgoh9/OgesIbuFf/PRC73t3OrPfzSfsgy3iYDdqTDCUF5cQ4m+Mu2L7h1m8wJXdq4wY/ybqzKCriDs4+At6ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN2PR11MB4711.namprd11.prod.outlook.com (2603:10b6:208:24e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 21:09:36 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9745.019; Mon, 23 Mar 2026
 21:09:36 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Mar 2026 14:09:32 -0700
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>
CC: Ard Biesheuvel <ardb@kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, Yazen Ghannam
	<yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, "Ying
 Huang" <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Zhijian Li
	<lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, Tomasz Wolski
	<tomasz.wolski@fujitsu.com>
Message-ID: <69c1ac0ce63ed_7ee310076@dwillia2-mobl4.notmuch>
In-Reply-To: <20260322195343.206900-10-Smita.KoralahalliChannabasappa@amd.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260322195343.206900-10-Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH v8 9/9] dax/hmem: Reintroduce Soft Reserved ranges back
 into the iomem tree
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0352.namprd04.prod.outlook.com
 (2603:10b6:303:8a::27) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN2PR11MB4711:EE_
X-MS-Office365-Filtering-Correlation-Id: fd8de104-0538-4bbe-1fec-08de89207cde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: t/8gt2w4kkrdrwFKrRhw+/i/mOL8g6cZnTiFFA+Z2G7qsOiV05/41qcJT0YmAep3hiS+T4A+LL15lY0wvyowo85BK9kgsEVqA663Dntu7zEqrtNi/mx/TspULwEYlz06lWDbbJh4Ki6wjhOMF5X26Kqg7arZju0NJo3KESuLr/8bHHJDLo3W3AK0v/u29RplLaSbPBpKslwns/V+iQ+F6jZ9XXjURvvx+jQmHnqI8rQ5v73Hw3IFxBdySs5TSWwwjI+lYbR4SKleZFTA5Df85isC8e6KcdhWyoqLF/JwKVqxJBhS4vP0dS/EGEwNRZ9SIR3RiDHWsUDoOAok3yLYz8gssgVvO7C5bLPrMIRhNFpFYdEow9BAi2pNWR+VGxXCFNK3IRd0lBv2wSv7waMyyfIkTWK2Yj27j51GtOfHIwW0jVMqtZB3V0gAgQ5FSyD+kcShzdzdOTRNzja+nGUTTS0STLEjup8dmILFq+jd2EHGshptqvwlEpTQHRW4E+FgPQPeQfbseuroqGEFSbPJS6u6xKOQ8XviysVtCqYIT9y7nDQyykVriIc35zbBuMbREs5Ibe9aT7nbhoSJWhwioButLxg3FzJoozNgKNS3K4nPhq5eBZPn84d+ZdyVY/JBSea1M5tagVOvyXYJifrNRfeojw2STTd3sPIjaxxmA/Hp9VqfgTEJB9ZK3mrUwmnIzHfOCWkXNjv5CLsnJqobM2WHvMgfF5PDZnw6D7Uosw0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2pmUlVOTDhxamRSZmIvL2h4bUxqNWNseTN2SVdrdUlsVzhZNUYvQ01QUE92?=
 =?utf-8?B?dE1SZEVyWm5UVmZCaHdzckN2N3BkUDV6MERjZ0NGVm9PeXhkbzRhSjBzUG03?=
 =?utf-8?B?VGZIUFdvNEsza3o5clRGQ2NEL1ZCczJMNXZSVHdrSDJKTE56U3I3dWNUbmFI?=
 =?utf-8?B?WDJMVy93VVlvN0pGK09XalljUUFvNUZNOXo3WTZCNS9TQXlGRGJaYWNwWmpX?=
 =?utf-8?B?K2dPTlpMbVVEUUpxOUlKQnZyV1RBeXQ0cVhMQ3lnNkxOV3hPM0xralFGcjFo?=
 =?utf-8?B?NFFUMGJZMUhxWVVxek8xL1dVeFRPZ05RUDhPTGZrNDU1NWZLcDYzWUxWYnZr?=
 =?utf-8?B?QUZrUzZNT2RXd28yc3dPTDhGR1dTcVc2T1B2OTVTMW15V3FMRERreXVMbjc5?=
 =?utf-8?B?YmdWYnZ6cE1XWnZKU3lSMUdiWC9lNFRrSTUxVXZIOFRSQU5HUG15Y3BmTjJx?=
 =?utf-8?B?YlE3alA2UFhCbC9nVVRMZnRLbVRLVzV4WW1NK3F2bUd6WEN2VW1WQi9sczlw?=
 =?utf-8?B?ck83TlhvOFg2YWsrcE0xT3ZZNzIwUzlZVHhKeG5SYnNPMElicjd1OFc1R3RG?=
 =?utf-8?B?N0FxTE1ZN2x2QzR6NWZLRFArcStuRHBYb2tqTDQ3SEhySEVUN3dGcE9nR2hw?=
 =?utf-8?B?c0oxcVBFcXJKQ2oxdGZQTmJrWnV6bHNMejkyZEQrL2d1UURCdnI4bm9EVS9U?=
 =?utf-8?B?YmpVcFFvR2JVN3hBb3hRd0VyV1JwQW4yVW15aWN4OCtwTWpPVHNWNWpJRCtw?=
 =?utf-8?B?Y1RpK2szSUdEL0dmZlhDTUNoUDd0Vlc2QVVpWXU1ak5xRFgrQXdqUCtsdEY5?=
 =?utf-8?B?bC8wbG9vdzBmRHZob1BNWEdPTk9VTG5FVHVIV3V0RStXcUFPR0toUy9FeXFy?=
 =?utf-8?B?RGE0M1VwS0Flc0FXR3k2b1NxTFhKZlRFd3pjeFQ2RDdTZXpZWVROVzN4MTdT?=
 =?utf-8?B?UFFWWVdMRnVFUXpmYkFMdjYxY25jd05xM0ZML1lpRloxaUlPQzd4ZnB0eGM0?=
 =?utf-8?B?blpRTURLMmtUZFpUbWZwRzFWZU5VcVdXZ0VIM3NCbmVpQ1FteGU2TnNMeFdE?=
 =?utf-8?B?ZkJWRFVEdWVQODR1bzIwWnVUaHd5bUVTY1hVNFhEM3h5aHpFNlBEZUZtWGFw?=
 =?utf-8?B?TEVnNm5wZHNOZjhoamtXK3kzNHd0QVFUWHlPNUFDb0tueTlBTVN5c2QrMlFR?=
 =?utf-8?B?TGFoZnpPWGpyandxUllhOFd3VnRBV3lQN2xjd1BUQnBmZ3FCQldvQXB5d2Nm?=
 =?utf-8?B?U3BCeXJnZExiZGpyQnh6eG8rRUdUakNJOWpCNlRGRlpsa2ltOG5UY1ltWVBk?=
 =?utf-8?B?ZG5HRm1Ed0RIZ2Frclc3NGJRR0tPdmR6UTZpMWFwUTZtQkVIS3RKcDQ4aGVZ?=
 =?utf-8?B?UmtmQ1pENHh4U0RsNmNCVWRsUjVFMzdTUXY0bzdTV1hFMGJzMEZpYmpRN1Rs?=
 =?utf-8?B?VTJmWUxQTlZrajhzdXU3NUFseFdkekpjVGxlb1ZReGJ4eExkQ0hab3RxaXJk?=
 =?utf-8?B?WU9MalZvbUFpUkxsZEZlYkNMdmlKWU9tNTZ6bUlHdDFwRGdxQkVUTmpta0hr?=
 =?utf-8?B?RlFlbjBGQWM2eFFqajBxQnJqZ29sd3V6VHN4emIvVkVuMUlLUWluU1RHMVF4?=
 =?utf-8?B?QmExTExHWlcvUWpIRGFpa3RkSlVSU2dlQTc3TGl2K1JEd3d1aURUK3hwVjZi?=
 =?utf-8?B?VEFlSW5IYm9OeDVDUEt6bkNjZGFlREhPa1RSMzd6RHZtZW9Hc1M2cjJ5YXh1?=
 =?utf-8?B?QU9IcFhSWTJvdXFwS3NOZzFjV05udVZOYmY5Ni8vcjdSeldoYnV0ZGtiVUNZ?=
 =?utf-8?B?V1dDMDBZZGdYWHRlWTZ4S1ZYakxmaVRhaDZHQ0QrN1YvNTJRQ1hGbi8yUGgv?=
 =?utf-8?B?Q1pXWnV1bFo5cGhBOVBDeWhqSm83TzJoZ2c1UmtsVFpXczJBaVFmTzIrYTlU?=
 =?utf-8?B?VXo1MEt6WVJvdjhXM01TVldNcldOcEUza016dnNsWlM1UnBiZGNVVEVkVVFa?=
 =?utf-8?B?ekc0NVFqQzVQd3NhV0ZUVTdlb1Mrb3Nla3BCSGxyUmZXR2kycHMvN2JybWVM?=
 =?utf-8?B?K0lNMExGZGR2TldyVmVWam9KZ09BNUZIWVJmY1FOMmF2djRldXM3YkpzS2Ri?=
 =?utf-8?B?L1BsclFYR0EzaFVoOEtDK2NzTkQ5V1h2Q3MxdnhVNWpXUmRyeTllOHhmSmNy?=
 =?utf-8?B?SEVYZlZ1K0psMElHZ2JCOHJVWmJGM0lNZFBSUFpRQlBLRUpFa1cwQ0x0NWlJ?=
 =?utf-8?B?V2Ztd05KTEN0UHJJdUJIZCtTMHI4Y3JMc2x6bFhzeUgya0JqRHcyZERQazZI?=
 =?utf-8?B?NVhEM28wbUpZdW9VUWpxUHlXcG5BejJLQ0VUVHFvdWRicFJwNDVXRStVL2tU?=
 =?utf-8?Q?mcPI/GCLIvvmiWv4=3D?=
X-Exchange-RoutingPolicyChecked: ggu0zb+Dkc4XJvsai4tZIn9Gl7h7tDh9WTy32EbLXQNXDhBJqfwFdygWbGDb/oWSwGkQxpxpsi3eP6Wby6awrP5UbL2E5/0fLvXcdH7d7GcImIygWn0lD0M80l6QPAh481UMO6SjIyWXpSmY2U/0geEQBq2r+89jKsmZPK3pq57c16g2YFmuYjCKrSAjg/+T/u9f+cErIauWAN260UIg0/ffhw9W+a53U/lEnZgKQBm5TOsPjq7Ps6ihMfUxTQ/P8cThYWQfs5F8zf7lBZFt5OyAUxNp5RnBxwW8tw7UAUTHrN5FGWqyyo3ih5wYMlY6J0yliPD1z8J7aW6HuPrMAA==
X-MS-Exchange-CrossTenant-Network-Message-Id: fd8de104-0538-4bbe-1fec-08de89207cde
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 21:09:36.1356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5n273DXbl4ybJ1OfWv79UESgcmDedIGGbMacUrUttKf5svcMDV5lD3eDalfCBKaQy4PdDR1iaAIdtmisgf55Rm1oskTjtUxjnxOlNpGft0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4711
X-OriginatorOrg: intel.com

Smita Koralahalli wrote:
> Reworked from a patch by Alison Schofield <alison.schofield@intel.com>
> 
> Reintroduce Soft Reserved range into the iomem_resource tree for HMEM
> to consume.
> 
> This restores visibility in /proc/iomem for ranges actively in use, while
> avoiding the early-boot conflicts that occurred when Soft Reserved was
> published into iomem before CXL window and region discovery.

I recommend dropping this patch. Given that the v7.0 kernel already set
a new precedent of not publishing "Soft Reserve", there is no pressing
need at this time to bring it back. We can always revive a patch like
this with a regression rationale, but otherwise a less busy /proc/iomem
is attractive.
