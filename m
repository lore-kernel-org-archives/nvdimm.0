Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AA1283FE9
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 21:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758749477; cv=fail; b=rdW2H9iw6batbf9T3GeDKqMsGlbrh81+Aybd/FeYdEHYZD76r25S8tojK0Hl45QNmWizy9A3isUGCPI4lk28YAhc9wOM5VtEGegYdMJUABVTgj3azxrIsewSA9dru14PRx3wE8APDJk3vLxp5+X6EMAYqIN0KfkxaORwBuHVd+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758749477; c=relaxed/simple;
	bh=0ff6xtfjewlvs0K5WtY4B+XfwGjkY1r+P2nluwsbPSE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o3qry326mhJESBlfiK0qaGatHGieBfUqyLLQ7oXyZn7DOVGPvvSn8sfHlJTP754YTmyC84+FOw2oHnfObM2aWDcwDuQ+PtcxPDfXOuruAN2Fj3jIaUn+UK5YUQ4XVENMrahiu/n5B1HICeksOt+uYVK1ozL7c43Fm4GszSrHtNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AtBty+8C; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AtBty+8C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758749475; x=1790285475;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0ff6xtfjewlvs0K5WtY4B+XfwGjkY1r+P2nluwsbPSE=;
  b=AtBty+8CBKBbR53CM4FI+gp2ofnU3/xEqhfjwGAREOP8KcMoYbjFJTm7
   FuEPBVzDjAIq097UYK/jeA5aOMXFw+IcG/w1irL+1js2qFpwdlsMInMCc
   Kvgz6YIEAZW1sKABJT4xTRKQk9WWfmsQvBdp6h8e+gjlLoaREntpi74yw
   ZJM3cxqbeNUdXuL2kmd+kp1ckqQXnxe47wrwxag458KQ7adNa4UsZ+UTF
   S3xs5YTIjUCp1mcvaQjmGr+G+iO305jgeE9SFl0zx6qIlQx+nid3JE+XI
   gHXPocK8qukWpD14Bgp0J+Gi8jigLmzBybprLgsjtlNB1RoD2EnN1snkx
   w==;
X-CSE-ConnectionGUID: 0iSCzjddSZC4Pfk9RIcSyQ==
X-CSE-MsgGUID: Kdva41XxTpyMMHbFktnumA==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="64896296"
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="64896296"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:31:14 -0700
X-CSE-ConnectionGUID: 9BMZjU4NTyK5GlVbj+U1GQ==
X-CSE-MsgGUID: hRrlPM3kQjq+EI95mNoh2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="214266392"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:31:14 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 24 Sep 2025 14:31:12 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 24 Sep 2025 14:31:12 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.71) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Sep 2025 14:31:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tSHD/TXs3VmZcoF33eoxMZDbtAymHlQ7nzfei8E4iqgIXV00IAWXXHQvmYaE1nrRk/QqLyPErBRdN1YOv4jnhbwomuPZm3An27jI5txIJzQdaUsCAZ91HB/kxu4QllR8tdDjhFxY7Wm2uOMD+Do6bm3SishY1+mll+XzZ+BfCh0vuR7Ce1ojwr/JB+jFUOLKdb5QDGaJvusNxXiX2kOouseSvehN4pJWSmE5y0acCoHu/T9yST0ZmGJ9QDV9fSEk8NO/T0vfoCMEwQ7v8D2NKtvjtHvVpNo9d7JMgfSmo/Mn4i9ewxL8QRPzw51mWESO54/7wWzldTNWS0QWLEKVmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBJ9KsO6AjiJkDVDAS116K/FjC1mn6Z4RyiKVL8QIv8=;
 b=hPEu/mzhcWEvwagm4O6dAxYcrY0IQWeatCgKN/v+dtkOJGS+h63gLNY/I9fPp21lbAmNmqin74WXzM2o6tc/HNIxgn7gYAzpNWtd6A5MJ+ORLzavCD5lnQ3gABWWyHYyrus5DNTDXqAeRBLQ6bgFvYbHGnI2JIoK3e4oX3PYSAj/LGpH0vguG98TGjz98bfsxrjPme6/j+nMgYnpFNlizRK2DsydKVddhXTJrix7e1k1UL8Zrfe5sj++CpViN1UYHKmiIfYdqbvpyHV0+SASTGkMIm6LoZsdBLfOlir7YRsPVa5Tsxa0+OefUWH43NJwnbl3FowcvDjdybjqzZMWNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by PH7PR11MB7961.namprd11.prod.outlook.com
 (2603:10b6:510:244::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Wed, 24 Sep
 2025 21:31:09 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%8]) with mapi id 15.20.9137.012; Wed, 24 Sep 2025
 21:31:09 +0000
