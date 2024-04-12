Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E4315251C
	for <nvdimm@lists.linux.dev>; Fri, 12 Apr 2024 21:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712956198; cv=fail; b=sWCNL9f9JiUvu4k9PFmnfh+kBTEEj7maxXjtsbBsCVbTz19RQ6sDRZxl4mGqPVOGTjneTWVcqXVJbBgE7n251YIrtN1c0betQiJ/J6G2HiJmFLCHsEJh/3CT2g7h3n+2KynuHvqylv27naX3JAn5dFHjEH2C3gqBMgtOOu00/pE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712956198; c=relaxed/simple;
	bh=o1RwyJWR+36dFO4rK4YYiuPenhQpAqIJPb3jR4IajMI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=au7bK++88ubjZovZioXRTZq8FBLzfbErM6KaFBcNL7OLJFcsPQhmyS5mWjtBMwi7msMvSJdAp4Z8MezszxC3AgVbtE73FBd8ChQfLer8CtJ/wvDLLdjg4X4T51eVRMPW+IcW1I7izrKcWWF5jsssg5t8437dHBKZLVgMo2HXjGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YEoFr/oz; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YEoFr/oz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712956197; x=1744492197;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=o1RwyJWR+36dFO4rK4YYiuPenhQpAqIJPb3jR4IajMI=;
  b=YEoFr/ozAHCyQMNc6J2xUqhTOxofLlSJ0Ns9zbPg30/BE9DACCk0rVyu
   +qGVXAp3HmloWWgQSXA/rX0ybv4YcMetMaoEG6DJ3092e/SQ0tB3YDU0x
   mcLe4U0xxQzH6VQvW+3qtLwaexr7Fs2jMSAJEiUHOf4Ovd2viZ8m4xY38
   pBlOmdZ6Byhtq7Lla/E23LbIj24+rB2fLjJL2QBj9F+4jMhpda4LUMtp5
   A58avalLXAdA0IIDV6xcIqIvjkinLDJhQPb0ncuNgy/lgQElxl+omDm9O
   CV4CVlCqvK4SzG+SBP1Mi591qKTXJNW+6r3A1BYxYqymNs6wVbc6wD6Dy
   A==;
X-CSE-ConnectionGUID: vl8+BBZWQ4mdeQJG0U9B9g==
X-CSE-MsgGUID: JYpXcOabQIyltae+268sNQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8556077"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="8556077"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 14:09:57 -0700
X-CSE-ConnectionGUID: 3sK988YKQn+wowXBQc/yQA==
X-CSE-MsgGUID: i1nMBqroTmylNkwdxCAmdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="21329653"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Apr 2024 14:09:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 14:09:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Apr 2024 14:09:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 14:09:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+sBdFjELRB50TuLJ1bxaU0Fy7wDGkucQxg+7UmP9lzF+PiahNR19H68cuNMAYsfnTm2k8bkBE6dCguY/zGo4zXCvAvzUOjp39GXSzXFQD789zUREYid/n0E4gAacsKIqQySDinDmE1SkhUS6v+Q6X8YOBeLck84Zn49D/fk9sevVJP6Ukj9dTa7yWmKjUBw3vmnAAE17ljG6n6cCoorNdfw2kczFtbR4G5tYVMGY+VTww7K7h5v2enz4qhUzPu9M0WdkQfZ/q32M5kab9lTVdaMVA6IinsZ53/FXIhDDuxzV8P34a/rDQD1zEUSrfr+HF4lEfdKPUZLgd+Caz1PzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HP+vd6eUgUYE7aq3EiQgryZ5nBcqCyADsoXbs+DCBe0=;
 b=NocnWirvm8AMws0htw/Ta+3LufiuIohXH3wo/SGp5VyKTnB5Z8IkWvz2nbi8dyYLIDINRCA/x1pDgt9hPJ+SFvhgvVDABP8T39WL06UnTFkNgHrgiYFJjc4DsRsRlc3ruMRKVixmC12M7gc/2rZ7y44HoMrxr0pIJ3/nfRsowdE6l23n1CjoMGefEaraGj5ptQbxQEZ6/XP39KWSvKgPDCj0HydhSRzQnsGxfEfTB4PYTSufp+qGxlQOfXhN+gMcDOCC4l+Y/+Xf6Lo1mI7Cbk+dHeBwr4Nezkqj0bcrVV94CG47h5sDaBbER2T1eyhl4bk3/c36XspDrZQIpWh31g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN0PR11MB6111.namprd11.prod.outlook.com (2603:10b6:208:3cd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Fri, 12 Apr
 2024 21:09:53 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7430.045; Fri, 12 Apr 2024
 21:09:53 +0000
Date: Fri, 12 Apr 2024 14:09:50 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Alison Schofield
	<alison.schofield@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH ndctl 1/2] daxctl/device.c: Handle special case of
 destroying daxX.0
