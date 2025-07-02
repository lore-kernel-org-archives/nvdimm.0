Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415AA2E7BB1
	for <nvdimm@lists.linux.dev>; Wed,  2 Jul 2025 18:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751479254; cv=fail; b=ah8/LmRdD51/1XStxNQbizxfMEzFUamQrYyNLtN2WmkSrTRQx/SeRWTGVMqLy8wCxNy5IGB270BwekHvlUzHacz9Py+jRU1Tmem/lyOXwEj/2tSZOT1hyL4p7O8S9qRTiZWt+8DyM99jhcSz5KTWPwXabZV/LbM3IOJpUBZ0NAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751479254; c=relaxed/simple;
	bh=St7b5FR9wGWUkzuH0+oOQCZg9lggRmxG9GEwAWgGV04=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=J18dBBvzuKOtHEWffzncGn74ONAqN35qykvzx+O7KCOcRN+Dk85PgoVafEPhI8St6F/7k10Dnk9WamLVrhzKkZUcEUYS427hlAJ4YQP62BlDxEYTW+3U61CvVXyBFnu3l2xlJpON1WoxlLvo2dPTsK5aFOaUbat4ToOqroFCL/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DGi6xs7e; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DGi6xs7e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751479253; x=1783015253;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=St7b5FR9wGWUkzuH0+oOQCZg9lggRmxG9GEwAWgGV04=;
  b=DGi6xs7eg1bd8sZBSH14btn2FzhJ9Taez+GWNWW70EUhLY3Tb3M5oCt1
   +KxDgyknzn5ZS8cHc/tBLcPmAMnisAZrUNe/26v1zQ8OhV91x9TOGQAKw
   4xvdcSHWiF79ohOQTED5XGU7aiwP3tzXD3ZwuXE+UmbPjMSU3+ggv227D
   2htfvI+GgeZgA4uF84lb8TDAE+R6dTH7XVD7D4+6tNTvugaO0iHWNnmGR
   RLvwrQW2p3gbLurjgtaFLRj8/Es/9PQ7NFxrxl4O6WzfHZ5LvTLe4yvAm
   e/gDrYasiNR7xjMiLy0rMinya5ikeKlto1sAbbm4cde/vQVLgsltopGpp
   w==;
X-CSE-ConnectionGUID: RaTCvCNgTlKj6OWtHcISwg==
X-CSE-MsgGUID: ee8p5idVTrqNotpm6oL90A==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="53756098"
X-IronPort-AV: E=Sophos;i="6.16,282,1744095600"; 
   d="scan'208";a="53756098"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 11:00:52 -0700
X-CSE-ConnectionGUID: 5FVldMLQTiq3d6irjOUaEA==
X-CSE-MsgGUID: fc03ybAHTr2CYQa5U/K2Yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,282,1744095600"; 
   d="scan'208";a="159660204"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 11:00:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 11:00:47 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 11:00:47 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.59) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 11:00:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kQA7MhHIy97iMDhnWdd4oXdBYi+sdAyrdthOHHyJMaXA2Vv0NF0P/cmuYWt8xBNNmgd0f2VUa6F9xaJRtUfCkWrWsqnnlssgPaiqBUjY7qm+ZfP52JIDusT6aLZ1EPs1vRpSSWMWCslAx+Y9dbgwZ8z5N8H50GxaQh65xB3v/FPsHCguVwyX8Ms/r2+7RldWMd7eYh55TV6uZ04fBTcJYEkpCGxenpDjz5keuY9PukbuUdI69dYfLF9zSD8QZvduXauTfARqwh2A3YlJ3wL1YdO/0DjrBu5eRBvvVKVP9fbNIHRAc78jA85RijMy+OKXNZJmtffm42AxkERksQiP4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3uzs750PyLeZu9WjXjISB6lhss5SyMooXL2IrXJTyxk=;
 b=fQiXq8Ye6QVG1h7zKixbmm8Nj9I7FKD/lTtp9xJkfxAGsLIa+FioA/y2+BJvcVkZJGjRSKoA8SQ22VD3YlVtGjMwr96SvCIm6KlGCWZpjE3s/9NFugFlVV5ocDhvW331ZP6bUN+BH+/GvClb9f64JeDBW4lqpVxv5gydrNJm61bM11CI54lAm+zpN0aiu6iAURLvkrpiDpc2H8TEB+Xg555qQpVkZab203xO/XSgFo33c0q9iuLUdaLvkfogHS9RSFMSZn+TuCnCczn4su5zss6n0Sds0bMatNiuRzbmZfVPTsIZ5iwlNGiQ1/X+DfbTtuyjsl7QmWJ6JlZIhnYOwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CH3PR11MB7913.namprd11.prod.outlook.com
 (2603:10b6:610:12e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Wed, 2 Jul
 2025 18:00:45 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%4]) with mapi id 15.20.8835.018; Wed, 2 Jul 2025
 18:00:45 +0000
