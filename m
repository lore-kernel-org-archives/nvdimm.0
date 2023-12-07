Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A2110A00
	for <nvdimm@lists.linux.dev>; Thu,  7 Dec 2023 04:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ewGVWqsZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701923778; x=1733459778;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=zD9JVL7KH7q9hrn7MRAVLdgdiV8d1EIq3/KpInC/SHg=;
  b=ewGVWqsZ8K/XXhr4pwSD5vDW/wK8nifmtT5EK2OwsIYsPtbTvfqLb744
   KISErK/eulegxPCsA8hdouJD0EfFREBUVHgH/NXud0bNXeRkLeYVFpqeI
   Gyp8Hlxz/Qp4I1cqI0Olr9IGHuR4ZhjNlObqLO/0QiXcKbF49KNW3lyq8
   BlIqE5Q0wbLeuL18ojCLrJce10qZn10vw+ThfC5+FTRYFsAUGoZx1LHak
   NfWMj0t0F1c9vdMcZ03bbpuZRBqGYkuuFff7Vu1PXdGe0nfJw8ZIm7NVv
   wfVb73Zy3BhOOOblfWY1N65zlhC7Jvy/o1P3GslAzawOSd0EK2pXdrPs+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="1053218"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="1053218"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 20:36:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="19570373"
Received: from apbrezen-mobl.amr.corp.intel.com (HELO [192.168.1.200]) ([10.213.160.175])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 20:36:16 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 0/2] Add DAX ABI for memmap_on_memory
Date: Wed, 06 Dec 2023 21:36:13 -0700
Message-Id: <20231206-vv-dax_abi-v2-0-f4f4f2336d08@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAL1LcWUC/03MQQ6CMBCF4auQWVvTGRGQlfcwxJQyyiRKTUsaD
 Ondrbhx+b/kfSsE9sIB2mIFz1GCuCkH7Qqwo5nurGTIDaTpgJqOKkY1mOVqelFYG8KTLStdV5A
 PL883WTbs0uUeJczOvzc74nf9MaSrfyai0qqsS+6bhkmjPcs082Nv3RO6lNIHQ+3CpqQAAAA=
To: Dave Jiang <dave.jiang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 Vishal Verma <vishal.l.verma@intel.com>, 
 David Hildenbrand <david@redhat.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Huang Ying <ying.huang@intel.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>
X-Mailer: b4 0.13-dev-26615
X-Developer-Signature: v=1; a=openpgp-sha256; l=1372;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=zD9JVL7KH7q9hrn7MRAVLdgdiV8d1EIq3/KpInC/SHg=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKmF3vtPxt7zFGeepfSHJyv/pff1h2bi3LEL5rld/Fzr1
 tOwY+bBjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAExkwl1GhpnhrBnWpjr10y0U
 p364cn0Cb7W5/clYfbed03OjdvkLPWNkuKx5fdW1bYIC+WtWpnY7tSyKWup675q1/rVfs5vvW+4
 XZgUA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

The DAX drivers were missing sysfs ABI documentation entirely.  Add this
missing documentation for the sysfs ABI for DAX regions and Dax devices
in patch 1. Add a new ABI for toggling memmap_on_memory semantics in
patch 2.

The missing ABI was spotted in [1], this series is a split of the new
ABI additions behind the initial documentation creation.

[1]: https://lore.kernel.org/linux-cxl/651f27b728fef_ae7e7294b3@dwillia2-xfh.jf.intel.com.notmuch/

Cc: Dan Williams <dan.j.williams@intel.com>
Cc:  <linux-kernel@vger.kernel.org>
Cc:  <nvdimm@lists.linux.dev>
Cc:  <linux-cxl@vger.kernel.org>
To: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Changes in v2:
- Fix CC lists, patch 1/2 didn't get sent correctly in v1
- Link to v1: https://lore.kernel.org/r/20231206-vv-dax_abi-v1-0-474eb88e201c@intel.com

---
Vishal Verma (2):
      Documentatiion/ABI: Add ABI documentation for sys-bus-dax
      dax: add a sysfs knob to control memmap_on_memory behavior

 drivers/dax/bus.c                       |  40 ++++++++
 Documentation/ABI/testing/sysfs-bus-dax | 164 ++++++++++++++++++++++++++++++++
 2 files changed, 204 insertions(+)
---
base-commit: c4e1ccfad42352918810802095a8ace8d1c744c9
change-id: 20231025-vv-dax_abi-17a219c46076

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

