Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E400E3E51EF
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 20:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774299356; cv=fail; b=PbjUTwzAgkZ9bELPvO0ekomAB4dEfzr+JbD4ZBFQsX4U/yRlgMS2PwUVS4unE6Dr6h/59VwZN6w1/2D9OO+mmrjHLLVjLpknz3hGXdMIh/DCwMfZEtpltXCFj6fa61mCi6c2gguCszEQxHKMmlfG0GQn80Wlyd2qa8Nw1KcSa/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774299356; c=relaxed/simple;
	bh=nL/p5RLAVkDjMSBKLuEQ8alqT+KTWs+5XAkWzj5KrXw=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=ch82BD5f8GuG+WAbuc873H9bmZlAteiRFKqFvVNNSZ0KeBkgUctZEQ6IGooNPNcVs9MyWWyUR99yZPuMHYLQfUaHhmkeqp3W+2jt4va2JDj9KbS+7B7FCskHHWxVUvRtEUqtIEGZkG/ZYR8fWUm9Ozji2nRhwCwtMn2Fbb+1eKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nubu4fnC; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nubu4fnC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774299354; x=1805835354;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=nL/p5RLAVkDjMSBKLuEQ8alqT+KTWs+5XAkWzj5KrXw=;
  b=nubu4fnCpz+Eti4LVQ4e5j8I3fpvQaCITDLHptwcT3x9xwoVwUGzjwns
   OLeh9aN1FgR1gTfxrIA3g54ogzOXjcpqMhTj+vgWBiO5GQ/XmFy5pskHS
   A9btdKFddx6rlid7S7+4GNcSl/wDFceW4KPA0Etlg7pKr5BRsuS6230c/
   P5W1qvuhd5KnXVLrSSY3LuMZDeJZBcCe1EVlkwwtHdAH2iGQbdzX0FXJn
   xXFpb0RqZlWqjVIwFqm+jC4G1rXmx+jeQCZBNLS3EqE+N6AgB7JFE9G+E
   zhvl3z63LGtimw9OiDeMl42EpW3OzxKjOjlMqv/YPk3G3jC3023mHfTqj
   g==;
X-CSE-ConnectionGUID: VwehoV4bTYCoOwu0UZ1wSQ==
X-CSE-MsgGUID: l2a/uGZsRHGrhPN68jCNvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="75216174"
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="75216174"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 13:55:53 -0700
X-CSE-ConnectionGUID: Th6cn6sBSNqrJCF2Ba66UA==
X-CSE-MsgGUID: +u5JMf4tQV+B+mLHPH9HKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="223206996"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 13:55:53 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 23 Mar 2026 13:55:51 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 23 Mar 2026 13:55:51 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.49) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 23 Mar 2026 13:55:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eDnyleUwnkW9V5m/bo4VCMVRkrhcPT3aQ2ri6659ws/ZsoR37lSOJHryNmQ2BMizV3mL2isRAFESXZ7uMh+Anjolj0yzyva7ZQbdpr/Z+yADNks1NQAgX84SfwLaqYL40CqQArNnG9kYGB8O51kGzVCyqUHz6RkCJ7bIHukAi78pf0Q6sKxt4VDSqEgvJvpMNusMKwjeLNtXPW6fG3MGKIRnxFmxZZp9aOrOpdzxg65MOwIzfnfIWaj/oTxMnKsd9+9VmRqdYVzmvN3W5Llosr54J3XEAOC5k7HktJ+84V3IXI75opL8xpT2bVEHI2V1QJv4buJI3R13K/XzZOrZmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/u8JbFIlXlgXjURHmObXpIBrcXU/+InF+j2wKW48lOY=;
 b=GHt++IXLq7ESnKbG70EutJxmJgdrxsIqBc2HxKhPbj0W2rjLUKvsmEKvB0Yx3EPaLf2tc4Cg3VPY0oY+OHaZCvnlhup6xWIvFmRNW/w0MFZlcJ6ng0bqExfO4IwzAZTXwh5MbEKQr76mQR4znkAmL7MFn5XfiBO6ReucbUMiRimPhGL9+/84A5ADy/vfpwXchGxihqNAED9vC0W2J/9O13wbp/rRoc1cu+l6WUNyhl9a5OFltNUpq6Nzurzg/GmYJCp8DOfZIVYC+5vvAGajI5iUGi0Cvit7LrN43Acu/OdWJZWg8ENqi5T7bW9Ixtv2/UP4ak31LKi/qAOqlqjX8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB5279.namprd11.prod.outlook.com (2603:10b6:5:38a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 20:55:49 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9745.019; Mon, 23 Mar 2026
 20:55:49 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Mar 2026 13:55:45 -0700
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
Message-ID: <69c1a8d1c0fa9_7ee3100a1@dwillia2-mobl4.notmuch>
In-Reply-To: <20260322195343.206900-7-Smita.KoralahalliChannabasappa@amd.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260322195343.206900-7-Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH v8 6/9] dax: Track all dax_region allocations under a
 global resource tree
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0003.namprd02.prod.outlook.com
 (2603:10b6:303:16d::30) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB5279:EE_
