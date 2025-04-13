Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048A41FECBA
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584747; cv=fail; b=WHKFreBLdzoSsaNh5+u8O377q554SFjvT3IZqKGBo//FbHQBafaz2ZHGb7qmoSyUdHy73PEB4aGTN7in4VQPsfPTUBBuUwCJvR+Xq23KvwwkqLNGBEtc3FbmL5gXoVyQNWIg9C9hUqtR2FMlWTt/Uvgi0BJJIv0K52UjgcFKghA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584747; c=relaxed/simple;
	bh=wkudF2XNTcQS8VPUDMQ571w4CvWff5yrKjJtNZtBW2s=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=U3szl7pzePmDN7/w4+C7EPUPiYCSprx0nL5B8mzga6Kdfi50DkrtZnQuahKCYikuIKpWyrbyokjjXO0cOrFqVQpqyTZRjkL8z32mSxq8cTVVOw8Rhj9fxj1am/Q4+6xgxlpH7KP2WvVyjk8bdMWZzNhLgW0H63yxEkB2TuRRMlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DUBXH5ca; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DUBXH5ca"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584745; x=1776120745;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=wkudF2XNTcQS8VPUDMQ571w4CvWff5yrKjJtNZtBW2s=;
  b=DUBXH5cai9lmW2iG6HcWGmdk6toSJwz4DBH+QHvYDNe7kUe0uhMwjfmw
   Ae4pSN2CUMm1358NW1N7LQ1LyKkuXWKlr6Y0ARGZntpQk1JJzTSrhGk8L
   oUvRk/3Oapqdd9ijtnWQhB/2uxycLxSiur6zySJbxsxOMEPQG1CgpZ3X+
   /9Z2ZGHb/9jIc0sJRQz8vxepphK3eoy11+npJWWpJaUT3VjHt6JEhAFi5
   oze5+7Qv3WC9HQglaRhQrZTebbrsg9eKxf9fQZaus2n03G34bldum52X4
   ZdeDYijAXQHkQejCPEegtV8gGmefUU39edKE9EIO51lb/jr43AazE/sfD
   g==;
X-CSE-ConnectionGUID: 8bsd7F2gTyCeUGD6amR0yQ==
X-CSE-MsgGUID: 1ZA9Oq36TbKcoXKJ5HWqdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280947"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280947"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:22 -0700
X-CSE-ConnectionGUID: 63yr2e9gTqqcH3hTpgEfDw==
X-CSE-MsgGUID: /cihgiucQ8W8OupWJpRtgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657627"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:21 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WaEqpOAEbVU9uT/MCZX+XZ0VJKOIoVg5TugwxWSDMkuZpAimSXRmDbtGw64BWAxMWzpbMX5sLkNht73POhbxOUw8uliHhRfzUeZPAoJuPxyRl+rZmQK2eMgAgUaSGAJ+r0NCQBZ/wgmUgkJNhmTTaPiVOWdvqWXuSk7AktlLSvHpl1GHG06Fv29m8/TrZDVJbzE/RFxNNUgvh6oc222Ar0PlQbYZqWfT7fxmO/Bhaksez6jE4wcsn4H+6ih8DdgoNhfp7AMFE821Q0Uq/EZngptpCU5oqbSQTGczjLijeRExVJ6rstvkeNrHcQzrRKg2Jua0WjupC+5FkIjXgKavIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xHChTg9LEV/qJAb1pJTzHBnMQyur4fyxjR7vjkIpdhk=;
 b=IBJelhyhXSOjQcUVOngq8tQEm2FT8+jx1RsGZAglEXIcQYTBc453ETWaG3yQGzmTZcvsrdNZ9Za52ih1eDfLgMr7/ARXhgxcLT7Nrl+JZyKASoPIKdzBvLYDypUvrOHt40kw+CrbFEiZlHnewMXU/9D5s8SmjNuM3+VJA+OpTSon+3cEsACInz3YokPd/J8f8BuHCiMHrUy+nFNWZMq3hILKluwOrcgWv3d8WEt1EarU9ffNrD6C70nmPINZ6etzfoLoDMQoWhI94JgH28Y16ukKCulEvOBt08omRrxAEN3Xk9conjWcDa5drIe/DWQ5bVGoWAFoYpJElyzfkjCRcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.28; Sun, 13 Apr
 2025 22:52:00 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:00 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:19 -0500
