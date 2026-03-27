Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE551D88A4
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 16:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774629412; cv=fail; b=cZxLrThdWyxuijcB+bjYLjqdWirk3y64ENyAmo5GPRG3awjzoxMIXrjbzPoUkH1aGYvMVz+dza541iICjz22ozlEqnl+1myouBNFfm52/fAtfLuHzYkvOA+yRNHVKDj1FBj1Nu4ltu11rfj5Y5M+fMAulRzsu5IhCmvtCIYb5Z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774629412; c=relaxed/simple;
	bh=UDPJf/c/Ww4LAu0xObQGqbiwxtXSapy9/cifV7D65pI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZQ2yu/njOzb68CM8ArDr8UeHgNN6frLgCaYEpV+iDXbWP59y4op0O4t8cK2BHFtMtZ65DsRPn208NCRCubtPd97vGc1QIKL1LhI2LdB4OrJv5PkNY+w8Bx6Vq81NJfGyB+GWcf8tDRYugwdUhpQty48PE1gKacMDFjcPj9uBPss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kzgUIGNM; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kzgUIGNM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774629411; x=1806165411;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UDPJf/c/Ww4LAu0xObQGqbiwxtXSapy9/cifV7D65pI=;
  b=kzgUIGNMXsMGm5TMKTi9TmPBRQVjX0IhmQ9gWJuQyLRSMQKlaG+HrJLG
   N2Stq376SgzWgaRcWgDBKQkcdipXZkihZVnuHyoMeMWnHuxmuxj75nhkG
   DC18/qmSlnjWrZFjUp8QHxU17S3zjAaWME7mQyh0ZAcxKJvPN6sDuD8KP
   PW0dPoto+iOqffLgt5s4UtolOrcvK1en8biEcQkk9BARmoN8unSQSX00o
   MLY+6EiY78F1BRs3KPLaXBuyu5bkAiUN1Jo5ZvfTHQ2qpwS5u6wGEf0X3
   OIZpLoC1wXDh8+s4wxLA5AGF3JMFTZAEs9pWzXBYkV0CN1y33oHsW3EeY
   A==;
X-CSE-ConnectionGUID: AUKo+ZTjRNS35EdmT8113g==
X-CSE-MsgGUID: w8pP14rDTG+c1fniqj81Bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="86326242"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="86326242"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 09:36:34 -0700
X-CSE-ConnectionGUID: lDlDZ+zSS4e9FV0SLYRlJw==
X-CSE-MsgGUID: 2eTHDYvmRLCqJBuV2fAB7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="229859111"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 09:36:34 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 09:36:33 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 09:36:33 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.39) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 09:36:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A2lxAzFO1AmjWh4StWLyP881Va0HWYhuNuTzng2gP+nxjFOMj4YgOGRhKgdTHmIe++pbSBdF63/pjJmk44AKzO3eZGUy+gWurVqqcZV2iFGVAeASY2+SqmHqCVH6HMtLXJqxpWJsFQavFHu5sUld6nbiw7O1jWxKjL+MFlrsM8NZv6nSAemoXfbsvzmmF8FxoHFIYHPrEsFfC8/togd6pH1vajDjq4HDaG+auoeemliMOulaHSIJV+Lxdvt5Leu7nhinns8YzYbffrF5/aZ4W9J6yIyNAesQ6+69gIyar/bbIqVSM92P5bgTvCkODZtJeJTVafInirlQ8EuZyKfRJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pSoLT6KQBl5mWrPkXGdcCjonU+pwBP3OBhe3h2vzuJo=;
 b=MDtSE/+PMeDUpmhJIHMWZjsnhWangTQqa7Hkbe6+op35s25oTXtna46M25IZhi9hm8dTzLam92M8Efba3WgZWPVNUSv6WhGZ4c156HeHC3J2ZYv/we4CvJ0oJ4mKTkN4d8M/YVpBs2U8A/D7d39P+rV8mr6C1yrW/6OAcKaOs5GKSWBNH/5TBqIqBdbfLZXKDmjrCN/fhgSf2dH4ZLrmlmW34pUwY8aGk4tEmlCvaP0Bkbs98ou/Ymeb5wnb70AARR3dJbCJogTDxTrRz87gLW4kqyZWKs4oYj80q/SDgEJ0AGDz4lQ+oOOzGPzNKjwc/AVXKxaIF6NZYRWy78wZnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by DSVPR11MB9766.namprd11.prod.outlook.com
 (2603:10b6:8:34d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.11; Fri, 27 Mar
 2026 16:36:25 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0%8]) with mapi id 15.20.9723.018; Fri, 27 Mar 2026
 16:36:24 +0000
