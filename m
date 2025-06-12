Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6904B78F5D
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 16:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749744674; cv=fail; b=Xyxc4Wt9MLgLO2sPaFG8abpk52BDciyuZ3W0ZBftvA7C5ZufM/ToDp25ngzO+YvSPXFKvdF92HNjEFlptlpwCXUiL+kFBVwkjOgmrDFw7uRKnQdYYLR2nZbVnnQowixLkSlJLn+mWBSG94ugrgOANzrMvIlnN12l6vrPuR2WX/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749744674; c=relaxed/simple;
	bh=La0GZzcQSXGSXj6eW2ZPH9tY8ixDu+4cnSjYReCRc34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tDJIcSkv9WNd82pbsoM6PsrnuUNaPcwFaz/E98jvHUJLog1Hhj9qxq5/k40sUPKP0TN4te97PDw0GqIj71PPa3I8gGDOMcs20FfFDu3sHPFtRzn6r53xd0+6hu1VvvP4pwmMoQngwwrmskl/GFa6PNRgcapurdnGf9Pua1Eiewg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WANl3C1M; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IHhtYbi9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WANl3C1M";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IHhtYbi9"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55CEtdDW004327;
	Thu, 12 Jun 2025 16:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gKK83WiOFlX+WnXSxa
	X2cSEoQXA1hR10ygt05rncRKY=; b=WANl3C1MPdNtl/mfvpRv1QhZJkLGidZD9M
	p3hHTMs+/DvT7IN/n4MmuQtFHzy7Vcv3+rX8alxx5Icg4RkZgl4i1DUNaFZgDEY1
	LOGJrKh7UVnAjw7nGZi+QbHetmMB/eb9F9NOe/1aM05/eFxc7W9DBJ+WxDNzBOz6
	+XabHLhleiuTHdYQ2KowARnXvT6yb0SwsgNkZt4EyDEFsCNUpu5VBh5Vk9DfbCQO
	p9csvkudpmBb2mZJW/UaYu+hmuuMj/Dce6F91zG9ZUsf8r/C91Y45NgfKqitErdU
	3qmSQuDZWXPyhhyfR7eghYtrcoj8HxsX5JYaJKLlWW9mr5GjyClw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474c7523dw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 16:10:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55CFlRT0013373;
	Thu, 12 Jun 2025 16:10:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bvbj86f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 16:10:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kqh0/WZNM0+7Oiike/VBvLV2/idxWgyDONnErMFKjrUhy5NFYqPH7DZRT4VQuuOZKtYv4HTzp3e6hrstrpl7sP8JUtfQot1JINMKQO30ra+W5zfhqQlsHLGBebcPmZW6GW4keIssPzqSLvODQSSVZ7u+SPhSb3jlfe/3HOkA/H3YQ96DfQTPSgjoccTpmV69Vbnn3TArjRAMc5bfwFX4/XqulCtFjsTfS8Red4Yx3fnf1B9TFetKZH3R19F128uJDgcurA4KeJxTmA7LNINgxgm+YP4wPKSVz07ZFBHP4zyocX63ohTtF7BRNc7V/JMgxTlXPLucrGx+PO8wzRZIaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKK83WiOFlX+WnXSxaX2cSEoQXA1hR10ygt05rncRKY=;
 b=xKogBRNZCX65L7VuwmO8IFAQ4f5tgiXtOfoGVl/+wddMCSAtXWurJd6bLnQKt2qpdIyGD87CZIOxx0AAPnpVrZUvk+QVnD67LtCmVzDMP33u/sK1edbgyCfsFJ7IyKcY9vSdk+jMOcqRUVjTtXpdDyq5pKOqpJdWPmB9qVGXNH+S1RJ2KvtAOxAVIfUF5lYJabEl8ZjavYUliYclQBJnq+IQWD202yscaet+bIeybVbpNmYsvGubw6lOqCzPgOXiP/O/Sjc8tjXgAqTWlPsqdp8IAXtYXbXTFOvWz0p3QEclMujXaOXTJOdpUYEfMhYL0m1kTGEFf38mLiavkTnlqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKK83WiOFlX+WnXSxaX2cSEoQXA1hR10ygt05rncRKY=;
 b=IHhtYbi9TpH/VmLq3Z9Kwn9qMVzOc9PDSFhrC2daCWbqoeFgMJ8YW4tQ1VwRZu1IiL0X+zHT45/hwPJd4YuEI/V6v9fk+unxXe3lXWoaZHSWZJxzP2JbyQMHN8iEBjAU2Zn5ae9K2+aKmVYSUW0aTA0JrCUVXXscJKQFcBqcEsk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 16:10:52 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 16:10:52 +0000
