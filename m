Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACA826FDB6
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 16:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749744014; cv=fail; b=iLHBXriKnBapDn0A/73l6/+DutvoGzuhbWhTNW7ThkYxlskxXcZToyC31rzwc5v+o3LzZaM6DO+nS11xHijH8RKkGe404JsF5FGMm0hFI0oHODhMoJX8FwzLpAdGCK8yT3SwqAC+LuSrE1yOyUOVKFpmIhGE4uGL05LmO5UEEPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749744014; c=relaxed/simple;
	bh=C8IdJctjvgBhPwCKHC0xUy8a+N3JVNAdL7t9ao1ydSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gxLLKZlLv63laHOoIZadKznbABlfyWzCo1IFQhkyvJAqMU9mgsd1JVl0VZhDaVG/QvSZxlwPjWMcHr0HPuipig495eSi+/9nXra+Ek5CEDoHa43YN/IzDeTPhr9LCfCesA+TUykNU8IOVw+JV9voZ+mLVH8XIbeZfIEfELc1YhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=POLjBJBc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gobD7qd/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="POLjBJBc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gobD7qd/"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55CEtcjL017312;
	Thu, 12 Jun 2025 15:59:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=C8IdJctjvgBhPwCKHC
	0xUy8a+N3JVNAdL7t9ao1ydSA=; b=POLjBJBctfQbdjBxLwJoI9tuacy1pxyhKS
	RpNB0FOw3y4bCFX2G0f9SssuHlwPlMhCos3NsABRCWXGk0NoB+nUG1wFxJ083hns
	Q/IKafqsfc24ISHPkaiZUykanNQ/IWt78joe8Rx/YquEgxBPe7jV9PZcjTSCpxYU
	OjQvlLjOZaYP9DJzSAFma2eWQREoRTY3V5P7NqNbbil/E/Ui7BWjc0fOl8i1webJ
	NRjyj2k36QlTVJ/fJzFv/8hz5Acm9ALXigQmwgGOyq9JpzK6y3IT8tci+xDgsJte
	jIRW4WLaWKpmVW/q4WrrJRff3Vh+Ftew72NbxQOxMR8mXUqUmjQQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474dad9wdh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 15:59:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55CEpWdp037907;
	Thu, 12 Jun 2025 15:59:23 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2045.outbound.protection.outlook.com [40.107.100.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvj0y2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 15:59:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LSUXuOGrpjqhLRSjjlbyBQKttJdfAI6mBwtzyc4KZdQAV1tM58nw1gyLgT8kO4PwsVfrbGo0gUpT9PTyVOiDsNHeKIdsUbMRk9OHfIW9nuGjEQL041S3jIK3N+z+YoFJGq1YVrHsWPiIohGIRoJgoYZWzdK7CqIOdZ5ot7WzInhrNm5+uWqG65RsWfEdxK8ruu1lG+W3GYzGxYK+PaeT9tHO15pxF59+o7zoLZ+LKKBjPOjeGjK0kSthHuM1XbRs98FRveYJnynD0QPSzbotDuA29R7wMcsyUtb8OKnIuJt6b4K8uTPpaiyl9asmr5RawDp+n8sGiqnxD9ZmA2j4Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C8IdJctjvgBhPwCKHC0xUy8a+N3JVNAdL7t9ao1ydSA=;
 b=wPwp+GboKwqwtsDwRCkIfkd8lelgsGgfJTGFmG8TfqSTZL9njv4KDVIwCRZlNc93HQFHj7ZZl0So0lXZ+/AeGQm9x3tuAe3pJiVrq60BLopqrQNXC8mxqniiIcp+FthPuK2fh9aPFrU2cJ5xQBhBwFYV1l5C1AQOvaMqdpzNBffLlIpmUC+q70DU7LLeZIwBXz49Mb+FaAz7mg8Dil4GSGwBtX3kVq7UcIzBt9jJ7d27dT6GqNwxgFdgHmIXE38QySU0HgT83yVsrN7VyTBZM9w7tO0MvS+cdt3fuLYpZV5rNv16AyHLIxzKIZ6jw5Y/6VOCp3yhXXj+qsquArv2SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8IdJctjvgBhPwCKHC0xUy8a+N3JVNAdL7t9ao1ydSA=;
 b=gobD7qd/UC5P6pdqGbhhZPksjHy8MCaB55y7Wb/9f16aBCARWYa/iYqn023VJS5LVyugrljsB7V3ofF6lxxlq3xpMcpGdvyeeG+MQ9H1OIsuKZZuPU/r2EyOCxjM4xrQCySJOfMdTh0F+1LyFtWee1wgKbnpiFD98gI5v75W8v8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB6820.namprd10.prod.outlook.com (2603:10b6:208:437::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.29; Thu, 12 Jun
 2025 15:59:21 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 15:59:21 +0000
Date: Thu, 12 Jun 2025 16:59:19 +0100
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
Message-ID: <dfab0736-4a62-4e2f-889e-3d6fdb4564be@lucifer.local>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-2-david@redhat.com>
 <02d6a55b-52fd-4dae-ba7a-1cccf72386aa@lucifer.local>
 <c6c1924b-54ae-4d75-95f7-30d3e428e3e7@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6c1924b-54ae-4d75-95f7-30d3e428e3e7@redhat.com>
X-ClientProxiedBy: LO6P123CA0045.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB6820:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cff41d6-6c0a-4196-1d03-08dda9ca1842
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VOqJfqv7unwhUdOoOKWq+GBYGUxkIiR1lm3CcInlId0n6DjAt4VBJsGDMrC+?=
 =?us-ascii?Q?CeAjL3uKqgyPAMeywBmOBi4Qc7VuZMyFXi3Xbk12jVAJ8sOm3gN2Zli86RPQ?=
 =?us-ascii?Q?myjkrXDVt74L4jSONYvsrCHy+XW3NftnJx1Y7NcLZFk2zMj2l5CCwhEzuDum?=
 =?us-ascii?Q?YaQztKD4F2ErDeyQoc11lKoBGuL1radsaUkdVJ3fI9+tgI0ex9jtsFf5FyNU?=
 =?us-ascii?Q?l9u7NNzHrT1tVwm59HkXTta0try4rE3D9+ptTR7/g/G/+Mb7BTyBh0py2fu4?=
 =?us-ascii?Q?HwZqcueKMm7UzMAObVLxloQDtmSfcr38t0t18aMNH/ysZkqFqbNB+FM4MgE5?=
 =?us-ascii?Q?nlO7NUWDPJCB1uXCBYOEQ8s9ICikv1UR4Lb+CTiq3K84U1i8dYjPVwsG1oSu?=
 =?us-ascii?Q?rRt8uja3l4AfnNJka3C8THv9iap6+QO4BuNBgyxevPiGovYrR8+rdPT2pzF5?=
 =?us-ascii?Q?QwhG/aANSn+aBIry5OxO+cTqkOxaEQxLs2w10xxfwV+NgkXVPKxMREnOFM+W?=
 =?us-ascii?Q?in1npKFsqzSt9XH8Eju/4moZWe88mxPAx3KfkaPF5VXacANG7Y/nyRJF5aLy?=
 =?us-ascii?Q?N4kn9lPXEIr84htWdYibt8jI07pmMW4aI2VjbYXyK1yox09zvCxZthzl0bPV?=
 =?us-ascii?Q?JXV9gdf3K9Py8/IA+0IuKvIy8+iqDemTWuVIzO712ijoDU1QKU7OKogL3/b2?=
 =?us-ascii?Q?wEHMjD/wwDw4FKVnC+8H1UqZUKbo6NYA2wA4ZfMucy6LSnfvtu3sOP4Ao5Hw?=
 =?us-ascii?Q?4mFRThSxD1O65QIkmlqd0zmor2MwT/7VieF3s2vYoYF7pYJ781HwgLHeNSaj?=
 =?us-ascii?Q?9Y+Ei0bSwFHa1VLjpoWsSjASyHWiSv2lefT0oS0/UJZwRciL4wh2l5dxehhR?=
 =?us-ascii?Q?bfxz0tIz7BPDFj2VmxIwtICHx7sQIW4Ek0XSIzCmD9NbDzIx/rgUONYa9Ozp?=
 =?us-ascii?Q?QUa0NkSbc6YSMclxp6+5B9+FCM+45m/Odo25RcHA5HMGd80c5BZcsFds9Zys?=
 =?us-ascii?Q?Zmqx0kfScYHFNRrAWjGO1NqTA5jJs5txd6DpyLik/DNUkopqQRBmiWkVEqk+?=
 =?us-ascii?Q?+xY9CgjMnvFw5W5dKR9AerrEz+LLmr0FA/rE/Y+TK2RgN/FbtbQanRC9+KAi?=
 =?us-ascii?Q?am+YszSz/4kGDfW3Phg8AEIQIUy75TfbM7sw+twoQcMbj9zn+jJ0Xcom5Twd?=
 =?us-ascii?Q?FX6voYUqPereEz84q2yEB4ddzrFOvd56gM0SMQ+Faa6XWo50aSdgLPVkHoSu?=
 =?us-ascii?Q?gcw90X+r4izd2KvkCS9eYT6JsemJl8eoX+f1TDf9XHRVxrjjtURr1/bWmHFt?=
 =?us-ascii?Q?F0DhHIr5+3yGONSJD9KFTZmYAmZsFa5fh3aDLEda497QEOT6vtB9f86ITs3g?=
 =?us-ascii?Q?4u9GN6iLBpSs3GC0SkI0sKFbEzB3RBxsHEpRwRWb5q06TB8UuFbsINxp8zgR?=
 =?us-ascii?Q?DO89LMyZcBY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5PU98pkjxm/3+MMt2wfhFbcPfIDxtVTKngGg5DO8zyeVlJamPq0fl91Cm/W5?=
 =?us-ascii?Q?CNkoJOHZb5wOojyJdWjza+aYvd102FbKfHcW0IKsdw5cqIKxO3EUI0wsNNKX?=
 =?us-ascii?Q?UVhtuvKgMB57vSJ+OKdovIDL+b6GvAEd20qZ9w83+vFqDrB8jqqT1K+jsTBa?=
 =?us-ascii?Q?Lg1qg92iVMn2SlobxNLP+eqtOMc/17t2ZlITEqDwUqwc2y3Ltf8i7AQ+k/M7?=
 =?us-ascii?Q?DEfFp6PbMWc2dmemZo97jR3wwiKxzuBC5IOGhQcZ4ME6bVL4ksEJsM5nkr5p?=
 =?us-ascii?Q?HAH5h+cf3ezaRqYmuYw2ChKXiXSM0i1gsDG8sxUKYdySrRIjtvz9u11baELP?=
 =?us-ascii?Q?zhBkXK3wLcs6qsLj02Mklmls4H0CJn9yxBkpVWryUhIePQpNBHkm8t/HFNTI?=
 =?us-ascii?Q?2jpWNFOFGxXcdA+rr9ipoV+lqDcP5/FCe4v7Y82fKX7N6z7XLkW6uE4Jqle0?=
 =?us-ascii?Q?jlt0m4u1UCg3Fos7PimFOQDqrzr6yqt9f0ybp8Igj1QpxN5vTFqzubU/ngfU?=
 =?us-ascii?Q?MhU7b8mwiavmEImBxAV7cuwvt4BDNY0pzPQfm0miIlhIjguh+2FZ6Tikurbu?=
 =?us-ascii?Q?lo9C+soeBIH1d+pJ4LAEjlwE2kqVqV5iEKBoTt+7nXX+jDNpbEuqkjkd07zP?=
 =?us-ascii?Q?h7rzYCW8rSqDtx3UUoimFGhwvt63fHDt84K7bHiqTDjn4fyAi9nkyih8u6sr?=
 =?us-ascii?Q?K66UOfxF0ZbBAwSn6/PkQQBQAwrImIC5QmuZiwAC8JzNi6wj1mWsihbGY2OZ?=
 =?us-ascii?Q?Uq6l9FCKttNqcX/erGQM57ekh7r41gLrwzKa6C88zAAqMTiEZNlhlmb8SEvy?=
 =?us-ascii?Q?FIgCKDh001UZNWPkqjGd8uIiRu7QWgK5p0tzwhsevFdOYndbG2or/S/FG3j6?=
 =?us-ascii?Q?+cT2HkR5Dq8VJKvvx15gLaLrdVbuqcsQIwTV4JtDIV+mRjaofurV+FnmVZJe?=
 =?us-ascii?Q?mG2G2Z8ycfvHDzt503snwdVvDg01+Xk3Oyx15ufO73gvFhMgMdQf96npHQgo?=
 =?us-ascii?Q?OuBh9AlLGRqUImlRsRUm+hKOgeqRZFpqTA9ioG8bGdfNJq75ZeVmglQHa3H0?=
 =?us-ascii?Q?P9p/lOZ0Hlc9DjdwB8mp7tib+FiMzKNv5xGRQ92vY53QyFRBjWrRmaSdsclm?=
 =?us-ascii?Q?3Kyyd4xgepKfW4Oh4OpoSGk/dd+M0XBO41VfrU6FcjaBu66ne6ayhfbvW18z?=
 =?us-ascii?Q?5Ti7n31Jd1T9eVPAtefDOxUYdMCQiHt8wkzfjav+9pUVfNE0iacQSjdaF7k7?=
 =?us-ascii?Q?2D03x7UhRB1E3vOXJDtpZ6p+HQ/6vpOtilGA3eGedPDjDr0/Zezr6/h1zKJk?=
 =?us-ascii?Q?n6vYv5mHi7LWwfdqVMjvgt29dBWqRfyIPnyF2ky47Re285UVnhLTuFGU7V5i?=
 =?us-ascii?Q?j/OYJh57xZTuWA6wK4Z+nU1p5MoItL8D62gMk/u/yZ4vZkSHyDwhbYG3HGyI?=
 =?us-ascii?Q?cDQjFCKiJ2hB2BaSZDBZL4g2mxcR8VIOEQ+QO9gSLKeNBSu/WmBz/HjD4x03?=
 =?us-ascii?Q?+tbXpkJETSa0wE71iJ7gSuANrz+Mnnm7ipJo3Sp8tMZoqvuscnO9Z33AMqIN?=
 =?us-ascii?Q?7hliUGykA37gUG8tQKXzFJn9EKgHt0d0gEtes/i962SykZoz+Co2LAsFRI2J?=
 =?us-ascii?Q?Xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E35agCA2qkorDaBCLcl3S5Y1tlbSgvLrOl0T8RGqeekB/1sCtAh+4Ol+ABrJXbYBqbRoXo39CbTQ+Pzq11bIc/WS7B+25XG2kJbQmG/+Wy6TDUGczJo17Yi7xJOw8GoBgXv/F3pEQSUEo3kvYot3a0XrTTi3nT7lAP4flymu49fP3dwnVXeWEJg5vY/HhAqQPKZo/Ca1JZWHYMmqcn80Db1AWZGmS+R2UX5KFJPmewCcCwLxoOonhZGvNVWWoj0X/SWN901J53x39curxCxskjK4f9zVSRZ5zxH2ZGsNZkvjx3kL775DgD106k8ojhv/Wt/Z/p5JTfhhYN/jQIQJXraxro8KqBmll8IJHuCxKQZeGATTbN0f3ZL8/jAIhP4pdLDsIn3ZONVq5TtYIlY5OtnrEr1l5KiZiXLESD7thz6k9V9jSFTTee4saVVrubge+8FYSZHcM1IjNSvreyc4WTQ65OwVsEMP+DNeJ8IWeY5+taF5CUt1Xvfxq+9cDfSJjCmjFG+k8JN3QMXIhAv9+2FMMUjP7Qhjrzm97aB6Whi6rxLMqy1usD6bBn1a5y62SdFxGIkEHvaT78ozpRFh3CxMmWNgikElmEWzv2NsKxk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cff41d6-6c0a-4196-1d03-08dda9ca1842
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 15:59:21.2794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C/p+mtrvQcopQMbekKfsMWi9kBGzlHcJ7WJfpOqY1aM65NNG32fDUX5TidAK/4IzN1q/AE5e7fVjxQga4blaqiOLZxvA+tqE1NN5bHU84wg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6820
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_09,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120123
X-Proofpoint-ORIG-GUID: a9urWQtDeksMMKtyl2Tnw_DVJagb2rCz
X-Authority-Analysis: v=2.4 cv=EJwG00ZC c=1 sm=1 tr=0 ts=684af95c b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=NznJ-deW5rm_l9ViEFMA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13207
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDEyMyBTYWx0ZWRfX0ESLYM5Bhohr 4TnSpS8SIp95qteqrgMP1SI75m3bIqM69FrtZYpkpKKlWBC/oBppbOHpq67ZQyzAg5f82FEoxi3 MVytG4CpALsZ9ouWp3MXD1L1isjNSy3g1BUYshNJs6c2prYU0z9PWvSlYOfwjVmkEtt2qPjZzgS
 nJheaphidwN3GkiGeXjU/ttryV8ka6zDc8u7AxyQj8D7pcUagnN2V5Mc8ij/XHOWohLq+dENvtx joP4+fUwe51rX4AeVypuH9Yeby49DKGU19Ckaz8CX7SRQW7PC5goGqLMb4Uqj9JC6eTaWE0+Pwb dkMyFS/YqfDcBgBBUzR5YdZcQL+BeJndv+DGSJJVTHo6+lykK99QiKPHlOf9V4/a9/x5wGavg6T
 e6jqhuUegJuKrnw2W2/Ob3oqbPBTiVL2zduBBtI9bNL+qBSOwXxZ3w5yjoDPvLpk8WjRDL6W
X-Proofpoint-GUID: a9urWQtDeksMMKtyl2Tnw_DVJagb2rCz

On Thu, Jun 12, 2025 at 05:36:35PM +0200, David Hildenbrand wrote:
> On 12.06.25 17:28, Lorenzo Stoakes wrote:
> > On Wed, Jun 11, 2025 at 02:06:52PM +0200, David Hildenbrand wrote:
> > > We setup the cache mode but ... don't forward the updated pgprot to
> > > insert_pfn_pud().
> > >
> > > Only a problem on x86-64 PAT when mapping PFNs using PUDs that
> > > require a special cachemode.
> > >
> > > Fix it by using the proper pgprot where the cachemode was setup.
> > >
> > > Identified by code inspection.
> > >
> > > Fixes: 7b806d229ef1 ("mm: remove vmf_insert_pfn_xxx_prot() for huge page-table entries")

Ha! I don't even remember doing that patch... hm did I introduce this -ignoring
cache- thing? Sorry! :P

> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> >
> > Nice catch!
> >
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Thanks! What's your opinion on stable? Really hard to judge the impact ...

I think it makes sense? This is currently incorrect so let's do the right thing
and backport.

I think as per Dan it's probably difficult to picture this causing a problem,
but on principle I think this is correct, and I don't see any harm in
backporting?

>
> --
> Cheers,
>
> David / dhildenb
>
