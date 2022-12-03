Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120E87B
	for <nvdimm@lists.linux.dev>; Sat,  3 Dec 2022 08:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670054507; x=1701590507;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=D1xUvAxPYiFoJgsUhcSia8LI6Yhm7dRKhf+fhhL/Ob4=;
  b=bXbr+RObFkqS8Bz4vrs6X56ZfQZ8gEN3YeAIP0ZcAdaQKNQOjvAyUKjB
   u/4qWK02BB16yXdWBoKpU53r5+/EHyeOF4dy8Jh7LNteUkArClG4ZSHux
   w8oTcZr5uu8pQfygaodHqht6pmmnTKKRo6PMHRkJqQ4eU3BeerJhHjrqp
   qjZXS7a4oysqVgTpeoDDZofpowfADgqhwJOPLtenkNS0r9aPw/kKZNHCY
   s6aGRnr6520AvjIS70mlmYu3tMkTJOBgnbdJS98GAG3/ZFOlcGgCc4b//
   2eww6L5yhHu3L3MnovTUiSx32r+N0yA9vAazguD0YN+7UcAOHOqA6S5JT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="317250310"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="317250310"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2022 00:01:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="708734660"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="708734660"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 03 Dec 2022 00:01:45 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 3 Dec 2022 00:01:44 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 3 Dec 2022 00:01:44 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 3 Dec 2022 00:01:44 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 3 Dec 2022 00:01:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQXAqUD8/RToM9dJmYuuiu6hVY1Hmc0hDCh7dg0yDDLukYKVf2BqsKY1CT8FqPZDdEtbneSgyA3pV6OM1pCHcF/GcbZERHkOzVFhGk+7oet2B2ANRADdPj5LG+jlkMppL9b5bNAw2ypp7efmrzQLzhhtacibejH7+hBx0Ko3QMM5u+Ojq7gJZf/hy56WNhpDIYK7+8Vl+WsbQFnv1TE1BSVaFQ7B1U00gLiB6G3GuBTS+I+g8uTpRe2GE9DJtvZT+dyE2cS28pBZKPccR4fPhHr+Ackkt6d/2KF0P2L1krD3bjcszxofnNc5OmCE4LgYUp6EAuSwOwvsfNBG31LXVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3brlraclUm4tz6IrcTatpvyrIu/k0FtA+qwiZAfQPLM=;
 b=JAY3LkZdoB5/q7gl2Z7DatTBPMZhZLfDsMFoy/VQ9cOtzMDPuyXJSeCDf+sdbUtrFZGte/GCxHYXzUw/gaqgFcgRbwCAr34wX4I/OehG3kXBoEBPu2yOX7lgPjTF0FLnFFWvfHWaYjwv7RJGnBePJt9AFGMHI2qL0o5Aj6V8LQUGA+o956YpEREblL8OS2JwlVU6x0/4u5MZQOM8o+RUp/KmzeNkKHlTmQCcXFdd9kaTmPhdVLlVKbASPrMNATXUhbn0f0NDCZSg3dSr4syA0mJjOM5AUKrSB+2U12NkbWggWb+ndgU9Nzn7q28YwtNTAC8o1peY3WNeVwryU8KZ6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM6PR11MB4657.namprd11.prod.outlook.com
 (2603:10b6:5:2a6::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Sat, 3 Dec
 2022 08:01:42 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 08:01:41 +0000
Date: Sat, 3 Dec 2022 00:01:35 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Dan Williams
	<dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH 4/5] nvdimm/region: Move cache management to the region
 driver
Message-ID: <638b025f7fada_3cbe029432@dwillia2-xfh.jf.intel.com.notmuch>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
 <166993221550.1995348.16843505129579060258.stgit@dwillia2-xfh.jf.intel.com>
 <20221202032131.hmy7ydpddjrlpd4u@offworld>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221202032131.hmy7ydpddjrlpd4u@offworld>