Date: Fri, 27 Mar 2026 11:40:12 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: John Groves <John@groves.net>, Ira Weiny <ira.weiny@intel.com>
CC: Jonathan Cameron <jonathan.cameron@huawei.com>, John Groves
	<john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, Dan Williams
	<dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, "Alison
 Schofield" <alison.schofield@intel.com>, John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Alexander Viro
	<viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, "Christian
 Brauner" <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, "Amir
 Goldstein" <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>,
	"Joanne Koong" <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
	"Bagas Sanjaya" <bagasdotme@gmail.com>, Chen Linxuan
	<chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba
	<tabba@google.com>, "Sean Christopherson" <seanjc@google.com>, Shivank Garg
	<shivankg@amd.com>, "Ackerley Tng" <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, "Aravind Ramesh" <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V9 3/8] dax: add fsdev.c driver for fs-dax on character
 dax
Message-ID: <69c6b2ec2ea62_1771f410029@iweiny-mobl.notmuch>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
 <20260324003818.5009-1-john@jagalactic.com>
 <0100019d1d476420-6b0bf60e-3b3a-4868-8f5f-484cd55d4709-000000@email.amazonses.com>
 <20260324143927.000024c3@huawei.com>
 <acPX9T2ZF7xTCHtZ@groves.net>
 <69c407903b54c_130d6e1007a@iweiny-mobl.notmuch>
 <acVDCKeolpJM9qg6@groves.net>
 <69c5b7411999c_14003310089@iweiny-mobl.notmuch>
 <acXMdEKG7kO11OtH@groves.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <acXMdEKG7kO11OtH@groves.net>
