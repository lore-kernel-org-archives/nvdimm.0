Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9B91F91F6;
	Mon, 10 Aug 2026 08:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=18.199.210.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350322; cv=fail; b=fJZqZAbrcvUK9VxV2Aq1/3lIWIkdIR4Wy1OiT3r5WbYuypIQ5ephbpLa9gPtpYj52rqcP/jOT/8lLcYnoilr351dQU94N5w5t+BIG/U8AZn91fpEAJELJ4vcnedjKYQNpFF48IBndeETXdEEEwT6CoImh+OCHRsV8+126p5FH0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350322; c=relaxed/simple;
	bh=oyModxRbk9aThO6nYfwX8Sfsr/12w9LGaLC/bnl40ww=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XsXbS/kKl+Tcfc1GEyIDUENOrcGCZKYNSO433hajYeSTUGSfrAPFEAurAqqKaBWfF9A27fD7qMzGovRwv2uWf9gKsAp688CZiThgSOatyk4sDMgSmiOrNHua4wMDssLeIHWJbdB/xZ5R4cYfNEnC8CUi/DF4AmJDZzuKQSfWBHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=Tv5wwrV3; arc=fail smtp.client-ip=18.199.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="Tv5wwrV3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1786350320; x=1817886320;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oyModxRbk9aThO6nYfwX8Sfsr/12w9LGaLC/bnl40ww=;
  b=Tv5wwrV3NUYij0xIFbATwV/LmG4GFZ1/YQewrPuArLXFRdydxV2WMeg0
   pJnNdJN2hBlghJcC1rrI2ItvwtP/STdogmGUOFl9YysHrxPsxasYfuA6+
   s8o8W5XOYSmGKhdaQgw1KSJFcL+wwijjQdxYLjqRROt6EDCLsIdMdj/GH
   hJMhZa5/nLOWYmqW6PNNYMmbBGzBLhI0YamRzDvGputYotnVDmtV4kMaL
   G9RRHSYejf/SavrtIOLTYKRRlz6IYH3KZIVsM8cZhZiPg8WJqrWChJ3bi
   gciuNIs6PRl8JPdADFGyCPLdQg8TCrbkXoJsN83CKLA8GypOhj4Dv84EY
   A==;
X-CSE-ConnectionGUID: MzPPrr1lSciBMY6c1BAnVg==
X-CSE-MsgGUID: VRS7tX92S2O4QdBVzkO7UA==
X-IronPort-AV: E=Sophos;i="6.25,215,1779148800"; 
   d="scan'208";a="17510949"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 08:25:16 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:12226]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.15.0:2525] with esmtp (Farcaster)
 id f69afa03-8348-4fa3-9a76-675d4f258658; Mon, 10 Aug 2026 08:25:16 +0000 (UTC)
