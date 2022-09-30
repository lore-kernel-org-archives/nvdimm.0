Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCB55A66
	for <nvdimm@lists.linux.dev>; Fri, 30 Sep 2022 15:57:46 +0000 (UTC)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28UDJnCN028767
	for <nvdimm@lists.linux.dev>; Fri, 30 Sep 2022 08:43:24 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3jx18b8eqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <nvdimm@lists.linux.dev>; Fri, 30 Sep 2022 08:43:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chYAGHQrjibBbjvQR0TkC5BSH7yde5tYyOO8pWbDshHVdCtZbGGFTgIfq9+uwSUQ6brFmqA5mcpN51QHh/Qsdwslly52ExAnbFp4+ZL9n3riiXrN97E5bJKBprdSSihvjhk+BDxi3LSTdwbDV5pzi4RS0XT5WRkZU7gVR3OWPrY26NyXOnYvu0pSVdryP4trsANZTyPIeXzblheWoC+S4zEzjmrinfgjG2sKcQ4GoBd1cQ+iOQu2Tn8w4e0fzzcFSM12kkt2NsG7nMWQEaAGslrakcCV5ExFpZvFKsMvDBwlwqDRIaYLj+nxlvikZzrnwOT3GopFjIx3lJCFPugn+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9y40qsr/t/iigfV2043NIJ7vzQsb3IqhYxybFrZFdww=;
 b=jl5K9nozJ5dNNSg1BaenQCqDWgS59/1KOZXyvIKzxA2a7AM888aZfQYLKFIYXArpDGlzasIny22oTp6SZbN6+egRGwqS1dAaJDrNL8kJa5Q7hO1ARLWWHvfamlrNCoIoqcsId2YHajaXYyKCCWLirLK+bh1d4rV2jePQcaKzU3vvt964rYXR5NYHipRDlCh0K+GIStCTjcifc9HIvXbN4T5xGbXAQBrcJr/0EgaS0t0uYFhQ5LKW82YTbVaXOzD/mwqlLZD9Y0QvVJoDUqzGaVntIelBRV7ATwhuBb3sHRkZkrAQibg5q9jyWlDhwU6US3WtEVSbdxXOnrn5ykR8fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9y40qsr/t/iigfV2043NIJ7vzQsb3IqhYxybFrZFdww=;
 b=Lk/flQtaOWiFZqBSUI7GEXb8S58Bu0/wteOc/FYjHw0kjJ2TlD3X7aqskgmr4OF2KezdE0PqNNlYZ474GwFw6UY1KM/mLlqN/lApnoe6EnD05SLok+R5ojGzI5NonSDwjM0thWzb6Y7PA1vpHXYloWeaFDDdppofowvU8tePYuU=
