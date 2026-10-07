Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252FE3CB569
	for <nvdimm@lists.linux.dev>; Wed,  7 Oct 2026 20:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791404332; cv=none; b=aSpvHcWjma5uHL/xyvb3SBPPkNGsflw50Xr9uBNVQJauBmwes1v5524OEKXn1CLpI75XMVwW8OJrOmo6/1FXG34iO7J8uRnFjavubPy+adpqeB1goWsVQHphbIYwb/c/TBaF8nE5juzGQed+LdOoJOos8hR1qz137o2X3e+UkMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791404332; c=relaxed/simple;
	bh=OKaeIO9X1hiHfV6TzafdOqaB7v65zFl5igFThBWqezk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddTF8lUOnr7doUUqW4wr577BBoZCKgv9UPe7iUIvG95mrZTDNBRtxxbSNxEV7zo0JWbGiANN8u91F9p93cSI/SbpGheRav9FIltsRMVCB10Rbn6gyzn+q7FRsOdTTaxhvRexIRD70blcqm00412gAaNicsr1qfZOajXreFqzaXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gkYSZrlE; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gkYSZrlE"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cbedd5aece4so13612a12.0
        for <nvdimm@lists.linux.dev>; Wed, 07 Oct 2026 13:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791404328; x=1792009128; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q5pSlynuMJzfUhbXx8QpV8TphfLEgYQox+MdVfDxaBE=;
        b=gkYSZrlE4eOhQbeo1Xxgsp4l25meb8l0GsQYiwUSQkRxrWXqDG4JPjtGzg/fWXl0Qh
         zdjhHk8kLaRuAJsjZIgfIncyBMm1UVm0krXJ5h0MReQMD/KnJ+ijQv/mwjLRkc7olVDp
         /5B/t1goN4zS/QkmH7xIuAqP+eGAcWaROOkaP4jAVKLB7r3Ds++sluqEgpor7KCvKba0
         j20W4lcn6E3n1KZKeDuh6j/Z1wCnX2gRK2TCYF0ozaIz+bof6slOIMT3br4DeBf9Nuq8
         fe7S/4Ti+CP4AtxVWR6uEBKQgVj4RYa7t6vmJwkbBlmHYz95LKXaLH5PKc5Y8w/uQyl0
         fJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791404328; x=1792009128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q5pSlynuMJzfUhbXx8QpV8TphfLEgYQox+MdVfDxaBE=;
        b=TvNTtPYIDTf3uYIUxn5RG0wE1cWnkLJlct6fgJ4ifVJmy1ZKvI6c7/98Zju5qgu3/w
         hpYYMMkDoqUUXu4XQGnNvMb/1a57DGmgJ4F91MKyTodimTQjOcZUUYLuqy+5Oi9dgm9S
         rK9PK+8RV2oeFDTt0K8lQJH5yjbJR7i1i9EYebZX+ME3huR4fZRiPxeQxqpMUY5AQrvC
         /6omRTOgIyE6yGZo0zzLBP1KxER+gduhw0okpNmBT1Wr//Wdmkjp5d1w9Eu+EA/TPNQ1
         kApy36z0EOQbS5RMx5n21I3o4VCetxVRs2NHNDdkX3HQwEP7wzFWgDHafmcEFvJDMam6
         XM8Q==
X-Gm-Message-State: AFq9FYKiDrbojX+lXnHGXZh2f4C73xxvJLZSrijMwKlDqDIyZ7dTEJIx
	VvVbm2Gr6sC22qGQQ4cggff52Rwj7Q1H5YVxHJg8m0sxU2z1qzlRYsPa
X-Gm-Gg: AYBFou0HU35yHmbTzzedTGEr5eCCxfOWTMuhTFom9QJiAfzmvoyLPgs8vmSHKuv1OtN
	1zjk4DMsryIPImuAgY6CcnYTLZgHVmLk7K9myyiWi/a95pW93eeV2+xT0W157Hl/8GBBTP3T1dj
	6Au52NrPG8gQtEDBr7pC8MHrnNdep3tWdjPbWBXl0wqCy67YLzxJgGLjbaFjylW+0NfOBFwshCR
	l+07EZnphe0EM7qu6G8t+HqRG3py/rVyMfHM2Ot19O9ZLkXspzdemQDMCAJmaK0nLhj1z70dYbF
	MCocICX7Gw7YYFKR8atS63l/li3JVKqrY7bOy+c+JUE2/GO/9gQfW4nzjaAmSGdndjfu0oJVJOc
	BAinUC2Jnk66FOIpXiRt3LL/o0OwtCdB6oS+rdY4EQqB7ej70Q2cn4RQx+mgBueyexsU8lWr6Nk
	J85uMiT1qNOCr6IDYWVp5IjPb9gbYq4SryDVOXV+Y85og3w8X/2vnBU91fzhdJ6Bl8s5ozz6eiv
	hcRZrcWKenRwFEkwUBLZYDy5ylE5DkuvxB9vptACB9AXwoYI8ZHHN12MpQPgoYS+cJbWHK8Mg3O
	pPd3v6Io6X7FjQ==