Subject: [PATCH v9 11/19] cxl/core: Return endpoint decoder information
 from region search
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-11-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=4478;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=wkudF2XNTcQS8VPUDMQ571w4CvWff5yrKjJtNZtBW2s=;
 b=qhzG4PaAzvVurrvwp6PNMi09MOnwGo2di6304YuKuEHO3itK6l3RaQvXu6NjdjeEvBwwQzhxv
 4ZGYHmnYlMJAkvmhyDnvAe+Kx2gnwgxxb71xVol0j6jm5WWesbpJ9TU
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW4PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:303:b9::22) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|DM4PR11MB6042:EE_
X-MS-Office365-Filtering-Correlation-Id: d89e3e88-eafe-4c1d-c85f-08dd7addcd11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UTdnWWI3NnNNL0QyVktseGxWRWk2RDhPQWpiMzlmUXNpV1REUk1Bc3BsNG5a?=
 =?utf-8?B?d3M2YWIyUDE3dDBjc2FDMzBRRkw2aGpiVjcxRkk5REFpdFBxQ0xuK1ZKNklw?=
 =?utf-8?B?dytYaWhUQm1CU05DRExZT2dOSDZqcmFEdUd6eXBRZHByaEJEMFBBNStSek5q?=
 =?utf-8?B?UElTRXFxK2hVWlJaSy9rNkxlNllRVTlOSzFsaGhGcWRMaEJFM1QxdWNkMzYy?=
 =?utf-8?B?OUZDRGxGejU2MkZNaGhsaVJ2Ylk1ZHVveTFKdTkzQ2Z0cXFHNjRJVVJiWUlj?=
 =?utf-8?B?WUlRTm5vQVNMVFdUbzRpVG1SVWRxUVFIdDVDRE9UQUtlaE9CenUwb2s4WDRi?=
 =?utf-8?B?UzhLa09nT29BeEpDbHB2d2NOMXRtanpqYUhwMmp6enRuem0xWWlvOHhEY0Rr?=
 =?utf-8?B?bjZlYUt4TnVsbk9waUVtZW9zc3pzTVpUMkRyVzQ1R1EyMGRRT1hwRWtFTWRO?=
 =?utf-8?B?ZnhlQkZia0JHd1RSNGUvd2FUK2NaSVRvTnNjcjUvM3BRN0NYQXVXNllFakFh?=
 =?utf-8?B?ZngwdTZBSWdhdlQ5ZCtFMkZlQmtmZzN3T0QrSWxzK1U5MkVYUThZRWttN3dy?=
 =?utf-8?B?V2dyS3RxYzdpWDFrODFkdjRncDhPU2I4N2s1MnoxNlJpaVdyeVhJdXBndmhW?=
 =?utf-8?B?Z2lSZHdvWVkrdTFrV0xlMXpzbVFHeW1RZ0g4MkFhVGZnSlJ5UFdUUFltODhY?=
 =?utf-8?B?cERvdVhJekRtZkN2a2k3b2hCbU5ETHFoTjRlaEFJZ25WamlQcGl6TTlsZG54?=
 =?utf-8?B?eFhUNW1SaUZRRm1PS3IvVUcxT3RqaHhEUG42ckRFQUNZRFplVzZMdGFCV05v?=
 =?utf-8?B?ZGp4dnF1Yi96VGliRnI0OXUzNFdVSFBQR09yWlJrWExBdjIzQkRXSko5WmhQ?=
 =?utf-8?B?aXNBUU5keGxhY3JhQjFaOFp1MzFUbjBXdGMvRW1ZdTFMSzVpcC9YWG9sYlF5?=
 =?utf-8?B?end2MkhYcjhyZjhmV1FMalNqNGFvWDJnditHcEVqUDZUSG1GNHVzYS9kYzhD?=
 =?utf-8?B?cTM2YjUwNGJjUWxQV2wrVWNMN0hkeEpkZ0cwWmZIQ2w4MkVjc3FucmpBY1lW?=
 =?utf-8?B?MUc5aEtmSElHRnlsS3RWb3hVOTh2UzVrQ2dPTnNJcUZ2cHNPQmZQWkx4ZEUw?=
 =?utf-8?B?VmFsTkZSd1ZFZ0YrZkhIRHRabCtRL0JOc3pSVitTQ2cyOUQzeitlZ0xsT2Qz?=
 =?utf-8?B?OTV3dU1WNWlhNmZzNWs1QlVKVjVuZ2RrMjNNT2NWcEFFWWhLM2Y3RVFiczVw?=
 =?utf-8?B?bVBva1JqM3pkN2lxZTdxWitRN3VZdjZsWmNMY0lJbnFZRmRhTzVMaGh3ZUJn?=
 =?utf-8?B?STdQUXJ0RndjUTc4ODJQbUZhVXJ1SzdCNXh1dE5pOXk1Z3FlYnpFcHZkdkJq?=
 =?utf-8?B?OUdyRmpIVllNYnkvS0VadldBZEQwK3Z3LzZGdzIvZ2d0MURKa2JMNU9hMHN2?=
 =?utf-8?B?Ry9vRXpDTU14Q2t4MXNMT3BUbEdMUHZIbU5kQkFqWEk5Y05DckJ5am5RdzV0?=
 =?utf-8?B?Z3JLb1VlZTZ3QXNQUm95bDB5aEE4eFYyTGZkd25HRXRFWEFjaGRtcjJVMldG?=
 =?utf-8?B?ZWVkcVBXWXJMMDhUZWZ3c1kxWWJpQ2UxK3ZTRnRVWjhKSGJBcERTc3JuVXVS?=
 =?utf-8?B?bXpQSzJ2ZitDRHhWZVdXQ1N3WDduUFdZNWZVRjJMOXFMdUF3amo4aVZRV0po?=
 =?utf-8?B?SUdpbkZnZksxdXNxcVp1NWRheTNmK1pyZFRqMUlNQXN3SzNtNGJmbFA2YjVF?=
 =?utf-8?B?Y0krMFhNQ1RVL3ZJZ3ZHbWE2Q29jcWlxaDVmRWF0RGxlcVRpbGpwVjByM1h4?=
 =?utf-8?B?SjAyR085TXYrUFBBNXJ4WEJhOHB1a0lvTlN5K1lVZzk4OWo1MEVpTWdLZkVG?=
 =?utf-8?B?b25iYTZ3V002UldURWZCY3M5OGVBNEc3ZHdlTVJQQlhRamVmcHlKZDZEem0v?=
 =?utf-8?Q?h8X33D9SQbU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFRGMzRJUTdNRWdBZmVPTldBNWV6Rmt4TndYV3QyMjRNa1J6TjBKZnFOK1FD?=
 =?utf-8?B?OFp2bEFzdC9UMzBhTVNYZ01KM2dtanN0YXl1ME10MDIrWGprVjRvekZoNGEr?=
 =?utf-8?B?anZQZlp5S0ZVTXlGOFpZREkrZEQzTkVmQk5XYmd6Mm12OTVtWCt5NTEyd2xw?=
 =?utf-8?B?YitLMjRST05ZQnRpS3JxbUdRbFpZd1RDajZ3bU5wdHczaEJkbStqREZyTWRo?=
 =?utf-8?B?eVl6cUUrRDc0dlBFVXFwaEI0WVgzcmIzV0o5b1l3MzB5SE1ISXlTVGw1bDJw?=
 =?utf-8?B?Wk5ncHlTY3k3SVBtMTQ2R04wS0FOUFU2d2Z3Mmc5eEUzSC90K3I0c2JxSDZ2?=
 =?utf-8?B?aXNwaTlJL21XQWpoZmpLb1hmMXRBd0dsN3VlaUZRZHhBckcrd3h5bm8yQVQr?=
 =?utf-8?B?UllwTmJReHJWd3RJZksxS29QVjBmTFhHaTJ6eUZnOGlYNW5ETTY4cVU5eTgw?=
 =?utf-8?B?Ui9tbFdJeDFiWVVDK1RzUlZhZGZtODQ1VU04anVGVkdUeUZ5eVh3a1Vhcmx5?=
 =?utf-8?B?WkU0UG1tS1NUN3VNZk4rU3lxUkZaRlFHOUFmdnNOY1pmZkNjODVTb0dIcnM2?=
 =?utf-8?B?bno2MHA3RmJSM2JacE9WNWd0ZVJMTXlRT01ieGZlcTlESm5lcTV1S1VWRVJV?=
 =?utf-8?B?QTFtTDBnaUdEYzQ0Z0hWcWc1WGxHUkNkQUlaeTJKeVpLKzJWTjBiaXpFSUtU?=
 =?utf-8?B?RHMxdjBsTFJtZFRPa00wSGlYUlJxUlMzMGozZEdlaTRUYmt1WU5SRXFxZmZy?=
 =?utf-8?B?elNkY3JyTjFIcHJaWWJqS3Qzemthc3NTRDRFNHArdlZ5SzJ1QVMwUmdnd09P?=
 =?utf-8?B?Wnp3L0Fzd0tlbXZjRWIrMG1CN0tBMXZOT2V6R29BTzlQdC9GaUcrTzl5NkVS?=
 =?utf-8?B?SWUweWFGS3Uyb3MvZGJ1RHZOQUptWlZsajNwdWs5L0QrMENYQ2N1VHNCQmJR?=
 =?utf-8?B?WkNSaVlSQUhxSGhWNVA3aVRQSE01Mk42RGlIM0JxSXBWMEJaeXRqaDNPVFMz?=
 =?utf-8?B?QldQQjhPbjRFeU1abHA4aFZSRlB2T3RsK2VGaXlBKzd1RnRNZ05MZXBaZHRX?=
 =?utf-8?B?ZVp4eTMzN2VlTU1PL2FjNlRzeUVmV3V4cVNzNGNmYnhwd3czVzJPZFhCdzBu?=
 =?utf-8?B?RDVIZERTTlZZMy9GNDR2MnJlS3hnRUlEdTFvcEdXcU0wTUtNM1dYeHU0c25U?=
 =?utf-8?B?S0FwY3VjbmtHT3lIVi9PT2VvTWk3Y0dLb2RXVUFjODdYa1NzU3REWjZpeXRP?=
 =?utf-8?B?TTNrVmdaUi9rMStYQlVubmJaTXhhTTlyTGVMVHRFcUJNY1pObXdTV1c1K0x2?=
 =?utf-8?B?UStrWGZhMmlQNnRjZW45Z0JkMkIrSC9lSjJzRWY4NVkyWU1uZm5CYkY4Z2c0?=
 =?utf-8?B?M3FQakRjZlQ1amtrbUJ1c1FkbHFraEtTY1c1aXFPeFhWd0tHOXZFUUVUVDVq?=
 =?utf-8?B?eC9NZlRESllHZmxSelpYbVZ4enJoUGk5M1RCdU5wRlZodDRaaTIzYkJZM0tm?=
 =?utf-8?B?R2FvZmhaMXM1d0NLcEg4QlhuT0JCUmNUeXhnOFVjdXBGMEYzcFBHbnVqWTFL?=
 =?utf-8?B?VXRZNVN2VXJReS9QeEs1ZVFkNVkvUUZnd05CSVRWVGJHcDVMMXJ5TUxXbU1i?=
 =?utf-8?B?bURFUksrS0NicFdsRGVsMi9aSU9hUVNVMStpSUw4NWhpdWw0ZDloSUtkRnY3?=
 =?utf-8?B?c0VmSWdSdmo3dlRjSmV3STl4VEpXOWpiRjBldWlobU5OZUVKVjdNMkZ4M2Jt?=
 =?utf-8?B?eGl5S3hMOGxWeC9JM2puaUxldTZNcGhsVG1uT29UbDU0QkVXNFJ5eXJDQkw4?=
 =?utf-8?B?M2h2UllxZGJ1Sm50RGVaQURPS3BxWFFBTTBmdUEvdEd4WEhqOEdvTG9RVjBW?=
 =?utf-8?B?cGJJSGk4Rm9VL2s5aTBQeit4dUp1VTJMUGRrdUY4aU90d3QzVDUvOWpRSit1?=
 =?utf-8?B?c1lYSDJqZXF3MHgxM21xVERmZ2Vnb0ttK1plRHpWSUlPL1dMcFprcDM4NUJ6?=
 =?utf-8?B?d1ZKOVZXZHVoc1ZjNkNlblJ6L1dZYWV0c3FQa3RQdDRPaUg5VW5abWhuL1JJ?=
 =?utf-8?B?ZnBPSWdhb3FSQS91eFBwa2hKMUpKRlg0eFkzSzNsYnMzRmIrMTVMUXV3TWJG?=
 =?utf-8?Q?6grNKALy5IZCH9a89Go4scNgy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d89e3e88-eafe-4c1d-c85f-08dd7addcd11
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:00.6300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jQckqDImRY5pMabHSSwuD9R8CB/bEhYKrCQFvsUvCtaCyJgncQRbC6uB2Hn3BhmW+2YhukkjTIrR6p2YBKgOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com