X-ClientProxiedBy: MW4PR03CA0171.namprd03.prod.outlook.com
 (2603:10b6:303:8d::26) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|DSVPR11MB9766:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c3116ca-1fbb-4cc7-65c6-08de8c1efc66
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: wW6+DcFRjOolOTjJ5Fah+jLhP6CBW5LnGDskqYV8IZs4Xm4x8+R6fD4ptPD6nRTqxY8GMRAlUnQ1btnRuCuss5k/EhJkAZn3d4ikdnm6WD+ZEP8QnWYkmnSuPthbGHtwd/iDEA1i/kyz7gf2ntmeZAucrLXUA2O5XLDrLYCOuEjOtpfjCl8eMZn5KAUq2pGjgAG8HzVXwT1JsURDrUFm4jic6J5HJflmM65rfGW+jvjh6MBpPzz7U1s7BVgOvooHHlN1CXQZ8Bp4oA/QNf15exQpAr0suBvr68PbiDiSGQbveskzdWgtGBQ2/EgFHuB5gQ7pUV1P8Pm3GSNy2ckLMUliEF8ejR9PWvLsHq+0rb63cAsBqJFBYgv5t79pl4D0PMwQZW2+i0WUZF/NZvPQnT22/61TX7CNZQhyx2QwHGmOr5gDWe8LJRkhNCtqGSbqdB81bU5ge5Oi7T+UvC3vDAPzDEKeNezzL+iPGXv3r+apMw4pJ8wlw6mKasw5T4y86O9Zs2VpKCcJIYTpqKz9kfgX6Y8qWASCwDD67NVk1l/iWLpa7cVwBoGpyTQf7w4RAm+PyEfmM1wd/ErC5DO1tEYhNhxsJKY0KaZgg6wbD/1vm7PeL7OP7MZbTCpv85wOnkiWSfJn30AZU+OJhaR8AIk1XbrYAoJ7E75RAmqQPwyrUBoQo+q0GJcLVH8jnE856gTZVADsyoAAbizASPZlvt9beyBPn0Z1wIQUnF1ZqmM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m/e50lMVjxzLl0824AiYj/mYrra20HkXUDOPyb56Ti+6xfdQZKxe9nqwIm1B?=
 =?us-ascii?Q?ITxrHa4b6yndrUAgLID8tWBU3HwqC4IiClaMtwZvJTSG0htgTiYYpydEouI8?=
 =?us-ascii?Q?KHMvPpg4QkKXNJmjq5Usr5AmcCjfKv/y0cRWB+mJFgbCD7qVGNSWOlbtfSJp?=
 =?us-ascii?Q?aHxfznubYQKgqG/2c8m/X9K4J93h6uATnc7Kz4UvRqOV2fBVrtazfuqHEzTR?=
 =?us-ascii?Q?3nAw6dAkXUMqatsvtF5xXtT406p5vM2/2ggWgAtjZU7rU4OXGKBzhEGGCqKh?=
 =?us-ascii?Q?8LpyBRNQDX2zgZ9kJsNXJfEvj/9lYFdOfAnL2dHLrWCCEx4ef4fZYKp1kcEE?=
 =?us-ascii?Q?qvz1P1sRIppdK1HTp8NLrYREnnTOAIfxvddu1hk9xra/qieD3JfEHlPNDnuq?=
 =?us-ascii?Q?bHu5XPJv0G3vO34ALIvlpP/3N6g7Z9ftlIvmaUOw+Eq2ZcY6NijzTFwrlCb9?=
 =?us-ascii?Q?ucbKO4/sC8UGNFiM3WnMHFGWgaHwkQBJvpjPK5d4imBb1UErVQZ2P3gQajnt?=
 =?us-ascii?Q?eisO0IDlXDu7iy+gyt8eWHGDy2ICrV5eZ2BoFgay/IfXYY8Y0n9rQ0KCcEdY?=
 =?us-ascii?Q?Dw9aEsE23ZjCfEaoaAU5Dn1F8VRqtIVEGUdgHRZG8x73F3slBSEX96JOjK+Q?=
 =?us-ascii?Q?+I9pC8h6cEmWDC+dxcHqRJnZu2esMH0UE7uNNMsx4GoKbaNE2ZWCLiXe8hSD?=
 =?us-ascii?Q?zK5C9gYOlF+K2AN619OdTQd8o/qJvx+QBgan7QXEI0jOAheBEG896QQH1MuC?=
 =?us-ascii?Q?sW28WvkBBco29DNuDasjXHOz3GmDAKSpAR7+AkoT345BI379mgn1ehdwYjT8?=
 =?us-ascii?Q?r6vQpDgGFNV81m1uTHPDmm4IjAjThmq9/3s6Q12cM+zokSoAmEKIEjINZDJK?=
 =?us-ascii?Q?BvMg0PJK4sh+BM53eLHePZubA/cIuhtN5sMFl1ABBsOksjOVNAjnCoMBVRPw?=
 =?us-ascii?Q?/Cyos5zpUeKyB+COE1b0nM332kJ8uJ6UpOgAQcUQzNCN6Eprcb4iRMHOroX4?=
 =?us-ascii?Q?gWDlk5AbgXx1Xv8zKfBMIeh60sTMOOoh2kPeXVBgmMTlVlf5RE4fLYTxh1nI?=
 =?us-ascii?Q?45njmRMypmerb98WkLNTj9amMp+RhqN6tsyauXQ1zn/mQDqwjO3kj++9D4U8?=
 =?us-ascii?Q?oHvEb/AK6smAFfFQR9MqKKQ0Df44Tc1y/Ai7GdaSMTqJr3iZSNmalWx9UyPR?=
 =?us-ascii?Q?h4rUJLTlmznYhKJxc7TBqSJ6QcBWkVTLyM4vBK1yBEFEwXJJ+5JRQcmKog5X?=
 =?us-ascii?Q?8gl5Rxroy/hjPy9stCEM84mXEEb9ttCFn2QgshIpVrKf+aJjdQK3e8OlNvqQ?=
 =?us-ascii?Q?LZItYsN/Dmcek4/boh5qRF9gtdCdPWq9R6DKsw/tNrVBIhK2rg4ysCrMsK05?=
 =?us-ascii?Q?8iZcJWicojSd5fOYIM3GVc3TchRIBZzHHCPe9j2AcT9QWmo46LjCCMxM5sMu?=
 =?us-ascii?Q?Y/jSGzHZSGj4VzcYazWrCeBvQTHvMZyMjPV8kzv2/GD7sUN+ubH+XPQZRO93?=
 =?us-ascii?Q?FXyZJMHOpvUYC9B0QQ4kaIe+2l4bYd7Yvn0kL9vDs+vZy7iPwuBPXgJ00IQf?=
 =?us-ascii?Q?YDEPgn2FZsGVS/aOdFzA+RfVeDSRa8bdJ9LMWuLNI9l94TyK+1teG4TcMvdG?=
 =?us-ascii?Q?lNh/FH+QgtQ8Fd/7rGCkFX/NAmP6XsZFA/5w48lynLLhAVycr1L/Iu7wEx0i?=
 =?us-ascii?Q?37l+ugwCiU7ve4wmCjEH8SpgwgpwPxHZyBm2tapVGQIxhyXLc9sL3UJrOPtl?=
 =?us-ascii?Q?vcyKibABsQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: MvzUCHp4uAs5NQfiVzEEZ2eXrouZ2mKoTcQQcnRwPhTyFWgoUGILMwlymDJL/r/ycJgvU3tnttzizZ+kTlQTZHybMt9KdBpy0DXaeRVuoMaeiiyqbsmFRe+aQhpUU5PkwpO9aoMTR/UQfui7HD2mQ7DNNgQrFZ4eOopLJ4TfpTu559ZAdCpzpcm9yn2m0WdmO2x+o3exaz9U2rm9+ilGPVFE6WvLrBSMC3XffI5voDEC+S9q2NMwiKJ8quCBoXbLnHSjORjYD7VwvRV90SPQMwq+YnS8FZfdmumLVwEA2B86gJBvTVkhOo+KB+zO3MdVTsxt6FjDIfbbBJxAq/CR5w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c3116ca-1fbb-4cc7-65c6-08de8c1efc66
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 16:36:24.6926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DdjUKSp1BtTexkx/tFKzaZPusbISAEZ1YURH/I9RDoXjw1CNcOtfg5Y0RsnxCrx/mHt2upYExmWxxx4koR+MNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9766
X-OriginatorOrg: intel.com

