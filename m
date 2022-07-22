Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54232C80
	for <nvdimm@lists.linux.dev>; Fri, 22 Jul 2022 18:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658515194; x=1690051194;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=6vURZAfYiAGZvHjSQd4LL+bPgbCaYp7qaLFEyGkP5PM=;
  b=gweIy8+uIvvG1rmJCtk4CV6Gzt6SNq4Jk24TNiPmtu+4qeJROUZ0uvQl
   LLWS0DwqtLfrEb2226rGC0wd02eHunjGWQ9sSB5CIylbDkBGZ4nPQUfnN
   WlxTHg5dlgJ1bKxSJOPz6F/Q9a8jxUS7fopAsseSFbABS+FmQJD38y40F
   hb89/xTNhWSB5Jl9x3bkngMG7AdFQOH+2Slb+/b5FoKuj83BtNuQaqa6H
   GGioAMzUZD1XGjfjPkUGBPDOl6IBxmscnSFxkVlW8YUDi8gvNPFwq7MvL
   1FrU8sWrKSJzXYu3gX57REXHBZwmJnDP9kFkQD/dcfl1+/7vyH1arFxbZ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="313115502"
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="313115502"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 11:39:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="631660707"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga001.jf.intel.com with ESMTP; 22 Jul 2022 11:39:53 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 11:39:53 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 11:39:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 22 Jul 2022 11:39:52 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 22 Jul 2022 11:39:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIboT/Y893HPIjPQztIyWpWy87s6qgdabvq6MxPe8dpBCyly3Ok5bCi/WPske7N26U7hCsvRSmfDhgO1g9Hd+OtGrRW3UF0nPqxU9VnYNOeY59/gmT2b/qguEnR3UEdvRPCz3TDPsyki2p8Eeva7dYZRXJR2CQiLyFPgpC8r1wQpI7xbIPnvigWDTmfZ64UFHTN9bt3bGZAJuUyoCdLbNxtfP0dxtZKtiOGVk2LK/Q4tXL8hX41HPgGL4yJiPhE5iOwEQ5NZeXpX8mBytRGjzsJ9TDD5CERI7xgfbnP1Ap8rlZTyCV4nhGJ6Ko0lLuGQAVjiwdqHVvtaaVysnt7VAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yjZTNJeMV6E2vvH0sr+g2gIIbfNeOwvVyyyIw1NJWAE=;
 b=bzjyDFIrsL/ipJ9XiduJJ8t+9j8S1QjVjhrIabrIBF7zX17UWE7jix7qXqLxDswypHvYqiJSpgLAbYqysbHZraTpneI+tpVvAAkKhejL5hxHziIUkv7nE40AVwm+YQV9PpZSd8fGnHMRVDtsBpz1zZL2QvB1JURolXTdCOUvRIMTr+CnLUPBp1eAEUQg2gkqUyC75CzARojFjH8xQXSqUvXHAjkGZjmlkSHvyky7mNcipeR5POwSzuegHNQjHxjcjlF2CT6egZOP01m4JZRYZ+LUpokAx1YUT7/iSrVs9+g/QVw1C/ahdql/acSz+MLjeaLuR5KblJdJAg5O4tGiGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM5PR11MB1323.namprd11.prod.outlook.com
 (2603:10b6:3:14::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 18:39:50 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5458.019; Fri, 22 Jul
 2022 18:39:50 +0000
Date: Fri, 22 Jul 2022 11:39:47 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Eliot Moss <moss@cs.umass.edu>, <nvdimm@lists.linux.dev>
Subject: RE: Building on Ubuntu; and persistence_domain:cpu_cache
Message-ID: <62daeef3d20b3_2363782948d@dwillia2-xfh.jf.intel.com.notmuch>
References: <c8297399-4c99-52d9-861a-62fade81cda1@cs.umass.edu>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c8297399-4c99-52d9-861a-62fade81cda1@cs.umass.edu>
X-ClientProxiedBy: SJ0PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::24) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77849625-e007-49b6-ae1a-08da6c118f47
X-MS-TrafficTypeDiagnostic: DM5PR11MB1323:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X7/G9EgW3HgQN29DG3AGmqc11qu411KCBijo7n6nWCvLExOzFIpJGCzciLLvMBDIg6xchgRH8a8AHk0qsKqCa0gc1VWg2/JhnVNgoOcFWNZYqCfM1gaEAG0XAsUk65vgwL6JnO1JMOJTY41LmkmxGztryAoY+Oqk2xqOeUwrGSLCqmMg9K3GSVZYDUOhASEoTgdUOAQJgcrdX9Vjv+1ZHgQxMKZJj+dZZqAHNYrwxOj+qXS53fyMZ8TSsm+f+J4WTReKVoW2O/uRX9dLLoYIVPA8O80p2Nazq6NWlKqpmOTHiGngQ0MYCr9umJ+xcCO+cCBLVxWmfGGuHFKQKSn8PViOXD3rcgdVYV9Tkv2FuOXntY6i25L0WtAFaeP9V2jzXL7DMDvL7rX1m7Dn6dVotWNvOr7QUOZ43+BgmLK2DyuDxgCot6DN+NJzzCy8BafFrzZnEV3l3LSHw0dxYLcTjSba51s+6tiXoa06vyG+A0f9G30vmSX2hRzcwYaG5R+oHlN8aTwDAY1CRygZbqQKD9feATLrlxE0gDLLOLE0wgm0QSnjgB0DpMBS7Epoy25LJ/7mLuJS4ay1tkjpauAWCmqjtwx89uuGU3+L8RTcyloEdgpRFpzkZFgR7FNOnbEWu2wHlQJBftLla6Y0qQnA8e0a7VnjE0lAxvixazrsxqctz+oIxWvguplTdYjp2SL5f6brALz/abXxzfd+/uwRQ3bvs7BNYCwI3v6beI7NAEmpJASEXvjEosaMJuITB2gXS+uifAU2V6cv3wyDY6n2ScSXSK2BbCfONYeOO6sUUpmNF+Os1Pf40JRdfbLHkOwm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(376002)(346002)(39860400002)(366004)(86362001)(38100700002)(82960400001)(966005)(6486002)(478600001)(6666004)(6506007)(41300700001)(316002)(26005)(6512007)(186003)(9686003)(66476007)(5660300002)(8936002)(66946007)(66556008)(8676002)(83380400001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2p+cLvTaZ2kOyrD1rjMasfPTY4b3SoqNdXI8RszduqMPH+ot7a4/OGWkAWXW?=
 =?us-ascii?Q?gxQ92lcUF4cjcYynYlITSvuvgEj6wOEe84pmoCO7jIqylA21NehILZkSDLnM?=
 =?us-ascii?Q?cJRCJfbVbmNPJK91cH/KCxadKmH64NiWyb4JbKZza+kd5fDv9btdqwPu4H5h?=
 =?us-ascii?Q?dIhJf273fsllkhE4wjQ/PXPfilLktYrIph+XCAzq/hCDN1rIv6ju8fZEYECe?=
 =?us-ascii?Q?qiEvj3QHAnN4o2lDqaL7aEHdG/hVlei++3hI4nSQU4fDcEyMLZE2xX5pM7TW?=
 =?us-ascii?Q?1W/l/ilSmFFjjkvekoqIP1wKG8jwAquVszOzj9JQz82J6OLRfihkIxPeOazj?=
 =?us-ascii?Q?APScGSXLwj5Szjq4gDwZBdgTVrVH0P+mJrCFli4jnIiJo2w7ONxoUPN6M1ef?=
 =?us-ascii?Q?Z5p/e1BwTT/YELERL+bqnSxz3iOAJIvqv1ldZ/6C5HXc/LrsXEruCWwwdQI3?=
 =?us-ascii?Q?KZ/l34nt4DHpVCdw5gbolF5a34WfUae7gzvGP9cPhEJRbY/VdNtzIrUs85mE?=
 =?us-ascii?Q?mgVuta3XqdMxs9BW4hqwapY0Ax/eFgw5YiGunMfkE1sRbTwPacnSdoyMMR7m?=
 =?us-ascii?Q?qbIHbvanGHageZsBskUx6UWbCdn6SrMqgJrYebOI0U99DSPMQirmyrR3V976?=
 =?us-ascii?Q?baprhWTtwqy/amlI2eauvYCy2XJeDWGZU3wMS3pAOePTXBEFYDj3iQK/KpEg?=
 =?us-ascii?Q?a4foGRMiVvXJS/JMIw4YZYM+MF40zKrJwlA/2LeYqqlDF7Qc2VWrkEc8mwAl?=
 =?us-ascii?Q?83rDxe62jVVXrVkwXveqWEPGJAVHIrwpsrlOzlyQUeB49Vti2tGMsIg9T1Mz?=
 =?us-ascii?Q?MqjePmSJhNQjvXHyMWdtlDLCEX/5jcJRz5qyF9ZikEDoU1D/ULg8FQow+LtT?=
 =?us-ascii?Q?q2vSWnQagx9JQVg2jfzp5zJ7FcJXhIghG+K27ArCHuou2YVmqBM2wqbFoyOz?=
 =?us-ascii?Q?fQI1A3IVwoRC+IN4NIwDb+rarx09+NMR4fz+3gz/V4WWhK78xyzFKnp9WEb6?=
 =?us-ascii?Q?1KMK4cwF1iW1OnGmrMLlRkub6/mGneDtBOPLEXiX7ORVl3UPdvOpeu7wzoGB?=
 =?us-ascii?Q?NtFTOd7lPwV98WMjeZN/WdQci7xSgdMwsDCv7zkuTjscUL1IocG57iwzPj1k?=
 =?us-ascii?Q?vIP/V/+y0r22fUhtBjO1+VDAnEeE5fM6WFidlOquTzVijQcn6u26q5DuPat+?=
 =?us-ascii?Q?1MvLpgaHMl64cpjkTHv9BATc/j6vdLUz1CfjxnrKKn8nPaDnlKnPJ9Js4gX4?=
 =?us-ascii?Q?7ZTFH/xGXVdTRSrF0OucccR/WHadOFKdR+nVATvhQ5WRjRztewlWZmSTnny0?=
 =?us-ascii?Q?2t+vqgi/oHZfTPMYjhJTRFFjWgNgrzyXH5dNW+n9baVnFr731YCJAmI4268u?=
 =?us-ascii?Q?pgZBiTtt7hnvmzqd6XLae1feQ3Il0br/VbotQQLj1/QarthACAhJ5Oobbegh?=
 =?us-ascii?Q?mjaJGG0E3hwnNs2qozEsuIRDuxhRZJzsvqkbvwry1YIzvo4zYbk/ZD9xNnpu?=
 =?us-ascii?Q?kJHFj1V8B/fDld+aQzht+3lp/b7BvoPbjfncSXN+V2FDaGpplVQmAvx93C8Y?=
 =?us-ascii?Q?jqcSAK8A1ILkfnfYN8EV+KUW55H6q5JwEAb+lF76mem36bvld4LXc/mUYCLD?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77849625-e007-49b6-ae1a-08da6c118f47
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 18:39:50.6679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GggL9QJqQ+5+3We1vAISA+o7pLZw5/9ml2qacJyMQzBrqVihKyHc+T7GNSs8ChxJqCKuy5Uw3qG+XmNEhcJ0z9MRAxDyvUx4jIXssJ7VeUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1323
X-OriginatorOrg: intel.com

Eliot Moss wrote:
> Dear NVDimm folk:
> 
> I write concerning ndctl verion 72.1+ running on Ubuntu 22.04 (Linux
> 5.15.0-41-generic x86_64).
> 
> The system is a brand new two socket Dell server with cpu model Xeon GOld 6346
> and 4 Tb of Optane DC P200 memory.
> 
> I am able to ue ndctl to configure the two regions with one namespace each in
> fsdax mode.  Here is what ndctl list --namespaces -R prints:
> 
> {
>    "regions":[
>      {
>        "dev":"region1",
>        "size":2177548419072,
>        "align":16777216,
>        "available_size":0,
>        "max_available_extent":0,
>        "type":"pmem",
>        "iset_id":-953140445588584312,
>        "persistence_domain":"memory_controller",
>        "namespaces":[
>          {
>            "dev":"namespace1.0",
>            "mode":"fsdax",
>            "map":"dev",
>            "size":2143522127872,
>            "uuid":"ed74879e-4eb6-4f88-bb7f-ae018d659720",
>            "sector_size":512,
>            "align":2097152,
>            "blockdev":"pmem1",
>            "name":"namespace1"
>          }
>        ]
>      },
>      {
>        "dev":"region0",
>        "size":2177548419072,
>        "align":16777216,
>        "available_size":0,
>        "max_available_extent":0,
>        "type":"pmem",
>        "iset_id":-3109801715871676280,
>        "persistence_domain":"memory_controller",
>        "namespaces":[
>          {
>            "dev":"namespace0.0",
>            "mode":"fsdax",
>            "map":"dev",
>            "size":2143522127872,
>            "uuid":"64c75dc0-3d7a-4ac0-8698-8914e67b18db",
>            "sector_size":512,
>            "align":2097152,
>            "blockdev":"pmem0",
>            "name":"namespace0"
>          }
>        ]
>      }
>    ]
> }
> 
> What concerns me is that it shows "persistence_domain":"memory_controller"
> when I think it should show the persistence domain as "cpu_cache", since this
> system is supposed to support eADR.

This is determined by:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/acpi/nfit/core.c?h=v5.15#n3022

The first thing to check is whether your ACPI tables have that bit set,
where that flag is coming from this table:

https://uefi.org/specs/ACPI/6.4/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#platform-capabilities-structure

You can dump the table with the acpica-tools (acpidump and iasl).  Some
examples of how to extract and disassemble a table is here (see the
usage of iasl in the "how does it work" section):

https://docs.kernel.org/admin-guide/acpi/initrd_table_override.html

> I wondered if maybe I needed the very latest version of ndctl for it to print
> that, but I cannot build it.  I did my best to obtain the pre-reqs -- they
> mostly have different names under Ubunut -- but the first meson command,
> "meson setup build" hangs and if I then try the compile step it complains.

ndctl is just packaging up the kernel's sysfs attribute data into JSON.
That data is coming direct from:

/sys/bus/devices/nd/$region/persistence_domain

> I am hoping someone here might be able to shed light on how I can verify that
> this system does support persistence_domain cpu_cache, or if something needs
> to be enabled or turned on, etc.  I have also gotten my Dell sales rep to
> contact the Dell product engineers about this, but have not yet heard back.

I can't help on that side, but if you do get a contact I expect the
acpidump result from above will be useful.

> Thanks for any light you might shed on either issue ...
> 
> Regards - Eliot Moss
> Professor Emeritus, Computer and Information Sciences
> Univ of Massachusetts Amherst
> 