Date: Wed, 2 Jul 2025 13:02:10 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <dan.j.williams@intel.com>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>
CC: <a.manzanares@samsung.com>, <nifan.cxl@gmail.com>, <anisa.su@samsung.com>,
	<vishak.g@samsung.com>, <krish.reddy@samsung.com>, <arun.george@samsung.com>,
	<alok.rathore@samsung.com>, <s.neeraj@samsung.com>,
	<neeraj.kernel@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<gost.dev@samsung.com>, <cpgs@samsung.com>
Subject: Re: [RFC PATCH 01/20] nvdimm/label: Introduce NDD_CXL_LABEL flag to
 set cxl label format
Message-ID: <686574227268c_30f2b7294f@iweiny-mobl.notmuch>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
 <CGME20250617124008epcas5p2e702f786645d44ceb1cdd980a914ce8e@epcas5p2.samsung.com>
 <158453976.61750165203630.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <158453976.61750165203630.JavaMail.epsvc@epcpadp1new>
X-ClientProxiedBy: MW4PR03CA0228.namprd03.prod.outlook.com
 (2603:10b6:303:b9::23) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CH3PR11MB7913:EE_
X-MS-Office365-Filtering-Correlation-Id: 27f46196-cac5-4d70-f350-08ddb9925e44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?lACt4DqZ2HwFkz2xlfKXTf5ir4uaXgyG3Js3OdU5fJ5HeyF8ivuCxgZaCSnO?=
 =?us-ascii?Q?hTqQk9Nvm7KtiKfcfFF0YDJNcINCjytOvn+DVfbw09JBsJ7OCSEWJns2fmla?=
 =?us-ascii?Q?uX5ymvA8dELbe6DD+fiGc2Vq9IamE0BsUO3reZT1BERgistsOcHIIVCaxn9N?=
 =?us-ascii?Q?+/JeJ3x29/fah7pGQ+0pZpx8Ce5BU3gMOcRzgnokyEy811kX+qVBtfBx3qvD?=
 =?us-ascii?Q?e8CNBzZEo9w89gN6XOuddJc0tgMeq+FigoQ8Bma5keFRAUTniXBP5fgcJ6JM?=
 =?us-ascii?Q?hCEWXrdFsdlpENE87MHDCVMCgHSZqfkq98n2/G8l7/fIMsr7JUnAIwSyrE28?=
 =?us-ascii?Q?pIerMMdu5pzlRoSl0r3zTWpssIPg4ODt62ggqrRtM3Pu3IcwbH9aDE0Cf8X4?=
 =?us-ascii?Q?RBE7yflQDVsAORylfxz0WwKvHFhdIHzx7NHQh+p4kfy0eI+RxxIkXHRXQ1oM?=
 =?us-ascii?Q?7hH6ab4kXqX3vzCeavwX2THcIpQ5rcXjrCJXliSIaaV4zsQ382sfySjZxNhS?=
 =?us-ascii?Q?ENvn8wBFJSK9yGlpKnM74/rbCRg122QBs7AQ49SpeqyZJxmkQUUeNQTTgVT9?=
 =?us-ascii?Q?HnxCF63TCwjiicVtnhlIMHomGprUhbaV+cBiTORFU75aVGupk8i/ublcVNp2?=
 =?us-ascii?Q?4msnAVEV/D3gwxCqS3v2JEbZnhPPJ701Dl02eiAQTfd/fMNFekN2jP1dpgt8?=
 =?us-ascii?Q?d4zndgGYwPuQkgZGMFNfwmpJaygpEDTB9ZMiFYTRRjzj4kI7oxuKc+YOr/78?=
 =?us-ascii?Q?yIZcuszy0S+JyK62rJDBvnAVYg4re5ppCVDZEjk297yGbhn05dztDr+r1mvb?=
 =?us-ascii?Q?u27YB06Z4Svz8XLvw59/uESI/EFkcN2qjUd2J5nlkY+RPTPJCw0623reXdX1?=
 =?us-ascii?Q?RxQI/qGs1hUdTfvLX/jc9Slb7EraVulLKwE7NSl2bnZEGd83LIDuEZ0BrUOZ?=
 =?us-ascii?Q?wQ0zhzTxO+PK/dwvWu/GuGD93IPIjLtRLTwVftGanA8aTaW2OMyhXcNhZjG2?=
 =?us-ascii?Q?IK7yrzoziJMhlAPPYJqMq1xqtZrcM/vWa40fb7vkJFyq8eaZxqGt0kLDaLFS?=
 =?us-ascii?Q?6EBWjLAcprkTig4IfLrhEGogj0Rsq8daa9gJo25c6+ac8nHQRBR11v3ZUZYE?=
 =?us-ascii?Q?XzQhMGUlgatvPdvtnxptln5dMqD4+aLcQthxkyir6QKEFULjYNxaoFg+qVaK?=
 =?us-ascii?Q?zo6AAGoP5b5kcvcYP+06ONoStXZa5wjdhvWus/6jGy3HyhMfNl48Zw8Eacpa?=
 =?us-ascii?Q?1N2TI0rkiv89gCeft5425Gzl0AE3lBREMvs/gA6CADA4k4eDhdxjPoc+ivVY?=
 =?us-ascii?Q?kk3AO5f9+21YHfDMe4zjxQsjY/n8XUHbUU/ateextkxXry4k5kT9yrVgMfjn?=
 =?us-ascii?Q?uFHQh/ogEV8jWaF4tvudQbc8vWl+uKlnmFdUeh1g4gR79xcI3/kU1dk1EyZd?=
 =?us-ascii?Q?e2l+LYWT33A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K8SLPIdHv4xbaUjNPUZYljWBxvM2PoZ5cbnDNuUOmzrqQ3+MLqu4aLcq2pJQ?=
 =?us-ascii?Q?sqmr7Km8qh9RKTLbhmepQ2WBpD62rJEInDc/awttAg/ZHqe099VJVpbM/pAM?=
 =?us-ascii?Q?8NwWa6gIeJ+vwyeNnEPTXbkbSGpTtewefTnUEmI5PsmlVNoSi/DCXFfouMCE?=
 =?us-ascii?Q?NuyDwaOcIboOz3Hyv1TuZh3xoLAs9hkpB+63fWTaZ1UPwOSdt98La3gI1UTa?=
 =?us-ascii?Q?XK6aX2vueFeWRXIjnm9v4E6UCCBMU5fh35GlcLuDbNKEh0nfi1p9SI2X9Y97?=
 =?us-ascii?Q?fzRh+5nUDdNat9RrOKU17x6tbd/K4lvN6nyoF2c5HPl2It5Ht7mciJ6vnAzS?=
 =?us-ascii?Q?mXEgURYxKwgfJaXGRCdB/7NHy26a1dgm3YiIuiS77LwwgCzNA/uJ0k2VLVY/?=
 =?us-ascii?Q?DfQolBYl6gccxOG9ZkkZCIb9rmXBPf5tW6BKz+NexarRQvbe0RBw4MkYWkz/?=
 =?us-ascii?Q?3vv4gv6Jzu4nKWWcJSK3CXnrK1jpk6XOZkZPt0edVRmj69YNfExP8CKc7fIS?=
 =?us-ascii?Q?rLbG1hjwkoUatVdTxPiC9Ljx8b0crJ/F/o2zkMM3Jr08P8YCwkMX5vmgQfPT?=
 =?us-ascii?Q?3wttWHOfsiNQR/cKitvMVDUyt00Bt2T2UA4xWaW5ESvsxdhQg2fFQn6i6C/y?=
 =?us-ascii?Q?4+/RJuX0H7UioTLFEzf9WX+4gxCXvTzs6DDw6AZIrLeKrmuO1AEcFOHM++We?=
 =?us-ascii?Q?czdkc9Qag+ARJRH4WWIlquVkFIzYOYNerKTMM6LOIifZddJjlRW9HjWQwW+a?=
 =?us-ascii?Q?Dlzrwzy17HB8zLO75cy2muv83LgZ1CVzBAFlE2lUpqnDUCnvcdLgA/66YavH?=
 =?us-ascii?Q?R3cY8PQaiZY+qoMl1IlTOSG4rlW84P7FbE4JSVKyfQ3wb0XjxXSKY9UENv2M?=
 =?us-ascii?Q?szrDfye7SlbbI9CqjjEF5GMOJPXQD3LQQtTU3xrqhmGe7CQCax15WKHQxaDO?=
 =?us-ascii?Q?vplEr4Oo6kaLN1clvA9iyT2QeZTcM6YtyJmx+lvyBPk2BS3NhFeRiIzFX08N?=
 =?us-ascii?Q?swLxB0bFnYpyepkNhBxn0h23CdCFOgBmgm1w5ophdVMP0Xcgn9BAoF0Lk+3C?=
 =?us-ascii?Q?1D9Tu7x6emOtsK+oEn0wZu1sf6yJzsC3bpQI8kxjdNuM0dsG2jwHp2zaSpUL?=
 =?us-ascii?Q?7HxCsaoEh0fk8ZGVs93gz+VWD9Dy9aNjrDNmiV82p2Wz9WvNY7AEJ5MXo4eY?=
 =?us-ascii?Q?LxZYwNcLmX1pkc9i07KSq3LHNXzo7Xs/Zc0g3gtVtWNw/oL83VqMXytJ9QYE?=
 =?us-ascii?Q?dMJ57cXmHNWotCCSmiCfGSvPDzzjZvBPunc7GO74QXkEybDQMbq0R5xeR5x6?=
 =?us-ascii?Q?C7sOIzo1CbK/7ZX62KS4hHGzbJ7I1akzCymtUjlhkua0SxDZECxEqZBlcUYi?=
 =?us-ascii?Q?tVAqL5qRxnKf+bMUYWb6/w+wopPuZj560TuBS8QkpuapHLLL0RKYWwpl6HE7?=
 =?us-ascii?Q?4j5SCxBcGMo9hG7UWd4nChP7sDaEkO/nlJy6kxW6m97uMiXABrIp7Yz/dIU9?=
 =?us-ascii?Q?JeIaUSx3iYo5eACf44798w0x5CpX2NNzof7gVUa7funDQam3ybYbXzOkyJhb?=
 =?us-ascii?Q?fPMwekybita6fwHopJfz/WiO/zPPiHsQls0xWx9M?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27f46196-cac5-4d70-f350-08ddb9925e44
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 18:00:45.5855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqUPLQRzn/A3v2kFAiC/dp+gIJxvNK6JcgeABLGLNtTQ4ia1Jc0HvHzMl43Uo9mwN6APAGhEvZRez6SIUUyVig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7913
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> NDD_CXL_LABEL is introduced to set cxl LSA 2.1 label format
> Accordingly updated label index version