John Groves wrote:
> On 26/03/26 05:46PM, Ira Weiny wrote:
> > John Groves wrote:
> > > On 26/03/25 11:04AM, Ira Weiny wrote:
> > > > John Groves wrote:
> > > > > On 26/03/24 02:39PM, Jonathan Cameron wrote:
> > > > > > On Tue, 24 Mar 2026 00:38:31 +0000
> > > > > > John Groves <john@jagalactic.com> wrote:
> > > > > > 
> > > > > > > From: John Groves <john@groves.net>
> > > > > > > 
> > > > > > > The new fsdev driver provides pages/folios initialized compatibly with
> > > > > > > fsdax - normal rather than devdax-style refcounting, and starting out
> > > > > > > with order-0 folios.
> > > > > > > 
> > > > > > > When fsdev binds to a daxdev, it is usually (always?) switching from the
> > > > > > > devdax mode (device.c), which pre-initializes compound folios according
> > > > > > > to its alignment. Fsdev uses fsdev_clear_folio_state() to switch the
> > > > > > > folios into a fsdax-compatible state.
> > > > > > > 
> > > > > > > A side effect of this is that raw mmap doesn't (can't?) work on an fsdev
> > > > > > > dax instance. Accordingly, The fsdev driver does not provide raw mmap -
> > > > > > > devices must be put in 'devdax' mode (drivers/dax/device.c) to get raw
> > > > > > > mmap capability.
> > > > > > > 
> > > > > > > In this commit is just the framework, which remaps pages/folios compatibly
> > > > > > > with fsdax.
> > > > > > > 
> > > > > > > Enabling dax changes:
> > > > > > > 
> > > > > > > - bus.h: add DAXDRV_FSDEV_TYPE driver type
> > > > > > > - bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs
> > > > > > > - dax.h: prototype inode_dax(), which fsdev needs
> > > > > > > 
> > > > > > > Suggested-by: Dan Williams <dan.j.williams@intel.com>
> > > > > > > Suggested-by: Gregory Price <gourry@gourry.net>
> > > > > > > Signed-off-by: John Groves <john@groves.net>
> > > > > > 
> > > > > > I was kind of thinking you'd go with a hidden KCONFIG option with default
> > > > > > magic to do the same build condition to you had in the Makefil, but one the
> > > > > > user can opt in or out for is also fine.
> > > > > > 
> > > > > > Comments on that below. Meh, I think this is better anyway :)
> > > > > > 
> > > > > > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > > > > > 
> > > > > > 
> > > > > > 
> > > > > > > diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> > > > > > > index d656e4c0eb84..7051b70980d5 100644
> > > > > > > --- a/drivers/dax/Kconfig
> > > > > > > +++ b/drivers/dax/Kconfig
> > > > > > > @@ -61,6 +61,17 @@ config DEV_DAX_HMEM_DEVICES
> > > > > > >  	depends on DEV_DAX_HMEM && DAX
> > > > > > >  	def_bool y
> > > > > > >  
> > > > > > > +config DEV_DAX_FSDEV
> > > > > > > +	tristate "FSDEV DAX: fs-dax compatible devdax driver"
> > > > > > > +	depends on DEV_DAX && FS_DAX
> > > > > > > +	help
> > > > > > > +	  Support fs-dax access to DAX devices via a character device
> > > > > > > +	  interface. Unlike device_dax (which pre-initializes compound folios
> > > > > > > +	  based on device alignment), this driver leaves folios at order-0 so
> > > > > > > +	  that fs-dax filesystems can manage folio order dynamically.
> > > > > > > +
> > > > > > > +	  Say M if unsure.
> > > > > > Fine like this, but if you wanted to hide it in interests of not
> > > > > > confusing users...
> > > > > > 
> > > > > > config DEV_DAX_FSDEV
> > > > > > 	tristate
> > > > > > 	depends on DEV_DAX && FS_DAX
> > > > > > 	default DEV_DAX
> > > > > 
> > > > > I like this better. I see no reason not to default to including fsdev.
> > > > > It does nothing other than frustrating famfs users if it's off - since
> > > > > building it still has no effect unless you put a daxdev in famfs mode.
> > > > > 
> > > > > Ira, it's kinda in your hands at the moment. Do you feel like making this
> > > > > change?
> > > > 
> > > > I don't mind making this change.  But we have to deal with the breakage to
> > > > current device dax users.
> > > > 
> > > > https://lore.kernel.org/all/69c36921255b6_e9d8d1009b@iweiny-mobl.notmuch/
> > > > 
> > > > What am I missing?
> > > > 
> > > > Ira
> > > 
> > > OK, I can reproduce that failure with kernel 7.0.0-rc5 and 
> > > straight ndctl v84. So it's not famfs.
> > 
> > No it is the fsdev_dax driver which causes the issue.
> > 
> > I can reload the driver and effectively change the order the drivers are
> > searched.
> > 
> > I can prove this with a simple print.  With my test system (where
> > fsdev_dax _happens_ to be the first driver searched) the failure happens.
> > 
> > [  526.564232] IKW searching drv type 0 ; type 1
> > [  526.564515] IKW searching drv type 2 ; type 1
> > 
> > If I remove your driver (modprobe -r fsdev_dax) prior to running the test
> > I get.
> > 
> > [   59.748171] IKW searching drv type 0 ; type 1
> > [   59.749127] IKW searching drv type 1 ; type 1
> > 
> > And it passes.  I can continue by loading fsdev_dax back and it will
> > continue to work.  If you are getting this to pass it must be because in
> > your system that driver gets loaded first...  not sure how.
> > 
> > This is with the same exact kernel just with your module removed at run
> > time.
> > 
> > dax_match_type() needs some other way of matching when the fsdev_dax
> > driver should be used.
> 
> I think the correct answer is that fsdev/famfs should never automatically 
> match and bind. Weird that I haven't seen it do that (or maybe it did but
> I didn't notice?)

