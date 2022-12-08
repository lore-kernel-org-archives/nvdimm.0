Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA6F8F6F
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 20:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670531129; x=1702067129;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=l/tlU4mWbIQYqB6Ownb/yF9k63isqBpUq7CvUDl3LYA=;
  b=KAht1wddFv4NGYpSdhUDpZf+FIpMBNKdROsbhe3ATUPvwGbsHaqNUQ9I
   o+jPfDnj0lFx2ltI1MbBySN2hO9v3qNNoIsq97V9WEoPAr0VT3xvgMd5p
   d2u6ViQtoR5UjaIKJJwMDti5YfJS1DwSEwms3ku2nvP0Rax/7LhYVASBB
   drMZkC8ZG1z2UP1twlhWLbCBwvU7AJdqlCoypwOLIOp5kaM2lDnSXrsUH
   vzxCivlQBFP+8Oem22K7blvqPz1XeY5C/2g4pATyY8n+W5i7NinyTinrd
   3uDVDL1jzaPjsnJ0QK4gADaUTuCHCKnruOl3gWBeOhvzLJ7gq8UyE/YhE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="319156625"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="319156625"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 12:25:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="753735962"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="753735962"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 08 Dec 2022 12:25:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 12:25:26 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 12:25:26 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 12:25:26 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 12:25:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLR0akKW8brzTH5qcNXTuPGEIaLOwxFUIbE/yPXviwI2YFnNh/BZJaaJngmqcYiFgOJxoHG5nbW2nDXi66kDNthGvK0uZrDCtf8Z4wFIPy9VbxVi5HFKMDdU/9o0R7IEwPLpaIE4KLsCtHSIZG2hOOR+zmpLH3kL9HQQKif1a2eJDUcBehyFSIeY7IUXv2+yOEAyGaBzRTondfVigUy+AOnThe3EeIHcQwqaTZGJRBYcdsfJyS7QJLk98pU0UrtdWe+VFBChWcs40clKpjN8XUuFPQchi4UqGfGRe/B1v6S9rCrkyfF2w/BrZ8/VHXjry+cT74IFAVWvo0X9WbxG4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1BvYD7i5kY+UuKpoJEp8nzBA1ZemlutrEwG8Z0lf7A=;
 b=DM+Md+V+gi18br2QCRm0JRAJS5ZvjeUmP18Q6iQxV3C5dbyyROJpMotBHNXQ0a0G8yRNmDryJ2wiEslnBXVzbtCnbaoqivk/bI8YgEZTfGDuvQG9UJaeRHphFkF5JUGr4lmltYXBkacAHRaWKk9HnWIVKCqpcOVtaDRbv18v+zjeeA49km5koDnKS2bj4MFkLR7BuM/cakSf1gZCb4ulfAmBlVyIuy0qQ6SXmxv1ZRV3CAs/2LJ8aInPW7BsGT1TYMt+pbnenvTzUnpIc/WE/5nFpvS4KS8VhXjHD0IDHnYp5R4I6WCO1+PhswAtdJzgfh/GeGPtlSA93vltPq5msw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM4PR11MB5535.namprd11.prod.outlook.com
 (2603:10b6:5:398::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 20:25:24 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 20:25:24 +0000
Date: Thu, 8 Dec 2022 12:25:22 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 14/15] cxl/test: Extend cxl-topology.sh for a
 single root-port host-bridge
Message-ID: <63924831ecaaf_579c12945d@dwillia2-xfh.jf.intel.com.notmuch>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
 <166777848711.1238089.14027431355477472365.stgit@dwillia2-xfh.jf.intel.com>
 <9b6565a8b59f3180f5d1d5edabebe8f32a35c172.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9b6565a8b59f3180f5d1d5edabebe8f32a35c172.camel@intel.com>
X-ClientProxiedBy: SJ0PR05CA0197.namprd05.prod.outlook.com
 (2603:10b6:a03:330::22) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DM4PR11MB5535:EE_