cxl_dpa_to_region() finds the region from a <DPA, device> tuple.
The search involves finding the device endpoint decoder as well.

Dynamic capacity extent processing uses the endpoint decoder HPA
information to calculate the HPA offset.  In addition, well behaved
extents should be contained within an endpoint decoder.

Return the endpoint decoder found to be used in subsequent DCD code.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: rebase]
---
 drivers/cxl/core/core.h   | 6 ++++--
 drivers/cxl/core/mbox.c   | 2 +-
 drivers/cxl/core/memdev.c | 4 ++--
 drivers/cxl/core/region.c | 8 +++++++-
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 08facbc2d270..76e23ec03fb4 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -40,7 +40,8 @@ void cxl_decoder_kill_region(struct cxl_endpoint_decoder *cxled);
 int cxl_region_init(void);
 void cxl_region_exit(void);
 int cxl_get_poison_by_endpoint(struct cxl_port *port);
-struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
+				     struct cxl_endpoint_decoder **cxled);
 u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
 
@@ -51,7 +52,8 @@ static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
 	return ULLONG_MAX;
 }
 static inline
-struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
+				     struct cxl_endpoint_decoder **cxled)
 {
 	return NULL;
 }
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index c589d8a330bb..b3dd119d166a 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -957,7 +957,7 @@ void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
 		guard(rwsem_read)(&cxl_dpa_rwsem);
 
 		dpa = le64_to_cpu(evt->media_hdr.phys_addr) & CXL_DPA_MASK;
