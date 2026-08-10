Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE403793BF;
	Mon, 10 Aug 2026 19:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=3.72.182.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786389264; cv=fail; b=seWt6rt/Pog5XrJ+fkuN461BJbOBtDzo0Vo0vfJ3FOIVJY4bCiS7HxQZZYOR1NxNzqXJkaG4HEX57l8T8gqJS1RpqO963ET7ncXAJJv1Vkh99pgoBBZMfz7qfqB3sYEnmWKNH+TyyNPwmf57ZKUb7snySD1oB1iaBVf0WcEfWc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786389264; c=relaxed/simple;
	bh=Oz3Keul7TDYo7yz5+1IoP/LVsE8nB94Mjodar5hMA0o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UcpD4DfHt+EF894Vofd786NymVG32+3Brp3ghswxvXt2jswnnVH/yzrXG0+609xAWcYrKdt7c3jaY07Z6GycbVRMF2nhBdK5bX7qnChd+W2kOJdDD25UDIygFZJ8bES8ybXUbtSjQwJBXisdlRfonLpZZMehY6BHnGEF0RSJuf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=V4wWR4sn; arc=fail smtp.client-ip=3.72.182.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="V4wWR4sn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1786389262; x=1817925262;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Oz3Keul7TDYo7yz5+1IoP/LVsE8nB94Mjodar5hMA0o=;
  b=V4wWR4sn9Y8y2gYdFp1SxGrjukQKlgCqK0np9M4sKFmZpcc+FhPmqeU6
   sKqpM+C0Xh4YBwSUxsmiL9hsBWm09nsEvnp/RzK4uu0n5mTd/pNN/Q2Pq
   CTNPjiVTCwkh8d6i6OS+HQytS40eqKDFEBNMo0xnI/PXWOg49XRaOGN/W
   Xy16ytQd6bAOcl1q1Q7l3lKzBS8iIdLDk5ORIshLEGycLgHRb6Dis/R1c
   4jCmtM15iCGYw1JlAbo5h29Pg5d6VCNOB6cRinJlczuReRSDZnSX4iYAf
   FD0GlJy5BB9/LwVdNIiM0z6OMo1KkPvOH1yl2mgk8dSnvkN3y5AkvNY7x
   g==;
X-CSE-ConnectionGUID: J9q2ZY+CSWioWYw4x8QL4g==
X-CSE-MsgGUID: 3czkgsQLRzSiEvWBYMptkg==
X-IronPort-AV: E=Sophos;i="6.25,216,1779148800"; 
   d="scan'208";a="17660185"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 19:14:18 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:23787]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.46.156:2525] with esmtp (Farcaster)
 id 523ac2a6-aab1-4361-b9e4-ba9fa44768f9; Mon, 10 Aug 2026 19:14:17 +0000 (UTC)
X-Farcaster-Flow-ID: 523ac2a6-aab1-4361-b9e4-ba9fa44768f9
Received: from EX19EXOEUB001.ant.amazon.com (10.252.51.80) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Mon, 10 Aug 2026 19:14:17 +0000
Received: from EX19EXOEUA001.ant.amazon.com (10.252.50.110) by
 EX19EXOEUB001.ant.amazon.com (10.252.51.80) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Mon, 10 Aug 2026 19:14:17 +0000
Received: from FR4P281CU032.outbound.protection.outlook.com (10.252.51.94) by
 EX19EXOEUA001.ant.amazon.com (10.252.50.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45
 via Frontend Transport; Mon, 10 Aug 2026 19:14:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DSf0Zs94VxFwHVpxORKbkz+RJjNEWWzkiKBcCiDRpWPal3lIft4oDlFbIrbdU59CSFWe9+9TguOF2E4QaijqosHZhEGhrs35iih1zNP2nfY7OaVQHPvjIpbsOrmZapyKNWgoO+/s220z1MxjApR1P3NLPr187X/3hAnMJYs3Ht6lHgpDXl7CyEv+wEJjQKRZnUejJfSyp5m5EucFTAv4CkujeXW2/6+p4ScAX+4+UfoEEarHwNKFnx4lWCD90uY5b3WbHPb18uzfbZRn/hxVl/pg781h9zLMm7kg1ydG4PkGjalLf2KKDH10lWSlcOCw6ky55VTmz/OU9K/mxgxslA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oz3Keul7TDYo7yz5+1IoP/LVsE8nB94Mjodar5hMA0o=;
 b=FEmDe3hoR41MBQzkzpgZD6HeJnoGc3tvMcRrgc5wBQJ0URlJ1rgmlkGnSJSWxY4Hga40T6nmMJEg/XIKX/jsuFyC4usl7bjGC5mY7jNLSTVLuugk4bugiLa8pr4Z7wBuknPTRELODWTqElQU1I97bo+o4cPYbwtQEbOaYmCnFopEt+Nzm2NU5LNeqTMAPHD4/ewSlv9zY/5sdRYU3lhPCxgK6OUfkCouw+nVEHf/3QrMOJQQcv9CAD/Ri5sj7Rs7G4CIboZ+G0Ap5g/mqL7EnwaVsVuJFqgapNep5NbUNlIMz/EXna0zBHv40nEfYIxMiF280hUS2x6QkOL+27CJOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.de; dmarc=pass action=none header.from=amazon.de;
 dkim=pass header.d=amazon.de; arc=none
Received: from FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e0::23)
 by BE3P281MB6227.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:103::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 19:14:10 +0000
