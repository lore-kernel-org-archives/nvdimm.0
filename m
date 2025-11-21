Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652CC29898B;
	Fri, 21 Nov 2025 09:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763717702; cv=fail; b=bRINFylSq7dZ+qoGWpkKgbQNn/JL0cv5ZmZZGoBuVdSo9pWN/6Ixz6ukN2J+nvr71/nyZsbLzwx7tuOdAnpWtYsqsjsw2rNw4gaazY9aT5mtPEEqzQWrFC2EhwaXAku2PXx5CveAHCuksF8v9xq5fT+CuRhVtYV0sS6G/oezfv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763717702; c=relaxed/simple;
	bh=46CnSbH2Y89VqsBQpPiiXeN37PA2h7KN1TY2yBFtIT4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y4lZsw2+y2XwbIC0lp/Nq8kLfMDAkc/Jlk8jVc0ORIugoN9QUoVksPRZAHk3f13RHL7uWHz2G6nK1XPIFFmAQBKDOP1bZA+vylBGnF3949VT3e4BgNggZyuYJ7ZeWfxCGKAZ5qIIKZgg92G8+FM4CPIGWyBXklh6pw1iovV3v80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lzdGUi+J; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Hv+QlElf; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lzdGUi+J";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Hv+QlElf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1763717700; x=1795253700;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=46CnSbH2Y89VqsBQpPiiXeN37PA2h7KN1TY2yBFtIT4=;
  b=lzdGUi+JUe2cEHb4AEJ5YO2PlHfgL/6Hf+6V83y5xO0Zldiw5PT0uSdS
   J0ELbUqY3uj9yDASjP9kFJ7VNuw7VvstIIlZrXXnQ6J/3blGS1qjQ+bzg
   0tyd3yljimTerI9lResMUKN/Bg5xlaw/fRwdTfx3DL7JKVFKh0Et0AkdB
   DwkX3EH92CKipmVvbCej1L4Y7k6Fkju/wohZ2Dbt+hspkzGqfUatqpF5b
   9iWGRdtxDtwGrTVO0hB5VR3EdCorgZrWiOvJxCTsWG/N4V9WymnZVyZDu
   /rB6j1eaR84vNw9j4vVbPES2lXz8AHhcbBAe0K+bnRCAXJTSg4Zv3TfmT
   Q==;
X-CSE-ConnectionGUID: lqucEsI3RTipxz5IzXsIdg==
X-CSE-MsgGUID: 9LN4J9niRfyDzVqOKrp9aw==
X-IronPort-AV: E=Sophos;i="6.20,215,1758556800"; 
   d="scan'208";a="135533109"
Received: from mail-centralusazon11011005.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.5])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Nov 2025 17:34:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F8VdhfA6oywSC2CD846gKhKBOED1DfMv2JldYzhAkISFmq5AYiF9eKlwz4Wfm5K8jjIl62Tr5kaiKQjXexr33IrP4euO3vXb6mIgPBi/ILBek2ueiHPsh80uqPNWLn1OTuV36da2TpI+eHsBSZcg+6IBNkv6atPIrZ0MIKUYOxpmSqfSigoA07ikTS2YwfHxt6RIuAnO6NopJHgyy9M2mRh35qoQxvaHxuVHhrpQX63tE/gPwUtO3V6HgZDyOin5NOEm2QMfweYn6qh81DMw3b4+DbCXmPYnHpmSx98ey/NIGKO4ntTatZOKyTwIx48d9qT7eupovofRrvCGoAJJ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46CnSbH2Y89VqsBQpPiiXeN37PA2h7KN1TY2yBFtIT4=;
 b=jD3W8hELvpkDJZ/O9/bbVOWCn7oHdcWSkX6m9vIB1tcLDTqh5jfQkZMI+fq1SZQ/h9Uscs03wDY04NdZ2vvRRWlVeDty45MjR4HRg8kh94dzZBhym8nN/Vv2eu7QqXfY4R8Raav53pTrtHFpnYUVUznFUcZr9Yyz1ys2JYVz7P91nZw2bpF2W7If0oUaZxIwDR+l444EuhAs5yHaa2Ffk1tZXY+JrPd1BidsKoGYezjFYWoJSeJ7kt4kq3j/kXn0qmHXZ0btluxZHthYRllwveGM530d8kneGJOo7Gtqz/60KyxIv1xK6lDodU5cJgBvNFuB8sO3GvnT29wZdvkC4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46CnSbH2Y89VqsBQpPiiXeN37PA2h7KN1TY2yBFtIT4=;
 b=Hv+QlElfCLDM0NEZYgCdu7YeLrKmar18WxwMZd1EK36Iis/zq9MYixr9CM5hB+62QduQdphORF5LK4MOloXUvouSEAKUirKDfSe2jw94LYYGzZyAgogn5TmoWjSqIkbkF3uLg+CQy/fjGAyMIbS1cgzrVxdw9WIRNIpv4QUfYxE=
