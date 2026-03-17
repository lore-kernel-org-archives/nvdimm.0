Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2533834753D
	for <nvdimm@lists.linux.dev>; Tue, 17 Mar 2026 02:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773714991; cv=fail; b=S3d4ZA771goieKyiwQ119c0Vr4/gECDPGpUQll4IQzVz7z9g6YNOpHIQXfJeAfLvU9kNhk+Yaq0DBPGJ0fesCnRB7cQhebanmfZWOxzPT4BHoCRO/6lbIQ0YMsCndmn5arEms2ar2N/sUkc02wyynXCXMIonus/VH40m2iP2FZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773714991; c=relaxed/simple;
	bh=7WFHQFH1509JgutCiR4JD/tTw1wp2b63G9wip+rGLOQ=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=HCZM/2RPP0EnRxpgg44m8erSDXOlNmSVzJZUvfyS+6Mw6jlC9xi44OX7FhncZpHbgzxzXPe4pb53J6E5RKR04LpvD5i9bNpmuReCa57CvuU8Ay5if2J9aiSEwlgtKCZDKjSVPJVds7SjCkDAD55+xDp/PwYAXr2sYCkoFCa4X5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CxuXhiem; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CxuXhiem"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773714989; x=1805250989;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=7WFHQFH1509JgutCiR4JD/tTw1wp2b63G9wip+rGLOQ=;
  b=CxuXhiemPxV9CKCtjGql88ahBhAGXI7MaIlW9HYgwNi9KySK0CdqkHLZ
   2CU6opCMjblHS9Sunn7hWqdQZ9IS/f589/6ge9SQdYfE9FvGRNY+OCAwc
   o+2JlgJXGQXIBnKd1cNofQrYSMZu2dDuFWZLvICNUhwObLzfxTuPxd2GG
   GJJKFvN0jvVCy5qYxiLSijyGAik49VYWQuW/5REFNXR6JTRArUfRQ0s7i
   l/H/NbpHXVI++k7WFSIwJEk8CgSdF7m/oPcSR3GziExmiwPuYyTtPYiLj
   uHNpolmzQm9uOJ1DgFIV4C7QGiQKRUQHub2OI4vUj7NFjTfeVoA6vikp0
   w==;
