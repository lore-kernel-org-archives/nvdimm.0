Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB481F130B
	for <nvdimm@lists.linux.dev>; Mon, 20 Apr 2026 23:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776727050; cv=fail; b=ELITek9+5+A5NUhCNevQa+eS608amD4bFEvNisxKi+O9PuTx+p7EFma8yzSCySnLoxobvkK3/rbgTOCLvTv9ZR3kmAV0bvTk7DM1sSZbwfhxXODupa8yi2luok4hLQj9/fNDyRJc1cpIo2K7B2Y32SAzg3eSWXuwa13jNjjtVDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776727050; c=relaxed/simple;
	bh=TB/BCMK7N+fjr4DWUUwLTAOIfoOl4M1JdG9PZUwo/Bg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lbs9WLjaFJHamu27COZcC9tBIzJII473cpPCUEXamvv3u0htgWVIxt7QXUWpMNdwRRy1IdhNif69YTBOEX23gmg/eqiUGwhy6IXozZIyg493S8Sjc2pBGxkaqRJtaVjS1vbx5VmrUBfDxVxj9XFOANsvmCW1OVb/jBy7Gvy73Sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AF2X/Lb3; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AF2X/Lb3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776727048; x=1808263048;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=TB/BCMK7N+fjr4DWUUwLTAOIfoOl4M1JdG9PZUwo/Bg=;
  b=AF2X/Lb3GbBCS82ENJ+AShhs+l2zqx1J10W1DwIwAvyKp3euDgv+HK0v
   KZt5HiNbtjKQXQRAkSIK7Ml23oKv2eWlFLkiHPw2bbrc+7K8qmNhJKKmV
   LvXlvXKEYkemgy/yGXlJe2zFqww0EAoiLxpzuFmku7As4u6oszHddrdBC
   UQdkb8grFX/yk3i1HYjeD/cgMO+IN6q6ct0k5iBLJKWMnmSjM/SKnrmGv
   ug9ffWYNMPW5fxzydioUvWW9vjHRYdWzGQ2cVf5w2HLnss0FZR8zN+99E
   9m2SaBV5Y6lIURs9VVC2KHFQmqhIJ+dW/Jd+DJZWeHa1LbFraI+gJF3g8
   w==;
X-CSE-ConnectionGUID: hE8zozcTTGuOpveibHCw/Q==
X-CSE-MsgGUID: GcXg2EnCQbGHV9F83oyfCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="89029632"
X-IronPort-AV: E=Sophos;i="6.23,190,1770624000"; 
   d="scan'208";a="89029632"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 16:17:27 -0700
X-CSE-ConnectionGUID: q998My9/S/KBvp5Musw5fA==
X-CSE-MsgGUID: HkIPCggqRgWop6fUdujYAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,190,1770624000"; 
   d="scan'208";a="227525986"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 16:17:26 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 20 Apr 2026 16:17:25 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 20 Apr 2026 16:17:25 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.57)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 20 Apr 2026 16:17:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ep23xy0UU6RQlGkJNRJVJ0PN7WWaLsUczDFGsFEf6riTpbOn7BRd6jWxqoHSW1XQyytF6BN9mZRHAdFiuwN3b/BKTJCwMc/FUO7OrwF+P3dk8IgUAbcn13Rzce062gzfHm3TpOuIffffzgVJFq277hzZ+CX7mqEMXArxNxOkpPIG0lHZwfWzbjfhUa3nyVrMSl9MS6mvXvU0qbS2m/22gRJ7wGef+dG8eOSZLdD5ANP/GhspJVH7v00+XL8ZYP1Iouz18nZ5zspClERFtn/CcvQ+1qn0axDHDlH6xnojSLzpWGPXSjxU1RxhE5d6Hi91+Ffix++WnZZK8JoZwYwb4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=siJfWTPpgxMjJVfRib7JItNFHzHigA0puEOA1LJjIHU=;
 b=ltN+yMv5u7qEgVqXdnk+zuWWelPwh2YLV5V838uCbWbbPVecwjJj8l1+Tqp3As86bCJUEpHJEgRPHaB+iMWnkIdbwTsveq9yiTYBV7eTWnwHsr0Kmm7OHqgt0cmO85RxRFQd0rioIGyAVJxoyU23dWbPEJ7o7bB7nhQvXdpvlquK49JCZHmP8DSs0mQL76qu1td2oPmMo/bvrXGWNP5g/BlVqKqunBAj3vUTtGn7GHBtqmjqAe55YUcgiep8tZvEb+/O+ENZk75KXAUA9yLAl1SHHwBIbBg5kqrYEwXURXyHpI1OsgGxH5+iUryET58l0gqEDTnOWTtasG9mCOc1Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.8; Mon, 20 Apr
 2026 23:17:21 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9846.014; Mon, 20 Apr 2026
 23:17:21 +0000
