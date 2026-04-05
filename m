Received: from mx0a-00823401.pphosted.com (mx0a-00823401.pphosted.com [148.163.148.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881F940DFD6;
	Sun,  5 Apr 2026 03:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.148.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775360749; cv=fail; b=sqq4EVh3BekKNKkD8Pqt9BBpZOwdg+NIv+oWvl/5oNQ1dtr66CSI//+Bkk9+Tp/RCLpXuqEuKzeVQlIt7jFAMUZxyCvtVT+YMX1IPkLyN6V7KfGLbCpADr0t8sWJnnv6h29YE2+clxTzR39QFn6JPtVpfb3lbb0myc71Jm7GT8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775360749; c=relaxed/simple;
	bh=r5wjLPHrT6M2h9TeK+qgDFTFcQC5oLseqLfGFBw/OvQ=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=kHfgAtey6/pm6v9lPfEYNGOQRFn4OumPx5DD61V5sc5O2bH5v/w+25L1jy7QsX34Pnpo/CUgiS2B6Rypqmlg5ds45RJJUa/YM1bvGGBa7e0zu6vceyXN8M2KSyMfbY0SwENpv0pd4TZehyerrIlz9JgnPsiLIGNf8FP47FWdpXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lenovo.com; spf=pass smtp.mailfrom=lenovo.com; dkim=pass (2048-bit key) header.d=lenovo.com header.i=@lenovo.com header.b=Gfk560Ty; arc=fail smtp.client-ip=148.163.148.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lenovo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lenovo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lenovo.com header.i=@lenovo.com header.b="Gfk560Ty"
Received: from pps.filterd (m0464638.ppops.net [127.0.0.1])
	by mx0a-00823401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6353jlJW1575421;
	Sun, 5 Apr 2026 03:45:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lenovo.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=DKIM202306; bh=vQCUKqKL5P+8LTw3qCcvg
	MySP2q++qoJI4w8zUV2Hv0=; b=Gfk560Tyyl7VbweLmGUW1aP5Y1uaokfrQ9Alr
	co0QBzbsh/dzIJ/bsEOP89LG24Pl2SAH5A7uQGde3D2Xh51yk8Qraa/FaD3GV9N3
	f8ZvE0lONNHBZ52CpZqSp1dTx2+Rpw3doN239K84e/mMUuo1sFDwq1nwXG7BCUZJ
	kxm3m1vJXjqPxvkpFG+oU5MWVxeIG90aNyxztu+jHXG9UbSyoDti7wf1o6eTaqEl
	Ehtr+84diMrRgmYpY/X9KzEPx41OM93dXtj0/kfdgtilMGjogd72acty+li8PmGt
	z8fdUw48LF5UemUe1fIRAHpQ96QtwBTpD5Hv6EX/fOYIHAuEQ==
Received: from typpr03cu001.outbound.protection.outlook.com (mail-japaneastazon11012062.outbound.protection.outlook.com [52.101.126.62])
	by mx0a-00823401.pphosted.com (PPS) with ESMTPS id 4dbe3dg260-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 05 Apr 2026 03:45:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d/3D7MzKjRnAownyZX5oRjhTlIko9Ubj6Aj1CwUy+0etF26lT9Ccr87LUmvMtc1nJtHRN+ybBWJ2q5PtjlwAIC1kmSXZikj9KHxBrdt8r9aDbZVBr6rd/RoCzqk+oCI7R62r2geLBv/zepTzLNlm0Za4EiDb/syjYcmRr6VyyMOGEkksLmF2o8umwO0aQRFZM46uk8EG+ss/FAIMMKsqudc1SUVPmRrNUPXlb9OE7+3HDCMTd4j5XHTonU5ojqqXAyW3voWVhv8SDUDm56KwxQ22Xi6vcjAsRxjf6rPRPXUKn7ocsoKkGSJPySewCLAa0ltzf3UFkNALdIFTKA6GjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQCUKqKL5P+8LTw3qCcvgMySP2q++qoJI4w8zUV2Hv0=;
 b=fhFVGSMBzicU4EM886VGmQDWRgAmHJjKylZkzaTPEnHM+YsLCEb5kFwW3AJ5Jgy9PiIDLViOtGJv3UBs3dFgHS4xgOxw6fRngglQm2sSJg9v+b/0Cvhjwyg/2z13cq3GuHXy/sBe329DZXtlSXceZs85GfYh9SrMA7/DqxDjAZ8sFhjw0ocHF9ePTK3RrCYaiB+iB9gUoQQW0Dd8DGoT36L8HHafA0T754ziajTs6h5j8eATwDlAgNcMWHbUG8fggvVaV8H7L7JbFvCt+1MOBiKgO54e4uDAuKCozTdeCuNE3mjMyh3VpTCEdtQVc8HSeT+55ztv8HddJafjhkgINA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=lenovo.com; dmarc=pass action=none header.from=lenovo.com;
 dkim=pass header.d=lenovo.com; arc=none
Received: from OSNPR03MB9538.apcprd03.prod.outlook.com (2603:1096:604:45e::17)
 by PUZPR03MB7092.apcprd03.prod.outlook.com (2603:1096:301:118::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Sun, 5 Apr
 2026 03:45:43 +0000
Received: from OSNPR03MB9538.apcprd03.prod.outlook.com
 ([fe80::2932:47e8:5e8:302c]) by OSNPR03MB9538.apcprd03.prod.outlook.com
 ([fe80::2932:47e8:5e8:302c%6]) with mapi id 15.20.9769.016; Sun, 5 Apr 2026
 03:45:43 +0000
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
Subject: [PATCH V2] drivers/dax: Fix typo in comment
Thread-Topic: [PATCH V2] drivers/dax: Fix typo in comment
Thread-Index: AdzEroJhJHJWjIpEQjmIUDHKuCNxWg==
Date: Sun, 5 Apr 2026 03:45:43 +0000
Message-ID:
 <OSNPR03MB95383CB4853CB4CD18C2A376DF5CA@OSNPR03MB9538.apcprd03.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSNPR03MB9538:EE_|PUZPR03MB7092:EE_
x-ms-office365-filtering-correlation-id: 2ddd20a1-d225-4b6a-374b-08de92c5d072
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|56012099003|18002099003;
x-microsoft-antispam-message-info:
 hsrIUUZZeYiGpVwDpRu8A2qsm6zpnERldzEcdpNZ6S9pN/ha52ilEthv4ad5I84dEvfafHB1vJ5OXjxXc+CRI0xyDz2I2q+0sNzgPnZITG5dVtbkWfW+1l2iK7HOtadFZBPNpDrxchyU2GXx/lNbpINCRfQ4McMxrm3ZFvYJbk5dFme0UXMDqh21sSYaPtWyyEK6K8gCRoMV5pFu+k4oaJoYQq1Boz/oaloNIgwN1pTIKkLYJ+/IevTkv5o0lPPW4wEal4Tr7dSmYEq3AQoGCtvk5j4OHdX0bb3JzbWq8+YMw3zPJeOwjH5Z8wFHElJSjWckBrE1v6WQ6MbOpvbyFtvNJR7PDtw8X+ZnqB7gL0h1k6YJMUUfnqoqoSWy4tyQ/HUS5XBSh7qg0dhjX/FF6tVi0ZYSIXzs6T9oExmJe6kUPRNBAiBsgjAdMlopyANC2DvkgbxYL+fNcDH301qSVEAHbfLISLqNBwc7HrprBCtgqLZvWNIPYKfBjyOGqpA7yEaR5ZfIMTiyJ8kLJMRBBG2xTZPhbXtcmp+VlfkJhFdkWpHa2s9KhWSjiOljeMptjZj0R9BRCLnKL2yEa9gzYEElyFa25bdtsB+sewPoJdZKWwh4OF88YqODJYqkG0UudgMDsE56a4+ztlVQvGL9BRCxreY9WG5vXkcx5V7jK01u/FwH4HVq4c6nGtUYkeRLB28FfKEpaiNVo/AAOyUcNf9sDUZT5WXmk2geUQ0XuEnPJCy6jh0BCam79cTgTqtbUxeG0s/18T3i6eht/utHo+nJv7r9ZQQrwcM9ZU/4VtE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSNPR03MB9538.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?a6WdFH8tRF1APKSE5OuO73so7DznjaJ594N/5K7/tkMr9f3+T6ikh1FFmY9j?=
 =?us-ascii?Q?euvgKSJxi+uUAr0G7PNcR1A9JfDVIIqghXf8m9jytfnoi4+32dfTN27bjmaW?=
 =?us-ascii?Q?2I65eEmDhQv1iUL6BuQ6y3fikspAuIK/O6jUwyvl8knn8hgSu6gF9ijbCZAF?=
 =?us-ascii?Q?d/+Hv0J9xTAkvWoAQaSO1POkYNyFVaW3QUEcvITKqX/Tcpj5ASzsKpCeRh97?=
 =?us-ascii?Q?kZFCtW1thsCYX/nwc2G211KhPobWqjN4ktLnsnVWZPB9Qj/M7zukpwAW2kOF?=
 =?us-ascii?Q?wKx1/77WocWEWBV1mCS921kv0zmcMuhzpUnQHwjxgnrxvD5l4zWZTjJBeBmd?=
 =?us-ascii?Q?RSHy1gd6kNA+CQAyA0+yZnnYvX56ePIOiJiU9tMLtr59eeqLf6HuI9kJRnj0?=
 =?us-ascii?Q?37FVOiUnkvIWYxrzsS+XDfSJYxYCyqV2omoX1RyP1bhr9he/HbO2YOuboY/c?=
 =?us-ascii?Q?IsNbAdbdyHzWAC8+gxoImkyS44d+Iyv7r5sW0ieFgsb+QZjlfNbDJdkuyqxx?=
 =?us-ascii?Q?u0DcRTql5fD1MtcKuJXXkAEMMtv7pXfg8ft89pR0gGRvsr2PuDTjpf2waugM?=
 =?us-ascii?Q?os+CMjbeqQ5P9V7l27i5Ybda5eZMHnMlwxH/MNOwLa8zBS19DP6GOCcy2vJU?=
 =?us-ascii?Q?dkdbr1COuCzAzok3EC+lBeSxEhkZaCqZW3bFB1vVKsAM1K5KgWHyVxrZ0y2i?=
 =?us-ascii?Q?TjMkJsjB2UBlsPyHmzdvmPbtpTrannPZguhYfNWTg1aEFYcqhsriFnaFyp+v?=
 =?us-ascii?Q?Atl0D25DztO+SjX4Fy7uDn1q6u2JCdAjCyJhUyXEAofU06cnONmLa9rz31Hd?=
 =?us-ascii?Q?P9xiDOE+hVDA2wqp5fodDfYm5zbN1tILa/0N+OlP4dnlDACAkfJAEWbxpqyW?=
 =?us-ascii?Q?dQYbtSoA++/SgmZpYppnXjWhMP2oSeg+y0NXy2fng6OxZQMbHJH/MwR7JeMg?=
 =?us-ascii?Q?LWZ/y+dMaKFbswy1dTnt0ti99GJyRC819fCVXpZJFQb3Ehv/BGAVkumbw+Sj?=
 =?us-ascii?Q?/Y6hkpaKxDBpcmeG8rYu2wHRyz56Z1LHvOlwRxkHQlKh4C1NaMC/tA7GneLq?=
 =?us-ascii?Q?rtkH8MYEpX8ErqAsVevdzjedZakyzMscmCT+Voa2J2WsCkYlVMEd5sIoulmi?=
 =?us-ascii?Q?F7MFfM3S2ixhZwZdfdp+dYQ19yexbPRwVEMBXOANd5qehvGNRpe04KvOcNIA?=
 =?us-ascii?Q?+9S6IL58Rxqe7b9boOCPuQudptJeEJkYw8CemCkLVbFO3/7f/z58eoETDo8r?=
 =?us-ascii?Q?eu/aUg+PFQ8pil8v63jwGIC6i0ftKKQywhiDTpW8DiB1rmfN3XAflOy2KNNI?=
 =?us-ascii?Q?vmEgWS85PJo+Gi9+g6ZQCfOwW0ZJL5Oa+7+BBl35pbI1qoGLsBpVAXsITQVG?=
 =?us-ascii?Q?bzaTypULefQUSRYI43WN7WFKRAKaJqLYWVCjer0KB8ojchi7iOumJfqdvJaV?=
 =?us-ascii?Q?O/kZvW0KJmFfVmJCXFLLcSAKvip7dfgk121d1k/DKbrlasiAfhEJCbkJBFrV?=
 =?us-ascii?Q?XMXc+IHmwcXTJY/CsFqFUl9WXoGCka0ZjaayUCDx4aekvEISY9hCjU5SrfAp?=
 =?us-ascii?Q?keF9Ekr3AVR74dIZGA0dvUOiSIrz0DCegx1gvJDrMNg6Lac+8+yaT88CDpVL?=
 =?us-ascii?Q?R9V0dNi6IrVDJGOB3SB94Tv7jORRJ1dVclcGEJQ8rPeuFMlXEyiqErkZW1NM?=
 =?us-ascii?Q?2OnRZVhmerC3DotbcHO9QiZoZMsKudzvmFmVXFoEpAVawYGf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	vgiRm4JwlaPB+Xlf3VTvCgu0E/RboyJRhsW6PgkBp00LUiG2eQXSTnWuIzZS8yYdxw8tgTN4gFQK8Tj1HK6hAU/vcHyw0OViXg3ola3Ywxba1IH9F3swhJufa1iIZL9npKTcYhxr1XGba+P5cLGjyRDPEUvfsx0cFTbduyZ2SUNbw132o+AVa/tRKTreMeA2FhXuqzJJmRDhunrBsRXNYBsrm2uLvKnFZFJ2UZpDfmW3Hw0z2nEv+QjOrirI/UFjDyvJ0MDFlZSaiEIVHuAM4I1tDYTMXq3XVRkkKW8/WragQqevade40MCkzuct3GmYhz62aF+oxhR+OkjWZTDekw==
X-OriginatorOrg: lenovo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSNPR03MB9538.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ddd20a1-d225-4b6a-374b-08de92c5d072
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2026 03:45:43.5866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5c7d0b28-bdf8-410c-aa93-4df372b16203
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y1kYMutqqdO/fvPeKPWKjhe7Lhu/rtkhgmXZHqzzJ6nOV5N8llKZywa9mk3q7Kyixc6DCls+ktI5JLNyFVSgaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB7092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA1MDAzMiBTYWx0ZWRfX0pMl8rpiJuAr
 vpBCwrIrDz7sTKhrJ6gMUPMDjkhtijFZXL5Yqr2mevyzSRDECIWBSL0Bty/iiUq+htqTABMneAC
 yHqPPIhwaC/XgHzlolS3MT6j7bOOX/ScWp11AwUoArXp/53dirvBCUKToEZPyp5A+QHmOdHQHUt
 fmXwD/94zblmRO32hsWlru7USkyzc5Xd7/fwkJmL5rgPwx8eeyZmxZRrqYdxwqRxt2T0AvNbbTY
 g8ZG1lAGV+lnRNIkDd034pslBhO/x2FcVhLZkJW2AN2g8UbfCbGMa0cczhYMHXToH6O+SYfsotu
 4Hi98Dcq8JLD3zKxNQeLOLm/gxcYnAzrb9cu6PHA3Rp9Xk1XlbO12IjG2W42iTrqChTcd33A7yf
 Ba4Q+QcXu/UBkU2CzuVH7J/lZc+0KYEhXpef2b5rIdhbTfso+7cKjoWifKFvJdGbbji56abUMGI
 tYEb/MF/x0iTXe+8u+g==
X-Proofpoint-GUID: FVbRLmf91NJoKKG9L0tUMIRyS6qZ2Q2c
X-Authority-Analysis: v=2.4 cv=QpBTHFyd c=1 sm=1 tr=0 ts=69d1daeb cx=c_pps
 a=Qj2SXdm9e47dEnvLI+3zSQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=2RTuljz969oO5usasWGy:22
 a=QJilI6ASod0cdCKXAsqI:22 a=8k6WQxmsAAAA:8 a=PGvEMCpmBVvAWQNzIMwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: FVbRLmf91NJoKKG9L0tUMIRyS6qZ2Q2c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-05_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 adultscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=-20
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604050032

Fix a typo in dax_copy_to_iter where "vfs_red" should be "vfs_read".

Signed-off-by: Yahu Gao <gaoyh12@lenovo.com>

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