Date: Wed, 24 Sep 2025 14:30:59 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, <cpgs@samsung.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>
Subject: Re: [PATCH V3 08/20] nvdimm/label: Include region label in slot
 validation
Message-ID: <aNRjE9gckXeC60-Q@aschofie-mobl2.lan>
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134144epcas5p498fb4b005516fca56e68533ce017fba0@epcas5p4.samsung.com>
 <20250917134116.1623730-9-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250917134116.1623730-9-s.neeraj@samsung.com>
X-ClientProxiedBy: SJ0PR03CA0253.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::18) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|PH7PR11MB7961:EE_
X-MS-Office365-Filtering-Correlation-Id: d091aaa2-02a8-4bde-a5db-08ddfbb1ad9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qMkU+08jILGeceErtevjtvaTjCYsKTOR7L/kwW45VRJC6cW3+1K91xVzUE8N?=
 =?us-ascii?Q?pV24zRItEzxYiFJRmFABUoaXyzY4yGk8dBCPZxzZd5LjNNaiDhSmA+KCrz15?=
 =?us-ascii?Q?PHC/HCd/9oEMvtdD8HRf0xWTma44CHnouXriCyLVXvVTDTcwdR7zSrvE+DRf?=
 =?us-ascii?Q?B95wK2VdILe01gfOIAJ5rxEiI+Ezvlc+r3oXUOd2wE2G4fzInfNizlQDsvXA?=
 =?us-ascii?Q?LtOzJwmBvlarPXufb+CLBnbTwAR+gF58I7OoO+QQV53q7rdfNezk12MQeqMe?=
 =?us-ascii?Q?q3qNwFskBWg1FW/nu93aGuqeqshZP9+eKP5lGKPT1xtbQqgBDDpQ1BkRZr4X?=
 =?us-ascii?Q?FaN6tfufGriN7Uv5RuqvhMsahhT6GF8u3Afq98nW+IoigSNtJ4LAzCbZEtKS?=
 =?us-ascii?Q?oQOQgBpUOio5IKdSr7NFtIz0JfQZJLzKRN/F3k6vnm/KZMgLT7htKB3lT2cE?=
 =?us-ascii?Q?QPfTj4WnzPvAi+Fszq4bvueiXaEKh89MXNOTWsLv1yvS7VVgfsNeRKDHLhtB?=
 =?us-ascii?Q?zJwkcb3MqhdgH+Fcwkljh09hEDXwngIhZYLm/dCEcfrn0bX68Gu8y4bDy717?=
 =?us-ascii?Q?3C54X9r+QZkeQwITEZbu8NufRYswiOhTMV+zbKa/+uN+nxPKsyYbivRvFsLJ?=
 =?us-ascii?Q?bSe6TyhIGcKIKRUAiuuxrNGPM0YzxilOmksuS8/JCRz/AEOlRR2AIwXHg6AD?=
 =?us-ascii?Q?SxxWh/+trnMec5fsXq45hIk0ZMYeAdwCmd5rAx8n6v6ypmtM2YdEUhLg5nza?=
 =?us-ascii?Q?7WL5DQ3TIPvXFpvsXeaqeDga2r1c0LXgSxpA8/bniCRKdti17tniCp7ORrcE?=
 =?us-ascii?Q?4KkUFkgb2Wrb0dz4nGC3cMQYYQ0qmlg3btNjKuHUnfULLKoR6zGyw4+TPJyB?=
 =?us-ascii?Q?2IozpgZDGHYCb7nDgDOhwn6ArWG4dcoG3CVp9Q6pU5NEjRxYVqOhVAqi9MSj?=
 =?us-ascii?Q?CHciamlexQS9jCm2pFgtXaEpQxYvy52GiVyk1GRY3WaSuYITxHoqGcXH6T7v?=
 =?us-ascii?Q?m6ZGgmTENFhlpDWttyssNAXF+RuWDvyuFbheBFcHizVD6NWAOKuxdwUdeKuT?=
 =?us-ascii?Q?5UQWCZ/CWS1MMW8qMyH0h1CD3uPe49GZXYnptBHvUkYeHVnOMGgb2dvmpHkJ?=
 =?us-ascii?Q?M2vZzHvageZfYX6QvyXm0Cqmh9KGVrkkpMKbyR+UdKEDrGEtwJrxOzvkdncm?=
 =?us-ascii?Q?0pIpkDHdEWfcKzko1ykYhwlS3DFm4cooAumE2mJ1FAcUxBxmqWsEHCMcsGgR?=
 =?us-ascii?Q?GcgtMxt2jRXnBjiMrj3a5TA39n1IWvO9bFbOvGvIXxVzZTPBzpQcHhRtBBaX?=
 =?us-ascii?Q?pix8XluiMBHAL4julFST+lBiL7vSqnQB0gYZTLqnEueevt3NvVAt+l5Wud4/?=
 =?us-ascii?Q?9EviEGvFNffB1IPz3CU2ltlV8XLPQW256QKDRo9LtRNGNu2fjK1hovp3qAUu?=
 =?us-ascii?Q?nQ8MV98uKew=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LrR9uG/Hqe/Y4/YNHw5yVK5xkAiCV/XPXXbSZ+SenhYV4UyRGxZi0z3z6ww1?=
 =?us-ascii?Q?2AUahSxwctccqwOoPmLg0QgFeGTXUYci0BbvWyKYFcjw3Rfb3VtFAm0fXA6D?=
 =?us-ascii?Q?BmgPmqniycgHZARsJ3lMMSOK38DX2r50qCw7uDi4x9U5uvze4m6PY26T8sdE?=
 =?us-ascii?Q?2Qybfv50Icr5KAgIDPfCRcn3rfymLpYryZYdUlr417NWN6AM+0U3elyU3QeM?=
 =?us-ascii?Q?O2mfkE5HMk/kXZ5GhJ64+729gOJTexVJqv5cNoVelBCMB3+1znboaCmFEOW2?=
 =?us-ascii?Q?608ghyE9NKQhiK5K4ONZLLmv2faA4GgKl3UAw3KiOO+TynBNjrDEob27h1fk?=
 =?us-ascii?Q?zHUjloW49LP5RL6Kk7P/9Ji+TjGt7t6QBLNyOr/66dNC6Dh3ieWkC6zKss5/?=
 =?us-ascii?Q?gVhAFIu5RWlxKhMdU+NsBLkZ02+sS0rL8RUz0WK16Duf5YP1VdfxrwUbWnqI?=
 =?us-ascii?Q?h8EeJRqUffcHxMUKXY8uniiyAeUVaSy7PFRQmhNkYo3o4XfcyGeEDbyKpXsK?=
 =?us-ascii?Q?DD5K8pNlIKRdZhoz4uBcvDmPOrLyUWX/80qVWf1wjuE4f+y5rc4zaD1MQtk7?=
 =?us-ascii?Q?MN7/cPhe1ERlkaNU2zujDNnGknIRbvhXtVj2yjF0uljQy4eNlpS0ZCZ5KPgr?=
 =?us-ascii?Q?gWUcVihFIv0WUGB3sb1DprZ23663ovv/urH+MMZICQvYbvZ7jvixX8n0HrUu?=
 =?us-ascii?Q?7XYJu/lcdxKLaINmzZ5e7eGDXweNn3ukgy7/MiCbmioQeLe5ubdJVqOIP0A1?=
 =?us-ascii?Q?ntr8Hgf8TmDQYGFz84hG1hLf/xqX0snXsc0tvdIMSlQT0EBQjACVcpYWHiS6?=
 =?us-ascii?Q?Wg18UROmhGEfLjbD6yon0IjyU6eyTBqKmfmhqEubvvpyy+RWoI7kW2pcrou7?=
 =?us-ascii?Q?Tc0tGxRa35xvtHnMy+tAPRKYPix3bj1tn6Bhk8rvM2ExFj6kXeqAntuA9Aex?=
 =?us-ascii?Q?lBOVX1NTDm3txVCNgJWqOiuEDafgDVnM+ZReAo3px03epn2kYrn/RlMvQ+UA?=
 =?us-ascii?Q?/oKqYmu0ugzgA9lmjOxt/VwfT6j3RvIssZBW5EDY/r3R+x4jNL8DWu9KbEjt?=
 =?us-ascii?Q?pYRj1z+e6vuUIiB9/QOQHuQtg0PZ7RoFYaKFOyBdcXLcXaAJmOGogdv6nOSK?=
 =?us-ascii?Q?hSEEZBPmdPyrdB8L8jcfTz7zOG+f7XtExfjPY6LWHl9JoTGm5VdczVt4JCAf?=
 =?us-ascii?Q?rDLgmlFCtNdxmRGFWIOLPFpGEt5gNk0JO/MJIlzFsWm0JIbeACP367S4Mt0a?=
 =?us-ascii?Q?XIYIYRmyN/SmdYJdCzmP4uILUTtpz9Xn5zTRdQXULWZzQPDp0bK8LtW0wMSG?=
 =?us-ascii?Q?OAB1oBDV2ahZMZHDbSN3QM16By++VdB1+FvgcIZmVsxprCaR0uyvVyAphrwZ?=
 =?us-ascii?Q?RxRy7LcX1uabQZZYkiTJsqeiwKEFiqnbSqgkBRdbbNiLyCGIkbgDnsjAhUXf?=
 =?us-ascii?Q?eFjbeX235esUqi6za/wUv0qLicTjfoqLWrvIXnH5xwK0QypgI+ffxO0C0JeS?=
 =?us-ascii?Q?kr0gDugiBHRWrPnO7iPwVhpjAbLGjBapeKkBD6vBZjNpuCv7TaJlAY2YqVfb?=
 =?us-ascii?Q?EPhg18s9JZVUi9YntqfVde/qZlrSgd9+/ny21+QEuL+D+AAw1YYF02b52jRN?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d091aaa2-02a8-4bde-a5db-08ddfbb1ad9b
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 21:31:09.8390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yP8amLSU6yV+kg7Uruod2f6hupIVLGH2WrwnHQUh6IhKWz56+O3r6mzkSwxu2Yoqyo2OmRF/pqucNd7UR88BIMnYpribw0o8nKaAdVYE6Nc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7961
X-OriginatorOrg: intel.com

