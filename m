Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E31E46B91;
	Tue, 20 Aug 2024 14:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724163816; cv=fail; b=VvQqz3kM+uFcyfoHZOh1FsyAbQta+LGuzC0dZCLVJEASmyvD/x4TZO38G70oxHunhUmN53lLTK0/mk4xEfqw6NVeTxMSgDJzuOuafxiuKa9d8KIIThwRSeFOWUvkneOP7bz+XW6L+Ju8gGpMeab3QHWfLGN8YOYD8DccQudMDbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724163816; c=relaxed/simple;
	bh=F0oB83wGPGWb1y8PryFdIjBYxJL3KBTDNsy6r7YcpeQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oLIq5FVRaTPQA6UjxSC3oLgvFQNl2ynuL2W2HNdPVW/dXPedw2/1h2upDVHLBaBjZTI+l/VCCgMUmYDEOXseJpA1kvAuYQNqZkKuA9UCCNgmgxLkC9ilBaQH17lgKpYPG1N1TuxX3IXL4WtqsXroWS2H1mSZYwY0yriZ9NivYsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HHRxle2r; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HHRxle2r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724163815; x=1755699815;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=F0oB83wGPGWb1y8PryFdIjBYxJL3KBTDNsy6r7YcpeQ=;
  b=HHRxle2rcbwlB7kcDMc/VhwjsrToT7CEHI8s6rzh1kwVob4Ysje8BovL
   z2Zk1KFdtBlkz/t/u+zdvOg7bEx7XvLz+jBv0GX87QkqJUUvTkV6WlHE/
   JzjwuBmMnSovcDv0ibLAorQGj5aE3ECVoBp+G2bI5GFtbVBCp1jtPT1dZ
   YKupJ1e1VlaekBZ+OgOQ5M8+oU/m3YBfpOlWEvMweiwxtjCIWo7vuVweB
   L3kVuLOqqzsNNZasTqMvyhq9gnYgKJjxCpSit1Ez7YTSxY8XuSFoXBw+V
   HAUj6WaWm9grMzECJcyRcHQYftQlHV9Yd7z0btz0+2HB6yAnEZDknDHQI
   g==;
X-CSE-ConnectionGUID: EXe66pwyS9eWBV3PXCjNIA==
X-CSE-MsgGUID: z45TL8m9SDyRWo0a+wmBSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="22434912"
X-IronPort-AV: E=Sophos;i="6.10,162,1719903600"; 
   d="scan'208";a="22434912"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 07:23:24 -0700
