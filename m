Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B1C3DBD48;
	Tue, 11 Aug 2026 19:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=18.199.210.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476817; cv=fail; b=FuoAhj9xSmGRbi3fh7wBZ31fc1d/JG3j7yWmG2Bh1q18slfDS4rhge8Zn+8bdgdCwBMXTJlnuMpSoSzKXhEnfwuB39GXLqpstbA2Aon7byJ5IVsa5Cw+bqgoyhlegBSo7/YLX6auXB/njI1bRTEhzeKDLiuOlxpJ3te7ULeYiOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476817; c=relaxed/simple;
	bh=6KCgRu57nWhaDVMB6y+KpxUEj/MkgSrDcNOCLLcfjOs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=icypA8lr3nqw4/0mltvhMcaK6uTCi9Qufs8n6+ssIqJ5W/1u5hHVVAzLkShMOTHTVJuaCuZnLSgpTMH4aAnCUHbbUMplXtmqO6HnpO6fK5rQxUF39CKJF/wbxfqkxiUcOa43oyXjn//cdpprBeWxLBI+cPzYURK0gMaxKE5JAjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=S3gaH36E; arc=fail smtp.client-ip=18.199.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="S3gaH36E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1786476816; x=1818012816;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6KCgRu57nWhaDVMB6y+KpxUEj/MkgSrDcNOCLLcfjOs=;
  b=S3gaH36Emh4hfHlRVVRqazKwLNnffQJiRmhHTWiABOVTb0oTqE5TxOCf
   m6OWLcQE+GeTUkLR/t7CLW+dMKY2XW01iACiQXpk38QM5AT/CU35trrrk
   l3caLrjI3xz4oVIoMS026wHdez6wfg3haNvVwNAqSyly50eXL5xANZP5f
   qsQqfk9I0HRhshdjdHJYTaI/g21wwoGAGKZ6SmYDr6rlxh9ffLK9Ymevb
   J0cvgMdOqCEd12W+HOVIhy9a35OSI4D/WV8yH3bQNAICGb4Eul+M+eWZV
   XJ7zUQIpBvR/IzaTSgoPYRPvavnkO4T/4jfEzS8jcphBRVhRhdSP9sCs+
   Q==;
X-CSE-ConnectionGUID: UotRurfNQNKckIanhX8oPQ==
X-CSE-MsgGUID: JN2LHAxHRuCG6ZQ5wzonaQ==
X-IronPort-AV: E=Sophos;i="6.25,218,1779148800"; 
   d="scan'208";a="17604226"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2026 19:33:31 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:12574]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.29.62:2525] with esmtp (Farcaster)
 id 5a8fd43b-57f0-48a2-b152-f0322f179708; Tue, 11 Aug 2026 19:33:31 +0000 (UTC)
X-Farcaster-Flow-ID: 5a8fd43b-57f0-48a2-b152-f0322f179708
Received: from EX19EXOEUC002.ant.amazon.com (10.252.51.145) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Tue, 11 Aug 2026 19:33:31 +0000
Received: from FR4P281CU032.outbound.protection.outlook.com (10.252.51.94) by
 EX19EXOEUC002.ant.amazon.com (10.252.51.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45
 via Frontend Transport; Tue, 11 Aug 2026 19:33:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ayu2g4QehFq8gh1T3tF/GYTRWvdsmL84zPTCaEm6hlHpG02ql7ABxDRmGo343pUUteEIHWcw2dnBuTtahyvjAAjkoK2XmS0Tmb8SDkhzbYHDHIG7zRnn2NB+GtNVFPo/B6vpqUaJfcR4NQABHeu7LfBXrvNbixXEhJzTdvQ14X3nplysSPrnKd/k6lmEFJH2i87AJyE0XYXTctu8fRZok74NspyzhItadHQpeapIkAtDce/NR2+yaiyVe3quf277x5VYrsEOuZIKUJeYZkHyyQQVbUcKIW4u8xwqqh86hOJ22IiK/2XbkHmZRHgSm0AGEqL0hvGhWTmC5jut1mJQfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6KCgRu57nWhaDVMB6y+KpxUEj/MkgSrDcNOCLLcfjOs=;
 b=qAZXorK58LYg+4kB6m56yydsWl0q6X+g+I5yruenu2lVUzdEfORFyw81ZQsq8zZ2p7HroUajxfZ0MJSIahDBEyqjNGFnL64Nw0zPG3hGp14wWQomO0hbwwRlnGh2Wn/mdcQOyWiMCmUCeUiVDV4HzQMir/Drzqhj3NOrDf8fv4vZ2GngUQiFw0+lPBiT7hr0Z4Tp6VH/yaguhYDUp7k0bTwK3aNWH9ITg1JCAc9YaAIJBaNxDqIHoDjPrXbUNZXG0fTNncZDEIHoCZ+/rl9Hx20ndj6oUjYsawzqSu5uEL0JNVlb1TIy/DUbXTrai/0eNKu0JFzi6wOKvb6ktDQJ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.de; dmarc=pass action=none header.from=amazon.de;
 dkim=pass header.d=amazon.de; arc=none
Received: from BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:103::21)
 by FR0P281MB2891.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:57::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 19:33:27 +0000