Received: from FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7ad:f028:e0a7:bd4b]) by FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7ad:f028:e0a7:bd4b%6]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 19:14:09 +0000
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
Thread-Index: AQHdKKHDfih8cWgV0EOg2wX3Ku7r+7aXpz+A
Date: Mon, 10 Aug 2026 19:14:09 +0000
Message-ID: <21714074-dc1e-4ef3-a515-6602bd19f055@amazon.de>
References: <20260809182010.32931-1-graf@amazon.com>
 <20260810021450-mutt-send-email-mst@kernel.org>
 <c56fb4d0-33ef-4e9b-ac18-ac4e896957cd@amazon.com>
 <20260810035246-mutt-send-email-mst@kernel.org>
 <bdcec878-d627-4d0f-a97c-35e596363b20@amazon.de>
In-Reply-To: <bdcec878-d627-4d0f-a97c-35e596363b20@amazon.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amazon.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FRSP281MB6250:EE_|BE3P281MB6227:EE_
x-ms-office365-filtering-correlation-id: 0c9c3666-5908-412e-15a0-08def7138e75
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|22082099003|18002099003|56012099006|5023799004|11063799006|38070700021|10067099003|4143699003;
x-microsoft-antispam-message-info: 6RExXWwuRA65It1fVNgdLdgiLxDTYRTLCVwzA5tmI7ET4/1MnsAiUQociWzgHpd1frWe6l4sKQPMT+jeP0wvvuBRG9mo1/ypVxQHDgeetXb/dgNFH7Vzo03UHLSwO406U/TDVEI1NgE5ZXpXz3eOpf5RbBr9UauKApHGFPEyulSpIhuDbqkl3vGphBGMdimvhPlfsIXxPBqlDELtDC3myu6UaHx9NjxVhX//uCEtwQBG+dH9D8O4klarKzG1FjX7O5J4c47uQxRj0WXvq0rHcLYXZwNJL6Pl9tdU1n5OTWsOYKAHp/kdqxd0crOsFLMo15Qg8TeU73TKWrXA1gb07MhPmu9LMvAOi5PPt+dFXkDaqRGcoPi+ryuoM1H42SzLMVWZif1YrStV2cm+x//Rht/qvmHbdJcdHd8NQ0tnE2pYza3OqVkaNURpjICm/j0Gx//U+6vMLT9NRJyiemhuSXn8vE2hpUiIAlyaJIyu8/yEBrcmFMX6TLowN/uq8YgRUXMdl9KU2YCcf/YKoZYj0J0PL/EBFudKCedQCitkghaiWtj389hEakMWasMEGnu6LVFyS88Sh0Cys9QYPMBeq5/RRvEzzxoPW4ihQd3ddjH0UKT9C+ZgMZSDBSHYrsyrjJHWm+FQij/HAalqx79FSTozZ+v8HO+mWcBqF6bXSGTC24usuU35sXfHK27+3dOuViO/PQsmwl1hNNVTwE+7rEoEArv2IaJawdgmNL4dZ/A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(22082099003)(18002099003)(56012099006)(5023799004)(11063799006)(38070700021)(10067099003)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzNvcHd3WnV1d1VNMGpvV0ZXOVArMU9NTW1YQXk4ZGNPand4V0dPZWhDR0Fz?=
 =?utf-8?B?N1VjOCs1U051eWphTlVIV3gyajE2NHo2VXRnZ01LUCtNSDhzZWFFNnJFaEtV?=
 =?utf-8?B?TFdMSHpqKzJ4OUVyUHdLY1hTVFljWVNuYTFiQ2dxOXFpMjJlcVpqbVBIOUxm?=
 =?utf-8?B?SEFrUktCR1J0SFZ1L0RkTXVFK2NrbkhReTQrTHJsRFdQMUp0anRCanhiMDk5?=
 =?utf-8?B?Qy93RlZUTnRVcWVtcnowTHBCaXY2dlVQKzRZaTdqNEkvcFVlcmQwbHFPckVY?=
 =?utf-8?B?aEcwRUM1clg4R0pZU05KRzRMbVc4N0M3NUs3ZHZpZEZseXJ3ZkpIV1AxWFNR?=
 =?utf-8?B?SmZ1WlAyVWJJeEE2S2JsdkQyQ2s2ejdGRzZ6SEtGNExMVDBuQ2tyYXNPY25T?=
 =?utf-8?B?bXFraldPbGViWDlEdnFscWV6UWgxYWZnYXR0bUduU0NtV0NrUXlQTnVMVWcy?=
 =?utf-8?B?RklhUGpiVnFwUzBPYmt2WmhPcWNTcmpxVFVQam1ESnRObFN3Z09LaXhJZXNT?=
 =?utf-8?B?bHg3Qk5CbUhzR2oyTWdYdHgwcGhrUE9wOU0rb0ZVM2dpNEdaNEFXR2FuRzVx?=
 =?utf-8?B?OTd1UmFUWWpTTUVDOGVVSW5wT2xRRnVJbnkwSkltd1Uyb3RvcFhGd0x3dWxj?=
 =?utf-8?B?TDB6OWo4ZUdpMWVhbFVpbmM2R2RobW50bm04SmRrZ2VmcUVqY3FGNllyYjZX?=
 =?utf-8?B?MnRpVWZRMXdNaEdzMUdoMzJGd0VwVGowVTk3aUh1YTBMUDVPdW1xM1ROaVFQ?=
 =?utf-8?B?UVRKdEFYTEloaEZGdGNyZTdEdDAwSEhTRnJqVWZXRGdlMHJYaENldzVMNnFG?=
 =?utf-8?B?cWJnOW5mSzVyQ3E5Zlo2dU9yVVNWZzQ4bFFHczNlaVhNTUtCVjVJY0ZqU3ZL?=
 =?utf-8?B?R21yTlBydzF5Z1FtV1JheEhYUmsxVW9GQVhsakFZakwwWTJ1RnNvaXNKQWph?=
 =?utf-8?B?V3liWjZFY1plQU5YSTlTc0RESmR6bUMzMFpMREFDcXVDNVNLd1pMVkxhejEw?=
 =?utf-8?B?OUtTSTFjN3VJV0xza2RwZE4weEVkdEFtNVdzRk1GRXYxSlRBRzJCN2k0Z1V2?=
 =?utf-8?B?eEViYWwxeURLSjBUS25lclh3QkJ0ekxLcDdPL3YrcWVlcEV2VStHeHRtS3ZS?=
 =?utf-8?B?a2dJcVU0b2dKK0lVUGFLVUhwWkY5YnZROG5MRWZrQldZeHNXUDFhaUVwRVd6?=
 =?utf-8?B?WFZ4bDRteUUvZXZ5eWxuZWwvZDZUY2dqeW9kSE9IMURXUmNzMjBZTkxlZkg0?=
 =?utf-8?B?ejdaUmo2VlhyYzFHUlE0bDJTOVgvSUhHbmtJcFl0R2NWL0x4d1lPVmlRUU1j?=
 =?utf-8?B?UGtDWEkwNnZXMTJMQzArQkQzKzEzSTNOV0hIV2JpWkZKN2RIaWE4UEFFb2ZF?=
 =?utf-8?B?WDd5WUVqR3RFelJSNUJ6N2RRQmRZRHpJbUxRcTBHRUVpS1crNkh1TEVDTjlM?=
 =?utf-8?B?VllydHRWaXpQZmRRYnhodTV5YVFMVHRSVVdtdmpjTE4zdnU0S20rL2ROa2lr?=
 =?utf-8?B?Y3VzSVRBWlhjamRFT21zWTRETEgrekdZdXh4R2dJZnpadFNHOWFVejhRbDVZ?=
 =?utf-8?B?VERLNDlDTk1ib1hkdFNSQkF5cTVwelpVbWxWdjF5VzVwSWpROUxqazJidVNJ?=
 =?utf-8?B?NEc5SStRMFY0RWN1OUorcjlDdW1FUy9BaHFHVzNTbzlyY2MyTlVWeGUzenRl?=
 =?utf-8?B?Z08xSms5ZXhzTUszV1QwdS9OcUlROUhHTkRCTkVxem5oVlZ0SWxGSysrZHVk?=
 =?utf-8?B?L1BsR3poYVd5cWFYdnZ0QllGZ3prOGhiTDVXL1VESk9CQnpDV25NZENSVVlN?=
 =?utf-8?B?MWV1WWlWdmR2NGZOUmRnSUJCNWFGZnVScXdMd2J3RHZ0UHEwbVVTSzdNWW95?=
 =?utf-8?B?S3lQTTN5OHFSdVhrSzJscGoyYkxILzhUU1ZXdjdjckJrOUZhSUpkNHZxcGZh?=
 =?utf-8?B?d2t6VUhTdi9JSWRnZUx2QlJPbTExZCtQaTJCKzZQVE5MYTFwbVY1SlZGQXB2?=
 =?utf-8?B?Z1dtc0hGMTNmcTNOQk9jc0NDd200SmpjMmtMc094UWt1eUh1a3hGMnYwOXl4?=
 =?utf-8?B?LzN1SXpDclRDY0dka0Y3M3ljTjRyQllFSXYya1l5ZGx2SVhyLzFUWFpIWWp0?=
 =?utf-8?B?ODNBcWtPMW0relRuVzZEYjVsSi9XYmZRaytya2Vtc2VHUEVjVWxHQ01DTis4?=
 =?utf-8?B?WFVjWGxOR1dMWGtiWWxUUXg3VXd3eERLWnVZRFIwQWtCdDdMc2FOWExyakRa?=
 =?utf-8?B?N1F0am1Kc3QxdW1LVWlwNmhiN21aZ2Y2MzJFZUE1cW9tZ0FuMENqbzNiaGF0?=
 =?utf-8?Q?i5HEyBBu/m076gjCne?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02067810D9385842B348124274F3D7BB@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: k1LvimUuRG+YHWtmiwReKG2ApSh5n0AfxasZWmOiSbNSfajP/AbAbqXtBrYYnFoB8wwWjooinNz2fAZ3HgCkaol5cehJFK6/1/agbfC693BCj2BE/zgzLkpVdPnuWd6TEU1Y3zbzQXsD8alicig1pfztuwfm/yBMNti1zEV58+Uz6OXElV3kOmPfZ3g3lVaPIxGW8KYCxnWO3poRoWoBgfUDODqm1hPSZHlj0oCOMTHFAI612ZT3AJ075RlvUx19/mO1l7h4KFMaMk845IU9Iz0Lsp2aUup+xg0apB7LZnBXtDma9rG8qIDrPuAmC1NaZFA8xHZaBsUrMI4nRgKDHg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c9c3666-5908-412e-15a0-08def7138e75
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2026 19:14:09.9601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y0MEJ+siDXurudjJFsICCkaw4VKs2JI3y07dzD8mS2swMmi/mGPK3CUqQ0fTZH4V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BE3P281MB6227
X-OriginatorOrg: amazon.de

