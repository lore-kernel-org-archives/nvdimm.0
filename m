Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96C07A70E;
	Wed,  7 Feb 2024 17:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707326461; cv=none; b=FNn1JvCT/34mOcA1DBszkQRgLV4quT0jv8kK4BnPXdMyN8ILpyroTjYYUSeSMIMuEp1jdGBjns/KBee5fAVUQKkOkUxVHt01j6y5bddp2QIlZIPIINNEjW43OGsLhuXqPrKd0vICtxqFpEPCqtJg789eCSbDA0p7zh+Y7A1yHxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707326461; c=relaxed/simple;
	bh=zHTUM0POKygwNCz2lNY2hdNAaXPntv6CZOGi3PYOiUA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qlOmtOpgChCPSNJKfHIs9tCyLXXuXbJsAprD9EAhEefRiC1nZ7y5CNsMrpihV7QpN2srjpJqgnM348RoskTJ4VoihNXhsH9mVpAX0lZ5gZibF70OqIebnv/Wjmspz0CjkxCnAvaHs1supPzLHUdn1L3Dmne5pu3kYFjcEWqMv3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDABC433F1;
	Wed,  7 Feb 2024 17:21:00 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Subject: [NDCTL PATCH v6 0/4] ndctl: Add support of qos_class for CXL CLI
Date: Wed,  7 Feb 2024 10:19:35 -0700
Message-ID: <20240207172055.1882900-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Vishal,
With the QoS class series merged to the v6.8 kernel, can you please review and
apply this series to ndctl if acceptable?

v6:
- Check return value of create_region_validate_qos_class() (Wonjae)
v5:
- split out test from cxl-topology.sh (Vishal)
v4:
- Update against changes in kernel from multi to single qos_class entry
- Add test in cxl-topology.sh (Dan)
- See individual patch log for details
v3:
- Rebase against latest ndctl/pending branch.

The series adds support for the kernel enabling of QoS class in the v6.8
kernel. The kernel exports a qos_class token for the root decoders (CFMWS) and as
well as for the CXL memory devices. The qos_class exported for a device is
calculated by the driver during device probe. Currently a qos_class is exported
for the volatile partition (ram) and another for the persistent partition (pmem).
In the future qos_class will be exported for DCD regions. Display of qos_class is
through the CXL CLI list command with -vvv for extra verbose.

A qos_class check as also been added for region creation. A warning is emitted
when the qos_class of a memory range of a CXL memory device being included in
the CXL region assembly does not match the qos_class of the root decoder. Options
are available to suppress the warning or to fail the region creation. This
enabling provides a guidance on flagging memory ranges being used is not
optimal for performance for the CXL region to be formed.
