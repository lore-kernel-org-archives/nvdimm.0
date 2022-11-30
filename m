Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5AD2CAB
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 20:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669840752; x=1701376752;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=dUFTLjOK0vr3b9QA4X1XiW0ZzTONSuX9+BrQ7uRxWa0=;
  b=lRPNHIncbqZRoydCUpggtHrUQ81tHcbzFp0zXoKNx8Ai2XhXa5t1y8jP
   QUIvRyhvNDIHTUY7YQU1PJGz6W3rqx9ICvjrpDfhopEPFj4dkq8766b74
   bl6QYtoZqzRRbXiXRojyhSFaRisb4OR39ZhMPW0NLCpxp6MMrP4uJ+BIC
   pctfT5o7VQZf6ec9Y7NAEXsD1TbV4VI0oZce827dlE153kTfdRJIJmjmA
   G+LP5n5SmgKhCyDnVE9zXJ+5N720IW6oMpct02ZcLfB6GmJP2JM8L2whV
   lhWGXCYAS3iSZHDESwtFJ4qSzc7Gqt1xC5HDvu8RCibh54JoRlY/jkJl0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="295871628"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="295871628"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 12:39:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="733131215"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="733131215"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Nov 2022 12:39:11 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 12:39:10 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 12:39:10 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 12:39:10 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 12:39:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAZORXu81Pc7dwfsZyyGueSAFjMFDNJmgWVaYAZP/8/uT3/FhMV3YSBiq2PwVKN/eSKh14MD7mmhlICfwv1q6CFcvysSUQonVLcWy+gAIByJf1OHQxsiRmnOrC0mePr+rMF9Eo4Qkr6A9QVX8Xlu30SV+wrFyLrgl9bXf0wZ+xpJQHmEtpENe+1Lqa1BxkJG6nzBJMJ/OHsyR/JjBHWxc4dDgWxPJeeAHN+8MdH+FcseG0ZIBt+4rjE6TuvDj5nj+iW6xov0H0EJUYl3ujIFpIyAXhdhL7i4hchvIHlZKP8USfzVqFZuo924Tpuz2SawAtLxm9lszgkzY5MTXTH2Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fevgAg9f1tAePGq6t9dhe8gXeNcZGEthZXJ2l2feMB4=;
 b=Ge/3i/5EXyiLLDCE68icb6mejHExQxSXDBf/tN5A5nWsIyBbqW4gqLAec75qPlhHZcdl94/IEabxRIRKj7/NOP48jf1KfTppKsKQz8cqK4ZLEFM0y0KNUnibTsnS/TkCxSgI4s2m0Xzn8H/LdZTXllmMshMiPpfKHi1ETT9RDbFR/XAi8qA6pSL9LFYvVSwjpcMq9DYILuHUYnnuDq6dFREoWE3FVADCoX/t+u38SFPCSlk0yN2+cCqUG3XHY/n4izTw8ZJOglMh8qXNYIsSH/n2scFkhoUMuV4YG9Ma5vZezJ/FKBuzfWQsJ5XexleWp/w0x8l6FZ7SvaucUhtVrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by IA1PR11MB7248.namprd11.prod.outlook.com
 (2603:10b6:208:42c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 20:39:02 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 20:39:02 +0000
Date: Wed, 30 Nov 2022 12:39:00 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Robert Richter <rrichter@amd.com>, Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 10/12] cxl/port: Add RCD endpoint port enumeration
Message-ID: <6387bf64519d1_3cbe0294de@dwillia2-xfh.jf.intel.com.notmuch>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931493266.2104015.8062923429837042172.stgit@dwillia2-xfh.jf.intel.com>
 <Y4U+92BzA+O7fjNE@rric.localdomain>
 <6385516eaa45a_3cbe02944d@dwillia2-xfh.jf.intel.com.notmuch>
 <Y4Z4I4madYxKNT7g@rric.localdomain>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y4Z4I4madYxKNT7g@rric.localdomain>
