Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0990E18E1A;
	Fri, 14 Jun 2024 02:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718330574; cv=fail; b=UBj9u7b3FROSPfIWvKDu7a41rDZxvk7m8fdq9cY07m/YZfeg+Ukb/XgEMwwW60QP1mWjb35LTmEQThPGOL+NkHVGv+L0EH0ajJQ8nFiN7vmnWkX9UlhcjNWRMr8Cfi1mcrIzM6txizPAPk6/IwH+xTYm1mNKlk7BRQ22pweepUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718330574; c=relaxed/simple;
	bh=eMX1FFX0WGN7g8JTe9Uf9M99P9ufEjAROMYBwx1R3XQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=U8GByTvrBHfDwaMbjCxne4aukPUeKxJc4Suuli+G4rD/x68VLwaKLhL2AZv230mbRMYv7qxzrVwe1yQqku4W7QjtmBL1GX6BDEPCa6n9kQzJUlHfU23MnElUofAn0sgqGhp16ZMUx5sNWGJlqHJuNuPZomJ3NkypDlVusf53Wlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ILliqkvf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dyg/Umnx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ILliqkvf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dyg/Umnx"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1fYVP003508;
	Fri, 14 Jun 2024 02:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=g2pH7Qm5zYweMY
	/Q/RPwut0Pa/eHXBrYFAal72Aszxs=; b=ILliqkvfMykPoxgvuQ0JN17t1RzOxG
	saHhRpsMGSsojuTESRpBIbiPB0/zZOhvA8pKDmmtUv1cI2szyjS9NXW6RkoFcJJZ
	WFQMopmeFxbVLXHS3RkVmP+GRu9h6W0uwqO4XVlKabHhSJ9w/1u+CK9FbA3pXeLx
	T6QoxspGG2mVQi8AbJUIbNp/HSOq/0XM/0h5t6rNx0EHc8EXoNDWq9M7bMWF1x4C
	bMJrNV4/HR+M3uMtkuJosOz8WQBiqh5KNzY1EcyKnbOKBaP46JxdabCgfo8xC8XW
	L0CS/4EKM1p7iQ7+bTWRd6tOslJ6fUOcfXO41dVJ/Ln6pgBynhesNfTw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhajatjk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:02:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45DNeMrC022228;
	Fri, 14 Jun 2024 02:02:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncayb4hn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:02:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwdXlNb5SdAZgHuAti9CTG0f5fiIJvbsjf0RthU0HABYKyj/wA4rg7TWp+fHcuww1vUjrLnOJbUdG/dtCKd5QwXWJnxwIiXxK+AB69jEEmJsV1NvoHcRo1j1Wi2NDFEB0KPa1cyhd38qLjnku4rLwBfvBaTROUwWKWTimaYUAfXradm1uSfG9ttVqbwJp6WMJm0zBpzTeJRFeIEXufUn66anrp8yWTtoAmf+Sq5IwOA+MzDK4pLCQzXEWGmxuheMyHJ8uDzVweNDbSbiBtAsRXgYweDzavfUKOoX6no6EqOH2M1AB4otX47gwMtc8spWq9rlnYqsj+yHpUQrY5JmPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g2pH7Qm5zYweMY/Q/RPwut0Pa/eHXBrYFAal72Aszxs=;
 b=cNeuSuZu9fDE7EEGFYe2hawBk2Xd2r6DP1xXrqO/UEbY2ymCZIK5ADGMfrPc2sOW+xYJylMq26MxAdUQ2W9tlLEV1ZK/E9OMhuwWStNR5jqGs2vp+Kuci3YF9Ia7vrxPS3wvOGG3N1tEPzXxdSEWBMcNoYlDuZlCu9kfQ/+0ndusPW7CgWnYtp+Mp3yonXLbc+TJnwh7Hfd3rhPIFuJsUxqqdekbxn7VrqT4nGyT6lMYYc7/v9SY1tFSeCDteHgIpEu431hUo9SiGJz5xXdydNq7csZ4i1dOy34Kc8DTuf5wFkUbazYNHWjJUrYSSi9clKLE7ZHWxwbxtfBFXkxiUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2pH7Qm5zYweMY/Q/RPwut0Pa/eHXBrYFAal72Aszxs=;
 b=dyg/Umnxz8ObfquJwDUlyPsuRajlcQXgnJr2ySAwY7oTroSXA1naAYb+4nywVwjR16lN5XXzr4tpyCQvIWL5FfKqDh3vogTfHDKwIjUcMmvOGHjqTNKZDN7a9xr/Tc+tJrhFO34NlDmM1vSljUxr8SpRHBtihdjTbFx62M2Xwwc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4607.namprd10.prod.outlook.com (2603:10b6:a03:2dc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Fri, 14 Jun
 2024 02:02:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 02:02:32 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Mikulas
 Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
        Yu Kuai
 <yukuai3@huawei.com>, Dan Williams <dan.j.williams@intel.com>,
        Vishal
 Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira
 Weiny <ira.weiny@intel.com>,
        Keith Busch <kbusch@kernel.org>, Sagi
 Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 01/12] block: initialize integrity buffer to zero before
 writing it to media
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240613084839.1044015-2-hch@lst.de> (Christoph Hellwig's
	message of "Thu, 13 Jun 2024 10:48:11 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ikycqo2d.fsf@ca-mkp.ca.oracle.com>
References: <20240613084839.1044015-1-hch@lst.de>
	<20240613084839.1044015-2-hch@lst.de>
Date: Thu, 13 Jun 2024 22:02:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:208:256::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4607:EE_
X-MS-Office365-Filtering-Correlation-Id: fac6d982-d93a-4642-2aea-08dc8c160d39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|7416009|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?NlP55oBgRffArEkqJ1hek6rroVMakyAKItLWAAtKMoRIfAQUYWGEeWUZv5bE?=
 =?us-ascii?Q?/olP5j/Xpo7YdT1kQULLRDFb/qOvMtvkX9W7m+tfcH4FhgX7oAzho6oEVges?=
 =?us-ascii?Q?+1BEv7iGDmeF2nnR4UQaP0qrg1efg2Cb1dOSBkcaHptLDaZRix+iPuUvDm8Z?=
 =?us-ascii?Q?Ht/HLBPkS/9nzTSLLMlph0zgI3M/GLIyKigrICgueFAOhfyxFmlxKne7mFhB?=
 =?us-ascii?Q?PuqUje6KGe/xHYLY36fZLkAHVwHU+zOsB32Atw/QNHvrF7EBs7OUSS2MC82D?=
 =?us-ascii?Q?Gp4DfjaEtXZjMTnXjOXAup/BB7vjPfbIDpntdktSs0lZe+1tf0BXxTGb1FfP?=
 =?us-ascii?Q?clHkMowKVwoSRIwI6ltAALitHwdsUy0BHG+dCnH1u/tWO+oc6eY64SI9763s?=
 =?us-ascii?Q?al4HphNMND10fI2iCJVr+xtM6UuTRAi9loFJ29Wzy48+OECnEQKgcyXkqJT4?=
 =?us-ascii?Q?zYIMw/xhlp9Q66GQgn3TGhYhq4ryDwaEHNSsrlvVohONI8d0lgVuozKjpmdv?=
 =?us-ascii?Q?9S/eyH8uMLqDYr4v9v5aaMWvZa8bzXMag4ASsWXx3u9/h7Htqz9alQ9zVgB6?=
 =?us-ascii?Q?xlMpNoiGXRx+X+Ekfx03S4Fs0ZTrY4KzV8mWrrbYBKbsaPXtckwiN8HQCnRE?=
 =?us-ascii?Q?J6zkMCwcROWw9CI8gEsHAP2+RpfOX5qw70KMzeqm1Ln5JVi5Ryo4MQ22cB66?=
 =?us-ascii?Q?sPhOikJR48O/fB5IjvTvvha+fsOw4OBvu/IwsxTIPrVEHSgMezN20A2sbiwv?=
 =?us-ascii?Q?8q+sw5XTZCOZlqTcR8XuZeFQvK6IcpLY3lkAOHDqNaMTYTSYQsDw9GmdSfdh?=
 =?us-ascii?Q?XTVn0KFfqEt2HDTcgnWeFuLdoi6UQq4+c8pPPYvw/jRvq2MLdXh7ktKmxLWv?=
 =?us-ascii?Q?yfT3VLXKyyIfQJe3sDRc4397eGtoz9oc68uoF6zwUNZD8MS+I+FKqhPW7wTZ?=
 =?us-ascii?Q?OdK2EwDKWTp9p4taWuKESDtWnSbEq6Bfmac/9eq2m+5M6pWDra2Qie4WG2Xw?=
 =?us-ascii?Q?LT9SRVLIIh63M4OIFDfXdb/ZopFaZ/eS5UtxQsbCr6XRYHGheoCn0nV3P7Mc?=
 =?us-ascii?Q?L7Ac85G/nZZS6KZ2AhQGRJ3TnzPn2WIOFLp3ZU3Vb7+44FEt3Y4+Ir/w+uqm?=
 =?us-ascii?Q?gtGsSU/w/ikMUyp+roDEE1cO7BDgzPLm6h9Xa43XeIBy35z7+JpvuVeXIT9s?=
 =?us-ascii?Q?stfMtdkS7kSmIUY6L9ONaK4TNGWE6Ezp0BdqYO6wE4DI9ohr0RHinFJSvnRg?=
 =?us-ascii?Q?WadFHYQ6R2sgKGlbuOZgaioD5dnTShiPt1BKYNClj3d4IQq5hzcSw705/Dnq?=
 =?us-ascii?Q?/xYYWfcCPL43V4cjr1BVxOuC?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(7416009)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?nq5IHcLbDoPQeUJ5ACzXZeo+HH/aql0aUgpj75jWoG2w5NSALxOEU329N7nJ?=
 =?us-ascii?Q?ypiibpq4IoD3hZpN/+7Sy7wp9wJlR9rYMaMWtQT4LDvOiataZTDWw8258YJa?=
 =?us-ascii?Q?tdAF/hydbOZXaCevcSwl45p3ybqNzTJDLz2JMdyDlBnR7ElUFoeOtUGh6kdG?=
 =?us-ascii?Q?DVErP9SsTUgOIujxB73vcygf6VxjnfZmqG/LrQIkistIEHyimWYv3ownJRlm?=
 =?us-ascii?Q?k1QlFCR16iE4NJzQfOTYDhV92dGGPrJTryux0q4wOBV8paecTcF2RK67c7WK?=
 =?us-ascii?Q?uBeNo4+S1GpouVss6vibkwFR9Qs21wNvqDF3IIhn9t/1G2f9uu09h4vfWkfo?=
 =?us-ascii?Q?gH2j/vqzAYWoqBRqVQWYgcJu4bJ/aIxT8vnkUyyaXey9AtIZ2RKBKKHEN62U?=
 =?us-ascii?Q?N8gm7ofL7DKVYBXMUcWY/2cel+TdlOk+Ezul5JVKcpGNimdK8lpufoZ/FWpv?=
 =?us-ascii?Q?knKI8ga9gkbh2PKMRCUn+aMJcXIFpjKHVsIT3hOsixdC+lxcX+3orNnZv3TW?=
 =?us-ascii?Q?ecKcSWlsZLoaf6+Ij88pEsCHI4IkhGqYqtTtSVQcRNkDwy1arSQDW+aAthft?=
 =?us-ascii?Q?zPhBtgfce8DT7D5hUI+HaOcfk4PgbkRM6rWGyAKSsEvM/u2FkX9iZIgGNDtl?=
 =?us-ascii?Q?V/AbqQuAklOIu6U05c4tDJt7+i7eyvEh/QBG0u6ScSm5e4UH4i/7LRb3tpyb?=
 =?us-ascii?Q?ndlMJSSJDMwyokCCh1Ep8Q1R2S2mGo1465ErEo3KhHD0WvtqQHXV+X7MaQyc?=
 =?us-ascii?Q?JZyRQivz/VBPLtEZS3u8h2Iw85uXimuwS/VB0+AOsLYpEOA+PAvyamIiIWuq?=
 =?us-ascii?Q?YRZRdhbKIJlTJQm30PXZj6/qrPXZCgxf7CHVecsVXsSxBaD1cTfAVsU+Iu7T?=
 =?us-ascii?Q?V9DZzJXVAQlscn6tqygazBF57xVjnK+wCE27Oez5szOXE+HPhPw0UhweL1zI?=
 =?us-ascii?Q?R3Dv97OVW/KWMYK5b5CRRrlRnPlu7DlMV7iPt7tIx0CYnS7xMeeK1QJC4WeD?=
 =?us-ascii?Q?6MdXuawgV95bCfONmjUlX7en3chDHgnxjkjwBMkkdJIUysdDnqKRn1tW2Qkr?=
 =?us-ascii?Q?MbhC6ADzYiAKxO3ASNnlK2w+D/FI8cIa9RWDEHnOHtZXUckbtypybBT1Y43J?=
 =?us-ascii?Q?wdCTwglIGq+Ux3tRRdX65R2j+n47bCCx7kO0pHDxTDq/OWAiI1+q4Gzn1Vv4?=
 =?us-ascii?Q?vYMBsE7H2mkn1X0tbFe9aymzibIFsXGuYMFYCOAP7d5/NVQSeiNNlsh90vqF?=
 =?us-ascii?Q?EI5ZmTKMuDXHNTSGxrUzefl5o/gYXEk+YtTOfyKaSi/P/IL/5oHRRh7vz8TX?=
 =?us-ascii?Q?K6FT7jecExLj1AwM1srw9XeYNFKil5eQQLEunh+fQkU+2IgpxwiDfIuW8m/G?=
 =?us-ascii?Q?vebBE4DTCKD6jLBluFfuZhjRDaZWO2YmIf36X4MeBn/t8tLKjWY++LHTUXnA?=
 =?us-ascii?Q?11Y2L3nBpZdO8Os7MTEAcIOxGuztM7udfZod3vtfZrbiZE4Za8K5nNHN5Uka?=
 =?us-ascii?Q?SLuqvPv/UsxsnK/QA9XycTmD2bdC78LnEBrHUHuMbxRHrapSzrhABxQYmQOq?=
 =?us-ascii?Q?2A1G4BWM7ZXhquMfwvAExDvB9Q+f9F8eqmQSz2JuL77B9GL1dbR8hB9eFjbL?=
 =?us-ascii?Q?Rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	TV3Ifg5RT0zlje0E0KPtw5ojplq14JJYTwNo0yjXSG7t5B2puiGJngDTqdYwIu5bSlJ3H6j6SxI3C187TWsQVlscZ7fIjXKh4TAfsafIJjXn6Yv5Op/MMArXLNma3ldmihrOhnUsVXH6J9fPAQ71Mri6LhmFn168dBOcD8WwtcGv50Nt4yqbYCG2NY/bjIYpQay4T8UI286NCYd7Cu+hIVem+rW1D21G20A0ebuQMM1af1f4NOprbnyowm4A4mf4m62Hs0OHdy5Ojv1MGkOUAiIC4iTM8RLBOJauKWoJNv+HjaKhW3+fckOQlJy6zWzW2nIawssmd8W0TDlbeCIjSjC82hbfoUfVzKmzoUkBzcC0vPyOoyMNCRYLnL+FFfeWaBPBS7ndmWB56eTIs5+h4BvHWnkt9WpRmnfU+YwIHf/RpwcCMC4Olfcm8DvXDVj9RiDuZejx2rac/+LDrsmusUI+Lt1ifWhEUw1suia7JqrcxuA2r1f8sK+bHp7q3V2vl38ZvWTC6bIoVVOHFnRyQ5TGtVRPLb2luNcbIjVMhFxhvh/D5u0cW+SpHVqM/4Js2NhupjN858ZB9YZ/a1cjl548N3F1jgoNe6OlSSQyoNI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fac6d982-d93a-4642-2aea-08dc8c160d39
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 02:02:32.0294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 24b/0+PAGU2Imt6RkitshTkfJisWgU6jJRWvPg1fftbYEScBi8HRJCCXh3l7a9LYfM0VWMTJDX0+j/4OBTZ5K+oqLRYyM+mWnKKyuIELXic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4607
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140011
X-Proofpoint-GUID: 3lzsmK-0qkBOskSnzEdxJIVnUu5jGSpz
X-Proofpoint-ORIG-GUID: 3lzsmK-0qkBOskSnzEdxJIVnUu5jGSpz


Christoph,

> Metadata added by bio_integrity_prep is using plain kmalloc, which
> leads to random kernel memory being written media. For PI metadata
> this is limited to the app tag that isn't used by kernel generated
> metadata, but for non-PI metadata the entire buffer leaks kernel
> memory.
>
> Fix this by adding the __GFP_ZERO flag to allocations for writes.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
