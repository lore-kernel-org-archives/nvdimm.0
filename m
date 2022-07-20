Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D877B
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 02:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658283352; x=1689819352;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ConLfEHfIqgII5DvNOcLKqcztGM3Rpw3MZg1grzY2vE=;
  b=j77NLOdu6iwL2RJuvIy5nQf6IrbVXMjzkRlsp0Ju0B05FvPqtaEoYa8Q
   SlUogUUdUDkw1vfxlPckzf+YokEE5ePsb6ylg/GwgvJfiqXDh6V/Ux4D6
   sm6rdp5n6GeUj9Qp0mjzWdOOHWFrbwZF6VanHojHn991oU/yNIxMn7Y3T
   RqrPyUHU5408srUyplpLAS/OGdrFO3FkvimBx/s7kamJehqk+WIdNGf3o
   Nw2YyR3aiUNfeJYqTlm+/y52Ma2VjdIrvBxCGVxlKdPQPXFB/Fm5SrW9v
   bQSm4DORqaG9J83+rfSKQS6Ta6k3KwgSS++imSZTEWZzuLKm2A0VRcWz4
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="285423932"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="285423932"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 19:15:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="597899704"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga002.jf.intel.com with ESMTP; 19 Jul 2022 19:15:43 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 19 Jul 2022 19:15:43 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 19 Jul 2022 19:15:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 19 Jul 2022 19:15:43 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 19 Jul 2022 19:15:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hE7aH3WFLk6R8uummZgQ06EJ/5WNJQqZbRFOwlbdIjvk+oN9Ll3HIMd/Cbqabwwv6zPfgn3GAU+4GdHvBNvHaRNGiBxoVZcaNb/rekCdyLZh8cZqFHvWK0kC00vtN9h2BR1XN/dhowfLvp7gPGH6wZuIgpOsRYuhuwU/6dxbLMVAb1yLv9zPiPs2n+vL7y0a+RsqTwnF2Z1IFnr4grH5D1r5gTMJCZTVxUW5tvSzK8q6U4tGkpFybgZLuNuznCrEZVWDzZ2g9Pzch5sYeh+/XoAuc7JCARNPRjjqPBNkq+FsfdrZe+srcg2fXdvAYmfF3LV9yxodMkf6ki9PO+U8qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ConLfEHfIqgII5DvNOcLKqcztGM3Rpw3MZg1grzY2vE=;
 b=Yfd71TyiqndbxcElA4ond0llbqlTBv+nCqYnqE/4YQXuTEpJ7BIyIUQ3Uz0P5NQMR89odpRO0HbRJAsofOEFAK6Eiu2aSwktEAj68W/a4q0gHJvtq8ojSDCFst9RpFfSjV5P7ostJRyxWTFkJMVp5y5/gMoo3RLeGQN/JfAJwjyoeO+X9jnLiK8TUntKbgzxTai4oZblBNr2olE6bWW6WciyNzMuojGI7klkPH1KQNxA7LbQkV38cRIh7FIOsWOFIPHOagQDGWT5wSDfDq5ZBvxNZI17p/NuQW26rhZ0OnbDpSWa64Et/HvI1n8rsW0CqY1b86pLlUFctVcwYQmtSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BN6PR11MB3987.namprd11.prod.outlook.com
 (2603:10b6:405:78::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Wed, 20 Jul
 2022 02:15:40 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5438.024; Wed, 20 Jul
 2022 02:15:40 +0000
Date: Tue, 19 Jul 2022 19:15:38 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH 8/8] cxl/list: make memdevs and regions the default
 listing
Message-ID: <62d7654ab36_11a166294c8@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220715062550.789736-1-vishal.l.verma@intel.com>
 <20220715062550.789736-9-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220715062550.789736-9-vishal.l.verma@intel.com>
