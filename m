Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00063215075
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584764; cv=fail; b=Qk7IF6bUDiCbeXTFumjlyx/jufkUC1XCKf4bG1qIHTGRcqgUWQ3lUt+Mh8fAmNVw+mwmH+5A8u7TEQwrM9/DYfrMKNdg9fVEzKWg9azyFG4f3xaSTUbgoA7uDZh35elFDfwEmM67DNQcI0S6GtnojUXF7M81meSKC0+u3svlbBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584764; c=relaxed/simple;
	bh=dFdwKs0png9HOITFWXrcRB3D1JUC59zlUdaHmJQc6+I=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=gopomScrEey1BhKN55wOweCyTgLjUXHrsHRM7rQ/cVf3APJ3gAc3L1AcOCtayvU9/wi2ESzpi8o/JGjun54Ac3yB+dUSKELKbSCgDnQGo9VB4kKLCuoxfy/2RFhgooCpNizKQR8d5T2uF2/1LFYw4B+7WBSyLEZNQ6OfAvvAvsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R5+YBjj7; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R5+YBjj7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584763; x=1776120763;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=dFdwKs0png9HOITFWXrcRB3D1JUC59zlUdaHmJQc6+I=;
  b=R5+YBjj7nQH8yCBXoLGD1IeyX00fwqMnWqeWQ+wamDJI1iKuxaHFSsQV
   E2PCSvIbxrU5sUi153KsspshHOTQ5ecCvG+0/Pz2osz0vNelF6lwgL5ks
   girXxCSDNA3gNLV3OdsVkCTDc9+yLkqxol8csei1KSSEXJdYOg4U2bzRA
   pB+VhjHjshb1NbVtUflknWfjbAR7W1P3p6uRnHiL9yUDPnZaYVAZI7yWt
   3FBT/aiC2O5tUUfS+TGVHrWBuRneUp4IrHi8CMid03jcjaBiImhgIcrAN
   yCmznUvg48TXOyrky0YmKiPeD2Uykh0rY7MO/n/dhL2Y7YZo9O4JTu3zT
   A==;
X-CSE-ConnectionGUID: pyfEL464RRCv8TYXBJRQaw==
X-CSE-MsgGUID: NQXliGw2SOyvoSgvCv9AWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280991"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280991"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:43 -0700
X-CSE-ConnectionGUID: 7lTcAC3aT/eCjbwDMeIcHw==
X-CSE-MsgGUID: yV/ZO9HLS8e0w0UwYKdXUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657645"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:42 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JMDF4rB/cZa4LAhLqqlpkus+DDBTdhwYiIDUqCAuDv/sQajv/cz7vjage4d1zNft6VQncXRd3XUO0zdOAmXrgZw5h7KE/6AvOy2Ys5CmYo+m8vETvRMwUeI0m3QJeCf/Q2HclfcnjQUP7XKkkLbHD1grKG2aDI53IVULD+RfOTiclhHMecppTY3xv6LmIKH+sFc5c9MTpUlbYTTACej4HKCcuGWh9aOfb2VBcyupTQKu3uRRaHhTfF/35T8IRZZWxx1OILOzpGKkNAAgFc98z2hc/XvB9wh1omWyLoszOA1EzSE05KIXR7Fki2nnU7rP5matkrIA0Xai0GypRqb27w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qna0HqNONCD2fzhnPQVIjl+GxH4W0hRw8y2V2kT4o0c=;
 b=j29edv6ipj4hWkEmIV293cnD0vOV3R2aXOYQ9Es1jbJY4ya8egDomGuLA4jH7ylp8IKsKcnLkLtUbivdJsCUCreWHgzrUD8rZ87g9hN626+iXHGkc+8bFouPpRhMqBgZQtJGBiHXwzTQ0ILk/dGGTLu8SKzHMvomv0BXm73mVAHhexKIBtFs7gzE0eTyIlUyo3jXQPtgngNREexDlBwICfV4uaLA0YWxiBz7kymU0wMkfhWrKyNn2DAuwPHxv2xa4tabgWKY2v5cIkePxHYlIF38sEY/LZR7YZQiL3jWkQQXRVAU89oleyJKUL9R4jTFJNPJrvLAdSn1pXNaQOa7pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Sun, 13 Apr
 2025 22:52:40 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:40 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:53:01 -0500
