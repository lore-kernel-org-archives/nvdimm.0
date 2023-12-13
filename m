Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E1A39F
	for <nvdimm@lists.linux.dev>; Wed, 13 Dec 2023 00:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MzCoGaFL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702427699; x=1733963699;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=20JlBWEGd0BMPZeHPTt+Sn95wqbfOkgpdEKzBTZP8SM=;
  b=MzCoGaFLoTa18kcwx/t3fbHHNj0tblOOkGS17EqaJ60vzvL0i8n9Dxl1
   oe2PtRxD8QfBW6KZIdxWWj6yV+eK0NmiPAy9nF6I9lRIIlT29M+Ld5ww5
   6EWp9ixGsDW8Xo6cLaYSua4Yoedk70XABl0SD9sEC6b/+liQ5F2sBFjP/
   p2L2KgP5jVbyjmXZcgaTkF5GINBzTlxKMte/5Qse8t1kis1V2eZL/Pc51
   GmTgsTsCSDQBzBAWWzedw6I0mhy8kznU4Dy4JhfRyzAQ6LYpdCmvA1W6e
   shdmNY2m/FOZY/8obYcGUZAUBm+kA/+g3wko9f0ahAuxlkO+Xl3hIdLAY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="375045278"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="375045278"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 16:34:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="777285621"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="777285621"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Dec 2023 16:34:56 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Dec 2023 16:34:55 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 12 Dec 2023 16:34:55 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 12 Dec 2023 16:34:55 -0800
