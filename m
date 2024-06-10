Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DED1F171;
	Mon, 10 Jun 2024 12:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718021021; cv=fail; b=Il6F+PkC/AIzXGOGrL3zS/N5TuZhwlZ7VMWzvahYU9RiohRR79/HwtDbTpRoDcamibeUUATNWLeTnsne232onBUPIZ/H0IVTE5rRnCa+rPcI15HEyuJA7V8MG5fK4YXFlhIrzr7ezAadpTymXukEFjWhMyaPHsJThKbFUVseHzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718021021; c=relaxed/simple;
	bh=tECMfFw5bPlCx+k7wYLXLJtIIu0rEIw7EeCL+tOL5Tc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=d/ZTe+rYSuYtZMasAvA1uTpPsxn4K/E6YDY9splNR4M9bg72Fm/2xFJgQEiju35QdERe6JNmyuizLa/AbjdELlN5bGb1P8qk6NQio/cqrzu2pSTmHl80Rol7oL5AUEFV7+/Q6kpiBwJKn4V5gBx3RT0Koobj/T340Cy8g6kiHlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j6YOyk1z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PKfPvumd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j6YOyk1z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PKfPvumd"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4BSa8006754;
	Mon, 10 Jun 2024 12:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=QByiqhShWqFtS6
	s9yWPY2iDtKabNQ4zbCRbvp+RSqBY=; b=j6YOyk1zyfb1Jhg3HhcTWks4dnvA9S
	XXi9nTb+aDAQZgBNrdygCaBUwaUItrZhyjPCkZ1arRInF2ruGBcsOxUJEvv/FFag
	YYo2xMgOskKm/sThRi7iDxebDq9JngHLT9w1tlmETf4vuBfEcsLj5dPLFrWteo60
	UHIg46JRbkefkrOU5hESZjFhaPWWSgwcZ/KshB1fnELVTwWAvkdciyjRAw8oNFHs
	lnSbe/cj707DS+KLK59nOfmmUzd6P+7hy8qyax/dgEWCSG6lT9svO2EOFsDscmMY
	JDn5Xk8UBGKm2R75pHmGZPdUUxvs/H9n/wWurIQsKaIhu1sHoLbbhU3w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhf1acn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 12:03:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45AC276d022228;
	Mon, 10 Jun 2024 12:03:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncasx0qs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 12:03:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SYIrIPonBURpjYJWmaQY+1UuBq3a3B4jhg8LljbWNbyMc3D8Xbz/00Y4mEtUPLOtZxWvelufWTXp31t6HPy46wkH3V6B0NPZbdqALAgNDcpkS1N8UAKssHp7ycwuvJtTCFPZZdfvJnve7dXMZIzihAe4p5bmT94GdYE19lsh0WgTGkR+den62zLfiTZTblSXIM3RNn+Pb4Mcm2yGzfUD3VyTxzpBVQB6ROTnogX8uW6hJOu12ado7TKhIjLUZeDKHHDz7Y3DfbbVTCSBpHkMMnHOh5SOP3bgOAfXqHwtzvos+tWGE9ZK7RVtk8Mc18Yd81fRltgw14MqLyKfE5q4zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QByiqhShWqFtS6s9yWPY2iDtKabNQ4zbCRbvp+RSqBY=;
 b=YrQwwEdqXHCC+7v91f+77xP+Irbsk9mWrysk/0cMWxH0DR9rFxBq+GmMDNfYsmKjXkpmykVJGyJn6S8Ktnk3ZCYSkhgLfBZU8MYCoNOAyie2+9wufTVJC4JpHDGbGsEk9ADxldKAtWvijC4x5GetqeAavN8vhKXcFtVCl7l3jdqP/cP/qOxeyRm77fHlsH3UB/KA/qhm/wmL/WpxChKBkBCY5x8QoUpCk+eL5zF/MGig+N6OhPKoJ+noAPKTm1lDvktK8WTrX1AWovtXKzuWMWH2N18lc1+ioROs2z+h3mLYFwK+euykDav91zZXCQce/r9UW/Ap/L6WFI5LcvjrfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QByiqhShWqFtS6s9yWPY2iDtKabNQ4zbCRbvp+RSqBY=;
 b=PKfPvumd3EuuDlbwVFWYbCJ1TXqrxwVg+WG2kl1pWEpyIv2YuSW0gFQDii/9FQGUey3+x1eH+Vo2DJpfh9QFQtDgOOBVnQACg7MbpW9kh8KtL5ADZrDTYz/hkplmHVOaUpTRGpaoq2h6b0VuadCmreHaMwPwZbbcf5/XHurMpEo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6783.namprd10.prod.outlook.com (2603:10b6:208:429::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 12:02:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 12:02:59 +0000
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
Subject: Re: [PATCH 09/11] block: bypass the STABLE_WRITES flag for
 protection information
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240607055912.3586772-10-hch@lst.de> (Christoph Hellwig's
	message of "Fri, 7 Jun 2024 07:59:03 +0200")
Organization: Oracle Corporation
Message-ID: <yq1sexl2efx.fsf@ca-mkp.ca.oracle.com>
References: <20240607055912.3586772-1-hch@lst.de>
	<20240607055912.3586772-10-hch@lst.de>
Date: Mon, 10 Jun 2024 08:02:55 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0171.namprd05.prod.outlook.com
 (2603:10b6:a03:339::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6783:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a7d5ef0-2411-4096-eb52-08dc89454542
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?E3uHDq3SLMSfl11zclqkbieJ61HioId6TDAD5jzK83TWgus8SjW8RJUFqpuO?=
 =?us-ascii?Q?W80ChcawftKCyAQnMdug7p22LjqgnCx0X6P8py12ih/by/cASFtTkdNJVarI?=
 =?us-ascii?Q?YS5OkUoUTWPj0Zayt8FkTEamHf9qGiXWV1BFt3bplrL5nkILk7mJi1gqGAjn?=
 =?us-ascii?Q?SL7HC5/HR+EYaACzVGfRP2PmcqQ++CObK16UZG4/uBBZbJuyvuhBtOxbuOR7?=
 =?us-ascii?Q?pq+ovfvrRAazceO4+3WPGsDRQ7gCOfoycU3GOVAEBKhzW7+3BMaEADVpYHtD?=
 =?us-ascii?Q?DmccgRyZ1jUYborap7SbWFBL9+34bkqnbaqXgOaDaSEnhQHwo2sjtG4/jH71?=
 =?us-ascii?Q?7X4OLlEkW+5v7IPEL3sgIkpxGK3U9ioBz4xpXfrL9ERPULvg8Sy2Gze6bZJb?=
 =?us-ascii?Q?SO9+BiHsTM1uWK9Z0Jj0rixSP+i5T8c1xTH88YxRglABe396BtYVgQ2m6v4L?=
 =?us-ascii?Q?I6KEI1jEzCHj1Fe5CfJCp1FPH6H9d7SkQ7avzALfV3lEDtwkljw7a+7/f4tF?=
 =?us-ascii?Q?h8Jag1XmpgFaUvGtD260lC9G9LvJtytH2xrvL7lL6xWg+kB49LgY713EPICE?=
 =?us-ascii?Q?TXjmzpqyTyfjQxueeXBqKpfWyiifecPRcyV1ZbTKbdn1R4VNY3CTdevWLE2Z?=
 =?us-ascii?Q?iY9n9pz5S0mj236ej1m2/3luURZ90AjQgWilZECL4LN/u9WstDhc/6bUuITo?=
 =?us-ascii?Q?6OEhVzacsf14Qdhr2xZ8pg5WEDhOkBu4KTVokaMlxmPVbK6UXe2tS29ddSU1?=
 =?us-ascii?Q?8LLd3wgNNb9TbHoBgQAdshPGUCnNcIaDLyantOhwq7E84ofQFWWCHI2Mcyw4?=
 =?us-ascii?Q?WcQ5+5QBnTz0mpmYdx3yhICQIZ8w70tScqm+irD7by6a4lcERoD57ApH2cJq?=
 =?us-ascii?Q?oLacyiQT76j6Kc00okW0xuskz08wC7B1QVAPmaQ4+xabgeQn1nmUHO5xlTIg?=
 =?us-ascii?Q?bqn9obcEjoeM/tjGX5bCNVdHaZZ/36sSJwmv6McxdkZ4UKZcutkvM4i9uyws?=
 =?us-ascii?Q?cOlGatfSBOfC1UgxwpDsmBMdFafHxJh24I+uFUgcV7J2o4AHDBggVH54khU+?=
 =?us-ascii?Q?YyuiAEWZoohYuz/Og065JfeRoGTtmGZrh+HGFr7IIlfCDNN0fdePHgVypfFA?=
 =?us-ascii?Q?DHgdFevnixVAbAjKcV5phvZ9lzKYzjrMLXHCCOtpju4izp4BssP+GHTBsXy8?=
 =?us-ascii?Q?ktjptD9dnLhlliAGHznWJiZRwUU7a67gPSajzLh7hdvjdKPeE3bcuQXi+rMY?=
 =?us-ascii?Q?Fiq2jGu+CyUXWEEvYktrShd/YykqQ6EH/mFVkYrRCTb6iZLn24xvXoyldiEJ?=
 =?us-ascii?Q?Lltz8gXbtzPCIoFWviCkeJKD?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?OGLuAeHbUUnxXvUKgCypu2JUAy/o+Z1XsLEOwoHXrleY3sT5k6mNJbhyVb5f?=
 =?us-ascii?Q?csNu+GAzNEF7ofh6dOwKO8lY41qnObJdJfmEYjtr4EGAYe5kZy1bAwK/ttvS?=
 =?us-ascii?Q?ACqIhN0IAKW1YfhmXkfkQ2PaxM/ey+j9Nnge+EwT3UyG+tqSoDxeajT1mi/V?=
 =?us-ascii?Q?e5fGTZ1EnyFbw25E3+Lr5QCw0mVFsx40vXWCSp0WHsQr/qCYOaRKa0quhcyh?=
 =?us-ascii?Q?s22fYYrTQQ8VEbHhq5d7ym90Dj2wPwOOtiRgUjvoKoMANRvoapYeWw8kzu4R?=
 =?us-ascii?Q?OWTvCPQtUPx/H/dCL4O4YDTkD/or1v8WnUz07IRZfRTHu+7HaSK2tEL4PuCS?=
 =?us-ascii?Q?Dk3K8ifzQkgEC0wt2/nekKFKUBtb6ZOaBgQnp2aMaqsT2H1f3dr5Cn1RWJVl?=
 =?us-ascii?Q?JQWEO/o77PAfmGY2vEVH22+26UKC2Kf+gqQkIeoKNqkD+6tktutYuFyxGe2r?=
 =?us-ascii?Q?PMUsOz9DRRbMA+hKWkixkpvrsvxs1cKOAAxlK4dB5PrJMAyqJCOIKXSSIUbI?=
 =?us-ascii?Q?kHsLm+qnRX+H2M4wP9uZk2gGpxu7ppFM/d715PYHXeTUHYrsqN9EOOsDhFXC?=
 =?us-ascii?Q?he8xyLEzQ/TDqxOadbPWDkDPtgm+e2Y/0XUSeynToHDF3jLI9e2FbErrVQqg?=
 =?us-ascii?Q?pcHFzOehPalUThGIz/HT8cQCW1heF6menK4IpRk3KrKXdLGfg8vG4wWn4/uf?=
 =?us-ascii?Q?Mr5HFXCfhY0ICHkCxKOtNGSmfmPNErysaJuy3Pvvlyf/rU6ym4vKTwy4aW5g?=
 =?us-ascii?Q?SXrsrFKTEFGJb9c/mLHbDHDbXKdUPyHFfoEXN+af8jPgIociCB8gFhT3Ejw5?=
 =?us-ascii?Q?vfIxIJZ6D+ZJMvYM3Bgal89mNIkW9HDippQVq+mCs+evm3ZgLeA2JZ4gR3Ye?=
 =?us-ascii?Q?XA2BDh/viRR+DeGQVMVuHmOfL/oyQUWjM2qjjfEsodr5Z87QTmBEqlKug8k6?=
 =?us-ascii?Q?9rxPi//bc00qsqFuG/Lq+w6V0D1phQ84wG2fYOHxIKh7enoDv2xP5MzrSDsm?=
 =?us-ascii?Q?jA7JgmGaUvPnY8U7ipytI59Snm4j+VRMgYAjABlo9rpioLkZsc6z6UIaP6rw?=
 =?us-ascii?Q?RytqPxSXnnT5HHpsmGt7rs6t7HyiIyt6q9ZD04ORZdDbsoBgXSahXZI50xSK?=
 =?us-ascii?Q?YXH2jkKM1jjIqp+PNdeF09XIcqTPRQKfBneqKuvw4++uUPZJk5SoEsEZWSN/?=
 =?us-ascii?Q?5BBXNk7mwLVG61goLvJaKzbiv/8u+QrAeeu4cP00pjLRJ+1QLJ1YVyVRC0SR?=
 =?us-ascii?Q?UpNt4DotTS1vG/g3klCLPjhvZRa3i56qMBXQHMlA5RxuPPPlv54bapwcY8iR?=
 =?us-ascii?Q?sMSOFq69LouX56Pmh1H3ze0D7tIRSV51JmAN6iGNrYGDolzIv0Db1ezThVmt?=
 =?us-ascii?Q?/I6IWRvjJsqmfmsCf1iyohQUmxQXjw9P/lZkDiEqEa5F8VZNsktskizLcWdq?=
 =?us-ascii?Q?edR7AHG8tlPGp5Y2rnTYRwR142navXA98ygBLBol/kxSCjWA9fsEvmGIOmui?=
 =?us-ascii?Q?3AqNXFrcWGkGElFFkVpDUisGulJYDcfgPRCk9o11WKBMfXL25nPnODK0x4BT?=
 =?us-ascii?Q?wnPpKAkR9liAhDDNnKsnxbsLl/+PkrMDEWgaxsPWDIGbnzu5hbqYasY26oDQ?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	6SWKHSC1NtjfNSfTJLfxmHAz0NZRRjvDPAWYXHwgWfeRkWMGbGLo4OgWeJUq6IdrBeah2/8wYVgDArojo/EX5bxc58tQASbhPtYq0kRRaYsMngVyctkoRXBFFAh1T8KE1S7YGALdRHi61OuwUoWAIovf59KEBODiWt8/jeFkHnwZaY33B3sU6hGc0pXtxCRHokmUUzj41+6JvT/beWr8VdkQ9Vypq0NRq+1tK8cyRUl3KnLWcCcJlnbrxStZn4uwIxdB54gHYTl38WBp92m4G9S8UYXZy1pfIyuIqqmmkXOiRKFrZvA/pkySBip+juH9rBn9k2bC3UyYSWTHeE25i1IWN2yXxugLHWXDEsJjQ+gGRtJjfgXfDOgC2xj6WU9XEO5a7O/nduTN9IOsS05lvN9I2YAtgVedYfOto1illNgiopPKU8+4ZNo/rdnh9L9J1Tvyv9msWvlug/qR9W+Hkd1WJiQh3HmDiheUrt3szAlAIcXEblS03ENDckqrtI0tNq0y3rKZeB/To6iKDRcgUKeAYgEXn6YBaLQZjUTFFl6Sc8OrcntOngjxoshi2hggNJuaF5S97GAUDGY1V9q7GPhIaAxZjiUHNmV55RU08BQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a7d5ef0-2411-4096-eb52-08dc89454542
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 12:02:58.9830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3PpLepOIKUn+8lQFsEGikZX+95j8YnCnDNkuy0Tg2hBSyInC7wkiu+P4KjPzsUnxYbovro1bMPsHj63frby/CYes5u+3sVjrSqrZBZO8GOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6783
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100092
X-Proofpoint-ORIG-GUID: wUcCpT-hZrGEJQ9vvYWq3WWEgHymZXDu
X-Proofpoint-GUID: wUcCpT-hZrGEJQ9vvYWq3WWEgHymZXDu


Christoph,

> Currently registering a checksum-enabled (aka PI) integrity profile sets
> the QUEUE_FLAG_STABLE_WRITE flag, and unregistering it clears the flag.
> This can incorrectly clear the flag when the driver requires stable
> writes even without PI, e.g. in case of iSCSI or NVMe/TCP with data
> digest enabled.
>
> Fix this by looking at the csum_type directly in bdev_stable_writes and
> not setting the queue flag.  Also remove the blk_queue_stable_writes
> helper as the only user in nvme wants to only look at the actual
> QUEUE_FLAG_STABLE_WRITE flag as it inherits the integrity configuration
> by other means.

Looks OK.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
