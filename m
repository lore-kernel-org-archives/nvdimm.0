Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5362817CE
	for <nvdimm@lists.linux.dev>; Thu, 23 Mar 2023 02:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679539748; x=1711075748;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OVIejSzVxoXMSluoQ7ndgCVgxTD/d910LOSP/dHtdIg=;
  b=gqhE5WkOsjDuCwPCmV2MsRnfwFVgI1CmbPw554BCyPvnT0KLxUUMqIOJ
   W2NcK0i2qGAuuZjWtFsGZmjFgn6CHrUy8OcyEMRTSYvcQyLi2NHfq2Mn0
   Y3LAdwVhPW1NLrOH7DVQ9i3HbUyBe+BClF2T//lI6QDPA4tQBWe74q8QU
   8anIP6yoPxqH0AJTI6miu7nanhlXWcIUyRjkz+gcn+7o058Kk4WDui99Q
   us+rXFZp2dyj1m9wFPX/OCEBUZ0iO3e++zR/Lhcwvjkcmsq/v1qIv7hoC
   HOQCqlPn6SdyGFFyhSq/J71K6fRbw8rKf/j+schUvWLMSoeAVPCi5PGp3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="401950219"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="401950219"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 19:49:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="714631075"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="714631075"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 22 Mar 2023 19:49:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 19:49:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 19:49:07 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 19:49:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tfox5L2tkRqTT0mYKoDyPI9J4vDqFr5HcPXDJyQhLH+oRT4H6piBI8JjWYohE6F0Mu7XpdgkfNyBCpI+Q3SIVDK529Rsb6DZ3u6bUxe7Vt087NNSeIa2vu0SNdbiHEzoesO+0ny7G/l/tV/7SrreGW5ydHrirRzD3Lh+zNhInyqUoLpl9zll8TWay4d6rHbI7vnEYm7PiRTWoBD5j3W6huafORsJDHcWNryfW8UL5TuGSYDA5XDxI/zQjL42HVV62VDd5/l+ajQWz0LisTmD9FpOEvd84cleQEGTqoMbHv46VvN9IH7MW7m0IwkPdIdqiYs6eHsXuAATLlzUzWPQCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IPA/fub0Ueuti0wa58vuOH9FAS4yY378VYrZ39YiiZU=;
 b=hIMY2XSgwPmBiFdmcNSp8zyFyDg3rFmys5bz6ytWwUDZlfU3Le7xBKrIZyuXz9m/Hx+KGtd0xls1u4tzL5Gp6awYfzP8BHt3sLJQ34dxiIPYDl7v7C0FD51QC2oQl6jutapbi6NKFH2pWpiWep89VgFYoVThLCAP/bdkJ9OWbXfsQEu3AS3e1pnjLvN62X7+JRH+J0rJlHwbTmh1M49+DYvnvsZ24xeyWqR3VVKowsmZZdUMd2FzbdQzHJmwkk2iS3uHSqICI9pX5CB6G9U7JFqS7Fi/c5Ism7ZurPPIOOJq6udeI/KEWlMISffk8nXBlU03nhlejjdIlbiXAslrlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA2PR11MB5003.namprd11.prod.outlook.com (2603:10b6:806:11e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 02:49:05 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233%5]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 02:49:05 +0000
Date: Wed, 22 Mar 2023 19:49:02 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Ian Rogers <irogers@google.com>, <nvdimm@lists.linux.dev>
CC: linux-perf-users <linux-perf-users@vger.kernel.org>, "Taylor, Perry"
	<perry.taylor@intel.com>, "Biggers, Caleb" <caleb.biggers@intel.com>, "Alt,
 Samantha" <samantha.alt@intel.com>, "Liang, Kan" <kan.liang@linux.intel.com>
Subject: RE: Determining if optane memory is installed
Message-ID: <641bbe1eced26_1b98bb29440@dwillia2-xfh.jf.intel.com.notmuch>
References: <CAP-5=fV_A0A8-BnfaWFoXX2a284UDp8JHvaBLC_FXPzW5GT+=Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAP-5=fV_A0A8-BnfaWFoXX2a284UDp8JHvaBLC_FXPzW5GT+=Q@mail.gmail.com>
X-ClientProxiedBy: SJ0PR03CA0175.namprd03.prod.outlook.com
 (2603:10b6:a03:338::30) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA2PR11MB5003:EE_