Date: Mon, 20 Apr 2026 16:17:09 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>, "Dan
 Williams" <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>,
	"John Groves" <jgroves@micron.com>, John Groves <jgroves@fastmail.com>,
	"Jonathan Corbet" <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan
 Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, David
 Hildenbrand <david@kernel.org>, Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi
	<shajnocz@redhat.com>, "Joanne Koong" <joannelkoong@gmail.com>, Josef Bacik
	<josef@toxicpanda.com>, "Bagas Sanjaya" <bagasdotme@gmail.com>, James Morse
	<james.morse@arm.com>, Fuad Tabba <tabba@google.com>, Sean Christopherson
	<seanjc@google.com>, Shivank Garg <shivankg@amd.com>, Ackerley Tng
	<ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, Aravind Ramesh
	<arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V4 1/2] daxctl: Add support for famfs mode
Message-ID: <aeaz9TecrINXaHcR@aschofie-mobl2.lan>
References: <0100019bd34040d9-0b6e9e4c-ecd4-464d-ab9d-88a251215442-000000@email.amazonses.com>
 <20260118223629.92852-1-john@jagalactic.com>
 <0100019bd340cdd5-89036a70-3ef5-4c34-abf8-07a3ea4d9f92-000000@email.amazonses.com>
 <aaD6yQLiyZznfAxr@aschofie-mobl2.lan>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aaD6yQLiyZznfAxr@aschofie-mobl2.lan>
