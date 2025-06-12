Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815F77263C
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 16:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749746999; cv=fail; b=ex0li3mIpI71G5prWyVCku5FTAPAM7MdbURqBKdDIo2WQDlLl7brCUcxy/Inyslp/izH6xZZEN+pFBai41VYm4sMaunK/hSlqzsNV4JI82gziZLvopfGamdmnHyfWfvO1ZQ5Ip+oWXXhL5BuNRA9jbDviUEwdDCv8JQeMdqloK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749746999; c=relaxed/simple;
	bh=3dwqexXbxSqVGKREaxUzFz1V3D1NQfIZSmX2sfuEHig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pOlOa7h5l1uE4kP3IiyTwbqVLdkMBtnI73UU/9nv9k7GL9RSdom/Zd6oeAXUIrD8SGbOXs9FyLembcvUwUxpHcw2YNoQueMGwsEGS83X00+c6VDtdIVKWShCwwCBErIn6om44//ohjpy4bc75meX/FDrwrJlKUQeqfQhnHpuRJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cjnSRP/3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WVdqYdRF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cjnSRP/3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WVdqYdRF"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55CEtctG003372;
	Thu, 12 Jun 2025 16:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=k6X0rn5sW0qTtQg3p6
	+v3ywqh7kqkXEGJYlvr1Zcvfg=; b=cjnSRP/3hmJLBACzQxlJB6G5oexgYDzNyw
	vb2SAejc5D7+e48Z12X4TUiygcAIOnjLGnby9a0fA/sIbsJUzuziehsGb+CLGQlx
	pe95vKWnCrNTGIuwiSie8I8TCKgHiuG4KdD3nFKNIUbqlUvoZ7gk7+xWTB8pUNm0
	xch/a8SxumlrBhi29mPvfQv5wDaOLwKqxi4VP9PnBLnbxEBj6g3GIY8FlKuD5NHD
	fXYfqUyIKxivjnkTPXAWvTWmEy+4mCtjtW0YJEMyB06CHAHHIOUdZqExzbO1W7n0
	ZYYiVm2JyqniwPE0l30K4eFgULRKXJUt4P287X1DotnyFJ+cmXew==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474c14j4ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 16:49:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55CFoISx013280;
	Thu, 12 Jun 2025 16:49:40 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2051.outbound.protection.outlook.com [40.107.102.51])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bvbkm9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 16:49:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CtcqUK+vwz5NaOy4XolfMa3SlhvhNmefIecKKn2slRp+ZMTtQxyMflX86241bM4NWdNj2LpsR9BzY9vTwdaL4pwkhfcwcuCyt7CtCmpEYz04Rdgr/hujRY/Gvq+78Hw9jV0EcchkMzDXjFKLEzsulUJwqub8TTsUOj7qj4XFoh3rw/zu8ZsmTRoqhx8+hGaA9qXyyksarq0mDb4U2Us0wf1h4OTQgfdluWUYYtN8ewTFMyNOTU8IQe8ICGGjV7hODr6IfMx+ciKiODf+uU/tETTQ5oyvwhv4YAakZOTCxKpWAyh6kw47IuSZGaEwZrhbCI+Ykvrm9lZO+vNvBAn7oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6X0rn5sW0qTtQg3p6+v3ywqh7kqkXEGJYlvr1Zcvfg=;
 b=aHnytTWJdpf4H4lRQZoA5h32I6PZwomK1MnQIpUdmldTW6UyiYQxslrksu16KF4kxkMi/CiUVekDuEm5pEXsHAtf56flmCJ6hF+JFp8uIU0C69z3UrpkddHzf5Ipqf4lVi/SgKUcO3JsuWdF1qlmv3jGZGUH0Av/1NbqlLwV3B5QRAtjnPqm84oiubSnIAVI1euNemS3CpW7MuMe5QTnI0oV/9JqIN9T8QXrG9/xONwibcz7RmGIJIHouzsUJON1e6L3MBagkuYr46MrLeL+OAa4uNOjO7xInmyWSDcBLYDeckZhuLv0X4Mo+eoS40b6Raf3ZlgNxwlH6hUifRpGAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6X0rn5sW0qTtQg3p6+v3ywqh7kqkXEGJYlvr1Zcvfg=;
 b=WVdqYdRFR7hFxORpCiMJCeOJKXxXSP5mDg/E3X/uzQnLHOnHxSOgaz5JummRbxvYKMDtO89se2ocWSvXT9/8jZqAlYMX/vbxwTP4ZrPuqJfuXFwXNKUIgXMvJTbVNmuqS9kC22KtYpImEAizL71sCLqpE37wULRnbQNUqVaGTs8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB6470.namprd10.prod.outlook.com (2603:10b6:806:29f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.22; Thu, 12 Jun
 2025 16:49:37 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 16:49:37 +0000
Date: Thu, 12 Jun 2025 17:49:35 +0100
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
        Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v2 3/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pud()
Message-ID: <177cb5d1-4fde-4fa0-adbc-8e295fba403b@lucifer.local>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-4-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611120654.545963-4-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0376.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: 3388a434-e25d-4bf3-ccad-08dda9d11dea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dse9eX+cIa5e1ccYw3N9vlC6zLu+uAQcraZkvqG6tD6OMiZzyqSF7adiACcH?=
 =?us-ascii?Q?MZzBd9poATH6o5ALZXFYwaF4Dl9SI6x+phtDGgZWcgNSOsFV2v96YF6cPJm+?=
 =?us-ascii?Q?IzJ/H2WcxmnmOWGWyrsEVxjNTDdkVvBAQ5RJRKGZ4TwUD8fyLSGk+wrJL5wR?=
 =?us-ascii?Q?edJM1cP+Tjrq7qfmqDvG4a50pg68aBZKMC1XAz3rhS5ii+lXlcZYlO778bpi?=
 =?us-ascii?Q?ncgvfNGcIOM1DWBvSi6MGLpBAMipIaJyjjrunQds0TxTmflVZ9bDowlEb948?=
 =?us-ascii?Q?nLQyuoN1EOrrdkr+9FOotyHqOannZhh1NFDDtD7gKk6Whyr/i87Un3a1ibtD?=
 =?us-ascii?Q?q74PQfVkXi43IK9C1kAMR9idVxPr6AppD7d9OwNwkaWfWAIPSPdOLDcVUlHJ?=
 =?us-ascii?Q?L/xXc/Onletrecs38lp83u258i0Ro2pt59N1I1uVMjTnaQUNKkAYUIOOeJ0R?=
 =?us-ascii?Q?UCZvr0da5apDQV3XtvW0j+zL++3I2jgRoKdv65e8qITyfUvqWkeSlCqORzx5?=
 =?us-ascii?Q?MKyzE7crJ0qthTJHjHTz12O4TUaH3AukIVM1aYnIhbmdCbIjm+fgZpsJsMfD?=
 =?us-ascii?Q?xrK+DzhPN/Sobd2cOKT66cmpIy6IZyPBAr2/dXvHbbm1tiMDyZ1wOSES6evo?=
 =?us-ascii?Q?/DDEcf1W2lCTnodnScCwczx1sieN1GWOvxYdxPAXv1a0uiwxBblsm/S3sVxX?=
 =?us-ascii?Q?qKTK+rEpdOtEoUHjZsjpqRVE0WvF189PX3sodb3BN3M8i8M4S1iHh1ySIr1C?=
 =?us-ascii?Q?nNY6AnRuFr5OQg68GgYa0yxbcm1m/Zvdk4Iv3aYPod33ZXw0bTpmDcUV/NY+?=
 =?us-ascii?Q?+HeFKOD9stqOPXx64URYJmdnpbw8bo5UAfOeweGvIJPdC/1dAxJyN4qvdW1y?=
 =?us-ascii?Q?TQM+lCG8mg4G9qDD8SIJgWvKRaoBQiZE2hE+KoaEipELs/IGSRib1XcxtlD1?=
 =?us-ascii?Q?7Smbm3gG1kJoVlclH2OqID4VMb9y61B2tzYK/NdR/hjxxMyD2rZFjSPbv0tF?=
 =?us-ascii?Q?yxI+WgAwHvXGAsrE1AJ3Mws0IMaEVlWaTLFK/BCX3yy7A39cBiXi1pKSQed9?=
 =?us-ascii?Q?dYnwzg6XNxxTeSyXHjTewYUAHuSLHd9CUVxA7oKJO7w0Lln3lZbeuQuhX4Sc?=
 =?us-ascii?Q?iiBla9xkf6LNYAdS7879VmxHWL7FIFSjFZ+F0SYbI1rHXcEOWE/WgFw+e2NY?=
 =?us-ascii?Q?1wcM/SfBrsjFqD/R2YMFGxCBfl3y3+tdTsOPqOyIvizGsAKkl8ygGn6LkNFe?=
 =?us-ascii?Q?ZvgvkLbUwuzctbCHF8VT2LQMEBiwRhTm9YeScpcQhn+xZevIWvuZoGoFWi36?=
 =?us-ascii?Q?dL3vKef/GbLGRskoz5v6DjotX7R/ErPfz1H9DVM2A0+MY/XlY58wTSXCvbxD?=
 =?us-ascii?Q?YU5hFltlI0uSLvHGzjA0tbmglYQJ7TbH1EuHbbM5SBAAYeNNuAXRyF4mCAXM?=
 =?us-ascii?Q?rBBxTiPWLXA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3kspILlhz9ktllCxTIVmFi138qM5hNlfl9pOEU9370JNWvFg5jJYZLrE1D8M?=
 =?us-ascii?Q?9ReV2g8U0cm3lAeS3nvmuQpqVmsJ2/canns2ZYOQhQBp4r3oh4c1umJo52fJ?=
 =?us-ascii?Q?G46F2PbF99QLKnchm6B5p2S3TuL2YgnPE1L/YKVkF23r6Do3udyMSinN4eZl?=
 =?us-ascii?Q?dPOTX4O3Ycf6L2OzLBg/9aw8CkeezKrpfGgeQIX63EwKLiG1EQHy6mUp26IO?=
 =?us-ascii?Q?M6xSSWyAGdt7NkTN8fmdhq4MN+l0mF/NT8V/hJV+sCpgp/d+pogESLHg5qYC?=
 =?us-ascii?Q?lOBZpxm1V9BhX0paGOls6zRICDuvI6jz7NXJ5un/SgKAugZ6uKEn5daoP8W8?=
 =?us-ascii?Q?pakhqYYLkFWYGlvO9nX79uYJjigTyVH3hi/eFNFnBhzNMkyethpnC6PB+j50?=
 =?us-ascii?Q?oNvKgMkYpgNtxNMhzK/ULpEv8t1B2jMghIKHNC7w1WQk6lWmFNLaW8YPSHgJ?=
 =?us-ascii?Q?c8y6m6V9dvOrcLSyb81mC1xMkvqolSSF9aFbkDCAM/t9arIEv/5usLTRZ9gW?=
 =?us-ascii?Q?ROvR3GhIQym5/jOMYUarFpjRdBvJojFsgMN+d3hGS/FT2TQTxNFfOXP7lH8W?=
 =?us-ascii?Q?dJn4r5AViIqyIFfFmOaubvCXdK1evePKozeqf+e/DFeDq40/kvhkxDBDFOEl?=
 =?us-ascii?Q?mJXD/dRNldua2rNzO+uZno3ZWQofQX15fQIDSk59s7JaYPQKg7jA6NNe8AyZ?=
 =?us-ascii?Q?cWHi9N78WCOJlw42l5klSLv0GN3+p0rDCGj2jOxGBek5jXTf8UIQOrzC1KlR?=
 =?us-ascii?Q?q9F/PTAU/ixRyGaOVpqYTl4r0y6wnHdDW4+6YsFqxFVQEVWRASVc6LE0Aikf?=
 =?us-ascii?Q?An/YaLStGNVOLfjPGXzw42W+zUfH/Qd9RyEKKwGBTxbXVXGaqotu5ekAopYg?=
 =?us-ascii?Q?4TqHXWLwC7vQU9AjimNDQ0WIS5fjtGHsLMgXZEutJ4eK/ief2DlRHlg+uCH/?=
 =?us-ascii?Q?JlLW8T1rjkL1V28wFstfWLWUrZPVOJ2Ku5tgdP+q2nS/eE/LMl6UtJCB1VEa?=
 =?us-ascii?Q?DsonndPAfqW4zjLtm45zNc9rp1MafSncfrqMsgecDQKS2gpetiGd+fd5ynDI?=
 =?us-ascii?Q?5ezHluh3W5kBnkw1g7ogeMoP42So/UuLftZPxVYPJDrAxXa3sxEn5sSVK3Pf?=
 =?us-ascii?Q?avDs3GO9TpaFxUkRH33J2kE2rgf0+YJkZkHuZztiHKb4vJbt8BmA6eYhJJpt?=
 =?us-ascii?Q?2wQybHgUptdSZIrow6p8UFPYZGsG1cqKg3G5FIk5BJxZs7Tjpqtfsbd5Klfe?=
 =?us-ascii?Q?k/SH1avEvKvuh49zzAQdoMpqZz9VmSbEBNbHcr7QK/4lXilsuiUMf83rR45V?=
 =?us-ascii?Q?Bdx7WBViaYiCtkt88+vlEaH3ND3w99EQ4Dg+zz5Rs3KWtyluHcP8wlaqH0Fo?=
 =?us-ascii?Q?kmozipI+nSzAQFiufw6cMtsyJ4ri7HwKaMO3zlHM8LhOWZaAEDsnm4+DreD3?=
 =?us-ascii?Q?mYYNaq1myIs1apnM1CdosHhz1iyAgspRE416zuO7p1K6q9HyOtN/yfkwuzbw?=
 =?us-ascii?Q?5eLYTAEwI+RyFkAAl85d3RKabDR2yJ29QIvtAFioJxdXSTYhWz7Dla7hGiuc?=
 =?us-ascii?Q?wBBB/ft2YlL3ESscbJGeSAbCkrzF7ujZYQ0FYVITzHCteGRmL0CUyVjzV9Az?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pgop9IZWncKc2iEynDwyazmrVpuRgzXeQfgelM/OWxVV+FPWsiesKT/9RoeLWJtcbyy89TPxMuhANhIcSKa7aAJLHNpvbRKPBgEGAs5JlHlsCB1s+eTGOC9TyxZZRzNBIR2NGApXqcJfie7AmLVWLJcdnhZ5/InhitDY2Txus3vYO5w/evZLiMbvbQoKc3baRQGOjGz7pH+4k/6Z5SSywffEeA5c7PFzxUp7835KkIY0A89PnhWLtch+pDnr78Wg+QWCIaiRzOOjHZMyaDiGlD8rCw7bYX6GSxR6wnK6ufgrJaOSa19VIFpgVDgmjBPkyxE6tQwMOjTVRK4OjT+dHOsUifHjwVPuY5UhQjrFlh8mrSpZWhoT22ITqUSyAqDkEHikelh8HDbc1x9DOdecUF8+Cabig68BtK8rJ8Au0h8zOij5yot0XMK0SXW5e43zZ08SYy9eum8gBtwCoEq6Yq7RBT+qnBPveq4JYnRUW2SdwiKM3zeKxTDPZdWYuQ4RNcrX7RvV/lRjixsksOpuUFGdJykFoTb7+0xqcj1wwWpvV3puF23QCm0ITJGSVqEtNQ727HQaZKJrMDjvY43vPG89h8+cGn2M1GElM7f0010=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3388a434-e25d-4bf3-ccad-08dda9d11dea
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 16:49:37.3810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3uZO4yl383aTmIutMlofQvUl33n/VrPeB3k+Zu4nPMOuuYWLD6SPEMN0zlcKV8fb071UqYosRN5Ajm8s7XVcwD5kSg0mialuoDARHsPXKQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6470
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_09,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506120128
X-Proofpoint-GUID: Mj54srUjmQ8MewjPVfPzSDRm8zNmIMp5
X-Authority-Analysis: v=2.4 cv=GcEXnRXL c=1 sm=1 tr=0 ts=684b0525 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=gHvMkU8LpKWSYgsdfg8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDEyOCBTYWx0ZWRfX6eQ4Isgde3PD KonbSuOlNA0Y+0cEffNm0rITjoKrunuPq7hkp14sD2/nL9OssROC7VWI1US6a6c1VpWT8TewfYh 2zCtf6dkMpTuEL84GIssUQzhoDTk+0n6e+eimxwuRcAT6PzFFVk6v1gsb7dNBO4RCPtzqkW43Xl
 3+HBmCpnRn9HmeMCKkUFDU4EsUJzq+iYJHF+j3mQrr45qBEpcl2R4f+/Wj0ssSDafYxXfp90eLw C4BhdWpslTyotLNI3ycxdqoSLPbUTUjuaLaE7X+pUgihwEgiXtgYsMwKG98mM/YW5OHptMPMTPt DJukHSFWZ+4lFkNM85YpOnLv5p/+xutdxTTK3YV8H8tl28x4fz/uaXzUIfmHxpMr+rLuDULVJDq
 7U7BH3kOrVbROWsFlBw06KdPXg5ixKpXuUdOisof4D3cDsgz9V7wReQj0N5JHKvdatO8HmWc
X-Proofpoint-ORIG-GUID: Mj54srUjmQ8MewjPVfPzSDRm8zNmIMp5

On Wed, Jun 11, 2025 at 02:06:54PM +0200, David Hildenbrand wrote:
> Marking PUDs that map a "normal" refcounted folios as special is
> against our rules documented for vm_normal_page().

Might be worth referring to specifically which rule. I'm guessing it's the
general one of special == don't touch (from vm_normal_page() comment):

/*
 * vm_normal_page -- This function gets the "struct page" associated with a pte.
 *
 * "Special" mappings do not wish to be associated with a "struct page" (either
 * it doesn't exist, or it exists but they don't want to touch it). In this
 * case, NULL is returned here. "Normal" mappings do have a struct page.
 *
 * ...
 *
 */

But don't we already violate this E.g.:

		if (vma->vm_ops && vma->vm_ops->find_special_page)
			return vma->vm_ops->find_special_page(vma, addr);

I mean this in itself perhaps means we should update this comment to say 'except
when file-backed and there is a find_special_page() hook'.

>
> Fortunately, there are not that many pud_special() check that can be
> mislead and are right now rather harmless: e.g., none so far
> bases decisions whether to grab a folio reference on that decision.
>
> Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
> implications as it seems.
>
> Getting this right will get more important as we introduce
> folio_normal_page_pud() and start using it in more place where we
> currently special-case based on other VMA flags.
>
> Fix it just like we fixed vmf_insert_folio_pmd().
>
> Add folio_mk_pud() to mimic what we do with folio_mk_pmd().
>
> Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Couple nits/comments below.

> ---
>  include/linux/mm.h | 19 ++++++++++++++++-
>  mm/huge_memory.c   | 51 +++++++++++++++++++++++++---------------------
>  2 files changed, 46 insertions(+), 24 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index fa538feaa8d95..912b6d40a12d6 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1816,7 +1816,24 @@ static inline pmd_t folio_mk_pmd(struct folio *folio, pgprot_t pgprot)
>  {
>  	return pmd_mkhuge(pfn_pmd(folio_pfn(folio), pgprot));
>  }
> -#endif
> +
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +/**
> + * folio_mk_pud - Create a PUD for this folio
> + * @folio: The folio to create a PUD for
> + * @pgprot: The page protection bits to use
> + *
> + * Create a page table entry for the first page of this folio.
> + * This is suitable for passing to set_pud_at().
> + *
> + * Return: A page table entry suitable for mapping this folio.
> + */
> +static inline pud_t folio_mk_pud(struct folio *folio, pgprot_t pgprot)

Nice to have some consistency around pud, it seems so often we do a pmd version
of relevant functions then with pud we go 'meh whatever' :)

