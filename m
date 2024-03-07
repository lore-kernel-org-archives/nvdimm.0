Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D969139593
	for <nvdimm@lists.linux.dev>; Thu,  7 Mar 2024 21:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709845544; cv=fail; b=DJYgfHAvGsyqAvFo9CxezChadHgRoL02yq9akPxsv39scx/LrfovFVYm+O1BxRuuExxvNdoWimsfaQeSWprIzZG3r3pnXZiEASmTRGMFh0Y52HJ9zLnctZHkYkb2PP9bJvOb4ZsyE1cNhlDp2QVKPaBvJYK00I5OeCrCChuNcVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709845544; c=relaxed/simple;
	bh=7r2JRnUm6BE9qpTA4Gy4QJ5oDGfSbjTzWR4KOa8PQZw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UlH8aU3yl4q2UFicMSmsUzgrXZq50c6N8Wo1vh636golYWJVgjuGohP8xJh3JOG/xSQeTkt1XT8FjQIH86ryOfrbLr8NsKmAO3UNWcotHhArpoF0G0UrFQpt8vzUecYCZIt/BFf6biRK6ZiMeAF2wXFIP4WnU4qFHE4ugZvajC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PzWlEkd1; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PzWlEkd1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709845543; x=1741381543;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7r2JRnUm6BE9qpTA4Gy4QJ5oDGfSbjTzWR4KOa8PQZw=;
  b=PzWlEkd1jnxMtpMUBbv9wwVLLRrCsS3Z/v4LOCy2fjBuhQe7cadcstYp
   QoDAGUjKZsnxx9q1oVA0uLTA8QAEjeNR0cGbc4DdsWl7BlD8G5MttYQpj
   o4AevDlmAlxX81ynI2pS57KWKN6D+VMWHAt4h5ytqFt1TL6ofTif4Ad8Q
   pJiq+Y5KuibVrGT0/qQgGtijkcLdm67jp+XLK5iLjD0OuMvzbnBmbD2hr
   QwVMrfaGQfZdFd6p8H0KClJoWX57Z1t28llb408UBaO6N0ngXrq1AAup3
   gCcFG7o4kLPI0WK7sHWpZhM+jY/QPHQ1Un1EpUmWNCh3q1keGErvipzrB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4669100"