X-ClientProxiedBy: SJ0PR03CA0292.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::27) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ1PR11MB6180:EE_
X-MS-Office365-Filtering-Correlation-Id: 46b628ec-9ce0-4673-9021-08de9f32f8fd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: Jnjpg5vqNiE3bq3JOULO8nq5frXw86E7ttudNrWwWzyjbUtQ6dRV8p/EitpsyiihkhsbXFx8qlOTW4EsFI3sYwJJUHf453hy/PvHGZASXC/UNHAhhA02MH/JfU7fr2gHMYQAgU9FbZKLcp6xuCZquQZtdfLA8k1L0htCEbemUhBlXclIlmDwc59sg3Wwizj6UgaB9joEp09MMfD0GWjk/rmZ3q8BABpDRPHxXAz4C4zjOkV5nmqidWYJSfdOBTitr+BXV8sMQIVLjL1NHcw82bMCFKxA8lZ5CVrUCJU/g6F7t8n+S3v/T/+6b0XRcgn3BRiHNlU5f31Q9tnLZ76SouLx7M5YlZ1cIkDJLjjfVoKKkAZsJ2p/lCLRlyB8MtfNZnTwyycIYMpKAuA+Mqy/2SXQHqXtT4qMgPc58iKoVsD1CAgoyhM2i91KvEubqiXlRtsw762uBfP6NKnKFJ8WIOoNMfqAL6T86skNXAeGSp2iemXUMRIVG7hZ4rLRDlyhYxjp++JkyrkM7JxcGXiixnKZ4IIEHVKWDZOByWDaqduPTQBoIROZgXH5X29iuhw13Bvs9FFZc5QtYSVzufSWcj8Tdshr2zpKO/inKj65bQ+OCf0JGjmgL4mXadOSqPU001B0fjVKRamzR28cwlB4Zw6HVsd/dcjJs124okEMG590A2jZXW4f7sWAcsI1fEZKAk+ilgdTg3IT/a0GeqDgeyopexIysUAl57ePrP+UdtSa9l8rKnUq7KYdb3BNTle9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3NqMnZmKzYzU0p6MzJYclB3R2VkMVI5Wmd6U1h0TWxlK3ZuT3lCTnRqTEo2?=
 =?utf-8?B?Z3BZZ09wV3N0NTdHY0VqNGZvQ2RJTkFmRnp3WlRqS0oxaCtERjlTODBwTWhC?=
 =?utf-8?B?Sm5GZW80TjdXbzVuWVAxZE91TUVFODFVTlBIN2ViSVcxQVZoVEVEOUxTdWVt?=
 =?utf-8?B?eGkwR0FtK2dEUDdvVVArVWs4QUNWZjRQQVo1YkRONkQzVGI3TGhreVd3bmtn?=
 =?utf-8?B?anMvU2dBMUpLUGgxZGR6UURJRHBqM2lUWVVYMVFzVDYvNWpVa005dXFrWFFj?=
 =?utf-8?B?OHRKZ1FwY2xnMlBtWVJJdERLUTBndEFaNGhRYlorL0V4ZHI3bzg0Q216dzJi?=
 =?utf-8?B?YW9aOGNTMHErYkI4Qm52UFVhdEZ5YkV5K2hmbzlPMWpaTWhxaXh2SEFzOElp?=
 =?utf-8?B?UUZuYW1qclpQK1JGS1E5SFVWT2lvS0ZuNTh1UU1rTklaZXp4czVBcFVjWXM0?=
 =?utf-8?B?eTN2dGFkZ1Awd1B3OFZJa1B4cVdydWloYWpKdE5zZkdiNlp6NWloWGdURVAr?=
 =?utf-8?B?THZTK1liYnVQblR1Y1hyZ0FmNlZ2eHU4Q0h3VnZGTWpwQk5IZmFCWnJFM2pM?=
 =?utf-8?B?clNBSDBCdUlMY0c4eDBLUm5Qa3l5UTM2UnZ0TTJ6aVBXTzhsSFNPY0hpYmZn?=
 =?utf-8?B?QytJZ2EzYUUwWWxzdEtjRytWMlBRRTNOZ0ZtZkpCd3N1djdVdEFpRm5udkF2?=
 =?utf-8?B?SHVxQW1kWjNJSlRrWkJ0M1Z1T3MyN29MTEtGRGpvWVdSY1kvRUk0Rjh4UmtU?=
 =?utf-8?B?OHp5OCtWZEdjdnFjVWFuckZCVGNiMEcwOVR2TVRuVEJEVlg0VEpSQVhFUGJI?=
 =?utf-8?B?T01YZmVSanFzMnJXVlF2UmhjcTFoYlZmUmlqbURtM0ZjcE8vVXlJVWd5ZnA5?=
 =?utf-8?B?cWdyTVgwY29oNzhnSWdPNXhEWTh6WkZETk0yUFMzM0h5Y09ic3Y4aWpwYVph?=
 =?utf-8?B?aG96cjdPbHNUekF3bkFuSFNJSUY1ZlNBSXZMb3lwZjV5N042dXVIL0VHTUkw?=
 =?utf-8?B?cG1oamlyemVJSlVVZXFIY3B6QW1WUDIvWXBnb3NzQjNlQUg5b3JVL0Y5eGJi?=
 =?utf-8?B?QW9WVlNRd2E1dWhFLzZPb0g5STIrNEZuOEdsVXhwT1lxUEhlM2VuWk9rSXcv?=
 =?utf-8?B?ZWNWa2FVZFVUTjVyT25wcnJWM0cyZmlGbVlVR0NqZFhTNk5ncGtTMTVZZ203?=
 =?utf-8?B?NXZuOXdGTGlMd2dBTVVvNmkrWWI2cHlUOGtQV1M2NVh5OWdnMkNoWWl0ZXRo?=
 =?utf-8?B?eTZENjB2V2svTVU2Z3hLcE9CSlU4NHFQMTZLcFZ2L042SWhkUmc0RXVNTGp0?=
 =?utf-8?B?S2lLLzdYUE9xSUlVcXhIWGMrYjRPc01zNUlZc1puS3hSU2VkR3AwL042ejU2?=
 =?utf-8?B?NVJSbXhVN0tUSVROVVJLclMrVUpTM3VMbXdnWFNIdURGQ1N3Rkc2WWkycWl4?=
 =?utf-8?B?Y1FsRUs0bTFBRzgyZlN2SkVqYnAva2xSNHF6SmJLVTUrRzNCRjNCdy96K1VP?=
 =?utf-8?B?WWNWT2s2MEpQVXVCaHVPdHVEaHNCcTNaVzFSMUh0Tm9tQ3FGRmxzODUydzQ5?=
 =?utf-8?B?RUFpK1lUUVBZbG93K3dBaHFsMUNhc3VFUjYrc1JJRkMyNHFCcUQ0ODU0bmI3?=
 =?utf-8?B?L3NPWUFHeEJUeXJRN3U2WlhaTGladm5xam01bnIzZS9hWkFHSkU0bk04UXJY?=
 =?utf-8?B?RThjUlBlc2dUZEhaWGcySXlSOTVxMWNMZGVBa1V0b2tNN1RsbnBUNWc3VXVn?=
 =?utf-8?B?R3BuMHUzSks0eHd4bVNRbGUrKzRuZlhZVTdhSzlhOTl2SHMyTDk0N25Fb3dJ?=
 =?utf-8?B?UnRVT2tDZWtXNFpDNlhvRFYvUXN2R0QrUmJ1ZDFPQWdnTXZQSG9SL2hxUHYy?=
 =?utf-8?B?Y2JicWdDVlNVbXVpb3BkWlBhM0g3YXVuekNGTGZPeHg0YS8vTEFXajExSSsr?=
 =?utf-8?B?dG9QR0xxQXl1elIxRFlHKzREUmhMUjd4bnVBN0ZvV3dSM3k4Z0ZlUkxTQ3lk?=
 =?utf-8?B?V1NEU00zTDlIdU8rQXo3YXMyVmpnRkRSNGdiWHp0MVFwVEhCUVlNT04zSjFt?=
 =?utf-8?B?a09HK3FYKzBVNUtsbENobWtxc0VhT1NSOEM4ZXZONXZ3YzdWck5VbVVER0lO?=
 =?utf-8?B?Q2tPSnZCNGlsUzg4N3pRbWdHbWxEejdjVEVRWWtVbTh2d1NGdVhOU2tOL1E4?=
 =?utf-8?B?ZzZxdDRscWllRHJNeGNLZENVYnIrL1dQYWdoeEZZS0V6azBuS0wxYnZ6endG?=
 =?utf-8?B?YmxQS2RKUUNJTjdqa1JoR0JLcTJ2N0diVXVBeTh1Z3ExR0VlZjVEazUybXVP?=
 =?utf-8?B?VjlZZ2R3L2g5SWtUZ0h4TjZ4RmZUbk0xVlQxWjNWK0JLb3FPYVI1T0tVbFZo?=
 =?utf-8?Q?j9kherq7JTOqiNsA=3D?=