Subject: [ndctl PATCH v5 4/5] cxl/region: Add extent output to region query
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-region2-v5-4-fbd753a2e0e8@intel.com>
References: <20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com>
In-Reply-To: <20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Jonathan Cameron
	<jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, Sushant1 Kumar
	<sushant1.kumar@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584788; l=6303;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=dFdwKs0png9HOITFWXrcRB3D1JUC59zlUdaHmJQc6+I=;
 b=Ew1zSf4QRDm9varIU/fjo4gi0mJLqICjqFm3SGvFbXeNs6WiYcP7gqzyUrvHz3eNF+RfK5jOY
 vhz9v+QKHJuB3V4/2EeVDsQD4aBQp5uiQTWrH4ARD2dJzoYpobubQKz
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW2PR2101CA0016.namprd21.prod.outlook.com
 (2603:10b6:302:1::29) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: c2f675ad-17fe-41b2-677c-08dd7adde49b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bkpMKzJZWWVlNXh1dTk5ZVF3UVBHR3h6Ly9wd0VoSS9vcUhWM3REWmp3Rk4r?=
 =?utf-8?B?eVNsbVhBTDFVM0dIWVNsYVdGR09MNHVnTjRNRk1tR21PbFBYSTZlckZWRGJL?=
 =?utf-8?B?NmNzbXozeUJIZ0RKVXJMVzVQUnI1ZFpydzMzM044cmRtRTZiWEpCaitOS3Fo?=
 =?utf-8?B?SmdERjljMGE3c0F1S0RFNTdWdW9WM1hqLzRNTit3SVZZVnVoMDVkbllZVjlr?=
 =?utf-8?B?ZFQ3bjZLK2JqTXVaUWljS3NPNDdJcXlpaTBKa2pGTzJ1MUdQRDFMMCtJYmZw?=
 =?utf-8?B?aDBLMVhyWkxneWtWbnFuWWlEdnkybWFpNVZnUHlqSEF2ZHRyZ1FNenFkRjlL?=
 =?utf-8?B?alRrMy9pV01PdS9nMWJERi9sQTgyUjBHWVlwc3JqMFZ0VXBJSUhxSVVnQ0Q4?=
 =?utf-8?B?OUpuc2VaMlRwdFFQaFdvL0VCVktBQVpjbWhFRHlLNXRnUC8xdjFrVk1wdW8y?=
 =?utf-8?B?ZS80VkpndXdua3IrYmNHWEtTSlhnYTcwL1l6QU42WXpXN1VwR0R2ek8xNzBi?=
 =?utf-8?B?Y3IzMXJoVCtja2xVRW9wRHovWFEvRHRpbWJLb1NNQkpPYkNBQUdkZ1l4SEVH?=
 =?utf-8?B?c2N0TkZFSXA0V3BZTHZxdzk5eGdUV1lJVk9yL01hVWxyNS9COWQwRnFXODFQ?=
 =?utf-8?B?RC9qV0ZEYkREWFpWUnZjZUV4RVJoZmg3WW9CVWFGOHpQZUt1aHdIWEVVZXY3?=
 =?utf-8?B?Y3VvMjhFSTl4dmE0VVJmcCtiRUhsbFRPZXREamFtYXJBUU91UFNVZFVtNE02?=
 =?utf-8?B?NmpIT253Q2pqWnJMKzlGbEdHWWdQNkJJd0kxbmVGODRremtrYmVSR2hscUhF?=
 =?utf-8?B?RW5mSUh0aTFrV3ozYzU5UjBXRlZoTnJIOW5BUFRoeERJK2lhbmp5QmsrQTNS?=
 =?utf-8?B?VS9DQVpFb1FKUWpwQ21IaG1Hc3hZRVNZNE1oRzVnNUhwMnhKVVRkZ3hlK0lL?=
 =?utf-8?B?ZTBablpFcTF4L25WQzZIREZyem1kRndjM1VyK2dOME5Nakk4VjdvcmplNXlD?=
 =?utf-8?B?Vk5Md3BJRCs4OCtmSU1FL25kZjZCV2ZhSkdSVnBaMkdSdVMyYkdEdWxBcGVs?=
 =?utf-8?B?VXYrb2R0YytSQWVrUGdLY1ZMcWpGQ3NTTkZEWFVKVThNMUlGYXhHeHRva2NE?=
 =?utf-8?B?SjZ4NW05WW5hbENPdDNQNGZJTGp0Z1hoUlozL2MvRFRYSVRINWhDRVA0RzVH?=
 =?utf-8?B?WjBENTk4UmhiQyt4cU1vZGs4KzJjL1ZMRkdGRUNqZ3BGTXpQaEYxeVhYNGRy?=
 =?utf-8?B?MWdpU1VqdklyUmZhUGFnQnU1NlEyaTcwVVhGaUpPSFZHRGVVMndHc09BOGRh?=
 =?utf-8?B?eXc2LzNJTzQzUk02ZzhDNmVpNDYxejBtS1dJNXd1bVN2QWJyaVFOLzh5WXFw?=
 =?utf-8?B?ZExCMnNXc0lRSFZpZUNWU1RST2FaT0JIYVB1KzR3REdsYmdESjlzei9TLzJB?=
 =?utf-8?B?SWZaNHJQM29ZcnFPSXNqTlJuNVlHVyszcFp2aGsrV0RSdlV1MEROcGlLWFRi?=
 =?utf-8?B?SWFKd0FyRmErc2JSRVovZ1hmQVVobVJyT0lwZ0FNZkk0L2JYRUdscVE2M0pW?=
 =?utf-8?B?T1hFNWFjK2lQNFF1TzJGWjMrMlZwRHcyVXlabWlUNHlQWURpYTdpSzNqWGFs?=
 =?utf-8?B?bHRNTlpsRlZweWlEUUxKU3Z5cVkvSUVyajhDTWJoOVdZNHF4M3BBVXk0dXJu?=
 =?utf-8?B?VVNjTmpKWVgvcEd4OUN5ZnpTVUZ6dnA1bUltbmFVSG84b2FOSnpHVE9UZzJa?=
 =?utf-8?B?aDNJbGw5SGJTWWlESzZBN1N2VmN6UDFKY0U5djU2d1BUSDdHaWluK3FmMDdx?=
 =?utf-8?B?ZkgwR1dwQ0YyVGM2NEIzcDlGMHlrM1dFaXFIRHNhUFZRNzdaNXNwTzd5TExD?=
 =?utf-8?B?N0J5QkJ1ZVAwMWFPZmJVS0hXRDdqY1hEZVEya29BK2ZCNk1Tdm0zOUpJQzIw?=
 =?utf-8?Q?jUOAyemamZI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFFBc2pLSW94MTRUMEtKa0JSc2pNTmh0cVZsd3lna29WMUEraGZFRmNnb2Np?=
 =?utf-8?B?YThud0dXdHZhTXNibEZlbjFtL0t5dEdLSytVSDNyQXZUbG9hSWpGL1RsZXV3?=
 =?utf-8?B?VXVQOFZOTXZFV09OZWpHYmhsQTRMeUhtTHo2NURoY2EwUUtSYU9DZzU5Mm1i?=
 =?utf-8?B?MHRUTEk1Ris2YVdiN3BaNDNYNkhQc3RCSFFRWnFpM2taM0I4eWhaeWFVYUdG?=
 =?utf-8?B?L3pUTTNQZkpoemZqbTJZUW5Mc3kxb24zbW1JVTdmLzJ3YUxyZ3VMV1pZV09k?=
 =?utf-8?B?cC8vSDZRL292VFhDM2h1QVQrTmdkUU50cENkd29zTGRxQ3BQaXNOclpQandx?=
 =?utf-8?B?TGxyYWwzbSt4b0NRWXBJTVB1NG0vMEYxTTErYjc4N2Q5eG5acUZiVUMydjdo?=
 =?utf-8?B?K1VQaEpxUXFHeGpnNnp0blgwSmJRUnpGazJIYXo5bnV6a3ZaZTNENVM2SXVE?=
 =?utf-8?B?SEhxMU9qVjdUeVV6UmRpUVhSYkhzdEFpaU95SzVvTjI5emd3WjkrdnZvSGh4?=
 =?utf-8?B?aCtkRWFyTjNYd0I3VTlUREx0aDFzcENTQ0FwNXdzUStkNVRORTdTQ0FFeTJa?=
 =?utf-8?B?d2o3NTUyMzM3ZFN4YmJaNVVQYlZCY1VoTlhJSkFrWFBJNEttTHJVOE8zeUhX?=
 =?utf-8?B?c0NBdm1YQXFVUUI5Qk9XZ3BTb0VwT3VuVG52K3g1VWpsRmFhOGt5WC91WjlL?=
 =?utf-8?B?UCtrZUFTNHczSmh0UTQyWlBOTkpaNDIyVWgydlBINmpaV3J1cEFBRlVRZDFN?=
 =?utf-8?B?Y3l5TGRaWXUveGYxdkxRNkdBYnQ4VzdhU0dhK0REeDhQVldjL1U0Rlk2YXla?=
 =?utf-8?B?R0dsSndTcWRxaTJOUjZoQ2wzRGdCREx5REUwSFlzOHViK0lLbnVqc0NjR095?=
 =?utf-8?B?Mlp5cjF5cklMSjJnYmdHSkZTN2h2b2dXeldzemNydGllZ0lwYUx3VTF4KzhU?=
 =?utf-8?B?V0RjcnY2OXhjWjk0U3EvN0RWaTlIVll1OE84YXJFYmpFTUwxNWk1MUQ1U3lD?=
 =?utf-8?B?dWxlaWxKTnRZaFdCT3pac3kzdjNZcERFblFYd0RiT29UNlZKUURQaWM1V0Zm?=
 =?utf-8?B?R0RBOUNqUHJMaU9kcEplQy8zNGdaWlYzSGpSVml0QkFWRS9aYkNiSEpsS2xG?=
 =?utf-8?B?bkVRR3FBYWcvbFNWVHFNUmp4SG5XWFpKaDh2SnlZN0FHRmRrYkR0MzJ6Q0lQ?=
 =?utf-8?B?elI4QUN3TXRiZVBURE92TDFoRGJpNU1hZzMzak9xb0RvR1RPL0FOTzZLTTVv?=
 =?utf-8?B?RDcwSkdxMDdQeEdOVndUQVo0QWNZZTFnemJVVURpbEEvU0lLejFCY2lMd2Nn?=
 =?utf-8?B?QXlvZ1RYQkVEOUkxNDVDVEZjWWgxSFpRL0I0eTMzR1JwZFlwSTg5SmlPcWpG?=
 =?utf-8?B?T3Z4UzN1OHB6QWV3ZWl6OWZ3c2xycVIwYkF5RWQvTlNBSDZuZkFLRUpxdEMx?=
 =?utf-8?B?encwNFk2eWZIQi85eGFNbkZuWVV6Rkx3WC9yclBHUFAwYnRQUU82SlVlL2dw?=
 =?utf-8?B?NXkzVTB2SGNqdS9ZajNEZ0RoOHAvM2d3WmlyUGU2UE8zTTdGK3VoWUQrOGdw?=
 =?utf-8?B?QkVYK043VjB5a3R0TStNVWZTRmkxdFdsaGJJUVA0UDdCbHlBSUtzQXBIdFpR?=
 =?utf-8?B?Rm0yRDkyeWpsWVd6M05hN2xGQ2N1TlZlcnJDOXBCWlhLUnR4VWM4c2pteTlB?=
 =?utf-8?B?Y1A5aURXZ0trTUVBUFhsd01yQktHS1RuTHYwMDFqaVRtWXRTaTkwMk1KSkU3?=
 =?utf-8?B?K09SeXdSc0lDWTErN3IxbDlNY1pKakxkUnVjdzZZV1BoaEhxMGdTaTl2WGFT?=
 =?utf-8?B?UE5tNktWL25rVjMzSVRNdmg4cFdzK3FEeTlwOU84dTR5Y3FJL1g3MWFJNjJU?=
 =?utf-8?B?SzlXYXJzMnVJeXR2N0RidG15T3EwZWtSVldqTEZSaGgxaEhQUkpOQzBFNk5u?=
 =?utf-8?B?UW9CNjVOYjBRODVaa2FUcENXZkNLSDJKNWVCRW5XQjlFaHgrTC82R1JvMHBJ?=
 =?utf-8?B?MHdMQ2sreCtkaWVVY1UrbjFsaGJQOFVXSFZJY29pR1FVZk01Y0ZPY1BRL2Iy?=
 =?utf-8?B?VVlmOEtCcTcrREYzTnBpM2F4UmFMYzIwV2FBU3ZZWGE2Um02dUxveVFBMmc4?=
 =?utf-8?Q?HOki0Gn/FylJ+4l+CsbwiRdgy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c2f675ad-17fe-41b2-677c-08dd7adde49b
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:40.0309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kelD7U839Yywf5JHmsZ1KSiBTXiN4/BIU6u2/ty187CxkRUZ2sJa4xPWBslwWkK8tiQJI3qhY67eXU1AKMt+nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

