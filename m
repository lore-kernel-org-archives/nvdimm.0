Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13EF641
	for <nvdimm@lists.linux.dev>; Fri, 17 Mar 2023 06:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679033586; x=1710569586;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yJggmRK/OuyoC6owTDOKaRT6HodwG3PINooO8CaMBWQ=;
  b=UHBgVEo1qtXLhy+ZuALvXZgGu0Lh+h1BOndft/Qgf3rghP5d9VhKbXmR
   NFFiQN44ySErlYJVKXZPqc+n1eEPClqG4BSVKnRaI8oiOLjZWJFl3MqB6
   DfeLTFSXLoj6DeZ2JpXtmbh1dmrhQUZB7/CjWTSHwpdmp5ae63qy4z0VL
   1vkTmKILx+xQbCC9/ASynRv2iBiJmGeYTTK+i+rHoDl18OnY8Qb55hMi2
   mT5r/Nmd3yGep3OsCw2cteikwaGW9qZkGHE6pX/K1wbe3PXpSzKeVOSJq
   QbJ1Rwrx/fAHJPaNgDyojg4NAynvVQy5V0roApOIiaexMoaQ9oLDH5S5z
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="365887265"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="365887265"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 23:13:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="749146675"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="749146675"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 16 Mar 2023 23:13:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 23:13:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 23:13:03 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 23:13:03 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 23:13:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6+balx9y3Ony+tc1pZox4PaWTM2Zt/ex+07NZw/LHaxrKV6wGYscaImchgD0emT1e6wCQ2HedLiFBldVreO5uVrHp2ULRZQQ8M6SGH0bkKE0w25KTivZHTwthpuZG/915jlUC8slIF7xkRA7XG69fH/cnDmEBacLXqEhVH/+Pb3W2yy3w/UKKDkLF1L3GGQQABFARq4f6+sOcEMe9ACf0NSVaHNtn61IP5AcpDAaAkQFTXIvRuaA3kJKVOg667J6D8/Xn4GHCuugBLjq5s8uJyXKxYO7ykKLYOuKtBCu8ooynxdfofXchSLvZLcgvLppiLEYadeBv0bRVlxYahs5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJggmRK/OuyoC6owTDOKaRT6HodwG3PINooO8CaMBWQ=;
 b=Y1fTmsLLJfSX2PKDrvF3Ewy/cU0ZPv1o3XXO0iOgppJMzxdTB9PSdEeSm21PxduvsmkLPvkgzFZHAl0waU5OF14Gp8mTMUKZvzlffyxCBwHm1Hn6fUqGQR63EHT+OfAexX8TuPPeZ/VBMykXOyJQ4vaupHaIDpr8AZThtoczLlaP97aC4pikYGuRn5wvTaLveDn5xfVs9vHJN13QgsINmFBWhTll9Byb3+rZLmuVF+PNt9GN83uAY9fByD21FNSrSteqBMc8+9tUIxgIU9KC6HTLE6aLYCOGSBIT8wJ6l3uZQSIjvDlGTey2MXI2c8yn/7sOCsq5cDUXxd5W9kxcsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY8PR11MB6939.namprd11.prod.outlook.com (2603:10b6:930:59::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 06:13:01 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233%6]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 06:13:01 +0000
Date: Thu, 16 Mar 2023 23:12:58 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
	"kexec@lists.infradead.org" <kexec@lists.infradead.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>
CC: Baoquan He <bhe@redhat.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>,
	"dyoung@redhat.com" <dyoung@redhat.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "dan.j.williams@intel.com"
	<dan.j.williams@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>,
	"horms@verge.net.au" <horms@verge.net.au>, "k-hagio-ab@nec.com"
	<k-hagio-ab@nec.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>,
	"yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>, "ruansy.fnst@fujitsu.com"
	<ruansy.fnst@fujitsu.com>
Subject: RE: [RFC][nvdimm][crash] pmem memmap dump support
Message-ID: <641404ea806dc_a52e2949@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <3c752fc2-b6a0-2975-ffec-dba3edcf4155@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3c752fc2-b6a0-2975-ffec-dba3edcf4155@fujitsu.com>
X-ClientProxiedBy: SJ0PR03CA0114.namprd03.prod.outlook.com
 (2603:10b6:a03:333::29) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY8PR11MB6939:EE_