X-ClientProxiedBy: BY5PR16CA0017.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::30) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|IA1PR11MB7248:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c528bba-e569-4491-4a1e-08dad312ea79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gHebRn/dMQZrLMtXZfX8Bk8MPICyAoXcU0ziYDpzOqQ4ZQnYXOu5PWpS1mJVBlE4JroQLWXkd9F4p3xib/ZLEq5qBdfGws9MX3VAu/waYCNhioKpEpxx9coDE77fG4qizR8+4OKfF4ap+2yBnQVdjD/vLv+II4zIjlDRcbuqrZYQaVIYHbPQ1hx1rSgbj2DRIzWepmnvejPLiskLa69WwoHHd+DTb9Jxgyytf6uxn+niUuBzu9eThloOG2PRZQdPtyGo8akslbqozdeQLaaJPjG1mW6mv/CSF97wpIO2vhH2miWjsXTc3SyBeABGz8Vi76Yr1OL+6xGC8XOJjXRXxn76+jSQ1lCxovY7FxtvzZQwbJZZzfJbk45d/KQfE1GREn3ozKgw1zveMh/ZOHFx/Hn0TJhLkX3IR8QfEBzVPnJZ9S9mkVtC/Lr+wg13xJbSiBVRZxXcH3ruqOTHTf3+vOi6mX1UF7bEfcpc5IUDGSasrpTFvw+neS65pSU6svoimLRiwg+j85wFFVE9AvyeJVh9BPhmMPzakqTs1N45wS2JjbS5YrYpykOG4jFFDJDtaIEPFKtebO+QS1Z9/miLN61JOqfw47NrsNWrD3yvDkX7eTzHSekAi+FaWxXgwrZ94MNpJu0ft02dWgHnBCMVnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199015)(6506007)(2906002)(66476007)(4326008)(41300700001)(66556008)(186003)(316002)(8676002)(110136005)(9686003)(8936002)(5660300002)(478600001)(26005)(66946007)(6486002)(6512007)(53546011)(38100700002)(82960400001)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnFUajBwTVdsQ3BFOW53N1NrS25yUUlwM0dTWlBJaUdCcDZMZ25BdEg4MkRo?=
 =?utf-8?B?Z0QvbWZlSlV2U2ExVklqWXhSa3d1MzE0WHM1TFprVitXdm5SbzhsMDQrb0RP?=
 =?utf-8?B?Ty9yUjUrV3BVZGMwMUlwOUVzQS8yOW5PRVlaZk4xWHMzSTM2Wk45TWJDQjIw?=
 =?utf-8?B?U1FiQUttd2dHZTJUditFM2ttcEV0ZEtNNmRudEpaeDA1TXZUamprOXljejI3?=
 =?utf-8?B?THdkVlRTT3JpTXRWeXQvZ1g5V0JzWmVuM3ErSVBQY2JFYWpsakhJRDI5M04w?=
 =?utf-8?B?amt5TUlaQ3dVS1UybjR6YXVzK1I3Q09ydDVZTmlsbFozUWlUY0MzdVRmZ0tm?=
 =?utf-8?B?TzNINmlxaVNTazBialJuSFBYSGZ3dnBtb05udCtxSW5MZXFreFREV2tvU0dK?=
 =?utf-8?B?VThBd1VEQ3hTUmV1QXZaZEk3YnBWVFJ2VUErWXQyelFjQ0Y5UDVjUWUvZlRH?=
 =?utf-8?B?UG14ZzRhYzJGYU43dlhIbFcycEdJU3lUN0ZUNTdYNFd5Zko2ZDNkbndMcFZN?=
 =?utf-8?B?Mzh4cGFZa0lYRkQzcVNNOGQ4U3FVV2lHTG9HZlloSHVpeEV1aDYzNUY0YytL?=
 =?utf-8?B?dzM1WFQxNzNmbmw3Uy9JcTVGMXlPOTB3aXhyMko4ODV2ODAxMVdCb1cwT09R?=
 =?utf-8?B?eUkxb1ZQd1doeHMxNkM5SGM2RWcxcUZDczRFOUU3RUh1Snl3bGQ2aW04N0tS?=
 =?utf-8?B?VDdHUDQxUFFaangydm9adml1S0htNFJNS2JnTUhaUGJUZGtQTHdYR1pSbHhl?=
 =?utf-8?B?UFJEMGZwV0I5OElxKzZsaDVBRlZ6YzZPcU44bEw1TGFveE5aOHpsVW9HaGc0?=
 =?utf-8?B?eDZySURydnRSK2tUOUt2SG9sZjAvR3NMUnkzUHhBQU9GZ2tNeUY4ck1WaUgr?=
 =?utf-8?B?MW5KWWZxSUNmL0R6aGpCN0lsSitmLzlveUhmQlNLcXkzRERIRFRNQ0lPRk9U?=
 =?utf-8?B?NVZOWllKR3ZSUFpGeEI4S29iTXBudUtISnp0b0FpWHhQMk5mYkdvSXBoSkNO?=
 =?utf-8?B?bGZIV25YazlrV21pcnNyM0xXZ1JJcmR5VjlXbU1XTE00Wk9rUzU5Y2x1bzFC?=
 =?utf-8?B?S1FLK0UxM2c4bEcvUWkwZmxvT0U5OHM0L0ZkUjRXb0t4Mm1hUW1QMlA1bGFi?=
 =?utf-8?B?Ulh3c2FUU3FJempMRXVDb2RoOWFxUjBla3NmK3k4eUt2VklTUU1SRlNyc29N?=
 =?utf-8?B?OVB6eDlQYmt6bWc3NXp5UU9Hd3pzUFFWVXMwS2dMQXR5VHlpczV2M2F1OE9X?=
 =?utf-8?B?UUdoVWsyQlBBSnpLcXNnOWN3T1BHdUw0TnNIb3BTQ2UxQ1gwaEd6SUU0ZHcr?=
 =?utf-8?B?YjZQNmxFVHJ5ZG5YaFdMR24rMndBb3BVU0tWcE8yWHA5MjlPSXU2RFdKM1Zw?=
 =?utf-8?B?bUlZTUJDeHBlSzRsaDh6NlFmMkdHeXM2c0l1NVhWUCtoMjlrR1Z1bTgxa085?=
 =?utf-8?B?R1lVVnFsakZaSXZTWWZKWHhid2xlSFlEcjJDanVDcWU4WWpWczNZb1JzRVI2?=
 =?utf-8?B?T3Arc1JGVzBnRzZJcHk5YmJRM1czbGVrNUU1aVlMODAxUldVdFNVMnZiUjZE?=
 =?utf-8?B?VjcrcU1yWEJSc0NNaGRFM0hqRkg1MVViRUlKbnpJT0FqT21zNkFQdyttcGgw?=
 =?utf-8?B?aHVINW9RRFZabW1oZTNXL013TVZ2V1J4RnU5eitobWU5UTB4cWE5VElDR1Z1?=
 =?utf-8?B?K1ZGV1RZWElrWDJrdDl1QmRGejVtUWYyeEFCSVgwdHV1N09UVDltcGx3U3VT?=
 =?utf-8?B?d1BsSmdBQXovZWVpNHBsZHhkTi9oMGk1dnJVZVVEbnR0TzVzdENOKzlrNXRy?=
 =?utf-8?B?SmZrSEp5c2piWllWSDRIczE4OTdwNlZWbzArSCtoSWJpdjhKWjZ0TzdOdnRv?=
 =?utf-8?B?WXEwczRkZHVPUG9RVElYOEpyd29RMnRMdHQ1OGFpY1dLMHNHMFFqeGhUSDZV?=
 =?utf-8?B?RFRZRG11SnpWTDQxTThjWFlDSyszR09ySXU0a2EzUzBjRHNuRk5GeTMwSlA3?=
 =?utf-8?B?bkYzNXNGamVFeVcwL0kyWExFWEdjR1VEWlRHcFhhWVNNWnRUVkEvUTM1Zk5W?=
 =?utf-8?B?bE1oYVhUcUl3RWpWT1RVWkhQNlNoaU94QmdUL1JWWVozSXNIZ1A5a1ZCMEYv?=
 =?utf-8?B?alBNQ2VKZG1VUE0wbkZEMEg5ZTF1WkZaNlBEdkRDS1ZhOURrQ1FBTTV4TzlR?=
 =?utf-8?B?WEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c528bba-e569-4491-4a1e-08dad312ea79
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 20:39:02.4442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0Xxt4LG3E9mVtW1Wl0KBIste33+NpV85mwdtlYfsminmpCuqZRONImGMQrvWdYz53TEmXu41aU6nffD6qyLXLu5bfQVyz+hCQrYcHXJyhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7248
X-OriginatorOrg: intel.com