X-MS-Office365-Filtering-Correlation-Id: 7186fcc0-f292-4bbf-240b-08db2b492a72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mwrScB4GvJQtbqbZjQ1FcY7jUGk1bE/BOrB4lATUZ3pYzydgKggeZj1H5t9pdt8BMp5OZcqgmRM5Uyxe/GT3zd5pGuMVvngY/nJqWTH0d7SXWMrG6HQU0gPgaX8cse3yLdD08Zmq2Ni8Cuzv0ENIKqKMKVrYWfSbC3KxBJcVt5WwJ4qdS4eFpoGfetxsjpB7cV9IGwXXLi0SQJtm3FHqS4CEwd/d4+anOc1fS0lC/yuOHGxtP2bob07Nd8E/HCD6+7b4GPxvbW6wyZMcTwhYB9HE5iOuMfIiFiEmKxVAU5F7m/qDxJez6CZDUEXa7CkNkSRV9yveha5ahEGeYbFq5fzyt6kZJ0sbYpwg72BSGK4HHJvQK62ryfC/0j/jhlWuTgIQlqDEfSL/B5TjV7LrCbs1H7pzVMvxlgCLFdaDi8Oj7+QueDIkEWr6zokWk6Ar3ED0BrNt6qdZ3JKd6w0MG2+7B+YMCQVe+w7Ua2gKS78d6ObCImKREvSAobVPZO8RYaHiaTpDxJH8Jtv9kJl2Hdxl62oAJFpS9CuENDFPC8dKYDxzLlV83G+JrnSexqWUvJTsJRNZOdepaOKLqubolAGbUeYlMqFkLSO8PV0QAJyTP4VsPrsbvPR5yeIBmIb6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199018)(38100700002)(66946007)(8676002)(66476007)(54906003)(316002)(4326008)(66556008)(41300700001)(8936002)(2906002)(86362001)(83380400001)(478600001)(5660300002)(9686003)(82960400001)(6666004)(6506007)(186003)(26005)(6512007)(6486002)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WLZ8f3uG+4cjHEquiUJLJGyu1VmwSyVa9Ez5+y2GogPXMoN6x9P1ZMn88QxV?=
 =?us-ascii?Q?WtE2oQKDXW2OOWQzI+HsFJl/ITuU4Y+h2AAF4MaXla+FzCX5Y6VIBQCpLGYA?=
 =?us-ascii?Q?/k72CJ+qam9Uzmhqt6cZBrUXW1oc4UkPCSeUozhEWj4yUmxyUnzugV2qlKW6?=
 =?us-ascii?Q?s0l8zhfiZXVvdDbLCPCH/Z9hL21scGRAajj3YmIzkKqnoCizvP4aeNPmsf0N?=
 =?us-ascii?Q?X7R7mMSg54Y55JxW+TnXXnDqfQDvCPUBGvPm3xh0shE8FQ3XJqJklEGTqxWg?=
 =?us-ascii?Q?mOT91b4DejrSPP1DPAa3qpLgyNTtDS4yych1HGlA2fqVl1ScApsOP08Z4yK6?=
 =?us-ascii?Q?uvzm3n2pe2fQTKpfLZevvRoZaL1Z1bMKaQeWIMgZB+IfSz0MvnHxM3KJPcwN?=
 =?us-ascii?Q?ZHR/0sqjTeks1Q/wuRO8bdB6+/ZUukpR2D5RtgH1CbGWlmCqjyxXN7QcjjQC?=
 =?us-ascii?Q?GAIswme3qcGfslLgIEj71GZCtUqmp6Zaz77wSUWmsut0CCCkjf5J3gGsvL+k?=
 =?us-ascii?Q?A0Og7mHxvlKbHvyI3fM31ESSeKBaoPMX7p73h3G3TfPacACncB6zcK5h9MeO?=
 =?us-ascii?Q?6NWHCsycZ5QGF7/88Pk/HDwoegeq2nnxnJzDjFYMJJvWBfLVqS+jHO+oKXnA?=
 =?us-ascii?Q?E6vassNve6bXNoqo6m/WhqH1VYk+HgZbcR68atZKTx0M3Kpui1cumyTUx+lb?=
 =?us-ascii?Q?6iqe5e0O5qji6IcZR1GwOwLjjic2lh0HdSDAOXn89raCRH76zGwuXoiNiMmo?=
 =?us-ascii?Q?D3yjC88FZT1y2Q3E1TKnID+Rx5cxzkbksfcak2mmTds650HJyLmPPeoctwZU?=
 =?us-ascii?Q?+D2VgvAeoQwOUSKI0ZWAgAh7CV1NZbl67BgMe+lfDib4gCL2fg+M8QRu9I4K?=
 =?us-ascii?Q?qmZVdOOd6V/mwxhMP28zBaXvgM0LIS42PyZwXzM5vDmom/Q3BW87T2nGa60M?=
 =?us-ascii?Q?xwibXNXy0d5V4QvKt48ac0b8hr99Ymp0Q/Ufgr8gJ5sPNnkM/DTyfcsHNg2H?=
 =?us-ascii?Q?G6pbj2bmmwlWPZESmnZf5gND0CambZIPLGoq126bsUSJlW462FmZ0YkFk+bl?=
 =?us-ascii?Q?dpCYEIMMWWYaBhmYkrETLJpn1A2rMOvQqsi4/MqaqhA8GdHKcUe4p5JY85bA?=
 =?us-ascii?Q?ISCHfujZz/q3Jxc5CFikoO3P0jnUaVdZ10x+01M6mLWlT0NPBMsS4G/kk40Y?=
 =?us-ascii?Q?AnpWk0ZgdTlFciqzOeh2LdAiEpVdaR2bXE/ki+pGhcQpUmQQkSpVjwRGPwG5?=
 =?us-ascii?Q?qV6RqTLpncrLkmZq3x6u7XGUt2JjmuW2UUmkEf9FEcMFW58NQ/FzqBsCRw1r?=
 =?us-ascii?Q?PW8pvRnbe12/vChj5rYNS2idgB+GN0NKBe9bYKqB7Iq73gyXuFJ53SZQWgfH?=
 =?us-ascii?Q?knVX3WAl1BSyg2fUu1deAUDsUUpWPisNDiFqfKBdEmBkW/1RnvemSkZAN8hc?=
 =?us-ascii?Q?gmiUXhDTuYen8oVemkKY8uihf5oVI+sjceKMLK17pWYbhsfUY+qBV+lK/jvp?=
 =?us-ascii?Q?rWiCa8xuLQX5fQ+Rkull4hS3q3i0hBxq4LL91gkC14Qei1PP0pXs2FY7Sqvi?=
 =?us-ascii?Q?76nd08NDY5BitnA+quy96FPIfuCCR6dxz3KknJ82GXn2pKaOofqRUOYlpx37?=
 =?us-ascii?Q?mQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7186fcc0-f292-4bbf-240b-08db2b492a72
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 02:49:04.9987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: awIS3MFBjZdsK0IiYXYrVvoIuTFdGwpXr+XOM0FJUCLx0+NWwQypLRhiJmt+IAknm9j1xeQQGPnJXJ2uGOkPgG131IsE8sNDG+4NdJ5NQrM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5003
X-OriginatorOrg: intel.com