X-CSE-ConnectionGUID: XGkeBX29TDa+i1ATWfKj6w==
X-CSE-MsgGUID: vvNnJ95KQm+XesxSupP+lg==
X-IronPort-AV: E=McAfee;i="6800,10657,11731"; a="85437648"
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="85437648"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 19:36:28 -0700
X-CSE-ConnectionGUID: mQF0VPWwT4uYa1Yz1m4WgA==
X-CSE-MsgGUID: VB3Nwuj/SsiwLyy4LbM8AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="227091205"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 19:36:28 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 16 Mar 2026 19:36:27 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 16 Mar 2026 19:36:27 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.45) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 16 Mar 2026 19:36:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lsbNQM9OiR2DKsBUxllq2/K+S7BqHVEi+yW9dUSk4M8P+1OvOWp2+c+T7fTXTx/zT/xuRFt5EYauvrgBMzuQ941wmnEkZunwxKQbJxc91D4AKysgNcCzheUPDpxG+5v8eZp0jAVQTmt9Dkam7czhycTPjwhUqy8NZ/rxyW5w425x9izjzKuNP4h5TTMgjirpQXg0ocqMptqpdngY3zpgsqRT6CKoFltV8y77AMijAQAjUiWWyubQAUr/KjZR70guEDgM7daCr+UsoJ2lXzVEHWzvK6MoWw/rO241+yo9/K2/GwkcaNKvCvMben1KuBiEAk0sYXL8bL+S30C9Z+MiDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QG2U2icEWgeCGCs23m0GDNixkaks4GoY1F4/HY6b9w=;
 b=c1+s3cUxRBXRHtEc57/3lgodkoJ01s+FX77DWbXMQQ5KGHjiJxw4gOTA5xjI6nKNe+wta69qYeh5u3dXuHMhPL75w0y/DGJFTndUrpzaiq7GGrsNJySSSIGi9mYxzCTCmlG2FoHgmJFYZQq+n6oS59JbhM05nKXwHvRMI739id8PDCpUvqUjIZRJKd115ZWMKY2yAw4meQB2OoSr1zJbcg2B58OYH2IiBJ1Nq9Oayza4Bp1cVREq9a5ZpZlqfgT6NkLyFFt3+4zTBLiLIzzsobpjp5z5UcSk/zgo5WEJIG65CJjFL5eEDg3i2bdfXNNhvsY8dn9s2N4mfrd0c+ktDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM3PPF1FCD3EAF0.namprd11.prod.outlook.com (2603:10b6:f:fc00::f12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.8; Tue, 17 Mar
 2026 02:36:24 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9723.014; Tue, 17 Mar 2026
 02:36:24 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 Mar 2026 19:36:22 -0700
To: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>, Dan Williams
	<dan.j.williams@intel.com>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-pm@vger.kernel.org>
CC: Ard Biesheuvel <ardb@kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, "Ying
 Huang" <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Zhijian Li
	<lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, Tomasz Wolski
	<tomasz.wolski@fujitsu.com>
Message-ID: <69b8be262e5ca_452b100c8@dwillia2-mobl4.notmuch>
In-Reply-To: <80bab312-7945-4579-a369-380d7094bbb3@amd.com>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-9-Smita.KoralahalliChannabasappa@amd.com>
 <69b224bf2fd12_2132100b8@dwillia2-mobl4.notmuch>
 <80bab312-7945-4579-a369-380d7094bbb3@amd.com>
Subject: Re: [PATCH v6 8/9] dax/hmem, cxl: Defer and resolve ownership of Soft
 Reserved memory ranges
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0099.namprd05.prod.outlook.com
 (2603:10b6:a03:334::14) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM3PPF1FCD3EAF0:EE_
X-MS-Office365-Filtering-Correlation-Id: a2e91e38-149b-462f-23e3-08de83cdfb32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: oXAIz4wIQjNWAVHSzbT9GJrEMIZQDLv8tLMX384+cd7cpIl9DiPomaFhFYQmKhDq1wK/5SFR6Ai/NQP/uNNg16UDTeWFNgzz44gYUwgqpBqUj7m5PB9uASz6uycJzEVUOQW3W+ORWHJw/AieeMd092aLt+x9evxKj67h4vzuvxe9APs9EylIfnDTtcX/HTM7uVmgPNITraPRdps8935hazeRNReU4W8Ij8ScVOtWU/ulyR0APjJ15KLhT2x7IsvhEWLDGjgoUqzh9YzCrVKqPYVX4tUzTVhQ6/zlkH19wsPzLdSkSvAYbeIjavzKY23oAG1TNUWF8GJ79fojeSnLtCmTN7zc5GA3i+vOrxRL1IO9LkOKUHesUeDq6NlVchHlUh1TOYYeLBg+LbrnkJVnYCxmYpnNpoYe7XNsc0AklSrWhkzipHWxjCEie9qKnBOzIsvP/9yDWE9CSb9cbzy6qmN1xq4FJvz7I/mhDeohMdOOjrDAw9nmRDEt11aQHl9zIxAwk5/1Jbqem5bKnKg788FreTGJLCusJmgqJloYcGWXfVqFyuKWZxXsCOg0eqe3K866HdGVbN5qghxttQRZj+ArUb7DvwmaLwncYI9CRW+UMTNWdW9v3aJyPBt9Bqqpexv+6p65c3JfERXUrHWWVj7wfIGBC0sRfpRkHPf4lhLhlNjL9xU1taaUsUtyMfZSxZKJbxHobgKM/kOi+UdtzL0Bc5W2tC06qH+rpYW8zgc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjI3ZzRCV2xSbHVPdXNPT2t6UjY5NDVWRmc3T1hGTExzT3RCNFJIM0ExUHUw?=
 =?utf-8?B?dFJtdjBXYmloTlk3SGZFYzV1bzhYaWRSaXMyVkFVNHpMWHBVcWlWMUcyd0E2?=
 =?utf-8?B?THVDNmNiWUFyRk9NdkFkZEoyRTN5RHpXdmZELzJ4TlVVQ1grTzVxVHIrRW13?=
 =?utf-8?B?ZyszNFpWT24xV0hNODZoc3JzTHE5ZjBFbGNuRDFUZ0ZvOXl1dHRmbmFvc0I2?=
 =?utf-8?B?d1pqL1ZwcDI1OHVxTHNMT1ZjRC9nN3NHQVVxaU9ReC9QVDM4OW9UaGtJTXgv?=
 =?utf-8?B?RnJTVVliaCtJdWpmT21UYVRld2l2SEczQ0V1NzBURmZFdU44ZjdFczV4dnVZ?=
 =?utf-8?B?UlZVeGNMMDJNZVRmUFNZZGR0NFA2Mk5IU05ZelJTWk5XRGhjL3RuYWd1NFQ4?=
 =?utf-8?B?MWxlQ3kwUWRwQktPZHRnWmhVc0cwL29BejllaStsMDduSEhmS1Z2eUZ5eXBr?=
 =?utf-8?B?bHZYcUJTN2N4bmFiOGdoMDUvNjBBY3NIN0luQkF3emNZUHR4NFpqalpPUXho?=
 =?utf-8?B?blRxZnVzMlYxWXlPRXB2dDlSMDVYbTBFZm1wdHpWbUx4ejN6ODdRdnJtc1Jz?=
 =?utf-8?B?RjBXSzVUQ3c4RjF4U1N6djRzcFBSN2g1TExvWmZGb2JKVmF3ZzVleC9OdmhC?=
 =?utf-8?B?bFBFRXVjUGtqeFA1QWtOdG5Va2t1ZVpGN2VRSml4TFhkdlBOVXBQOFpmSW4v?=
 =?utf-8?B?ZHY3Z3VDRXdPMFZZKzk5eC9ROGp3Q1FSUWpRMVREekgvYks1b3ZKaW9tNEhj?=
 =?utf-8?B?QmlMRUhiOTU3R1d0V25NaWxUbXlEQ0cyVCt3QzVSWEhDSFBnbzBHVVhDSmdW?=
 =?utf-8?B?ZTB4dHlncmE0Y3JuNWtmRmV6cGNsVVlraU9uM2k4bXlpVzFpbUxidlpqRDNS?=
 =?utf-8?B?R0dNWEFDTXdTTVpnemtDNDRaYkIyNnZycVptRi8zTHViNGNnQmhvRE55ZU9y?=
 =?utf-8?B?R1VjRmJPUGNVdUUwODRQcnVkMlFSVU1kdElhcEhUMDN3K1NyZmlnNGRkbCtI?=
 =?utf-8?B?QkEzTE9na2p3S2ZBcjFNNXErbzBrYWFrd0hJVFpuOUpBY0ZxdWtmYUFoQ0Fx?=
 =?utf-8?B?OG96UWRPNmErWlhTMFJYTUFRaW5TdkVaRmFnYmJoWkM3eVh6RUxma20rUC91?=
 =?utf-8?B?QVQvRFN2dHZHRDVydXpFRFprMDhrNSsxNVRmMDVjMEZnVVlSSHhMRzlOcWlp?=
 =?utf-8?B?R1FvU3l6cEV3ck4zY01qZmVVci9oMzZQZ3BPdjU5YWtobjFGVjNMSXlJcFZk?=
 =?utf-8?B?dDhmVG1wMjROdDNZVWxVOWRHTEplbEpiY3M3Tk9Kb3BSMWVQVStxSElnVUN6?=
 =?utf-8?B?di9BK3RKRUlPZExPZ0xNNXdMejM1bVF2RlRzTXV2WUZPNnA3aVNtcXZLREJ1?=
 =?utf-8?B?ZTJSdmFiL2FqSkREcHdvd2NKcXR2cmRUN0dmWk5UNC90dkhIRFlZVytleXpE?=
 =?utf-8?B?dVVTT05qSjVtK2lhK0l3eWUyRUN5QkpaV1J3V1ZUN0lzRFA4cFJCd0pYRHN2?=
 =?utf-8?B?VlNSdyt1dCs4QytWTDFVTmQ2OXFCM05rYUIvVTdPWkRGNXY1SXBOQTY5ZEY2?=
 =?utf-8?B?VnppTkYyR09CZGw2OGg3Wlp3WlFCMjJjb0pzZVdoNmhOc1BLOHZETDk1TXB4?=
 =?utf-8?B?R3VsVEtHQWhoSWpyK3lNcnFBRDRsclU0ZDl6SHVPSUVPejlwczhXNEIrYTRC?=
 =?utf-8?B?S3J4MEFYWDI2ZXd5Nld6aXlHYXdVYUFHeFNJekFzcjlWa2cvTEk0T0tLdXgv?=
 =?utf-8?B?N2ZPZCtjeUZERFBuOFNxSDNGYjdWajBDQjRUeXpkQTRPbnUwTHR5YmNpVkVO?=
 =?utf-8?B?ZS9MdkVUTEtidHFvblAwaHIrb0hISmNZWHVMSmttSTkxR2dSS0o1NFlDSE5o?=
 =?utf-8?B?bld2Q3Q0SnVKZUVPWWxyVGU4WC9qV005UWNROFZKRmtxL1c2Yyt0RHV3WC9Y?=
 =?utf-8?B?S3AwS2tVZHEvejlTUGZydmFTZXJyaHRPSkMrM2FPdUVUUU1aNFdWRmM0aGky?=
 =?utf-8?B?WmoraVkyNHA5SEIzYUIvR3lmQkhvQVpRK29pa0puVmFjckpPOTExZGxZQWc4?=
 =?utf-8?B?R1hxZXpNa1J6T0gwUTN5c3dRbnpicWZtVTJrOWZKTVRIWGN1NmhmUzhvUFlo?=
 =?utf-8?B?RTB4eHgrS0ptajJ3VDNEWmp3Ui9GNTh3Y3BtSWRxZ05VQkVsQ3JsQS9vTXdB?=
 =?utf-8?B?cEo3QnhsTFovSTBlRkF6Ulo3c0RaZXkwR2tBK0M2WUxmRDNWNGs3Zk9SeDZK?=
 =?utf-8?B?bzRVLzltakllcWtOejZma3lta2VjeGt5MWozSDVGQlFiWlg3TUhWTkV4Q1pX?=
 =?utf-8?B?UWU4cDJvZ2lWL1o0S0RyQkx5ejJxYU5UdzVwSGZwdGtSWDlKVWVTSmdJQ0JB?=
 =?utf-8?Q?imDEQWFyUAdAUNQo=3D?=
X-Exchange-RoutingPolicyChecked: NSMpXZNP2rHY+JMEudJ5Oyy6GJ5O6/PszoY3UPn9JkWYWzfVU/p7dChxafMUdwmQKowqCeP6m3bF4uAL0M8dGfeW7ejk0nOMP0RlzR3Ob7O4ZdIYcOBKxGGp8zJxCPt80+1XqCvq+ZAG7lrTG0Ps/xN+jhuNHYHMvjLE/+J6Or7G+OrzoE38ezPa5K9YbfPRwa62i+UMT16yn3wGItD2zKATT9Q8AwiTcrEnyDao8VBCL8llT+TtaU5BpSNnL3g8IjWmlV+vHRWy91WakErNPZGjdWVXS0BYlK9xy+Jkcq5U9gh6xp1FniIfUPcGUVLkJv8y6S29vSWrkfkU4kL80Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e91e38-149b-462f-23e3-08de83cdfb32
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 02:36:24.0692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0r4w+ZPI1Qtn0FdMb8GNtvs4r1LsriNTgP0tasmoqHNz5YbFR1g5LKsTy4/JcYwKdI7sOdlu94zNE2Q4Kyp7tttJMUSCFaIGU6UsuI1uw4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1FCD3EAF0
X-OriginatorOrg: intel.com

Koralahalli Channabasappa, Smita wrote:
[..]
> +static int hmem_register_cxl_device(..)
> +{
> +	if (region_intersects(..IORES_CXL..) =3D=3D REGION_DISJOINT)
> +		return 0;
> +
> +	if (cxl_region_contains_soft_reserve(res))
> +		return 0;
> +
> +	return hmem_register_device(host, target_nid, res);
> +}
>=20
> +static void process_defer_work(struct work_struct *work)
> +{

I think this also needs:

	guard(device)(&hmem_pdev->dev);
	if (!hmem_pdev->dev.driver)
		return;

...because you can remove the driver while the work is pending.

> +	wait_for_device_probe();
> +	/* Flag lives in device.c */
> +	dax_hmem_initial_probe_done =3D true;
> +	walk_hmem_resources(&hmem_pdev->dev, hmem_register_cxl_device);

Even though nothing deletes the hmem_pdev device today, I would still
keep its refcount elevated while work is pending.

> +}
>=20
> static int dax_hmem_platform_probe(struct platform_device *pdev)
> {
> +	if (work_pending(&dax_hmem_work))
> +		return -EBUSY;
>=20
> +	hmem_pdev =3D pdev;

This wants to be initialized when @dax_hmem_work is initialized.

Otherwise this makes it look like @hmem_pdev can change dynamically. It
is a singleton.

[..]
> A few things I want to confirm:
>=20
> 1. Patch 7 (bus.c helpers) drops entirely =E2=80=94 no register/unregiste=
r API,=20
> no mutex, no typedef. Everything lives in hmem.c.
>=20
> 2. enum dax_cxl_mode drops =E2=80=94 replaced by the single bool=20
> dax_hmem_initial_probe_done in device.c.
>=20
> 3. dax_hmem_flush_work() exported from dax_hmem.ko so cxl.c gets the=20
> module dependency for requirement 2.

Looks good to me.=