Robert Richter wrote:
> On 28.11.22 16:25:18, Dan Williams wrote:
> > Robert Richter wrote:
> > > On 24.11.22 10:35:32, Dan Williams wrote:
> > > > Unlike a CXL memory expander in a VH topology that has at least one
> > > > intervening 'struct cxl_port' instance between itself and the CXL root
> > > > device, an RCD attaches one-level higher. For example:
> > > > 
> > > >                VH
> > > >           ┌──────────┐
> > > >           │ ACPI0017 │
> > > >           │  root0   │
> > > >           └─────┬────┘
> > > >                 │
> > > >           ┌─────┴────┐
> > > >           │  dport0  │
> > > >     ┌─────┤ ACPI0016 ├─────┐
> > > >     │     │  port1   │     │
> > > >     │     └────┬─────┘     │
> > > >     │          │           │
> > > >  ┌──┴───┐   ┌──┴───┐   ┌───┴──┐
> > > >  │dport0│   │dport1│   │dport2│
> > > >  │ RP0  │   │ RP1  │   │ RP2  │
> > > >  └──────┘   └──┬───┘   └──────┘
> > > >                │
> > > >            ┌───┴─────┐
> > > >            │endpoint0│
> > > >            │  port2  │
> > > >            └─────────┘
> > > > 
> > > > ...vs:
> > > > 
> > > >               RCH
> > > >           ┌──────────┐
> > > >           │ ACPI0017 │
> > > >           │  root0   │
> > > >           └────┬─────┘
> > > >                │
> > > >            ┌───┴────┐
> > > >            │ dport0 │
> > > >            │ACPI0016│
> > > >            └───┬────┘
> > > >                │
> > > >           ┌────┴─────┐
> > > >           │endpoint0 │
> > > >           │  port1   │
> > > >           └──────────┘
> > > > 
> > > > So arrange for endpoint port in the RCH/RCD case to appear directly
> > > > connected to the host-bridge in its singular role as a dport. Compare
> > > > that to the VH case where the host-bridge serves a dual role as a
> > > > 'cxl_dport' for the CXL root device *and* a 'cxl_port' upstream port for
> > > > the Root Ports in the Root Complex that are modeled as 'cxl_dport'
> > > > instances in the CXL topology.
> > > > 
> > > > Another deviation from the VH case is that RCDs may need to look up
> > > > their component registers from the Root Complex Register Block (RCRB).
> > > > That platform firmware specified RCRB area is cached by the cxl_acpi
> > > > driver and conveyed via the host-bridge dport to the cxl_mem driver to
> > > > perform the cxl_rcrb_to_component() lookup for the endpoint port
> > > > (See 9.11.8 CXL Devices Attached to an RCH for the lookup of the
> > > > upstream port component registers).
> > > > 
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > ---
> > > >  drivers/cxl/core/port.c |   11 +++++++++--
> > > >  drivers/cxl/cxlmem.h    |    2 ++
> > > >  drivers/cxl/mem.c       |   31 ++++++++++++++++++++++++-------
> > > >  drivers/cxl/pci.c       |   10 ++++++++++
> > > >  4 files changed, 45 insertions(+), 9 deletions(-)
> > > > 
> > > > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > > > index c7f58282b2c1..2385ee00eb9a 100644
> > > > --- a/drivers/cxl/core/port.c
> > > > +++ b/drivers/cxl/core/port.c
> > > > @@ -1358,8 +1358,17 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
> > > >  {
> > > >  	struct device *dev = &cxlmd->dev;
> > > >  	struct device *iter;
> > > > +	struct cxl_dport *dport;
> > > > +	struct cxl_port *port;
> > > 
> > > There is no direct need to move that code here.
> > > 
> > > If you want to clean that up in this patch too, then leave a comment
> > > in the change log?
> > 
> > Oh, good point, must have been left over from an earlier revision of the
> > patch, dropped it.
> > 
> > > 
> > > >  	int rc;
> > > >  
> > > > +	/*
> > > > +	 * Skip intermediate port enumeration in the RCH case, there
> > > > +	 * are no ports in between a host bridge and an endpoint.
> > > > +	 */
> > > > +	if (cxlmd->cxlds->rcd)
> > > > +		return 0;
> > > > +
> > > >  	rc = devm_add_action_or_reset(&cxlmd->dev, cxl_detach_ep, cxlmd);
> > > >  	if (rc)
> > > >  		return rc;
> > > > @@ -1373,8 +1382,6 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
> > > >  	for (iter = dev; iter; iter = grandparent(iter)) {
> > > >  		struct device *dport_dev = grandparent(iter);
> > > >  		struct device *uport_dev;
> > > > -		struct cxl_dport *dport;
> > > > -		struct cxl_port *port;
> > > >  
> > > >  		if (!dport_dev)
> > > >  			return 0;
> > > > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > > > index e082991bc58c..35d485d041f0 100644
> > > > --- a/drivers/cxl/cxlmem.h
> > > > +++ b/drivers/cxl/cxlmem.h
> > > > @@ -201,6 +201,7 @@ struct cxl_endpoint_dvsec_info {
> > > >   * @dev: The device associated with this CXL state
> > > >   * @regs: Parsed register blocks
> > > >   * @cxl_dvsec: Offset to the PCIe device DVSEC
> > > > + * @rcd: operating in RCD mode (CXL 3.0 9.11.8 CXL Devices Attached to an RCH)
> > > >   * @payload_size: Size of space for payload
> > > >   *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
> > > >   * @lsa_size: Size of Label Storage Area
> > > > @@ -235,6 +236,7 @@ struct cxl_dev_state {
> > > >  	struct cxl_regs regs;
> > > >  	int cxl_dvsec;
> > > >  
> > > > +	bool rcd;
> > > >  	size_t payload_size;
> > > >  	size_t lsa_size;
> > > >  	struct mutex mbox_mutex; /* Protects device mailbox and firmware */
> > > > diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> > > > index aa63ce8c7ca6..9a655b4b5e52 100644
> > > > --- a/drivers/cxl/mem.c
> > > > +++ b/drivers/cxl/mem.c
> > > > @@ -45,12 +45,13 @@ static int cxl_mem_dpa_show(struct seq_file *file, void *data)
> > > >  	return 0;
> > > >  }
> > > >  
> > > > -static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> > > > +static int devm_cxl_add_endpoint(struct device *host, struct cxl_memdev *cxlmd,
> > > >  				 struct cxl_dport *parent_dport)
> > > >  {
> > > >  	struct cxl_port *parent_port = parent_dport->port;
> > > >  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> > > >  	struct cxl_port *endpoint, *iter, *down;
> > > > +	resource_size_t component_reg_phys;
> > > >  	int rc;
> > > >  
> > > >  	/*
> > > > @@ -65,8 +66,18 @@ static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> > > >  		ep->next = down;
> > > >  	}
> > > >  
> > > > -	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
> > > > -				     cxlds->component_reg_phys, parent_dport);
> > > > +	/*
> > > > +	 * The component registers for an RCD might come from the
> > > > +	 * host-bridge RCRB if they are not already mapped via the
> > > > +	 * typical register locator mechanism.
> > > > +	 */
> > > > +	if (parent_dport->rch && cxlds->component_reg_phys == CXL_RESOURCE_NONE)
> > > > +		component_reg_phys = cxl_rcrb_to_component(
> > > > +			&cxlmd->dev, parent_dport->rcrb, CXL_RCRB_DOWNSTREAM);
> > > 
> > > As already commented: this must be the upstream RCRB here.
> > > 
> > > > +	else
> > > > +		component_reg_phys = cxlds->component_reg_phys;
> > > > +	endpoint = devm_cxl_add_port(host, &cxlmd->dev, component_reg_phys,
> > > > +				     parent_dport);
> > > 
> > > Looking at CXL 3.0 spec, table 8-22, there are the various sources of
> > > component registers listed. For RCD we need: D1, DP1, UP1 (optional
> > > R).
> > > 
> > > 	D1:	endpoint->component_reg_phys;
> > > 	UP1:	parent_port-component_reg_phys; (missing in RCH topology)
> > > 	DP1:	parent_dport->component_reg_phys;
> > > 
> > > I don't see how all of them could be stored in this data layout as the
> > > cxl host port is missing.
> > 
> > If I am understanding your concern correctly, that's handled here:
> > 
> >     if (parent_dport->rch && cxlds->component_reg_phys == CXL_RESOURCE_NONE)
> > 
> > In the D1 case cxlds->component_reg_phys will be valid since the
> > component registers were visible via the register locator DVSEC and
> > retrieved by cxl_pci. In the UP1 case cxlds->component_reg_phys is
> > invalid and the driver falls back to the RCRB. DP1 is handled in
> > cxl_acpi. I.e. the D1 and UP1 cases do not co-exist.
> 
> What I mean is we must store all 3 component reg base addresses for
> later access. E.g., if there is an AER error of a pci dev or the host,
> we must (depending on the error details) access CXL RAS status of
> either D1, UP1 or DP1. So for all 3 of them there must be a way to
> determine this walking through the port hierarchy. In the above list
> of locations I don't where UP1's component reg base address is stored.

So I think we are reading the specification differently. I am comparing
Figure 9-7 "CXL Device Remaps Upstream Port and Component Registers" and
Figure Figure 9-8 "CXL Device that Does Not Remap Upstream Port and
Component Registers" and noting that there is never a case where three
sets of component registers are visible. It is either DP1 connected to
UP1 (Figure 9-7) or DP1 connected to D1 (Figure 9-8). There is never a
case where the code needs to consider UP1 and D1 component registers at
the same time because those things are identical just enumerated
differently depending on how the endpoint is implemented.