Ian Rogers wrote:
> Hi nvdimm@,
> 
> In the perf tool there are metrics for platforms like cascade lake
> where we're collecting data for optane memory [1] but if optane memory
> isn't installed then the counters will always read 0. Is there a
> relatively simple way of determining if Optane memory is installed?
> For example, the presence of a file in /sys/devices. I'd like to
> integrate detection of this and make the perf metrics more efficient
> for the case where Optane memory isn't installed.

In simple terms the presence of an ACPI NFIT table is probably enough to
tell you that the platform has persistent memory of some form:

    test -e /sys/firmware/acpi/tables/NFIT

...if you need precision to tell the difference between battery backed
NVDIMMs and Optane memory then you are looking for something like:

    ndctl list -D

...which gathers NVDIMM device data from sysfs and spits it out in json
of the form:

    {
      "dev":"nmem0",
      "id":"cdab-0a-07e0-ffffffff",
      "handle":0,
      "phys_id":0,
      "security:":"disabled"
    }

...where the id string follow the format defined here:

https://uefi.org/htmlspecs/ACPI_Spec_6_4_html/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#nvdimm-representation-format

...and then you would need to know the id string of Optane devices vs
other NVDIMM vendors, which I think is overkill for what seems like a
simple case of hide counters that will never increment.