X-IronPort-AV: E=Sophos;i="6.07,107,1708416000"; 
   d="scan'208";a="4669100"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 13:05:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,107,1708416000"; 
   d="scan'208";a="33386314"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 13:05:42 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 13:05:41 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 13:05:41 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 13:05:41 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 13:05:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpywTb3ZunXqOP+P+6TjY2Vj6z/gz14Pz/jntuYjNIHHue+NjVBtw3xUa/HCOauOgqPXTaYF3vwXFVLc6Yd4rDbMyrQ1rSv7Zq8401W0l6pDkcCZJJBp755oica9Yp7w8EcLtwdgZDwSl1st5Z7W7HqBnhcXNr+c8YLUgQRDkIQOeHTvbiUeAP+WGn0+33hF+uBksaWyccQH4MtAJ1wkYsm/5Oc2PLBRS4S4PJFs/0LMLvlhL2RcRLu95zNRKBqRZeosy+UwGF2ltmJYkPgTpMr2kH5SVU/pkQyUpOL7/lvQqaXai6ONY0JfvFz75PXwJeG2fkgRxyFJFgXeMII2gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FtXs3y5oL2epGkozVegY6upKrP40JFHPix/bX6JHFNs=;
 b=LToK6mnOPJgd/fPMMTMBlwhnbyPi43LXL758smNPAtHTEWECWIoA70UN0N7Wk9euZqwwNPiGnwBX1fbR8h169GpwlDhY63t4xXppdvo5MYdUmas4M2mjKayhcG27jHio002JPmFeeXa0A5xH3+/+pqls5tDrqihlSHxxIu7Gcw2vz4c6aQQCWrb8wO67zXa9uMOzO6RV5F6O4PcmQoA/mTBO5ZRWNpsG4vUihNeEwzzOc1JEbCrfcXjpaPGmU1ZLASSt/u2IeCy3aE95PXJ/A/NTqc4qxcQAKjWCuHEC85guZXucPPpP/LFTMhWQXcwCMAUUhYdTvKjSclWx6I1IeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB6805.namprd11.prod.outlook.com (2603:10b6:806:24c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Thu, 7 Mar
 2024 21:05:37 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 21:05:37 +0000
Date: Thu, 7 Mar 2024 13:05:30 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jane Chu <jane.chu@oracle.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
CC: Linux-MM <linux-mm@kvack.org>
Subject: Re: Barlopass nvdimm as MemoryMode question
Message-ID: <65ea2c1a441d_12713294d9@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <a639e29f-fa99-4fec-a148-c235e5f90071@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a639e29f-fa99-4fec-a148-c235e5f90071@oracle.com>
X-ClientProxiedBy: MW4P220CA0019.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::24) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB6805:EE_
X-MS-Office365-Filtering-Correlation-Id: a44f70e4-7cf7-45f7-2f7d-08dc3eea5656
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /W2owkCRqTxSkpnUM7mUXaDwBMnkhcIfUC/ZvcdvZOg0S8KHv7VTQSpR5Es9lzC7xSEjWV23rR4qyt/rqSRGqeO8rc5aOyMnFC1YYQXscfdPmfELESxXMWtDr2K/ozrkBgsQxG08zYEhGbtxVLaIwrO7xUy9vEEI47nIvdayjtftg/lHBLRoG50IjOTG+kJaGTzbhlexRdqWJPQyBblSDeeHbZa2d42A7sEWhz25PotfJMNA7JdkfAbrz+u/xZYUgTRVSszz+vW7Oky2JCh28s6EMlIpcfMyzkUZzhoeK3sqlq/B01L/jIxEvT6cR0O3SoGF7bgDaLosPfRLBuH4tSWdbqIGVRpURRmBfsETaMn1VVynK7qAzt+3R6fveF0VUGO+9eVzc77RmUyO5pFDMrWmtxVOlsF66rj7ppc8Jy5JoT7GHFcdCGuSFR74861/CNqDwkKoBpkJ0dr2fnZjyjqXZU6sc6IM7uCCnF6ociqhHQ9gXuRLqqynJdREe8wZbyc17CKNuOVSihb0qN1MEV2Boy+Ja0QsBQDc9QcDJYJ6bsKNOKSfDvWezVuxef7fWZ8yOv0OC+KLCpOJKFxW8l+pEb/zreEiLKVFyw4j9jeufHWbP8Jg80cz2DlO8cBjrlF6STQxXmRUJj2NjBQTObL8/MrQtNYOd2tnWcCsnYI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nPdgNw5A6gqlZl7v9vexjKHYSBgvXa1W4tCbpxT0SAMvcnTzS0P9Zqy0S7eo?=
 =?us-ascii?Q?W5rbT1KErwFIxzFR8+21uQOm4CwzNF9fpqXVZfSSU/t65COfauhENju0YdJu?=
 =?us-ascii?Q?IHKWJxvMZsJcFHW6zBY6g4OunRY79QsHjTtOjbxnh19l6xsv4771u1CMJ0K5?=
 =?us-ascii?Q?NyFBi/2yzzLyOVEI6Lxnhv5V0ZRa2UenEDYaFHFCCeaYM5WgEvgniZX7s3Vo?=
 =?us-ascii?Q?c2MBEl79ErMuPBLW0fRKWfqRPrM7yLJeZb/Zj/3s76H07TBkGTUDLXGFENRR?=
 =?us-ascii?Q?KCXGUgr3nRVFRykF05wcNeKX+7l+srnQ/VHN081GZcPafmEsgtcglB0DLwEv?=
 =?us-ascii?Q?+Lg5KBnV9iRdCxw7Q2hPJXRfrV+LwbkYVUwOBwpZAxEUt7CsqNJJtc5CDc7D?=
 =?us-ascii?Q?dQQaZqyomQMyJeyyC+dF7o8LJhwEkl2YP6r1fwHagVKA9NRg4v5Bo+hIV/lN?=
 =?us-ascii?Q?YAAwV8pMpwVg345DP/oyjhULycJn5xfJBJylwuds2cm8URy7F6U/vYTlaKnD?=
 =?us-ascii?Q?/lgf2McIIyw00kDOdSDoKaXchE63KD/nJbdZLUHMfx0670yVtZmATBOC6vEi?=
 =?us-ascii?Q?BpZPg1rHRkdT6lGMWZGtx5PD0xqlkd2zNvSf0A8M+D92KGwFBA4smvoGF80L?=
 =?us-ascii?Q?D+mKMGiRD37mmEKm59FK3dcQ1XSBnck/Oq+qsDNQYvsFz4A7J6H92/IML9XA?=
 =?us-ascii?Q?GDNrRLpn8yf+dBK1WOzhA/l4+yJbJWhm22H0eAnPZC3qJjXz2OMmy//1KXGb?=
 =?us-ascii?Q?CMp5la1eMp2E+KLl9TPVifopze+CI+OiVb5Yztgv+051ydeT1HAzyMuM9M+7?=
 =?us-ascii?Q?e1W+p0vQvKtSJPh3grCv/y+UdsqAD1Xbguq2dYOB9x19k6cuCmzHEofaB5K3?=
 =?us-ascii?Q?xZqILSumYNgKfPEyQqTUJolLknNh1xKXUoA/FcXcWWIOm3gCzPgCI9xJzE23?=
 =?us-ascii?Q?TzwfBzBaiGyzAcHG0G99hkZ5Byo23T1A5RtBwRT3BfmeaTDgqb0sTbxv1HZr?=
 =?us-ascii?Q?tq5a4amnz3fELQhErt9Cc10TZFiDo3B6aNADjXHPOcd/0W9jhGGZjpTxo8Ny?=
 =?us-ascii?Q?x7eeucLxotTzogtUZF64lae99DLpBCQUeYfZ8VjUbk4RuYbP3dkke6f6xBBl?=
 =?us-ascii?Q?FUiVx+myyobBWg4ZnJxEV767In+Dev+6d1gmCnS8jUWkjBm7aqldmFzHCBgO?=
 =?us-ascii?Q?DLOiZaWRJHFrPWCtzVpZNFBeDztVxIM6n/8/2zh+ZeC+eAS583cSOLiN9QPl?=
 =?us-ascii?Q?ioEf3L0JHYLwV79s/STeLlYy172EH39q5D63K4CSrfhWaI0SHGv57BjjuOdq?=
 =?us-ascii?Q?gZH2jgxLoho+BHhvuSFa+UmmqOxdwYff3Bz/4vXQwoImuFGU4kZlkXE8NxpR?=
 =?us-ascii?Q?ugiAGGYz6B4Rh1TYVZAMZn7cTZl+ZLhVGYIsFFqiAnVoaer7CMPvQ0Abqi/6?=
 =?us-ascii?Q?R/uNZnwE2L2TV4rP4fCpBM3SqTRYazP1cGwzdQTIXnEZjxbczETDz2HC2Vg3?=
 =?us-ascii?Q?EiwbMvgXzmZly4E8DurJZrbBKPXkp20tHEOGvehJUdQIYtD2ZnwqgrRV8xjB?=
 =?us-ascii?Q?k1qhYEesHFfqqztXsNLGmG/VftmZPbc/Jcq5OkAblZ49JjxwxxX1QyU75iLk?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a44f70e4-7cf7-45f7-2f7d-08dc3eea5656
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 21:05:37.3216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2/cd3C4VxvLrG9etNBqpjJOE8G9NMVNLE5yk9OTafqNgCOd9Sr5dGRtLA6gpW78TBqdeyOgR8As7w+6G8ZO5TdMc/SOonUpYCZEUq7LXSec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6805
X-OriginatorOrg: intel.com

Jane Chu wrote:
> Hi, Dan and Vishal,
> 
> What kind of NUMAness is visible to the kernel w.r.t. SysRAM region 
> backed by Barlopass nvdimms configured in MemoryMode by impctl ?

As always, the NUMA description, is a property of the platform not the
media type / DIMM. The ACPI HMAT desrcibes the details of a
memory-side-caches. See "5.2.27.2 Memory Side Cache Overview" in ACPI
6.4.