Received: from CH0SPR01MB0001.namprd04.prod.outlook.com (2603:10b6:610:d8::5)
 by SN7PR04MB8740.namprd04.prod.outlook.com (2603:10b6:806:2ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 09:34:56 +0000
Received: from CH0SPR01MB0001.namprd04.prod.outlook.com
 ([fe80::1425:795e:ebac:cf71]) by CH0SPR01MB0001.namprd04.prod.outlook.com
 ([fe80::1425:795e:ebac:cf71%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 09:34:49 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: zhangshida <starzhangzsd@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"gfs2@lists.linux.dev" <gfs2@lists.linux.dev>, "ntfs3@lists.linux.dev"
	<ntfs3@lists.linux.dev>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "zhangshida@kylinos.cn" <zhangshida@kylinos.cn>
Subject: Re: [PATCH 1/9] block: fix data loss and stale date exposure problems
 during append write
Thread-Topic: [PATCH 1/9] block: fix data loss and stale date exposure
 problems during append write
Thread-Index: AQHcWr+N8M3IrR4uQ0m4nxlivQrPr7T83qgA
Date: Fri, 21 Nov 2025 09:34:48 +0000
Message-ID: <72fb4c90-0a75-43df-8f5a-154d9e050c09@wdc.com>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <20251121081748.1443507-2-zhangshida@kylinos.cn>
In-Reply-To: <20251121081748.1443507-2-zhangshida@kylinos.cn>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0SPR01MB0001:EE_|SN7PR04MB8740:EE_
x-ms-office365-filtering-correlation-id: e17e470e-44ae-4bd0-f933-08de28e13714
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|7416014|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VkRhYzFqNEdiczlUSkdWU2FROGwvSmlFWERtMDl2bjJRZ1BiWGdWbDFRck4y?=
 =?utf-8?B?dUxIdjBDbDl2TXV1d2dyLy8yS1ZQaCtrUHpWSys5SllZeGI2L0lkYWFNaTNK?=
 =?utf-8?B?TEJIcDZ4Q0M0UnNKREZDQ1pXamNKZ1U0dm0rRGZzaDl6OG1WZ1RaMjhmMGxH?=
 =?utf-8?B?MUVMVVZYelh3MUJtOGFMeGpNY2RTa3FkK21WMFpRUGFOZ3hSWkdzdUdlbXI2?=
 =?utf-8?B?MlNJbmtod0M0S2F1WS9XR0FTSkx0Q21QK2g0Y0JzL1JlYTQrMFhYR2tEcWNT?=
 =?utf-8?B?RVZqSXFLU0RWazg3SmJXNk8vS0VuM204Y2V5bEY1MG9zYUxIdjBDT1JBVUx4?=
 =?utf-8?B?U3RUT0VYbUMyUDlvRHd1dGJJVXVIb0NLdjNnajNxaG9yWHdRM1V1d283QnNy?=
 =?utf-8?B?dXZlRnZucFFLSmFCZG1lNS9RK2pnVnZuNkVZM2dTVWh4cTcycTJhekNuemUw?=
 =?utf-8?B?N3JYN2lIOW5IejZhM1pHT3ZBVEdtU2pLNDlGKzdyUUNUY0V4M2ZlcVhRVnFq?=
 =?utf-8?B?dGRWalo4L2ZLRmVpcE1BWFRWcVNvREZkdlJjeDREaTNmYVNFMGRaK2R5ZGNr?=
 =?utf-8?B?b2NuNFlnTExKNnVLOUx6clZaWHBROGxXMGpwMWU5d2YxSVByYk8rdGE4VnhD?=
 =?utf-8?B?UTUyN3dyelNnNXF3UWQvVmZkNGdRVEZtSm14bzFZWmtFT0RQMUJTcFhBSGpD?=
 =?utf-8?B?dEQwTDh1MTkvQTF5eThMWjJhMHRVeU9hZzdwaDZ1cDdyUXJIU2FaZmJEdzlQ?=
 =?utf-8?B?K2x4YkhTV2g5OTc1b0hQWWdrNVJZTGdTYWZrRUZEbWdVWXF4NXkvaVo5ZlVG?=
 =?utf-8?B?S0ovcW1ZMUxxdFdhSjVnRS8wSitsVkYyUXFZTnRJWC8vSzY4aGFKeVRNaXQr?=
 =?utf-8?B?TTVKbmFTb2JTWVJQTzBDajk1RTRUMVdiRFczSER0TGJKOTNnUmhoN0xKZmhU?=
 =?utf-8?B?dGpuYUJJOGVUTVludUpUWFhnMkIxbW9nTmV2VEVhNy9GdmxBb3Y0TTJzM2lE?=
 =?utf-8?B?YmF2a1UrbnVkT20yY0YyeTRLYkpRYzNxYlFEdDdMdFlaVXgyRms5VFRRY0Fj?=
 =?utf-8?B?dURTL2ZhYXRnU1loNFEyMUVBTGRneDZiVVNkcllTQzJOU3NuaDd4d2JDU1lm?=
 =?utf-8?B?K05HWk5qQkExVVhHSmVXM0tOaElaS3RHTVVMZzNhMUJsQ09wWUpNWTFIb0tv?=
 =?utf-8?B?aFNxbWh6aXA0OVhqU1p6aVp3STFkUmY0WXlNL09sQlBWdk5UOHo5dW5hK1Bj?=
 =?utf-8?B?Mk5HWVRhQWdKZy8zUkR4RnNFVGZoa3FXeXZQcDF5QmN5Ykx0UG9BeGVGU3No?=
 =?utf-8?B?NU52QlRmdlhMcjF2MC9WWUgvWnNTcE1hM0VYajNmVFZZdzFoeTlod1Q4SzBr?=
 =?utf-8?B?NEUrWFdXNzNOM3lYTGMrbzBkMW1qR0NSNnlJSzU3V2ozMXFtT2NUYXRGK0Zz?=
 =?utf-8?B?c0JrdXdsaVJUZFBvNEl0VGc2U1lxY0NpLzFlUHBBK2MzTjRpUk1Lbkl0OXFU?=
 =?utf-8?B?djNmbjY0aTVCWmloRG9US2VjTW9IckNPaTZvNkRMVDRLVCsyTTM4dHpmQ01z?=
 =?utf-8?B?YXpMZ2JJeVFXSmtHNlpKMDh0OUQ0VndwczYwU3U1a2theEpaU0RqdzBUOXMx?=
 =?utf-8?B?SmpUcFpvR3JZU3RNcy96c2pnUlJNYTgvSG5zNEs2bXpPQk15Uk9raXVRRjl4?=
 =?utf-8?B?RUQ3UHpqN2xReW15QTJYaU9FdjB6VjdsVnVnRlF2RmR5RnBoQkptMUhmWGJh?=
 =?utf-8?B?Tjh1b3NjeWxzL3U5RG80b0Z2cVJYREN0MnNXVW1MajM3QStra2djT1dFTzZs?=
 =?utf-8?B?S1BWVmd1NmFpY3l3cG16VnJWN2xDM0V4UHhRdXZmb1dmbnNQMjRqNmgyQ0dN?=
 =?utf-8?B?Ti8wYUt4MnRLUWhiM0xIVjB6M1FZRUFIbmJjWTF4MFZFWkI0andpeENOTStN?=
 =?utf-8?B?dzNwd2ZnUW9tYzdUTlM2UUVqMkN4UUJuRTdDSWptQUxtT2E3MU5kSzJZSHVo?=
 =?utf-8?B?OUhEM3ZXSmFldTU2RG8vSVF2aTFtM0kyK2lEbURxNFordTVYR2FHWXRuY29Y?=
 =?utf-8?Q?UQhQzO?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0SPR01MB0001.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QVZrNllaSFJ2UXZpQyt4YUFJU3FnS3JneC8vM3pvaE9MOEhlV1lMMnZwUmpV?=
 =?utf-8?B?TDh3emIvTkV4NnV0TVBqbmo0UVlNakhuWnpPMHk1SnlWZWJjNTNrakZMKzht?=
 =?utf-8?B?d3dZazZMWGlKcHlwdjF6dWp5clVQSUpHbXlJaER2ZFV1Z1kxaVpGMTJwMkl6?=
 =?utf-8?B?SWZRNnFZVEtoVU1QOWp5bngzTXo3ZnI5d2E1eDdjbTBCRHVzQXhxRElVNnZl?=
 =?utf-8?B?QSt0RWZ3Z3dmY1FlZnhJRHZMMHZwQndpUG9zSGkxVjJTbkU4ZG9zRWVPNDFv?=
 =?utf-8?B?UG1rQkpxZXh2U3pYb1RPcXRMYkpvWUZNQUhKanNOa0NaN2ZOMzV4cDU4bHgw?=
 =?utf-8?B?OUNvbTg5WG5IMFBUMlgzdDl5SHJhSzNaV1Q4M0xUVzg0VzFvcDBqZCtocU1S?=
 =?utf-8?B?RDdkR3pIazVYTmxRT08rL1dZNnFaL0dNdGJCTTU1bVRVczV3WmhEb2paN2Fj?=
 =?utf-8?B?ZXhxT3B2NDdSQmwrLzQ0azJSYi9pRkJHVXBqR2NCZFV6K0hKeXJjN013M0FZ?=
 =?utf-8?B?aFhDUW12RGp6aS9qVStJTi8ydnJMcmIyWGdvekZmNDcxVW44cWhsOS9kbkdX?=
 =?utf-8?B?L2JveVl4enVtbFd3NVhCRk1hTzM2RG5vQzQ4MnZLWktRdDRad3IvK2F3Y0ZF?=
 =?utf-8?B?c3ViUFplaUlzVFhVdk5KZTZlZWtWdjlZaHlHV3VVL3loV0VSWDBHb2l3NXIr?=
 =?utf-8?B?emdyNk9Da0U5cERjRDFhdEljYUEyMlpmRm1pcnZYYTlWeUpCT3k5MkVXY1JT?=
 =?utf-8?B?V2NkVE1HSGxvNDRyRi9jYlpiejNsa2J1QjJhUXlTMU4vQTRqL3k2NGFvdHdp?=
 =?utf-8?B?U2RyenEwVnVYK2l4YStjWHJDaGQ1VkxsL2NKS2VvRjJUWFQraFErdE1BdWc1?=
 =?utf-8?B?ZURsLzFPR0xESS9jWkdXN3NiSmFNREhNTmplUXppNUVjMjdnRTUxL3FCcEJo?=
 =?utf-8?B?dGxlVkRIVVNuazhwTXBybjQvbnBOekl1czlJazhkRG5HQW11ODJCSHZBTHdX?=
 =?utf-8?B?V2ZUYVJ0UldCYmtVTUhCOFVEMFhhVVBIQ1NxYi9KdWZ0eGdrQU5MQ3hYQTU2?=
 =?utf-8?B?UUFzMTYvbWU1dFo4dFZBVjJ0VUorVklEYWhhbmZTYU5DZWpNTjRndFpnOTVa?=
 =?utf-8?B?TTQxQmNkUk80bFZrWmdxZi84OFBCZEtLUHQwT3c0WHBZQUlPVVJvbEEwK085?=
 =?utf-8?B?VUkxYWNDMk90TG5nU3Z6djlxSC83R29zYnlMcmZaQUxlSytDbHV2QnF4QjZu?=
 =?utf-8?B?aEQ2eG9JTXlPSHRLeU9YdHNNUzJDSUZmTnUxL0k0L3lRWittVXFSQkwrMldT?=
 =?utf-8?B?MkVwTlFIMEcxbGw4RE5hMm9nQTNacUtXUW4vRyswTWR5WlFmdXJLVzRNTVJF?=
 =?utf-8?B?cVM5bDJDeTZVdHFvTXd3U1FmUWZ2SU5JMGhGdnhYUmUvRmFFYTdRcmNhL0V1?=
 =?utf-8?B?cTBidXFYVm56N1dqRDdyZUtSQmxzc3k0MytGeFBWYzcvUEZIMU9iYVlvOGFt?=
 =?utf-8?B?WDFwOXptQ3RHbnNrd3RoVVV4d0dFWXhDUTNScEN4akUvVlJkaDBjK0k5TjVD?=
 =?utf-8?B?ejZPcFVNNTloRVFCUEVoOS9RVFFGVEh2aGo0Skh0MytuQ3ZGVTcrVm9xREN5?=
 =?utf-8?B?TFNQTU1ENDcxWWVoRTFsT0x4N1crU2U0Q3dXOGhDaml6eFVyR3E5QitVR3BI?=
 =?utf-8?B?MFIySXptS3pvZFUzNGtJdzFEYjNyNStRQi90SkdQZ2t0dVB4K0o3b0Y4eVBk?=
 =?utf-8?B?aFRoblVsemdkOUJiandoU3VrbmdzTUc0ZGRsWU1hUnUxQmRvQWZKU1Q1NUJP?=
 =?utf-8?B?R0lFVlRrcDNXeEs5bjE0NFpKSk5PQkxzb053aG1tN05rMGlRbUg3QWIvMWMz?=
 =?utf-8?B?ZUhidmhLN3R0Nlo1Znk4cGtEcW85eU9IUDhZSFhnMnc1ZDNJbGxlZlRBRWhN?=
 =?utf-8?B?OWtKYU9ZSy9peUJjTXlER0poRlZpalI3a2hoOUlhSFppZHkrOTlZVXA0VEs1?=
 =?utf-8?B?cDJQRy9hZk1MOHNnUStWWlNERlQ2R3poQlJkcnFSekJubUtsTldkOTlWSG52?=
 =?utf-8?B?NXJyeFViT1ZscU52UkVkTlJPRm82RGVyVEFRTVVBOVFaUnZhcEtNWlpZa0M5?=
 =?utf-8?B?cFkvWXliNkg2Um80OFNPRFY4TitmM3FHSDl3WC9JY3VHcld4aEhWWXh6czJu?=
 =?utf-8?B?V3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ADD8B05F20442440BF567C762CBE1BD1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	46YBjKq8x7IBAG8+SZpGCcUHkET9H6wqWkewYg7CmGT4RQ/rf18p4RGregP/NHLYqtt/aJ5dbghCGCc7At/yluesCeywSC9qQeiH6ToQmWrOcLZWSVZ7oRSi8g2n7yBtherm8L4O2klAu0a4v8qPbgi2Wkns7qXVJo22UACS7gPVTs4xhCMtljo/VkI7+VMPt0/fjkkgpv+NMtsnpbbJGbHMDFqb9TR2t2FyB1VPseFS5VH0lhkh/a6L81kxOIFXSWcqB6l4O7ZyfWuKImbXXI9DCGYksvz8a3xHGYAu8IzaggA0BqBNk/hr6Oz+dx6aN+zXHevE076N+9O2FTOGtr6yGraESMwF9pZPDZ4h+2lL6qWsZVzHjS6y9gT5txxjAA2S3rH3pYw3gWX+wFMSkjmAFrqYMC9j6g/aiG54+amhGM+5IH80jIdUbeuMduqNUH4b2RnFZC24wDlYFYJ+CuMQhLsrgPDetU2ltgan89H4aunRR2hjVXQ+4BL6qeRaAUnqXO/OrRzqvkqpTicqHkhWHTADEwSKPQ44ujdce6oReRv/5NHHClj5zOlSXv/OCQ+dE2Fz/9IbeR5Fm1nR9TWI0grPaVU9D8X0Q6oTrf7azXwUjbJ71xZmuR1uymPM
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0SPR01MB0001.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e17e470e-44ae-4bd0-f933-08de28e13714
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2025 09:34:48.9624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DIGZVSsJorS+tw9CD9onvWPFS4EjtuWXMQavDXK0Q3JOgHtxaTPZa/JtDEZNU/j8kgPK2hCXpI4u364aSVBesVBP39ZG67y03UpkZ+ChbZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8740

T24gMTEvMjEvMjUgOToxOSBBTSwgemhhbmdzaGlkYSB3cm90ZToNCj4gRnJvbTogU2hpZGEgWmhh
bmcgPHpoYW5nc2hpZGFAa3lsaW5vcy5jbj4NCj4NCj4gU2lnbmVkLW9mZi1ieTogU2hpZGEgWmhh
bmcgPHpoYW5nc2hpZGFAa3lsaW5vcy5jbj4NCg0KDQpSZWdhcmRsZXNzIG9mIHRoZSBjb2RlIGNo
YW5nZSwgdGhpcyBuZWVkcyBkb2N1bWVudGF0aW9uIHdoYXQgeW91IGFyZSANCmRvaW5nIGFuZCB3
aHkgaXQgaXMgY29ycmVjdA0KDQo+IC0tLQ0KPiAgIGJsb2NrL2Jpby5jIHwgMiArLQ0KPiAgIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPg0KPiBkaWZmIC0t
Z2l0IGEvYmxvY2svYmlvLmMgYi9ibG9jay9iaW8uYw0KPiBpbmRleCBiM2E3OTI4NWMyNy4uNTVj
MmMxYTAwMjAgMTAwNjQ0DQo+IC0tLSBhL2Jsb2NrL2Jpby5jDQo+ICsrKyBiL2Jsb2NrL2Jpby5j
DQo+IEBAIC0zMjIsNyArMzIyLDcgQEAgc3RhdGljIHN0cnVjdCBiaW8gKl9fYmlvX2NoYWluX2Vu
ZGlvKHN0cnVjdCBiaW8gKmJpbykNCj4gICANCj4gICBzdGF0aWMgdm9pZCBiaW9fY2hhaW5fZW5k
aW8oc3RydWN0IGJpbyAqYmlvKQ0KPiAgIHsNCj4gLQliaW9fZW5kaW8oX19iaW9fY2hhaW5fZW5k
aW8oYmlvKSk7DQo+ICsJYmlvX2VuZGlvKGJpbyk7DQo+ICAgfQ0KPiAgIA0KPiAgIC8qKg0KDQoN
Cg==