Received: from CY4PR1801MB1896.namprd18.prod.outlook.com
 (2603:10b6:910:7b::25) by PH0PR18MB4037.namprd18.prod.outlook.com
 (2603:10b6:510:2e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Fri, 30 Sep
 2022 15:43:21 +0000
Received: from CY4PR1801MB1896.namprd18.prod.outlook.com
 ([fe80::4320:3128:f843:13cd]) by CY4PR1801MB1896.namprd18.prod.outlook.com
 ([fe80::4320:3128:f843:13cd%6]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 15:43:20 +0000
From: Dharmesh Pitroda <dpitroda@marvell.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: [cxl PATCH] add support for CXL mailbox command
Thread-Topic: [cxl PATCH] add support for CXL mailbox command
Thread-Index: AdjU4xYF+WVSeMRRTJSjENv6gLgFCQ==
Date: Fri, 30 Sep 2022 15:43:20 +0000
Message-ID: 
 <CY4PR1801MB1896EA05EAD04A6A954106ABC9569@CY4PR1801MB1896.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJuZGN0bF9tYnhzdXBwb3J0X3YxLnBhdGNoLnRhci50?=
 =?us-ascii?Q?Z3oiIHA9ImM6XHVzZXJzXGRwaXRyb2RhXGRvd25sb2Fkc1xuZGN0bF9tYnhz?=
 =?us-ascii?Q?dXBwb3J0X3YxLnBhdGNoLnRhci50Z3oiIHN6PSIwIiB0PSIwIiBoPSIiIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMCIvPjxhdCBubT0iYm9keS5odG1sIiBwPSJjOlx1?=
 =?us-ascii?Q?c2Vyc1xkcGl0cm9kYVxhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00?=
 =?us-ascii?Q?YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTk4NjJlNTdhLTQwZDYt?=
 =?us-ascii?Q?MTFlZC04NjFjLTA4OTIwNDhiZTA3NFxhbWUtdGVzdFw5ODYyZTU3Yy00MGQ2?=
 =?us-ascii?Q?LTExZWQtODYxYy0wODkyMDQ4YmUwNzRib2R5Lmh0bWwiIHN6PSIzOTQ0IiB0?=
 =?us-ascii?Q?PSIxMzMwOTAyNjE5NTI0NjIzODIiIGg9IkpwRjlQMmpreEdDVExWK0FGUUdt?=
 =?us-ascii?Q?My9JdGUxUT0iIGlkPSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFS?=
 =?us-ascii?Q?U1JVRk5DZ1VBQVA0RkFBQXVmcjFhNDlUWUFjeTM3aVVJN2hSRHpMZnVKUWp1?=
 =?us-ascii?Q?RkVNSkFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFIQUFBQUNPQlFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFFQUFRQUJBQUFBNlBxZWxBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBSjRBQUFCaEFHUUFaQUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFC?=
 =?us-ascii?Q?ekFIUUFid0J0QUY4QWNBQmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3?=
 =?us-ascii?Q?QUdnQWJ3QnVBR1VBYmdCMUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJqQUhVQWN3QjBBRzhBYlFC?=
 =?us-ascii?Q?ZkFITUFjd0J1QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFB?=
 =?us-ascii?Q?QUFnQUFBQUFBbmdBQUFHUUFiQUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0Jv?=
 =?us-ascii?Q?QUdFQWRBQmZBRzBBWlFCekFITUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFB?=
 =?us-ascii?Q?WkFCc0FIQUFYd0J6QUd3QVlRQmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxB?=
 =?us-ascii?Q?SE1BY3dCaEFHY0FaUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFIUUFa?=
 =?us-ascii?Q?UUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFCc0FH?=
 =?us-ascii?Q?VUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFB?=
 =?us-ascii?Q?QUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJQVpR?=
 =?us-ascii?Q?QnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFB?=
 =?us-ascii?Q?QUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIUUFa?=
x-dg-reftwo: 
 UUJ5QUcwQWFRQnVBSFVBY3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBQT09Ii8+PGF0IG5tPSJuZGN0bF9tYnhzdXBwb3J0X3YxLnBhdGNoLnRhci50Z3oiIHA9ImM6XHVzZXJzXGRwaXRyb2RhXGRvd25sb2Fkc1xuZGN0bF9tYnhzdXBwb3J0X3YxLnBhdGNoLnRhci50Z3oiIHN6PSIzNDIzIiB0PSIxMzMwOTAwNjA2MzAwNzUzMDAiIGg9ImpENFYwM3lWaTBkTkx5T3NXOURjTkdiZ3B6VT0iIGlkPSIiIGJsPSIwIiBibz0iMCIvPjwvbWV0YT4=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY4PR1801MB1896:EE_|PH0PR18MB4037:EE_
x-ms-office365-filtering-correlation-id: d2eb722d-dd1d-4aeb-5632-08daa2fa8074
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 FAVHtpqhIhgnFf3JIl0NG8a0nOPcTBaAF7M7TRYQxEhyBn4hhmQhwgRJm0hnve4sie08WXRNMdYo4yjuEMlLeW23Wog6JGpZUuTptQklenr2wy2ek+ei76N4SsVefHkuCawAJswarekpbbGqubXYUvqv1A7GD3xXwG7BKvgletxJJKHzOgSPxENK0VJuDlER6paE24YgydofnrCC7UnKR7kBBA/YpFONrgvRHZR1U5yoGVRRSZlSyIrLyydMC6uMVtgFhKRH+p82+wxm+WHkKp/2cCA9hp34Aj/BE2iIDSTBBr7Np1UxDsnYlWD3HIJA5CzJ9Z5tyBNpTyPnGLEevAAiLe+M9TDurydZ/UovGq+uxt9vwaOm8G9kJ4adQAMIe9w5FmRFRxrkTx7/R7EalkNe8lUJJ+P6K+ePoWVp96xDpYrVSjVCYPkcWonX4H8Us76doywZcTVsOYVy+brMuJssBwKSlSheBgDQKdQiKt8of0NNZyKk1d4vbM6Wz+KpsCb+WVgLDcRx6p9JWgSpO1oDeD7/d9kLlXIeDj01WEbtXQbPc4WtV2YXkk8f0pRG2Cfpr14Mfelw3CxaA99XBv0h7EzfSYK5FJ+XXti+7+4O2TNOyYcf4fOzUiW517iqVymPHteBzbfBOwrO9GWsqZrVImk76byMeS8nIhVcCNc+sWUrEzGxzUDzBrIe7xEx6sXB1qXZav8Oe8gFX+Bnwg==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1801MB1896.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199015)(38070700005)(66556008)(478600001)(71200400001)(38100700002)(316002)(5660300002)(64756008)(33656002)(66476007)(41300700001)(66446008)(55016003)(8676002)(52536014)(66946007)(122000001)(8936002)(6916009)(76116006)(83380400001)(9686003)(99936003)(186003)(7696005)(6506007)(86362001)(15650500001)(2906002)(4744005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?qYRUs4jc/6CeU4uiMEgs1siLSCwmr9eXK4jlmvSHt5fET8A+SDmv4Sk/pJ2R?=
 =?us-ascii?Q?2RJ4TzbEcaJVRsOS2N5gsqKvBKrM0ssktWBr6JrvhmV26/WZRXYO273aORMZ?=
 =?us-ascii?Q?qzSWBG0s19266QD1bZYCg0QwDbnqRnJzTrQ0lryfNvyDTVQD2Vpfc56ES32I?=
 =?us-ascii?Q?xWw2yIk3/oLcxpFDYj9Qn/RBTX1hyffgFTGLetNRy4Gzhs/YpFyW/OKn+IMM?=
 =?us-ascii?Q?YPzcABW03F9CFAyQmLd4MdVEhgvrKznDm2hM22G9D3+gxVwZnxVoa/RUxlZ6?=
 =?us-ascii?Q?ivRdU22hw65IWteJncfzBN9y+X7dN7J73odUFzSYppBkdjAYPaz0B7B84YHr?=
 =?us-ascii?Q?z1wRQZF7P4GVPSIblGAQ0ii6yEWTbuErClMH7RmcFNyihpvZGBMt6GjfX8Cc?=
 =?us-ascii?Q?LRR01ZLiak5/X9j3cX3QKUxTwzR05IIupt4g2AUx3VxcR/TrKzRZO1XZBu09?=
 =?us-ascii?Q?u8HNjOWOb5WyZVilVjXlYRvO1nmf7wyW86RMmcbMmYbc2mpfD712v9z+Yq/m?=
 =?us-ascii?Q?twF4TNBdpvZ9VG+rnWzfHo+6WROj6vpK+yb0B56TXdqVDfafI78rEM1xTGse?=
 =?us-ascii?Q?DIOuoKV1Sw5jU7NZFNCkwxBmu8zWyS6zg7FCCpIJ6kNX9nYuk3jnKw1Tvcar?=
 =?us-ascii?Q?CBASLm+1Yvw5g5I0mafhsyao/b5ti/Q6Wf5MAGsHEK4AppSMZIA+7OObtBpB?=
 =?us-ascii?Q?9vaPCjXWQW77fzQcxNGahxQFa6PdJyKSS1O8jIUCHRCwVDVTSCjltpRh2h9M?=
 =?us-ascii?Q?icsPmlxGJl+KgsPJ/tqfp0ozbPlIOBFQI4WdmpUTRZ2M4XDq+Uwj7o9+esCu?=
 =?us-ascii?Q?GKtvA1oDeYtXvFiQ1t4PszCEvO7cCgdF9lZ3bVG25INh3BYVLHkQ0Rs+TkHf?=
 =?us-ascii?Q?6u5bY8cWqpPk8TXArKbyrEBWSvQV3VXGMDnpmjDDXgcWA6TQb4pygsbZYLDG?=
 =?us-ascii?Q?8W7uzCn+jsqo+tN894HAZEBSuzxn7hepncRnzUgWn5YiGDKAyEHgcZ4NVqek?=
 =?us-ascii?Q?EKsN19TRY13rvocGulopa8e+QyYmlf32++1+n69LD+bak3CKl36MUbz+NOXJ?=
 =?us-ascii?Q?aw+v1m4iQKOmIki+LdpQ/3OqH/kOgmlHH9qTj7KGys2njGKuA/1PUTobx045?=
 =?us-ascii?Q?OnWK+/FAGTKorv4qEU1jA83tGsYmSkbe6FbCMePeSiO+prL36wzJSnzweCld?=
 =?us-ascii?Q?cO6baLHe+XBWLt0HYF2U3iIw26TDBWu5YrMSs1W9yRWN++bgdREuHFop/hZQ?=
 =?us-ascii?Q?i7T5mT/IN4vrKZG6UfDXy8pZb5H+kEjTEx/eZPhIPdbaXJBX6eevC8WYq37O?=
 =?us-ascii?Q?2w07UCiei0lPrLj2a4OlSxDGZL0CG8FNkaUn7M9EPv58VAO4UM5IPNdMaUf1?=
 =?us-ascii?Q?dOUQgMiXM2Glu6Bs9dcLGWpwqHd6NGFQlRgWqfuHt7sV2fJz8hoZK9Wgv5hm?=
 =?us-ascii?Q?4iLYbFc9IelyhRnl8tyLfXD92+FZ+JtVVByUoEV5BYkyHO/sB+MZ3PRrHDWx?=
 =?us-ascii?Q?8xyhyfn14nSGry+FWnFRO28a6rLG5/HU2dbH5VMOYuvvDJgibvdtS0GJNNwj?=
 =?us-ascii?Q?8ZM5ncswOWxw9krIcgbIiHlqI3JvGEfbDbfrf6t1?=
Content-Type: multipart/mixed;
	boundary="_004_CY4PR1801MB1896EA05EAD04A6A954106ABC9569CY4PR1801MB1896_"
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1801MB1896.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2eb722d-dd1d-4aeb-5632-08daa2fa8074
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 15:43:20.6509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MKt7RkxEPA8Rt4PxLXYR4IAP+4w1zS7ktCrVuKi9v0kRf71kLxV1kA3mtNwttLbeyzXcRqEJOPbkoWx3lDDNPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4037
X-Proofpoint-ORIG-GUID: GIOfPRAKIhm6BRG0hkv4WCxXUxmAcTjR
X-Proofpoint-GUID: GIOfPRAKIhm6BRG0hkv4WCxXUxmAcTjR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-30_04,2022-09-29_03,2022-06-22_01

--_004_CY4PR1801MB1896EA05EAD04A6A954106ABC9569CY4PR1801MB1896_
Content-Type: multipart/alternative;
	boundary="_000_CY4PR1801MB1896EA05EAD04A6A954106ABC9569CY4PR1801MB1896_"

--_000_CY4PR1801MB1896EA05EAD04A6A954106ABC9569CY4PR1801MB1896_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

change detail- add support for cxl mailbox command from "cxl" cli

update cxl code for all supported mailbox command, start with 2 basic mailb=
ox command get-partition-info and get-supported-log

[root@fedora dp]# ./cxl/cxl --list-cmds
version
list
help
zero-labels
read-labels
write-labels
disable-memdev
enable-memdev
reserve-dpa
free-dpa
disable-port
enable-port
set-partition
disable-bus
create-region
enable-region
disable-region
destroy-region
mbx_get_partition_info
mbx_get_supp_log
[root@fedora dp]#
[root@fedora dp]# ./cxl/cxl mbx_get_supp_log mem0
num_of_sup_log_entry =3D 1
log_identifier =3D 0d a9 c0 b5 bf 41 4b 78 8f 79 96 b1 62 3b 3f 17
log_size =3D 52
cxl memdev: cmd_mbx_get_supp_log: get_supplog 1 mem
[root@fedora dp]# ./cxl/cxl mbx_get_partition_info mem0
active_volatile =3D 0
active_persistent =3D 2
next_volatile =3D 0
next_persistent =3D 0
cxl memdev: cmd_mbx_get_partition_info: get_partition 1 mem
[root@fedora dp]#

Attaching patch.

--
--
Regards,
Dharmesh


--_000_CY4PR1801MB1896EA05EAD04A6A954106ABC9569CY4PR1801MB1896_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Consolas;
	panose-1:2 11 6 9 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72" style=3D"word-wrap:=
break-word">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:&quot;Ar=
ial&quot;,sans-serif;color:#222222;background:white">change detail- add sup=
port for cxl mailbox command from &quot;cxl&quot; cli</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:&quot;Ar=
ial&quot;,sans-serif;color:#222222"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:&quot;Ar=
ial&quot;,sans-serif;color:#222222">update cxl code for all supported mailb=
ox command, start with 2 basic mailbox command&nbsp;<b>get-partition-info</=
b>&nbsp;and&nbsp;<b>get-supported-log</b><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:&quot;Ar=
ial&quot;,sans-serif;color:#222222"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:Consolas=
;color:#222222">[root@fedora dp]# ./cxl/cxl --list-cmds<br>
version<br>
list<br>
help<br>
zero-labels<br>
read-labels<br>
write-labels<br>
disable-memdev<br>
enable-memdev<br>
reserve-dpa<br>
free-dpa<br>
disable-port<br>
enable-port<br>
set-partition<br>
disable-bus<br>
create-region<br>
enable-region<br>
disable-region<br>
destroy-region<br>
<b>mbx_get_partition_info<br>
mbx_get_supp_log</b><br>
[root@fedora dp]#<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:Consolas=
;color:#222222">[root@fedora dp]#&nbsp;<b>./cxl/cxl mbx_get_supp_log mem0</=
b><br>
num_of_sup_log_entry =3D 1<br>
log_identifier =3D 0d a9 c0 b5 bf 41 4b 78 8f 79 96 b1 62 3b 3f 17<br>
log_size =3D 52<br>
cxl memdev: cmd_mbx_get_supp_log: get_supplog 1 mem<br>
[root@fedora dp]#<b>&nbsp;./cxl/cxl mbx_get_partition_info mem0</b><br>
active_volatile =3D 0<br>
active_persistent =3D 2<br>
next_volatile =3D 0<br>
next_persistent =3D 0<br>
cxl memdev: cmd_mbx_get_partition_info: get_partition 1 mem<br>
[root@fedora dp]#&nbsp;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:&quot;Ar=
ial&quot;,sans-serif;color:#222222"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:&quot;Ar=
ial&quot;,sans-serif;color:#222222">Attaching patch.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:&quot;Ar=
ial&quot;,sans-serif;color:#222222"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:&quot;Ar=
ial&quot;,sans-serif;color:#222222">--<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:12.0pt;font-family:&quot;Ar=
ial&quot;,sans-serif;color:#222222">--<br>
Regards,<br>
Dharmesh<o:p></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_CY4PR1801MB1896EA05EAD04A6A954106ABC9569CY4PR1801MB1896_--

--_004_CY4PR1801MB1896EA05EAD04A6A954106ABC9569CY4PR1801MB1896_
Content-Type: application/x-compressed;
	name="ndctl_mbxsupport_v1.patch.tar.tgz"
Content-Description: ndctl_mbxsupport_v1.patch.tar.tgz
Content-Disposition: attachment; filename="ndctl_mbxsupport_v1.patch.tar.tgz";
	size=3423; creation-date="Fri, 30 Sep 2022 15:41:00 GMT";
	modification-date="Fri, 30 Sep 2022 15:43:19 GMT"
Content-Transfer-Encoding: base64

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
UAAA

--_004_CY4PR1801MB1896EA05EAD04A6A954106ABC9569CY4PR1801MB1896_--