X-Farcaster-Flow-ID: f69afa03-8348-4fa3-9a76-675d4f258658
Received: from EX19EXOEUB002.ant.amazon.com (10.252.51.83) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Mon, 10 Aug 2026 08:25:16 +0000
Received: from EX19EXOEUA002.ant.amazon.com (10.252.50.139) by
 EX19EXOEUB002.ant.amazon.com (10.252.51.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Mon, 10 Aug 2026 08:25:15 +0000
Received: from FR5P281CU006.outbound.protection.outlook.com (10.252.51.94) by
 EX19EXOEUA002.ant.amazon.com (10.252.50.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45
 via Frontend Transport; Mon, 10 Aug 2026 08:25:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w6072UWMJb3uf42n9JoLWM7FXXFVJikWxcona16gKbayQr+EKOqE374pXiTKhN2mac8pXtg/IoGqpkUfw2pQo7VY3IlcDOGUU1KE0DBNKPi6kBTFaAlF3j8fnykFvlQDs3rGpfhs5FHK9Fydbll3WO3WmHsZITrvx1Y3oBeIQ2pZNEGgyyuK3vX9Fvf/e2bgnntSg3u1Ds0KozPHsdl4SlJOt5zODzUcH9OeK2kd9X+THieIDiwv/oSWdlqq+HtOyknTuGb7PUdpeJE7/RCMidLlwT/Z0OxvuJXKfcT2AI7V9YEHuTBe9JnwYmvt5R22J0684KhzVyMtQde8lDrHyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oyModxRbk9aThO6nYfwX8Sfsr/12w9LGaLC/bnl40ww=;
 b=nypKPeQf2kNmyBcz1FZK362Qs+zJcb0HGxGY1WmzxVAPLN6+10pkS0JWzKHQwkW20W7AxVmQDW4dSURa4nLXNB8UWie5MtQC0KLCZA0Uw4nAXQC6x0IBQmyeIYMKZL/iPflqET4Dk3pEjuY7qdMA6DWm4xqmRUfbSL82WBQr/O0oznzRzhpdC6j5ZtrAjJ7gQQ14nmHhiUZLQvna20kGAAFQRRCXlKRRfazkz9b4m5ICe2JOE4DiilAGPhe6uRZF79rPbQoKJjfZ50s92+ENiGHALmCxUw+eiItKtzorw6ZTUhkbEDFrrbe3WGTsLCrfdNubgdtXGadqQQ0vpWUIOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.de; dmarc=pass action=none header.from=amazon.de;
 dkim=pass header.d=amazon.de; arc=none
Received: from FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e0::23)
 by FR0P281MB2320.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:23::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 08:25:12 +0000
Received: from FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7ad:f028:e0a7:bd4b]) by FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7ad:f028:e0a7:bd4b%6]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 08:25:12 +0000
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
Thread-Index: AQHdKKHDfih8cWgV0EOg2wX3Ku7r+w==
Date: Mon, 10 Aug 2026 08:25:12 +0000
Message-ID: <bdcec878-d627-4d0f-a97c-35e596363b20@amazon.de>
References: <20260809182010.32931-1-graf@amazon.com>
 <20260810021450-mutt-send-email-mst@kernel.org>
 <c56fb4d0-33ef-4e9b-ac18-ac4e896957cd@amazon.com>
 <20260810035246-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260810035246-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amazon.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FRSP281MB6250:EE_|FR0P281MB2320:EE_