X-Received: by 2002:a17:90b:6cc:b0:3a7:ed4d:afeb with SMTP id 98e67ed59e1d1-3aaed7ff677mr143101a91.27.1791404328364;
        Wed, 07 Oct 2026 13:18:48 -0700 (PDT)
Received: from 4470NRD-ASU.ssi.samsung.com (c-24-19-224-150.hsd1.wa.comcast.net. [24.19.224.150])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff7ab034sm967623a91.4.2026.10.07.13.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 13:18:47 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>,
	Anisa Su <anisa.su@samsung.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH v15 8/8] Documentation/cxl: Document DPA partition layout and ordering rules
Date: Wed,  7 Oct 2026 13:16:41 -0700
Message-ID: <20261007201828.952-9-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007201828.952-1-anisa.su@samsung.com>
References: <20261007201828.952-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DC Partitions complicate DPA ordering. Add a DPA Partitions section to
cxl-driver.rst describing spec-mandated and Linux requirements for the
layout.

maturity-map.rst breaks the DCD entry into sub-items so the map shows
what this series lands: partition enumeration is [1], event handling
and DC-backed DAX regions remain [0] until the follow-on series enables
them. The parent stays [0]; nothing is usable yet.

Suggested-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
---
 .../driver-api/cxl/linux/cxl-driver.rst       | 35 +++++++++++++++++++
 Documentation/driver-api/cxl/maturity-map.rst |  4 +++
 2 files changed, 39 insertions(+)

diff --git a/Documentation/driver-api/cxl/linux/cxl-driver.rst b/Documentation/driver-api/cxl/linux/cxl-driver.rst
index dd6dd17dc536..212df4fb8d63 100644
--- a/Documentation/driver-api/cxl/linux/cxl-driver.rst
+++ b/Documentation/driver-api/cxl/linux/cxl-driver.rst
@@ -181,6 +181,41 @@ A Memory Device is a discrete base object that is not a port.  While the
 physical device it belongs to may also host an `endpoint`, the relationship
 between an `endpoint` and a `memdev` is not captured in sysfs.
 
+DPA Partitions
+~~~~~~~~~~~~~~
+A memory device presents its capacity as one flat `Device Physical Address`
+(DPA) space divided into `partitions`, which Linux lays out in a fixed
+order::
+
+  DPA 0                                                     end
+  +---------------+---------------+---------------------------+
+  |      ram      |     pmem      |       dynamic_ram_1       |
+  +---------------+---------------+---------------------------+
+  part[0]         part[1]         part[2]
+
+Part of that order is required by the CXL specification and part of it is a
+Linux choice.
+
+The `ram` and `pmem` order is mandated.  CXL r4.0 section 8.2.10.9.2.1 "Get
+Partition Info" (4100h), Table 8-310, mandates that volatile capacity starts
+at DPA 0 and pmem starts at the DPA immediately following it.
+
+Dynamic Capacity partitions only need to be 256MB aligned according to
+CXL r4.0 section 8.2.10.9.9.1 "Get Dynamic Capacity Configuration"
+(opcode 4800h), Table 8-347. So a device could leave a gap between ram/pmem
+(static) capacity and its first DC partition, or between one DC partition
+and the next.
+
+Linux chooses not to support gaps between static and dynamic capacity: the
+first DC partition must begin at the DPA immediately following static
+capacity -- after pmem, after ram on a device with no pmem, or at DPA 0 on
+a device with no static capacity at all.
+
+Currently, only one dynamic partition is supported. A device may report up
+to eight (CXL r4.0 Table 8-346); Linux configures the first as its
+`dynamic_ram_1` partition. Gaps between DC partitions are not checked, since
+only the first is used.
+
 Port Relationships
 ~~~~~~~~~~~~~~~~~~
 In our example described above, there are four host bridges attached to the
diff --git a/Documentation/driver-api/cxl/maturity-map.rst b/Documentation/driver-api/cxl/maturity-map.rst
index 282c1102dd81..fefd31899229 100644
--- a/Documentation/driver-api/cxl/maturity-map.rst
+++ b/Documentation/driver-api/cxl/maturity-map.rst
@@ -150,6 +150,10 @@ Memory-pooling
 * [1] Hotplug of LDs (via PCI hotplug)
 * [0] Dynamic Capacity Device (DCD) Support
 
+  * [1] DC partition enumeration / configuration (Get DC Config, CDAT DSMAS, event interrupts)
+  * [0] Extent add / release event handling
+  * [0] DC-backed DAX regions
+
 Multi-host sharing
 ------------------
 
-- 
2.43.0