Date: Thu, 12 Jun 2025 17:10:49 +0100
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
Subject: Re: [PATCH v2 2/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pmd()
Message-ID: <434c6cfd-ba83-4d3c-8bde-736fcb8e9d91@lucifer.local>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-3-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611120654.545963-3-david@redhat.com>
X-ClientProxiedBy: LO4P265CA0255.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: 60cf95bc-287a-4aed-8996-08dda9cbb3f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lyK/Q9z59bGvA6zxKtP7l3EJ15k/2LtbRuCUBpyW7Ka/wijxdCiuRCUFWa+a?=
 =?us-ascii?Q?koeyk6jXJiJ7+Bn6Gjp9HC4eJwGUW46ZbUvbtCrEXdDYG+D5kFSSfPAze6m5?=
 =?us-ascii?Q?3RVdYv+0v7To3MTESn2HccV/LgMkTAFl23/+2GZhJealiJ0bH8kCnKDaI48C?=
 =?us-ascii?Q?UakxYw7CjP0lTTZVOAbHM/jplrQYkOlYFgkag8stCXwYXqUGRTYsDOHMr4fT?=
 =?us-ascii?Q?0ubPgN8rcFHZ1l+v1FQzn1J0St9kJWihF818JnU1tOqkMm/lwctYLbioVof/?=
 =?us-ascii?Q?TXN6oDTrbKKZsFQAIV941BezEWTzCBXAIOdHOYXYLJ3N603NPUIEji5nGMLN?=
 =?us-ascii?Q?j1kLX+jZApyWZFwG7rifiW2V+Mx5RcE0DxFScSLtk4WK7SeWbRyT03wucrnp?=
 =?us-ascii?Q?NKflHv4Zh0GqOmHmsMHH/nQJB3ib6+oBFoGFMBztHyoUZHSNA30sY50c5edm?=
 =?us-ascii?Q?Nt3ZOckqmzg8pul7ADhgdxZQldmghsgf9lpSVF47N31B/CRXHACQP3g1zdRa?=
 =?us-ascii?Q?zDkE7TYHx4HGnih0d+B0myu83hny4Z+r5GpWLu70MU7tHHqTNuZrLHqoiON7?=
 =?us-ascii?Q?ofKAX6tJMh7gTIt79HteDUydiMthqrx4fu7xVSAgEJgLKGB0nysU7XqTWE4z?=
 =?us-ascii?Q?wCeokTfDiDTyrBRoYdxJe5RnH5UtcWSnYTNpZLEx5oQRSuVOw/HP7fvgSdv3?=
 =?us-ascii?Q?NhPAImCgdBm5U/3M8G/AptMJY9CWn8Jeeb3qMumtcRo0km/QgAEYPNOfP49m?=
 =?us-ascii?Q?SKIlNZJ6Gnag/Zzt1g4VQdcW7Qo9D24+MwctZFkrp1PSeq6DWTqyX9Z3Id2/?=
 =?us-ascii?Q?j30GxAaLnCyN+9fAfQL+UfyAG6gxxTeq+5dNxdYDUkIU7rIenNGqtbjLIHdn?=
 =?us-ascii?Q?kcl1bmxSbKkaEFVWAb3qmiKAU2CiS/827rn8K9UH9uIyJpEOM3zowFniCd1f?=
 =?us-ascii?Q?2yRYYXb+w52Nr8LZJ75jG99USM6kfvbkPsrRoP7PoiY4fANv0nquXz14vxp1?=
 =?us-ascii?Q?0FpFYc8Jp3EnPaxU/AZ8slwtL6OYFeIpQwuFmMrTmBUSwrUAXhjas+vcfiED?=
 =?us-ascii?Q?JfrPw96mmcGnGj3atA3wI0jktpHKECdcX7daydim/SQeOMTiII/TKKJcWWbU?=
 =?us-ascii?Q?G1aPy6UNkhh7O+WUnc1H5BZpNLukGgIm8u92pTrzg396wMxqRDSDKMH+3pKa?=
 =?us-ascii?Q?8LYtN0xjjhh8m5VyAnCRk+kcG9sk1QsiMgCASFybBGVhbjkwv4+YBzsujmuJ?=
 =?us-ascii?Q?68L5ESc/Sq5fRs4GLZY5yXnDOe/EM0dEeiLlv+NIxmQCqsesu20IG7E99NcA?=
 =?us-ascii?Q?3xbDcpiPNa5/NAu2njFJ448ej8A795uMzQYHq53Vcic8rpCVIvySE29jz82x?=
 =?us-ascii?Q?me79rnx8/L98hSkYekfrv2DomBu9BSDaJ9nV119C5lqpDL3n0pKIfoh41Lwv?=
 =?us-ascii?Q?EGqo4Y5/QUk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UcjfYWpSBEcHn4eYYJokLZQHhwAMiwfYu4ER2y8LVz+EO9j/ttNIaI/o8X+P?=
 =?us-ascii?Q?H1ihsB1RwbIf6vdQXJFA/kXAvjLw5F9PTgwJAnxYhvH1k6x20UMms+ns2Ops?=
 =?us-ascii?Q?YendGn8XVEwrG6nqz1X8TZbE9V4g47JVdcVoSI95rVXYD03bew07J/ZIaz3E?=
 =?us-ascii?Q?nkyVANn8mom/n2+BNuVLDRsHf94Zz0vLfpi+7FZwAjJ1rMZZLjofuytXkuK0?=
 =?us-ascii?Q?wLaHtRSw+VKzd4y18DF0lLkjNvnrrFfiWqdTRAVxvtfyRVk4JHICpAAZYUSO?=
 =?us-ascii?Q?y3TZh7JXX5sGTtWb3Tk2b5RI9IoL2M6LHzm8duAjjOmQjguAMhltkZXbJd3E?=
 =?us-ascii?Q?1UayQoCYyaZtR7b4uXUMJImwjSD5Ol0EV2M3TCCJLNx3pnkezfeh8kM6kKGS?=
 =?us-ascii?Q?rLEwgQkhzDyORV12NEzSZkKAOUQatm9NVZT3VPWi2a+JMs0yAdUaEIoqa1t1?=
 =?us-ascii?Q?iS7vYKV2KOLHLXC+3dJPcXvFG8rjaejicSmRd9MXyMHLSgH6/WaB4Wlkv+lz?=
 =?us-ascii?Q?Iiw3MlZ0OUTDh7V75hbuV6tgmEIWZzYFmjwovSc36yoZE7GSVI+NzxQx02To?=
 =?us-ascii?Q?Sz1+aDXj/VTiMphgXLI/rM2FNiDxPp50UNXpVuIhygKWwxt6kg8Qn2ZULNp/?=
 =?us-ascii?Q?1G84PqsWECg/9x9nGnRubwvOBqvWxsK/EpIhDGFJaoX3EziDwclBwJSzuxvK?=
 =?us-ascii?Q?4m2uvC2BCgRjfw4mkbyEEUuCQ6QSB8qtCZmJyRjWAcosHN5+CgyJ3ZJFC7H8?=
 =?us-ascii?Q?ezW+BWq4aw+UUCrcjBrF+6Nk8PgCVq7gBx2H9R8FlcitgEHLN9J+z2TNgU5F?=
 =?us-ascii?Q?7uMt3IqkoZ/UIeE6gDgBAiPT+RZ+tZEwDNYHwWcoa8TmUfYVC7jgMbvvBAE0?=
 =?us-ascii?Q?/8dr0B9rAHkVN12b6DcG/Hwd0j4oh8OxfxFRLVLWRAPdn+S+moQAz8nkGouQ?=
 =?us-ascii?Q?q19+8NXcu9mlz9lhuRM/Z2gYtBJ/KYOnvttccTavCwjxLoGmvppZMIhw7jsp?=
 =?us-ascii?Q?Y8AZz9BRKRawCwmAgdpceFX1YOaSMECioq21pmlvZOwKw/QpuCM3hQWj+GB/?=
 =?us-ascii?Q?yCbP7aAzf3Gb/eLx3rZtWqFciOksCLl5Iqch9vhpGISzFO9+9RA+W749lq7t?=
 =?us-ascii?Q?mBVeoBwsBhHIuiqDq7vNCdSyogkHGPYFY/bI06SGBX7IH8bD4lw5+MuoP8ik?=
 =?us-ascii?Q?fqcDvVfJGNv8eU68e5Za5GTQYar437VHzYpCjylWVdHhl8T8+3tTjCNmCMFM?=
 =?us-ascii?Q?Tx2PynH7hNiRdGb0KufaF2DY0N8tIseaOCZOywsVKYJ06OW2Pe5lad74N8MM?=
 =?us-ascii?Q?JDh8CRv2QPlIv8RJ/qQ0zjpo35QkIwJX6QZsqwPu9a/TaRUgbRuicAQiNiFS?=
 =?us-ascii?Q?YxcN/Ta3e/2rx3UVBndl+PMmwj9ApwU1Z0BDWbrImC3q5hwoS9otlxI+KUqe?=
 =?us-ascii?Q?dNB7Np+56SXH8d8XGbeng/q3Q+jAFuHifXj+p6CdX/Ta3nSLKYHApb7RwsKS?=
 =?us-ascii?Q?Zz0x038gO8aveMGJT12AodAnEfisGyWSQq0oo8L/JloLaHNcIlYi23xcRbwF?=
 =?us-ascii?Q?7miGhfM0NyU5ViuZRUC0MIrn5TIuFCxD6k1u1dFeVUWDxRO0BInAZRAkzeiN?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O4KgcH3Uz+PkLKmGxGwQ1WQqSKMmRzLWKTswB2Z9gHdNHzhmOj3xBv7+VL79PGOgknVFhYPnxniR6eOCPu//m72U7lzDKNl2tK3FTP6M6DlmIA+pgtSoePr8U8eFZP2wBB2KgLu+xRDYjZVUnHanAmhJuRabzaz/mo5hW0PbwgyHc73xl6G3w9ZnyPfNXE04ayn8RSvJ6089HUh/PbHKbAjCAdIHUFkOFge3Fwbq95WYZImXlXMy71Wd3VjVKHzZHy5YooP4UljTleuBFQcGs44jPvMiC2j1mb9Jw0P8gIsVAWCudfiAeI+JZVcwRrvWp+qs82215GcBqNIHOnaIM2+/8AkeOwZrEE+PH7OfIo8Qprn6rDXysaYvpNdKVdJa66AE9eFPIN2VRoQ8M5NZ2hygvxVaRM1O8s0pKr55KV0HutYuOUXD4wyhP9U09lso4UEGY4dGGkLGUEUtBrD+9FSTLg/HqG1wcHKqGw3impBdjCoOFmduPM5+OFGmrxLGCfkLaPIQc4l/lEhFx+xwBtgNBX9AvPRf2Ocpo6aj5uVyVCfXNHHADFgteE3u4ggckrO7Q6amfUhcG4XW5q7NQAJGTysTYrRs2jt5u6h5BJk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60cf95bc-287a-4aed-8996-08dda9cbb3f0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 16:10:52.0346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NtzlHmmYvQB8u6zPhZFGVbCe83NBOgy0CZ5HDlMNLqz+bG1Dvx3UEOh31p3IzQMeu+IsLTfwTQX4hKDHVWkGQCv2mAgKU2JM8Fu2oMDLVAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_09,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506120123
X-Authority-Analysis: v=2.4 cv=LIpmQIW9 c=1 sm=1 tr=0 ts=684afc0f cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=YsqJlWqfsuv5vrmSBRgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: ESrB6qUN1etOpbSPksVWz_dUYXxPnk_N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDEyMyBTYWx0ZWRfXzKCWI0YOQf+0 FP3V6B5uHgftXK2dgLsNWQWPiLLdXV2CNgan+AmWhzZOlZEYMeR8uePttFppjy/UMeaYRQZzAtk yAM9bh8xcRrocPX6j8e5Y1vofZbSSBrEEXzealOOUGp2UKtSvhIE5lSW6IS/oSvlb1VaWCKrCae
 Uz3DAPtYBXi3r1ExbV93mqwDAWbKQOaJgbxK0czbDj8CDD4eMMmnx0B2anj4Hg0T5YnoACqETER f8zhcXQV+NqwxnUJU9INxOgqB4lGl9BZMnMCRAEcH7y9ao5RFINpk0oiusSpJwVphQBtkVYt2IZ hd3Iwj0OiCODSnZxS6MrEKMVqOtGwZh0c9m39msZKhDtGFOSGC7zvaVu/qbyF1r4KF60wBdfk+A
 l7CCxRdeUk/AhLEYFc2W1JroqbQFHJqYtjcrr98y33qdWqMs0znb1coU6Vwq+sTDoinF9iaT
X-Proofpoint-GUID: ESrB6qUN1etOpbSPksVWz_dUYXxPnk_N

On Wed, Jun 11, 2025 at 02:06:53PM +0200, David Hildenbrand wrote:
> Marking PMDs that map a "normal" refcounted folios as special is
> against our rules documented for vm_normal_page().
>
> Fortunately, there are not that many pmd_special() check that can be
> mislead, and most vm_normal_page_pmd()/vm_normal_folio_pmd() users that
> would get this wrong right now are rather harmless: e.g., none so far
> bases decisions whether to grab a folio reference on that decision.
>
> Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
> implications as it seems.
>
> Getting this right will get more important as we use
> folio_normal_page_pmd() in more places.
>
> Fix it by teaching insert_pfn_pmd() to properly handle folios and
> pfns -- moving refcount/mapcount/etc handling in there, renaming it to
> insert_pmd(), and distinguishing between both cases using a new simple
> "struct folio_or_pfn" structure.
>
> Use folio_mk_pmd() to create a pmd for a folio cleanly.
>
> Fixes: 6c88f72691f8 ("mm/huge_memory: add vmf_insert_folio_pmd()")
> Signed-off-by: David Hildenbrand <david@redhat.com>

Looks good to me, checked that the logic remains the same. Some micro
nits/thoughts below. So:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/huge_memory.c | 58 ++++++++++++++++++++++++++++++++----------------
>  1 file changed, 39 insertions(+), 19 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 49b98082c5401..7e3e9028873e5 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1372,9 +1372,17 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>  	return __do_huge_pmd_anonymous_page(vmf);
>  }
>
> -static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
> -		pmd_t *pmd, pfn_t pfn, pgprot_t prot, bool write,
> -		pgtable_t pgtable)
> +struct folio_or_pfn {
> +	union {
> +		struct folio *folio;
> +		pfn_t pfn;
> +	};
> +	bool is_folio;
> +};