x-ms-office365-filtering-correlation-id: 6a8a3c76-1b5a-4882-2fa5-08def6b8e5f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|11063799006|4143699003|56012099006|38070700021|3023799007|22082099003|18002099003;
x-microsoft-antispam-message-info: k/7K5kE5zMI4ZjxnTYI+9gQUCpunjN5Avv9b8y2KnT99xb5bXFgESw/TVJdfEFouZ76dmACarig/VhJVkBOUiYbsuHW41EfeZxbL5UsOuiNavMJLWKPeoccf6zzYEqMUxoeOR86jPxfTm2tXaMIGnUIyvZD2JtzccNZplARlk1K3thfoJ8xlNn5rAB3pENDiVr8yb5aITYIA4tDAljyfsgpSzm7rFV15HIqMmu/TVRBNBo+KFrhsXTpSn21bt7BiUuU6tRde8HV3sBbMewXfRyCN1wmCEN7ka5NDlOunFcH+6AUOTizr/ofunZhWHED5uPDBRB+L9Id0QALq4x14IFmTV7OJkjbfmMjKzuH9KXCTV5MT8we7HgEJsCZYmMxw0CAoIOfMXocrYPEhdwOS+uSZFDwfbd2cqeRJbpHNmP5Zv7cUa07ibXcTwJnMyRLYoB8Iiq9/cmL+fAzZkMKaMRbxHIk5JthVEn9l35fFE1gywB46PDunfqA1/rcPmZHIlT+gnR1ajZqbhxFLMJwurwOYk2MybuooNnDd18gav4ctNG+ypCG8S8A94amb0Th2HCdCI6vq65XzqCJs+UxjmEbxlcY1K3T1Xyy0ilzdnzHJSQhrge9Wm6/UzaJIk8IFj150c2LmMjeQJIDibouGPSs9xhMRHe2PYa4YC3rQGhl5dykNo2G/+bPTNnvgRE2Il0VZvLBxODoo06gmmfMPJJhUxRuAzF3YBSexb1/mTnE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(38070700021)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3JFY3hkOXQ2NjNSMUtyUUFvVG5SQzJncXd6UnJaN3lLVlVHMCtOa2VTRFdY?=
 =?utf-8?B?dncyOGNubytHNjl6N1dhM25uR3hmay9yZTlyTlV5RlpCNTdXMzE2Y3dYb2pm?=
 =?utf-8?B?QjlydzVraWRxdkJJQTF6QjhGK1RwK2F3NjRBRjFuS3p1ZTN1bkw1RkpOZHI5?=
 =?utf-8?B?WjJuZWswZEFKOEViSEMzb29TTjVicDltcDJCZVEwZmNOUENwRDdjZm41a1dP?=
 =?utf-8?B?YlMrYk91QTVKZXFRdmRRSG1VVDA5NTB3dHM1bGU3SG91a0tweWdrbkl0WjJx?=
 =?utf-8?B?WmYxN2cxN2EzWENMNktUbFcwVk02di9DREROeXcvLzMzZmhsQjR3ZXR1a2ps?=
 =?utf-8?B?aDR0TGlsblcwd3ZzWlpPd3EycUhLL0V0cmJJSXNmbmpCR0ppWkVkd3pBYkd2?=
 =?utf-8?B?VjRKdmRGQzJCL0xRZ0ZCUi93clRCQXM2RXdpOVlCbnFPQkk1a1UwdHpocy9Y?=
 =?utf-8?B?SUNvbVRMQ2FmVVU5ODcwYkhYb3FQbmF6Uk1HMUlCK2xoVG1yNi9pWWlkTVJr?=
 =?utf-8?B?R0NhZm81a2N2WjZaK2VJbFhPR1NrbFlXd0Y4VWpGVncwQi9Xb29XbnNZdE5w?=
 =?utf-8?B?a29EZWU0Ni9tN09WaUdmZ2x0T1dDdFN0Ymt2YVdMeXFKa0txb05OcFFzUXlE?=
 =?utf-8?B?TndQU1BWQzgwcFRrbEh3Skl4V0h3SDkyTGgzcWNHb0xCUVAxQklRSTRXckZ0?=
 =?utf-8?B?ckZ6SFgzaWFTV05CR3kwZGF6dHpWdUIrTWk5a05nTkNIVG9nbFYxN3YxY3o2?=
 =?utf-8?B?eGhGNS9XdHZ1ekFRL1FjUXAzRWJqUzhGT2p0bDdpdmE1UmVUNk5FU1hnMllx?=
 =?utf-8?B?emdwaVJTbWpibTk0d3lrVFBFOUtWdnNJRjBTR2NLaElMd1FJcFk5QUd1czh4?=
 =?utf-8?B?dm56b2RkRWtGVllkc1dMeEZ4QnkydTQrT2xoS1VNTmozY3BrRUg1Z2gvbDds?=
 =?utf-8?B?TnRCd3NEVkZLMzl5L0s2VEFaWkxFemZwZm9sWXIrODJWRU1sRDNUWDJrNHB2?=
 =?utf-8?B?dU1YaVg4OEFvak5aWWQ1dTMveGFmNk96T2VKLzg4cGQ1WHJlYktZRXJJVk0y?=
 =?utf-8?B?M2ZQK0I2OEhRbElCZThvRkZjcy9oS3hMV2llUGg1S1cvaStYQXBEWXpvcU1o?=
 =?utf-8?B?ZXk4cDNvamtteWhLSzJpSUsyRkt2REExRDVBaVZ2ZFVydlBrVldMOGJYWWRv?=
 =?utf-8?B?blJoY1JTTDJqNlhVRDIwckhBTUN6WXVNZDU2ZVF3NUpyQnZ0Mnc1a2RKYWRT?=
 =?utf-8?B?UnpCL1FjOXhXb2ZYMnBXTjN5a0xjQlNIYmRyaHJCVU1lK0RmYi9pa0VCZHFK?=
 =?utf-8?B?TWRLK2t4YkpmRnhqZ3VDTUk4Q1VxK1NMc292dmZmRzlySzBqWFRSWnYwWVRq?=
 =?utf-8?B?cVYwR3d0OUxhSTl6Q1h3MVBTRUxOS2FJcG9IcFpJSmRkZEdBOVg2SGR0ZUhV?=
 =?utf-8?B?aitsZWJXTS9aSUhaOWQ4c1VTUVFrZFl5VE82M3NtbFBRZnBoUmV3b2syS1Bj?=
 =?utf-8?B?cVR1K2t1TStndmVDRkJsMFRITUpCeVlZeDc5Y0VTYUNZZS9TejVlcnc3T1Fk?=
 =?utf-8?B?ZGVGdWliUmUzbHVGY3lKaE4rZHdNLzd6UXpObml1dnNuWmZNbzBWMFA1Ujda?=
 =?utf-8?B?Nmx6WUlRZG93aDVlbUtaYjR1ZmtwaXIvcTBzdDJpS0w2QVkyMDZFNjRybXlU?=
 =?utf-8?B?cUwxcFNveG9oUUxHYjVUZThXbXc4SHpYcFZYald4ZCtad2t1b2xXaGZFWkFr?=
 =?utf-8?B?VmVvcVBENVY2RjcrbkRRSEhBNENkdzUyUDZZOGpBOEZNYkc1S05EbnNoYm5X?=
 =?utf-8?B?cGxPNTF1Q3gvQXFnRGhqd1FqNDF0K1FXQjd4eHhZdFJXb1Y5WG9YVmhGaFRE?=
 =?utf-8?B?UytHaHpudFJUVXJtbFc4bG9MQXhEci84M21hNk9zakhtaStuMFg2VnBGL2Fy?=
 =?utf-8?B?SHlpOElBdWRuQjFpU3JWUnMrNlg4b0FUUE5tSitZeFdtN0paTWMzOFhiY1E5?=
 =?utf-8?B?Rm9nU3FrVFFURUgrQVczK0Jabnk3TVJzeW5OM1BlZDlyMTNZRDhJa3RoYXdZ?=
 =?utf-8?B?VlVHNVlEWVNXRVZGYzQwV2pQRDhOQXQyOVc5MG1OMnpKUk85a1dFaStTcFJ3?=
 =?utf-8?B?Z0tQd3NuY3hUQTdsTEVBVm1qalpQUGZJV1lVZW0zRWNRMVZsb1YvaGN5WUtK?=
 =?utf-8?B?WVUwMkI4U0R4QlNxYWlzbUZYWGpHWkRuRitrZE0wNHp1djRmME8wS0pLQitU?=
 =?utf-8?B?N1VIN3NZa2lpZFpvRGZZVmFUTG5qd1kvRTl2NnUyTlBZeDlleTZaRkd5VWVL?=
 =?utf-8?Q?8piNFR6jbp6totiud3?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8423C13547A49458D6E702E70D0D464@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: opozf5yDgKo/N8rckpKAH3Xm4oigTepgRfi9AofG9Ar7X9vmdjjqATdY3RHtk+pLodElWv9T6h6OV8IsYoAFBOppDoqIX5lZaoPbd9WcXQ+OObsb7HvDFYbr7clEwjxLApyXxIAYi3xQLRwwm+6kN+fitWfSEvEaRJOJrlxx9dpwQ11bwjADcz2HL6bS+QP8QkKlkmYWwGMTwUZCSoXj38iYMmFnx7tgJJyt/SgMH1FcAnrq0/csHzzLw3xNy7VHS9YrSHAu96GuOk2XVz60Lgzu/gj16d8zycESt5bXPUvGYI36jBpk8OKXxQWDWZdlrySyqK2AYSQ+vfoees39Sg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a8a3c76-1b5a-4882-2fa5-08def6b8e5f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2026 08:25:12.5337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cNCQ1ZTss2vrb7ixsZRP50yqM2Sgb5LFyR45LWYULvkE8LjxHwlkVAiiy3dZSbrx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR0P281MB2320
