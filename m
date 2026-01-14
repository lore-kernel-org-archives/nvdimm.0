Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AB32F4A05
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 02:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768358085; cv=fail; b=Vn3I0nDdnV5IzDIOP095855ftltVLYbb1/niB4SnmCTxXDjMtNQZV7KgDNODD+V6wQy1MD1pZENJqlBkfAVdy4oNBcKRjtgirjkkAXruTLNvvxHPEE2kXBfJl8M8zxctJ0xuYrjWq1msHRfx0eqmCvWrPHvVnSlpVX+iKS5dEmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768358085; c=relaxed/simple;
	bh=hzRxbcrVvQOuzOhJiaObeHBGywLo68S38FrfDK5Xybc=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=FG+ZidIOnUybR7INhrCB7NrUz2OOe5Y08VxIlOKJ0L3FG+e2WlPzOaU3FpL6yTUK4ajhZawhQiXqqpPzY23VIoLo/aEwvMlWxMAkV1kstZlvTML2IDZm//UVQ8LmQ/dAOd8TPS3AuuhR425vkr5D0uYRa2ozgo13VUWjBlqZf3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U+nkK8KJ; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U+nkK8KJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768358084; x=1799894084;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=hzRxbcrVvQOuzOhJiaObeHBGywLo68S38FrfDK5Xybc=;
  b=U+nkK8KJGTWcGw9x71oQ2FB+je8EKdHE3/ouTP+xUzXwGodvH5E+b9aU
   jusxx7cnATShbENKStoTi0eiIw3ktMrV/nUDeJzftc+32nbJg3x/9Oi8c
   VD5sPJSSARQ0CcaDgjfOBUZtqdJE7pdiseCA+ttQ07Ej5mYZvnwX6hBwM
   1C/ODw3mbw0wmKYWFXrUFo+wS9GF11wGGuAtWe+26WECyJfPBya/jecW7
   +mRd5jfB8ryu2r4Z//6YwKrh6po1yw2kg1wzXJ8VXY0z/0KOjteuFLPHS
   1/XAFYwDZyJh4gnvsQ5a4osVMD+17MulxfXSlE8x/kiiY1lh2duW+ipQG
   A==;
