Received: from esa1.fujitsucc.c3s2.iphmx.com (esa1.fujitsucc.c3s2.iphmx.com [68.232.152.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AB020298A
	for <nvdimm@lists.linux.dev>; Wed, 14 May 2025 07:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.152.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747206002; cv=fail; b=PE0t69NDKHdCvHNxVPi9aSO/gp3OLlJFgczZdJy/jDXR9n3S/zF3zUFpG3ZAroNACo97H8t/A4hC5VhD+Lqkl0EB9RTy7ce8jpBQJkherdk8KDNd1nXoarhp0rdvg8FjUkQQSackO76Ku+uyBc2PTRRGlx3AtkJhQ0PNOr650A8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747206002; c=relaxed/simple;
	bh=cpI+xKoVioKkvxtWDXzl5ozc0XHufyt+Mvh5Rne8Oig=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TQBMxgIsKzJJLopgQ++YB5xjfZVa567TjNa8+DeqvEPLDrikKr4Zsm/k61nQTnhtK0ded067lmMO+YcKZYoxSNCrzNSFxP1i9eESHSrSjx6eRwVxzBUuyHj8+hYt2aEqmRHfN7eB2WkC2nK+DHy8WXZFfTMQuLhNctbH2moE9jM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=vVrVuPy3; arc=fail smtp.client-ip=68.232.152.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="vVrVuPy3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1747206001; x=1778742001;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cpI+xKoVioKkvxtWDXzl5ozc0XHufyt+Mvh5Rne8Oig=;
  b=vVrVuPy3+dmszmlqRwiU7YWu20rnqKSCtxL8B2696RnefbqvdETQsbCU
   YOSC5t5NDLrQnHPlUcDYny60gmCXnIH10vZ2GSgF5gY3FKXqJCZ8OjpdM
   AGZpmEmarIPy2+qV1shu/oDNVrlyGYzt4kT4IbdgJLOnWHxIk5S012dKH
   oMd4amae3us8MvTIgd568bFaGg8713Cd0VVWWd8f0xCwwPWS/bFcKPSXt
   DZ6pz4wD8q02jcA5qlaUnnittwahzcsQgELVfwGDqvXkHyxtennLqbkmT
   8Noh4j3Ad6WZaoBvSubmcuVrnXX0tUIuDomgwGAcmF2bhdnN3jm/lvEkF
   A==;
X-CSE-ConnectionGUID: pbtgMlG/Teigwibf6FspDQ==
X-CSE-MsgGUID: icfC+39vTDGlhtG4KaVtcg==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="66464465"
X-IronPort-AV: E=Sophos;i="6.15,287,1739804400"; 
   d="scan'208";a="66464465"
Received: from mail-japaneastazlp17011024.outbound.protection.outlook.com (HELO TYVP286CU001.outbound.protection.outlook.com) ([40.93.73.24])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 15:58:49 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j2BgFhPyqZE+uC6sm99y2pDLAvcMXkNVmVZ+ABmYABHu2J0d2j0SGRpCZFeBC4qnK6t1wvmS/eGtWjR2YPGTCnbwcO5qrXPEjpVUEoKBfnyMyNeodReYe36xvVZZ3C0Wz5rVQel7/bC3T/FF2+qphLFRAt0EqgFVMOx9QLCCAbS23u08wgBMF4qW1BoCYVZUh+Qg+lUJ1+DoaxuQoOFTeiBc2V5x/3GHwDTai4Au1WSoiUYYU7lKFIicH367xLSFmne/KdSg5HaHGenCKCPFFtdT/C/30keZ4wXqQ4KOPge3Bdbx2Qnjmirnq1VmvzUshn7OrGAV56imlwu3rDB/Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpI+xKoVioKkvxtWDXzl5ozc0XHufyt+Mvh5Rne8Oig=;
 b=sENmETmS+c5Kf0qFxF+Jn7D4yfozrfl/g617S1zPzKB6dNy/xXTE2ewG3W1Uf3eXE7yOALSnZ4dQP7fS1Pu8lj2axeuqmAP/vIA4NOStGQMEHTRjOtS4zV52SpJtLFrG7rB10wmu7oA2K6nbx8qCuVdegMlGCpQ1aykuvypnLnV8ImV0ukbV0hZmYOS7vNgUqcuDPYFxRgIM1ATBBw3yxc8hP5dVGTnmzs/61CtWk3aBqia6gI2L2AtDFDDQIm4ZVBZtvq8LeVIQevGAhDPxcjjnNimAWp7O4mCiYeHMykZDHS3H6j4TXZf5XQV2Oard+P25VfsljDKhCCYuEBK8LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by OS7PR01MB11551.jpnprd01.prod.outlook.com (2603:1096:604:23b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 06:58:45 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%6]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 06:58:45 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dave Jiang <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "alison.schofield@intel.com" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>
Subject: Re: [NDCTL PATCH v2] cxl: Change cxl-topology.sh assumption on host
 bridge validation
Thread-Topic: [NDCTL PATCH v2] cxl: Change cxl-topology.sh assumption on host
 bridge validation
Thread-Index: AQHbwFoEN9E/yUTA10GYYY0eLzYpsLPRuo8A
Date: Wed, 14 May 2025 06:58:45 +0000
Message-ID: <1a69ac7c-7a8e-4351-b07f-642b39208c84@fujitsu.com>
References: <20250508204419.3227297-1-dave.jiang@intel.com>
In-Reply-To: <20250508204419.3227297-1-dave.jiang@intel.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|OS7PR01MB11551:EE_
x-ms-office365-filtering-correlation-id: d5bb6180-cc2a-41e0-70c8-08dd92b4c510
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?MHhoOU45aUQ0T2ZuZ3lLQ3h2Qk9qZkNJNXAwV1VkQmpPYmFlc0ZWS0ZFNlJ2?=
 =?utf-8?B?azJpQ0ovRTlmdDlSSlNmQjE0MVlqQzlqT0Y3dTFoNjBzbUE0ZXE2UUZYRDNW?=
 =?utf-8?B?Mmh0bEZWeFdqUUtiMFI1cTBsUXM4aGFZOTl1ckRTZ1ZoMElwM3k3aTdsaWo2?=
 =?utf-8?B?bUpRWFhvWnkyRSt2OXRHQVMxWm8vOXlSNlVvUStObnR4RkxiRVp4OXJuK3dW?=
 =?utf-8?B?Qmp5Q015TjcvN2xKb2dBT1kvcjA1OTlyM1FOajFLdFhsSzgxOVhpTmFTK0Jv?=
 =?utf-8?B?MVBDOTFkMHZ6WlE3bGJDNzQ2eWxqdy9UcElnd3FXMTVNdTNMOU0yamxCQzAy?=
 =?utf-8?B?M1JiQWRxOThFcHYvWjZKUTkrdVVPNnRybW9hampkcXg5cGk3eHM5ZnZnUUlr?=
 =?utf-8?B?SDFDeFdtQWs2WG1IZXhFN3R1QXM4Z1VhOFlpWkRKSjMxbUxpQVVCZ2JPWWc3?=
 =?utf-8?B?OXZXTS8vdENaOXVDTUFwN0MwRWFuMHdPS0padklJdU8zWnVTc3NSNVRrTGZ0?=
 =?utf-8?B?emlrTStJZWtiaEw0cVFNSTIwZ0RyY2RHYTZIS0o0V2F3K3RnMXdna2FrckRE?=
 =?utf-8?B?aFU5eG5QZFl2SnpHVTVMQ1VHcm02V2JjbEx4S0Z0OXpXUlZrZm04MGVyOGVp?=
 =?utf-8?B?b2U4V1ZyR3ZpUEF0ZVZuVkI2WHNmMzQ2VkZLdGd2S2ZPMUhjaE9YOFJCdi8z?=
 =?utf-8?B?aWtMVjhhVklNalRSWVArRVA4aU5qS1JTb2ZmSUdKclMxWkNBT2VKTTk2MWgv?=
 =?utf-8?B?QXB0VlVTekw5YTJwRVdRdnZEeTZ3alZKbFFPWTBpRmR1TkJnajVmVFhyNmdj?=
 =?utf-8?B?MlI5MzVIQUdCS1k5QnBzYUxnWVFEeWVLOTdFb29DSm5Udm9KYTZHRkgvOVk5?=
 =?utf-8?B?cGlFMTVCNTJ2NDA2V21KdlJXVzJXWTlFbk8vckc4ZkFhbzV2MjVLenRwOXQz?=
 =?utf-8?B?bytTM0p2YTRNREUxaUZNMVVYYTdiU2RBVGx5WE9uajFNTmFIeGdRUlM1MlVj?=
 =?utf-8?B?dHdCY1RhVTRTOUZqa2c0NGs4UTJGd3BwVXRTS29hSkN1Vkd5Tzk2YUNhZmdz?=
 =?utf-8?B?QkMwYzltT2VXY2J5d0VFcVZkcHdhekdhSGVuTVp1QytqODgreFloMWo2d2kz?=
 =?utf-8?B?Tng3YzZ2V3d5YjZkenUxZjJqanh6Z3I1OXp1Z1Y0ZWFkdGIrQVo4dWh6SHdW?=
 =?utf-8?B?L0lqNkRibkFlZVpIWEJCMWlJbUQ2eFJxK2I1WDdCZU1JQnBYVWFYMmE5ZzVs?=
 =?utf-8?B?VXg5eGtraHQ1cUxaS09DQUhjTDBIL0l5SUl6K3JjSVBhamNRS1JHdkNLTm9a?=
 =?utf-8?B?OWhJN24vUHFsM0szb2JCOHpLQkRySStHcjhpL3JFeEtPNlcwNjRUbnJkbUQx?=
 =?utf-8?B?OXNxNWExZTN3K1c5SG41LzdLR1VUSFQ0UDN1QkJBNmZKbFhMWVJ2em5uMFZ2?=
 =?utf-8?B?ekhINWwyYjU0RDJ6TTBUTkxVT3ZKbnpJSjZJcTEzUzV5THQ4YXluTElLUU9W?=
 =?utf-8?B?VGNsRWwwTHFWNCs4OVhtTk1ZR2hwL3dtWmZ3NjFvb2FUaEIyNjBHV01TdS81?=
 =?utf-8?B?czFiNXdtWk9EQmNUcU5lYWl5RWJjc0Nqek5pcGtlQzc2TkNrM0N2TUNMcUo2?=
 =?utf-8?B?M0dqR05lNHVDdkU1dlB5RjVvYjFsbkoxZHBmTHQxUHpkNjBqU1poTjk5WWhj?=
 =?utf-8?B?SzNiWUhGa2wyN3ZEM2ZMNmJxVzNDcEdtU3VURzJPZGxVTmgzZy92OUtwT0Jw?=
 =?utf-8?B?MFNGa2ZqVjcyV1FBaUhNZndqQjNIS01RSHZmWE5IVFNzTjF4cjNweFJoRjJZ?=
 =?utf-8?B?SEJsUHlvVGgrQS9DTklXWmdSd1lNNkVGMWlCMnJiYytodFh1Y01aeXBkWTJv?=
 =?utf-8?B?YjZwamQ2U2pzUDNaTFJOMExqL1dlOG4ybk85M3RxWXNTYUhGTjdQVFZQK0R2?=
 =?utf-8?B?UW5tMG5FMHAvUU9HeXJZU1ZNYVI5bmtjcVFCaVYzeVdsL1ZxVnBrZ01UMHJB?=
 =?utf-8?B?TlkzYktLRmVVaWJuMjBKckpZWnd5RWRxeWhBNmoveUJ4cERtdVdScnFqTTls?=
 =?utf-8?Q?Bc+aWw?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dGk0V1FOUkRJeHFsbHVxaFhONFppVjBkYXliR3IyaURjajczQmpOTWtpWENv?=
 =?utf-8?B?aGZZekkvY2swTi9renMvcXVsbUg4OEdSaHc4VGlzNGFuVGxnSjJLaDVrWERj?=
 =?utf-8?B?M2pFcktsTDNRbVJwYkRFNlhqaXFyQ3RnZ1hrcGMxak1wV0Q1OUU1Y1l2WWZj?=
 =?utf-8?B?TEdXbkJVbWtuc1lhMkxpK25YbGtxeUV6bmdQQ0tlMnB5T1hKeTk2TFUwVm1G?=
 =?utf-8?B?VEFQbFQrVE5mejI2bUlyUldtbUtHbDU5LzZKdFlJTDlBUEdzNFVrZDVwMExW?=
 =?utf-8?B?akdCalZQTGVFSGhrK2RsUE1hYWZkZEgzVUZONi9tSUg2SEgvaXBMaHZkdlFr?=
 =?utf-8?B?VC9OYlFMTHgrZ0Z6ZGJHVG5qdEgvbDE4Qm4yakxsNGhsbG8yNHU4SE5sTzVj?=
 =?utf-8?B?WDhzaklNVWRjb09YdU5nUElQNlN3ZGtUR1ZUUEp1QUhzVDZlb3F4Y0pmZzlY?=
 =?utf-8?B?d1VXYURrMWFibGhmMlUvVTFvdVpNUFNLQllSdzk3TUtTcWxOaWtpcTJRN0lo?=
 =?utf-8?B?elJTR3Z3Ym9HNjdFUmZnQm9XZGwwbzBMdmppVDdMNHgzMVhVYkhIZk5NSWNi?=
 =?utf-8?B?YU1USEdJWGVsOFVCelYxbWpSM0Y2bVZpWGg0QWFEYjVaSFZiL3dvcWRBOTFn?=
 =?utf-8?B?cU51eVJEQWtzMXo0aHA4elJlaWkwL3BTdi95bW1EZHpqODIvSWtzSmxsNjc5?=
 =?utf-8?B?Mm9GRWxHNHZUUERmNWphcXQ2VXJVRmtIcHhrTW1kODRGU1BwbXJvTzNubFFR?=
 =?utf-8?B?WGNvaU4vZWgvMFZIaVh1bi8yUEt5bytNS3U0ZXQwSGdicW5kWUU1ZzVHNjRz?=
 =?utf-8?B?SmxEUDIzZUtKVk5ZL1JOaDBKUHZoZ3dLSS9wL1JQS0FLUjRMTXUrQThRSENr?=
 =?utf-8?B?blZNcjRkclVtZEx5UzAzTGh6QVcyMEs5VU5IbDlzUHJFc1dlTCtadVZBNS9B?=
 =?utf-8?B?djl3c3pHZ0hNQytpd2RPSXBwN3U2cWdCUHhHazgrbWgzVWZVRmdWeE04N1Qx?=
 =?utf-8?B?eTY2QkdKZDVoL1hVVnZFVnJ5ODRmeGQxT2ExVW80WkxvVXpHYSt6UmtENVJn?=
 =?utf-8?B?QmxLOGUrWEVlMlBQVDJpUlgyNTNSU3l6SVlBTTJJejVycU9CMkZEYjJzNFRL?=
 =?utf-8?B?ZTJ0akJ2Y0V6ZEVld3djNEgxTkFtSEhhMGM4YmYxaWZZWnZKeDRIWG1LK2NK?=
 =?utf-8?B?bTRsOEpIanNIMlFYOTk0eU1pMmE5c1JhTDZML1k5MmF1ZjlpY0Z5OTNPc0lF?=
 =?utf-8?B?VzVtMHpyakZjcUllRlV3M2JqSktnTGFCbmpURGFtbkxVbnJ4NGNwNFIvM2Y3?=
 =?utf-8?B?bUFPY05LZ3lQUVpQM0RXYkRleVZLTEpiVTFiZklMa2IySWVuSE5CbEw5TkhY?=
 =?utf-8?B?c3FrR25tR1hkaGV0dVRZRVRwN1U3ZE9XTHlLOTZxSkVpU1UwSjlKV0IyM3g4?=
 =?utf-8?B?eGNQRUdYdmZtbWFIUDlYVXRZMmVvbVMxZysxUkRmTzFtNEdHbkk2YVcwcEh2?=
 =?utf-8?B?RjdMRkwrWkttRTYrZkpmQmRvN1dGMnhQSU9sbXdnaDJVbGtCUkxLN3ozSUdV?=
 =?utf-8?B?cW5ic3RFdUduTmVSemtsQTVlYUh3djhSSlVFRHEzM2N5bnV5L3F6by9IQ1Fv?=
 =?utf-8?B?OTExQjJyTWNyVkRvc3JvOXlrazM3WTJpR0VUSW0zVHM3NlpUV2hjMUwwckZU?=
 =?utf-8?B?TmdqMURaOEtPQ3VXWFBVVC83dzNUSURwZEpqUVptaHp4c2RjQm5QTWw0c3VC?=
 =?utf-8?B?SnZmbGhwUXJxUlJqWE9WYXFqTVpKaDlWOWZrWlJhdkZFNHFtNDhud3NMUXh4?=
 =?utf-8?B?VUxMY1VIYWJZRjhoUG5IZkt0MzZCR3kzbTNxaGJwTHRsMUpidVlGLzYwbzlB?=
 =?utf-8?B?dWw1UXRpeFphR1lXT2dheS9pNFBVVThMUU96V0xXc1k0L2o3eFFqUUVieWlL?=
 =?utf-8?B?ZnVpVW9QY0ovRGxpSVJwdjhkTFFCWDlNMCswa3V6WXI1Rko3SVU1aWVNaFdZ?=
 =?utf-8?B?YjlOZUM5UzRkWjZ5bUZNaklqZHNoS3Bkbis4d3FvOFEyVWVoUVJhNTVXd1dZ?=
 =?utf-8?B?WFhzYnZubW1VS3RMb3A5ZEJ1eGNnaG5Sb3FzTzN4ZjRqSTl6aHkzZWZ2MVdR?=
 =?utf-8?B?RTdVN3NwUGdLZklEc2VxdEpISGt6MkpCaW5TTEpCbnExM09KM0dCRE1PRGlV?=
 =?utf-8?B?K0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F6F9E84BEE01104480AA639E635FC02D@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4cLf5x+dXwvBzItcol9sE+HfHGzG2DBXVecNYwNgCq4CgH5dsQiCyH8o09CYLSFuPtgezRw2sQKB6PXpovqF3cOtDq3v9gJIfhQYdKwppE3xnCkLxuHeQkegJL9zn0BdMgMPOes36oWpOQWAwQzMhfnwRetI4v6FNh1igELKA05yfuauuqicuyqUcKQ40cqS6669/qp66MUUZB6bQHj727mxXshB4yhuEcIztvsCZWVgX5eqkO7DnIv/qMXRaXkoV3q3YT19xbgBIXDhS2fMBPPMSlYrsIYCJHAylEBecbgZZbYgOPNnN+7i6sX5K/623jr/SnWciyYtHOzzHdWfJVpfza5/lW6QmzWO9KNlyjglQvKjDG+kFPJAuqrAiGHk+8GmRKMo6aTJGYj5M6XzYkmoOmP1BMIabRQ0KqCznnKSdyEg4rXZFtB9dEpfjxBKeHrte0TPIT7oRrU9eJRY3+HtPcU7c6ewL3hYccFBkl1RqxwIPQo3DXYjd8C/p9PBOaxn7z11qjKXWfU+fOICzJaZ5azYJzYr3LOtfeUt/GeadfZf2PbLqR8taX+2Ee5Kpy9sKQ4xu1luzQJy10n+s8t6ExsNN2fWfjQ6BXU0q5sdu3UsyRZ2RLtgpxsZbrU1
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5bb6180-cc2a-41e0-70c8-08dd92b4c510
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2025 06:58:45.4208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NcJY1lWcXzu6prPbadpcBuG8cH4I9wOu4JEveyMDpb1ybe+WlvX6p/7OpCaoSoQdjYHNNv+oFxRE55dvqpMAGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7PR01MB11551

DQoNCk9uIDA5LzA1LzIwMjUgMDQ6NDQsIERhdmUgSmlhbmcgd3JvdGU6DQo+IEN1cnJlbnQgaG9z
dCBicmlkZ2UgdmFsaWRhdGlvbiBpbiBjeGwtdG9wb2xvZ3kuc2ggYXNzdW1lcyB0aGF0IHRoZQ0K
PiBkZWNvZGVyIGVudW1lcmF0aW9uIGlzIGluIG9yZGVyIGFuZCB0aGVyZWZvcmUgdGhlIHBvcnQg
bnVtYmVycyBjYW4NCj4gYmUgdXNlZCBhcyBhIHNvcnRpbmcga2V5LiBXaXRoIGRlbGF5ZWQgcG9y
dCBlbnVtZXJhdGlvbiwgdGhpcw0KPiBhc3N1bXB0aW9uIGlzIG5vIGxvbmdlciB0cnVlLiBDaGFu
Z2UgdGhlIHNvcnRpbmcgdG8gYnkgbnVtYmVyDQo+IG9mIGNoaWxkcmVuIHBvcnRzIGZvciBlYWNo
IGhvc3QgYnJpZGdlIGFzIHRoZSB0ZXN0IGNvZGUgZXhwZWN0cw0KPiB0aGUgZmlyc3QgMiBob3N0
IGJyaWRnZXMgdG8gaGF2ZSAyIGNoaWxkcmVuIGFuZCB0aGUgdGhpcmQgdG8gb25seQ0KPiBoYXZl
IDEuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIEppYW5nIDxkYXZlLmppYW5nQGludGVsLmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5j
b20+DQoNCkl0IHNlZW1zIGl0J3MgYSBiaXQgbGF0ZXIsIGFueXdheQ0KDQpUZXN0ZWQtYnk6IExp
IFpoaWppYW4gPGxpemhpamlhbkBmdWppdHN1LmNvbT4NCg0KDQo+IC0tLQ0KPiB2MjoNCj4gLSBN
ZXJnZWQgVmlzaGFsJ3Mgc3VnZ2VzdGlvbg0KPiANCj4gICB0ZXN0L2N4bC10b3BvbG9neS5zaCB8
IDMxICsrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwg
MjcgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS90ZXN0
L2N4bC10b3BvbG9neS5zaCBiL3Rlc3QvY3hsLXRvcG9sb2d5LnNoDQo+IGluZGV4IDkwYjljOTgy
NzNkYi4uNDllOTE5YTE4N2FmIDEwMDY0NA0KPiAtLS0gYS90ZXN0L2N4bC10b3BvbG9neS5zaA0K
PiArKysgYi90ZXN0L2N4bC10b3BvbG9neS5zaA0KPiBAQCAtMzcsMTUgKzM3LDM3IEBAIHJvb3Q9
JChqcSAtciAiLltdIHwgLmJ1cyIgPDw8ICRqc29uKQ0KPiAgIA0KPiAgIA0KPiAgICMgdmFsaWRh
dGUgMiBvciAzIGhvc3QgYnJpZGdlcyB1bmRlciBhIHJvb3QgcG9ydA0KPiAtcG9ydF9zb3J0PSJz
b3J0X2J5KC5wb3J0IHwgLls0Ol0gfCB0b251bWJlcikiDQo+ICAganNvbj0kKCRDWEwgbGlzdCAt
YiBjeGxfdGVzdCAtQlApDQo+ICAgY291bnQ9JChqcSAiLltdIHwgLltcInBvcnRzOiRyb290XCJd
IHwgbGVuZ3RoIiA8PDwgJGpzb24pDQo+ICAgKChjb3VudCA9PSAyKSkgfHwgKChjb3VudCA9PSAz
KSkgfHwgZXJyICIkTElORU5PIg0KPiAgIGJyaWRnZXM9JGNvdW50DQo+ICAgDQo+IC1icmlkZ2Vb
MF09JChqcSAtciAiLltdIHwgLltcInBvcnRzOiRyb290XCJdIHwgJHBvcnRfc29ydCB8IC5bMF0u
cG9ydCIgPDw8ICRqc29uKQ0KPiAtYnJpZGdlWzFdPSQoanEgLXIgIi5bXSB8IC5bXCJwb3J0czok
cm9vdFwiXSB8ICRwb3J0X3NvcnQgfCAuWzFdLnBvcnQiIDw8PCAkanNvbikNCj4gLSgoYnJpZGdl
cyA+IDIpKSAmJiBicmlkZ2VbMl09JChqcSAtciAiLltdIHwgLltcInBvcnRzOiRyb290XCJdIHwg
JHBvcnRfc29ydCB8IC5bMl0ucG9ydCIgPDw8ICRqc29uKQ0KPiArYnJpZGdlX2ZpbHRlcigpDQo+
ICt7DQo+ICsJbG9jYWwgYnJfbnVtPSIkMSINCj4gKw0KPiArCWpxIC1yIFwNCj4gKwkJLS1hcmcg
a2V5ICIkcm9vdCIgXA0KPiArCQktLWFyZ2pzb24gYnJfbnVtICIkYnJfbnVtIiBcDQo+ICsJCScu
W10gfA0KPiArCQkgIHNlbGVjdChoYXMoInBvcnRzOiIgKyAka2V5KSkgfA0KPiArCQkgIC5bInBv
cnRzOiIgKyAka2V5XSB8DQo+ICsJCSAgbWFwKA0KPiArCQkgICAgew0KPiArCQkgICAgICBmdWxs
OiAuLA0KPiArCQkgICAgICBsZW5ndGg6ICguWyJwb3J0czoiICsgLnBvcnRdIHwgbGVuZ3RoKQ0K
PiArCQkgICAgfQ0KPiArCQkgICkgfA0KPiArCQkgIHNvcnRfYnkoLS5sZW5ndGgpIHwNCj4gKwkJ
ICBtYXAoLmZ1bGwpIHwNCj4gKwkJICAuWyRicl9udW1dLnBvcnQnDQo+ICt9DQo+ICsNCj4gKyMg
JGNvdW50IGhhcyBhbHJlYWR5IGJlZW4gc2FuaXRpemVkIGZvciBhY2NlcHRhYmxlIHZhbHVlcywg
c28NCj4gKyMganVzdCBjb2xsZWN0ICRjb3VudCBicmlkZ2VzIGhlcmUuDQo+ICtmb3IgaSBpbiAk
KHNlcSAwICQoKGNvdW50IC0gMSkpKTsgZG8NCj4gKwlicmlkZ2VbJGldPSIkKGJyaWRnZV9maWx0
ZXIgIiRpIiA8PDwgIiRqc29uIikiDQo+ICtkb25lDQo+ICAgDQo+ICAgIyB2YWxpZGF0ZSByb290
IHBvcnRzIHBlciBob3N0IGJyaWRnZQ0KPiAgIGNoZWNrX2hvc3RfYnJpZGdlKCkNCj4gQEAgLTY0
LDYgKzg2LDcgQEAganNvbj0kKCRDWEwgbGlzdCAtYiBjeGxfdGVzdCAtUCAtcCAke2JyaWRnZVsw
XX0pDQo+ICAgY291bnQ9JChqcSAiLltdIHwgLltcInBvcnRzOiR7YnJpZGdlWzBdfVwiXSB8IGxl
bmd0aCIgPDw8ICRqc29uKQ0KPiAgICgoY291bnQgPT0gMikpIHx8IGVyciAiJExJTkVOTyINCj4g
ICANCj4gK3BvcnRfc29ydD0ic29ydF9ieSgucG9ydCB8IC5bNDpdIHwgdG9udW1iZXIpIg0KPiAg
IHN3aXRjaFswXT0kKGpxIC1yICIuW10gfCAuW1wicG9ydHM6JHticmlkZ2VbMF19XCJdIHwgJHBv
cnRfc29ydCB8IC5bMF0uaG9zdCIgPDw8ICRqc29uKQ0KPiAgIHN3aXRjaFsxXT0kKGpxIC1yICIu
W10gfCAuW1wicG9ydHM6JHticmlkZ2VbMF19XCJdIHwgJHBvcnRfc29ydCB8IC5bMV0uaG9zdCIg
PDw8ICRqc29uKQ0KPiAgIA0KPiANCj4gYmFzZS1jb21taXQ6IDAxZWVhZjI5NTRiMmMzZmY1MjYy
MmQ2MmZkYWUxYzE4Y2QxNWFiNjY=