X-CSE-ConnectionGUID: xjOxMB3QSf+EusyTz4nDgQ==
X-CSE-MsgGUID: Wl8mlSwvSg2ABOl7PyDwpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,162,1719903600"; 
   d="scan'208";a="60901728"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Aug 2024 07:23:24 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 07:23:24 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 07:23:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 07:23:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 20 Aug 2024 07:23:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZGkHctjcAAqLSgLaARMhWD8xYKb34zvsm2w94R3YrpBhaUmj8kXEaJlt03xF6BdBSUi/uoVK3V8Gr4S5KjiSFsOAda+9jLETan52kSMI8XjGmYh5TUREn2kgBWxJE4UY9h7j92BxDRPseMwzxCYjV5UpkOskcLlaX0cDws7gwKdvZolEse2Rhd92QW60JZYvabLZZLdIre3Yzfp0hP8/Dgw4g7rgCATzD2s3h/L+RGqdfjnHNCidYw0g7fUKh+WR9x/ohDhgM1FAgjJ5nEq8JzZylmH65eRnwM5rz+vHcFL6kkpy/i7GRJcoxM3kQVKIKEiKNl3wzMjXU4+UDbjIZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LOiRJC+i3g2Uc17cuV2yvlX0iZ/AV9dcWJ7YfGndDYY=;
 b=x0AH8TLph+l1Fq9eDGnIRrRZE6+Q3ss+BGVQzPFVmrdkxqokpRZmYHlSPK4THaf85FhtXnuhK4QKSuMn3EZ01UQthC/Vi+PgXMngjc+X/kGOAjF9x3hyFiDi7310NgO3bGOEtF4OVx/wMB0JtfqhqqjxrDjKSBtDExMc/rH86sm/521dEdCWFB01Nzpx0kTLATEfHZu4z1dY8cdBTFZb4Bdly7Tck/j81/3JOSRWzhVoHV+00lTIJ4eAUBazWWDCNQgRFoRCRNJJKZQDX+GLnBgeZW/zlVfh+RlSW5CcKVms5N5ylnvsgi/9uKiHCPpdixjuBkLhaTnBTFF3OFUoPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by CH3PR11MB8211.namprd11.prod.outlook.com (2603:10b6:610:15f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Tue, 20 Aug
 2024 14:23:18 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.7875.019; Tue, 20 Aug 2024
 14:23:18 +0000
Date: Tue, 20 Aug 2024 09:23:13 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Philip Chen <philipchen@chromium.org>, Ira Weiny <ira.weiny@intel.com>
CC: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <virtualization@lists.linux.dev>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virtio_pmem: Check device status before requesting flush
Message-ID: <66c4a6d18e811_2f0245294ba@iweiny-mobl.notmuch>
References: <20240815005704.2331005-1-philipchen@chromium.org>
 <66c3bf85b52e3_2ddc242941@iweiny-mobl.notmuch>
 <CA+cxXhmg6y4xePSHO3+0V-Td4OarCS1e4qyOKUducFoETojqFw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+cxXhmg6y4xePSHO3+0V-Td4OarCS1e4qyOKUducFoETojqFw@mail.gmail.com>
X-ClientProxiedBy: MW3PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:303:2b::12) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|CH3PR11MB8211:EE_
X-MS-Office365-Filtering-Correlation-Id: f8972672-6e19-4073-b793-08dcc123a30e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?emxwUWhQUVlJUmltVExXV2hwclFpZS9IZUlBL1QrNERGb2luYjFqNlRYcFRT?=
 =?utf-8?B?QWI1czNmaHk5QXROd2YxQmhGODU0Z2J6MS91cGJKdHYybytPZ2U2OElkU0Jp?=
 =?utf-8?B?SVpEZWxVQzVTcnNmbUF1a2VlVE1jd211aHlvaVg2TkZCSVp6eEw0Z1JZVXlI?=
 =?utf-8?B?Ty9UbEpRTTJYNFkzb3JZTzFJZmxxL0FBSm54MEhHSFArOTVHcmdRODlLZklQ?=
 =?utf-8?B?M2xqNStCWTE2NkZkdnJZTlk2My9LbnJMS3FBdHJjd2dacUc0ZW1PSUcyQmpj?=
 =?utf-8?B?VHBycUNZQnpFdk90ZU0rKzJ0T25NNVNIMVFCU2lXOUxVTlh0U2UxZjF3UzhE?=
 =?utf-8?B?Zjdmb3BkVjBRRXIyMWhGek5rZytVeHI1M0FmVWE0MmJ1OC9NTFpCdTE5OXRv?=
 =?utf-8?B?QTZ1bllzenBnY3ZuQkorUUQ2ZWNBNndBTWNuUmpQNUJzbkdVWktFYkJvQ09j?=
 =?utf-8?B?Nk0zN3lJYmVybVVoNy9ZZGJVcjdIeGpqVTNZYVhZTGlWcjhpcTdiN2RpVm91?=
 =?utf-8?B?UGcxaVErY3hFY09mMktRQnFFVDBNKzhUaXVETU1yK1lFZ09HcXVzL2U1OGkr?=
 =?utf-8?B?ZGhjbjRkdU9SMWZpZkNHWHo1VnFVcUpuUTkwemF2QTR4a1lQdCs1Zm9EQXRE?=
 =?utf-8?B?VWhNWlE2eVNGRHFQWTNjazVDS1FhbnMzdkNPU0VvaEtIUi9XS28vWFFZbjhW?=
 =?utf-8?B?S3dYQ08vdS9TQnYvN0QxKzZoUXQ5ZFQvZlZ5S0ZrcmtqczFjbHBtUllXLzRV?=
 =?utf-8?B?Y3BlL3pHUVJuU2JMOEUzT250NklxWDRwcGRKMUk5dUlSS3ZDNmdpaG0vMm9u?=
 =?utf-8?B?SkpWNXl0QVYvWlM0Q213Umo4dWRzdWdpclZMbVhMeDRJL21KRyt5OENWbTh4?=
 =?utf-8?B?elhudktYTlJUL29iTjhNdGFjQmF3Y2FWMktVVjBrR2JvWnlFYkxScjZwcytQ?=
 =?utf-8?B?aDBRYStPZmh4MGh4REZqbURUQUx3TlFhNVZWQ3ArS0t5REdVZkp0eHZvUDdM?=
 =?utf-8?B?UWlHbGRUcUtZNEZrYm5ST09nNmtKdFJ5VzRnKzhVYmx2bTAyME5DVDZPakJ2?=
 =?utf-8?B?eXE5bnAzUjBZbGJnRmJvOXY4eFRLUS81WWc5L05jZmZlTy92NDJDS3oxQytT?=
 =?utf-8?B?T1RpcXBGbDFFMXZ1UXp1emNIR2RzWnZsQk5WTHJORmY0ejNJZmZYZnY5SkRt?=
 =?utf-8?B?OW82Y2FZNFUvMTRtOTFCK3NIMWNwcFVnSkxzNS9FNWhGdkVWQTVObm0xWlFJ?=
 =?utf-8?B?RDR5SE5UUU9zRkVsKzNkSVNhb2ZrQmxhcVZxL2ZvZUR2MVcxdGh3eXB2ODY2?=
 =?utf-8?B?cGlSWk1rNEFvMFVoR2lobWltaTkxWldRZ3lKakxDNGloOEdjUUFpY0lOOFdU?=
 =?utf-8?B?WFlOTFFpaTRMcmxNUTVVcjNjaFdXcnB1c283emFyZE5CeUhGck9VcW92RGY3?=
 =?utf-8?B?Y3FxSGxyU1ZQM0pyUDZFalJ0ck5TdnJieVNSWTI1R3hGQysxTjZ3SmJ6d0ZN?=
 =?utf-8?B?SWJCS1FRdkVvOGdTTFlsUS80RWI4VEhhd3FpUkhiTXJOSFBnTzhSa1U2T2RL?=
 =?utf-8?B?OGlHVTg2N0QxL0RnNnlITFUwRWhlZ1JJRmV3Z002Q3g1aUplR0E4dXZSbUxa?=
 =?utf-8?B?WlBOUS9GY2xkWWs0QjVnNDdZVXhLR3hxT2QxMWFEVmwxYUdYK25LWU5tcFox?=
 =?utf-8?B?cklLVnJTT3UrL01sRkVTczRsZkNkVVhtOCtmcHZoK2h5UmNuNTZhTFlDcVMw?=
 =?utf-8?B?L1U4SDFLZEozWGpzeDVJZkFoSUxHR1NuenB0UHM2aC80dTNtRmVCMTlvYzhh?=
 =?utf-8?B?MGhWV0xBUzBZdXFLMFBmdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2VTQllDV2J1bTFGRXB6RDBQZ0s0UkxWaWM2NU0wVWJRN2YyQzJ3V3pYTTU0?=
 =?utf-8?B?OGk5REY4QVhGeU1QdkFvQ0xwamtqbkU1ZlJhV2J3VmNIbWF2SVlDT29jeWp2?=
 =?utf-8?B?czJrbVhYS2VVU3lSbmRiaURNaDNLOFVMQ1FTWWtGd1g3YWsvQmJxd3J3VUVX?=
 =?utf-8?B?T3kvcWdyUkFPMmU3VWVHaXNIaC9UL0o3UWR5UXBTS1FSRFZmUCt3dHZtQm9W?=
 =?utf-8?B?NEwrZ3cyYmFZOWloMkpwazU3b3FmY2toV1RwOUJaalFMTk9Lb0daUjZTVGsv?=
 =?utf-8?B?Y1loQ090K0xza2JCUlhoQytoYSs3alpMY00reUhXOWdzemNWeU5qTklHR1l6?=
 =?utf-8?B?TkFzR1ZqUmJ6K1VpcWdSN3NSYzNTTVcrbUJjdU5Od01rNVM2VXY4RG1qc2tp?=
 =?utf-8?B?OUd3RHk5ZjRJVDdWNTBTYVpwb0ZvdFk1SExkS21hVUt3LzVnM2dUZnlXY0U4?=
 =?utf-8?B?SWRERkhzdEIxL01aZGowRXBodXE5NzJsS1lEM3R2cmE4NDNFbUhXOWdMLzJ5?=
 =?utf-8?B?T2ZvRHlnWGlvODY5bVhMQ21ZQWFlVzYwcVBDa3lOQ0hkTzN5dmt4MVB4OTJ6?=
 =?utf-8?B?NFFKS090eTl6ampxNm9Fam1Hb2Y0a01aalY5ajAxVGltMnB1LzlWUVp6bk0w?=
 =?utf-8?B?VkJFSStaNStDS0Uya1RRNVR1M3FCOUpDQmhKUWFJNk8ybXdEQ3pPZktOUURx?=
 =?utf-8?B?Z0VZVnhHY1Q3M09FMlEvYUV1RGE0U0ZQeExtTTVqOHFFQ2pMYnkweHg1bHJ1?=
 =?utf-8?B?NXhrcEtUZHpyMHJrK3Vpck5iNW05NU5WcnJJUi80QnhhWHgxdU5FNGhnUVpt?=
 =?utf-8?B?bXArRHFFaWttSG5yWS9uZ0tQblptVXgrRU5QSTdTNjhHSUxzVkhIa2hwQmJm?=
 =?utf-8?B?bEdndERFcUVSMWp2SjFhdHh6Uk53dU90QzlMcVZNK0tpZy8wSGN4MnZRd0V5?=
 =?utf-8?B?eGVxSzJFWUJONlhYUzEwVFBJSjhibGJzZ1Nxb3lYTmVhSUZTQ0lkbE1HeDRx?=
 =?utf-8?B?cUNyNGZSL292cUxEZjlxQ3Z5VkR5aHRLaXVoYldFSi84UnFpNFY5Mmt5dGZw?=
 =?utf-8?B?L05wVzQzYTZIZmd3RTlyVFhsZlpIVmVzeWhXdm8vM0ZOd1lTQmVubEYrb05J?=
 =?utf-8?B?NWFVdUUzcjFwR0NIRS9QZnlwVTFQQkpyMjFYWkZNaHZMTGt6UjlOb1NGZUw1?=
 =?utf-8?B?SU9XZkNyUTdEM1ZrRjgxcHBEWFg2Y01ZeHhtRzc1WmRNaHBIUjFMMDF4TGF1?=
 =?utf-8?B?Q3c1NTl4KzJLK1pLbG9rUDVSU3ZBZDRCSDdkVTdYT3ltY3Z0NHNjT3p4SnI5?=
 =?utf-8?B?Yk5aM0xXb1Jid1dNZitPeXU1THF1K3pPbk9ReEk0S2tEM1NBKy91bm1jaFpr?=
 =?utf-8?B?cGl5SCsxL3h3Z25wKytzMGh6VTlEanhKM1Q5TkVCc2syQlJUenJNS3FpMFlp?=
 =?utf-8?B?cGxBREZNYjJFZVM5RTFNMGhDV043Y2U3U243L1ZYTWtqOFE0aW5FUmN5QkJx?=
 =?utf-8?B?WHpmNm13QkRKVlg5TGxMOWZnM2FmVVdVdFVlc2ZGaWlDVEhDMEhyMkhVUVpr?=
 =?utf-8?B?SGVicnJrODZEOUZ2eHFCU0VOZ2g1czRQMGdPZFYySnRpTytNcGFKakh6c3NI?=
 =?utf-8?B?OHh0akQ5WU1RZjdJOU1GK3NhaXhrSi92SVZYZjM4cWVFZVVnZE1IMXdkalBu?=
 =?utf-8?B?TmxLdHJJZlJWSmVFQ2lHZnRDOStDem10dmhsQmdVeTBxYW1qTUhYR2FrTGpO?=
 =?utf-8?B?WXRudE9zWmxHbkI4bEZXc2x2OXFEZGpQekdBamN5Y1p2YllZK01sbzFhQjVX?=
 =?utf-8?B?RjhsWXRyLytXM2g5ZnhsNW44bnJPcGx3QTNDRUw5SkpEWVJsTWVpQ3doL0Mx?=
 =?utf-8?B?VjJia0hya2xnVUxxOXZ1MUtFNlZLTm1EOWk0Z1lhbEhRSUJRdk40SWJWdXN6?=
 =?utf-8?B?eThvSVd2ZFppVkV2UXIzMnF0VXBxcCtlOFdXWSs2ZWJEQzRmNCtKeUQwYTBO?=
 =?utf-8?B?c0gydTBONldjaGVlVmNqUDk5dEp5R3FzeXFTT1I3Sm1QQnlnTVhqajBtWnQ4?=
 =?utf-8?B?alEwekVsb3dpVDdUY2h2cCsxazNFYUJZTGM4bTA2OE0vcExPMUMzU3A0VzlP?=
 =?utf-8?Q?nyMKgEjYLzb876JIDlWa5/fbt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f8972672-6e19-4073-b793-08dcc123a30e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 14:23:18.4588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PI3cx7On+jizLu2v7dPrOjisHANZUyWX6lykhqxpGalJ7R3mErIUKfKalxge5+1hPAFYoNiRFnJVNKzPYxGHmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8211
X-OriginatorOrg: intel.com

Philip Chen wrote:
> On Mon, Aug 19, 2024 at 2:56 PM Ira Weiny <ira.weiny@intel.com> wrote:
> >
> > Philip Chen wrote:
> > > If a pmem device is in a bad status, the driver side could wait for
> > > host ack forever in virtio_pmem_flush(), causing the system to hang.
> >
> > I assume this was supposed to be v2 and you resent this as a proper v2
> > with a change list from v1?
> Ah...yes, I'll fix it and re-send it as a v2 patch.

Wait didn't you already do that?  Wasn't this v2?

https://lore.kernel.org/all/20240815010337.2334245-1-philipchen@chromium.org/

Ira
