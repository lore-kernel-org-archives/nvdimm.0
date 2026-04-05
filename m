Received: from mx0a-00823401.pphosted.com (mx0a-00823401.pphosted.com [148.163.148.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF71186A;
	Sun,  5 Apr 2026 03:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.148.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775359190; cv=fail; b=DZPaY8156AgpIVfjxBOfvnA9w4UzGurqDr72ts0E4BizHlAnacKv2gIkTkxWuAGvVdk4/cHQiF82ZZ5P3GUMZqPOiv4OGdCpxrN892EfxRkXBalCE7TkxgZSjQGiaSYoEd7gmY1Bc4EqmFJk+yhD/BYDxK6ahRWeCXq4G58k7RI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775359190; c=relaxed/simple;
	bh=9xi51x5IxA8yjb26iqTyGB1C21zdheIUt3rR9Hg1pS8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=DEVvQ/6IBQ3X8Z3lL0x2pKEa43eGIEVJFvAZaaKc54B0V6qCBCPYuKTSwkB2tFTlb+RpShZFTcsYNbCurEXX875DxwVA86cxa/Z/qNlz+qfrsNdF8FkCNENsnqYcyD+gaJL3j5QpvDSkwIcstHkCVSIJNqSLlETSL7QNBb7nGZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lenovo.com; spf=pass smtp.mailfrom=lenovo.com; dkim=pass (2048-bit key) header.d=lenovo.com header.i=@lenovo.com header.b=luuSdLyM; arc=fail smtp.client-ip=148.163.148.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lenovo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lenovo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lenovo.com header.i=@lenovo.com header.b="luuSdLyM"
Received: from pps.filterd (m0355085.ppops.net [127.0.0.1])
	by mx0a-00823401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6352rNqg3131659;
	Sun, 5 Apr 2026 03:19:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lenovo.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=DKIM202306; bh=n5H4wvuLT05Bp1Ud0DzwC
	TBJJC10+m+8xe5lWfH5+uk=; b=luuSdLyMvHFxCAqtMcu2zw+9pftedX8weQCKp
	eJ2/AiKfSXCY3hlS9VkOmGBDE1GpWz+PCqm2ljL99lnY7KefsBM0MJXTiSHJUUF9
	V+sesK2kmcPe4tieKCi4WyNpRBcprfFUsyc22cEVENplPvTJoFZYUEAkaMz0/UvD
	0knAUWN9oSmFuXsWIIcSmvK7vmBdVJppEkyD9DtxwxzJH3y7/mgJwkFUCB1wX4U/
	S7phc7YMYxVssIRMOYul9Kml9bO20VrUzY5pxC024Dg286vvT7ss3aGSw7NthqN7
	dcYIiuz8xA3bqTX9gYTzxlTIPkipFkxcJe07qx4ZhdExKCVEA==
Received: from seypr02cu001.outbound.protection.outlook.com (mail-koreacentralazon11013053.outbound.protection.outlook.com [40.107.44.53])
	by mx0a-00823401.pphosted.com (PPS) with ESMTPS id 4d6wgecbm0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 05 Apr 2026 03:19:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N/squRQFUr8OXyHiIrrW4naiXZUbdHk9qPl+ZpMlfigJkye/oXtB3FQfqLuivirD/xg45HBWpOC6WEUqPKsfWXSWMmGDrOV8HBmsTl4f6BMJCbkSVVNp8xFeEY+aZ0bskA7PB6+m+pj+ZLrLhroXMcQAK9yo92oW8Uk58setB0gMg7/R7avc0ajsoJbspt+6OzoBQBSnbJJNKEa+E8aJYg4MI95bqB7DMUVxRXJeRaa0Bq1TV+yQEtq0DBi7KjOG7yVFAdu0yuvTCQaP9gSwtrtwDASCSGYxC5D/F/HfOGdUmGxzVrxferpY4xqMjwbtG8gYNbyMe4JuYJehA9289Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5H4wvuLT05Bp1Ud0DzwCTBJJC10+m+8xe5lWfH5+uk=;
 b=W3QvYl63QbTKhOhh7A9Cgogx1uEpLn9NFIc3I8hWup4GF2LWJAaoeLU002eD8YUsb+LOUAqRY0L/Lus7uUyFkw/G7GDlRrDX6WWssdcA+Q65dQ/VNcaytT/13d01Jy52q2VdLm11k6qlpPqOVbQ561q6nR6RL/xUhYff+yRQiaLSlzXcY8ZW8JOOKbCZrUZt0Squseg3Rcd7DdbwkWmRKw8HHK1lAwpCjy5yDGI6Y8YIsDu+/3v6rTtgz/3NoepfY86EylAHGVW7G0ufM/2CEnBx2/OgMlHzTEZbYzrva6gcCVTtWA6SOl3aEfpsmeRLJB434mAGl+3DJTIkhQpahA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=lenovo.com; dmarc=pass action=none header.from=lenovo.com;
 dkim=pass header.d=lenovo.com; arc=none
Received: from OSNPR03MB9538.apcprd03.prod.outlook.com (2603:1096:604:45e::17)
 by SI2PR03MB6710.apcprd03.prod.outlook.com (2603:1096:4:1ea::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Sun, 5 Apr
 2026 03:19:38 +0000
Received: from OSNPR03MB9538.apcprd03.prod.outlook.com
 ([fe80::2932:47e8:5e8:302c]) by OSNPR03MB9538.apcprd03.prod.outlook.com
 ([fe80::2932:47e8:5e8:302c%6]) with mapi id 15.20.9769.016; Sun, 5 Apr 2026
 03:19:38 +0000
From: Yahu YH12 Gao <gaoyh12@lenovo.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma
	<vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        Yahu YH12 Gao
	<gaoyh12@lenovo.com>
Subject: [PATCH] drivers/dax: Fix typo in comment
Thread-Topic: [PATCH] drivers/dax: Fix typo in comment
Thread-Index: AdzEqu6so3Qd37qPS2ObsanU+5DqHQ==
Date: Sun, 5 Apr 2026 03:19:37 +0000
Message-ID:
 <OSNPR03MB95389421960C592713DD923FDF5CA@OSNPR03MB9538.apcprd03.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSNPR03MB9538:EE_|SI2PR03MB6710:EE_
x-ms-office365-filtering-correlation-id: b426bc59-c5e5-4ae6-4864-08de92c22b38
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 8sBuwtRA+r1ezsTt/fKT7e4Xkh+ufRJ33ubAa9jAZ68kQPsu1p0agtyhwt4jXNBBpDZKC7O+2HrCkIXIGidpi4vuzqc06dw7UEQFALsk4DI7h+KGqRxxJgtZJuUlM3SwWUhl6SgvVI/ZUfU/agBGZTDguzj7c1NxbRvN5Fm+D0SO8ruhGYwVDpRLC4cspIRW2mp2T4SZ2U6Vw+qeeuH6E6I51Ff/cJMhJ3rcqjvHNBlJ+aotZ2nA0RQhbKQztE8p4xjZlp83q5qyUyiE1Vhx62CSxsyD/Rb7DUL9S2nBjSBe6GzaZgWiiOyit6uHyZH1zp7digFcRyOCafH01jVOeMUZCTx5eL7MYuslS+xqCGBBjf8jGzlRNAAjHny5ulNqBGpVCdvwot42ISEdNtH2v8lGm2qTz8nbOjoEUC2CcnNOh4SPRV9g7VIIlrqvXSH2EV1g/dbsusQHwapznRPXjGa6kg2iEzqK+gZskIrHZOhC/gNrE9JVLY6mRGutR+cWRhFM7v57eeIZOk75BCLnY9K49hvH5VuXwuwORCbAMjS//0bsWCeQSze0kKdsoEOlADV1FPp2v91YuQM5btRyFUG3kx5xd6JBuok0xb72iElMXIpHn/nKaI7BNraqE9jHpRW831e6h6+SM4/hs+gkE2mC0JBMqe4d7Qu9+Iht+msY7hXB+8uy4qyHUWQpDwArpRzPSAAJ2MSQn9Mj3xIxUQpQ7bM4Nt185cZKdtQc8MzQj90O78IIerFQ6BDFjhwPVnsxwmHjlSPTHh6o08ie9CHIq+M3bCemC3+gOYLdMiY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSNPR03MB9538.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?HqYPLtlcxDknlilSfwxtmbLBjd/oTaAe/GoGvBA32Vv5pASzrkhlNEuhLgVK?=
 =?us-ascii?Q?UgSOlJo8XZDp3kuPX9C+sAkAZTxGrctd6dsbUlMyR37icKVD1No2AbuyfC63?=
 =?us-ascii?Q?COXElBo8W6cJgzBz4VR0FA0VZIOwMf+Bbe2ZZ6pDr6f2QevISX9TIMp6IfcZ?=
 =?us-ascii?Q?B+v9InBPa9x8pc+ODDJEIIG1VQ0CBEQ+LI3xdk1rFUk88ucNEpgdwf9SfQ10?=
 =?us-ascii?Q?gpkEfI2IQuJ4pjQV9LiDY/kyKQdkyaBWGRwx0gEi+j9fNtL0wWECBBd2Yegd?=
 =?us-ascii?Q?8HC3ctjNdOypbpM5Wnxjc7uexIwAsMfA7WY2K6zeFxlbZmYZwpxY4yWtUcNS?=
 =?us-ascii?Q?15L00pFJnuvEiPgrvv9ThV+JDgnaoMzdnMV4IuVG4R5GpMh7NmTP7oh9ernv?=
 =?us-ascii?Q?iy9M6/WF7BWMwwWpAsGz5SoIlzyV3GkXWA7mtz2XzSj88Udj8FJHky3n39PV?=
 =?us-ascii?Q?a8XbJQPZvXC2yT79hTeYC1qFdAVyJiCGiLvvPf7xUqxa2y1uO2cujNeTszru?=
 =?us-ascii?Q?H7bU3cLqNzg+3GjUnuP1jwRD03MmGzY1JYGSgv3SlpF76XkKQR4cWBQ5g/nC?=
 =?us-ascii?Q?pAx0UU+US0xf5wkasXPuZStZn5v91dKsquHWTun68xlxfsPYclAU5CNORw+M?=
 =?us-ascii?Q?8c/UzEX+hovqf3XQZP2nAcVtKEjDkhPBs0qzV9DhM4YpsAZQj1h57G6cwAiX?=
 =?us-ascii?Q?YCEHoPu1pdK6z1fc2tJoDwLXc3GcX9t+VIf89hTh6UtE8qTEcLlzCAHyVQvj?=
 =?us-ascii?Q?ngCIlUmSbWWNlyMIjCNIp6OVKncKJtt1TQzgtHK0JftDnhj8/mO84rdVAxDC?=
 =?us-ascii?Q?l5AKwh68UgZqREEVJgHMHP52C3qkWGI8Srevb0GrJpZpvqplLAbhBvkvYj1O?=
 =?us-ascii?Q?WAJZu8nh1TdkiSBqqnLkaCQt5x8JVLcBHtdRmdTM7h06ObohxIUwNSVL0fFi?=
 =?us-ascii?Q?eOoXk/kGTP5wOJjNOnI3u+ja8MGZtCYHjiEJ2wc81gM/mmZWAZi8qJ1R9H/T?=
 =?us-ascii?Q?g9furY+KrBYRz/KF6wyh/OEQKkDCtBIYDkhbBIIaklZB6Cz5jN+SbBKgIS8V?=
 =?us-ascii?Q?e57Kbo4lIY1KPctLP4eqeHebKd68p+Z9e1DlbmYGX74wn+Y4xdXcl4YJ1Sno?=
 =?us-ascii?Q?yYkYrxUMZdyPol4eCtOrNJEszWBcWIokXiajJwzLyV58i6eVbv//DYxnuR1d?=
 =?us-ascii?Q?9eMMOTcuBPaeBYA100zlBJ5gzaPPh0/EXjTjKQ+cIuOASXqXMOFo5SrPaDNz?=
 =?us-ascii?Q?OPB9QkfJ2ih09bt0bmvdo0+uk0F3oTM/LYNS5u8HCcfSaWL0QMXRgcy20/nz?=
 =?us-ascii?Q?EgMKUkssC3f42GGx8u0SPyUt6eFHtGLneFwxjm7ifB3tND10qM41R4am4JRq?=
 =?us-ascii?Q?yzenSSQkN078ACBG+hPH31o9d/IX5rRHsmI7gWIzGfFWQfz8PG6/yswdsoML?=
 =?us-ascii?Q?WxAjSmJiK1FfoXTX15LJNi7FOEk0TwyATg8cpKo9/v07C/bNBDwyf3LSONOa?=
 =?us-ascii?Q?7MjL4m11qxqUmYkRzeJcCBb+pwKO8gnFVJddu0fhngLA6P+dxbbVIgKK4Ewh?=
 =?us-ascii?Q?Ocm/bBoQ/CziByi7OWqN2D15j5aCpa5ExOpxhwuwcPvCJ0VBHKSssay3fAI0?=
 =?us-ascii?Q?J8wzqatRQz8B3aaQiC8Z6wX4StYmb3/viPu3T0tq6rNqj3YpREMlCbZ2E9ME?=
 =?us-ascii?Q?YPeUTBSj8sVFwEhlC9sQv/X1gPqxv863gNcxI7mnjZXUS1Ob?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	vALWlcd6pfJNFvscn1iPM8B7zoLxBCQLsVSmfHkSJZndvv149pUThwVGL8D//02ThTSnMPp3/JW2iMzcQgoHTqnv1/5U68Q0tk/clV6LjNczdTZ/eyqfUJV0/TDmTM1UByJLnlMLpxv3aTeLEg6qSa4hOZV5jsgsTf3PAPsbZbYzkptc1gbZNXnXP9RwCYLB7XDADyZZW3LZM9TqyxxABIuQfHqTgQvIMieo3dAwWsmmozRqsk6aN8lpDWOyB1rkDzs/6LsA/hGu7+dHvCJQGmzwi2FKmWPepix0eaUx5b1uqXj+qNVqz+nTFAE1fx8+T0TfctXpxkHPcx2Shj1sZg==
X-OriginatorOrg: lenovo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSNPR03MB9538.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b426bc59-c5e5-4ae6-4864-08de92c22b38
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2026 03:19:37.9260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5c7d0b28-bdf8-410c-aa93-4df372b16203
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nC64xbOZ/fFjBO1CI9pTPc66isQW33OC8zWR8avyxFpQ1DibuVGAHencmYcyO7E+eI3QjmOWrdGgJRkjcOabXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6710
X-Proofpoint-GUID: rgXfq4GeR4vZB6YVrptPM0EnsYxFSS62
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA1MDAzMCBTYWx0ZWRfX2Fz6ni/cCAPj
 vTKfU9mtOXRJru54MskTfqySj/SFJB+HtE6UwDLOXX4N1nooPE4G0B1ySi8NuyWbp8E4hwZ/5lS
 3zJnohuPxx5qVVhujDmQ4++aZEH4QTg5MeqhXPxwmq5yWFojbcmZRbJGhEe60VnkXkLTREmK24e
 VsuXNx2YhQGGwuqIYsjUb2rKySnHuoOomzRkU0T9Puw+xGzJkIFIqEdX5n9CXw5kKim6An5WmtA
 60hZIr1SxzorTt5aj9f6OiNyAQT4gCVw+O0uiqh+wwlhEzVkuKyk/hpug5vK+DMMlZoPiX+6Lsv
 9BT9Kum7vrDXtc10Ik/EaYfAU9qWWNQ38ADcbWg+ouas/EzVxC0SCkulPk7yPTV0eZI94T7k8AI
 9dG7ZDZW+YL2G75v212+veiQKh1y00f/K/U/Uy4Cmc95S4/HDjwyuWggzIJijDaWd92pJf6ZXtr
 peeLYRqub64H17euffQ==
X-Proofpoint-ORIG-GUID: rgXfq4GeR4vZB6YVrptPM0EnsYxFSS62
X-Authority-Analysis: v=2.4 cv=SPZPlevH c=1 sm=1 tr=0 ts=69d1d4cd cx=c_pps
 a=3FoI3lUye8QVV3OBnmahqQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=2RTuljz969oO5usasWGy:22
 a=ohM_6DErYqYCNn4jCPz8:22 a=8k6WQxmsAAAA:8 a=PGvEMCpmBVvAWQNzIMwA:9
 a=lqcHg5cX4UMA:10 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-05_01,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 adultscore=0 phishscore=0 malwarescore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=-20
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604050030

Fix a typo in dax_copy_to_iter where "vfs_red" should be "vfs_read".

Signed-off-by: Yahu Gao mailto:gaoyh12@lenovo.com

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index c00b9dff4a06..e32db0eba9c1 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -192,7 +192,7 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgo=
ff_t pgoff, void *addr,

        /*
         * The userspace address for the memory copy has already been valid=
ated
-        * via access_ok() in vfs_red, so use the 'no check' version to byp=
ass
+        * via access_ok() in vfs_read, so use the 'no check' version to by=
pass
         * the HARDENED_USERCOPY overhead.
         */
        if (test_bit(DAXDEV_NOMC, &dax_dev->flags))
--
2.47.3
