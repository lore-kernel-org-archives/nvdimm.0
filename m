Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471964D8C0;
	Mon, 10 Jun 2024 12:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718020893; cv=fail; b=qHI5jqAvzfKAK6H7eDQADtoy40T4q5QU1Wuqhs4llSVguJ7uXaJ3vCQYYjIqmneCP9sunj+ZjDWFwoz4Uo+M7JVPj1MZkOnC56+R+TO10Zs0tGMEWwmP2Jo+kHR3FJGxws+601b9MPKOtNf++CkQulYOqLkZB8RossAtAMkqATo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718020893; c=relaxed/simple;
	bh=MBZ6fWW6f4gID/Gkj0EfP7NhnSBcFwdivm6/wn2urbo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=MAV1aKWUG+eemq9HhtMBnFrzWk1U+cOI28AbheLDH69vuDSpJhLAtG6wfn7TNYCFSYbMXsLrmZggU+fpnxsJPT4+jr2yNIQNOpNgphniU/JqfA51uJifum5KMCDkN0eZUzXaaSSedtgRPW1jp1m1dblJTfWcbQ1QFWU7g3gL3Yw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HREK0mGh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0N3XPlTs; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HREK0mGh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0N3XPlTs"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4C0eX005419;
	Mon, 10 Jun 2024 12:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=n2evvZ5J3sLuv1
	JMyq0c4VXRXEd02fRcDYQGUAgfwuI=; b=HREK0mGhtl4m3uVJ1PYN5VP4P7YDAj
	pYPzmswRlp15ohsE7LlHUs9r5u8ClHG7bxJs2t0qYdshnyRm88S5N2+xozHRzDck
	EYMuL4+Mj8SPF6FYQWj/Hu/erx3AkKfCec8Hg0wgZqV0eqyhTfiEZN8E3E0TJKSr
	CgGuXz0NDNSvZoikmqk+L/RfAS4wBW/hlt2ju+Nv1y2NzAdglfl5ieOFeNZ7UvdB
	CokvwF+Q8aWUTYtTZQ6s7FsaqTwJn7i5KrJIyGrUFcLDXfLtN+VIVCgQdcOvUANC
	CniwkMuxS2IDMUKP0RUDN+BU0XoXctTSJun0u+05cwqT2NfK8bBNWS/A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh192ctr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 12:01:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45ABUaWx027065;
	Mon, 10 Jun 2024 12:01:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncdrnx8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 12:01:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhO7sUiAL2TVEwBqo0IC8WGAyjuFUaJCBLTJX9LEKZAEV6j4qdxFqLfWmU1WsVjLr/Ylqj/HI2O4X8q5CR7QUPwB9TiRhAMY8Q95FXvYexkr73bbt00St1ki8d5AUXXgBDRNjplBGNSpsKf+uH3lNQuiiuChYF4IokPCYsmiHkZaAjEAFmf9YthIKxsGB5iX2vAyP+wMnm+Cn8QTUZmdltTuGT9DlfQsBzYuTzHxfYscqiorzr6aBRNP4iYmu9li0JgkpQXj9Ot0RW0USvBmnzH/9QdVRFmFP/I5+NWap2Y5bTbnWoFWgiUqG2rKXSf83xF/UBhu56wFj6cbwsRbNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n2evvZ5J3sLuv1JMyq0c4VXRXEd02fRcDYQGUAgfwuI=;
 b=MgkqTB937CzEnJ4IP+wLN+1g3PhptQXR4YDzL1H4We34yp110dkJTY84M++KiJrGXY16ogkLNPFyH4JfT08YFg1BS3b92BhZSFsdqywos5KQmjN2oJfOzWz60ThkJYstmlnrafJT0Rk6PRXJcmn+NdyVHoTzNTE7thdJMFgUL7zy0gVPA8BvPhtk6v1YcrUZdNXO/O3qEHd0057YjQoDd5FJJ8vjfh32+2URwhGA+JygPdgEWMErHdWVBIDD/kKCQWAjWrR/UUJWCYgzzPIs82fYgrymRtLNZb3WPfgxO6TWbNQThOZSYl1A2waoUrDd1UTQaQSTx/in+Ggke9+pGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2evvZ5J3sLuv1JMyq0c4VXRXEd02fRcDYQGUAgfwuI=;
 b=0N3XPlTscIAbIYreQPz27uCExAfTNw/s9sN0jOSXwFFZryK43anC4vPS7jDOO0qMiPS7hy1X8pT3GlZ0gMiN6XWyazb04td0DWxmff4H/LPjRulVLn0bvHIFA5PP7mDaoNw/zQ5WWdof7KCeQPuaTQnCF5Fz4UkVO4XIGhMALw4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB7285.namprd10.prod.outlook.com (2603:10b6:208:3fe::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 12:01:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 12:01:12 +0000
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
Subject: Re: [PATCH 05/11] block: remove the blk_flush_integrity call in
 blk_integrity_unregister
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240607055912.3586772-6-hch@lst.de> (Christoph Hellwig's
	message of "Fri, 7 Jun 2024 07:58:59 +0200")
Organization: Oracle Corporation
Message-ID: <yq14ja13t34.fsf@ca-mkp.ca.oracle.com>
References: <20240607055912.3586772-1-hch@lst.de>
	<20240607055912.3586772-6-hch@lst.de>
Date: Mon, 10 Jun 2024 08:01:10 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0027.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB7285:EE_
X-MS-Office365-Filtering-Correlation-Id: b2683cee-a008-4d31-9581-08dc89450601
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?80b+0Pv35ckprvPLYbEW6foUYct30PrYgp1SYfjN4/lCFP0zuLUZ3afM3BHe?=
 =?us-ascii?Q?Rt6PmTxqSEZSCbfC+jU0TXmWMd3IXOcgUV5d1BOA2uQoEpwjwpLm+hE4Xv2g?=
 =?us-ascii?Q?klq2D4sCWPJzgrSj3Z9qjuxQkgjTLJVnpxbVEsAra4m52zRMUY1hV2eoAwy8?=
 =?us-ascii?Q?Wqx+SXWt/nIIhjOt+dkTv4S5L9eBmmujORkm8ed+MXDRwnGwPjK22FRvM2Vb?=
 =?us-ascii?Q?k0xKKj2k803hKlcY9Ro5bVyc8iJw5Wt9/7QqHm//DB+1bm8ZnGCGM0Ikit8O?=
 =?us-ascii?Q?I1w6iEmAQXS23/Rpp/rbnKofLV4LDJy2Tm7jGzv7NhWb2XueqShshlMXPM5q?=
 =?us-ascii?Q?Xc7A3gWWA7w3QgT+rszLZqUmCqKeSXQR9lEQu0SZVzl6uhO1eyVpkrXaNSqu?=
 =?us-ascii?Q?R38zr2L832o6/mz0cu+60GS+H8456uwetcOHA3uK59TyodWfANuUMJurhpSZ?=
 =?us-ascii?Q?8NpV15riEHN7Nay1oK3GgffuCxFYQHnGyIxhWh3OfhXTUC2vxgUecUtHBW30?=
 =?us-ascii?Q?rDSyZjCkBNaiNM2t76UUolRcchRsh0qzy1kgqdAALrpB9TZPDnEkmKeY5wQF?=
 =?us-ascii?Q?XB3TbTTL8gzX4WzOu9glKuhRYkbDVtsXhWhHlxDds4dCQduyrJ7FXXCq0Q+b?=
 =?us-ascii?Q?ESE6Fz3h4gCyZDfL8FuREZjNL5mg0lIJkmfU1MNp8RG//CsdOjMOcOpm309y?=
 =?us-ascii?Q?Nzl1cA96GmwAgBN9geJbl+is0SDbvrFqZmoPy9HpJqO7LGTxJ4j8xB3vb940?=
 =?us-ascii?Q?soJK69GPpOUGqYMfF6OFN9lssiolTvFb3RPXbCWt5LuqGkC9egPUD0IxZJVj?=
 =?us-ascii?Q?e8vVShl623XOSCU4zof7gyLDbTso2/nOP8Tf7NSxMWeYOUkI5vQoBYKUYs8V?=
 =?us-ascii?Q?u9KwD88GTzxByLLKKvWich0Lfwphm3N/XvaN033LC6A7MiijV4QeGzm/gnsB?=
 =?us-ascii?Q?r8TitSEKaAndnIzWq89GvLhAxThVYBACVdpQiXS232Gn7vA2yVydplgf+7c1?=
 =?us-ascii?Q?7/voFtpiTu7nCf5XFMdwGnP67KU+x+R3SL3jZkoHBaTDV0ndlGB6qfCxBSAl?=
 =?us-ascii?Q?UfALZR4BGXDRhiT6wyoaQCMR+RSCt2l6+P+jGYlQlNuHAxeoIiPpc5dOapv7?=
 =?us-ascii?Q?P1yq1faRByBspwXxm6pg4ggQyd9iz6fX8eXsjFDCZAD6j+xex3GlXTVhbYlJ?=
 =?us-ascii?Q?wmVAcdkQUMTC5EYAQXN8hL4hR70oNVu3rUpst8vgpNtE4dAvzoYmcLZRnIuv?=
 =?us-ascii?Q?uNRmROqQlH3cgG6+AxvaaoFe+qpGwQtAQcOARl/oKiteoGwznbAHJsM3GhW6?=
 =?us-ascii?Q?Zg08QM8iws/SCdNTILjMa1UG?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?znGXzCsGnqU3lgv3L3fW8R6gq/gaGIpunnGVIBvoRwCeRwQZC+V9zQ0bTKxa?=
 =?us-ascii?Q?ULovBqUKICZnUIoZByiLZwRXIEJOzKkhzXRifbuh9jiud0ZOnoi5zgvK0n7Q?=
 =?us-ascii?Q?+yr2rEl3SSkPgvdUh02qDFYQlEsZKbiIIGLGjN8L2QbO4xg2RxP+RxFAvEoo?=
 =?us-ascii?Q?nMIVl0BCbXQOYmr+Xrx6N4R+v+40UPESHX9J/ePonSbRUhTgsvulB1G60rbg?=
 =?us-ascii?Q?Tjp7YnHwmrbSuKRAw/39JW8Eq5iAbrZ2MdW06Bp0pY8uTB0ACopSkJJMeDx+?=
 =?us-ascii?Q?PpvFSTlqxE8YBuBeqI87azUQXfWl0WQXQw+qUrp8LcYdV0s6XdfxO3RxqEYQ?=
 =?us-ascii?Q?mKyc7hp7mITWA4jhSpd1udTldvkgA5dWR0LxwL4CUeUh62VRt51jnnxA6gFq?=
 =?us-ascii?Q?zCeQN4ulyrsloO2rB3oEB6BV3YRd+E2725bgmdkV/US0Tghl/lIaN5bFQR9S?=
 =?us-ascii?Q?jKzZMRa/CDPjot3tFdL3twK0TEwk6vuIq8xfCPWJwnid2hShO0MWNuFO9I8S?=
 =?us-ascii?Q?7BhOmNDGCfaSCbdip+tqo8BTb2dr5kngFKFF8prLbcTGnBqSzQRl8vfLiwPE?=
 =?us-ascii?Q?RfR3BAMOptoKYWyFg4lX8pg/VUxbDQFmp8098MVjxBV92gz5pHZmGhNVg2+w?=
 =?us-ascii?Q?Qi74BVE7dwBKIlesVUvuymzfnwY+Xf55Y/3Y94PHiFj3ne5vOdMRcay4XSLD?=
 =?us-ascii?Q?lkFLlheFw0GCdK3f41EFA/w4IfREILeXjItDezsaSzxzUPzRHWRUcxlihNUU?=
 =?us-ascii?Q?Lff+q1lv8gx7dbUhvow2HEfPlJ8tp5TDE9CLMfcGtDhCtx3Jrg7OnjXMl4Fi?=
 =?us-ascii?Q?cilrgUSmWScPod2cKKbLBc2PaxVAjradKuWEkNCY8MHLSEuMD6GivMn4fJc9?=
 =?us-ascii?Q?cBHfM25HgTDXBWwiNPPo7mYrvcpQ6Sge+MfI2T8EzHpe8HMfa8pejXkCRNSf?=
 =?us-ascii?Q?hf47P/fuuGfQGpmqUDv36fK7Gx0eYxLzjx8EtQHghogetfC/0dsIE5qyBZdv?=
 =?us-ascii?Q?Oc9tMPbO2YLXVcZ78LQpiW60ospVwuCC5tNIYgDnkybTvjMH8icJsNTFvDLY?=
 =?us-ascii?Q?zTUscjSP7gPAvfc/JQkK6ZSZT8QaqfJPbCdoByzXW3JMKiudFy47fXuJgjc+?=
 =?us-ascii?Q?cg9JCnH0RwffbK+zoeJ8cfIWFgwHdWHjljr28Ot3g/zcgVXClGyELewL7GVd?=
 =?us-ascii?Q?h8Yf/N+2Ui3KNvj1oUKLrWdMOdfhHhu2j758nhzGI8VTqqomqibsCAgK91bD?=
 =?us-ascii?Q?95Dg5hvYve5/YR1F6y3bo41BS+q78SZ5lQUOmFl3OnQlkdCgeqrcPF9DvUYi?=
 =?us-ascii?Q?Caso68ck/VQj2PH6dBNWJZUhOAYxXOqK0rJzkq14beJFWZMUwlMq+X2PnIfM?=
 =?us-ascii?Q?hGiqJH8ptuiqbCXXo/IeNSC2QAvYVQj9lEq1y7mYiaMqZEE9ch7ViWVfdgv2?=
 =?us-ascii?Q?KXE6w/9ace+Fb7WEhpX461258pIoCFvqXgV3/7eiMOReF4vcL/QANfhc7wa6?=
 =?us-ascii?Q?ShTiK2NHUP5V9NfxOCVZfY5Au7zUSkzFSfQ6JhS6qhPbA/fcrxtq5/4OPnPR?=
 =?us-ascii?Q?8o7VtiBcvHSzMQxZTvUy3uL+tlsYhFf5zdULF5weXS77eE/Hk8nwLxvYRJ6n?=
 =?us-ascii?Q?iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	GqlIZQlpLUoZMklGe28+3Z628IsjBoGzEIEkvIjbfs2RJXDWXLU0jFTfw+LuDcgfV2pNp8psY6mr0xTcvaTkADdN6rJFJz+j6xXZK58aX443uL5Fyx7xv6PE9kgQT51fUw4ko75B5heKoj0M4Di9K+Gtxer+dBVKZwAUMD3ypqP4vPjnwy3VEoUBMIY9JWUSxF05WSo71bp8RvepSVYAx7UHZhnEE2OJ65MywDe4bx1yGUIQB1nvUyXGHhi8DPKwIj88Qm+J5ihHXwNmK1DNH085wVSPX/tixnyxHL6ZQswi4HlUAguYsJoGW8G7oyheyb9jRBzKWHGntBwEQWJ+m0BVcBVwNOPCOum+TuhtfNYLjQTKYCJRxv5N0Jgcer+sDF0RGtIZLfBYtHVdmctrGTkgpDWvUZowsQxc6Uy6wzDt21q5pyjKTtZT6L32UnFECpmD9gyig8nh+sGG4UM39xwgX925qA50g/tb3A+eOjHlp2pI4stSI/wOS1S+mGQIXBN1iah3CT0m+1qhz/wHEL1+VujVVxXTWxySjxofU7QaHMJR3N8fGpIqo+FDndIfNqceRgY26swae/4AdvQCWZJEWj2KKXtv/mRR2enzcK0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2683cee-a008-4d31-9581-08dc89450601
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 12:01:12.7821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94py1mj0giZ41rFEGF0VsGC3beKKMeD7jQFs6PpErVd78lQd33dPfVXlOCgieJPHOGDqgyitb6mKjgxOZsAs2rqZHauX45p3ZKRvy6Awdr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7285
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100091
X-Proofpoint-GUID: ly-P4r2kDREEh6JoeOqAqZrjwcAnp8n5
X-Proofpoint-ORIG-GUID: ly-P4r2kDREEh6JoeOqAqZrjwcAnp8n5


Christoph,

> Now that there are no indirect calls for PI processing there is no
> way to dereference a NULL pointer here.  Additionally drivers now always
> freeze the queue (or in case of stacking drivers use their internal
> equivalent) around changing the integrity profile.
>
> This is effectively a revert of commit 3df49967f6f1 ("block: flush the
> integrity workqueue in blk_integrity_unregister").

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
