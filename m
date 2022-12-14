Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296DF7F
	for <nvdimm@lists.linux.dev>; Wed, 14 Dec 2022 01:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670979768; x=1702515768;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2tu6L220PUZbxZX70sVjqyPTxUPHF4pWq4wZqFeBqxI=;
  b=VJFORfXA1Y+TTD4ZJC9W1PQ8AFZ8pGbUNcSMD8te6nWvWlx0B7Gd35BE
   xpXfme9IO2kM3y2+ldxLkP01/DNAxVm4DKc8yG5sipiJzsA9zZSq1VoYp
   oNGp2L1NfkANhsaCsf15G4yPk5O02JrOHawM91esGYmBngbee521Vkuyg
   w8i37rjKk+FayJFh9Lo4IOpui9V2eufpR87YPfPV9S1W2ESynAu1TF7qs
   mQTzHVUIk53DNpJgWeIl7aRqz/rQmE9TzsJcGg3oBuItp2IZLc5tLg5xn
   5A5zCfv59nUABNQwc0ZvJTZy3buyYOQ2yt17q+X2qfKYjRMwfX82iiVYN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="298626581"
X-IronPort-AV: E=Sophos;i="5.96,243,1665471600"; 
   d="scan'208";a="298626581"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 17:02:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="737559876"
