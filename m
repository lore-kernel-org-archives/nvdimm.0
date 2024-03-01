Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120E43B1AC;
	Fri,  1 Mar 2024 22:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709332659; cv=none; b=CKvsZXxV80dgFHy/hFaq8ABR175RcLx51439/xKDNdXoPDVxlLG0fWVJWoej4mfvPQJ4Q/eY85pz9P06W7lOCSxs/waLjvh5kmi46Bx1cdtOZ89Bt64/PzNvZH4x1fmrT6a571dhgIftT/FOq/pGi0EJsRgVGOXj0dxunOuhVHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709332659; c=relaxed/simple;
	bh=K4FXhxgJ5WSgughmjmci9utjXhKkjJc3y1ukbSp1ugE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YnPWfN6a9UMfud2u6qW50EO9zdV5H0SLIqaSB/T1jClWcXCE3tILLnzh7WGDtJPS8VqtpxYd8y4/qh259NMtvnWFUWlVdwlkpTranaOy91bEgfEqyKoxY+y01v/9JXMLqfd14DrIDglPZGPdnTIxCJ6tqzyrSKNBM0iXFzv2Cos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5B3C433F1;
	Fri,  1 Mar 2024 22:37:38 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Subject: [NDCTL PATCH v8 4/4] ndctl: Add support of qos_class for CXL CLI
Date: Fri,  1 Mar 2024 15:36:39 -0700
Message-ID: <20240301223736.1380778-1-dave.jiang@intel.com>
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

v8:
- Move qos_class comparison to libcxl. (Vishal)
- Move check to validate_decoder(). (Vishal)
- Update test to pick decoder that will always work. (Vishal)
- Fix script style. (Vishal)
v7:
- Removed qos restriction flag entirely (Alison)
- Added check for invalid qos_class when doing json output
- Change -q to -Q (Vishal)
- Add qos_class_mismatched to region output for cxl list (Vishal)
- Add -Q test in cxl-qos-class.sh test (Vishal)
- Change verify behavior to only do qos matching with -Q (Vishal/Dan)
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

