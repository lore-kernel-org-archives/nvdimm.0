Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6298529B761
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 15:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749742127; cv=fail; b=pVWKDrSVbKesGzNb3Sr0WqLCGmuCvlvW3vninPJgC0pGgnvOmvQFHrIjmyTSNm0u0cKZ1CIfaLoo9n9Tp31M+dNRWFaG6X9XgBmlFLfbJsQm9ttyPw9xijbBQx0yeQ1zdN4CYp18eLCEjXpUJv32aRYS0XjTLzoV/VFuFRxwbio=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749742127; c=relaxed/simple;
	bh=jHMKC9S5YzcBa/pcGmWV72I6pG9cnvQl4PKxxlU5noA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dVEE32ty5uuNiehz6H8n+QQnx5X8rE3O0Ekn5X8wZosIqXfQL3/JEy7N4flUQjC14FQdrF6yk5duXDuBVw8o9m4lO1JSSA2myCnjxAODPjtcMgRBQfRiuBdlhhYN5KXR/pPvWyDHKjc6doPa4tCRpP4mnBzbubg/s6aeI7PpU/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XFCY59XD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yfvDcv6V; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XFCY59XD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yfvDcv6V"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55CEthgY026749;
	Thu, 12 Jun 2025 15:28:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BDjJUv5BxaVqchjG+Z
	X7rLKdLZLcPWGNc00vHa58cz8=; b=XFCY59XDR3d0VZ7Q3eL9BX1SHjWmmCDgpV
	/WmIjzxeXREEgIEVQu0CDlAGWpsvTsWrvTULne+EOtfEPluXOZY1npgDJPQ3BidW
	2wWjxpegWQXEzQpQImbSCEguGoQMsr5UsUoWnoFKFKoEpFVlGiPRq91+dPPKUpOR
	9pqgno7xROV5Han8UXPKbAuGAOIVQI3wDfdaO41PnnfNFs3bo6UFZq/gZlcjt991
	BqlxxCglCpAJ08K0jUe451d+uLA97vKJ3lMdsGvdnD7j+QiXq++Sxh7me9g6fxB2
	sdxm1bDplovxTjKd9UUfBcyK5P/YtSVRe7EbvOBET4Zj0rdw2nCw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474cbehy9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 15:28:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55CFFOlj009366;
	Thu, 12 Jun 2025 15:28:21 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012000.outbound.protection.outlook.com [40.107.200.0])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvcf5gq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 15:28:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KHv3UhikAgx5R0bSehdX2BCf09OrTnFxliakHqgtFnOPAR8heuMk9WQ7oBMAskD3eJvvVKNKstvRoKwE6PM1ExyZqtfq0LihUSdj6tsuQ0UMK4p7ku+PcbuKwND2Zyx5+5FZaZf/UiW6jo33EXnPv1ZizaCMHCxFCzd+uXYa06HQwIcdntlr0wUapDc6m5cqZMkCzR1MJ7N1x8fUnG7/I2c2tnL1T0l/q7tGZo9cmLKgRwRaEopPiquovU7vpi2M7VB940oY5SWC1H1zQ56YzpIgbE0T2rgnJQOJ0ycG+4PmUXZCqxgwThAVg9ObRdE9TxiSdMPZdnRjsY4Dq4DeJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BDjJUv5BxaVqchjG+ZX7rLKdLZLcPWGNc00vHa58cz8=;
 b=WFVwYoFiwiAYKiOyQ6NIckYmlZDe3PhG0CXRrI1QqB19NM2bOhEWqbWFWF88zJdfSGqaNc8AVB2cD7WuL8kBB0h2kdRxSCXilRrcX0t82oUo6QqwbdeJb7orV9n2dVyB+RjV/ZoPM8cfrSsoD4J8e8NBomuxGoo+AbaSqIw/GkGYbuZx31zMczQB67r1LxqMVmWvhc9WUmlxhVmLCH+TCwFhUai9Ol0YSl3/W1RTY28pSdKNJU8xg/767P1FWUK/tBs+Hmf/pENg/CjL+pZbmQWnNgwOMGSJDnS/He3qyyae/mRGxBEdZkJhgoXLn9WwsE+uJ6q/fGiISp16vxIl0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDjJUv5BxaVqchjG+ZX7rLKdLZLcPWGNc00vHa58cz8=;
 b=yfvDcv6V3V8ap2ArUDBEMRAwTWUNg3F5xEvO+NlhznwL1SSmITnc+8FmdKlkI8F4M/XMp3DBHGUqFJtQ4dK023bfRW5Orc8ohkmxumUoLKynDp1w+JAJ0klYf1lA7obdKA95+rfyUXsQ+ARpjREIrQLoRZfAogJlk4O/R73z1Ng=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB6960.namprd10.prod.outlook.com (2603:10b6:510:26e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.26; Thu, 12 Jun
 2025 15:28:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 15:28:15 +0000
Date: Thu, 12 Jun 2025 16:28:12 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev,
        linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alistair Popple <apopple@nvidia.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/huge_memory: don't ignore queried cachemode in
 vmf_insert_pfn_pud()
Message-ID: <02d6a55b-52fd-4dae-ba7a-1cccf72386aa@lucifer.local>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-2-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611120654.545963-2-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0186.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB6960:EE_
X-MS-Office365-Filtering-Correlation-Id: aecbd3d6-b3d4-497d-aee6-08dda9c5c057
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BTLv6E6WRlt0exJ18IELNZ2swYjGk4Lgr25NagG3NqMHmhVB0zB9OLZhbuln?=
 =?us-ascii?Q?mfffeRJENP7P6dIi3FbeZfGyNyOsfaHuSpoB/Vt9cCJX6pm+nSZrzvTtaJ72?=
 =?us-ascii?Q?+W1negFraYq1p5G4e49nOjbqRtzweKv0c2OF/WDR0fROqrfds3IF/5PJX888?=
 =?us-ascii?Q?Rt64K11f6m4FQp6lMFeFTtN6BVU8aIT89oTAiWq9/WuUFZLBN2SoHDOJZx2L?=
 =?us-ascii?Q?cyBrIw68rTy22Rf7zUdqCVoOgWdsUttnl6JPVzj17h2FRt3xrAsfak9xc6+L?=
 =?us-ascii?Q?iGOVZrGse//ciryAyMZ+LnFenmxCDveRWv1YJRooxKtfz0lcPtlWh0MFtCG+?=
 =?us-ascii?Q?G1IoztxdQpJWr33qbJn4aCUlQmJGqNUmy+d7OAXpzvTzJrACTC9mfpcunoPw?=
 =?us-ascii?Q?3DwpcjsU2C72Cq2NSinQVfxn7RZm6daItypnWSBiMc7Pgk+Sex4Df/yOScxI?=
 =?us-ascii?Q?7MNLZUa11peLfGVVqcgkFdtPNjDsIpGjdxR/ZMWYqFcBgyn2BYMne7xi4nsn?=
 =?us-ascii?Q?c0uYnCLjfOuT6sMDAtgdagj/Nqy7+uYkeS9S6ouHn9uf5IdC/r31FazHFyFb?=
 =?us-ascii?Q?2RNXK7s6jAGp6wqvdFo7WqkfeE4Vu3GqwL2nEQqD/9heDY79wSMawGB09+bI?=
 =?us-ascii?Q?ZICgs5cVoHL79vyn0U7UERgqlhwajXJmmaphjvXbh2XL82fJkcabYeYikpZx?=
 =?us-ascii?Q?QQ74YQPt83Q/WMetAzDAonMs/PJco6oqsNYXF2hM930GhTKEDJSQz9oIVk0Z?=
 =?us-ascii?Q?E0y22vizSYzQ/Gmvzak6LszMYeG3GMCwjwaPBHfE54HINkV1MXFg7gZUkkWr?=
 =?us-ascii?Q?c+rewGGtOTXYTHUmyccn2SuKQM42BCjLUS++JhKHvyQYLcCz1OkX1HjyE0p5?=
 =?us-ascii?Q?X+QaKd5oNfzWKHXv8bu+OW7rHTxP85SI2np1bSswBZ1vQ63GkTWwJ5jbA+0S?=
 =?us-ascii?Q?+5DGbFM3I7blAr+b0VYlkeShEZu1bAxmXEiWA+ar/q2b6p0O2rLmk7xseZ8z?=
 =?us-ascii?Q?9xx4HfgmYVf7EFLqxTl6gGmwE0Z0OcP+tVxI9wGQZFzBPMy3Sdt+3oQBEIKQ?=
 =?us-ascii?Q?tz5Y2HprPqtQb7qlTJ7isdqD28hHQgMxXV0Lh/53O+0l2AGJLJiDhYfypjhg?=
 =?us-ascii?Q?Eng3d70tBNDyiBbCSTLqQPbQVFC1wWVaQ80B5TV++Tb94eFFiV7IhY5Lcmum?=
 =?us-ascii?Q?iX6zhNYKkM1RbxNq/tnNvNlFecuInqulK7WPOZCoNl+QGxiGyFe2mwFk+l9o?=
 =?us-ascii?Q?8DRWBlobNhPO4PCsHLxYkOtAlRfrodDtbGVNn8sNDHNq2GyhQqJKI6c1XirY?=
 =?us-ascii?Q?jAlCuZp8oZH9Q39vL7Pt+urccIzS/h1bGfgt9QLZyy7K2/UN4wVLodBcdqI+?=
 =?us-ascii?Q?45lrH1EH3W195brsMr9ukOE/8xI9L9knh8ofSsJYE/DervlV103xWWCIo7uF?=
 =?us-ascii?Q?1d/AXfln7KM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3me6wbxn9LUxFXyNkF9PXo86vt+FjJeC/09C3fPy1/7RPk5jtVo6b+HwfV57?=
 =?us-ascii?Q?JrUKGVga/nKXYvYnAw/M9JIaAj80mzQ4nDHKWwfdkeAvB9KnC4RpmVUr5JDL?=
 =?us-ascii?Q?7ZhSog8H3800ncPa+aWfERv3K8tWM7A6dznBxE1EIJbD7KEHKAMeFHmCFnZC?=
 =?us-ascii?Q?KzQb3xQyg34gRp0zgy6RmSs0QkKcQesEOmXZ92/WWKKMdoJDfAzZ5Xvtjzby?=
 =?us-ascii?Q?SU2ZgURxECVMvdN5CGBss4V8wpzgMdEXNe6Cy0FyMwu7J53RWeXnRfRMvZqX?=
 =?us-ascii?Q?omxwz8D7iEYQmBlOZC579/W7bPvzDxDrGGSo7NPIF2dFPIPPzeyGXuyyCCQL?=
 =?us-ascii?Q?1N5nNIimzytXyi+IiULjRpr9Q3ph5RQ5vh9YiRPTWCu/2Gk6XBHlTgXMi5dh?=
 =?us-ascii?Q?TYpVvGGi8LF/Lirc6UbrQd4Q7lGGm3ejCymfwD/jiLy0YQRGC2PlHOXGo1xg?=
 =?us-ascii?Q?JVpDbmHA0+nNzzqRMIOfq2lSgQGkSVcRy0hevRCQKSm8YLKBgZaCstgBiUIp?=
 =?us-ascii?Q?wagMAwquiXlZr2h+NOLsoUropOBnTU1ixr0KRCUXEa3aRbMZlJ6BTh052TiI?=
 =?us-ascii?Q?iHXBoAocXiv9vuEWChla5DhyVIi2JBQ8/EzZ1eTypHx44cfG9VBZXgRhnfh0?=
 =?us-ascii?Q?pREVLX8TML2aZgKU/3CEi8eZ+M1QHChJhkaAi7Ji2JzEw+Z2jdfRWAP9peLU?=
 =?us-ascii?Q?NQN7ClOBf8Un1iXoO680BTMLWauojsHaoF4bnV9Z/lmpeQfuUwPMmU7WoJ87?=
 =?us-ascii?Q?63BaGd3ozI8jAqBHoerQhoM2p+forpes22lzUub91RP2MtxpUpsVVp8sZWI/?=
 =?us-ascii?Q?yW6X3Om3dw2VZYg8/BMYWDLKblXrnJjKDmYWfS1RMN6ei5DePC7q1I42ly4J?=
 =?us-ascii?Q?wIfHmZIB1ZoCUNDPVc0sjvxcPt4sHvPCyITsoM7HtqXBK82Pfvrry2ZQLlR/?=
 =?us-ascii?Q?7f/BbagWYRRTq0VcmaYU0+8TI3uKbuwW07sIh+F1Lai3UvArJEHvxLH0SWjh?=
 =?us-ascii?Q?mdAcbz5r+BNjsnMHzz4UXhkW8320yzAC4puPx4SME7XeqsyfRoidhjpGwHfu?=
 =?us-ascii?Q?XLhs705kCnFFP6w9JKJgHnUqK8m3gesQQSf3ZbEf3qxx7rMT34CSxT36Q0Ib?=
 =?us-ascii?Q?nNS4G9hu/cKquMZO+9pLTzs3Rl/siI7BJLz5B4izGQtGxMZ5I+WwGQ2AvyZr?=
 =?us-ascii?Q?NEpldvlc7mcXZlzePUQIoc2OhZ15Fh7Tp/xx8OfHFpZRuxJVmmflEHkYsyDY?=
 =?us-ascii?Q?tR2heAUxsVzV/S6itpmSCt4uVVsom0U92NTHMWHQC+KUQ+42Lhnq0SsoJGTL?=
 =?us-ascii?Q?ZZRnrkhsFgBRfWqtysduhmHMmzN40R9WIadziHRLeks2yCwzfeZipLjZXHv5?=
 =?us-ascii?Q?c/SNbtzw5Rz/MvxqIyt+pw5Hz+zNSxm35breweaxaR5FtWXRE0GBisCK0c4E?=
 =?us-ascii?Q?GZxxnYMnpPAmHAWu5oAuLBRcHymcfrSwRTVTWB/Q4jJIhR8XB2Gl7GWkKhiw?=
 =?us-ascii?Q?HJGGzfNgWcqTBBasl14qExMJKSMDuRDWMv4A13owdOeU5raiqYg3CiM+T0uU?=
 =?us-ascii?Q?TsgIqN265kPenZXM/iYwKZLr7ml8y4FVN6Cw4mE4DOjnSnwChBJQAowM7AES?=
 =?us-ascii?Q?hA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AcmVOp0oKvbZjEkmHk2R9rIxSkMwlpdmVYTvHS3tzQGpf2uWgaWRZHFisIlMgQNoibmjo4sLWv0QqXEpbnO9+Wk+APRxVyd38kYcl/Bvx8TeTaZ/2Mq9aA6YlbU6MGVLyreeriVsZKimlMAt3DWLxEpEGHXZ83X8ZwlO5dt2ZzscJKTAX9jWUUt5EMsiIeLNIvJwG0g2hRrybbbI/UjlrDSM7KFNtUVwvJlMkaE2x08OMxgfcMJdBDqXYfGiqNYP/MPM6ANvEq++Hh6IqMP1O+YNCzkvX2jRud9ZEYr2QYHxvXeTllfG0IAzOrXTbnhtcf0LUnMxY7yNNpCRQ4QxH9uWxVsvEJASPo8Y1iCfLF1l8Pd34wZDSC86XJuKf86X/Y21BTTnRr6aV1CPWlbSleya6QCD4iVO+sYCMxhV3SxXhvm9rF78xXBD/CTF0CAPcRMS4DKxGlNjgDVv0QtNEmxCHsX4xjGt79S3SXgJ2z/yh1U5P3C7kx2sKRZuwnV+QRqClJMhk0YUlVGieRvJk53/N6kftDdSYetSVaaqZ4aSIoWPWLnFp8nyZuXkzPAkprS39AInukQ71bKF97pboms0U6qNtoouEMs6KG7RXMc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aecbd3d6-b3d4-497d-aee6-08dda9c5c057
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 15:28:15.8287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yVxIfLOkgUvw49PgI0rB8W1Blm0KEEzZ5R7Mj11Ms3LWpsZ0IyELtbjkytXEWqT1K+zBS2LvRWHXRRlS+pfIy9Lctl3wIETLhdrUy97dxSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_09,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120118
X-Proofpoint-GUID: oMN9xay6mdNwT6zF5kOTf7RRgguMdR_z
X-Authority-Analysis: v=2.4 cv=BffY0qt2 c=1 sm=1 tr=0 ts=684af217 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=Ttzb6ue6nKAaAUQ-lNcA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13206
X-Proofpoint-ORIG-GUID: oMN9xay6mdNwT6zF5kOTf7RRgguMdR_z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDExOSBTYWx0ZWRfX+fO4iqOn1ZG6 bD/PfCNMAKn+ot4nlmj0eMvKgyunU9PcOtXz0ScIto8cUjhOXFZBZkJjmS3IZMTmBa75qIcRFJB bgB4qugkfnJzJJ0exqckKhvIRIeKs8F1nxM7c5JWMt61ibSZkEflEcq9SV6EYr0lPjle3sHTx6V
 dQ8aUb4xXzrm1rwC6zG+gT+G37oNqyn1QGTB2qGnGlvXGlCRaddQBB/2GdP0ViY8CC4WZyQ5+JS HFVFsCDCGi6B2TD2RJXTM20qUPloQ99kUP/+gdxPcH6goJRli+6K1fUmHxfF4w6LHsxdItLsaeO FY6L0+dAlCpm1H7GvIcrdc9Lc+uML96QfDjhco1+/jGvTJXVc3V/xryO+GsqkVuLSiYIxZ5XXgc
 LS9APR+mo5fehN8Sy+sXEA7R9rWKaleHj08lkFKxN1arc21w7efsIqNO6IbOPDu3Iy1p+Nm7

On Wed, Jun 11, 2025 at 02:06:52PM +0200, David Hildenbrand wrote:
> We setup the cache mode but ... don't forward the updated pgprot to
> insert_pfn_pud().
>
> Only a problem on x86-64 PAT when mapping PFNs using PUDs that
> require a special cachemode.
>
> Fix it by using the proper pgprot where the cachemode was setup.
>
> Identified by code inspection.
>
> Fixes: 7b806d229ef1 ("mm: remove vmf_insert_pfn_xxx_prot() for huge page-table entries")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Nice catch!

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/huge_memory.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d3e66136e41a3..49b98082c5401 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1516,10 +1516,9 @@ static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
>  }
>
>  static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
> -		pud_t *pud, pfn_t pfn, bool write)
> +		pud_t *pud, pfn_t pfn, pgprot_t prot, bool write)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
> -	pgprot_t prot = vma->vm_page_prot;
>  	pud_t entry;
>
>  	if (!pud_none(*pud)) {
> @@ -1581,7 +1580,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write)
>  	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
>
>  	ptl = pud_lock(vma->vm_mm, vmf->pud);
> -	insert_pfn_pud(vma, addr, vmf->pud, pfn, write);
> +	insert_pfn_pud(vma, addr, vmf->pud, pfn, pgprot, write);
>  	spin_unlock(ptl);
>
>  	return VM_FAULT_NOPAGE;
> @@ -1625,7 +1624,7 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
>  		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PUD_NR);
>  	}
>  	insert_pfn_pud(vma, addr, vmf->pud, pfn_to_pfn_t(folio_pfn(folio)),
> -		write);
> +		       vma->vm_page_prot, write);
>  	spin_unlock(ptl);
>
>  	return VM_FAULT_NOPAGE;
> --
> 2.49.0
>