DCD regions have 0 or more extents.  The ability to list those and their
properties is useful to end users.

Add an option for extent output to region queries.  An example of this
is:

	$ ./build/cxl/cxl list -r 8 -Nu
	{
	  "region":"region8",
	  ...
	  "type":"dc",
	  ...
	  "extents":[
	    {
	      "offset":"0x10000000",
	      "length":"64.00 MiB (67.11 MB)",
	      "tag":"00000000-0000-0000-0000-000000000000"
	    },
	    {
	      "offset":"0x8000000",
	      "length":"64.00 MiB (67.11 MB)",
	      "tag":"00000000-0000-0000-0000-000000000000"
	    }
	  ]
	}

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: s/tag/uuid/]
---
 Documentation/cxl/cxl-list.txt | 29 ++++++++++++++++++++++++++
 cxl/filter.h                   |  3 +++
 cxl/json.c                     | 47 ++++++++++++++++++++++++++++++++++++++++++
 cxl/json.h                     |  3 +++
 cxl/list.c                     |  3 +++
 util/json.h                    |  1 +
 6 files changed, 86 insertions(+)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 9a9911e7dd9b..82e703620136 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -411,6 +411,35 @@ OPTIONS
 }
 ----
 
+-N::
+--extents::
+	Append Dynamic Capacity extent information.
+----
+13:34:28 > ./build/cxl/cxl list -r 8 -Nu
+{
+  "region":"region8",
+  "resource":"0xf030000000",
+  "size":"512.00 MiB (536.87 MB)",
+  "type":"dc",
+  "interleave_ways":1,
+  "interleave_granularity":256,
+  "decode_state":"commit",
+  "extents":[
+    {
+      "offset":"0x10000000",
+      "length":"64.00 MiB (67.11 MB)",
+      "uuid":"00000000-0000-0000-0000-000000000000"
+    },
+    {
+      "offset":"0x8000000",
+      "length":"64.00 MiB (67.11 MB)",
+      "uuid":"00000000-0000-0000-0000-000000000000"
+    }
+  ]
+}
+----
+
+
 -r::
 --region::
 	Specify CXL region device name(s), or device id(s), to filter the listing.