On Wed, Sep 17, 2025 at 07:11:04PM +0530, Neeraj Kumar wrote:
> Slot validation routine validates label slot by calculating label
> checksum. It was only validating namespace label. This changeset also
> validates region label if present.

Neeraj,

Was it previously wrong 'only validating namespace label'
- or -
Is validating region label something new available with cxl
namespaces that we now must add?

I'm looking for that pattern in these commit messages, ie
this is how it use to be, this is why it doesn't work now,
so here is the change.

-- Alison


> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> ---
>  drivers/nvdimm/label.c | 72 ++++++++++++++++++++++++++++++++----------
>  drivers/nvdimm/nd.h    |  5 +++
>  2 files changed, 60 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index d33db96ba8ba..5e476154cf81 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -359,7 +359,7 @@ static bool nsl_validate_checksum(struct nvdimm_drvdata *ndd,
>  {
>  	u64 sum, sum_save;
>  
> -	if (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
> +	if (!efi_namespace_label_has(ndd, checksum))
>  		return true;
>  
>  	sum_save = nsl_get_checksum(ndd, nd_label);
> @@ -374,13 +374,25 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
>  {
>  	u64 sum;
>  
> -	if (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
> +	if (!efi_namespace_label_has(ndd, checksum))
>  		return;
>  	nsl_set_checksum(ndd, nd_label, 0);
>  	sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
>  	nsl_set_checksum(ndd, nd_label, sum);
>  }
>  
> +static bool region_label_validate_checksum(struct nvdimm_drvdata *ndd,
> +				struct cxl_region_label *region_label)
> +{
> +	u64 sum, sum_save;
> +
> +	sum_save = region_label_get_checksum(region_label);
> +	region_label_set_checksum(region_label, 0);
> +	sum = nd_fletcher64(region_label, sizeof_namespace_label(ndd), 1);
> +	region_label_set_checksum(region_label, sum_save);
> +	return sum == sum_save;
> +}
> +
>  static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
>  				   struct cxl_region_label *region_label)
>  {
> @@ -392,16 +404,30 @@ static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
>  }
>  
>  static bool slot_valid(struct nvdimm_drvdata *ndd,
> -		struct nd_namespace_label *nd_label, u32 slot)
> +		       union nd_lsa_label *lsa_label, u32 slot)
>  {
> +	struct cxl_region_label *region_label = &lsa_label->region_label;
> +	struct nd_namespace_label *nd_label = &lsa_label->ns_label;
> +	char *label_name;
>  	bool valid;
>  
>  	/* check that we are written where we expect to be written */
> -	if (slot != nsl_get_slot(ndd, nd_label))
> -		return false;
> -	valid = nsl_validate_checksum(ndd, nd_label);
> +	if (is_region_label(ndd, lsa_label)) {
> +		label_name = "rg";
> +		if (slot != region_label_get_slot(region_label))
> +			return false;
> +		valid = region_label_validate_checksum(ndd, region_label);
> +	} else {
> +		label_name = "ns";
> +		if (slot != nsl_get_slot(ndd, nd_label))
> +			return false;
> +		valid = nsl_validate_checksum(ndd, nd_label);
> +	}
> +
>  	if (!valid)
> -		dev_dbg(ndd->dev, "fail checksum. slot: %d\n", slot);
> +		dev_dbg(ndd->dev, "%s label checksum fail. slot: %d\n",
> +			label_name, slot);
> +
>  	return valid;
>  }
>  
> @@ -424,7 +450,7 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  
>  		nd_label = to_label(ndd, slot);
>  
> -		if (!slot_valid(ndd, nd_label, slot))
> +		if (!slot_valid(ndd, (union nd_lsa_label *) nd_label, slot))
>  			continue;
>  
>  		nsl_get_uuid(ndd, nd_label, &label_uuid);
> @@ -575,18 +601,30 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
>  		return 0;
>  
>  	for_each_clear_bit_le(slot, free, nslot) {
> +		struct cxl_region_label *region_label;
>  		struct nd_namespace_label *nd_label;
> -
> -		nd_label = to_label(ndd, slot);
> -
> -		if (!slot_valid(ndd, nd_label, slot)) {
> -			u32 label_slot = nsl_get_slot(ndd, nd_label);
> -			u64 size = nsl_get_rawsize(ndd, nd_label);
> -			u64 dpa = nsl_get_dpa(ndd, nd_label);
> +		union nd_lsa_label *lsa_label;
> +		u32 lslot;
> +		u64 size, dpa;
> +
> +		lsa_label = (union nd_lsa_label *) to_label(ndd, slot);
> +		nd_label = &lsa_label->ns_label;
> +		region_label = &lsa_label->region_label;
> +
> +		if (!slot_valid(ndd, lsa_label, slot)) {
> +			if (is_region_label(ndd, lsa_label)) {
> +				lslot = __le32_to_cpu(region_label->slot);
> +				size = __le64_to_cpu(region_label->rawsize);
> +				dpa = __le64_to_cpu(region_label->dpa);
> +			} else {
> +				lslot = nsl_get_slot(ndd, nd_label);
> +				size = nsl_get_rawsize(ndd, nd_label);
> +				dpa = nsl_get_dpa(ndd, nd_label);
> +			}
>  
>  			dev_dbg(ndd->dev,
>  				"slot%d invalid slot: %d dpa: %llx size: %llx\n",
> -					slot, label_slot, dpa, size);
> +					slot, lslot, dpa, size);
>  			continue;
>  		}
>  		count++;
> @@ -607,7 +645,7 @@ struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
>  		struct nd_namespace_label *nd_label;
>  
>  		nd_label = to_label(ndd, slot);
> -		if (!slot_valid(ndd, nd_label, slot))
> +		if (!slot_valid(ndd, (union nd_lsa_label *) nd_label, slot))
>  			continue;
>  
>  		if (n-- == 0)
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 046063ea08b6..c985f91728dd 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -344,6 +344,11 @@ region_label_uuid_equal(struct cxl_region_label *region_label,
>  	return uuid_equal((uuid_t *) region_label->uuid, uuid);
>  }
>  
> +static inline u32 region_label_get_slot(struct cxl_region_label *region_label)
> +{
> +	return __le32_to_cpu(region_label->slot);
> +}
> +
>  static inline u64
>  region_label_get_checksum(struct cxl_region_label *region_label)
>  {
> -- 
> 2.34.1
> 
> 