Message-ID: <6619a31ead1c8_2459629497@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <20240412-vv-daxctl-fixes-v1-0-6e808174e24f@intel.com>
 <20240412-vv-daxctl-fixes-v1-1-6e808174e24f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240412-vv-daxctl-fixes-v1-1-6e808174e24f@intel.com>
X-ClientProxiedBy: MW4PR04CA0371.namprd04.prod.outlook.com
 (2603:10b6:303:81::16) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN0PR11MB6111:EE_
X-MS-Office365-Filtering-Correlation-Id: 5712b597-52b0-4a36-cd0b-08dc5b34e5da
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rU/Dkoi+QgmyE+jgmwcuMeQtOHPHJ6kMo5JlQyok2FkqgXkPlpPRJq5Ie3PDJDhEmVx2IBP9AKlNpxNxer3bKMIc5psJxDifuHQj3zeYACRYoof+BUSkhTlAsPyne+39OiRpqGi5Q84diV9CCkvr/QsweBvpoHS+AAD7dkFalkLaXZz5wWaaqF7IzuerqVMj3Q56aVQ/zVGUMkxeiR7v/v1/7JpYi/j3uFg6qyC2cnmgh1QJ+onmfSVuH9IaWmVQf83FtkSCbxCBDnt7RvO9dAhI1Mrbb49prQ0nCeFKhBnuk35eCtvejI16OGGXyBcAj2BWk2kK8s2dahiBosb7jH0f914ZLjaAs7mcJ9o0AumRSupjvTCeYzmDFtH8ExVQVUfUF/piY24Y0yo7qYwz91hf5piBW0fJ+PuC6YgGN5yyrEEKyRw5VljuQqpHEz/12/6LmBPvc/o5PwDaqa8iFA/g4CH23TeRvhg9+Zo4PYZ7tzLEF/D+OWko9JTRaUJwO+mwB8l5S+M1WkkTwjDHo6sG/O+fv5YCvRYLYuDWxEGj/M9GdCsWfAWwHYvBshL8Md0imWN/IjsHCXhE1YNIsSau+ouYlRTPCzpmqLk7Jf8gSmzLlLinYrFdDPleBySva/iJVytR3FYXxsLqADmMtgN+tMmAqjYNyo8Aof0SMfE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bNRSZBmL2dRgyru0gF2CjExfq+wqj3m/p4fiUbf58tN7VHCHd0uIpMXmsik1?=
 =?us-ascii?Q?WV8O1gXaxCu/y31u9hFgN8rTKtGJpzV32yY78ag4l++vgsAKdliKmI8Z92lr?=
 =?us-ascii?Q?wVoz1gYTGVB7PhdG3zxuoBOZw3sfHiVHEEm/vKIpIDsS3HH0ckXwqQLfwQcb?=
 =?us-ascii?Q?jTwTPwCTzYphbhlPlVA36VDwBNKdX2UTFsMTHsUDhLont9ZP5NBUo5lkeCMj?=
 =?us-ascii?Q?BQbI8+8SHTQChVPXl17GTGjY/2uXz0Hb54huzQyQE4Me8PAtoHP6e4dFgdbf?=
 =?us-ascii?Q?3BPdUFCPm7b2GL6bcR0MBqY5JU13B2OMS95rqo8k3mct5Sz5qX/D1y3CYYh8?=
 =?us-ascii?Q?91yjTzeTtS0eMe+UPqdctNyVKCsAzFFAt5iH0s4uIc3Mtq3HODJES52MERhw?=
 =?us-ascii?Q?n/RY57csoqm//EIAOuiwTHks6cZ8VA1OjZPR7rPTZN5ojLn6TNuF6NJTHOO1?=
 =?us-ascii?Q?OIHqd4SM6dKkKoEVQgH3g7aM4MlrXl/4rGBWeqt33h1MWoOZhMCdsu295n5p?=
 =?us-ascii?Q?MfZlJwtBQLC35p4Dm+Sv47PVg9az6I9ufia2tacH804kxt2CKf972owFW1be?=
 =?us-ascii?Q?bMWoTX+YrR1GvB4WkUAu/dPFywaZbrKCE45mYn7lOXcrZ3sOV8X6ueVwFUZh?=
 =?us-ascii?Q?e/CoiI/s6oIxjjZP9szcy+DwzsTMRRUtut1xtWaE9RSzmUluyx+PKU0dBtK7?=
 =?us-ascii?Q?HTymQLYtz2T3ZcR1P1+bNQTGnujqBREdPRfPnXP5CUHSCJKg5okLs3srRpmq?=
 =?us-ascii?Q?hdLqF9hadx5L5FWPFN2oDKKu/jkxc47IoAkDG+EBaxRX3wzKLcB32JrLi/XP?=
 =?us-ascii?Q?xfRWi6gM8R9vn9zeRqFJ8XqB/1BlYtcIakx2BQS3GI+znhHhNxJaQzH0nUq9?=
 =?us-ascii?Q?8TeqTCEgXLOB82MtGZMyF868soi1hHNZXVKhKzM94kxZIJtteFpr7dHwedUp?=
 =?us-ascii?Q?SvavTQRDKGU6FCnt30DXRza6FeXQr9yJtW4ZIOn7PV/8NKgyFe9kO4XfUGHm?=
 =?us-ascii?Q?1AzXxZJnuR+IqESLB4Qu2zX2VDqjCo1gi8VcIAlZagUX5hNSME3NENXx8V38?=
 =?us-ascii?Q?hevRoyrN0YAg18zhzx1Gu7VBAwFvnfEWH9zxTjIj/eP4vkTW3t731LVfXB13?=
 =?us-ascii?Q?Lx//MfemW0Zn2ujFh9Iim/eFhrZAilGIvvROQ/MDdtvMUorjlc8U8UN4JOLN?=
 =?us-ascii?Q?Q0F98BdqvjsUamUQlTqhIjW+B9Bat6qPJsXlSgpW7jYsPIum+MiHr+mH5Rfx?=
 =?us-ascii?Q?+LK9+Ql4Aro6kpaxpgu0C3OpaFsaCkjLia1h9swMcMeCEJjVMUpJQ/tFln5r?=
 =?us-ascii?Q?YbmKIiLI3RxnGnSfEnAUpBsfsjL0JOUdKvHmDJZbTcd3EaHqDODj4xiwncaH?=
 =?us-ascii?Q?OWoRhCekTREboOzJ6NCkgtlr38fPjBuN+UEWRCRd4HT5pBekQnqbqf0joONP?=
 =?us-ascii?Q?ZVv9j6t7lyDfr2t44SPziYyBAKVPdKawqvOhW0fQcQ30w8ae9GyK8/AwhHa+?=
 =?us-ascii?Q?EdAO+tcCfmkDkqwmSE0tpsIM/znt8Mj2eO4tUrI8diIKmyfOGQSIs/MyzNto?=
 =?us-ascii?Q?qGbTEtEGQly4XE1mErsfkdfKicU94nC5Tf4m/Sw63tmw/UaS6RvLGugrJGc4?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5712b597-52b0-4a36-cd0b-08dc5b34e5da
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2024 21:09:53.3809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qOyoYXaLQrzLk3TqGfWJ8PGTc+8bpw62x+wOA/BZtFooO8FdmIN0SucZoaKzmP0arX9CzXam3Hz9mKglF7ggbto+OvlD7zQ2nOcJWEp1wKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6111
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> The kernel has special handling for destroying the 0th dax device under
> any given DAX region (daxX.0). It ensures the size is set to 0, but
> doesn't actually remove the device, instead it returns an EBUSY,
> indicating that this device cannot be removed.
> 
> Add an expectation in daxctl's dev_destroy() helper to handle this case
> instead of returning the error - as far as the user is concerned, the
> size has been set to zero, and the destroy operation has been completed,
> even if the kernel indicated an EBUSY.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Reported-by: Ira Weiny <ira.weiny@intel.com>
> Reported-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