diff --git a/cxl/filter.h b/cxl/filter.h
index 956a46e0c7a9..a31b80c87cca 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -31,6 +31,7 @@ struct cxl_filter_params {
 	bool alert_config;
 	bool dax;
 	bool media_errors;
+	bool extents;
 	int verbose;
 	struct log_ctx ctx;
 };
@@ -91,6 +92,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
 		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
 	if (param->media_errors)
 		flags |= UTIL_JSON_MEDIA_ERRORS;
+	if (param->extents)
+		flags |= UTIL_JSON_EXTENTS;
 	return flags;
 }
 
diff --git a/cxl/json.c b/cxl/json.c
index 79b2b527f740..0c47550ff440 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1164,6 +1164,50 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
 	json_object_object_add(jregion, "mappings", jmappings);
 }
 
+void util_cxl_extents_append_json(struct json_object *jregion,
+				  struct cxl_region *region,
+				  unsigned long flags)
+{
+	struct json_object *jextents;
+	struct cxl_region_extent *extent;
+
+	jextents = json_object_new_array();
+	if (!jextents)
+		return;
+
+	cxl_extent_foreach(region, extent) {
+		struct json_object *jextent, *jobj;
+		unsigned long long val;
+		char uuid_str[40];
+		uuid_t uuid;
+
+		jextent = json_object_new_object();
+		if (!jextent)
+			continue;
+
+		val = cxl_extent_get_offset(extent);
+		jobj = util_json_object_hex(val, flags);
+		if (jobj)
+			json_object_object_add(jextent, "offset", jobj);
+
+		val = cxl_extent_get_length(extent);
+		jobj = util_json_object_size(val, flags);
+		if (jobj)
+			json_object_object_add(jextent, "length", jobj);
+
+		cxl_extent_get_uuid(extent, uuid);
+		uuid_unparse(uuid, uuid_str);
+		jobj = json_object_new_string(uuid_str);
+		if (jobj)
+			json_object_object_add(jextent, "uuid", jobj);
+
+		json_object_array_add(jextents, jextent);
+		json_object_set_userdata(jextent, extent, NULL);
+	}
+
+	json_object_object_add(jregion, "extents", jextents);
+}
+
 struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 					     unsigned long flags)
 {
@@ -1250,6 +1294,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 		}
 	}
 