X-ClientProxiedBy: SJ0PR03CA0203.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::28) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DM6PR11MB4657:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c455e46-61dc-4fb5-7176-08dad5049c8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: juO7xASN/xd21atyR4sNzf0PHEjCa7bLcJsloKWmdwQ9lw25+whAFtDzojYz9ZDCL8e7ne5XDngEzZRa/+9EqzLMQ3nMb/x5ig+nlWmgTzxPZxziaNxKfID2+6mUM1t5cbUVuEHnRoOQwIT8FAQL1xBSKeLG+xs5QZQOzegyXVRWTaigQ9hRxG+aiPdOsOl4sK79G4/7ecpwbxJKD2Oc/mDwh9GFP1oPe7BzPYrDiYBFiSAkGVRk1BhbNAx+5YvpgkZENuAx/Ynynmy/6XvfkIn2oXEJmLSdeh2hr2KblbOFx/hwHpWgk7BiXXkm4GkzMTbntq8QCu+IEQVYjOBsdWEyQ3vixcbvY84dPX9MbB+7cQmInsXON0XPYQGuD8/o4S58OIoDRG1ubQITVjozk0rIuCvDEuk+LHAZnndc3UQMUoof7VGAwECue43wz7FuNPi2Znq8XUWev3RoTK9I0O4CsFO7IfO0IFWKgPcTmkuiWTKJTAGffkUsf7LMikeE4ApqbfQXsBUFFtG1OmunYgk1fvCeRb+nuqDRawX0MGU+ISGuic/pUxgCKY7eyReA1XDRQO5I7I1XjulR3Wmy619ll98uMf+ik72gzjIoOFJXHB5EJxFZ51uTabcugB6ibig/tx76drfbdsOfxb0ZqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(39860400002)(376002)(346002)(451199015)(38100700002)(82960400001)(2906002)(41300700001)(8936002)(4326008)(83380400001)(86362001)(66946007)(66556008)(66476007)(478600001)(6486002)(316002)(110136005)(5660300002)(6666004)(8676002)(26005)(6506007)(186003)(9686003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XImwnVr9cXqZyKnavnO41TCJWUnGKbtZBpiEd/T5Q53QdP5DQ3LEZfxBdi29?=
 =?us-ascii?Q?+QK2n//aBEp0bBKSIrfRYDI80pe3PyN0QztF6KssxHQB+fL3qhf9xvt3gOA3?=
 =?us-ascii?Q?nak3ST5qYZAX3pU06Itj0vE0RtwOwHg0SSVOkfc9luxP1lmKJ1GnaKc/xjEr?=
 =?us-ascii?Q?6yvPRpAVy8BXfy5R2Zs7pqtG+UUMe2CpJIgtdK5nfRJ8V+b+qwKyw+2VCskC?=
 =?us-ascii?Q?lLBPFrwCnWQ9TXnj4DodRwQ8ngh1yWS8ojXpGB3OjyLSU3oAu2C6W1lpt1jE?=
 =?us-ascii?Q?A7TYNH/2b0qFV3xcqR36BDTxF4FWGqiTKNuzSuffmiLzv66ZYdQ5wz2Z3DCc?=
 =?us-ascii?Q?DHdpAZcUMsQrQR1GxllAVLtIrRkkG3i9ngo7E4FLLkIRv81jKG1sqGqwqQaa?=
 =?us-ascii?Q?uekWpjSfX9T4n/sYzCKxBmI89SsnYk3TDXx+Y/qXvMjQHk+fHwZFqL2ljYjJ?=
 =?us-ascii?Q?iFkHFXTXJfWdEGZgIOJt4PbWvzEtbfw8SHSo8Hm+BLfROl6kYxzxTUiOeeT9?=
 =?us-ascii?Q?fWvyz9ZEHIVipwCPLbpkhm9TpIctYTydiNQ1CPGL5sgnE1gtPj7X1ZK6WUGn?=
 =?us-ascii?Q?ZftgZ3Y/AGxIOmYrcwj6oEkV5NR7PCbWUwSndBYtqtusA5ldOP0IVZs3W82G?=
 =?us-ascii?Q?AabQcRbOi0uwLwx9l0HKD00Yu11FKdLKj9FPO+XhNyG6CYFZlCcXrje+LCjb?=
 =?us-ascii?Q?UapFWx7mgjOr9yeFcaT/CLo79YvbFbTr/FA2NdUSqyhoI0bwserq3MSMSXOt?=
 =?us-ascii?Q?KJ5tWqgWq0MCiIfz8nVb+JWqtlAYOgtocw59VfBg6s2y9SojpS77sSQfu8ki?=
 =?us-ascii?Q?QMLL/YOF/EqgAS0WV/fiWtlON+z22DuoeGwQDPc7LFWnJhFa80RANteCMVVO?=
 =?us-ascii?Q?pClXAD/KdpkEXL/7nUftDctKciHbkRhD2CX++S6jr1oBAVyIPdxrmFeIpwf0?=
 =?us-ascii?Q?Wi4KEyBn9EHmAE5gCr5UogaJL4ZgkHy0Vgyii8KL1efIqX8RyjljyKTemD9V?=
 =?us-ascii?Q?HbGkW0Oev9iQ7XHnnX1fDN2ebYzOMHXNOgKEtMRDLVJWkFEiVIQwcp9Wglil?=
 =?us-ascii?Q?kaJq9KVTaCUILDrH8DNZpGZHaCom+n23X9myjAwzyD4UfeUee8WF/HS2jiBp?=
 =?us-ascii?Q?QFncOzdzw+xBcsY4v/rs2EzWJO2jGw3DCA+94b8OZ8ft6sUOA251VVwwPZnL?=
 =?us-ascii?Q?n82grAL9L88SJNrgC3HAqMHiqZl0mXKkkPyrO7JB0DDJ6uOzvObCRp15/4E0?=
 =?us-ascii?Q?wBWHH6BJWXZFF/IycHIYX59ewACr8l7BLCMrIYRVPMxkpi99jct9DSxz2TAY?=
 =?us-ascii?Q?qUn23SasLdIUveWAeNceRiDkgWVngFIS5chZdjA8V7WnAeLnsAd1DMKrfW9O?=
 =?us-ascii?Q?ORti4pZp4O0gnNbTjkTo5ZyRCxGN6V3GSJYcfV61CoaPClwHBqFLnuaInwyL?=
 =?us-ascii?Q?BFab4Mj2GHpGr/0lb+hI7eeg72bn827lteE5DDrg58wRv/tMus6gTyZ3LDJy?=
 =?us-ascii?Q?x8DAAEpaYj1JmvkGhUTdic3C/xz89TW0WwMUtxWSP+F0wvI9VICdp7RHkUov?=
 =?us-ascii?Q?g6AI9vsdyGoiWtWblk3m/v2NJveiGv3LAO+xqJWIMR5wmwv5LgNRJsCjxs2i?=
 =?us-ascii?Q?lw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c455e46-61dc-4fb5-7176-08dad5049c8d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 08:01:41.1478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJjSdDwe47bCrWJbwaHbU3DjK3aPZJirl76dhk+PEf6o4tBpdOdYWcE1eIeofOGtBzD+nwNXhRKRgSch7UUFoZ3CrI59SqAOIVUy+swpDdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4657
X-OriginatorOrg: intel.com

Davidlohr Bueso wrote:
> On Thu, 01 Dec 2022, Dan Williams wrote:
> 
> >Now that cpu_cache_invalidate_memregion() is generically available, use
> >it to centralize CPU cache management in the nvdimm region driver.
> >
> >This trades off removing redundant per-dimm CPU cache flushing with an
> >opportunistic flush on every region disable event to cover the case of
> >sensitive dirty data in the cache being written back to media after a
> >secure erase / overwrite event.
> 
> Very nifty.
> 
> >Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
> 
> with a few notes below.
> 
> >+static int nd_region_invalidate_memregion(struct nd_region *nd_region)
> >+{
> >+	int i, incoherent = 0;
> >+
> >+	for (i = 0; i < nd_region->ndr_mappings; i++) {
> >+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> >+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
> >+
> >+		if (test_bit(NDD_INCOHERENT, &nvdimm->flags))
> >+			incoherent++;
> 
> No need to compute the rest, just break out here?

Sure, makes sense.

> 
> >+	}
> >+
> >+	if (!incoherent)
> >+		return 0;
> >+
> >+	if (!cpu_cache_has_invalidate_memregion()) {
> >+		if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST)) {
> >+			dev_warn(
> >+				&nd_region->dev,
> >+				"Bypassing cpu_cache_invalidate_memergion() for testing!\n");
> >+			goto out;
> >+		} else {
> >+			dev_err(&nd_region->dev,
> >+				"Failed to synchronize CPU cache state\n");
> >+			return -ENXIO;
> >+		}
> >+	}
> >+
> >+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> >+out:
> >+	for (i = 0; i < nd_region->ndr_mappings; i++) {
> >+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> >+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
> >+
> >+		clear_bit(NDD_INCOHERENT, &nvdimm->flags);
> >+	}
> >+
> >+	return 0;
> >+}
> >+
> > int nd_region_activate(struct nd_region *nd_region)
> > {
> >-	int i, j, num_flush = 0;
> >+	int i, j, rc, num_flush = 0;
> >	struct nd_region_data *ndrd;
> >	struct device *dev = &nd_region->dev;
> >	size_t flush_data_size = sizeof(void *);
> >
> >+	rc = nd_region_invalidate_memregion(nd_region);
> >+	if (rc)
> >+		return rc;
> >+
> >	nvdimm_bus_lock(&nd_region->dev);
> >	for (i = 0; i < nd_region->ndr_mappings; i++) {
> >		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> >@@ -85,6 +129,7 @@ int nd_region_activate(struct nd_region *nd_region)
> >	}
> >	nvdimm_bus_unlock(&nd_region->dev);
> >
> >+
> >	ndrd = devm_kzalloc(dev, sizeof(*ndrd) + flush_data_size, GFP_KERNEL);
> >	if (!ndrd)
> >		return -ENOMEM;
> >@@ -1222,3 +1267,5 @@ int nd_region_conflict(struct nd_region *nd_region, resource_size_t start,
> >
> >	return device_for_each_child(&nvdimm_bus->dev, &ctx, region_conflict);
> > }
> >+
> >+MODULE_IMPORT_NS(DEVMEM);
> >diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
> >index 6814339b3dab..a03e3c45f297 100644
> >--- a/drivers/nvdimm/security.c
> >+++ b/drivers/nvdimm/security.c
> >@@ -208,6 +208,8 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
> >	rc = nvdimm->sec.ops->unlock(nvdimm, data);
> >	dev_dbg(dev, "key: %d unlock: %s\n", key_serial(key),
> >			rc == 0 ? "success" : "fail");
> >+	if (rc == 0)
> >+		set_bit(NDD_INCOHERENT, &nvdimm->flags);
> >
> >	nvdimm_put_key(key);
> >	nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
> >@@ -374,6 +376,8 @@ static int security_erase(struct nvdimm *nvdimm, unsigned int keyid,
> >		return -ENOKEY;
> >
> >	rc = nvdimm->sec.ops->erase(nvdimm, data, pass_type);
> >+	if (rc == 0)
> >+		set_bit(NDD_INCOHERENT, &nvdimm->flags);
> >	dev_dbg(dev, "key: %d erase%s: %s\n", key_serial(key),
> >			pass_type == NVDIMM_MASTER ? "(master)" : "(user)",
> >			rc == 0 ? "success" : "fail");
> >@@ -408,6 +412,8 @@ static int security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
> >		return -ENOKEY;
> >
> >	rc = nvdimm->sec.ops->overwrite(nvdimm, data);
> >+	if (rc == 0)
> >+		set_bit(NDD_INCOHERENT, &nvdimm->flags);
> 
> Are you relying on hw preventing an incoming region_activate() while the overwrite
> operation is in progress to ensure that the flags are stable throughout the whole
> op? Currently query-overwrite also provides the flushing guarantees for when the
> command is actually complete (at least from a user pov).

The driver handles this in nd_region_activate(), but hey, look at that,
nd_region_invalidate_memregion() is too early. I.e. it's before this check:

                if (test_bit(NDD_SECURITY_OVERWRITE, &nvdimm->flags)) {
                        nvdimm_bus_unlock(&nd_region->dev);
                        return -EBUSY;
                }

...which means that the cache could be invalidated too early while the
overwrite is still happening. Will move the cache invalidate below that
check. Thanks for poking at it!

Folded the following:

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index c73e3b1fd0a6..83dbf398ea84 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -67,8 +67,10 @@ static int nd_region_invalidate_memregion(struct nd_region *nd_region)
                struct nd_mapping *nd_mapping = &nd_region->mapping[i];
                struct nvdimm *nvdimm = nd_mapping->nvdimm;
 
-               if (test_bit(NDD_INCOHERENT, &nvdimm->flags))
+               if (test_bit(NDD_INCOHERENT, &nvdimm->flags)) {
                        incoherent++;
+                       break;
+               }
        }
 
        if (!incoherent)
@@ -106,10 +108,6 @@ int nd_region_activate(struct nd_region *nd_region)
        struct device *dev = &nd_region->dev;
        size_t flush_data_size = sizeof(void *);
 
-       rc = nd_region_invalidate_memregion(nd_region);
-       if (rc)
-               return rc;
-
        nvdimm_bus_lock(&nd_region->dev);
        for (i = 0; i < nd_region->ndr_mappings; i++) {
                struct nd_mapping *nd_mapping = &nd_region->mapping[i];
@@ -129,6 +127,9 @@ int nd_region_activate(struct nd_region *nd_region)
        }
        nvdimm_bus_unlock(&nd_region->dev);
 
+       rc = nd_region_invalidate_memregion(nd_region);
+       if (rc)
+               return rc;
 
        ndrd = devm_kzalloc(dev, sizeof(*ndrd) + flush_data_size, GFP_KERNEL);
        if (!ndrd)