I'm not following why CXL specific code needs to be in nvdimm?

I did not get a cover letter in this thread and looking at lore I don't
see one either:

https://lore.kernel.org/all/158453976.61750165203630.JavaMail.epsvc@epcpadp1new/

So perhaps I am completely out of the loop here?  Could you point me at a
cover letter?

Ira

> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/dimm.c      |  1 +
>  drivers/nvdimm/dimm_devs.c | 10 ++++++++++
>  drivers/nvdimm/label.c     | 16 ++++++++++++----
>  drivers/nvdimm/nd.h        |  1 +
>  include/linux/libnvdimm.h  |  3 +++
>  5 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index 91d9163ee303..8753b5cd91cc 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
> @@ -62,6 +62,7 @@ static int nvdimm_probe(struct device *dev)
>  	if (rc < 0)
>  		dev_dbg(dev, "failed to unlock dimm: %d\n", rc);
>  
> +	ndd->cxl = nvdimm_check_cxl_label_format(ndd->dev);
>  
>  	/*
>  	 * EACCES failures reading the namespace label-area-properties
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 21498d461fde..e8f545f889fd 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -18,6 +18,16 @@
>  
>  static DEFINE_IDA(dimm_ida);
>  
> +bool nvdimm_check_cxl_label_format(struct device *dev)
> +{
> +	struct nvdimm *nvdimm = to_nvdimm(dev);
> +
> +	if (test_bit(NDD_CXL_LABEL, &nvdimm->flags))
> +		return true;
> +
> +	return false;
> +}
> +
>  /*
>   * Retrieve bus and dimm handle and return if this bus supports
>   * get_config_data commands
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 082253a3a956..48b5ba90216d 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -687,11 +687,19 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
>  		- (unsigned long) to_namespace_index(ndd, 0);
>  	nsindex->labeloff = __cpu_to_le64(offset);
>  	nsindex->nslot = __cpu_to_le32(nslot);
> -	nsindex->major = __cpu_to_le16(1);
> -	if (sizeof_namespace_label(ndd) < 256)
> +
> +	/* Support CXL LSA 2.1 label format */
> +	if (ndd->cxl) {
> +		nsindex->major = __cpu_to_le16(2);
>  		nsindex->minor = __cpu_to_le16(1);
> -	else
> -		nsindex->minor = __cpu_to_le16(2);
> +	} else {
> +		nsindex->major = __cpu_to_le16(1);
> +		if (sizeof_namespace_label(ndd) < 256)
> +			nsindex->minor = __cpu_to_le16(1);
> +		else
> +			nsindex->minor = __cpu_to_le16(2);
> +	}
> +
>  	nsindex->checksum = __cpu_to_le64(0);
>  	if (flags & ND_NSINDEX_INIT) {
>  		unsigned long *free = (unsigned long *) nsindex->free;
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 5ca06e9a2d29..304f0e9904f1 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -522,6 +522,7 @@ void nvdimm_set_labeling(struct device *dev);
>  void nvdimm_set_locked(struct device *dev);
>  void nvdimm_clear_locked(struct device *dev);
>  int nvdimm_security_setup_events(struct device *dev);
> +bool nvdimm_check_cxl_label_format(struct device *dev);
>  #if IS_ENABLED(CONFIG_NVDIMM_KEYS)
>  int nvdimm_security_unlock(struct device *dev);
>  #else
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index e772aae71843..0a55900842c8 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -44,6 +44,9 @@ enum {
>  	/* dimm provider wants synchronous registration by __nvdimm_create() */
>  	NDD_REGISTER_SYNC = 8,
>  
> +	/* dimm supports region labels (LSA Format 2.1) */
> +	NDD_CXL_LABEL = 9,
> +
>  	/* need to set a limit somewhere, but yes, this is likely overkill */
>  	ND_IOCTL_MAX_BUFLEN = SZ_4M,
>  	ND_CMD_MAX_ELEM = 5,
> -- 
> 2.34.1
> 
> 