X-MS-Office365-Filtering-Correlation-Id: e481186a-1dfa-420b-bffa-08de891e8fdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|7053199007|18002099003;
X-Microsoft-Antispam-Message-Info: 2E05ObayKAxUeHweoJIrCRLcboAnrw/p09X7iz0+Wf3XqnReII/Yym4AeCJyFqn1a2/m2R7DY6EcLyedT79fwI2El40xrRvhKTdNliQNoCzJjTkDviTjtwGeJP6rCuqdRDRunivFMJLng2vCwB0+72ciqIZ7kqQSyQzoFESYbKfMgfJyPMVlzUUvhPvMDoO2Mt5PEidxm8kgsuZUMgJaol81qOkxr0JlprHMMJv33NWN6Cb2trVdls3ki/8iRiLCfdbNK0ZfZqTGu4j6iX9Pm0fhd9feitZtlUcK/NgxkgfzbiqUw2hjUrJ3KckqrNHbApHmZ5xVcQyyrSjprqf9ptvB7awR8GlvLE9mfqnIqfIgfg6xhGOHAEaGMD1y+xsHOV+vRZpBFLm9mk1O0BNrHo1UC+5mdaGWGR5Pvz6ycT3lwfobky98Fl9j+8Oj8iPW+LZe4MUbGulPCKLTFuQNvQIIsr6hX46y5+mr6AcziSK8LN0QRjmWyYPaFlk2upIX1NCzuKjMTrwslRzRMZGtjvXXQDSQCQIqSOObiM4oigYb5KbI6Q/wPfma4nCI8YY30M+pE/mBAkm2XGzf1FbHVrkfpi6W7PwM7FvOFxeUEJQ73mef8RXkzQPSdXFMQMpuwwkOfjJ/GLJGomizXcYO6Lqq0OwbgSUOTdL9ewR5V/MrENaw/iMLIjHatpF1o38C0tUoLVBxnYxGDVEHWcLzxZVe77LfmsqG2IYDkIXGARo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(7053199007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emhmVnlsWW56MGVhaDBHeW5Ed2xTcHZ4SnVNRnNoai9sL0FxWWRkaEZmbjU3?=
 =?utf-8?B?UzN2TnV0ZGJuWVgweUV4UmorZFE0U0tRM2JqTkFITkhBWktCZlNhMy9IMVJs?=
 =?utf-8?B?U3YwVC9sd3E5UGlJVjFSd1NQRzQ0L2FQaVY3cVI1T1BCNnh0RjFXUHg3WlhG?=
 =?utf-8?B?VlAvbDFFRnhDT2M1Znp2WXBMRFJOU3drSW5IUS8xYUFrOHJhZHprZmNnUU4y?=
 =?utf-8?B?T1BwUGxBbUJGRTg2ejliL3d0Wk1pYUhtQmdFQVJLK25wSHBQcGM2Nkx4WXpW?=
 =?utf-8?B?bDQ2TEsvbkVSTlJTanNrNWc4d09PTEJGOU9uOWVvRm5QaWg0Ym9leWVCTGlI?=
 =?utf-8?B?WUxkYloyZnN6SVZzcWxIUHBKRjlsVVZaenhGbmU2OSt6VjJ5QlNTR2lDc25Z?=
 =?utf-8?B?eTFvTE9CYm1rVTRRWHNOV1NvZVFCOWZ4MjBZMXFrSERqajlkTk5BV25rWGtU?=
 =?utf-8?B?eW1wdVdtRDh2elN3cUdKQjUya0VCSjFvUGdQQTBvcmJEUWN1N2JzVnJDTjVu?=
 =?utf-8?B?bnBiSTUxdHdFbStuVVlKb1ZTRzBQR0oyb0k3b2lRNmErUkh0Y0xsY25CRXNn?=
 =?utf-8?B?bFk3OUxBT0VDVDZYMUVOWDBjczhPRmRGSld0LzlBUXFtV3pMSXJmdkhnelBW?=
 =?utf-8?B?Q2FJSG1Xemc2aU82cU83U2hMbVl5d3FnSGQ5aHp3dW80WXRCUUd0N3VtU3pi?=
 =?utf-8?B?R3gzazNORWZnTkYzRExsNFNYSCswVk9jVkJwQjVMdVBxcTkyYUZLQ2JVMXMy?=
 =?utf-8?B?dzRYUkdhd1hRT21LYkpCK1Z1T2d5ckdnZFozQmw1RkgySW9zTEZDbE43QWRh?=
 =?utf-8?B?aENFc0pUMENDb1pkRGl2ZlR2OHdKOGdiSkhNbU9PT25SRERicDY1Q1Zzc1pH?=
 =?utf-8?B?Wk1KZUpNSFRONkEyZ1FaQ29pZzlFZkVWWnE5Tmd1U2ZoUXM3K0hHYmtwVCt4?=
 =?utf-8?B?Vk5YSVM4SkRwTExIOXRVb29UUmxNMWk4OGZrbzBySk5SSDllcFkzZmtQRUl4?=
 =?utf-8?B?ek9WL2ZGTzRqV3AwWDNFMG5sZi9yK3BUajQ5UHJ0WmQrRjhtV2gweGVDbkFY?=
 =?utf-8?B?d1JCbnlEZVYrMTJEQUdtbkszVEcwVGJnaVAxMms5SzFsM3dJdXd3dFlKd293?=
 =?utf-8?B?YXhMUWtoVHU0d1I3VitPMEExc2Jkc2d5OTRTWVR0TkdvZU1XK2o0ZERzUVEv?=
 =?utf-8?B?bjNBYWZyZGYrZk9vcHVwWlpHY00xU2J5Z1krQTR2emJ4aW9rb2FCb3Z3Umkz?=
 =?utf-8?B?cXUwQWxxUDJEMlB1LzlTSXhhN3BKdXNpNnhQaUo1VjdGSmZQRTYwTFhnNlpL?=
 =?utf-8?B?Q2h3SFA5THNQUGZubXhLNEpLUmVpOER2U3ZtbUpNZzlSUWdMeEhQWVVDSHJo?=
 =?utf-8?B?OHpOY3RWbWxtVFB0WDNuWXNnc012bU9QRGxiOXFnVjVEMEFwN0ZjSlYyT0NV?=
 =?utf-8?B?bGFVamV5ZWFick9XbmF4dlVaME9kZ21FTk5PUnpZdmpmVjRPVGxFbFVtQXBJ?=
 =?utf-8?B?aERiQ20wNTA3OHNxMVNNNjA3TGpWODZ2RU9TMlBjeFlwa2VWc05mRmJqYWlJ?=
 =?utf-8?B?a25PVFUxUStjWmpOTUJKcjZnTmRTZmIvdldKYVdPU3VsdkFTbGQ5T0FJTmFY?=
 =?utf-8?B?L3gxVEJ5Z3I4SWs4WnQ2RmxPay9yQmcraGdJbmd0MzE4dzdaMm5GUHByRUx2?=
 =?utf-8?B?bmtUNWNqWVFXdVkzNHBVaDRpZHlwZlh2TUI1ZjNwd2N2SjA2cnB0TzBFVE1v?=
 =?utf-8?B?M1FtSTlLWW0wa1l0LytwK3h5a0NqQ1FiUE9UcDVvUktDVjI3bGlwUFBJWjhB?=
 =?utf-8?B?b2tzT3B1T3dDeXhFMVVJb3BWSXZmeStIL1UwUDdVdy8xaEkrbi93UG56cGlX?=
 =?utf-8?B?QjEyUWVxZlU4WTBCUDFaTlk4RmdSeEdZWWdJVVRnL2dWaTZZOWxid1hMV1VV?=
 =?utf-8?B?LytmSHp6cXQ2di83aEFYSFB5TUxFVWo1ZWpYZnpCK2VMUmh4VUJhRmR3bW9K?=
 =?utf-8?B?czdMWG5TcnN4U2ZWUTZaMDdUdlVlSU9iVktBMGJqbkh2TnZJOVpJQzh5MXN2?=
 =?utf-8?B?YzNzZ2V0VnFEYkN3S2IvRjFxb0tCdXdTckFsUTgrMmxITHZjOU11eTZFMVl0?=
 =?utf-8?B?aktyWDBqQ2RtR0xBYytJMVlRRUhUQXVpYU0zQXBWekZIdFFpY2xrRmFzUG1n?=
 =?utf-8?B?Z2V5aUhrQW93Lzl2Y3ZFazVzRStGYUlPNnVERWJRaUs3Ym84VmVkV2p2d3dk?=
 =?utf-8?B?UTQrWHZYWTRicG4rcjQ4ai9HRUFWMUNTM2hOT2t1OWwyZUhqanh0anBzVnBH?=
 =?utf-8?B?SHduNitkMUlLR1FpZldnTzNONkZkN056YVIxeERydHVrTDQ5OUY4Ly9QaC9G?=
 =?utf-8?Q?Tsx7x3TNZHQkvlk4=3D?=
X-Exchange-RoutingPolicyChecked: QMcQRZhlhh4IvbuGivKdWVnBmoQfQaMF4bGJqueVbC+nQHlzFTO1mv4JsaYWVPSZe1K1pDAyUxJM6reEFirUabDNtlyD+2/f+1wEE7evOj2CgiUI2UqH6R8jIMXsCTjsRokjX3drW0v0kTbXUHB2JiDJvVlzjxk+zTHg4aFztSTN2JiM1FUqEgouaW0gxlj5J3U+R5h7ph04lcRAWbrlgF/cCpk9wc51FAsFjNdpirunKdpQXQHvPteVdeSmszIUTvvro9V0qOBRyw8O1FZWu1BXAajtzvOVOzf4wniDY8wDjpD8XR0VPma7/Prt+cSOBQY5BRC2TXV0mgX+m6dIbw==
X-MS-Exchange-CrossTenant-Network-Message-Id: e481186a-1dfa-420b-bffa-08de891e8fdb
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 20:55:49.0699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Di8SZFKnzkG3oiRwIOiycVrAtG2kw8wxe0gBq2aM2NVad7uM49YJBFNfxjhWnYicgs42QNFk/TCUQTAuSicfvCnIVc+jm/vTgJh/C0WB+uk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5279
X-OriginatorOrg: intel.com

Smita Koralahalli wrote:
> Introduce a global "DAX Regions" resource root and register each
> dax_region->res under it via request_resource(). Release the resource on
> dax_region teardown.
> 
> By enforcing a single global namespace for dax_region allocations, this
> ensures only one of dax_hmem or dax_cxl can successfully register a
> dax_region for a given range.
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> ---
>  drivers/dax/bus.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 299134c9b294..68437c05e21d 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -10,6 +10,7 @@
>  #include "dax-private.h"
>  #include "bus.h"
>  
> +static struct resource dax_regions = DEFINE_RES_MEM_NAMED(0, -1, "DAX Regions");

Just type it out, skip using the DEFINE_RES* macro, like the definitions
of iomem_resource and soft_reserve_resource. Since the argument is a
size not an end address.

>  static DEFINE_MUTEX(dax_bus_lock);
>  
>  /*
> @@ -627,6 +628,7 @@ static void dax_region_unregister(void *region)
>  
>  	sysfs_remove_groups(&dax_region->dev->kobj,
>  			dax_region_attribute_groups);
> +	release_resource(&dax_region->res);
>  	dax_region_put(dax_region);
>  }
>  
> @@ -635,6 +637,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  		unsigned long flags)
>  {
>  	struct dax_region *dax_region;
> +	int rc;
>  
>  	/*
>  	 * The DAX core assumes that it can store its private data in
> @@ -667,14 +670,25 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  		.flags = IORESOURCE_MEM | flags,
>  	};
>  
> -	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
> -		dax_region_put(dax_region);
> -		return NULL;
> +	rc = request_resource(&dax_regions, &dax_region->res);
> +	if (rc) {
> +		dev_dbg(parent, "dax_region resource conflict for %pR\n",
> +			&dax_region->res);

I normally do not like a driver to be chatty, but resource conflicts are
significant. This one deserves to be dev_err().