DQpPbiAxMC4wOC4yNiAxMDoyNSwgR3JhZiAoQVdTKSwgQWxleGFuZGVyIHdyb3RlOg0KPiBPbiAx
MC4wOC4yNiAxMDowNCwgTWljaGFlbCBTLiBUc2lya2luIHdyb3RlOg0KPj4gT24gTW9uLCBBdWcg
MTAsIDIwMjYgYXQgMDc6Mzk6MDJBTSArMDAwMCwgR3JhZiAoQVdTKSwgQWxleGFuZGVyIHdyb3Rl
Og0KPj4+IEhleSBNaWNoYWVsLA0KPj4+DQo+Pj4gVGhhbmtzIGEgYnVuY2ggZm9yIGhhdmluZyBh
IGRldGFpbGVkIGFuZCBxdWljayBsb29rIQ0KPj4+DQo+Pj4gT24gMTAuMDguMjYgMDg6MjMsIE1p
Y2hhZWwgUy4gVHNpcmtpbiB3cm90ZToNCj4+Pj4gT24gU3VuLCBBdWcgMDksIDIwMjYgYXQgMDY6
MTk6NThQTSArMDAwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6DQo+Pj4+PiBWaXJ0aW8gZHJpdmVy
cyB1c2UgZ3Vlc3QgbWVtb3J5IHRvIGJhY2sgdmlydHF1ZXVlcyBhbmQgdGhlaXIgYnVmZmVycy4N
Cj4+Pj4+IFRoYXQgbWVhbnMgYSBWTU0gbmVlZHMgdG8gYmUgYWJsZSB0byBtYXAgZ3Vlc3QgbWVt
b3J5LiBUaGF0IGlzIG9rIGluIHRoZQ0KPj4+Pj4gbm9ybWFsIHZpcnQgY2FzZS4gSXQgZ2V0cyBp
Y2t5IHdpdGggY29uZmlkZW50aWFsIGNvbXB1dGluZyAod2hlcmUgd2UgdXNlDQo+Pj4+PiBzd2lv
dGxiIGFzIHdvcmthcm91bmQpIGFuZCBpdCBkZWZlYXRzIHRoZSBwdXJwb3NlIG9mIGlzb2xhdGVk
IHZob3N0LXVzZXINCj4+Pj4+IGJhY2tpbmcgZGV2aWNlcywgYmVjYXVzZSB0aGV5IGVuZCB1cCB3
aXRoIGZ1bGwgUkFNIGFjY2VzcyB0byB0aGUgZ3Vlc3QuDQo+Pj4+Pg0KPj4+Pj4gU28gaW5zdGVh
ZCwgSSdtIHByb3Bvc2luZyBhbiBleHRlbnNpb24gdG8gdmlydGlvIHdoaWNoIGFsbG93cyBpdCB0
byBnaXZlDQo+Pj4+PiBlYWNoIHZpcnRpbyBkZXZpY2UgaXRzIG93biBkZWRpY2F0ZWQgbWVtb3J5
IHJlZ2lvbiB0byBjb21tdW5pY2F0ZSB3aXRoIHRoZQ0KPj4+Pj4gaG9zdCwgY2FsbGVkIERNQiAo
RGV2aWNlIE1lbW9yeSBCdWZmZXIpLiBBIHRydXN0ZWQgaHlwZXJ2aXNvciBjYW4gZm9yY2UNCj4+
Pj4+IERNQiB0byBiZSBwcmVzZW50LCB3aGljaCB0aGVuIGVuYWJsZXMgc2FmZXIsIG1vcmUgaXNv
bGF0ZWQgYW5kIHJlc2lsaWVudA0KPj4+Pj4gY29tbXVuaWNhdGlvbiBiZXR3ZWVuIGd1ZXN0IGFu
ZCBob3N0Lg0KPj4+Pj4NCj4+Pj4+IFdpdGggRE1CLCB0aGUgZGV2aWNlIHByb3ZpZGVzIGEgc2hh
cmVkIG1lbW9yeSByZWdpb24gdGhhdCBib3RoIHBhcnRpZXMNCj4+Pj4+IGFncmVlIGlzIHRoZSBm
dWxsIG1lbW9yeSBtYXAgYm90aCBoYXZlIGFjY2VzcyB0by4gQWxsIG1lbW9yeSBvZmZzZXRzDQo+
Pj4+PiB0aGF0IHByZXZpb3VzbHkgd291bGQgaGF2ZSBiZWVuIGludG8gZ3Vlc3QgUkFNLCBhcmUg
dGhlbiBvZmZzZXRzIGludG8NCj4+Pj4+IHRoaXMgc2hhcmVkIG1lbW9yeSBidWZmZXIgcmVnaW9u
LiBPbmUgbmljZSBwcm9wZXJ0eSBvZiB0aGlzIGlzIHRoYXQgaXQNCj4+Pj4+IGlzIGEgZ2VuZXJp
YyBtZWNoYW5pc20gaW4gdGhlIHZpcnRpbyB0cmFuc3BvcnQgbGF5ZXIsIHNvIGhpZ2hlciBsZXZl
bA0KPj4+Pj4gZHJpdmVycyB3b3JrIHVubW9kaWZpZWQuDQo+Pj4+Pg0KPj4+Pj4gSSB3YXMgZXhw
bG9yaW5nIHRvIHVzZSBzd2lvdGxiIGluc3RlYWQgdG8gY3JlYXRlIGluZGl2aWR1YWwgcG9vbHMu
IEJ1dA0KPj4+Pj4gdGhhdCBhcHByb2FjaCBoYXMgbXVsdGlwbGUgZG93bnNpZGVzOg0KPj4+Pj4N
Cj4+Pj4+IDEuIFN3aW90bGIgaXMgYW4gT1MgcHJpbWl0aXZlIHdoaWNoIGlzIG5vdCBhdmFpbGFi
bGUgaW4gYWxsIE9wZXJhdGluZw0KPj4+Pj4gU3lzdGVtcy4gRE1CIGhvd2V2ZXIgbGl2ZXMgaW4g
dGhlIHZpcnRpbyB0cmFuc3BvcnQgbGF5ZXIsIHdoaWNoIG1lYW5zIHdlDQo+Pj4+PiBjYW4gYWRk
IHN1cHBvcnQgZm9yIGl0IGluIGFueSBPUyBpbmRlcGVuZGVudCBvZiBnZW5lcmljIGxheWVycy4g
VGhpcw0KPj4+Pj4gaGVscHMgd2l0aCBXaW5kb3dzIHN1cHBvcnQuDQo+Pj4+IEhvdyBkb2VzIGl0
IGhlbHAsIGlmIHlvdSBhcmUgZ29pbmcgdG8gcHV0IGEgcG9vbCBpbg0KPj4+PiB0aGUgZHJpdmVy
LCBwdXQgYSBwb29sIGluIHRoZSBkcml2ZXIuIE1heWJlIHdpdGggdmlydGlvIG1lbSB0bw0KPj4+
PiBzaW1wbGlmeSBhbGxvY2F0aW9uLg0KPj4+IEknbSBub3Qgc3VyZSBJIHVuZGVyc3RhbmQgdGhl
IHN1Z2dlc3Rpb24gOikNCj4+Pg0KPj4gSSdtIG5vdCBzdXJlIHdoYXQgdGhlIHByb2JsZW0gaXMg
Zm9yIHdpbmRvd3MgOikNCj4+DQo+PiBCdXQgaWYgeW91IHdhbnQgYSBjaHVuayBvZiBjb250aWd1
b3MgbWVtb3J5IHRoYXQgd2luZG93cw0KPj4gZG9lcyBub3QgcG9rZSBhdCB3aXRob3V0IGEgZHJp
dmVyLCB2aXJ0aW8gbWVtIGlzIHRoYXQgOikNCj4+DQo+Pj4+PiAyLiBXZSBtdW5nZSBETUEgc3Bh
Y2UgdG9nZXRoZXIuIERNQiBwcm92aWRlcyBhIHNlcGFyYXRlIERNQSBzcGFjZSBwZXINCj4+Pj4+
IHZpcnRpbyBkZXZpY2UuIFRoaXMgbWVhbnMgd2UgY2FuIGZvciBleGFtcGxlIGltcGxlbWVudCBh
IGRldmljZSBpbg0KPj4+Pj4gdmhvc3QtdXNlciBhbmQgZ2l2ZSB0aGUgaW1wbGVtZW50aW5nIHBy
b2Nlc3Mgb25seSB2aXNpYmlsaXR5IHRvIHRoZSBETUINCj4+Pj4+IHJlZ2lvbiwgbm90IGFsbCBv
ZiBndWVzdCBtZW1vcnkuIFRoYXQgcmVkdWNlcyB0aGUgZXhwb3N1cmUgdGhlDQo+Pj4+PiB2aG9z
dC11c2VyIHByb3ZpZGVyIGhhcywgaW1wcm92aW5nIHNlY3VyaXR5Lg0KPj4+Pj4NCj4+Pj4+IDMu
IERldmljZXMgY2FuIG9wdC1pbi4gQSBoeXBlcnZpc29yIGNhbiBjaG9vc2UgdG8gdXNlIHN0YW5k
YXJkIHZpcnRpbw0KPj4+Pj4gc2VtYW50aWNzIGZvciBzZWxmLWltcGxlbWVudGVkIGRldmljZXMg
KGUuZy4gTlNNKSwgd2hpbGUgcmVxdWlyaW5nIERNQg0KPj4+Pj4gZm9yIGRldmljZXMgaW1wbGVt
ZW50ZWQgYnkgbGVzcyB0cnVzdHdvcnRoeSBwcm92aWRlcnMuIFRoZQ0KPj4+Pj4gbm9uLXRydXN0
d29ydGh5IGRldmljZXMgZG8gbm90IGdldCBhbnkgdmlzaWJpbGl0eSBpbnRvIHRoZSB0cnVzdHdv
cnRoeQ0KPj4+Pj4gb25lcywgZXZlbiB3aXRoIERNQiBpbiBwbGFjZSBmb3IgYm90aC4NCj4+Pj4g
U28gSSBhbSBub3Qgc3VyZSB3aGV0aGVyIHRoZSBpbXBsaWNhdGlvbiBpcyB0aGF0IGl0J3MgcHVy
ZWx5IGEgc29mdHdhcmUNCj4+Pj4gY29uc3RydWN0LiBCdXQgaWYgaXQgaXMsIGNhbiB3ZSBleHRl
bmQgdmlydGlvIGlvbW11IHRvDQo+Pj4+IGFkZCBhIHdheSB0byBkaXNjb3ZlciBhbmQgZW5mb3Jj
ZSB0cnVzdCBib3VuZGFyaWVzPw0KPj4+PiBBbmQgbWF5YmUgdHJhbnNsYXRlIG9mZnNldHMgdG8g
QkFScywgaWYgdGhhdCBpcyBkZXNpcmVkPw0KPj4+Pg0KPj4+PiBJdCBzZWVtcyB0byBiZSB0aGF0
IHRoZSByZXN1bHQgd291bGQgYmUgdGhhdCB3ZSBkb24ndCBuZWVkIGZpZGRseQ0KPj4+PiBzcGVj
aWFsIGNhc2luZyBpbiB2aXJ0aW8gcmluZyBzcGVjaWZpY2FsbHksIGFuZCBhIGxvdCBvZiB0aGlu
Z3MgbGlrZQ0KPj4+PiBwcmUtbWFwcGVkIGRtYSB3aWxsIGJlZ2luIHRvIHdvcmsuDQo+Pj4gT24g
dGhpbmcgSSdtIHRyeWluZyB0byBhdm9pZCBpcyBkeW5hbWljaXR5LiBBbnl0aGluZyB0aGF0IGR5
bmFtaWNhbGx5DQo+Pj4gY2hhbmdlcyB2aXNpYmlsaXR5IG9yIG5lZWRzIHN0YXRlIHRyYWNraW5n
IGlzIHNvbWV0aGluZyB0aGF0IGNhbiBnbw0KPj4+IHdyb25nLiBCeSBrZWVwaW5nIGV2ZXJ5dGhp
bmcgc2VsZi1jb250YWluZWQgd2l0aGluIHRoZSBndWVzdCwgSSBjYW4NCj4+PiByZWFzb24gYWJv
dXQgd2hhdCBpcyB2aXNpYmxlIGFuZCB3aGF0IGlzIG5vdCBlYXNpbHkuIEVzcGVjaWFsbHkgZm9y
DQo+Pj4gY29uZmlkZW50aWFsIGNvbXB1dGluZywgSU1ITyBzdGF0aWMgd2lucyBvdmVyIGR5bmFt
aWMgaW4gZ2VuZXJhbC4NCj4+Pg0KPj4+IE9yIGRpZCBJIG1pc3VuZGVyc3RhbmQgeW91ciBzdWdn
ZXN0aW9uPw0KPj4gSSBnZXQgdGhpcyBwYXJ0LiBCdXQgd2UgY2FuIGFic29sdXRlbHkgbWFrZSBp
dCBzdGF0aWMuDQo+Pg0KPj4NCj4+IExldCdzIHN0YXJ0IGJ5IHJlcGxpY2F0aW5nIHlvdXIgZnVu
Y3Rpb25hbGl0eSB3aXRoIHZpcnRpby1pb21tdS4gIFNvOg0KPj4NCj4+IC1kZXZpY2UgaXMgYmVo
aW5kIHZpcnRpby1pb21tdQ0KPj4gLXZpcnRpby1pb21tdSB0ZWxscyBndWVzdCAidGhpcyBkZXZp
Y2UgY2FuIG9ubHkgY29uc3VtZSBtZW1vcnkgZnJvbSB0aGF0IHJhbmdlLCINCj4+IC1hbmQgbWF5
YmU6IC4uLmFuZCB0cmFuc2xhdGlvbiBpcyAxOjEgd2l0aCB0aGlzIG9mZnNldA0KPj4NCj4+IGlm
IGd1ZXN0IGRvZXMgbm90IGFja25vd2xlZGdlIGl0IHdpbGwganVzdCBmYWlsPw0KPj4NCj4+DQo+
PiB0aGlzIGNvdmVycyB0aGUgcHJvcG9zYWwgaGVyZSBzaW1wbHkgYnkgdXNpbmcgYSBkZWRpY2F0
ZWQgcmFuZ2UNCj4+IHBlciBkZXZpY2UsIHJpZ2h0Pw0KPj4NCj4+DQo+Pg0KPj4gQnV0IGxvb2sg
d2hhdCB3ZSBjYW4gZWFzaWx5IGFkZCBsYXRlcjogc2hhcmUgYSByYW5nZQ0KPj4gYmV0d2VlbiBk
ZXZpY2VzLCBub3cgeW91IGNhbiBtb3ZlIGRhdGEgYmV0d2VlbiB0aGVtIHdpdGggemVybyBjb3Bp
ZXMuDQo+Pg0KPj4NCj4+IElzbid0IHRoYXQgYmV0dGVyPw0KPg0KPiBJIGRvbid0IGtub3cgaWYg
IkFkZCBkZXZpY2UgZW11bGF0aW9uIGZvciB2aXJ0aW8tbWVtIGFuZCB2aXJ0aW8taW9tbXUsDQo+
IGluY2x1ZGluZyBhbGwgb2YgaXRzIHN0YXRlIG1hY2hpbmUgYW5kIHRyYWNraW5nIiBpcyBuZWNl
c3NhcmlseSBhbg0KPiBpbXByb3ZlbWVudCwgYnV0IGxldCBtZSB0cnkgYW5kIHByb3RvdHlwZSBp
dC4NCg0KDQpJJ3ZlIGJlZW4gcG9uZGVyaW5nIGFib3V0IHRoZSB2aXJ0aW8tbWVtIGlkZWEgYSBi
aXQuIEkgdGhpbmsgeW91J3JlIA0KdHJ5aW5nIHRvIGFkZHJlc3MgMiBjb25jZXJuczoNCg0KMSkg
UkFNIHNob3VsZCBiZSBhbm5vdGF0ZWQgYXMgUkFNLg0KMikgV2UgbWF5IGluIHRoZSBmdXR1cmUg
d2FudCB0byBhbGxvdyB6ZXJvLWNvcHkgRE1BIGJldHdlZW4gdmlydGlvIA0KZGV2aWNlcyB3aXRo
IERNQiBhY3RpdmUNCg0KRm9yIDEsIEkgdGVuZCB0byBhZ3JlZS4gVGhhdCdzIHdoeSBTSE0gaXMg
c3VjaCBhIGdvb2QgZml0LiBTSE0gYWxyZWFkeSANCmhhcyBSQU0gcHJvcGVydGllcyB0b2RheSBh
bmQgdmlydGlvIGRldmljZXMgdXNlIGl0IHRoYXQgd2F5LiBJIGRvbid0IA0KdGhpbmsgd2UgbmVl
ZCBhIHNwZWNpYWwgdmlydGlvLW1lbSBhZGRpdGlvbiBmb3IgdGhhdCBzZW1hbnRpYy4NCg0KSG93
ZXZlciwgdmlydGlvLW1lbSBicmluZ3MgaW4gYW4gaW50ZXJlc3RpbmcgKGFuZCBkYW5nZXJvdXMp
IG90aGVyIA0KY29uY2VwdCBpbnRvIHRoZSBtaXg6IFRyZWF0aW5nIHNoYXJlZCBtZW1vcnkgYW5k
IHByaXZhdGUgbWVtb3J5IGFzIGEgDQpwb3RlbnRpYWxseSBjb21tb24gcG9vbC4gRGVwZW5kaW5n
IG9uIGhvdyB3ZSBpbXBsZW1lbnQgdGhlIG5ldyANCnZpcnRpby1tZW0gbW9kZSwgd2UgbWF5IGVu
ZCB1cCBhY2NpZGVudGFsbHkgdHJlYXRpbmcgdGhhdCBzaGFyZWQgbWVtb3J5IA0KYXMgUkFNLg0K
DQpUaGF0J3MgYSB2ZXJ5IHVuZGVzaXJhYmxlIGRlc2lnbiBwcm9wZXJ0eTogSSB3YW50IHRoYXQg
YSBndWVzdCBjYW4gcmVzdCANCmZhaXJseSBhc3N1cmVkIHRoYXQgaXQgb25seSBldmVyeSBwYXNz
ZXMgZGF0YSBpbnRvIHRoZSBzaGFyZWQgbWVtb3J5IA0KYXJlYSB0aGF0IGl0IGFjdGl2ZWx5IHdh
bnRzIHRvLiBJdCdzIG9uZSBvZiB0aGUgcHJvcGVydGllcyB0aGF0IG1vc3Qgb2YgDQp0b2RheSdz
IGNvbmZpZGVudGlhbCBjb21wdXRlIHRlY2hub2xvZ2llcyBnZXQgd3JvbmcgSU1ITy4gSSd2ZSBz
ZWVuIHdheSANCnRvbyBtYW55IGNhc2VzIHdoZXJlIHlvdSBlbmQgdXAgd2l0aCBhIGdlbmVyaWMg
ZnJhbWV3b3JrIHRoYXQgaGFwcGVucyB0byANCmRlY2xhcmUgYSBwYWdlIHNoYXJlZCB3aGVuIGlu
IHJlYWxpdHkgdGhlIHBhZ2UgYWN0dWFsbHkgY29udGFpbnMgYSBtaXggDQpvZiBzaGFyZWQgYW5k
IHByaXZhdGUgZGF0YS4gQnkgY2xlYXJseSBzZXBhcmF0aW5nIHByaXZhdGUgYW5kIHNoYXJlZCAN
Cm1lbW9yeSwgSSBoYXZlIGEgY2xlYXIgZ2F0ZSBvZiB3aGVuIGRhdGEgcGFzc2VzIGJldHdlZW4g
dGhlbSBhbmQgY2FuIA0KZWFzaWx5IHJlYXNvbiBhYm91dCB0aGUgc2VjcmVjeSBvZiBkYXRhLg0K
DQoNCmZvciAyLCBJIHRoaW5rIGl0J3MgYW4gaW50ZXJlc3RpbmcgdXNlIGNhc2UuIEJ1dCBpdCdz
IG5vdGhpbmcgSSdtIA0Kd29ycmllZCBhYm91dCB0b2RheS4gSWYgaXQgY29tZXMgZm9yIGZyZWUs
IEknbSBoYXBweSB0byB0YWtlIGl0LiBCdXQgDQpsb29raW5nIGF0IGhvdyBtdWNoIG9mIGEgY29t
cGxpY2F0ZWQgbW9uc3RlciB3ZSdkIGJlIGNyZWF0aW5nIHdpdGggDQp2aXJ0aW8tbWVtIGFuZCB2
aXJ0aW8taW9tbXUsIEkgYW0gY29udmluY2VkIGl0J3MgdGhlIHdyb25nIHRoaW5nIHRvIA0Kb3B0
aW1pemUgZm9yIDopLg0KDQpIb3dldmVyLCBETUIgYXMgc3BlYydlZCBkb2VzIHJlZmVyZW5jZSBh
ICJ0YXJnZXQgU0hNIGlkIi4gSWYgd2UgcmVhbGx5IA0KbGF0ZXIgc2VlIGEgbmVlZCBmb3Igc2hh
cmVkIERNQSwgSSB0aGluayB3ZSBjYW4gZmFpcmx5IGVhc2lseSBjcmVhdGUgYW4gDQpleHRlbnNp
b24gdGhhdCBwaWNrcyB1cCB5b3VyIHZpcnRpby1tZW0gaWRlYSAob3IgbWF5YmUgc29tZXRoaW5n
IA0KZGlmZmVyZW50KSB0byBpbXBsZW1lbnQgYSBzaGFyZWQgdGFyZ2V0IGlkZW50aWZpZXIgaW5z
dGVhZC4NCg0KDQpBcyBmb3IgcHVyZSB2aXJ0aW8taW9tbXUsIEkgZ2VudWluZWx5IGZhaWwgdG8g
c2VlIGhvdyBpdCBpcyBhbiANCmltcHJvdmVtZW50IHRvIGVpdGhlciB0aGUgY29kZSBmbG93IG9y
IHRoZSBkZXNpZ24gcHJpbmNpcGxlcyBJJ20gdHJ5aW5nIA0KdG8gYWNoaWV2ZSB3aXRoIHRoaXMu
IFdlIHdvdWxkIHN0aWxsIG5lZWQgYSBzcGVjaWFsIHB1cnBvc2UgYWxsb2NhdG9yLiANCk9yIG5l
dyB6b25lcywgd2hpY2ggTGludXggaGF0ZXMuIEFuZCBhbGwgd2UncmUgZ2FpbmluZyBpcyB5ZXQg
YW5vdGhlciANCmRldmljZSB0aGF0IG1haW50YWlucyB1c2VsZXNzIHN0YXRlIHdoaWNoIGVhdHMg
dXAgcmVzb3VyY2VzIGFuZCB3aGljaCANCnJlcXVpcmVzIGFkZGl0aW9uYWwgaW50ZXItY29ubmVj
dGlvbiBiZXR3ZWVuIGNvbXBvbmVudHMgdG8gcHJvcGVybHkgDQpkZXNjcmliZSBhbmQgdGllIHVw
Lg0KDQpNYXliZSBJJ20gbWlzc2luZyB0aGUgcmVhbCBwb2ludCB5b3UncmUgdHJ5aW5nIHRvIG1h
a2U/IDopDQoNCg0KQWxleA0K