Interesting... I guess a memdesc world will make this easy... maybe? :)

But this is a neat way of passing this.

Another mega nit is mayyybe we could have a macro for making these like:


#define DECLARE_FOP_PFN(name_, pfn_)		\
	struct folio_or_pfn name_ {		\
		.pfn = pfn_,			\
		.is_folio = false,		\
	}

#define DECLARE_FOP_FOLIO(name_, folio_)	\
	struct folio_or_pfn name_ {		\
		.folio = folio_,		\
		.is_folio = true,		\
	}

But yeah maybe overkill for this small usage in this file.

> +
> +static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
> +		pmd_t *pmd, struct folio_or_pfn fop, pgprot_t prot,
> +		bool write, pgtable_t pgtable)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	pmd_t entry;
> @@ -1382,8 +1390,11 @@ static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>  	lockdep_assert_held(pmd_lockptr(mm, pmd));
>
>  	if (!pmd_none(*pmd)) {
> +		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
> +					  pfn_t_to_pfn(fop.pfn);
> +
>  		if (write) {
> -			if (pmd_pfn(*pmd) != pfn_t_to_pfn(pfn)) {
> +			if (pmd_pfn(*pmd) != pfn) {
>  				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
>  				return -EEXIST;
>  			}
> @@ -1396,11 +1407,19 @@ static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>  		return -EEXIST;
>  	}
>
> -	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
> -	if (pfn_t_devmap(pfn))
> -		entry = pmd_mkdevmap(entry);
> -	else
> -		entry = pmd_mkspecial(entry);
> +	if (fop.is_folio) {
> +		entry = folio_mk_pmd(fop.folio, vma->vm_page_prot);
> +
> +		folio_get(fop.folio);
> +		folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
> +		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
> +	} else {
> +		entry = pmd_mkhuge(pfn_t_pmd(fop.pfn, prot));

Mega micro annoying nit - in above branch you have a newline after entry =, here
you don't. Maybe should add here also?

> +		if (pfn_t_devmap(fop.pfn))
> +			entry = pmd_mkdevmap(entry);
> +		else
> +			entry = pmd_mkspecial(entry);
> +	}
>  	if (write) {
>  		entry = pmd_mkyoung(pmd_mkdirty(entry));
>  		entry = maybe_pmd_mkwrite(entry, vma);
> @@ -1431,6 +1450,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)
>  	unsigned long addr = vmf->address & PMD_MASK;
>  	struct vm_area_struct *vma = vmf->vma;
>  	pgprot_t pgprot = vma->vm_page_prot;
> +	struct folio_or_pfn fop = {
> +		.pfn = pfn,
> +	};
>  	pgtable_t pgtable = NULL;
>  	spinlock_t *ptl;
>  	int error;
> @@ -1458,8 +1480,8 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)
>  	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
>
>  	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
> -	error = insert_pfn_pmd(vma, addr, vmf->pmd, pfn, pgprot, write,
> -			pgtable);
> +	error = insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write,
> +			   pgtable);
>  	spin_unlock(ptl);
>  	if (error && pgtable)
>  		pte_free(vma->vm_mm, pgtable);
> @@ -1474,6 +1496,10 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
>  	struct vm_area_struct *vma = vmf->vma;
>  	unsigned long addr = vmf->address & PMD_MASK;
>  	struct mm_struct *mm = vma->vm_mm;
> +	struct folio_or_pfn fop = {
> +		.folio = folio,
> +		.is_folio = true,
> +	};
>  	spinlock_t *ptl;
>  	pgtable_t pgtable = NULL;
>  	int error;
> @@ -1491,14 +1517,8 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
>  	}
>
>  	ptl = pmd_lock(mm, vmf->pmd);
> -	if (pmd_none(*vmf->pmd)) {
> -		folio_get(folio);
> -		folio_add_file_rmap_pmd(folio, &folio->page, vma);
> -		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PMD_NR);
> -	}
> -	error = insert_pfn_pmd(vma, addr, vmf->pmd,
> -			pfn_to_pfn_t(folio_pfn(folio)), vma->vm_page_prot,
> -			write, pgtable);
> +	error = insert_pmd(vma, addr, vmf->pmd, fop, vma->vm_page_prot,
> +			   write, pgtable);
>  	spin_unlock(ptl);
>  	if (error && pgtable)
>  		pte_free(mm, pgtable);
> --
> 2.49.0
>