X-CSE-ConnectionGUID: TLjNtV7hQnKlKTJ28YUDdQ==
X-CSE-MsgGUID: EkCJMdl1RAOn1Ui5bE8CcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="69815766"
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="69815766"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 18:34:44 -0800
X-CSE-ConnectionGUID: M1RPknwuS6Km7fyOOexO/w==
X-CSE-MsgGUID: HliczeoqSgKNbEXb5qFSBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="208708741"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 18:34:44 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 18:34:43 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 18:34:43 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.59)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 18:34:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RSodbsWDYRKXm/T3e0w+urLD7UKZElnmFabLgD11wcwZ3iG3uFiD7GUYFlfd2WkyY9SVlUR6pKnbUvuX/A2fnsdJR1b+slX2R3pkBmcYn0KFgAAwNxONbq2MoB2DBJIc6Rjr4olIz8GpfrzmvI2X0I7jJPzQmE2WP4ptD3bOQtQ8WxBoUsEVtUfZp4j91iBV6RrziXQ9ls3PDGqP+6RnO7122O4hTOng/3FfXvuyEzXzRwfXrUtAw0jri6o1MSq0NkyNxhdzz+2ImqVOs2W+C5x/kE/8Nuzx58W12TkTPMEtD0L0B8YzWqrT9XlIIuqTQxmh4tbmJmy1AKDK2qk+Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnEZSkekoauN9MF+j/Z2rDB22TLbSZyVmlUt0E44OGw=;
 b=RpW02TXIr+d0GB+IV/KCklNrW0m5ltNMvwr/yfNO0AwE0rcMRhxsuWEBDoqoh7cLeIimhXZHOxXqUubtuwnf0nATX2n+X6XnKDb7jrWK4V+NhrbBiQRFBCSFtm/o+3Gq4XWNNm9GUVKBYC9YJLQWQ7ommpajFM+KogsYK5a+Y1Jhnrp/wXx6g45bccPT+weKf5s13iZSQkMr9vVL0NG736cJXs8HWDS9lEICId2axkEqwdX3UkKMag+ldvmkhZXm61z+UfshOEU9sutQlyR+IXvIXiIqo7YvCcMks4fxGTNGCdKCE2xc9Yw6eXydfXDUnng1xxfaLJS0x/k8OmxxpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB7406.namprd11.prod.outlook.com (2603:10b6:8:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 02:34:37 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 02:34:37 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 13 Jan 2026 18:34:35 -0800
To: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, "Ira
 Weiny" <ira.weiny@intel.com>
CC: <dan.j.williams@intel.com>, Mike Rapoport <rppt@kernel.org>, Dave Jiang
	<dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<jane.chu@oracle.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, "Tyler
 Hicks" <code@tyhicks.com>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Message-ID: <696700bba6f6a_207181006c@dwillia2-mobl4.notmuch>
In-Reply-To: <CAAi7L5e3TFcuwpt5vzy_xOtDxX0AfgH3tDzZJM=uiJy4h9a08A@mail.gmail.com>
References: <aLFdVX4eXrDnDD25@kernel.org>
 <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com>
 <68d3465541f82_105201005@dwillia2-mobl4.notmuch>
 <CAAi7L5esz-vxbbP-4ay-cCfc1osXLkvGDx5thijuBXFBQNwiug@mail.gmail.com>
 <68d6df3f410de_1052010059@dwillia2-mobl4.notmuch>
 <CAAi7L5dWpzfodg3J4QqGP564qDnLmqPCKHJ-1BTmzwMUhz6rLg@mail.gmail.com>
 <68ddab118dcd4_1fa21007f@dwillia2-mobl4.notmuch>
 <CAAi7L5cpkYrf5KjKdX0tsRS2Q=3B_6NZ4urNG6EfjNYADqhYSA@mail.gmail.com>
 <6942201839852_1cee10044@dwillia2-mobl4.notmuch>
 <CAAi7L5e0gNYO=+4iYq1a+wgJmuXs8C0d=721YuKUKsHzQC6Y0Q@mail.gmail.com>
 <6965857b34958_f1ef61008b@iweiny-mobl.notmuch>
 <CAAi7L5e3TFcuwpt5vzy_xOtDxX0AfgH3tDzZJM=uiJy4h9a08A@mail.gmail.com>
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM
 devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR16CA0028.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::41) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB7406:EE_