Received: from MW3PR11MB4604.namprd11.prod.outlook.com (2603:10b6:303:2f::16)
 by DS0PR11MB7926.namprd11.prod.outlook.com (2603:10b6:8:f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32; Wed, 13 Dec
 2023 00:34:53 +0000
Received: from MW3PR11MB4604.namprd11.prod.outlook.com
 ([fe80::d186:82a4:8b37:5394]) by MW3PR11MB4604.namprd11.prod.outlook.com
 ([fe80::d186:82a4:8b37:5394%3]) with mapi id 15.20.7091.022; Wed, 13 Dec 2023
 00:34:47 +0000
From: "Tsaur, Erwin" <erwin.tsaur@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
Subject: RE: [ndctl PATCH v5 4/5] cxl/list: add --poison option to cxl list
Thread-Topic: [ndctl PATCH v5 4/5] cxl/list: add --poison option to cxl list
Thread-Index: AQHaHOJiaSd/fciOg0uA8GzeJsLsL7CdUGYAgAkrFmA=
Date: Wed, 13 Dec 2023 00:34:47 +0000
Message-ID: <MW3PR11MB4604F798CF42BB0BCF169801E78DA@MW3PR11MB4604.namprd11.prod.outlook.com>
References: <cover.1700615159.git.alison.schofield@intel.com>
 <216ab396ab0c34fc391d1c3d3797a0d832a8d563.1700615159.git.alison.schofield@intel.com>
 <657148ae35bce_b9912945d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
In-Reply-To: <657148ae35bce_b9912945d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW3PR11MB4604:EE_|DS0PR11MB7926:EE_
x-ms-office365-filtering-correlation-id: 1cbed0ed-f18c-4921-c814-08dbfb734f84
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oS71Z7RlU9JC6iyk+XMTpnE8AJHKzDE2XSElyjZizn6O0lTkLquWfRNaTYpD2u0YLy2U2Su+dqxe725JUiOPgx5v3RxIMDvd22HboKXSmk9nrCxumPQTbNfzk+4fJQDkOkDWsEcgySd1+Ao2l0Wa+ZzRlW0UC3N3DoFfLX6sWFDj+wIWchpi2bpYmPBhS7YYbEmUmsvqb/xpkY4KD4YqwwDb22900Y5DXgRgVc50mNFd1WzVHhmyC37tIZO7oIFgIGNcgMchW0xPNUNPVKnbMl88bC4g90tyjderIi2zcZHyIvs8Jd5uN7QpPaeHFvPRV3bxtjnpTDYa8RfT+F+aY9jIagVZ+lhIMlAs1IOHY8Oy3PINK9NiSLtJM3J/0IaC2MPKwpGW9+RjONJ058wk6j1OCVkM7mFvDzZd80BQ1a3CeQzjGJ3tFD3+X387BCn9hijzUUn2LO3ulV7XeBvjKJAshOMGgzxhJysgrpz/nhMEYNLFwQ952TJda0wRaXvL80yf8AQRjnW5lbFktYBPT/K/9lt9uQc9Qy16xTAGYc5LYoY9q47JRRNLvykPrnbgm8Gxa15B1n0txBQ4zWH884BVOIBTbH0Bb5VuNFLcRWpQfwyGeuJDKxYG93TQFNdEx2Po7lqIZrt/mecaIXwcqL8XIrGzirpLLnJhJa5UPY0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4604.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(396003)(366004)(136003)(230173577357003)(230273577357003)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(26005)(52536014)(71200400001)(6506007)(9686003)(478600001)(7696005)(4326008)(83380400001)(5660300002)(53546011)(76116006)(41300700001)(2906002)(316002)(64756008)(8676002)(8936002)(54906003)(66556008)(110136005)(66446008)(66476007)(66946007)(82960400001)(6636002)(38070700009)(33656002)(122000001)(38100700002)(86362001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?50af8dngtVg4dfD9GQrjgO6Ib+Ih4l5cRQkNNnCKh4y5PZbLS4JyHe6R8E7s?=
 =?us-ascii?Q?zPbqG7knweaSsksx82Yv5kFcn8Mqifh1o0dOEgxa6ZwXMYYL0pElrQ6XRdOo?=
 =?us-ascii?Q?GiFzUXfQ/WqbA6J3OfYD6tJ91GFFhcCguUG0LLPgGg3/fGE7Ho8GOQkNlPlK?=
 =?us-ascii?Q?nU+oO5/E1iKEPiG8Bla/c1YC6sV1tAywht5GVxa/FGInAvPiTEWvBTlwb609?=
 =?us-ascii?Q?eQlTYcfcwtuoskyyTmmZ362O8+Wc/wjaPQk/cNupfjINMnxyetJUY6VTrmpd?=
 =?us-ascii?Q?y77nR09QCg3ymtxKVT8MNOhOfkAIS7UpPD2dzqsh91SqRa9DbjgmnA0dp0LQ?=
 =?us-ascii?Q?SQzZVfF+XSWeMITqn92GgtTGYPxEdAkRbdyoDan+hFflf9mzYSgvcPPQW9gp?=
 =?us-ascii?Q?kgOBRnPbTMvUiz7JOctor91N+QKFYrhY0Ze9KX3b3Ab341ZTon6KwsnCewf6?=
 =?us-ascii?Q?adikS6VkurYJE3Q/2W+31BmsR4rF/JyadA1mYICopG55uaATx7ZLL5aQGJyO?=
 =?us-ascii?Q?KCOCSMX2FvGHYztwp6AFfo3wNi5E4sbu6nEePkOMHjoSAVILhR2r8JySzbhL?=
 =?us-ascii?Q?MnwSNmXIOwrIkQ72PoLk9nunmlix3YE2k0DS8EqDQn3tu50O/AehBHl3uYdS?=
 =?us-ascii?Q?JgLH/BvD+7du5YwjoCRAOEZUUCCZx7PNkFb5GRdBmN159GaZN67Cp8N2XlDb?=
 =?us-ascii?Q?U/7ZplYMrq+3mCxRzKSYwkiUhoPfcnZfXbGnnFr3jnWDhwfOiAWvrB4BRrDv?=
 =?us-ascii?Q?1jIlyLz7HBBO2gSQntLn9XgNm4XWtiaPJVdhk5jJcnHMD71PPV/hxNf+1Fit?=
 =?us-ascii?Q?/69MInHNUNFA/AdXTwHlSdAfohh4mc9TRJium9G1IGypfTjyXtUaM8XyBLon?=
 =?us-ascii?Q?zrGXp1pWYJX2jfc4SM6cOlMzYenXYlen+WeYRtFNOY23m+Z7z1DaIyTFMmXL?=
 =?us-ascii?Q?WPUHQ1KeEEPDYpyEQneefdM2RDzFMmY2Ce3CMdrYIPyjLrRhwaVy95VbhgSC?=
 =?us-ascii?Q?ZJoEa0MR6wV1r3LJVIwqjmdRM1c2ZCACXyopmGozHlqHHZCyCMgO2Uvpw4D7?=
 =?us-ascii?Q?3F9zHwR0QaB97X4eUrSOJIVoKbPi4pE4ItIhzN3kPlf1QwzSgFs9MwzVDYCK?=
 =?us-ascii?Q?1nfWlPUKKmcIVKOcbVEBT4blMQCaHUArrYTt2PrRzLOrEWbBL2vp7bQgGKZH?=
 =?us-ascii?Q?Y1qFrVx6J0Ge9kWHfuQEb/sDMuhs6y8TXTvXuQ+VmXNEtgRBlupqBK18i8NF?=
 =?us-ascii?Q?ltTpKNG69SqvprtQvfgCc8CbbTU70HPlniIwqSic1nKP8lvKI2/11DgQt9Z+?=
 =?us-ascii?Q?JF6ypowL8didA2sjLrsMuUtc0vvoe+jtFilt8nBw8wDu6BR274Pi03dEURu7?=
 =?us-ascii?Q?HoGBSqYwtakc+j6CZQp1u1GQLUiiT6579MOs9EJYij1OXb8SpUVI2H0hADPy?=
 =?us-ascii?Q?4riDq8qoMD0j6iyi5sPG5BsyjfgAbYU1qosH35FBTzRWMVGg1JvtRAU4Mv1j?=
 =?us-ascii?Q?uO+M5VHAOIl6aYEebXLW2xowc1vQ5Z9gcG4rNY6DJdZmMh8v+JB/R8pGv6E8?=
 =?us-ascii?Q?z8NoIUdjsyp9NrKRYlw8RsFaEudu4EoIj4T3CuCa?=
arc-seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iyp9iehFgJR5VAvXi4AfvmcL6Hb++jL9s3ybqfIKzQMINMvjktQ44mIVde8HQJZQYUSPJYFb89FZx2ZfUPYL5shJeobJinD4XE49lQ5tdqnwt99/EcCYtuHFnLJyyBHgYjErUjxXBhBFGJOGcXFzaGZDD2ya2Zk+hgVSu3zFxS1hJHL30mqT5BiENcp9TI/jlY0CDQE3aAwV15RyaBWzVM09Xdrv+tqDaj0oRKiTK/a/GQsfNTbfmLUhNA7UcWmXi2nKf0wNTRvl2FKs0Nt2EI2oNKUH1FKRNwwefDA1DJx1KlJeUjsAN2KjLo53AlhFJZh94Quww1N2banZsZypBQ==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fxNPs6E3db1mXswCn8YBnz46U9ZOq55E/HnEIQufOk0=;
 b=Ec2en1x2ra6bvRV766ldUkB1o0jjasNTPfvS6AxdlaMUZEhLWmrAULHR5rF5tUi+LPAxY9fhpCb3yGy7AQaPVSXWuEQyQQCzuQ0TsUsMWYQnABlAt0k3x+J9gFaiSnARSkAk0zA5P2C8qHwF1qsF7bM2VKlKX3UnvCtJG0RaEkhirlAuAA+bTp+pQ6u8NPmXzwsyuUPuJLnYbjzjJTtYznAv64ArF7SwD0Mw+FWjbOJYPEaW/eGeAEUniOoSR8leVeGpD/h2CaJO42A4qGJeakGvEtAReOiJiWEKwqe9xO4aNmOfMoo5ce2RDFYm5YWLQ5mwwE9rcs/GNft+VY8oQw==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: MW3PR11MB4604.namprd11.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: 1cbed0ed-f18c-4921-c814-08dbfb734f84
x-ms-exchange-crosstenant-originalarrivaltime: 13 Dec 2023 00:34:47.6468 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: mnDPw8ZDqzgtz67FajmZjaKLRhJ7MKNtqJmhnOvYMHK/GJtl1ymtogM38QLDaYTdB54Xsz3scET9xpPwoJPvug==
x-ms-exchange-transport-crosstenantheadersstamped: DS0PR11MB7926
x-originatororg: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Some comments inline

-----Original Message-----
From: Dan Williams <dan.j.williams@intel.com>
Sent: Wednesday, December 6, 2023 8:23 PM
To: Schofield, Alison <alison.schofield@intel.com>; Verma, Vishal L <vishal=
.l.verma@intel.com>
Cc: Schofield, Alison <alison.schofield@intel.com>; nvdimm@lists.linux.dev;=
 linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v5 4/5] cxl/list: add --poison option to cxl list

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
>
> The --poison option to 'cxl list' retrieves poison lists from memory
> devices supporting the capability and displays the returned poison
> records in the cxl list json. This option can apply to memdevs or
> regions.
>
> Example usage in the Documentation/cxl/cxl-list.txt update.
>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  Documentation/cxl/cxl-list.txt | 58 ++++++++++++++++++++++++++++++++++
>  cxl/filter.h                   |  3 ++
>  cxl/list.c                     |  2 ++
>  3 files changed, 63 insertions(+)
>
> diff --git a/Documentation/cxl/cxl-list.txt
> b/Documentation/cxl/cxl-list.txt index 838de4086678..ee2f1b2d9fae
> 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -415,6 +415,64 @@ OPTIONS
>  --region::
>       Specify CXL region device name(s), or device id(s), to filter the l=
isting.
>
> +-L::
> +--poison::
> +     Include poison information. The poison list is retrieved from the
> +     device(s) and poison records are added to the listing. Apply this
> +     option to memdevs and regions where devices support the poison
> +     list capability.

While CXL calls it "poison" I am not convinced that's the term that end use=
rs can universally use for this. This is why "ndctl list" uses -M, but yeah=
, -M and -P are already taken. Even -E is taken for "errors".

> +
> +----
> +# cxl list -m mem11 --poison
> +[
> +  {
> +    "memdev":"mem11",
> +    "pmem_size":268435456,
> +    "ram_size":0,
> +    "serial":0,
> +    "host":"0000:37:00.0",
> +    "poison":{
> +      "nr_records":1,
> +      "records":[

One cleanup I want to see before this goes live... drop nr_records and just=
 make "poison" an array object directly. The number of records is trivially=
 determined by the jq "len" operator.

Also, per above rename "poison" to "media_errors". I believe "poison" is an=
 x86'ism where "media_error" is a more generic term.
[ETT] The problem is that a poison can be written into CXL and is NOT a med=
ia error.  Generally... the only way a customer should interpret that a DPA=
 is "poisoned" is that if you consume that address, you'll end up in a MCA-=
Recovery path.  It does not indicate media health.  But see discussion late=
r about "source"

> +        {
> +          "dpa":0,
> +          "dpa_length":64,
> +          "source":"Internal",
> +        }
> +      ]
> +    }
> +  }
> +]
> +# cxl list -r region5 --poison
> +[
> +  {
> +    "region":"region5",
> +    "resource":1035623989248,
> +    "size":2147483648,
> +    "interleave_ways":2,
> +    "interleave_granularity":4096,
> +    "decode_state":"commit",
> +    "poison":{
> +      "nr_records":2,
> +      "records":[
> +        {
> +          "memdev":"mem2",
> +          "dpa":0,
> +          "dpa_length":64,

Does length need to be prefixed with "dpa_"?

> +          "source":"Internal",

I am not sure what the end user can do with "source"? I have tended to not =
emit things if I can't think of a use case for the field to be there.
[ETT] The sources are "external" (poison written into CXL), "internal" (the=
 device generated the poison), "injected" (ie via poison inject) and "vendo=
r specific".
This is how I would use source.
"external" =3D don't expect to see a cxl media error, look elsewhere like a=
 UCNA or a mem_data error in the RP's CXL.CM RAS.
"internal" =3D expect to see a media error for more information.
"injected" =3D somebody injected the error, no service action needed except=
 to maybe tighten up your security.
"vendor" =3D see vendor

How about a HPA? :D