X-ClientProxiedBy: BYAPR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::46) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 250ec66e-c889-4204-0471-08da69f5bdd3
X-MS-TrafficTypeDiagnostic: BN6PR11MB3987:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fF6uhHZSpaZdMA03HAis2ambWxfJlmn5tqklZ/Qz4areLWz9ASZqJ4TfhxXQZ57289UJmOQ6mIGWxNG5t49n7jtr2rJOxFMU739KBY4fM/AyL1lSfcFbt3p8zu8u39y7CJbnRy1KRzbD26rplXmV1CPq+8bdVFlV61G1Vmp/0iFzf75AkXNnjzmvRri6S2JVQ0wo/XQVTxzxCdH6C5vFcqUCTj4pfaNEBNpbGikwMbxZhsKX95o8GHSpETpDrzqJ4KikpojlRkFfdgcd5tzZv+d0LjX1o+ki7t+TQniHXBKjgxdQsUNrRWgMp4Rh7NfnEsKYUDj5/NuVKu3iYlhf8WjB9LH+gLdL7jrMhRW6dNaa0KgXqaLR4wA7ZZ/m2/etIPgd9EpL2uzRwe31wa9Vd99IpqAf4c8Gjm0btQuM8CFwT1D7y0k8mULtAvR0noiZd19cUa7Pg0oNexDqxYaeA/2MzO0JZxZTyTcMRYz4q8hVwZ9QAn1eKjRZWkG4pcQfWRt30rIr360uTOaHT3+s1qGHNG8tJPitQWteu5IfVyXyl8lFcoCBJuRBsp+PbW8ooNWAmtnSUKXjQlCTmDqfWPgLJSvH5SnBvLN0pTiCUb9YWSIdeOHAW4dhkNxQU8AEBHBQ0FHaFKCoa+0iUR7tqtQdGvozXF3aL+SydrUm8BoueZ6fkjoa/2c5wIh0QfLdH0fMUbehWwMdU6w+r5XicxqB8VNgetViltFL/mQG72E3C7dRUe9wXgR74Y9NxrIP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(366004)(346002)(136003)(396003)(107886003)(38100700002)(186003)(66556008)(66946007)(54906003)(66476007)(316002)(8676002)(4326008)(86362001)(6486002)(6506007)(6512007)(26005)(4744005)(8936002)(478600001)(5660300002)(82960400001)(9686003)(41300700001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nGesJmptcnq8pVUu2Z7x3kDFTyceeKampbHkJgq/vxYy/H6Pjge4gdhAD18e?=
 =?us-ascii?Q?wTH2UWYUvl5HyhtH8C9ErGaBc/psezTGfKsPpc0uyaD4rUa/ISX3A9uDl6uh?=
 =?us-ascii?Q?mr/8qZIaeVqAVCKJLlWlde1vzXu5h2L52cI9aA3Xg8lJYPxUIxPGj2ezLM5d?=
 =?us-ascii?Q?peI4pI2knSa8uJ3uR8gK+HwGvBjE3oOJmpovb7G4nwFHhpTrRTMprpr/8vh7?=
 =?us-ascii?Q?8KMPHaVkiKavnKwy5qaYYZsxxGMgDj2F1JJ0n4d2clhEdKcNMoOY+trlX1Oq?=
 =?us-ascii?Q?B0a17kNB/prUXR3/zXM8narnmNg/sY+tzBa1LhBovmFIaxVXhxcFmOlS2f8l?=
 =?us-ascii?Q?/qAhtOQYk6Ho1q3aGEkeR/4WY8JZ6mYLaP8cDb4+0HWh0UOgxvLGN30hmaG7?=
 =?us-ascii?Q?1thjxMw7/17m1wNKpTOEYQWw0dJrhNf/SvjC0Gn4LzEIIIjuYG+bEZ449Tju?=
 =?us-ascii?Q?tyOlE7d4zA80dBOSKg59TIi/fcNZZxWKvNLfA4kRoqQayt1EBifVkKbnxHgT?=
 =?us-ascii?Q?16R5brLX+VR6MQ9QPhl6G0taYTByiVYMb06j1JHJc6LFnKEITdQRr2JP0btT?=
 =?us-ascii?Q?acQo8IVI58q36iUKyJMl0oGVybtcxSUb2cbVqcBwasvygVqdVS3I6oUq2odE?=
 =?us-ascii?Q?Md6d9X3noTmkVgPpeoY9kulQsRDMRSC5J6tKPaGPZJnb4geKYUnrr//H1k52?=
 =?us-ascii?Q?chU0RUpoG29dPI08hUsc9x76lXL+9pL3QeioZdbY1YCTPu47q9Ba5U+aY8Mq?=
 =?us-ascii?Q?ik+5NhVdUkhkKNVIHddi0o2+WJPt8Di/NcWClaylr1GZOY5nhmDVRtWMy7TU?=
 =?us-ascii?Q?D1Ho1W0lHOvupAcwPkknywJQOxJJV790F/2xZ6jcnMEF2+wNLt63qBejRnaE?=
 =?us-ascii?Q?9kCg9wZWMvZbryun0Wt0FivKKihUfb6BImp3+L5aEFIXOMwXMX6TVSyUc9mp?=
 =?us-ascii?Q?epmznUsQ/p2vWu9p168ZAvxvvqYCCYTLyx6pmOZdDLTF0KsJJLNuPGwSIK4x?=
 =?us-ascii?Q?cjqG1QPPe/8eWu2mvklk3zdDvy3nTc30Imml4nlhecWhZSPidxlfoowEiuqV?=
 =?us-ascii?Q?q4S6X7GfGSKWrNsqccSushhNLhwyFaafWhYqPLidtdqjNz7FgKdKscKPU+ef?=
 =?us-ascii?Q?domYuav2CY4v8nZeV9IkaSNw+x2uA08QoMXyfI5hJil6hMgNC9vpSne9kaSF?=
 =?us-ascii?Q?QyoAQ0wDKwdgBIYBfUD6icdmDjeLZqROELDZPEtvmPzwRKocV/K/vkP81upF?=
 =?us-ascii?Q?XFeQ2WGBjVO8v8l71+Pmrl61cRokYy7iTCZrXDeUMiiI9I3E/yfMQMeA96TN?=
 =?us-ascii?Q?R8fJNh7tsA0IZpYGo0vQh/fQXTpHYEKbrxLXpdQc3TYM3ceeg/Y08Az1ai/n?=
 =?us-ascii?Q?3UlXAMqUjLdMKTkDPUmbrBRcinGyUlWKgCfzqNhAIutfS4CMYD0pAI18lFhv?=
 =?us-ascii?Q?gpIbHRDq+bm8V9rfx51xYlu1lTMidsFatmMvwKej9L6dMqYZH354VH5+Eroc?=
 =?us-ascii?Q?VHStvFNUXC+uwBhldEoji3kCKy6/tvAZJ6RI42R2ROmU1Ksee1i7DonyNYli?=
 =?us-ascii?Q?unau3n23Jq2eMni8xZb8SGsxvd0cvOzqLfubAFOPbHoNa2OEG5fC5x6m0AQR?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 250ec66e-c889-4204-0471-08da69f5bdd3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 02:15:40.0223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KCCeUBgzkrW6vcjM9pRIi0J+NayNfitf+su/mgthCMDrT/Ri5gEGbUJim3FV9UnGt2rELItVGBomKTwg5JRk3DikIRlvj0IhN6ZLn8Poyug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3987
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Instead of only listing regions by default (which can often be empty if
> no regions have been configured), change the default listing mode to
> both memdevs and regions. This will allow a plain 'cxl-list' to be a
> quick health check of whether all the expected memdevs have enumerated
> correctly, and see any regions that have been configured.

Looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