X-IronPort-AV: E=Sophos;i="5.96,243,1665471600"; 
   d="scan'208";a="737559876"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Dec 2022 17:02:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 17:02:46 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 17:02:12 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 17:02:12 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 13 Dec 2022 17:02:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhsDaCPVkobVBt6l23W+o6vpga6hpqtC+MyBCN7QdSB37lJsvyRt25WzWIgZapz75hfM3Rp/OH4bLUWUuSUbIHhUhHP/u6NoGXCLU8QBmHnE3xzVxAua6i4V9yOQBWVel1AupiohLtOfOeuBvt12QF3abLnSWigP0k23aeLstPTsXtoE3w/3GxUIVvrLmU8osBmHZ6G+j9J2wtpvtIPefXV7+80TmwxNisnl5zOPiRKyBOxz3G7sbg4YRWR1zMwROArU08ulwmcdD56i4pUFbs+0vDrgqo4mn3kB1H//h4L/Gm6y4ygWAnyGumAUu8eQwWd/W7rPB8fd9y72R886DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5PMJ3mBMDHxETptSAvq7bKno4Gqv03OniJa7h5t9O5I=;
 b=BnSmgQY/cQx+GSAH/ukAiQLpXOV1M36H2ktBA+EFtn4BhekF0QFAAL1ZqXfnGkfglJU5qamTsCctSeciBJ/eHhWAK7qySxYOdgkGrjuXHvE+3Z7NKkpP1d8KN+DYJsusLP3wenlHiVPQVUouC9W9UzTLhF7RJ34R2mj6rsQNzyQSVrCyJ7akDnHnMoeK8nTfIrhFTu8vWkgmbZDHtwRhxMTWJBe7DhhmRSN3TO6MBfaQoNA8hG+H84XEO84+UhPofFTfFw9tMMEzzjf5iwnhFcAKXNbk+j7YXKlnioWYnzSmVfYpd+oFu3lv/O4sg9hHIm0ofJO5oK9oYyUzosYkwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CY8PR11MB7900.namprd11.prod.outlook.com
 (2603:10b6:930:7a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 01:02:03 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 01:02:03 +0000
Date: Tue, 13 Dec 2022 17:02:01 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <vishal.l.verma@intel.com>
Subject: RE: [PATCH 4/4] ndctl/test: Add CXL test for security
Message-ID: <63992089c1243_b05d129451@dwillia2-xfh.jf.intel.com.notmuch>
References: <166379397620.433612.13099557870939895846.stgit@djiang5-desk3.ch.intel.com>
 <166379417897.433612.16268594042547006566.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166379417897.433612.16268594042547006566.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: BY5PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::38) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|CY8PR11MB7900:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a18158-e44c-43e5-c1e7-08dadd6ed018
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bS0IOswNykwxMQZnNaX0KYP0jX5fdu4Kb8MME0B5Kgga/MIBykgoYXVWT3eGpsmv96dxtb3YW/XXoPBVcDlg49F/jHQ4geZ39m2z8wdL7PnLbo1Ab8XfHegDrT8uNuV2pHghcAAPVvE4CYUht0kq/vOasdNWqwlIoTv0ypX6JezreMsqcqe6aPGiI9dzOOUmVne18hVMpHOHEG0/+PfOIZXLarvdG4bYnpHrkKAOAejn/AQsY9yGFVvywkqL4Q5pIQbRYS8Jsb9Jb1vxg7WFUo8aVntxWzpZo5mKJFgIGZOm8JOo6E/4wKaGIjj5wD6xqUswTtJAsSo2WBkiHq8WJns1gNfaZF1JBnKwiKG+cO5rCxCT30p+VbfqJD6EG7OYjZBsULcfk69+lYwkaKLGHYTUTMVt7gNTFFLhqmqmtrAlNw+cCtQLO1njz8WObWBXKrh5AhH8yble3w1VfBKghNIk4cO1lB9/wTgr+uFph1ovINJnJr6rKqeUIPZvt3quVCAa09IcDq8ZAvUJp/EignMqceKv500icgl2lLsZue4nHv1GWtIs3l2VrAypoTbWiZ6mNKqEod3PFb0NkBxliyLms/IzA04yNFbWU6Sz6n1D0F9WHUe8TAQYwjlX264pZ2zeVXDYGC2sIyOQ58j5xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199015)(2906002)(82960400001)(15650500001)(38100700002)(8676002)(4326008)(26005)(6506007)(6512007)(107886003)(9686003)(86362001)(66946007)(8936002)(316002)(6486002)(66476007)(66556008)(5660300002)(478600001)(41300700001)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lWLoVXB/crURtmRW3avJPaT/UF7HotBjbQZqV09NoKOQwkzGenNUDxA+ktol?=
 =?us-ascii?Q?yyPO5mhPbsxDl3yWcGvtCoE/hNyFOz3bmlwxk6BjMQemx98GooMoP7FAvWYS?=
 =?us-ascii?Q?TvcRarlqFYi5KN3URVJ5N/zN+IytLNaKI+3wvU5RwsoGzCyPW4yMXk6TWpnf?=
 =?us-ascii?Q?uwdEu3qwgu+J9dljI3H/tpqWxOiPA+73de89HmyZV3Zrp7ap+FF5vk1BTDIG?=
 =?us-ascii?Q?DpEey4O5gUhK5eSPNHTi8KjWsHWvYywx1YH6eRPv+Sz7GePVSGqEg3UhTMx2?=
 =?us-ascii?Q?tdclvzV8LYHbWo04TeLopA3Jd23og6gtW7Wdt1UuvMH7gw7io0sqZEBcJ6Er?=
 =?us-ascii?Q?DNZsj96ugMFXaKiuADey93d5CRjXp81Z13W9unBg4IuJ3VpIgAbP+8we8jKq?=
 =?us-ascii?Q?X4Hqo7ID+aIKm/obJTyX1zKzqZoM/jqynJ+4uBOTTzbcN/3SDWqhbJsL/41N?=
 =?us-ascii?Q?X8e9VcX5OwN941hvan940yHtPPlpjf/xLm3kh3pMwQvifE0095sFOIL2bhmZ?=
 =?us-ascii?Q?F5NVHJJpEqn91UBvxbXcgmnQRyHHPpVInCNiMzi3CJVoYYrXNxb1+qODjJN8?=
 =?us-ascii?Q?MAADyXggx/Sy02tEO7wFanCxLMnBJBFtiHaShV53f22rz0B1TnByPKtd1tOH?=
 =?us-ascii?Q?K1TBdpKpPG28BRRov27Xo5+HgFNe9dGZHthHoRfG8rKHf/wOWPsrMktcR0oZ?=
 =?us-ascii?Q?u296YuJeS4yaWozqkRhRaEn1qLlMDATTZbVoRt9bB3Jakvmo9HJioWwf8xwA?=
 =?us-ascii?Q?3gOBdpkQozRAQkRCkwZz2Iw+/m7ToRF3wVBWKRniCtV5+xFgKYfw4hnfy92/?=
 =?us-ascii?Q?e+fgzpbBi/ER4qlEhFR1Aya7hYB7ka63IMNLoBtaBhVCDWPR5qAMn8YDexLV?=
 =?us-ascii?Q?j/VzsUCkEA/8TQAi5u4vJiGafQe87eJF6Bkfrs0HM0DDpuKkYhQB8Ab7lkZg?=
 =?us-ascii?Q?c6wg8Sv2pkqazJ7HhOt6tWB9+PujF0BvGBVQA0o08sz8YP8OvBLEwl6PBDQr?=
 =?us-ascii?Q?ifeIkmvBc0kCgCSSW21NqtfuLxD4oFaj8Xn2S23YquCoaUE66sozy9z2bs9F?=
 =?us-ascii?Q?8lV5AZQ4TM0rkUr2KVixpVYS8XOmaTQB4gs0TJwo2bR/3hkFoJqqvQlRtJRH?=
 =?us-ascii?Q?03P5MRFfLGCgH6dqBY+G+6kK6XtgeH2u6yCrfUkhcNq2qz8VwJqDonNj9/C6?=
 =?us-ascii?Q?quSJICkTZFnrnoOGiD3Id9rz3b5hBvU+bsSLAH016emBfzJY0hP8lCzqmYGX?=
 =?us-ascii?Q?+cZKVMCcgdDzxjMts04AWjrjwFXgaDCmXHMbQJ9vfy5KwHh/DFJSbb/E5z46?=
 =?us-ascii?Q?BVnjwCSja7sWjUf29sjFndlEq/fXwM2ygV9oNtXdK9KQZpVvMKefI4lYbJHp?=
 =?us-ascii?Q?S3tVP/0fprHGsF42z65N6kUKZY+/SOlOk6oSbS1vZT4+fIxefJ0i/0+GGH64?=
 =?us-ascii?Q?YbRhgME6JBkeT5LcyX4KUn2Jtf+6wgvkfwZ2VJ4Puoaugb37F2/Yz0WrvvYF?=
 =?us-ascii?Q?++LTo7LoZfohaUqAKHzOyZyIMnOrmcHYHa1gzj1D8oj0za2KKy7BGx2OYjtt?=
 =?us-ascii?Q?scwqvM7MhWWaPRP2eIhbF6YmySZM7Ss2bgdLlHVGuQVVwUmV5n2qd+oqllRy?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a18158-e44c-43e5-c1e7-08dadd6ed018
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 01:02:03.5333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qyTfYJVgP/Wj0Xw9pwcHnFEOtYQByuOKb9irR0ahlpRXpjFJnA1sfwh9CUV30UR6UwNe4xWD650MZXDvqb9xToWg4N4dUfcZyo4nFB9AVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7900
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> Create security-cxl.sh based off of security.sh for nfit security testing.
> The test will test a cxl_test based security commands enabling through
> nvdimm.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/common          |    7 +
>  test/meson.build     |    7 +
>  test/security-cxl.sh |  282 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 296 insertions(+)
>  create mode 100755 test/security-cxl.sh
> 
> diff --git a/test/common b/test/common
> index 65615cc09a3e..e13b79728b0c 100644
> --- a/test/common
> +++ b/test/common
> @@ -47,6 +47,7 @@ fi
>  #
>  NFIT_TEST_BUS0="nfit_test.0"
>  NFIT_TEST_BUS1="nfit_test.1"
> +CXL_TEST_BUS="cxl_test"
>  ACPI_BUS="ACPI.NFIT"
>  E820_BUS="e820"
>  
> @@ -125,6 +126,12 @@ _cleanup()
>  	modprobe -r nfit_test
>  }
>  
> +_cxl_cleanup()
> +{
> +	$NDCTL disable-region -b $CXL_TEST_BUS all
> +	modprobe -r cxl_test
> +}
> +
>  # json2var
>  # stdin: json
>  #
> diff --git a/test/meson.build b/test/meson.build
> index 5953c286d13f..485deb89bbe2 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -219,6 +219,13 @@ if get_option('keyutils').enabled()
>    ]
>  endif
>  
> +if get_option('keyutils').enabled()
> +  security_cxl = find_program('security-cxl.sh')
> +  tests += [
> +    [ 'security-cxl.sh', security_cxl, 'ndctl' ]
> +  ]
> +endif
> +

I had this folded on top for my local testing:

diff --git a/test/meson.build b/test/meson.build
index c9853421ce69..1df115f82fef 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -216,15 +216,10 @@ endif
 
 if get_option('keyutils').enabled()
   security = find_program('security.sh')
-  tests += [
-    [ 'security.sh', security, 'ndctl' ]
-  ]
-endif
-
-if get_option('keyutils').enabled()
   security_cxl = find_program('security-cxl.sh')
   tests += [
-    [ 'security-cxl.sh', security_cxl, 'ndctl' ]
+    [ 'security.sh', security, 'ndctl' ],
+    [ 'security-cxl.sh', security_cxl, 'cxl' ],
   ]
 endif

...although I like Vishal's suggestion to name this cxl-security.sh to
match the other cxl test in the suite.