> +{
> +	return pud_mkhuge(pfn_pud(folio_pfn(folio), pgprot));
> +}
> +#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
> +#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  #endif /* CONFIG_MMU */
>
>  static inline bool folio_has_pincount(const struct folio *folio)
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 7e3e9028873e5..4734de1dc0ae4 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1535,15 +1535,18 @@ static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
>  	return pud;
>  }
>
> -static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
> -		pud_t *pud, pfn_t pfn, pgprot_t prot, bool write)
> +static void insert_pud(struct vm_area_struct *vma, unsigned long addr,
> +		pud_t *pud, struct folio_or_pfn fop, pgprot_t prot, bool write)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	pud_t entry;
>
>  	if (!pud_none(*pud)) {
> +		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
> +					  pfn_t_to_pfn(fop.pfn);
> +
>  		if (write) {
> -			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn_t_to_pfn(pfn)))
> +			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
>  				return;
>  			entry = pud_mkyoung(*pud);
>  			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
> @@ -1553,11 +1556,19 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
>  		return;
>  	}
>
> -	entry = pud_mkhuge(pfn_t_pud(pfn, prot));
> -	if (pfn_t_devmap(pfn))
> -		entry = pud_mkdevmap(entry);
> -	else
> -		entry = pud_mkspecial(entry);
> +	if (fop.is_folio) {
> +		entry = folio_mk_pud(fop.folio, vma->vm_page_prot);
> +
> +		folio_get(fop.folio);
> +		folio_add_file_rmap_pud(fop.folio, &fop.folio->page, vma);
> +		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);