X-OriginatorOrg: amazon.de

DQpPbiAxMC4wOC4yNiAxMDowNCwgTWljaGFlbCBTLiBUc2lya2luIHdyb3RlOg0KPiBPbiBNb24s
IEF1ZyAxMCwgMjAyNiBhdCAwNzozOTowMkFNICswMDAwLCBHcmFmIChBV1MpLCBBbGV4YW5kZXIg
d3JvdGU6DQo+PiBIZXkgTWljaGFlbCwNCj4+DQo+PiBUaGFua3MgYSBidW5jaCBmb3IgaGF2aW5n
IGEgZGV0YWlsZWQgYW5kIHF1aWNrIGxvb2shDQo+Pg0KPj4gT24gMTAuMDguMjYgMDg6MjMsIE1p
Y2hhZWwgUy4gVHNpcmtpbiB3cm90ZToNCj4+PiBPbiBTdW4sIEF1ZyAwOSwgMjAyNiBhdCAwNjox
OTo1OFBNICswMDAwLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToNCj4+Pj4gVmlydGlvIGRyaXZlcnMg
dXNlIGd1ZXN0IG1lbW9yeSB0byBiYWNrIHZpcnRxdWV1ZXMgYW5kIHRoZWlyIGJ1ZmZlcnMuDQo+
Pj4+IFRoYXQgbWVhbnMgYSBWTU0gbmVlZHMgdG8gYmUgYWJsZSB0byBtYXAgZ3Vlc3QgbWVtb3J5
LiBUaGF0IGlzIG9rIGluIHRoZQ0KPj4+PiBub3JtYWwgdmlydCBjYXNlLiBJdCBnZXRzIGlja3kg
d2l0aCBjb25maWRlbnRpYWwgY29tcHV0aW5nICh3aGVyZSB3ZSB1c2UNCj4+Pj4gc3dpb3RsYiBh
cyB3b3JrYXJvdW5kKSBhbmQgaXQgZGVmZWF0cyB0aGUgcHVycG9zZSBvZiBpc29sYXRlZCB2aG9z
dC11c2VyDQo+Pj4+IGJhY2tpbmcgZGV2aWNlcywgYmVjYXVzZSB0aGV5IGVuZCB1cCB3aXRoIGZ1
bGwgUkFNIGFjY2VzcyB0byB0aGUgZ3Vlc3QuDQo+Pj4+DQo+Pj4+IFNvIGluc3RlYWQsIEknbSBw
cm9wb3NpbmcgYW4gZXh0ZW5zaW9uIHRvIHZpcnRpbyB3aGljaCBhbGxvd3MgaXQgdG8gZ2l2ZQ0K
Pj4+PiBlYWNoIHZpcnRpbyBkZXZpY2UgaXRzIG93biBkZWRpY2F0ZWQgbWVtb3J5IHJlZ2lvbiB0
byBjb21tdW5pY2F0ZSB3aXRoIHRoZQ0KPj4+PiBob3N0LCBjYWxsZWQgRE1CIChEZXZpY2UgTWVt
b3J5IEJ1ZmZlcikuIEEgdHJ1c3RlZCBoeXBlcnZpc29yIGNhbiBmb3JjZQ0KPj4+PiBETUIgdG8g
YmUgcHJlc2VudCwgd2hpY2ggdGhlbiBlbmFibGVzIHNhZmVyLCBtb3JlIGlzb2xhdGVkIGFuZCBy
ZXNpbGllbnQNCj4+Pj4gY29tbXVuaWNhdGlvbiBiZXR3ZWVuIGd1ZXN0IGFuZCBob3N0Lg0KPj4+
Pg0KPj4+PiBXaXRoIERNQiwgdGhlIGRldmljZSBwcm92aWRlcyBhIHNoYXJlZCBtZW1vcnkgcmVn
aW9uIHRoYXQgYm90aCBwYXJ0aWVzDQo+Pj4+IGFncmVlIGlzIHRoZSBmdWxsIG1lbW9yeSBtYXAg
Ym90aCBoYXZlIGFjY2VzcyB0by4gQWxsIG1lbW9yeSBvZmZzZXRzDQo+Pj4+IHRoYXQgcHJldmlv
dXNseSB3b3VsZCBoYXZlIGJlZW4gaW50byBndWVzdCBSQU0sIGFyZSB0aGVuIG9mZnNldHMgaW50
bw0KPj4+PiB0aGlzIHNoYXJlZCBtZW1vcnkgYnVmZmVyIHJlZ2lvbi4gT25lIG5pY2UgcHJvcGVy
dHkgb2YgdGhpcyBpcyB0aGF0IGl0DQo+Pj4+IGlzIGEgZ2VuZXJpYyBtZWNoYW5pc20gaW4gdGhl
IHZpcnRpbyB0cmFuc3BvcnQgbGF5ZXIsIHNvIGhpZ2hlciBsZXZlbA0KPj4+PiBkcml2ZXJzIHdv
cmsgdW5tb2RpZmllZC4NCj4+Pj4NCj4+Pj4gSSB3YXMgZXhwbG9yaW5nIHRvIHVzZSBzd2lvdGxi
IGluc3RlYWQgdG8gY3JlYXRlIGluZGl2aWR1YWwgcG9vbHMuIEJ1dA0KPj4+PiB0aGF0IGFwcHJv
YWNoIGhhcyBtdWx0aXBsZSBkb3duc2lkZXM6DQo+Pj4+DQo+Pj4+IDEuIFN3aW90bGIgaXMgYW4g
T1MgcHJpbWl0aXZlIHdoaWNoIGlzIG5vdCBhdmFpbGFibGUgaW4gYWxsIE9wZXJhdGluZw0KPj4+
PiBTeXN0ZW1zLiBETUIgaG93ZXZlciBsaXZlcyBpbiB0aGUgdmlydGlvIHRyYW5zcG9ydCBsYXll
ciwgd2hpY2ggbWVhbnMgd2UNCj4+Pj4gY2FuIGFkZCBzdXBwb3J0IGZvciBpdCBpbiBhbnkgT1Mg
aW5kZXBlbmRlbnQgb2YgZ2VuZXJpYyBsYXllcnMuIFRoaXMNCj4+Pj4gaGVscHMgd2l0aCBXaW5k
b3dzIHN1cHBvcnQuDQo+Pj4gSG93IGRvZXMgaXQgaGVscCwgaWYgeW91IGFyZSBnb2luZyB0byBw
dXQgYSBwb29sIGluDQo+Pj4gdGhlIGRyaXZlciwgcHV0IGEgcG9vbCBpbiB0aGUgZHJpdmVyLiBN
YXliZSB3aXRoIHZpcnRpbyBtZW0gdG8NCj4+PiBzaW1wbGlmeSBhbGxvY2F0aW9uLg0KPj4NCj4+
IEknbSBub3Qgc3VyZSBJIHVuZGVyc3RhbmQgdGhlIHN1Z2dlc3Rpb24gOikNCj4+DQo+DQo+IEkn
bSBub3Qgc3VyZSB3aGF0IHRoZSBwcm9ibGVtIGlzIGZvciB3aW5kb3dzIDopDQo+DQo+IEJ1dCBp
ZiB5b3Ugd2FudCBhIGNodW5rIG9mIGNvbnRpZ3VvcyBtZW1vcnkgdGhhdCB3aW5kb3dzDQo+IGRv
ZXMgbm90IHBva2UgYXQgd2l0aG91dCBhIGRyaXZlciwgdmlydGlvIG1lbSBpcyB0aGF0IDopDQo+
DQo+Pj4+IDIuIFdlIG11bmdlIERNQSBzcGFjZSB0b2dldGhlci4gRE1CIHByb3ZpZGVzIGEgc2Vw
YXJhdGUgRE1BIHNwYWNlIHBlcg0KPj4+PiB2aXJ0aW8gZGV2aWNlLiBUaGlzIG1lYW5zIHdlIGNh
biBmb3IgZXhhbXBsZSBpbXBsZW1lbnQgYSBkZXZpY2UgaW4NCj4+Pj4gdmhvc3QtdXNlciBhbmQg
Z2l2ZSB0aGUgaW1wbGVtZW50aW5nIHByb2Nlc3Mgb25seSB2aXNpYmlsaXR5IHRvIHRoZSBETUIN
Cj4+Pj4gcmVnaW9uLCBub3QgYWxsIG9mIGd1ZXN0IG1lbW9yeS4gVGhhdCByZWR1Y2VzIHRoZSBl
eHBvc3VyZSB0aGUNCj4+Pj4gdmhvc3QtdXNlciBwcm92aWRlciBoYXMsIGltcHJvdmluZyBzZWN1
cml0eS4NCj4+Pj4NCj4+Pj4gMy4gRGV2aWNlcyBjYW4gb3B0LWluLiBBIGh5cGVydmlzb3IgY2Fu
IGNob29zZSB0byB1c2Ugc3RhbmRhcmQgdmlydGlvDQo+Pj4+IHNlbWFudGljcyBmb3Igc2VsZi1p
bXBsZW1lbnRlZCBkZXZpY2VzIChlLmcuIE5TTSksIHdoaWxlIHJlcXVpcmluZyBETUINCj4+Pj4g
Zm9yIGRldmljZXMgaW1wbGVtZW50ZWQgYnkgbGVzcyB0cnVzdHdvcnRoeSBwcm92aWRlcnMuIFRo
ZQ0KPj4+PiBub24tdHJ1c3R3b3J0aHkgZGV2aWNlcyBkbyBub3QgZ2V0IGFueSB2aXNpYmlsaXR5
IGludG8gdGhlIHRydXN0d29ydGh5DQo+Pj4+IG9uZXMsIGV2ZW4gd2l0aCBETUIgaW4gcGxhY2Ug
Zm9yIGJvdGguDQo+Pj4gU28gSSBhbSBub3Qgc3VyZSB3aGV0aGVyIHRoZSBpbXBsaWNhdGlvbiBp
cyB0aGF0IGl0J3MgcHVyZWx5IGEgc29mdHdhcmUNCj4+PiBjb25zdHJ1Y3QuIEJ1dCBpZiBpdCBp
cywgY2FuIHdlIGV4dGVuZCB2aXJ0aW8gaW9tbXUgdG8NCj4+PiBhZGQgYSB3YXkgdG8gZGlzY292
ZXIgYW5kIGVuZm9yY2UgdHJ1c3QgYm91bmRhcmllcz8NCj4+PiBBbmQgbWF5YmUgdHJhbnNsYXRl
IG9mZnNldHMgdG8gQkFScywgaWYgdGhhdCBpcyBkZXNpcmVkPw0KPj4+DQo+Pj4gSXQgc2VlbXMg
dG8gYmUgdGhhdCB0aGUgcmVzdWx0IHdvdWxkIGJlIHRoYXQgd2UgZG9uJ3QgbmVlZCBmaWRkbHkN
Cj4+PiBzcGVjaWFsIGNhc2luZyBpbiB2aXJ0aW8gcmluZyBzcGVjaWZpY2FsbHksIGFuZCBhIGxv
dCBvZiB0aGluZ3MgbGlrZQ0KPj4+IHByZS1tYXBwZWQgZG1hIHdpbGwgYmVnaW4gdG8gd29yay4N
Cj4+DQo+PiBPbiB0aGluZyBJJ20gdHJ5aW5nIHRvIGF2b2lkIGlzIGR5bmFtaWNpdHkuIEFueXRo
aW5nIHRoYXQgZHluYW1pY2FsbHkNCj4+IGNoYW5nZXMgdmlzaWJpbGl0eSBvciBuZWVkcyBzdGF0
ZSB0cmFja2luZyBpcyBzb21ldGhpbmcgdGhhdCBjYW4gZ28NCj4+IHdyb25nLiBCeSBrZWVwaW5n
IGV2ZXJ5dGhpbmcgc2VsZi1jb250YWluZWQgd2l0aGluIHRoZSBndWVzdCwgSSBjYW4NCj4+IHJl
YXNvbiBhYm91dCB3aGF0IGlzIHZpc2libGUgYW5kIHdoYXQgaXMgbm90IGVhc2lseS4gRXNwZWNp
YWxseSBmb3INCj4+IGNvbmZpZGVudGlhbCBjb21wdXRpbmcsIElNSE8gc3RhdGljIHdpbnMgb3Zl
ciBkeW5hbWljIGluIGdlbmVyYWwuDQo+Pg0KPj4gT3IgZGlkIEkgbWlzdW5kZXJzdGFuZCB5b3Vy
IHN1Z2dlc3Rpb24/DQo+DQo+IEkgZ2V0IHRoaXMgcGFydC4gQnV0IHdlIGNhbiBhYnNvbHV0ZWx5
IG1ha2UgaXQgc3RhdGljLg0KPg0KPg0KPiBMZXQncyBzdGFydCBieSByZXBsaWNhdGluZyB5b3Vy
IGZ1bmN0aW9uYWxpdHkgd2l0aCB2aXJ0aW8taW9tbXUuICBTbzoNCj4NCj4gLWRldmljZSBpcyBi
ZWhpbmQgdmlydGlvLWlvbW11DQo+IC12aXJ0aW8taW9tbXUgdGVsbHMgZ3Vlc3QgInRoaXMgZGV2
aWNlIGNhbiBvbmx5IGNvbnN1bWUgbWVtb3J5IGZyb20gdGhhdCByYW5nZSwiDQo+IC1hbmQgbWF5
YmU6IC4uLmFuZCB0cmFuc2xhdGlvbiBpcyAxOjEgd2l0aCB0aGlzIG9mZnNldA0KPg0KPiBpZiBn
dWVzdCBkb2VzIG5vdCBhY2tub3dsZWRnZSBpdCB3aWxsIGp1c3QgZmFpbD8NCj4NCj4NCj4gdGhp
cyBjb3ZlcnMgdGhlIHByb3Bvc2FsIGhlcmUgc2ltcGx5IGJ5IHVzaW5nIGEgZGVkaWNhdGVkIHJh
bmdlDQo+IHBlciBkZXZpY2UsIHJpZ2h0Pw0KPg0KPg0KPg0KPiBCdXQgbG9vayB3aGF0IHdlIGNh
biBlYXNpbHkgYWRkIGxhdGVyOiBzaGFyZSBhIHJhbmdlDQo+IGJldHdlZW4gZGV2aWNlcywgbm93
IHlvdSBjYW4gbW92ZSBkYXRhIGJldHdlZW4gdGhlbSB3aXRoIHplcm8gY29waWVzLg0KPg0KPg0K
PiBJc24ndCB0aGF0IGJldHRlcj8NCg0KDQpJIGRvbid0IGtub3cgaWYgIkFkZCBkZXZpY2UgZW11
bGF0aW9uIGZvciB2aXJ0aW8tbWVtIGFuZCB2aXJ0aW8taW9tbXUsIA0KaW5jbHVkaW5nIGFsbCBv
ZiBpdHMgc3RhdGUgbWFjaGluZSBhbmQgdHJhY2tpbmciIGlzIG5lY2Vzc2FyaWx5IGFuIA0KaW1w
cm92ZW1lbnQsIGJ1dCBsZXQgbWUgdHJ5IGFuZCBwcm90b3R5cGUgaXQuDQoNCg0KPg0KPg0KPj4g
QXMgdG8gcHVyZSBzb2Z0d2FyZSBjb25zdHJ1Y3Q6IFdpdGggQ1hMLCB5b3UgY2FuIGltcGxlbWVu
dCB0aGUgZXhhY3QNCj4+IHNhbWUgcHJvdG9jb2wgb24gcmVhbCBoYXJkd2FyZSBhcyB3ZWxsLiBB
bGwgaXQgdGFrZXMgaXMgY2FjaGUgY29oZXJlbmN5DQo+PiBvZiB0aGUgQkFSIChvciB3aGF0ZXZl
ciB0aGUgdHJhbnNwb3J0IHVzZXMpIHJlZ2lvbi4NCj4+DQo+Pg0KPj4NCj4+IEFsZXgNCj4gWWVz
IHRoaXMgaXMgd2hhdCBJIHRob3VnaHQgb3JpZ2luYWxseSwgdGhhdCB5b3UgaW50ZW5kIHRvDQo+
IGRvIGl0IGluIGhhcmR3YXJlLiBCdXQgcmUtcmVhZGluZyBpdCwgaXQgYmVnaW5zIHRvIGxvb2sg
bGlrZQ0KPiB0aGF0J3Mgbm90IHJlYWxseSB0aGUgY2FzZSwgaXQncyBvbmx5ICJ0aGVvcmV0aWNh
bGx5IHBvc3NpYmxlIj8NCg0KDQpUb2RheSBJIG9ubHkgaGF2ZSBiYWNrZW5kcyBpbiBzb2Z0d2Fy
ZS4gSSB0aGluayBpdCB3b3VsZCBiZSBhIHByZXR0eSANCmNvb2wgZmVhdHVyZSBldmVuIGZvciBh
Y3R1YWwgaGFyZHdhcmUgb3IgZm9yIA0Kbm90LWFzLW9idmlvdXMtYnV0LXN0aWxsLWNhY2hlLWNv
aGVyZW50LXNvZnR3YXJlIHN1Y2ggYXMgRUwzL1NNTS4gSSANCmRvbid0IGhhdmUgY29uY3JldGUg
cGxhbnMgZm9yIHRoZW0sIGJ1dCBJIGxpa2UgZ2VuZXJpYyBidWlsZGluZyBibG9ja3MgDQpvdmVy
IHRvbyB0YXJnZXRlZCBhbmQgdGllZCB0byBhIHNpbmdsZSB1c2UgY2FzZSA6KQ0KDQoNCkFsZXgN
Cg==