X-Exchange-RoutingPolicyChecked: UtQukaajIKhYeCRfEccz1whIE89gjOtTg1YW2/5VIHGQ0rtQEUSVgl++KR8yFZINoRYaexSeBi1csWZAguCvW8Y6XzTeoF3/0Wz/MMysPaVyJfOpaJrOGTLVR1OUvve2cBgSXvs3vuNjEedgWQy3YieyXyuPxzESHeAFLQpcCkn9fmrPa6nZai7ZrxEzu/JOvfe5m8YWulPpFOgDwS1wIG8i080U91QS2yDDEWGJTlwNjhuxN7ZvWpzpDzaVXc5H1TOuqjpvkHrViUqO34n4Y1GlngvLTuQCk/A7WfdOmtnLJHu3+hrK+IAqCWPiapTArk/SBOP0CZ+ohS+B+rCSGA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b628ec-9ce0-4673-9021-08de9f32f8fd
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2026 23:17:21.0867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jCL5AtockpYWWK1zwQ6mfitaWUnj4mwHAIrj7iA06kYF2HcWyxVSK02S+Srivr5jc20rV2fkRSWr47oSGgQf9k1ZFWB0/RpHWttzeqsbltk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6180
X-OriginatorOrg: intel.com

On Thu, Feb 26, 2026 at 06:00:41PM -0800, Alison Schofield wrote:
> On Sun, Jan 18, 2026 at 10:36:38PM +0000, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 