Nit, but might be nice to abstract for PMD/PUD.

> +	} else {
> +		entry = pud_mkhuge(pfn_t_pud(fop.pfn, prot));

Same incredibly pedantic whitespace comment from previous patch :)

> +		if (pfn_t_devmap(fop.pfn))
> +			entry = pud_mkdevmap(entry);
> +		else
> +			entry = pud_mkspecial(entry);
> +	}
>  	if (write) {
>  		entry = pud_mkyoung(pud_mkdirty(entry));
>  		entry = maybe_pud_mkwrite(entry, vma);
> @@ -1581,6 +1592,9 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write)
>  	unsigned long addr = vmf->address & PUD_MASK;
>  	struct vm_area_struct *vma = vmf->vma;
>  	pgprot_t pgprot = vma->vm_page_prot;
> +	struct folio_or_pfn fop = {
> +		.pfn = pfn,
> +	};
>  	spinlock_t *ptl;
>
>  	/*
> @@ -1600,7 +1614,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write)
>  	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
>
>  	ptl = pud_lock(vma->vm_mm, vmf->pud);
> -	insert_pfn_pud(vma, addr, vmf->pud, pfn, pgprot, write);
> +	insert_pud(vma, addr, vmf->pud, fop, pgprot, write);
>  	spin_unlock(ptl);
>
>  	return VM_FAULT_NOPAGE;
> @@ -1622,6 +1636,10 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
>  	unsigned long addr = vmf->address & PUD_MASK;
>  	pud_t *pud = vmf->pud;
>  	struct mm_struct *mm = vma->vm_mm;
> +	struct folio_or_pfn fop = {
> +		.folio = folio,
> +		.is_folio = true,
> +	};
>  	spinlock_t *ptl;
>
>  	if (addr < vma->vm_start || addr >= vma->vm_end)
> @@ -1631,20 +1649,7 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
>  		return VM_FAULT_SIGBUS;
>
>  	ptl = pud_lock(mm, pud);
> -
> -	/*
> -	 * If there is already an entry present we assume the folio is
> -	 * already mapped, hence no need to take another reference. We
> -	 * still call insert_pfn_pud() though in case the mapping needs
> -	 * upgrading to writeable.
> -	 */
> -	if (pud_none(*vmf->pud)) {
> -		folio_get(folio);
> -		folio_add_file_rmap_pud(folio, &folio->page, vma);
> -		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PUD_NR);
> -	}
> -	insert_pfn_pud(vma, addr, vmf->pud, pfn_to_pfn_t(folio_pfn(folio)),
> -		       vma->vm_page_prot, write);
> +	insert_pud(vma, addr, vmf->pud, fop, vma->vm_page_prot, write);
>  	spin_unlock(ptl);
>
>  	return VM_FAULT_NOPAGE;
> --
> 2.49.0
>
