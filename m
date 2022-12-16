Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A186181
	for <nvdimm@lists.linux.dev>; Fri, 16 Dec 2022 18:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671216263; x=1702752263;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OJoxnHSQQm0qlVrGGFDZqGNNd/ukSYuc8xtMgTU9W1w=;
  b=BOLPgR3wdPpDBl9+i9j/joox9pWBTiDkzrio/nryR9IkHE+OZyhihU0s
   k84uuJsgYkoB/97z9dWHmerLYJpV4d0D725/pqxuENf9RrctxDbtawmZw
   8P6weUMv9eKk8bqzluwzjqSK1cupNhN0M/BtzTkWeG6LNusFNQwbkcFTr
   WQWEHmAdPiFKDD9ENUbX6L9dKdScdyytTQ2YOJFaW5rD/ol9ZkKBhsprn
   6nz4+nOkydj2RGv8AbXqyelI3y7JA3woX2fVmGiqPxV6X8rfw94VIBZ7o
   ecHj5+fT439IRFiDrbsLXz9QNvhwhoyzK/gjAyr/k2vfYb9QsLBFpesUD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="383367589"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="383367589"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 10:44:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="627626084"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="627626084"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2022 10:44:22 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 16 Dec 2022 10:44:22 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 16 Dec 2022 10:44:22 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 16 Dec 2022 10:44:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Og3qTFJec6+BJJJHO9lQKnc8xbFZoSc8sMvlwbImiXml/Jpyuyn9EZfpFm3I8QQhuGDLNVdUbPpV/1iEoVcIgSdSebZTyTbrB4nuQwHSiufOeV2z7UGcNkOgpdd4+FzVdW9PH/ELVuzX1k6QlvbKdY+DuyZm7ZOVkHqJM1fHjHC0wSf6osmzSBUUnM5qfNXAakLo0ofkKYFHx4wsBeLZ1wvyC9DEkZEfO0VsCoYB/UVeWOjQebYwGfuNjuJdVUXcbFYPbNv388nHroig0zq8IESa37zhrzNEpF1BzAc/3NdMDC/DL4nd8f7P3+HZYGC5sGKjQhMK+oRR2LLFwHeteQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OH6THOsW39843Gl9PuzT5pWiAJLQgpGU4YLi8BqF9gg=;
 b=eUvjBvx589+jRqcyajXsXF/KvG6s85GEVu1SXE/MI7M9GQPCYfRNjOYJP8BLa0R6F4PG7AB3VYBkN0fhTBQ5E5VMbFsiROCQkhmlLxL5vRCHqezGebTxHWwwHAMYBT5YDfAkJrTouQ0samfecxXqJySxW8SMLVMMyyaIJ4yOPJlqMRwoZWnOCuT8X4bax34iHtXo+BaqY7kvmtBl8w9qGP9jyt2u9My7pWyMid3TRp5pUDPK4ruGussTBMt43LjK1XIVEiQtMnhdAqUIB+mr/szjqeKtnRCWdnQsdQ4G2KnIeL7+R5nBM9eW3enneCg2bM5at0JwcjbZmo+334pNcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BL1PR11MB6028.namprd11.prod.outlook.com
 (2603:10b6:208:393::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.15; Fri, 16 Dec
 2022 18:44:19 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5924.011; Fri, 16 Dec 2022
 18:44:19 +0000
Date: Fri, 16 Dec 2022 10:44:17 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <jmoyer@redhat.com>,
	<vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v3 1/4] ndctl: add CXL bus detection
Message-ID: <639cbc81606a8_b05d1294d0@dwillia2-xfh.jf.intel.com.notmuch>
References: <639b9f6062c69_b05d12941f@dwillia2-xfh.jf.intel.com.notmuch>
 <167121128334.3620577.18417349282991011007.stgit@djiang5-desk3.ch.intel.com>
 <f804d081-abb9-cb46-e14f-a37f3ac63f21@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f804d081-abb9-cb46-e14f-a37f3ac63f21@intel.com>
X-ClientProxiedBy: BY5PR13CA0032.namprd13.prod.outlook.com
 (2603:10b6:a03:180::45) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|BL1PR11MB6028:EE_