Hi John,

This is where I left off with the actual changes to "daxctl" for FAMFS.
We need a new rev of this ndctl set that includes both patches rebased
on ndctl pending and addressing the review comments below for daxctl.
(Although I've used more recent branches, I haven't looked at whether
these issues were addressed in the code.)

With a new rev, I'll take another look at ensuring a dax device is
available for the unit test.

Thanks!

--Alison


> > Putting a daxdev in famfs mode means binding it to fsdev_dax.ko
> > (drivers/dax/fsdev.c). Finding a daxdev bound to fsdev_dax means
> > it is in famfs mode.
> > 
> > The test is added to the destructive test suite since it
> > modifies device modes.
> 
> Make it clear that it is added in a separate patch. (and assume you
> can drop the destructive part too.)
> 
> > 
> > With devdax, famfs, and system-ram modes, the previous logic that assumed
> > 'not in mode X means in mode Y' needed to get slightly more complicated
> > 
> > Add explicit mode detection functions:
> > - daxctl_dev_is_famfs_mode(): check if bound to fsdev_dax driver
> > - daxctl_dev_is_devdax_mode(): check if bound to device_dax driver
> 
> 
> The precedence check (ram->famfs->devdax->unknown) now happens in multiple
> places. How about adding a daxctl_dev_get_mode() helper to centralize that.
> It could be private for now, unless you expect external users to need it.
> 
> daxctl_dev_is_famfs_mode() and _is_devdax_mode() are nearly identical aside
> from the module name. Refactoring the shared part into a single helper will
> also make it easier to add a daxctl_dev_get_mode() without duplicating the
> precedence logic.
> 
> > 
> > Fix mode transition logic in device.c:
> > - disable_devdax_device(): verify device is actually in devdax mode
> > - disable_famfs_device(): verify device is actually in famfs mode
> > - All reconfig_mode_*() functions now explicitly check each mode
> > - Handle unknown mode with error instead of wrong assumption
> 
> Wondering about 'Fix' mode transition logic. Was prior logic broken and
> should any of these changes be in a precursor patch that is a 'fix'.
> 
> 
> > 
> > Modify json.c to show 'unknown' if device is not in a recognized mode.
> 
> I think this means disabled devices will always look unknown even when
> the intended mode is devdax or famfs, but disabled. This seems to
> change the meaning of mode from 'configured' to 'active' personality.
> Can you detect the configured mode even when disabled?
> Perhaps a man page change about this new behavior?
> 
> snip
> 
> 
> >  
> > @@ -724,11 +767,21 @@ static int reconfig_mode_system_ram(struct daxctl_dev *dev)
> >  	}
> >  
> >  	if (daxctl_dev_is_enabled(dev)) {
> > -		rc = disable_devdax_device(dev);
> > -		if (rc < 0)
> > -			return rc;
> > -		if (rc > 0)
> 
> Please check the return code semantics.
> This gets rid of the <0 vs >0 distinction. That means a '1' skip
> becomes an error return to the caller. Is that what you want?
> 
> Previously, we had a return 1 from disable_devdax_device for
> “not applicable / already in other mode” and I think that is now
> gone.
> 
> 
> > +		if (mem) {
> > +			/* already in system-ram mode */
> >  			skip_enable = 1;
> > +		} else if (daxctl_dev_is_famfs_mode(dev)) {
> > +			rc = disable_famfs_device(dev);
> > +			if (rc)
> > +				return rc;
> > +		} else if (daxctl_dev_is_devdax_mode(dev)) {
> > +			rc = disable_devdax_device(dev);
> > +			if (rc)
> > +				return rc;
> > +		} else {
> > +			fprintf(stderr, "%s: unknown mode\n", devname);
> > +			return -EINVAL;
> > +		}
> >  	}
> >  
> 
> snip
> 
> >  static int reconfig_mode_devdax(struct daxctl_dev *dev)
> >  {
> > +	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
> > +	const char *devname = daxctl_dev_get_devname(dev);
> >  	int rc;
> >  
> >  	if (daxctl_dev_is_enabled(dev)) {
> > -		rc = disable_system_ram_device(dev);
> > -		if (rc)
> > -			return rc;
> > +		if (mem) {
> > +			rc = disable_system_ram_device(dev);
> > +			if (rc)
> > +				return rc;
> > +		} else if (daxctl_dev_is_famfs_mode(dev)) {
> > +			rc = disable_famfs_device(dev);
> > +			if (rc)
> > +				return rc;
> > +		} else if (daxctl_dev_is_devdax_mode(dev)) {
> > +			/* already in devdax mode, just re-enable */
> > +			rc = daxctl_dev_disable(dev);
> > +			if (rc)
> 
> disable_* helpers print an error message on disable failure.
> Seems this should too.
> 
> 
> > +				return rc;
> > +		} else {
> > +			fprintf(stderr, "%s: unknown mode\n", devname);
> > +			return -EINVAL;
> > +		}
> >  	}
> >  
> >  	rc = daxctl_dev_enable_devdax(dev);
> > @@ -801,6 +870,40 @@ static int reconfig_mode_devdax(struct daxctl_dev *dev)
> >  	return 0;
> >  }
> >  
> > +static int reconfig_mode_famfs(struct daxctl_dev *dev)
> > +{
> > +	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
> > +	const char *devname = daxctl_dev_get_devname(dev);
> > +	int rc;
> > +
> > +	if (daxctl_dev_is_enabled(dev)) {
> > +		if (mem) {
> > +			fprintf(stderr,
> > +				"%s is in system-ram mode, must be in devdax mode to convert to famfs\n",
> > +				devname);
> > +			return -EINVAL;
> > +		} else if (daxctl_dev_is_famfs_mode(dev)) {
> > +			/* already in famfs mode, just re-enable */
> > +			rc = daxctl_dev_disable(dev);
> > +			if (rc)
> > +				return rc;
> > +		} else if (daxctl_dev_is_devdax_mode(dev)) {
> > +			rc = disable_devdax_device(dev);
> > +			if (rc)
> 
> and here too...the disable error message.
> 
> 
> > +				return rc;
> > +		} else {
> > +			fprintf(stderr, "%s: unknown mode\n", devname);
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	rc = daxctl_dev_enable_famfs(dev);
> > +	if (rc)
> > +		return rc;
> > +
> > +	return 0;
> > +}
> 
> snip
> 
> > +DAXCTL_EXPORT int daxctl_dev_is_famfs_mode(struct daxctl_dev *dev)
> > +{
> > +	const char *devname = daxctl_dev_get_devname(dev);
> > +	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
> > +	char *mod_path, *mod_base;
> > +	char path[200];
> 
> We have PATH_MAX for the above.
> 
> > +	const int len = sizeof(path);
> > +
> > +	if (!device_model_is_dax_bus(dev))
> > +		return false;
> > +
> > +	if (!daxctl_dev_is_enabled(dev))
> > +		return false;
> > +
> > +	if (snprintf(path, len, "%s/driver", dev->dev_path) >= len) {
> > +		err(ctx, "%s: buffer too small!\n", devname);
> > +		return false;
> > +	}
> > +
> > +	mod_path = realpath(path, NULL);
> > +	if (!mod_path)
> 
> Maybe a dbg() level err msg here
> 
> > +		return false;
> > +
> > +	mod_base = basename(mod_path);
> 
> Please use path_basename() because of this:
> https://lore.kernel.org/all/20260116043056.542346-1-alison.schofield@intel.com/
> 
> Give me a minute ;) to push that to the pending branch and you can
> work from there: https://github.com/pmem/ndctl/commits/pending/
> 
> snip to end.