+	if (flags & UTIL_JSON_EXTENTS)
+		util_cxl_extents_append_json(jregion, region, flags);
+
 	if (cxl_region_qos_class_mismatch(region)) {
 		jobj = json_object_new_boolean(true);
 		if (jobj)
diff --git a/cxl/json.h b/cxl/json.h
index eb7572be4106..f9c07ab41a33 100644
--- a/cxl/json.h
+++ b/cxl/json.h
@@ -20,6 +20,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 void util_cxl_mappings_append_json(struct json_object *jregion,
 				  struct cxl_region *region,
 				  unsigned long flags);
+void util_cxl_extents_append_json(struct json_object *jregion,
+				  struct cxl_region *region,
+				  unsigned long flags);
 void util_cxl_targets_append_json(struct json_object *jdecoder,
 				  struct cxl_decoder *decoder,
 				  const char *ident, const char *serial,
diff --git a/cxl/list.c b/cxl/list.c
index 0b25d78248d5..47d135166212 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -59,6 +59,8 @@ static const struct option options[] = {
 		    "include alert configuration information"),
 	OPT_BOOLEAN('L', "media-errors", &param.media_errors,
 		    "include media-error information "),
+	OPT_BOOLEAN('N', "extents", &param.extents,
+		    "include extent information (Dynamic Capacity regions only)"),
 	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
 #ifdef ENABLE_DEBUG
 	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
@@ -135,6 +137,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		param.decoders = true;
 		param.targets = true;
 		param.regions = true;
+		param.extents = true;
 		/*fallthrough*/
 	case 0:
 		break;
diff --git a/util/json.h b/util/json.h
index 560f845c6753..79ae3240e7ce 100644
--- a/util/json.h
+++ b/util/json.h
@@ -21,6 +21,7 @@ enum util_json_flags {
 	UTIL_JSON_TARGETS	= (1 << 11),
 	UTIL_JSON_PARTITION	= (1 << 12),
 	UTIL_JSON_ALERT_CONFIG	= (1 << 13),
+	UTIL_JSON_EXTENTS	= (1 << 14),
 };
 
 void util_display_json_array(FILE *f_out, struct json_object *jarray,

-- 
2.49.0