X-MS-Office365-Filtering-Correlation-Id: a0b123ab-f940-4848-a68b-08dadf958a86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iKfWig6FZFE+Hsd4Cia0wd0JAjsjHQd3ZqQiwqsdM3oPVvN6VEpCP1iFBZFHtzOx8Ge1RFTuFnQQJ/XLoyaSW/9UFcxjzKCROMwahKuoBEnN7xwJOwGbMUcNQzxvBuPsWcb2xC/82gMLl3MtmOJMsOjTPXlze8Qdr4iOrp2UkjX5xfSXo33zjKlLpFdGJ78dwIPiHzpCcEXUM/d01iwMEmsFMwiloqQyHurk1PNjSAGsGxdWM7wz6A71nLjBrs9dt/6B3VzrmY2ZdIHzbITM/GddxzNAD3nlCWh7Qq/XJC8+n0+obBfyvVVijTfX1GB5dtTUBXIi2YpeANIrcKaROXaRhDVSP8iL20c6dii9q8OkduOLDN3dsa3dMiIOGCJWxhM+xZNyIi+Q25/TZ1hxwVJBmx3828If0N88wpdzJIXJX9nMr+NXlnYuMyhCt7k/7KNle9lpUdGlaDxIkKFp5N8Bn2iWBPhgyjHZgp/gt71W+QLwOhn+GfM4LhHSOFgCIIZcSF7WLJMtXV5Ngvs+4K4pfDgIVJlPIcF/Gy3s3Qt8eLKaT3J4kQYQGBFK+VEM07tdLf3mIxCN7nJqhKA1PN5uCo/P8SY9uNCrdJoNhOzj2IG14IR+I9+ojv6lN7qIXX4Dozonbvm/rjZkrzvQOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199015)(86362001)(478600001)(316002)(26005)(5660300002)(6486002)(2906002)(4326008)(66476007)(66556008)(66946007)(8676002)(41300700001)(8936002)(107886003)(38100700002)(82960400001)(9686003)(6512007)(6506007)(53546011)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WNR/2l1LTRquQjM4YGtK4DXKMs1hWJD0F9qY5wCb2VUn3+2d6+y6dnqVaPIY?=
 =?us-ascii?Q?qmfpvRsPXefj8rPAE0iBqrEploK0JhtwPd2v6gkjfYAqfaC3IrpA6yAh+T2V?=
 =?us-ascii?Q?ZqWG9uiEW1rIPIAc/A2w82O73HZZNzYtjZeoOH6TQdF/CJd7QOTq3PvIOqUC?=
 =?us-ascii?Q?XxrgGyo/wswLQkxwScaqJ6wXkmkHC8ufd6jST9gZO8y5sPpnRY9fxGtVzLEk?=
 =?us-ascii?Q?+7d5KRZfndArDopWReMv1UTc5TwrQDADe3mQWgSiO5kKcPzWY/qDVj+rrEy6?=
 =?us-ascii?Q?p91iRuvlyHI9JfNF2okJavdUH6OiwalFhEd+5yDDko7yK7lTz+pINwEXvlk8?=
 =?us-ascii?Q?1dPRQPM7OpSMt8TrIMinA3uTgXfMnZdEKn9LxaEvYvILLj/5QmYcnLPQpFy2?=
 =?us-ascii?Q?8Gny34CBBR5MIW/RHeTOQ9M5Q2+slgl6GGn7pbT/XgTfnRoFi6C8lryHloEs?=
 =?us-ascii?Q?zZgtFwHpGT5cAa9A6NXgKNGwA4O5dwBPJA6h1hD5C7f6EXJ+a5oX5Pn3LuyE?=
 =?us-ascii?Q?KfB+0nhsY6d7VOrkxpvrmXzrLzGmVgJlwAG0Nrm53h+HkkZJQLNYdg+we13E?=
 =?us-ascii?Q?aADFOrAvpyu54LvbGG5lLFKbaZu6oPGA3o1c+DjjEpgMk0uV1dZOrwvThZdX?=
 =?us-ascii?Q?GzNCqCFwz4l/qqhBCAAE9/FOGxBb03f8eXAl2HDpjvYm5QWRQhB9oW39dt2k?=
 =?us-ascii?Q?w0kFI4v6sGfb9l5UfoHV4Mg9f5fxK3WtOVXT/PHbVFRuK8jVAxGi/TFRWG2M?=
 =?us-ascii?Q?15qy3nyIAcqKDfLLXj0vaX2kYPz0Nn08jUReq+HGxDczJMfGCXU83czL/7Pr?=
 =?us-ascii?Q?VykGVuv8OXCj4g38HfaoS3vuaZDnHWxzdC90Rh0S9Ypjwy2zPJQRbZ3MSPgS?=
 =?us-ascii?Q?YjTP2JYJqNG0wmDADhgbtrXAb/Reue/PgbtgW+Y5Nry5x1hQi9IcrM29VDJT?=
 =?us-ascii?Q?O9pWLvV6DrivxvF+j3M1O7RPf6B0kA9ZKQsdHM2L5hKG2H1sRGYsSxTXzWGT?=
 =?us-ascii?Q?FVBqU3rMxde06hAP7WqAm5NtftLa1G/J++s+ijM25VqrWvMjyivAsVYtPObQ?=
 =?us-ascii?Q?YKnv+QEvmERxN+O0UNYOQExYCUnHap1byJ0NOY7uKHXQFfh4sJzpHVsZln6x?=
 =?us-ascii?Q?qNlXL43JwV8FP7MJVSFXNTsTgXdok4Rl+R/RWoI0gNMIKveNERdnWr/kUFCE?=
 =?us-ascii?Q?09MakF5DkHPnu5u4M4oq3irs5fjHkamjB6at0VOxKxOE3DA+cpY7WOKxWrgM?=
 =?us-ascii?Q?Gm/HhkdSWKITBjeJ+qsTzE9Eom/XU9z7WjMPpgtxKVcny0zgeJAmBrmD24rm?=
 =?us-ascii?Q?iimDBr1b0oIo4OxoQ9e9157FwPZBTKUImeTfUlEoFgL412Nyt4USFp0Rzubh?=
 =?us-ascii?Q?XyCIGGlWu4OMJ/GCIqfM7cjr0EIRsoE0vp+rX5pwNplUBKagBCKs7lwMRKNM?=
 =?us-ascii?Q?hpVCpwbbOXYskbbW0ZFAuKOzmY2VWRqYi2SEPa6BQ2JM8a3k0HaALzrRZtNW?=
 =?us-ascii?Q?1pmUonDGwLcdsCkxyS4YenFRHUyknyQMD/QhSX2XBmujn26j+IMZQe0tH3XW?=
 =?us-ascii?Q?UmtudOwtucAyeES3U5HelDFq9xQY5+DcsZgwDmyU6gRVVwyz8jxJRCTZBUCQ?=
 =?us-ascii?Q?zA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0b123ab-f940-4848-a68b-08dadf958a86
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 18:44:19.5266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l/3tVQUOtR3yuJVFzUpnUezt6BQTlMrN/dHU5LZ4yW5GSvMIFJ5bGr6aFFs+sQJYMQ50jiixIdME1jg7hubSxoW7KD91JyZ1EtX32No47io=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6028
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> 
> 
> On 12/16/2022 10:21 AM, Dave Jiang wrote:
> > Add a CXL bus type, and detect whether a 'dimm' is backed by the CXL
> > subsystem.
> > 
> > Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > 
> > ---
> > v3:
> > - Simplify detecting cxl subsystem. (Dan)
> > v2:
> > - Improve commit log. (Vishal)
> > ---
> >   ndctl/lib/libndctl.c   |   30 ++++++++++++++++++++++++++++++
> >   ndctl/lib/libndctl.sym |    1 +
> >   ndctl/lib/private.h    |    1 +
> >   ndctl/libndctl.h       |    1 +
> >   4 files changed, 33 insertions(+)
> > 
> > diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> > index ad54f0626510..9cd5340b5702 100644
> > --- a/ndctl/lib/libndctl.c
> > +++ b/ndctl/lib/libndctl.c
> > @@ -12,6 +12,7 @@
> >   #include <ctype.h>
> >   #include <fcntl.h>
> >   #include <dirent.h>
> > +#include <libgen.h>
> 
> Of course I missed removing this change.

With this fixed up feel free to add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

...for the series.