Agreed.

> 
> If one does a mkfs.famfs or 'famfs mount', the famfs tools already try to 
> bind fsdev/famfs mode if necessary and fail if they can't.

Yep.

> 
> > 
> > I'm not seeing a clear path ATM.
> 
> I do, but I need to test it out. If it works I'll send a v10 patch set
> in a day or two.
> 
> Also, I am definitely seeing ndctl/dax test failures from the device-dax 
> and dm.sh tests at rc5 with no famfs code (dax or otherwise) at all; I'm 
> puzzled that you don't see any ndctl test failures in that situation. If 
> I understood Allison correctly, she saw something similar to what I saw). 
> But no worries, we'll get it sorted.

:-/  Ok I can get dm.sh to fail with rc5.  But it is intermittent.  I'll
investigate that.

FWIW I'm not saying device-dax does not ever fail on rc5.  I've not seen
it though.

But I can definitely get it to fail with the procedure above.  If there is
another failure it would be good to send your log with a report and I'll
look at that separately.

> 
> If my strategy works, the next version won't ever automatically bind fsdev,
> but it will be explicitly bindable via daxctl or famfs tools. Famfs does not 
> need fsdev to ever be automatically bound do dax mem...
> 
> > 
> > > 
> > > I also studied the verbose logs trying to figure out if famfs
> > > could cause it (while running a famfs kernel and ndctl), but
> > > I don't see it.
> > > 
> > > Then I tried non-famfs kernel and ndctl and it's the same with
> > > or without famfs kernel and famfs ndctl.
> > 
> > :-/  I'm not seeing any failures with rc5.
> > 
> > Also I'm not running with famfs.  Just the dax changes.
> 
> Right - if fsdev ever gets automatically bound instead of 
> drivers/dax/device.c, that's my bad. Weird that I haven't seen that happen, 
> but that's why we review and test :D

Sounds good!

Thanks,
Ira