Received: from BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM
 ([fe80::6854:a8a7:80a6:2c71]) by BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM
 ([fe80::6854:a8a7:80a6:2c71%6]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 19:33:27 +0000
From: "Graf (AWS), Alexander" <graf@amazon.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowangio@gmail.com>, Alex Williamson <alex@shazbot.org>,
	David Airlie <airlied@redhat.com>, Dmitry Osipenko
	<dmitry.osipenko@collabora.com>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>, Feng Liu <feliu@nvidia.com>, Gerd Hoffmann
	<kraxel@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, Jens Axboe
	<axboe@kernel.dk>, Jiri Pirko <jiri@resnulli.us>, Jonathan Corbet
	<corbet@lwn.net>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "nh-open-source@amazon.com"
	<nh-open-source@amazon.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Parav Pandit <parav@nvidia.com>, Shuah Khan
	<skhan@linuxfoundation.org>, Stefan Hajnoczi <stefanha@redhat.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [RFC PATCH 00/12] virtio: support devices that own their
 virtqueue memory
Thread-Topic: [RFC PATCH 00/12] virtio: support devices that own their
 virtqueue memory
Thread-Index: AQHdKchHcVe2KOeMjkSNLqlP5cvryA==
Date: Tue, 11 Aug 2026 19:33:26 +0000
Message-ID: <8c31b1a0-b9c1-4580-9589-9f868da42785@amazon.de>
References: <20260809182010.32931-1-graf@amazon.com>
 <20260810021450-mutt-send-email-mst@kernel.org>
 <c56fb4d0-33ef-4e9b-ac18-ac4e896957cd@amazon.com>
 <20260810035246-mutt-send-email-mst@kernel.org>
 <bdcec878-d627-4d0f-a97c-35e596363b20@amazon.de>
 <21714074-dc1e-4ef3-a515-6602bd19f055@amazon.de>
 <20260810162924-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260810162924-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amazon.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BE3P281MB6244:EE_|FR0P281MB2891:EE_
x-ms-office365-filtering-correlation-id: b8d24dc4-c58b-4c3f-3884-08def7df6a80
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|7416014|366016|1800799024|376014|38070700021|6133799003|11063799006|10067099003|56012099006|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info: RGzaMntpl2hoG567kwVJfOmWV3qbDF6bpJHiJHEy3bHiOQxBgHkw7f6pqlqztilGGQpjnwpzU7NGrScBq8qmBbtBYZBo7IOO41JBavecu+aqPSQgVMD5Yk1UiAd+pKliyqwPC0no3ZLic7Uc4OMUy+uwLeacOkLynx7yw1uUdELsFs6VeWXB91lIo63HTxNBmXTpDbgKsKqZDhz5G+W6xqrVMTNyHW0GgiSkudTPtMtgA/pzIuDXPPYYQJD9Kxra7YE0seEiyHi5ezMHwf/6/IoEXvaSClEnngdtzRmPIL3jgB/64KCybLl8Ir8syNUCt9H3eI14IL7jtr9emqoHBukIBgVc5OPr4feEgDIB9vdIAm5+/TPJSk82K4WvZMU/vwe6PoJl9SRDmIDq/uWQTg5KgsrmLdPQvFovmKG2R4DJNkcqWAX/9ABBtZ6p66B5uvezETFjm9/T4wE52RfQgdrF+1v+TBHn43EBF7I6Bm1bkQ2/js5j06gn34DXu05u1zNGOKFSJq8d9P7Nh3PI8Yjo/9f9y9Sm/2XFNTH0p/HnYPgCe5t+QKZC1idw60Jz98OKnKxYaKzN9SGToZWBo3JjinUC8Q8cEQ2di5bEupKja92liy1jDIhjWbN4cqO6uO/IDfetDs5hu+DdekIrFbCo36h9OjEedx/hKUGRs5icV2u16d/b8IIWyhzMaO0DD3zBfQnqSq1+EtVBAC081EkWwUHJyExHlnRtvmSFyNo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(1800799024)(376014)(38070700021)(6133799003)(11063799006)(10067099003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1NrbUVZZjNsdFZ1ZzFvVXZuMWtURGhNaGZmbkJJNFBEQnVVcUR6dU9BNFVV?=
 =?utf-8?B?SDBJN0FWMkt6eGI3R2RjZUNvaGNQQzFYSDZlMUJ5UkRHQVI3VmxURWpsdTAy?=
 =?utf-8?B?d3lvV3BPS0diZE42Qk9FWEROMXFjNHNTMmZvdUtUMVVONnNHUG40TlR3b3dQ?=
 =?utf-8?B?c2grNmRXcW4rUWtVQ3ZsMEdsdittTW5sc2JPdDU3VnBSTXp2bU5aeGZmNGN1?=
 =?utf-8?B?VWJETWNFOHNqUExUWVkxODAySlo1U0g4czRjRlMrYkgrZEIzb3J0UjJENGo4?=
 =?utf-8?B?WkVwWUVNM0t3ZU9DY2t1alk3ZnJSMUdPZmNRT3dXWG51RXpoenp0Zms3MzJQ?=
 =?utf-8?B?cnltSnVoeEk1R0lwYjk4VC83VjlNSS9BUzdMenR4WGtpTTZTRlQzcWxqZFAw?=
 =?utf-8?B?NXBBSnMwc2pqbDgwZDhHaU42UXJLbEw3aWpqUWtybDdRYmZXRzNDaEtqNXMw?=
 =?utf-8?B?RnFRR0MxazFoV3FzMCt0bXd1TllzdGJZVm9GWGo0WEhydzJQWWZqYlV3ZEg0?=
 =?utf-8?B?MnR3WGx4RkU3dW9DNkk2c2kyWm9FSUxqbUNWUytGWnUxMnNGRUJwVklCZ0g1?=
 =?utf-8?B?WEtRM1Y2d0szV1FVckp3UzBZcFl6ZW9TTzlUeVRWWFN6NU5MNjZheDE0a3Nt?=
 =?utf-8?B?aUJLamRSa0d0eU9qL1FiN25tRTJIVW5nWWZ0dUlnNndtcWw3MlZ0cEp6UlZF?=
 =?utf-8?B?dktyQW9SZS9qdTVLc2pmMElSaDA5cWVEbFRyelNvZWw2TjcxRDkzNzBpekVz?=
 =?utf-8?B?U0gyOGpxZ1JHcWNDVFBYRDBmV2pNU3Bkdnc1VGpZTHN1ZFc0UHhEZFBQa0sx?=
 =?utf-8?B?T3QrLzQrY0dZU2Z1MVNadlRCaEUrVkNqMS9NdlpFQ2JZSGcvdEtENzRhZ2p2?=
 =?utf-8?B?UmZMbnY0Tzh0L3lXbHFuTXVUTXc1dk1oS0N1RUNJZWJGR21yZDBrOGxGa1ZR?=
 =?utf-8?B?UmlUdFJpNzN0a2hkOVVYQmFTV0lSc1pROTk3SDRqYWNscWdGOVY0SmZiRndE?=
 =?utf-8?B?aVpLU2pNRjNzNXBOQzREL0tISENRVC9Od0RNanBqcTBueDZHRzA4NmphTkNp?=
 =?utf-8?B?UXlGdzZ0eHMyc2NrbHVKbzM2OTdyQmx6YjRjMEVKUXlTTVN3N2xGbk8vRDlR?=
 =?utf-8?B?YnY4V2VBZUpsVHA3bGJSalVQYTRMWEFYMXk4a3M0VnN1cUwyTlkyZjRUb3RX?=
 =?utf-8?B?dHhscFVGMkpBUHFFZ1JkdTBpL0dVeFkrcXlacUNEck9waGYxaWFGMWRNd01N?=
 =?utf-8?B?djlJUkNhT2lHQnRpWkFkSHJ4ME9tdDJ5eVhIb3hHQWE3N0RqUDdVck80dzU3?=
 =?utf-8?B?azlQK2hvNUpiblQ4RWlKT2wzNTN1NUczS3Q2R283SDBiamx5bUU4RmsxM3Vj?=
 =?utf-8?B?VitpS0RrNjJiNFhMT1lNMEpJNSs4Q2c3alJyeTlsN29Qc1piVVpCVlRWRDQ0?=
 =?utf-8?B?SHp3UEVQbzRyMURXSVEzYzM0RjdLdG55R1BLMC81cGpTbEQzb01NMmZ4RVhL?=
 =?utf-8?B?N0N5NjEvZ2RpYWlWdlY3ME45SjJDUWJqR3Jna05UTy9hdlRKUTVEQytpcFFR?=
 =?utf-8?B?bEswS3A0czRZKzNtQ1FFa2g1Nk1iN1E2TVVmTkNjZEcvRGtJdlg5QXJ4L1ly?=
 =?utf-8?B?SmUreWQ1ZDBVYWdyZDk4SGl0RGdaU1RVblFBM3FXYzZxZ3c3STZTU3hmUTBh?=
 =?utf-8?B?VTE3NnhjM2RGRzJtaytxdlBQaVhkK2hoRkRVYVBTSk9tazhiRjBiTDZGMlpO?=
 =?utf-8?B?bTQ5dmVJbWUxbVBNSFdsTkJGYjJuUzVkeUkxTXJ3b3UyOGcrYmpzazVmYXd1?=
 =?utf-8?B?bkdzR0tHUlMwTFRYakJ0V296N0kvZTF5ZkUwNkJhV1AzMGFxaHBwakxQRndZ?=
 =?utf-8?B?Y0ZxVE5jbkgvVFFaWGNhZHRHK1p6RU5XZCtDWjlhdzhhOElJcGlpUTB4d3Bv?=
 =?utf-8?B?VFErRDlZOWpITlNCMXJqV1RaZEU0bzFXdkswOTAzSlJxbndlZWxZeU9VSGla?=
 =?utf-8?B?RFdpSVhCN1VHT21jZVZOSTU0M3o3cUlZOFFOSkVwcEhESGNQcFJ4c2dFWS9l?=
 =?utf-8?B?Vllhd1UwSjM1UzVZbkxCU1FIbGgwa1pQRkxGcXhPUW1HM08vRXVxTW1JQVRu?=
 =?utf-8?B?ZHlsS25EdVBva1NnYTJUbEhCZy8xdzZrcGE3TzJNZnE4WjlyUlNRRU9RWlRo?=
 =?utf-8?B?ZHZaS2RHMmg1T1FOTzBsQStYNUkzUXdxS2FZZVhQNW5GanBhRlp1MXJzUUtD?=
 =?utf-8?B?ZUt4Mkd5MjNWeWNsdU9LWlpibFBiaWJRa0xhUDVkK2ZOT01GaWcweG1udjdD?=
 =?utf-8?Q?fH0zQmWrAvyrsdcAGo?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E7680D0CB34944DB02A08C7FB1238AC@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Zo33V/j/tClOF7+Nt+5QTMJA50Nf2EavTia5rcQZv/9oa6Hn8SYHl8YI8hX6edSGKcZx0eB7ELi+vYg1Cyflq1dtLrtTpK9tyNXUy3Kgd4MZoxSqZn/JONEX2VUDgety0LwWhnpS5uE5MQJUfFLG7YggH4h/jZG0ngC5yH4AiDbfYpkCSftpzUi93P7YknHPV76ZVctLTLkDk0nIODeFFqttf7Z6EYMAoAjiO1jQz9K8zmmSiFc1PCBMOLFisnk71fQEnSxMoAYyNtdhU2YNGl+h95mTg3roY1UePmFwcmpAi9+XeNDbdi457Y7uIMhLEnz8L+Kflh4GUPX5FL1H1w==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d24dc4-c58b-4c3f-3884-08def7df6a80
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2026 19:33:26.9087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /pWH+44CCLFS6qqilNCN+eJYH68nh2hd5BRHBbBB17FS2sJOoYls+oWBMjvoKzJ2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR0P281MB2891
X-OriginatorOrg: amazon.de

DQpPbiAxMC4wOC4yNiAyMzo0MiwgTWljaGFlbCBTLiBUc2lya2luIHdyb3RlOg0KPiBPbiBNb24s
IEF1ZyAxMCwgMjAyNiBhdCAwNzoxNDowOVBNICswMDAwLCBHcmFmIChBV1MpLCBBbGV4YW5kZXIg
d3JvdGU6DQo+PiBNYXliZSBJJ20gbWlzc2luZyB0aGUgcmVhbCBwb2ludCB5b3UncmUgdHJ5aW5n
IHRvIG1ha2U/IDopDQo+IEF0IGxlYXN0IG9uZSBwb2ludCBpcyBub3QgdG8gaGF2ZSB0ZXh0IGxp
a2UgImludGVwcmV0IGV2ZXJ5IGFkZHJlc3MgYXMNCj4gYW4gb2Zmc2V0IiBpbiB0aGUgc3BlYyBh
bmQgYWN0dWFsbHkgbWFrZSBpdCBhbiBhZGRyZXNzLg0KDQoNCkkgYW0gZ2VudWluZWx5IHVuYWJs
ZSB0byBzZWUgaG93IHdlIGNhbiBtYWtlIGl0IHByZXR0aWVyLg0KDQpXaGF0IEknbSB0cnlpbmcg
dG8gdHJhbnNtaXQgaXMgdGhhdCBlYWNoIGRldmljZSBzaG91bGQgbGl2ZSBpbiBpdHMgb3duIA0K
YWRkcmVzcyBzcGFjZSwgd2l0aCB0aGUgaG9zdCBzcGVjaWZ5aW5nIHdoaWNoIGJvdW5kYXJ5IGFu
IGFkZHJlc3Mgc3BhY2UgDQpoYXMuIEkgYWdyZWUgdGhhdCBvbiBzdXJmYWNlIGl0IHNvdW5kcyBh
IGJpdCBsaWtlIGFuIElPTU1VLiBBbmQgeWVzLCB3ZSANCmNhbiBjb21iaW5lIHRoYXQgd2l0aCB2
aXJ0aW8taW9tbXUsIGJ1dCB0aGF0J3MgcmVhbGx5IGp1c3QgcHVudGluZyB0aGUgDQpwcm9ibGVt
IGRvd24gb25lIGxheWVyIGFuZCBtYWtlcyBpdCBtb3JlIGRpZmZpY3VsdCB0byByZWNyZWF0ZSB0
aGUgdGllcyANCnRoYXQgYSBuYXRpdmUgcGVyLWRldmljZSBtZWNoYW5pc20gYWxyZWFkeSBnaXZl
cyB1cy4NCg0KV2l0aCBhIHB1cmUgdmlydGlvLWlvbW11IGltcGxlbWVudGF0aW9uLCB0aGUgbW9z
dCBvYnZpb3VzIHdheSB0byBjcmVhdGUgDQphIHByaXZhdGUgbWVtb3J5IHJlZ2lvbiAobm90IFJB
TSwgYmVjYXVzZSB0aGlzIHJlZ2lvbiBzaG91bGQgbmV2ZXIgYmUgDQp1c2VkIGJ5IGFueXRoaW5n
IGFzIFJBTSkgdmlhIGFuIFNITSByZWdpb24gdG8gdGhlIHZpcnRpby1pb21tdSBkZXZpY2UuDQoN
Ck5vdyB3ZSdyZSBtb3ZpbmcgdGhlIHdvcmRpbmcgaW4gdGhlIHNwZWMgZnJvbSAiRGV2aWNlIERN
QSBpcyByb3V0ZWQgdG8gYSANCnByaXZhdGUgYWRkcmVzcyBzcGFjZSB3aGljaCBpcyBiYWNrZWQg
YnkgdGhlIERNQiBTSE0gcmVnaW9uIiBpbnRvIA0KIlZpcnRpby1pb21tdSBoYXMgdGhlIGFiaWxp
dHkgdG8gdGFyZ2V0IGEgc3BlY2lhbCBhZGRyZXNzIHNwYWNlLCBiYWNrZWQgDQpieSBhbiBTSE0g
cmVnaW9uIi4gQW5kIHdlIHRoZW4gbmVlZCB0byBmaW5kIGEgd2F5IHRvIHNpemUgdGhhdCByZWdp
b24sIA0KZHluYW1pY2FsbHkgc2xpY2UgaXQgKGZvciBob3RwbHVnIHN1cHBvcnQpIGFuZCBjb21t
dW5pY2F0ZSBiZXR3ZWVuIGFsbCANCmNvbXBvbmVudHMgd2hlcmUgYW5kIGhvdyB0byB1c2UgdGhl
IHZpcnRpby1pb21tdSBTSE0gcmVnaW9uIGluc3RlYWQuDQoNCklmIHdlIGRvbid0IHdhbnQgdG8g
dXNlIGEgdmlydGlvLWlvbW11IFNITSByZWdpb24sIGJ1dCBwdW50IGl0IGRvd24gb25lIA0KbGF5
ZXIgdG8gdmlydGlvLW1lbSwgaXQgZ2V0cyBldmVuIG1vcmUgZGlmZmljdWx0LiBXZSdkIGhhdmUg
YWxsIG9mIHRoZSANCnByb2JsZW1zIHRoYXQgd2UgZ2V0IHdoZW4gdXNpbmcgdmlydGlvLWlvbW11
LCBidXQgb24gdG9wIG9mIHRoYXQgd2Ugbm93IA0KbmVlZCB0byBlbmxpZ2h0ZW4gdmlydGlvLW1l
bSB3aXRoIGEgc3BlY2lhbCAicHJpdmF0ZSIgbWVtb3J5IHJlZ2lvbiB0aGF0IA0KaXMgbm90IFJB
TS4gQW5kIHRoZW4gY29ubmVjdCB0aGF0IGJhY2sgaW50byB2aXJ0aW8taW9tbXUuDQoNClNvIHdo
aWxlIEkgdW5kZXJzdGFuZCB5b3VyIGNvbmNlcm4sIEkgZmFpbCB0byBzZWUgYSBwYXRoIHRvd2Fy
ZHMgYW4gDQphY3R1YWxseSB2aWFibGUsIGdlbnVpbmVseSBiZXR0ZXIgKHByZXR0aWVyIC8gbW9y
ZSBtYWludGFpbmFibGUgLyBlYXNpZXIgDQovIGxlc3MgZXJyb3IgcHJvbmUgLyBldGMpIGltcGxl
bWVudGF0aW9uIHdpdGggdmlydGlvLWlvbW11Lg0KDQoNCkFsZXgNCg==