X-MS-Office365-Filtering-Correlation-Id: d4fb6a17-9768-4848-7846-08db26aea941
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DgZ8qSMMf1ynxIRnrmV1ccBbpkzPqrBEY8DV0q8o15zPs1tpI4QrsrQ2VqklVFaeWhq4LugHcISziAKh5fZ1sK+tqxnOgdw8T7yMgDTSPiQemNpH7cEXArp+Zcv5RiTv+u0fz7nupNgC87lMsZp5Si+BX1eUH2dI4ABTkV9meLsj/m8G724aPNxYkEx/Ay/8AvAFRLCyEntZ37pXKzeYCClyE/c9WUbZGLQPMdk947jYHveldmgyM1obVee4JsZ6ZKxHl/IkHxwJrFjODdkD+Q6rFPJjCH+hCAmKjgtSZNiuK1YN1zNIFxWZzFs+oVbz/PC1Kj1lXVHn4qqWNPmx5UVYSDRP7HiFx46HD1SiynHEfWmZZSOEzLVVBd33Ol4sfFeJhQn176NOZlJ6Lah2hBhZZzPsPeMtto3cPo4UEJLZ2D8Fqm0XKHlIMs9S0By//a8MsuWz3YhtlQhX+CiMU6PQwKuEqx3P7wPvpew0wDzxqBgZ7o9NEH/YzQ9P6QjxtOZNzQ+sLB3m+0C/hD5cs0o7nbO1WzXG7buf1L8kFPcBqa0r2Ennw4HpmIel6Y+a/oCKj6CoheIzC7TxYxBsPWzbENZ5pIzeqtBvT+HwGzayWXG+i2Bc0vAhQkJtFMD2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199018)(26005)(186003)(7416002)(9686003)(6512007)(6506007)(5660300002)(83380400001)(8936002)(6666004)(966005)(82960400001)(38100700002)(6486002)(4744005)(66476007)(2906002)(66556008)(41300700001)(110136005)(86362001)(316002)(66946007)(478600001)(54906003)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0yMhAW8ZAMO87dSe54JuGWRv3Oy2IEYt7kzSA1DdOpw6OCSLCFFyCGVJxFF0?=
 =?us-ascii?Q?397fXfVY8WWe6iXwL5sncVj+lwhwgwf9uD4o33Yaa8tzAkW2gtHO3BCVg5Ur?=
 =?us-ascii?Q?WdzQKwC4OuNrz99ojwkYkzmXRze04MUqdB85uMw4jfHw8VR+mdDpxTWQvnmR?=
 =?us-ascii?Q?pD92W9Ysfsv1+d1W7f/a0JYtbbAP13gfHsRyh139yK31kbAMFT5W6d8nCcou?=
 =?us-ascii?Q?++ihxKZjPkO9854xt8heTZg12nleMvs+Eo3chNBVSjAQPxcyiLUyOdXXeOjw?=
 =?us-ascii?Q?Hm5xCiN9DWXdxMvwcLQ9XAlXRDF+okAyyvVUWq/DuyC1cR5J2cVZmAVR+ZWR?=
 =?us-ascii?Q?8VvaGKLSXPYCFGWHC7Z9vsxJfiuoru4qQW+fKV3HhxRP7EPQu4K8etZHtgEg?=
 =?us-ascii?Q?9T4CHNets6ZN8TPB3rdUy9i+NbGV2hLxE6smGBY4grmCKu60oJCn+9hMfjNX?=
 =?us-ascii?Q?t34WHBUJPaZqYytyqclPC2nIoXQ4FKfHV1FpTcvn7BgMwXL6VwBDL+ZWgfBy?=
 =?us-ascii?Q?t2+eaF38vqjaFcFX1V3ClmUTRI7qrzNKT2dOVSpE7Xl7XTSJbk22jcXf7UaW?=
 =?us-ascii?Q?ipinFWc6+iwnQuP72zUF2my/QP8uuqx9VJx+XTC2daDs1TqeF69Wnh49upBJ?=
 =?us-ascii?Q?nVNHnpNu611ZxSUMBd2sMwG2m3m3xdfbAU7FwqKBj4ulzn5BnkTw02Nu0Fv4?=
 =?us-ascii?Q?Me/zRJEjpQh53hvV3aLyoQmolAscyeaioRkGgxFx8f85xgz8cpA6dUTDregj?=
 =?us-ascii?Q?Dwwldu0SgMFUGwpsm7LaqTV+8lvR9sv8hU4D0Z4plUIcpAXvuQ4xZEy3Bhw6?=
 =?us-ascii?Q?ibURxvIh++moVtBtiI72P7+SHKKrPcwlva96CuzRi4Co9eJ49Yhr6DXXiO78?=
 =?us-ascii?Q?8yaI015wcZ7S5C2KVRCRT5/GvEXZMAH0V2rjXkPzLSi/AAqamy4OoDC7r+TY?=
 =?us-ascii?Q?aVg0b2RRxxAaVVOey38zYvXvYGm7Mag6oHq6D3YcRxtZ04VQ8bnczQsHkZxl?=
 =?us-ascii?Q?Y6cNfPFbCoZ0qYHd/eQVl+weL3nDDNU+XPopxi0Oe825sG+xDqy0NQp/jqLn?=
 =?us-ascii?Q?VWn8MjYljBhjlZ+Sc1CxqD9Xj9LuismkDFx8OgmPKbcHJchtrJOp0r7FRLwY?=
 =?us-ascii?Q?Dn/MNf3NbC7n8Hy9+HsKjfkPh1APcBy2hUHIQfWVbECu3IvJk4/L9JH8IEWN?=
 =?us-ascii?Q?PsrSxPy/lXL1TMIu22sOGjW1jIlmIYxAWGc0wCV4wM+S4BeBXne4aXdunTl9?=
 =?us-ascii?Q?tWH8IBRMV9V//nvYv2AzO0BKanabkDXjCsy3GxZP9SVgTvzkkKNHVtcO549l?=
 =?us-ascii?Q?xN5nx3edv/lrxlTG8/4FVBPspFu1mQ9FXjCRYbjL1Ma/JI3DtoG8TrQvROyT?=
 =?us-ascii?Q?RyiNXBkiI95FWNXY82VfNo4dfNfvTVoGepGxHatVs1eLMdWN6IdP3qKOCqnr?=
 =?us-ascii?Q?yczG2o6BPP6bWLPBuzmM7okX0vsi0xz4Sl2pFExt42cYOe22KYwxb5qVLbrQ?=
 =?us-ascii?Q?mk22LGkq5QdO3z338u7hUywjaZNaSDpVHPVpBOylIcr3Se2W0YejU1q2d7jr?=
 =?us-ascii?Q?bogcADx+Ut0CnoDF+21BmjCvqtdOgbDTRbHZWYx2FPy0OCgBPWrVNP/kgT+A?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d4fb6a17-9768-4848-7846-08db26aea941
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 06:13:01.1050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oQOBDvoiBiPZgE4lugOBhexTGtKgi6cffzrec0lbjvobZCDbLyyuM33ksEIbn77ej6JNXWfjYpuyIhJaSiI/Xkv2LzjMDLlWVGJzcV8zzXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6939
X-OriginatorOrg: intel.com

lizhijian@fujitsu.com wrote:
[..]
> Case D: unsupported && need your input To support this situation, the
> makedumpfile needs to know the location of metadata for each pmem
> namespace and the address and size of metadata in the pmem [start,
> end)

My first reaction is that you should copy what the ndctl utility does
when it needs to manipulate or interrogate the metadata space.

For example, see namespace_rw_infoblock():

https://github.com/pmem/ndctl/blob/main/ndctl/namespace.c#L2022

That facility uses the force_raw attribute
("/sys/bus/nd/devices/namespaceX.Y/force_raw") to arrange for the
namespace to initalize without considering any pre-existing metdata
*and* without overwriting it. In that mode makedumpfile can walk the
namespaces and retrieve the metadata written by the previous kernel.

The module to block to allow makedumpfile to access the namespace in raw
mode is the nd_pmem module, or if it is builtin the
nd_pmem_driver_init() initcall.