X-MS-Office365-Filtering-Correlation-Id: 11e4ebe5-30fe-4ef2-c16f-08de531575bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RWFkMjkxODlKRjk3SkdOakdOejRpNUJkUnY5WEJWck1uN3FrTFZHSFVDdWxZ?=
 =?utf-8?B?TVlaazZucDBpZDFKRlZtWVV3czl1bUFkODhSTlR1eEpMZytWMmtDVFJFOFh5?=
 =?utf-8?B?V1RnOTF6cjY4YkNOOENocUpKYnEvWi9tV25VMXdLK1o2T0RKclFMdjRIV1dO?=
 =?utf-8?B?aDMxclV5bGQvQy9Tb0VGc3Y4cDJZdDJkbHNtUVpZbUxOVHZsRER3SnhIMldK?=
 =?utf-8?B?QU5ONjdXa0V0UlBpaGozQnFQNGhCVXd2MUs5ZFdFOExQcG5SbEZ5d1BUS2h5?=
 =?utf-8?B?UHFiNFJLdEtwNlJwSVRLRnlpcTIvM3A3ZW5VWU9PSlU3WnR4TitsM0loNXov?=
 =?utf-8?B?bFcyb2p5YUk4bldBNU1MNnlLOGxPZ0lnV2k2STFTWitHREhYSkp4QjV4YU5G?=
 =?utf-8?B?VCt3TU10ODc4ZW5NRHZ3ZzF2WktzZXdHWmRqZGI0cTB5TWVhLzEzRmtXRVQy?=
 =?utf-8?B?bTdleUp4NCtVY1BXdkpzZmZmNkJvV0tKV2MvRFBFd0JzVzhqazUxR1ZzQ05O?=
 =?utf-8?B?UmJuekZXQUZQWG5QUkpHSXZFZ3dCUU55V0lnT0w1N0xuRnMyRzUvcEdVOE1H?=
 =?utf-8?B?alNSK2Y4ZGpDNHJJR0FNU3lFTmZkbDA5ZjRTTnQzRTZKbEhNWmVzYkpnSG1M?=
 =?utf-8?B?c002eVMyT212Qll2ZmJYNjZ6aTY4QWNqcW9qTCtvU1VUaVhQSHhLOHY4bkdj?=
 =?utf-8?B?UitWU3J6WjlqbVdQTXlMY3VJR01uUGUxZTM0bHdBM1MvS0h1dGZkMTdhNC9i?=
 =?utf-8?B?RTNuUWdYeTUzdlV6NU9udXY0VkR0NHlHMmV1VGtYMnorcmx0aGFTRmtKTk5l?=
 =?utf-8?B?YlVkaWs1SFJNcDVmanpuZ3ZMTFZINWdsdzdpQllsV3d4SXBhWnBGT0hEN2lm?=
 =?utf-8?B?c0RROHhZRG43cDN1blJZb252YmVsR0VBeldkeDBveWEzZzNvTFJWdCtOV0FQ?=
 =?utf-8?B?RFhFRXhqNHpjNTdCVG5GeDY5STRZRE03ZFFSY2FheEdXZG5rMHFrOFp3TWpa?=
 =?utf-8?B?NjR2R2QxSStVcFN5S3hmWFEwQWdjRXM0am9wWTJwOUtsUTRsdmlzd3IvS1Rv?=
 =?utf-8?B?Z1BJazI0ODhmUUQ3MUpGdkYzNkxXaEtEdDdTZmFCMi9NSXUzTE5MYlI0VGRF?=
 =?utf-8?B?c01vQTVHWHZLbGlCZHh2akVjNzh3cWdoT2N4ODBNZ0ZpV1R5Z2kxN2xhWEtY?=
 =?utf-8?B?cFBEUTNNbU1UUWtKWjJTWDFLM21lakd2L1haUlVkbWpkeGRNcTFVZXdWY2NC?=
 =?utf-8?B?VjVaNGNZWkdtOTUvWUhhbU0zeC93dFNyMGlMdU94aVI2a0QrMlFaU1NKVWc0?=
 =?utf-8?B?MlBLdENBYUJrR1RubXR3aHdtYXNjMWlwdjEzdFJkT01uR2w1TVFsbXRkNGQ5?=
 =?utf-8?B?YjJTMmtHRno0QnVPd3ptcS9yU0xZdE5HQ1V3OUtONlZSTGF0dkE1TW5MUThV?=
 =?utf-8?B?Z3lwSEt2b3JKcXg1Yng5Si9CNEYyWllpZU8xYzNkV2VvdUFiM2s4VUNsSW8y?=
 =?utf-8?B?c3h2WkI3KzRjQnE2aUx6UmJWQmlpVzRXZlpZREh4NzJSdXdHckx6VXhsRFhy?=
 =?utf-8?B?cXp4UGNWNms2MXoxZHhkZkMzY0NsUkM2aWxxVlVDdVJmSDVPQ2tPSjlCZ3RW?=
 =?utf-8?B?dVMrcVY0RFcvVzdxTUsvUWpwNm8yWE9DU05RMHpxUktyTzNsZmhkd1l3bmZJ?=
 =?utf-8?B?MENOVVVlYVRHRGR2VWNuZHAvdWhabkhxRGFjdXgzcS90RnY2VFhxNlFQNmR2?=
 =?utf-8?B?MkJSWmtDWVF2RStWdktvcVdRZFRFVDQ3YmpGekVnenVIWndhNU1RTGJrNDZx?=
 =?utf-8?B?Mng1elhxUEt1bFhoeC9TWkJ1RTY1cjI5YjE1K2ZEa2hBUUZCSnAzanF5elNo?=
 =?utf-8?B?RkFzOSszUElNTXE5Q2lRR0VLeXVuUVZpTTQvRmY4b1hhREJvb0hBcDVJQkYy?=
 =?utf-8?Q?tQ5X/WXM0h/yDTMAOWiBn/AqgRMSKyiW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3kxbUtNQTkyZzlpN3JacWlMd1NuaDlDY1o2ZXFRUnk0b1U1cW1ybndCbmtY?=
 =?utf-8?B?YnpERi9oQm0rUkhBZ3llSlZsRmhLUUorTDNjdXVUcHc2OGFoVVcwMTBJMnp3?=
 =?utf-8?B?YWV6UHJXVFFSS1IxVytXY0o1cmI4R0JkRzV2K2lMWnJsRjRDdEpicHdMMzk3?=
 =?utf-8?B?dHpzdEpjUWc0Qmd5VGVWWFhxT3Naa2xwNFA3N0xZYVNmamFBQ0xDckJGN3VG?=
 =?utf-8?B?M2xCN0dzaEF2Y1llVnRVNlg4Vy9CN0JZdkppRVJtVktBY0ZXS0VTT0ZWRnp2?=
 =?utf-8?B?c3R3NkZqbXVXS0NUcHpPd0p3WkJtWlhBd090Ui8vT1lvdHJ6M3AzVzNscmwr?=
 =?utf-8?B?TXpoMHFjcVBvMUp0Y2tWQm04a29Mb2Y0UElPMTMzS3lYano0UEdlQ2dlbjJz?=
 =?utf-8?B?NitmUWpxMXJVOW4vL3FTTXZ1Z0w1b0dSWVFtZXpCc3hMSmliWkZmMTd5TXBl?=
 =?utf-8?B?SXZTbjJGR2pJNHErZUpncUo4NnJrZXdkTXBQRCthWVpCOUp3aEEwckVrVS90?=
 =?utf-8?B?Mjl6cmdQNTJHdWFldnJKVmlNN2hVZGpyMUhmUUNNaCthTUdBMXY3bWloRGUy?=
 =?utf-8?B?UUFKam5jZUdiV05BNmcwQ2gwZndkUlFzVkI0K2hoUHRwWktzZ0x4UUx0QndQ?=
 =?utf-8?B?dUtLc0liWTVPOHE2Y0cvVVRLM2hzZ1lrNnZkOFErUFBUQ1dzTWhHdzB2RlpZ?=
 =?utf-8?B?SGF5TEx0WjZxZE5vVTN3SlQzVXhQdFFnVWdwZDk1M2RuN0s2OGhqZFgrb05s?=
 =?utf-8?B?RE9kbWdBcHNPemh4clBidUlSMFRkVWp1Uk5tZ0cwTlVJR2JWU3dsMGV5Q2cz?=
 =?utf-8?B?b3piWXc0RjJFZWtyNVRJdGlOUzRoemFKY3orR0dPMWhTZEN4NjNvMnQ3WVBz?=
 =?utf-8?B?YTV4WSs5NDZWUzJSbTE3QXkvT2xVQkRseVc0Y0laR3k1UzFQTGNpU0swWlJU?=
 =?utf-8?B?OUxUd0VaeDRVY2EyVW9PbjJuaTh0elRJWE1MVFRDWEtVbEFSV25EZlVnUmMy?=
 =?utf-8?B?bk5GbjN1aHN0N2RhanIvK1BMVmxlc1BDYTlxcVBXRSszVHIrRkQxOWg0VG9a?=
 =?utf-8?B?UGt4aGJlanJra1N4UGdnV2h3eU5IOFoyTnJwVlBvVS9TK0lObUFweE43L2kv?=
 =?utf-8?B?dTl0bEMvSlRXejlRMUdaM1VEeUp3Y01rTUtRMTMvNjI2R2J6ZnNEWm85ek4y?=
 =?utf-8?B?bW15MFVNaU5Ka2xCdDZ0WWhYbEwvaXV3L3ZyT2lQeWU2REQvMk9aR0tobE9m?=
 =?utf-8?B?QVNmQ2Z6YkN3SEZCbUFKWkpHSnc3SXlBOVUrRm1HaVlaTFM4d2NwN1dFR2Ir?=
 =?utf-8?B?aURic0dYVTVsS0NrclhHclVqZlBVNythMlFIUmQ1cGlLbk5IL3I5U04wYUVa?=
 =?utf-8?B?UldXTEw5WW90L0JFYUFtYVZmeS8wTHhUbUpYdFZ6bkwyWHhkM01UR1A0LzJE?=
 =?utf-8?B?Y0ZRbjZZdFRBNS9PS0g5QlhpWkl0N2k2aXQ4dFY3QmloTGtjN3pFdEFQSHVN?=
 =?utf-8?B?UjgweXpQb3dxR0p0ZHBPR0hac01QRGl4bXA5cW5uNE1OT1JXR01jR2Y5aFNE?=
 =?utf-8?B?MmZLazBreHRZM3Q5SUxIU2RJc1N3Z2Vaak5xVk9QVGt0S3JOMkYveWR1cWRM?=
 =?utf-8?B?T2s1a0daV0xoYWE2dFFoeHJoSUowZXRCYWhyTWwya3BTL3ZpSVZpZERTdXVx?=
 =?utf-8?B?VG8vREpwa2JwY0xUQlhqS01xVGZxRjh1VUU4TDVTV0l1cDlRMTBNZm4vMWxQ?=
 =?utf-8?B?bUZ5UWZYOUtvSU9lTVhQYWZrR2tsMTUwczZCSTZnU3QvQUx6MlJUNkFJNDVL?=
 =?utf-8?B?SU5sV0tReitTSnZma1NxTlNRM2R3WlQ5VU1maHp6eWc4VG0ycy9LSnpEaE50?=
 =?utf-8?B?UHZuTVllYVduUTdHUzY3YzRBSjBWTnIyRE1IaWw4cHBlL1N3bU04aGhkTjF1?=
 =?utf-8?B?MWRRYWFWSTJEaC9EN3pvVmh4b0xydkdHYkZuM2VmS2pmK0czbnJkZDRIQ2NL?=
 =?utf-8?B?NEdYSmpmZ3ZnNFlTdVRzV05MU2VOZ3hkd1R1c2xPc0h6bDMzT3BTNlRvYVRa?=
 =?utf-8?B?OEYvSmNvWU5RWVFzSm9TVldvKzBnMjkvdVIzejV1MTdUUk15dXlySldOOUVS?=
 =?utf-8?B?Mkl6NWxkcHhoVVB4NWc2NnZVK3NqdlpRcHBZMTFTODFDTDVxQWhPanFzRlRV?=
 =?utf-8?B?TGdHSEZjTUdkU3VtUVJuZHZBcUhUbTl2UkJIOEx2UVhNMG9WSFlNSlluQ0lt?=
 =?utf-8?B?YnZRUTRVUG56SVJ5YzlvbU1tWmU3Ui8vTFdsc1JLM0Z0bVJaZXdMN3laeFlU?=
 =?utf-8?B?ZUYvV1BsN3hHSDExTElpMWpwRndubkxVbFpISWRUNjV4djBiekVXMXgyQVpX?=
 =?utf-8?Q?S7XpO/C4CyxxBC+w=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11e4ebe5-30fe-4ef2-c16f-08de531575bf
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 02:34:36.9746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pb3GcM9CuS946KN+0g6WygQjpxmPho/6N72EtLBuo1Uod808Ggot6CnyoVJWs+kCSwX2JeWgWp7HbLVnHw19K+B5F3Tjj4HUunyE2BXAe70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7406
X-OriginatorOrg: intel.com

Micha=C5=82 C=C5=82api=C5=84ski wrote:
[..]
> > Did yall have a suggestion on how?  I lost track of this thread over th=
e
> > holidays and so I'm not sure where this stands.
> >
> > Ira
>=20
> I think Dan's change needs to skip devm_request_mem_region if offset
> =3D=3D 0 in __dax_pmem_probe in drivers/dax/pmem.c.

I would be happy to review a fixup patch that works for you, and give
you Co-developed-by credit. That would be faster than waiting for this
to bubble back up to the top my queue again.=