-		cxlr = cxl_dpa_to_region(cxlmd, dpa);
+		cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 		if (cxlr) {
 			u64 cache_size = cxlr->params.cache_size;
 
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 063a14c1973a..d3555d1f13c6 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -320,7 +320,7 @@ int cxl_inject_poison(struct cxl_memdev *cxlmd, u64 dpa)
 	if (rc)
 		goto out;
 
-	cxlr = cxl_dpa_to_region(cxlmd, dpa);
+	cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 	if (cxlr)
 		dev_warn_once(cxl_mbox->host,
 			      "poison inject dpa:%#llx region: %s\n", dpa,
@@ -384,7 +384,7 @@ int cxl_clear_poison(struct cxl_memdev *cxlmd, u64 dpa)
 	if (rc)
 		goto out;
 
-	cxlr = cxl_dpa_to_region(cxlmd, dpa);
+	cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 	if (cxlr)
 		dev_warn_once(cxl_mbox->host,
 			      "poison clear dpa:%#llx region: %s\n", dpa,
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 716d33140ee8..9c573e8d6ed7 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2839,6 +2839,7 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
 struct cxl_dpa_to_region_context {
 	struct cxl_region *cxlr;
 	u64 dpa;
+	struct cxl_endpoint_decoder *cxled;
 };
 
 static int __cxl_dpa_to_region(struct device *dev, void *arg)
@@ -2872,11 +2873,13 @@ static int __cxl_dpa_to_region(struct device *dev, void *arg)
 			dev_name(dev));
 
 	ctx->cxlr = cxlr;
+	ctx->cxled = cxled;
 
 	return 1;
 }
 
-struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
+				     struct cxl_endpoint_decoder **cxled)
 {
 	struct cxl_dpa_to_region_context ctx;
 	struct cxl_port *port;
@@ -2888,6 +2891,9 @@ struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
 	if (port && is_cxl_endpoint(port) && cxl_num_decoders_committed(port))
 		device_for_each_child(&port->dev, &ctx, __cxl_dpa_to_region);
 
+	if (cxled)
+		*cxled = ctx.cxled;
+
 	return ctx.cxlr;
 }
 

-- 
2.49.0