X-MS-Office365-Filtering-Correlation-Id: 707bfbe7-6e87-4336-dd72-08dad95a5621
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HOUWlTTQCu3JYDm2aqHksRu5sQbfgp5nN0BmSdA7QbGAz6Oh+J2tZWF2kgdP5MGzFuDfJY5ojEbX/RKZ9sGSKsEPsZwWCFs/44ygwq87bKEVtU2bG+dcgYEvZTl6na1fomaT/vYr4NGDbWrGOzbnzWvaPjNJvR+Dknj54cZePcarXaqx5NO3QxrqcIXct0cHXimAx+HDzawoKW2z2VzQjnmExSv4bXpG4i0iEKNDsXVjNns3RJ8nse4xFGeYFCfGafHIuzIYA8ubghaa9yANPwp6+mkh3hnF0EKqFKLo7peDNLJIS4B3EHuJFSnRvtV5KR/tz6m9A6JYeshwuEIEkJrPZoQm8T0kUTeJsnlIDKdndqxvEVPebdYedjxY42R4sZs28wenbw1axLaLWxXtraTzMRvRfo6R1XRecMPDSe4oTm+R9O6YS93JxdPyBFv1JIgUxXO9c3YiTkmlTvNjs7fyii6Vo3XqqMAUCC9B1X2f2f4kSXRTgh+WCxQMCFwH1xdWO/vbCLYYKZLFRhXSMjoZI4nEDDuZLXGvi9sFEyX7VOKeDQMvR2B03DbPyhXLH3yN79EixzxALmriUTX1EfrA0mZ4gjnF5bWNgXzTC8/RtTNmPcdGlIXmB3wONufR4aRAHcTgmsfEznqSKlDaw7zrQrZHkxFhMJ30Gh3UF8o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199015)(6486002)(478600001)(966005)(66946007)(186003)(86362001)(6506007)(26005)(6512007)(66556008)(110136005)(9686003)(316002)(54906003)(8676002)(66476007)(4326008)(38100700002)(82960400001)(41300700001)(83380400001)(2906002)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?DQ3vTcZ5lxp2pYNFaTk7Z25HKLMCiwiJd+meQgKRWVO2d5Esy3qNcTvm2R?=
 =?iso-8859-1?Q?1V5sJ17jgyIXTua0WgbN0bBnA3tR3M51ckPmNhQPzy890KzBkHY8671I9y?=
 =?iso-8859-1?Q?ymLFvpOCLJckmPVi4ftvTP/wW6v/VNCr7UwAsMtWqlen7jpuBFRc55a7/u?=
 =?iso-8859-1?Q?YVOxCZWdv75a5KAyyI5J5TEX8SKWibyQSnn8B/E4+g6LnnJlR/6vVqTHxJ?=
 =?iso-8859-1?Q?7SwSDDJOheyXpzZjwt96Sh21TnAjWUXmW7jGqPGemIrPpHTcXFA3wdlsL3?=
 =?iso-8859-1?Q?i4/FQezyO7luOK+Ms1lRcPOR37VErMovaIQ4RAc3VE8EZ4yDZDk0DOaH0+?=
 =?iso-8859-1?Q?N8sE1ZJWwDVWFwMmOMP6VAnL/DbdY1CUBIC+PwietuSgiSuaGMYokK56wN?=
 =?iso-8859-1?Q?nxrxYNk3thGYbe//5HMCSZUjUC/tH52U1WlkgTJMjqU3w3j3CV3xo1UYmT?=
 =?iso-8859-1?Q?faCtgeEePLmXcWFjlZbcX8lSu/rpsSi7nTXUD0v2CVxusgVUlVRbnpQfqG?=
 =?iso-8859-1?Q?HZDufAQagRvH0d4DcL34VC3E6kfQC9K8p/Hp5/sP+R6fghyXG0T9KfgNyI?=
 =?iso-8859-1?Q?YMloU7I/1HZPiJ9MRuClegTgLbmVGRNpTZbfiHgG4eviY4qzvtW3WXi9LI?=
 =?iso-8859-1?Q?wN+SO9DPhmoHQBmbmyEfH/pSQ6o3RRl6yFiPxmq14tzIrR6g4d6RcZX1J6?=
 =?iso-8859-1?Q?96Bxovq1VFZNI/ySF2iFq1YXeX0FmnaOn25NKrWzk3ZyTdzhAbTwZhrsvK?=
 =?iso-8859-1?Q?tsF9ksWqLC/6JHbzpJ8MktfGbobO+rw5I2L1xkxgkztEXna9GT5o5kfqF0?=
 =?iso-8859-1?Q?rzAHDHqTPv+podnspwfY7COjcDcQlI1s42nWLX9X2dDQ+G1wXuNYs0yxXD?=
 =?iso-8859-1?Q?pcmX0SicgNuxSRWMNqACHUlQI6mMNQsFysXgYBpmOBGgR58VArh8JouL7q?=
 =?iso-8859-1?Q?4nzUERAuZni5/5PehS8QnWMRDoYq2IBw1s7CyTy8/rWpSBZ7vDVTMiIkJG?=
 =?iso-8859-1?Q?pXC01iG2EC85AAY3wRpGKxReqf6ua+erKjai8h00cH1InVbbtHZ9W2Cy4d?=
 =?iso-8859-1?Q?5nYvdQ3V6qdlEQLytWlXi7aWY/45+quzySxZ6VNqvFZIAtxZ2zq/+Hq4BL?=
 =?iso-8859-1?Q?nDPvViHnPGnp8hTm4gwZQda5nyvUkYI5mET4Rf6C5o3vbkTYdE5nnDbcaJ?=
 =?iso-8859-1?Q?KQ5UdxUdS4Ajc1Noz8dYNsUnSuM7I19bWA/VnEFSt1iSGqYCmvJ/W+C5Dp?=
 =?iso-8859-1?Q?sl1ekrJwuMUZSR6F72hVHHKnUycbItXB8r+yLMStO/L/6DOPl42J/qokrL?=
 =?iso-8859-1?Q?zyPZDwoKJ+edMDQPytpg3lFz5cga0CbgAzMxJw9X6yq/+YItMs6S6HA/a8?=
 =?iso-8859-1?Q?JNhkqBeQy9GAle5TV69oCY46FO0jgLc6U6gbL+67QzajI37LLFdJNtxPeB?=
 =?iso-8859-1?Q?eV2AaFvyadHLfm3c7xyL1wmrYg/IL0ACHZ6xPcsDa1S8lC50XflICEYTra?=
 =?iso-8859-1?Q?hMBsLhKwrNKRbFr45WJbXXYQoltoDLYYB3K4Z7JWyjqybdnN8THMRZr992?=
 =?iso-8859-1?Q?RI0p3/UFjToqklc65xCyOXfMtC759kI3lGU/d27vt00IuwzZCmxMfeXWN/?=
 =?iso-8859-1?Q?IIe2abrjAHxs1WiQss5Zv1olhEL6OT78RRbtmpNEI7zyPiMwIyGhx9xg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 707bfbe7-6e87-4336-dd72-08dad95a5621
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 20:25:24.3096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ll+0fFwzLxS8MTZd2eCwOrF+kxw/XEigBHP2z/KmJpdtbX0o9LgzzDykzY+EdtK6AOaTjGZ7e1Hxzm6FknBcatPOSkdOIOmRPfQZKYRWDfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5535
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:
> On Sun, 2022-11-06 at 15:48 -0800, Dan Williams wrote:
> > A recent extension of cxl_test adds 2 memory devices attached through a
> > switch to a single ported host-bridge to reproduce a bug report.
> > 
> > Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Link: http://lore.kernel.org/r/20221010172057.00001559@huawei.com
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  test/cxl-topology.sh |   48 +++++++++++++++++++++++++++++-------------------
> >  1 file changed, 29 insertions(+), 19 deletions(-)
> 
> This looks good, just a minor nit below.
> 
> > 
> > diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
> > index 1f15d29f0600..f1e0a2b01e98 100644
> > --- a/test/cxl-topology.sh
> > +++ b/test/cxl-topology.sh
> > @@ -29,27 +29,30 @@ count=$(jq "length" <<< $json)
> >  root=$(jq -r ".[] | .bus" <<< $json)
> >  
> >  
> > -# validate 2 host bridges under a root port
> > +# validate 2 or 3 host bridges under a root port
> >  port_sort="sort_by(.port | .[4:] | tonumber)"
> >  json=$($CXL list -b cxl_test -BP)
> >  count=$(jq ".[] | .[\"ports:$root\"] | length" <<< $json)
> > -((count == 2)) || err "$LINENO"
> > +((count == 2)) || ((count == 3)) || err "$LINENO"
> > +bridges=$count
> >  
> >  bridge[0]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[0].port" <<< $json)
> >  bridge[1]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[1].port" <<< $json)
> > +((bridges > 2)) && bridge[2]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[2].port" <<< $json)
> >  
> > +# validate root ports per host bridge
> > +check_host_bridge()
> > +{
> > +       json=$($CXL list -b cxl_test -T -p $1)
> > +       count=$(jq ".[] | .dports | length" <<< $json)
> > +       ((count == $2)) || err "$3"
> > +}
> >  
> > -# validate 2 root ports per host bridge
> > -json=$($CXL list -b cxl_test -T -p ${bridge[0]})
> > -count=$(jq ".[] | .dports | length" <<< $json)
> > -((count == 2)) || err "$LINENO"
> > -
> > -json=$($CXL list -b cxl_test -T -p ${bridge[1]})
> > -count=$(jq ".[] | .dports | length" <<< $json)
> > -((count == 2)) || err "$LINENO"
> > +check_host_bridge ${bridge[0]} 2 $LINENO
> > +check_host_bridge ${bridge[1]} 2 $LINENO
> > +((bridges > 2)) && check_host_bridge ${bridge[2]} 1 $LINENO
> >  
> > -
> > -# validate 2 switches per-root port
> > +# validate 2 switches per root-port
> >  json=$($CXL list -b cxl_test -P -p ${bridge[0]})
> >  count=$(jq ".[] | .[\"ports:${bridge[0]}\"] | length" <<< $json)
> >  ((count == 2)) || err "$LINENO"
> > @@ -65,9 +68,9 @@ switch[2]=$(jq -r ".[] | .[\"ports:${bridge[1]}\"] | $port_sort | .[0].host" <<<
> >  switch[3]=$(jq -r ".[] | .[\"ports:${bridge[1]}\"] | $port_sort | .[1].host" <<< $json)
> >  
> >  
> > -# validate the expected properties of the 4 root decoders
> > -# use the size of the first decoder to determine the cxl_test version /
> > -# properties
> > +# validate the expected properties of the 4 or 5 root decoders
> > +# use the size of the first decoder to determine the
> > +# cxl_test version / properties
> >  json=$($CXL list -b cxl_test -D -d root)
> >  port_id=${root:4}
> >  port_id_len=${#port_id}
> > @@ -103,12 +106,19 @@ count=$(jq "[ $decoder_sort | .[3] |
> >         select(.nr_targets == 2) ] | length" <<< $json)
> >  ((count == 1)) || err "$LINENO"
> >  
> > +if [ $bridges -eq 3 ]; then
> 
> The $bridges should be quoted if using the posix sh style [ ],
> or use the bash style without quoting: if [[ $bridges == "3" ]]
> or use a 'math' context: if (( bridges == 3 ))

Ah, got it.
